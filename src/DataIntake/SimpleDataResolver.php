<?php

declare(strict_types=1);

namespace GivingAssistant\DataIntake;

use \Exception;
use \InvalidArgumentException;

class SimpleDataResolver
{
    /**
     * @param array<int, string>         $data
     * 
     * @throws InvalidArgumentException If not enought data to resolve is passed in
     * @throws Exception                If is not possible to resolve a value from data
     */
    public function resolve(array $data) : string
    {
        if (count($data) < 2) {
            throw new InvalidArgumentException('Resolver needs at least two elements to be passed in');
        }

        $duplicateIndex = array_count_values($data);

        if (reset($duplicateIndex) > 1) {
            return array_keys($duplicateIndex)[0];
        }

        $similarMap = [];

        foreach ($data as $key => $dataFrom) {
            $shortest = -1;

            foreach ($data as $dataTo) {
                $distance = levenshtein($dataFrom, $dataTo);

                // Do not compare with itself
                if ($distance === 0) {
                    continue;
                }

                if ($distance < $shortest || $shortest < 0) {
                    $similarMap[$key] = $dataTo;
                    $shortest = $distance;
                }
            }
        }

        $duplicateIndex = array_count_values($similarMap);

        if (reset($duplicateIndex) > 1) {
            return array_keys($duplicateIndex)[0];
        } 
        
        throw new Exception('Cannot resolve data from multiple sources');
    }
}
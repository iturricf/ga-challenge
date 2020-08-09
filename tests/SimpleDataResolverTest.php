<?php

declare(strict_types=1);

namespace GivingAssistant\Tests;

use \Exception;
use \InvalidArgumentException;
use GivingAssistant\DataIntake\SimpleDataResolver;
use PHPUnit\Framework\TestCase;

class SimpleDataResolverTest extends TestCase
{
    /** @var SimpleDataResolver */
    private $resolver;

    public function setUp() : void
    {
        parent::setUp();

        $this->resolver = new SimpleDataResolver();
    }
    
    public function testEmptyDataThrowsException()
    {
        self::expectException(InvalidArgumentException::class);

        $data = [];

        $this->resolver->resolve($data);
    }

    public function testResolveWithDuplicateData()
    {
        $data = [
            'The North Face', 
            'The North', 
            'Teh noth face', 
            'The face', 
            'The North Face'
        ];

        $resolved = $this->resolver->resolve($data);

        self::assertEquals('The North Face', $resolved);
    }

    public function testResolveWithoutDuplicateData()
    {
        $data = [
            'The North Faces', 
            'The North', 
            'Teh noth face', 
            'The face', 
            'The North Face'
        ];

        $resolved = $this->resolver->resolve($data);

        self::assertEquals('The North Face', $resolved);
    }

    public function testResolveUnrelatedDataThrowsException()
    {
        self::expectException(Exception::class);

        $data = [
            'a',
            'b',
            'c',
            'd',
            'e',
        ];

        $resolved = $this->resolver->resolve($data);
    }
}
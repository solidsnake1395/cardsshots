<?php
// src/Controller/TestDbController.php

namespace App\Controller;

use Doctrine\DBAL\Connection;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class TestDbController
{
#[Route('/test-db')]
public function test(Connection $connection): Response
{
try {
$connection->executeQuery('SELECT 1');
return new Response('<h2>✅ Conexión a la base de datos: OK</h2>');
} catch (\Exception $e) {
return new Response('<h2>❌ Error al conectar con la base de datos:</h2><pre>' . $e->getMessage() . '</pre>');
}
}
}

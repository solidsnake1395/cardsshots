<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class HomeController
{
#[Route('/', name: 'home')]
public function index(): Response
{
return new Response('<h1>Symfony está funcionando</h1>');
}
}

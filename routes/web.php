<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('autishift');
});
Route::get('/blog', function () {
    return view('blog');
});

Route::get('/cursos', function () {
    return view('cursos');
});
Route::get('/depoimentos', function () {
    return view('depoimentos');
});

Route::get('/post', function () {
    return view('post');
});





Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');

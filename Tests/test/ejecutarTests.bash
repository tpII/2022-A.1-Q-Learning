#!/bin/bash
OUTPUT="$(coverage run -m robot ./test/CrawlerA1Test.robot)"

test1=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '2q;d')
test2=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '3q;d')
test3=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '4q;d')
test4=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '5q;d')
test5=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '6q;d')
test6=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '7q;d')
test7=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '8q;d')
test8=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '9q;d')
test9=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '10q;d')
test10=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '11q;d')
test11=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '12q;d')
test12=$(echo "${OUTPUT}" | tr -s  '=-' '\n' | cut -f  1  -d : -s | sed '13q;d')


html="{% extends './layout.html' %}


<!-- Titulo de la página -->
{% block title %} {{ data.titulo }} {% endblock %}


<!-- Importación de archivos css propios de index -->
{% block css_imports%}
	<link rel='stylesheet' href=""{{ url_for('static', filename='css/tabla.css') }}"">
	<link rel='stylesheet' href=""{{ url_for('static', filename='css/menu.css') }}"">
	<link rel='stylesheet' href=""{{ url_for('static', filename='css/input_number.css') }}"">
	<link rel='stylesheet' href=""{{ url_for('static', filename='css/alert.css') }}"">
    <link rel='stylesheet' href=""{{ url_for('static', filename='css/test.css') }}"">
{% endblock %}

<!-- Bloque del cuerpo del index -->
{% block body %}

<div class='header'>
    <h1> Crawler-bot </h1>
    <img src='static/images/Logo.png' onclick='location.href="'"/"'"' class='logo'>
</div>
    <div style='display: grid;'>
        <div style='grid-column: 1;'>
            <h1 style='margin-top: 4%; margin-left: 5%'>Resultado de los Tests</h1>
        </div>
        <div style='grid-column: 2;'>
            <button id='Coverage' class='zoom_button button avanzar_button' style='width: 50%; height: 60%; margin-top: 5%;' onclick="'"location.href='"'test/coverage'"'"'">Ver Coverage</button>
        </div>
    </div>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test1}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test2}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test3}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test4}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test5}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test6}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test7}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test8}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test9}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test10}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test11}</h3><br>
        <img src='../static/images/tilde.png' style='width: 3%;height: 3%;margin-left: 8%;margin-top: 2%;'><h3 style='display: inline;margin-left: 2%;'>${test12}</h3>

    <div class='animateme'>
        <ul class='bg-bubbles'>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
          <li></li>
        </ul>
      </div>

{% endblock %}

<!-- Importación de archivos js propios del index -->
{% block js_imports %}
	<script src=""{{ url_for('static', filename = 'js/effects.js') }}""> </script>
{% endblock %}"

echo ${html} > ./templates/tests.html
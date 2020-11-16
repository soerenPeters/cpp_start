# cpp_start

[![Gitter](https://badges.gitter.im/cpp_start/lobby.svg)](https://gitter.im/cpp_start/lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
![CI](https://github.com/soerenPeters/cpp_start/workflows/build/badge.svg)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=soerenPeters_cpp_start&metric=alert_status)](https://sonarcloud.io/dashboard?id=soerenPeters_cpp_start)

cpp_start is a cmake - C++ starter project. 

It supports the github workflow:
 - linux, macos, windows builds and running unit-tests (googletest)
 - code coverage gcov
 - deployment to sonarcloud.io
 
 
To set up Sonarcloud initially:
 - link the github project on sonarcloud.io
 - generate a security token on sonarcloud.io: **User > My Account > Security**
 - add this token as a github project secret with the name **SONAR_TOKEN**
#!/bin/bash
ssh ec2-user@"$(terraform output conn_serv)"

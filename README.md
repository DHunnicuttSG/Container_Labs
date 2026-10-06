# Container_Labs

This repository contains hands-on learning materials for a ContainerLab-based networking lab focused on production support, SRE fundamentals, and Linux networking troubleshooting.

## Overview

The lab simulates a small web and DNS environment running on a single AWS EC2 instance. Students use Docker and ContainerLab to deploy a multi-container topology and then diagnose connectivity, routing, DNS, firewall, and application issues using Linux networking tools.

## Course objectives

By completing the exercises in this lab, students will be able to:

- validate end-to-end network connectivity
- troubleshoot DNS and routing problems
- identify firewall and policy-related issues
- analyze application failures in a containerized environment
- inspect traffic and service behavior using standard Linux tools
- apply common production support and SRE troubleshooting workflows

## Included materials

- [ContainerLab_Instructions-1.md](ContainerLab_Instructions-1.md)
  - Full step-by-step lab guide for environment setup, topology creation, container deployment, and troubleshooting.

- [How_2_Create_Graph_Service.md](How_2_Create_Graph_Service.md)
  - Instructions for creating a systemd service to expose the ContainerLab graph viewer in a browser.

- [README.md](README.md)
  - High-level overview of the lab and how the materials fit together.

## Recommended workflow

1. Review the lab scenario and prerequisites in [ContainerLab_Instructions-1.md](ContainerLab_Instructions-1.md).
2. Build the lab environment on an AWS EC2 instance with Docker and ContainerLab installed.
3. Deploy the topology and validate connectivity between nodes.
4. Use the troubleshooting commands and scenarios in the lab to identify and resolve simulated issues.
5. Optionally, follow [How_2_Create_Graph_Service.md](How_2_Create_Graph_Service.md) to expose the graph viewer for visual topology monitoring.

## Folder structure

```text
Container_Labs/
├── README.md                         # Lab overview and usage guidance
├── ContainerLab_Instructions-1.md    # Main networking lab instructions
├── How_2_Create_Graph_Service.md     # Graph viewer systemd service setup
└── .git/                             # Git repository metadata
```

This folder is intended to provide a practical, lab-based learning experience for networking, operations, and support teams working with containerized infrastructure.
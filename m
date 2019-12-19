Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FC1265CD
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 16:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLSPbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 10:31:39 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39234 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfLSPbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 10:31:38 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so4737933ioh.6
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2019 07:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=tVdAuyoDt7pjZuW0nCW1d+a6Wz/ajojEaVLRBDIh8IE=;
        b=JXX/1wNjO8Dvzke2/0qlXqY2kkbsGeCZdplmNXPVgZoRqvVB0xhAF11ReLDbfYsQql
         /+J5NPscjqm2q61ekqbnmS29vunY1kdANLcKAtUPCgkk/slViu+WvTA6g7e+gjtlGeJ2
         7PTdagKdw1QR9OlFISqMCJMSxw2pG1PnfybgrAsXmrz8Q74PYAX+JvVNluYuRYy9kQvO
         ucJ0hXdjjS446vSY/8CIYvYYTJKvv04vCm431LrPT2Wzg85KACKEAsNjxDnLrZr/GvqE
         NOX+FnFzYYt+v0x2YnjFphYJ9sQ2abzJMmMGM7PkAUQGlMP5PvUzvbsFzspeVQ4J1hfp
         vD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=tVdAuyoDt7pjZuW0nCW1d+a6Wz/ajojEaVLRBDIh8IE=;
        b=QkOh0NvPIQtkE/LYcuNB6JSvRoIl3nVJhi18rWGeZVKs2jDyn5kxtFuC8YbOwI+w5X
         eHvu8taESRh+PdrxY1rP+rpwE24Q+BtCLCuKnXhFBk80/QGaHSimnuB9SOhgjkDpJ6De
         CB/EuZSyXWRgOwJ6YbfzB217f5Tb8DxamOMxv6XiQNlyqJv3xwFu5JRzFSJY0m+i6DOu
         zGABpPH4r0DnqpXFTMpYb53K8cmJ80EVlmW6QmuXu3M8mf87ow1ZbQ2tBkDGTt2/AA/N
         Q/Mj52jyDb1tAMnH3wAxQdH7qGHJqTxybQ5WUc1JPgUzRUUZS+Um3rMG7spid+K89OOc
         PAxw==
X-Gm-Message-State: APjAAAVDoIxzmhcW3+Bo5xOsVoHniajIS4KV1HvUSVt4FTBIWoKotl83
        6Kq9YlW2UZ8gsigOGJMiVBk8ph+cL7uMzDAOUt9Ockt0hbo=
X-Google-Smtp-Source: APXvYqye+d2pOdaRuadvZsWPwUFylA328ZuWStM03MxcDVNAsOWhUO7IBJh7aJCy56wKWBXhrlmO8j0oajqDEIbG3z4=
X-Received: by 2002:a02:5b45:: with SMTP id g66mr7726689jab.29.1576769497002;
 Thu, 19 Dec 2019 07:31:37 -0800 (PST)
MIME-Version: 1.0
From:   VHPC 20 <vhpc.dist@gmail.com>
Date:   Thu, 19 Dec 2019 16:31:26 +0100
Message-ID: <CAF05tLPPpp848UH30d2RQc_2r5g0+BSXpg=UcNDMnHA=i9CXtw@mail.gmail.com>
Subject: CfP VHPC20: HPC Containers-Kubernetes
To:     kvm@vger.kernel.org, kvm-devel@lists.sourceforge.net,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
CALL FOR PAPERS

15th Workshop on Virtualization in High-Performance Cloud Computing
(VHPC 20) held in conjunction with the International Supercomputing
Conference - High Performance, June 21-25, 2020, Frankfurt, Germany.
(Springer LNCS Proceedings)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Date: June 25, 2020
Workshop URL: vhpc[dot]org


Abstract registration Deadline: Jan 31st, 2020
Paper Submission Deadline: Apr 05th, 2020
Springer LNCS



Call for Papers


Containers and virtualization technologies constitute key enabling
factors for flexible resource management in modern data centers, and
particularly in cloud environments. Cloud providers need to manage
complex infrastructures in a seamless fashion to support the highly
dynamic and heterogeneous workloads and hosted applications customers
deploy. Similarly, HPC environments have been increasingly adopting
techniques that enable flexible management of vast computing and
networking resources, close to marginal provisioning cost, which is
unprecedented in the history of scientific and commercial computing.
Most recently, Function as a Service (Faas) and Serverless computing,
utilizing lightweight VMs-containers widens the spectrum of
applications that can be deployed in a cloud environment, especially
in an HPC context. Here, HPC-provided services can be become
accessible to distributed workloads outside of large cluster
environments.

Various virtualization-containerization technologies contribute to the
overall picture in different ways: machine virtualization, with its
capability to enable consolidation of multiple under=C2=ADutilized servers
with heterogeneous software and operating systems (OSes), and its
capability to live=C2=AD-migrate a fully operating virtual machine (VM)
with a very short downtime, enables novel and dynamic ways to manage
physical servers; OS-=C2=ADlevel virtualization (i.e., containerization),
with its capability to isolate multiple user=C2=AD-space environments and
to allow for their co=C2=ADexistence within the same OS kernel, promises to
provide many of the advantages of machine virtualization with high
levels of responsiveness and performance; lastly, unikernels provide
for many virtualization benefits with a minimized OS/library surface.
I/O Virtualization in turn allows physical network interfaces to take
traffic from multiple VMs or containers; network virtualization, with
its capability to create logical network overlays that are independent
of the underlying physical topology is furthermore enabling
virtualization of HPC infrastructures.


Publication


Accepted papers will be published in a Springer LNCS proceedings
volume.


Topics of Interest


The VHPC program committee solicits original, high-quality submissions
related to virtualization across the entire software stack with a
special focus on the intersection of HPC, containers-virtualization
and the cloud.


Major Topics:
- HPC workload orchestration (Kubernetes)
- Kubernetes HPC batch
- HPC Container Environments Landscape
- HW Heterogeneity
- Container ecosystem (Docker alternatives)
- Networking
- Lightweight Virtualization
- Unikernels / LibOS
- State-of-the-art processor virtualization (RISC-V, EPI)
- Containerizing HPC Stacks/Apps/Codes:
  Climate model containers


each major topic encompassing design/architecture, management,
performance management, modeling and configuration/tooling.
Specifically, we invite papers that deal with the following topics:

- HPC orchestration (Kubernetes)
   - Virtualizing Kubernetes for HPC
   - Deployment paradigms
   - Multitenancy
   - Serverless
   - Declerative data center integration
   - Network provisioning
   - Storage
   - OCI i.a. images
   - Isolation/security
- HW Accelerators, including GPUs, FPGAs, AI, and others
   - State-of-practice/art, including transition to cloud
   - Frameworks, system software
   - Programming models, runtime systems, and APIs to facilitate cloud
     adoption
   - Edge use-cases
   - Application adaptation, success stories
- Kubernetes Batch
   - Scheduling, job management
   - Execution paradigm - workflow
   - Data management
   - Deployment paradigm
   - Multi-cluster/scalability
   - Performance improvement
   - Workflow / execution paradigm
- Podman: end-to-end Docker alternative container environment & use-cases
   - Creating, Running containers as non-root (rootless)
   - Running rootless containers with MPI
   - Container live migration
   - Running containers in restricted environments without setuid
- Networking
   - Software defined networks and network virtualization
   - New virtualization NICs/Nitro alike ASICs for the data center?
   - Kubernetes SDN policy (Calico i.a.)
   - Kubernetes network provisioning (Flannel i.a.)
- Lightweight Virtualization
   - Micro VMMs (Rust-VMM, Firecracker, solo5)
   - Xen
   - Nitro hypervisor (KVM)
   - RVirt
   - Cloud Hypervisor
- Unikernels / LibOS
- HPC Storage in Virtualization
   - HPC container storage
   - Cloud-native storage
   - Hypervisors in storage virtualization
- Processor Virtualization
   - RISC-V hypervisor extensions
   - RISC-V Hypervisor ports
   - EPI
- Composable HPC microservices
- Containerizing Scientific Codes
   - Building
   - Deploying
   - Securing
   - Storage
   - Monitoring
- Use case for containerizing HPC codes:
  Climate model containers for portability, reproducibility,
  traceability, immutability, provenance, data & software preservation



The Workshop on Virtualization in High=C2=AD-Performance Cloud Computing
(VHPC) aims to bring together researchers and industrial practitioners
facing the challenges posed by virtualization in order to foster
discussion, collaboration, mutual exchange of knowledge and
experience, enabling research to ultimately provide novel solutions
for virtualized computing systems of tomorrow.

The workshop will be one day in length, composed of 20 min paper
presentations, each followed by 10 min discussion sections, plus
lightning talks that are limited to 5 minutes. Presentations may be
accompanied by interactive demonstrations.


Important Dates

Jan 31st, 2020 - Abstract
Apr 5th, 2020 - Paper submission deadline (Springer LNCS)
Apr 26th, 2020 - Acceptance notification
June 25th, 2020 - Workshop Day
July 10th, 2020 - Camera-ready version due


Chair

Michael Alexander (chair), BOKU, Vienna, Austria
Anastassios Nanos (co-=C2=ADchair), Sunlight.io, UK


Program committee

Stergios Anastasiadis, University of Ioannina, Greece
Paolo Bonzini, Redhat, Italy
Jakob Blomer, CERN, Europe
Eduardo C=C3=A9sar, Universidad Autonoma de Barcelona, Spain
Taylor Childers, Argonne National Laboratory, USA
Stephen Crago, USC ISI, USA
Tommaso Cucinotta, St. Anna School of Advanced Studies, Italy
Fran=C3=A7ois Diakhat=C3=A9 CEA DAM Ile de France, France
Kyle Hale, Northwestern University, USA
Brian Kocoloski, Washington University, USA
John Lange, University of Pittsburgh, USA
Giuseppe Lettieri, University of Pisa, Italy
Klaus Ma, Huawei, China
Alberto Madonna, Swiss National Supercomputing Center, Switzerland
Nikos Parlavantzas, IRISA, France
Anup Patel, Western Digital, USA
Kevin Pedretti, Sandia National Laboratories, USA
Amer Qouneh, Western New England University, USA
Carlos Rea=C3=B1o, Queen=E2=80=99s University Belfast, UK
Adrian Reber, Redhat, Germany
Riccardo Rocha, CERN, Europe
Borja Sotomayor, University of Chicago, USA
Jonathan Sparks, Cray, USA
Kurt Tutschku, Blekinge Institute of Technology, Sweden
John Walters, USC ISI, USA
Yasuhiro Watashiba, Osaka University, Japan
Chao-Tung Yang, Tunghai University, Taiwan



Paper Submission-Publication

Papers submitted to the workshop will be reviewed by at least two
members of the program committee and external reviewers. Submissions
should include abstract, keywords, the e-mail address of the
corresponding author, and must not exceed 10 pages, including tables
and figures at a main font size no smaller than 11 point. Submission
of a paper should be regarded as a commitment that, should the paper
be accepted, at least one of the authors will register and attend the
conference to present the work. Accepted papers will be published in a
Springer LNCS volume.

The format must be according to the Springer LNCS Style. Initial
submissions are in PDF; authors of accepted papers will be requested
to provide source files.


Abstract, Paper Submission Link:
edas[dot]info/newPaper.php?c=3D26973


Lightning Talks

Lightning Talks are non-paper track, synoptical in nature and are
strictly limited to 5 minutes. They can be used to gain early
feedback on ongoing research, for demonstrations, to present research
results, early research ideas, perspectives and positions of interest
to the community. Submit abstract via the main submission link.

General Information

The workshop is one day in length and will be held in conjunction with
the International Supercomputing Conference - High Performance (ISC)
2019, June 21-25, Frankfurt, Germany.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA931A2799
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 18:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgDHQ5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 12:57:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:32926 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbgDHQ5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 12:57:52 -0400
Received: by mail-io1-f66.google.com with SMTP id o127so853197iof.0
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 09:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JE1PMbnVz2KLIUyWTUZVdSzFEptNOXD7IlLbF6zfQHs=;
        b=HIH6s2MZdejC347KlCnd5LjnsO1OtyiahSyWy00P7adhii+FWPiTuhi+sr6QW8alwP
         iwMJAiY2Z9hmNPa187CQQF86Br/SgBa8NI3RyY5QurIki+Pa/qO1mCLN/UzfPEIPUPFw
         ZLFoyLJ2KNM76o9I2E7z9Ni0/5rMsmazKDqVf++aEISEwW2hnQb+TJYwOhisEazf1jSD
         tqTR6tKI8y/j453TTdRqRvfjO/z9cr88AJLiXsTBH6ZvH/xklwn2qQlOU8BQzklm9ju+
         1zN8jyPuaFZLfBOvm996DBzTL3lwCln3815oETptls/QI4jBYLFoWpq8FJRFwmco0o7A
         MnbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JE1PMbnVz2KLIUyWTUZVdSzFEptNOXD7IlLbF6zfQHs=;
        b=OqNzu8nFoWBmRv+K9AoaZXr7XMIpgT4sVZlFCnNCzu7LJ5M778yN8OeowuHPrVa7Gq
         2LMoR/fJen5Ikl0/2TlcSAktDQZ+NoiQdLCo3QbfvCoBYkfLRi2mQt1B7h75t5Je6dKA
         r5oLAH7tI/DlIIpeoJX1U7wbGViaqg0h9A+gxFQ27f1xVSo1GWe2Kkt9vbDpDS3DKYrn
         Ki1ShxMBulVNObTO/IC34cxrpLmRMUPdQHGTRi3mQVh8Uz45e4xKfW3JOF5vKunQYI+P
         /ZfhlaEv1fpArm3ghCpA40QZflMygETBqS9Cj3/qd58jvnr6cfIbD3sWy0UcoDdyowxa
         +TUw==
X-Gm-Message-State: AGi0PuaYSuIv1jYVy0Km8OzDKv0cHvn731Faf8PhDr65znDGMxN1AUpb
        RVx4r5lNC6Y0IJ1+2WV0/19o2Butc5/QuWvFAkUcHZxP
X-Google-Smtp-Source: APiQypJVeXJzYkau4cNJDkXcNVPqYhEAyFAvLG/sV9irMZC0y3sIjfi/7ZG9Fi6y5egJKM7CKOGooFQPg5EFqsa7CfU=
X-Received: by 2002:a02:a68e:: with SMTP id j14mr633234jam.86.1586365070216;
 Wed, 08 Apr 2020 09:57:50 -0700 (PDT)
MIME-Version: 1.0
From:   VHPC 20 <vhpc.dist@gmail.com>
Date:   Wed, 8 Apr 2020 18:57:38 +0200
Message-ID: <CAF05tLNBvJb76OyAa2BNp_mOwg3tj9OxVaFROwQ1K-o47yvx1A@mail.gmail.com>
Subject: CfP VHPC'20: extension, Zoom Online Event without charge
To:     kvm-devel@lists.sourceforge.net, kvm@vger.kernel.org
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

Online Zoom Event
https://us02web.zoom.us/webinar/register/WN_vC5pwmgbQ6ypJEfyQ8nHIg

Physical Event: ISC, Frankfurt

Paper Submission Deadline: May 12th, 2020 (extended)
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
in an HPC context. Here, HPC-provided services become accessible
to distributed workloads outside of large cluster environments.

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

May 12th, 2020 - Paper submission deadline - extended (Springer LNCS)
Apr 26th, 2020 - Acceptance notification
June 25th, 2020 - Workshop Day
July 10th, 2020 - Camera-ready version due


Chair

Michael Alexander (chair), BOKU, Vienna, Austria
Anastassios Nanos (co-chair), Sunlight.io, UK


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
Simon Kuenzer, NEC Laboratories Europe, Germany
John Lange, University of Pittsburgh, USA
Giuseppe Lettieri, University of Pisa, Italy
Klaus Ma, Huawei Technologies, China
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

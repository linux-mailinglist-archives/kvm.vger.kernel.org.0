Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C796850877D
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376388AbiDTL5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378334AbiDTL5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:57:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371E764E5
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 04:54:52 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23K9MgR6024662;
        Wed, 20 Apr 2022 11:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=p3qbMD3DB/7LuNV7P6l1vzan82NICw7pUhJtjm2c0bk=;
 b=jHcSdiHK0u1Gkr4f654ZrmK7qgHwNaN57yFYS5QbjOnSuACGFFVdAKPVICPDkT6NaoXS
 S0H+ym0gfciFbplU4e7xHC26qc+XzaZfgVHXie+b6V/OXcYsk+5m3jgfy/9CRDMQCCLA
 G0NjqVXa+plEIGBLrivQcwpFiczK7EowNvAAsOos/CG4id/BWNgNaupdy1uMQ0unfIii
 8uUs5HckWSQ3Fmjd6W/4mnYW2zsoUztvpmeh9llyaF9fGF5G+y8RzqcfKLOdE9fvnI2t
 l6Ka7TbacEKMJs6lI4LnsWJlLDORNcFs5Gd/IXyLdyHZY84uDahF74eK0/ytkWQO3xT6 Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fg75r9h7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:48 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBfveQ014835;
        Wed, 20 Apr 2022 11:54:47 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fg75r9h78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:47 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBr1bl023275;
        Wed, 20 Apr 2022 11:54:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8p7ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:54:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBsTZZ28377410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:54:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B9F4AE055;
        Wed, 20 Apr 2022 11:54:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B2D6AE051;
        Wed, 20 Apr 2022 11:54:28 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 11:54:28 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
Subject: [PATCH v7 00/13] s390x: CPU Topology
Date:   Wed, 20 Apr 2022 13:57:32 +0200
Message-Id: <20220420115745.13696-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fstQpGqwEgJZ4HKi3Ai0Ks0jc3YBjEhu
X-Proofpoint-GUID: mnIyPToN9WFY1AVViMTohRK1tfs7GKZw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_03,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This new spin adds RESET for the CPU Topology.
I added Matthew's patch to help compile the source until
the migration V2 is in the main tree.

The goal of this series is to implement CPU topology for S390, it
improves the preceeding series with the implementation of books and
drawers, of non uniform CPU topology and with documentation.

To use these patches, you will need the Linux series version 8.
You find it there:
https://lkml.org/lkml/2022/4/20/465

Currently this code is for KVM only, I have no idea if it is interesting
to provide a TCG patch. If ever it will be done in another series.

To have a better understanding of the S390x CPU Topology and its
implementation in QEMU you can have a look at the documentation in the
last patch or follow the introduction here under.

A short introduction
====================

CPU Topology is described in the S390 POP with essentially the description
of two instructions:

PTF Perform Topology function used to poll for topology change
    and used to set the polarization but this part is not part of this item.

STSI Store System Information and the SYSIB 15.1.x providing the Topology
    configuration.

S390 Topology is a 6 levels hierarchical topology with up to 5 level
    of containers. The last topology level, specifying the CPU cores.

    This patch series only uses the two lower levels sockets and cores.
    
    To get the information on the topology, S390 provides the STSI
    instruction, which stores a structures providing the list of the
    containers used in the Machine topology: the SYSIB.
    A selector within the STSI instruction allow to chose how many topology
    levels will be provide in the SYSIB.

    Using the Topology List Entries (TLE) provided inside the SYSIB we
    the Linux kernel is able to compute the information about the cache
    distance between two cores and can use this information to take
    scheduling decisions.

The design
==========

1) To be ready for hotplug, I chose an Object oriented design
of the topology containers:
- A node is a bridge on the SYSBUS and defines a "node bus"
- A drawer is hotplug on the "node bus"
- A book on the "drawer bus"
- A socket on the "book bus"
- And the CPU Topology List Entry (CPU-TLE)sits on the socket bus.
These objects will be enhanced with the cache information when
NUMA is implemented.

This also allows for easy retrieval when building the different SYSIB
for Store Topology System Information (STSI)

2) Perform Topology Function (PTF) instruction is made available to the
guest with a new KVM capability and intercepted in QEMU, allowing the
guest to pool for topology changes.


Features
========

- There is no direct match between IDs shown by:
    - lscpu (unrelated numbered list),
    - SYSIB 15.1.x (topology ID)

- The CPU number, left column of lscpu, is used to reference a CPU
    by Linux tools
    While the CPU address is used by QEMU for hotplug.

- Effect of -smp parsing on the topology with an example:
    -smp 9,sockets=4,cores=4,maxcpus=16

    We have 4 socket each holding 4 cores so that we have a maximum 
    of 16 CPU, 9 of them are active on boot. (Should be obvious)

# lscpu -e
CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
  0    0      0    0      0    0 0:0:0:0            yes yes        horizontal   0
  1    0      0    0      0    1 1:1:1:1            yes yes        horizontal   1
  2    0      0    0      0    2 2:2:2:2            yes yes        horizontal   2
  3    0      0    0      0    3 3:3:3:3            yes yes        horizontal   3
  4    0      0    0      1    4 4:4:4:4            yes yes        horizontal   4
  5    0      0    0      1    5 5:5:5:5            yes yes        horizontal   5
  6    0      0    0      1    6 6:6:6:6            yes yes        horizontal   6
  7    0      0    0      1    7 7:7:7:7            yes yes        horizontal   7
  8    0      0    0      2    8 8:8:8:8            yes yes        horizontal   8
# 


- To plug a new CPU inside the topology one can simply use the CPU
    address like in:
  
(qemu) device_add host-s390x-cpu,core-id=12
# lscpu -e
CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
  0    0      0    0      0    0 0:0:0:0            yes yes        horizontal   0
  1    0      0    0      0    1 1:1:1:1            yes yes        horizontal   1
  2    0      0    0      0    2 2:2:2:2            yes yes        horizontal   2
  3    0      0    0      0    3 3:3:3:3            yes yes        horizontal   3
  4    0      0    0      1    4 4:4:4:4            yes yes        horizontal   4
  5    0      0    0      1    5 5:5:5:5            yes yes        horizontal   5
  6    0      0    0      1    6 6:6:6:6            yes yes        horizontal   6
  7    0      0    0      1    7 7:7:7:7            yes yes        horizontal   7
  8    0      0    0      2    8 8:8:8:8            yes yes        horizontal   8
  9    -      -    -      -    - :::                 no yes        horizontal   12
# chcpu -e 9
CPU 9 enabled
# lscpu -e
CPU NODE DRAWER BOOK SOCKET CORE L1d:L1i:L2d:L2i ONLINE CONFIGURED POLARIZATION ADDRESS
  0    0      0    0      0    0 0:0:0:0            yes yes        horizontal   0
  1    0      0    0      0    1 1:1:1:1            yes yes        horizontal   1
  2    0      0    0      0    2 2:2:2:2            yes yes        horizontal   2
  3    0      0    0      0    3 3:3:3:3            yes yes        horizontal   3
  4    0      0    0      1    4 4:4:4:4            yes yes        horizontal   4
  5    0      0    0      1    5 5:5:5:5            yes yes        horizontal   5
  6    0      0    0      1    6 6:6:6:6            yes yes        horizontal   6
  7    0      0    0      1    7 7:7:7:7            yes yes        horizontal   7
  8    0      0    0      2    8 8:8:8:8            yes yes        horizontal   8
  9    0      0    0      3    9 9:9:9:9            yes yes        horizontal   12
#

It is up to the admin level, Libvirt for example, to pin the righ CPU to the right
vCPU, but as we can see without NUMA, chosing separate sockets for CPUs is not easy
without hotplug because without information the code will assign the vCPU and fill
the sockets one after the other.
Note that this is also the default behavior on the LPAR.

Conclusion
==========

This patch, together with the associated KVM patch allows to provide CPU topology
information to the guest.
Currently, only dedicated vCPU and CPU are supported and a NUMA topology can only
be handled using CPU hotplug inside the guest.

Regards,
Pierre

Matthew Rosato (1):
  vfio: tolerate migration protocol v1 uapi renames

Pierre Morel (12):
  Update linux headers
  s390x: topology: CPU topology objects and structures
  s390x: topology: implementating Store Topology System Information
  s390x: topology: Adding books to CPU topology
  s390x: topology: Adding books to STSI
  s390x: topology: Adding drawers to CPU topology
  s390x: topology: Adding drawers to STSI
  s390x: topology: implementing numa for the s390x topology
  s390x: kvm: topology: interception of PTF instruction
  s390x: topology: resetting the Topology-Change-Report
  s390x: CPU topology: CPU topology migration
  s390x: topology: activating CPU topology

 hw/core/machine-smp.c                         |  48 +-
 hw/core/machine.c                             |  22 +
 hw/s390x/cpu-topology.c                       | 647 ++++++++++++++++++
 hw/s390x/meson.build                          |   1 +
 hw/s390x/s390-virtio-ccw.c                    | 125 +++-
 hw/vfio/common.c                              |   2 +-
 hw/vfio/migration.c                           |  19 +-
 include/hw/boards.h                           |   8 +
 include/hw/s390x/cpu-topology.h               |  99 +++
 include/hw/s390x/s390-virtio-ccw.h            |   6 +
 include/hw/s390x/sclp.h                       |   1 +
 .../linux/input-event-codes.h                 |   4 +-
 .../standard-headers/linux/virtio_config.h    |   6 +
 .../standard-headers/linux/virtio_crypto.h    |  82 ++-
 linux-headers/asm-arm64/kvm.h                 |  16 +
 linux-headers/asm-generic/mman-common.h       |   2 +
 linux-headers/asm-mips/mman.h                 |   2 +
 linux-headers/asm-s390/kvm.h                  |   9 +
 linux-headers/linux/kvm.h                     |  20 +-
 linux-headers/linux/psci.h                    |   4 +
 linux-headers/linux/userfaultfd.h             |   8 +-
 linux-headers/linux/vfio.h                    | 406 ++++++-----
 linux-headers/linux/vhost.h                   |   7 +
 qapi/machine.json                             |  14 +-
 qemu-options.hx                               |   6 +-
 softmmu/vl.c                                  |   6 +
 target/s390x/cpu-sysemu.c                     |   7 +
 target/s390x/cpu.h                            |  51 ++
 target/s390x/cpu_models.c                     |   1 +
 target/s390x/cpu_topology.c                   | 169 +++++
 target/s390x/kvm/kvm.c                        |  96 +++
 target/s390x/kvm/kvm_s390x.h                  |   2 +
 target/s390x/meson.build                      |   1 +
 33 files changed, 1651 insertions(+), 246 deletions(-)
 create mode 100644 hw/s390x/cpu-topology.c
 create mode 100644 include/hw/s390x/cpu-topology.h
 create mode 100644 target/s390x/cpu_topology.c

-- 
2.27.0

Changelog:

- since v6

- Changes on smp args in qemu-options
  (Daniel)
  
- changed comments in machine.jason
  (Daniel)
 
- Added reset
  (Janosch)

- since v5

- rebasing on newer QEMU version

- reworked most lines above 80 characters.

- since v4

- Added drawer and books to topology

- Added numa topology

- Added documentation

- since v3

- Added migration
  (Thomas)

- Separated STSI instruction from KVM to prepare TCG
  (Thomas)

- Take care of endianess to prepare TCG
  (Thomas)

- Added comments on STSI CPU container and PFT instruction
  (Thomas)

- Moved enabling the instructions as the last patch
  (Thomas)

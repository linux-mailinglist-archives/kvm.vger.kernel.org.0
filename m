Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C03540DB96
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 15:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbhIPNpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 09:45:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240229AbhIPNpd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Sep 2021 09:45:33 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18GBoxOv023629;
        Thu, 16 Sep 2021 09:44:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=HtKygSPi3oYqwMruQ99VjgC+Z+kWAOtQT7JsSHwYT68=;
 b=p3lwGsMp5Yo1RGNYl3PdslMG9geOjR+essIxtmUKC+KX6QAyM08HiRsXpEKhM61rpGt0
 6KC2R8mMmodglcPH1+TmlIfsmQpbjcA9dGVlaIyJKLgK5YaKLvPeB1BMvyTk6UT7Ey5L
 0QNAG1ghMsQNNb4JnI0Hh2Rr2WKmPZB94OKRdi2+fxhD3ndN2HtLD4WtwLsufhExAR1r
 d4Ccdo/nv0amici/wa9nXV9tZvAue01LE7AEberoD3tVG6KBe/tGjygEhWtRKFAfYLzS
 bFKTCKhUPChSE1dCLBzU/7cFZaDknHRZkz62hsl2GiVPnCzebsWTK/hW8pFFvcjYgHEB Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b421g81ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Sep 2021 09:44:13 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18GCmksL027895;
        Thu, 16 Sep 2021 09:44:12 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b421g81a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Sep 2021 09:44:12 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18GDgqVl002007;
        Thu, 16 Sep 2021 13:44:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3b0m3ahc59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Sep 2021 13:44:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18GDi6L050987478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:44:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9D6D11C05B;
        Thu, 16 Sep 2021 13:44:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3375111C052;
        Thu, 16 Sep 2021 13:44:06 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.190.206])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Sep 2021 13:44:06 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v4 0/1] s390x: KVM: CPU Topology
Date:   Thu, 16 Sep 2021 15:44:04 +0200
Message-Id: <1631799845-24860-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: djm7p5uOWuuhltAH20n5DueXSEw-Qkab
X-Proofpoint-ORIG-GUID: wrtp9Z9C9dOf7ciG-k1SPQ_uSsG-9Izj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This new series add the implementation of interpretation for
the PTF instruction.

The series provides:
1- interception of the STSI instruction forwarding the CPU topology
2- interpretation of the PTF instruction
3- a KVM capability for the userland hypervisor to ask KVM to 
   setup PTF interpretation.


0- Foreword

The S390 CPU topology is reported using two instructions:
- PTF, to get information if the CPU topology did change since last
  PTF instruction or a subsystem reset.
- STSI, to get the topology information, consisting of the topology
  of the CPU inside the sockets, of the sockets inside the books etc.

The PTF(2) instruction report a change if the STSI(15.1.2) instruction
will report a difference with the last STSI(15.1.2) instruction*.
With the SIE interpretation, the PTF(2) instruction will report a
change to the guest if the host sets the SCA.MTCR bit.

*The STSI(15.1.2) instruction reports:
- The cores address within a socket
- The polarization of the cores
- The CPU type of the cores
- If the cores are dedicated or not

We decided to implement the CPU topology for S390 in several steps:
- first step we provide a correct topology only for dedicated CPUs
  and vCPUs. We provide the basic framework and report topology change
  only when a new vCPU is plugged in a monotonic scheme.

In future development we will provide:
- NUMA handling, allowing holes inside the cores bitmap reported by
  STSI(15.1.2)
- dedicated versus shared CPUs handling
- vCPU migration on a different CPU

We will ignore the following changes inside a STSI(15.1.2):
- polarization: only horizontal polarization is currently used in Linux.
- CPU Type: only IFL Type are supported in Linux


1- Interception of STSI

To provide Topology information to the guest through the STSI
instruction, we forward STSI with Function Code 15 to the
userland hypervisor which will take care to provide the right
information to the guest.

To let the guest use both the PTF instruction  to check if a topology
change occurred and sthe STSI_15.x.x instruction we add a new KVM
capability to enable the topology facility.

2- Interpretation of PTF with FC(2)

The PTF instruction will report a topology change if there is any change
with a previous STSI(15.1.2) SYSIB.
Changes inside a STSI(15.1.2) SYSIB occur if CPU bits are set or clear
inside the CPU Topology List Entry CPU mask field, which happens with
changes in CPU polarization, dedication, CPU types and adding or
removing CPUs in a socket.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry of the guest's
SCA which will be cleared during the interpretation of PTF.

To check if the topology has been modified we use a new field of the
arch vCPU prev_cpu, to save the previous real CPU ID at the end of a
schedule and verify on next schedule that the CPU used is in the same
socket, this field is initialized to -1 on vCPU creation.


Regards,
Pierre



Pierre Morel (1):
  s390x: KVM: accept STSI for CPU topology information

 Documentation/virt/kvm/api.rst   | 16 ++++++++++
 arch/s390/include/asm/kvm_host.h | 14 ++++++---
 arch/s390/kvm/kvm-s390.c         | 51 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/priv.c             |  7 ++++-
 arch/s390/kvm/vsie.c             |  3 ++
 include/uapi/linux/kvm.h         |  1 +
 6 files changed, 86 insertions(+), 6 deletions(-)

-- 
2.25.1

Changelog:

from v3 to v4

- squatch both patches
  (David)

- Added Documentation
  (David)

- Modified the detection for new vCPUs
  (Pierre)

from v2 to v3

- use PTF interpretation
  (Christian)

- optimize arch_update_cpu_topology using PTF
  (Pierre)

from v1 to v2:

- Add a KVM capability to let QEMU know we support PTF and STSI 15
  (David)

- check KVM facility 11 before accepting STSI fc 15
  (David)

- handle all we can in userland
  (David)

- add tracing to STSI fc 15
  (Connie)


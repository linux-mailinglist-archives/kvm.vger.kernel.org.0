Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05FE56D842
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 10:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiGKIhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 04:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiGKIhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 04:37:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413E913CD2;
        Mon, 11 Jul 2022 01:37:22 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26B7gPv6013255;
        Mon, 11 Jul 2022 08:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=P9z575zVdvY2nr2mvCgubEEkBU6RoJhAsBiZpmBLPB0=;
 b=JbpxktKxTm6IDG4vZfpE5NtWZgUgocYyWa1GB20M2OttxoTXZgRtxDfe8HIsuVxu340D
 W7S/WpF8xGXfy5denOyWTr5p21dsBngyG80vfRdNNvv1lxTfHAwOuIAI20cO5k2Iip5K
 LG7k5FRB09c87vg3ZUKPc94xADCTNRHKQh2qO36cB8dFXDnL1QjfjOpqbBRLTjwSxUna
 hn20vZ26Y+NlC0+XXx3OJRwcUqHnipksOGZbmd3ETlPyJfIgPj1oYYPvudm+Be1iQZ0S
 VopvyFfb6Uo0ZRcFoR/WhCWSBsbenynFxCMBBOgOIshovwr5OL2/SdDEji1uj12Xb3Hy uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h82jx5mun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 08:37:22 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26B8YlVB029325;
        Mon, 11 Jul 2022 08:37:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h82jx5mtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 08:37:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26B8bJVE001880;
        Mon, 11 Jul 2022 08:37:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3h71a8htx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 08:37:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26B8bPm932309734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jul 2022 08:37:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CB04A4051;
        Mon, 11 Jul 2022 08:37:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB34AA4040;
        Mon, 11 Jul 2022 08:37:12 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.7.160])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jul 2022 08:37:12 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [PATCH v12 0/3] s390x: KVM: CPU Topology
Date:   Mon, 11 Jul 2022 10:41:45 +0200
Message-Id: <20220711084148.25017-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5_kEtq6d4QCqngumZk1I7gTEtyIijhFr
X-Proofpoint-ORIG-GUID: xETyMzb3icHTceXkYLFpoqglHQ--Beae
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_13,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207110036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This new spin suppress the check for real cpu migration and
modify the checking of valid function code inside the interception
of the STSI instruction.

The series provides:
0- Modification of the ipte lock handling to use KVM instead of the
   vcpu as an argument because ipte lock work on SCA which is uniq
   per KVM structure and common to all vCPUs.
1- interception of the STSI instruction forwarding the CPU topology
2- interpretation of the PTF instruction
3- a KVM capability for the userland hypervisor to ask KVM to 
   setup PTF interpretation.
4- KVM ioctl to get and set the MTCR bit of the SCA in order to
   migrate this bit during a migration.


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

- first we report CPU hotplug

In future development we will provide:

- modification of the CPU mask inside sockets
- handling of shared CPUs
- reporting of the CPU Type
- reporting of the polarization


1- Interception of STSI

To provide Topology information to the guest through the STSI
instruction, we forward STSI with Function Code 15 to the
userland hypervisor which will take care to provide the right
information to the guest.

To let the guest use both the PTF instruction  to check if a topology
change occurred and sthe STSI_15.x.x instruction we add a new KVM
capability to enable the topology facility.

2- Interpretation of PTF with FC(2)

The PTF instruction reports a topology change if there is any change
with a previous STSI(15.1.2) SYSIB.

Changes inside a STSI(15.1.2) SYSIB occur if CPU bits are set or clear
inside the CPU Topology List Entry CPU mask field, which happens with
changes in CPU polarization, dedication, CPU types and adding or
removing CPUs in a socket.

Considering that the KVM guests currently only supports:
- horizontal polarization
- type 3 (Linux) CPU

And that we decide to support only:
- dedicated CPUs on the host
- pinned vCPUs on the guest

the creation of vCPU will is the only trigger to set the MTCR bit for
a guest.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry of the guest's
SCA which will be cleared during the interpretation of PTF.

Regards,
Pierre

Pierre Morel (3):
  KVM: s390: Cleanup ipte lock access and SIIF facility checks
  KVM: s390: guest support for topology function
  KVM: s390: resetting the Topology-Change-Report

 Documentation/virt/kvm/api.rst   | 25 +++++++++
 arch/s390/include/asm/kvm_host.h | 18 +++++-
 arch/s390/include/uapi/asm/kvm.h |  1 +
 arch/s390/kvm/gaccess.c          | 96 ++++++++++++++++----------------
 arch/s390/kvm/gaccess.h          |  6 +-
 arch/s390/kvm/kvm-s390.c         | 87 +++++++++++++++++++++++++++++
 arch/s390/kvm/priv.c             | 28 +++++++---
 arch/s390/kvm/vsie.c             |  8 +++
 include/uapi/linux/kvm.h         |  1 +
 9 files changed, 209 insertions(+), 61 deletions(-)

-- 
2.31.1

Changelog:

from v11 to v12

- protect sca pointer
  (Janis)

- check for user_stsi before returning information
  to userland
  (Janis)

- check for protected virtualization
  (Pierre)

from v10 to v11

- access mctr with interlocked access instead of ipte_lock
  (Janis)

- set mctr in kvm_arch_vcpu_destroy
  (Nico)

- better function documentation
  (Claudio)

- use a single function to set and clear
  (Janosch)

- Use u8 as API data
  (David, Janis)

- Check KVM_CAP_S390_USER_STSI before returning
  data to userspace
  (Nico)

from v9 to v10

- Suppression of the check on real CPU migration
  (Christian)

- Changed the check on fc in handle_stsi
  (David)

from v8 to v9

- bug correction in kvm_s390_topology_changed
  (Heiko)

- simplification for ipte_lock/unlock to use kvm
  as arg instead of vcpu and test on sclp.has_siif
  instead of the SIE ECA_SII.
  (David)

- use of a single value for reporting if the
  topology changed instead of a structure
  (David)

from v7 to v8

- implement reset handling
  (Janosch)

- change the way to check if the topology changed
  (Nico, Heiko)

from v6 to v7

- rebase

from v5 to v6

- make the subject more accurate
  (Claudio)

- Change the kvm_s390_set_mtcr() function to have vcpu in the name
  (Janosch)

- Replace the checks on ECB_PTF wit the check of facility 11
  (Janosch)

- modify kvm_arch_vcpu_load, move the check in a function in
  the header file
  (Janosh)

- No magical number replace the "new cpu value" of -1 with a define
  (Janosch)

- Make the checks for STSI validity clearer
  (Janosch)

from v4 tp v5

- modify the way KVM_CAP is tested to be OK with vsie
  (David)

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


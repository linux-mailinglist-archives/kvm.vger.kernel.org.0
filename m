Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D398B508731
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378187AbiDTLm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352651AbiDTLmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:42:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD4A1FCC7;
        Wed, 20 Apr 2022 04:40:09 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23K9KJMt024487;
        Wed, 20 Apr 2022 11:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=FOWMJaKcBmxHsdy9nbpnE+qHGCZ33g0Dy6GQGJuQGv0=;
 b=rNQMmkJP1GPp+Ex5ZLfM+n8HS/QptDTsVOkVlegToRv0YrheS1DIHUu7Fnk23Hkt6HpW
 5Ln7zj9Knty10a3lcyQGDb/Hgq60BhVNAPla6DuYEP/DkvTeP8I9yoSqUE5LDQbfvXJK
 nUDPJhCWKpMo7xhATe+KcRYsgR3GRCGt1+1FCcM09aU4Yk/zy/g6viMHJuverW0wDKhG
 H1zTejwVqBYWgxhowo5jvp/u3j0y5/lJLlzjvPQoCjKR6MIUGM4txECk6cqiFVDXkM7C
 EI7sY9AtM9XOb32SHb6MQseWoUhnEK68nuqhZn9Q4Yih/+lptn5MXmg+IIyJdAsnAOLW 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2tnh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:40:09 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KAjQLm017970;
        Wed, 20 Apr 2022 11:40:08 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjff2tng6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:40:08 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBROga029774;
        Wed, 20 Apr 2022 11:31:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u3bsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:31:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBVEGg33817080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:31:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A60052059;
        Wed, 20 Apr 2022 11:31:14 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7194D5204F;
        Wed, 20 Apr 2022 11:31:13 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 0/2] s390x: KVM: CPU Topology
Date:   Wed, 20 Apr 2022 13:34:28 +0200
Message-Id: <20220420113430.11876-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g4aqulNEI10u-YXs4DIdOon25_AuB94Z
X-Proofpoint-ORIG-GUID: 0VzG0B7ww_JgPTZYzSGRioIsDrDdXcGC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_03,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This new spin adds reset handling and bug correction to the series
for the implementation of interpretation for the PTF instruction.

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

- first we report CPU hotplug
- modification of the CPU mask inside sockets

In future development we will provide:

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


Pierre Morel (2):
  s390x: KVM: guest support for topology function
  s390x: KVM: resetting the Topology-Change-Report

 Documentation/virt/kvm/api.rst   |  16 +++
 arch/s390/include/asm/kvm_host.h |  12 ++-
 arch/s390/include/uapi/asm/kvm.h |   9 ++
 arch/s390/kvm/kvm-s390.c         | 177 ++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  25 +++++
 arch/s390/kvm/priv.c             |  14 ++-
 arch/s390/kvm/vsie.c             |   3 +
 include/uapi/linux/kvm.h         |   1 +
 8 files changed, 249 insertions(+), 8 deletions(-)

-- 
2.27.0

Changelog:

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


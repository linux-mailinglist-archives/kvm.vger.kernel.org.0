Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A35A3DE85E
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhHCI1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:27:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6602 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234238AbhHCI1F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:27:05 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1738Ji3n079441;
        Tue, 3 Aug 2021 04:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=7cemd5s5otMhR9MCqAuA2hGt0hUzYjf15MAYf1qsiQo=;
 b=G7D689uqjuhO3YAmKvSxUDG6+CcXCZko2dBji4NsZKangTBO2i95oJlnB3Y3uDNGwFny
 MDUVTDJo11B5jA9r+lHm1+IONUrwemD6RrpZKBswP7929c2lX6fPP8yeJneiwsvhP2JG
 o2Wgv3xCTkxm0/+GB+FZnR/Nyo1NZ9ewUQrmHONprw7S5Sz+BgvQjqLMYCJCLtR8KP/9
 e5AUDvh4ueFPVF5isLdDUigDgDL3r1+AI6FonNSF0Ij7kUkUo4ZBwmglK4ezAtlBV0DA
 GtYTFcyT8gXk3I/eWhjXMME61ajQcOIg3libWX/Z7qPw+Y1p8M69yGABxLEBjvGsvzzC lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a5ke67mm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:26:54 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1738KGxF080974;
        Tue, 3 Aug 2021 04:26:54 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a5ke67mk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:26:54 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1738HSE8027869;
        Tue, 3 Aug 2021 08:26:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3a4x58e0rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 08:26:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1738QmK850659784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 08:26:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7176A4053;
        Tue,  3 Aug 2021 08:26:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5359EA4040;
        Tue,  3 Aug 2021 08:26:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.75.95])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Aug 2021 08:26:47 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v3 0/3] s390x: KVM: CPU Topology
Date:   Tue,  3 Aug 2021 10:26:43 +0200
Message-Id: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yQWuUXS2XLDoPTmMEgeYAubkBEhVNNKb
X-Proofpoint-ORIG-GUID: tkOyn02WWK_xTck1yaG74c3CSOFjM7h-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-02,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This new series add the implementation of interpretation for
the PTF instruction.

The series is devided in three parts:
1- handling of the STSI instruction forwarding the CPU topology
2- implementation of the interpretation of the PTF instruction
3- use of the PTF interpretation to optimize topology change callback

1- STSI
To provide Topology information to the guest through the STSI
instruction, we need to forward STSI with Function Code 15 to
QEMU which will take care to provide the right information to
the guest.

To let the guest use both the PTF instruction  to check if a topology
change occured and sthe STSI_15.x.x instruction we add a new KVM
capability to enable the topology facility.

2- PTF
To implement PTF interpretation we make the MTCR pending when the
last CPU backed by the vCPU changed from one socket to another.

The PTF instruction will report a topology change if there is any change
with a previous STSI_15_2 SYSIB.
Changes inside a STSI_15_2 SYSIB occur if CPU bits are set or clear
inside the CPU Topology List Entry CPU mask field, which happens with
changes in CPU polarization, dedication, CPU types and adding or
removing CPUs in a socket.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry of the guest's
SCA which will be cleared during the interpretation of PTF.

To check if the topology has been modified we use a new field of the
arch vCPU to save the previous real CPU ID at the end of a schedule
and verify on next schedule that the CPU used is in the same socket.

We deliberatly ignore:
- polarization: only horizontal polarization is currently used in linux.
- CPU Type: only IFL Type are supported in Linux
- Dedication: we consider that only a complete dedicated CPU stack can
  take benefit of the CPU Topology and let the admin take care of that.


Regards,
Pierre


Pierre Morel (3):
  s390x: KVM: accept STSI for CPU topology information
  s390x: KVM: Implementation of Multiprocessor Topology-Change-Report
  s390x: optimization of the check for CPU topology change

 arch/s390/include/asm/kvm_host.h | 14 +++++++---
 arch/s390/kernel/topology.c      |  3 ++
 arch/s390/kvm/kvm-s390.c         | 48 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/priv.c             |  7 ++++-
 arch/s390/kvm/vsie.c             |  3 ++
 include/uapi/linux/kvm.h         |  1 +
 6 files changed, 70 insertions(+), 6 deletions(-)

-- 
2.25.1

Changelog:

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


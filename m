Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B321D21D9
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 00:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbgEMWRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 18:17:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730276AbgEMWRU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 18:17:20 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DM2tHW020466;
        Wed, 13 May 2020 18:17:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31016mafm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 18:17:19 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04DM3r0n026330;
        Wed, 13 May 2020 18:17:19 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31016mafkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 18:17:19 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04DMEtqP002407;
        Wed, 13 May 2020 22:17:18 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3100uc4fjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 22:17:18 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04DMHFlZ40239508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 22:17:15 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FA59AC059;
        Wed, 13 May 2020 22:17:15 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76974AC05B;
        Wed, 13 May 2020 22:17:15 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.196.213])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 May 2020 22:17:15 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: [PATCH v6 0/2] Use DIAG318 to set Control Program Name & Version Codes
Date:   Wed, 13 May 2020 18:15:55 -0400
Message-Id: <20200513221557.14366-1-walling@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1011 impostorscore=0
 cotscore=-2147483648 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130188
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog:

    v6
	- KVM disables diag318 get/set by default
	- added new IOCTL to tell KVM to enable diag318
	- removed VCPU event message in favor of VM_EVENT only

    v5
        - s/cpc/diag318_info in order to make the relevant data more clear
        - removed mutex locks for diag318_info get/set

    v4
        - removed setup.c changes introduced in bullet 1 of v3
        - kept diag318_info struct cleanup
        - analogous QEMU patches:
            https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg00164.html

    v3
        - kernel patch for diag 0x318 instruction call fixup [removed in v4]
        - removed CPU model code
        - cleaned up diag318_info struct
        - cpnc is no longer unshadowed as it was not needed
        - rebased on 5.1.0-rc3

This instruction call is executed once-and-only-once during Kernel setup.
The availability of this instruction depends on Read Info byte 134, bit 0.

DIAG 318's functionality is also emulated by KVM, which means we can enable 
this feature for a guest even if the host kernel cannot support it. This
feature is made available starting with the zEC12-full model (see analogous
QEMU patches).

The diag318_info is composed of a Control Program Name Code (CPNC) and a
Control Program Version Code (CPVC). These values are used for problem 
diagnosis and allows IBM to identify control program information by answering 
the following question:

    "What environment is this guest running in?" (CPNC)
    "What are more details regarding the OS?" (CPVC)

In the future, we will implement the CPVC to convey more information about the 
OS. For now, we set this field to 0 until we come up with a solid plan.

Collin Walling (2):
  s390/setup: diag318: refactor struct
  s390/kvm: diagnose 318 handling

 Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
 arch/s390/include/asm/diag.h          |  6 +-
 arch/s390/include/asm/kvm_host.h      |  6 +-
 arch/s390/include/uapi/asm/kvm.h      |  5 ++
 arch/s390/kernel/setup.c              |  3 +-
 arch/s390/kvm/diag.c                  | 20 ++++++
 arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h              |  1 +
 arch/s390/kvm/vsie.c                  |  2 +
 9 files changed, 154 insertions(+), 7 deletions(-)

-- 
2.21.3


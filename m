Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368021D5C46
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 00:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgEOWUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 18:20:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726212AbgEOWUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 18:20:02 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FM4Wh6146781;
        Fri, 15 May 2020 18:20:01 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310v8tdq3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:20:01 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04FM5VCj149901;
        Fri, 15 May 2020 18:20:01 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310v8tdq35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:20:01 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04FMAJMM007662;
        Fri, 15 May 2020 22:20:00 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 3100ucjfvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 22:20:00 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04FMJudA7602476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 22:19:56 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA712C605A;
        Fri, 15 May 2020 22:19:56 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C3C1C6055;
        Fri, 15 May 2020 22:19:56 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.146.125])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 22:19:55 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v7 0/3] Use DIAG318 to set Control Program Name & Version Codes
Date:   Fri, 15 May 2020 18:19:32 -0400
Message-Id: <20200515221935.18775-1-walling@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 cotscore=-2147483648
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150185
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog:

    v7

    • Removed diag handler, as it will now take place within userspace
    • Removed KVM_S390_VM_MISC_ENABLE_DIAG318 (undoes first bullet in v6)
    • Misc clean ups and fixes
        - introduced a new patch to s/diag318/diag_318 and s/byte_134/fac134
          to keep things consistent with the rest of the code

    v6

    • KVM disables diag318 get/set by default [removed in v7]
    • added new IOCTL to tell KVM to enable diag318 [removed in v7]
    • removed VCPU event message in favor of VM_EVENT only

    v5
    
    • s/cpc/diag318_info in order to make the relevant data more clear
    • removed mutex locks for diag318_info get/set

    v4
    
    • removed setup.c changes introduced in bullet 1 of v3
    • kept diag318_info struct cleanup
    • analogous QEMU patches:
        https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg00164.html

    v3
    
    • kernel patch for diag 0x318 instruction call fixup [removed in v4]
    • removed CPU model code
    • cleaned up diag318_info struct
    • cpnc is no longer unshadowed as it was not needed
    • rebased on 5.1.0-rc3

-------------------------------------------------------------------------------

This instruction call is executed once-and-only-once during Kernel setup.
The availability of this instruction depends on Read Info byte 134 (aka fac134),
bit 0.

DIAG 0x318's is handled by userspace and may be enabled for a guest even if the
host kernel cannot support it.

The diag318_info is composed of a Control Program Name Code (CPNC) and a
Control Program Version Code (CPVC). The CPNC is stored in SIE blocks, and
the CPNC & CPVC pair is stored in the kvm_arch struct. 

These values are used for problem diagnosis and allows IBM to identify control
program information by answering the following question:

    "What environment is this guest running in?" (CPNC)
    "What are more details regarding the OS?" (CPVC)

In the future, we will implement the CPVC to convey more information about the 
OS (such as Linux version and potentially some value denoting a specific 
distro + release). For now, we set this field to 0 until we come up with a solid 
plan.

Collin Walling (3):
  s390/setup: diag 318: refactor struct
  s390: keep diag 318 variables consistent with the rest
  s390/kvm: diagnose 0x318 get/set handling

 Documentation/virt/kvm/devices/vm.rst | 21 +++++++
 arch/s390/include/asm/diag.h          |  8 +--
 arch/s390/include/asm/kvm_host.h      |  5 +-
 arch/s390/include/asm/sclp.h          |  2 +-
 arch/s390/include/uapi/asm/kvm.h      |  4 ++
 arch/s390/kernel/setup.c              |  9 ++-
 arch/s390/kvm/kvm-s390.c              | 82 +++++++++++++++++++++++++++
 arch/s390/kvm/vsie.c                  |  2 +
 drivers/s390/char/sclp.h              |  2 +-
 drivers/s390/char/sclp_early.c        |  2 +-
 10 files changed, 123 insertions(+), 14 deletions(-)

-- 
2.21.3


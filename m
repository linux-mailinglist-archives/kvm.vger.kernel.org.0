Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9970E1FFDE7
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 00:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbgFRWWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 18:22:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731994AbgFRWWp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jun 2020 18:22:45 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IM4LwU155638;
        Thu, 18 Jun 2020 18:22:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31repa3qxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 18:22:43 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05IM4T15156398;
        Thu, 18 Jun 2020 18:22:43 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31repa3qxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 18:22:43 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05IMLDC4009207;
        Thu, 18 Jun 2020 22:22:42 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 31rdtr1dsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 22:22:42 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05IMMdk062062976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jun 2020 22:22:39 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 301586E04E;
        Thu, 18 Jun 2020 22:22:39 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 446926E04C;
        Thu, 18 Jun 2020 22:22:38 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.159.16])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jun 2020 22:22:38 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v8 0/2] Use DIAG318 to set Control Program Name & Version Codes
Date:   Thu, 18 Jun 2020 18:22:20 -0400
Message-Id: <20200618222222.23175-1-walling@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_21:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 clxscore=1011
 mlxscore=0 cotscore=-2147483648 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog:

    v8

    • Reset is handled in KVM during initial and clear resets
    • Sync/Store register handling
    • Removed device IOCTL code
    • Added KVM Capability for DIAG318
        - this is for determining if the CPU model can enable this feature
    • Reverted changes introduced by bullet 3 in v7
    • Unshadowing CPNC again, as it makes sense if the guest executing in
        VSIE sets a unique name/version code; this data should be preserved
        - reverts bullet 4 in v3
    • Diag318 is no longer reported via VM or CPU events
        - no place to put this such that the messages aren't flooding the logs
        - not necessary, as this data is primarily for IBM hardware/firmware
            service events, and is observable via such events (e.g. CPU ring
            dump)
        - was nice for testing purposes
    • A copy of the diag318 info (name & version code) is now stored in
        the kvm_vcpu_arch struct, as opposed to the kvm_arch struct

    v7

    • Removed diag handler, as it will now take place within userspace
    • Removed KVM_S390_VM_MISC_ENABLE_DIAG318 (undoes first bullet in v6)
    • Misc clean ups and fixes [removed in v8]
        - introduced a new patch to s/diag318/diag_318 and s/byte_134/fac134
          to keep things consistent with the rest of the code

    v6

    • KVM disables diag318 get/set by default [removed in v7]
    • added new IOCTL to tell KVM to enable diag318 [removed in v7]
    • removed VCPU event message in favor of VM_EVENT only [removed in v8]

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
    • cpnc is no longer unshadowed as it was not needed [removed in v8]
    • rebased on 5.1.0-rc3

-------------------------------------------------------------------------------

This instruction call is executed once-and-only-once during Kernel setup.
The availability of this instruction depends on Read Info byte 134 (aka fac134),
bit 0.

DIAG 0x318's is handled by userspace and may be enabled for a guest even if the
host kernel cannot support it.

The diag318_info is composed of a Control Program Name Code (CPNC) and a
Control Program Version Code (CPVC). The CPNC is stored in the SIE block, and
the CPNC & CPVC pair is stored in the kvm_vcpu_arch struct. 

These values are used for problem diagnosis and allows IBM to identify control
program information by answering the following question:

    "What environment is this guest running in?" (CPNC)
    "What are more details regarding the OS?" (CPVC)

In the future, we will implement the CPVC to convey more information about the 
OS (such as Linux version and potentially some value denoting a specific 
distro + release). For now, we set this field to 0 until we come up with a solid 
plan.

Collin Walling (2):
  s390/setup: diag 318: refactor struct
  s390/kvm: diagnose 0x318 sync and reset

 arch/s390/include/asm/diag.h     |  6 ++----
 arch/s390/include/asm/kvm_host.h |  4 +++-
 arch/s390/include/uapi/asm/kvm.h |  5 ++++-
 arch/s390/kernel/setup.c         |  3 +--
 arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
 arch/s390/kvm/vsie.c             |  3 +++
 include/uapi/linux/kvm.h         |  1 +
 7 files changed, 24 insertions(+), 9 deletions(-)

-- 
2.21.3


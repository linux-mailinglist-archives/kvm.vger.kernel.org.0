Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2744FDD40
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 13:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfKOMSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 07:18:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727557AbfKOMSG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 07:18:06 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFCEtB4019252
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 07:18:04 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w9jtvuncc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 07:18:04 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 15 Nov 2019 12:18:03 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 15 Nov 2019 12:18:00 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAFCHwHb27852848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 12:17:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B464CA4040;
        Fri, 15 Nov 2019 12:17:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67E96A4059;
        Fri, 15 Nov 2019 12:17:57 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Nov 2019 12:17:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com
Subject: [PATCH] SIDAD macro fixup
Date:   Fri, 15 Nov 2019 07:17:55 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <6f956633-d067-bde9-78dc-7833b9cd86ee@redhat.com>
References: <6f956633-d067-bde9-78dc-7833b9cd86ee@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19111512-0008-0000-0000-0000032F445C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111512-0009-0000-0000-00004A4E56D8
Message-Id: <20191115121755.63197-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_03:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=3
 adultscore=0 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=895
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Additionally I would need to use it in the other patches...

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 4 ++++
 arch/s390/kvm/kvm-s390.c         | 4 ++--
 arch/s390/kvm/pv.c               | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 2a8a1e21e1c3..81f6532531cb 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -122,6 +122,10 @@ struct mcck_volatile_info {
 	__u32 reserved;
 };
 
+#define SIDAD_SIZE_MASK		0xff
+#define sidad_origin(sie_block) \
+	(sie_block->sidad & PAGE_MASK)
+
 #define CPUSTAT_STOPPED    0x80000000
 #define CPUSTAT_WAIT       0x10000000
 #define CPUSTAT_ECALL_PEND 0x08000000
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0fa7c6d9ed0e..91a638cc1eba 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4436,7 +4436,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	 * block which has its own size limit
 	 */
 	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
-	    mop->size > ((vcpu->arch.sie_block->sidad & 0x0f) + 1) * PAGE_SIZE)
+	    mop->size > ((vcpu->arch.sie_block->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
 		return -E2BIG;
 
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
@@ -4460,7 +4460,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		}
 		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
 			r = 0;
-			if (copy_to_user(uaddr, (void *)vcpu->arch.sie_block->sidad +
+			if (copy_to_user(uaddr, (void *)sidad_origin(vcpu->arch.sie_block) +
 					 (mop->gaddr & ~PAGE_MASK),
 					 mop->size))
 				r = -EFAULT;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 764f8f9f5dff..661f03629265 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -119,7 +119,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
 
 	free_pages(vcpu->arch.pv.stor_base,
 		   get_order(uv_info.guest_cpu_stor_len));
-	free_page(vcpu->arch.sie_block->sidad);
+	free_page(sidad_origin(vcpu->arch.sie_block));
 	/* Clear cpu and vm handle */
 	memset(&vcpu->arch.sie_block->reserved10, 0,
 	       sizeof(vcpu->arch.sie_block->reserved10));
-- 
2.20.1


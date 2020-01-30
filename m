Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4A314D825
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 10:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgA3JLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 04:11:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbgA3JLG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 04:11:06 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00U98ruo069557
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 04:11:05 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xue96r1e0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 04:11:05 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 30 Jan 2020 09:11:02 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 Jan 2020 09:11:00 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00U9AxKj34472068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 09:10:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBBE94C050;
        Thu, 30 Jan 2020 09:10:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFEA64C040;
        Thu, 30 Jan 2020 09:10:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.99.188])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jan 2020 09:10:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: Cleanup initial cpu reset
Date:   Thu, 30 Jan 2020 04:10:55 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200129200312.3200-1-frankja@linux.ibm.com>
References: <20200129200312.3200-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013009-0008-0000-0000-0000034E0FDE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013009-0009-0000-0000-00004A6E8F79
Message-Id: <20200130091055.1857-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_02:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 suspectscore=1 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300065
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code seems to be quite old and uses lots of unneeded spaces for
alignment, which doesn't really help with readability.

Let's:
* Get rid of the extra spaces
* Remove the ULs as they are not needed on 0s
* Define constants for the CR 0 and 14 initial values
* Use the sizeof of the gcr array to memset it to 0

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---

I only send out 4 of the 5 patches...

---
 arch/s390/include/asm/kvm_host.h |  5 +++++
 arch/s390/kvm/kvm-s390.c         | 18 +++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 02f4c21c57f6..73044545ecac 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -122,6 +122,11 @@ struct mcck_volatile_info {
 	__u32 reserved;
 };
 
+#define CR0_INITIAL_MASK (CR0_UNUSED_56 | CR0_INTERRUPT_KEY_SUBMASK | \
+			  CR0_MEASUREMENT_ALERT_SUBMASK)
+#define CR14_INITIAL_MASK (CR14_UNUSED_32 | CR14_UNUSED_33 | \
+			   CR14_EXTERNAL_DAMAGE_SUBMASK)
+
 #define CPUSTAT_STOPPED    0x80000000
 #define CPUSTAT_WAIT       0x10000000
 #define CPUSTAT_ECALL_PEND 0x08000000
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d9e6bf3d54f0..c5f520de39a6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2847,19 +2847,15 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
 {
 	/* this equals initial cpu reset in pop, but we don't switch to ESA */
-	vcpu->arch.sie_block->gpsw.mask = 0UL;
-	vcpu->arch.sie_block->gpsw.addr = 0UL;
+	vcpu->arch.sie_block->gpsw.mask = 0;
+	vcpu->arch.sie_block->gpsw.addr = 0;
 	kvm_s390_set_prefix(vcpu, 0);
 	kvm_s390_set_cpu_timer(vcpu, 0);
-	vcpu->arch.sie_block->ckc       = 0UL;
-	vcpu->arch.sie_block->todpr     = 0;
-	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
-	vcpu->arch.sie_block->gcr[0]  = CR0_UNUSED_56 |
-					CR0_INTERRUPT_KEY_SUBMASK |
-					CR0_MEASUREMENT_ALERT_SUBMASK;
-	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
-					CR14_UNUSED_33 |
-					CR14_EXTERNAL_DAMAGE_SUBMASK;
+	vcpu->arch.sie_block->ckc = 0;
+	vcpu->arch.sie_block->todpr = 0;
+	memset(vcpu->arch.sie_block->gcr, 0, sizeof(vcpu->arch.sie_block->gcr));
+	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
+	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
 	/* make sure the new fpc will be lazily loaded */
 	save_fpu_regs();
 	current->thread.fpu.fpc = 0;
-- 
2.20.1


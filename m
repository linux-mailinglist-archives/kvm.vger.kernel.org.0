Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D208117DB99
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgCIIvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgCIIvn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:43 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298pHBG005164
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:43 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym7t6dsd1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:42 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:40 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:37 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pava23068680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6574911C04C;
        Mon,  9 Mar 2020 08:51:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4752911C04A;
        Mon,  9 Mar 2020 08:51:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:36 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 05CEBE0251; Mon,  9 Mar 2020 09:51:36 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 25/36] KVM: s390: protvirt: Only sync fmt4 registers
Date:   Mon,  9 Mar 2020 09:51:15 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0008-0000-0000-0000035AA7E4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0009-0000-0000-00004A7BE6E9
Message-Id: <20200309085126.3334302-26-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=685
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

A lot of the registers are controlled by the Ultravisor and never
visible to KVM. Also some registers are overlayed, like gbea is with
sidad, which might leak data to userspace.

Hence we sync a minimal set of registers for both SIE formats and then
check and sync format 2 registers if necessary.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 110 +++++++++++++++++++++++++--------------
 1 file changed, 70 insertions(+), 40 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1c7bbc2497a2..abe295077d00 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4113,7 +4113,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct runtime_instr_cb *riccb;
 	struct gs_cb *gscb;
@@ -4122,16 +4122,7 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
 	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
 	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
-		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
-	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
-		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
-		/* some control register changes require a tlb flush */
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-	}
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
-		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
-		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
 		vcpu->arch.sie_block->todpr = kvm_run->s.regs.todpr;
 		vcpu->arch.sie_block->pp = kvm_run->s.regs.pp;
 		vcpu->arch.sie_block->gbea = kvm_run->s.regs.gbea;
@@ -4172,6 +4163,36 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
 		vcpu->arch.sie_block->fpf |= kvm_run->s.regs.bpbc ? FPF_BPBC : 0;
 	}
+	if (MACHINE_HAS_GS) {
+		preempt_disable();
+		__ctl_set_bit(2, 4);
+		if (current->thread.gs_cb) {
+			vcpu->arch.host_gscb = current->thread.gs_cb;
+			save_gs_cb(vcpu->arch.host_gscb);
+		}
+		if (vcpu->arch.gs_enabled) {
+			current->thread.gs_cb = (struct gs_cb *)
+						&vcpu->run->s.regs.gscb;
+			restore_gs_cb(current->thread.gs_cb);
+		}
+		preempt_enable();
+	}
+	/* SIE will load etoken directly from SDNX and therefore kvm_run */
+}
+
+static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
+		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
+	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
+		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
+		/* some control register changes require a tlb flush */
+		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+	}
+	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
+		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
+		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
+	}
 	save_access_regs(vcpu->arch.host_acrs);
 	restore_access_regs(vcpu->run->s.regs.acrs);
 	/* save host (userspace) fprs/vrs */
@@ -4186,23 +4207,47 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (test_fp_ctl(current->thread.fpu.fpc))
 		/* User space provided an invalid FPC, let's clear it */
 		current->thread.fpu.fpc = 0;
+
+	/* Sync fmt2 only data */
+	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu))) {
+		sync_regs_fmt2(vcpu, kvm_run);
+	} else {
+		/*
+		 * In several places we have to modify our internal view to
+		 * not do things that are disallowed by the ultravisor. For
+		 * example we must not inject interrupts after specific exits
+		 * (e.g. 112 prefix page not secure). We do this by turning
+		 * off the machine check, external and I/O interrupt bits
+		 * of our PSW copy. To avoid getting validity intercepts, we
+		 * do only accept the condition code from userspace.
+		 */
+		vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_CC;
+		vcpu->arch.sie_block->gpsw.mask |= kvm_run->psw_mask &
+						   PSW_MASK_CC;
+	}
+
+	kvm_run->kvm_dirty_regs = 0;
+}
+
+static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
+	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
+	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
+	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
 	if (MACHINE_HAS_GS) {
-		preempt_disable();
 		__ctl_set_bit(2, 4);
-		if (current->thread.gs_cb) {
-			vcpu->arch.host_gscb = current->thread.gs_cb;
-			save_gs_cb(vcpu->arch.host_gscb);
-		}
-		if (vcpu->arch.gs_enabled) {
-			current->thread.gs_cb = (struct gs_cb *)
-						&vcpu->run->s.regs.gscb;
-			restore_gs_cb(current->thread.gs_cb);
-		}
+		if (vcpu->arch.gs_enabled)
+			save_gs_cb(current->thread.gs_cb);
+		preempt_disable();
+		current->thread.gs_cb = vcpu->arch.host_gscb;
+		restore_gs_cb(vcpu->arch.host_gscb);
 		preempt_enable();
+		if (!vcpu->arch.host_gscb)
+			__ctl_clear_bit(2, 4);
+		vcpu->arch.host_gscb = NULL;
 	}
-	/* SIE will load etoken directly from SDNX and therefore kvm_run */
-
-	kvm_run->kvm_dirty_regs = 0;
+	/* SIE will save etoken directly into SDNX and therefore kvm_run */
 }
 
 static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
@@ -4213,13 +4258,9 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	memcpy(&kvm_run->s.regs.crs, &vcpu->arch.sie_block->gcr, 128);
 	kvm_run->s.regs.cputm = kvm_s390_get_cpu_timer(vcpu);
 	kvm_run->s.regs.ckc = vcpu->arch.sie_block->ckc;
-	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
-	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
-	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
 	kvm_run->s.regs.pft = vcpu->arch.pfault_token;
 	kvm_run->s.regs.pfs = vcpu->arch.pfault_select;
 	kvm_run->s.regs.pfc = vcpu->arch.pfault_compare;
-	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
 	save_access_regs(vcpu->run->s.regs.acrs);
 	restore_access_regs(vcpu->arch.host_acrs);
 	/* Save guest register state */
@@ -4228,19 +4269,8 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* Restore will be done lazily at return */
 	current->thread.fpu.fpc = vcpu->arch.host_fpregs.fpc;
 	current->thread.fpu.regs = vcpu->arch.host_fpregs.regs;
-	if (MACHINE_HAS_GS) {
-		__ctl_set_bit(2, 4);
-		if (vcpu->arch.gs_enabled)
-			save_gs_cb(current->thread.gs_cb);
-		preempt_disable();
-		current->thread.gs_cb = vcpu->arch.host_gscb;
-		restore_gs_cb(vcpu->arch.host_gscb);
-		preempt_enable();
-		if (!vcpu->arch.host_gscb)
-			__ctl_clear_bit(2, 4);
-		vcpu->arch.host_gscb = NULL;
-	}
-	/* SIE will save etoken directly into SDNX and therefore kvm_run */
+	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu)))
+		store_regs_fmt2(vcpu, kvm_run);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-- 
2.24.1


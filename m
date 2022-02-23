Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB154C102A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 11:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiBWKUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 05:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiBWKUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 05:20:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E22B8BF26;
        Wed, 23 Feb 2022 02:20:10 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N9CY2S004391;
        Wed, 23 Feb 2022 10:20:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pIU2ZQzM9XmpYh9hy18AkRmvhqaLER20u7QOn2MozuU=;
 b=Q+fvNrMnbU48oijq4Eeors6wrnjWAqq5re4c0wEpwnVBsDEDzxCjsPh7kH5E52H/wXoa
 8nZNo5XYsQxWR4Mj7nTBzeIKmaAUFADCpIcGB0rLTM+hfJFDCrrB/BGvMnD9AMrb/kuV
 Zm3+hcTPVb2lj63MknJ/H9zWTEo8ntAXKmyqfxzzdFTrutvyT9sWBb7KZkJq5Ary7u45
 +kyX6T8AKVqjn8QFhb340BsFzMxViElc9le8PTOU9BtFq6LLfMv2N64014Nh0AvyDXHI
 FFm+W5xOLIYbp7eakZR1cAMrbSSl9rJNI3fSoRMYKlVWNCCb9QE1lkIpaiZhR7IrvOHM yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edj3fsakt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:09 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NAGts3016634;
        Wed, 23 Feb 2022 10:20:09 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edj3fsak8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:09 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NADkJ7018036;
        Wed, 23 Feb 2022 10:20:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3ear69ferf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NAK3Zp51970382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 10:20:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CB8A52050;
        Wed, 23 Feb 2022 10:20:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3C97252067;
        Wed, 23 Feb 2022 10:20:03 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com, pasic@linux.ibm.com,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH v4 2/2] KVM: s390: pv: make use of ultravisor AIV support
Date:   Wed, 23 Feb 2022 11:20:00 +0100
Message-Id: <20220223102000.3733712-3-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223102000.3733712-1-mimu@linux.ibm.com>
References: <20220223102000.3733712-1-mimu@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hMFAQtkQ3-sB8SNaqjMoREucFXINR5Nz
X-Proofpoint-ORIG-GUID: TWNgKRp4d1DqQNK26ljqiuE4zJq19QQ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_03,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=664
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enables the ultravisor adapter interruption vitualization
support indicated by UV feature BIT_UV_FEAT_AIV. This allows ISC
interruption injection directly into the GISA IPM for PV kvm guests.

Hardware that does not support this feature will continue to use the
UV interruption interception method to deliver ISC interruptions to
PV kvm guests. For this purpose, the ECA_AIV bit for all guest cpus
will be cleared and the GISA will be disabled during PV CPU setup.

In addition a check in __inject_io() has been removed. That reduces the
required instructions for interruption handling for PV and traditional
kvm guests.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kvm/interrupt.c  | 54 +++++++++++++++++++++++++++++++++-----
 arch/s390/kvm/kvm-s390.c   | 11 +++++---
 arch/s390/kvm/kvm-s390.h   | 11 ++++++++
 4 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 86218382d29c..a2d376b8bce3 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -80,6 +80,7 @@ enum uv_cmds_inst {
 
 enum uv_feat_ind {
 	BIT_UV_FEAT_MISC = 0,
+	BIT_UV_FEAT_AIV = 1,
 };
 
 struct uv_cb_header {
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index db933c252dbc..c3b2c7650b48 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1901,13 +1901,12 @@ static int __inject_io(struct kvm *kvm, struct kvm_s390_interrupt_info *inti)
 	isc = int_word_to_isc(inti->io.io_int_word);
 
 	/*
-	 * Do not make use of gisa in protected mode. We do not use the lock
-	 * checking variant as this is just a performance optimization and we
-	 * do not hold the lock here. This is ok as the code will pick
-	 * interrupts from both "lists" for delivery.
+	 * We do not use the lock checking variant as this is just a
+	 * performance optimization and we do not hold the lock here.
+	 * This is ok as the code will pick interrupts from both "lists"
+	 * for delivery.
 	 */
-	if (!kvm_s390_pv_get_handle(kvm) &&
-	    gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
+	if (gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
 		VM_EVENT(kvm, 4, "%s isc %1u", "inject: I/O (AI/gisa)", isc);
 		gisa_set_ipm_gisc(gi->origin, isc);
 		kfree(inti);
@@ -3171,9 +3170,33 @@ void kvm_s390_gisa_init(struct kvm *kvm)
 	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
 }
 
+void kvm_s390_gisa_enable(struct kvm *kvm)
+{
+	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	u32 gisa_desc;
+
+	if (gi->origin)
+		return;
+	kvm_s390_gisa_init(kvm);
+	gisa_desc = kvm_s390_get_gisa_desc(kvm);
+	if (!gisa_desc)
+		return;
+	kvm_s390_vcpu_block_all(kvm);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		vcpu->arch.sie_block->gd = gisa_desc;
+		vcpu->arch.sie_block->eca |= ECA_AIV;
+		VCPU_EVENT(vcpu, 3, "AIV gisa format-%u enabled for cpu %03u",
+			   vcpu->arch.sie_block->gd & 0x3, vcpu->vcpu_id);
+	}
+	kvm_s390_vcpu_unblock_all(kvm);
+}
+
 void kvm_s390_gisa_destroy(struct kvm *kvm)
 {
 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
+	struct kvm_s390_gisa *gisa = gi->origin;
 
 	if (!gi->origin)
 		return;
@@ -3184,6 +3207,25 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
 		cpu_relax();
 	hrtimer_cancel(&gi->timer);
 	gi->origin = NULL;
+	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
+}
+
+void kvm_s390_gisa_disable(struct kvm *kvm)
+{
+	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	if (!gi->origin)
+		return;
+	kvm_s390_vcpu_block_all(kvm);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		vcpu->arch.sie_block->eca &= ~ECA_AIV;
+		vcpu->arch.sie_block->gd = 0U;
+		VCPU_EVENT(vcpu, 3, "AIV disabled for cpu %03u", vcpu->vcpu_id);
+	}
+	kvm_s390_vcpu_unblock_all(kvm);
+	kvm_s390_gisa_destroy(kvm);
 }
 
 /**
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b75ea3e57172..e2827c0ed642 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2194,6 +2194,9 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 		}
 	}
 	kvm_s390_vcpu_unblock_all(kvm);
+	/* Ensure that we re-enable gisa if the non-PV guest used it but the PV guest did not. */
+	if (use_gisa)
+		kvm_s390_gisa_enable(kvm);
 	return ret;
 }
 
@@ -2205,6 +2208,10 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 	struct kvm_vcpu *vcpu;
 
+	/* Disable the GISA if the ultravisor does not support AIV. */
+	if (!test_bit_inv(BIT_UV_FEAT_AIV, &uv_info.uv_feature_indications))
+		kvm_s390_gisa_disable(kvm);
+
 	kvm_s390_vcpu_block_all(kvm);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
@@ -3263,9 +3270,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.sie_block->icpua = vcpu->vcpu_id;
 	spin_lock_init(&vcpu->arch.local_int.lock);
-	vcpu->arch.sie_block->gd = (u32)(u64)vcpu->kvm->arch.gisa_int.origin;
-	if (vcpu->arch.sie_block->gd && sclp.has_gisaf)
-		vcpu->arch.sie_block->gd |= GISA_FORMAT1;
+	vcpu->arch.sie_block->gd = kvm_s390_get_gisa_desc(vcpu->kvm);
 	seqcount_init(&vcpu->arch.cputm_seqcount);
 
 	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 098831e815e6..4ba8fc30d87a 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -231,6 +231,15 @@ static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
 	return ms->base_gfn + ms->npages;
 }
 
+static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
+{
+	u32 gd = (u32)(u64)kvm->arch.gisa_int.origin;
+
+	if (gd && sclp.has_gisaf)
+		gd |= GISA_FORMAT1;
+	return gd;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
@@ -450,6 +459,8 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu,
 void kvm_s390_gisa_init(struct kvm *kvm);
 void kvm_s390_gisa_clear(struct kvm *kvm);
 void kvm_s390_gisa_destroy(struct kvm *kvm);
+void kvm_s390_gisa_disable(struct kvm *kvm);
+void kvm_s390_gisa_enable(struct kvm *kvm);
 int kvm_s390_gib_init(u8 nisc);
 void kvm_s390_gib_destroy(void);
 
-- 
2.32.0


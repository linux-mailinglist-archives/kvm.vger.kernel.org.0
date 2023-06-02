Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134F071F761
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbjFBAvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbjFBAvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:51:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96097F2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 17:51:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bacd408046cso2110470276.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 17:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667089; x=1688259089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UIUDwv4uXBQqeuankcviKzdoEYgwjSk1vg/GMI2E9kU=;
        b=kwepsSVcQ1ZdllZMR+MuqRSRsxwF4VhSpgm7WIv0Bcs1azSUeortlbVmeG/zK9PNJb
         zvOIhOtG1OpxvjnC0tRq4DFSnuyzuJ0Q6Z+UXjSTWvMpGWtoYpm+grtLPNL+PNVHNZmz
         5ihyyFwazCkYN45GFrCCD6Q8d/ivtGDTMrzfx/aaPq5YmDJPmxGmVlAFl1ud2RlcAQLp
         r/ZNiyOmzLCFNPP4dOzzaRYER1TeoSkPKV0PZtjVnHtIIFJInzVZQFgU6AvL4prJ0GFZ
         e9xUe1aMkKX0RpiCFCUuY/5iX7OcoAeq1s6iQtIoESkCJL5TVOxYN25I+4NEQlzgrx55
         X0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667089; x=1688259089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UIUDwv4uXBQqeuankcviKzdoEYgwjSk1vg/GMI2E9kU=;
        b=akmzPCQb/J8n+FkJXZuZRyOOA0qpYy5uOVjzeDx+iQruBEQRd1vgB591+SzGZpftPW
         cHhy9xmAUwrrn2RomiJTKjIjD/R4wdSYvCQHRgFdwWPbdZQFyTGoEj9aUO33UCxPHVhB
         tD7dlO3QfPZuFvQt8/gfMld5ZWj+MIL/mzPqBeZ39LtCkx89J4LvAcXUJItb6wpm4PYn
         fY2lG3/8B4/ie3uBgcOILKT5EezMHoo2DpJaRm7OQLfJnvHP5Pr16n8H7fsi7mOakWyr
         96KHXOMB6v5kqGszHTnRQ1zCl/XD6Jd4ltuBygnn3ftlRlD8IOYzZtgidpol1yX8kCT6
         kN/g==
X-Gm-Message-State: AC+VfDz2rQrzPTfBVKQ5Rd60V+iz52uaOFRygFkGfM/NdndpzGYBMf0/
        7s/1e31xR7079M664lL2SnnjU8cvo2xHhy1ZENgWabMMlflrmQjXDWKVjouvYO/agsNErfyUSVk
        +pF/w4RuuZljaJTNFL0ITPUAcIwrc0MVbujKwFZeORFf0CFTOlYXJskSlJa3I+dqCBYcIBqs=
X-Google-Smtp-Source: ACHHUZ6L8I9kweh9tNyfLEgcfmyI9zHXG+ige0ZlkfN1WFwSPkKcyEaomEafF3my9cCaL2N4ry6YaqlVe3cPwMG3ww==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:1547:b0:bac:bae6:b363 with
 SMTP id r7-20020a056902154700b00bacbae6b363mr997620ybu.3.1685667088732; Thu,
 01 Jun 2023 17:51:28 -0700 (PDT)
Date:   Fri,  2 Jun 2023 00:51:16 +0000
In-Reply-To: <20230602005118.2899664-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230602005118.2899664-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602005118.2899664-5-jingzhangos@google.com>
Subject: [PATCH v11 4/5] KVM: arm64: Reuse fields of sys_reg_desc for idreg
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sys_reg_desc::{reset, val} are presently unused for ID register
descriptors. Repurpose these fields to support user-configurable ID
registers.
Use the ::reset() function pointer to return the sanitised value of a
given ID register, optionally with KVM-specific feature sanitisation.
Additionally, keep a mask of writable register fields in ::val.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 101 +++++++++++++++++++++++++++-----------
 arch/arm64/kvm/sys_regs.h |  15 ++++--
 2 files changed, 82 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0179df50fcf5..1a534e0fc4ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -541,10 +541,11 @@ static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
-static void reset_bvr(struct kvm_vcpu *vcpu,
+static u64 reset_bvr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = rd->val;
+	return rd->val;
 }
 
 static bool trap_bcr(struct kvm_vcpu *vcpu,
@@ -577,10 +578,11 @@ static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
-static void reset_bcr(struct kvm_vcpu *vcpu,
+static u64 reset_bcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = rd->val;
+	return rd->val;
 }
 
 static bool trap_wvr(struct kvm_vcpu *vcpu,
@@ -614,10 +616,11 @@ static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
-static void reset_wvr(struct kvm_vcpu *vcpu,
+static u64 reset_wvr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = rd->val;
+	return rd->val;
 }
 
 static bool trap_wcr(struct kvm_vcpu *vcpu,
@@ -650,25 +653,28 @@ static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
-static void reset_wcr(struct kvm_vcpu *vcpu,
+static u64 reset_wcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
 	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
+	return rd->val;
 }
 
-static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 amair = read_sysreg(amair_el1);
 	vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
+	return amair;
 }
 
-static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 actlr = read_sysreg(actlr_el1);
 	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
+	return actlr;
 }
 
-static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 mpidr;
 
@@ -682,7 +688,10 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
 	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
 	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
+	mpidr |= (1ULL << 31);
+	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
+
+	return mpidr;
 }
 
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
@@ -694,13 +703,13 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
 
 	/* No PMU available, any PMU reg may UNDEF... */
 	if (!kvm_arm_support_pmu_v3())
-		return;
+		return 0;
 
 	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
 	n &= ARMV8_PMU_PMCR_N_MASK;
@@ -709,33 +718,41 @@ static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 	reset_unknown(vcpu, r);
 	__vcpu_sys_reg(vcpu, r->reg) &= mask;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
 	__vcpu_sys_reg(vcpu, r->reg) &= GENMASK(31, 0);
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
 	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_EVTYPE_MASK;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
 	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr;
 
 	/* No PMU available, PMCR_EL0 may UNDEF... */
 	if (!kvm_arm_support_pmu_v3())
-		return;
+		return 0;
 
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
 	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
@@ -743,6 +760,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
 	__vcpu_sys_reg(vcpu, r->reg) = pmcr;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
@@ -1232,6 +1251,11 @@ static void pmuver_update(struct kvm_vcpu *vcpu, u8 pmuver, bool valid_pmu)
 	}
 }
 
+static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	return read_sanitised_ftr_reg(reg_to_encoding(rd));
+}
+
 static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
 {
 	u64 val = IDREG(vcpu->kvm, encoding);
@@ -1540,7 +1564,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
  * Fabricate a CLIDR_EL1 value instead of using the real value, which can vary
  * by the physical CPU which the vcpu currently resides in.
  */
-static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
 	u64 clidr;
@@ -1588,6 +1612,8 @@ static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
 
 	__vcpu_sys_reg(vcpu, r->reg) = clidr;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -1687,6 +1713,17 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.visibility = elx2_visibility,		\
 }
 
+/*
+ * Since reset() callback and field val are not used for idregs, they will be
+ * used for specific purposes for idregs.
+ * The reset() would return KVM sanitised register value. The value would be the
+ * same as the host kernel sanitised value if there is no KVM sanitisation.
+ * The val would be used as a mask indicating writable fields for the idreg.
+ * Only bits with 1 are writable from userspace. This mask might not be
+ * necessary in the future whenever all ID registers are enabled as writable
+ * from userspace.
+ */
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
@@ -1694,6 +1731,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
+	.reset = general_read_kvm_sanitised_reg,\
+	.val = 0,				\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
@@ -1703,6 +1742,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = aa32_id_visibility,	\
+	.reset = general_read_kvm_sanitised_reg,\
+	.val = 0,				\
 }
 
 /*
@@ -1715,7 +1756,9 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.access = access_id_reg,			\
 	.get_user = get_id_reg,				\
 	.set_user = set_id_reg,				\
-	.visibility = raz_visibility			\
+	.visibility = raz_visibility,			\
+	.reset = NULL,					\
+	.val = 0,					\
 }
 
 /*
@@ -1729,6 +1772,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = raz_visibility,		\
+	.reset = NULL,				\
+	.val = 0,				\
 }
 
 static bool access_sp_el1(struct kvm_vcpu *vcpu,
@@ -3067,19 +3112,21 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
  */
 
 #define FUNCTION_INVARIANT(reg)						\
-	static void get_##reg(struct kvm_vcpu *v,			\
+	static u64 get_##reg(struct kvm_vcpu *v,			\
 			      const struct sys_reg_desc *r)		\
 	{								\
 		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
+		return ((struct sys_reg_desc *)r)->val;			\
 	}
 
 FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
-static void get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
+static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
 {
 	((struct sys_reg_desc *)r)->val = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	return ((struct sys_reg_desc *)r)->val;
 }
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
@@ -3389,9 +3436,7 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
-/*
- * Set the guest's ID registers with ID_SANITISED() to the host's sanitized value.
- */
+/* Initialize the guest's ID registers with KVM sanitised values. */
 void kvm_arm_init_id_regs(struct kvm *kvm)
 {
 	const struct sys_reg_desc *idreg = first_idreg;
@@ -3400,13 +3445,11 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 
 	/* Initialize all idregs */
 	while (is_id_reg(id)) {
-		/*
-		 * Some hidden ID registers which are not in arm64_ftr_regs[]
-		 * would cause warnings from read_sanitised_ftr_reg().
-		 * Skip those ID registers to avoid the warnings.
-		 */
-		if (idreg->visibility != raz_visibility)
-			IDREG(kvm, id) = read_sanitised_ftr_reg(id);
+		val = 0;
+		/* Read KVM sanitised register value if available */
+		if (idreg->reset)
+			val = idreg->reset(NULL, idreg);
+		IDREG(kvm, id) = val;
 
 		idreg++;
 		id = reg_to_encoding(idreg);
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index eba10de2e7ae..c65c129b3500 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -71,13 +71,16 @@ struct sys_reg_desc {
 		       struct sys_reg_params *,
 		       const struct sys_reg_desc *);
 
-	/* Initialization for vcpu. */
-	void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
+	/*
+	 * Initialization for vcpu. Return initialized value, or KVM
+	 * sanitized value for ID registers.
+	 */
+	u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
 
 	/* Index into sys_reg[], or 0 if we don't need to save it. */
 	int reg;
 
-	/* Value (usually reset value) */
+	/* Value (usually reset value), or write mask for idregs */
 	u64 val;
 
 	/* Custom get/set_user functions, fallback to generic if NULL */
@@ -130,19 +133,21 @@ static inline bool read_zero(struct kvm_vcpu *vcpu,
 }
 
 /* Reset functions */
-static inline void reset_unknown(struct kvm_vcpu *vcpu,
+static inline u64 reset_unknown(struct kvm_vcpu *vcpu,
 				 const struct sys_reg_desc *r)
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
 	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
-static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static inline u64 reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
 	__vcpu_sys_reg(vcpu, r->reg) = r->val;
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
-- 
2.41.0.rc0.172.g3f132b7071-goog


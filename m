Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EA3705FC1
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 08:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjEQGKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 02:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjEQGKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 02:10:43 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A2330E6
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5611211f767so5901307b3.0
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684303826; x=1686895826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rClp5Zek+lrq7D6BY/89xeY/Hvv1bZ/OLAmK1/PvS2I=;
        b=gTjYm8QC8364AiDOaDbvYvlBA9/FQn33CrJP7v3bSmev41oCVltEglVSE55ZHGaSEh
         jy/wGdH0PT8kztQsTsNEoV7xgJEsUM0t1Qq6dASldXC7HXL45k0hONUSbMX8VHZZUxyU
         yoUUpBpZMZ67W1qCO4GkuG70hXqNCrxuY8l2QSH5KjMcmTwj67jmeE6Q/21FfXk7oPOY
         sxHgW4W9sH+cmlJ7Er7gOPCG5Hd5wjTySyDFCkoH7kkBAVEmUm0u6xll+NgeQlY4BdcG
         lcTpVXvmZrT6zHne/zuvKbu51YnvjXh0cGPjcq2Z+S9/NiAYUv/OIiY7glBOUFd++Tke
         clWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684303826; x=1686895826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rClp5Zek+lrq7D6BY/89xeY/Hvv1bZ/OLAmK1/PvS2I=;
        b=chGPt0m9JGjGmw6/7AANvl5o0iuYcqARYk+1A6RtJNDxeWqvt7rUKSjXRWwCCUR/qA
         VzNW/g3A/b74WEXeiRinY3CZ0acjK575nYy/j829Q5EG0Ra+JoNTRoiqBjAXc/6c4nrh
         NiKcwYOO29t78+k59yy6eSRZEVVjQXH1OrwJI3o0FtjwB0jMopnWceypdgjRYHzsI18+
         1xJpKw5BYU+jxoMc/602m3L+3oPBGHMhV2PTXv8DH0nNSLdFwJPNu6HylJ1Ggy6gWxVE
         2CZTD1DhOgOQKu6gFIa/EdBIjlT2itgVRCR/tSxLdshHBUbwfUFeiznPTgYl6MUU/mVB
         UqGw==
X-Gm-Message-State: AC+VfDylPUdDEj5mUulF+foFhM+3rFCqo9UFw3YFhjNQPSYhaX7PP9gi
        /3xa8mjmlu1cA+0HgzGxNUbbK65yf9w9mEefqZqrbFHYhiQw8bZ2wP9ZBTDk1mhTMXe/2JGDfue
        WEXYWbLzbgjD5489MCUgwzNJLJqZ6EJIJvBD8zKth6E7ielaYB4dQzl4LrNcahIND2U3QKXg=
X-Google-Smtp-Source: ACHHUZ4Sn2OIpJg1ZBf8Wajbw9FdpJGG3msE7JVETYW8YpBhe5GeeRKVY7K2OxG43c2rKd2fjT1VUSujCslXr0dM1w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:4419:0:b0:561:89f1:b9bd with SMTP
 id r25-20020a814419000000b0056189f1b9bdmr3034464ywa.0.1684303826333; Tue, 16
 May 2023 23:10:26 -0700 (PDT)
Date:   Wed, 17 May 2023 06:10:13 +0000
In-Reply-To: <20230517061015.1915934-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517061015.1915934-5-jingzhangos@google.com>
Subject: [PATCH v9 4/5] KVM: arm64: Reuse fields of sys_reg_desc for idreg
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

Since reset() and val are not used for idreg in sys_reg_desc, they would
be used with other purposes for idregs.
The callback reset() would be used to return KVM sanitised id register
values. The u64 val would be used as mask for writable fields in idregs.
Only bits with 1 in val are writable from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 101 +++++++++++++++++++++++++++-----------
 arch/arm64/kvm/sys_regs.h |  15 ++++--
 2 files changed, 82 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fefe83f8deda..1b5dada9aad7 100644
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
@@ -1212,6 +1231,11 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
+static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	return read_sanitised_ftr_reg(reg_to_encoding(rd));
+}
+
 static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
 	u64 val = IDREG(vcpu->kvm, id);
@@ -1594,7 +1618,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
  * Fabricate a CLIDR_EL1 value instead of using the real value, which can vary
  * by the physical CPU which the vcpu currently resides in.
  */
-static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
 	u64 clidr;
@@ -1642,6 +1666,8 @@ static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
 
 	__vcpu_sys_reg(vcpu, r->reg) = clidr;
+
+	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
 static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -1741,6 +1767,17 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
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
@@ -1748,6 +1785,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
+	.reset = general_read_kvm_sanitised_reg,\
+	.val = 0,				\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
@@ -1757,6 +1796,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = aa32_id_visibility,	\
+	.reset = general_read_kvm_sanitised_reg,\
+	.val = 0,				\
 }
 
 /*
@@ -1769,7 +1810,9 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.access = access_id_reg,			\
 	.get_user = get_id_reg,				\
 	.set_user = set_id_reg,				\
-	.visibility = raz_visibility			\
+	.visibility = raz_visibility,			\
+	.reset = NULL,					\
+	.val = 0,					\
 }
 
 /*
@@ -1783,6 +1826,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,			\
 	.set_user = set_id_reg,			\
 	.visibility = raz_visibility,		\
+	.reset = NULL,				\
+	.val = 0,				\
 }
 
 static bool access_sp_el1(struct kvm_vcpu *vcpu,
@@ -3119,19 +3164,21 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
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
@@ -3421,9 +3468,7 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
-/*
- * Set the guest's ID registers with ID_SANITISED() to the host's sanitized value.
- */
+/* Initialize the guest's ID registers with KVM sanitised values. */
 void kvm_arm_init_id_regs(struct kvm *kvm)
 {
 	const struct sys_reg_desc *idreg;
@@ -3440,13 +3485,11 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 
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
2.40.1.606.ga4b1b128d6-goog


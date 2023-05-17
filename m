Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69455705FC2
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 08:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjEQGKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 02:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjEQGKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 02:10:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC700448A
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:28 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-24e5481a79fso333799a91.2
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684303828; x=1686895828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mpie8/glAH3yyNKq+/RQAK3YUsaaOKOt8+ItYsJdR5g=;
        b=3lQbJ+WmlSX/MfGhhiEeYS5JTt2kvAWyvpDW+7K1fcChPIMXgJzLMLYN8klvUT2dNR
         jDfPmAlpGshnTQcNLp0nhYzl+o+jGiK1GyTWfX4pdxB/hQHGFAuqjXowIkAQK0Cj2P07
         Aktl78TGaPAV9qE9rs8PUZlMXW5YrEjq5B2O8VlYlFlHAygUK30seCbiT+B8xfJ7rD5B
         5ruj7zIgKY/Z86cEHty3rLyPB6m78IGLf30ngZ6UMHh86IugnrWU3Whp9NNMhI2iR2Dp
         bg5v/pzqt67ipobudQvo4MJzhjtSsupCbmYwdwTkVomVej/SkW5o43rJek7MVsQkh+PX
         12OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684303828; x=1686895828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mpie8/glAH3yyNKq+/RQAK3YUsaaOKOt8+ItYsJdR5g=;
        b=LhVRyObyuPSAKLP6h9bGpqqkWxWki32Q2IAafWOLQtoqYgaU946WlziIUrEhmevge5
         8upS9f9O3Ar9tGKyXeRDnigoocD0O1r4JI5v9DmFWetV5njWPm7oZ5RJ00Nq5LmBzEZy
         osZnxLRgfs5Qisr1xltUKRuYa7jAHCWmHSNT0pnWALZ+psjWBMBTttF73Ja8CLsc+N5u
         Z2DzV/ys+dFVjRSkXL0IyQ+RMSyaD2kRSMPa8A+EIsh3b2k8MnTfyXai1BQ++tAd4DGU
         0Ojuda700FaMsC291HZvEnJuWUeO77ES7DJ4x3wazKLZu+dJux/+k0VQg/8O4Eo6rt3p
         44wA==
X-Gm-Message-State: AC+VfDwEx68gI+9roo7B/K0HTtqLhwf3kTwx3FC7zHxKKIozvdvRXy8u
        zEnEQK50VtJZVdZQBYVT+vJGXRcaByuOk3HiLh0uRPhcHyIVWv+f/mH4ycawdmTRZUogSUzKXVU
        wpOQdTtbNECMKEjmPjR2LjsUsUUaCamF7HKfx3fwYlcF9QqXAlS2s668CZB0vhCXRJ0/tjJg=
X-Google-Smtp-Source: ACHHUZ7ymLKbNwkdZJhNer36L79U61TvNmDNh9nttcLICQtSsSGRaDBlJHJiUMh7Mj8uc4n1K6lDiYacraGnec4JNA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:fcc:b0:253:48c2:69c5 with SMTP
 id gd12-20020a17090b0fcc00b0025348c269c5mr88475pjb.5.1684303828080; Tue, 16
 May 2023 23:10:28 -0700 (PDT)
Date:   Wed, 17 May 2023 06:10:14 +0000
In-Reply-To: <20230517061015.1915934-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517061015.1915934-6-jingzhangos@google.com>
Subject: [PATCH v9 5/5] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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

Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
specific to ID register.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/cpufeature.h |   1 +
 arch/arm64/kernel/cpufeature.c      |   2 +-
 arch/arm64/kvm/sys_regs.c           | 362 ++++++++++++++++++----------
 3 files changed, 243 insertions(+), 122 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 6bf013fb110d..dc769c2eb7a4 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -915,6 +915,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
 	return 8;
 }
 
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64 cur);
 struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
 
 extern struct arm64_ftr_override id_aa64mmfr1_override;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7d7128c65161..3317a7b6deac 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -798,7 +798,7 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
 	return reg;
 }
 
-static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 				s64 cur)
 {
 	s64 ret = 0;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b5dada9aad7..bec02ba45ee7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -41,6 +41,7 @@
  * 64bit interface.
  */
 
+static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd, u64 val);
 static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
@@ -1194,6 +1195,86 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
+				    s64 new, s64 cur)
+{
+	struct arm64_ftr_bits kvm_ftr = *ftrp;
+
+	/* Some features have different safe value type in KVM than host features */
+	switch (id) {
+	case SYS_ID_AA64DFR0_EL1:
+		if (kvm_ftr.shift == ID_AA64DFR0_EL1_PMUVer_SHIFT)
+			kvm_ftr.type = FTR_LOWER_SAFE;
+		break;
+	case SYS_ID_DFR0_EL1:
+		if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
+			kvm_ftr.type = FTR_LOWER_SAFE;
+		break;
+	}
+
+	return arm64_ftr_safe_value(&kvm_ftr, new, cur);
+}
+
+/**
+ * arm64_check_features() - Check if a feature register value constitutes
+ * a subset of features indicated by the idreg's KVM sanitised limit.
+ *
+ * This function will check if each feature field of @val is the "safe" value
+ * against idreg's KVM sanitised limit return from reset() callback.
+ * If a field value in @val is the same as the one in limit, it is always
+ * considered the safe value regardless For register fields that are not in
+ * writable, only the value in limit is considered the safe value.
+ *
+ * Return: 0 if all the fields are safe. Otherwise, return negative errno.
+ */
+static int arm64_check_features(struct kvm_vcpu *vcpu,
+				const struct sys_reg_desc *rd,
+				u64 val)
+{
+	const struct arm64_ftr_reg *ftr_reg;
+	const struct arm64_ftr_bits *ftrp = NULL;
+	u32 id = reg_to_encoding(rd);
+	u64 writable_mask = rd->val;
+	u64 limit = 0;
+	u64 mask = 0;
+
+	/* For hidden and unallocated idregs without reset, only val = 0 is allowed. */
+	if (rd->reset) {
+		limit = rd->reset(vcpu, rd);
+		ftr_reg = get_arm64_ftr_reg(id);
+		if (!ftr_reg)
+			return -EINVAL;
+		ftrp = ftr_reg->ftr_bits;
+	}
+
+	for (; ftrp && ftrp->width; ftrp++) {
+		s64 f_val, f_lim, safe_val;
+		u64 ftr_mask;
+
+		ftr_mask = arm64_ftr_mask(ftrp);
+		if ((ftr_mask & writable_mask) != ftr_mask)
+			continue;
+
+		f_val = arm64_ftr_value(ftrp, val);
+		f_lim = arm64_ftr_value(ftrp, limit);
+		mask |= ftr_mask;
+
+		if (f_val == f_lim)
+			safe_val = f_val;
+		else
+			safe_val = kvm_arm64_ftr_safe_value(id, ftrp, f_val, f_lim);
+
+		if (safe_val != f_val)
+			return -E2BIG;
+	}
+
+	/* For fields that are not writable, values in limit are the safe values. */
+	if ((val & ~mask) != (limit & ~mask))
+		return -E2BIG;
+
+	return 0;
+}
+
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
@@ -1244,7 +1325,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -1271,15 +1351,10 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		break;
 	case SYS_ID_AA64DFR0_EL1:
-		/* Limit debug to ARMv8.0 */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
 		/* Set PMUver to the required version */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
 				  vcpu_pmuver(vcpu));
-		/* Hide SPE from guests */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
 		break;
 	case SYS_ID_DFR0_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
@@ -1378,14 +1453,40 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+	/*
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
+	 */
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
+	}
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
+	}
+
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
+
+	return val;
+}
+
 static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	struct kvm_arch *arch = &vcpu->kvm->arch;
-	u64 sval = val;
 	u8 csv2, csv3;
-	int ret = 0;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -1403,26 +1504,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
-	mutex_lock(&arch->config_lock);
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val) {
-		ret = -EINVAL;
-		goto out;
-	}
+	return set_id_reg(vcpu, rd, val);
+}
 
-	/* Only allow userspace to change the idregs before VM running */
-	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
-		if (sval != read_id_reg(vcpu, rd))
-			ret = -EBUSY;
-	} else {
-		IDREG(vcpu->kvm, reg_to_encoding(rd)) = sval;
-	}
-out:
-	mutex_unlock(&arch->config_lock);
-	return ret;
+static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+	/* Limit debug to ARMv8.0 */
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			  kvm_arm_pmu_get_pmuver_limit());
+	/* Hide SPE from guests */
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
+
+	return val;
 }
 
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
@@ -1432,7 +1537,6 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
-	u64 sval = val;
 	int ret = 0;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
@@ -1454,40 +1558,61 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	mutex_lock(&arch->config_lock);
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Only allow userspace to change the idregs before VM running */
 	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
-		if (sval != read_id_reg(vcpu, rd))
+		if (val != read_id_reg(vcpu, rd))
 			ret = -EBUSY;
-	} else {
-		if (valid_pmu) {
-			val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
-			val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
-			val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
-			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
-
-			val = IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
-			val &= ~ID_DFR0_EL1_PerfMon_MASK;
-			val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
-			IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
-		} else {
-			assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
-				   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
-		}
+		goto out;
 	}
 
+	if (!valid_pmu) {
+		/*
+		 * Ignore the PMUVer filed in @val. The PMUVer would be determined
+		 * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
+		 */
+		pmuver = FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK,
+				   IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
+	}
+
+	ret = arm64_check_features(vcpu, rd, val);
+	if (ret)
+		goto out;
+
+	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
+
+	val = IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
+	val &= ~ID_DFR0_EL1_PerfMon_MASK;
+	val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
+	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
+
+	if (!valid_pmu)
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+
 out:
 	mutex_unlock(&arch->config_lock);
 	return ret;
 }
 
+static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), kvm_arm_pmu_get_pmuver_limit());
+
+	return val;
+}
+
 static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *rd,
 			   u64 val)
@@ -1495,7 +1620,6 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 perfmon, host_perfmon;
 	bool valid_pmu;
-	u64 sval = val;
 	int ret = 0;
 
 	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
@@ -1518,35 +1642,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	mutex_lock(&arch->config_lock);
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Only allow userspace to change the idregs before VM running */
 	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
-		if (sval != read_id_reg(vcpu, rd))
+		if (val != read_id_reg(vcpu, rd))
 			ret = -EBUSY;
-	} else {
-		if (valid_pmu) {
-			val = IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
-			val &= ~ID_DFR0_EL1_PerfMon_MASK;
-			val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
-			IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
-
-			val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
-			val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
-			val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
-			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
-		} else {
-			assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
-				   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
-		}
+		goto out;
 	}
 
+	if (!valid_pmu) {
+		/*
+		 * Ignore the PerfMon filed in @val. The PerfMon would be determined
+		 * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
+		 */
+		perfmon = FIELD_GET(ID_DFR0_EL1_PerfMon_MASK,
+				    IDREG(vcpu->kvm, SYS_ID_DFR0_EL1));
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
+	}
+
+	ret = arm64_check_features(vcpu, rd, val);
+	if (ret)
+		goto out;
+
+	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
+
+	val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+	val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+	val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
+	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
+
+	if (!valid_pmu)
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
+
 out:
 	mutex_unlock(&arch->config_lock);
 	return ret;
@@ -1574,11 +1702,23 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd))
-		return -EINVAL;
+	struct kvm_arch *arch = &vcpu->kvm->arch;
+	u32 id = reg_to_encoding(rd);
+	int ret = 0;
 
-	return 0;
+	mutex_lock(&arch->config_lock);
+	/* Only allow userspace to change the idregs before VM running */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
+		if (val != read_id_reg(vcpu, rd))
+			ret = -EBUSY;
+	} else {
+		ret = arm64_check_features(vcpu, rd, val);
+		if (!ret)
+			IDREG(vcpu->kvm, id) = val;
+	}
+	mutex_unlock(&arch->config_lock);
+
+	return ret;
 }
 
 static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -1929,9 +2069,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility, },
+	{ SYS_DESC(SYS_ID_DFR0_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_dfr0_el1,
+	  .visibility = aa32_id_visibility,
+	  .reset = read_sanitised_id_dfr0_el1,
+	  .val = ID_DFR0_EL1_PerfMon_MASK, },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -1960,8 +2104,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_aa64pfr0_el1,
+	  .reset = read_sanitised_id_aa64pfr0_el1,
+	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
@@ -1971,8 +2119,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_aa64dfr0_el1,
+	  .reset = read_sanitised_id_aa64dfr0_el1,
+	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
@@ -3494,38 +3646,6 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		idreg++;
 		id = reg_to_encoding(idreg);
 	}
-
-	/*
-	 * The default is to expose CSV2 == 1 if the HW isn't affected.
-	 * Although this is a per-CPU feature, we make it global because
-	 * asymmetric systems are just a nuisance.
-	 *
-	 * Userspace can override this as long as it doesn't promise
-	 * the impossible.
-	 */
-	val = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
-
-	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
-	}
-	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
-	}
-
-	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	val = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
-
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
-			  kvm_arm_pmu_get_pmuver_limit());
-
-	IDREG(kvm, SYS_ID_AA64DFR0_EL1) = val;
 }
 
 int __init kvm_sys_reg_table_init(void)
-- 
2.40.1.606.ga4b1b128d6-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822B36F5CDC
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjECRQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjECRQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:16:36 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA0F469E
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 10:16:34 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-559deafac49so95688217b3.1
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 10:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683134193; x=1685726193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LD8eS5xyhGqsj8lKD+Knwax1wsv6Nka1HQ5YxbZTTpk=;
        b=hUdcrb34PKM/6OzYy8cAIjtKuZ1hUFcsqDUgpup+6Egrx0POlTH883hG4OnE/xO6IQ
         ewY52J78aTG5B+mECkyYV08WUDXMVOLEyweTOU8Pg51OJoVXyK8GGURKtRDrKYFP9dx+
         4RjuoDHE43XVL6tbmhbMgmckZzFLb3aeuVt6PfiH1yK5gUkMS9lpujuoHJMsLyrU0Vhp
         XUMXNEngAoKcLsMN1dGg4KkM7M0bTihx6iBR/m8OiqfrUTeNG0EmuUk+StdcZgFk9ZOd
         KWgP3jwtrJSfS1cKvWluUbKVLVYlY5y4fx09hvoEgvKS4jtK846sXPVrJc5Q26Wh/jLi
         FrIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683134193; x=1685726193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LD8eS5xyhGqsj8lKD+Knwax1wsv6Nka1HQ5YxbZTTpk=;
        b=Ps5sbmcKCdI70IPo461YhWEWIRDmdBRXpqn47Vs0kG7gYMdrFtnhLKQXTGz55bli8O
         WC0H1Dqjo96e3vpd4dkytyfWYOHqibquxcANISFWhY92izmqGhKGL1K2g2fip7M6qz4M
         Pn0cYMrSfjke/MJDCILLHSys6dodPcv9WERyzd3NnF6qET746LYpII2liSjJ8fS2vr1P
         tIHCCRM7gqMfgqbiayt3xEm6yDpNcGyCxbbJeD5FGlR/oc6Lz/ZDV/pwJDKzj5sXWaOP
         Bg88Ep5UBo+gil2EUljX2uOjww0zTD9C5r1V3J1T54ldHEhFbKg+xYCdMvfX7SovOAix
         DeaQ==
X-Gm-Message-State: AC+VfDxc/7JhXG+10xp/YE3q9WuTH+r8C10yR8aSqW6UB0A0ghm1m1HT
        fpN985PTnNzjMjklp6y8h0FbhXnDyMVK9O9CGTAr9yM6WLIewuW5g/suF4HG42FiEl26uvBXi5w
        jDpN6rnu1VVX3C9GEajqsf6aluFKuTsUV81Ua/qSuuGarZlz4l1CThCOP7L/3GNCIG8cDxsI=
X-Google-Smtp-Source: ACHHUZ5Bke/R8eFg5fwu85amumBg8ZjKsNFYqixYgKNn/2aMA0ejT4WAswtiClIGPEOApKyZF11aOvJbpyH8ZNg+0Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:b723:0:b0:55a:5641:54be with SMTP
 id v35-20020a81b723000000b0055a564154bemr6097125ywh.6.1683134193225; Wed, 03
 May 2023 10:16:33 -0700 (PDT)
Date:   Wed,  3 May 2023 17:16:18 +0000
In-Reply-To: <20230503171618.2020461-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503171618.2020461-7-jingzhangos@google.com>
Subject: [PATCH v8 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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
introduced by ID register descriptor array.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/cpufeature.h |   1 +
 arch/arm64/kernel/cpufeature.c      |   2 +-
 arch/arm64/kvm/id_regs.c            | 361 ++++++++++++++++++----------
 3 files changed, 242 insertions(+), 122 deletions(-)

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
index 2e3e55139777..677ec4fe9f6b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -791,7 +791,7 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
 	return reg;
 }
 
-static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 				s64 cur)
 {
 	s64 ret = 0;
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 64d40aa395be..6cd56c9e6428 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -18,6 +18,86 @@
 
 #include "sys_regs.h"
 
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
@@ -68,7 +148,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -95,15 +174,10 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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
@@ -167,11 +241,23 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
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
 
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
@@ -203,14 +289,40 @@ static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
 	return id_visibility(vcpu, r);
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
@@ -226,26 +338,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
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
@@ -255,7 +371,6 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
-	u64 sval = val;
 	int ret = 0;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
@@ -277,40 +392,61 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
+	}
+
+	if (!valid_pmu) {
+		/*
+		 * Ignore the PMUVer filed in @val. The PMUVer would be determined
+		 * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
+		 */
+		pmuver = FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK,
+				   IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
 	}
 
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
@@ -318,7 +454,6 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 perfmon, host_perfmon;
 	bool valid_pmu;
-	u64 sval = val;
 	int ret = 0;
 
 	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
@@ -341,35 +476,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
+	}
+
+	if (!valid_pmu) {
+		/*
+		 * Ignore the PerfMon filed in @val. The PerfMon would be determined
+		 * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
+		 */
+		perfmon = FIELD_GET(ID_DFR0_EL1_PerfMon_MASK,
+				    IDREG(vcpu->kvm, SYS_ID_DFR0_EL1));
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
 	}
 
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
@@ -448,9 +587,13 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
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
@@ -479,8 +622,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 
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
 	ID_UNALLOCATED(4, 2),
 	ID_UNALLOCATED(4, 3),
@@ -490,8 +637,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	ID_UNALLOCATED(4, 7),
 
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
 	ID_UNALLOCATED(5, 2),
 	ID_UNALLOCATED(5, 3),
@@ -563,36 +714,4 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 
 		IDREG(kvm, id) = val;
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
-- 
2.40.1.495.gc816e09b53d-goog


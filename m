Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A916ED8F4
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 01:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjDXXrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 19:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjDXXrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 19:47:21 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46C749EB
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:47:18 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63b79d8043eso26481186b3a.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380038; x=1684972038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DoqosKAO7vt4Apem+vp5K/PHJy1C6t89LuJhpJ40gSo=;
        b=k7BFC4Ofsui1Z1V6e0npf2dObjfkFcBvujLgC6x4wJE/FBqIl91KU5VXsoNyx9Q3fQ
         yX0904ukJtjZYMaydvPuuMvChNNj8+NZiJC3gZ8rdzsxkghlOXiwVMR3e/XepenJe7cl
         hW2XNx2cxLuG3uqquqQU09yzBusE13ASyk7UjzlUE3f3Qdt1dOXvM+ybZAKFKFMhVqyi
         +8DF1qP+70b3KjQTTZIltC59XI2bXPT30MOHgH7XtMSAOehfqttaZ+vc4hFj3LEXe0jF
         MIVFtzem//GfmbiLkvKiVUsQZr6C5vtOCRugGZ0EoR6E9Uyi8xmTRFEgHUsipJnBJBfW
         Touw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380038; x=1684972038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DoqosKAO7vt4Apem+vp5K/PHJy1C6t89LuJhpJ40gSo=;
        b=OcQSTv/xfxjIra2xCss2Wj+/77SZCW6Izg3WH0/71d9VGqXz5MwQOYJEh+ZwPUE7lN
         DqdlshvIPHAIZ4MyZaAqJC/lZWULzgZ6rJvik5ipE1UsejbUumQyrniS/4PhJ1+ilgiI
         jai9d7la6z4+364h/15IoWPOxBblXm8lWtixRnnzYNmXaXXgAMZkMITIptwk585jJz8D
         ahh75S/Fzx12F6amNWjSf+dWQ8PVSY91RQpcEl18fny0JQ4+eStBwB4ADmDQad4NJDrU
         JQXuDhNK8LFzIrHyVYP/+tMQ/lS37zFlhh9EaQl5ceHk8OlrARybRs1y6F/lOHs1+gPA
         Px9A==
X-Gm-Message-State: AAQBX9f30o4BRNT5VK9/bn8/uG4N9Ba5h9cC6l25CundAuA/tsVw6fy5
        cCA20d7Ftr0dcKpFIQa0hMI0b1mnPF6QZfdq7yHfQwqIlYwKmZ1MLz8lcxXRUc+0tX8qiU9RQr3
        7AfVoh4GJTKKbIy4rR4eMkpa5BPNnwOUjERAbkG2AepdyMQIEvoN9mR0cP3YAiHXyTqcJ0j8=
X-Google-Smtp-Source: AKy350ZnrzLZiWDgWDZCp/OgJAeoodsWUfYlbkGKuZe6DEoVJ0BWgxmBR+wd9ablrqQUZHQpeXb1Px7rOUgE85ZdFA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:19c6:b0:24b:6d01:584a with
 SMTP id nm6-20020a17090b19c600b0024b6d01584amr3029079pjb.0.1682380038249;
 Mon, 24 Apr 2023 16:47:18 -0700 (PDT)
Date:   Mon, 24 Apr 2023 23:47:04 +0000
In-Reply-To: <20230424234704.2571444-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230424234704.2571444-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424234704.2571444-7-jingzhangos@google.com>
Subject: [PATCH v7 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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
 arch/arm64/kvm/id_regs.c            | 318 +++++++++++++++++++---------
 3 files changed, 223 insertions(+), 98 deletions(-)

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
index a5fabbb04ceb..de66bfb026f7 100644
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
@@ -162,9 +236,14 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd))
-		return -EINVAL;
+	u32 id = reg_to_encoding(rd);
+	int ret;
+
+	ret = arm64_check_features(vcpu, rd, val);
+	if (ret)
+		return ret;
+
+	idreg_write(&vcpu->kvm->arch, id, val);
 
 	return 0;
 }
@@ -198,12 +277,40 @@ static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
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
 	u8 csv2, csv3;
-	u64 sval = val;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -219,16 +326,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val)
-		return -EINVAL;
+	return set_id_reg(vcpu, rd, val);
+}
 
-	idreg_write(&vcpu->kvm->arch, reg_to_encoding(rd), sval);
+static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
 
-	return 0;
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
@@ -237,6 +358,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	int ret;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
@@ -256,40 +378,62 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
-
-	if (valid_pmu) {
-		mutex_lock(&vcpu->kvm->arch.config_lock);
-
-		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1);
+	if (!valid_pmu) {
+		/*
+		 * Ignore the PMUVer filed in @val. The PMUVer would be determined
+		 * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
+		 */
+		pmuver = FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK, read_id_reg(vcpu, rd));
 		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
 		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
-		_idreg_write(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+	}
 
-		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_DFR0_EL1);
-		val &= ~ID_DFR0_EL1_PerfMon_MASK;
-		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
-		_idreg_write(&vcpu->kvm->arch, SYS_ID_DFR0_EL1, val);
+	ret = arm64_check_features(vcpu, rd, val);
+	if (ret)
+		return ret;
 
-		mutex_unlock(&vcpu->kvm->arch.config_lock);
-	} else {
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+
+	_idreg_write(&vcpu->kvm->arch,  SYS_ID_AA64DFR0_EL1, val);
+
+	val = _idreg_read(&vcpu->kvm->arch, SYS_ID_DFR0_EL1);
+	val &= ~ID_DFR0_EL1_PerfMon_MASK;
+	val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
+	_idreg_write(&vcpu->kvm->arch, SYS_ID_DFR0_EL1, val);
+
+	if (!valid_pmu)
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
-	}
+
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return 0;
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
 {
 	u8 perfmon, host_perfmon;
 	bool valid_pmu;
+	int ret;
 
 	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
 
@@ -310,30 +454,34 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
-
-	if (valid_pmu) {
-		mutex_lock(&vcpu->kvm->arch.config_lock);
-
-		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_DFR0_EL1);
+	if (!valid_pmu) {
+		/*
+		 * Ignore the PerfMon filed in @val. The PerfMon would be determined
+		 * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
+		 */
+		perfmon = FIELD_GET(ID_DFR0_EL1_PerfMon_MASK, read_id_reg(vcpu, rd));
 		val &= ~ID_DFR0_EL1_PerfMon_MASK;
 		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
-		_idreg_write(&vcpu->kvm->arch, SYS_ID_DFR0_EL1, val);
+	}
 
-		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1);
-		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
-		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
-		_idreg_write(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+	ret = arm64_check_features(vcpu, rd, val);
+	if (ret)
+		return ret;
 
-		mutex_unlock(&vcpu->kvm->arch.config_lock);
-	} else {
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+
+	_idreg_write(&vcpu->kvm->arch, SYS_ID_DFR0_EL1, val);
+
+	val = _idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1);
+	val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+	val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
+	_idreg_write(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+
+	if (!valid_pmu)
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
-	}
+
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return 0;
 }
@@ -411,9 +559,13 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
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
@@ -442,8 +594,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 
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
@@ -453,8 +609,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
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
@@ -529,40 +689,4 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 
 		idreg_write(&kvm->arch, id, val);
 	}
-
-	mutex_lock(&kvm->arch.config_lock);
-	/*
-	 * The default is to expose CSV2 == 1 if the HW isn't affected.
-	 * Although this is a per-CPU feature, we make it global because
-	 * asymmetric systems are just a nuisance.
-	 *
-	 * Userspace can override this as long as it doesn't promise
-	 * the impossible.
-	 */
-	val = _idreg_read(&kvm->arch, SYS_ID_AA64PFR0_EL1);
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
-	_idreg_write(&kvm->arch, SYS_ID_AA64PFR0_EL1, val);
-
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	val = _idreg_read(&kvm->arch, SYS_ID_AA64DFR0_EL1);
-
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
-			  kvm_arm_pmu_get_pmuver_limit());
-
-	_idreg_write(&kvm->arch, SYS_ID_AA64DFR0_EL1, val);
-
-	mutex_unlock(&kvm->arch.config_lock);
 }
-- 
2.40.0.634.g4ca3ef3211-goog


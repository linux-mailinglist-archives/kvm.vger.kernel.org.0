Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7C870CDB0
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbjEVWSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbjEVWSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:18:50 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E59BF
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:18:48 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d67a12befso1071604b3a.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684793927; x=1687385927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/poaNaOrMaOWpcJS0msAO1JJZSaOkyXyWcZbcKh1EsI=;
        b=B3YZJ4NC4MAf2yJU9FiifvmmDnD46172Ok0W+slcZmUjoeVVWM4B4l0wDQCP7AEArY
         fBXr5EPWNCM9bhJMwOm3ZAVPk+T9ejH7gnJLrDo0t4pWZxxLvUNZe9AiYn9HADj9zLcz
         FnstCejW/NjN7q5VnuKnkYpg0axYWa9K+xvEGTY4MekKpxgVkCPQpwE2C/m9IjRSeANP
         BCOpb7jmjSHfdJD5axvSQ8VBw3rzkDawPO4+uyHmcryfA1+brXJ8U7vbzzZtcvedcTtL
         zMZzr+5Gd3HUiKwpQLhjJGlYtf9xIQK6xHsZ61RnK8/+FsQGDNCP5RmM3JkCzWbMGd0p
         pd7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684793927; x=1687385927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/poaNaOrMaOWpcJS0msAO1JJZSaOkyXyWcZbcKh1EsI=;
        b=Zs2sAR6STKjnxo7yjpuYRFxbKcoh64XzToLLV2f0Psna7xizwOnQHyy6VcpPyAJWfN
         CUi+gphtl+u58cLgt8ZGqoyqdDtVWva2zv59+/ynJz0CoGFzK+cUmml9CRkt7vHLc9LR
         ahYORdql2hGKsEtX8f5wk2OoMzt4R7lYOHjHOEqCuh7baukUMTJiK0wLVrh5i7uDT1yR
         P06WdyzsjciEUUnXpp2YxcSA7Hv05Ewb+pK/cJUc6rrtB6ZzEI8upF3hfcX2DYVkXlkP
         /LV+gg3kWdaYuautPwh0fHDnHylCxnHbG3IMP0AlofdRJqiMqMvUyRBtnh0FS8a2EtMW
         jeYA==
X-Gm-Message-State: AC+VfDz4ELy8Wupwuj8s2SF9eCREJfe63DAGHqMV81JX++U4ULhrFDn2
        XVzg+FO/KaJ0T/Ndn3tix44S8LbpeJlhK7OTkTEOJUgqCeDizdzUn2N8A9bg+hQ1/NsCROYXxzE
        C2+gO1VmSi+bslvV6N7ppmArSTXg+uuY8gXGZ7FAtQo/qJj63ULpfSPSrv1kEt5gOTFfQ7eo=
X-Google-Smtp-Source: ACHHUZ6lLYGjKcKwr0DRMshIbU7PYm3NY4FPnp4zYe6fglsoCGFczLxaZp0dBDk9LbgQJkAGBAisdXT5OQrLyui/uA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:98e:b0:643:a3a6:115f with
 SMTP id u14-20020a056a00098e00b00643a3a6115fmr5215347pfg.3.1684793927604;
 Mon, 22 May 2023 15:18:47 -0700 (PDT)
Date:   Mon, 22 May 2023 22:18:35 +0000
In-Reply-To: <20230522221835.957419-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230522221835.957419-6-jingzhangos@google.com>
Subject: [PATCH v10 5/5] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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
 arch/arm64/kvm/sys_regs.c           | 365 ++++++++++++++++++----------
 3 files changed, 243 insertions(+), 125 deletions(-)

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
index 72255dea8027..b3eacfc592eb 100644
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
@@ -1378,15 +1453,40 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
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
-	u64 old_val = read_id_reg(vcpu, rd);
-	u64 new_val = val;
 	u8 csv2, csv3;
-	int ret = 0;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -1404,26 +1504,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
-	mutex_lock(&arch->config_lock);
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= old_val;
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val) {
-		ret = -EINVAL;
-		goto out;
-	}
+	return set_id_reg(vcpu, rd, val);
+}
 
-	/* Only allow userspace to change the idregs before VM running */
-	if (kvm_vm_has_ran_once(vcpu->kvm)) {
-		if (new_val != old_val)
-			ret = -EBUSY;
-	} else {
-		IDREG(vcpu->kvm, reg_to_encoding(rd)) = new_val;
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
@@ -1431,9 +1535,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       u64 val)
 {
 	struct kvm_arch *arch = &vcpu->kvm->arch;
-	u64 old_val = read_id_reg(vcpu, rd);
 	u8 pmuver, host_pmuver;
-	u64 new_val = val;
 	bool valid_pmu;
 	int ret = 0;
 
@@ -1456,48 +1558,67 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	mutex_lock(&arch->config_lock);
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= old_val;
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Only allow userspace to change the idregs before VM running */
 	if (kvm_vm_has_ran_once(vcpu->kvm)) {
-		if (new_val != old_val)
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
+		 * Ignore the PMUVer field in @val. The PMUVer would be determined
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
 {
 	struct kvm_arch *arch = &vcpu->kvm->arch;
-	u64 old_val = read_id_reg(vcpu, rd);
 	u8 perfmon, host_perfmon;
-	u64 new_val = val;
 	bool valid_pmu;
 	int ret = 0;
 
@@ -1521,35 +1642,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	mutex_lock(&arch->config_lock);
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= old_val;
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Only allow userspace to change the idregs before VM running */
 	if (kvm_vm_has_ran_once(vcpu->kvm)) {
-		if (new_val != old_val)
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
+		 * Ignore the PerfMon field in @val. The PerfMon would be determined
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
@@ -1577,11 +1702,23 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
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
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
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
@@ -1932,9 +2069,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -1963,8 +2104,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
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
@@ -1974,8 +2119,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -3497,38 +3646,6 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
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
2.40.1.698.g37aff9b760-goog


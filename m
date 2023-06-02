Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0CE71F762
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjFBAve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjFBAvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:51:33 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F94195
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 17:51:31 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64d138bd759so777406b3a.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 17:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667090; x=1688259090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qytCj1yDieZphoiGJtfZ7vshJfgLOvMVIy+kGR/q7+c=;
        b=VfpWAoJirMFcwtqL1ZrZr5frBsCaTdg+FnXcDrbmh2yR4of7HuLpLZW9hvZkv209wI
         5EpzcjU57tAEjU6bcRX/yLAP1EYAyFVFhOrxbYcNFDq/2hp+Idz5Elkt/RxzE1Q3po7C
         mQ7FokP5QKafmHexOr0cencSlJgGJe1VFyKZ8KKk6VIKkysdu52R5ZxZoLqlfwfsO5ND
         RyRp6StQHLv884YGnDuQX1bo4bWjrCy4UuekW1mUjBrE2FzgGxvcmh4mwcIBrTvy7rJx
         dj1YpkU4sKK4zmigC4+3vWDpydT6htZ3NQGS7cj5UAZh1jZcLDWqYN4rO9CYqZOwkWcP
         IxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667090; x=1688259090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qytCj1yDieZphoiGJtfZ7vshJfgLOvMVIy+kGR/q7+c=;
        b=V5ICHulbvsfvg4LQ6xHwSYboaZZe5AoetXqjoJaV8DX7mTsxbYrTx9xbrVlwW+SESn
         x3F+EP1gITrnrcCl7gvD2wlk8LZrXswRI4EueQnU1nel7Te+c3nCW7cT65NGZW038FgM
         JFaOUpStvPI0v7lSFoqBUPoSojEh0EJzcttQC5jPpHgSvptKFSY771zRsDUIIk9DRBv4
         J5RQ7UbtHCtUwcVoKH7f1S2dwO1st01ejeCviQgMskhrbcSd18unlOI2X5lQolzpGnLM
         6JVzvqaBrB8nxexX27xprBGRZut5RmiYOLwwf/X3Yj7YCLssxdkpZmyNYlEZ7BiIMFIz
         PrTQ==
X-Gm-Message-State: AC+VfDzIhRKsv/rCjrupLtGP6TgkzNq8usOsamznspvSSiW9knSGzwBD
        aGeDHebI9A+7W1mR1yuJXztpDjDVw4csGsYrII9v/4MM4uPmI58l7lZNF9CAzstdugHB017aWFx
        Jxj7LXW5DtX+tDu20mDbBYefbEHjVdPRD891dub0PCxDOYYUj2w8r5IJBGFwWuxWthIn3a0k=
X-Google-Smtp-Source: ACHHUZ4tlxqmk+ETGs9kCH5k8TrnotXROYu6lP+ZMcHetBnnzW7ytUneMJY+D0N8wc2c57Fuc7ypsfrCCYcGDAGJRQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:1ad4:b0:650:1a63:cd4a with
 SMTP id f20-20020a056a001ad400b006501a63cd4amr1944113pfv.0.1685667090512;
 Thu, 01 Jun 2023 17:51:30 -0700 (PDT)
Date:   Fri,  2 Jun 2023 00:51:17 +0000
In-Reply-To: <20230602005118.2899664-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230602005118.2899664-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602005118.2899664-6-jingzhangos@google.com>
Subject: [PATCH v11 5/5] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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
 arch/arm64/kvm/sys_regs.c           | 291 +++++++++++++++++++---------
 3 files changed, 203 insertions(+), 91 deletions(-)

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
index 1a534e0fc4ca..50d4e25f42d3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -41,6 +41,7 @@
  * 64bit interface.
  */
 
+static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd, u64 val);
 static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding);
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
@@ -1231,9 +1312,17 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
-static void pmuver_update(struct kvm_vcpu *vcpu, u8 pmuver, bool valid_pmu)
+static int pmuver_update(struct kvm_vcpu *vcpu,
+			  const struct sys_reg_desc *rd,
+			  u64 val,
+			  u8 pmuver,
+			  bool valid_pmu)
 {
-	u64 val;
+	int ret;
+
+	ret = set_id_reg(vcpu, rd, val);
+	if (ret)
+		return ret;
 
 	if (valid_pmu) {
 		val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
@@ -1249,6 +1338,8 @@ static void pmuver_update(struct kvm_vcpu *vcpu, u8 pmuver, bool valid_pmu)
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
 	}
+
+	return 0;
 }
 
 static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
@@ -1264,7 +1355,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -1291,15 +1381,10 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
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
@@ -1398,38 +1483,56 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
-			       const struct sys_reg_desc *rd,
-			       u64 val)
+static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
 {
-	u64 new_val = val;
-	u8 csv2, csv3;
+	u64 val;
+	u32 id = reg_to_encoding(rd);
 
+	val = read_sanitised_ftr_reg(id);
 	/*
-	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
-	 * it doesn't promise more than what is actually provided (the
-	 * guest could otherwise be covered in ectoplasmic residue).
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
 	 */
-	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
+	}
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
+	}
 
-	/* Same thing for CSV3 */
-	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val)
-		return -EINVAL;
+	return val;
+}
 
-	IDREG(vcpu->kvm, reg_to_encoding(rd)) = new_val;
-	return 0;
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
@@ -1457,14 +1560,35 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
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
 
-	pmuver_update(vcpu, pmuver, valid_pmu);
-	return 0;
+	return pmuver_update(vcpu, rd, val, pmuver, valid_pmu);
+}
+
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
 }
 
 static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
@@ -1493,14 +1617,18 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
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
 
-	pmuver_update(vcpu, perfmon_to_pmuver(perfmon), valid_pmu);
-	return 0;
+	return pmuver_update(vcpu, rd, val, perfmon_to_pmuver(perfmon), valid_pmu);
 }
 
 /*
@@ -1520,11 +1648,14 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd))
-		return -EINVAL;
+	u32 id = reg_to_encoding(rd);
+	int ret = 0;
 
-	return 0;
+	ret = arm64_check_features(vcpu, rd, val);
+	if (!ret)
+		IDREG(vcpu->kvm, id) = val;
+
+	return ret;
 }
 
 static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -1875,9 +2006,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -1906,8 +2041,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
+	  .access = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_reg,
+	  .reset = read_sanitised_id_aa64pfr0_el1,
+	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
@@ -1917,8 +2056,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -3454,38 +3597,6 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
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
2.41.0.rc0.172.g3f132b7071-goog


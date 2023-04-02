Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0FF6D39DC
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 20:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjDBSiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 14:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjDBSiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 14:38:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A70E077
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 11:38:01 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l14-20020a170902f68e00b001a1a9a1d326so16163643plg.9
        for <kvm@vger.kernel.org>; Sun, 02 Apr 2023 11:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680460681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tkHV26ZKa37Z+YGJb0NT+bZ5b4d4C9f2N15vUl43rfs=;
        b=U2xi8W86uDVgDTnFOyETl2Eu41ck9YV+zUkkO2MihMtr0IwGo4/uv/NDnX9qFYsXvA
         PJgl1Os2p8W/NS7rrbwewwO0a9cN2HTfq1fUha7K4Ow7nGif4Wmrduk0KoTbtJ+avhtT
         MODf/vWeyNasOC7gbEZppAf/CF4EugggpiU8WvyAd+qZaTKEskY0Yy67K80Tv8dTloOd
         XW/fi6DXuuGLFXvCmBZeKP8aSbL7a8C2zfNqTebPdHKNy3+mAIZIt7mZA8hRUlvDifa9
         UIOc581cMVYuzSAwko5YPjZM+266zX16lzsOXqEww/hUtrlLABLSyn7b9TRWEWr8Fa8t
         Hulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680460681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tkHV26ZKa37Z+YGJb0NT+bZ5b4d4C9f2N15vUl43rfs=;
        b=QwZzi/a6v6Lq7cZ4su6oDm8MqFYH4mkhbvxvr2++/x/51EZN6L9gNlELiYBUy9dgDG
         DYXahFD1mHDb7ThNzSosTNZIB5/DkJi+4iVmhrcnjXA9LjWXyd8v7HuT1uYna7lP/3Wi
         xAgjfqPw6g03G/OMbL/YW951hPhcemRCQMBNZy6oyq4n3QQRamS3DNqqsxgkno3cXnDB
         R3DN0l6wcaEZbEyKYOnPEg755qcv9zku/8zkM0FYxERE0Fnm/01P+PRvCmw1sP0BC+JU
         ZqB5Hs8w1kgbQGPRIyIMUGm6ljU2JJ+2DOwe3KZJZDcgpWGwIH4z9YkTVyZXwxfaNqZh
         fJrA==
X-Gm-Message-State: AAQBX9cIWXd1t+lBiD0HEcOJMYq9+bWnXc2XiMYQNlqXTIqvYq+DeEXH
        Q/7MFLtUlQSExnWxRE7DzRr3O3Jo+ZmFYeWUGxNWEBmBCjxKM1XHD03NU82nfN2w5tsJ75AGPb1
        7FAWEC7Jc6XnLImKl41W4fvSRa+yI6bAIvxrRbzKUsfjgiIuhG6m7TuMIlDL2IiaONwf0PMQ=
X-Google-Smtp-Source: AKy350YAHCSnVbZ13dFv8vMX/cE7Mmt0Pdbn1pu9lGkqh7T9FYV5ozB3WPnS1+q85/0CvlA6q+3RieDxn6bnKkqRyQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:186:b0:1a1:f70c:c800 with SMTP
 id z6-20020a170903018600b001a1f70cc800mr11862627plg.8.1680460680791; Sun, 02
 Apr 2023 11:38:00 -0700 (PDT)
Date:   Sun,  2 Apr 2023 18:37:35 +0000
In-Reply-To: <20230402183735.3011540-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230402183735.3011540-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230402183735.3011540-7-jingzhangos@google.com>
Subject: [PATCH v5 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
introduced by ID register descriptor.

No functional change intended.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/cpufeature.h |   5 +
 arch/arm64/kernel/cpufeature.c      |   8 +-
 arch/arm64/kvm/id_regs.c            | 262 +++++++++++++++++++---------
 arch/arm64/kvm/sys_regs.c           |   3 +-
 arch/arm64/kvm/sys_regs.h           |   2 +-
 5 files changed, 191 insertions(+), 89 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 6bf013fb110d..f17e74afe3e9 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -915,6 +915,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
 	return 8;
 }
 
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64 cur);
 struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
 
 extern struct arm64_ftr_override id_aa64mmfr1_override;
@@ -925,6 +926,10 @@ extern struct arm64_ftr_override id_aa64smfr0_override;
 extern struct arm64_ftr_override id_aa64isar1_override;
 extern struct arm64_ftr_override id_aa64isar2_override;
 
+extern const struct arm64_ftr_bits ftr_id_dfr0[];
+extern const struct arm64_ftr_bits ftr_id_aa64pfr0[];
+extern const struct arm64_ftr_bits ftr_id_aa64dfr0[];
+
 u32 get_kvm_ipa_limit(void);
 void dump_cpu_features(void);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c331c49a7d19..5b0e3379e5f8 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -225,7 +225,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
 	ARM64_FTR_END,
 };
 
-static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
+const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_DIT_SHIFT, 4, 0),
@@ -426,7 +426,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 	ARM64_FTR_END,
 };
 
-static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -578,7 +578,7 @@ static const struct arm64_ftr_bits ftr_id_pfr2[] = {
 	ARM64_FTR_END,
 };
 
-static const struct arm64_ftr_bits ftr_id_dfr0[] = {
+const struct arm64_ftr_bits ftr_id_dfr0[] = {
 	/* [31:28] TraceFilt */
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_DFR0_EL1_PerfMon_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR0_EL1_MProfDbg_SHIFT, 4, 0),
@@ -791,7 +791,7 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
 	return reg;
 }
 
-static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 				s64 cur)
 {
 	s64 ret = 0;
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index af86001e2686..395eaf84a0ab 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -39,6 +39,64 @@ struct id_reg_desc {
 	u64 (*read_kvm_sanitised_reg)(const struct id_reg_desc *idr);
 };
 
+static struct id_reg_desc id_reg_descs[];
+
+/**
+ * arm64_check_features() - Check if a feature register value constitutes
+ * a subset of features indicated by @limit.
+ *
+ * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated by
+ * an item whose width field is zero.
+ * @writable_mask: Indicates writable feature bits.
+ * @val: The feature register value to check
+ * @limit: The limit value of the feature register
+ *
+ * This function will check if each feature field of @val is the "safe" value
+ * against @limit based on @ftrp[], each of which specifies the target field
+ * (shift, width), whether or not the field is for a signed value (sign),
+ * how the field is determined to be "safe" (type), and the safe value
+ * (safe_val) when type == FTR_EXACT (safe_val won't be used by this
+ * function when type != FTR_EXACT). Any other fields in arm64_ftr_bits
+ * won't be used by this function. If a field value in @val is the same
+ * as the one in @limit, it is always considered the safe value regardless
+ * of the type. For register fields that are not in writable, only the value
+ * in @limit is considered the safe value.
+ *
+ * Return: 0 if all the fields are safe. Otherwise, return negative errno.
+ */
+static int arm64_check_features(const struct arm64_ftr_bits *ftrp,
+				u64 writable_mask, u64 val, u64 limit)
+{
+	u64 mask = 0;
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
+			safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);
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
@@ -84,7 +142,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -111,15 +168,10 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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
@@ -178,9 +230,16 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd))
-		return -EINVAL;
+	int ret;
+	int id = reg_to_encoding(rd);
+	const struct id_reg_desc *idr = &id_reg_descs[IDREG_IDX(id)];
+
+	ret = arm64_check_features(idr->ftr_bits, idr->writable_mask, val,
+			idr->read_kvm_sanitised_reg ? idr->read_kvm_sanitised_reg(idr) : 0);
+	if (ret)
+		return ret;
+
+	IDREG(vcpu->kvm, id) = val;
 
 	return 0;
 }
@@ -219,12 +278,39 @@ static u64 general_read_kvm_sanitised_reg(const struct id_reg_desc *idr)
 	return read_sanitised_ftr_reg(reg_to_encoding(&idr->reg_desc));
 }
 
+static u64 read_sanitised_id_aa64pfr0_el1(const struct id_reg_desc *idr)
+{
+	u64 val;
+	u32 id = reg_to_encoding(&idr->reg_desc);
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
@@ -232,26 +318,37 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	 * guest could otherwise be covered in ectoplasmic residue).
 	 */
 	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
+	if (csv2 > 1 || (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
 	/* Same thing for CSV3 */
 	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
+	if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val)
-		return -EINVAL;
+	return set_id_reg(vcpu, rd, val);
+}
 
-	IDREG(vcpu->kvm, reg_to_encoding(rd)) = sval;
+static u64 read_sanitised_id_aa64dfr0_el1(const struct id_reg_desc *idr)
+{
+	u64 val;
+	u32 id = reg_to_encoding(&idr->reg_desc);
 
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
@@ -260,6 +357,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	int ret;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
@@ -279,23 +377,25 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
-
 	if (valid_pmu) {
 		mutex_lock(&vcpu->kvm->arch.config_lock);
-		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
-			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
+		ret = set_id_reg(vcpu, rd, val);
+		if (ret) {
+			mutex_unlock(&vcpu->kvm->arch.config_lock);
+			return ret;
+		}
 
 		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
 		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
 			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver_to_perfmon(pmuver));
 		mutex_unlock(&vcpu->kvm->arch.config_lock);
 	} else {
+		/* We can only differ with PMUver, and anything else is an error */
+		val ^= read_id_reg(vcpu, rd);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		if (val)
+			return -EINVAL;
+
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
 	}
@@ -303,12 +403,29 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static u64 read_sanitised_id_dfr0_el1(const struct id_reg_desc *idr)
+{
+	u64 val;
+	u32 id = reg_to_encoding(&idr->reg_desc);
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
 
@@ -329,23 +446,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
-
 	if (valid_pmu) {
 		mutex_lock(&vcpu->kvm->arch.config_lock);
-		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
-			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon);
+		ret = set_id_reg(vcpu, rd, val);
+		if (ret) {
+			mutex_unlock(&vcpu->kvm->arch.config_lock);
+			return ret;
+		}
 
 		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
 		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
 			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
 		mutex_unlock(&vcpu->kvm->arch.config_lock);
 	} else {
+		/* We can only differ with PerfMon, and anything else is an error */
+		val ^= read_id_reg(vcpu, rd);
+		val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		if (val)
+			return -EINVAL;
+
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
 	}
@@ -354,14 +473,16 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
+#define SYS_DESC_SANITISED(name) {			\
+	SYS_DESC(SYS_##name),				\
+	.access	= access_id_reg,			\
+	.get_user = get_id_reg,				\
+	.set_user = set_id_reg,				\
+	.visibility = id_visibility,			\
+}
+
 #define ID_SANITISED(name) {						\
-	.reg_desc = {							\
-		SYS_DESC(SYS_##name),					\
-		.access	= access_id_reg,				\
-		.get_user = get_id_reg,					\
-		.set_user = set_id_reg,					\
-		.visibility = id_visibility,				\
-	},								\
+	.reg_desc = SYS_DESC_SANITISED(name),				\
 	.ftr_bits = NULL,						\
 	.writable_mask = 0,						\
 	.read_kvm_sanitised_reg = general_read_kvm_sanitised_reg,	\
@@ -417,7 +538,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	.read_kvm_sanitised_reg = NULL,			\
 }
 
-static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
+static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
 	 * entries in arm64_ftr_regs[].
@@ -433,6 +554,9 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.get_user = get_id_reg,
 		.set_user = set_id_dfr0_el1,
 		.visibility = aa32_id_visibility, },
+	  .ftr_bits = ftr_id_dfr0,
+	  .writable_mask = ID_DFR0_EL1_PerfMon_MASK,
+	  .read_kvm_sanitised_reg = read_sanitised_id_dfr0_el1,
 	},
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
@@ -467,6 +591,9 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.access = access_id_reg,
 		.get_user = get_id_reg,
 		.set_user = set_id_aa64pfr0_el1, },
+	  .ftr_bits = ftr_id_aa64pfr0,
+	  .writable_mask = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK,
+	  .read_kvm_sanitised_reg = read_sanitised_id_aa64pfr0_el1,
 	},
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4, 2),
@@ -482,6 +609,9 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.access = access_id_reg,
 		.get_user = get_id_reg,
 		.set_user = set_id_aa64dfr0_el1, },
+	  .ftr_bits = ftr_id_aa64dfr0,
+	  .writable_mask = ID_AA64DFR0_EL1_PMUVer_MASK,
+	  .read_kvm_sanitised_reg = read_sanitised_id_aa64dfr0_el1,
 	},
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5, 2),
@@ -607,7 +737,7 @@ int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return ret;
 }
 
-bool kvm_arm_check_idreg_table(void)
+bool kvm_arm_idreg_table_init(void)
 {
 	unsigned int i;
 
@@ -641,10 +771,7 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 	return total;
 }
 
-/*
- * Set the guest's ID registers that are defined in id_reg_descs[]
- * with ID_SANITISED() to the host's sanitized value.
- */
+/* Initialize the guest's ID registers with KVM sanitised values. */
 void kvm_arm_init_id_regs(struct kvm *kvm)
 {
 	int i;
@@ -660,33 +787,4 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 
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
-
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
-		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d7fb0acf154..27cff8022754 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2940,14 +2940,13 @@ int __init kvm_sys_reg_table_init(void)
 	unsigned int i;
 
 	/* Make sure tables are unique and in order. */
-	valid &= kvm_arm_check_idreg_table();
 	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
 	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true);
 	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true);
 	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
 	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
 	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
-
+	valid &= kvm_arm_idreg_table_init();
 	if (!valid)
 		return -EINVAL;
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 15a0a1e2fe99..df8d26df93ec 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -246,7 +246,7 @@ int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
 int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-bool kvm_arm_check_idreg_table(void);
+bool kvm_arm_idreg_table_init(void);
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
 u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 
-- 
2.40.0.348.gf938b09366-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9DC685D8B
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 03:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjBACvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 21:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjBACvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 21:51:52 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6187B457ED
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:51:47 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gn18-20020a17090ac79200b0022bef1f49c9so1670638pjb.0
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gYXB8455jErANOmRJ2jLFfjMcp+g3Oz3xDMAy3Dz6GI=;
        b=c2lGockCeQPFRxkSN0rbjLqGNy7jBnJXAMfPpRKS7ZuwGZCGxGASbiIZL0qZResYSp
         fhRITaOj5oqmPHx3gp0ZkkayTPQOCQty67KuOxr+ZQ5LErSYBA6c/uMe/p6jYOj3r7NR
         s3t+Eda4k/aqcJh+9n8FgWeh0yise+wLW0CtjTpKlyXNw55Li4aop5VEfKU7YBzpPJt4
         XXPNgOY3yjcf5sVBcDP2WHCfcnZntfWvQHuPG8kTajQkGLLqrmU3T98gq6pCI0yDLD5v
         cKBE294mat+Q5hHvV00Y6W37WphDmBrloopsugDsQs3h9FpVYD/qe6Yjac/OLFyHz1pe
         Cupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gYXB8455jErANOmRJ2jLFfjMcp+g3Oz3xDMAy3Dz6GI=;
        b=nj3eJ8WfPwXt6DeqY1vWFTv+XMf2kZj8yJ7Lfrbx9L2lVP3dPFzg0DdSQID98Om40R
         kyF1Ok5grsc0QvmCfQ5ujXCniIEEWWM0ntp71V1lxjf8hJF/o+ZH4gMQgQdteOcgV2ak
         kmuUTi5xe4vI60xa6WgS685aLLOeoHVnrDhGXg27MUtS3R/6w+odgehLUbSl9r9km0i8
         cgGRZ2cj6ZnZk5mxWyGa42ZHFkBQUop340xcM2Y6cTM9qVzAjvJ8TQhEm3KNnBvvSSy7
         eFcbWsscYwqbo366ge4kpmAPfm4fYKrUTEZoyD0MjntUaSzpoiN6mbCY+os0TPltglPu
         iJyA==
X-Gm-Message-State: AO0yUKUy008WhlMrdrDmYeRlOA0TsGxZdIRwEudMm2OB6rKuj0R1YN6D
        X6PWiE8ZTuvChytke1ZXduyhoEbwc5HF/wvSjH2jdtxbllfp47vPGB4v2ugVhPC8MkYSw2aTe/R
        4wXKWygQHor9ejqvA3jifnr1a3uH7YSBXrDnDnV8xt1apgoJnsvqnzELlBOeU4uLF4jCK5/Y=
X-Google-Smtp-Source: AK7set9o36kPcvx7OJBsp3Z/hVwjyJdwEYXZ6FHQ/s5CcegzKpB/IA23dWbDS7uKF2BWQL61tqjc30aeYc5YkKYYSA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:1821:b0:593:ebe9:90c with
 SMTP id y33-20020a056a00182100b00593ebe9090cmr147318pfa.40.1675219906563;
 Tue, 31 Jan 2023 18:51:46 -0800 (PST)
Date:   Wed,  1 Feb 2023 02:50:48 +0000
In-Reply-To: <20230201025048.205820-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201025048.205820-7-jingzhangos@google.com>
Subject: [PATCH v1 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save KVM sanitised ID register value in ID descriptor (kvm_sys_val).
Add an init callback for every ID register to setup kvm_sys_val.
All per VCPU sanitizations are still handled on the fly during ID
register read and write from userspace.
An arm64_ftr_bits array is used to indicate writable feature fields.

Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
introduced by ID register descriptor.

No functional change intended.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/cpufeature.h |  25 +++
 arch/arm64/include/asm/kvm_host.h   |   2 +-
 arch/arm64/kernel/cpufeature.c      |  26 +--
 arch/arm64/kvm/arm.c                |   2 +-
 arch/arm64/kvm/id_regs.c            | 305 ++++++++++++++++++----------
 arch/arm64/kvm/sys_regs.c           |   3 +-
 arch/arm64/kvm/sys_regs.h           |   2 +-
 7 files changed, 232 insertions(+), 133 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 03d1c9d7af82..a64c75bc75c8 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -64,6 +64,30 @@ struct arm64_ftr_bits {
 	s64		safe_val; /* safe value for FTR_EXACT features */
 };
 
+#define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
+	{						\
+		.sign = SIGNED,				\
+		.visible = VISIBLE,			\
+		.strict = STRICT,			\
+		.type = TYPE,				\
+		.shift = SHIFT,				\
+		.width = WIDTH,				\
+		.safe_val = SAFE_VAL,			\
+	}
+
+/* Define a feature with unsigned values */
+#define ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
+	__ARM64_FTR_BITS(FTR_UNSIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL)
+
+/* Define a feature with a signed value */
+#define S_ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
+	__ARM64_FTR_BITS(FTR_SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL)
+
+#define ARM64_FTR_END					\
+	{						\
+		.width = 0,				\
+	}
+
 /*
  * Describe the early feature override to the core override code:
  *
@@ -905,6 +929,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
 	return 8;
 }
 
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64 cur);
 struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
 
 extern struct arm64_ftr_override id_aa64mmfr1_override;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1ab443b52c46..d139aace06b1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -971,7 +971,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
-void kvm_arm_set_default_id_regs(struct kvm *kvm);
+void kvm_arm_init_id_regs(struct kvm *kvm);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a77315b338e6..00ddaf04c649 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -139,30 +139,6 @@ void dump_cpu_features(void)
 	pr_emerg("0x%*pb\n", ARM64_NCAPS, &cpu_hwcaps);
 }
 
-#define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
-	{						\
-		.sign = SIGNED,				\
-		.visible = VISIBLE,			\
-		.strict = STRICT,			\
-		.type = TYPE,				\
-		.shift = SHIFT,				\
-		.width = WIDTH,				\
-		.safe_val = SAFE_VAL,			\
-	}
-
-/* Define a feature with unsigned values */
-#define ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
-	__ARM64_FTR_BITS(FTR_UNSIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL)
-
-/* Define a feature with a signed value */
-#define S_ARM64_FTR_BITS(VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
-	__ARM64_FTR_BITS(FTR_SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL)
-
-#define ARM64_FTR_END					\
-	{						\
-		.width = 0,				\
-	}
-
 static void cpu_enable_cnp(struct arm64_cpu_capabilities const *cap);
 
 static bool __system_matches_cap(unsigned int n);
@@ -780,7 +756,7 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
 	return reg;
 }
 
-static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 				s64 cur)
 {
 	s64 ret = 0;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 25bd95650223..f76edcf5e7a5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -135,7 +135,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
-	kvm_arm_set_default_id_regs(kvm);
+	kvm_arm_init_id_regs(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
 	return 0;
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 435f38e3ceb3..aed11cdd6fee 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -17,10 +17,88 @@
 
 #include "sys_regs.h"
 
+/*
+ * Number of entries in id_reg_desc's ftr_bits[] (Number of 4 bits fields
+ * in 64 bit register + 1 entry for a terminator entry).
+ */
+#define	FTR_FIELDS_NUM	17
+
 struct id_reg_desc {
 	const struct sys_reg_desc	reg_desc;
+	/*
+	 * KVM sanitised ID register value.
+	 * It is the default value for per VM emulated ID register.
+	 */
+	u64 kvm_sys_val;
+	/*
+	 * Used to validate the ID register values with arm64_check_features().
+	 * The last item in the array must be terminated by an item whose
+	 * width field is zero as that is expected by arm64_check_features().
+	 * Only feature bits defined in this array are writable.
+	 */
+	struct arm64_ftr_bits	ftr_bits[FTR_FIELDS_NUM];
+
+	/*
+	 * Basically init() is used to setup the KVM sanitised value
+	 * stored in kvm_sys_val.
+	 */
+	void (*init)(struct id_reg_desc *idr);
 };
 
+static struct id_reg_desc id_reg_descs[];
+
+/**
+ * arm64_check_features() - Check if a feature register value constitutes
+ * a subset of features indicated by @limit.
+ *
+ * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated by
+ * an item whose width field is zero.
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
+ * of the type. For register fields that are not in @ftrp[], only the value
+ * in @limit is considered the safe value.
+ *
+ * Return: 0 if all the fields are safe. Otherwise, return negative errno.
+ */
+static int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit)
+{
+	u64 mask = 0;
+
+	for (; ftrp->width; ftrp++) {
+		s64 f_val, f_lim, safe_val;
+
+		f_val = arm64_ftr_value(ftrp, val);
+		f_lim = arm64_ftr_value(ftrp, limit);
+		mask |= arm64_ftr_mask(ftrp);
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
+	/*
+	 * For fields that are not indicated in ftrp, values in limit are the
+	 * safe values.
+	 */
+	if ((val & ~mask) != (limit & ~mask))
+		return -E2BIG;
+
+	return 0;
+}
+
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	u8 pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
@@ -31,19 +109,6 @@ static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 		return 0;
 }
 
-static u8 perfmon_to_pmuver(u8 perfmon)
-{
-	switch (perfmon) {
-	case ID_DFR0_EL1_PerfMon_PMUv3:
-		return ID_AA64DFR0_EL1_PMUVer_IMP;
-	case ID_DFR0_EL1_PerfMon_IMPDEF:
-		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
-	default:
-		/* Anything ARMv8.1+ and NI have the same value. For now. */
-		return perfmon;
-	}
-}
-
 static u8 pmuver_to_perfmon(u8 pmuver)
 {
 	switch (pmuver) {
@@ -76,7 +141,6 @@ u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -103,15 +167,10 @@ u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
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
@@ -167,9 +226,15 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd))
-		return -EINVAL;
+	int ret;
+	int id = reg_to_encoding(rd);
+
+	ret = arm64_check_features(id_reg_descs[IDREG_IDX(id)].ftr_bits, val,
+				   id_reg_descs[IDREG_IDX(id)].kvm_sys_val);
+	if (ret)
+		return ret;
+
+	IDREG(vcpu->kvm, id) = val;
 
 	return 0;
 }
@@ -203,12 +268,47 @@ static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
 	return id_visibility(vcpu, r);
 }
 
+static void init_id_reg(struct id_reg_desc *idr)
+{
+	idr->kvm_sys_val = read_sanitised_ftr_reg(reg_to_encoding(&idr->reg_desc));
+}
+
+static void init_id_aa64pfr0_el1(struct id_reg_desc *idr)
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
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
+
+	idr->kvm_sys_val = val;
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
@@ -226,16 +326,29 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val)
-		return -EINVAL;
+	return set_id_reg(vcpu, rd, val);
+}
 
-	IDREG_RD(vcpu->kvm, rd) = sval;
+static void init_id_aa64dfr0_el1(struct id_reg_desc *idr)
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
+	idr->kvm_sys_val = val;
 }
 
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
@@ -263,17 +376,24 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
+	return set_id_reg(vcpu, rd, val);
+}
+
+static void init_id_dfr0_el1(struct id_reg_desc *idr)
+{
+	u64 val;
+	u32 id = reg_to_encoding(&idr->reg_desc);
 
-	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
-		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
+	val = read_sanitised_ftr_reg(id);
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
+			  kvm_arm_pmu_get_pmuver_limit());
 
-	return 0;
+	idr->kvm_sys_val = val;
 }
 
 static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
@@ -302,28 +422,22 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
-
-	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
-		FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
-
-	return 0;
+	return set_id_reg(vcpu, rd, val);
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
 #define ID_SANITISED(name) {				\
-	.reg_desc = {					\
-		SYS_DESC(SYS_##name),			\
-		.access	= access_id_reg,		\
-		.get_user = get_id_reg,			\
-		.set_user = set_id_reg,			\
-		.visibility = id_visibility,		\
-	},						\
+	.reg_desc = SYS_DESC_SANITISED(name),		\
+	.ftr_bits = { ARM64_FTR_END, },			\
+	.init = init_id_reg,				\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
@@ -335,6 +449,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 		.set_user = set_id_reg,			\
 		.visibility = aa32_id_visibility,	\
 	},						\
+	.ftr_bits = { ARM64_FTR_END, },			\
+	.init = init_id_reg,				\
 }
 
 /*
@@ -350,6 +466,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 		.set_user = set_id_reg,				\
 		.visibility = raz_visibility			\
 	},							\
+	.ftr_bits = { ARM64_FTR_END, },				\
 }
 
 /*
@@ -365,9 +482,10 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 		.set_user = set_id_reg,			\
 		.visibility = raz_visibility,		\
 	},						\
+	.ftr_bits = { ARM64_FTR_END, },			\
 }
 
-static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
+static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
 	 * entries in arm64_ftr_regs[].
@@ -383,6 +501,11 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.get_user = get_id_reg,
 		.set_user = set_id_dfr0_el1,
 		.visibility = aa32_id_visibility, },
+	  .ftr_bits = {
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_PerfMon_SHIFT, ID_DFR0_EL1_PerfMon_WIDTH, 0),
+		ARM64_FTR_END, },
+	  .init = init_id_dfr0_el1,
 	},
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
@@ -417,6 +540,13 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.access = access_id_reg,
 		.get_user = get_id_reg,
 		.set_user = set_id_aa64pfr0_el1, },
+	  .ftr_bits = {
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64PFR0_EL1_CSV2_SHIFT, ID_AA64PFR0_EL1_CSV2_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64PFR0_EL1_CSV3_SHIFT, ID_AA64PFR0_EL1_CSV3_WIDTH, 0),
+		ARM64_FTR_END, },
+	  .init = init_id_aa64pfr0_el1,
 	},
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4, 2),
@@ -432,6 +562,11 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.access = access_id_reg,
 		.get_user = get_id_reg,
 		.set_user = set_id_aa64dfr0_el1, },
+	  .ftr_bits = {
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_PMUVer_SHIFT, ID_AA64DFR0_EL1_PMUVer_WIDTH, 0),
+		ARM64_FTR_END, },
+	  .init = init_id_aa64dfr0_el1,
 	},
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5, 2),
@@ -544,7 +679,7 @@ int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return ret;
 }
 
-bool kvm_arm_check_idreg_table(void)
+bool kvm_arm_idreg_table_init(void)
 {
 	unsigned int i;
 
@@ -561,6 +696,9 @@ bool kvm_arm_check_idreg_table(void)
 				&id_reg_descs[i - 1].reg_desc, i - 1);
 			return false;
 		}
+
+		if (id_reg_descs[i].init)
+			id_reg_descs[i].init(&id_reg_descs[i]);
 	}
 
 	return true;
@@ -585,55 +723,16 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 }
 
 /*
- * Set the guest's ID registers that are defined in id_reg_descs[]
- * with ID_SANITISED() to the host's sanitized value.
+ * Initialize the guest's ID registers with KVM sanitised values that were setup
+ * during ID register descriptors initialization.
  */
-void kvm_arm_set_default_id_regs(struct kvm *kvm)
+void kvm_arm_init_id_regs(struct kvm *kvm)
 {
 	int i;
 	u32 id;
-	u64 val;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
 		id = reg_to_encoding(&id_reg_descs[i].reg_desc);
-		if (WARN_ON_ONCE(!is_id_reg(id)))
-			/* Shouldn't happen */
-			continue;
-
-		if (id_reg_descs[i].reg_desc.visibility == raz_visibility)
-			/* Hidden or reserved ID register */
-			continue;
-
-		val = read_sanitised_ftr_reg(id);
-		IDREG(kvm, id) = val;
-	}
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
+		IDREG(kvm, id) = id_reg_descs[i].kvm_sys_val;
 	}
-
-	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
-
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
-		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
-			   kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 11d302a75090..91bc80f40e72 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2758,14 +2758,13 @@ int __init kvm_sys_reg_table_init(void)
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
index 3646be75b920..e1e0cc0d0cde 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -237,7 +237,7 @@ const struct sys_reg_desc *kvm_arm_find_id_reg(const struct sys_reg_params *para
 void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-bool kvm_arm_check_idreg_table(void);
+bool kvm_arm_idreg_table_init(void);
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
 u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
 
-- 
2.39.1.456.gfc5497dd1b-goog


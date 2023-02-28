Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D85C6A52EF
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 07:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjB1GXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 01:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjB1GXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 01:23:24 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA3ADBD9
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:20 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id p36-20020a056a000a2400b005f72df7d97bso2613661pfh.19
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZJEOIST+SJnVqj4X4EJIooT5+OMH7gtCygAbIcw5/o=;
        b=HOAzcHnWIKy59peqwYVLYPmkBW88kX6M6h4m8LZOC6KTdTZqOUGksXrllYSZZBgNlO
         LcU07l8I9Um+TSAnm/dBUlDhEElAv/SaxCL0B/q0MZ/wStVdzIsItXJVw0Q8OX26dHfi
         eXEoarwEYq3ZzCmCy9rLUqKDJKELWz9Ow2jgRTSRj9T91ikd3dcLO4FI9emIo754H1f1
         twjkW8QjNBEm2UdIezmN2jF4uNGyb1gR4zW0URSRwTSbVXFgCwCw8XHGuhQhAQoNPlGv
         k8SbC4nTOtfBkFFN+NhWevRUjnPTjNgOYwzUZZdHH+qu5DFl6B+VOiyy4YtYzsy+Fpdu
         vSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ZJEOIST+SJnVqj4X4EJIooT5+OMH7gtCygAbIcw5/o=;
        b=MiTVXiAId/k+iw0WFPY3QfG5DWO9DF5EuxeTdzPRn/9dPqLcNMf/Wl+wZ+myZGK9qm
         grJUYw9ufykXKisviQ5OLvaucmUnLOHquBKIC8zoEoDnlKeUyBU6xLj55TDQRT1HaGoW
         59waIDpmfANDyrACoLgYbCZIhMuR3k5zzrFv3+waS8r9kqrMW52SWu1VHtyj9WNeTpV4
         9xkasat09NFpu1WnrDJWDMi56/w+WAi3pznzHeAmhei/fzhi36rhTv81FKievrPWFYex
         WLCSpM3C8ephVzrgM99GlTD1uZHZ/Ds8OZbnI3dlLkAaln+Ro05TqppCypKFoZHQDE83
         sBFA==
X-Gm-Message-State: AO0yUKUSnjTL+SO+lcgta3dsFlaCTXX4/W4Rhzd3IepO4MQdh/dZgrnL
        KjgZKBo1gHoLI4J8gXYx3yPl7kd9psEBxf2Iwn0YlqgJJgomT6kVaxvFfxC3QHe3zrdzEGSgq95
        bUYYV1NEIr3hDyvLEEGUNfaCHEQNHevoZULphHHkCyZdu4JhWX48cV9ShrH1lC86x/lBruC8=
X-Google-Smtp-Source: AK7set/XCWNuZIE5xs0cryaGGU6aq3EXiAEpwBYEoDhYVbHJMzWqLXTpvZNNbZfenMnAEafXr4tycuUX47vC65zgCw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:d344:b0:233:bc72:1c69 with
 SMTP id i4-20020a17090ad34400b00233bc721c69mr701770pjx.9.1677565400176; Mon,
 27 Feb 2023 22:23:20 -0800 (PST)
Date:   Tue, 28 Feb 2023 06:22:46 +0000
In-Reply-To: <20230228062246.1222387-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228062246.1222387-7-jingzhangos@google.com>
Subject: [PATCH v3 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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
 arch/arm64/kvm/id_regs.c            | 325 ++++++++++++++++++++--------
 arch/arm64/kvm/sys_regs.c           |   3 +-
 arch/arm64/kvm/sys_regs.h           |   2 +-
 7 files changed, 261 insertions(+), 124 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index fc2c739f48f1..493ec530eefc 100644
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
@@ -911,6 +935,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
 	return 8;
 }
 
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64 cur);
 struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
 
 extern struct arm64_ftr_override id_aa64mmfr1_override;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index effb61a9a855..4795f81b31b4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1015,7 +1015,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
-void kvm_arm_set_default_id_regs(struct kvm *kvm);
+void kvm_arm_init_id_regs(struct kvm *kvm);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 23bd2a926b74..e18848ee4b98 100644
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
@@ -790,7 +766,7 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
 	return reg;
 }
 
-static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
+s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
 				s64 cur)
 {
 	s64 ret = 0;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fb2de2cb98cb..e539d9ca9d01 100644
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
index fc0dcd557cbb..6578bce81854 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -18,10 +18,88 @@
 
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
 	if (kvm_vcpu_has_pmu(vcpu))
@@ -67,7 +145,6 @@ u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -94,15 +171,10 @@ u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
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
@@ -161,9 +233,15 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
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
@@ -197,12 +275,47 @@ static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
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
@@ -220,16 +333,29 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -238,6 +364,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	int ret;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
@@ -257,35 +384,55 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
-
 	if (valid_pmu) {
-		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
-			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
+		ret = set_id_reg(vcpu, rd, val);
+		if (ret)
+			return ret;
 
 		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
 		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
 			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver);
-	} else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
-		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
 	} else {
-		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+		/* We can only differ with PMUver, and anything else is an error */
+		val ^= read_id_reg(vcpu, rd);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		if (val)
+			return -EINVAL;
+
+		if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+			set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+		else
+			clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+
 	}
 
 	return 0;
 }
 
+static void init_id_dfr0_el1(struct id_reg_desc *idr)
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
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
+			  kvm_arm_pmu_get_pmuver_limit());
+
+	idr->kvm_sys_val = val;
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
 
@@ -306,38 +453,43 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
-
 	if (valid_pmu) {
-		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(
-			ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
+		ret = set_id_reg(vcpu, rd, val);
+		if (ret)
+			return ret;
 
 		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
 		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(
 			ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
-	} else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
-		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
 	} else {
-		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+		/* We can only differ with PerfMon, and anything else is an error */
+		val ^= read_id_reg(vcpu, rd);
+		val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		if (val)
+			return -EINVAL;
+
+		if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF)
+			set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+		else
+			clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
 	}
 
 	return 0;
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
@@ -349,6 +501,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 		.set_user = set_id_reg,			\
 		.visibility = aa32_id_visibility,	\
 	},						\
+	.ftr_bits = { ARM64_FTR_END, },			\
+	.init = init_id_reg,				\
 }
 
 /*
@@ -364,6 +518,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 		.set_user = set_id_reg,				\
 		.visibility = raz_visibility			\
 	},							\
+	.ftr_bits = { ARM64_FTR_END, },				\
 }
 
 /*
@@ -379,9 +534,10 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -397,6 +553,11 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
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
@@ -431,6 +592,13 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
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
@@ -446,6 +614,11 @@ static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
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
@@ -575,7 +748,7 @@ int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return ret;
 }
 
-bool kvm_arm_check_idreg_table(void)
+bool kvm_arm_idreg_table_init(void)
 {
 	unsigned int i;
 
@@ -587,6 +760,9 @@ bool kvm_arm_check_idreg_table(void)
 				&id_reg_descs[i].reg_desc, i);
 			return false;
 		}
+
+		if (id_reg_descs[i].init)
+			id_reg_descs[i].init(&id_reg_descs[i]);
 	}
 
 	return true;
@@ -610,55 +786,16 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
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
+		IDREG(kvm, id) = id_reg_descs[i].kvm_sys_val;
 	}
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
-		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
-			   kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b63d9038639..e09730a6cba4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2912,14 +2912,13 @@ int __init kvm_sys_reg_table_init(void)
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
index 094a7f19d93f..379e42d70caf 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -260,7 +260,7 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
 void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-bool kvm_arm_check_idreg_table(void);
+bool kvm_arm_idreg_table_init(void);
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
 u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
 
-- 
2.39.2.722.g9855ee24e9-goog


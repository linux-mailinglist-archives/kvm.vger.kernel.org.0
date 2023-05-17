Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441F1705FBE
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 08:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjEQGKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 02:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjEQGK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 02:10:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C262640F7
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8338f20bdso320182276.0
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684303821; x=1686895821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cKyq0k8dUe1ZDkVuhkx8yfrDn2XznqE91J7ozeqOzC8=;
        b=riMXLqyIjxnx+fZhPS9Kz5DbIt4+vLe6kK56YvBEFHqrn1gLBCerg44ExiAvBZKyXl
         kWwzXitFaOxcmL77MSHABjfJfRyg9EUnkt7Rjoi19hXxBF8/iD+MlSM/fapf6dapUMdN
         nyMHZxAFTHcKySo0i8IZ0nPELFeDz4M8ErSudCyHnsYUcUNt+6lQlCFiE7yuu5HvtXoN
         PD3AvLc2GrFfdDRaoE+zpmlGLVjWi6LIe6NKOdW9Wmnobu/8a13VztEx5VjqIZOLdjU0
         y0q+MRrZehOX6iPtCEvRgTd/yXGnzkBS8OhLWsqoxBTttSh1N20S8Ti8e9swQDo6sUkz
         Y3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684303821; x=1686895821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cKyq0k8dUe1ZDkVuhkx8yfrDn2XznqE91J7ozeqOzC8=;
        b=Lflm7uoeBuEbOxPYz/R/1HDJGqYpraP0wRQqKNwF+5RgmYk37TMv8T9rcbnXRcyhbH
         Xj5J9lNR1SisT+l9qfB2vTHE+ancCm0QJYU57KgDSgEZ1jr0lN+d/WB3fs1JTM0E3yI0
         dVKJCDl8HQx5nVyTFHwyXXr4jqrFQSf/fR6wm1Bm11KnqZBvcSZnqQZxiljA/r2FUJrD
         2QNSJoyXMBAUyYkPxTMoiG0rh2mtuusS9mpenAjECPU5WAvfsLMczlhOsNxFbam9FcvN
         w+DASrB3ty74OzcQzxKHCxK/+UzhEV7Iexn/OWbsTcsy8o1p1I3101hD88eyVb6QNIHZ
         y+vQ==
X-Gm-Message-State: AC+VfDx6HO9tcBg3H76+6+lzIejErdPhPFCP4EUz0K4brsjdOOweOtmp
        U/uKEUMdJ3U+TTCUyBKlZjQ6wx+GPAEOe35ewwqXF2dZgsQE5HQN4Dg3olWpe5BgBbyVyEIvTx8
        94k5odhRvDGMBgUF+WabZzJtV0xqfROQLvn5v+x3BBoJzUatzWvDLE1lwG9yP970gitSrTKk=
X-Google-Smtp-Source: ACHHUZ7cwYyAnKcwFLd47vJe+F53J6CH3KQCe7LUnUoh7iIPeEPYjQ5mDvu55p2f6cGXFqtaouNZmrDgPOqD/+dw5A==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:dad3:0:b0:ba8:4c16:78b7 with SMTP
 id n202-20020a25dad3000000b00ba84c1678b7mr1292255ybf.12.1684303821022; Tue,
 16 May 2023 23:10:21 -0700 (PDT)
Date:   Wed, 17 May 2023 06:10:10 +0000
In-Reply-To: <20230517061015.1915934-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517061015.1915934-2-jingzhangos@google.com>
Subject: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized value per guest
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

Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
and save ID registers' sanitized value in the array at KVM_CREATE_VM.
Use the saved ones when ID registers are read by the guest or
userspace (via KVM_GET_ONE_REG).

No functional change intended.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 20 +++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/sys_regs.c         | 69 +++++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.h         |  7 ++++
 4 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7e7e19ef6993..949a4a782844 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -178,6 +178,21 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap;
 };
 
+/*
+ * Emulated CPU ID registers per VM
+ * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
+ * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ *
+ * These emulated idregs are VM-wide, but accessed from the context of a vCPU.
+ * Access to id regs are guarded by kvm_arch.config_lock.
+ */
+#define KVM_ARM_ID_REG_NUM	56
+#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
+#define IDREG(kvm, id)		((kvm)->arch.idregs.regs[IDREG_IDX(id)])
+struct kvm_idregs {
+	u64 regs[KVM_ARM_ID_REG_NUM];
+};
+
 typedef unsigned int pkvm_handle_t;
 
 struct kvm_protected_vm {
@@ -253,6 +268,9 @@ struct kvm_arch {
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
 
+	/* Emulated CPU ID registers */
+	struct kvm_idregs idregs;
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
@@ -1045,6 +1063,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 				    struct kvm_arm_counter_offset *offset);
 
+void kvm_arm_init_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..774656a0718d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -163,6 +163,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
+	kvm_arm_init_id_regs(kvm);
 
 	/*
 	 * Initialise the default PMUver before there is a chance to
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 71b12094d613..d2ee3a1c7f03 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -41,6 +41,7 @@
  * 64bit interface.
  */
 
+static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
@@ -364,7 +365,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
@@ -1208,16 +1209,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (sysreg_visible_as_raz(vcpu, r))
-		return 0;
-
-	val = read_sanitised_ftr_reg(id);
+	u64 val = IDREG(vcpu->kvm, id);
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -1280,6 +1274,26 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 	return val;
 }
 
+/* Read a sanitised cpufeature ID register by sys_reg_desc */
+static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+{
+	if (sysreg_visible_as_raz(vcpu, r))
+		return 0;
+
+	return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
+}
+
+/*
+ * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
+ * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ */
+static inline bool is_id_reg(u32 id)
+{
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+		sys_reg_CRm(id) < 8);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -2244,8 +2258,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL1_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0xf) << 28) |
@@ -3343,6 +3357,37 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+/*
+ * Set the guest's ID registers with ID_SANITISED() to the host's sanitized value.
+ */
+void kvm_arm_init_id_regs(struct kvm *kvm)
+{
+	const struct sys_reg_desc *idreg;
+	struct sys_reg_params params;
+	u32 id;
+
+	/* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
+	id = SYS_ID_PFR0_EL1;
+	params = encoding_to_params(id);
+	idreg = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	if (WARN_ON(!idreg))
+		return;
+
+	/* Initialize all idregs */
+	while (is_id_reg(id)) {
+		/*
+		 * Some hidden ID registers which are not in arm64_ftr_regs[]
+		 * would cause warnings from read_sanitised_ftr_reg().
+		 * Skip those ID registers to avoid the warnings.
+		 */
+		if (idreg->visibility != raz_visibility)
+			IDREG(kvm, id) = read_sanitised_ftr_reg(id);
+
+		idreg++;
+		id = reg_to_encoding(idreg);
+	}
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	bool valid = true;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 6b11f2cc7146..eba10de2e7ae 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -27,6 +27,13 @@ struct sys_reg_params {
 	bool	is_write;
 };
 
+#define encoding_to_params(reg)						\
+	((struct sys_reg_params){ .Op0 = sys_reg_Op0(reg),		\
+				  .Op1 = sys_reg_Op1(reg),		\
+				  .CRn = sys_reg_CRn(reg),		\
+				  .CRm = sys_reg_CRm(reg),		\
+				  .Op2 = sys_reg_Op2(reg) })
+
 #define esr_sys64_to_params(esr)                                               \
 	((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
 				  .Op1 = ((esr) >> 14) & 0x7,                  \
-- 
2.40.1.606.ga4b1b128d6-goog


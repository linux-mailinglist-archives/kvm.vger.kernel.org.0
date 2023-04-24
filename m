Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D160F6ED8EE
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 01:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjDXXrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 19:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXXrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 19:47:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B11249EB
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:47:12 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1a697b1a71aso57126405ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380031; x=1684972031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TLvwoCFmT9d/aZDDcIcw6O5cB0ka34ie/8GfmqiEy0E=;
        b=XiAt1WVgGgyZQs1Z3bzcnmvPUrHzham8w+vyr6VYC4lCujss7LCYpVDhhAZXsI+BZ8
         Sn1UQtJPcSrbvLChfdi3VmuG+GU3tKWWTW+sBFIHnw31/HO6a/j2bOfye6jlPrTMRkXL
         7l+ujDu1mKVJFQPQpeZAFCZ9nP6EJi/q6lquHLiI2mp21FRnuADvnsRU/2ZGiom+oCwj
         to1ckbCuPgjJ0W6duecxTklCsjzM2gGMcPhcl2qT7UIio9A9tAjtX29KnHcNwCL2fwdb
         MGd7U4GfFkYDn1xx4kzkldCBZ3/raGbppHN5MUSPHGN0qZArdfgjsjhbGd3WVavYUjyX
         Fowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380031; x=1684972031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLvwoCFmT9d/aZDDcIcw6O5cB0ka34ie/8GfmqiEy0E=;
        b=RsFNnZwmRZHsUZmoMk2/PkZk3hLtdm9J4kM9ENSOcXRHx5SpeuIr7IGtIsA+z6/6jf
         SHE1CmBUYVJMHtKO3U0oLmMaYfF/IN+As/A8Xr7p8oFJNvILJCUf7sPlsLEpjwINvtZK
         Q/SqGSqXmix0BhGLJj/MKrbtdzSYWzRwucbHPZDVl8DMNef4tQCiNWr35MO0dprtlQOE
         Vm2XL+tGGubLaQF7ZSecAOufUsu8rQ9PwQ2hP51B6Zb64NFbdXAAJwV7oAAs5MC8/+9k
         UMAnoAfBtxH5CtWn4gLnkfeMICXZrNiRwc95ix62jxT6jAnh06u7nzefQUnTu7RcVhTK
         /rVA==
X-Gm-Message-State: AAQBX9eQA23ZCCcq/pf5qlxE/fih9Rckxnoy8S2WGe343WyR3bMkOsKg
        fP5Jk/Wn74JoHB5Jj1tc4ci5lwCBWlPEiysNLFTZA7spGD4q91lR26REgRgmdop4KWiGKkPttw+
        bvDYEJryoKVaXMtEEbC0fhaOFzyOcrVUeyLry7BpHO712ClNwRAP4URcSVyuJXtXG41ZRUo8=
X-Google-Smtp-Source: AKy350ba5SY+SLj8omjfpO1GfrqZ6xxAW5x0jMmZCyJbxcpObI07/vL+6dtRFvhOwxJuGuu/sBqNAzvPlys5kajTKA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:41c4:b0:1a6:ef72:b11 with SMTP
 id u4-20020a17090341c400b001a6ef720b11mr5251210ple.9.1682380031510; Mon, 24
 Apr 2023 16:47:11 -0700 (PDT)
Date:   Mon, 24 Apr 2023 23:47:00 +0000
In-Reply-To: <20230424234704.2571444-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230424234704.2571444-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424234704.2571444-3-jingzhangos@google.com>
Subject: [PATCH v7 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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
 arch/arm64/include/asm/kvm_host.h | 47 +++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/id_regs.c          | 49 +++++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.c         |  2 +-
 arch/arm64/kvm/sys_regs.h         |  3 +-
 5 files changed, 90 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..2b1fe90a1790 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -177,6 +177,20 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap;
 };
 
+/*
+ * Emualted CPU ID registers per VM
+ * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
+ * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ *
+ * These emulated idregs are VM-wide, but accessed from the context of a vCPU.
+ * Access to id regs are guarded by kvm_arch.config_lock.
+ */
+#define KVM_ARM_ID_REG_NUM	56
+#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
+struct kvm_idregs {
+	u64 regs[KVM_ARM_ID_REG_NUM];
+};
+
 typedef unsigned int pkvm_handle_t;
 
 struct kvm_protected_vm {
@@ -243,6 +257,9 @@ struct kvm_arch {
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
+	/* Emulated CPU ID registers */
+	struct kvm_idregs idregs;
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
@@ -1008,6 +1025,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void kvm_arm_init_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
@@ -1073,4 +1092,32 @@ static inline void kvm_hyp_reserve(void) { }
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
+static inline u64 _idreg_read(struct kvm_arch *arch, u32 id)
+{
+	return arch->idregs.regs[IDREG_IDX(id)];
+}
+
+static inline void _idreg_write(struct kvm_arch *arch, u32 id, u64 val)
+{
+	arch->idregs.regs[IDREG_IDX(id)] = val;
+}
+
+static inline u64 idreg_read(struct kvm_arch *arch, u32 id)
+{
+	u64 val;
+
+	mutex_lock(&arch->config_lock);
+	val = _idreg_read(arch, id);
+	mutex_unlock(&arch->config_lock);
+
+	return val;
+}
+
+static inline void idreg_write(struct kvm_arch *arch, u32 id, u64 val)
+{
+	mutex_lock(&arch->config_lock);
+	_idreg_write(arch, id, val);
+	mutex_unlock(&arch->config_lock);
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4b2e16e696a8..e34744c36406 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -153,6 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
+	kvm_arm_init_id_regs(kvm);
 
 	/*
 	 * Initialise the default PMUver before there is a chance to
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 96b4c43a5100..d2fba2fde01c 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -52,16 +52,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (sysreg_visible_as_raz(vcpu, r))
-		return 0;
-
-	val = read_sanitised_ftr_reg(id);
+	u64 val = idreg_read(&vcpu->kvm->arch, id);
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -126,6 +119,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 	return val;
 }
 
+static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+{
+	if (sysreg_visible_as_raz(vcpu, r))
+		return 0;
+
+	return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
+}
+
 /* cpufeature ID register access trap handlers */
 
 static bool access_id_reg(struct kvm_vcpu *vcpu,
@@ -458,3 +459,33 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
 
 	return 1;
 }
+
+/*
+ * Set the guest's ID registers that are defined in id_reg_descs[]
+ * with ID_SANITISED() to the host's sanitized value.
+ */
+void kvm_arm_init_id_regs(struct kvm *kvm)
+{
+	int i;
+	u32 id;
+	u64 val;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
+		id = reg_to_encoding(&id_reg_descs[i]);
+		if (WARN_ON_ONCE(!is_id_reg(id)))
+			/* Shouldn't happen */
+			continue;
+
+		/*
+		 * Some hidden ID registers which are not in arm64_ftr_regs[]
+		 * would cause warnings from read_sanitised_ftr_reg().
+		 * Skip those ID registers to avoid the warnings.
+		 */
+		if (id_reg_descs[i].visibility == raz_visibility)
+			/* Hidden or reserved ID register */
+			continue;
+
+		val = read_sanitised_ftr_reg(id);
+		idreg_write(&kvm->arch, id, val);
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8dba10696dac..6370a0db9d26 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -364,7 +364,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 7ce546a8be60..e88fd77309b2 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -237,6 +237,7 @@ bool write_to_read_only(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *params, const struct sys_reg_desc *r);
 unsigned int raz_visibility(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *r);
 int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
+u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
@@ -251,6 +252,4 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
-#define KVM_ARM_ID_REG_NUM	56
-
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.40.0.634.g4ca3ef3211-goog


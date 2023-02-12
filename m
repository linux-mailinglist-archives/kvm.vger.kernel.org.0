Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B9C693A59
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 22:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBLV6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 16:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjBLV6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 16:58:52 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBCFDBE6
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 13:58:51 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id p4-20020a654904000000b004fb64e929f2so1912419pgs.7
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 13:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XUDynuDy3v1ChI5J3XvdO3P+OiMkheD0Jz8fWovR3nU=;
        b=tMYQRzmQIb+8nr2nTK5UCq9bJAv/srPWX2PPIN6R7IxrB4y8U1uZNJclzjkoPVvgWM
         8gJEZMkFeKYHxIIBCbZjmoT1UnZdOn56eh00p8ZQ3Q4kh7EhQOUS0Q6yBvjO3R0uJxQM
         tZadeOmK+ezTsLJErkg1l/xmneQekowqmAbMocVGM84JcYPOlMpmVPI+Hg+Ccd/KPVlW
         sxiG8GPMRZPBK67h+Yo5N9l3Z0Lwk9diZFqUpISdE4LNj1z/5Wk0I22LXcQI2qDZ7zCD
         6C7qqU7dsgaF2edkSrMlNDD2izNVx9C1WzYJLXNQ5Gn7NWUcNuKR5uhCO9Weha/9nxkI
         SDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUDynuDy3v1ChI5J3XvdO3P+OiMkheD0Jz8fWovR3nU=;
        b=Zq9cv7fByimWRN5N3F3m5uJBH0XWmX9eiibk9VSx5ZuzJ/lCao/y8cU2fV2//fXSDH
         VFVGotreVX5UxC2bKYaSmBKAbP21ZnPtOMttIBhTdAZfa6qvsHG/jK6wVDP0lFV97Vuv
         ujdcYtlIGLbjIuG6350nwok5UADKNGa/Qc+vDTktdhdGyX6hdTAVJCZYzoBsjKNHjwuN
         OzQGe0XhVnQf6o1o/sEeMJpUsQ5EylY2NCcJQUtD0/kHRUoaSQQkNy70fpll0ymVNQ91
         dNxZxDc9vTOoBzU3mDemRBbCH5FuxgZqXbniht8Mc9P/Cvo4mi/h7FT8IuLN4RPBIPW4
         Y7CA==
X-Gm-Message-State: AO0yUKVCE759fUf+ahvrVKDHTZ0fn3A24UFc2h/nZPyl19b/zwj13qfQ
        n1bLiQfYxdjTL0kYM7gG1yaQ12uCD/zCG/vYbMx2xZgS9BgS9am5/QlQNrAxLhCRfVwuzG6oVbS
        LbFz5dZIjWqc9KGlNjY/UUvQLepEOh/2CC25BfZDJYRJgg75sf0HjyXL5npQvniZjvvM0GY0=
X-Google-Smtp-Source: AK7set9htWsR3/r/ZOBYfxuLGprlmedyNN4d+UWgBdgyrpSxeBdQk5StP4cXgEDfhuj84RuuJbVDfcPiDD0NxyBO/w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:601:b0:233:c3dd:1d4b with SMTP
 id gb1-20020a17090b060100b00233c3dd1d4bmr216515pjb.2.1676239129646; Sun, 12
 Feb 2023 13:58:49 -0800 (PST)
Date:   Sun, 12 Feb 2023 21:58:26 +0000
In-Reply-To: <20230212215830.2975485-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230212215830.2975485-3-jingzhangos@google.com>
Subject: [PATCH v2 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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

From: Reiji Watanabe <reijiw@google.com>

Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
and save ID registers' sanitized value in the array at KVM_CREATE_VM.
Use the saved ones when ID registers are read by the guest or
userspace (via KVM_GET_ONE_REG).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Co-developed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/id_regs.c          | 53 ++++++++++++++++++++++++++-----
 arch/arm64/kvm/sys_regs.c         |  2 +-
 arch/arm64/kvm/sys_regs.h         |  1 +
 5 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a1892a8f6032..5c1cec4efa37 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -245,6 +245,16 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+
+	/*
+	 * Save ID registers for the guest in id_regs[].
+	 * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
+	 * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+	 */
+#define KVM_ARM_ID_REG_NUM	56
+#define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
+#define IDREG(kvm, id)		kvm->arch.id_regs[IDREG_IDX(id)]
+	u64 id_regs[KVM_ARM_ID_REG_NUM];
 };
 
 struct kvm_vcpu_fault_info {
@@ -1005,6 +1015,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void kvm_arm_set_default_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..4579c878ab30 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -153,6 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
+	kvm_arm_set_default_id_regs(kvm);
 
 	/*
 	 * Initialise the default PMUver before there is a chance to
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 7f30d683de21..0302507abbce 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -52,16 +52,20 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+/*
+ * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
+ * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ */
+static bool is_id_reg(u32 id)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (sysreg_visible_as_raz(vcpu, r))
-		return 0;
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+		sys_reg_CRm(id) < 8);
+}
 
-	val = read_sanitised_ftr_reg(id);
+u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
+{
+	u64 val = IDREG(vcpu->kvm, id);
 
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
@@ -126,6 +130,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 	return val;
 }
 
+static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+{
+	if (sysreg_visible_as_raz(vcpu, r))
+		return 0;
+
+	return kvm_arm_read_id_reg_with_encoding(vcpu, reg_to_encoding(r));
+}
+
 /* cpufeature ID register access trap handlers */
 
 static bool access_id_reg(struct kvm_vcpu *vcpu,
@@ -484,3 +496,28 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 	}
 	return total;
 }
+
+/*
+ * Set the guest's ID registers that are defined in id_reg_descs[]
+ * with ID_SANITISED() to the host's sanitized value.
+ */
+void kvm_arm_set_default_id_regs(struct kvm *kvm)
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
+		if (id_reg_descs[i].visibility == raz_visibility)
+			/* Hidden or reserved ID register */
+			continue;
+
+		val = read_sanitised_ftr_reg(id);
+		IDREG(kvm, id) = val;
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3b23b7a67eb5..a4350f0737c3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -354,7 +354,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = kvm_arm_read_id_reg_with_encoding(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 96a52936d130..5cfab83ce8b8 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -248,6 +248,7 @@ int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 bool kvm_arm_check_idreg_table(void);
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
+u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
-- 
2.39.1.581.gbfd45094c4-goog


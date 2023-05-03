Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CD6F5CD7
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjECRQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjECRQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:16:28 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C086A44BE
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 10:16:26 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6435432f4ffso344781b3a.0
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 10:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683134186; x=1685726186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pPrcWb1iMXWS2OwiEI/Bt53hfLOEj9XoO7wdzqsY4lA=;
        b=cP0R12EUvjREO5uZjqPu2BGz6kQrpMSOB2zqXWOvusQpE6WZ7fZvphA14BsixV2f/7
         dPdbbTtMDifMMTWqEGxicosD5hxxm5SIuIBJOe4x8Qf3SXSfG7P3uVfv3ug2fi4ORS4E
         7NfxyC6v0AH0LkW7TZ3pWywRfiTWfxGekrL6Kd/TGmR0GIHQQMPHL4JL/Ru+5d9GshtR
         5Yy2BbFZ3vdT1GNH8oT0c20PdERuq2CduYQE7cPgPyibVBk6HKbx2UrtL9irBCXJtJls
         B14L4cQG1cBgLZwuiQGcJLfpErJR/566WyZp49YF2l7qKSs8XOzo1svDKOijofrQBwGe
         JgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683134186; x=1685726186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pPrcWb1iMXWS2OwiEI/Bt53hfLOEj9XoO7wdzqsY4lA=;
        b=lousZFsDmCdbwFrJQ5yo1yPDqAlm06eKMQio4hFOBZIdqEs2BRof+WN6kHUOzolKS3
         dD7MwALAt+5K7KIinwcZE286tkqZ/zi0FwDKLG0lVMse4wFVhENiO/T+WIO1LPJLMpo3
         H5DNP7xTQ82zq4U/WQPXNfrDp+/YEr1DQsxcIotsMSebl5mS4+o3ggjd/7h3kCoGjvLU
         xFE9oBTcHc+8XP53qvVBZ1Ghx4rAnMhvtKhJkRRl0F/bIyNhK7BU/wOab+e5i/Gk3avP
         Xy2Hd2Fa9vEbJvJXUbiDgNba+zYgXa3pNwty/5S+7qR33ygzDpfEKkA/70XwrdzhACS8
         rB7w==
X-Gm-Message-State: AC+VfDzzPQK1h8ljCoDfb9q1VR/LtN/DYTPH/lmupub53dwqyHRV4FJF
        WWFviEV/gKoONwjZHGSJR3cG8fhTQA5aFN4Bs5p65SSdpz3reyg8azQrNrglWwoPlnth/mnhYKL
        FvCU+d+i4l0ImOWxDHyHjtDm368MD261Tpi0G9i/Pm6XOc5DyISzTA/0fw5+VwmygTeYTQTM=
X-Google-Smtp-Source: ACHHUZ63PFv28fB95Zp6Jfd1/TWWp0WkFqq+NSD2N6eTyTqOoCbT/IZypPl1F86nomhmddYvmfnsIa2WxhDv/DhroA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:80f2:b0:643:4b03:4932 with
 SMTP id ei50-20020a056a0080f200b006434b034932mr479912pfb.4.1683134186119;
 Wed, 03 May 2023 10:16:26 -0700 (PDT)
Date:   Wed,  3 May 2023 17:16:14 +0000
In-Reply-To: <20230503171618.2020461-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503171618.2020461-3-jingzhangos@google.com>
Subject: [PATCH v8 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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
 arch/arm64/include/asm/kvm_host.h | 20 ++++++++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/id_regs.c          | 46 +++++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.c         | 11 +++++++-
 arch/arm64/kvm/sys_regs.h         |  3 +-
 5 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..a7d4d9e093e3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -177,6 +177,21 @@ struct kvm_smccc_features {
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
+#define IDREG(kvm, id)		kvm->arch.idregs.regs[IDREG_IDX(id)]
+struct kvm_idregs {
+	u64 regs[KVM_ARM_ID_REG_NUM];
+};
+
 typedef unsigned int pkvm_handle_t;
 
 struct kvm_protected_vm {
@@ -243,6 +258,9 @@ struct kvm_arch {
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
+	/* Emulated CPU ID registers */
+	struct kvm_idregs idregs;
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
@@ -1008,6 +1026,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void kvm_arm_init_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
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
index 96b4c43a5100..e769223bcee2 100644
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
+	u64 val = IDREG(vcpu->kvm, id);
 
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
@@ -458,3 +459,30 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
 
 	return 1;
 }
+
+/*
+ * Set the guest's ID registers that are defined in id_reg_descs[]
+ * with ID_SANITISED() to the host's sanitized value.
+ */
+void kvm_arm_init_id_regs(struct kvm *kvm)
+{
+	u64 val;
+	u32 id;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
+		id = reg_to_encoding(&id_reg_descs[i]);
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
+		IDREG(kvm, id) = val;
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8dba10696dac..2e7b17d14b4f 100644
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
@@ -2967,5 +2967,14 @@ int __init kvm_sys_reg_table_init(void)
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
 		invariant_sys_regs[i].reset(NULL, &invariant_sys_regs[i]);
 
+	/* Sanity check for ID registers */
+	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
+		if (!is_id_reg(reg_to_encoding(&id_reg_descs[i]))) {
+			kvm_err("Non-ID register(index:%d, name: %s) found in idregs table!\n",
+				i, id_reg_descs[i].name);
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
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
2.40.1.495.gc816e09b53d-goog


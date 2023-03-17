Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277176BE072
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 06:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCQFGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 01:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjCQFGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 01:06:49 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3308A4A1E7
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:48 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id e8-20020a17090a118800b0023d35ae431eso1840055pja.8
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679029607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RuRhuab5NHh6jdquqFeN+zZbgdXrSF9RmQxZ9t9e3LY=;
        b=KA14W5qmmIRQTJN4Voj4DlKGiiH9FnRzPrtb3AU+BUWgS/cfFw1WWeoHsN5c0t1qJK
         LegrY15yg4rKxarAcgoB287PSDz4fjM7ZsiGGr3tgco/JIGN7u6FL2wS3ELnEvGb/3WJ
         9W5/OAPTmjIAHHYNoLTc/mxpBu0L37GrHLgz5m7VcPh9TO3EuaRQHNPvQ4x4O6GFpHFr
         RWfz32bnvQK4RN9eJn4LJyr2xjr4ydoZVNoB/qYBuTzE1FV6vqeZ9SuqmGWZznqoTSNj
         f1InBT+5MvG4xTbUxfmFzSByP0ahIhpCgXnXnKmWGB0+S0BE0fJ8Lzbpo9QsS5cB3oPs
         +lIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679029607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RuRhuab5NHh6jdquqFeN+zZbgdXrSF9RmQxZ9t9e3LY=;
        b=bv5dT83v/NljyNkgvhLtD+Qgyx7vTpTT7eF1C5PM1dKJg/VrBq6B9qJm+30v/Z6EnL
         3ULmZf/n1Hbg/FcHy0CA17RZulp4LcsjQAEFIrd6h8rHrxhfVxXQ8SCS2FgqSH1KVMOF
         dfxyEIu0E5swPIJs0zWKgEunffR95Ybq7epBnhkxusTSVgLm7h8S0+yS91qigc1UhPRe
         yL0NeDDWgUCzYzlF5RuUj5BJ6J9BcIX9ZmggHujDSNKtqbfrHsO2VVs9MRpExRyibc1d
         ycxfTBvCD4XnnqbSgzc5x8ehKS3lYgJYSMMQqHcnbvIerWiuJZ3sUy3d1Xoh0OJpvNva
         hUxA==
X-Gm-Message-State: AO0yUKUQJ8JT8M8cALVm5kRZgGFdCGIEB3hkt3ejCuumEyeSGGHnurHm
        3YjXTRlzM8lTXkQZZsHZCcrXZzUMz7D7FcSxUmHu6Vjd+zP98u5APEsMpD2yHEMG3QIrKott2bp
        9pLc1eKOegtyXoezCjlQqVRYfig8FbVquy5BmAowQqcDalraZzBK5Z1vknsX+qmZC3DE1bJg=
X-Google-Smtp-Source: AK7set+9JvZdD/7XS+6rY8t6RIow6Q6uj5u+3/IXKHFcsW/cp9TrWnV6fizperVFTxTGIyxZGtx85W8ItIsNTRweXQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a65:5306:0:b0:502:e1c4:d37b with SMTP
 id m6-20020a655306000000b00502e1c4d37bmr1599137pgq.12.1679029607543; Thu, 16
 Mar 2023 22:06:47 -0700 (PDT)
Date:   Fri, 17 Mar 2023 05:06:33 +0000
In-Reply-To: <20230317050637.766317-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230317050637.766317-3-jingzhangos@google.com>
Subject: [PATCH v4 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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
 arch/arm64/include/asm/kvm_host.h | 11 ++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/id_regs.c          | 44 ++++++++++++++++++++++++-------
 arch/arm64/kvm/sys_regs.c         |  2 +-
 arch/arm64/kvm/sys_regs.h         |  1 +
 5 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a1892a8f6032..fb6b50b1f111 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -245,6 +245,15 @@ struct kvm_arch {
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
+	u64 id_regs[KVM_ARM_ID_REG_NUM];
 };
 
 struct kvm_vcpu_fault_info {
@@ -1005,6 +1014,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
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
index 08b738852955..e393b5730557 100644
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
+	u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
 
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
@@ -504,3 +505,28 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
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
+		kvm->arch.id_regs[IDREG_IDX(id)] = val;
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b60474fcab..3243c924527e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -354,7 +354,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index ad41305348f7..ee136ba28fa5 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -261,6 +261,7 @@ int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 bool kvm_arm_check_idreg_table(void);
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
+u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
-- 
2.40.0.rc1.284.g88254d51c5-goog


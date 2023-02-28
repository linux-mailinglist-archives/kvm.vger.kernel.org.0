Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F8E6A52EA
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 07:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjB1GXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 01:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1GXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 01:23:14 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9455CA5E8
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:13 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id in9-20020a17090b438900b00237161acdfcso2561290pjb.1
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1N+wNKgMEQeF/0JUqt/FeBuHIyXrfSFPh0v72H54JA=;
        b=UgEQmFvCC3SWFzVPXUbXRrgpls9/kYYeFWNzNoNjnwjl9aRmwCkM/owwyKCxp4xO4M
         oTCn2QGw3Ne6YJ712A8joKHynMA+mwwpCz5yDJUQk9AsJ5ftC1lgRwgTcBa+wqOf8zm5
         u5UFT+4O2RbKqnMoe/UN7rq2Q4awTwp3SxtvsF154IB0lFITwS736gxrD1UrDheDsGz/
         i6MV8GStSOE6D5h+ZcnefI31kVX+0iCf4rUBOpruJKKmBdZRH11khBBRM/vxbOA9tTm/
         Sx9NtoO/IYz1i85jivjgO0eJGJdrwWXhJVloJtCnNRKKRJhvbXFqohAdj4Lo3vbH4tWM
         KXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/1N+wNKgMEQeF/0JUqt/FeBuHIyXrfSFPh0v72H54JA=;
        b=6zu77HJlRJf0pR2ugXS88Bf/lQo8kSEuVLlEYImxMnR37zsIKlvIjrmG/aWqwvs81a
         c/rZMyRp9JVnTR/K4mEk6JnfUS2gorJsM8h3Y0OX7CDoPyiVhRNCTxBSYX1pJ8+SUDwB
         mtUkHtc4jmhx4w/2wZCIFjBNgzts7q3vELjDLxNcyp3GnXCcQu0+e5hEgWOVkFjPMosy
         V//8enkL048x26J78CJFNIQvQXn6khKpG1wbmgUXfnpshCCA21E+PhBteChMDOsGG6B4
         iKyrjnLcUznEi+conAUWa7PK4zaywxEjMqtpb/s0iWV9VhpV5YCfXqlnQ4Rcit9+gSo5
         zR4w==
X-Gm-Message-State: AO0yUKV+M4eJCdnzasU0Jz4bHRtZP86uLruy1/csKLHab64+M8lIqO52
        W0Aa1OqYxJFdTXVGFlbKAuSJkFSNRFvEmoHrBE9eKYDfPdsd1y9k2sOxm1oNz9YeT5YxnEOvX9+
        YbFU/cD+Ir7NZL9v8B/ITxeQa/PDTY7yYEFD7zQC6yX6kQYEv/kIIthCpccgjkLg20s1JcOI=
X-Google-Smtp-Source: AK7set8lkYKW0pmCt/E52l5BPx7z+xbdDWF4dAye332cJRd4n2xTgNdL3Mu6TVqPKhe1KP+0QMzER1fcFPknI2oJxw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a62:868f:0:b0:5da:cbe6:c0fb with SMTP
 id x137-20020a62868f000000b005dacbe6c0fbmr566325pfd.4.1677565392990; Mon, 27
 Feb 2023 22:23:12 -0800 (PST)
Date:   Tue, 28 Feb 2023 06:22:42 +0000
In-Reply-To: <20230228062246.1222387-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228062246.1222387-3-jingzhangos@google.com>
Subject: [PATCH v3 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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
 arch/arm64/include/asm/kvm_host.h | 12 +++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/id_regs.c          | 44 ++++++++++++++++++++++++-------
 arch/arm64/kvm/sys_regs.c         |  2 +-
 arch/arm64/kvm/sys_regs.h         |  1 +
 5 files changed, 50 insertions(+), 10 deletions(-)

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
index 08b738852955..811f01361d12 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -52,16 +52,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
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
+	return kvm_arm_read_id_reg_with_encoding(vcpu, reg_to_encoding(r));
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
+		IDREG(kvm, id) = val;
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b60474fcab..568ebc0fb15c 100644
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
index ad41305348f7..9231d89889c7 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -261,6 +261,7 @@ int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 bool kvm_arm_check_idreg_table(void);
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
+u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
-- 
2.39.2.722.g9855ee24e9-goog


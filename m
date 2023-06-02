Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FC871F75F
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbjFBAva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbjFBAv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:51:26 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF257F2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 17:51:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-256a45c6389so580753a91.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 17:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667085; x=1688259085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kg7uaoAK4bQT2tKsp4ZqVoj31EN4GRxWyNGcj0TnQnY=;
        b=7nq1AAr8pDfixD3Hq0HFhNUQi1tJr0lCjdpHWTF6jK8GZcjxMnmKEk5FPw3Qo19HwX
         D2msppwMoGgtqgLn8lC3PSP4CE9tIH/z7klQskyuICkGgNqYcfgUdOvHNtywQbFG9/1t
         VjrJ3AvBRXAEnN59DnXnwkS44gKFU7Bks+oJZFd4bP8aBAs9FginJDMgpzoJy8cUKpPb
         YqSoyVbRB0JCCBHXo1dB15VreJObljE7bMhS8DrREKykEuiVb5EwIg5/8Xm6xwsl04oB
         ux8cC3WkcxeUZExg2kkKp7FY69VNSaiywuyU4eG7G7E1KK0SzoVuX4QS5p0b9Y0PJBOe
         Qxug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667085; x=1688259085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kg7uaoAK4bQT2tKsp4ZqVoj31EN4GRxWyNGcj0TnQnY=;
        b=SjYo4tJCpatB1SnFtOxkPg4YCeZwkyHs9oYr3pNehCNv4v+455EIauGBfH+/mAy8yK
         s650iXmSbhGNDUFeXOdHUl/YvsZg3gl5Tly5eQus8QizvMcHc4A+sI1oIPDKCVbZJ10h
         mNJtsyJxH6xvaGraOLi19eJcmClfl5auN+x2m2as7i/rs9rJ2cuMNkskHnoIelnik3QG
         xUfqmHHiEfnuu6fziriALqOu7S4XcJKuRIruSNYznd4fDxVJvUwLmhSlX3OhBti54rpa
         k+s5IS2nK3LsCxLop3aC3Brd6nY/3jQYbbh4nVeYTMmJZoxuBJzgXrihYOuHsYkwaG0i
         oXDA==
X-Gm-Message-State: AC+VfDxI2x+Imcc/Sa5Yq5WYMMxawhB3gn8j8vcKijqI0Gsv7pgRkaWc
        8OmwGhRk2e+1FPTZAlxFSw/unEUGZ86dS66o07S4YwrWNluH04tWbKFfjZlC/PLtudORIMAEHsT
        0GQ1rgW5UoAUsqArFvY1bxmIjc2SxdjTyXyHdNRCcfHAUup9WUAoWLhZNlJCm+XIMHnUVuOM=
X-Google-Smtp-Source: ACHHUZ5uf09YxU3CLVC0EfBn09+vMrrcdNwwyvHYI+ZrH5XfcCUWhzbUNdU3p/t5W2WpwavTeRyXM6+mVNL5QxJOmw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:df08:b0:250:7ed2:b61a with
 SMTP id gp8-20020a17090adf0800b002507ed2b61amr210142pjb.9.1685667085128; Thu,
 01 Jun 2023 17:51:25 -0700 (PDT)
Date:   Fri,  2 Jun 2023 00:51:14 +0000
In-Reply-To: <20230602005118.2899664-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230602005118.2899664-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602005118.2899664-3-jingzhangos@google.com>
Subject: [PATCH v11 2/5] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
userspace can be stored in its corresponding ID register.

The setting of CSV bits for protected VMs are removed according to the
discussion from Fuad below:
https://lore.kernel.org/all/CA+EHjTwXA9TprX4jeG+-D+c8v9XG+oFdU1o6TSkvVye145_OvA@mail.gmail.com

Besides the removal of CSV bits setting for protected VMs and using
kvm_arch.config_lock to guard VM-scope idreg accesses, no other
functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/arm.c              | 17 ---------
 arch/arm64/kvm/sys_regs.c         | 57 +++++++++++++++++++++++++------
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 069606170c82..8a2fde6c04c4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -257,8 +257,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 774656a0718d..5114521ace60 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -102,22 +102,6 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
-static void set_default_spectre(struct kvm *kvm)
-{
-	/*
-	 * The default is to expose CSV2 == 1 if the HW isn't affected.
-	 * Although this is a per-CPU feature, we make it global because
-	 * asymmetric systems are just a nuisance.
-	 *
-	 * Userspace can override this as long as it doesn't promise
-	 * the impossible.
-	 */
-	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv2 = 1;
-	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv3 = 1;
-}
-
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -161,7 +145,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_init_id_regs(kvm);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 40a9315015af..f043811a6725 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1218,10 +1218,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -1359,6 +1355,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	u64 new_val = val;
 	u8 csv2, csv3;
 
 	/*
@@ -1384,9 +1381,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
-
+	IDREG(vcpu->kvm, reg_to_encoding(rd)) = new_val;
 	return 0;
 }
 
@@ -1472,9 +1467,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 /*
  * cpufeature ID register user accessors
  *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
+ * For now, only some registers or some part of registers are mutable for
+ * userspace. For those registers immutable for userspace, in set_id_reg()
+ * we don't allow the effective value to be changed.
  */
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 *val)
@@ -3177,6 +3172,9 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	if (!r || sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
+	if (is_id_reg(reg_to_encoding(r)))
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+
 	if (r->get_user) {
 		ret = (r->get_user)(vcpu, r, &val);
 	} else {
@@ -3184,6 +3182,9 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 		ret = 0;
 	}
 
+	if (is_id_reg(reg_to_encoding(r)))
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+
 	if (!ret)
 		ret = put_user(val, uaddr);
 
@@ -3221,9 +3222,20 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	if (!r || sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
+	/* Only allow userspace to change the idregs before VM running */
+	if (is_id_reg(reg_to_encoding(r)) && kvm_vm_has_ran_once(vcpu->kvm)) {
+		if (val == read_id_reg(vcpu, r))
+			return 0;
+		return -EBUSY;
+	}
+
 	if (sysreg_user_write_ignore(vcpu, r))
 		return 0;
 
+	/* ID regs are global to the VM and cannot be updated concurrently */
+	if (is_id_reg(reg_to_encoding(r)))
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+
 	if (r->set_user) {
 		ret = (r->set_user)(vcpu, r, val);
 	} else {
@@ -3231,6 +3243,9 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 		ret = 0;
 	}
 
+	if (is_id_reg(reg_to_encoding(r)))
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+
 	return ret;
 }
 
@@ -3366,6 +3381,7 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 {
 	const struct sys_reg_desc *idreg = first_idreg;
 	u32 id = reg_to_encoding(idreg);
+	u64 val;
 
 	/* Initialize all idregs */
 	while (is_id_reg(id)) {
@@ -3380,6 +3396,27 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		idreg++;
 		id = reg_to_encoding(idreg);
 	}
+
+	/*
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
+	 */
+	val = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
+
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
+	}
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
+	}
+
+	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
 }
 
 int __init kvm_sys_reg_table_init(void)
-- 
2.41.0.rc0.172.g3f132b7071-goog


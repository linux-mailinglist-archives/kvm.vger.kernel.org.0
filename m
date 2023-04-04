Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DAA6D5753
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbjDDDx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbjDDDxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:53:52 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371A71BFA
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 20:53:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id kw3-20020a170902f90300b001a274ccf620so9809554plb.8
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 20:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680580430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r7KopWmYgyG4BAc+t+TUqSjsoZRF/OiyVXJKVfWzjBw=;
        b=OLLiGafTEdYL4TSKQEHA6AYvywRSeEepjdPEn0iGMi0PEKNXCzxQWO8ZbP39vUNJ7T
         20Em4PCqH6goIRH6yjJj5RyHWwcQwnJj3P3ws3g8PoVo9LeJxGI15G6s+ziX8HrdlGVL
         z5YJoxxnYNDYGvKER6+xbemad8z03T83rpnxAOLyjhjC0HjpSbfPt6enCFKErHgXnHaI
         UBPwXzvVt1hF8C/Fa4TqIkdmHm2Ue9LoBSlaGbJ41lShou/mqWMNHqGZoYR6fSb8MiZO
         u/YAaBz1rPMI2jUkqGVWNFhKpyp5PgWQ0nhaBrSVdpKJin6bf+IKFgao+tYNZw2kj6GV
         S0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680580430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r7KopWmYgyG4BAc+t+TUqSjsoZRF/OiyVXJKVfWzjBw=;
        b=ZwBfKXZyMTWeA44SyvedbPCguBohiocL1TDV7Vlaa+B/2Gp8SpRd5V7i8+AZVnNe2W
         IgcQ5JL+966Il7i02dOE0Vq8l5+lhu3CHYnxNMPskUwObAJp10B/Pu0q5Yy5hSRkFhfE
         +oi/59lskKL5K2NgiTI/o0hCCKZ1vjaMTB82kNymf4E2/tC40sKVYgfjgVHhPBsHyaqi
         bSt8ro5L+SS/OTrS+3tT08YqBonPgAzNXJJYeU7d67cGosRipgl6liDmiM2+3HXPYTH0
         jt8si7oIMWeVuHOdZkLNK5u+c2NkjN1+fqBpXNF05gQqlqg/2WnXIJoevS/v/E6v6nr4
         0krg==
X-Gm-Message-State: AAQBX9cIqAX6gJY+vbzGhq5W7x92jXdixwW2s2zrBVGgDHc7+6pLxfER
        hMdNrlfrOk2HqrF2y+ag5+L552YjienDnM+w5ZHQW9QcSzfvl+WuQ0jTXAR6ZA/IWyT4wRlNjGc
        KEm7w1A4Aa/xLdIjVV0kJ6a0mX1tqDVfIhONiYsSXUz3rh0PstWdhaRMjC6RhQLpJF5y+S0g=
X-Google-Smtp-Source: AKy350bES0q7q4KRfGnqjoT5tfES1v3mONDsYd8FiEgJfCaMqRs3OddDnqdCV7myHwitWydGnR9vZ0dRz0cO316YYw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:453:b0:1a2:6e4d:782c with SMTP
 id iw19-20020a170903045300b001a26e4d782cmr431274plb.13.1680580430672; Mon, 03
 Apr 2023 20:53:50 -0700 (PDT)
Date:   Tue,  4 Apr 2023 03:53:40 +0000
In-Reply-To: <20230404035344.4043856-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230404035344.4043856-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404035344.4043856-3-jingzhangos@google.com>
Subject: [PATCH v6 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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

Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
and save ID registers' sanitized value in the array at KVM_CREATE_VM.
Use the saved ones when ID registers are read by the guest or
userspace (via KVM_GET_ONE_REG).

No functional change intended.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 21 +++++++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/id_regs.c          | 49 +++++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.c         |  2 +-
 arch/arm64/kvm/sys_regs.h         |  3 +-
 5 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..f0588bdce0ef 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -177,6 +177,22 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap;
 };
 
+/*
+ * Emualted CPU ID registers per VM
+ * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
+ * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
+ *
+ * These emulated idregs are VM-wide, but accessed from the context of a vCPU.
+ * Updating multiple id regs with dependencies needs to be guarded by
+ * kvm_arch.config_lock.
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
@@ -243,6 +259,9 @@ struct kvm_arch {
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
+	/* Emulated CPU ID registers */
+	struct kvm_idregs idregs;
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
@@ -1008,6 +1027,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+void kvm_arm_init_id_regs(struct kvm *kvm);
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..1bf6030c8946 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -153,6 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
+	kvm_arm_init_id_regs(kvm);
 
 	/*
 	 * Initialise the default PMUver before there is a chance to
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 96b4c43a5100..7e78957085fc 100644
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
+		IDREG(kvm, id) = val;
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d16213adc07b..15979c2b87ab 100644
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
2.40.0.348.gf938b09366-goog


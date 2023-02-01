Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6040685D88
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 03:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjBACvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 21:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjBACvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 21:51:42 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3D93B3C1
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:51:41 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u15-20020a170902a60f00b00194d7d89168so9255290plq.10
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 18:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jtA8OJbXoe0QFW21mEwKtvXGHpBgnZe8L3qzReVjKUA=;
        b=fXhhMzOwr3O8t7BTYHm6r+S8OYvBdR5e23axs9ydQrZLDuRrtsEcC9WN1XNkFH2rWT
         amAnslZyg0UvJYOxuIdorLuWvurkkJsK13o8aV3N+ryHgZoVudjgOxkBpMAVDE/e4amb
         eEToFfW9YWOdngPLol95yHqDQ3b3Ppzo+VcQjK1nMOu0jByqHKz8dtZj8v8z00Y0M5ky
         1dC3MZTwf6PhFemMBE9oXTHhAwecmZeoeGlRk40bB8Fp07T9r/pEa6TR8KiZraM5L/L1
         t3uwkiT8irpHqk6eIXzK58tH5e15mzz8MJGR6BdIRhP6VgF3Pw0HEsbtDXj8rZp08hHI
         2HRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jtA8OJbXoe0QFW21mEwKtvXGHpBgnZe8L3qzReVjKUA=;
        b=rrB62HQg7IU1CQmWHFVv8E2kn3t7lZlhB6DlTQ24o2c3EvNc6qYyYNMp6tlwRt75DO
         9Raodo6QPoSo9bmOJJ6fIabEvRywkiyCvMbW/adxsUpPXY2smO3pZjVW/NuzNNZNvZX1
         KC5BFC86/5gj6K5wy3hXq9jvyAHcUXMlOKMskE3Rz+c+MoFsk0Asf8MY64Q8HCf2zEUr
         eK12WUP/iX7NFpl3KcOGpWFds0SoUTazNV31Y+mE/GbJbV1Ew4jEiZ2otrq+uac8uB3N
         5tHkFYRhReaC2DXyp5PN3bUx5Zfp0v+SqPM7XCyM06HHNweFuMFp8qeI1LkEsctDax5i
         EqCw==
X-Gm-Message-State: AO0yUKWZbFo4uZZBxZJpFaz1Bb+fU9+TjRwc9WxSr218BgzAiWCIiiuu
        p9PfcjdtLL0juQqpn9kwZGR98he4oIeDIiCzF0KsqPIxhDmYOaRYvXfPaqGPO0X1U4zNTSl0W3p
        n7csBETU897dTz9OnuE7itl/9MloJ3idUykquVVPbcM0Ch91DfhhbVZ6Nx0RcHGNiPfTucBM=
X-Google-Smtp-Source: AK7set/iZnCZiaWSDZD4YPdKBK98pfHE92kCKD48HnVnF5FD/69mopaG2vFmhcK4wXYYXo99CDCTOcty5ugXK3Mgnw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:74cf:b0:22c:dfb:a9da with SMTP
 id p15-20020a17090a74cf00b0022c0dfba9damr84622pjl.115.1675219901051; Tue, 31
 Jan 2023 18:51:41 -0800 (PST)
Date:   Wed,  1 Feb 2023 02:50:45 +0000
In-Reply-To: <20230201025048.205820-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201025048.205820-4-jingzhangos@google.com>
Subject: [PATCH v1 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
userspace can be stored in its corresponding ID register.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h  |  3 +--
 arch/arm64/kvm/arm.c               | 19 +------------------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 +++----
 arch/arm64/kvm/id_regs.c           | 30 ++++++++++++++++++++++--------
 4 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b1beef93465c..fabb30185a4a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -225,8 +225,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
@@ -249,6 +247,7 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	56
 #define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
 #define IDREG(kvm, id)		kvm->arch.id_regs[IDREG_IDX(id)]
+#define IDREG_RD(kvm, rd)	IDREG(kvm, reg_to_encoding(rd))
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d525b71d0523..d8ba5106bf51 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -104,22 +104,6 @@ static int kvm_arm_default_max_vcpus(void)
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
@@ -151,9 +135,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_spectre(kvm);
-	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_set_default_id_regs(kvm);
+	kvm_arm_init_hypercalls(kvm);
 
 	/*
 	 * Initialise the default PMUver before there is a chance to
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 0f9ac25afdf4..03919d342136 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -92,10 +92,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
 	/* Spectre and Meltdown mitigation in KVM */
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-			       (u64)kvm->arch.pfr0_csv2);
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-			       (u64)kvm->arch.pfr0_csv3);
+	set_mask |= IDREG(kvm, SYS_ID_AA64PFR0_EL1) &
+		(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
+			ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
 
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index f53ce00ab14d..bc5d9bc84eb1 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -71,12 +71,6 @@ u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-				  (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-				  (u64)vcpu->kvm->arch.pfr0_csv3);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -208,6 +202,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       u64 val)
 {
 	u8 csv2, csv3;
+	u64 sval = val;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -232,8 +227,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
+	IDREG_RD(vcpu->kvm, rd) = sval;
 
 	return 0;
 }
@@ -516,4 +510,24 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 		val = read_sanitised_ftr_reg(id);
 		IDREG(kvm, id) = val;
 	}
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
-- 
2.39.1.456.gfc5497dd1b-goog


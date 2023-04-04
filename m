Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24386D5754
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbjDDDx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbjDDDxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:53:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC815170F
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 20:53:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u11-20020a170902e80b00b001a043e84bdfso18876409plg.23
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 20:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680580432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ch2U6ty5T88f6V+9FBCOXhicmZ9im9bNn2G5dyREKis=;
        b=RjhcCYGcjCoxFOs5DfLqev0wiGdzTo8vNHS9AzyWFfMTH6Tk1W/8LvP08ZpPWjeYQ+
         0XZKHjvv0gbYPyfDOeaJ+TCM/mciFWkDxaMbCDPazjTX4NhF/rFbbrJ+IA130sjS9kFl
         fuhJhZ+j5zI1aaOnsstRPZiuevTVlXAkP25mnSe3UuC2Cxptl0F5SGW2HCOi2RxddrqD
         1n1KyNBdcx9Pjdt55OcKnO+OtqEvcmrGfYtgPmHBglSpxPPunN7o3bFugPiWtNOVTO3p
         e0So8X7Ddxmga7tSuwEh6NmHgVTMLHVYzlGwsZ9Fj5Nj4ejAMHszuwGvwwLQOqFlRC6z
         gEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680580432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ch2U6ty5T88f6V+9FBCOXhicmZ9im9bNn2G5dyREKis=;
        b=ydu0/48g0lvKBZJBBRplKgROVnkmWrSud5XvQrNYRHMjcac062auGIMjMeQU473wG7
         jpNAvlMazfdRE/lvqeJ+FyDGiab+D7MBI3fnuan1Fvoe0FdRE8K8MjJ50VP8cCb7BpZ/
         Ok8piw2/K1PN3AGyttTm8N4nYkumSooSTy8XufWJ2q0sEwQX+VWaCBH0EFOqnn9onpVC
         iAywRhXDW07ZS4U8v7VyKsoewpy4orXGNk0mbj6lCdGqtIZGj3I9xFZ+5RF7DulqFSwp
         deUluA6VLd3a2a2CuitaVc5HAtQuMsoQvm1kT+XoeHbMcFSuuaFWvOjD2CKn/xoKjdKr
         t4Lg==
X-Gm-Message-State: AAQBX9eG3m5XAqQk+kfMSOMqzqRrNxkxH0o/+m/iYS/8vSGaS5KruS2p
        OIyJuu8DZfld2rCMoHQQaDHsCKfOgyqTCQMMGidBGi7F8AiPSJSFE/ocHCQkoN6M35lIijFi1eg
        A7EL8bEKFbmXFtOzKmPn/O4WIppKYo9VqnWvmbscQ7Y4tC/M4foovrMAAZVGXVFjFrdj1d0k=
X-Google-Smtp-Source: AKy350bC9EBmTtP3WYLQhME9KL1kMRqt87S77bP1xkusAE+BQVKa+ZJbiI3D1jBcTT4yXwcaE5kvVJgjryd7sC+8Dw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:e09:b0:240:228:95bd with SMTP
 id ge9-20020a17090b0e0900b00240022895bdmr402042pjb.5.1680580432236; Mon, 03
 Apr 2023 20:53:52 -0700 (PDT)
Date:   Tue,  4 Apr 2023 03:53:41 +0000
In-Reply-To: <20230404035344.4043856-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230404035344.4043856-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404035344.4043856-4-jingzhangos@google.com>
Subject: [PATCH v6 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
userspace can be stored in its corresponding ID register.

The setting of CSV bits for protected VMs are removed according to the
discussion from Fuad below:
https://lore.kernel.org/all/CA+EHjTwXA9TprX4jeG+-D+c8v9XG+oFdU1o6TSkvVye145_OvA@mail.gmail.com

Besides the removal of CSV bits setting for protected VMs, No other
functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h  |  2 --
 arch/arm64/kvm/arm.c               | 17 ----------------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 -------
 arch/arm64/kvm/id_regs.c           | 31 ++++++++++++++++++++++--------
 4 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f0588bdce0ef..67a55177fd83 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -249,8 +249,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1bf6030c8946..64e1c19e5a9b 100644
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
@@ -151,7 +135,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_init_id_regs(kvm);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 08d2b004f4b7..edd969a1f36b 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -85,19 +85,12 @@ static u64 get_restricted_features_unsigned(u64 sys_reg_val,
 
 static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 {
-	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
 	u64 set_mask = 0;
 	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
 
 	set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
-	/* Spectre and Meltdown mitigation in KVM */
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-			       (u64)kvm->arch.pfr0_csv2);
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-			       (u64)kvm->arch.pfr0_csv3);
-
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
 
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 7e78957085fc..291311b1ecca 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -61,12 +61,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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
@@ -201,6 +195,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       u64 val)
 {
 	u8 csv2, csv3;
+	u64 sval = val;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -223,8 +218,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
+	IDREG(vcpu->kvm, reg_to_encoding(rd)) = sval;
 
 	return 0;
 }
@@ -488,4 +482,25 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		val = read_sanitised_ftr_reg(id);
 		IDREG(kvm, id) = val;
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
-- 
2.40.0.348.gf938b09366-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9406D5752
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjDDDxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjDDDxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:53:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48093170F
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 20:53:49 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q30-20020a631f5e000000b0050760997f4dso9006257pgm.6
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 20:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680580429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g5e5aq/SDnjZSdu2JuzM6VSXHf19dOEcCJ7wBTJg2AA=;
        b=K+Q/hFVPYlFGKkhdpEMHlZZ17x6gY+hJHoP1K7DpRad9DChqxK0PqkCqguoNQfKWQb
         Q7qRN7DdLmSd2LbR2CGbo4uWVDIsRqOz+j/Hi2XAfEHxe/Xjwx3Z6iqJg3Nd3lRyclB2
         drGzszs5iS9yM/Ud5K4mUEiEhDc75eAg0EoA5MwfEIcm4wLpQv4S7O7echzPOw22qFnt
         wjm0RKCECrSZ+HXOpYIB5mwdv5whkd+n61m9ANCfdjYS5NMeS5Vf3A5RPZVjXPPKJPEw
         jBwHuHnJdIs631uPpXAz1qNly8+fD8jsRi4pRBmMrBpYBcevpa9Nqp8zPqAeWUIq2M9t
         6gOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680580429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g5e5aq/SDnjZSdu2JuzM6VSXHf19dOEcCJ7wBTJg2AA=;
        b=WOEQfmgYkH8SGxhfaWoypU5tGce0ow+qF1YPXekWaqPCa5vV7edYuKhhlM70n+O646
         HNexDvhv7pr+XfNKJRZK7F8HnNd6jnVDKGNbidjrvkY6T4uAYu1kUlfA7TyJyNKGQ08i
         ZVO7MqeTRBaypAI8eMqShqq8PcZMiTWEdD6rjNot45PGz9vxyDPJK25JffCHzgl7E9Ov
         pJWsZduaQaHeBQsbJo16rMwenupcrX2vUxkfOXY2O8AfWTUiOJPKOj8m6NbvrXNsZEKE
         LgzQNlt4l5/mJNJqGJsmfAxTFInZzg5+OtCieg3T9hlQk/hfCbSK10kDfqEXoTlAuQST
         yJUg==
X-Gm-Message-State: AAQBX9ctyA2dI7BzeU8oDOVG0yi39H7eo1uXrag4JwAcujbNPNL6bmIG
        DI8o41K5Kw7P7N2AB4EHQmi2oqEBjsTCbVM6cfiVUSiQF8UHYkShyQ21CfTJYlVkThoi0iT2yK6
        thHudGWToZp/n6xJVUQq6qMCSQp0YIBR0K3OUAE6r2J8E2OX/DtKfrl9EWl7f1fakwGRclEE=
X-Google-Smtp-Source: AKy350ZTxK4oUObBxU0o4hYCt3g2ZzvOeFpfF63lEJlCkR9vYyA2xU7364XOHBRpLfw43w1Co3IBCccDR/eLe694KQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:fa05:0:b0:50b:eb56:b675 with SMTP
 id y5-20020a63fa05000000b0050beb56b675mr252670pgh.7.1680580428566; Mon, 03
 Apr 2023 20:53:48 -0700 (PDT)
Date:   Tue,  4 Apr 2023 03:53:39 +0000
In-Reply-To: <20230404035344.4043856-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230404035344.4043856-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404035344.4043856-2-jingzhangos@google.com>
Subject: [PATCH v6 1/6] KVM: arm64: Move CPU ID feature registers emulation
 into a separate file
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

Create a new file id_regs.c for CPU ID feature registers emulation code,
which are moved from sys_regs.c and tweak sys_regs code accordingly.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/Makefile   |   2 +-
 arch/arm64/kvm/id_regs.c  | 460 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c | 464 ++++----------------------------------
 arch/arm64/kvm/sys_regs.h |  19 ++
 4 files changed, 519 insertions(+), 426 deletions(-)
 create mode 100644 arch/arm64/kvm/id_regs.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index c0c050e53157..a6a315fcd81e 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_KVM) += hyp/
 kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
-	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
+	 vgic-sys-reg-v3.o fpsimd.o pkvm.o id_regs.o \
 	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
new file mode 100644
index 000000000000..96b4c43a5100
--- /dev/null
+++ b/arch/arm64/kvm/id_regs.c
@@ -0,0 +1,460 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 - Google LLC
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * Moved from arch/arm64/kvm/sys_regs.c
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bsearch.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
+#include <asm/sysreg.h>
+#include <asm/cpufeature.h>
+#include <asm/kvm_nested.h>
+
+#include "sys_regs.h"
+
+static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_has_pmu(vcpu))
+		return vcpu->kvm->arch.dfr0_pmuver.imp;
+
+	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+}
+
+static u8 perfmon_to_pmuver(u8 perfmon)
+{
+	switch (perfmon) {
+	case ID_DFR0_EL1_PerfMon_PMUv3:
+		return ID_AA64DFR0_EL1_PMUVer_IMP;
+	case ID_DFR0_EL1_PerfMon_IMPDEF:
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
+	default:
+		/* Anything ARMv8.1+ and NI have the same value. For now. */
+		return perfmon;
+	}
+}
+
+static u8 pmuver_to_perfmon(u8 pmuver)
+{
+	switch (pmuver) {
+	case ID_AA64DFR0_EL1_PMUVer_IMP:
+		return ID_DFR0_EL1_PerfMon_PMUv3;
+	case ID_AA64DFR0_EL1_PMUVer_IMP_DEF:
+		return ID_DFR0_EL1_PerfMon_IMPDEF;
+	default:
+		/* Anything ARMv8.1+ and NI have the same value. For now. */
+		return pmuver;
+	}
+}
+
+/* Read a sanitised cpufeature ID register by sys_reg_desc */
+static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
+{
+	u32 id = reg_to_encoding(r);
+	u64 val;
+
+	if (sysreg_visible_as_raz(vcpu, r))
+		return 0;
+
+	val = read_sanitised_ftr_reg(id);
+
+	switch (id) {
+	case SYS_ID_AA64PFR0_EL1:
+		if (!vcpu_has_sve(vcpu))
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
+				  (u64)vcpu->kvm->arch.pfr0_csv2);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
+				  (u64)vcpu->kvm->arch.pfr0_csv3);
+		if (kvm_vgic_global_state.type == VGIC_V3) {
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
+			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
+		}
+		break;
+	case SYS_ID_AA64PFR1_EL1:
+		if (!kvm_has_mte(vcpu->kvm))
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
+
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
+		break;
+	case SYS_ID_AA64ISAR1_EL1:
+		if (!vcpu_has_ptrauth(vcpu))
+			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI));
+		break;
+	case SYS_ID_AA64ISAR2_EL1:
+		if (!vcpu_has_ptrauth(vcpu))
+			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
+		if (!cpus_have_final_cap(ARM64_HAS_WFXT))
+			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
+		break;
+	case SYS_ID_AA64DFR0_EL1:
+		/* Limit debug to ARMv8.0 */
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
+		/* Set PMUver to the required version */
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				  vcpu_pmuver(vcpu));
+		/* Hide SPE from guests */
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
+		break;
+	case SYS_ID_DFR0_EL1:
+		val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
+				  pmuver_to_perfmon(vcpu_pmuver(vcpu)));
+		break;
+	case SYS_ID_AA64MMFR2_EL1:
+		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+		break;
+	case SYS_ID_MMFR4_EL1:
+		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
+		break;
+	}
+
+	return val;
+}
+
+/* cpufeature ID register access trap handlers */
+
+static bool access_id_reg(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = read_id_reg(vcpu, r);
+	if (vcpu_has_nv(vcpu))
+		access_nested_id_reg(vcpu, p, r);
+
+	return true;
+}
+
+/*
+ * cpufeature ID register user accessors
+ *
+ * For now, these registers are immutable for userspace, so no values
+ * are stored, and for set_id_reg() we don't allow the effective value
+ * to be changed.
+ */
+static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		      u64 *val)
+{
+	*val = read_id_reg(vcpu, rd);
+	return 0;
+}
+
+static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		      u64 val)
+{
+	/* This is what we mean by invariant: you can't change it. */
+	if (val != read_id_reg(vcpu, rd))
+		return -EINVAL;
+
+	return 0;
+}
+
+static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
+				  const struct sys_reg_desc *r)
+{
+	u32 id = reg_to_encoding(r);
+
+	switch (id) {
+	case SYS_ID_AA64ZFR0_EL1:
+		if (!vcpu_has_sve(vcpu))
+			return REG_RAZ;
+		break;
+	}
+
+	return 0;
+}
+
+static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *r)
+{
+	/*
+	 * AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any
+	 * EL. Promote to RAZ/WI in order to guarantee consistency between
+	 * systems.
+	 */
+	if (!kvm_supports_32bit_el0())
+		return REG_RAZ | REG_USER_WI;
+
+	return id_visibility(vcpu, r);
+}
+
+static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 val)
+{
+	u8 csv2, csv3;
+
+	/*
+	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
+	 * it doesn't promise more than what is actually provided (the
+	 * guest could otherwise be covered in ectoplasmic residue).
+	 */
+	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV2_SHIFT);
+	if (csv2 > 1 || (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
+		return -EINVAL;
+
+	/* Same thing for CSV3 */
+	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV3_SHIFT);
+	if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
+		return -EINVAL;
+
+	/* We can only differ with CSV[23], and anything else is an error */
+	val ^= read_id_reg(vcpu, rd);
+	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
+		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
+	if (val)
+		return -EINVAL;
+
+	vcpu->kvm->arch.pfr0_csv2 = csv2;
+	vcpu->kvm->arch.pfr0_csv3 = csv3;
+
+	return 0;
+}
+
+static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 val)
+{
+	u8 pmuver, host_pmuver;
+	bool valid_pmu;
+
+	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
+
+	/*
+	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
+	 * as it doesn't promise more than what the HW gives us. We
+	 * allow an IMPDEF PMU though, only if no PMU is supported
+	 * (KVM backward compatibility handling).
+	 */
+	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
+	if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver))
+		return -EINVAL;
+
+	valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+
+	/* Make sure view register and PMU support do match */
+	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
+		return -EINVAL;
+
+	/* We can only differ with PMUver, and anything else is an error */
+	val ^= read_id_reg(vcpu, rd);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	if (val)
+		return -EINVAL;
+
+	if (valid_pmu)
+		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
+	else
+		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+
+	return 0;
+}
+
+static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
+			   const struct sys_reg_desc *rd,
+			   u64 val)
+{
+	u8 perfmon, host_perfmon;
+	bool valid_pmu;
+
+	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
+
+	/*
+	 * Allow DFR0_EL1.PerfMon to be set from userspace as long as
+	 * it doesn't promise more than what the HW gives us on the
+	 * AArch64 side (as everything is emulated with that), and
+	 * that this is a PMUv3.
+	 */
+	perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), val);
+	if ((perfmon != ID_DFR0_EL1_PerfMon_IMPDEF && perfmon > host_perfmon) ||
+	    (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3))
+		return -EINVAL;
+
+	valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_EL1_PerfMon_IMPDEF);
+
+	/* Make sure view register and PMU support do match */
+	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
+		return -EINVAL;
+
+	/* We can only differ with PerfMon, and anything else is an error */
+	val ^= read_id_reg(vcpu, rd);
+	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+	if (val)
+		return -EINVAL;
+
+	if (valid_pmu)
+		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
+	else
+		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+
+	return 0;
+}
+
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define ID_SANITISED(name) {			\
+	SYS_DESC(SYS_##name),			\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
+}
+
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define AA32_ID_SANITISED(name) {		\
+	SYS_DESC(SYS_##name),			\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = aa32_id_visibility,	\
+}
+
+/*
+ * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
+ * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
+ * (1 <= crm < 8, 0 <= Op2 < 8).
+ */
+#define ID_UNALLOCATED(crm, op2) {			\
+	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
+	.access = access_id_reg,			\
+	.get_user = get_id_reg,				\
+	.set_user = set_id_reg,				\
+	.visibility = raz_visibility			\
+}
+
+/*
+ * sys_reg_desc initialiser for known ID registers that we hide from guests.
+ * For now, these are exposed just like unallocated ID regs: they appear
+ * RAZ for the guest.
+ */
+#define ID_HIDDEN(name) {			\
+	SYS_DESC(SYS_##name),			\
+	.access = access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = raz_visibility,		\
+}
+
+const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
+	/*
+	 * ID regs: all ID_SANITISED() entries here must have corresponding
+	 * entries in arm64_ftr_regs[].
+	 */
+
+	/* AArch64 mappings of the AArch32 ID registers */
+	/* CRm=1 */
+	AA32_ID_SANITISED(ID_PFR0_EL1),
+	AA32_ID_SANITISED(ID_PFR1_EL1),
+	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
+	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
+	  .visibility = aa32_id_visibility, },
+	ID_HIDDEN(ID_AFR0_EL1),
+	AA32_ID_SANITISED(ID_MMFR0_EL1),
+	AA32_ID_SANITISED(ID_MMFR1_EL1),
+	AA32_ID_SANITISED(ID_MMFR2_EL1),
+	AA32_ID_SANITISED(ID_MMFR3_EL1),
+
+	/* CRm=2 */
+	AA32_ID_SANITISED(ID_ISAR0_EL1),
+	AA32_ID_SANITISED(ID_ISAR1_EL1),
+	AA32_ID_SANITISED(ID_ISAR2_EL1),
+	AA32_ID_SANITISED(ID_ISAR3_EL1),
+	AA32_ID_SANITISED(ID_ISAR4_EL1),
+	AA32_ID_SANITISED(ID_ISAR5_EL1),
+	AA32_ID_SANITISED(ID_MMFR4_EL1),
+	AA32_ID_SANITISED(ID_ISAR6_EL1),
+
+	/* CRm=3 */
+	AA32_ID_SANITISED(MVFR0_EL1),
+	AA32_ID_SANITISED(MVFR1_EL1),
+	AA32_ID_SANITISED(MVFR2_EL1),
+	ID_UNALLOCATED(3, 3),
+	AA32_ID_SANITISED(ID_PFR2_EL1),
+	ID_HIDDEN(ID_DFR1_EL1),
+	AA32_ID_SANITISED(ID_MMFR5_EL1),
+	ID_UNALLOCATED(3, 7),
+
+	/* AArch64 ID registers */
+	/* CRm=4 */
+	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
+	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	ID_SANITISED(ID_AA64PFR1_EL1),
+	ID_UNALLOCATED(4, 2),
+	ID_UNALLOCATED(4, 3),
+	ID_SANITISED(ID_AA64ZFR0_EL1),
+	ID_HIDDEN(ID_AA64SMFR0_EL1),
+	ID_UNALLOCATED(4, 6),
+	ID_UNALLOCATED(4, 7),
+
+	/* CRm=5 */
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
+	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
+	ID_SANITISED(ID_AA64DFR1_EL1),
+	ID_UNALLOCATED(5, 2),
+	ID_UNALLOCATED(5, 3),
+	ID_HIDDEN(ID_AA64AFR0_EL1),
+	ID_HIDDEN(ID_AA64AFR1_EL1),
+	ID_UNALLOCATED(5, 6),
+	ID_UNALLOCATED(5, 7),
+
+	/* CRm=6 */
+	ID_SANITISED(ID_AA64ISAR0_EL1),
+	ID_SANITISED(ID_AA64ISAR1_EL1),
+	ID_SANITISED(ID_AA64ISAR2_EL1),
+	ID_UNALLOCATED(6, 3),
+	ID_UNALLOCATED(6, 4),
+	ID_UNALLOCATED(6, 5),
+	ID_UNALLOCATED(6, 6),
+	ID_UNALLOCATED(6, 7),
+
+	/* CRm=7 */
+	ID_SANITISED(ID_AA64MMFR0_EL1),
+	ID_SANITISED(ID_AA64MMFR1_EL1),
+	ID_SANITISED(ID_AA64MMFR2_EL1),
+	ID_UNALLOCATED(7, 3),
+	ID_UNALLOCATED(7, 4),
+	ID_UNALLOCATED(7, 5),
+	ID_UNALLOCATED(7, 6),
+	ID_UNALLOCATED(7, 7),
+};
+
+/**
+ * emulate_id_reg - Emulate a guest access to an AArch64 CPU ID feature register
+ * @vcpu: The VCPU pointer
+ * @params: Decoded system register parameters
+ *
+ * Return: true if the ID register access was successful, false otherwise.
+ */
+int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
+{
+	const struct sys_reg_desc *r;
+
+	r = find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs));
+
+	if (likely(r)) {
+		perform_access(vcpu, params, r);
+	} else {
+		print_sys_reg_msg(params,
+				  "Unsupported guest id_reg access at: %lx [%08lx]\n",
+				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
+		kvm_inject_undefined(vcpu);
+	}
+
+	return 1;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b2c161120be..d16213adc07b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -53,9 +53,9 @@ static bool read_from_write_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-static bool write_to_read_only(struct kvm_vcpu *vcpu,
-			       struct sys_reg_params *params,
-			       const struct sys_reg_desc *r)
+bool write_to_read_only(struct kvm_vcpu *vcpu,
+			struct sys_reg_params *params,
+			const struct sys_reg_desc *r)
 {
 	WARN_ONCE(1, "Unexpected sys_reg write to read-only register\n");
 	print_sys_reg_instr(params);
@@ -1169,163 +1169,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
-{
-	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
-
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
-}
-
-static u8 perfmon_to_pmuver(u8 perfmon)
-{
-	switch (perfmon) {
-	case ID_DFR0_EL1_PerfMon_PMUv3:
-		return ID_AA64DFR0_EL1_PMUVer_IMP;
-	case ID_DFR0_EL1_PerfMon_IMPDEF:
-		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
-	default:
-		/* Anything ARMv8.1+ and NI have the same value. For now. */
-		return perfmon;
-	}
-}
-
-static u8 pmuver_to_perfmon(u8 pmuver)
-{
-	switch (pmuver) {
-	case ID_AA64DFR0_EL1_PMUVer_IMP:
-		return ID_DFR0_EL1_PerfMon_PMUv3;
-	case ID_AA64DFR0_EL1_PMUVer_IMP_DEF:
-		return ID_DFR0_EL1_PerfMon_IMPDEF;
-	default:
-		/* Anything ARMv8.1+ and NI have the same value. For now. */
-		return pmuver;
-	}
-}
-
-/* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
-{
-	u32 id = reg_to_encoding(r);
-	u64 val;
-
-	if (sysreg_visible_as_raz(vcpu, r))
-		return 0;
-
-	val = read_sanitised_ftr_reg(id);
-
-	switch (id) {
-	case SYS_ID_AA64PFR0_EL1:
-		if (!vcpu_has_sve(vcpu))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
-		if (kvm_vgic_global_state.type == VGIC_V3) {
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
-		}
-		break;
-	case SYS_ID_AA64PFR1_EL1:
-		if (!kvm_has_mte(vcpu->kvm))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
-
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
-		break;
-	case SYS_ID_AA64ISAR1_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI));
-		break;
-	case SYS_ID_AA64ISAR2_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
-		if (!cpus_have_final_cap(ARM64_HAS_WFXT))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
-		break;
-	case SYS_ID_AA64DFR0_EL1:
-		/* Limit debug to ARMv8.0 */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
-		/* Set PMUver to the required version */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
-				  vcpu_pmuver(vcpu));
-		/* Hide SPE from guests */
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
-		break;
-	case SYS_ID_DFR0_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
-				  pmuver_to_perfmon(vcpu_pmuver(vcpu)));
-		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
-	case SYS_ID_MMFR4_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
-		break;
-	}
-
-	return val;
-}
-
-static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
-				  const struct sys_reg_desc *r)
-{
-	u32 id = reg_to_encoding(r);
-
-	switch (id) {
-	case SYS_ID_AA64ZFR0_EL1:
-		if (!vcpu_has_sve(vcpu))
-			return REG_RAZ;
-		break;
-	}
-
-	return 0;
-}
-
-static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
-				       const struct sys_reg_desc *r)
-{
-	/*
-	 * AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any
-	 * EL. Promote to RAZ/WI in order to guarantee consistency between
-	 * systems.
-	 */
-	if (!kvm_supports_32bit_el0())
-		return REG_RAZ | REG_USER_WI;
-
-	return id_visibility(vcpu, r);
-}
-
-static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
-				   const struct sys_reg_desc *r)
+unsigned int raz_visibility(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	return REG_RAZ;
 }
 
-/* cpufeature ID register access trap handlers */
-
-static bool access_id_reg(struct kvm_vcpu *vcpu,
-			  struct sys_reg_params *p,
-			  const struct sys_reg_desc *r)
-{
-	if (p->is_write)
-		return write_to_read_only(vcpu, p, r);
-
-	p->regval = read_id_reg(vcpu, r);
-	if (vcpu_has_nv(vcpu))
-		access_nested_id_reg(vcpu, p, r);
-
-	return true;
-}
-
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -1336,144 +1184,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
-			       const struct sys_reg_desc *rd,
-			       u64 val)
-{
-	u8 csv2, csv3;
-
-	/*
-	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
-	 * it doesn't promise more than what is actually provided (the
-	 * guest could otherwise be covered in ectoplasmic residue).
-	 */
-	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV2_SHIFT);
-	if (csv2 > 1 ||
-	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* Same thing for CSV3 */
-	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV3_SHIFT);
-	if (csv3 > 1 ||
-	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
-		return -EINVAL;
-
-	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
-		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val)
-		return -EINVAL;
-
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
-
-	return 0;
-}
-
-static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
-			       const struct sys_reg_desc *rd,
-			       u64 val)
-{
-	u8 pmuver, host_pmuver;
-	bool valid_pmu;
-
-	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
-
-	/*
-	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
-	 * as it doesn't promise more than what the HW gives us. We
-	 * allow an IMPDEF PMU though, only if no PMU is supported
-	 * (KVM backward compatibility handling).
-	 */
-	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
-	if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver))
-		return -EINVAL;
-
-	valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
-
-	/* Make sure view register and PMU support do match */
-	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
-		return -EINVAL;
-
-	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
-
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
-
-	return 0;
-}
-
-static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
-			   const struct sys_reg_desc *rd,
-			   u64 val)
-{
-	u8 perfmon, host_perfmon;
-	bool valid_pmu;
-
-	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
-
-	/*
-	 * Allow DFR0_EL1.PerfMon to be set from userspace as long as
-	 * it doesn't promise more than what the HW gives us on the
-	 * AArch64 side (as everything is emulated with that), and
-	 * that this is a PMUv3.
-	 */
-	perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), val);
-	if ((perfmon != ID_DFR0_EL1_PerfMon_IMPDEF && perfmon > host_perfmon) ||
-	    (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3))
-		return -EINVAL;
-
-	valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_EL1_PerfMon_IMPDEF);
-
-	/* Make sure view register and PMU support do match */
-	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
-		return -EINVAL;
-
-	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
-	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
-
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
-
-	return 0;
-}
-
-/*
- * cpufeature ID register user accessors
- *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
- */
-static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		      u64 *val)
-{
-	*val = read_id_reg(vcpu, rd);
-	return 0;
-}
-
-static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		      u64 val)
-{
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		       u64 *val)
 {
@@ -1658,50 +1368,6 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
 	.visibility = elx2_visibility,		\
 }
 
-/* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
-}
-
-/* sys_reg_desc initialiser for known cpufeature ID registers */
-#define AA32_ID_SANITISED(name) {		\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = aa32_id_visibility,	\
-}
-
-/*
- * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
- * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
- * (1 <= crm < 8, 0 <= Op2 < 8).
- */
-#define ID_UNALLOCATED(crm, op2) {			\
-	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
-	.access = access_id_reg,			\
-	.get_user = get_id_reg,				\
-	.set_user = set_id_reg,				\
-	.visibility = raz_visibility			\
-}
-
-/*
- * sys_reg_desc initialiser for known ID registers that we hide from guests.
- * For now, these are exposed just like unallocated ID regs: they appear
- * RAZ for the guest.
- */
-#define ID_HIDDEN(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access = access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = raz_visibility,		\
-}
-
 static bool access_sp_el1(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
@@ -1738,6 +1404,8 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+extern const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM];
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -1792,87 +1460,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
 
-	/*
-	 * ID regs: all ID_SANITISED() entries here must have corresponding
-	 * entries in arm64_ftr_regs[].
-	 */
-
-	/* AArch64 mappings of the AArch32 ID registers */
-	/* CRm=1 */
-	AA32_ID_SANITISED(ID_PFR0_EL1),
-	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility, },
-	ID_HIDDEN(ID_AFR0_EL1),
-	AA32_ID_SANITISED(ID_MMFR0_EL1),
-	AA32_ID_SANITISED(ID_MMFR1_EL1),
-	AA32_ID_SANITISED(ID_MMFR2_EL1),
-	AA32_ID_SANITISED(ID_MMFR3_EL1),
-
-	/* CRm=2 */
-	AA32_ID_SANITISED(ID_ISAR0_EL1),
-	AA32_ID_SANITISED(ID_ISAR1_EL1),
-	AA32_ID_SANITISED(ID_ISAR2_EL1),
-	AA32_ID_SANITISED(ID_ISAR3_EL1),
-	AA32_ID_SANITISED(ID_ISAR4_EL1),
-	AA32_ID_SANITISED(ID_ISAR5_EL1),
-	AA32_ID_SANITISED(ID_MMFR4_EL1),
-	AA32_ID_SANITISED(ID_ISAR6_EL1),
-
-	/* CRm=3 */
-	AA32_ID_SANITISED(MVFR0_EL1),
-	AA32_ID_SANITISED(MVFR1_EL1),
-	AA32_ID_SANITISED(MVFR2_EL1),
-	ID_UNALLOCATED(3,3),
-	AA32_ID_SANITISED(ID_PFR2_EL1),
-	ID_HIDDEN(ID_DFR1_EL1),
-	AA32_ID_SANITISED(ID_MMFR5_EL1),
-	ID_UNALLOCATED(3,7),
-
-	/* AArch64 ID registers */
-	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
-	ID_SANITISED(ID_AA64PFR1_EL1),
-	ID_UNALLOCATED(4,2),
-	ID_UNALLOCATED(4,3),
-	ID_SANITISED(ID_AA64ZFR0_EL1),
-	ID_HIDDEN(ID_AA64SMFR0_EL1),
-	ID_UNALLOCATED(4,6),
-	ID_UNALLOCATED(4,7),
-
-	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
-	ID_SANITISED(ID_AA64DFR1_EL1),
-	ID_UNALLOCATED(5,2),
-	ID_UNALLOCATED(5,3),
-	ID_HIDDEN(ID_AA64AFR0_EL1),
-	ID_HIDDEN(ID_AA64AFR1_EL1),
-	ID_UNALLOCATED(5,6),
-	ID_UNALLOCATED(5,7),
-
-	/* CRm=6 */
-	ID_SANITISED(ID_AA64ISAR0_EL1),
-	ID_SANITISED(ID_AA64ISAR1_EL1),
-	ID_SANITISED(ID_AA64ISAR2_EL1),
-	ID_UNALLOCATED(6,3),
-	ID_UNALLOCATED(6,4),
-	ID_UNALLOCATED(6,5),
-	ID_UNALLOCATED(6,6),
-	ID_UNALLOCATED(6,7),
-
-	/* CRm=7 */
-	ID_SANITISED(ID_AA64MMFR0_EL1),
-	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
-	ID_UNALLOCATED(7,3),
-	ID_UNALLOCATED(7,4),
-	ID_UNALLOCATED(7,5),
-	ID_UNALLOCATED(7,6),
-	ID_UNALLOCATED(7,7),
-
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
@@ -2574,7 +2161,7 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static void perform_access(struct kvm_vcpu *vcpu,
+void perform_access(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params,
 			   const struct sys_reg_desc *r)
 {
@@ -2949,6 +2536,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
+	if (is_id_reg(reg_to_encoding(&params)))
+		return emulate_id_reg(vcpu, &params);
+
 	if (!emulate_sys_reg(vcpu, &params))
 		return 1;
 
@@ -3168,6 +2758,7 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	struct sys_reg_params params;
 	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
@@ -3177,6 +2768,13 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (err != -ENOENT)
 		return err;
 
+	if (!index_to_params(reg->id, &params))
+		return -ENOENT;
+
+	if (is_id_reg(reg_to_encoding(&params)))
+		return kvm_sys_reg_get_user(vcpu, reg,
+					    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+
 	return kvm_sys_reg_get_user(vcpu, reg,
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
@@ -3212,6 +2810,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	struct sys_reg_params params;
 	int err;
 
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
@@ -3221,6 +2820,13 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (err != -ENOENT)
 		return err;
 
+	if (!index_to_params(reg->id, &params))
+		return -ENOENT;
+
+	if (is_id_reg(reg_to_encoding(&params)))
+		return kvm_sys_reg_set_user(vcpu, reg,
+					    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+
 	return kvm_sys_reg_set_user(vcpu, reg,
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
@@ -3290,14 +2896,15 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 }
 
 /* Assumed ordered tables, see kvm_sys_reg_table_init. */
-static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
+static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind,
+			 const struct sys_reg_desc table[], unsigned int num)
 {
 	const struct sys_reg_desc *i2, *end2;
 	unsigned int total = 0;
 	int err;
 
-	i2 = sys_reg_descs;
-	end2 = sys_reg_descs + ARRAY_SIZE(sys_reg_descs);
+	i2 = table;
+	end2 = table + num;
 
 	while (i2 != end2) {
 		err = walk_one_sys_reg(vcpu, i2++, &uind, &total);
@@ -3311,7 +2918,8 @@ unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
 {
 	return ARRAY_SIZE(invariant_sys_regs)
 		+ num_demux_regs()
-		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
+		+ walk_sys_regs(vcpu, (u64 __user *)NULL, id_reg_descs, ARRAY_SIZE(id_reg_descs))
+		+ walk_sys_regs(vcpu, (u64 __user *)NULL, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
 
 int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
@@ -3326,7 +2934,12 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		uindices++;
 	}
 
-	err = walk_sys_regs(vcpu, uindices);
+	err = walk_sys_regs(vcpu, uindices, id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	if (err < 0)
+		return err;
+	uindices += err;
+
+	err = walk_sys_regs(vcpu, uindices, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 	if (err < 0)
 		return err;
 	uindices += err;
@@ -3340,6 +2953,7 @@ int __init kvm_sys_reg_table_init(void)
 	unsigned int i;
 
 	/* Make sure tables are unique and in order. */
+	valid &= check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_descs), false);
 	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
 	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true);
 	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true);
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 6b11f2cc7146..7ce546a8be60 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -210,6 +210,19 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
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
+void perform_access(struct kvm_vcpu *vcpu, struct sys_reg_params *params,
+		    const struct sys_reg_desc *r);
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
@@ -220,6 +233,10 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 			 const struct sys_reg_desc table[], unsigned int num);
 int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 			 const struct sys_reg_desc table[], unsigned int num);
+bool write_to_read_only(struct kvm_vcpu *vcpu,
+			struct sys_reg_params *params, const struct sys_reg_desc *r);
+unsigned int raz_visibility(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *r);
+int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
@@ -234,4 +251,6 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
+#define KVM_ARM_ID_REG_NUM	56
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.40.0.348.gf938b09366-goog


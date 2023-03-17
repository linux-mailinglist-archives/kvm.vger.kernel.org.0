Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2536BE073
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 06:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCQFGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 01:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjCQFGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 01:06:50 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AC843904
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m9-20020a17090a7f8900b0023769205928so3550986pjl.6
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679029606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QHHnLNrs+JVSlnbuECYVEYVT7+1L+l7HidxlmtUcdy0=;
        b=ftrB7zuCVYwAGnUMYnyY/tEPYloZmBfbZqAPNb8C4y94YZFGiOeWKteTHl0pJj45jk
         YD2ho7zWilLzG5rJHH27sw4aP23YQt74poTpGtN9FTKoW8rYvyoF7kSb0RLMhBNgoVGD
         9WQLm2CcWQVlUPQXQUzE01RshJitfpuDPngreS2pEpUbZrQj5NqszQ/ofG+w50I/A7jh
         QPEB8BgCJWkAZegBZLWHhHScP8eAIPomN/uecA9RbJfDnk2jVQrd/vBkTbHqtHXtfAOc
         XTrEtEM8gp8nMSSnmIGkGX32fKM+n/6cVPGADcGM+6utIrCsUt2+g6aFGGONJOjPLkcU
         ppPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679029606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QHHnLNrs+JVSlnbuECYVEYVT7+1L+l7HidxlmtUcdy0=;
        b=hFwaWFHRvKiYTlmBW3taxAAlyOP/B1YYE5rV0pcE1+Jlvcd/kzjcYpXNDOQcaudQFw
         CZPVpmfyvnZeBzFu91/CiGtGY5HvYnl8KCP7Ih7fRiZUBSbxMz9k12AgLrIsey0t/A68
         ejY4QkrBie2hX0FT5KJs6Md1MyosMj8EIdBlzNZPvMtapOBSzG7yxsRPuWdI9hTF2HJ9
         WqPs8zRuAcMOdAESKa6BrqdvNRYP9B/DhNlsDveZyuklzZLivgWgGpwgKXeb2TVytWAZ
         sFzoBbc5BQXqqHjRduydjJdk59awtYOzalmTYfJm/qPV5T5CGIpZVYOsC6FeT4n7FXjo
         XNOA==
X-Gm-Message-State: AO0yUKUWrvh9XTUdZHhzDe69zygi9HmU4hBW/JxjvlBYJD07MStGHBXe
        jjDzQfbMJYvD4K13iEOLHsCa32WxGf52i/qGoqi0GBxmTCQCy7aTzINyNibzVfKQJvAW7WN+dky
        JGq94frI16Irkv6trMOeAWITux8XDZ0Upl+AscJSAPwROm2NrSTlHkO2yefEta4rfG3I9So8=
X-Google-Smtp-Source: AK7set+vSm9T6H3E7NAkWbJJ97pe/c0QSOA25B8OmFibLFOcPq2CZcJylh8x3Jq9Ba8DULJzKEI5yxPk456AtpGC4w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a65:47cb:0:b0:503:7cc9:3f8d with SMTP
 id f11-20020a6547cb000000b005037cc93f8dmr1563486pgs.9.1679029605653; Thu, 16
 Mar 2023 22:06:45 -0700 (PDT)
Date:   Fri, 17 Mar 2023 05:06:32 +0000
In-Reply-To: <20230317050637.766317-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230317050637.766317-2-jingzhangos@google.com>
Subject: [PATCH v4 1/6] KVM: arm64: Move CPU ID feature registers emulation
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

Create a new file id_regs.c for CPU ID feature registers emulation code,
which are moved from sys_regs.c and tweak sys_regs code accordingly.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/Makefile   |   2 +-
 arch/arm64/kvm/id_regs.c  | 506 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c | 464 ++--------------------------------
 arch/arm64/kvm/sys_regs.h |  41 +++
 4 files changed, 575 insertions(+), 438 deletions(-)
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
index 000000000000..08b738852955
--- /dev/null
+++ b/arch/arm64/kvm/id_regs.c
@@ -0,0 +1,506 @@
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
+	if (csv2 > 1 ||
+	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
+		return -EINVAL;
+
+	/* Same thing for CSV3 */
+	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_EL1_CSV3_SHIFT);
+	if (csv3 > 1 ||
+	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
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
+static const struct sys_reg_desc id_reg_descs[] = {
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
+
+
+void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
+{
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++)
+		if (id_reg_descs[i].reset)
+			id_reg_descs[i].reset(vcpu, &id_reg_descs[i]);
+}
+
+int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	return kvm_sys_reg_get_user(vcpu, reg,
+				    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+}
+
+int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	return kvm_sys_reg_set_user(vcpu, reg,
+				    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+}
+
+bool kvm_arm_check_idreg_table(void)
+{
+	return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_descs), false);
+}
+
+int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
+{
+	const struct sys_reg_desc *i2, *end2;
+	unsigned int total = 0;
+	int err;
+
+	i2 = id_reg_descs;
+	end2 = id_reg_descs + ARRAY_SIZE(id_reg_descs);
+
+	while (i2 != end2) {
+		err = walk_one_sys_reg(vcpu, i2++, &uind, &total);
+		if (err)
+			return err;
+	}
+	return total;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 53749d3a0996..22b60474fcab 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -53,16 +53,6 @@ static bool read_from_write_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-static bool write_to_read_only(struct kvm_vcpu *vcpu,
-			       struct sys_reg_params *params,
-			       const struct sys_reg_desc *r)
-{
-	WARN_ONCE(1, "Unexpected sys_reg write to read-only register\n");
-	print_sys_reg_instr(params);
-	kvm_inject_undefined(vcpu);
-	return false;
-}
-
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
 	u64 val = 0x8badf00d8badf00d;
@@ -1153,163 +1143,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
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
-{
-	return REG_RAZ;
-}
-
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
@@ -1320,144 +1153,6 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
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
@@ -1642,50 +1337,6 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
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
@@ -1776,87 +1427,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
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
@@ -2531,8 +2101,8 @@ static const struct sys_reg_desc cp15_64_regs[] = {
 	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
 };
 
-static bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
-			       bool is_32)
+bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
+			bool is_32)
 {
 	unsigned int i;
 
@@ -2557,7 +2127,7 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static void perform_access(struct kvm_vcpu *vcpu,
+void perform_access(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params,
 			   const struct sys_reg_desc *r)
 {
@@ -2912,6 +2482,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
 	unsigned long i;
 
+	kvm_arm_reset_id_regs(vcpu);
+
 	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++)
 		if (sys_reg_descs[i].reset)
 			sys_reg_descs[i].reset(vcpu, &sys_reg_descs[i]);
@@ -2932,6 +2504,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
+	if (is_id_reg(reg_to_encoding(&params)))
+		return emulate_id_reg(vcpu, &params);
+
 	if (!emulate_sys_reg(vcpu, &params))
 		return 1;
 
@@ -3160,6 +2735,10 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (err != -ENOENT)
 		return err;
 
+	err = kvm_arm_get_id_reg(vcpu, reg);
+	if (err != -ENOENT)
+		return err;
+
 	return kvm_sys_reg_get_user(vcpu, reg,
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
@@ -3204,6 +2783,10 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (err != -ENOENT)
 		return err;
 
+	err = kvm_arm_set_id_reg(vcpu, reg);
+	if (err != -ENOENT)
+		return err;
+
 	return kvm_sys_reg_set_user(vcpu, reg,
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
@@ -3250,10 +2833,10 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 	return true;
 }
 
-static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
-			    const struct sys_reg_desc *rd,
-			    u64 __user **uind,
-			    unsigned int *total)
+int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
+		     const struct sys_reg_desc *rd,
+		     u64 __user **uind,
+		     unsigned int *total)
 {
 	/*
 	 * Ignore registers we trap but don't save,
@@ -3294,6 +2877,7 @@ unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
 {
 	return ARRAY_SIZE(invariant_sys_regs)
 		+ num_demux_regs()
+		+ kvm_arm_walk_id_regs(vcpu, (u64 __user *)NULL)
 		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
 }
 
@@ -3309,6 +2893,11 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		uindices++;
 	}
 
+	err = kvm_arm_walk_id_regs(vcpu, uindices);
+	if (err < 0)
+		return err;
+	uindices += err;
+
 	err = walk_sys_regs(vcpu, uindices);
 	if (err < 0)
 		return err;
@@ -3323,6 +2912,7 @@ int __init kvm_sys_reg_table_init(void)
 	unsigned int i;
 
 	/* Make sure tables are unique and in order. */
+	valid &= kvm_arm_check_idreg_table();
 	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
 	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true);
 	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true);
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 6b11f2cc7146..ad41305348f7 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -210,6 +210,35 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
+static inline unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *r)
+{
+	return REG_RAZ;
+}
+
+static inline bool write_to_read_only(struct kvm_vcpu *vcpu,
+				      struct sys_reg_params *params,
+				      const struct sys_reg_desc *r)
+{
+	WARN_ONCE(1, "Unexpected sys_reg write to read-only register\n");
+	print_sys_reg_instr(params);
+	kvm_inject_undefined(vcpu);
+	return false;
+}
+
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
@@ -220,6 +249,18 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 			 const struct sys_reg_desc table[], unsigned int num);
 int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 			 const struct sys_reg_desc table[], unsigned int num);
+bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
+			bool is_32);
+int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
+		     const struct sys_reg_desc *rd,
+		     u64 __user **uind,
+		     unsigned int *total);
+int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
+void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu);
+int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+bool kvm_arm_check_idreg_table(void);
+int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
-- 
2.40.0.rc1.284.g88254d51c5-goog


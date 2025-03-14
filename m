Return-Path: <kvm+bounces-41121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF51EA6207C
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 23:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0261C4213A1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 22:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E9F204F7D;
	Fri, 14 Mar 2025 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="suFrm8Z6"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACFF2046A3
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991678; cv=none; b=DhbZMFJrLd0I4a+1ROoJIzJt8WyWjzVeTtpyKR8RdtM/wZAYJUuY+Z8QtFwjc5oVcM116J/wb7cISQONFZdFx3p+x97jFkBoGPBNgD1MhIaIhTjGSDIwZnzidvZ8v71IElR4QGaarVC4OjCCq5hQxANSSWnHiFOzYQlYW+bXsug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991678; c=relaxed/simple;
	bh=Kv+wIpmkYHOLsd48IMZhJuVzIIq0z0EnikylGYYxls8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=POVbGxUOOEpnQ3jU083RB90p06OH2Ex9b7+shHAABLe5LvC268/5s+wMUYs/89JKd0sDAhQjMFkiKStG55ygKREiI2aWqH5G8++pro0uy+V4HO4z7L4P7wIoMMQN49a7OXuLCJFixJjwjbWRM74OfBtbVCMqBii4IJ8GM+CKGrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=suFrm8Z6; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a17R8BEJCwzwp3PK3WwO4SOam+pAI/yQQ/+ddO+4/Yw=;
	b=suFrm8Z6Tui3Ls/GoW5WbOHX5dzJqLHsd/T369P69nDHPY3RRaSOulvK0zBcAlDSdzL1bw
	ljAn9JyGChY3tLYakaCTG6T9OAFsmo1581EB3wU40pPEXw91ZR1MznXLYtTLiJtPH1pOi0
	PExnG0iwH04MvXGp9hXTYS5eBsldhLw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 4/9] arm64: Merge kvm-cpu.c
Date: Fri, 14 Mar 2025 15:25:11 -0700
Message-Id: <20250314222516.1302429-5-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As before, glue together the arm64 and ARM generic bits into one file.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Makefile                                      |   1 -
 arm/aarch64/include/kvm/kvm-cpu-arch.h        |  19 -
 arm/aarch64/kvm-cpu.c                         | 330 ------------------
 .../{arm-common => kvm}/kvm-cpu-arch.h        |  10 +-
 arm/kvm-cpu.c                                 | 328 +++++++++++++++++
 5 files changed, 337 insertions(+), 351 deletions(-)
 delete mode 100644 arm/aarch64/include/kvm/kvm-cpu-arch.h
 delete mode 100644 arm/aarch64/kvm-cpu.c
 rename arm/include/{arm-common => kvm}/kvm-cpu-arch.h (82%)

diff --git a/Makefile b/Makefile
index 72027e0..25ee9b0 100644
--- a/Makefile
+++ b/Makefile
@@ -179,7 +179,6 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/timer.o
 	OBJS		+= hw/serial.o
 	OBJS		+= arm/arm-cpu.o
-	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/pvtime.o
 	OBJS		+= arm/pmu.o
 	ARCH_INCLUDE	:= arm/include
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
deleted file mode 100644
index aeae8c1..0000000
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
deleted file mode 100644
index 7b6061a..0000000
diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/kvm/kvm-cpu-arch.h
similarity index 82%
rename from arm/include/arm-common/kvm-cpu-arch.h
rename to arm/include/kvm/kvm-cpu-arch.h
index 923d2c4..1af394a 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/kvm/kvm-cpu-arch.h
@@ -1,11 +1,17 @@
 #ifndef ARM_COMMON__KVM_CPU_ARCH_H
 #define ARM_COMMON__KVM_CPU_ARCH_H
 
+#include "kvm/kvm.h"
+
 #include <linux/kvm.h>
 #include <pthread.h>
 #include <stdbool.h>
 
-struct kvm;
+#define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
+#define ARM_CPU_ID		3, 0, 0, 0
+#define ARM_CPU_ID_MPIDR	5
+#define ARM_CPU_CTRL		3, 0, 1, 0
+#define ARM_CPU_CTRL_SCTLR_EL1	0
 
 struct kvm_cpu {
 	pthread_t	thread;
@@ -58,5 +64,7 @@ static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr,
 }
 
 unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu);
+int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
+int kvm_cpu__teardown_pvtime(struct kvm *kvm);
 
 #endif /* ARM_COMMON__KVM_CPU_ARCH_H */
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index a43eb90..94c08a4 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -1,5 +1,17 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
+#include "kvm/virtio.h"
+
+#include <asm/ptrace.h>
+#include <linux/bitops.h>
+
+#define COMPAT_PSR_F_BIT	0x00000040
+#define COMPAT_PSR_I_BIT	0x00000080
+#define COMPAT_PSR_E_BIT	0x00000200
+#define COMPAT_PSR_MODE_SVC	0x00000013
+
+#define SCTLR_EL1_E0E_MASK	(1 << 24)
+#define SCTLR_EL1_EE_MASK	(1 << 25)
 
 static int debug_fd;
 
@@ -35,6 +47,74 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target)
 	return -ENOSPC;
 }
 
+static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
+{
+	if (kvm->cfg.arch.aarch32_guest) {
+		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
+			die("32bit guests are not supported\n");
+		init->features[0] |= 1UL << KVM_ARM_VCPU_EL1_32BIT;
+	}
+
+	if (kvm->cfg.arch.has_pmuv3) {
+		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3))
+			die("PMUv3 is not supported");
+		init->features[0] |= 1UL << KVM_ARM_VCPU_PMU_V3;
+	}
+
+	/* Enable pointer authentication if available */
+	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
+	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC)) {
+		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS;
+		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC;
+	}
+
+	/* Enable SVE if available */
+	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
+		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
+}
+
+static int vcpu_configure_sve(struct kvm_cpu *vcpu)
+{
+	unsigned int max_vq = vcpu->kvm->cfg.arch.sve_max_vq;
+	int feature = KVM_ARM_VCPU_SVE;
+
+	if (max_vq) {
+		unsigned long vls[KVM_ARM64_SVE_VLS_WORDS];
+		struct kvm_one_reg reg = {
+			.id	= KVM_REG_ARM64_SVE_VLS,
+			.addr	= (u64)&vls,
+		};
+		unsigned int vq;
+
+		if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg))
+			die_perror("KVM_GET_ONE_REG failed (KVM_ARM64_SVE_VLS)");
+
+		if (!test_bit(max_vq - KVM_ARM64_SVE_VQ_MIN, vls))
+			die("SVE vector length (%u) not supported", max_vq * 128);
+
+		for (vq = KVM_ARM64_SVE_VQ_MAX; vq > max_vq; vq--)
+			clear_bit(vq - KVM_ARM64_SVE_VQ_MIN, vls);
+
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+			die_perror("KVM_SET_ONE_REG failed (KVM_ARM64_SVE_VLS)");
+	}
+
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature)) {
+		pr_err("KVM_ARM_VCPU_FINALIZE: %s", strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+{
+	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE))
+		return vcpu_configure_sve(vcpu);
+
+	return 0;
+}
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
 	struct kvm_arm_target *target = NULL;
@@ -151,3 +231,251 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
 }
+
+static __u64 __core_reg_id(__u64 offset)
+{
+	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
+
+	if (offset < KVM_REG_ARM_CORE_REG(fp_regs))
+		id |= KVM_REG_SIZE_U64;
+	else if (offset < KVM_REG_ARM_CORE_REG(fp_regs.fpsr))
+		id |= KVM_REG_SIZE_U128;
+	else
+		id |= KVM_REG_SIZE_U32;
+
+	return id;
+}
+
+#define ARM64_CORE_REG(x) __core_reg_id(KVM_REG_ARM_CORE_REG(x))
+
+unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	u64 mpidr;
+
+	reg.id = ARM64_SYS_REG(ARM_CPU_ID, ARM_CPU_ID_MPIDR);
+	reg.addr = (u64)&mpidr;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (get_mpidr vcpu%ld", vcpu->cpu_id);
+
+	return mpidr;
+}
+
+static void reset_vcpu_aarch32(struct kvm_cpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_one_reg reg;
+	u64 data;
+
+	reg.addr = (u64)&data;
+
+	/* pstate = all interrupts masked */
+	data	= COMPAT_PSR_I_BIT | COMPAT_PSR_F_BIT | COMPAT_PSR_MODE_SVC;
+	reg.id	= ARM64_CORE_REG(regs.pstate);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (spsr[EL1])");
+
+	/* Secondary cores are stopped awaiting PSCI wakeup */
+	if (vcpu->cpu_id != 0)
+		return;
+
+	/* r0 = 0 */
+	data	= 0;
+	reg.id	= ARM64_CORE_REG(regs.regs[0]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (r0)");
+
+	/* r1 = machine type (-1) */
+	data	= -1;
+	reg.id	= ARM64_CORE_REG(regs.regs[1]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (r1)");
+
+	/* r2 = physical address of the device tree blob */
+	data	= kvm->arch.dtb_guest_start;
+	reg.id	= ARM64_CORE_REG(regs.regs[2]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (r2)");
+
+	/* pc = start of kernel image */
+	data	= kvm->arch.kern_guest_start;
+	reg.id	= ARM64_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (pc)");
+}
+
+static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_one_reg reg;
+	u64 data;
+
+	reg.addr = (u64)&data;
+
+	/* pstate = all interrupts masked */
+	data	= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT | PSR_MODE_EL1h;
+	reg.id	= ARM64_CORE_REG(regs.pstate);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (spsr[EL1])");
+
+	/* x1...x3 = 0 */
+	data	= 0;
+	reg.id	= ARM64_CORE_REG(regs.regs[1]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (x1)");
+
+	reg.id	= ARM64_CORE_REG(regs.regs[2]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (x2)");
+
+	reg.id	= ARM64_CORE_REG(regs.regs[3]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (x3)");
+
+	/* Secondary cores are stopped awaiting PSCI wakeup */
+	if (vcpu->cpu_id == 0) {
+		/* x0 = physical address of the device tree blob */
+		data	= kvm->arch.dtb_guest_start;
+		reg.id	= ARM64_CORE_REG(regs.regs[0]);
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+			die_perror("KVM_SET_ONE_REG failed (x0)");
+
+		/* pc = start of kernel image */
+		data	= kvm->arch.kern_guest_start;
+		reg.id	= ARM64_CORE_REG(regs.pc);
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+			die_perror("KVM_SET_ONE_REG failed (pc)");
+	}
+}
+
+int sve_vl_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm *kvm = opt->ptr;
+	unsigned long val;
+	unsigned int vq;
+
+	errno = 0;
+	val = strtoull(arg, NULL, 10);
+	if (errno == ERANGE)
+		die("SVE vector length too large: %s", arg);
+
+	if (!val || (val & (val - 1)))
+		die("SVE vector length isn't power of 2: %s", arg);
+
+	vq = val / 128;
+	if (vq > KVM_ARM64_SVE_VQ_MAX || vq < KVM_ARM64_SVE_VQ_MIN)
+		die("SVE vector length out of range: %s", arg);
+
+	kvm->cfg.arch.sve_max_vq = vq;
+	return 0;
+}
+
+void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	cpu_set_t *affinity;
+	int ret;
+
+	affinity = kvm->arch.vcpu_affinity_cpuset;
+	if (affinity) {
+		ret = sched_setaffinity(0, sizeof(cpu_set_t), affinity);
+		if (ret == -1)
+			die_perror("sched_setaffinity");
+	}
+
+	if (kvm->cfg.arch.aarch32_guest)
+		return reset_vcpu_aarch32(vcpu);
+	else
+		return reset_vcpu_aarch64(vcpu);
+}
+
+int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	u64 psr;
+	u64 sctlr;
+
+	/*
+	 * Quoting the definition given by Peter Maydell:
+	 *
+	 * "Endianness of the CPU which does the virtio reset at the
+	 * point when it does that reset"
+	 *
+	 * We first check for an AArch32 guest: its endianness can
+	 * change when using SETEND, which affects the CPSR.E bit.
+	 *
+	 * If we're AArch64, use SCTLR_EL1.E0E if access comes from
+	 * EL0, and SCTLR_EL1.EE if access comes from EL1.
+	 */
+	reg.id = ARM64_CORE_REG(regs.pstate);
+	reg.addr = (u64)&psr;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (spsr[EL1])");
+
+	if (psr & PSR_MODE32_BIT)
+		return (psr & COMPAT_PSR_E_BIT) ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
+
+	reg.id = ARM64_SYS_REG(ARM_CPU_CTRL, ARM_CPU_CTRL_SCTLR_EL1);
+	reg.addr = (u64)&sctlr;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (SCTLR_EL1)");
+
+	if ((psr & PSR_MODE_MASK) == PSR_MODE_EL0t)
+		sctlr &= SCTLR_EL1_E0E_MASK;
+	else
+		sctlr &= SCTLR_EL1_EE_MASK;
+	return sctlr ? VIRTIO_ENDIAN_BE : VIRTIO_ENDIAN_LE;
+}
+
+void kvm_cpu__show_code(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (u64)&data;
+
+	dprintf(debug_fd, "\n*pc:\n");
+	reg.id = ARM64_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ PC)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
+
+	dprintf(debug_fd, "\n*lr:\n");
+	reg.id = ARM64_CORE_REG(regs.regs[30]);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ LR)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
+}
+
+void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (u64)&data;
+	dprintf(debug_fd, "\n Registers:\n");
+
+	reg.id		= ARM64_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (pc)");
+	dprintf(debug_fd, " PC:    0x%lx\n", data);
+
+	reg.id		= ARM64_CORE_REG(regs.pstate);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (pstate)");
+	dprintf(debug_fd, " PSTATE:    0x%lx\n", data);
+
+	reg.id		= ARM64_CORE_REG(sp_el1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sp_el1)");
+	dprintf(debug_fd, " SP_EL1:    0x%lx\n", data);
+
+	reg.id		= ARM64_CORE_REG(regs.regs[30]);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (lr)");
+	dprintf(debug_fd, " LR:    0x%lx\n", data);
+}
-- 
2.39.5



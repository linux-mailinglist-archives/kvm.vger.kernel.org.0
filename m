Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07869446B67
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 00:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhKFABn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 20:01:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4775 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbhKFABm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 20:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636156740; x=1667692740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oAAklw2+l3Z+7rUkDWJ+Pk60d+W6Gai8Zdl3z5WLmn4=;
  b=lqbP+tyi3LvmxvwPO0IiIEV9Hhm/uty7pc4b4G3htUmi34dpv2l9Z+gV
   O0+9lWosE/B+znoLYjEhheJLPdL7SYhAmzmXJq9BUBPxvBfTMYLloZ6aM
   nHn0LA+LRFS+PtQjeoOtg43heyeQay3ulCqkAime8F9z75R8UEky/iZBC
   q/ZHXK4EoHmUEggjny0xqbTsfNGvnvkuH9AbyFB+Rb003/PgMCN772Ffq
   0OGwwU1IdLI87Bl/cRQAVdyZhMVlTRv44ky9eAch4sUnVvw4zJk0OiQBh
   TXyasiigEPeJDD+QkrseQyTWx/C+MQS5B6EpM9uHf3rSco/mTTN7zfyAv
   w==;
X-IronPort-AV: E=Sophos;i="5.87,212,1631548800"; 
   d="scan'208";a="189637761"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Nov 2021 07:59:00 +0800
IronPort-SDR: 28uVNt3fSJFvL6qMiirJhNGSzWkKUGaPIVTBE9qvZLaTLPYbT7XOSPI4NEdng/AeOnS3VEs4VT
 vYk0ur/2bJzBb6mHOa2H5+IpHTfEsOvEHyWDFqrGkwTnplI4qqPhdhT5A3Yf0Im05r36gVli/0
 RcsIe+VUlrtEAPzYrjTGMoOKu/wD0CnrL5GDWvC/R6POaw7FW0ZmHF2fLvLqR0j/lzNDE22g7z
 iTmYYNrW39ePYS/6K+n7hoz1YaWFgfI03tbNyy0B/OreXmpMEM3aDL70z5dk2QBN0+OeiSqnil
 0d3r408hNRiTocLIeRGpYE6E
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 16:32:46 -0700
IronPort-SDR: 6I4QEXh2k8Tvp4lrFF0q9Fcf6ZEsiD2oVrlSCtYZzXFLRYzcdgtShfxX84k+ulbNGJhE/XVrb6
 ShUzRzKhp0qFva7/JuG0AxkpQMF7jmxY8vbpsvKYcf+HB+6JDMbQ4zIAkbMRzWJ9s3gdHGyD6T
 dwqGTfGH2tgAGNWTzwckIQjx9R3qR7P17IlkbssJUw6etHwU9WHqVjh2ushANW1fkxPzHVp4Bt
 dnikvKdA5ApxHtsoClqFYEehIyRDvA+q5yQkH2ev3Z1e9RYtMnkZPemdO4bePKpqe5BrI0nyP5
 yAs=
WDCIronportException: Internal
Received: from unknown (HELO hulk.wdc.com) ([10.225.167.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Nov 2021 16:59:02 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>, Anup Patel <anup.patel@wdc.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>, pbonzini@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v4 1/5] RISC-V: KVM: Mark the existing SBI implementation as v01
Date:   Fri,  5 Nov 2021 16:58:48 -0700
Message-Id: <20211105235852.3011900-2-atish.patra@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211105235852.3011900-1-atish.patra@wdc.com>
References: <20211105235852.3011900-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing SBI specification impelementation follows v0.1
specification. The latest specification known as v0.2 allows more
scalability and performance improvements.

Rename the existing implementation as v01 and provide a way to allow
future extensions.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  29 +++++
 arch/riscv/kvm/vcpu_sbi.c             | 147 +++++++++++++++++++++-----
 2 files changed, 147 insertions(+), 29 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
new file mode 100644
index 000000000000..1a4cb0db2d0b
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/**
+ * Copyright (c) 2021 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __RISCV_KVM_VCPU_SBI_H__
+#define __RISCV_KVM_VCPU_SBI_H__
+
+#define KVM_SBI_VERSION_MAJOR 0
+#define KVM_SBI_VERSION_MINOR 2
+
+struct kvm_vcpu_sbi_extension {
+	unsigned long extid_start;
+	unsigned long extid_end;
+	/**
+	 * SBI extension handler. It can be defined for a given extension or group of
+	 * extension. But it should always return linux error codes rather than SBI
+	 * specific error codes.
+	 */
+	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
+		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
+		       bool *exit);
+};
+
+const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
+#endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index eb3c045edf11..05cab5f27eee 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -12,9 +12,25 @@
 #include <asm/csr.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_sbi.h>
 
-#define SBI_VERSION_MAJOR			0
-#define SBI_VERSION_MINOR			1
+static int kvm_linux_err_map_sbi(int err)
+{
+	switch (err) {
+	case 0:
+		return SBI_SUCCESS;
+	case -EPERM:
+		return SBI_ERR_DENIED;
+	case -EINVAL:
+		return SBI_ERR_INVALID_PARAM;
+	case -EFAULT:
+		return SBI_ERR_INVALID_ADDRESS;
+	case -EOPNOTSUPP:
+		return SBI_ERR_NOT_SUPPORTED;
+	default:
+		return SBI_ERR_FAILURE;
+	};
+}
 
 static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
 				       struct kvm_run *run)
@@ -72,16 +88,17 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
 	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
-int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				      unsigned long *out_val,
+				      struct kvm_cpu_trap *utrap,
+				      bool *exit)
 {
 	ulong hmask;
-	int i, ret = 1;
+	int i, ret = 0;
 	u64 next_cycle;
 	struct kvm_vcpu *rvcpu;
-	bool next_sepc = true;
 	struct cpumask cm, hm;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_cpu_trap utrap = { 0 };
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 
 	if (!cp)
@@ -95,8 +112,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * handled in kernel so we forward these to user-space
 		 */
 		kvm_riscv_vcpu_sbi_forward(vcpu, run);
-		next_sepc = false;
-		ret = 0;
+		*exit = true;
 		break;
 	case SBI_EXT_0_1_SET_TIMER:
 #if __riscv_xlen == 32
@@ -104,47 +120,42 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 #else
 		next_cycle = (u64)cp->a0;
 #endif
-		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
 		break;
 	case SBI_EXT_0_1_CLEAR_IPI:
-		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
+		ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
 		break;
 	case SBI_EXT_0_1_SEND_IPI:
 		if (cp->a0)
 			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
-							   &utrap);
+							   utrap);
 		else
 			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
-		if (utrap.scause) {
-			utrap.sepc = cp->sepc;
-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-			next_sepc = false;
+		if (utrap->scause)
 			break;
-		}
+
 		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
 			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
-			kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
+			ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
+			if (ret < 0)
+				break;
 		}
 		break;
 	case SBI_EXT_0_1_SHUTDOWN:
 		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
-		next_sepc = false;
-		ret = 0;
+		*exit = true;
 		break;
 	case SBI_EXT_0_1_REMOTE_FENCE_I:
 	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
 	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
 		if (cp->a0)
 			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
-							   &utrap);
+							   utrap);
 		else
 			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
-		if (utrap.scause) {
-			utrap.sepc = cp->sepc;
-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-			next_sepc = false;
+		if (utrap->scause)
 			break;
-		}
+
 		cpumask_clear(&cm);
 		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
 			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
@@ -154,22 +165,100 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		}
 		riscv_cpuid_to_hartid_mask(&cm, &hm);
 		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
-			sbi_remote_fence_i(cpumask_bits(&hm));
+			ret = sbi_remote_fence_i(cpumask_bits(&hm));
 		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
-			sbi_remote_hfence_vvma(cpumask_bits(&hm),
+			ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
 						cp->a1, cp->a2);
 		else
-			sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
+			ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
 						cp->a1, cp->a2, cp->a3);
 		break;
 	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
+	.extid_start = SBI_EXT_0_1_SET_TIMER,
+	.extid_end = SBI_EXT_0_1_SHUTDOWN,
+	.handler = kvm_sbi_ext_v01_handler,
+};
+
+static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
+	&vcpu_sbi_ext_v01,
+};
+
+const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
+{
+	int i = 0;
+
+	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
+		if (sbi_ext[i]->extid_start <= extid &&
+		    sbi_ext[i]->extid_end >= extid)
+			return sbi_ext[i];
+	}
+
+	return NULL;
+}
+
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	int ret = 1;
+	bool next_sepc = true;
+	bool userspace_exit = false;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	const struct kvm_vcpu_sbi_extension *sbi_ext;
+	struct kvm_cpu_trap utrap = { 0 };
+	unsigned long out_val = 0;
+	bool ext_is_v01 = false;
+
+	if (!cp)
+		return -EINVAL;
+
+	sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
+	if (sbi_ext && sbi_ext->handler) {
+		if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
+		    cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
+			ext_is_v01 = true;
+		ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
+	} else {
 		/* Return error for unsupported SBI calls */
 		cp->a0 = SBI_ERR_NOT_SUPPORTED;
-		break;
+		goto ecall_done;
 	}
 
+	/* Handle special error cases i.e trap, exit or userspace forward */
+	if (utrap.scause) {
+		/* No need to increment sepc or exit ioctl loop */
+		ret = 1;
+		utrap.sepc = cp->sepc;
+		kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+		next_sepc = false;
+		goto ecall_done;
+	}
+
+	/* Exit ioctl loop or Propagate the error code the guest */
+	if (userspace_exit) {
+		next_sepc = false;
+		ret = 0;
+	} else {
+		/**
+		 * SBI extension handler always returns an Linux error code. Convert
+		 * it to the SBI specific error code that can be propagated the SBI
+		 * caller.
+		 */
+		ret = kvm_linux_err_map_sbi(ret);
+		cp->a0 = ret;
+		ret = 1;
+	}
+ecall_done:
 	if (next_sepc)
 		cp->sepc += 4;
+	if (!ext_is_v01)
+		cp->a1 = out_val;
 
 	return ret;
 }
-- 
2.31.1


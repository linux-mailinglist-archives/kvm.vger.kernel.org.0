Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275B730EC16
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 06:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhBDFeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 00:34:11 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:38831 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhBDFeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 00:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612416841; x=1643952841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KKoZm/yRaWYpbDjxNyImgz6OnxMRCIBlc1M6mN/Snb4=;
  b=ls1mwO3ObFWflehvMDiTOxWnhEo3rMPV3STbmPHztP6bFY+OLuPxCbPW
   AFoL+CvNsfWVF0fIgm3lZvCh0vjhS4+r+7PNqysPyiW+UVdAXo0mjOWXa
   MuqvOqehMrWhe2DeIdD5H/jaeyjYo3/qlZWNHzmqbWnabLmds5KmtvjP/
   gfqK5smtz1nr+UB5A0tIknuZl7NUkoMnk/Cp4LvA/p5cwDhGvVbsS7zEc
   mma7zY5F6uFjFW6qMR5BW3fGhhEl8Mn4ZDxXM9YNOrVRTJb41MNwbeJjK
   SDvhza/tci3SK973EvA2okueTQZxaOmoMRDcevNE2PGJ5SAZPYpmKcFGj
   A==;
IronPort-SDR: 3soR+W/kcUoUJJxHaEbz7lhn49813qTH65T39UoIPt7Zwq2Ykf3MC1mkfCHKp5S6Sdyk/td1s8
 6iwxI970H9woqaYbeN8wZcroJfd2F8Xx1Xl+U4WA2GBsg0XnCZmu1VhbRfKQIGGRbQgwoaOMeK
 1ohWNb9+N+6x/d6S0iwx8er2zSeLXXO/q/yEWQbkR0evL/10Zsjm6PawuOeNk1tPGIbsXs30e4
 xu3zyyIZP9MVb64Rx7tX9bJH8AF6wKXdYb6MO0W33U4B1+I39B3wk6o5SKwOpTNC5dJ48r52qL
 RjM=
X-IronPort-AV: E=Sophos;i="5.79,400,1602518400"; 
   d="scan'208";a="159086432"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2021 13:32:53 +0800
IronPort-SDR: OBvI8pSho5MYsCVWNGNjHHVBVmIPmW0Lt1sg5eDgOaT/BFUFXXb/mZXuJ6Y5kWG9m0Z/+w+rzj
 mdmF9YX360lS2Pe5noJ/L9mMHmHXPhUVuRGWZGCRLgJjA9FcG89TjqasO96s380CadSGtc9vuE
 nV8d4qQ1MuTSVBCEGSYbnvfzyaIMAHV0fvyquLXWgRk5AfIHn6s3RBa6i8+KCTVCVnDoSAYSye
 Sas10/Msf6SZejGoV/+brG1vc0I1i52wGj9dhaOGb/Yikb67h0L6SsffWPrvT1B4OWdMQhAFSM
 YS1yrdHw51TKv4e5ooVStTxZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 21:16:53 -0800
IronPort-SDR: alPokM4Ni8YztwJSBFlZvtaYzFjJvz7QCcB0erZK2+Wb5cT6Mxt0WIBRbZryZm9dHk7/ja734c
 iTWetN/DrwEXAgES68K1mA26oNtJjmfHnHm8tNkAYZrpHthQp/7vnQVuKszl3NcBv95wshIPR8
 lVGqwM3o1OEojPUJoT6s3idyEtiMJDP53bOOlrtmMl6H14ism29w38eII3CNSVCIJtgBOPKJ/I
 wg6+FWvGe426rpHzljdP2zQLHXBVyAN5sXdmX9XRzTo/a76bk+m/5/mvyfDqyqwT96hdU5FoA+
 8Q8=
WDCIronportException: Internal
Received: from cnf008142.ad.shared (HELO jedi-01.hgst.com) ([10.86.63.165])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Feb 2021 21:32:53 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH v2 1/6] RISC-V: Mark the existing SBI v0.1 implementation as legacy
Date:   Wed,  3 Feb 2021 21:32:34 -0800
Message-Id: <20210204053239.1609558-2-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204053239.1609558-1-atish.patra@wdc.com>
References: <20210204053239.1609558-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing SBI specification impelementation follows v0.1 or legacy
specification. The latest specification known as v0.2 allows more
scalability and performance improvements.

Rename the existing implementation as legacy and provide a way to allow
future extensions.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  29 +++++
 arch/riscv/kvm/vcpu_sbi.c             | 149 ++++++++++++++++++++------
 2 files changed, 148 insertions(+), 30 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
new file mode 100644
index 000000000000..5b3523a01bce
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/**
+ * Copyright (c) 2020 Western Digital Corporation or its affiliates.
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
index 9d1d25cf217f..a96ed3e3a9a3 100644
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
 
 static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
 				    struct kvm_run *run, u32 type)
@@ -70,16 +86,17 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 0;
 }
 
-int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+static int kvm_sbi_ext_legacy_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
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
@@ -93,8 +110,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * handled in kernel so we forward these to user-space
 		 */
 		kvm_riscv_vcpu_sbi_forward(vcpu, run);
-		next_sepc = false;
-		ret = 0;
+		*exit = true;
 		break;
 	case SBI_EXT_0_1_SET_TIMER:
 #if __riscv_xlen == 32
@@ -102,47 +118,42 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
@@ -152,22 +163,100 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
-		/* Return error for unsupported SBI calls */
-		cp->a0 = SBI_ERR_NOT_SUPPORTED;
+		ret = -EINVAL;
 		break;
 	};
 
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_legacy = {
+	.extid_start = SBI_EXT_0_1_SET_TIMER,
+	.extid_end = SBI_EXT_0_1_SHUTDOWN,
+	.handler = kvm_sbi_ext_legacy_handler,
+};
+
+static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
+	&vcpu_sbi_ext_legacy,
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
+		/* Return error for unsupported SBI calls */
+		cp->a0 = SBI_ERR_NOT_SUPPORTED;
+		goto ecall_done;
+	}
+
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
2.25.1


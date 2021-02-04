Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125E530EC1A
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 06:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhBDFfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 00:35:00 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:38831 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhBDFeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 00:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612416890; x=1643952890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V5hcHtmAfeJBPF3g3umUzSrG8ecGlDvA9Hi3xImGAxk=;
  b=DGSHRaZoT48qwNIqi2WRHLDVHlPefILSycyd85PxrD2Bd6gpRFJQK/oN
   cFoqEpxkvkx76BpRjKQLKgJuoqJO1on+aFt5kgfQ4YJ8mvytSQfVblj52
   oZQZcBiBRBvhSZEy5mC9UKVB7RG0fCMa+cR8ut50Q15g1b1vERalNQQ8R
   RwgCLJiRbAZx8yfcAYbJpyxlXnP3GaYsZPkEBbSBumitnWwHt7xGQK/Wn
   7xXRHwm2Ya/puplneNFB/2tW6PDj95uL7AftYsseso/DxC466AOp17/GU
   2QVbOtP/6nyVEfEo+ViMTmlIZCA/FrLi9ouOcWIpEJ6S4GuR8CTBCBPvk
   A==;
IronPort-SDR: 6SafRo0sMEAk6dcfeGXfB+ahiWkcKAmsCdEOkW062GEJwud+vC8DELWV391eIkzxacAB9dvL3N
 iHkbb2sAO+O/df/jE6STbM8Lz1rgh9A/vfSqN3RD/nvQ/422djPDwrImZudlE3NcZlRrJr39DU
 55uipiZxWw7x+Xhqe/PVI284ouroY0lKLH8/N7ytsuYNAnaLyI11fw5Hzc66whJDzcpikgGUAR
 91ISACztrWFFQThIZmQwFYDtfFhoWZ8G4K8yDXrSKC8ol9tnuO/mWmGnTBM8gjJzj1MI+s/XuB
 Ngg=
X-IronPort-AV: E=Sophos;i="5.79,400,1602518400"; 
   d="scan'208";a="159086441"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2021 13:32:54 +0800
IronPort-SDR: u1h3A4mrXeFhjOK18wOtjnYeRjBwP17o2YKHc4Fhe3ka0y3PK/E81pEh1f2a6QYmCnL0qlWcPY
 yiyW+LMiKz0mg04qmEhz4v34abLE9paaEYGixJYpiLSUgcQBpC1hckOGUuLr4qB6CFQGJK+MMD
 /uHzy3kUxtSf28j/P1z5MtK8rrYmooXwkpDhJqzCldVGXX+gfJtgFzRYuKlGhbSeewssOLpZDi
 xuikoXpKiluBIz1wpSz7l2BVi8/JCAi9a7oJW/XnOrbXZDyJjCEn/I7O4jgjoOMSmjj2vhYmGF
 wg6RIjw6Tk3v5U47w5o1tgsi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 21:16:54 -0800
IronPort-SDR: 8ODTY/isjotPeAhGRXatURbVEIlwhpRnxPyBOdTHVOMPNr+zFaRzhtDw4m1KDvEUflWTUBs1HU
 LsFuc0ESb7yQrulZj7LfaY0iQxZd0lIuZOLNNRkotMokkj4hYEKxvDP+KLLZng/TSAoV1+8XbW
 nFSkP2OgtYXgQ3gA+bd93P3v/MHUwrkLpS1soAylLx0yq+PLLhwV5j9uk10EHjP/tmuNMoULqj
 5OD+rB28GtWg+G2KxChNQmKe+R9iFcpL+gkpgPYwyMAQhy3U/qUM8cvUDeF5ddGnDqP37vmTcU
 Bz8=
WDCIronportException: Internal
Received: from cnf008142.ad.shared (HELO jedi-01.hgst.com) ([10.86.63.165])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Feb 2021 21:32:54 -0800
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
Subject: [PATCH v2 3/6] RISC-V: Add SBI v0.2 base extension
Date:   Wed,  3 Feb 2021 21:32:36 -0800
Message-Id: <20210204053239.1609558-4-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204053239.1609558-1-atish.patra@wdc.com>
References: <20210204053239.1609558-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SBI v0.2 base extension defined to allow backward compatibility and
probing of future extensions. This is also the only mandatory SBI
extension that must be implemented by SBI implementors.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 +
 arch/riscv/include/asm/sbi.h          |  8 +++
 arch/riscv/kvm/Makefile               |  4 +-
 arch/riscv/kvm/vcpu_sbi.c             |  3 ++
 arch/riscv/kvm/vcpu_sbi_base.c        | 73 +++++++++++++++++++++++++++
 5 files changed, 88 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 743c71f0c331..e208c8ac57fe 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -9,6 +9,8 @@
 #ifndef __RISCV_KVM_VCPU_SBI_H__
 #define __RISCV_KVM_VCPU_SBI_H__
 
+#define KVM_SBI_IMPID 3
+
 #define KVM_SBI_VERSION_MAJOR 0
 #define KVM_SBI_VERSION_MINOR 2
 
diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 3e7141a7d11f..4a405f583d32 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -28,6 +28,14 @@ enum sbi_ext_id {
 	SBI_EXT_RFENCE = 0x52464E43,
 	SBI_EXT_HSM = 0x48534D,
 	SBI_EXT_SRST = 0x53525354,
+
+	/* Experimentals extensions must lie within this range */
+	SBI_EXT_EXPERIMENTAL_START = 0x0800000,
+	SBI_EXT_EXPERIMENTAL_END = 0x08FFFFFF,
+
+	/* Vendor extensions must lie within this range */
+	SBI_EXT_VENDOR_START = 0x09000000,
+	SBI_EXT_VENDOR_END = 0x09FFFFFF,
 };
 
 enum sbi_ext_base_fid {
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 1ba4afe112f1..0f17dffe8d46 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -10,6 +10,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs := $(common-objs-y)
 
 kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o vcpu_sbi_legacy.o
-
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
+kvm-objs += vcpu_sbi.o vcpu_sbi_base.o vcpu_sbi_legacy.o
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 29eecf8cbdc3..c85c3b1dd2eb 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -31,8 +31,11 @@ static int kvm_linux_err_map_sbi(int err)
 }
 
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_legacy;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
+
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_legacy,
+	&vcpu_sbi_ext_base,
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
new file mode 100644
index 000000000000..48f1164f189c
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * Copyright (c) 2020 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_sbi.h>
+
+static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				    unsigned long *out_val,
+				    struct kvm_cpu_trap *trap, bool *exit)
+{
+	int ret = 0;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	struct sbiret ecall_ret;
+
+	if (!cp)
+		return -EINVAL;
+
+	switch (cp->a6) {
+	case SBI_EXT_BASE_GET_SPEC_VERSION:
+		*out_val = (KVM_SBI_VERSION_MAJOR <<
+			    SBI_SPEC_VERSION_MAJOR_SHIFT) |
+			    KVM_SBI_VERSION_MINOR;
+		break;
+	case SBI_EXT_BASE_GET_IMP_ID:
+		*out_val = KVM_SBI_IMPID;
+		break;
+	case SBI_EXT_BASE_GET_IMP_VERSION:
+		*out_val = 0;
+		break;
+	case SBI_EXT_BASE_PROBE_EXT:
+		*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
+		if ((!*out_val) &&
+		    ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
+		     cp->a0 <= SBI_EXT_EXPERIMENTAL_END) ||
+		    ((cp->a0 >= SBI_EXT_VENDOR_START &&
+		     cp->a0 <= SBI_EXT_VENDOR_END)))) {
+		/* For experimental/vendor extensions forward to the userspace*/
+			kvm_riscv_vcpu_sbi_forward(vcpu, run);
+			*exit = true;
+		}
+		break;
+	case SBI_EXT_BASE_GET_MVENDORID:
+	case SBI_EXT_BASE_GET_MARCHID:
+	case SBI_EXT_BASE_GET_MIMPID:
+		ecall_ret = sbi_ecall(SBI_EXT_BASE, cp->a6, 0, 0, 0, 0, 0, 0);
+		if (!ecall_ret.error)
+			*out_val = ecall_ret.value;
+		/*TODO: We are unnecessarily converting the error twice */
+		ret = sbi_err_map_linux_errno(ecall_ret.error);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
+	.extid_start = SBI_EXT_BASE,
+	.extid_end = SBI_EXT_BASE,
+	.handler = kvm_sbi_ext_base_handler,
+};
-- 
2.25.1


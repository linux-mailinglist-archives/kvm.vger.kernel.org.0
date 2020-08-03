Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1952D23AC03
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 19:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgHCR73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 13:59:29 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:64741 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgHCR7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 13:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596477558; x=1628013558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jU9YUiaLBL5uWBVTinVot5g73YeyDZgqDfT7h5RHaK0=;
  b=bB41/+VYlAhY6QYPsGv8Lih0Nfa8fRs5wlSpjJg4exCRaBRKnNw+JfVy
   OAAQOD0ov0Vg17efpQm3QMa377zFfq200VpJqOra6vumDbQwLpOvQuXC1
   FQlI6vUTaT+h4T/CvtZSYInRXwZ3Th4AUK37TbSNa+WS2qvbE8kYzaATc
   D5IKBMtCdBUYIEX3Oo8R8v8Vhy6dFcJJTheTLboA3B1At5K0v5ZHuwY85
   KtJXeAZlfaIrm+pN0p+EDRwQrcZV9GcGDsfDsQNMiTmrNbF8HL0H35HL2
   S3MXw/eUofUKu1C1ZUJJ2AryUnEtjJoelJfiFn1EjLip66dArUcQ9yKlQ
   w==;
IronPort-SDR: 5XKXjpNL9kHDPWXk+ikxoV2mA3uZNPUPUJp/zYuO4gE4PesyUqIzGIdTIYfAhwciqL0K6jKUWV
 rudlMUJbiSuOw5mIA/8LB16kuvz2Po6yjBra97rKMqD1wD2oFKVIzsSATb7+o3q/mFP78JfyBW
 1pw/PgTH6mWIW7b9cUrS+OcYJSuvJz6vlTvbFfs8mzwjyQE/LtpCqDejpBMmsG/TBBmu1VnAAn
 Yo1e56cJ1aQ7dBr29uyW35+XlgkhyYxo0SxP+tuYcEIu51AyeGTB3nx2gqskyaVrCWS9ApQyLc
 Bpc=
X-IronPort-AV: E=Sophos;i="5.75,430,1589212800"; 
   d="scan'208";a="144033187"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2020 01:59:06 +0800
IronPort-SDR: C655FkzNbXDHtYLNB0Aj1hPKjL7wMjSVCkyDioz6yPM1a3Zp33zNO+LKObGAuOq2Mn/CGiL48U
 y8c7pDHZprtg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 10:47:08 -0700
IronPort-SDR: UG53wW/fsc7pTLfYnTrWL5HIO4RpvYc7yZ62ccSKI1De9f1BmKIPMtdK31OiH8/TfRKOylDfwP
 Pacm67hl6K2A==
WDCIronportException: Internal
Received: from cnf007830.ad.shared (HELO jedi-01.hgst.com) ([10.86.58.196])
  by uls-op-cesaip01.wdc.com with ESMTP; 03 Aug 2020 10:59:06 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>
Subject: [PATCH 5/6] RISC-V: Add v0.1 replacement SBI extensions defined in v02
Date:   Mon,  3 Aug 2020 10:58:45 -0700
Message-Id: <20200803175846.26272-6-atish.patra@wdc.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200803175846.26272-1-atish.patra@wdc.com>
References: <20200803175846.26272-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SBI v0.2 contains some of the improved versions of required v0.1
extensions such as remote fence, timer and IPI.

This patch implements those extensions.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu_sbi.c         |   6 ++
 arch/riscv/kvm/vcpu_sbi_replace.c | 136 ++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c

diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index a95c91ba9a51..b0e8b760fda0 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -10,5 +10,5 @@ kvm-objs := $(common-objs-y)
 
 kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
 kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
-kvm-objs += vcpu_sbi.o vcpu_sbi_base.o vcpu_sbi_legacy.o
+kvm-objs += vcpu_sbi.o vcpu_sbi_base.o vcpu_sbi_legacy.o vcpu_sbi_replace.o
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index bb50d63f78e7..8c3ca522dddb 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -32,10 +32,16 @@ static int kvm_linux_err_map_sbi(int err)
 
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_legacy;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
 
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_legacy,
 	&vcpu_sbi_ext_base,
+	&vcpu_sbi_ext_time,
+	&vcpu_sbi_ext_ipi,
+	&vcpu_sbi_ext_rfence,
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
new file mode 100644
index 000000000000..8e6b57fc1622
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -0,0 +1,136 @@
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
+static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				    unsigned long *out_val,
+				    struct kvm_cpu_trap *utrap, bool *exit)
+{
+	int ret = 0;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	u64 next_cycle;
+
+	if (!cp || (cp->a6 != SBI_EXT_TIME_SET_TIMER))
+		return -EINVAL;
+
+#if __riscv_xlen == 32
+	next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+	next_cycle = (u64)cp->a0;
+#endif
+	kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
+	.extid_start = SBI_EXT_TIME,
+	.extid_end = SBI_EXT_TIME,
+	.handler = kvm_sbi_ext_time_handler,
+};
+
+static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				   unsigned long *out_val,
+				   struct kvm_cpu_trap *utrap, bool *exit)
+{
+	int i, ret = 0;
+	struct kvm_vcpu *tmp;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long hmask = cp->a0;
+	unsigned long hbase = cp->a1;
+
+	if (!cp || (cp->a6 != SBI_EXT_IPI_SEND_IPI))
+		return -EINVAL;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		if (hbase != -1UL) {
+			if (tmp->vcpu_id < hbase)
+				continue;
+			if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
+				continue;
+		}
+		ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi = {
+	.extid_start = SBI_EXT_IPI,
+	.extid_end = SBI_EXT_IPI,
+	.handler = kvm_sbi_ext_ipi_handler,
+};
+
+static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				      unsigned long *out_val,
+				      struct kvm_cpu_trap *utrap, bool *exit)
+{
+	int i, ret = 0;
+	struct cpumask cm, hm;
+	struct kvm_vcpu *tmp;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long hmask = cp->a0;
+	unsigned long hbase = cp->a1;
+	unsigned long funcid = cp->a6;
+
+	if (!cp)
+		return -EINVAL;
+
+	cpumask_clear(&cm);
+	cpumask_clear(&hm);
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		if (hbase != -1UL) {
+			if (tmp->vcpu_id < hbase)
+				continue;
+			if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
+				continue;
+		}
+		if (tmp->cpu < 0)
+			continue;
+		cpumask_set_cpu(tmp->cpu, &cm);
+	}
+
+	riscv_cpuid_to_hartid_mask(&cm, &hm);
+
+	switch (funcid) {
+	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
+		ret = sbi_remote_fence_i(cpumask_bits(&hm));
+		break;
+	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
+		ret = sbi_remote_hfence_vvma(cpumask_bits(&hm), cp->a2, cp->a3);
+		break;
+	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
+		ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm), cp->a2,
+						  cp->a3, cp->a4);
+		break;
+	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
+	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
+	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA:
+	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
+	/* TODO: implement for nested hypervisor case */
+	default:
+		ret = -ENOTSUPP;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
+	.extid_start = SBI_EXT_RFENCE,
+	.extid_end = SBI_EXT_RFENCE,
+	.handler = kvm_sbi_ext_rfence_handler,
+};
-- 
2.24.0


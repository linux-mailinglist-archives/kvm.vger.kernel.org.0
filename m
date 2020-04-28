Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA951BB7C3
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgD1Hfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:35:46 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57395 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgD1Hfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:35:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059365; x=1619595365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YFYGhqysS/gSevWj7p5k2ldpMHtUbUE1jxGq11oOZeo=;
  b=DHJwx3iwAZy1bidY2cbX6Fi+eG0C8gC4SWw4hPBl5zT2X9wlvF+M7m3i
   7gaA0lQ09L1kCp4gBGRSDwYdutmWX/wYc8xN79AG4ZVjMZLBRlH+DVjO7
   32oUoMlR5G0tXGE4PV6A4G3cBTo8j1aIClFZZ9QkOVRHlYgAhW/vvBU6b
   W8L+ZnEs661WkwZeM+Ub5zUtqxVmGdmkClBW3N4a8CFfrVGGFXT8Y69Tw
   IPmGNGNxg05WshIxzLxCqMuSt4s4ekjXv2aeOBD2aVoOftdOjuwHEQlEv
   qNo0hljTxK5gIMRPp8Vg8KLP/hBwJ5Bw9SdkQJuNXJqWPW9mFgJwOH1Z7
   Q==;
IronPort-SDR: xTBpeBpG9x+1TQBiXheTH/HEH43uYQlbdu/UnZjLZqXaxggGCvhXv1Cj1wfwkfCVXi7axY6FbO
 lblcHkEGUI5dh+SohVK5Dr+ewxS+B6iiLNIPYRgBkie8B5V46JjOFim1rcSPXg5qB+Gh3yov7m
 G/YtrO062l+WDql9Bp64o3qnIb75NICQC7tRf1UOKIFCqY+euNSEnTsEjI3SO4zqvwSH6NGr7a
 iX2fJ+kWzp9n6uXaMhR1RziGCL+dI/XB4FuG0FK6drZZOpG2fU2odfkhXILILN65TdN9Au4Bno
 dEg=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="238865942"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:36:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irLykxZaZbBRSfCMwnUxiy+ytMlkNSQkvXsoYjEfmvPfCdo8a3O2l0II04bWJHGB/d4lHB8ZqLhHNrBHKOYZxdUVMQnUB0kSI9eYzkZn2Q8dQ+gi5B79cEw97VkrE6dwxffrwnGlpKopss/yHwpy2UQIpcnBe4eeFUbbLvsiP0w1FQFqpSuFtyrzmllv7TTBwMEfwFw/rROQGlvoVLo5Wi/nQ+sEX+AlRDj+y3IdklN4ex/vLIFzrcUaXuMjsXazxatUrzTOl3CmJAu/5/ZcSF8YV8GDZV42RIr7gTtCitpVwUFBvz/FhG1yX5J9SEVrOWwivhL1cAqfXibVFGzjPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBmtsXqyLt2FnCLDZ4L+KzBZe67/6rI3QCIrFawrlUk=;
 b=HVUwTNlnipANuwxfvSVHY8OVenMq77W7XTnqyPW3OwqKD8OMbQ+xwUQCSrPN3Au0iwP93kUpTWi3Q0gw8SKNAJWU2paIyJD/kdgE/xayMc/R3SXWqoc9LsXSZpqklPWbJr53KaCjg+XqReiEHu5u0ux2acOdDB8r11XANkIj/oHvE6aAeEPfDRSCT2nLOtqnkbQ3SDJh9NYfDBy/vwfw1DCCEm4/Gg48TaKU0324P0IzMpnFCsoYoZpqWkaiFoPb5gd2WQQHy51z9Pyygvjy2kCi/BGjWqolAn/htj/MAyVxoBPjq5alRpRrcH+oLUciDbum95nwBHrtMYYr1tjqKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBmtsXqyLt2FnCLDZ4L+KzBZe67/6rI3QCIrFawrlUk=;
 b=kH5qLGRPSz0KQzMmW0SKJoUDh9ELyCKZhrgiHNHkJBkFQNKYOoSl4YGEKP0/bmtOCJcgaWhhbuXawGZtkSgJq4tI73niXaKLnq+S9sTYtcS1aTlB81bCcHphVK6ob+xKucvUWvQCmTK+wxCkSSb9p2Y7IWzjK7MCuhCZbaI8r0s=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5929.namprd04.prod.outlook.com (2603:10b6:5:170::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:35:42 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:35:42 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v12 15/17] RISC-V: KVM: Add SBI v0.1 support
Date:   Tue, 28 Apr 2020 13:03:10 +0530
Message-Id: <20200428073312.324684-16-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428073312.324684-1-anup.patel@wdc.com>
References: <20200428073312.324684-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:35:37 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60ce2042-98ef-40da-143e-08d7eb46c1a8
X-MS-TrafficTypeDiagnostic: DM6PR04MB5929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5929584E3BFC477A249E5AAF8DAC0@DM6PR04MB5929.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(1076003)(66946007)(2906002)(5660300002)(498600001)(66556008)(66476007)(7416002)(86362001)(55236004)(55016002)(186003)(8936002)(4326008)(7696005)(36756003)(956004)(110136005)(8886007)(2616005)(6666004)(26005)(16526019)(54906003)(44832011)(52116002)(81156014)(1006002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlCMwEVO3KeNAfEzvmZd2wFt23SNkUHbJmL97EBgswdAjWeGuy1tx3cvKcqDharF7PR0ReaJiEv1SH2zOWCrzr+GyS0TlvDl0EPV+ZDOoCKBTQhAlPiAOyt4+5jBCAv5ZP0ptKfFUopZiFAblJ04Y6kqiJKVSAoVk9UaDvArGKzeamQX8lMBY4uaeRXZ3QWehIFotT2fEqPNHFYqDPR4Wh8m8E3lY4kDqhbqYATrlBkYC78YbrxbwY0fvSC1wdckEsCUqFYd5VGj6sb6SaNrNlsoMAte6M89I7LwfQvJQoQTEDEiTB1/boaTAEDslvpjbvfjr1ntP69kCqrfyiZhr1yrf1rthh+d1dzS7+j4FCVGjFglabnsnVKFHusP4+YjNQKFBPsjmSVb74ekzL8kLLTgOH4nwzr6xpsl7tb4cyyrh6SD1CNr3ULzJnm1BYem
X-MS-Exchange-AntiSpam-MessageData: o87vzV5PPxbSTOBFA7G7U88iJ3lCbcSiF6no1TRO6XatkP3WAYTspm5/NQXvQAQHhyc4vfTwW6hVGYYU/pnYbPen623+qo8/9zJPhdt0yuenzldPi/pSN7NqOCDwCM8+nYWyFWYaPI6ccNF7v+WCkDBwOciHw69EH+KE7v/IRbGoFQaHEq5sZ6IbxyytoR8QhwMA8JUr2wft9NTSnNUdNgjpfR176kvRMOv/uB1WYfy1GOfnH77NtdaLBP9wE/cSIM+cbHVlcFMC+6ft6pZr9gg0Rycyju+ul+YVA2o8DWoqsL3YbKYVk8e+xtRAMZKwzgzYOYTdusOWrZdD+AqsJbjVFEK/3/F3vFwhRV7eJiLPMbPVWSnRJl1ZY21PMTlHvzTDRofx4UGeEvfH3g9kS1g4oQB/OdpO7edgWJ1f/uqY8c7YCUWVz6M0ucZ48gdwVd4R16VBaxioYfefckicgT+Cchn2PMm8Epfwy5eBUCU8vhwS35d3jGx8xrcCAJ8D7KtoSvWZrILvlXH3nma1loe9Jkh7ED6XSvuQ8dDRrPCpSOVVdkJ6/0E+b85YgG2OdnI5U0HbPxHsThSaGuDECc/mdNAG+Qh6uK6v0QJJcEKtnR1phbjlRpGSNLEx30Bds5sbQmbRhFmsloj4Vclof2rY4KLmxB7XwY3Dy3iuc8K0KFJ2WqsalmGud9dJZ+qM9qhWZNOw5OtsDfhSGpNqIp/JxhBh84RsbGfV7yHsFzmWHIIWRtNNabURvbvSwwRss9JVA6shIrLGvvy71OlSV4UYQEKEJObxfKjKZn4uetw=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ce2042-98ef-40da-143e-08d7eb46c1a8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:35:42.7139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cYab0GTo5cMYRaoN1RDRoRevtriuhB2MgaF+7OCWwsCNRdU2HKt5mXOZlDLuTgHRMSMPBOrZ6xs8EC2HM7KbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5929
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The KVM host kernel is running in HS-mode needs so we need to handle
the SBI calls coming from guest kernel running in VS-mode.

This patch adds SBI v0.1 support in KVM RISC-V. Almost all SBI v0.1
calls are implemented in KVM kernel module except GETCHAR and PUTCHART
calls which are forwarded to user space because these calls cannot be
implemented in kernel space. In future, when we implement SBI v0.2 for
Guest, we will forward SBI v0.2 experimental and vendor extension calls
to user space.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h |  10 ++
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu.c             |   9 ++
 arch/riscv/kvm/vcpu_exit.c        |   4 +
 arch/riscv/kvm/vcpu_sbi.c         | 172 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |   8 ++
 6 files changed, 204 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 0677b5a70ac1..f7520d4e0b43 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -77,6 +77,10 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+struct kvm_sbi_context {
+	int return_handled;
+};
+
 #define KVM_MMU_PAGE_CACHE_NR_OBJS	32
 
 struct kvm_mmu_page_cache {
@@ -187,6 +191,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* SBI context */
+	struct kvm_sbi_context sbi_context;
+
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_page_cache mmu_page_cache;
 
@@ -259,4 +266,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 3e0c7558320d..b56dc1650d2c 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs := $(common-objs-y)
 
 kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index a52180404271..567804268c39 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -866,6 +866,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		}
 	}
 
+	/* Process SBI value returned from user-space */
+	if (run->exit_reason == KVM_EXIT_RISCV_SBI) {
+		ret = kvm_riscv_vcpu_sbi_return(vcpu, vcpu->run);
+		if (ret) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			return ret;
+		}
+	}
+
 	if (run->immediate_exit) {
 		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
 		return -EINTR;
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 2384b4bf4939..d826ce6f1e98 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -631,6 +631,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
 			ret = stage2_page_fault(vcpu, run, trap);
 		break;
+	case EXC_SUPERVISOR_SYSCALL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = kvm_riscv_vcpu_sbi_ecall(vcpu, run);
+		break;
 	default:
 		break;
 	};
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
new file mode 100644
index 000000000000..b04e2b175fbc
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * Copyright (c) 2019 Western Digital Corporation or its affiliates.
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
+
+#define SBI_VERSION_MAJOR			0
+#define SBI_VERSION_MINOR			1
+
+static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
+				    struct kvm_run *run, u32 type)
+{
+	int i;
+	struct kvm_vcpu *tmp;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
+		tmp->arch.power_off = true;
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+
+	memset(&run->system_event, 0, sizeof(run->system_event));
+	run->system_event.type = type;
+	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+}
+
+static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
+				       struct kvm_run *run)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+
+	vcpu->arch.sbi_context.return_handled = 0;
+	run->exit_reason = KVM_EXIT_RISCV_SBI;
+	run->riscv_sbi.extension_id = cp->a7;
+	run->riscv_sbi.function_id = cp->a6;
+	run->riscv_sbi.args[0] = cp->a0;
+	run->riscv_sbi.args[1] = cp->a1;
+	run->riscv_sbi.args[2] = cp->a2;
+	run->riscv_sbi.args[3] = cp->a3;
+	run->riscv_sbi.args[4] = cp->a4;
+	run->riscv_sbi.args[5] = cp->a5;
+	run->riscv_sbi.ret[0] = cp->a0;
+	run->riscv_sbi.ret[1] = cp->a1;
+}
+
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+
+	/* Handle SBI return only once */
+	if (vcpu->arch.sbi_context.return_handled)
+		return 0;
+	vcpu->arch.sbi_context.return_handled = 1;
+
+	/* Update return values */
+	cp->a0 = run->riscv_sbi.ret[0];
+	cp->a1 = run->riscv_sbi.ret[1];
+
+	/* Move to next instruction */
+	vcpu->arch.guest_context.sepc += 4;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	ulong hmask;
+	int i, ret = 1;
+	u64 next_cycle;
+	struct kvm_vcpu *rvcpu;
+	bool next_sepc = true;
+	struct cpumask cm, hm;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_cpu_trap utrap = { 0 };
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+
+	if (!cp)
+		return -EINVAL;
+
+	switch (cp->a7) {
+	case SBI_EXT_0_1_CONSOLE_GETCHAR:
+	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
+		/*
+		 * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
+		 * handled in kernel so we forward these to user-space
+		 */
+		kvm_riscv_vcpu_sbi_forward(vcpu, run);
+		next_sepc = false;
+		ret = 0;
+		break;
+	case SBI_EXT_0_1_SET_TIMER:
+#if __riscv_xlen == 32
+		next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+		next_cycle = (u64)cp->a0;
+#endif
+		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		break;
+	case SBI_EXT_0_1_CLEAR_IPI:
+		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
+		break;
+	case SBI_EXT_0_1_SEND_IPI:
+		if (cp->a0)
+			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+							   &utrap);
+		else
+			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
+		if (utrap.scause) {
+			utrap.sepc = cp->sepc;
+			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+			next_sepc = false;
+			break;
+		}
+		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
+			kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
+		}
+		break;
+	case SBI_EXT_0_1_SHUTDOWN:
+		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
+		next_sepc = false;
+		ret = 0;
+		break;
+	case SBI_EXT_0_1_REMOTE_FENCE_I:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
+		if (cp->a0)
+			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+							   &utrap);
+		else
+			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
+		if (utrap.scause) {
+			utrap.sepc = cp->sepc;
+			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+			next_sepc = false;
+			break;
+		}
+		cpumask_clear(&cm);
+		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
+			if (rvcpu->cpu < 0)
+				continue;
+			cpumask_set_cpu(rvcpu->cpu, &cm);
+		}
+		riscv_cpuid_to_hartid_mask(&cm, &hm);
+		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
+			sbi_remote_fence_i(cpumask_bits(&hm));
+		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
+			sbi_remote_hfence_vvma(cpumask_bits(&hm),
+						cp->a1, cp->a2);
+		else
+			sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
+						cp->a1, cp->a2, cp->a3);
+		break;
+	default:
+		/* Return error for unsupported SBI calls */
+		cp->a0 = SBI_ERR_NOT_SUPPORTED;
+		break;
+	};
+
+	if (next_sepc)
+		cp->sepc += 4;
+
+	return ret;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..c5cfb5abb80a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_RISCV_SBI        28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -400,6 +401,13 @@ struct kvm_run {
 			__u64 esr_iss;
 			__u64 fault_ipa;
 		} arm_nisv;
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1


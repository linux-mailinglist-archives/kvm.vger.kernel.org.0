Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B6741935F
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhI0LoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:44:20 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36472 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbhI0Lnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742914; x=1664278914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EQt7NwtN28bXWxXKwVUKAIR9P4RmzxuE+QZccclBSbo=;
  b=ayz/1yolSMiTl+vag4eopZxRR8odZaXwMBV+OVwO80+g4X8esfsBi9o2
   O9j9YYcR50ulyvOwCsy6SHWZr1RN1RA31ZM2pQKn3MCUV+2ttlw++qmy7
   zKkmaZB6DNS4VkznZ2L84L766LzJcsZ/JLFzyafd+veShFMF3eC/wCZ0D
   c/k9uher7vohn7OiO6UbkwiyYWZZ2MvE6fGK3OxCvTi2tCV5SCPhzAqHw
   wLdNeuPdW6G/nCGSz34tsz1OnrDPQGas+ddKWqNDKv2nWo9mBGrDtpL+L
   MPq0sLlmdAuHydNBWPBkWZyIXMDKxraKhaWFixumd5ofZDWPsRbkC+8as
   w==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181673106"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:41:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2a0EirimJfVbKWsn1LwFbPx35imHq8Vg1TS1xdeiF9NQ6qwBizBGPcrnNCV0VjAcXkfK9JO3lYwOEyHoaRuOGBnl4x5mvUyjkWsKfRpgCHZsS5eH+nQash/4A14FWVcCLr4Hb02VUE0L2mSjczaNIUOeMB4IiitaedefU2JZaNvOoD1jMGkI9QVNWOzs2YUeVefxeiMdeNSYJeuVLo2X/aB9VZKXth1NPzy3kXNuxUGfjQFOORdq5UTkkDCEVt2/K07iCBgfoF73vyQciSvwoK//VNkTZ1G6szxEaE55cIpZO4Y5qCO+LagaZwy2v9JHHhFTu8IgBQyd2GY9A6sAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=L35rhHuF82nJ0UCBBobDGFe3qwwIbuiiyI6mWN2agiE=;
 b=U3TBvsYAJixoSd7QeBrWvBMLOsIQJYll3BtYN7pCk12WdRS9iKD94vfUFWLdZXOcYGivnnoGW884WmbG2BRJ3V1QAjhf0Hw9swWF6h9M0eDYsLwKymLAsu3GCkqfliJQTtxa1AxthJFvHbyTeJDupmCLHNMDnTYLvR/mgrOjxSOEXUVhqMVR+Xuu+prplyAi3oYgAC2AHrlGvbLSkU1K3dLlswbH74Si/iUv1MzD/47VMDWxZMTbdEyK1/0ztvoAebLGEUxFEUAucTpjgcPLEycvdwMZ6Qcp4C6JRRZcA88+8++GV52SzXVcKpAwdgaY8WmDE6ZriR/um8b2XEnh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L35rhHuF82nJ0UCBBobDGFe3qwwIbuiiyI6mWN2agiE=;
 b=ZyadpNrGdX6EdRg7C0t9gmkAPn1gVA7rwUxb4K5rciQ7YFB0R1speS3FOKnrF1bemyGkhVZDYzJO99+N8Vj0RTLjm8T9Qj4J5C5XRJBE6uBBdZ7eC7QQOZfKwn4TO3WX5R/kyEf8EuNHCWf1SkJuW4DYH+ieTH8abci+5PebhH8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:41:50 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:41:50 +0000
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
Subject: [PATCH v20 15/17] RISC-V: KVM: Add SBI v0.1 support
Date:   Mon, 27 Sep 2021 17:10:14 +0530
Message-Id: <20210927114016.1089328-16-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:41:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f16d76f9-f60d-4068-63e6-08d981abcba6
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB8236F1ABD2C66DCF1A15C31C8DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkBsFvGZ3UH8KK+cc8BZ4+A5Nil61CXBsEyt9jTJOrgeDRF3OgMUWHOfWbOk+QPOZakPA/oWlkOPF2NFDrFqA5FLZhxV1pZpZnJC9GI4iwxE4v6k+CwtNiMD+RlQ3ZfRBj344XILHYRkDGbZygQVH7eHq3cngd662BeT2d5Wm0kREeRHPldYk/dvel295ve7q1FdIAo8IbEylbFXbHT/DlXRXtRGGz43LnfrNWXMGoadw7iSDdw/TuWEgGG6kNCiARgWYHXuYlinR4a1pfIjslUXXZJZQdHubBnMtRQ4YX2bceBKIUc5c3kkdCwqQ+Ur9bODCtIDQAf/5top+UZtPBFzTn9bP8R4Ugizzarvbj8VWvgUs/MqLlhFBHOodGSJCnf6MrA+SleL3cm808D/We7IPvfVjxmFWmXWJEpIYgcu6gW01dJiU/kGvsgvVXPTYlXsvbvlz7J4wr4nZTf+3qt3avVMzPR6dvtku1Hx4RFjNsPMw2iQ7aMT00OvymGWyqGDQjmpxPIwbTkJyyMAg4IXkq8rkrbI64I/Mvm5c1lMvgMT6k0mOX44YZCFJBqRZB+Cwrf7VYgOm6byobfRueOOjt/1smK4VzrQhj/6fWhCS3GTHzBZg8TF6h8y0zqm1B0gVpU6vKbyiPOzI+L1msVuaa4tQJwm7TtuEX5PD8mEkCWo/SX5crELM0asydfG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(44832011)(38100700002)(54906003)(110136005)(186003)(55016002)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(7416002)(26005)(83380400001)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CyRGmijp9kNVfO1PUjkBEClqa/GQLXQ4RmRiWbYYCi3Z4p7g08TKE6rv6LuA?=
 =?us-ascii?Q?zHcAujqiOw1rROAqSWJJluCN3ygvcLYXbQouT0c7QNgpDZQG8tse6crnmh9X?=
 =?us-ascii?Q?Gyen3XijzwtIzfbYFTDpxHKg2er6e45I8a4A/cysF+HAdQENjANC14LUSNqF?=
 =?us-ascii?Q?CSoCMVRB3MXvMeGF0uv5YFDyKKaY96xpXDezDTAExwjlKlpVgCK61RyxEn6A?=
 =?us-ascii?Q?TPvVYf08aou6k79Zjhz1yBp033YiX8YOfumdvO+lGQEommMrzJjtJQSZZDxq?=
 =?us-ascii?Q?3qBMtC12JI3iPr+WWoOjeeeSMasLpp2SpjVMVwYM2K9wdVXTXGHOH141acrE?=
 =?us-ascii?Q?pRox3YNJ86GbbS13THq7lj6j0J9avNpQexJ7arBFd/XmCvlnYiBFNjMyBfbl?=
 =?us-ascii?Q?nWwkLg/DCDqP9fe5gTTowebXqgdZ7VKFOmZEac7Ufx3+//4jHth2IWWhYyHi?=
 =?us-ascii?Q?WZOBR1frvxuLxXDFV/U22T50kj/bT2VlNGQDvd7Yikgs3kwMs2CWuyt0rf16?=
 =?us-ascii?Q?qOe2R98A+p6lgnlsE3pHbMimLaG+Z8ybhh5ZPr5EMk245c/BHupvPheIK2r6?=
 =?us-ascii?Q?2PnEmlH4SeV9zpK2rh7YI+zqkegzXRQV8g6cmgGZEoP6d9aPqSXuH+3V8V74?=
 =?us-ascii?Q?CuBciVTjNWVfmfE/mOYSRqFkAArTrTVKExCBuia5EaAG4f+Kg6smMGVDpvK4?=
 =?us-ascii?Q?1Mzmt9ldjYjHJYUiYCrAsFfYISIeUX7kFNygZQwIV2N/RfjLO9gVyVw0k//7?=
 =?us-ascii?Q?nWCdQgjk4Xtv/rySAfq6rGuHq7GNiXUEilo+lNIt+3ZquT9ECPgIJjmKq58J?=
 =?us-ascii?Q?/75jmKu0Ye/JrGbzM8COFj2PWNpaV1LTL6ErCDIi3zm6k8tbzVqjmhY5gWO0?=
 =?us-ascii?Q?0L56pjmCUaGOagVOZg7ZEL+lBaM2WqQGzx1MxiuJSenmx0ajFteZp1TpnFpv?=
 =?us-ascii?Q?m1Yj9qH7BsM2eGvicLB2yQPyfDgbcZwaTu45oXtH2ovg+HJTkBZt3nFmjRPt?=
 =?us-ascii?Q?hQ5xL/lPShWmPdr8DpQC/nq6SVXUUx9FqveV+3xXDSCZdQLhDvMc9iB7V3Pn?=
 =?us-ascii?Q?r9LTnLvECY7hRQNpGCQVl5wAUfdn168wQEeAYyPuddauCoO0nGqx+XDSLamK?=
 =?us-ascii?Q?WIVc01N1ZvEAg8sAtG+GMIzX1jeORuvnaWAiucOMsTp/LOCqknAI2KVBYafC?=
 =?us-ascii?Q?wHqenH6HAr3WBwkTSQhOlXu7PK+bE8bmE3XFsAMsAGwfF4MPtgt3EHO+L7gi?=
 =?us-ascii?Q?Ac7Lyy7L5hmCXUphJ3IzU4g9GPXHTCoTk6KTLUstLouTg5TVFStH9b88cHxa?=
 =?us-ascii?Q?9cDmU8OUFIcv9aZPtqz6FwgJ?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16d76f9-f60d-4068-63e6-08d981abcba6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:50.6711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/7rMTxm4U5t29d7b5Df4tRIc+wsFd10GvorYYsFb8Ykz5FL4vSalScf/9G7wSKWcj1yT6cM0610ullqYd98FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
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
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/vcpu.c             |   9 ++
 arch/riscv/kvm/vcpu_exit.c        |   4 +
 arch/riscv/kvm/vcpu_sbi.c         | 185 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |   8 ++
 6 files changed, 217 insertions(+)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index be159686da46..d7e1696cd2ec 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -74,6 +74,10 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+struct kvm_sbi_context {
+	int return_handled;
+};
+
 #define KVM_MMU_PAGE_CACHE_NR_OBJS	32
 
 struct kvm_mmu_page_cache {
@@ -186,6 +190,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* SBI context */
+	struct kvm_sbi_context sbi_context;
+
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_page_cache mmu_page_cache;
 
@@ -253,4 +260,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 4beb4e277e96..3226696b8340 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -21,4 +21,5 @@ kvm-y += mmu.o
 kvm-y += vcpu.o
 kvm-y += vcpu_exit.o
 kvm-y += vcpu_switch.o
+kvm-y += vcpu_sbi.o
 kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 5acec47236c9..c44cabce7dd8 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -867,6 +867,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
index f659be94231d..13bbc3f73713 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -678,6 +678,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
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
index 000000000000..ebdcdbade9c6
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,185 @@
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
+static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
+				       struct kvm_run *run)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+
+	vcpu->arch.sbi_context.return_handled = 0;
+	vcpu->stat.ecall_exit_stat++;
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
+#ifdef CONFIG_RISCV_SBI_V01
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
+
+#else
+
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	kvm_riscv_vcpu_sbi_forward(vcpu, run);
+	return 0;
+}
+
+#endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..322b4b588d75 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -269,6 +269,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_AP_RESET_HOLD    32
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
+#define KVM_EXIT_RISCV_SBI        35
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -469,6 +470,13 @@ struct kvm_run {
 		} msr;
 		/* KVM_EXIT_XEN */
 		struct kvm_xen_exit xen;
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


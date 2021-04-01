Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650F8351A92
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbhDASCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:06 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24190 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbhDAR5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617299862; x=1648835862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=HSdAmCoZx/n49VBFvLSZcO2206xYyZvjABNckOI8ebI=;
  b=DzckrpMBlRjaFhowKm2BCcHkONDa5yzZR8XCChgPbsKawDRV8TxujdyZ
   fvptInbd7LtJy0l4X1nK9q22CZupufhMTZZVjleKhZkc2kznuX13Jbwsl
   9TEuBfsiv6NTab+HJQtKnS2LoqMbO+lnib2C2soU8d8S+APguMcTwki2S
   L9c/CCyufH8K+9kALTgijOckoxsB9xUSiEKHy9atW92jJWjB/6S0tpF+z
   eTlM0s3KtGE5nK4Tw0Xb2D2NLSADFVhrbGl/k9yW0TdVpwTBv3BpATKzU
   SJiCi1IUZ/BfXTxThwj8L/UqZkVyjglrAZUyG4dNTV4+Oysc6/ITHDYWK
   A==;
IronPort-SDR: aJ6cqMsUR6OWiW7Prl7ddLO4g+w9UuY6gs7Art3Ubbj8bca+qoBc0/pCa3G0psmWGQSnq/R83Q
 LAv0NrfXN3eFjx6m0z0wBwH312OPU22rqUTgzkm+ZIvEhMLOIM18kZoXL+1xjPROXwUknOiAc8
 OFjJWpHnImhKWRLwH0rLrVQqVZh367cmZwS0r5hxU9+Klw9fuCOypbOFMDPqwwT0SqqnJJogcs
 bc1phoj9SIdrBw+hxVUm4tkLBr4KRS+yk93VyHOfczJqbkxGDXwjKQ3yn3FG7mpjPiLN9LoHuU
 wfM=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168041217"
Received: from mail-dm3nam07lp2041.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.41])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:35:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCMrRl8+FoEvdjdQR94omt2uqAzqB3WJqo2sJxbXyWvpmBfOKd8/i8OQLFyornTPhu2KSGjpQeC6+OF970xCbBxFjj6oaIJUF1wJK/4V1e+0rtQhphvsUapVePx0ez1nzgysLEMHf98cN0lq+FHFofSd6Vp4hs/MtJZrqudxydpEBsHWfag+dGrvRkUUyZDr+cPuki+paiAnKRf284BAPkqZRjuaRTFAU0W5fsQXnPprjEB1mRU/z6XEaolRTDvjWHFJc6UbAk+XNMm4eoW/L0jIkfU64P4Mk7lavt8G6ER37Bk4S3UsVOThi+5zGnGTj6DQXQJhEuerVIFjxansCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hO3KMQjfrCzV2hjtP0eEoUUzEX/KxjKxZy/ka5NPRIg=;
 b=bNyMP8dKR0OQjDiIRt18fEonq8zNFOxyj7Gqtv1IaA5ot1i7smkTsEUr8ocl0iayZe/4LBAJPuNZeQWl6twNT/KPPTGpdJzmckdC3UnB2a0H/93o3pqOf+Lo/M40Z3rRh/q+XEssmY0sDNCbESCBodozE4/oSnK8VtlHuraMUewY7vL7QLDf2AbM0FipD63C5FluxPwlAnTd2cf1YXE2TJ1IX4m7qJjmyMlGz5Jz8GDEzoqMD5qBADJlp/GeCYBXQR0nZ557tiJJ5ZzxckEHBhnUch3UQPZeNEm259X7deCpa9exhAoOsj0zslQH4b+b7JsXB4cdYkohNtsb62qW9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hO3KMQjfrCzV2hjtP0eEoUUzEX/KxjKxZy/ka5NPRIg=;
 b=gO+94egs/9E4/8Z599hnzFqFcYEOI/lx4xDoOF9oCd8SN7fUg7w3aB0tIXV/0F2ROvms3tzU6EphJvcUg9bdZxldMeUiPFQsMQwjmIiax3fI06GPMyXrO/MMCYLdThnpwxSJElvMlS0mzMgh2WsKzM1sAUkMpE6hplAB+mXzDVo=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3865.namprd04.prod.outlook.com (2603:10b6:5:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:35:46 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:35:46 +0000
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
Subject: [PATCH v17 02/17] RISC-V: Add initial skeletal KVM support
Date:   Thu,  1 Apr 2021 19:04:20 +0530
Message-Id: <20210401133435.383959-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401133435.383959-1-anup.patel@wdc.com>
References: <20210401133435.383959-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:35:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0808551-f094-4ed7-d8bb-08d8f5130ddb
X-MS-TrafficTypeDiagnostic: DM6PR04MB3865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB3865348487E5E45126456D6D8D7B9@DM6PR04MB3865.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:214;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJEpdBvaeE3vSk1hlcMnNkNrM3hU4UefHDFudKxa0knXWPJWSjKY74WyyDzZesd6AibhoU2U2o/ZuL71yDzp9t8vTk/qFyF7e+zfCltIkHSkkXYiwql+SNtQvHKJXBfATeCtXtvdchHgv6acmBTNE7yIRLcqLSnxfWnttY2L2oeJP1+OXaEnuJIoyAWrcQJHZYLEQCOsYESI3aoQSc88EuaAabwI8Qjd0wimfBVOc9UImcbEUSh0w7eGzylfUW5jO8mv37/MuI7U9vFhaJZmAQQQk9xQhm9fnjTc/Hjtto+BGXKEJjRiFoh5BRo4T+1VNZTn6u+6uZl0hz4ne8tCZyoamTy+F4jSyf6Yj5b8s9FkB7o5Tut5Vt8b41h3ZASag3Qm6dgyvSLIzQO2h2M/aMXxSWwYo0/o92VH1bR1gxj1qVVSUc8IIEzg9bDhwEmZciVbaqFRJeDYlCDF3iJ0RVWXpGluIgfjTBEn6ZwcioXmPVkLWGrR2CgSu9lHLwsp98JbHCxTOcH8kXPPNsYMg9EnLk2ShMj/z++wHU2CVa8D/P8icdKCQXUqhByFbgLSE8NWyHXSxWTM8V/WIplYcT/dfbOB5DevexSEvl0MhMBPrjdnPvZh46IdbUxuv2+Am7XYkoxBVahxtXR0IlJu/m/Jwo5/nN1R4OUKg6kLXII=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(6666004)(36756003)(55016002)(26005)(2906002)(30864003)(83380400001)(66556008)(66476007)(5660300002)(66946007)(7416002)(186003)(16526019)(7696005)(956004)(2616005)(8886007)(38100700001)(8936002)(52116002)(44832011)(54906003)(110136005)(8676002)(316002)(86362001)(4326008)(1076003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MmUk3Ztim3QDb+wVML4BA+f3xmc3ibpWBqCA0lgjtnog94zlSu8GVMOVHzgL?=
 =?us-ascii?Q?zSWsQuK/IsJuMX7NUWZjyEr4S82LzwoofYWtp2ZszOGf+1wQrqfYRrNRH/6P?=
 =?us-ascii?Q?3y0f2N1W5MWYcrm+xg4XsBwfthfG5hyz8TYTiXf8hwppw0cGNPxjb5yPl0Oa?=
 =?us-ascii?Q?z1rNxozHYKtb5egLrYKMV3oobY4bc8qCtN7NBpW22ieLEe9ZT85yCBkosiB+?=
 =?us-ascii?Q?4A8DzMGgVNbmNyBKiy84UGX9E0NycFUSVerlzUP2OXEA3QicLS7URbN1YNQQ?=
 =?us-ascii?Q?yCIWffXrZRMmowmh2noDcfunFAv0M4P7QocBv6bMIJAaQZA41uNr0ObryVSs?=
 =?us-ascii?Q?UP2N67/aGOyHAV13J4k0VnNFbnykGKvdpVM21wlaU8vO6aXt9CZn7J+ss4mu?=
 =?us-ascii?Q?Al/mrWGIAjesLkloUjnuekyf1oXgEKexFq/f1hBwGUbrHmaCgLsc0lWLvVpL?=
 =?us-ascii?Q?ZmSyrirAwh6kNZuIUuKoG9F+9BO7FIc0zdVmIekbX74pmqwK2xkRX43LFy9I?=
 =?us-ascii?Q?K9SaAQ1xuRNsERUxXlC8nHOS1DCl2QDFZ8Linn9HiV7iGeWr8EMN078NZT/M?=
 =?us-ascii?Q?tgq291YxT5D+8pmYALwxx4yT960Es93RkMlZPLaXeiWGl98pBJFZ+SxxryGI?=
 =?us-ascii?Q?n0VvqHGJD7WBf3H4TvMiMzNgG8bMsc+TTdiTRC9gzjqZDaL+gJenhYWyke2a?=
 =?us-ascii?Q?aEHOSCeEJp26RomTVU2P76ZFgBMoULrmGIBeahuyfMS41dxBBianTSplHP4D?=
 =?us-ascii?Q?bvDGBH4QiRGZjmTKwjw0eFk0RoP0/qqevdCWOL15YwNHriMpK7xrg997tAZH?=
 =?us-ascii?Q?bV4l09R+h75EgIyzolY0BDqyo5in2RaLieaFbGyUlaZ8LDplGAex5OPMwXLm?=
 =?us-ascii?Q?J4Dm652hbvJomYPerQy6o0w5HoOToZ1xNLKHz+vA3pDFowN2o8REyfYLQ2wJ?=
 =?us-ascii?Q?uAI/CsU/SQRvV8Kf1SOk1D7aWKujJG3UDoSx6kDtWwA0xm1xtwdR22yScNdR?=
 =?us-ascii?Q?FNHPqzoqXWfWVrUZKOBxxjpY3DDq1kojbGF1/qKF86Fs6FeAU7UkKZBE83PW?=
 =?us-ascii?Q?55il9fFccZ76A7ML+9FUb4WInR1uyoB6J5qtPczEdDt8D7GKtuFfUe6edDRh?=
 =?us-ascii?Q?2pFozFRbq3Dgtr3l+P2+jtjPthyD5jk1QmP5tP54zMCsey8Y30brYpfW2LvV?=
 =?us-ascii?Q?epa8rvlJ3D0meEE8VeqfBZ2pnrQrLYRpuPZHOScZ0OqwT6O/6/RVrq9DPjdN?=
 =?us-ascii?Q?8sxa7j7i+jX8PSg6XCrcH25XDkAcHsC6I3kUv9hh/C/KcQ6pVIDz6zsm91db?=
 =?us-ascii?Q?/+ZJJFQxOOHhmYxzlFmM5XFR5jzHQEtXWYxxq+RLH6iUcA=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0808551-f094-4ed7-d8bb-08d8f5130ddb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:35:46.1548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pcw254FAwr1tgql0QhCue8fShoIPrgobg3sZmnEe+wCUvpW97psPe0bEYy22wFAyNkvqvSyZayghRBOG4QpW1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3865
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds initial skeletal KVM RISC-V support which has:
1. A simple implementation of arch specific VM functions
   except kvm_vm_ioctl_get_dirty_log() which will implemeted
   in-future as part of stage2 page loging.
2. Stubs of required arch specific VCPU functions except
   kvm_arch_vcpu_ioctl_run() which is semi-complete and
   extended by subsequent patches.
3. Stubs for required arch specific stage2 MMU functions.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/Kconfig                 |   1 +
 arch/riscv/Makefile                |   2 +
 arch/riscv/include/asm/kvm_host.h  |  90 +++++++++
 arch/riscv/include/asm/kvm_types.h |   7 +
 arch/riscv/include/uapi/asm/kvm.h  |  47 +++++
 arch/riscv/kvm/Kconfig             |  33 +++
 arch/riscv/kvm/Makefile            |  13 ++
 arch/riscv/kvm/main.c              |  95 +++++++++
 arch/riscv/kvm/mmu.c               |  80 ++++++++
 arch/riscv/kvm/vcpu.c              | 311 +++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c         |  35 ++++
 arch/riscv/kvm/vm.c                |  79 ++++++++
 12 files changed, 793 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_host.h
 create mode 100644 arch/riscv/include/asm/kvm_types.h
 create mode 100644 arch/riscv/include/uapi/asm/kvm.h
 create mode 100644 arch/riscv/kvm/Kconfig
 create mode 100644 arch/riscv/kvm/Makefile
 create mode 100644 arch/riscv/kvm/main.c
 create mode 100644 arch/riscv/kvm/mmu.c
 create mode 100644 arch/riscv/kvm/vcpu.c
 create mode 100644 arch/riscv/kvm/vcpu_exit.c
 create mode 100644 arch/riscv/kvm/vm.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index dc9182680897..45caf2d8c35c 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -475,4 +475,5 @@ source "kernel/power/Kconfig"
 
 endmenu
 
+source "arch/riscv/kvm/Kconfig"
 source "drivers/firmware/Kconfig"
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 1368d943f1f3..7b5a5c7fd9b4 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -88,6 +88,8 @@ head-y := arch/riscv/kernel/head.o
 
 core-y += arch/riscv/
 
+core-$(CONFIG_KVM) += arch/riscv/kvm/
+
 libs-y += arch/riscv/lib/
 libs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
 
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
new file mode 100644
index 000000000000..e1a8f89b2b81
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __RISCV_KVM_HOST_H__
+#define __RISCV_KVM_HOST_H__
+
+#include <linux/types.h>
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
+
+#ifdef CONFIG_64BIT
+#define KVM_MAX_VCPUS			(1U << 16)
+#else
+#define KVM_MAX_VCPUS			(1U << 9)
+#endif
+
+#define KVM_HALT_POLL_NS_DEFAULT	500000
+
+#define KVM_VCPU_MAX_FEATURES		0
+
+#define KVM_REQ_SLEEP \
+	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+
+struct kvm_vm_stat {
+	ulong remote_tlb_flush;
+};
+
+struct kvm_vcpu_stat {
+	u64 halt_successful_poll;
+	u64 halt_attempted_poll;
+	u64 halt_poll_success_ns;
+	u64 halt_poll_fail_ns;
+	u64 halt_poll_invalid;
+	u64 halt_wakeup;
+	u64 ecall_exit_stat;
+	u64 wfi_exit_stat;
+	u64 mmio_exit_user;
+	u64 mmio_exit_kernel;
+	u64 exits;
+};
+
+struct kvm_arch_memory_slot {
+};
+
+struct kvm_arch {
+	/* stage2 page table */
+	pgd_t *pgd;
+	phys_addr_t pgd_phys;
+};
+
+struct kvm_cpu_trap {
+	unsigned long sepc;
+	unsigned long scause;
+	unsigned long stval;
+	unsigned long htval;
+	unsigned long htinst;
+};
+
+struct kvm_vcpu_arch {
+	/* Don't run the VCPU (blocked) */
+	bool pause;
+
+	/* SRCU lock index for in-kernel run loop */
+	int srcu_idx;
+};
+
+static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
+
+void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
+int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
+void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
+void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
+
+int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			struct kvm_cpu_trap *trap);
+
+static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
+
+#endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/asm/kvm_types.h b/arch/riscv/include/asm/kvm_types.h
new file mode 100644
index 000000000000..e476b404eb67
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_types.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_RISCV_KVM_TYPES_H
+#define _ASM_RISCV_KVM_TYPES_H
+
+#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
+
+#endif /* _ASM_RISCV_KVM_TYPES_H */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
new file mode 100644
index 000000000000..984d041a3e3b
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __LINUX_KVM_RISCV_H
+#define __LINUX_KVM_RISCV_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+#define __KVM_HAVE_READONLY_MEM
+
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+
+/* for KVM_GET_REGS and KVM_SET_REGS */
+struct kvm_regs {
+};
+
+/* for KVM_GET_FPU and KVM_SET_FPU */
+struct kvm_fpu {
+};
+
+/* KVM Debug exit structure */
+struct kvm_debug_exit_arch {
+};
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+};
+
+/* definition of registers in kvm_run */
+struct kvm_sync_regs {
+};
+
+/* dummy definition */
+struct kvm_sregs {
+};
+
+#endif
+
+#endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
new file mode 100644
index 000000000000..88edd477b3a8
--- /dev/null
+++ b/arch/riscv/kvm/Kconfig
@@ -0,0 +1,33 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# KVM configuration
+#
+
+source "virt/kvm/Kconfig"
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	help
+	  Say Y here to get to see options for using your Linux host to run
+	  other operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled.
+
+if VIRTUALIZATION
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
+	depends on RISCV_SBI && MMU
+	select PREEMPT_NOTIFIERS
+	select ANON_INODES
+	select KVM_MMIO
+	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select SRCU
+	help
+	  Support hosting virtualized guest machines.
+
+	  If unsure, say N.
+
+endif # VIRTUALIZATION
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
new file mode 100644
index 000000000000..37b5a59d4f4f
--- /dev/null
+++ b/arch/riscv/kvm/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for RISC-V KVM support
+#
+
+common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+
+ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
+
+kvm-objs := $(common-objs-y)
+
+kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o
+
+obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
new file mode 100644
index 000000000000..47926f0c175d
--- /dev/null
+++ b/arch/riscv/kvm/main.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/hwcap.h>
+#include <asm/sbi.h>
+
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_check_processor_compat(void *opaque)
+{
+	return 0;
+}
+
+int kvm_arch_hardware_setup(void *opaque)
+{
+	return 0;
+}
+
+int kvm_arch_hardware_enable(void)
+{
+	unsigned long hideleg, hedeleg;
+
+	hedeleg = 0;
+	hedeleg |= (1UL << EXC_INST_MISALIGNED);
+	hedeleg |= (1UL << EXC_BREAKPOINT);
+	hedeleg |= (1UL << EXC_SYSCALL);
+	hedeleg |= (1UL << EXC_INST_PAGE_FAULT);
+	hedeleg |= (1UL << EXC_LOAD_PAGE_FAULT);
+	hedeleg |= (1UL << EXC_STORE_PAGE_FAULT);
+	csr_write(CSR_HEDELEG, hedeleg);
+
+	hideleg = 0;
+	hideleg |= (1UL << IRQ_VS_SOFT);
+	hideleg |= (1UL << IRQ_VS_TIMER);
+	hideleg |= (1UL << IRQ_VS_EXT);
+	csr_write(CSR_HIDELEG, hideleg);
+
+	csr_write(CSR_HCOUNTEREN, -1UL);
+
+	csr_write(CSR_HVIP, 0);
+
+	return 0;
+}
+
+void kvm_arch_hardware_disable(void)
+{
+	csr_write(CSR_HEDELEG, 0);
+	csr_write(CSR_HIDELEG, 0);
+}
+
+int kvm_arch_init(void *opaque)
+{
+	if (!riscv_isa_extension_available(NULL, h)) {
+		kvm_info("hypervisor extension not available\n");
+		return -ENODEV;
+	}
+
+	if (sbi_spec_is_0_1()) {
+		kvm_info("require SBI v0.2 or higher\n");
+		return -ENODEV;
+	}
+
+	if (sbi_probe_extension(SBI_EXT_RFENCE) <= 0) {
+		kvm_info("require SBI RFENCE extension\n");
+		return -ENODEV;
+	}
+
+	kvm_info("hypervisor extension available\n");
+
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+}
+
+static int riscv_kvm_init(void)
+{
+	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+}
+module_init(riscv_kvm_init);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
new file mode 100644
index 000000000000..abfd2b22fa8e
--- /dev/null
+++ b/arch/riscv/kvm/mmu.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/hugetlb.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/kvm_host.h>
+#include <linux/sched/signal.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+}
+
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
+{
+}
+
+void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
+{
+}
+
+void kvm_arch_flush_shadow_all(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
+{
+}
+
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+				const struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot *old,
+				const struct kvm_memory_slot *new,
+				enum kvm_mr_change change)
+{
+	/* TODO: */
+}
+
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				struct kvm_memory_slot *memslot,
+				const struct kvm_userspace_memory_region *mem,
+				enum kvm_mr_change change)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
new file mode 100644
index 000000000000..6f1c6c8049e1
--- /dev/null
+++ b/arch/riscv/kvm/vcpu.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/signal.h>
+#include <linux/fs.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/delay.h>
+#include <asm/hwcap.h>
+
+struct kvm_stats_debugfs_item debugfs_entries[] = {
+	VCPU_STAT("halt_successful_poll", halt_successful_poll),
+	VCPU_STAT("halt_attempted_poll", halt_attempted_poll),
+	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
+	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
+	VCPU_STAT("halt_poll_invalid", halt_poll_invalid),
+	VCPU_STAT("halt_wakeup", halt_wakeup),
+	VCPU_STAT("ecall_exit_stat", ecall_exit_stat),
+	VCPU_STAT("wfi_exit_stat", wfi_exit_stat),
+	VCPU_STAT("mmio_exit_user", mmio_exit_user),
+	VCPU_STAT("mmio_exit_kernel", mmio_exit_kernel),
+	VCPU_STAT("exits", exits),
+	{ NULL }
+};
+
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	return 0;
+}
+
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
+{
+}
+
+int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+}
+
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return false;
+}
+
+vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+long kvm_arch_vcpu_async_ioctl(struct file *filp,
+			       unsigned int ioctl, unsigned long arg)
+{
+	/* TODO; */
+	return -ENOIOCTLCMD;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	/* TODO: */
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				  struct kvm_translation *tr)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
+{
+	/* TODO; To be implemented later. */
+	return -EINVAL;
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	/* TODO: */
+
+	kvm_riscv_stage2_update_hgatp(vcpu);
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+{
+	int ret;
+	struct kvm_cpu_trap trap;
+	struct kvm_run *run = vcpu->run;
+
+	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	/* Process MMIO value returned from user-space */
+	if (run->exit_reason == KVM_EXIT_MMIO) {
+		ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
+		if (ret) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			return ret;
+		}
+	}
+
+	if (run->immediate_exit) {
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+		return -EINTR;
+	}
+
+	vcpu_load(vcpu);
+
+	kvm_sigset_activate(vcpu);
+
+	ret = 1;
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+	while (ret > 0) {
+		/* Check conditions before entering the guest */
+		cond_resched();
+
+		kvm_riscv_check_vcpu_requests(vcpu);
+
+		preempt_disable();
+
+		local_irq_disable();
+
+		/*
+		 * Exit if we have a signal pending so that we can deliver
+		 * the signal to user space.
+		 */
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			run->exit_reason = KVM_EXIT_INTR;
+		}
+
+		/*
+		 * Ensure we set mode to IN_GUEST_MODE after we disable
+		 * interrupts and before the final VCPU requests check.
+		 * See the comment in kvm_vcpu_exiting_guest_mode() and
+		 * Documentation/virtual/kvm/vcpu-requests.rst
+		 */
+		vcpu->mode = IN_GUEST_MODE;
+
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+		smp_mb__after_srcu_read_unlock();
+
+		if (ret <= 0 ||
+		    kvm_request_pending(vcpu)) {
+			vcpu->mode = OUTSIDE_GUEST_MODE;
+			local_irq_enable();
+			preempt_enable();
+			vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+			continue;
+		}
+
+		guest_enter_irqoff();
+
+		__kvm_riscv_switch_to(&vcpu->arch);
+
+		vcpu->mode = OUTSIDE_GUEST_MODE;
+		vcpu->stat.exits++;
+
+		/*
+		 * Save SCAUSE, STVAL, HTVAL, and HTINST because we might
+		 * get an interrupt between __kvm_riscv_switch_to() and
+		 * local_irq_enable() which can potentially change CSRs.
+		 */
+		trap.sepc = 0;
+		trap.scause = csr_read(CSR_SCAUSE);
+		trap.stval = csr_read(CSR_STVAL);
+		trap.htval = csr_read(CSR_HTVAL);
+		trap.htinst = csr_read(CSR_HTINST);
+
+		/*
+		 * We may have taken a host interrupt in VS/VU-mode (i.e.
+		 * while executing the guest). This interrupt is still
+		 * pending, as we haven't serviced it yet!
+		 *
+		 * We're now back in HS-mode with interrupts disabled
+		 * so enabling the interrupts now will have the effect
+		 * of taking the interrupt again, in HS-mode this time.
+		 */
+		local_irq_enable();
+
+		/*
+		 * We do local_irq_enable() before calling guest_exit() so
+		 * that if a timer interrupt hits while running the guest
+		 * we account that tick as being spent in the guest. We
+		 * enable preemption after calling guest_exit() so that if
+		 * we get preempted we make sure ticks after that is not
+		 * counted as guest time.
+		 */
+		guest_exit();
+
+		preempt_enable();
+
+		vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+		ret = kvm_riscv_vcpu_exit(vcpu, run, &trap);
+	}
+
+	kvm_sigset_deactivate(vcpu);
+
+	vcpu_put(vcpu);
+
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+
+	return ret;
+}
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
new file mode 100644
index 000000000000..4484e9200fe4
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+
+/**
+ * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulation
+ *			     or in-kernel IO emulation
+ *
+ * @vcpu: The VCPU pointer
+ * @run:  The VCPU run struct containing the mmio data
+ */
+int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	/* TODO: */
+	return 0;
+}
+
+/*
+ * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
+ * proper exit to userspace.
+ */
+int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			struct kvm_cpu_trap *trap)
+{
+	/* TODO: */
+	return 0;
+}
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
new file mode 100644
index 000000000000..d6776b4819bb
--- /dev/null
+++ b/arch/riscv/kvm/vm.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_host.h>
+
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+{
+	/* TODO: To be added later. */
+	return -EOPNOTSUPP;
+}
+
+int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
+{
+	int r;
+
+	r = kvm_riscv_stage2_alloc_pgd(kvm);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (kvm->vcpus[i]) {
+			kvm_arch_vcpu_destroy(kvm->vcpus[i]);
+			kvm->vcpus[i] = NULL;
+		}
+	}
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_DEVICE_CTRL:
+	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
+	case KVM_CAP_ONE_REG:
+	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_MP_STATE:
+	case KVM_CAP_IMMEDIATE_EXIT:
+		r = 1;
+		break;
+	case KVM_CAP_NR_VCPUS:
+		r = num_online_cpus();
+		break;
+	case KVM_CAP_MAX_VCPUS:
+		r = KVM_MAX_VCPUS;
+		break;
+	case KVM_CAP_NR_MEMSLOTS:
+		r = KVM_USER_MEM_SLOTS;
+		break;
+	default:
+		r = 0;
+		break;
+	}
+
+	return r;
+}
+
+long kvm_arch_vm_ioctl(struct file *filp,
+		       unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
-- 
2.25.1


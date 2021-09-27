Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFC8419349
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhI0LnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:43:22 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11275 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbhI0LnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742892; x=1664278892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RdblwgDF62LuP9QpJM/UHJEqwbC2bYsYJ5uJTengtgY=;
  b=SIcX236aJlBCwI05e8nEZGSlGZv0uKO+FrvaPjpNkXTU4TSpUs+B8a/Z
   ZqiuWCfFe0A5qMFCQiJ/rcsaA6+httra7TG/X4BBajmv7ujiS85GvAvZv
   F/P1s7iib1/2bLaDWH5snUuTw/h56toyj1ILCAbvNAmMXcOuzkIzl9waP
   XxuDZg4AKOSrH8LtVkfOXgKC8jq9mcR8CPiv4Y0MpiAfYpHuHzyUgmehr
   KyXQN+qzhLto3LoZOPfWbLRJ6AfXL+ra3cNzBe35d7vvMIFbCCbs7c4CY
   BlPgANrr6emERGQymjGvLLXE5885qyRHGkNusctCBE5OmzvzTGENBIJ0R
   w==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="284861889"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:41:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jG1taQ+/PP9/5DOUYJIFEsuvZXtBfK6tatAugC9elNx9IBZ2yRErUGhSbdnrN4ka4p2yWp9ZGJ1it1Z/6DQQ5QwoCthLLdQaZEgmkJyJia0VSYLbd2iYOg93FPnLzUQnPDmGiLXkT/186jZa5zkABm6Zrwd9b0RrBLXsHjlqBWGyo02ypTJ2aDQIps26L6GTYuztJKs8pvba14o0JTgGiGU6zyUXFXQgFCUs9dovJqGqwXe7Z3XwCzBG2nw4VIHkTFXNbkttZNa4k44/y/ZYTSJg2k6Mhr8h2J2hiPlzg/qinYuqdzc69TXKBXxVCAZGwc2sstNhYhoGAPyNEfFq6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LfDt9uXKDUhbxBYNUXJq5/R/W5fgu7gIvHIW2E+eczs=;
 b=SvmmHQpuiDJY2tCj491o3VWLCyaVPZuemIfg94zwvHSWbWEAn1FUap4JNGA5vETaG2iploeVmA0NHRg+XWTy1SvMjAK+FCLx2cgiTqh/oBh1WhlerTkBDlre0JiQix3O1GnRO+CrGTiviLXWdyYb+L5YuXm2iRQTC8kZJnerzdlVfN6stC9TTCZNC3SGkGSOkXJiS0uicUmQdiaqHGJ/wNOyEnTdIkHw6/T2/Sn/uuF9aQDzuWz9XrvgC1oU0OOQcZ+CydRUf9cJFSMHNmAwdizIiQf8VnokJRjSn2OX439LMqraqXasNshYnNWzQ1sjXnMWO3lz1uTv9bdZLapoGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfDt9uXKDUhbxBYNUXJq5/R/W5fgu7gIvHIW2E+eczs=;
 b=WkX/RmpsEH/v7V9yoYCQLo4qZ/ueawQIWPp26J4BN8xrowBOIbgWoMj/Qy6xIkCVW3uwGCsj6u9eXfLE6NQCmA9IWf5rokaoTV6JLOUKy+tt0Qu7DEmiJrt8i2u6wgs6Lg3R5oIF2lpmXRhYOhji+MYXj1YT0WnIfmwqeaBsyhQ=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:41:29 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:41:29 +0000
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
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH v20 10/17] RISC-V: KVM: Implement stage2 page table programming
Date:   Mon, 27 Sep 2021 17:10:09 +0530
Message-Id: <20210927114016.1089328-11-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:41:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f889d728-5bff-4ccb-0c90-08d981abbe88
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB82361A79A8A94D094D85AFE48DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4S6YejKR3j4ADZbG+c2qXy09QszS4XMq2HfMO3YU1MsznmMz7/pRHNYeE5sXrVreoBeJlZ/VfIsziH7ICez0tfIvJ5Oe+mv3I/vBQ0n/1E3zRsSN52gRcB720VJkkHuIFwDuZqgsB+QXRZ8D4EW34SUMkJMMWOi7UeUC5n02aEB+v22yUzT1VmLBrJjNCRIK7EEJQb/sh8KnDVrZ+O99EHZ2X4ro9CKMQXhkpelvOUJnRNxBtJmDZ10V98rjFTyzDZ6xXwhWMzXUrYB4+/j29hWYzgV4FL3YHDxfKYZdJxauA/qmZdCncm5sNEQb/9aBhQWoQblZsUVinrpxpVv39L08xawhUkCdgyT7ol6SkPC3nLDC8pormE02GOBjJZIdq0jx9NOKl5qjc/Mc7VxuGhimjP63bmlfoVdH8aJ3BSlyRLOx6PRbKuTQ1WlQMWZEm/aztfqGUDsrlx6MAKydcYcruv32PGlDx4GwX4yIKXqlsdFOUNR1Ih8+Pk+BjuvkVRXNIeSv43tkxFomMp2mkf9yL/PdLcyOXF0VEmEjgCAyiMpsHCNAazbaF7Kuj1HA1X4gJlIA8G49UGfbuExXNX92jhsIHCWDRIj3xDBKd8gGS+oGoihpmwqgE2YyL9aJBmDynZoDmyJnTvay+HZuDRZx7yVPNwJjJ3agR49HayktPlH6CYJ+H7ju4bnleve2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(44832011)(38100700002)(54906003)(110136005)(186003)(55016002)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(7416002)(26005)(83380400001)(30864003)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fCTEdaV9vMvF2mFuSK5+yKYGxXtpclCEgFT5a/YSgseryYZqpEC1LdNYOzx7?=
 =?us-ascii?Q?3ZXOeue89m7xA3qc0Wg6volY5tXpmZRv32SBM9Qbe1Lv6t5XwAY73rlMkpVD?=
 =?us-ascii?Q?ZOfRHod2gP4f0s/Zxqln68Wnq0u1FZa9zI2nNaaC8k4fxM28n+ZSZWRPXsur?=
 =?us-ascii?Q?QerT7ZRFyELhQszoFUS4PVgiUv5M5qxr451Z3206TPV9Hx7xbc4DkT3fTGfF?=
 =?us-ascii?Q?eHah/Y8BHiv3kKZJqbo3bdFK16LJEnZE73Mgjc7sATWZaEuSe5MknEmDcyS8?=
 =?us-ascii?Q?3j5QItAtCGu14WLcpJbSj8XHi1CA4PcHFwKmQo77xVDwRCTQYCx28jCfo0QL?=
 =?us-ascii?Q?ZncsglFzko0dL+uZtXQ0x6sx4mo/yTAb8XQdRbkTKQYp2yFZJwEOQfP3e9TW?=
 =?us-ascii?Q?U1BWTOHc7sPr2SGVEA4LOmP+6aKAk5pCBrACabThtk8nfKYeyHqNb4OIgqk8?=
 =?us-ascii?Q?zdqdz9fswmc8IBe035IsqeueXRTv+4sfbfqeBrp9IjGC6ysZD/M2ffunldIf?=
 =?us-ascii?Q?LWdQt1kWbhLljZCKetbxEAVIkBcro2t3S94GytiTuxxb7qh++4LnctV2CHGc?=
 =?us-ascii?Q?hQxAKEF0UhyMgO380RLfukpkuKZ9hho2JkPoxqsB0jmf8yrNK/W9v26G8sxP?=
 =?us-ascii?Q?HKGrI9XJXMV8AU4C3ZgnfN9xPMPsDIKRKCNhB9rJE8xrqBCGViyteuaTFR6K?=
 =?us-ascii?Q?2oueqc+KxB9I/wN6djlfYIATS2gNPA8XL8RZzwdZ/6J2ljLPPHNz3jys+3T9?=
 =?us-ascii?Q?HWXzkv3ZmA/u/QkMM2n1UTlT7QkoDa1gMiMuoasqf09i17McIpA2WmONz5xF?=
 =?us-ascii?Q?4fCzyys00w4NWgG0oOGosvXCvCQfJbsq0oMIwYqbUhlYZTMwE5zDkIARs5pH?=
 =?us-ascii?Q?PCMlccChVXKWoCDUT401BUQeQgiZqm7Am/u2Z8+JMtqKdFxdtu8s9i6yEwhe?=
 =?us-ascii?Q?7UL2foN7B10JFncjoOhh1lEdJaXmhGzS4iVqTvdAda36Em3oHWPOduEBdvte?=
 =?us-ascii?Q?yc7PL6jsHoGpkFjb/SR4Lus2fOgP1sY+Vghj51Ry9aJlvZTPx6P1bUij5C9o?=
 =?us-ascii?Q?CkkigAGsyUmMoeg1LTMWwyK6Q3jwv/Yxmn9ErAajIZnZhbFrBIWZPI7n2Uvo?=
 =?us-ascii?Q?nMpS5cNs3+mZdzbPCEJJc3XDhHJB2jYUt3b4143Ghyn+37m7JAOwWjRyWp7e?=
 =?us-ascii?Q?iJu3cw5vJB0joO5yXREN2hBiy+tpzjNe/zsxme5pi1PFHjQly74gbwLXYM6d?=
 =?us-ascii?Q?J1QZy8YwJldDoHAUDRGmKVGbfFc+J962VFXC3w12CgiaIkCjPhmwzQ1W0x7O?=
 =?us-ascii?Q?ts6dcTtjWM2zppensNeikig7?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f889d728-5bff-4ccb-0c90-08d981abbe88
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:28.9028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SCB4yCkwg305i26Ie7BQz33dvj9lH+2ZJYF6pn7QH6ZQPWiBrqL0t6a8T4GFPkVk/JJtlrwtNGYy+j+2BqQC4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements all required functions for programming
the stage2 page table for each Guest/VM.

At high-level, the flow of stage2 related functions is similar
from KVM ARM/ARM64 implementation but the stage2 page table
format is quite different for KVM RISC-V.

[jiangyifei: stage2 dirty log support]
Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h |  12 +
 arch/riscv/kvm/Kconfig            |   1 +
 arch/riscv/kvm/main.c             |  19 +
 arch/riscv/kvm/mmu.c              | 654 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vm.c               |   6 -
 5 files changed, 676 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 69c342430242..2e71a353395e 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -70,6 +70,13 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+#define KVM_MMU_PAGE_CACHE_NR_OBJS	32
+
+struct kvm_mmu_page_cache {
+	int nobjs;
+	void *objects[KVM_MMU_PAGE_CACHE_NR_OBJS];
+};
+
 struct kvm_cpu_trap {
 	unsigned long sepc;
 	unsigned long scause;
@@ -171,6 +178,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* Cache pages needed to program page tables with spinlock held */
+	struct kvm_mmu_page_cache mmu_page_cache;
+
 	/* VCPU power-off state */
 	bool power_off;
 
@@ -198,6 +208,8 @@ void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
+void kvm_riscv_stage2_mode_detect(void);
+unsigned long kvm_riscv_stage2_mode(void);
 
 void kvm_riscv_stage2_vmid_detect(void);
 unsigned long kvm_riscv_stage2_vmid_bits(void);
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index b42979f84042..633063edaee8 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -23,6 +23,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select KVM_MMIO
+	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_EVENTFD
 	select SRCU
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 49a4941e3838..421ecf4e6360 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -64,6 +64,8 @@ void kvm_arch_hardware_disable(void)
 
 int kvm_arch_init(void *opaque)
 {
+	const char *str;
+
 	if (!riscv_isa_extension_available(NULL, h)) {
 		kvm_info("hypervisor extension not available\n");
 		return -ENODEV;
@@ -79,10 +81,27 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	kvm_riscv_stage2_mode_detect();
+
 	kvm_riscv_stage2_vmid_detect();
 
 	kvm_info("hypervisor extension available\n");
 
+	switch (kvm_riscv_stage2_mode()) {
+	case HGATP_MODE_SV32X4:
+		str = "Sv32x4";
+		break;
+	case HGATP_MODE_SV39X4:
+		str = "Sv39x4";
+		break;
+	case HGATP_MODE_SV48X4:
+		str = "Sv48x4";
+		break;
+	default:
+		return -ENODEV;
+	}
+	kvm_info("using %s G-stage page table format\n", str);
+
 	kvm_info("VMID %ld bits available\n", kvm_riscv_stage2_vmid_bits());
 
 	return 0;
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 8ec10ef861e7..fa9a4f9b9542 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -15,13 +15,421 @@
 #include <linux/vmalloc.h>
 #include <linux/kvm_host.h>
 #include <linux/sched/signal.h>
+#include <asm/csr.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/sbi.h>
+
+#ifdef CONFIG_64BIT
+static unsigned long stage2_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
+static unsigned long stage2_pgd_levels = 3;
+#define stage2_index_bits	9
+#else
+static unsigned long stage2_mode = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
+static unsigned long stage2_pgd_levels = 2;
+#define stage2_index_bits	10
+#endif
+
+#define stage2_pgd_xbits	2
+#define stage2_pgd_size	(1UL << (HGATP_PAGE_SHIFT + stage2_pgd_xbits))
+#define stage2_gpa_bits	(HGATP_PAGE_SHIFT + \
+			 (stage2_pgd_levels * stage2_index_bits) + \
+			 stage2_pgd_xbits)
+#define stage2_gpa_size	((gpa_t)(1ULL << stage2_gpa_bits))
+
+#define stage2_pte_leaf(__ptep)	\
+	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
+
+static inline unsigned long stage2_pte_index(gpa_t addr, u32 level)
+{
+	unsigned long mask;
+	unsigned long shift = HGATP_PAGE_SHIFT + (stage2_index_bits * level);
+
+	if (level == (stage2_pgd_levels - 1))
+		mask = (PTRS_PER_PTE * (1UL << stage2_pgd_xbits)) - 1;
+	else
+		mask = PTRS_PER_PTE - 1;
+
+	return (addr >> shift) & mask;
+}
+
+static inline unsigned long stage2_pte_page_vaddr(pte_t pte)
+{
+	return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
+}
+
+static int stage2_page_size_to_level(unsigned long page_size, u32 *out_level)
+{
+	u32 i;
+	unsigned long psz = 1UL << 12;
+
+	for (i = 0; i < stage2_pgd_levels; i++) {
+		if (page_size == (psz << (i * stage2_index_bits))) {
+			*out_level = i;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int stage2_level_to_page_size(u32 level, unsigned long *out_pgsize)
+{
+	if (stage2_pgd_levels < level)
+		return -EINVAL;
+
+	*out_pgsize = 1UL << (12 + (level * stage2_index_bits));
+
+	return 0;
+}
+
+static int stage2_cache_topup(struct kvm_mmu_page_cache *pcache,
+			      int min, int max)
+{
+	void *page;
+
+	BUG_ON(max > KVM_MMU_PAGE_CACHE_NR_OBJS);
+	if (pcache->nobjs >= min)
+		return 0;
+	while (pcache->nobjs < max) {
+		page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return -ENOMEM;
+		pcache->objects[pcache->nobjs++] = page;
+	}
+
+	return 0;
+}
+
+static void stage2_cache_flush(struct kvm_mmu_page_cache *pcache)
+{
+	while (pcache && pcache->nobjs)
+		free_page((unsigned long)pcache->objects[--pcache->nobjs]);
+}
+
+static void *stage2_cache_alloc(struct kvm_mmu_page_cache *pcache)
+{
+	void *p;
+
+	if (!pcache)
+		return NULL;
+
+	BUG_ON(!pcache->nobjs);
+	p = pcache->objects[--pcache->nobjs];
+
+	return p;
+}
+
+static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
+				  pte_t **ptepp, u32 *ptep_level)
+{
+	pte_t *ptep;
+	u32 current_level = stage2_pgd_levels - 1;
+
+	*ptep_level = current_level;
+	ptep = (pte_t *)kvm->arch.pgd;
+	ptep = &ptep[stage2_pte_index(addr, current_level)];
+	while (ptep && pte_val(*ptep)) {
+		if (stage2_pte_leaf(ptep)) {
+			*ptep_level = current_level;
+			*ptepp = ptep;
+			return true;
+		}
+
+		if (current_level) {
+			current_level--;
+			*ptep_level = current_level;
+			ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+			ptep = &ptep[stage2_pte_index(addr, current_level)];
+		} else {
+			ptep = NULL;
+		}
+	}
+
+	return false;
+}
+
+static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
+{
+	struct cpumask hmask;
+	unsigned long size = PAGE_SIZE;
+	struct kvm_vmid *vmid = &kvm->arch.vmid;
+
+	if (stage2_level_to_page_size(level, &size))
+		return;
+	addr &= ~(size - 1);
+
+	/*
+	 * TODO: Instead of cpu_online_mask, we should only target CPUs
+	 * where the Guest/VM is running.
+	 */
+	preempt_disable();
+	riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
+	sbi_remote_hfence_gvma_vmid(cpumask_bits(&hmask), addr, size,
+				    READ_ONCE(vmid->vmid));
+	preempt_enable();
+}
+
+static int stage2_set_pte(struct kvm *kvm, u32 level,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t addr, const pte_t *new_pte)
+{
+	u32 current_level = stage2_pgd_levels - 1;
+	pte_t *next_ptep = (pte_t *)kvm->arch.pgd;
+	pte_t *ptep = &next_ptep[stage2_pte_index(addr, current_level)];
+
+	if (current_level < level)
+		return -EINVAL;
+
+	while (current_level != level) {
+		if (stage2_pte_leaf(ptep))
+			return -EEXIST;
+
+		if (!pte_val(*ptep)) {
+			next_ptep = stage2_cache_alloc(pcache);
+			if (!next_ptep)
+				return -ENOMEM;
+			*ptep = pfn_pte(PFN_DOWN(__pa(next_ptep)),
+					__pgprot(_PAGE_TABLE));
+		} else {
+			if (stage2_pte_leaf(ptep))
+				return -EEXIST;
+			next_ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+		}
+
+		current_level--;
+		ptep = &next_ptep[stage2_pte_index(addr, current_level)];
+	}
+
+	*ptep = *new_pte;
+	if (stage2_pte_leaf(ptep))
+		stage2_remote_tlb_flush(kvm, current_level, addr);
+
+	return 0;
+}
+
+static int stage2_map_page(struct kvm *kvm,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t gpa, phys_addr_t hpa,
+			   unsigned long page_size,
+			   bool page_rdonly, bool page_exec)
+{
+	int ret;
+	u32 level = 0;
+	pte_t new_pte;
+	pgprot_t prot;
+
+	ret = stage2_page_size_to_level(page_size, &level);
+	if (ret)
+		return ret;
+
+	/*
+	 * A RISC-V implementation can choose to either:
+	 * 1) Update 'A' and 'D' PTE bits in hardware
+	 * 2) Generate page fault when 'A' and/or 'D' bits are not set
+	 *    PTE so that software can update these bits.
+	 *
+	 * We support both options mentioned above. To achieve this, we
+	 * always set 'A' and 'D' PTE bits at time of creating stage2
+	 * mapping. To support KVM dirty page logging with both options
+	 * mentioned above, we will write-protect stage2 PTEs to track
+	 * dirty pages.
+	 */
+
+	if (page_exec) {
+		if (page_rdonly)
+			prot = PAGE_READ_EXEC;
+		else
+			prot = PAGE_WRITE_EXEC;
+	} else {
+		if (page_rdonly)
+			prot = PAGE_READ;
+		else
+			prot = PAGE_WRITE;
+	}
+	new_pte = pfn_pte(PFN_DOWN(hpa), prot);
+	new_pte = pte_mkdirty(new_pte);
+
+	return stage2_set_pte(kvm, level, pcache, gpa, &new_pte);
+}
+
+enum stage2_op {
+	STAGE2_OP_NOP = 0,	/* Nothing */
+	STAGE2_OP_CLEAR,	/* Clear/Unmap */
+	STAGE2_OP_WP,		/* Write-protect */
+};
+
+static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
+			  pte_t *ptep, u32 ptep_level, enum stage2_op op)
+{
+	int i, ret;
+	pte_t *next_ptep;
+	u32 next_ptep_level;
+	unsigned long next_page_size, page_size;
+
+	ret = stage2_level_to_page_size(ptep_level, &page_size);
+	if (ret)
+		return;
+
+	BUG_ON(addr & (page_size - 1));
+
+	if (!pte_val(*ptep))
+		return;
+
+	if (ptep_level && !stage2_pte_leaf(ptep)) {
+		next_ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+		next_ptep_level = ptep_level - 1;
+		ret = stage2_level_to_page_size(next_ptep_level,
+						&next_page_size);
+		if (ret)
+			return;
+
+		if (op == STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		for (i = 0; i < PTRS_PER_PTE; i++)
+			stage2_op_pte(kvm, addr + i * next_page_size,
+					&next_ptep[i], next_ptep_level, op);
+		if (op == STAGE2_OP_CLEAR)
+			put_page(virt_to_page(next_ptep));
+	} else {
+		if (op == STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		else if (op == STAGE2_OP_WP)
+			set_pte(ptep, __pte(pte_val(*ptep) & ~_PAGE_WRITE));
+		stage2_remote_tlb_flush(kvm, ptep_level, addr);
+	}
+}
+
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	unsigned long page_size;
+	gpa_t addr = start, end = start + size;
+
+	while (addr < end) {
+		found_leaf = stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret = stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_CLEAR);
+
+next:
+		addr += page_size;
+	}
+}
+
+static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	gpa_t addr = start;
+	unsigned long page_size;
+
+	while (addr < end) {
+		found_leaf = stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret = stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_WP);
+
+next:
+		addr += page_size;
+	}
+}
+
+static void stage2_wp_memory_region(struct kvm *kvm, int slot)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
+	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	spin_lock(&kvm->mmu_lock);
+	stage2_wp_range(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
+	kvm_flush_remote_tlbs(kvm);
+}
+
+static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
+			  unsigned long size, bool writable)
+{
+	pte_t pte;
+	int ret = 0;
+	unsigned long pfn;
+	phys_addr_t addr, end;
+	struct kvm_mmu_page_cache pcache = { 0, };
+
+	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
+	pfn = __phys_to_pfn(hpa);
+
+	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
+		pte = pfn_pte(pfn, PAGE_KERNEL);
+
+		if (!writable)
+			pte = pte_wrprotect(pte);
+
+		ret = stage2_cache_topup(&pcache,
+					 stage2_pgd_levels,
+					 KVM_MMU_PAGE_CACHE_NR_OBJS);
+		if (ret)
+			goto out;
+
+		spin_lock(&kvm->mmu_lock);
+		ret = stage2_set_pte(kvm, 0, &pcache, addr, &pte);
+		spin_unlock(&kvm->mmu_lock);
+		if (ret)
+			goto out;
+
+		pfn++;
+	}
+
+out:
+	stage2_cache_flush(&pcache);
+	return ret;
+
+}
+
+void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
+					     struct kvm_memory_slot *slot,
+					     gfn_t gfn_offset,
+					     unsigned long mask)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+
+	stage2_wp_range(kvm, start, end);
+}
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 }
 
+void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
+					const struct kvm_memory_slot *memslot)
+{
+	kvm_flush_remote_tlbs(kvm);
+}
+
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
 {
 }
@@ -32,7 +440,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	/* TODO: */
+	kvm_riscv_stage2_free_pgd(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -46,7 +454,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	/* TODO: */
+	/*
+	 * At this point memslot has been committed and there is an
+	 * allocated dirty_bitmap[], dirty pages will be tracked while
+	 * the memory slot is write protected.
+	 */
+	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
+		stage2_wp_memory_region(kvm, mem->slot);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -54,35 +468,255 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
-	/* TODO: */
-	return 0;
+	hva_t hva = mem->userspace_addr;
+	hva_t reg_end = hva + mem->memory_size;
+	bool writable = !(mem->flags & KVM_MEM_READONLY);
+	int ret = 0;
+
+	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
+			change != KVM_MR_FLAGS_ONLY)
+		return 0;
+
+	/*
+	 * Prevent userspace from creating a memory region outside of the GPA
+	 * space addressable by the KVM guest GPA space.
+	 */
+	if ((memslot->base_gfn + memslot->npages) >=
+	    (stage2_gpa_size >> PAGE_SHIFT))
+		return -EFAULT;
+
+	mmap_read_lock(current->mm);
+
+	/*
+	 * A memory region could potentially cover multiple VMAs, and
+	 * any holes between them, so iterate over all of them to find
+	 * out if we can map any of them right now.
+	 *
+	 *     +--------------------------------------------+
+	 * +---------------+----------------+   +----------------+
+	 * |   : VMA 1     |      VMA 2     |   |    VMA 3  :    |
+	 * +---------------+----------------+   +----------------+
+	 *     |               memory region                |
+	 *     +--------------------------------------------+
+	 */
+	do {
+		struct vm_area_struct *vma = find_vma(current->mm, hva);
+		hva_t vm_start, vm_end;
+
+		if (!vma || vma->vm_start >= reg_end)
+			break;
+
+		/*
+		 * Mapping a read-only VMA is only allowed if the
+		 * memory region is configured as read-only.
+		 */
+		if (writable && !(vma->vm_flags & VM_WRITE)) {
+			ret = -EPERM;
+			break;
+		}
+
+		/* Take the intersection of this VMA with the memory region */
+		vm_start = max(hva, vma->vm_start);
+		vm_end = min(reg_end, vma->vm_end);
+
+		if (vma->vm_flags & VM_PFNMAP) {
+			gpa_t gpa = mem->guest_phys_addr +
+				    (vm_start - mem->userspace_addr);
+			phys_addr_t pa;
+
+			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
+			pa += vm_start - vma->vm_start;
+
+			/* IO region dirty page logging not allowed */
+			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			ret = stage2_ioremap(kvm, gpa, pa,
+					     vm_end - vm_start, writable);
+			if (ret)
+				break;
+		}
+		hva = vm_end;
+	} while (hva < reg_end);
+
+	if (change == KVM_MR_FLAGS_ONLY)
+		goto out;
+
+	spin_lock(&kvm->mmu_lock);
+	if (ret)
+		stage2_unmap_range(kvm, mem->guest_phys_addr,
+				   mem->memory_size);
+	spin_unlock(&kvm->mmu_lock);
+
+out:
+	mmap_read_unlock(current->mm);
+	return ret;
 }
 
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write)
 {
-	/* TODO: */
-	return 0;
+	int ret;
+	kvm_pfn_t hfn;
+	bool writeable;
+	short vma_pageshift;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	struct vm_area_struct *vma;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
+	bool logging = (memslot->dirty_bitmap &&
+			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
+	unsigned long vma_pagesize;
+
+	mmap_read_lock(current->mm);
+
+	vma = find_vma_intersection(current->mm, hva, hva + 1);
+	if (unlikely(!vma)) {
+		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+		mmap_read_unlock(current->mm);
+		return -EFAULT;
+	}
+
+	if (is_vm_hugetlb_page(vma))
+		vma_pageshift = huge_page_shift(hstate_vma(vma));
+	else
+		vma_pageshift = PAGE_SHIFT;
+	vma_pagesize = 1ULL << vma_pageshift;
+	if (logging || (vma->vm_flags & VM_PFNMAP))
+		vma_pagesize = PAGE_SIZE;
+
+	if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
+		gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
+
+	mmap_read_unlock(current->mm);
+
+	if (vma_pagesize != PGDIR_SIZE &&
+	    vma_pagesize != PMD_SIZE &&
+	    vma_pagesize != PAGE_SIZE) {
+		kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
+		return -EFAULT;
+	}
+
+	/* We need minimum second+third level pages */
+	ret = stage2_cache_topup(pcache, stage2_pgd_levels,
+				 KVM_MMU_PAGE_CACHE_NR_OBJS);
+	if (ret) {
+		kvm_err("Failed to topup stage2 cache\n");
+		return ret;
+	}
+
+	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
+	if (hfn == KVM_PFN_ERR_HWPOISON) {
+		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
+				vma_pageshift, current);
+		return 0;
+	}
+	if (is_error_noslot_pfn(hfn))
+		return -EFAULT;
+
+	/*
+	 * If logging is active then we allow writable pages only
+	 * for write faults.
+	 */
+	if (logging && !is_write)
+		writeable = false;
+
+	spin_lock(&kvm->mmu_lock);
+
+	if (writeable) {
+		kvm_set_pfn_dirty(hfn);
+		mark_page_dirty(kvm, gfn);
+		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+				      vma_pagesize, false, true);
+	} else {
+		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+				      vma_pagesize, true, true);
+	}
+
+	if (ret)
+		kvm_err("Failed to map in stage2\n");
+
+	spin_unlock(&kvm->mmu_lock);
+	kvm_set_pfn_accessed(hfn);
+	kvm_release_pfn_clean(hfn);
+	return ret;
 }
 
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	stage2_cache_flush(&vcpu->arch.mmu_page_cache);
 }
 
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 {
-	/* TODO: */
+	struct page *pgd_page;
+
+	if (kvm->arch.pgd != NULL) {
+		kvm_err("kvm_arch already initialized?\n");
+		return -EINVAL;
+	}
+
+	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				get_order(stage2_pgd_size));
+	if (!pgd_page)
+		return -ENOMEM;
+	kvm->arch.pgd = page_to_virt(pgd_page);
+	kvm->arch.pgd_phys = page_to_phys(pgd_page);
+
 	return 0;
 }
 
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 {
-	/* TODO: */
+	void *pgd = NULL;
+
+	spin_lock(&kvm->mmu_lock);
+	if (kvm->arch.pgd) {
+		stage2_unmap_range(kvm, 0UL, stage2_gpa_size);
+		pgd = READ_ONCE(kvm->arch.pgd);
+		kvm->arch.pgd = NULL;
+		kvm->arch.pgd_phys = 0;
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	if (pgd)
+		free_pages((unsigned long)pgd, get_order(stage2_pgd_size));
 }
 
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	unsigned long hgatp = stage2_mode;
+	struct kvm_arch *k = &vcpu->kvm->arch;
+
+	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
+		 HGATP_VMID_MASK;
+	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
+
+	csr_write(CSR_HGATP, hgatp);
+
+	if (!kvm_riscv_stage2_vmid_bits())
+		__kvm_riscv_hfence_gvma_all();
+}
+
+void kvm_riscv_stage2_mode_detect(void)
+{
+#ifdef CONFIG_64BIT
+	/* Try Sv48x4 stage2 mode */
+	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
+		stage2_mode = (HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
+		stage2_pgd_levels = 4;
+	}
+	csr_write(CSR_HGATP, 0);
+
+	__kvm_riscv_hfence_gvma_all();
+#endif
+}
+
+unsigned long kvm_riscv_stage2_mode(void)
+{
+	return stage2_mode >> HGATP_MODE_SHIFT;
 }
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 42e75dc8ab06..e2834ab9044c 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -27,12 +27,6 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 		       sizeof(kvm_vm_stats_desc),
 };
 
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
-{
-	/* TODO: To be added later. */
-	return -EOPNOTSUPP;
-}
-
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int r;
-- 
2.25.1


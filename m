Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D548D2F78D6
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbhAOMYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:24:05 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48776 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731288AbhAOMYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713442; x=1642249442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=J2cpvmLca+bcZNIfvwwazEWUDVCS+mUesMImd32OCKI=;
  b=TimrLgdDi5RTNXn3nqr4wSpeKCM6l/pUZvqZaNeuFN0EuYjp7D6UcYjG
   YhnH+xswRFdhCtMwgR47AolMmpQBOBpvpBW9MWRBt0laczL5smNvIElhw
   42RpH6EBGRF4zIV4dwYY2kH0KiyAu09KYAQHpYRD6nmURDLOuYBbDUdyF
   H+mOSbyI2Fa9Z/cX/te5bOjJBZ/noyj/5gRdSW2Fiz8dJg8y7CYL3zJSH
   LhKI10AQG60iuYWAJweZDpjiL8zOphWWZxSzd6q4+GgJnLKYFACU/9vFf
   xbTiTp9O2vf7FJ8zhpH5dlmh7xPrX9gshi7BxUSL7OSOTOEshMFjVhQbQ
   A==;
IronPort-SDR: k8GldbNncJ0CxCItAXf8XH+VYb+gMGf+180PCMT1jDF6L59ksWB5cxGdChARcVVdehF0esSEjI
 0eo3lWWQGwU5uX8o0yyOIbwRGyI0vqWY7nLS4qPmLGm06UFbc1/SBp3ndTh5D8O6HEPCMcwinj
 IIjfJoB02I7N75nA6l+GouZqI/SbGao3f3zFX0kg2TrEB4/As4mOKVyFfTGBfnZqpfH6pQICr+
 VnIqWGoC303iGPxnFtAxX7uI2kqDzgEAINGJr7zIq09PzDdaQAa3fMDlyyCMoOI2E9pddfUeXP
 xFk=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="158687569"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:22:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+q2pq5ze2jZwYIhkNq8NQYFZ02Oflb+mFnymM4Y5JufXNEB1kCfw4pSxjyb6XWIdX+zkmigtIU4StdJk68a9Mb3gi4vTIXhAUjm3ebYsEegaa9ulYJb6qqTus0bSjXnUTu4Dx5NglO1ks/vjQScoTgmJWUOWTSQgQ65N7ReelBNXzSQQ/v5Z41X7lLYJNE1mCspv+2rxAefKW9oAYC+9L15v2p4bCtPy13MbrQyfm7iPGZuL5TopUr4Z1L0EuDczCHjiRooiTzopHXhtEI9Oxga5TZBEHD4UYlU1/g/I8gdVa7VEU3vEq1TAPmhrQC7l0i+Ojq22+7/n1r3lE6zIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snyvI1y7qQBAFxfxyk8O6jo2b9wN2rmBeeuDn4dFHUo=;
 b=Cany+GKcNJcltP/a+6GuArOhp/GBymK/x76kGP+ZBu4tRtpH/RQJJ8a8ciK9g1OBHNeB90gy/XkCFUF0LiHxwFDBF1FlHu02iSdzR5CweAFgjXLAIJu3gzmOCF2kYcHCb6w1nTuDQ534iYQH50OC6TeUDpfy20od/0yh/37erzIxhqvb8heabLJuI3UAqbE5RfWx0fRb3vune4xVKjHXfJw6scX/xvqmgqM0gibUswFsnSPBoJeXTJP5LLy9x9jn0L3wCN3iPUoo7IyvhWHQjJWM1d6DayPjLbl1XNfRiqoUtJqKrG4DyuJdoERwgftLaWHldjPriBUQVqgF1fANJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snyvI1y7qQBAFxfxyk8O6jo2b9wN2rmBeeuDn4dFHUo=;
 b=C2i7d70k5eZ1StYve0S+AAuvvCZJStFdRVMAwXZsJywtNtKfpht6cJ1+okd1AzeSahS/T68ITPg/bvc8GLrNWtxEhLTn6s/pzNOdo3nwhPtaGNA4wk2qA51yoW6ifK+/Vj4VpMPL0gUHmqDkuv6ZhfrQBarTL9a4u2XDFikpJvA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:22:54 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:22:54 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v6 8/8] riscv: Generate PCI host DT node
Date:   Fri, 15 Jan 2021 17:52:00 +0530
Message-Id: <20210115122200.114625-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115122200.114625-1-anup.patel@wdc.com>
References: <20210115122200.114625-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:22:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 828b4d91-96a2-4f9d-47ae-08d8b9504891
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB43308543125560E356D5058F8DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uyiqtouIO/TuSsJui5EktIh5oNVIGuCxedI5VeY2++tJBznjmIB1NZmA2Ejh99zSfqC5EkdvNPrwNt/K2ymLEOC48qZp0LPyut0rgq0t1Yu4dmRQC6SneHxqCNL6Lq6mwRoWdj5rwZFGlYfZbsAqU34gar/SPBfRvchmwHkf6ULnsJsH+gLC1mQDgR/3kS1lMNyIgP2R44RRKYlzQTqTQegjy3cgSbUMaY9iuzle1M+FBhUguWonLfJ5DpQbVVh/M6PgBeY2YTgGs+BRWpTxIfC4y2z726Q/K1Yct6vMOMN+GBhbLqzmx8JW6cEFN7vq7A9Rfs+tJd8AdzK1w+/uSHeskI0UaDsh6TPJf1ijswePx5ajzRFwgIoB0DBRHRXh8IhnJgy9kGLyfZzbHG4RIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(66946007)(316002)(1076003)(66476007)(8936002)(186003)(66556008)(86362001)(16526019)(36756003)(6916009)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e917GY9QT7WexdsQig4rZg5yJdFEOzHlcrtzkrDEnExSdR2B40sYQasDIWPq?=
 =?us-ascii?Q?pZo/4eY8W1o1xrl85IwFkomCAC6VCjEdh7liuOXm1G3fEQXlrtyspeiAbqst?=
 =?us-ascii?Q?mRwxaBXD//1CKdy0u38yKIBTCdmqZVM7ZCl4Bxno48QjsHoDdTovfpayYXym?=
 =?us-ascii?Q?WMrrIvYm6wSTdFsSZexD2Q8Fk43Ov5DtMxtnoZqv+43oflt/ZySTtJOwIWiP?=
 =?us-ascii?Q?v09m3Oxk8VeTwf9n9rp8P7gcfcxU2SG1VuilbuWWzmjR9KBopNJAaEqM4rzQ?=
 =?us-ascii?Q?dEE302FRA+nmtYqYYvWO1BKPlSHyLBQ2WegWhlrg672VoB9R8QwIg4CmqsGk?=
 =?us-ascii?Q?BEHPLhx83TIfjjvSEKrOXIfh1TlFGUd1obV3Vvsqd0l7poyXrqGsStQ/VG1w?=
 =?us-ascii?Q?6gjUUwwZDhhXEntaxs53Ms2jWfq/AFOSenLZH1rcesL4f1dISYccVsQ4Grjs?=
 =?us-ascii?Q?ta2CMXSX2Tzra1IWBBqVTUsUhAN3monj0M1/zGahk78+5x4yO7Pd9NNRhBvb?=
 =?us-ascii?Q?gsQDTDZEKEXDXw/evP3orJ530jbfQs5mOX01RppIkW+3JZR0wl/n0RIgrHah?=
 =?us-ascii?Q?mw3XrbxrgfL/4vq6qQi+mJcmtGVnqxkGRiVSPABuZc1z5c/uCN98XPD4pmA/?=
 =?us-ascii?Q?20jZ+37jQRdA0wAeo8iG/wJRIBFzoB5s7OJSY4ScmQKUWtkGP/lzxTTc2pD2?=
 =?us-ascii?Q?Zwuo9BtdFLPhwdrHu751nj3MwI9+HC+Du+g8YaWnwPL416V+4E5JCWM0i5aV?=
 =?us-ascii?Q?MmgRUxDekGLhTvK1Y92UNljrP44d9XiwAZh6hk5061uRbNooB2aFG2Ux8ubU?=
 =?us-ascii?Q?5be7eKB3wNj2RQNsg5/pPeN/niiKGFvCjf46NlkFS5BQ8vPv8E8wb+VX50hr?=
 =?us-ascii?Q?s9YpRA1NGsxJzcGpS01xYV4gx9pVYGG+Z1ZiQXT276EWic4D1Skdg5BdHDUe?=
 =?us-ascii?Q?MRc8ABBO/GUHLsoPgdYGVhF1oY1ZGn0E8Tbxs7DmjAhNRdqYvq0pvsHlFFoq?=
 =?us-ascii?Q?7wNm?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828b4d91-96a2-4f9d-47ae-08d8b9504891
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:22:54.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mUhNWlFTR7gGfgUi7BVQVEdNtnKTs+j4QPBRzTSqecPW5Cyjot8ZBecPsWw+Rljb0Gqo1JQg3AuAKZfKss2kVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch extends FDT generation to generate PCI host DT node.

Of course, PCI host for Guest/VM is not useful at the moment
because it's mostly for PCI pass-through and we don't have
IOMMU and interrupt routing available for KVM RISC-V. In future,
we might be able to use PCI host for VirtIO PCI transport or
other software emulated PCI devices.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Makefile                     |   1 +
 riscv/fdt.c                  |   3 +
 riscv/include/kvm/kvm-arch.h |   2 +
 riscv/pci.c                  | 109 +++++++++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+)
 create mode 100644 riscv/pci.c

diff --git a/Makefile b/Makefile
index 6042c1c..5cb6c8b 100644
--- a/Makefile
+++ b/Makefile
@@ -204,6 +204,7 @@ ifeq ($(ARCH),riscv)
 	OBJS		+= riscv/irq.o
 	OBJS		+= riscv/kvm.o
 	OBJS		+= riscv/kvm-cpu.o
+	OBJS		+= riscv/pci.o
 	OBJS		+= riscv/plic.o
 	ifeq ($(RISCV_XLEN),32)
 		CFLAGS	+= -mabi=ilp32d -march=rv32gc
diff --git a/riscv/fdt.c b/riscv/fdt.c
index 6527ef7..de15bfe 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -167,6 +167,9 @@ static int setup_fdt(struct kvm *kvm)
 		dev_hdr = device__next_dev(dev_hdr);
 	}
 
+	/* PCI host controller */
+	pci__generate_fdt_nodes(fdt);
+
 	_FDT(fdt_end_node(fdt));
 
 	if (fdt_stdout_path) {
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 02825cd..d9a072e 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -80,4 +80,6 @@ void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
 
 void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
 
+void pci__generate_fdt_nodes(void *fdt);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/pci.c b/riscv/pci.c
new file mode 100644
index 0000000..666a452
--- /dev/null
+++ b/riscv/pci.c
@@ -0,0 +1,109 @@
+#include "kvm/devices.h"
+#include "kvm/fdt.h"
+#include "kvm/kvm.h"
+#include "kvm/of_pci.h"
+#include "kvm/pci.h"
+#include "kvm/util.h"
+
+/*
+ * An entry in the interrupt-map table looks like:
+ * <pci unit address> <pci interrupt pin> <plic phandle> <plic interrupt>
+ */
+
+struct of_interrupt_map_entry {
+	struct of_pci_irq_mask		pci_irq_mask;
+	u32				plic_phandle;
+	u32				plic_irq;
+} __attribute__((packed));
+
+void pci__generate_fdt_nodes(void *fdt)
+{
+	struct device_header *dev_hdr;
+	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
+	unsigned nentries = 0;
+	/* Bus range */
+	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
+	/* Configuration Space */
+	u64 cfg_reg_prop[] = { cpu_to_fdt64(KVM_PCI_CFG_AREA),
+			       cpu_to_fdt64(RISCV_PCI_CFG_SIZE), };
+	/* Describe the memory ranges */
+	struct of_pci_ranges_entry ranges[] = {
+		{
+			.pci_addr = {
+				.hi	= cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_IO)),
+				.mid	= 0,
+				.lo	= 0,
+			},
+			.cpu_addr	= cpu_to_fdt64(KVM_IOPORT_AREA),
+			.length		= cpu_to_fdt64(RISCV_IOPORT_SIZE),
+		},
+		{
+			.pci_addr = {
+				.hi	= cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_M32)),
+				.mid	= cpu_to_fdt32(KVM_PCI_MMIO_AREA >> 32),
+				.lo	= cpu_to_fdt32(KVM_PCI_MMIO_AREA),
+			},
+			.cpu_addr	= cpu_to_fdt64(KVM_PCI_MMIO_AREA),
+			.length		= cpu_to_fdt64(RISCV_PCI_MMIO_SIZE),
+		},
+	};
+
+	/* Boilerplate PCI properties */
+	_FDT(fdt_begin_node(fdt, "pci"));
+	_FDT(fdt_property_string(fdt, "device_type", "pci"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x3));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 0x1));
+	_FDT(fdt_property_string(fdt, "compatible", "pci-host-cam-generic"));
+	_FDT(fdt_property(fdt, "dma-coherent", NULL, 0));
+
+	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
+	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
+	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
+
+	/* Generate the interrupt map ... */
+	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
+	while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
+		struct of_interrupt_map_entry *entry = &irq_map[nentries];
+		struct pci_device_header *pci_hdr = dev_hdr->data;
+		u8 dev_num = dev_hdr->dev_num;
+		u8 pin = pci_hdr->irq_pin;
+		u8 irq = pci_hdr->irq_line;
+
+		*entry = (struct of_interrupt_map_entry) {
+			.pci_irq_mask = {
+				.pci_addr = {
+					.hi	= cpu_to_fdt32(of_pci_b_ddddd(dev_num)),
+					.mid	= 0,
+					.lo	= 0,
+				},
+				.pci_pin	= cpu_to_fdt32(pin),
+			},
+			.plic_phandle	= cpu_to_fdt32(PHANDLE_PLIC),
+			.plic_irq	= cpu_to_fdt32(irq),
+		};
+
+		nentries++;
+		dev_hdr = device__next_dev(dev_hdr);
+	}
+
+	_FDT(fdt_property(fdt, "interrupt-map", irq_map,
+			  sizeof(struct of_interrupt_map_entry) * nentries));
+
+	/* ... and the corresponding mask. */
+	if (nentries) {
+		struct of_pci_irq_mask irq_mask = {
+			.pci_addr = {
+				.hi	= cpu_to_fdt32(of_pci_b_ddddd(-1)),
+				.mid	= 0,
+				.lo	= 0,
+			},
+			.pci_pin	= cpu_to_fdt32(7),
+		};
+
+		_FDT(fdt_property(fdt, "interrupt-map-mask", &irq_mask,
+				  sizeof(irq_mask)));
+	}
+
+	_FDT(fdt_end_node(fdt));
+}
-- 
2.25.1


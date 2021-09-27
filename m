Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB16419379
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhI0LpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:45:04 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36578 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbhI0Los (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742991; x=1664278991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+mK7vf0MuUd//RpadQ1Cp9Qt9FPwo6hzcQK8qWaUcHE=;
  b=R6YAuL570N0rJafYlQmbvytw0tCTzLVFUcvduJKnRWOJVTcUbFjgGjfP
   8It00q+Fb4ZjV09mr+Zr9vlmVSJp4LAkeu0cLkQW3o3q20LnIVeaZTZf1
   ZlwKDy8T9AywoHKrlE8ThYKAZo0/FJcjZjU+S2xvzvtXzPLRQsXYI1c6w
   Q9Sm8VqBe+wGA/InNcMJ8TArFXSgzxF6NlrzMh4VQxzbW8XugiFmjEu2U
   1wUcGN75syOc2E7MAnitj275lbDExAp2mZ/HYdU9EUMrXY0jLxoGjMzOQ
   gJ0QUL5QLL5wsBUVP7xvkC+Cj3F2UuTtSbKB9jGe3orrxJMskXTfENTE6
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181673183"
Received: from mail-bn8nam08lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:43:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXLeJ64lAp3Q3hp7jmIsbh27xC9cJLM+jf52AIY1L+/d/4tl2v4jg74sYvKACXcZ2DJlsbZV9eSJQgPza1sRgw8JYMooyLkb3cT0rOhHQmM9Z+4AI+PrKJCHy8wFjAeprUJJzgWUIdlajA4MM579yJ3O8/nHqGCOe/aSy8RS+ZNO6cQMFUINYloLVJ2o5QZgTF8YqJqM1geQuFBUQEe42dDjwwLBU7DEqcU2v1uEoR8RVp3eFF+3mCvWCl2bf14VAPCh7zxGzPnuCGqUF7VNht56Bb+ylcNQt3JQYP/7jlnOqtR2vjbl6RzztFUJlrPxCIoAfXpE17CHG5M8aCwFNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5eyFMlTJnJUUIedmzywRGS5GenL0J9FU5n4+qKN+g1c=;
 b=jmzom+m+IMBDrTJvhNAcHu2vMdli4Zc7luB6WSX5LKkPykNDmG5zQcIkOYTBxjI+WTmcklPA/6qCqsDFbW6Tf/mjJMfj9VBO4I1AdmrWiSSlekdMXzUSTihNFPztiajiEBaBYxfziUvGVEYTLQXmi6VJMeprdDBJowEvm5VB2N77OVILagJzjpBL9RtxliB94wuLQNuie3xsD4JjO1zfXio9/MUyoprbu647TvDDvW+qsKIuFFSGlmiKKd39xWePvBwZNJZJl6RE+buAKyZfE44L7d/NGNFlZb1aYg9no6Nyp+3Vq/fr1e7mxgS+/SV+RVV96c0C6we0unzbK2HSSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eyFMlTJnJUUIedmzywRGS5GenL0J9FU5n4+qKN+g1c=;
 b=AztxHmSKdLvJ0I/i//BkM8XWGhB2xQwOwH/6eFJ688WwWpIB3NAAUdWsrhx28YZRcJmPN8hlnCtE5wcYi/r5WHmPrRmcT4FmFIyyhTBY6KN3pMvdnFIbVJE1OJYYQ5UdFIcGfPSAdYf+5UT+KcR6INDkOPY2DRXDb3ggibIfGak=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7841.namprd04.prod.outlook.com (2603:10b6:5:358::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 11:43:08 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:43:08 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v9 8/8] riscv: Generate PCI host DT node
Date:   Mon, 27 Sep 2021 17:12:27 +0530
Message-Id: <20210927114227.1089403-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114227.1089403-1-anup.patel@wdc.com>
References: <20210927114227.1089403-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::14) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Mon, 27 Sep 2021 11:43:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f64d9363-3b21-49bd-50fb-08d981abf9d6
X-MS-TrafficTypeDiagnostic: CO6PR04MB7841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB784121676C94383A1EC3CB8A8DA79@CO6PR04MB7841.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2KrLgE75Tw3bh3MicPV15xBqpSEBV5ovZNajXqaq2DnuPMQERA1HokSamlKGGDUs2cM0iCy4Etxos+RzbIaJprNf22X90lg3RN8/p2tGGNlyJUubj45ur10Pew8ajM9ap2DXfVGBC5tWyzIbxgadKtrKMCEIqGsbo4YxmrhofeWKFx2u5Q32epBIxmxAhH/6Tv81HNyr+rzR/+5yl+i/FeIRRMvbew9H2a8YPjBC+6lZOfuviFRzO7V5HqvpXTd5t1VVHBuaE3gfUiWvpADXhYJrWzTVbca1H/qJUQrogqX8pTCZFX8Zrnbk61h9O+7mFqiwWS0PvSv7At4XIceJrZD3SDAcBMAhYGGqqu5vWnDuJCj8BP+n79TaCKnC/6nJh0GM6wHr2kvJ4cvG269UqmMYotKAhF6mFpVw463wACzGJxV8L1VTqn75LxIwXKpQO4+mlZGSNBqmCp7TWfqxvKMrp/7Zn9RVgHFybBKFbr8fZ713NR+Ryb/NzQJdPF0o2jI6n59qiIUPnUjK8wY2wXpP2DLSTrl1L3KxbCGq0pU4G/tBvxnNxqICGTywTdwJIeIjJKQb/7W/I46pzP35spQDWw5K8E5U3fhnB8dGHi2O/v7hiUhROXNn4qmhGNRrGdK1kT4Klhar+kl3/EOwfYnZed0vI1JI4yiFXwTM2zQr07GsHzxkd1c7fL6oQXuD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(5660300002)(1076003)(66556008)(66946007)(66476007)(36756003)(38100700002)(38350700002)(55016002)(86362001)(508600001)(6916009)(44832011)(8886007)(6666004)(2906002)(8676002)(956004)(2616005)(7696005)(8936002)(4326008)(26005)(52116002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JrS+kTnJktbYAQlCQgYD/baYuxE6Kt+0D60DV9YE97m12wPCz8Wo0gZGHOUM?=
 =?us-ascii?Q?w3QDLs566l8YCPpMo7MnnVkJvy7p+ZlR9KsqY7Cd3cJD6Np/QekXKPqRIbxC?=
 =?us-ascii?Q?q0KlqsCksmkek4XpWzY03Yjh8m0wN55GojAmHy4630uXdGS/ORQ3USyU4U8E?=
 =?us-ascii?Q?xNxArDAbzmxjM5yB0IOC3b7pk05fS0KiaPthl8erLlwRrmPJVOOFmgrrpQRQ?=
 =?us-ascii?Q?xbSSITbJTF7R5gt0IUrRONKcPOYqwexpBIqrjOR1n4oxq29ai5XgSmM1zDHK?=
 =?us-ascii?Q?PSmEnWwPzsbb4KvaF4d9vB8kUROdSag8G4yNBXD59/vG3rhaAO7aF/rokQCv?=
 =?us-ascii?Q?a8t6T+1xB455HEdE2/sWgw9Ru+iEy7X2P7QehYlOk3FOlRy9WnjCYfU+iQSL?=
 =?us-ascii?Q?b539SEzAXAS032F6mtBBTigfZUmhlDd0qKpYmFMx1l3hgXGNT9IkejuwTGJ2?=
 =?us-ascii?Q?iXoe5LjfNEljHpjObfnW+IBX5TGreIVGN5dgLZV7enhRzRa/paebH8i6TagB?=
 =?us-ascii?Q?jTPvPyI1xDKIE6J1pFNzI7aLMsgGOZq5h2/DIR6vMK0tje5SPzFwrAXbyPEk?=
 =?us-ascii?Q?evT5QgY8g5M4cP4G7NutpeQtJr42LH+4NlyBuZn2vlgLILzfU7xbahP68gCA?=
 =?us-ascii?Q?ySfdEo80Qs/87W+XvSXauarFHecn+maqcyTw2OFkMlJxrvB9JtTHE+ZxucGp?=
 =?us-ascii?Q?mXO23ZTIkoNfsw9/kJGccFwbEDODIT47/qbpobcbhp5ZQa+ssKmouDvBTtel?=
 =?us-ascii?Q?cN7bgi50WrTg+Mg5xR/cG4SSf2ZlD1jzrbNg+Zpif0OhOlxBPpuA3HsT+/st?=
 =?us-ascii?Q?vnEfprokoorzEL+BnGm9s4nEE4XtAn8DVbMxU5nrAKNaMuGimo/SdqwsgDMq?=
 =?us-ascii?Q?a7LzzkunqnCYd7P8ti7EBaTXmiTT2o1baY3n3ChfqPmvvRf+TY0LzaQQbQeD?=
 =?us-ascii?Q?gQdfZlAD8EOtLeJkCz/e3K8ZeMNE0bcp21vGmL8H/xNtVX6BmMR9CJ+ojyNs?=
 =?us-ascii?Q?w4ld5kj91GhNwvtljfq6Jjf5kGXL9sHY/JozWVxzFnvdfpD73IP2FWRCCgsL?=
 =?us-ascii?Q?KpZMfkce6fUCOAHNPhHEYfwNTZskSeVBf0N2fYkWSxYgw0ym5B15UlunzRB5?=
 =?us-ascii?Q?tseCHwnuVLo/s5lc98dr9dcOxemajqLyww9bjghHPhSUGuS9dkoh7vVzc16F?=
 =?us-ascii?Q?HMWGmfHPotn7lITzsNBgZ5TH17GvBQNVuh1VV7WGBWzkXWdG74NZ2Tyzk/J5?=
 =?us-ascii?Q?iWTaKM1mILttUv/cu6O6TEz6OLGQxvRNu/Chi2FOG2OmF/XJzTNqeVFXN2tP?=
 =?us-ascii?Q?ySJR2Hm8C/JtvjG03p9aw92O?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64d9363-3b21-49bd-50fb-08d981abf9d6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:43:08.2082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qhex0WGMqCPagSnmFGiIM1T9SfX0idWK8XXtzafRMcTUq74catHy9xqZZVroCOl4KoJ5rrEuLVSCwLiaje8fmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7841
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
index e4e1184..6920d7f 100644
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
index 884c16b..a6dd0fe 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -82,4 +82,6 @@ void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
 
 void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
 
+void pci__generate_fdt_nodes(void *fdt);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/pci.c b/riscv/pci.c
new file mode 100644
index 0000000..604fd20
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
+	_FDT(fdt_property_string(fdt, "compatible", "pci-host-ecam-generic"));
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


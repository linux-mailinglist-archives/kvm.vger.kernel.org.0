Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E6B19947C
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgCaK5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 06:57:37 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:50130 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730473AbgCaK5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:57:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585652311; x=1617188311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=KZJSMGfXhAMt1p27r4f97547wNv/LAo9OtVgRTQdyQc=;
  b=fNA6qAm3zkpfauj3w1jiMNeu7ZuRMngrJUZGbC3uaJ0bTeo3t7LwFjx6
   RkebzzghZ+bxUPY2ePn46JEZBGe54UU+VPbR9j5DUBjLn5CHy3Lu0MYnv
   XewQlECXTJONgxIJvJ3Pn0VeXYoC2fmV9TxQ1sL77IuDWuispVR/ghGmS
   TaNHujRhab3JWp8F/ilwvU19cLo7dLnPsKrOY+dSJ7Ogidpv6P+rm/y+/
   d6RbUl5S3BB+YX/CJP7id+VmcyVigTjYe/StvWg2Ki9LXdOJwSLYUEWRn
   ArHufBcwZKDXoAHho+UKFduPJHT5ICo2BgjS7cjko3UFa5EdlP1zWgxA2
   Q==;
IronPort-SDR: LGToG8SWJpGi5OcpHBm/lyJbeCNLKkMyRJZ46MgnpdtHv9HECZLGU21Mh3EFNlCWD4HB1Kw/vC
 25Hr/5bf2ovLhfAIWwVzZCmPANjpKU3KnHEpc6e6nDAlALPUAyjJVke3i0IFgSt/rPzxzQ+see
 VMwHnZGRjNXRfoA6bFshAjbzz80VBGtYmPOh8APOo/+1YUmJOjnXL6NL5TFjdfzH3TZJrfrJyC
 0atU5lehow7e9MEMTRFFY8J1E/mqvj5Qbrcv2B8ZAZJutPJHRL2fQOvdoWlhUlgaH2MgMZIp5O
 fT4=
X-IronPort-AV: E=Sophos;i="5.72,327,1580745600"; 
   d="scan'208";a="236298742"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2020 18:58:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt3ISZ2Wp+T6UkLTW659sDX+kkMxHQP9s5EW2+xyPZzfsAezwy9Y/S8spaxJzK9Hyuzq7LLvMGOryF5Gi+Wp7tVnYXPLZ1W6o9WMebEjf/MQDUbXEzFxditOLJjj9tF1V6rbBAouYgPJ4OCuEmrfMgA/G/HrxkjbYA4ZvvyhYBWpJolhPHbYUvT+CYN27UUbMlMWzjIEtPsZNPyQqj+ux3Bs7ml5uRmHVcPqy8LXflLY5AfLAhE+Qe0Yi9LhBAG0amGwGXpkOF0IuLMvzmGcqrUKpC77eGDGmM2EWWyZ5CIca90/bpBhpw5FDbyiRrEZBz/C+mCt1fMaVOTFW6Mzbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHfQieXvUNeiXbgjtDMezs1RxQIqm7VzvjONg6jxqfw=;
 b=SmMWTIecMCDKo3mojHWBqm/B395n4OcQS/cKuqDbCEnG0rlr6EGe6F2fTR6gzTrekP9G+DmamJ+830aC+4+zgn0GOIFnp+5dWxJXUe2dhK2nXFPh/dUkKbRhMHT4r4jPoLlr8cY9aEIFGOE2wLRVDXdgprQJRa+E+PBr+7hz8mur2U7rkHu0+tilxjO+LohQ+S8KAS4jb3NkDrUddGJKa/O/gbeIxe2k+VvxnzyTwx5ibsn3eJHnVpjtq9R0EKKrUFGN9sLQgo7WZ1z1yjXdsMy6+5+NJL/ao+qohm+dtZ4qwFFSp/StzK0p39dOL5d16zskRc0tNubxXCITuBC90g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHfQieXvUNeiXbgjtDMezs1RxQIqm7VzvjONg6jxqfw=;
 b=gVWBp0AluMuLijaUlJmKPXuM1VoVdP162IOVXU/cvjP2voK98zxRKfb8JTXzcs6rT7qHJbZVCtcK90FfDRJXXDOdqIVyrXXw0qAB6HQESWIUci9CmoRm9I8zbCz/WmN3RVdSNO1NP70XRd11TqeQphm67Ry5Y2rg8r6BgPo69c4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB5981.namprd04.prod.outlook.com (2603:10b6:208:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 10:57:35 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 10:57:35 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v3 8/8] riscv: Generate PCI host DT node
Date:   Tue, 31 Mar 2020 16:23:33 +0530
Message-Id: <20200331105333.52296-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331105333.52296-1-anup.patel@wdc.com>
References: <20200331105333.52296-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.117) by BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 10:57:32 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [49.207.59.117]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa244716-0064-4294-b252-08d7d5625171
X-MS-TrafficTypeDiagnostic: MN2PR04MB5981:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB59815B1AC9AEEEA9E687E6CB8DC80@MN2PR04MB5981.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6061.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(7696005)(44832011)(2616005)(36756003)(16526019)(956004)(26005)(8676002)(5660300002)(55016002)(52116002)(186003)(478600001)(6916009)(81156014)(54906003)(8886007)(55236004)(2906002)(86362001)(81166006)(8936002)(1006002)(316002)(66556008)(66476007)(66946007)(1076003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fhPY6t5cLmSEGe3YHVZip9TBfwwZqbTHpifzPe6cGXp0BwN/HJ779O6gApXx5LpmY08Y4Jmeq22Sn+DoD1YG6mfefdyiomCxb2Bm99kyC6J6lFyVQSdoBspluW+e+22Kjy5hpRZO5eere/To3tN4nf30dOurotY34M/nCqOYHUBaPlDY7QPLGAHud7a5kTOu6APANcSF7lXNh32J4H2gCFo2gpBD8CGIMoAGqPkLTiKdrVNWMtnb3hPUIi4YYNdAFGQa/kijukolZm1Krdpm90k+QpZ8WkZy3FFx0BLFS9L/nNK0v+VKns1Aomri2dimMGfSoOGdlyYrbLqDHeGerJoPeYqKuBX/1BP5RpwrQAUfV0McDjwII/Ks3LkKLDXU0cZZ+0cbCz2VicHdYnDSNMqrIRSQsqy5w93oPiVv50riMApa8KAYJDw5ECTh7bPi
X-MS-Exchange-AntiSpam-MessageData: UGL3fEgG4+tWeQaSWFz8ZXYofRYg1oB7AknjGK+i243UNH1pV5nigsjeadZ2aNcmneWS9PGYUJz7NKW3bzJN8aK3836REcP0QEQNtav9I7bnVSAvBMF55opXoX/+fzOiDgM9Jm9JggDuuZCrMnYdew==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa244716-0064-4294-b252-08d7d5625171
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 10:57:34.9269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XMwePb4M2OJ/bhY6fhPaSBhrVi9IglamQDxdgMsOXNnaxm3KERQa2HFv0ayjB4P0dH0yYNr2zQ91MwwuH0VsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5981
Sender: kvm-owner@vger.kernel.org
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
index c8be10e..7433c86 100644
--- a/Makefile
+++ b/Makefile
@@ -201,6 +201,7 @@ ifeq ($(ARCH),riscv)
 	OBJS		+= riscv/irq.o
 	OBJS		+= riscv/kvm.o
 	OBJS		+= riscv/kvm-cpu.o
+	OBJS		+= riscv/pci.o
 	OBJS		+= riscv/plic.o
 	ifeq ($(RISCV_XLEN),32)
 		CFLAGS	+= -mabi=ilp32d -march=rv32gc
diff --git a/riscv/fdt.c b/riscv/fdt.c
index 3b56e30..fc8aa88 100644
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
index 630cd6b..bc66e3b 100644
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
2.17.1


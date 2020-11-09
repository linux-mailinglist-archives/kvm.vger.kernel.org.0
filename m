Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB4F2AB74A
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgKILiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:38:05 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28194 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729929AbgKILiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:38:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921883; x=1636457883;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=J2cpvmLca+bcZNIfvwwazEWUDVCS+mUesMImd32OCKI=;
  b=CKvzRgSjx9CvRjr1btzAPfcMlxU9TJXqh1EpOV8sO8lNNC7qDxcOfdn5
   CgbB6feu5q6Wdq6W9VIyn+gHWyO3gg12sYZpkqUTmL290zeM7nSwDkFcn
   PGrDWcBeHYv6jGmMPXEHsEaTl9PXDx/e6mDIYP1CsqYlmn1F3MkJa93h5
   etCM2pne6dGhYOhnoLhUsW6wW0mIaST74DwbTLxPgWFyhFjI6Ny/8FwK1
   l5l8Dfi4h/Ss6joRI5kkjQXCdJtuSWCp51gX9XWU4bNr+ryuICfANYh9e
   FBeqwmUZxoh9+lXFAEfmROC2eejFy+wEc4O/Q0W/sL0Wi+6Q3SnEhU4kW
   A==;
IronPort-SDR: nEZUOjZ7te8MlWpEzXLNpODEN7zLq4E7OfDSh85LT9vQJJNGHz1mYQwQQuKdBLdYaieo3/GLlI
 +sL9nh4lvPpxLGb+bCkN0WqbVrtT5rc93/FPg193Egq1gaVuPQ1/4RcCbPDi0uzrbCLB5ZYggr
 NqIg9vNpLfOEDw7TPUch7HOAZ4ntqkdyBSvZQhQasjIYt0HokARbeobFjplFkteCtwmcDVoCkD
 PsitPCP1eLlsEpQ11+tTR+Z7WPuU7Tvc0LA5fG9kbH8TpNeSigxhxChJ40/aKqOAXdFEcUIj89
 pW4=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="153383077"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:38:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zh3+XlJPIt673kqJ/uqIv9k5psiTXCaEC27YZf05U8DWiSmAlke41k098NiL2MR6lC1lKFMNimhllMdtMXl1PCLsxvw5Z5fcRqtzoSWvZeKZXv+eRdami2gRttnvzXCYQaO3dSyLbqHKnjRxwsmQnOR/24/E+onb7w8lBdwMD4yiZ0QEjGyzdJitQWy5jL3byWNVONJsX7CfKgyFya8Ut81bBzQxg3eWoB/y6itxxsiUZl6kYuFCErFkHFBQxSDThmOXIGno5a6KNsaesuLDlShYdh4hULUPp1FtTw/tlAxRdaqoE4DHKU259pB/Osh4PlAt5pjAgT0yw5z7WZYWSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snyvI1y7qQBAFxfxyk8O6jo2b9wN2rmBeeuDn4dFHUo=;
 b=gyVpVrrUbnc3Xr77Lu0KOOyftLrshXtStHVPBCoNppiyp48+DasNn0MxvdYYa6lxQJIdlF67PE0pYDJ0Zx/hl8uBYusyXERt7KeDrTyiIPUZnBY904cY4RgPFdHGdaYHeBYzbY7CD/9iahy17yMcMwDMbADgy/MEw52v+VuCqOdgSPx+hcyjb/kkXHyVil2cxB/F8ENRQAI5qtVnRdppm6RTY4yWxDrSuD1f3m9/cULqWdPY5PaOZ0QqUXIEkE4tWHuQABN3yEenECIEMYz7ywvE+Sd+COFyeTGiauoM8FpOx9t1lk2B3BWe36pdVgmWJVRzK0dnVHZXDlAxH1b2vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snyvI1y7qQBAFxfxyk8O6jo2b9wN2rmBeeuDn4dFHUo=;
 b=QmfZnkqEJ08anTWMjBS8zKSHHF9hKAJWlC+lHUINe6vFs72ALHyR2NJIjfbV/0PZeAN0j8/qhSsGWLKwc+G3aB5fGrtN5uELZn2rgrg+i5MkdsoXB4njsfTmpBVrgCtYVy3+hGAzksmZ7Ogfw71svOD+S/04RFIaEEwj5pDwJro=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5961.namprd04.prod.outlook.com (2603:10b6:5:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:38:01 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:38:01 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v5 8/8] riscv: Generate PCI host DT node
Date:   Mon,  9 Nov 2020 17:06:55 +0530
Message-Id: <20201109113655.3733700-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113655.3733700-1-anup.patel@wdc.com>
References: <20201109113655.3733700-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34)
 To DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:37:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b617cd4c-13dc-4e48-b62b-08d884a3e9c2
X-MS-TrafficTypeDiagnostic: DM6PR04MB5961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5961751EC2F5E25EE2B2FCA58DEA0@DM6PR04MB5961.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLVMfZSKeo2wRhhG97qbWzRK/DBI5SnaaGIuDCp8Xdco+TfT/ri9Ep6wx+1fT8OTyPoBwPkd9GS5n7wBE+CfJPOMbBTgh6nUJjg16zEudpOtnNFt2tFWyR4F43+nJV9WFzBYmzWQvHA5SAV1K/deqEk6lZNTnBSQXwgzT5UyzeQ+KHeklxZUHfJB+LNGlFRCYBsTroFv/8f2vYqNzxMBvvl8KMANtCi6GS0pf7MiOPAD2GiJ9yx2lim3pBTN6AC+Yjd7sI5R223OWPhyF1E5tBypZDSjwd+4WDOAW3e/OY33ve8igSU/WvINyC2JhIFV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(8936002)(8676002)(86362001)(956004)(2616005)(44832011)(55016002)(66946007)(2906002)(6666004)(4326008)(66556008)(478600001)(316002)(7696005)(6916009)(66476007)(1076003)(5660300002)(26005)(16526019)(186003)(36756003)(52116002)(8886007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kQiv+k3LTEZJUftsGnFyldP5/WdyDdiwRZ8z8NLM4kX05ntGLhPCs02H1aetJLt8JZWY1JeZbsjRRqVQRq1duyRWInQVvnvcob1BPJoOGyiUDRX3+2KXayeQeG53EacdbwvYiymCX2eYnoAVmKZqYyM7fDrNThYKK/tEkCogUUp7XztLfEFeGMhar0QdQj715KoSId/up8XbGemJ9WpmRxABabSXvTgHgypHNW80cqoDXyFBfViCALDx+NuMMrnOpY7WJ1FJEW7PvPAHH7FHCDz5gc7PjkODHdGM+VbujSp7DBlGk5oTvQJCYh6bxm92eP9evgXzhomGT9yvyo3xt+CeI8D2BSVBpQVzYCkxgdjJLo/DB4n4D+caTDFt5EYfTC220jI2jLlcSpsm9Isu4lmgGnyK2TgkD0ExrvAwCa5oUr5HU+4Z034noUi6iAUfxSv2eVXEtYzpZpcNyd9XZOYzeoH7uD3RwN86Mq2jJBnsnGrCFxC40SspDEmIoi9Hq1gl+rX9Do87pCQvfwUfUFEXHEEihhV8rTJ6mljprRLu+jsjucaAEnd0nH38g9qdudeMu7iSo9CjfYP+0fHIubN3+DHZiNzDxYPqXk2oPIYR7FE21/U4Xt+GCMVjubpnxBAzuczjp4nuyep2mxg9+Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b617cd4c-13dc-4e48-b62b-08d884a3e9c2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:38:01.1381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYo7fzYGTNwSuSgwGwmQd/aN/JIrO1N+WNWdVcW7QAy4RIrYesNroCkuT8lLe9+HOT8NjOZj9XVy2qp+HwMF2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5961
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


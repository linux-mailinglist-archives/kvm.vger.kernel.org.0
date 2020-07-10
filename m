Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2154721B1E6
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 11:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgGJJBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 05:01:43 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30305 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbgGJJBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 05:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594371699; x=1625907699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=J2cpvmLca+bcZNIfvwwazEWUDVCS+mUesMImd32OCKI=;
  b=jgStI+8LNFqD9pW3hprDLzXPwaUOs1kbmMcT286cctgLkigTn00vHFj7
   ZMG/fRtoifM5GX6f7Kh6WFh9XEyTg18NyCx1a11JmZZiFILAjqXQSEFON
   ubTjXx9UWnN39bR2cOOUqPYHzHjpFvBmbVlSVhuF+09UgtH15f4UDc7fy
   4IEF+YzrKRpknQ9fhEID26XraUw5cx5oIFpmYojsnHSUA7DxejEwkAgA3
   1Dbi5CjvwWbSEMkC4e6MQfZF/IQsWxJ7CkpJn0vRm23ofFktFilNicJuP
   N12rfxXkygUTH6t4X40lOSY1L3fd6nY8RnZjCBLox6h+yForTwuMOknS3
   A==;
IronPort-SDR: 5Uh+xIR9yoXGjf++8KlNjA4TCLAvqLJZy7zIiAqvxJPHbDKWaISHhFBS1zK1+8NfwADv82JINP
 uZn/1LWFulDR6u//+xmE91+40GsewcP7umY0H81NIAh81SIIjYjcoi4QtHcrL+4Jzstkp+/lry
 mf12T8fLi8mUQFrVpw39yUHPEaSXRVM+M1lHYGbG6Ty0aH18+T9JKSXGPNfSflm6u3R4OXf8u8
 l7lzP1XKsXE8JFXWPtlwwnlIPmJSML6npdU/Ue+xbFyGeD5GS8f+KqiYMCr13guPQKAimNs2zt
 f3w=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="251358915"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 17:01:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRXFIxcSxALsyx89RH/WyiN1kb746HV1Kxb1/diOzAcLdQlVAV83b54H47D47f8kulUabxpqbxK9Lv4vwZKCZxYSAF85Yiw72k6lDqha0+Mzyd8O/1e4X81ZLChlIsYvG3DT9MtiIhZoZWjyRzptf9MYxiYeoJN22r9wgcez4PSrstikOmMcb5oodlg7zzKRDNUaTjIA9oglAEqbl7AjM2YN3nkEoAzK3Sm+27Y7fCiC1BQ8bdUYRePPzW9JDk3OR4QsDfHChEWpzhCC5twvvXBwlA71iQVgzUZF6dfm6kyZiesBGehRSfuN1c3U4PFnyfrxgF0AF1o0phOM42D10Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snyvI1y7qQBAFxfxyk8O6jo2b9wN2rmBeeuDn4dFHUo=;
 b=BuqmbrD+WJ2kTbvjVkHVdyET68ms7ngRw3nQQJ0dG64vVCmXQdU3pijUzB796vZvotExBGlEKiy03hpKKWrLCmgiox5GPt5UeazR77KqvelbuwVm7ilOzyG5DHx09v1i0HrFom5+ja974UD522GNJCK1qJcqqjKOF/ArFbVirCw3U8zJDK+mfGp289GJjpehJv1CYMO3ggsYMb+T8GBkNqCC2zq/7DMzRJW6eX0tbqkdtHlCrokpiGZlV2IrApneHmPnoU/YL1GfG/vIho8K3hvbXr94fKorliw/RStTqlb6lBv45GSBLWoUM7WmwWRCGcJNqH5bux21ocCODZSYXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snyvI1y7qQBAFxfxyk8O6jo2b9wN2rmBeeuDn4dFHUo=;
 b=pgu2CDIQC/oNSdMW8Hd9Jm1sRqK/uCNHi0ptGBGrS8KQZ+xVLwSq4ADTUk6/82+r/V/zaZf+Kwk7BBdhrwXyD91lPYTtqwrjHa95A2DkkNH+jVQf5pyI1rv+wrOgHgEaZKrQ/ZxgLoSvei+BOQqThKWloEIeBS+DV7qcoCoeXIY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0346.namprd04.prod.outlook.com (2603:10b6:3:6f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 09:01:37 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 09:01:37 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v4 8/8] riscv: Generate PCI host DT node
Date:   Fri, 10 Jul 2020 14:30:35 +0530
Message-Id: <20200710090035.123941-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710090035.123941-1-anup.patel@wdc.com>
References: <20200710090035.123941-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 09:01:34 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a1f0a2e6-15c8-4cca-261e-08d824afda30
X-MS-TrafficTypeDiagnostic: DM5PR04MB0346:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB0346DC82EAB048D819D2DFEF8D650@DM5PR04MB0346.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +CqyA2o7DNMc/lW1sjQbCO/LEfMrAlGAY1AstSpDhi6B0o7rPjs6UjvGifEDxm2fmUYCgr8OARiyyYZfHvja3o/Pazd/pPkMIZB4Q0HVhQIXA/yP5ARkqiMdooZEbou169jq4lD75S302iVCwcjCyPwlNwnM262DutIkud3WW8JgohWLsRrOEYcLKVPb9UZo+qZIRbPkU9ADeoiXEjn+HtpqmL+W7JS2cWbA1QuCfPk4otw+xfZOo28Jn3y2U5k2Ha+XYf9H6HUIZBt/A1p3frUqZZ6X2bBT/LVDlwJ2pLGi0ibfRWLVpk7sjyNLxStC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(66476007)(186003)(66556008)(16526019)(52116002)(8886007)(1076003)(6916009)(86362001)(7696005)(36756003)(26005)(66946007)(4326008)(5660300002)(8936002)(956004)(2906002)(2616005)(55016002)(478600001)(316002)(44832011)(8676002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BQElYo7ryj9JqkZYZtbH/Estr4x8J6+HG2QKgD5sgOmyHIQu4TyQIj4+Rpu91iTMFddsiyaHtVY3Clk6vWBFRwXvYV/MEHIGXjQ9PYRFmu7PzpJJ/nV3McgZSWepiHR2/wm34+Ev6HpG1RsXe45hfg0Sn1Zo/KglUfjMAqtPUkjlfq8HVAva/8WeBjsrD/kZl047BYnlYRlzYjyXPbBhFhPYrRYRLxJlpwApJgXDQS30PjsBM3ViwE29B2yR0m4srpfgVBEsSJcF2FeNofOpmrYnJjxgcKNcRYbwGchxZT+8i7KUOViIW0f6RikA4wTXBcgp3zN8OzKvxPldhQWuPhyxm3QbDB9iH/IO4+1wH/mNGpmVYpJAYMkeZu8g2fFIPsL7JUDLSr+eqPbYaxa/MRJcvLRyJ9zY3ULJ6Qr8DMyDzNZzW4iQMZcxu934Yoc+0rS9wmGEshSmsM872ZN6pTWXbeJaprle3z3hx6Zm19o=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f0a2e6-15c8-4cca-261e-08d824afda30
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 09:01:37.2479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+nlDkPRqLeznW4XdLsJFJdsowRpGygq2UtxSGggu8KuXWtqIFa/dxImMhEsJ1Kb+mUzwgX0Ck7dKP9BCnEYHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0346
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


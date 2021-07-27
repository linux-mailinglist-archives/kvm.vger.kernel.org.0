Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EB93D6E89
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbhG0F7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:59:22 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33290 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbhG0F7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365555; x=1658901555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=UCl6X4m6b3iY/P0guJ+d3JPlrnYi+UgiNs3Gcnggxx0=;
  b=h5N5tEau6aX4DXLRGk0kd+QN6afBNgPFsv78rW02Y1TFlIz7e176Vgf7
   +NVDBtZr3IYmZ+lLM7ElXZtQREp3tO1wIyht6rBH77uUn7AMM1Cz03aR0
   TxfiAwTSSqyOIg8iL5Af9/+jn+VepGzEXBU32FFfB35+HOir1TgIgkCwN
   CSCHkjby6SZRikiTCQUIkUmgrJAPV0/33zIHG2iK1zsGv/V1JQsgFK8x1
   PNbq6RKYeZmnAqiwaNmdv8/J95W5R4PXBghIVVonv6FD2oW8+cYZzQvIq
   KeoGsnmVL2eyJivy3+re3FTY9ug+8bdU7MaWeaR42kof6+YfWxTPd1gS6
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="180386141"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:59:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hiap9ZcLPBCb3qd8fSAXRq3xGSzshFYKR2xM5qlGptI9jrpv7tMBkH8w3jsr28vWg6bxtS2CxIzdXBlwCP+eGyE6sM6a9tDerxoIvM3tjHQNBlpywvmgi+YUYG8Qzaj8bDks+a3vftoJD6bh+x/gJzy04Hu12hGHw6YbFmJYr2aAprjiyieC2oJfJfplUukh5JhEfXOu1BTphvxcOvPue68Bi9ZjDIH4R/iYhhfW4Kqe1JkbM/d/B61ABlAmL3Epzz1lbOUbFJ9PWvZktwhamr+2ELkKGh7oxp1EF2XS2hUn+TRO3qZkZ1rLgw6kVAj9GA2Mps/txtZ9OWH5s0sgIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPfxwv2Xd6DU878svzqGr1/VXOoKbl55wHZWIcz2HoI=;
 b=DcJmz+rmna8u068LK89hBtKN05W98kSgWQZCkTc3q0+xp3YhTQfxaWY928/H6pvN9Iwdh2nBxqF1OizOiYlchYf85wK+IpAJgzSP8jmBp3BACLQaMAo6kffN18dAlWi+EpOzC7JUOnkd61tkMg6gOMuXKaHl6WGJCKWJjEBFYPu2ATxAB60d05qLp3f0cqY8h5CgXntJ7Y8DGs/Zuj18fkhARS3XehmAuqlF/KjdtyK4BUGAb31cvqGBjgIBSDnKiH8egAhPKBRXlB7st0uJWQu2ecamnDABzr43MljnQAnuXUFiOTsfwk1/BHN5kgar1z9B4LiuO5e3KR4B1Ulw6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPfxwv2Xd6DU878svzqGr1/VXOoKbl55wHZWIcz2HoI=;
 b=ZBubZMobdKV9TqluMTKnvdJSizce+FZW3ux3ZL/wVjuPIU5y2Iy3LqzFZbAuJ5HuinrzDKSpu5Vdt03vvrmezKp9eDz0CknP0nWIPpnaOgH27PA3ll9MBqwPzX9BwduHAvlfC8mBayFP51ETITbBf1YiaSZQqJD31V+gG5XciK8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7747.namprd04.prod.outlook.com (2603:10b6:5:35b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 05:59:15 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:59:14 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v8 8/8] riscv: Generate PCI host DT node
Date:   Tue, 27 Jul 2021 11:28:25 +0530
Message-Id: <20210727055825.2742954-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055825.2742954-1-anup.patel@wdc.com>
References: <20210727055825.2742954-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::12) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 05:59:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd63f24c-0ca7-45ea-d2ba-08d950c3a9a2
X-MS-TrafficTypeDiagnostic: CO6PR04MB7747:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7747C04431DF41FF97E264E78DE99@CO6PR04MB7747.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 16vLN75t306lUrR7/Mxqf9WUiw2I/C/LdjXbve2E4WB9M2SmrLcn78ySK58Fvd5lZCEiDyOWqjjGbtBhok0uStMwDbvnt/C1x0lEGcehdV39xsrIwQVnFeNxTixnjDKqm/RqdzOqsYak9S+eobVwFtviFh5Y4GMcim89iOeVMRCwXpsU+YtiFEAQsKkQq0xZCNkEdwT0fe5mDtgDeO9GML3RjWt3R2OkBD1/jc4WPz8YQ4HEgtXZxBbyK0RIlQMVRkWwR2Brp6CAazM280nNulT484qT62GaG8qKaqq/O9DRBK+gTRmfF00EZHvSk9d2fkglGneCroqIveOYN8dAEZWAulVmsqB9wFpRHCtyc1WoEPTiNrS3zpPNEw4yUoPG03q/sw9ifjFxcM3nmnmRA/5irxP5RGHX7RMoGnZCS2m/33E05PHNVYs97/LMdrRYY8K0+CXtttIB0TqeDq7o5l+L/0GPLXEfbtcil/F4XHeORLSK0dF8CrzGFTSvWRYpY01A/CGHj0iGE6dMjK/mFyd1iZLGXVoTIkswx1Hn7S1gWYNZy7ULlNikGb7pQNq+VL3g7++LwsszLVA58uc+PfSPtQUbArkl3shUzj0OT4Fq9CjO7JbXqAcCTrEsbVHy6UMFEDk6gpmwA8nOfMclY2AFw6wQ5KvyCi5enmH3aBzBL0VZ42GhicZZs9hLJEWo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(6666004)(86362001)(6916009)(478600001)(2906002)(2616005)(26005)(8936002)(52116002)(1076003)(186003)(44832011)(8676002)(956004)(55016002)(7696005)(54906003)(316002)(66556008)(66946007)(66476007)(8886007)(38100700002)(5660300002)(4326008)(38350700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WKZTmwfSCBtYNPVXap/YGF2mAZsgEnpddNjmbt7WgjOsqts3Cy6c3g1/m/3L?=
 =?us-ascii?Q?+plXe7k9/ZAmj89rDeS/qQutW82U0Lv35IouJ651TlClu/nuv/O0vB6D2Y4V?=
 =?us-ascii?Q?rRKfzEfO3NqahuhwlqB0Pc+tt5VeUyRMm8EtW23QOvSgMQUsfhrsRJuIYFp+?=
 =?us-ascii?Q?AOkcWhmUGHMY/HDBms52dAWzXtRG7+hA6MaJ5+dcVu85NAYKCorf7WBr9r+S?=
 =?us-ascii?Q?T9nuOSh7ZHULVkFtFwnIllFcK6sjk7gUWHwrDJhVhh4n48DW2JJ8UuoqntGd?=
 =?us-ascii?Q?3K0KPtS+PGQixWVn6KwX6ENXNK8q0Wo9Nwj7lZWJqCyJMXq+MH+IeOf4jZ3N?=
 =?us-ascii?Q?ZC5OUDbSkwumRVeHY45ia6QV/5BQdGmb2WXIOj1FuOFgKqqr+qf5BR8ca5OS?=
 =?us-ascii?Q?MKXtXIf9XUhUYMOvnIc8EPuVYld60wU1zaIKetbSFWENgnfeUZr9s3IeGA4A?=
 =?us-ascii?Q?mxAcaKI8I66dCuTc/muH7/tOwiFZhz5mQoUYXBgWkG5dgexveKSbOEeozq5Z?=
 =?us-ascii?Q?3QRv+BbpdWb+urJDOmqLSB4KsJ/lMapmG1NwEqb71/c0gG36z3rnzYhI4x99?=
 =?us-ascii?Q?5HqRlWmP94X56uLt9Jdk+ra3LrvLUDp8PBVAjqmZLwzJpXP0mmE86RImThKa?=
 =?us-ascii?Q?oLZXFSa17IFYRPLxNoHGY9fI9EvZe4o/VTU5qDcfjpRq+60q/1w5Zxw6hyC4?=
 =?us-ascii?Q?ExTtX/Bzdkd7A+AIeYYuPoE5UJaW9M2jDcoPlTgeq0iWn/IV3NnqAAKNSKOW?=
 =?us-ascii?Q?pr7iuhHWPJlSHbBVKRZ3xq6YWd5Y18nmyXUKNaOi11gez1LB/QVXGRHKEcsh?=
 =?us-ascii?Q?WSDf8KOnkdJtI2qdvOa293ToVLBvvcG+xNJJhN1jFU7tSp24tFnhE2rauAG0?=
 =?us-ascii?Q?dhKCi6A9Z2DhR3ne6lUeC5wEfy3tDWKGgJLCekfvxPb9mcTCo7qXEW6UNdJl?=
 =?us-ascii?Q?h+06ZQqNonRqtUilaYqjVXnM6ckU1qVqj315XUg+0mxnWgDLJRbFctGecUM+?=
 =?us-ascii?Q?CodSidCwcPSD9AS7yPD94kYGMf93WEb0Kqzw19a71BUdYFyeONUCW6GNRTJd?=
 =?us-ascii?Q?mdLv6Mub7pPOOuyljdPZVzzbXvRJUOfnQ14u1K+ghgY7nr0QV1HOvw8bzR5m?=
 =?us-ascii?Q?aATwtcf+IsVZ8ZGDM7MkwZ4KMhvQBMUNUBlDKbvAoz/Mv1OzAtdWwTrsrbsg?=
 =?us-ascii?Q?5AzqwObog0AD6/EH9zF6i93Q9n7pn7EJOA42cMY2Y+PrnbFiMMox+nEoH7Xl?=
 =?us-ascii?Q?NaJMxjplJIfFAUOKIRF2ealWT4B+mI8fHah/JcoMiH484joiHc30ndSKHpNF?=
 =?us-ascii?Q?MNBPuIjyikbge/wnnpVzR7xt?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd63f24c-0ca7-45ea-d2ba-08d950c3a9a2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:59:14.5924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dtaRoc5xISZIkqJk2mWjP17bdLtWy6sguv7vqALdUZK2DBJaRrNp9qs4DHY8Y7EZSCv4c2A1+9zqtZbCkCFxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7747
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


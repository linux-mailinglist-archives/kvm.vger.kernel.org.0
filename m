Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E18456F0A
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbhKSMtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:49:14 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16451 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbhKSMtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637325972; x=1668861972;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=D1cARkAArM8K1gB3X75oBoxs87f/TxJOrgeWMkbQybs=;
  b=hYUquPM3qomrFdJTlXQ5tRfOi3w5O+TmRGNg3vOK4CvBWLwmasY1Clla
   Z4f2XRAOtQgl2+/iaO8eEDazycpqSeLTD0MS1nqNQywuts3hF+Tas8dg6
   9LiFH11kAFOA0yEH2nvEQmDMFAzoBzJSSxwVOkCdlS8rErKlvhFWW4yP0
   Xmqu/O2qsKhKcISbfwwLhKyP5V220ICBFNHtJz2HmVUA7mv3rUaIEUyDM
   GBVjkUloAqHVPuy1Nm12xV+2MJ/qKbWTjsGnACN8bNJ1btA4SoKlTanPp
   uVYCS+tSnu2pAiEUs3d1Is2U2BngmUVE9mWeG59CGWQuG1leskOJ3W29P
   g==;
X-IronPort-AV: E=Sophos;i="5.87,247,1631548800"; 
   d="scan'208";a="185086399"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 20:46:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzdX0vX8RZFMRCwr3TW/TbeH8Krm+EZP0R5Yt3hQ1EyP4KcbpBirSlUhT7b/av+kw5T9QR44EH9qAft3bEbtF5e109UiOctEt7bsJ49hM1HM+rGo41heCNcqZEHIew5irQWeX85R3vbSB+97X+YL4lk2ddasx+J0Qu2EU7PY+b8VzlXKBHl/5AFWMKiS+L64rt/raXlIhqugJyT4DpMHoLIguh0vQALpOvxH8KQKneYoFZbePRKPGMILx8Vvwe1iErMpYL+Hd/TcF6YYnG+ed87w9tghhdIJoQ5g5d2INHhlsKZUQi+9Bn1PAiwp9NFlhgNc89/qnXLidEHfSzyVtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqD2Isi2RVc+S4qi+f8tB5ggdWgWcbt3YZ6ghkdH9f4=;
 b=mBr2Rgw0i4XrPuBCprpwmp7F3Ke5EvQDxRVz9gYImbiDWMz/FjC+4A2rtl42RsFDknteqQmXi1OjGealqGqNQeEeXEwrhUs80fFeUxb+i/fMPLTk9Xjtxwmn+V6QYgDBld+Z1LkSZ3DiEQXF6w9lW6C+3VIuxL27OKmS848BT+GFg7V0ycoBT/iTsjU0ytk38gI2K8yodrc/VPLzqPrXv0GJpgsDt1b3FcSQYTgOOmuDHPH2y0YWfIy17LuRNApfCAlZR6u5brfJ7fvDyOzZNNaJ7Gc8WF5zve2CJuOkoqI/RFWeSCLLgN0GLEk+51JKt6mhPWe4H8Vaex8eub24tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqD2Isi2RVc+S4qi+f8tB5ggdWgWcbt3YZ6ghkdH9f4=;
 b=FzU36th9npwicOkuI8TQa025E842hMzclkrMashdINch+ohzw+shloWKpXirGqJMTofeOCtM8JaruFps58sh17gmulH5WCGU1o2PJdGtVSuAnDT1lmKGfMiwdUty+E4YzaKQ3bM5t+WNBxlJua1oytmIkVEuRcDtlqDVOtkb/xU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7777.namprd04.prod.outlook.com (2603:10b6:5:354::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Fri, 19 Nov
 2021 12:46:09 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 12:46:09 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 kvmtool 8/8] riscv: Generate PCI host DT node
Date:   Fri, 19 Nov 2021 18:15:15 +0530
Message-Id: <20211119124515.89439-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119124515.89439-1-anup.patel@wdc.com>
References: <20211119124515.89439-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25)
 To CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.171.140.195) by MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 12:46:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7531f0d8-f96f-4689-9ee3-08d9ab5a8fab
X-MS-TrafficTypeDiagnostic: CO6PR04MB7777:
X-Microsoft-Antispam-PRVS: <CO6PR04MB777727F4FBFD27DFA31C95BF8D9C9@CO6PR04MB7777.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 18ad/rZyasADAJZ1M/CbbpTRldCX85fQbClxKDiMXeACyWZPLnTM78K4wx//1l7hMso3eZt/3ELXlZqeNPMofMNkLOrHLni7xNlayLd2X5H7c2qPv0g5sWsQlUahTaBvCI4Go9ZK7T8lks4h5dbZ2oSUq3RdbRzPeoCpFPRR/M/LlH39RhG/i+b88vTeeaDz2Vi6IedvRKsDSZiJ52iJxg1/2k513ZVwM6/XmqTM8LaGZKjTid2+dLSyPJLbdJHQ+6QwBFH01PvqN50Im0Rg2JRx62NHedh5qMiJ4/lZnrV0rl/JuIZ61ejLvatQvef7eCEOlAXVoCw/4trtSR3loxayRtizqdKY+yq7k2vQR9eXjH1pMJL4s9vSQlMsiYykOmmMOUpEltbzsCZjMF6CoiJjwdweqHU/rtJiNnXZ6a+dKL8PGdAnBCHiEuMBzsAQTC/6906MqPy8dSpgJ17k9kk5tctaatXzGRokKCTD896gcrZZEgR2QpGVJxrQjJcE4ng7Yv3gZBFVr5jC2zrM31aYY07cX5LsJZ4hbgIfT5L0wovxc0dmR38cReVdVgVVTHzb4M6MVg60ROtAg9kUWcOrSp2SocS0jR2WT1LAb/XTTgpqPoEgGgZEjD3KIc+nFUBDj0/AJmc2M+oQixMf/vOLDEYhwiu29s8m6/Us/cvbszZYle0edezCtEIdvF+o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(82960400001)(6666004)(956004)(52116002)(8886007)(38100700002)(26005)(55016002)(7696005)(186003)(4326008)(5660300002)(38350700002)(8676002)(36756003)(508600001)(66476007)(54906003)(66946007)(1076003)(66556008)(8936002)(44832011)(316002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U3QFSNY4Oaq5ejrCTrYXZpVZEWcNqh+EEv1a6zOf+7CDAUnVAVkkKF7JKWJr?=
 =?us-ascii?Q?edZ95WRue0AZItJs3BMaANamZdiZlyS13DAmKL5t2utBAsp9i+pwLubbI/7D?=
 =?us-ascii?Q?SlB85a3DzyT56T012GyC+pfiIhC9xePtyjLp8LO3ElI+5U31JGnvUJ6N5r7c?=
 =?us-ascii?Q?0V4j8TLjHK3rTbeLaHT0bZlTs9Fd44yFR7ZOwZcQZJMu1bEvqMMjWzyPnVJD?=
 =?us-ascii?Q?mIlPo1m6qEENVbyb0AtqSw/aLZok+oJw96MJ+NqkbrzbYIGL0FkGBWB0Ocnp?=
 =?us-ascii?Q?KcV7jMTPKgl+qnZTo0l75cwbGVBEyFH7W8NxltXgegOR8A19cMlby4pkJkw/?=
 =?us-ascii?Q?hl74eZ2wT3WnWU1Atk8wxdsMyKoVx0hE/c4qeeva9YEF4/UghfS7L7H28d5z?=
 =?us-ascii?Q?/iEQ9kkIBuRkl5heLE4mapoTvDdv0e24O4gs8L4NhezWrjOhu5nVEFSW+eFY?=
 =?us-ascii?Q?1CC6NATCQ8ec9+w6w9OcrsrYf6Xk/3XilCo0J20vc2ezkthc917jUwFGNOLx?=
 =?us-ascii?Q?TyLlqOCSppvvVZPCced46lFQyP5163lSGj3Eauam4sitOYX7x33GjcoQ/XVg?=
 =?us-ascii?Q?V7jH/ZobyFyLmI9WM3FU0xLNBKKY5K3KFc0s6Cp0AHOmzquGpITGUsg3EnED?=
 =?us-ascii?Q?zXoG7hsS+uJBHTiQHmhRDUPdSos0IultyTlsYGw48Z+9AeINlJR3Pui7RxU9?=
 =?us-ascii?Q?GohUoPnvaUxGs8AV3mXg+pBWZWZnlSmHaEg76xvQPtyezNKAcrq06vyNbXIo?=
 =?us-ascii?Q?nO8p08lfugVNwEdHpLooFuZJMCgVteqnsaQcTFnuD575yb+BqQJo5JPGPVYt?=
 =?us-ascii?Q?enQ18l1bqnhItI3xj52jgKgDsfhLcpDT9QUw6SA198NXqjg69jx33ZRGnBKO?=
 =?us-ascii?Q?W/+yexYqv2LaYFGSgf+FcCXnc+RqHaSrQxdKpSZ20PzS4rvuSwCxqA2m3sBa?=
 =?us-ascii?Q?vUy2fPfaEb+tx4NPUDbwwOE1OvhuYj/hW5r2AgBPNio8EWcjAA27S9zpcumx?=
 =?us-ascii?Q?hoEWlMNn/pIaMsmHl4CcWPedwI/ptGLU28s7hyouOPlCAZGD82ABkk/FAhUw?=
 =?us-ascii?Q?8Wdsgh6TuIGaeIlGE8qtBxuaYiRKSbyC/cMIY+CO4DLlYfY/gIl/oO9ARwns?=
 =?us-ascii?Q?o8Ne1sUzdNL05oHYrLuhEnxaZH/VrVvtYqSXVIoDfUk15Gl/f52t33k78EZF?=
 =?us-ascii?Q?7H/avs4dqxdrKBxhqR7AYnsMBJLBwObg76GfuEdGrIw8d6Uiayh9p/EpoEIj?=
 =?us-ascii?Q?vRdivGDH26Qlx/+KGQ5OcpZ8Za3ROiCCSqeRmc93YYFcp0oHmdSh/Tq8Hd9Q?=
 =?us-ascii?Q?m3LhzxCH6Kmc4Q+x1IX6+EzDC6KTiFtoK1hEA0q/Z2dpGd9vYMrIzIh7ryG6?=
 =?us-ascii?Q?5ZRrIubW+Cskcoqv9J/slUfWrUgYBqK9DJBmB7flAWH+izmKc1fky8CNVC65?=
 =?us-ascii?Q?kkdPDp5pzdUpwRNPXEUtn0+HFzQDeq/5C/tqylYDt34IG+wyj6E26GENILa9?=
 =?us-ascii?Q?aDnXg3xXA8ji2qAFtQuAi28ST++5o0KI9ycuwKR/uTt1fhXXUft5tK+ZDMLJ?=
 =?us-ascii?Q?/aYvYzl3MUR1xOx2d4OBttV+Na+sYosIvj5DxXHS23t3U0+yfRx+5B5l1ul8?=
 =?us-ascii?Q?xPEG+hOHuV5hYM0nsFzmMXw=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7531f0d8-f96f-4689-9ee3-08d9ab5a8fab
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 12:46:09.7024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HUSh8annYOxmb6I9IQlL1Qrd1YAmsmjd9t05EAgc2OFuz0he0zeS1WiZEHH22fUPsBJjNhb2LCdHmrUvB3k4PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7777
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
index d0be965..f090883 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -84,4 +84,6 @@ void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
 
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


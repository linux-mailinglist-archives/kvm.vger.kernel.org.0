Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEE9452992
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhKPF1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:27:02 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25831 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbhKPFZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637040162; x=1668576162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=D1cARkAArM8K1gB3X75oBoxs87f/TxJOrgeWMkbQybs=;
  b=SpYe4CxXyc19ibScyuSZmIKpWFwHnkA3bc+BmDyoQQry1s6xPsiDgDVf
   kfxLnzWiwKXJxZBdSNfbxi6yQyBXvr8acwvZjTyO3SODkJ34OhT/x9ISq
   Uf7ZYMWsdxo702qGs/umXjeRDFCwnm/Upmzj71NEbxZKKeLYG79EdBdyn
   5yIHTEbWKaGjrepw/h8wcaMG2hr27Joj4Mq8v6Ww07jLPi6b/1cEm1tzV
   MPEXScS7FOL3iOdAPLdj1Juxpd/h/mrx9iUNnWShGz3yNnBGUcCXXLpvY
   mnOUQEsb1WY7QeO2uqNX1gnsMdIjNBqqf/EuaExpuPJ/XGEkd+OZJPYEG
   A==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="184696460"
Received: from mail-bn1nam07lp2048.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.48])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 13:22:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vw91On17AnKjCLAFTuB65FsnyOStJtTOlza4abMsBAJSqNXIlzcmmqlL9srN2ndnpxUrSPqeKb+Jr9/hV/fdPMCx9ozTHP8sFStr3szgbQfTnPUso2pFmAtuB19zo6qTG0GCtTT7pwTctGjxy74zz4q2PwI+GCjw84+DOkIDToyjxUmqQrfkRuIStD2Soc4ZI5kXi9/x2z8qQmjAvXeMTunMFlBElltpwaoa0/KntR8qHiyM2voQvdtN3D4e/DVs4HehLT3R2bH38gxkuJtBqsjGkA1R6IRX0GYV063bG2hWSBGzOcm46GCSmnXkPYF/o9FgJmjnwaUqytBGuTc63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqD2Isi2RVc+S4qi+f8tB5ggdWgWcbt3YZ6ghkdH9f4=;
 b=XwuekjXB/Fclq0R7eTJfwjwjQQzf9F7PmGSqwCQdTf1Pi4QgTA1MbEFbvARzRNIgubM9ME/I++2Ay0znbjZGFZYXsnbUxSLvO5ivrjjznQMYPlle53IJU0BwpLdMyFlNntCZq7/JnkKnfOFeglGb7M3c+AvzqzwM4pFK/TBN+dVUESnMQ2bHYvE7n3OGb+XslsBMRC+TaxAyHPcHyHlB9RBOahp2H0lji5fsnu2fLJqhH+//kSJujNVjz7T1VoIoViRU3n8A+do1XpcbiisZPQXd6ASyzqBhoNP0ZFlgZPgyDLTGg594fqfdXlvNgGfCOlF8ChtTe8HtUYS6ikLrLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqD2Isi2RVc+S4qi+f8tB5ggdWgWcbt3YZ6ghkdH9f4=;
 b=E07fP8Fui35HzTdTMmsiCuOBjzS1GQefm51a6VQrBHjei7jtu4btgiQ89vwrmgBbthTytZRr/6hK3XJNobwjcxWA+SPjATJfOagHfwmGWjYvoG76FuTW2m+BIxm5vx8i8gqGw5bsBB69/YS8GHFKyC7FsFNLmHBPgfhWLoNe6QU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7843.namprd04.prod.outlook.com (2603:10b6:5:35f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Tue, 16 Nov
 2021 05:22:32 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 05:22:25 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v10 kvmtool 8/8] riscv: Generate PCI host DT node
Date:   Tue, 16 Nov 2021 10:51:30 +0530
Message-Id: <20211116052130.173679-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116052130.173679-1-anup.patel@wdc.com>
References: <20211116052130.173679-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (223.182.253.112) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 05:22:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8f54c8e-fea4-4d98-ff9e-08d9a8c1132f
X-MS-TrafficTypeDiagnostic: CO6PR04MB7843:
X-Microsoft-Antispam-PRVS: <CO6PR04MB7843CDB68E6E4DAC2F1513108D999@CO6PR04MB7843.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56HSfr/BfhmZiStApJPQx1C3f0NENSNIXefMw9Z8+J4JS0ygrEIYADdxXaI3BbXxRHV/SM9n//VZ0woKxsxEQ3A9x4u9wLHNJIStZ9Ciedw2LF1ZSVfLaWS9NOGyPe2AOkyVC3i7iuPdoNP/dm1T1ZBrtjnzRuhsmm607cwTvHGWwv+owIIY8e1FzVj7qZPIp6SBpMIh9bVCovDW8vGWOX7YT86Ud41m7IWFiQsw3J1u5xh/7cVy7PaMPVZaf5V8Y8xmUM5KQFH/egvNdmDSJOGPx67IhPW8GInoI1xEE0GQMkCeCMBgOnMEJhpB5/+Xy8x1QuG8iG9FToj2kJZBE3iZ/vhHs1SSsRmk5Cg+vE2tmBAjscaXU7QLKaLT3qTA5P2U4c1NCBT5LEaPH0vlWuOOUq9+GAO9UbNaf20egVRhwhMvMDjo76YYsu/JK77YLmj81W0BT68+iVLqC6OMSBBb7Oy1OIidLf6GnIXJh2JvQrLGO/KJczd+3+eZ2WclR8qOdkendIEmYvFxCo2PYtD5wxHMHULOTfTM9vttPqvovrUb7673KmmtTeBYkvnyfwipGZbJuFb2XSpbfuqIUTS30qjpwvM/iCnm11p36VaG6ZFDGmS1w6AvVKUVs6LjEWzEOy7uLPgZCA5YqdWmBVXUAZAtGeBc6ax1i3/ZsSUdumvmjM8PHIVJrALxuoxN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(4326008)(52116002)(66556008)(8936002)(66946007)(6666004)(186003)(86362001)(8676002)(82960400001)(2616005)(66476007)(8886007)(38350700002)(36756003)(44832011)(38100700002)(956004)(26005)(1076003)(55016002)(54906003)(5660300002)(2906002)(316002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s1MY+5C4xDDIvrDORrB/l0MeQebzlj1oF7UCp/mpVt3HNVrLoxEN61H6gbl5?=
 =?us-ascii?Q?iJS3Y6MT3YBFiB6Ox3ef7wJkNj8KLOWEiXC9lHRlZ1fgqsb3xwG/tLw4CHpn?=
 =?us-ascii?Q?EnfaEXm/vqieumhqEVTt8WYd4ct1NRKsyNF9cORSxqHMBL35ZHSdPCV0YmlR?=
 =?us-ascii?Q?5/H15Z4ZxSNiFU+ZuqdObAyB9/h3cSfHHMFmhfWEcijvx//I08R093NZRjPp?=
 =?us-ascii?Q?zDUDXpE2nV9aNlJ5+vYv2zmx9hhvr1Dzvykpiz+Agm1az9O0PsBaIrilQjP5?=
 =?us-ascii?Q?IvBClYCzjTDmck/dctLWp4bDiDB+0vRz7iDjWsx475hU+pWxJ5bEW6lP7+5Z?=
 =?us-ascii?Q?BUChc595cz1eS9YEeEXBOtBSx+8poBo7qlvbPMTqfhIqM95xYsbUGqhpnOdW?=
 =?us-ascii?Q?eeBRruHpBzP3lGX+WqIoZouscMxkPHx8HTcenrQumsjzbGTsH6PuNcVtwVKG?=
 =?us-ascii?Q?D0abTjDUJl00eSLV5LllmIVn0aFy5q3HUI+ERyNQMOwAvYowamMeDs4hFp8x?=
 =?us-ascii?Q?gXO9+Mo9ZFbGGw4jPpImjzN+6E+ybQaJuRt37ElBUCz3dfVOF7Ve/A8Sp5t0?=
 =?us-ascii?Q?yCqLiogF48FrIvRfQLqFObiPlOnKvSYUvtajHy98RniPYqorNOTyNhhEVItv?=
 =?us-ascii?Q?vkt1iVOFBinTpCqquoJZ7NzBKuJCEGvCWYfzhWon1BzJi/rq+bNEvPcWViTK?=
 =?us-ascii?Q?U30NvVvAk28K7idq6lKEB3OJPqqb/D5ejBP2vb16CzT+B3Vxure6ySvpak8+?=
 =?us-ascii?Q?kJ06r3xHkBqg9+0RsAOo/Pjcc8TzoGbRjGk/oa1TGtbTSGJbbMUCeppBjLSP?=
 =?us-ascii?Q?BLxvqKlfbd2Af0sY2TWviKQr+EqhkRaw7Gnb7/UX4nL1M8Sjc387sEVfnCC7?=
 =?us-ascii?Q?RBeB0vmLgaDvtcaSkXLdMpHDMoKFF2NYovHbAAwqxk6tTeXBjjiqfMOOeaZp?=
 =?us-ascii?Q?3DskfxUEinJtJj4vJNn8JGU58D7WaRmfcJz0sPjqpYWxSfGCWvY6bzrdUDmK?=
 =?us-ascii?Q?TejRCZmwh5Ze4tzGq2gXUH1aHgo/mcLMNugcPesvK2xtOLDM7GShJTHjh4kA?=
 =?us-ascii?Q?0EDD+cRdeMlSm7eeKPaYy+eExjqHhTiqFuFdXiJePbNGTGu8+lRV6y+egLvY?=
 =?us-ascii?Q?5UlAwxxO5qYDDwAkDxB6liZ501gG7ffXyjLSYsHqmLObDUXIpENBLVPZZI8E?=
 =?us-ascii?Q?WJ6IM1HfF5xbBk1DFrqHew2XhsJI6YwQlNtIhMd1AaYzXviO9S3gxrpCn8oH?=
 =?us-ascii?Q?XypEyGENMsT1OdyHeEJFS9b7L7g16ZP2ReUqn8OyEDzXyuSKZ0/wFhR4Cyaz?=
 =?us-ascii?Q?p8g6ndKtNsZ2f/OAblC3ZyuPNMoDPE3HyS68s1ZX8zMrM9KpOEUCgi6cudyI?=
 =?us-ascii?Q?2RCGib2qn0GWMEURxGMPBfsip+XmRJVncipr3fW3Fm34VYcEXOlD5I74pfs9?=
 =?us-ascii?Q?lrTOg/Z1Mc5zswK7hRIHev4DbNKftG7Qi4fJTPOWCpkmXMTibQ3OioK1G4IE?=
 =?us-ascii?Q?ExS8yzmnXLsAD7GnPeqRMrU9zuSjLTaP++bhbbs5kolBnQIUmF4h3JoaTOOn?=
 =?us-ascii?Q?u2pWl5SzJqaHM4LbcGJFc++ld7JjnufwhDhOjrbWEhNw1A6ZEuqmfPsLR0wL?=
 =?us-ascii?Q?n6t3R5L7fLO6FaSl53AxrmI=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f54c8e-fea4-4d98-ff9e-08d9a8c1132f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 05:22:25.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zs+fmH5uVN2FJuaBaElcWzPNHxxbWGoz302RKZzB8o+ZxODbgVIOOwxRW0IzY7fZF8mKKXi8wUwdwooR/wkRpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7843
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


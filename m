Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573742AB748
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgKILh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:37:59 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28161 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729537AbgKILh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921877; x=1636457877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YnXhNVx2riz72/YbI6PEmnKneq9/uZelooUUirU4FUc=;
  b=fBzr/fcosb4b9NeafIACXY/8yqlIEq/NE1NochAEiZgT5o9gXl2QT+YM
   JkNEWQUEtNGUbtg5UnUiow5PMhX/3knQj5r1EsUkM/77+cD8Imay2J1TS
   CjNzSy1dTbyxeBDm6T6TbORVsAChSs1WLurSU8FOTGwKabbyVEVJk+KOJ
   XK0qQc+/+Y/d+kN0uIlpIuhTX3LhOaGj/r/MqpzV/Ee7GPG6WfOwHO3U1
   cRP9cJJPZjeb0Wqjg6OPqVEx+CtCNaom3xF9KfVbHaSlUZgAEVzDB9KYJ
   UyKc43Rr3zpVTTJzHKqOrXPvGJqDZC2AYTtbJKTY6XgKSC0FZqedESkIO
   w==;
IronPort-SDR: 8s6IVIIpgjLUo8bEnOtMhkahScMOHXLpQB0jkIuyDGjqpkuxrPxyxJzyx0sAGw2wL826wLTEqN
 qNMBK/pgF8s6Pk5JbQ+jKBrUIqVfd2T1XwRSXOe7Mxbm9qty9A3sMXEwSKL6f3FTJL2qW1qRr/
 iidDMkLx0/lW/VU11sHUXICry+ZYDZD4r9q/AX2keyLLyQAThRj0a9sRTdYZvPhuy2fVqz2Jtc
 yvwdEBu3JwwYghNdGxbJ0Jh2Im3pqZ0sFagnqRkW0eeLL1smwXw5H7WLv192GcdGnBqu3bJ8LG
 XyY=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="153383065"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:37:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWcZ1cJMjR7xj86ETdzPuIPXr5uUgzpu52xq3C+qHb70CdemiGJJX84JH/4sji+LAHGoWhPDvdRMxu/7ymVGA+WUQuGztTNS4K1+fu8lEITo07cHGt8U0WP1Qd2+RA8fXpChDcywgz7JBN6jPtL1oEz4Z0bMB9qB/resFo3OOiAKSscDZbaVL3wHqf9IHaMUnC5aoD1u8lHj1XxoVXxgtsFvJAZ2TwMKwUVFQv2w7DdwFB1rrwyu4c4RD3WIzxuZMgt/Td8qsDkIEMgRvDNaiaTeQOg7lPh9bHL5RUZGEOZDQhUT3cPyP6rCWI3p2EwbU7km2UmHKswXw/qzb6xqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCpZfgqtVjz4zTxqDEfZnDSbOHypl1AAPuOb1l9RIos=;
 b=fX7NwR5V2vr7RdXHmNjaz4QPKhsKQyhubbmSiuz/tMzDLXQejxnzRPAHonNOu+uNaIcKzINLBzmm9oTJLXbFPuupR8JmWCpLl7GbiubIcgsUrLHSp4RNWvr0XQmZlNRDBJWcFqsUC52vxmjp8e6tjYBBB+aPTO4WOrDwHFImCLr1bUhJwZxbLdiuP0CD1souwgt35E859VR2xpVTNl4wFWNl5IVOaMbySK+dIAZZSNiayfkiDcVV41CQc9fwhVly8VBKKsnsBNiuLzkD7AKyRbNUUZQToIaZywEpZbK50WPUCOYcasLaHqiJ55CCsreltH7nLvWnvulTRGoLgBWlVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCpZfgqtVjz4zTxqDEfZnDSbOHypl1AAPuOb1l9RIos=;
 b=nD8ORapnQiBLBRcXhxVXEEvdro78gEZmB7RH1655hlS2dn2fhU+gAlw7id/msE1dEDLp6urZA283Urx6iPiPyaC03mKMKaRmOrAIrYGR4Cm38lHRp90wF3XLa+Xvb8tL7wMSH+a2aCDXLB164FdfDgcIIyC4Wif7Tg1heFXpCn4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5961.namprd04.prod.outlook.com (2603:10b6:5:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:37:55 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:37:54 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v5 6/8] riscv: Generate FDT at runtime for Guest/VM
Date:   Mon,  9 Nov 2020 17:06:53 +0530
Message-Id: <20201109113655.3733700-7-anup.patel@wdc.com>
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
Received: from wdc.com (122.171.188.68) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:37:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8a6cadb3-df1a-4aca-f7b5-08d884a3e610
X-MS-TrafficTypeDiagnostic: DM6PR04MB5961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5961BD26072D98A95F7F45A58DEA0@DM6PR04MB5961.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YnLezpp0Ma2WsslRymHTDdh92b8lleok1gkAHdbv+Ue5vWW48m/E5dwG+Kr7inntvKhIPBxzFP0AAETrPh5v0qkvKQgmMwHyQEl1ZrLEfrQ1cMOZVTSRO/JtCLOy9AecVeE6wB9qPqmiGXhDtIqAx4bPA4ZpGGbCKgLkK9jjpu9hO90V4q/xGMKULrThFeSokp8B8wejGg1MBWQAF5XZv3bK5/BOk4Iw7izzO+rHa5kkThVu0y2TE335hZbqAV2MLfpzKbpub9ZaVmEVhpYt2oBwUWrMXvS+Mz4hU9pD7O4skCu9OO8yM37HJPOTiwvMTHK1nKlVEZ6RIPN4C1nKQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(8936002)(8676002)(30864003)(86362001)(956004)(2616005)(44832011)(55016002)(66946007)(2906002)(83380400001)(4326008)(66556008)(478600001)(316002)(7696005)(6916009)(66476007)(1076003)(5660300002)(26005)(16526019)(186003)(36756003)(52116002)(8886007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WBwWnY0fWXCnGjaFFr/ntuXx8DzaVd2jkyt5zAreoFGqyGSTklq/PGEhxWxR+DEuNs9KsTDx1DyNdWJAhVVQ4gPpnACyAmQzBPJ6TIMbdHlxDRsND9mkUQUj0c+e6AgPNQOCnmGepKFSEl8dXgkJ/UyStm2GEZUVp6GT6xXRMDBsc/Bjwdma/Ilv3/56IRDdbqEvxy8qLSsx19QX1e07aRhEW+Y8b0s4A2/QwIgEzSzbRfoSYfv10xVCil02fTDbhRB74X5Dlxfi/x6BiblW5dujQD6MTUgDNiywHyEQ1+xwhTDABfmzFtpye5S4lWCSawuIPuUM3DD/SkSRrec913F4KCOYNjgIVfv0v0C/iVZjF/hBmf9LQR/NRZ/xqM0urBKe4QahhabgF+gQobyp96H71Be2zb9W50sLxpjT1XCGPs92X1xFPSbqOjYIgMF6i8IysrXkgv3zxmHPKZy+kNFdd4KQZ7Fy8n+GXfo9mdi1REz9YENq284dRm9HYH1e/Sxsv0fkloV32Lwbba48b4V4moHSYB2HCFCFdvjaRGgq3+DpEjUdFP/P4Ee/JRYHIcJ2yhEUYMVzyEXMkY+f+Th3FBgowRz2pFQRi94YedOszfm8Esv3zMu8XJF1stVDfi9t/zZ3cETlewZGry/ozA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6cadb3-df1a-4aca-f7b5-08d884a3e610
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:37:54.9091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ANCgP+zLTpXHIyBckdn8KyjiXMME98n/msqo0alD5/C21RbvNIF5O7LBzKKe+j03n/klG2tUGzg1zO3klDgag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5961
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We generate FDT at runtime for RISC-V Guest/VM so that KVMTOOL users
don't have to pass FDT separately via command-line parameters.

Also, we provide "--dump-dtb <filename>" command-line option to dump
generated FDT into a file for debugging purpose.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Makefile                            |   1 +
 riscv/fdt.c                         | 192 ++++++++++++++++++++++++++++
 riscv/include/kvm/fdt-arch.h        |   4 +
 riscv/include/kvm/kvm-arch.h        |   2 +
 riscv/include/kvm/kvm-config-arch.h |   6 +
 riscv/plic.c                        |  50 ++++++++
 6 files changed, 255 insertions(+)
 create mode 100644 riscv/fdt.c

diff --git a/Makefile b/Makefile
index e2dd39d..6042c1c 100644
--- a/Makefile
+++ b/Makefile
@@ -199,6 +199,7 @@ endif
 ifeq ($(ARCH),riscv)
 	DEFINES		+= -DCONFIG_RISCV
 	ARCH_INCLUDE	:= riscv/include
+	OBJS		+= riscv/fdt.o
 	OBJS		+= riscv/ioport.o
 	OBJS		+= riscv/irq.o
 	OBJS		+= riscv/kvm.o
diff --git a/riscv/fdt.c b/riscv/fdt.c
new file mode 100644
index 0000000..6527ef7
--- /dev/null
+++ b/riscv/fdt.c
@@ -0,0 +1,192 @@
+#include "kvm/devices.h"
+#include "kvm/fdt.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+
+#include <stdbool.h>
+
+#include <linux/byteorder.h>
+#include <linux/kernel.h>
+#include <linux/sizes.h>
+
+static void dump_fdt(const char *dtb_file, void *fdt)
+{
+	int count, fd;
+
+	fd = open(dtb_file, O_CREAT | O_TRUNC | O_RDWR, 0666);
+	if (fd < 0)
+		die("Failed to write dtb to %s", dtb_file);
+
+	count = write(fd, fdt, FDT_MAX_SIZE);
+	if (count < 0)
+		die_perror("Failed to dump dtb");
+
+	pr_debug("Wrote %d bytes to dtb %s", count, dtb_file);
+	close(fd);
+}
+
+#define CPU_NAME_MAX_LEN 15
+#define CPU_ISA_MAX_LEN 128
+static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
+{
+	int cpu, pos, i, index, valid_isa_len;
+	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
+
+	_FDT(fdt_begin_node(fdt, "cpus"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x0));
+	_FDT(fdt_property_cell(fdt, "timebase-frequency",
+				kvm->cpus[0]->riscv_timebase));
+
+	for (cpu = 0; cpu < kvm->nrcpus; ++cpu) {
+		char cpu_name[CPU_NAME_MAX_LEN];
+		char cpu_isa[CPU_ISA_MAX_LEN];
+		struct kvm_cpu *vcpu = kvm->cpus[cpu];
+
+		snprintf(cpu_name, CPU_NAME_MAX_LEN, "cpu@%x", cpu);
+
+		snprintf(cpu_isa, CPU_ISA_MAX_LEN, "rv%ld", vcpu->riscv_xlen);
+		pos = strlen(cpu_isa);
+		valid_isa_len = strlen(valid_isa_order);
+		for (i = 0; i < valid_isa_len; i++) {
+			index = valid_isa_order[i] - 'A';
+			if (vcpu->riscv_isa & (1 << (index)))
+				cpu_isa[pos++] = 'a' + index;
+		}
+		cpu_isa[pos] = '\0';
+
+		_FDT(fdt_begin_node(fdt, cpu_name));
+		_FDT(fdt_property_string(fdt, "device_type", "cpu"));
+		_FDT(fdt_property_string(fdt, "compatible", "riscv"));
+		if (vcpu->riscv_xlen == 64)
+			_FDT(fdt_property_string(fdt, "mmu-type",
+						 "riscv,sv48"));
+		else
+			_FDT(fdt_property_string(fdt, "mmu-type",
+						 "riscv,sv32"));
+		_FDT(fdt_property_string(fdt, "riscv,isa", cpu_isa));
+		_FDT(fdt_property_cell(fdt, "reg", cpu));
+		_FDT(fdt_property_string(fdt, "status", "okay"));
+
+		_FDT(fdt_begin_node(fdt, "interrupt-controller"));
+		_FDT(fdt_property_string(fdt, "compatible", "riscv,cpu-intc"));
+		_FDT(fdt_property_cell(fdt, "#interrupt-cells", 1));
+		_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+		_FDT(fdt_property_cell(fdt, "phandle",
+					PHANDLE_CPU_INTC_BASE + cpu));
+		_FDT(fdt_end_node(fdt));
+
+		_FDT(fdt_end_node(fdt));
+	}
+
+	_FDT(fdt_end_node(fdt));
+}
+
+static int setup_fdt(struct kvm *kvm)
+{
+	struct device_header *dev_hdr;
+	u8 staging_fdt[FDT_MAX_SIZE];
+	u64 mem_reg_prop[]	= {
+		cpu_to_fdt64(kvm->arch.memory_guest_start),
+		cpu_to_fdt64(kvm->ram_size),
+	};
+	void *fdt		= staging_fdt;
+	void *fdt_dest		= guest_flat_to_host(kvm,
+						     kvm->arch.dtb_guest_start);
+	void (*generate_mmio_fdt_nodes)(void *, struct device_header *,
+					void (*)(void *, u8, enum irq_type));
+
+	/* Create new tree without a reserve map */
+	_FDT(fdt_create(fdt, FDT_MAX_SIZE));
+	_FDT(fdt_finish_reservemap(fdt));
+
+	/* Header */
+	_FDT(fdt_begin_node(fdt, ""));
+	_FDT(fdt_property_string(fdt, "compatible", "linux,dummy-virt"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
+
+	/* /chosen */
+	_FDT(fdt_begin_node(fdt, "chosen"));
+
+	/* Pass on our amended command line to a Linux kernel only. */
+	if (kvm->cfg.firmware_filename) {
+		if (kvm->cfg.kernel_cmdline)
+			_FDT(fdt_property_string(fdt, "bootargs",
+						 kvm->cfg.kernel_cmdline));
+	} else
+		_FDT(fdt_property_string(fdt, "bootargs",
+					 kvm->cfg.real_cmdline));
+
+	_FDT(fdt_property_string(fdt, "stdout-path", "serial0"));
+
+	/* Initrd */
+	if (kvm->arch.initrd_size != 0) {
+		u64 ird_st_prop = cpu_to_fdt64(kvm->arch.initrd_guest_start);
+		u64 ird_end_prop = cpu_to_fdt64(kvm->arch.initrd_guest_start +
+					       kvm->arch.initrd_size);
+
+		_FDT(fdt_property(fdt, "linux,initrd-start",
+				   &ird_st_prop, sizeof(ird_st_prop)));
+		_FDT(fdt_property(fdt, "linux,initrd-end",
+				   &ird_end_prop, sizeof(ird_end_prop)));
+	}
+
+	_FDT(fdt_end_node(fdt));
+
+	/* Memory */
+	_FDT(fdt_begin_node(fdt, "memory"));
+	_FDT(fdt_property_string(fdt, "device_type", "memory"));
+	_FDT(fdt_property(fdt, "reg", mem_reg_prop, sizeof(mem_reg_prop)));
+	_FDT(fdt_end_node(fdt));
+
+	/* CPUs */
+	generate_cpu_nodes(fdt, kvm);
+
+	/* Simple Bus */
+	_FDT(fdt_begin_node(fdt, "smb"));
+	_FDT(fdt_property_string(fdt, "compatible", "simple-bus"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
+	_FDT(fdt_property_cell(fdt, "interrupt-parent", PHANDLE_PLIC));
+	_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+	/* Virtio MMIO devices */
+	dev_hdr = device__first_dev(DEVICE_BUS_MMIO);
+	while (dev_hdr) {
+		generate_mmio_fdt_nodes = dev_hdr->data;
+		generate_mmio_fdt_nodes(fdt, dev_hdr, plic__generate_irq_prop);
+		dev_hdr = device__next_dev(dev_hdr);
+	}
+
+	/* IOPORT devices */
+	dev_hdr = device__first_dev(DEVICE_BUS_IOPORT);
+	while (dev_hdr) {
+		generate_mmio_fdt_nodes = dev_hdr->data;
+		generate_mmio_fdt_nodes(fdt, dev_hdr, plic__generate_irq_prop);
+		dev_hdr = device__next_dev(dev_hdr);
+	}
+
+	_FDT(fdt_end_node(fdt));
+
+	if (fdt_stdout_path) {
+		_FDT(fdt_begin_node(fdt, "aliases"));
+		_FDT(fdt_property_string(fdt, "serial0", fdt_stdout_path));
+		_FDT(fdt_end_node(fdt));
+
+		free(fdt_stdout_path);
+		fdt_stdout_path = NULL;
+	}
+
+	/* Finalise. */
+	_FDT(fdt_end_node(fdt));
+	_FDT(fdt_finish(fdt));
+
+	_FDT(fdt_open_into(fdt, fdt_dest, FDT_MAX_SIZE));
+	_FDT(fdt_pack(fdt_dest));
+
+	if (kvm->cfg.arch.dump_dtb_filename)
+		dump_fdt(kvm->cfg.arch.dump_dtb_filename, fdt_dest);
+	return 0;
+}
+late_init(setup_fdt);
diff --git a/riscv/include/kvm/fdt-arch.h b/riscv/include/kvm/fdt-arch.h
index 9450fc5..f7548e8 100644
--- a/riscv/include/kvm/fdt-arch.h
+++ b/riscv/include/kvm/fdt-arch.h
@@ -1,4 +1,8 @@
 #ifndef KVM__KVM_FDT_H
 #define KVM__KVM_FDT_H
 
+enum phandles {PHANDLE_RESERVED = 0, PHANDLE_PLIC, PHANDLES_MAX};
+
+#define PHANDLE_CPU_INTC_BASE	PHANDLES_MAX
+
 #endif /* KVM__KVM_FDT_H */
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index bb6d99d..02825cd 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -76,6 +76,8 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
 
 enum irq_type;
 
+void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
+
 void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
 
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 60c7333..526fca2 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -4,6 +4,12 @@
 #include "kvm/parse-options.h"
 
 struct kvm_config_arch {
+	const char	*dump_dtb_filename;
 };
 
+#define OPT_ARCH_RUN(pfx, cfg)						\
+	pfx,								\
+	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
+		   ".dtb file", "Dump generated .dtb to specified file"),
+
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/riscv/plic.c b/riscv/plic.c
index 1faa1d5..07cadc7 100644
--- a/riscv/plic.c
+++ b/riscv/plic.c
@@ -1,5 +1,6 @@
 
 #include "kvm/devices.h"
+#include "kvm/fdt.h"
 #include "kvm/ioeventfd.h"
 #include "kvm/ioport.h"
 #include "kvm/kvm.h"
@@ -455,6 +456,54 @@ static void plic__mmio_callback(struct kvm_cpu *vcpu,
 	}
 }
 
+void plic__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
+{
+	u32 irq_prop[] = {
+		cpu_to_fdt32(irq)
+	};
+
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+}
+
+static void plic__generate_fdt_node(void *fdt,
+				    struct device_header *dev_hdr,
+				    void (*generate_irq_prop)(void *fdt,
+							      u8 irq,
+							      enum irq_type))
+{
+	u32 i;
+	u32 reg_cells[4], *irq_cells;
+
+	reg_cells[0] = 0;
+	reg_cells[1] = cpu_to_fdt32(RISCV_PLIC);
+	reg_cells[2] = 0;
+	reg_cells[3] = cpu_to_fdt32(RISCV_PLIC_SIZE);
+
+	irq_cells = calloc(plic.num_context * 2, sizeof(u32));
+	if (!irq_cells)
+		die("Failed to alloc irq_cells");
+
+	_FDT(fdt_begin_node(fdt, "interrupt-controller@0c000000"));
+	_FDT(fdt_property_string(fdt, "compatible", "riscv,plic0"));
+	_FDT(fdt_property(fdt, "reg", reg_cells, sizeof(reg_cells)));
+	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 1));
+	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
+	_FDT(fdt_property_cell(fdt, "riscv,max-priority", plic.max_prio));
+	_FDT(fdt_property_cell(fdt, "riscv,ndev", MAX_DEVICES));
+	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_PLIC));
+	for (i = 0; i < (plic.num_context / 2); i++) {
+		irq_cells[4*i + 0] = cpu_to_fdt32(PHANDLE_CPU_INTC_BASE + i);
+		irq_cells[4*i + 1] = cpu_to_fdt32(0xffffffff);
+		irq_cells[4*i + 2] = cpu_to_fdt32(PHANDLE_CPU_INTC_BASE + i);
+		irq_cells[4*i + 3] = cpu_to_fdt32(9);
+	}
+	_FDT(fdt_property(fdt, "interrupts-extended", irq_cells,
+			  sizeof(u32) * plic.num_context * 2));
+	_FDT(fdt_end_node(fdt));
+
+	free(irq_cells);
+}
+
 static int plic__init(struct kvm *kvm)
 {
 	u32 i;
@@ -464,6 +513,7 @@ static int plic__init(struct kvm *kvm)
 	plic.kvm = kvm;
 	plic.dev_hdr = (struct device_header) {
 		.bus_type	= DEVICE_BUS_MMIO,
+		.data		= plic__generate_fdt_node,
 	};
 
 	plic.num_irq = MAX_DEVICES;
-- 
2.25.1


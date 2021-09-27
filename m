Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6004C419376
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhI0LpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:45:01 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36563 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbhI0Lon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742986; x=1664278986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=qyjSXJELHWvSvV9oYRAheCP/Wi4KRzpZ4SoeSJ+ZCFg=;
  b=j8K2M2gqzr4Ei1QI8S27rx50B8eShMfh2qMJjsOp0LEuQAVd3s61KlMJ
   DveeqTZ/h/F2r7o7D5UwgUR1YDJ6+T+KEo2nHXEjGMV+uFWRXmOH3vigj
   a1dzmHExDKtkS0mWv+lQ8bv197op90oXHrFQPPjGZYmYgipvFPhademnt
   oG9s4VFZ2zvyFmnbIYFuvO6pXFrlNdvJ89VTIGNualMlj8DHYtMGdrz3m
   JBi0Q3cAcPn2EkNkvYZ0o//Wvo5+ASpSryjuwIMb4T7HiSaWhlncrc/sY
   9t0qNQtlUGpUbsn482T3O8qiYmL0+SN8+xflChQqVgtGo/ww3x3UZqcbd
   g==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181673176"
Received: from mail-bn8nam08lp2044.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.44])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:43:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVyZ5j4IAFV0sfSiW4YYsllWuBdx7fEGTjxCFiEyZ3tC/xtMhBEbzMnpjGX26KQkTOex5EAjGkPQVGPL0RvIGP8Nw7q5Qs9FZ7xaLra3UN1VPw7/GrOVOPPlKREQwaOJCBiV6NrqfPL/ZeTTA0m6WpxHI0oZSzVdFdi56vOlsaYQkafE0BxNgov90dq7QnnzXO5Pc4aL/fs5vZ1z/tkjXuQ/hh7WikfX/1RjnPXZ9zGMFNqy4xmHAq9agvgbev79VI5CBN0Ctav0YiXNSJpjoMRFvjaWb4hon6taGs20ysGHTJv594edSKDHCh3tOC1H4B+nt3/3vErUCup36gZKtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=08yt89Q9GIfVQt8YmX3rqkut9qjhcuJwoF9DcI15KWc=;
 b=giZV0ZNBBJ5leD0vRS6UDvCCL5HQzs5Qix+/bEksye35y5Lac9H5eP1Sn6zy66zAvGGb2g+MZ/Ds3VjVlqZXKwSMCNiFPjZ4w8eG224HxTfq9X+IVj3cLLjvKX8cp3deTXxQI5tJOQuPkJZz/zIaYTpgiK1ecSjutsO3++Ipx5DszGg/+/UuQV9Rl8gi/HqkSmR1gl0bwkoNPm6JzUP7SGdKxPTuhmQyaw3TrS2cQbznz5zSMzWQ7UXYqy5X2tIarvUUGCyuFBiV9dLxyEd5ID+Aq4AJwkmpik/5OxgjP1N46sUSu/gH2egYmpBGdU2a1Qxd+2LZdfA9XlcOLgHunw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08yt89Q9GIfVQt8YmX3rqkut9qjhcuJwoF9DcI15KWc=;
 b=jt8+O59XgmMeD33McqtE9m6/paow+4uMFg/O7S/dacs32EBQuvBWkg6TFoGUFpumoOmbDQqeCP6B5iRjGDxSDTMcltydxOl8ceeBHv/ByEHHBYawkisaMe5yqFiOUUkoOOX7EwJ0PRQ6Cx41hcoIV7INgHcat4Aai7YCYqOU0qA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7841.namprd04.prod.outlook.com (2603:10b6:5:358::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 11:43:03 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:43:03 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v9 6/8] riscv: Generate FDT at runtime for Guest/VM
Date:   Mon, 27 Sep 2021 17:12:25 +0530
Message-Id: <20210927114227.1089403-7-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114227.1089403-1-anup.patel@wdc.com>
References: <20210927114227.1089403-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::14) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Mon, 27 Sep 2021 11:43:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6deb653-3c8d-4af3-dcb1-08d981abf6ae
X-MS-TrafficTypeDiagnostic: CO6PR04MB7841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB78417992D6F158E78247387E8DA79@CO6PR04MB7841.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juCtLdGxqIgk/s47YG2dZnl67/Qwxl0xRJtWSoXs1+IP8U6WfmGgcciF1dESAnrOtS4yeI1NuP9BXB6WWGN/BOOfJDX3FDzXdSV1Bp+3fGZneRh3jWDOJBnrkmoDmQ8xCxa9fAs6Y4fQV3OdG0lxeeFvNJaMdCWp3wWjaokC3KA3q5sOIoCtE54TIF1i+Glh5rIW5Dwm4921LfhgUYe9OzHr6qDvSyvH9PgMg8SFasJJFMAo5HuC6J1QH1U7XQXuDGWBKDD7eOJs+INc1hWm8r4XoTLnG596E3F2g7U1w11uWb1YhYaylNXic1wYhW0QRBwC48cBbUsHDyQeXDV5WBcOmaLIrgZWAoOhSt549C2B6bF2FKirchUcPnDJkJJPdZsC4fwIKDZ7FV3aUMoQya8khkN8RWASjO5GSlunT06z+pchsdTUg275CbSp827dyWTCQb65C2RB4hEOvIBpZeP4XNCpWMrdOirD0r1JBIeAI1l/azh26vK6ogpyJpQ/cTGPn90vM1oOmeFA8nQupNpkJYAERq6lmkUsiwzFc0BUNzGUoUq8AAskXM5bWNO/mSl55PioNZ9m2qIMtr7zThs/XgnFfPA8aJw1h0bOFNOVbXIvj2tbxCxp+u6Iwz1pUPLPWCvWsO3mvQx5jv49fmRp6ITQyUOyltfzu9rsuO4QWTMU4mR4y0JSEXGCgEfZ44B5KaeDXH+NoAC3BduM5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(5660300002)(1076003)(66556008)(83380400001)(30864003)(66946007)(66476007)(36756003)(38100700002)(38350700002)(55016002)(86362001)(508600001)(6916009)(44832011)(8886007)(6666004)(2906002)(8676002)(956004)(2616005)(7696005)(8936002)(4326008)(26005)(52116002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ckUGfqp0XOUwsUqysW7SfWODTGV9PSsD2jDlQ5xuyrLXU12E4LEpCbIhGUXt?=
 =?us-ascii?Q?PZtxrR4pEAbXestp2EyuHtn0XuvH8Pn4u4k4wi29LDCwPVbYxNa3KXccEKOh?=
 =?us-ascii?Q?XURUiAtwb/YNEM+exPPn7ura5GSnbHBbyJNJdiMl82qMSo0JDmvA81D5K71j?=
 =?us-ascii?Q?fZhSGx5Uiks7CUs+H7so6iAGoOA5HYqwAe9kxXA5oLG6BG85UJp55oX8S6II?=
 =?us-ascii?Q?MhIlI2ymJPNqWEif8S/PRojG+r+8Qg+bEhSnyCbFfwEUC/xSmpmj0ZpBlo8o?=
 =?us-ascii?Q?wfjrstYF8ozNcEeW32JkczNBHzWzuaoEstbKwX4UWm+uARj2J+GRsbkkY4KE?=
 =?us-ascii?Q?16yVFgJRW8TxtMLD0PJa2dQ6ysRJI7F1+aDNZeINpKu9dQ1dTxuDW/lHdrDY?=
 =?us-ascii?Q?kanDIflVm9R8IrjrUfdDOljl7c8Ap03gXONR5/0FCtEMKGFjM9QjD10cIE7H?=
 =?us-ascii?Q?uspIhltcxP+f0CP6jwL7BfiALJ/RUtKpIqC3bB7ZA2kLHMFIPIzv2s/DKKTP?=
 =?us-ascii?Q?RFfX+6qdxCTHyMK0OrLFFVTHEij3yKk5+Ido5VkgMDnR/Iy1hjLh1xTUoaan?=
 =?us-ascii?Q?OijP/sdIhmylGZVjFZ5mmGiL/LR92gGzhtWezi7FW90eFDBQJLUQXOWJlJ64?=
 =?us-ascii?Q?oOBofCKoMsJ8RykE6a03h1YfIE4jy0e9kBXKF5eV7dcMADy74YkamSHo2+Hu?=
 =?us-ascii?Q?VIwkSuHvMwNvsey6S3FUhjGaMmqQewiIW6z2dIkPAv95Jtx3BkxnojsW7aTj?=
 =?us-ascii?Q?a59yWRIK+GqEajMeQ3ni6ighg0FKoHcm2s1DVTBW3fYAETlAvqOVs9FJxiz+?=
 =?us-ascii?Q?4z21noOPSUidaoYvouacpmMtsw5bFzN9sIYQ/VaAqzQqshm1rBg16wsod0Mw?=
 =?us-ascii?Q?V7pzPoEiQKEzVJhquLGMug64SZsfVs4s3ia2B0TWoam1v/eNyMZnmpPTiXh8?=
 =?us-ascii?Q?DzTfU2VO6++NEMYJzyACb4Jjd98lKACBs5TVrzo4Q5ddkDw5h2B1dQo3o49r?=
 =?us-ascii?Q?vY8t2nTWliWm3oyOs5kv5DPGN73UiHpw86HuVNo85KdQJ6ssBUTLN6ULKgqu?=
 =?us-ascii?Q?W02mUTSF3zX96feaJwwKSf8yV9YvkbPXek053Mrzafzrg0xag9gt+TkH4o6n?=
 =?us-ascii?Q?w01uO8rngUM0A8vrZ8FlgAvvLLUsS3nPDwkkM6aOzx3YBDnRMc5+ICFqNZ4v?=
 =?us-ascii?Q?0ToHKmGIiiNO9JZx1eyw4Q374hP2xlbWj6IL6XM70JV92ctLJzBLxWddz39f?=
 =?us-ascii?Q?Cv8OnAY7wQnheh1o2TFwD4Vr7YYjpLfYUyDXLj8XeG1+clmun9RUkJk+YMaN?=
 =?us-ascii?Q?YpKwqzozyTpHY3d3N39Ukc3/?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6deb653-3c8d-4af3-dcb1-08d981abf6ae
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:43:02.8846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sj9Yk4jtyh4FGJICHQBXZJXP6zlSMk5xn5frvWHYSAWMwKDxnzApEwR+yHbTK+tZcW/tY+HMJ/VsotZhd6oeww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7841
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
index eacf766..e4e1184 100644
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
index 9face96..884c16b 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -78,6 +78,8 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
 
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
index d71226e..9344202 100644
--- a/riscv/plic.c
+++ b/riscv/plic.c
@@ -1,5 +1,6 @@
 
 #include "kvm/devices.h"
+#include "kvm/fdt.h"
 #include "kvm/ioeventfd.h"
 #include "kvm/ioport.h"
 #include "kvm/kvm.h"
@@ -460,6 +461,54 @@ static void plic__mmio_callback(struct kvm_cpu *vcpu,
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
+	_FDT(fdt_property_cell(fdt, "riscv,ndev", MAX_DEVICES - 1));
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
@@ -469,6 +518,7 @@ static int plic__init(struct kvm *kvm)
 	plic.kvm = kvm;
 	plic.dev_hdr = (struct device_header) {
 		.bus_type	= DEVICE_BUS_MMIO,
+		.data		= plic__generate_fdt_node,
 	};
 
 	plic.num_irq = MAX_DEVICES;
-- 
2.25.1


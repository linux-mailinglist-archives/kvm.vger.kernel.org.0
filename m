Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713712F78D2
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbhAOMX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:23:56 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36088 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731959AbhAOMXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713943; x=1642249943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YnXhNVx2riz72/YbI6PEmnKneq9/uZelooUUirU4FUc=;
  b=aDKktQHm86GaJIBpLzWoAViG2/IvaMyOXyXE6krXKPeFN3Yc3a/+hkR6
   +CmhiIen61kWJhJrU3wfqMbXkQ2ld2ag8MsI4a320iopadcZVeZvTGFtC
   96SjNRCwRt/f4p+B/ghO4HxQX53YjtdSMybFnWXC2A04yOJ+3mVnyN8vW
   X3zWhAOxATq0TksgkYUz2M7tm0h//NMbAIdNYh6r/NN09VWoH5aBRixOT
   IDyYvpxi9fQbbMjpajfnwfr8Qfz3sxz0ou1Fzm6CvJq6nnNKKNeymt9LX
   PM4q7T6s9kJbBrVF1BOyj1CmJH6XraZJD0eA3qI2AxmUuxgdHMAe11jfJ
   g==;
IronPort-SDR: TA1CKZv3nMVceMN7CtEcwJiuGBShFWlfFrfRZSxC9/jVWufbm0iyLVuEQRFZc53h9mqbANhN31
 maFxL0oeLAB65pXhMZKu7jkWkj1Q2k8mTWNtpCq3Osvo0gSBh6YzulpFubo7tb1j+vnMqsgY4F
 GxpI9AgHAGvoHYg3456rSt/IpsacZgEPilV3Th02h1FD5zpSc6HR3hWYTwQi2qhxmrkZtRSRyr
 afy/iQLux6Igp0v0jqQsgeeg0lUKhkK1GErDmpDqMTSX1UbMRHGxntnX/5f3MdnR303/bXBa+w
 wDg=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="261441503"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:30:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/56kPaNaQ8XPaxgyQWnpbKkmUnPb08PFQzhAlwaPXIdkpKuMVVhMnng0zw6/d2z1N47S3NvoJw1AHbrMDdOPKpgoOits8X5M06RZ66iaP9aq867NwrGP5oFK9zStZj02OxNnjaC6hUblxPTtiGwudweFhFinYXe1zULFKVl91ufh37H431kZl5ZsQoca60Dbaym9VN19Bx6lOxTgEHAkkXtffw84GJNc8O3v9eky6fLmhXa35l5uM1SXtR6+0R4eBtfTl7eUO9alHW5BrLue4ug5CkV8O6W96PeJYFKPg4LraxpSEdArQz/R0TSA8agWLmSo7UBRQkELJ8Ouaxl8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCpZfgqtVjz4zTxqDEfZnDSbOHypl1AAPuOb1l9RIos=;
 b=K5wmwVogOAxX3oiNcM5HMUVpgeXFL7i3Vsr0IFGh7cDsZWZLfZYN/5EIoWsgsFv4fD6hoPk/wAknC5jG4enhFHYKmeYAGed1Dmbh3WDgX+Hj7dowkF96dmoe3tmlKzl0MQoT5+1FJs/RwRAIfbOmWnBXOoi+LqWYfhurqr5D5q8oIh1nQZogiiClnjW6YaS03IrHDrusJ8RCAfkBj1zNQ7bw0Ge/ETy/7tIS874cDFCRCQ8ucF6R8xOtlf+9c5q8bSiXLxT7rFCQnRAsjVsjX62X2lsd0xynvHUSGUkuGs6euZLimXBQRVWCigozIKL9GSvALGhyXgbl9oRP2gqU2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCpZfgqtVjz4zTxqDEfZnDSbOHypl1AAPuOb1l9RIos=;
 b=QqbSysMxaHpLPaEbnRU14mZsMKpQk3VY1sIzhV09Zy6uDpgo5kn6UNeXto2/CpUyTa5n8KttdIcZ8nsWZAQ8bByyExqTBluhnBq9crxAwcagFuTvcozWmzTCFOzIAZmnu5gQUwbGAlBb3A2tzMq+UFKKjm8g22R19NSfOtRiLew=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:22:47 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:22:47 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v6 6/8] riscv: Generate FDT at runtime for Guest/VM
Date:   Fri, 15 Jan 2021 17:51:58 +0530
Message-Id: <20210115122200.114625-7-anup.patel@wdc.com>
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
Received: from wdc.com (122.167.152.18) by MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:22:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 712b834e-ff2f-4c07-6efa-08d8b9504483
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB43303E21729C153E5FEF30228DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T0RdUD5boClXC5AfGLZjlUzvtnX8eAHdt+KkB11okdXiQggKcVTKVbbtQo1CXQVe1knupLZiCidYJgVp7hwMFMv+am/hivgQNILLiUFlJguBg3QFkeRIPjAjk454HCEGup4IzapF46/VBi2oY7Bi+DlrFGciAC67D1ABLNprZ/eE4c4aNbuGXbYWY8eRlh4OIRKlWlYPwhVA7+ARz2Xv/GLqmisBEVojniRbYkRScAGzfu2WzArlS0Na6QVa7H3UfPUwY2uswCQmc1WX4sLPvsFA1gsFG9TgWMKnWFnLf1dYmKxzG4EmXa99vKiSniWG7bY94mgtHU0nl9V2FSz5cnwKxeq/C8WqD0irvYqDpKb6FJkr6bsYsAxhL4M881WktrJy9Wd+425yG/8eDSO5LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(66946007)(316002)(1076003)(66476007)(8936002)(186003)(66556008)(86362001)(16526019)(36756003)(6916009)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(30864003)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Bi+2S09YFp0svewSAa52OyTNRs1uZiswL3knfSQCEO+GRmwoLf8SllZGPTsU?=
 =?us-ascii?Q?r/BKDhwBaUatFNP8lSnB8OgdL2pI5g6Hoah9ejh1RNKRnOd67MKwAjZCFox5?=
 =?us-ascii?Q?flt41hRGOqS7Iv10qOAhCL92UwSKOMWEf2sozL+OjSA2EjX+WjfH3XiX+GR8?=
 =?us-ascii?Q?SOJsVOE7e2Oay4MkXwNI9rdzQlnGLi+V90tjCvyKRfhnwCI9e8vi0/P/QYul?=
 =?us-ascii?Q?K1OjFWuwwXz90dpYv8iO97NfwAI7wtSMr/sh91OmTnMnLoQsu87clLYdMR6M?=
 =?us-ascii?Q?u4QyX5UczE9TlT/oEoDu99BOgQyRFfwuNQgb69lI476AmuGpf5IX4ydOFCr9?=
 =?us-ascii?Q?SxTaKLokhGqvpydr1CG9ozH1TmZCtPYPEOHvVRZgP5vYyBpydn52H06DjDDU?=
 =?us-ascii?Q?mjY73WgGLghzItyju2W7TCI6u9gqMZE77cJMxzIA/uCADasfzMIIjo4sQQDw?=
 =?us-ascii?Q?RkND9A0MCcs6c5Pg4koKGX5sAvJatzFJ5FXUIbLTZo4PCvtEx3IxlG6vKvGP?=
 =?us-ascii?Q?YkNPF0vpJS4gZ/bsK9h8LG82A3dZ0zAfCpo3l53SBtCEmraik8OCDkA0Wcn8?=
 =?us-ascii?Q?At6RMBbYOcu/Qnid+RuRg8NFUChpQYkUYt1DroyF1NBbxO6Jf0saKQ+k0NSV?=
 =?us-ascii?Q?hHyeKyzRY8o13qMJrmfgPE38HdpIL9w2ek2w4R9gvNMJGDxB/dcGQ3+tpwZz?=
 =?us-ascii?Q?gW4y+iOOrHOaOEWQ9apBLwNKjSxAoY76jYDq3SbBET6OkyYM1N+6NOPM4cdy?=
 =?us-ascii?Q?SQSuzId+dV+k2lWETvnxBbS3QNNfJ/QhvUYudH1M8R6AR556zlwiB3qVVpt2?=
 =?us-ascii?Q?YSfXHtpkJkxzuXxKGe1zIQ7wEeyk5U2HWhDmH9HtubPjdoqDBR9L58QivGQO?=
 =?us-ascii?Q?YlKqlrFs/05fctPtvhuWr1RU4erRdUStfpBkJwzzgvuoK/gkh5nj6/ekzECY?=
 =?us-ascii?Q?BTDjzSa6Jy0KGtiJYOuRaEmwouTCK+gbHjBZDUZH+hmeeTy3QN0g4/mJHRb2?=
 =?us-ascii?Q?Bcgr?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 712b834e-ff2f-4c07-6efa-08d8b9504483
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:22:47.3310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0ZYPV5y84ViJ06qzwb8hw0VS+C3bP4P9cX0xXtxO31VW9YLnSZ99rbrpkyIELrHVNs37kiFNjy7lAd+FXub7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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


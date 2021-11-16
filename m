Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05CE452991
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhKPF06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:26:58 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46810 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbhKPFZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637040162; x=1668576162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QMxnsZYmEZ308Oh86vNfSbeNNa42FMCLFimTUPcGoTg=;
  b=C9d9HwAuvrrekQ3wjNvqYlgVgD4YOu7z0cPPPVb03kBc8xzWMMKJW3kF
   0VnYyFX2nxTQmZTBv5E5zMNzufYAx94n5M7KvE/nQmeswWnnYOnBE70K8
   RA9AZ7vNR8Tf6Qyr+mkC/lb6zx+nRHTZOZe1MpiCN8ARcEEayXRXo2UZb
   Mc9Sz345rxZ3jjGQHNvUJRL758wpvzroE5Qh6EGaPS8BBN5AUzneV9Qxs
   saj8Py+BlLOujnCcuuVcGeBmzyakJdbDMnjAaDdFDV0plv54tk5uVqaa9
   eVcEFaO1z6NnJZdA1P+6/UPOQ4ZcKrNqvOYXqBA8Sky1OTZx6lXkwGxfc
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="297516502"
Received: from mail-bn1nam07lp2048.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.48])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 13:22:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlFF5kxjGZrwzaiBVlJTgEAiHwHp1+mjE6EhIU1s0Zwjtvecr5gklnt1YhpCQD44POeo7q85XdOzGINtDykXP+Wq3PTOzEazc8EaJBBtBMQ1esSYJyw7S67nMttXFeCAcP+UOCYo0xXa/TxaKa4RMgBi7WIJtZ9snzT714n6ByZOyuc13px87pQoa7g1PaBDOwVJ88ua8chjIgbBhvKln63zygYGgpiXvtnvZYLKIBnCyAEk9enxJaVB98/8MOBWMfWSJEbFfNHNS17Y6dMXLrUC1syh9GE/+qxlp9ZsxhVNIhTREDA/33DU2zSmQOEHeDee5WNxuXZ2p6vLarfvnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5BpwQvjVLMODXK/OR6C/VGdnfYPWEqutDq7Z6wEfME=;
 b=lWp4rDa0PhU5MlScYC4eDAVQFtQfCWjDzGmSGIQ7c77XdHY8fxI02wV8hOpB5NyYhin0mCuZzPf+gWFK089Taa3Np7TxvJA8A4jbFSMeehuI4zP6sE1Ujj7QcjHYDElwxti2sJIAgJHdRKgbdSpn5CZGOhitibZBkuuYLJhVlwxor7o+0bVgph36KbaAW9AcbPEgPrO87VTV14Fh58hFe+kGDuPuvbxYaOaZcL1EpO0W2SJ3dm8PwNpnIOcQYviXTTdCk5pMFJTqibvQzy0wQw7bcjHeKoRDKIsJQywMuNahK9fwcM6+AR+bbKwmc884nk06iyQbOGWKZYjvbG3SdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5BpwQvjVLMODXK/OR6C/VGdnfYPWEqutDq7Z6wEfME=;
 b=GCgsa5BGE/fFQew+MgepHtq5V8HMCEeYJ4m3xwXOaUvebEOpxPkz46dFsGWcNrkS/8SE7mxhIBSHRdSRB8yjCBoKsei4q8bDtmSuZ9mfBiJBWAnOhqB7lMlvSxQ7zBchjCBDPE+4UjespxEHncc5iAFIhzk6Te8Pejw06KDiyeA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7843.namprd04.prod.outlook.com (2603:10b6:5:35f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Tue, 16 Nov
 2021 05:22:19 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 05:22:19 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>
Subject: [PATCH v10 kvmtool 6/8] riscv: Generate FDT at runtime for Guest/VM
Date:   Tue, 16 Nov 2021 10:51:28 +0530
Message-Id: <20211116052130.173679-7-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116052130.173679-1-anup.patel@wdc.com>
References: <20211116052130.173679-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (223.182.253.112) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 05:22:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be796629-fb03-49cb-795d-08d9a8c10f7c
X-MS-TrafficTypeDiagnostic: CO6PR04MB7843:
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
X-Microsoft-Antispam-PRVS: <CO6PR04MB7843977AC5B4D4CEED99CF7E8D999@CO6PR04MB7843.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mPwThQTbAJ2FReErpveV52IHaQqg2vnS6kUtIIxwZVI1bE9KkbnvH0IylgiFuYYeXXMNrUcsB8SxjN7pHxD79qbp9rdq2h8BfN5iX+6lOfL36SwOgMS2Mk9oLFh7aZ16zZHsolhZCZ9Ys0uvJfk6N1biHKLEXYjITaniAp6yw0X518aiZfD+zt1hpGbOIpW6Mwt/ad7MoeIRo50IVVegkRRXWLX5NaCb/bRetKN+74tHuzxUPHR1tkNh0qAidFgRWX4Z5Lzxvj/1FvLXv9pw7GOqsc3whnK8Ahx7ViIu73pCljhStXuH5U8KmYd3WcJVSrdy9VvsPmPljqtJuO6vK8HyU2vdJ7qqzoMFKzByYiqSbbDWX/7CBHA2d7TSElLz8Uy+ip0aJhCIIAIIo31+hMUy2PZMbgoVtYApyMeLbCOBZyCo6zcdGyVWjL1uKkZ0mfKeA5zvKDu5zSXmunFfhdOeEp06FqnihdYsCVz4mquCpZgHYicwydVQ4P95eLyJAn31Yb2tcwsgcfLnEroTr+cPBW8vuMvdPg/pchHpi2hgPTT8Z4AXUq8x5Vx6D6uJvLnjJnyIf+SYj1blbY1vS2tEkGnnvJBPN7BFWWeSajneOlTOaCYqlv6qtxHTCzKJUGMk2UZVpj1hAughqbf59vvRgf4RB+bs0e/Z8LXqmbgISQrlrsxUP20XxwsOwjyvgp49g2x6ZkDcKDakOh7LPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(4326008)(52116002)(66556008)(8936002)(30864003)(66946007)(83380400001)(6666004)(186003)(86362001)(8676002)(82960400001)(2616005)(66476007)(8886007)(38350700002)(36756003)(44832011)(38100700002)(956004)(26005)(1076003)(55016002)(54906003)(5660300002)(2906002)(316002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mMfeOHfEEAe/th7Bi9fAY6tR34IAxd3lcEKxRySF21ww3zqYnnORXJVfrFT+?=
 =?us-ascii?Q?zkOQhia4Wxpjoa/kH3mmnP9CtAKQ0OOnXhH8aISg8vbash+mZO58UnCO+DtE?=
 =?us-ascii?Q?TyaxYjP6ogYLyhXf/xV2yY4sjk4uZMUan9HZnvfghMVO3iN22VLKOElmWyJE?=
 =?us-ascii?Q?rkblVft8bgnc9AoaCf+lkgXJnQF+ahtS7Ez4OgKQ6fLos2URQGqazg9lkW6J?=
 =?us-ascii?Q?qLwE0gG5ihAy0r3uv8KZQRaSvLwDq2k4jUwtAlpkxOJwiM5RL8/w3qc9ToD7?=
 =?us-ascii?Q?ZDUd4Y9TUM9BDBQzeDN7S5E8RBzExYA8Vi5x3EftdSNph0RfdK4Ql1TgBhSq?=
 =?us-ascii?Q?7fp7mwymovXCSx/LUwOWFPJ6OFCgxC1N2zADix4yQuwLZUB8sOACnoQl0kos?=
 =?us-ascii?Q?24YM5RaVI54Peq/mBGqf87dB92wyijp5KlhRdLanr+rnnTgT0K6fiAKLbF+v?=
 =?us-ascii?Q?rjm7sL/g9r3Qq5LYQijAOqej4sD9/BpUmZZMfgBw4Pzl7U/e+lUpZjsf2Eqf?=
 =?us-ascii?Q?uZfklQ2Z53kO5ixfZhPsGN+AoOP1r2YxwOf7TkcPV7y4anjxOO4x3jYLflte?=
 =?us-ascii?Q?Ty/+CTu35JbzsUX73b4MraKm3va7EPk+iwi3roCjdLAbw9hoEzvF5pToICn/?=
 =?us-ascii?Q?itmi69eZ53SkzL/yTrYvOoAMk6qPzpubodXGl2vbT/DL/eqJhpvZdGa047f2?=
 =?us-ascii?Q?okN3So8fSZy3Em9xFhwZASTyLYbUpovgUwPmQMk5WTm6u5R/gAe09xEIniZX?=
 =?us-ascii?Q?2rsr/Xh84tzAWLQ6aV1sWclgBMGEUEj3Z8Pc9qZiZfglT4wlWAcvDJf+kwhp?=
 =?us-ascii?Q?6HTZUYIml3AzqBr2xQXE3yTw+SFKiMnlf13YabaJXNhVvr058eWm58iMHDfR?=
 =?us-ascii?Q?k2+v/Z1nuzCh4CrQnAYs3NwJxlmlRwNi4Jomyjsy1C48Idhicp/ecsEHf/Ue?=
 =?us-ascii?Q?D56X/WNZfjwdyC21vyohIi1K/ERsm/nWbqA74J+cgCs/QLGZwSi8TFnh+ksx?=
 =?us-ascii?Q?1H6ztPbKFWJs4HAnF2vhXBsgPkIf8bBeAcbfaaAvZR17eIWwn44RYaw/CnJM?=
 =?us-ascii?Q?FxdWakUIeB7Aip2/KDIwkO+bSSJNXH/RFx/78nHYtDH7bjdiO0C95CNGAQJk?=
 =?us-ascii?Q?OiIp48cAeQDarPD/QZ3/eWFOSy4CzOneLtetL/e9Eq9zxv7IF8K0xd3KstC8?=
 =?us-ascii?Q?CKxk2Jyoya9Em9V5GiaTPcHMNYc1bTCW8bAyLikeZi9ted3DV/rX2Ab+S44E?=
 =?us-ascii?Q?7NUsQSso06bJ6NzIQI3EX+sLeGrIzdeHRl7/Ighlbf+9XKNCtg+h6KVUj8Cg?=
 =?us-ascii?Q?ONF9OLQ4t6RCM0NFcdMW/CcLmEV7ATHvX2NdBvIT4TOKm5iIIvNQOAjLVyrT?=
 =?us-ascii?Q?riecXsp7fMDxpWjVC/QB3aZTJ7ZuU6vF0p3voRH2n1jzfatNvskVt8exa3dP?=
 =?us-ascii?Q?J3rpl71kOSweTwaWZ+U0dSxnK5StBtDSBnhq28zR2ceB7qm7FZPFr0aNpUog?=
 =?us-ascii?Q?+7Hs9KDHgChNlSRHqCFl8/qWEZvTpdKb6jWH7WYPUdpEph1kLdAgdnj9g+p1?=
 =?us-ascii?Q?nIdacjIAVPZ1mE5kUwsRLpxLtZen9qOXEQwMgLwzn6WUjFEWUhoxc5pAlFVW?=
 =?us-ascii?Q?+82ub8owDMgCLuCJDpbX2Ww=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be796629-fb03-49cb-795d-08d9a8c10f7c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 05:22:19.4383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vg5HJiYCymEphS+AgiN2JISP/5eV8DJs636BSeOG3p2vZyrk0V2I3vWpmDUgjn+BM83OgQO7Iz9OKvkuZU3mCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7843
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
index 25b80b3..d0be965 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -80,6 +80,8 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
 
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


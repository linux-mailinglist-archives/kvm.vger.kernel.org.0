Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B471351B61
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237386AbhDASID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:08:03 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24190 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbhDASFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300344; x=1648836344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3x6r9pVOvOLNv1fxhrOh+vKYHlukNV9gU7/0xOmAtBo=;
  b=Y0yiew8yTcwr1X30laPCAU+KlQvYY1sQeNiqOzlLle7S4oqgiSJ5sBXz
   pWhBAu2NmE6RAoM+XkFRowTIf/PcyILPqTAfc1pV5l0c9j2Kf1tTgYyJx
   KJWzcTCEk5qTkugNiXiJnLXc0+kQ105MMVL+KdA30nvZOKlOS5JSmcXL6
   EEZ7l2fyhMT2hIS4UWD0eNuhzP2TbvTJ6L/nM/elHBBAfhnCEgbCcx4My
   eHv6YcNachCRj3oq4uErZ5svH9ziqakmOfZVtbJ80yaveCPj4I9suTYFV
   75tZAE4FxqAMEQz+zr+rGxu7hBHaLJ3rqJm2DJI2sigkXkwFxMwyOW2fV
   Q==;
IronPort-SDR: e/GTCM7WJBXK7svUEPkln9XO9VUL9DELN7GI4zfiVnrKoatH8t61zuD5suPzGQZYKIB6p7Zh0N
 ULTCNYhGkp5uyqHyK3I+F4Fafc1A2JCHR/ALpwdQd4kCbMICMDxCCpyKvonriK4BfnxqVQObqe
 7PyBmrLlX45M30hlGuQ4CFb6mgzQ8kR/am/vcM10OY8iJfnrTJogTWr33V2No06+L6u2t4PgaO
 UQMyQ/zpWHDJVnV5gS7aCVzkw9hFWQ2cuPwWdTU+bRHANHJTDDzYBBNK93OqW7bJ+c6lRLbvHX
 7Ww=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168041958"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:42:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnolQxq09H1MbdLceAzysi8ptcJ8HVoCcpAkA9WH9P0cQaFwsFFi3a4yQu3n8XpoSXyQ3ZWstlpmDakQNkw+9H7BI3O0rm9Oqo2P1fdlNNODHQOQ2cWl0bOi/w1fErcXjs4HiSf4evCV3dWAEKuz6yRbIILY4dgQDQdJtNc/xwFRAfb9ZUP4dFptmgERO9mfdm6PUAI53WZErrzACANxgeA3wo/xSHcGvH8irqUZxk7//rB4ZPhBLBO4jMeLOBrEjZ7Aksocig3jzObae9TgkzwayKFs1nFPXevLOba/XLxJxTgcpDVKL8l00R2yjhy8bKy3p9GNJC58XDS8ov2TWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cO3bthXb+aQGmAk64KQiphLrIGWPoG1itlPb0qqjj2s=;
 b=BMbR5v+tXJxaYr2jcWmwEpkiFY9ccsEzGgIDrbAZgPPdkZ3urH/EvKywCojgor1Q40AxBhlInMs/XPlfi0fRckLOLRMIdKnz6mpvzq7iS/FZfhR584MCxIOSEHblm5kJAr94dd7aw4Vi+aXiUGMNBOfSD5jpag1A/UMRuVMSv63C2DDBaPXLMNc9YkfeZpU2LIzvdiSBY3nwLwsDf2EmJkH3rRchZhRDAXp4rK8rqlTo6rBPmcPyYMWFptC7sg4hfaR7699lPrku45hdsV1ySyGxY2djUKhd455akwlcOJ5nBoEMur7Sm7RFMZTpLnZwBcicJjDyhRyBcrV/68fyZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cO3bthXb+aQGmAk64KQiphLrIGWPoG1itlPb0qqjj2s=;
 b=gupzTh2dVY9QrXA3X2oOaVHecmX6IYW0VOa1Cc+tMbJLPP4l6kXqQPkMPWjJY6YsdNw6bN9fJ5Ez4iU+U4tvBlWEkcVbeuHCe1lJx1xOjgukX72zi7CYkbeSOKz5rLHMq1Jb2Dd9ATIFZiSiVtQ+m9AbAlzdwx4Phfgv9H3b9J4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6493.namprd04.prod.outlook.com (2603:10b6:5:1bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 1 Apr
 2021 13:42:32 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:42:32 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v7 6/8] riscv: Generate FDT at runtime for Guest/VM
Date:   Thu,  1 Apr 2021 19:10:54 +0530
Message-Id: <20210401134056.384038-7-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401134056.384038-1-anup.patel@wdc.com>
References: <20210401134056.384038-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::29) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:42:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5937526-7327-46fe-6c1d-08d8f513ffcd
X-MS-TrafficTypeDiagnostic: DM6PR04MB6493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB6493F7E15ADBBFB082061D158D7B9@DM6PR04MB6493.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vc8d7XGtzAFxLWvIjFE+XTpjr6utkcJVbJOKCsGis89ifmcWGPfnHNooVBksB9hkn3w/wKi47UGGGQJE/htnwijGfBDcilm12kJMlbDHtH4yA7dmdjSE0GTJSvsGyoWTudQL0tOxnCHTqbIZJdQlkDXw1AvVamqHWv/Cm+KvK+dnwpBLkbQOXkK7jf+actJsNAQDV7zpp/PEmksUdxfAO9whndSWQCsvUkN5Jt+EiRr2/dJUVUIJhJQ38Hiy2TTDhKuTQXWbtiXrt31uEWXsi2z4FYtCAtIRrMURSM7WfZBgblb8jsIaAB2hyKCxfbQYaZCP82d2yA3NJMHyytJ2JENzjTXwcB+8/FrVhEcqUPiYrk8H6xJmTeu6SN435AYi27e0YK9tQxEgBik5IsfqL056/ELMEZ/BBuiMdN/VF1CxomHOaH1F0xDai4r2qEX3rOV0FRTYpw+9GqsHR66yd2Q3Pt8S1nL+V80ljfYOcOhz6IjJy+7PqoeDS3zAk5myl3UiAHPiDC6GWevKBEzxBZnVNDJxeXxhto5iSaF4J39EN6A8QPtlxhRyUyY0S8wfbV4Z4exGVFzHWO3t/UScgPKYyzFrSbF6i6xSjPjveU+AQnn4Q1w+/H6rOLOJ1WyvhVRCJmek1HIJP8TIt6NoEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(478600001)(26005)(66476007)(186003)(16526019)(30864003)(8886007)(6916009)(66556008)(8936002)(316002)(66946007)(8676002)(5660300002)(38100700001)(52116002)(7696005)(44832011)(956004)(83380400001)(2906002)(6666004)(54906003)(86362001)(55016002)(2616005)(4326008)(1076003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iFtJDNxKrwfls8+iIAHEBUWOkIAyAGPFdyiKiK8XSXMpmwLmh6cNQjClSYlh?=
 =?us-ascii?Q?lx/Ip6gyfJhviH/ZpycLL+XnrrdB/+0rbZzH2D5hhAYvSU+Th2wHNUnSxJyf?=
 =?us-ascii?Q?mnLC5PyfZHfb6jSoGxMjutEK6c5DqMMJx+Xq60ryfaaI6g0GmbnZZsSXahFX?=
 =?us-ascii?Q?vuXqrvg+09zSwxIyS7JcmAE/xmqI82jqx+TIg98isHU6cBosM/N6/Jv7ZiYh?=
 =?us-ascii?Q?VzEKoXhUGDgqkeaMJ9zwxtJnICthmcHVxLzdwEscz6hEGdxMR+joEBPSHCIi?=
 =?us-ascii?Q?tG8vDvZH0ZXsoHpIG69GGjd2nTsePZm+tkRBI6z7KlPS1sjpihCHWCIwM8E6?=
 =?us-ascii?Q?eVTWphSDs8US8kCV7oCLasJlX1oCAQ1tCXk2U1gfdil3ai6w3jlwbPhOOyai?=
 =?us-ascii?Q?vheHJ3038/3TTyUmnnqFBKoCqIDlMqy9sBOieyDX6h7NisnT37KN6Lc6rY8Z?=
 =?us-ascii?Q?OxDWXi0YgImG6qlbCig4NI5aYNxAi8MmMni8oRmAGkAcg1blqY5jAZanruOr?=
 =?us-ascii?Q?MsP+RMznCDZp0/dbda4ZJCg3fiNmLnbCW0ZnEg37i/4mxDbGClrHRL891hvd?=
 =?us-ascii?Q?TUmuBhPXaw27NdG5pgsR3f9JZxsBBl96gXhaVYJBXVN3Sg9X02KlfDQ/kKYH?=
 =?us-ascii?Q?8XP2OmwNHQ7lQ4NblaPUWe/KViJJyOC04YmRwHNGBDie+4JpLpdUe3ajbtya?=
 =?us-ascii?Q?4xaWOX4Gsz/9Hv7XnxI6qr1pGSFq0nvM6nDvh8AWtDzNf9pezzeqrHfIA9rO?=
 =?us-ascii?Q?xutojmBcr/kvCgNk5A2yPoW0dyrJhiwXiE4d8p+mg6rKdri5j/L5F4wpuQhn?=
 =?us-ascii?Q?8fumDSIxFs8WMpbMgkOT01B7wQ3c012KoGLOIzRw7YzRIzRoW5cp5BrLx5V7?=
 =?us-ascii?Q?5MT08+vbLessQoeJgijS0HNE+7PkkMmzyy/FCWfqaWO7Zk4VIMN87zZsfkRY?=
 =?us-ascii?Q?n088c885eiI9BXB3gNjyB5JN4L3Ji1K7TUoOHOKgvMED2cOxPjYqP/1eebO5?=
 =?us-ascii?Q?aXnOXQgiVjvGAEm4TEo+j+w0Xphz2B2rEaKlZVnu+lvPaxSHWoIKkVnQ+NNW?=
 =?us-ascii?Q?fSuAwhE75mth86HLoNUx3Qqurbssgmhfelx11znQ0qBU4Fl57JC+yNXbkqzX?=
 =?us-ascii?Q?6QdBM24NZ5cfOfGIbOJZe6cVVutqU8QmkBOcJlZuOc1WcFMjrKbGiA4VtEwW?=
 =?us-ascii?Q?IrkAQ2Ekzs9C8N+ANcC4dqMq2jbrqi1Hs7eAQaRnWX2cdKjYENZ5RFS1iIzZ?=
 =?us-ascii?Q?RdOZrl2VA6om9BARJGVmalTwDMRu28ZC7cTE970vSH3MtrJuFBYzrDpUVt9C?=
 =?us-ascii?Q?+WGJXXiK8Jj7Jmtku0HBjOqN?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5937526-7327-46fe-6c1d-08d8f513ffcd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:42:32.1669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysvNHpGxj0vjoyI33MqeQI+K2yqq6+Sc60fYgWQE7ypi4roOHkWGzZVLLrqKONEp/96EthJ62/I/hlHu7s3xCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6493
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


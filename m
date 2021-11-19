Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1991B456F08
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhKSMtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:49:09 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16451 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbhKSMtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:49:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637325966; x=1668861966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=4tUeWSdewr79RZr/gdR+EQeNQWlugyWM2ECwyN3mHGI=;
  b=Wf9MgIAE3+1w81aDrnM2JkF159m8/+TuekXEg0H9LLvEzuhS/gsrXptE
   crewtRET90mlln954qeBkv5Y9Ob+VtgyzdfV/h0l8pRzTuvQQbjtb7fku
   w43N47RWABaXca3w3Ky3i8dyf/p8uPVxGePPnDZEE+foj24NTGhV65K/k
   CzohAit/BEbXjhBSmeQnu1LVSi6+bYjxWwqbShue4F0jIbFTmluAZgJC3
   AIGKTTUX1cGlaidTM3aBnI3PgpFip2aiUH9jnkJtWpqvYzTyii5jMzilf
   kOFkkCyoWvRPweR8qyAK1Ntnp6expjdErr4ozYeTq8Z3SoKZPMFxbbEw1
   w==;
X-IronPort-AV: E=Sophos;i="5.87,247,1631548800"; 
   d="scan'208";a="185086383"
Received: from mail-bn1nam07lp2046.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.46])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 20:46:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GO0B6Q7GzScLQJtbMpxeTrMZwfN4/x0AlinwIGuL5qglyRPEL/82jt8Yt4Sa0+XPfVt6zaoF075qCSOKlD5KU7286aqqumYTwdxlEXjIxPLLmQLmD/JPdLA4A08huAGzg3Td3FgdkEa9vwetNjIIkJyV0n/M29HJBTs9Vp3ybZkx3JPEBVagVWyw5osCGzzW6gA4dQRfGc0vxdw76yEq+86sMidvXsgGR7YukEs5AZlc6/FwCQt+1DO/J7M3SRoLvWMJFolwNslT6v7WEBaF36RI9xl9iMaCv8ceH0f4UnMJa3Q71ZDSxMY+jjO+hfM89kgstWhF9wJkGSbZ3yz8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ymj/jUfRvfQKFFyfcvvQ7E/h6P+RIzYSsK75QE7SGRU=;
 b=fWwjQ/vX+E+yejcVlEyXWUmJbsOd/FradHa3Zd87OahlTrGMuEY+Cnj1mpmAqdPBgRFPSyKTDcjwO8xUIY0Umiwxn2/qvg/9X6rR+CZpfX9AHnsMVy5+mpIAKIZ60C0BsBY8RjBSHd2pup7chHbRoZx6l1lsvIrItfCcuoES3NC71FmyBzY+KvKOJhWgdv/sOCTavsHaMAZon66pLn1VqR2F+v/N75BmZkb8Enaof6Xf2CmXe5VH7VRvwNy+YrRVUq9kBtnklJAapea0dlN53Sq38q+n9Lubqnz24hRPz4CY8Lmzw9J67u+AWfzCABPRQozE1e1ldFe74klNwPVFXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymj/jUfRvfQKFFyfcvvQ7E/h6P+RIzYSsK75QE7SGRU=;
 b=loqmPUw68LnhmiDtRJAdnAQrls9tjlyYZU/qWlj5iAvG3vX1eEZ5fZoVYT/6UbbGXEnzCTWQhZlwZ2D8B7SLe3Q/+Z5NfvIA+cH0bUyOcDLm1UT6UMQyO6dUbcE4RuZcGI951ml3LiIJVrTI/V1ab+NLN/hEKWVJrBm4T4+/1dc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8444.namprd04.prod.outlook.com (2603:10b6:303:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 12:46:03 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 12:46:03 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 kvmtool 6/8] riscv: Generate FDT at runtime for Guest/VM
Date:   Fri, 19 Nov 2021 18:15:13 +0530
Message-Id: <20211119124515.89439-7-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119124515.89439-1-anup.patel@wdc.com>
References: <20211119124515.89439-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25)
 To CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.171.140.195) by MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 12:46:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84ac94c0-16b7-4070-75ef-08d9ab5a8be1
X-MS-TrafficTypeDiagnostic: CO6PR04MB8444:
X-Microsoft-Antispam-PRVS: <CO6PR04MB8444CA4B6448BFB93AA443F58D9C9@CO6PR04MB8444.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:31;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fc1XT6eK9nhULiGoTC9Ij6yqdhApxb5FVUA5wYjOscHxMOhrYeEcUl5FIEquxIhtq+tPBiZpPkAukqrogsQhiZBXJtsHSI6KAY2Fv8ZJWkFKUFGxLrzjBpKVABA7sIVQFgzp8x7r2ModcFFa+Q4PPPZIwp/ntf0FJFlC3z7gPKyk2cAR8z9D3PoQvagVFxGxDaPoVT+E6MMox4X0Ve8Y1zolvFZ7QeVKBwkxkUHFK7pVWDqXdsSRug2fQEfUK6a+Z0WyjF6VXbZb2mS8rr+0pMkGYtEARCsIY5DaOrgh9FXXCkEpuiKYKGJt3aIJlZszUySykOri0l33k9Q0aLcjGd+LGZ153xkKP3V9g25e5b2qKOYhwpEVCrZHALjq9ZuGVSc5GNqQlAI6po0bYPDbo1k8kglrBOwMGaWmK9nJTuAbh6pCqgZouXWaUDvE3n1z0BBIu3vsfJXeiKoPkx5ehH8UGLgTff1kgh036ct4MlfxlaYE9fDinU54r4GTG4p0Iuogad2hyA3l6N7o4IdBvhzmtzNTrsR2nn0b68weeTTA7NZ+d0ABwxpVyXj8zTokjgfGcnFUC6kgJlpLozIGwwCdatNZXIXlooQjrPGwQqX322uJeHc0VsHJ0/6BalPyLqt0pAwgK2j6mNra1RFDcLbezh+mAbyVZxq7WErBP9YOg4kvyDJ22Gaem7KsA2E/Yd71schZDYYs62/WD74l+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(1076003)(38350700002)(38100700002)(30864003)(44832011)(66946007)(4326008)(8886007)(2906002)(66556008)(66476007)(956004)(54906003)(83380400001)(55016002)(2616005)(6666004)(52116002)(7696005)(82960400001)(5660300002)(508600001)(316002)(26005)(186003)(86362001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sz6/E5YOwH01LeYVWcAT0ouuxGDSm2iDSyP74bgqHjkZXjAy6e5W3gVKfnJu?=
 =?us-ascii?Q?qk6gRJMmemeT9jZ4uZu+G3IDh3CLmwLH3NsTo8vXS2SJMIPPZlW7T2cz+C96?=
 =?us-ascii?Q?THGY7BuAaV1xzBYDn9IFaBsKrLjvsPwOm+/pwMn66Dwi9phqQIAf4LNwg1SL?=
 =?us-ascii?Q?UYqZaMfXlMy81e5Tl6FaFt25Gz7ISjqPMJXi73S0ygy8Z4Ot5CflNBzbUsHc?=
 =?us-ascii?Q?YZy2iv7DTTMkS1xCwZNrBOb1YVgpMBjL+3z6UtJCS8uek3+KBx4xNOve+XSg?=
 =?us-ascii?Q?HbvFp95V3y+XvxxACkVf0yhtU89kJH/EFzztu+E2ZSnifjHkEmkRQvBjnT3J?=
 =?us-ascii?Q?HRiN2VSmZ45R2T2OYtMVgTY7tnN8uH9789w38njuRMvXM63IwUNg3xJbu3fQ?=
 =?us-ascii?Q?nTqMNdT0QGNcQPetgZHIRv6qohYEHRuOeq/wfnoHxrzbdV+GkG37m4bMhZ2o?=
 =?us-ascii?Q?xYcM4BNG3A9ya99XOHFmOnEFQx/Nmwi8Lpzo9rrC/3Lw6kkgwvni55i2fIls?=
 =?us-ascii?Q?nBxLP05DM59dVuysapYPtaI2VcGqNeFYHj+U06Rj2AfsxLNXd3MXPrXbABG7?=
 =?us-ascii?Q?Bi3gNDgAeP3ivc6QZcXjD+jRDlHbOLArgDLuAUdqcYzntE6tXjhzZKix1FQM?=
 =?us-ascii?Q?DaU4kEn7z71H6n4q42e4dykhdamYiq0InTVoXvzHQXHx1UgfYqMp/EVHXpA/?=
 =?us-ascii?Q?h0i87vGgNDSGzhmoL71HjHdJINZrrt82K+IoADs+j2W2m7WuKndssky3vFxs?=
 =?us-ascii?Q?re1Ikq6Rqu1ZwstXLfH2nAGouFI00FzL/SoFBkrioJll2MwHNgPP2BFAg2wi?=
 =?us-ascii?Q?z/kBYNtndg7gT4vwLA+5NsMP+nKz+gTFiAH9RF6Vm+1CjVNMwrHmIdYusoL0?=
 =?us-ascii?Q?2It6JoFeOzpDGlVjt7aygLInPO/3Xv5h5ebb0AcHKOYyVWmH5m7CkTI/SyU/?=
 =?us-ascii?Q?6LxoX91eoPm0hwmcUqL40wnBQkvlcDxMk7KzwgX1+uPMCe9zKf/xj9JoC/xZ?=
 =?us-ascii?Q?OXvsnC+oR6JXZCWvM9XwxL9tZPej+k3WN8zhJy4DC5TxlGsYz1UzhdtVVEK3?=
 =?us-ascii?Q?f5I1+4mTiVuN1+6J36ooWZibhZQ4G+5+hdChtW8DJX09ERaV/0M+V98sl4vK?=
 =?us-ascii?Q?ozojplWh1TB8wJMseQK6T0aClezBY0gPhnEqgzrSSHX1wUBdtyiE6o9Kvscr?=
 =?us-ascii?Q?GmrQKGQbquY7ifhYStXMmOw28I3zwqaO97v1WFKs9AAXsJygys1ktLuwK0Xa?=
 =?us-ascii?Q?7Q+J9GLyfDTkiOP3Mz4vEV8w/Bk2+NhVMwPeI2/5ReAwru6EBkfYXB79ArwX?=
 =?us-ascii?Q?Yed6PdtSaIoa5IGP8E+TsC7ZYL+nk5KVPApCKEMzcOma8+ExzEbvU1UI50x9?=
 =?us-ascii?Q?9Glns8O3W5tvasyX6aH1+pQO0SrmS2jHX8RmSTLqz0nZmaO6ZoECqZ3KG8NX?=
 =?us-ascii?Q?Odwaexmt1OYl0Q4uxLNK9Z/L8EUCfLXX/MNMsogM+FAZeNxifD2GsJegHMCS?=
 =?us-ascii?Q?YgFXgDl9Z0mijoTsrfa+nFl17Z2t7bcbZ3CyzkfO4pa6wKVQsF9rPf/awRn2?=
 =?us-ascii?Q?SYK/G2oMK2nqZ13adHMULLgyYpJ+KTsA0Ddz3CezopwdzB53fd/jxBIpBNOl?=
 =?us-ascii?Q?59csoEDWVeyHsY5J7c++nzk=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ac94c0-16b7-4070-75ef-08d9ab5a8be1
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 12:46:03.2976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKD3QP9f7kKxmiydk9v7Io9M3VIaH//eVBnGZgNfttKLOYPncGpgfK+uQIjesvRYIXPglHskuJnrcRyb+PtKsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8444
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
index 6d64e8b..6242286 100644
--- a/riscv/plic.c
+++ b/riscv/plic.c
@@ -1,5 +1,6 @@
 
 #include "kvm/devices.h"
+#include "kvm/fdt.h"
 #include "kvm/ioeventfd.h"
 #include "kvm/ioport.h"
 #include "kvm/kvm.h"
@@ -463,6 +464,54 @@ static void plic__mmio_callback(struct kvm_cpu *vcpu,
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
@@ -472,6 +521,7 @@ static int plic__init(struct kvm *kvm)
 	plic.kvm = kvm;
 	plic.dev_hdr = (struct device_header) {
 		.bus_type	= DEVICE_BUS_MMIO,
+		.data		= plic__generate_fdt_node,
 	};
 
 	plic.num_irq = MAX_DEVICES;
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D892F78D4
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbhAOMX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:23:59 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48767 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731964AbhAOMX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:23:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713437; x=1642249437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lDq+FKo7RmMLlDr7OA4J8sRiNlAUgKGsONyvb6DEe/M=;
  b=MkzfhPaprh0uSRDWdGwb65V1Lx1/ESrb7tRfebJkrVl6bUtnTdZKkiyJ
   Ee7KiurLwh6GfKqAZQtmh+au87PJRCQYNT39lyePN+ZIc8iFJrr1lVWfe
   hiDnuyFynySY4sSAz2Ekldji9cSiq6/SvcnbG5zvmwpQy6aE0dH62FiDR
   2LfmgxfUz9A+k0Fzp/ASLi7jgxI1uLS/8cusoKcre5+M7aIQsClB7XH47
   QfT9m9YELfJfB3Yo7ahdokDqLvKF7DS4HOqf5ADCnGFSQU04pHT2FzITL
   12B1QRFGC3w23/Gyp7q0nf9ZM+Q5Q9nM+ZoRDcHNru9lr3165vgALgymB
   Q==;
IronPort-SDR: 0A3ydi4riZTxCMOKOWC2i/MkJFJeY7ePK3uxi9JhYhLGWN0uNqGuATzsmYaVyqShwgQHVlAGAu
 Sp6daR/FMpkkGTD6XeUh1UJK8NTpDbgfUWOmpfBW+MlwtyZQolg0OYaHdJN9sT8XacdQk1IjYg
 WeTzi+6ABJwq0f7YpXEtnEGC1SmcpiTHd3ImbgDm4voUCnMpbvrEtPWnkvbpbb1qiF5M9sWVmt
 S0h8txjEZDr+I30A5HprHBWlK7GKFKwkThF7QqqQr0kLPQyMIw1eS+Hl9w4FDcapLcXYGpNf/A
 AxQ=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="158687560"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:22:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPOKTH4RdgCI6hBiSzmC4LWbWnicU2epijzmhQCgKQJFomOHE/7fN8gBi4yXyij4niJlLhMmzq9308lwWx+10xdJ4I+5Vi/6lTdLyFbZhf8ko2OrsRx1iJv9vpiGTpntehgJV9IUGeNUKZFODMexjp+P71qgBdJqNHr0G53gzB2IRiBa9b+d3Dr8zgafqlMiUp9+mvW1z7jF77JQd5Nb7/2CgPoehn33adSEgG1jesM+VivolQ+Oi5JHkxFW1toGuI9ZqR54PU6vWh7lM2nMrauZxwUNNtNhTGeO5Raug50d+w5Mf1l+MgUBKl1yUEh3zEr8OSQ2iOWOHgoDRH6KSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=VOQK7RDi7UgI9NlrWCELLDVwYR7hGKFm60cKDTZcF1pbIy4baPIgaDDXBqbaXPG391apkfKE8ex2VF1+N3r6tztdtBAwBAiPiQK/sIizNPTe82weLGsnMNwqC4mIev0OSsFUoZPaPYILRRnkcJDVNrXOq1LMUDG38Mjo6Ws84uQlQ6GBPIbz4uKdIESKjz3fNHUxxs8d8rZKq31Jo9lhA8K7sZFucPzBSwC8ybubNSX4BmwlADxAfOc3vCOt6Fzp0aWcS3ylAPKxhjYhouRaHUMrxzkGboSwZzrTBzt2lh1Ytz3/SbX/PYipTi7/sFxxAh7RutFdkchA2XfYZRUZBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=tUumApUap1TWCR3JcCHhxAkCgwCbSBkJYj9ZUWxCEkwyT3ArNjtBVyvoszimXRT7t6WazEb2anHv3VKPor4fB3GWBV8O89BIU5yfPIVhDMxtMDS66PYhCPJd+fPyARcAPU4QLEvmGAGxxOd3n0QSKknKZ3sWIkVbvFJLq3Nj8Go=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:22:50 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:22:50 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v6 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Fri, 15 Jan 2021 17:51:59 +0530
Message-Id: <20210115122200.114625-8-anup.patel@wdc.com>
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
Received: from wdc.com (122.167.152.18) by MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:22:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff5a2a57-a183-445c-5288-08d8b950465a
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4330FCB36B573CCCC5B1B0B58DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3UK/2PsFW/EkqmP2cUzmtCGNhsnQTYEaHlgRRUSt1lXLqDj48igEWZ/8E4w5ejnxrxfbRazhhHRKXcXbX0aWfOkRO5PDEXQ9YFCjL5Gem6zv9PhbmZLaS83Bb/obdbLwygo+axSbNOOvoGZKz68RHRkpnGSV1WDrobU20+rjZrsyoI7J7C10cAXVUXC2Cx/OompF/WZ+yTtvoCm9QmJe8Pa2cMhKXMv8PmjF08j3PPCG0afagV1RE9PbAJpDhV0xq3uNqcsmjp94zQkIERE/4XgIRH0/HRV6g9sOJ3pT8KMoEj8bz+sq9lhgNAiYigg4OBc1H4ZfY47Fv9Qqm5QvYVxn2BYA90Al0r2uglndHr0Iem7vZ3gsBzY7vdaW8Eitm0Hne54QBAwG3lDKypmMkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(66946007)(316002)(1076003)(66476007)(8936002)(186003)(66556008)(86362001)(16526019)(36756003)(6916009)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/6NxKIlNQDLWk3p6dsV/ZumFeLzDaUkTdfqK+P9KM8RyM7CJ+Kr8lDfRXpW4?=
 =?us-ascii?Q?/sbT7hQMCoPtkh/0wnqeETdNzWCAm1VWtYQugV1Lv4nf4zwfaJhpKPjDF8BO?=
 =?us-ascii?Q?boAj+f5veNUb5LTa9Cfw0pDf5hFeeIlz78FVonpZ+0fQj2GpWYS7NKZANsjg?=
 =?us-ascii?Q?tA3sjUuR/g06wnmwGdrXSG+ZtXQGdRifX4xf3PNFMGucsbg/ohLtq7fH/lBK?=
 =?us-ascii?Q?GLu464WXeguAOOAOPQXTNFcn/HEd7+8zUoeFb+Pu9lmvzzDEWifttGtId9PL?=
 =?us-ascii?Q?dGONyyYcheze5iMy6olE6hdvrljR2rnYFDrF/WFybAb+Jn8OsGjSxXrK+3ip?=
 =?us-ascii?Q?aUUc3F1aZUpsAzOGVYdPkSztOZfCd2U8WKyimMOrTXaH7pursFKtuEdH1k3e?=
 =?us-ascii?Q?Var6DcfVpgBosyYXMhyNAzLcWH8hH5+UWh0SSlwTStr1TPD+bYanlmD0zHU8?=
 =?us-ascii?Q?NniZz4ZZfJvjKzxrOEd1qDHrz5q7fbwPt0yS1/25SfzLI6mEnjHrbMCx5i8g?=
 =?us-ascii?Q?gdKyNxHujejvnDGyOEfNuCGVvRG7R+N2bkOpSQq8/wtZttvrScwnwYWB3zsH?=
 =?us-ascii?Q?00DCaEGK1w7AcEBYWsOvwe5Nltq6zNyc0umnzEAbkpxWlalJjmcKm5Ou/5wJ?=
 =?us-ascii?Q?+AmdEAAC24M5aTp8KtII4JoBaSnzoUVtFsogKg0t+Ry0uguxkWwv5GeHtQvq?=
 =?us-ascii?Q?pei12g5cyP3aMyr3VmZcVO54XtxxDmmb78puXqJWWKz1W2xw5fXidO5ATais?=
 =?us-ascii?Q?vfFcfflRabxtl679QMMDelXdePenGK/JiouK5/zYvOQEIPvvaWZhodoOHsra?=
 =?us-ascii?Q?ldGVcGPSpxSefwLbbkHFzCXxZUXqBSRcpdbtmipVcMt4o097LkpR1tGh4/zt?=
 =?us-ascii?Q?hDzAk/iim6my5aVg5XzWnPrQ6yuG+7kIxOWY3xlq185aDPg/yrTAicwCPF65?=
 =?us-ascii?Q?whwO5MyKKy4Y9UL+3UNov+joane/ehVZm4wx+ckpK+IB8vKFSatef28Rdqio?=
 =?us-ascii?Q?pctZ?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5a2a57-a183-445c-5288-08d8b950465a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:22:50.5029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LB7sq+rlUwosyJQ21JoZIsLnvSgaGQCcBbTOmgkTGF+fnCop/ZgcKzH1hobLDD0dfy0/P2YSyu3SmG9V3iVFww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel KVM RISC-V module will forward certain SBI calls
to user space. These forwared SBI calls will usually be the
SBI calls which cannot be emulated in kernel space such as
PUTCHAR and GETCHAR calls.

This patch extends kvm_cpu__handle_exit() to handle SBI calls
forwarded to user space.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 riscv/include/kvm/sbi.h | 48 ++++++++++++++++++++++++++++++++++++++++
 riscv/kvm-cpu.c         | 49 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 riscv/include/kvm/sbi.h

diff --git a/riscv/include/kvm/sbi.h b/riscv/include/kvm/sbi.h
new file mode 100644
index 0000000..f4b4182
--- /dev/null
+++ b/riscv/include/kvm/sbi.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Common SBI related defines and macros to be used by RISC-V kernel,
+ * RISC-V KVM and userspace.
+ *
+ * Copyright (c) 2019 Western Digital Corporation or its affiliates.
+ */
+
+#ifndef __RISCV_SBI_H__
+#define __RISCV_SBI_H__
+
+enum sbi_ext_id {
+	SBI_EXT_0_1_SET_TIMER = 0x0,
+	SBI_EXT_0_1_CONSOLE_PUTCHAR = 0x1,
+	SBI_EXT_0_1_CONSOLE_GETCHAR = 0x2,
+	SBI_EXT_0_1_CLEAR_IPI = 0x3,
+	SBI_EXT_0_1_SEND_IPI = 0x4,
+	SBI_EXT_0_1_REMOTE_FENCE_I = 0x5,
+	SBI_EXT_0_1_REMOTE_SFENCE_VMA = 0x6,
+	SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID = 0x7,
+	SBI_EXT_0_1_SHUTDOWN = 0x8,
+	SBI_EXT_BASE = 0x10,
+};
+
+enum sbi_ext_base_fid {
+	SBI_BASE_GET_SPEC_VERSION = 0,
+	SBI_BASE_GET_IMP_ID,
+	SBI_BASE_GET_IMP_VERSION,
+	SBI_BASE_PROBE_EXT,
+	SBI_BASE_GET_MVENDORID,
+	SBI_BASE_GET_MARCHID,
+	SBI_BASE_GET_MIMPID,
+};
+
+#define SBI_SPEC_VERSION_DEFAULT	0x1
+#define SBI_SPEC_VERSION_MAJOR_OFFSET	24
+#define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
+#define SBI_SPEC_VERSION_MINOR_MASK	0xffffff
+
+/* SBI return error codes */
+#define SBI_SUCCESS		0
+#define SBI_ERR_FAILURE		-1
+#define SBI_ERR_NOT_SUPPORTED	-2
+#define SBI_ERR_INVALID_PARAM   -3
+#define SBI_ERR_DENIED		-4
+#define SBI_ERR_INVALID_ADDRESS -5
+
+#endif
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index 8adaddd..df90c7b 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -1,6 +1,7 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
+#include "kvm/sbi.h"
 #include "kvm/term.h"
 
 #include <asm/ptrace.h>
@@ -110,9 +111,55 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
 	free(vcpu);
 }
 
+static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
+{
+	char ch;
+	bool ret = true;
+	int dfd = kvm_cpu__get_debug_fd();
+
+	switch (vcpu->kvm_run->riscv_sbi.extension_id) {
+	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
+		ch = vcpu->kvm_run->riscv_sbi.args[0];
+		term_putc(&ch, 1, 0);
+		vcpu->kvm_run->riscv_sbi.ret[0] = 0;
+		break;
+	case SBI_EXT_0_1_CONSOLE_GETCHAR:
+		if (term_readable(0))
+			vcpu->kvm_run->riscv_sbi.ret[0] =
+					term_getc(vcpu->kvm, 0);
+		else
+			vcpu->kvm_run->riscv_sbi.ret[0] = SBI_ERR_FAILURE;
+		break;
+	default:
+		dprintf(dfd, "Unhandled SBI call\n");
+		dprintf(dfd, "extension_id=0x%lx function_id=0x%lx\n",
+			vcpu->kvm_run->riscv_sbi.extension_id,
+			vcpu->kvm_run->riscv_sbi.function_id);
+		dprintf(dfd, "args[0]=0x%lx args[1]=0x%lx\n",
+			vcpu->kvm_run->riscv_sbi.args[0],
+			vcpu->kvm_run->riscv_sbi.args[1]);
+		dprintf(dfd, "args[2]=0x%lx args[3]=0x%lx\n",
+			vcpu->kvm_run->riscv_sbi.args[2],
+			vcpu->kvm_run->riscv_sbi.args[3]);
+		dprintf(dfd, "args[4]=0x%lx args[5]=0x%lx\n",
+			vcpu->kvm_run->riscv_sbi.args[4],
+			vcpu->kvm_run->riscv_sbi.args[5]);
+		ret = false;
+		break;
+	};
+
+	return ret;
+}
+
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	switch (vcpu->kvm_run->exit_reason) {
+	case KVM_EXIT_RISCV_SBI:
+		return kvm_cpu_riscv_sbi(vcpu);
+	default:
+		break;
+	};
+
 	return false;
 }
 
-- 
2.25.1


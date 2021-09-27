Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E691A419378
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhI0LpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:45:03 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50214 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbhI0Lop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742987; x=1664278987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lDq+FKo7RmMLlDr7OA4J8sRiNlAUgKGsONyvb6DEe/M=;
  b=gNm3T3tmHG6rFhGmzz7uVHVVbMPn4WO/d9cz7WKkLfbnetO1B7BlrMUt
   BgkIDSA4wiJ8hTPowmODuxpmTTYZXjlp4nltvLLhxTlvvHhbtit4QEzmY
   Ox0zkob4YUnwLzBvR4s7PwdHuc41axWveBpLIeKBG5HgjRU1ug3DJNHWx
   TPtN1oemBSKBKwqrrlCrvlwjmLR3qxazr/4b2pK+AU70cXnZ6xYKODjmg
   pypJigDxXtSb62y+JjeVzstFgUBN+aeOOycUfUtRhQtAlB4/wvAllO/i5
   cqo20ONYtNBndTLP4uH3NaATlFmHvQfKoQAmsdZUWTxwDyj2N1vFo4ka+
   g==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="292706622"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:43:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVtAXAx0pw9oS58treJmGtNboIMbAKKXtoSStmPz5vs6ZIfeSAlaZlzb6XUzGIRHZWignXR3V06tBv7Eck+KXNXN4Hoxu8nQhSzyLshzImM+YT9Q02sRuAdg4QT9qVLq5ovsVKebb5xkv4wQgFE/HuHPFGrPhp97LTCY+Gpk/tltf8/F3G+1ZVTKvAH7l/tLC8qewl1VqMDC0jFzDNiHDBox4LncU1TcLjV3f6Oteqg8T0xuVLoYOeNjPusH0VGS2Lhkqxarw0ygiKDuW1hxAs0wB2wo55J+/JOi+Rf3hbead71GyzeI9awHLwdPCnDfPZJvEjg7ZA1jyBXCFOH0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=KWwW5HU4Gx1zNo1ea7JxJV9ryGKUMtrNiVffsw95moY8LsLLUbAj0GWWnAaHa8HBhm2HAKwtGtE+1bmKdj79mKgNewvxjM1A6DU/kBFs/xPsyAhI7ZG/q/ipHCaD/e4H5DDJ0klwdezMDa3rnWOEE56uptuUGYEnHXkbm8sURKtBYyzBsRWZRTvH3HSfC3KC+1n1thOIXD1DcY56FiZFZPUPHljofuSfTFXkoRDdnlsV8dAjzwzJCTMXr3egq/U4GS0VDpmYESsUF31mqItutU4kdfE7n5BFzaoCLABnj+0ZKfJ8LE0dj28zJSDw5U1TRKz37nB6nk7q+BXoaw/FjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=jjAwsrSZNbNVfXBNTmLmFvGdgKahb2wIDEsT6T4Kd2T5YIsVwORFaikebdkTF8/zMbaERojTfWjhMEjeznLEwqsGw3WiduqRvaiTP7f3ds5iqR6O8hZXOR4zxoWjVwXiBDsLGL3sGUjOH59fxyGXnbK9gKc76vEMZ50ivD+t5Pw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7841.namprd04.prod.outlook.com (2603:10b6:5:358::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 11:43:05 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:43:05 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v9 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Mon, 27 Sep 2021 17:12:26 +0530
Message-Id: <20210927114227.1089403-8-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114227.1089403-1-anup.patel@wdc.com>
References: <20210927114227.1089403-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::14) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Mon, 27 Sep 2021 11:43:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8581a0a7-ebb9-48ef-72c6-08d981abf835
X-MS-TrafficTypeDiagnostic: CO6PR04MB7841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7841C704A4BDEC341AF670048DA79@CO6PR04MB7841.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lu9sfRioGMgdtp21iHTeEl7Rl4XpMMuBufJoBq3PkDglm9I33SdpvPBszjnH5jsK6svXiUUptDqjjs/BohFi+mc0eiZ+ATYRuz+IAPWD9wjYm+GNSdiOSfGvb5SzUFfJuSitd23kpiuFePuyGYx3kIQMI9naCqIzSHJQSaW/dKlC5UdiL887JodzjXlxBRqlC8M9rerrrPYi6rKFnY7RZLn9VFBr4Xp4WU6e4YfoiASmcLtJJQN9dWtGvettwDYmvxGOOs8+cdFQXtBdD2Y9VoQJDM0GTkaxAxiKQRwP/zB8AQwK3wGX5MPa8BdG78vaZRdMPqVt+m67vcDNAnRCOfdMbUj/CFlWjtnofYtMNWEmOsB8EoB1b/LmqbPPDUtkjmPJerXWTD50MQvIsHAlQYIgLJdsU6Fj6dP46owK5sKHQhCxj7pmhCNrueXhJFl8t74OAOuK6HolLzmKaFodzcEJsR5zRVW1lIkCXJdufV4VRx2YkGpZLiGqiUZ/xSk83y9Oy/vtkuQAO7OiElCz23izJdg64F98NHcljZRLEfUrmD4eqW/SVqC5FEXcKZwx4sCex5KpUKjPbGdsrMAHqu9GRT4lRYvGXwi9KJG5RyIkZeC2VwFjXETo44YfqeMXDUWCMq3np4IW9iGlhYWBTKuAvldplaZLj4y5U8nhZUjDw8h8yLSpIRySFvzzTyaz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(5660300002)(1076003)(66556008)(83380400001)(66946007)(66476007)(36756003)(38100700002)(38350700002)(55016002)(86362001)(508600001)(6916009)(44832011)(8886007)(6666004)(2906002)(8676002)(956004)(2616005)(7696005)(8936002)(4326008)(26005)(52116002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4dpngnTH0EEc5dPkPAuNVMwwGckGpqH6Fh7FeDk5EHj+CkJxSiUIthsruuta?=
 =?us-ascii?Q?Sbk8YPPj0eYT/7skQRI0Aan0RAGZfdJomOHgGtpzJRFlsuwasgoDRW7Q9757?=
 =?us-ascii?Q?+JbVgPTrRmY6v6Fz7A98qdbdLBRXPYzg23ziNBo6U3V1v96wVyx7tOPCDNvr?=
 =?us-ascii?Q?2TctrPmeoXQuRW4lIs7tnzZVdsvP8uAzp5m+kZ5xAzDJeiNA9ju7PTBzXt6e?=
 =?us-ascii?Q?AcnsuZc5T6AO83m1IACCFM5jXItnF9OMNRE9Kovd5NVz+0UQkefmm5lluqNz?=
 =?us-ascii?Q?yyqNOkhQT9gkSXnDyfNB2W1apvFwqDM70jdUNjpGkjWL8Ror3fhEozRUpT3x?=
 =?us-ascii?Q?ZbgxyPJsEiTroL2J4oqiPRWNmRs/DM0lpiN0bGN6xdMxPQJK0RdUQv5kx6cq?=
 =?us-ascii?Q?rqCyiq0XJgCVKw4wb8TA3JGrx4ANT/TkstVzOKm8iyDAPBze2czxX9gXnhws?=
 =?us-ascii?Q?DyYTowq9/+ngVHLasjiASgIEOz1INoPzUSRdM+as1oaAKp1dHBFMHwx8ayee?=
 =?us-ascii?Q?vjAt0khw9wUvaMNsxstm/WpASRL64zhUj5JKctCre9ISUU/egbGgGMDTiXIQ?=
 =?us-ascii?Q?oCuXgLkPv4HY3CMVdrso4BRE+tbt4dByfC9Z2gxJNaK2fDHLsBgSDpg1rUuY?=
 =?us-ascii?Q?S9sLmMuKhuNuxFBvu4bbcHwuL/5ccLQNlABk4luEi/7TFGovKfZMpT8CTBu7?=
 =?us-ascii?Q?VsfSs6k6ebP4m0+lvrZeJP90Z9K4xmE4ZtdFGWHah3XYFZZykLDQZ6EC4gfR?=
 =?us-ascii?Q?BBIJDF574h0M8XKZVntepdWkf6cXkCkeVkkIdzl3R7PsrapPDVSKJC+1/jnJ?=
 =?us-ascii?Q?tgknOsP5v1q/JGE0m0AGQxnHCjII+mt8NthZ6zrLCrj9J5oxnmjVyY7LKV+B?=
 =?us-ascii?Q?Y1bZxo3sLw29d8ToISX4bRELmwPu1XKs/1HUrhF6weMsP/WRAAZTlb01xIBs?=
 =?us-ascii?Q?2gB1DtT4r0CJ+gcYztQ8vyAxS/iMfJsoU23EuF7A3aTw2JWKIuvL9a8W+iAT?=
 =?us-ascii?Q?Ppv31nVktq3PAJpd7n8OJUhISG0g/NJrZia4Kexu1QUpOhu5HA49VrS6vSLM?=
 =?us-ascii?Q?A1kQ5mi9uqQVFLc/FUcBbbZ3DiUjxrM6xNh0A5ijvDUMNPFzmRKdO8tKJR1H?=
 =?us-ascii?Q?ClhxREGwZ3UP5Lp2ZsxAvgZEfOwSNiTO84VllZwLLcEoubzmcT0qnBHJHdUe?=
 =?us-ascii?Q?TVp+Qcb3gSsvogOlgTW2D+NjINxwsKl3yBO5ohZWhgjETBVuEiO97BAEH9Fa?=
 =?us-ascii?Q?NxDbbPnX4tfZEneIGeWJwojULaKgyUsPRa9VhVhs32f62/cieDexxKVk5gB+?=
 =?us-ascii?Q?SnUHgRfPsLcjBereVbq8L/jh?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8581a0a7-ebb9-48ef-72c6-08d981abf835
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:43:05.6564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhsoajUkTwDdRcC/dyCSdGRPFkOf2Mq2/jDbLSRzAbgjuY5ExudhZYjtc4M5vwfZ909cuwZCgwc8dkp378HmQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7841
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


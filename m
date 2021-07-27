Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D2E3D6E88
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbhG0F7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:59:21 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33304 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbhG0F7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365552; x=1658901552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lDq+FKo7RmMLlDr7OA4J8sRiNlAUgKGsONyvb6DEe/M=;
  b=mg5/0i1qDE9gtGpnfiDEr0HwjOhOUP5r41N1Rf0zsmGWVy0uYWJ1gtIP
   x28aD5FKo2D7ak/LQdUWL8HoV9QbuIwAZlD6x9ZA/cCRx0YKr1lRxzHMt
   +QQg3Xw/NenZswnLXxy0+iApkzid7+uXkAVLDSQ8F3bjXsy99A5ZHtsvh
   LikKqaRbQf3xPejejSV3DyWKIDyzlwaq+IOxLvv3YR/l+A53ZiA4cfuee
   CsK4OlVfidggcfLvo4aE/AhvNd0pHBmLYBt3qdPREbGVYGkoM65Euxuch
   ijjVXq71iqUoR92DR3N03s5nGcu+CStNoPkwBnNgLYokvsx/BWe8uSJIA
   g==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="180386136"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:59:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdnoOobqZshwFTt61DcQEwcSH1SEovGFWUhceY1U9W72JiFNrmDrT+2mL5xfTL/HMY4K1lF0jElw665tpfb2na+s+XSiL8D/Uj9cSDvZZsPRnSgGBF9EW9g8l3arc6A3Dtt7vMk5QTiIJGWp7npttdWIXa21oVX3sPJqGEjmuoRmPerpBJKg0k/uB04pj/ZM1d9C0j4vT+CymWAYryCSn/gx4O3i0i7/e9uUIoLOXjjaSz5BXmcN+4FzRhokYLFhjbqtdDMgoUM8It6QvaUXOQ661+iy/Oue3lJKfAxrUAwhxlm+T2Q/UcBVLf6wIviMtKw4UwFBqAKX9TrmJUsbBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=T1Ib6/6oIDi/RrfpwKBQmRjwwPZe/7VT8ozXxFzS1qF2KqWs3QpByxdsDoWJ1ATNvBl6FFHhzgEpcCY/315LY/qYp2sgMR8lcFWwE91Sr0g9TzeKvMgbo6z8DKtDJrVDQx7e5yGCWBMaNHZXSFbWZK07A04tn42z+IPM9aWE0XcrQvyDvGNFD5rxsmL0yUWH+J067VUxlUVa8QV4VqzUjBwFAZHNUSYK5cV13jpTpx4UiBZ6ouQgZZutdKfinjXzPwI4OCXbKvFvhkB29pNbd3pyKT/eHnv2UUCA4WjcDDjiPndTYE4jvcK4ujS73JE8JbHEmZFf6hQr7eg7UdNWFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=K7msoc7+w4eOM2wm1/N8N+XYj7x9D1gOChELC49kQMpYMh8ZQIRYssjDtRgq9a/AKWTnycyXFvpt/cT5tn0ifxDTQrh0vqoAyq+oxfGXKnnTTveEn4qoffHfQcvRIhOYKmPkjxvlz471qHuxZ5xSa+T4lQsfmnb7V7COGEGJGy8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7747.namprd04.prod.outlook.com (2603:10b6:5:35b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 05:59:12 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:59:12 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v8 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Tue, 27 Jul 2021 11:28:24 +0530
Message-Id: <20210727055825.2742954-8-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055825.2742954-1-anup.patel@wdc.com>
References: <20210727055825.2742954-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::12) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 05:59:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc43a648-aba4-4041-bfe4-08d950c3a7ed
X-MS-TrafficTypeDiagnostic: CO6PR04MB7747:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7747FAC605BF52E96B71DE468DE99@CO6PR04MB7747.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDPXOcgU6ceDbssW8p0TxJK3gfHQ0k98HNzO1IkyDBRmqKlVDR6omkc7qJPzbUkJTDXivVFr0MMNqn+xQwbVj6GloqxwK532ISSD7kjUEagKAp7fYef4+EccPYMvMk+xxTe4X+eRE+MZs4aV6yUXXHBGeFaC1mCw3Qsr59fddcMvfs4o7VtkYPlMnOaJj60wxKDNHkNcuMgZIUoCiWKIU5FsXu5XL4Dc509v20QBM5wbBEy1j3gv+YQBHsvD6HsTFx+4ImQPA8EDEWoyECyoL0WthhxolAZuS5zxJaVuBKnzLIbBMyJB9h9VKjLJU3klxjQ+70pou4KEtWue8VfZCHmWNhjoKpbPg6TDKA1FyZylqSxrOWctCEitvX+fEvqynCoDPiKF6a+I6EkT36hS1oASLos/6NHed5/vjQx116uWGAPAj0O2hvLvt1naHru4UBqgMG84Nb7OqQQeaS60uQD1SXGWRemJjweZ2fQwcWj7D5IMH3TyQAcTV82/2U/3wrws6VnYSk+RSI2cj6BC1UrfPkCh55tZoxLzjcZyqu1uMGogDuMp8oP9GzhEcCgr/fWGPGzWyCdFop4JETbjctkGldSwGUB+92EcS6Wuh4pGqsxmiAuB2lgFCI3U0MLmQjPdBzgK+9ecTdYg2P8KuuhMO/gAaNP0RljPiF688pfAuHCnl1Sm9hjAjEWrFWRj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(6666004)(86362001)(6916009)(478600001)(2906002)(2616005)(26005)(8936002)(52116002)(1076003)(186003)(44832011)(8676002)(956004)(55016002)(7696005)(54906003)(316002)(66556008)(66946007)(66476007)(8886007)(38100700002)(5660300002)(4326008)(83380400001)(38350700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E6yGvqBc2kJ5/ov8lItGE7GhRaIgU3N1jpC5Nira0XIdJVtdI82E9Sww/FHL?=
 =?us-ascii?Q?cwYWpRTkdGQnoTyLoO9yTIQX/vU7F/NWezYS9M2tvSAf8j3Ya9exDNLCiWJf?=
 =?us-ascii?Q?UT1tJwQ1XKpDfB0coOSb7df5a/oFbZ6vYgM15MfrQ0Q5bxE6sTz5bK1n/uQZ?=
 =?us-ascii?Q?/uDIHAY5hVGH8eESqnlzUVunD7utZ9G00eMOCdM1zkczsgyGgKDOGbK5UBdh?=
 =?us-ascii?Q?ELT8im4v1IfCkEPQndPd+fjhzBS+j/cHz8j1/KRAcI12ot/1i4Ox3iUDUply?=
 =?us-ascii?Q?gefaRl1vqMoOJAteAAv9mFafaFg+V28ANN9VXS22SM5ZelBOgmhP4iU9R76T?=
 =?us-ascii?Q?c0WSVag1iSs3+S1mwkA59LwosnjGiNVZuxlgaQPw1GlPE1RXTns9c9zYc6Av?=
 =?us-ascii?Q?6/WrWIpqDdWCo4yxa0Qwr5TuMqR4CYd6snuBB1lKiOa/qNgTbNI9VIy2ei7b?=
 =?us-ascii?Q?H6GO04eCgISgjHhxnBulBVMZ23jzucveEUY+xtUHHnmaDZAUIuHF2IIWjNKZ?=
 =?us-ascii?Q?owazBs7f7vEqnH0HgyPNx3bsWa7x8bV/5pqOiL1IVUztWKTZogwaqW/sxn/V?=
 =?us-ascii?Q?XyuUAX4UDN75Szr4PMtTmh2WsjhS8z3RE/ODnvLVB4ufqdfbx1DzO7Pdb6fE?=
 =?us-ascii?Q?0iTxFOzccT35LBHaKgWxQ5mB1FTXYYVxSOsm8FK7YQJ586JZe9/u/lofXE6a?=
 =?us-ascii?Q?Z/pmk+XWJVvOoQH6iUHgEEuYS7gmbs3+DOc/5Zj74LqOUMWltYSvcFyzYJ0C?=
 =?us-ascii?Q?jHSo2A4KfXeykzaeSkWvnLyUIQOIv0SteC80+iyRA1QYanaUB9VKR05HQPr5?=
 =?us-ascii?Q?KNpyboNTWk6Qa+nw/bu+WLrgK8IrMxGdVhl3hvtxYG6KgcEEAk7dXVP5R8rw?=
 =?us-ascii?Q?HyIZfIZC8h2ytNt1tpWD/kjY36IWVjW9BwVRV/gFLvX8mfMoCFiUQuSuGtu5?=
 =?us-ascii?Q?w/oBHuZCb7WLfrObaOwFM6OSRJzdiC58UOvC39OZ8O9bqu6dMqU5HO+MX43g?=
 =?us-ascii?Q?59fJNAe6/wihmiKGW5Uu2+poe8aPEr2pyaZfdEYI4PuIQqOuyc04G/1d1KuX?=
 =?us-ascii?Q?QE7ETyXWi9al+en4KCPpUfZjEAL56zHMCoiyr/QGVbr/S8Hm4QJNP7NwmS6K?=
 =?us-ascii?Q?Z0X/+x2jl0fkhlCvZgQ/xhDrftKfzgenw78eZEnsVsZGR0rH+AGX8gtfHwaJ?=
 =?us-ascii?Q?Y3XewPLQBTry4+JMTHlgW5GBVOgIHB8JPGiPhkuX5LefaIgdv5AceLHsULvD?=
 =?us-ascii?Q?Agq9T9se1J+LcbiaZyHIJw3Pha2RpGTcVqu3I7DexvDYDg/WCmYzYA9T3GA0?=
 =?us-ascii?Q?k2DlDu4vh9P5BYPdFYwHQ8s0?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc43a648-aba4-4041-bfe4-08d950c3a7ed
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:59:11.9003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YR4HaLPSOqlVT36qNcpSWBYxBR5a9VbUItUQNtByIgRTmH7opshY2YCMR1hEwsP2VSbAj2TDjiD0dXMk5SAEMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7747
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


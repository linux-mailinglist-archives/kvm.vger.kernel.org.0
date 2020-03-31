Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4995519947B
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbgCaK51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 06:57:27 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:9767 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730681AbgCaK50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585652245; x=1617188245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=tlTaUaBFftNIiIPrLBjJUvDbsS0yyuD2pbx3PW1cJic=;
  b=huK//lvH1DXJ5f8BGcZqEo5x00jlJZ4dFqGErUME4eLguHsqqwe8MVhu
   pWlknvLV6wZ3sBubjmswEpg4a/Po78ORWDfO3FkzSo9aihQskVP90D+Km
   1H/8DNeEEWS+FNR497PmwGOz2Vtjqkscv+p/iuP4R6DeMSnsM9UZZak2q
   UsI9/hbLA8SJBpW8rbA9cDzMRZM6LeTsx19um+lsFHMOwyb7ybG/V1+l5
   RrcjgY/QUOv3C0TQOVrOkFh/AcLHaFAXztsN2m/bHiVqIgjtVFNn3T/76
   FLZrJflMr3x6Ty1DZFVGRwaOmfb5y0Sk2OPdffHms7msUJ48OJzWQfXbt
   A==;
IronPort-SDR: kKqqqI/eSdVP02EJ9ZzRn1EMqZdg4B/f6TPaFpu87D7eDC7+nRSX4uHh15fJ4BXH/AfBxHpWaY
 F+CGli8ADG3h5J60v2GhWie6Y9ySbvSh+oY6O0g1RBKRkgjoSYs77m9P35rAQZMS+NtUDIK0MC
 UqDErIJM1ldQ2F0PboM/Ga7zNQZJpJfH8TPe0NYbnf4HE5/k/qDQbyhuNAkRSC95h6uMcNrObj
 0rVmmcnKFXC0ZZ8IB7rzvv6S6bbqngno9pVPbkNYvaxNRkl5qaujEuRdMTxS8OlD+H++12MjQi
 mFI=
X-IronPort-AV: E=Sophos;i="5.72,327,1580745600"; 
   d="scan'208";a="134016808"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2020 18:57:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auAsltT4llIq/KMILKgS2Cq82rtOCnTLsNSBSoHvWyDn5SNUwfwp8A0orRe87cgMx0LbQSysAIO7r2Z5XW56E9vGpUN5O6pYg1sXHaFyx1a4kPwEBcG8mi74f+OWhKh9OfyaD2YBeWY3NkKcpnBHm4kWj53bKHIVz8XlrcOaibTOEH5DwIvYoExBWsdeuH7ej+fGWakwYFe89JwHIQ2oXAniDDpj88KYdxHzu8DvdEqXVexa6cX3r2y1fv0MKPmEEs8/BSTrcgIEoydO8RbSNJeNZ5NEx0vA5nz9IsYcifxmuu6q64e4eNImPvuuilo+PesQFjzce+VOg0dof0c8sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frDm+5qpCZq70lVB+KoEVZ6YE1uCD3Fc/IwZTOZ68+8=;
 b=NVPNwQDKaAfyInOojpe9FsWKruanJhMIYHjbsDNy9QfEYdHHeY9rMftiEMJumduM8rMnOQZvPPrjmaZj4Q7FyyDxMyVOoRw9Mhzq6jVkkY4kU8N7uA2Gg94JcERfWykjz0H4j+xRxRDggV7Md+CKHoTwCYqbyDo9/CfRdHsQg8NTLs8GeXNH7NzrPZI3DQMxrT1VJuQvhAkjfCGoyQ4La6iH5tVe5c3NY2zD4Le76kq/jle3R8CwY4K/itkPWeVQgjOQCUihHj6AHlN5Wc+LqL05kK/QxTXEZpnXzmd+2sXY9K1lxb+3N37IIcWbijOchZaaMa3A4doTZivu16QJ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frDm+5qpCZq70lVB+KoEVZ6YE1uCD3Fc/IwZTOZ68+8=;
 b=k3oVvHqftCqG7S5zWA88NQJ9l0GqwEkh3EWUwT68wCR6jyz89OgsN4OgxIqDLlDLUkolml6Fp6T7mS67DCVqHYw2x1gOUswj917wqSzLASs3lhbAb92+BDjj6aNyHDL+JpD3zPDk9beKS2ZcOnJDbTQgD2zNnzk/PwLTnGE/5Kc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB5981.namprd04.prod.outlook.com (2603:10b6:208:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 10:57:24 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 10:57:24 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v3 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Tue, 31 Mar 2020 16:23:32 +0530
Message-Id: <20200331105333.52296-8-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331105333.52296-1-anup.patel@wdc.com>
References: <20200331105333.52296-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.117) by BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 10:57:14 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [49.207.59.117]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 81f36790-3866-4c96-1c7a-08d7d562471e
X-MS-TrafficTypeDiagnostic: MN2PR04MB5981:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB5981C06C6C3EC0C1417E12818DC80@MN2PR04MB5981.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6061.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(7696005)(44832011)(2616005)(36756003)(16526019)(956004)(26005)(8676002)(5660300002)(55016002)(52116002)(186003)(478600001)(6916009)(81156014)(54906003)(8886007)(55236004)(2906002)(86362001)(81166006)(8936002)(1006002)(316002)(66556008)(6666004)(66476007)(66946007)(1076003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajBWFxtk2H+SQY9ZuXHgl3L3m4tGSAH2Q0nHkRfavhm+6IW5VpVAzz/f5FdVxUl+JZr0VzHBfodCbxsg8h6TU1evJyLMxCHJ8fOt+JpienlPumQdXvYTbte62CLylCV6e+VQ1D3Nk3opSmfmjj8AH9b6IrIeATavSWI1pe9EZ4zipPiuHqOvQJVRbJ9FZ/28AyIIArd0C13dtDj6H5OZDyzouWBzDVl3qkjNd3+Z5Dv2U7tEeDbZmspOpL9rzKLBcSxhR1i70mU7DqJuDX4BolplGTY7MQmInB8Zr9ogLcP8bZYt3qzH1X16pniJX/ecLWB+vwhEyE19jjr7rf2TnLdJAmiqMcwtIwxoddi5vPRM+o5dvJFbtsJ/6P1PrQ1wgEBqmJqA7zDXeclz8O0+feaLQHZLjfJ0hTcdQ6VG9ZsM2mcOJW/6T7NtLR9c67iB
X-MS-Exchange-AntiSpam-MessageData: 3r0FyWRR/u1r9nfixxrMgDcAOtPlTzdgb1/9+ju5bPTGeL+gQieYIjDIbVPMn5DjNQUDAietf2/d31w8kzKlwREqZPKh3jkyorIqisCtaJTzIpSeAeqWkwZPi3uGoDyEvn6L7rhW2K8FZfjardTnzA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f36790-3866-4c96-1c7a-08d7d562471e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 10:57:23.9712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RePWx4VezAk7t88k171C0Ir5x8cVpUKM7wfSd/9VvzcsotMJhBR5Xsng6i7RAfgyRH+k9/YSNfvBsD4Xjn/38w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5981
Sender: kvm-owner@vger.kernel.org
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
index b0cbaeb..3838d6e 100644
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
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E0321B1E4
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 11:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgGJJBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 05:01:36 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30305 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgGJJBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 05:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594371695; x=1625907695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lDq+FKo7RmMLlDr7OA4J8sRiNlAUgKGsONyvb6DEe/M=;
  b=Ly/g6qEsJJ8e0BcMHjFUH/W/cIv4Xi3tAmlKgnKMaui/RsNCXt0eC7CE
   dalm3mB0xv5erKInAhxCI98gjxJimnfkU6C4ka1XE8j2sWBnMM/KzE5ft
   P9wjGgGpn7PvEHda+wHc+mwvDSbryADsvpmpFdY0rCXybcu5ydf5XKrcT
   sp06WEAtsDUEVxUVX+izOw43eEzcRdKmoQ/9i6ZmwBOOt3vOKd6vXhrvV
   3+vKYHzInnpn0OpArX+HyHfZVKtA8osIZdMsYLDg4U8jl4pF+MiBKoIko
   gOp23Oy0TXUGGJLq+kJfnzfDUjfIf9XuRZavE+oyuAwhgJa4OKVCPnEJv
   g==;
IronPort-SDR: QtCVdxqHV3uGoAkhoEvuSj6tpzW5UmN86ey6q8Gjvv+M+tY1YGDD1vYlRC9HFUvFBBh/u13DgV
 WtdDYKVJtzcAEg3ywaEroUhoxw8u4SE5zC3xtkWoYGFUH80gcu6rQefP+nW9kYV4YIsxyC+kbo
 60FVN3R7d2DcVf/EDO2GuKhBuDsG53tbfU9P9HxiC0D8m7+Ub4n4Ao19tkyLfkpX4CNbSb/TvD
 lV7FNOaUXu+YSPxkV+6CpXjEW9dXnc28H6iv6RbRCHHwV8fzQyJ2ns1w4JF6NSk3dOHHKmwXk9
 2Tk=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="251358899"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 17:01:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khzNEDKculPgREbGKLV2/PH4UVM0hnUqLTc9NzB5CPwSMWQTKAwn3miq10ZEC62wAyhGje2/AI6Qz4dtA4aOLGG6UMmAush85Z+pQ6C6O6zbBazxeRJax0/Z7SR7wAbwaHF98i7L5JDocdfspbqKFje3A2Nfcs91OFcYJ6DB7cfPCWWMmuWFOPB66ZeQ6CO9cj2eWp8+spcmumRY9pZLZa+grO9vvHKFCxHIPiKOhGJZ/Ggcd6e+D83ECl6nl9of44PP7/jLKLRUH+6sbx0gAPC/Q8KKqoss12iQhzVVeXZTkD2SN5Fd5I9hGHBq5Wg7Ir3nzRhC/UylMx0h7O2wKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=JAqUfsTnRNL5BGiAIv/RMbILUzb1v3di6H76Q0VkKwo44aGQAP75/fqGKqdSt+H26p2V2YCt4YC2JSxcNjUO0zLrkbWtykBlaabd2IX7yTOz4PFlMkiJ/di88Zbo3H54tNeSD5rA5Ahl9W0lhXAuxotiRo5dPRi0yjqQeYni2/9w+oLx9JRU0cdaRj0UgU78Xft18TEQu7fhIqzLcKeDjh5p/Iuk0uHqTJzBLz47HprZtSM5TXeFmXz1R69mqq7S2U1LolGf2ppfdzS8zBqJoGACmv+mJr55WK4AIwOEi/02PJcgBzJL135GCWjM1AAQ1lMMy1LyRW2FnyhPNpOL3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=PSv/4vwR1l1ERlFrP1nY5nuVzp80ewInNNSkmgAeH4PaB0o6Mt0G9ipEhKdU+sGkSZ9nBJ9LfsqaWEODXex2r937DAvGr7afeQ4ub9hZ1/X5ZDuS6l7vi1/VQmDYKV9NqAqCDkWDg2/JHt8l9fsYFZYqln6fwzGm+yUwv3NHd8M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0346.namprd04.prod.outlook.com (2603:10b6:3:6f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 09:01:34 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 09:01:34 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v4 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Fri, 10 Jul 2020 14:30:34 +0530
Message-Id: <20200710090035.123941-8-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710090035.123941-1-anup.patel@wdc.com>
References: <20200710090035.123941-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 09:01:31 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0e69e39-6944-402e-2221-08d824afd833
X-MS-TrafficTypeDiagnostic: DM5PR04MB0346:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB03466EBBC05EE20F2D3CE4D78D650@DM5PR04MB0346.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n3o9cLuG0OY8+al7s7plwVBwaArXfpSdczlxd0/UYCtzlV11/DyUlPJYspCicZSGocUyt1uYwccXlg5HEDVkj2cQC0uekTnrYg5KGR3PXLF5tMwDdg3m4KThr32MnkufoIZNG4mRlIr8CwPDVPlN9hPekMbq1EmYePlOJVx2YaqqZ1Et6yFYBAQWo6U/TmEoZeSeQNMmUiuA3CDYvzsIBK19ILYzWpb/JTeiIffld1p//fxBJ4hlZ4UZSbA32Uw/54Cq+/IB3ItxhCri+ViKsfXHFwVjOHzukb1p/fh6Bnss4kCVruzR9ItINTxMZyW3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(66476007)(186003)(66556008)(16526019)(52116002)(8886007)(1076003)(6916009)(86362001)(7696005)(36756003)(26005)(66946007)(4326008)(5660300002)(8936002)(956004)(2906002)(2616005)(83380400001)(55016002)(478600001)(316002)(44832011)(8676002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qQfC+x/v4OIyD/kngUx1+KepocigmoNK7C3KguEah3IqbGmb/Y+uxV7bDyYtDkknPXYa2hCgmCc2HnbPZ9bYSzUjwfcr3Bjh+uTs2xJ12Sdqx+buqMewt0quurJ+OMg2th6zR9XIQPSDTI49kh071eODwFu3exRhhxcKG8ejBX70S4oZ+vnkdj4KdcaXfXAs/9TjKeR/DhRB2SNCHnIkPUnVtso/wXvRnq8qreOpc/mmck3qtx7Vv701U3TpP41bQdG3OwkUedNs6yNYl4puu3vKzYmpsJ4CwU/HYu1DmxYPz0so1nMUwNJ/z2zTXap6h7y21ESR9r+vX0A0wBGS7/X/3Uc9d/3oyB/HRI6oX4po9goYtrZC8nSkvxF0G+df5gUXduReQwWfiqRmFevXA+8CHzHIqU1xItI+UdBmv4VLAfqrkl/GsvLKE9uLpOO4WTcgouo/St4t4RFxspuOVRmWMFZpyX1VF2a9R1+UJcc=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e69e39-6944-402e-2221-08d824afd833
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 09:01:33.9130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BvUFBKlc7T8mV0SckAnNl4BuLmRahUStKZ4pn6GNhiwVgaDfpayv6VD2kUJ5+eT/u9qlmkA4vHJVXoRYO/LlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0346
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


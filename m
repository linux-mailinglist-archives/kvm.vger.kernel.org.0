Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43882AB749
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgKILiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:38:01 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28190 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbgKILiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:38:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921880; x=1636457880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lDq+FKo7RmMLlDr7OA4J8sRiNlAUgKGsONyvb6DEe/M=;
  b=DO78LhUkjh8jIAzJGWQENNk8pXX7JYaiPTtKWi0dxcKVDPtmRZJ9oU6M
   aZnW41bZmUzfaokPVFB/UlwDeM2h651MwQGgl9XTfN8IpN/p+ujM8bUii
   0s+eRiUKwfGV9iDCCdzjgMMscjaLuI8ogTB+fjZE1/zNDsZJQEwDen3fS
   KaD3hINPsWIeqJXMUpLP463WC0t3zQJA+wMGJTUxOFWIs9wecuFFidl9K
   tF+ytWbjr5ej06T0zrg1KSAMchY2KWEDcfZOPuYQuGyaXGOPjccxIUXVO
   QR+F+iWWPncQH/wZVdW0aE7JegIdPOSMb5hRAt9NXn1BpfbnPgK+sYSt/
   g==;
IronPort-SDR: 12ylTgOEkeexxzE02yus3jRJ2c+XmpcGdIhr4OZmDWaznOZrwRCJFJvBs19bmH61xNiy6vMvxy
 NiFwOlQgknWeoFvmpR01/HpjRfgpVk+vFNTVtwrh0gyF4PI7lWOUdajZEN/+ZJSLNm30c1M9f1
 ebE5bSN+9cC8KjwLBq0IF4r1mcjPamlIBJ17CXTVrs1E56W6fiIeywM138p6pZnYPmgZWoL6Rr
 /xC65815lI37g68KsdEo3Ln6rECJP8LOLamhSLsa0N26ws8XiYSYLhglkOnRqsiWAaQttKipJ+
 q1A=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="153383071"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:37:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTXvnXR1J6YILVwzVE0d804WeobCs36drpFMIhpJxOrrmNK3hG2XyXnu5BhLJX/c5LUGJ03XwyinlEAt2V+yOdaN0wAzi3Y2uM6r4l3TlKtPDGQeZ3QwEIkmfq7F87z7Bx17tF3DBAqKBqSMpyInMZZApIoTuK2m3Yo3wDeunnFUyJ9VN8fusvh06cSS4PCu85rj3nk50p4olMm5C5Tp3iGAeB4UvMWcHP7DrU6NNO7Dok3TpguN2WgpiH/wpNWi1ezvCJSW33sxM5weRwpp1GH69rhb8ZwdkLIWZ6FptarzPNIBJFZvPTdk8kH1lpuDbV1jL8mAGmw14j4ES8OwqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=QlVjgY8IVD1qD6EZRkdnx93pGLjUQhDCLBR2egCMrBWAqvHw7whM8WLvF0uBhUgfICO6iJvO+XH1Q3AIJWwe9GBLblwMPh0zKBiLFobdBIv+lAt3D3eue/rTGbvOJznPxahONbJ5C612JNGzr8hYNvVeWreSkjhWa5Rc8u897h2r5vjVVKQY1Sfe0jDUpqm3/xCj3DFEex9ERB2kMWDej9DCIvMCK/L9ZyXwS7l0V4sQ44rF7wx8K8zf1mvyKSsVXsqnUAG/nOq4ZIPOCxQJEKZnBuImxTy5fa6iDvnIN7rl4zZn9FJo6izjbLGfnkcrE2vgLNxaYA5GNukoyxAxng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=GzVWvlLczVssmoO4sUWMwZX6y1kKTMS7Ul/iLA0vrryiJ3WmKs9ZX44Gbq9nVt6vs1P4vMzL4EogOLJ+5d3bIaOjz1vKa2b458FsV717cddlIUKgX7O0YnEn87Bxrn1SYxy/a141MCWoM5EP9cY8kFVk5sKfRJKSCcXU/QH/vfQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5961.namprd04.prod.outlook.com (2603:10b6:5:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:37:58 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:37:58 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v5 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Mon,  9 Nov 2020 17:06:54 +0530
Message-Id: <20201109113655.3733700-8-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113655.3733700-1-anup.patel@wdc.com>
References: <20201109113655.3733700-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34)
 To DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:37:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 11c109d6-92f0-45d2-f975-08d884a3e7eb
X-MS-TrafficTypeDiagnostic: DM6PR04MB5961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5961C263191B96FDAF46E5048DEA0@DM6PR04MB5961.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/1D3IZmNkaM8oDVSy/Yib53hbp2HbQTuPqhXBapMqXYmsw0Rb7YGLBeK02Y5/jA05d2lLWFjvPIZnyVZK7PiSLm9SwLVYgRyVqijYHGg68bhpPjDVjV6IWg9ihG7yioPrLGilr3qvPPM3+iTSlPVR61EjUYAiNHH5OIBDgPL7aeuixwxNJYT4cHxlyx+tWj7eQXxSc6CsgqSsTVFtRkIMKgKkz9pXxbGUak8RUerm1xrvdHyH0plok5DF44GstPFqdQcZuoN/U2rfeojmv1tdp3KO65oO94KtedgFmNSEzL+CKJa+qgcldDsdyWE4ZO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(8936002)(8676002)(86362001)(956004)(2616005)(44832011)(55016002)(66946007)(2906002)(83380400001)(4326008)(66556008)(478600001)(316002)(7696005)(6916009)(66476007)(1076003)(5660300002)(26005)(16526019)(186003)(36756003)(52116002)(8886007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vG7I4jcyg0BvC/3kLd++a2SDbnTqlFECl85e0MCdrtBesePpmrP4eiCPiTS1dtcQR59dsvYusFdT9biMclrscI/6GixSCo+Zv0FI/KqKQMzEVwKqOAIkfWtuA90bx6nQCiv7iCLl1PSmsjp74aRUCjFc8+W4pTe2xikXmSOvSDK4b+21ixVvH39mzEXAqyU5aQk3oXCQ+VtOMEM7TvpFY/r09WfwQkjejlGXgyxQ3+ZqGiV8KNUabMtK0qCOczeJLu6QAWmsMD2rDsZjJ8/l9xsOaTc/wR6+rsfF/ic+LDBKE3DzvRThANq9qs05maIgjJj/yzcMrBb7FXdMpMnn7ZOoobWViY2PxeVAC4Th/zb9hpeFUqrXqV5uAUTRoxX4wrGIUxFaSBkuNkvps/QDU+LEqKMKay3tLOx3hzjrTjT8JkdAfor7ulHin6qcq/vup+dMapDq9o6ewxlJGzPDHWo6DFkSfCj6rVDIu3V5VDSVKDB5joNA7KehJn3YvcnTZeDdktwBh8ebFvl03W0oT7cw1mNc/h/u6CU7CMo5/WMNk98ecnS2PyOdXX4W4LOkHq0Z1KQpGAnp8EPoO+I0wGYj3kHazfhKTIizo1gxLMOy90Q3VSg03g0bvXtFPl6bhyF6BzofBGHaRgRi3nuGiQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c109d6-92f0-45d2-f975-08d884a3e7eb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:37:58.0221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FpSD2VulN0WHuqLPNBM/Tt8dWLdhNMng+sXtzY8GpWy24JvML/CPm8iLOBCZNHE0jlcAseUyJcv0/HMm2+AK5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5961
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


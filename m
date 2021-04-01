Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927E5351B5F
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbhDASH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:58 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24491 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238211AbhDASFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300344; x=1648836344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lDq+FKo7RmMLlDr7OA4J8sRiNlAUgKGsONyvb6DEe/M=;
  b=X5196MyP9pKqajQ1p/NDsz6PORFUVtXn5mmDoWlFASAXqp03kEWIATNh
   tfmxFEVaBNKdIItrVPpkvO//A2QfwNTF7CHXxPurupDq9y5YwQopoJPq3
   sKXjiDt6p5XSrS8oJIYfIS4cHE7KKXAlgcRHvGYCak+Yu8at5DAjFAkdW
   pyklcPHQgPHxhr67IUJyF5osikkSA36IgwVA67D++BccJXK8DEIRpn8/b
   gezzYLawccCAUD+tNzehAcGO17LIGkR1N5iKaZ3ms9b9u+yItmJA+Ez3g
   pXGTzNq4k+EzqzWFlKLX23zJQf3qrE3OKw26LxmY0emqVNgby9HxZXYGH
   g==;
IronPort-SDR: lzYaRDg2QnpYD02yDR8BU2Tii1YVaQhQg7L29w6hxEWfF1Ph7FhVM6Z4XTj9HKfEV6FOWz3ePe
 zOq8InA6nZafDI5SBIr28vCF/+AWJuc+cxH2LOlECJqDJvowkwxCWASnK+t5v9ZRJsII2uxTEg
 FJAhvPRyIDLA9rHvmDpFaVfPXt3AJyY9hfgD3I4N/tRxSralAekDFZyHnGn6bl4/YmWoH4qZk6
 06TNb58KuSyrI7wH4zlsnaCaXklNYw+Twwb/N8pbaO0iF22jzi7PIckXICzAWkFlMZH04CKB9f
 vP8=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168042000"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:42:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6MTv+aYmwsV0esisDrkLWo3MvITnQ9O2psl8aZGORA3szxzUkU9tiOp/Yi7bEIayjxAapblfszp5IJa1N3q2TedduMqohSUMuPTC3YuEbsXYRDQTpuLV/J63e6e2WsEWaGU0rtwQsPKgVmwZJNlFD+6ReEU/QRb9/DhrSNH1ZrLHitznZMu3YTeSZVKVNBgjNo67vnjin7X+KuUtZrtpID6Mi+/0xBa2v9SxCpE93SF8KuLjPmWeNhJYSzNeneQjqUieEJtoozPz0uP8eb6tHsOIBL2XTMd2X6q2MLAdNyNiyrjFdXrEqosOlMiAL+ZfvNoMI6OMy94j3ntNDLNbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=hL94kbnYqctkfyYlbj21Yq9frwLXdp5+rtZ7twxYRcuxWzj0HjpS18TQcMWYGLVvdDr4IZrK/Fwbt5+dNCOezLemoEj8AIs77Tcc3+jv4gghhyQWcZ7K71uFDdsh1cfPgEf+12CWC2m2vUX/EQkm8cpJ29mCy96iUJKGZYIL1tz/WFchTgVwAnQydRaahfsQkoN9Rq071HkSwqCLnll1g0DzHh4x5x+oayJNgg9gwSL7izNRD26WHdn+vgMhnX0+ENm0jz6E53U2TDb7FX5+brPBHL4tyyCflOx3kGlvK6xd4rOk8qKCYwVch6lEJDjjuKBXIn2WfP3LWP+RspUMvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=dDvcPgy8NMdnwQMf/KlPTU4zKIrsy9MO/9VYiU+JKJGr8thyJIhuNTW3VE3+YB50mFbPah6/vBWuIVozUwCtoQLOjX3MfzkgH1qObyteAlRACPOkA1aY/yqP2/xG97XT10sFccKFrI07t4dHTjZirYMvCbrZISRvtHlSf7xFBWA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6493.namprd04.prod.outlook.com (2603:10b6:5:1bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 1 Apr
 2021 13:42:41 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:42:41 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v7 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Thu,  1 Apr 2021 19:10:55 +0530
Message-Id: <20210401134056.384038-8-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.112.210) by MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:42:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f27f322-ed22-4359-7a37-08d8f5140551
X-MS-TrafficTypeDiagnostic: DM6PR04MB6493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB6493AF3CA37AAB1B976920E98D7B9@DM6PR04MB6493.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XOBry52Pc+0S8g4XaAZtkMI83e1vle0NfanNhjj7vk4573Lr/CN3+rFkW8vDjRUumSu1uJseOELFDXWWsn9YihuC5J8lEhuhfU1qgNvH9nO2fPIO9SOYIulqI6t1ElF8v7lIL7Yso7fduMIa7e+gJcg+DeeXOxxXi+A7lKjfuIQgKI8Kp1TX+rUjs/uyGY2+eEwTXToBOA1/ztCnQx/t3fvLBr2R5Niv4G3BXz8382YfNWz4gbdwBbijE0hE6UToz3QPxF8xpGOzqB3bKOT8izJOXllmppr/LvCrPtfitCZLiajF0BBnUBA93+ns235hTUn0JAZkH0qtGoOK1DslZiVGAkPO+lSGPVo4Zuda1sCEKA+/aUy7HpQ2YQ+0AUMAiAbrRLd3dIqvJLSiSA+KmaDey2gdMVW74zLIDwJdBU1FXSnXhkTDPwjS3RKoW7U++c5g+NXmtononNpfOXMsqlbkMYBYw1hFJRAlXIrD2JiKCbci8OEjaleEMDnxXY9sl35Q6h21qc4vSyFEOhvK/UdOJyvqjsftwMLn5gqtVFHN4e9NB90aOuCpabYBVgjCEu73jnzKMuZ3suXY6aXOYvVwb0q5pKNiXJn5ZzBTmZHC2xVI3KJBX9SKAiqZgIkPsg+aDUMnkHWqiabzmAj15A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(478600001)(26005)(66476007)(186003)(16526019)(8886007)(6916009)(66556008)(8936002)(316002)(66946007)(8676002)(5660300002)(38100700001)(52116002)(7696005)(44832011)(956004)(83380400001)(2906002)(6666004)(54906003)(86362001)(55016002)(2616005)(4326008)(1076003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d7gA83IGEQQT4I6gsZ7qc0AiIHcySASioIYiriJ1Pvn9UHjN3PgT0Dq0RIoN?=
 =?us-ascii?Q?Quvjyg5DQoRpYf8Gq1OF9xCAONrcDgp/WpUuqEQl+a4ye48LqQAaI46hnKsa?=
 =?us-ascii?Q?jt3frY7+0w1D0Cp4TS3RwlSZuW+pRDjRzBl4igEhGPsy7M/QcX+uaonxbsV6?=
 =?us-ascii?Q?wYgD2t6hk8eU15vp9/mEv90Z632twuA6NMzhPwWmCSC1acbsqyk2FGRGm+42?=
 =?us-ascii?Q?W7qU/GIlZFfp1tQFBX/f/WVF5f+gM7R0Ckov+SXezLX6T5NRCFwN1vCjdCsC?=
 =?us-ascii?Q?QNk0O//Oquz/dhbexhZKE5EqGC5tRhY7C8FhtUii6RNdqnbcjxkgkoxJFG1N?=
 =?us-ascii?Q?xtid4RDY3ktKCyMSw3UYPHlNuATcI6KgFEOFASG9EXKJkZH53fH9Gw4rIp1u?=
 =?us-ascii?Q?7BHgBEFFvqYeJAXy9tAh5aEvJTOfCqN2z0kS01tqwzBASt+KXwdCaw6d3hEh?=
 =?us-ascii?Q?Ya7wfqj93KGyalp1+S7YKp1PO4B1aeZ1SB82jLLXzIEXaFMHofEWwxPo+mbA?=
 =?us-ascii?Q?NjHjKMwBTi4/6rgujnVOvAKDjDtMUv6egRIebzWcoE9zg3/mgOPuPRRUGirS?=
 =?us-ascii?Q?GjgOEtKmaaELCV3Ar7glbdjEKZDdgxwGEKnwsrn/jYKI74NpeUu8MqPexE+G?=
 =?us-ascii?Q?6/dv4GQDbjIn+IWRuPS+6+4XsHE6y3Bzh+qWKzfP91Y8qnAjARs3mr7XYlw5?=
 =?us-ascii?Q?8sEI7RDFcUArH3STtc59MvCiAK8gVDzBT3bKlszjS3xItSDO9gFuYO2SI4na?=
 =?us-ascii?Q?76t2UckOLyvcApxYQptEjQpfYDHmohN0c6Xmw1We+dTXu3vn2FC9aEV572B3?=
 =?us-ascii?Q?p7U/L6Ml4ZS5TMl/NpW9pLAVeNy+L14XQYL9bM09Qnxj8qYa3MOWlBDzw7XD?=
 =?us-ascii?Q?aI5DmZkv6z518z+h1zX5zU89if6Xx3dNxsHwJW+N4kav9jHxydvvrsFpe5QB?=
 =?us-ascii?Q?tcB5JgCNjA9ba1fHKn1LJqURy6DQJ7hW/xr0DKWU+uuNPmUMwrPamI8NPHs1?=
 =?us-ascii?Q?c89zuZjF1ZHJnBu0uQIG9T3hLGpFR2/nbqTBKCe3isS8NEuvg0QsFEJ8HsVj?=
 =?us-ascii?Q?nEGbrbi/ln91wV2vygpxxxI2L+SeR1wPHaOlVen82YCFHCWzrQaiFWnHg+i+?=
 =?us-ascii?Q?RY9nQNbzg1RIYwJRB4pGom9i0FVW+NFrpboJrWQ3XYWZXi/Yskn59+ICo8Ok?=
 =?us-ascii?Q?S+ZBuH3vpCbmerP7jXf83Sca34dvjCoCyznWkppZ6STfbBjdJoDx+B+QbQ5C?=
 =?us-ascii?Q?BMokWECxGu09oLTGZiTL8yRr+9qIa5ntDEpXhWL6AbB2PaBKzxTRvKHpXOGS?=
 =?us-ascii?Q?IC2Pp7RxPeMS4cYTvvpshlv0?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f27f322-ed22-4359-7a37-08d8f5140551
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:42:41.3390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSVbEvpTUI/M4lPQEEBQGv0cO6rf80Pe5+bE2eg3wR5MTIt0MBF+kpD+bXyzjS4dZz2Ew7LmM3zy1u35sXA30A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6493
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


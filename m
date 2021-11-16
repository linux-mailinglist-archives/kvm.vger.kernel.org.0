Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF71452993
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhKPF1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:27:10 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25814 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbhKPFZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637040162; x=1668576162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lDq+FKo7RmMLlDr7OA4J8sRiNlAUgKGsONyvb6DEe/M=;
  b=a9ysgpO/uFTPUTvjjILbMJ3mOIEwylA6DfF6r3xr+tvqug30o/dU6fDh
   Xi9CSijCPAUzxj3IXI1gS5eqpHD9lzRGZxrThvSH1nacdcnJtGs4kwqrU
   KPBqgc9QKkJszmZbIF2GuxMN2c4y4nNOT6pgUZJdmsRsTuG82zKovbUJr
   inRfSEQwva7hgG25/hr3i441wGR5sim0dYWqNJNn8uhO10jgpFMH+dJZ1
   OC6xP9iFWHYhMil9FvH7q+zQBn2UC+HXCVfCWMl6syvFp99ojmbC+rLef
   K++VSTJZURiVGbgQqgmcfkU0amXk4K/9DRg6Qlihj3jJ1/Vk5yQ8rHaYs
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="184696445"
Received: from mail-bn1nam07lp2044.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.44])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 13:22:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WY3Bc5LeH6e9am1yewYd/HYtt/ccccBaCMeXRNIA3+M/nXH3iFR12X9Bcl8emPfCb0614IlO/oBSkQm/nRxsAKkVKO1foTQoe/0pulyq2jDaqDAWzvcnEdlU0mWLnCfJ+/9MNl1nKkVxybhony066uOFmGeHnH+SGvCiwfYzdurzVE7baADAWW3G4v1ElsZXYtgONE/LJM3XAnuB7G0Ihk7aXPhF3aM/6E3pUi9jH+XCmird7REqKMwpzNgYAGF0kTcn+X3MLM4tfT6FOgMA1icjrzEhdroVgC40IBEG0OfFQwi9fRM+9RW2o4az50LduYBU6a0VYZINpnStzeb0yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=jgwSfuiEIWB1m+qJyJJ7wy1mZwC2yAbVSkFbyFpYVMGJ3+7BNusUy2V7bxGkJlqmp2YcGagsn6Rr7Q6Cg3pMakgf5rIgy9ejyIX+tkuHp8wTWevAxcLtTGkiN1Jmlj0r1rAMvlbyOwCtkMYm4KJtWLjKsCfT0cqsB4QEI3099Ftgy7YdfJOkTKEMphJn9abyCkMin9m85/H/HUJujP4aiDa1KWvKdbcHNNm0qNKXiB1E5/1lfkoWb3inJ56PIcwhxmMsCp9uTNq1Dej4xBCglI+uqew8Og09s7T8jY24UqLGVkf/Xddt3PcU2Vn+1Yx+7W5mvm+FO46lMWqVZtK28Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=Febzx7P4STp3eVKC31bs4tIdtkMtGBdt9+BrKKkG6J+9X3M2kOkEky+4aAq0zKXD9P2YDJCIB1ZYxW8g2w1QZmHzBCNvoUk3uibHGdEtXURCNotOi/arvQ9xZwPsUtSNxtwOsCFDoGWvRo2xFKGDAdBCk37nI+BttDQqXvLDLe4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7843.namprd04.prod.outlook.com (2603:10b6:5:35f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Tue, 16 Nov
 2021 05:22:22 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 05:22:22 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>
Subject: [PATCH v10 kvmtool 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Tue, 16 Nov 2021 10:51:29 +0530
Message-Id: <20211116052130.173679-8-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116052130.173679-1-anup.patel@wdc.com>
References: <20211116052130.173679-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (223.182.253.112) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 05:22:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f196a90-f50f-4057-74c3-08d9a8c11175
X-MS-TrafficTypeDiagnostic: CO6PR04MB7843:
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
X-Microsoft-Antispam-PRVS: <CO6PR04MB7843376E553783FCAAC7FB478D999@CO6PR04MB7843.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmNEXgzL9+2R3NkNXCvQyQfM+xHIMOfAPHKm8hpKjElk6UD/RijID6pnMbMxgRDYJZTN972ynI7Kmll/jIwUwG/Rk/L3vzyc8HmgQNt0oo8EMEGxi67sj1rdkPABlMvUID8EIUmSS5BoC1hmkL7NVcmXwZWThJENMzEFbgFhZNHbKXdc/g2S5CFVbO+B6DEnMWyw1qZHxaXrn9dymwpyIOCzpvm99jOJFA/dpum5Ye7FGpa49HU7OGLxdbO9FTC1yJdzlnWKiy1AXxXcUAbOI1FKfaaJcJMZlQWa7eKlnS2S+c0rcyUO5X6PPzxGh0TFXIGUJk8BbUKtVMymnOQA02cnBywrdlvD5F/HmaXYSq5bU2VrYiS8Zt7GOlkcQhqXL88EaGI+k/tJrPh9shWKodKSKda4Tu69JwGO6OmMgXmgARd7ajIzNowaRYpkCJDTTGLpBHvi73bmL7hAsq74FeqxIuURFQVAywo5x/Y0RIWakojie5Ezqk3eGYoD2KeA6ZoLGkn1RZMb8OAFy3O8VqSKtMXLYkWFuiB/VP0DoD3qwB7/x2zYoz3Ii7064asgtB53X8HVhgHNROvZWQF2GODfOGDnrPmsguTMQRx2Y9q9HZTDeoitoxBrvxAlAOqVfNiLXKKet4J69cgZ9YKv/ky64YaiIwGFWkhdZNLzF3PCYTkMKNdS0fX+5yYmNk9V+QxGaKD1Se2VVIy3wB9D0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(4326008)(52116002)(66556008)(8936002)(66946007)(83380400001)(6666004)(186003)(86362001)(8676002)(82960400001)(2616005)(66476007)(8886007)(38350700002)(36756003)(44832011)(38100700002)(956004)(26005)(1076003)(55016002)(54906003)(5660300002)(2906002)(316002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zAAB7g2bm3FRye2/gQ7NPVnYsFoNhGxRFnFpmbGzF0v2MkgcTdwj9uPFBAsK?=
 =?us-ascii?Q?oaHoiSpUky6X19qUD82BBvudAkf5eiI1FsXiuupNGSX19QQTvZwnx0C4ftep?=
 =?us-ascii?Q?BnIGwwJTDhF/jBcGNH+iKszoWvid1QmHRQf8mnEwbJlCg202z2NFN009hT3N?=
 =?us-ascii?Q?GARNqr2Cc35xFKpRZmvhlVMyT9HE96zZt/fjAdo6zPQWfqoQ+w62F59nmjO4?=
 =?us-ascii?Q?tK5kztEvWMftsO4vHqZCiJtDXvYX4QBaSnzNlOsvI4B5XFu04ygiU5Vvoqa/?=
 =?us-ascii?Q?71lesRPR1GXpF6egJ3/tqUxgSoXAK0evHyybexwC42nAGxDRFCHw3Px90xf4?=
 =?us-ascii?Q?qA1HVgI0RWhkSTyEVzyamdTjfNaBKdv/L6r8u4DUPGJuhJqN/s9C96fJ/j1M?=
 =?us-ascii?Q?pvTPdMKi4uJKs4cyKLxxpvTcmFzsXzwcq+fPGL908c0M26Wgr9FZFL+bqOpx?=
 =?us-ascii?Q?ybBPQ0SLYzlilvGJdmAiMGVtlyMCRbEwS9GKrb4YqcOGxRXUXRrglbUDrKTj?=
 =?us-ascii?Q?F9ump+kHYN/NpVH9yP2dTp04VxtQ9Km8aGW5BOFezD/m1cYFnkKs07WABo2k?=
 =?us-ascii?Q?xJ/w8iLtG1yllwvwSvkQLJP2gUf2gWrgJvQRNzcehkzyU0sbuJFr3U0luKWb?=
 =?us-ascii?Q?R7DvjfaYpXTODEYo07cqFhC62ki1z+dOkvUhRBESFufW8MvLSXfGvKFM404e?=
 =?us-ascii?Q?4sRcSCLiAL53/RGS+I3iu9L2UIG5yP9rb7R0tnFEihlZ1nVNnUv1n85tOJhe?=
 =?us-ascii?Q?QB72WSG/GyD1Z6z6u7ortbSGnF5lYoSEYvM5NlFM8CWLNCpYSaaajoVX0Ino?=
 =?us-ascii?Q?Cw9BDB6dTdEJQIb9EWyh1hD6cFKzSA86QCdDABgbJgtHP4z0m2wFxTceQR90?=
 =?us-ascii?Q?CSM3VFFDZlmlV1/GyE/GZHd6Ok6zvm2+IIqMNeA5Xhw8QL8D6fR+yw8Eemm6?=
 =?us-ascii?Q?6+p144d75gvTgyHce4x3e4ZZku47lbcBCtKlVkU6+4pjlskwAPJg2QdqdtDV?=
 =?us-ascii?Q?04hZIpIwO93Ox3glCNZPkMYDlxWDZYIOGRCTz45FcgEFslVvnR9GNFP/lZh+?=
 =?us-ascii?Q?gF7r2P+dceUjACsIpO6gGQlMOpU8hJY/ItUsT71Gu6QSGC6RHeKjj1v84TPD?=
 =?us-ascii?Q?ByutYgNp/947c2aAIMr04moQ4getWlOee9A80fyfPfqVoQbn5KHV6BFVpRvw?=
 =?us-ascii?Q?NqUz2PVshBlwvNJ0vvNEe5HgCq/GmaOHo+aQE6s2ltRT8f+X1d2aPry49uM/?=
 =?us-ascii?Q?rqB/awkC3QjPJJXP4XZv8gWo64EiAwXanL9/RTa0kNP7yFLUdGPpf0yO6rzf?=
 =?us-ascii?Q?ygo5A3RiFZXllZH5a7egYDF16VhfKy9uysnT0d5+j6DPKtDV1B0zsUOzbOKs?=
 =?us-ascii?Q?gkVl+j1GUvYLmStHE9pX5BZTaBzVkUVVps4QOAZzQkY8A36J0qBMckfb8GU2?=
 =?us-ascii?Q?CvvPgCoqAYnS20KdW72H6+U5rGx+7EYjmLu4bSlceIipgogc2vJDVqRp5Jft?=
 =?us-ascii?Q?EJ+Th2Huu4fDUfUnEK9MAO9DS6LIESSnq4ET5WVB6DrXgeXNP/coe0Gps1iQ?=
 =?us-ascii?Q?tLDXiQFIHI9aTqA2+V7uELMZ2LuBiSteBQ+IHfyz8qaKzrAoWtO90c4PwNNR?=
 =?us-ascii?Q?y6lpzePm2av/Cgt9GVZjuS8=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f196a90-f50f-4057-74c3-08d9a8c11175
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 05:22:22.5546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TYERBCC52475fidyB95tQHKGeV8rj54aU8GUf0/ToJosx6iDFMvLaRfl9WKINnUWcS7zrvF2AmXAQDTwCAsnLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7843
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


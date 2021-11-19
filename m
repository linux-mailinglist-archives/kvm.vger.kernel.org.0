Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DC9456F09
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbhKSMtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:49:11 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16451 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbhKSMtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637325969; x=1668861969;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lDq+FKo7RmMLlDr7OA4J8sRiNlAUgKGsONyvb6DEe/M=;
  b=IlhCMeH6ZyziLEKJmi561CkCuoDEg+R8b8JuWQinygONxZC5h1KkxSiQ
   Qf2YqZBWr4kTGV2eFcK6yCpRkvp1zM2NPehniPtADZOpFoTYKhY+R/LN3
   6awss/Ftud9SpaYcK2pdla/xI5/a1FIkO1pJjY1F/lHxg0JHLN/6CadRG
   YPAoVZ7ZIBkKDvOvbulV14GDI3BwSjJnCQH1V/3z3xJ1OLHBqBj508dsY
   X2cP5pFPp/VqwhR8RxJJ5k1Aivj6utoMDYQfuBiomkkzw0eVyfXL7AcVC
   E7DSItr1Jf8NHttu0gQfAectO+geFZBtLpcCg9TKpLKDXW5zVWTxFaRvd
   A==;
X-IronPort-AV: E=Sophos;i="5.87,247,1631548800"; 
   d="scan'208";a="185086392"
Received: from mail-bn1nam07lp2044.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.44])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 20:46:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4qDkeDfNB47uCa6oa/OaJvvPpCOsmpTHkkm0urHAwu+gYVq4+7izf3GPXsQ0jd+kgTMnyBKpxcnzvlYnTwl9vHz2RJSicMdFnJs5vt9zNzvDuseiXYk75AdfC7asgoSkTAN6FCKr7VOxCKH5SNr3XvpsHsodvkiigHis75Y2aYAgB8yIohXiA0/xatLqjkep61+NMfnLCkUS4S+5vDjd5Jejgg3aB6jnhTq5FXm8Tv3Yc5JfC8LydnMQe4LMRq6uNrkFn21SHtbCYnpAg8YYE2zHepchpmQ6vjtFEFtkDK97jFVXZDZ4BhO/cpJOucQ2r6l2g5VdtbKsSBnzaveOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=LRiqWAQ72bpL6SVJHytVhyXWtkXdYlcb8C+jQ/5ITPqslmnYnMIbG0ZVuJb6/EIe3NqZmY5SVLwbnErZKefYCnyh3WkT0LgubD8/8PfF970CrKoBj3b8PY5tUrvkrHGtGkf1MV8IF4l1YoJiP8x7abMQg0k16bnDd8SZnm6ntc/t56Pmd9aUdgE4flryBg0tLgdNAH+FFIaqJtjSuGNoJMOP70mrHDpmpgvpaNj5/AWusf4L3WoEX/PW7m8ui2AEJQ1QLhIZ/QTgkOt1qx3QyAQeHc2DtRm5rhbfbVQPFc4LCH5EWSLUZDoh9Zka0wObA2HHfLGFN3mrgkJ6OAvQsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrurI0CrHyGTFt1VaTothhQZAEntRUm1BYM8Wyf5F+M=;
 b=X0e1+PDDrCI5sAyESghgsW9oIxchiCXPNchyYB4Xe4Uu7lX7N9TLjYKmiMrtxZoIjbRYb9F4EYl9BD+/5ymglJW2ZtJzlbr+nXRDLohb3dvK4ZytvmUQN+1cKBN/vsokniSkSzDqkB9FAcPD6ZD9cd9vh+DgV5+hGlpwWG9xSpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8444.namprd04.prod.outlook.com (2603:10b6:303:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 12:46:06 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 12:46:06 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 kvmtool 7/8] riscv: Handle SBI calls forwarded to user space
Date:   Fri, 19 Nov 2021 18:15:14 +0530
Message-Id: <20211119124515.89439-8-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119124515.89439-1-anup.patel@wdc.com>
References: <20211119124515.89439-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25)
 To CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.171.140.195) by MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 12:46:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d04f53f7-9c8d-4e86-d1c6-08d9ab5a8dc8
X-MS-TrafficTypeDiagnostic: CO6PR04MB8444:
X-Microsoft-Antispam-PRVS: <CO6PR04MB8444858032683C91BFDD6DF48D9C9@CO6PR04MB8444.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+nUDIzgYePdExeEmoJzrK6xpCeRASAeuD3c4PGRNC+G0Wsd+jdQ7K/X1Ujaz+bZtgkggrQW5Yu8Nq4wHpDzA2Hj+TAukGYyCcRQGdHelZ8VEzYqm2NTrfl0r5LqVWQVLJ57XSRlz1ynE4qCjKbzzTeqVXAyHqouLvkS9fmuKZ0etMKDSwDAN6XYeL8wpcy/DPUlmHhDJTmN4ViiVrEyeSFs1/IVUijOMfLPi5IgIdGbDHYe8atu5D2lXLr6a0gq4vgRHMfqXjpIVO1uQ3rmlvrMLeieEc6U2H02ygUI/mR9OnzW/rQ/XK4nv1BQPhBtL4kkyC5qCKsEqPxG2aZmT7RUlCivYo6HXWS3IElYTYrJ4Ad/0AyK/pkBPz9WUQD5n1HQ8nzgI1NSz4fh+DrRfAWzx4befcHO+qI0jGhzHUzURE4IxiWNCRFS9dacuPfvceC8i/8rDqjyjQfm1tq8ZWSvi6Fi5DNpe3Jq4A4DJc0YbGd9BBu19JDJ+b9ST9q5vkeofM9H5kAobGgT0w4LiiSXpiUu2YUag1VYZRjRiZUa9NimtkwqH4ySxZvRKmdohj4DJZgSgi+NAz67bLJNTqr2tbr6DMIy/zjpT6yL6aoPiSJ0BNn+EAQ7Lr9mBF368dtAvOkS3PT8F8RPtKwGxI9e+kPuSeauIzLn4QJ3CB+xPeOJY1rRzaQenEITlPt/uYUOsJBLoQVlBkOlFY7dXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(1076003)(38350700002)(38100700002)(44832011)(66946007)(4326008)(8886007)(2906002)(66556008)(66476007)(956004)(54906003)(83380400001)(55016002)(2616005)(6666004)(52116002)(7696005)(82960400001)(5660300002)(508600001)(316002)(26005)(186003)(86362001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8QM6PFMhAu+w27UAANPeoVArzVbP32cHBs4sswkM7HBqbbUAMvaX6BkilLXj?=
 =?us-ascii?Q?9Pl4xP0EkKrFMdWr6RTg5eN7xefk/dxBLICiUp8ClaK010bqZILuCjOOfnBI?=
 =?us-ascii?Q?DMfcPePL+JablDd9H5+hMkFfDULuPkz9U216SIi4rn5lpCxlccIDrbguyaUZ?=
 =?us-ascii?Q?d4B1BjenExW5eTyfy8O8voD7L2e5lP4/EcDSkWMJA6ep6MV6xAVu6Hsz2TqF?=
 =?us-ascii?Q?Ax/qJsxmhrRrTQVmDP8r6JhD0VZLaFfnztFsOReJrYMQ+rSebMyue+hKV7e7?=
 =?us-ascii?Q?4Jq2obSZlEj/FEQ93KZawTfyv/sI4rejIa9eq4C6BSGRdDHTcaQIyJ/n/IyK?=
 =?us-ascii?Q?zgc9Aw/eVCrzyHxkp5pzGOcv5jHFzED0aDEWCKLp7dXqt/SBLxoZ214ObglF?=
 =?us-ascii?Q?2Vwj9qZ/5J2zrZ+LMeoUWcnPfczH0UwDQmJvTVyC4wtGvbH8rVVJgkIwJDxU?=
 =?us-ascii?Q?K7sOupKOWdPy9sTXrEKGJ2wl7WnP5d+l2ECld0YzcrYoUTG8IkNI6pL9jOE9?=
 =?us-ascii?Q?O759lPkQwoSLvL0QKsIIuT7/Y6VFgY/SMs/Tf8k71Gqbpcs2NBIXaSZkCzs3?=
 =?us-ascii?Q?jCcMI44K/cLD3z//KOgzIjxaRcl2Ks5MuG/Jd/TL5SCwnfm9cY8VssUsyBZT?=
 =?us-ascii?Q?gVhrNlYyECzjIuGPOnAEa6SOdNCccZ1j6H9K8XyxNcw+7xMSL+IEibKilXuM?=
 =?us-ascii?Q?74qnfiVLzfE77Rq6jlKtTJ2n8GY5NSWcFsU9bGkLyqBGKIoh+rxjs/K3BeqV?=
 =?us-ascii?Q?NRWVgUffBEWF9mBmZ+B/+LWARyxUYh5pHvSvX+JrNo71kln32faBal/rnvVU?=
 =?us-ascii?Q?7IxXr5BobP4YGsDC5jlbl8mBhWcf4RUUDS5TCoPdOVxLe478mAfzDsteiyX3?=
 =?us-ascii?Q?L8+4jUxwcVzI3NZKnlff5/t1W2eWDP8Q8QEdY6SW3mQtnkjXDSASOO36ozCL?=
 =?us-ascii?Q?FwZz3yGjn7mJdcEf+81u/E7t0d+DxWuaLTWIjqLrQm6cvGWjHziSjKR0LHtC?=
 =?us-ascii?Q?HRvWHW7el1uhS409VQY47n62Th+grwPUTlMltkco9sd7h1J24ZYmNT3UYhNN?=
 =?us-ascii?Q?Q5vko9qbOf9lo5cuHwJmrkSzVgOgj3mgBTCNzrECKbNnTR0beOMryI01rLjV?=
 =?us-ascii?Q?rf/WVBNhBa8ewGhUX5N6h3v5SCYTQctu6qljChLEOI9wsxhfd4F9QueXBS5T?=
 =?us-ascii?Q?Qh3D7DZWhvTK+D0GseKA907T1f1zl+TCPhBYu34qFtjEjKbG+xBxDJYMusMx?=
 =?us-ascii?Q?6vRLdUBA7YFDNag8ETTIEA+R0W8gN0njaH/gTYP6RW/xcwFeYlkOpowrkugh?=
 =?us-ascii?Q?2Wf9zPxIE2CwkKoO66kE3n0d6IOJ39eyf2tp/notRAgGohGkGhPEop34pKE8?=
 =?us-ascii?Q?VDQXRnUbaxm8ZQBk/rTP4xwM3O3EY4X1N/8RZkOXgRCAoHDNfKmGQLC6vqXi?=
 =?us-ascii?Q?7LWo6LYMudzkcgmWBYFOeBZ0luwigVesbG3Njucr73+6yqU4WB/vNCVfUCfQ?=
 =?us-ascii?Q?OKIl1e7/hFZFN7wCUCBJ40kDCrYKAfadyzr61zA7eCGQYSAFWHdbplQEivbb?=
 =?us-ascii?Q?fAPN1orucNr5Fh515sxQNge5PmwuEcxmF34uYjW4ASxD2o3aW8nK2fdahlxE?=
 =?us-ascii?Q?4Y1GmMnb2qiVUT2N5Jsd+U4=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d04f53f7-9c8d-4e86-d1c6-08d9ab5a8dc8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 12:46:06.5264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXjMzU27YbiMFPi9BVOKq7jgm8ezhvcf2V1GF8MyBPn4VP2yCu6bmIQzRm9+PQ2ZTVFVUIWYXuKPQWieZroqGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8444
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


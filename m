Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1251641934D
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhI0Ln3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:43:29 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36452 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbhI0LnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742903; x=1664278903;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=dEDorj1bJ6xt+/Xb8bxMahV8cLUxUsdVCLciOn5XJp0=;
  b=P+1l7b/jDiX534Q14cJ2ZvSCVnNosIS3QA5y0CkpCS1DerWvlY5c8Oih
   u341woDjhxXMRJMzYEczOda17PWI2mjgMTKWlmx8bCuOEl8o33tFEBy/T
   yJH5P4mu7z0JNu+lNyOqC6NuypL7NeGDCVwbZ1ASpd6+uF8L2UAoYvcx8
   vtNA2TYQIIuFDfs1o3GCHDx829UweIA+57KHPq9DJB9kSya4Q+L1Ln6MG
   kTUlX0TT5MlRehcerJ7Yp5pi9sazzZYTXSjeHpi6e+mh0frDY9wW9TPNT
   ZZUINNWtDFju5NdpsTqTwds5dYtJr1mvwQgiQd8Ur+Wm8WXTAAGKv8u7+
   w==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181673088"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:41:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyRiSvCN21HLu+m/nd2jPzyYwFoG35bSDfT+XvdIGKZhLQwrTK5CCNBFNkgPkIxsXbKwnSWqvrmcYPzsTs2kHale7rfEk8T3hDidM8Xd3mrledI2qr87vXIf2pI7gQUB13NnruuSch2qOCod02628/9Q/ZfFl0viGh6ML8gFk7kaF2kfAPUQbFxxBHuYwNs4FQq5LcpC5P6zCWe7R8PO5ab5N5nsgmyLkcMPHfaPy1LwlMoFGRCRrMYt5DJDDkU916TPd//NFMlTcTaN3lUSrvcQenwpJlNLJAcx97VtughnURDbUVfycf+M4lYLoLx3zIq2yJXd5g9SBlpRpLQwtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WvJzVs+SK1nRY3y+/2hxXn9gprVJveO6SQYZgTPaaGI=;
 b=BRHHFC9gAiWmizVApFWEwcdx0OZgTTNB6sX6SH2YvvJWdGRQAXko91F4yt7y+JUvx3OAdKPQ7NaIsTmtu7UfPRpmF8S2cUPFD3rWSYS/E1spxfZX61WHKP1fmfaGt2lv7DP9iJkV8XzDAd4tJ6rp56uk9FG4zcViqTSIj6QV4Z0vEtU0D0HkqxowiXgJYipvuGz1fuiRaI9abx+TJ9p8MGqugheiAdzAIzdZZoPwlWARkQ2jb6B/dqNcnN/EF37A73xzBzSiOOLhmRC5Ejl16yl5V0voay8SfUfeFAgzXBqbA1Y7ul1keTaZK/hYo3K90XyfEeyhMQQCC5pGBYNVYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvJzVs+SK1nRY3y+/2hxXn9gprVJveO6SQYZgTPaaGI=;
 b=RorRwK6i3zZbmC+68pppz1pVQJWMTLMzFfx1xXD2b7wf+WVG6ht9+R+s3XacN2ykqCPm7J6IKSmAOGN71wOjfIEF+xI0dBh3WhLh23y3+pTM3K6f++iv8d0p0FLimUI1FqZdusdAjY+XHZnbJpSk+oYFYFepPHFLmGWTBxrOI+g=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:41:37 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:41:37 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH v20 12/17] RISC-V: KVM: Add timer functionality
Date:   Mon, 27 Sep 2021 17:10:11 +0530
Message-Id: <20210927114016.1089328-13-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:41:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fe4d210-a677-48ce-2c47-08d981abc3c7
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB82364E47B65582ACD4B069AD8DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q/5bjolCML0TW9vz0xZaZpt0eqlxRDLmMUBGLhmO0wNE2j0S+MF6QUMhxpAGyBQ9x/tnPTcET8rsF2yd4qW3Pvjw0+HOaMV6TfG4ugCDCryvEMONWG9BNFVk22AuAtGafXvYY1v3FyxSwXf90fzBrYMlbS7fBEj9y+A864g9xCo0geiaDcOzsF3chmB2zt2v5JGYHA0mo+a/um964800h8+PbZ5Tjie/p1eLjymXUB5jR2evV9Rb0NKQNU3ms3c168btvId0DGQyM4XcGErqDDmWmEfzRdrNkpGK0e/I7FE7VSNBj2EIdhkn5x3hY88BJgbQQIkwVUDeq4XDuhRFboBcRiEE1f604Cg7VoaaDQEcfm31c5sql7aKn+/dkGzufoHkMiEz/QshLolIF83G7l+uOja2cGQ+098uTCN3FQIIeizCK2xDUOlvoP7gGQH+NAbh6bK7uriWVNYnjSqJ3dZgGS//66ceipz8oebMrTE6vYOgxUDIaND2r+ERBM1QTW5rWr/aaMuhneMjyeuw19itl++RJ1ZZrz1UUWlvC5+q5+Vtq1Vzy4GZWLImAn2hdz/VhcJhM1JxyQDF2S6vQFvVSiQ57LUU9ei3oENHjm2NOrtfOmrbttCjjedrUMTdOcBCRBSWEgzvAjOY5OOrHabU/KrboxbT/tGp4kNDo1JD9+HUrGlHfNh1/FQ6Yol5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(44832011)(38100700002)(54906003)(110136005)(186003)(55016002)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(7416002)(26005)(83380400001)(30864003)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4iluNnRwpJe6iazD9IBhXGuQ9dfT1T+NwMoOKssYcFfk5TUJKzGMJpsA61UX?=
 =?us-ascii?Q?E/wMVgEA7D5ewVZT3JhWBFRAyDiQVqBEJwhLfzhHZDl9XoFgq1cmeRDxdUb/?=
 =?us-ascii?Q?pZyS4f/vv66MK9pd1Bpdq3goHrQVbJfmOQFLxd8ChJPI7XxlwMJ6rwT/EJyv?=
 =?us-ascii?Q?Py7i055pRA571dzibmDSBZd8wRAxKxzYv/GzDbagJqdQJZVYJVL8tLHaYRXE?=
 =?us-ascii?Q?GOB6XZQCgSaOVteGqWjBfRf3HI5lEa4AbMmfCKWRDxlH44quBtNVRyEU1UsV?=
 =?us-ascii?Q?EmAJnqXmn3NYQ1Iyswf4udTGJDFxdjk7dOTDh9QLmrWP/gqbDzvhfR4qWvlR?=
 =?us-ascii?Q?pXjqKAOQkM+Pb59z3k9OxBb8+DIIsiaKVOwy5qlOAi5IsQKeLAZVoHT7WeLm?=
 =?us-ascii?Q?tQAedz9jxDlFg1vqqYudSZniT67HQxsf7CgJrMGIEI9zk5NlWz9KuptPI/1F?=
 =?us-ascii?Q?NEV00csebJ3+9jUJEzyW/ftbTNcSR4nvziRtQk3vZXhSS5BFdq+XD2FbstTW?=
 =?us-ascii?Q?UFM+TMSN7IBVS9uPcxVVJI5X/CvKRNC8jzBh8ANR5gF1xe4OHRZYpmebKPqb?=
 =?us-ascii?Q?brWB23rJzB/W/kzkIrnZ9LivRTx6xiFNlSbamcT/5NIAicm4hdDzg/45f/dK?=
 =?us-ascii?Q?nzzp7APuE6Abk70xjrfw/h5jYs64JGcgMf50o6/qzW/iGfdmZsT7dn6Cw5+3?=
 =?us-ascii?Q?DIj+LYN9CaLf6nHNAORQgm0kgoyq6Vj0Jg/qmF07UQeTWFyudfKjPIWdvB6q?=
 =?us-ascii?Q?ZH5y3qnDxQQTFLfAZPmEXFa2ndK9H81Vle3SDIkyfw4jCLz1508+xEjGpvcQ?=
 =?us-ascii?Q?Ej1+t8GuVd3e02FkHWCOPcklq43OxxJbSBwc5ECRVr0jsIFbVVleGD6CS58x?=
 =?us-ascii?Q?5ZvFJS6Ge1f6GBI4YGT2eQfKfz1jyvNXsvq6o2xQevEYYQhOgys5YsanQuwg?=
 =?us-ascii?Q?qG25JwBV1Qys/kTKND4/4ovaHfwPj30wIH1vDIuQHjFPBLdQgvS84tOw9bCz?=
 =?us-ascii?Q?OQeGTDxD/6GM+d+Coj8Tik1muZbLY9SvOOnKkMlCj2q0lmTyc1sGTXP2IAVN?=
 =?us-ascii?Q?OdfkpPg/7HpY9aFk7/FohwakiT8Zh3fLkdChKYZdrSEHQSX9LcgdekXyqv7p?=
 =?us-ascii?Q?czLoaIfn5mO+My4qabfEMJJcb/21a7yrzwe6VW4EqEtaRSquXmei9E+2qePH?=
 =?us-ascii?Q?zoYaMFoO9HV9gwGlvpgJxBNRy835w7m4V5OYQG04Ln+HzihJYxCyEpVu4gqh?=
 =?us-ascii?Q?jeFPXit28bDu3jygzsslx8vw8voB9JxCIlca1nJgnLfrie5LaK7sh4hfy74X?=
 =?us-ascii?Q?eDgOj9OmPVeZ8XOuJiRgW0IM?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe4d210-a677-48ce-2c47-08d981abc3c7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:37.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Eoc1bCJ8ywfh/gMcDIFf2XGcdPuGSfywhpw79B+8tnxd/8gz1R+d4ghzuiSmvH32Esc84mhRyAXMvXkWIPnVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The RISC-V hypervisor specification doesn't have any virtual timer
feature.

Due to this, the guest VCPU timer will be programmed via SBI calls.
The host will use a separate hrtimer event for each guest VCPU to
provide timer functionality. We inject a virtual timer interrupt to
the guest VCPU whenever the guest VCPU hrtimer event expires.

This patch adds guest VCPU timer implementation along with ONE_REG
interface to access VCPU timer state from user space.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/riscv/include/asm/kvm_host.h       |   7 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |  44 +++++
 arch/riscv/include/uapi/asm/kvm.h       |  17 ++
 arch/riscv/kvm/Makefile                 |   1 +
 arch/riscv/kvm/vcpu.c                   |  14 ++
 arch/riscv/kvm/vcpu_timer.c             | 225 ++++++++++++++++++++++++
 arch/riscv/kvm/vm.c                     |   2 +-
 drivers/clocksource/timer-riscv.c       |   9 +
 include/clocksource/timer-riscv.h       |  16 ++
 9 files changed, 334 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 include/clocksource/timer-riscv.h

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 17ed90a4798e..c22d3f6519fa 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <asm/kvm_vcpu_timer.h>
 
 #ifdef CONFIG_64BIT
 #define KVM_MAX_VCPUS			(1U << 16)
@@ -60,6 +61,9 @@ struct kvm_arch {
 	/* stage2 page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
+
+	/* Guest Timer */
+	struct kvm_guest_timer timer;
 };
 
 struct kvm_mmio_decode {
@@ -175,6 +179,9 @@ struct kvm_vcpu_arch {
 	unsigned long irqs_pending;
 	unsigned long irqs_pending_mask;
 
+	/* VCPU Timer */
+	struct kvm_vcpu_timer timer;
+
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
new file mode 100644
index 000000000000..375281eb49e0
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *	Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_TIMER_H
+#define __KVM_VCPU_RISCV_TIMER_H
+
+#include <linux/hrtimer.h>
+
+struct kvm_guest_timer {
+	/* Mult & Shift values to get nanoseconds from cycles */
+	u32 nsec_mult;
+	u32 nsec_shift;
+	/* Time delta value */
+	u64 time_delta;
+};
+
+struct kvm_vcpu_timer {
+	/* Flag for whether init is done */
+	bool init_done;
+	/* Flag for whether timer event is configured */
+	bool next_set;
+	/* Next timer event cycles */
+	u64 next_cycles;
+	/* Underlying hrtimer instance */
+	struct hrtimer hrt;
+};
+
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles);
+int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
+int kvm_riscv_guest_timer_init(struct kvm *kvm);
+
+#endif
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index f7e9dc388d54..08691dd27bcf 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -74,6 +74,18 @@ struct kvm_riscv_csr {
 	unsigned long scounteren;
 };
 
+/* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_timer {
+	__u64 frequency;
+	__u64 time;
+	__u64 compare;
+	__u64 state;
+};
+
+/* Possible states for kvm_riscv_timer */
+#define KVM_RISCV_TIMER_STATE_OFF	0
+#define KVM_RISCV_TIMER_STATE_ON	1
+
 #define KVM_REG_SIZE(id)		\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
 
@@ -96,6 +108,11 @@ struct kvm_riscv_csr {
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
 
+/* Timer registers are mapped as type 4 */
+#define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_TIMER_REG(name)	\
+		(offsetof(struct kvm_riscv_timer, name) / sizeof(__u64))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index a0274763e096..4beb4e277e96 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -21,3 +21,4 @@ kvm-y += mmu.o
 kvm-y += vcpu.o
 kvm-y += vcpu_exit.o
 kvm-y += vcpu_switch.o
+kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index dfe479d9f564..840f4586796f 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -58,6 +58,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
 
+	kvm_riscv_vcpu_timer_reset(vcpu);
+
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
@@ -85,6 +87,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	cntx->hstatus |= HSTATUS_SPVP;
 	cntx->hstatus |= HSTATUS_SPV;
 
+	/* Setup VCPU timer */
+	kvm_riscv_vcpu_timer_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
@@ -97,6 +102,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	/* Cleanup VCPU timer */
+	kvm_riscv_vcpu_timer_deinit(vcpu);
+
 	/* Flush the pages pre-allocated for Stage2 page table mappings */
 	kvm_riscv_stage2_flush_cache(vcpu);
 }
@@ -332,6 +340,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -345,6 +355,8 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -579,6 +591,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_stage2_update_hgatp(vcpu);
 
+	kvm_riscv_vcpu_timer_restore(vcpu);
+
 	vcpu->cpu = cpu;
 }
 
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
new file mode 100644
index 000000000000..ddd0ce727b83
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -0,0 +1,225 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+#include <clocksource/timer-riscv.h>
+#include <asm/csr.h>
+#include <asm/delay.h>
+#include <asm/kvm_vcpu_timer.h>
+
+static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
+{
+	return get_cycles64() + gt->time_delta;
+}
+
+static u64 kvm_riscv_delta_cycles2ns(u64 cycles,
+				     struct kvm_guest_timer *gt,
+				     struct kvm_vcpu_timer *t)
+{
+	unsigned long flags;
+	u64 cycles_now, cycles_delta, delta_ns;
+
+	local_irq_save(flags);
+	cycles_now = kvm_riscv_current_cycles(gt);
+	if (cycles_now < cycles)
+		cycles_delta = cycles - cycles_now;
+	else
+		cycles_delta = 0;
+	delta_ns = (cycles_delta * gt->nsec_mult) >> gt->nsec_shift;
+	local_irq_restore(flags);
+
+	return delta_ns;
+}
+
+static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrtimer *h)
+{
+	u64 delta_ns;
+	struct kvm_vcpu_timer *t = container_of(h, struct kvm_vcpu_timer, hrt);
+	struct kvm_vcpu *vcpu = container_of(t, struct kvm_vcpu, arch.timer);
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+
+	if (kvm_riscv_current_cycles(gt) < t->next_cycles) {
+		delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
+		hrtimer_forward_now(&t->hrt, ktime_set(0, delta_ns));
+		return HRTIMER_RESTART;
+	}
+
+	t->next_set = false;
+	kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_TIMER);
+
+	return HRTIMER_NORESTART;
+}
+
+static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
+{
+	if (!t->init_done || !t->next_set)
+		return -EINVAL;
+
+	hrtimer_cancel(&t->hrt);
+	t->next_set = false;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 delta_ns;
+
+	if (!t->init_done)
+		return -EINVAL;
+
+	kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_TIMER);
+
+	delta_ns = kvm_riscv_delta_cycles2ns(ncycles, gt, t);
+	t->next_cycles = ncycles;
+	hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
+	t->next_set = true;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_TIMER);
+	u64 reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_timer) / sizeof(u64))
+		return -EINVAL;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_TIMER_REG(frequency):
+		reg_val = riscv_timebase;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(time):
+		reg_val = kvm_riscv_current_cycles(gt);
+		break;
+	case KVM_REG_RISCV_TIMER_REG(compare):
+		reg_val = t->next_cycles;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(state):
+		reg_val = (t->next_set) ? KVM_RISCV_TIMER_STATE_ON :
+					  KVM_RISCV_TIMER_STATE_OFF;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_TIMER);
+	u64 reg_val;
+	int ret = 0;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_timer) / sizeof(u64))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_TIMER_REG(frequency):
+		ret = -EOPNOTSUPP;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(time):
+		gt->time_delta = reg_val - get_cycles64();
+		break;
+	case KVM_REG_RISCV_TIMER_REG(compare):
+		t->next_cycles = reg_val;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(state):
+		if (reg_val == KVM_RISCV_TIMER_STATE_ON)
+			ret = kvm_riscv_vcpu_timer_next_event(vcpu, reg_val);
+		else
+			ret = kvm_riscv_vcpu_timer_cancel(t);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	};
+
+	return ret;
+}
+
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+
+	if (t->init_done)
+		return -EINVAL;
+
+	hrtimer_init(&t->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	t->hrt.function = kvm_riscv_vcpu_hrtimer_expired;
+	t->init_done = true;
+	t->next_set = false;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	ret = kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+	vcpu->arch.timer.init_done = false;
+
+	return ret;
+}
+
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu)
+{
+	return kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+}
+
+void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
+{
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+
+#ifdef CONFIG_64BIT
+	csr_write(CSR_HTIMEDELTA, gt->time_delta);
+#else
+	csr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
+	csr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
+#endif
+}
+
+int kvm_riscv_guest_timer_init(struct kvm *kvm)
+{
+	struct kvm_guest_timer *gt = &kvm->arch.timer;
+
+	riscv_cs_get_mult_shift(&gt->nsec_mult, &gt->nsec_shift);
+	gt->time_delta = -get_cycles64();
+
+	return 0;
+}
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 892d020674c0..26399df15b63 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -41,7 +41,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return r;
 	}
 
-	return 0;
+	return kvm_riscv_guest_timer_init(kvm);
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index c51c5ed15aa7..1767f8bf2013 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -13,10 +13,12 @@
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/module.h>
 #include <linux/sched_clock.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
+#include <clocksource/timer-riscv.h>
 #include <asm/smp.h>
 #include <asm/sbi.h>
 #include <asm/timex.h>
@@ -79,6 +81,13 @@ static int riscv_timer_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
+void riscv_cs_get_mult_shift(u32 *mult, u32 *shift)
+{
+	*mult = riscv_clocksource.mult;
+	*shift = riscv_clocksource.shift;
+}
+EXPORT_SYMBOL_GPL(riscv_cs_get_mult_shift);
+
 /* called directly from the low-level interrupt handler */
 static irqreturn_t riscv_timer_interrupt(int irq, void *dev_id)
 {
diff --git a/include/clocksource/timer-riscv.h b/include/clocksource/timer-riscv.h
new file mode 100644
index 000000000000..d7f455754e60
--- /dev/null
+++ b/include/clocksource/timer-riscv.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *	Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __TIMER_RISCV_H
+#define __TIMER_RISCV_H
+
+#include <linux/types.h>
+
+extern void riscv_cs_get_mult_shift(u32 *mult, u32 *shift);
+
+#endif
-- 
2.25.1


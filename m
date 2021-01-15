Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539F32F78B4
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbhAOMVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:21:32 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11507 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730971AbhAOMVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:21:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713285; x=1642249285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Ap7/IUO9FWLd99Pzzcbw2OkIW81q66/Uz7hck6YZm9A=;
  b=UA9p4P/4M2NFwxC04W8YlBq03SfdaBRKBRjsLnD00++rxWDZXi71V+0S
   ZPXoCzuPJHHFIKLoRgkaua+HgLW40pW9q9VrszhPGyNyOdDNyXgU3SBPw
   /iWJFcjaOtddFl8b/54YtSXgbK5lEKI6hVLXRh+76nwfeBd346oDtui6X
   UM7LiO8x0iRES4YW5iyZFMUJHnHOyQE6mVjyu9+9NJzd8bAHfJ2cF26rJ
   kPWAzeGnCWhAYCTYwHXMZdZ7LLO4+V2V7FBTbafdjBLWHrrZjdaVlmvI7
   UFHk46P8FST2fO+KyXpw5jx1Bv0vi7ifilh/1M2kzbD8lyboDiFDtG+pj
   g==;
IronPort-SDR: HvtJ0erK+QhRlAJaCnwBynf2B3JT3USVWcI8J6lxNyHVUS526XzXp8DbJsd6hvsKoJ7zX4h8aH
 3OuIiZyKbU488HS9ZnCQ7KHOnFHWjXUyzrtg+IPio3fqJgdzUDRf2gBm06A203Pr71aLxMxNDp
 sIf2gqgAoEuE9xc0rY3JSWkbRiWffqiss6MJuxAcFlcie/3JViHt2B63yaKyRYF4HXeSkwq1gM
 N3Jk+W3IJGXpUpnlS3nidpxvfV+q0RAsb7Oe0nSm51asylaCAAht2QCGPHiw9hyFNJA0Y1Q19J
 aBA=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="161949575"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:20:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8ij6pE6teWF++xmh1vocWcklW+AGKmtaapn4zu7oyZGpqA5bXj2LlYgzyqMQjLgo+uDOXEeVCoir/exdJeXrs3K3ty+05iemID7guKN49f24oYPEu2c5YVwRTY8aOn7DifEbEQHNHgs6nOma1QKTCY4EhdxkKA2fN5Eb+V3NFrJnPdSgM+ZZj5vSjQMzxd9NAT5kkzkJhsMyjRVP0WBYVSMKgjmOEeCgWIVL9nF5uX5yzTkpPXFe1mafWdu9rE045IUTI3YFQJpslY36HJtrvhatyHSut8kXjcWFzXNT/wrPJ4maB94LwT+1fQYPBVdv42NfuyZaVeZspGtBsnGjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4b4CVjjpCFTmpbo/8hK4e/Vu/GyKbKeHzgur1PPyp8=;
 b=ZPW2MhwUelrpdbKnu6VxQStBU4hgQAkUOGNVMXRwVDKpNnv9R/NtGbYiraU8v2UAqH4glVrkNCcRLzIyTbCB/rpt1B4ghOYYoNkqZTSBD90Y0mcICxS4PpdE+KF0d8bCTjRggfW09wO2l/z4+iOboaPi+M/UdnlVimxjuF0D+Agt9vX833xow2u4lxtw0jIyv8BUo+Ysu8QzhmiQMWVY1U2hzrH92J7LOZ97jiO82UZHpQHVaeNpPAOr9szncYYC7koUOFUTSLgbAA8C9MObNJwBaxrdmJnmuiiZcPvRo9l7DUamIyN7RAjdD0gwmQGPUWy3df+hUkmInGfKSLOcpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4b4CVjjpCFTmpbo/8hK4e/Vu/GyKbKeHzgur1PPyp8=;
 b=dEZ2idfiHhouz331DnQp7jdURykG53WICmtSBdzfg52wPGQG9JbAlRc7U97t7uCa57lAh/5iCu6E46LOPVVL4oe+fI+obP621oOdYIAJJQdxzI+USIDL6NROlh47N4bA428d23KBodGKKo2mAxBIx2aJ1UxRIZGpGZaJ+ZBF1Fw=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:20:17 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:20:17 +0000
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
Subject: [PATCH v16 12/17] RISC-V: KVM: Add timer functionality
Date:   Fri, 15 Jan 2021 17:48:41 +0530
Message-Id: <20210115121846.114528-13-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115121846.114528-1-anup.patel@wdc.com>
References: <20210115121846.114528-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::34) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:20:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0b390a48-bd38-47f6-6bf0-08d8b94feb0d
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB43307FEC033B3B1F7375ECAC8DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: msf7+oiRZN+cZyeZl4aLmK0ULNRInXx1WwHzj9qbA1CMJaUU6qTJkyka/NBR6SZd08dcaypUxVQJRgg6gg7jQcEKr55Iy5GFThBhcBgbh7F9JfZmIdPXpFJ/lXVawkmJKqwVw3aUFhLiT4N/Z9knrenpGCHmo34sm6dwV9na7U3PNqvt9bm1fhKu0mulucARXDafkxDW8w7cvXpPXadne2hjoOSAbPfM6nrK4HSEg4bAazS49DlEDVDVZFlWGtrZ2ayCtpmjAv8ecQ8AYKLgLqfOSmTeS4rU8CDXIdLBPlXL8xljrMsfXKku3wxJVbDPRshpDrDrfGmJEWEHeU7O6DFDQ5031atta1qlff8oCgz4XjpS98QJ0y4CCBOjPsfkGaK1rwyAaquZMk97BwFjtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(7416002)(66946007)(316002)(1076003)(66476007)(8936002)(110136005)(186003)(66556008)(86362001)(16526019)(36756003)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(30864003)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LJTej5/jci8flkFTccMLYdl0iUvfUynHmBmlY4FSYjwzXROZ6Y0WSmYexHKH?=
 =?us-ascii?Q?C/3XkCJ1TNspbraTugeFOLPYfTe0zqlC39W936L/ljheAlutHKCMFlO5jWID?=
 =?us-ascii?Q?ByMeHz/y7+gLc2/4k38+VkizM5ue5gU+SCaleI0pwLIexvCzPUSED0S/zZM2?=
 =?us-ascii?Q?+3I+6tTLacIhhcL5vX/60t6ePIY7tu0MivEWwHjK434iRm2SARvn//jwkyrq?=
 =?us-ascii?Q?Tz8Fjp86LoI/tliEXupbSd02aGeHufxezTLPZt9LMh63aLiHhmgv9WYg124p?=
 =?us-ascii?Q?lh0vZQ18/VhIgH0Mdiq2ow2T56R8XDVICIC71U71tiXCI7QldgfQEP5coKCl?=
 =?us-ascii?Q?0VWf8Xdb4qDAA6lwqGsZ2xDoSGdtH8iZj13joYCj8IfkZ0023m3eZPs2l2wt?=
 =?us-ascii?Q?w2Ytxqj9oJ3BM53sNbJGy+KEsy1OaXYcJP41A5gMTCE6W823HZq3AGGbkps0?=
 =?us-ascii?Q?wFXPg6NG0GqxTjKLkRfiNnHKxqzWLliFGzcv0uwj34stEwKFMDp464zD6wJy?=
 =?us-ascii?Q?UridMa3dyy0s1tTKRx5I/okyw6NdCOrrgK2sxMHgsT4LNKFdck8ZTNOX3Zl0?=
 =?us-ascii?Q?T3VU3NKOwfpvZoDkl1AzzflCWsBfxAqNsOK1e/1/H2D+Gl9OzlQRn1BYSYor?=
 =?us-ascii?Q?w1TC3gN+2d6ccY7Y8pXskBpWlQXaDSw7Xb27KA6p0mig/IBHkNKIQkR3IqH1?=
 =?us-ascii?Q?QeIav38o5dA8iwxM808iSFtRyjrHx+pDiSj48QxJTKxzFOOa8ZlPu202ze59?=
 =?us-ascii?Q?J0g45wKsAjoNtq4M1VUO5vuMd86yoKrF/fTJUIpm5UaDjt1DuPLOVW65iMsZ?=
 =?us-ascii?Q?tbNvDp+fwolim6sU9HqhQT7NcsV/9L71E0drTT8SYcWnGDHju6zQMnxZqM5w?=
 =?us-ascii?Q?FzBl+OHs4pvSNgTuxn6Nq4r4t7+tlMWuuHTTCLoNc8kRi1ctwMHQl8l0+hE8?=
 =?us-ascii?Q?KhVqwNev+brCujy9ErnQxX0thHiyPAIIdUTm/aFZcanvn6evshDr5agCul2l?=
 =?us-ascii?Q?LpPg?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b390a48-bd38-47f6-6bf0-08d8b94feb0d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:20:17.4862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9N4dTvAmUcaYRNrJEzFLO2d9j/jtNq+pthCQjQ3HS636NTzCTpxf/LdhUEYzPrPEusw1eeYKcEv9Q+41XWzBIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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
 arch/riscv/kvm/Makefile                 |   2 +-
 arch/riscv/kvm/vcpu.c                   |  14 ++
 arch/riscv/kvm/vcpu_timer.c             | 225 ++++++++++++++++++++++++
 arch/riscv/kvm/vm.c                     |   2 +-
 drivers/clocksource/timer-riscv.c       |   8 +
 include/clocksource/timer-riscv.h       |  16 ++
 9 files changed, 333 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 include/clocksource/timer-riscv.h

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index d25f181c3433..dcdc7816a799 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <asm/kvm_vcpu_timer.h>
 
 #ifdef CONFIG_64BIT
 #define KVM_MAX_VCPUS			(1U << 16)
@@ -66,6 +67,9 @@ struct kvm_arch {
 	/* stage2 page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
+
+	/* Guest Timer */
+	struct kvm_guest_timer timer;
 };
 
 struct kvm_mmio_decode {
@@ -181,6 +185,9 @@ struct kvm_vcpu_arch {
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
index b32f60edf48c..a034826f9a3f 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -10,6 +10,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs := $(common-objs-y)
 
 kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7192b6edd826..45ff6761b89c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -55,6 +55,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
 
+	kvm_riscv_vcpu_timer_reset(vcpu);
+
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
@@ -82,6 +84,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	cntx->hstatus |= HSTATUS_SPVP;
 	cntx->hstatus |= HSTATUS_SPV;
 
+	/* Setup VCPU timer */
+	kvm_riscv_vcpu_timer_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
@@ -99,6 +104,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	/* Cleanup VCPU timer */
+	kvm_riscv_vcpu_timer_deinit(vcpu);
+
 	/* Flush the pages pre-allocated for Stage2 page table mappings */
 	kvm_riscv_stage2_flush_cache(vcpu);
 }
@@ -349,6 +357,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -362,6 +372,8 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -594,6 +606,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
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
index 00a1a88008be..253c45ee20f9 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -26,7 +26,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return r;
 	}
 
-	return 0;
+	return kvm_riscv_guest_timer_init(kvm);
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index c51c5ed15aa7..8e73c0a23910 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -13,6 +13,7 @@
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/module.h>
 #include <linux/sched_clock.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/interrupt.h>
@@ -79,6 +80,13 @@ static int riscv_timer_dying_cpu(unsigned int cpu)
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E614C419345
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhI0Lmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:42:53 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50730 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbhI0Lms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742870; x=1664278870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=pdz5hF7uAtqcvy13MlGsldtC3BNftRrGuasVCDGNo2Q=;
  b=ZIQZoEqJJCT+tGI7b5HzHCkj6pGmXbJXS9bnmHxZzVvVOHr6708Yv7rZ
   QK76XLmoCirLye8qJsGjXeZHSOv5rmFAM88LvyXBln/6JTuiUOloLq0Gv
   doolV+SMYKPfRAlCC1/oiZhFVftGn5DdyI5ABMCqD9/YoR1eUXlScUUPc
   Gs95U2tG5JmebuM26iJ1EpCbXZxSMtt6eHED/ITodfBxOkrKSuoVnb367
   0LNHzKv67Jc4mq1rQERdUAIV8IznhAH5Ppk0uCfxSBesHKYcmuI9dTySD
   VAT2ju3Rl3XFo4/WMjIEiE4heEUDkkRtnTPYzHeBltbwR9X9lMsc7CCLr
   A==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="292706473"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:41:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOXr71iV8CBIY7oC6OSFiezih38fYVjXYUMhtDcOY9Vgs9tpyxXANfoL/FHtRZKYZ7QZ/KAmn41FzSC0lhEsqcMvWIUGgZMdMX/NMoPmPABa+n4x/3U/z7huelXqX6FxE40iKYztjig33n3IpW+Q8FFobSTwGHI3scyBuhNdlDmAIyTE2vUFa93nfhxhFuFNEa7fPNfbjmTuV02ln2ydaUmax4gndVz86QZd6i4mhBmD7ap9pOUlli18yM9KpXghLKL+vQOGHNsg5xFP+jU9tes5C8q78ydKanJKFFdZIS/Tl1Q1So6dCXjUhRSbML4IT2wUQVAoQK70QwZjK1F0Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NmTH30eKdLKaWg5LjQIMDH99g1vVUjdq5tsRZ14sKeE=;
 b=CRzakpzCDZw4xyVWUYBlof7hgsmRdsdYguq3w78FkmIaHp4RKreCab+iNO0BJbA93UuLCTSeKvH2QmyURikNUfthc3RS1psRH5EC/wMP3oItWQHWV+wNrxeJ+AwWPWubA3iiXsEtHYRJqA6lY67pm0OG4kRe+3LdAQYpXeq21dgQvYwnSz9otK0finCGOPufThHriF19B9jYw/jT1zDYgxwBpd0q0CH93+5rffyvS6fbklmq6XLkP5XzEFznJFcWZ+Q1lDQNl21qyA/TeS92j53L/FJbZa1yfSRe6cHvczXWVAxeql9rOpK4ZD0qlmGhH4xzCMmGLo0vvxcw62ThFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmTH30eKdLKaWg5LjQIMDH99g1vVUjdq5tsRZ14sKeE=;
 b=iE0TNK152D7Zwxgnuj3YsYfN5vFNYa5vwSaKmuVoH23nhsyOtRLUI//Vs/ZswmsWWopBteCt/kWqTVpCMOWeIy8UuZyYYrXTDcgxvWPpsrlTt//y2CBhx4/Ks6GRZzmKk6WeipwWVfpnmG8ybC/9NmuEJQJxakmL/oBBb8IMeg8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7841.namprd04.prod.outlook.com (2603:10b6:5:358::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 11:41:07 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:41:07 +0000
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
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v20 05/17] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Date:   Mon, 27 Sep 2021 17:10:04 +0530
Message-Id: <20210927114016.1089328-6-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:41:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f688246-9b1e-47b8-fdec-08d981abb18f
X-MS-TrafficTypeDiagnostic: CO6PR04MB7841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB784187F18EB596327499C61A8DA79@CO6PR04MB7841.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQOc7PUHJstMsz8YUlUsjJ4i9G3/VZjAXD6iBWbTbS4xzKRsOhBZiXXjRAWhIug+1JLw6lw7ORk9HmcjBAHrILZ4Q1MibAwBYJfi4RXfKqYflC/sPZf/M6wDjO91zuXL7+oUZ0W+KJfJU3LS2YLUPzvTNzN2r49zXwM45A54V8AAtzBmr6eVBFVwlRMJBNBuTXDfxhR6uH6Szo8JIYjsjVfA6rn5Lvju5mWe0GIAAvFP4CTo91rawjp/5j688zPTEzf4ZG3ANlY70rkTtG0+kEuw64G4zcp/neLWpRmYjG+L7zOYfR9UfVS1QDh5JFr3JC7qLHxdp5hpxZvfbBFeu2YM9KirgIv4OkSm9MCZVv038xobEE/e2UIT3M8uJodUEvaAEPK+xQS8CnZufyZsodTo2g69ne1szJiFxDkW78ou9z+TwZuntEQH/rlzqpLh7VLo85O/WK4KnVbuOTu5fzD6aExKT3w9SlEqz+eZUDoZttVv/BAuR3M/SwXP9/I7HxGZloM4FhLSb8jKIH7b1eZk4BMXX+HOED7LkDp1bS1kba6ZwKFrtkL2IIqy3N/uL40m5t5WhRhDVjfEQMgkZYQS5NptP+M9QY6K41YfdzYdFW9bgLhwodNLJUVx2GJUk1BvPcUk+AYbtL37ZlBNzndf39tXPSNkmrjXYQzD3FQpQ4oJsn4f/y/26qb04uo+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(110136005)(5660300002)(1076003)(66556008)(83380400001)(30864003)(66946007)(66476007)(36756003)(38100700002)(38350700002)(55016002)(86362001)(508600001)(44832011)(8886007)(2906002)(8676002)(956004)(2616005)(7696005)(8936002)(7416002)(4326008)(26005)(52116002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KuBi6unHvIF9VCpD6y4HYb2q859Lvrn8IiPTXHb+BBGPxWP4a6QvGwJZE2pp?=
 =?us-ascii?Q?BvQMzkFRZnWlWOc1If6iMOQ6lbjf6uEe0ONMGspMN8ks1Vqm1UjHrohkLwed?=
 =?us-ascii?Q?jpw65/XtT5oh0mvd2peRLNh9b8MT/O09+dDWIQMjmHbuoM252f5deBBsL9LO?=
 =?us-ascii?Q?5lxwPNuwpVJPmWYMLmwnX1oIxab9shH6BHeRB5AEPlw3kZmiaCGZGgHIxFOF?=
 =?us-ascii?Q?9CRTafyIU075rWtM7AQQYOPw5V4qLj4x/Y5kSE14KkLVg/PztTQvwPBrDmQS?=
 =?us-ascii?Q?41oBRR62isuNxoqQNVxv/m68NxaNfedg7w1B4hCWg+FxSnLMEzZyvAjMlYzV?=
 =?us-ascii?Q?HUtPHh+Bm6jqXWSS7w9epqsb9ef7b/2EuJrqIWLsqJBfvQa+Qbq0J0w+AhxM?=
 =?us-ascii?Q?kb/zv+Ew4eWlOYv+uccDeoBVBF6SlJpQ6Eb50Kb+tSK503WpPvE6p8BapVH+?=
 =?us-ascii?Q?1VwUGO3TQD5u1ECGtfs7uCvwTKDxGhQIieOalZOz8ZE/520kxJOMK2iiasQZ?=
 =?us-ascii?Q?cMjIJoROp8XFhd4s1Ifb8J+iX2lsNQDXtISi66BQFECgdEdlnJJkgRZC9kRW?=
 =?us-ascii?Q?y985D0ZZwuQSzomVXiTZhDc90YtkRWgPrGP12bXCnx1lcV5U1kQ5ch6G5gx2?=
 =?us-ascii?Q?B5wQ81dLpalaHp3EXVEaeFqlbOvuPxqjUBmEiSENjnydZBNle9zcOxpnBQ/i?=
 =?us-ascii?Q?fdecdjOubbhIyDWA0aV3x4uz/L2ZtGtSYAxGJm4LkuRqwkkRiYE8Wr0WzFqR?=
 =?us-ascii?Q?S35KcDLC4umKGQfg2DyoGhFm6y8ncRbf4jQ8tsOCiXRLXtbBL6IOw0Q1vX9S?=
 =?us-ascii?Q?apKoyMGHmDg5StoHw2vVbPzzZnigYVVOe2YPSwS4xcqdfJ2VyA6346hGy0E5?=
 =?us-ascii?Q?GzJvBqWDiwEDs3/lPsisgNI5KcmiGBmkGgA8ItYhcHItJyrZUEkcGfIfIolK?=
 =?us-ascii?Q?bpO3QlfKBdVon9wlTFxtb6FFJ5DErfg0zLq9VG7eto3Hw7XZVq2XYQkgUlav?=
 =?us-ascii?Q?jk20c+uhLfYpFmKlxirf1nbJHGnhcFlnkV4k50fsy96uAYLYhCm0VnHMSWvP?=
 =?us-ascii?Q?4SlPa31yLuEq+LYeUzNHKZ2mCi5psCRM0G207E/pTF/XV0qbek49WiHVNeh6?=
 =?us-ascii?Q?nxGz7yesTk53Q96I3c/aELMEFK3AT1FvtvmG5anV5JkVHQc9nXkccOi1589C?=
 =?us-ascii?Q?mzBx2mZwUhiAWK/PJHgWxIXbJqKkAU5af9r9teXNrMIFUWn/4u+w5wSuqql2?=
 =?us-ascii?Q?1/OGX/nBcGlyJkwr85A15zItxfk/F9340sWRcNQZw3Jn5aAztYpDbzy2YPtD?=
 =?us-ascii?Q?NLQoZqOEQqvn2VATWdRP9qeh?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f688246-9b1e-47b8-fdec-08d981abb18f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:06.9603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3J+CxTBUMxekJh8YFj0RliPeWV5R/j5XzoKBaKzUKuRjxFXqZ+lT1u3SJq05xu/JyYBkxJG80V59qWwt9/OilQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7841
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For KVM RISC-V, we use KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls to access
VCPU config and registers from user-space.

We have three types of VCPU registers:
1. CONFIG - these are VCPU config and capabilities
2. CORE   - these are VCPU general purpose registers
3. CSR    - these are VCPU control and status registers

The CONFIG register available to user-space is ISA. The ISA register is
a read and write register where user-space can only write the desired
VCPU ISA capabilities before running the VCPU.

The CORE registers available to user-space are PC, RA, SP, GP, TP, A0-A7,
T0-T6, S0-S11 and MODE. Most of these are RISC-V general registers except
PC and MODE. The PC register represents program counter whereas the MODE
register represent VCPU privilege mode (i.e. S/U-mode).

The CSRs available to user-space are SSTATUS, SIE, STVEC, SSCRATCH, SEPC,
SCAUSE, STVAL, SIP, and SATP. All of these are read/write registers.

In future, more VCPU register types will be added (such as FP) for the
KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  53 ++++++-
 arch/riscv/kvm/vcpu.c             | 241 +++++++++++++++++++++++++++++-
 2 files changed, 290 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 3d3d703713c6..f7e9dc388d54 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -41,10 +41,61 @@ struct kvm_guest_debug_arch {
 struct kvm_sync_regs {
 };
 
-/* dummy definition */
+/* for KVM_GET_SREGS and KVM_SET_SREGS */
 struct kvm_sregs {
 };
 
+/* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_config {
+	unsigned long isa;
+};
+
+/* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_core {
+	struct user_regs_struct regs;
+	unsigned long mode;
+};
+
+/* Possible privilege modes for kvm_riscv_core */
+#define KVM_RISCV_MODE_S	1
+#define KVM_RISCV_MODE_U	0
+
+/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_csr {
+	unsigned long sstatus;
+	unsigned long sie;
+	unsigned long stvec;
+	unsigned long sscratch;
+	unsigned long sepc;
+	unsigned long scause;
+	unsigned long stval;
+	unsigned long sip;
+	unsigned long satp;
+	unsigned long scounteren;
+};
+
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
+/* If you need to interpret the index values, here is the key: */
+#define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
+#define KVM_REG_RISCV_TYPE_SHIFT	24
+
+/* Config registers are mapped as type 1 */
+#define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CONFIG_REG(name)	\
+	(offsetof(struct kvm_riscv_config, name) / sizeof(unsigned long))
+
+/* Core registers are mapped as type 2 */
+#define KVM_REG_RISCV_CORE		(0x02 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CORE_REG(name)	\
+		(offsetof(struct kvm_riscv_core, name) / sizeof(unsigned long))
+
+/* Control and status registers are mapped as type 3 */
+#define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_REG(name)	\
+		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3342c7305265..a15d97f3e5f6 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
-#include <asm/delay.h>
 #include <asm/hwcap.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
@@ -136,6 +135,220 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
+static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_REG(isa):
+		reg_val = vcpu->arch.isa;
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
+static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_REG(isa):
+		if (!vcpu->arch.ran_atleast_once) {
+			vcpu->arch.isa = reg_val;
+			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
+			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
+		} else {
+			return -EOPNOTSUPP;
+		}
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
+		reg_val = cntx->sepc;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
+		reg_val = ((unsigned long *)cntx)[reg_num];
+	else if (reg_num == KVM_REG_RISCV_CORE_REG(mode))
+		reg_val = (cntx->sstatus & SR_SPP) ?
+				KVM_RISCV_MODE_S : KVM_RISCV_MODE_U;
+	else
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
+		cntx->sepc = reg_val;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
+		((unsigned long *)cntx)[reg_num] = reg_val;
+	else if (reg_num == KVM_REG_RISCV_CORE_REG(mode)) {
+		if (reg_val == KVM_RISCV_MODE_S)
+			cntx->sstatus |= SR_SPP;
+		else
+			cntx->sstatus &= ~SR_SPP;
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
+		kvm_riscv_vcpu_flush_interrupts(vcpu);
+		reg_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
+	} else
+		reg_val = ((unsigned long *)csr)[reg_num];
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
+		reg_val &= VSIP_VALID_MASK;
+		reg_val <<= VSIP_TO_HVIP_SHIFT;
+	}
+
+	((unsigned long *)csr)[reg_num] = reg_val;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
+		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
+		return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
+		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
+		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+
+	return -EINVAL;
+}
+
+static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
+		return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
+		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
+		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+
+	return -EINVAL;
+}
+
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
@@ -160,8 +373,30 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
-	/* TODO: */
-	return -EINVAL;
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	long r = -EINVAL;
+
+	switch (ioctl) {
+	case KVM_SET_ONE_REG:
+	case KVM_GET_ONE_REG: {
+		struct kvm_one_reg reg;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+
+		if (ioctl == KVM_SET_ONE_REG)
+			r = kvm_riscv_vcpu_set_reg(vcpu, &reg);
+		else
+			r = kvm_riscv_vcpu_get_reg(vcpu, &reg);
+		break;
+	}
+	default:
+		break;
+	}
+
+	return r;
 }
 
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD8A38856E
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353095AbhESDiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:38:05 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26363 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353075AbhESDiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395401; x=1652931401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BwSWFJSipeDawyZ3dg550guHDdFqxKJQ10oUIzFnYB0=;
  b=dZNpz5gBwlE0NipAVXh916LYmBXIJ7FCMmx7UaCy4wXPIMLSO8IFdjsf
   ZTULtdLKwxyUuK3xXCm9uhgxy78KBXqGgbR3Vt1W3TqI2JwzJdEYG4qq1
   tEJxo7UZPvWXxOiiFDekk+Xgv/acfGhRVGqcbUavKyLHbADdR0HPgKWU4
   5al9dd3coyeRVhWooszETI+QSyAxPIGr2J9TAni3nTYj4szVU+jJJe2oY
   DIKpMGok8kcUyg9VuOk3rObniaEtBlsUuvPVCjIxXWISmNkfRhDWNWE1F
   udBW92U75LzE4a2G9xYcgMpS6JZE76E3GQsP8aKZ/oI6bNS1CBaPgPCM4
   g==;
IronPort-SDR: MCOqvxeOfFOeWTzxBFdRuhIfczytnYu7/BizqKdE1UeHQ8OuTVGqAoG0GlMBywBvna4ILdGiUN
 46baC4LAhHXqkMdjdwd0yBi8WW2aljr3GPFSZvLCf2zJzhSrp1a0qOyGN3jf0xzwBRQamtJkMa
 m5FfTTwa2bNeEO/vP2tI/JmaTD5sOUYylWqx1ZSRUh5DC6hy1FiKEtBm2toT5y5kwLSQ6GXD7j
 e3dXwBYH1nLnARu0tOApQTlzg/BqxQntLL71H+k/rSS+TBFu6PFo7+KkREDD40ZPysIJRAvRng
 F58=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="167950666"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:36:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZ0H7kR4MJGXtIyoxDDt9ZqSUdZre/0tZQ94Hi7jF5HCUlSY0CUo+PRXOXmNqbmdin3W4YyJAc05efiqkUZXWwg6cyLpPsfwK+XuCspaaVBTUVG+qa5JzBJBUIyGAE4FtVPSLZ3Nm7WxfQMMI43ekj+LyLv/pVPMtJ8radJjH7rrBjm0w0OIgD+PhMvRfDzGX1NM7NF6khUoq/9MTdCuOzPz8WNgKhEg69izav0M+FS28lwgsZFJoNw0zoVijDRFXZLZ8WfruCIfU/qKAU3bfKa7IJkpbLPmUv+P/wkWegUxmfZx+gFoJdnYOdVuVkXqspkiik+87OLmEl47qJnNRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcYBjEyTbRsAoQuHR7Cm4ex9hGgnfjAjZMIZnNp8JDk=;
 b=SL3Ea9T3pQ5vassHFek5Vwb0WLINQr9ez43qm94jIpBQAqs1WwCwdr48yVjS+PpwBrDXBOOd0qUQ3p0OtY4GVL9hf0LaO6pirZUvLEARXDGUP51Z4sDfEilJEDgv7LVUjN5bIq8i7i0cAx4c1kvwrtEj07AEPjyaXqWc7VULG8aJ+HJ+SNflImwP8slb/HSCR/yynK0OhVCTM76/gsPWmTXaNaWRQQTfrWTcBEFz1GbJPFdRiIbIwRRUMcDINCY2V5SOuWOODtJu96H2KWzfvAsI5g3NXPaSPUsl3Mb6OVTEDPl2WbcSCVCT11H980EDRDh7TYcB8sYtrTQ4ddgJyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcYBjEyTbRsAoQuHR7Cm4ex9hGgnfjAjZMIZnNp8JDk=;
 b=D5oRfF4jn6BME/ELDoeN0sB0X+yHHXMYg/utwcGDArNODSo2Kg7SX4wnEuHq85eDrQ1YdCk4IUj5Gne0E3swmDThus1uhZeoEfLoAXtlquDVmM2GOIZaigcCWZYVS2ot+M5+BSpa5K2/6Z2H1+ZzszAH5NX65sLes50EZHu84Ig=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:36:37 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:36:37 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 04/18] RISC-V: KVM: Implement VCPU interrupts and requests handling
Date:   Wed, 19 May 2021 09:05:39 +0530
Message-Id: <20210519033553.1110536-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:36:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7dec459-9702-434d-8486-08d91a774e74
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB776197563E4EBDF1420059F08D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+SDYCzwFTXmJkmnKdmJchWIUpG2ZJrJJBKkY1+RTwixb+niZ3UaAMXPhQ7F0EKYoeCe7SbDiWEjFm2RiVs4zmPioBtyUuJQVdqpFEHaMsHqmmc3FxwPgaBovsoKIvBVdyn1QrUR1ocD7zy1q/aYT7l+pBeog6SlxYpsLO6I7lNuoFWscJLzhIcFkYcB9wG6ms/txm6/GDet8NgaE06QebIxyxCUJMC2Tu3IbytuwoOsnCdivs7FdCqUA5cI5pF73C0gxlWp/MXuf2pUf5fXDgI7S+Jkhz0+JbgYTxoLbUu5/RlQka00UcoKARV68X0v/vmLW61mbhyEmOqW1iqrA74G/hC2VqbckFcXrA/Ugf078piDq5tJD/yYfo+k8mLptvt0KcK/xS+FVsFOssFaNOmcAaOGnoiH3xMTtdWEAnGaJ7bKScjuV/Xs6n5sJI9yvzUAv7NvRgVjw7obvjv7n3RsV9hTFa+rYUei5VadVveCuI1nj5TlxWSN9oC3AaenJA2DAaX9UUxp/hwKjy1IVH8O2VkDyeUNdDmyjnxo28gp5HX5BpnjFCyq5wI+ehWVQ9wq+hHuKrWPnhkQAXkdTRnKC+/OVfUtL0elXV/KlxO/B/WgBojGDIHRHsHxPg7c59J/tSnyH1TweO4iFDXn7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(83380400001)(8676002)(66556008)(36756003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RNqyZbGDlukN/NIRlbVxt3F1VkrpvQWrPHIzRPSPkdu8XZgRAe/Cl4Z35AfH?=
 =?us-ascii?Q?1IHvcsL1cCz3PyRACotMezD+G2O6LNyjZDsBa0FPiNJ3nMGYREclKfW9JlM9?=
 =?us-ascii?Q?cknFRhq06PpynPhhpAZNA8+cYQlp9jMx+CglutcxnaY9NowVHkF42wih/xT4?=
 =?us-ascii?Q?VOXWB1dMlfeaHw9ZSrKe6t8wMXWHk+ArV2F39P7YQICgQV16H4bxEt4foLop?=
 =?us-ascii?Q?Ydj0ZVycGshnq8mntlg/pLE7GPHRH0o/8W7id1eKDMp6xImbapDQdvm88BFH?=
 =?us-ascii?Q?kyU51STVlmhF41njev0f77Y+axv7y0SXNzdhcKexD+9T9J4ovb5N0dlUk68L?=
 =?us-ascii?Q?VfGBviEqbJwtp+lmlAeAbZJG6rSxJHpvs/7g3H8OTTdy7JPuLoj4w0Lb/n+W?=
 =?us-ascii?Q?gyHF6XShJJzzRmsS1YyumH40b7D8h2YJM4e9HTnnSBoiCPYo5ue/t8mMfvI5?=
 =?us-ascii?Q?AgNBB7vYmeiuqS4tr+J8hLzNHrrCBfU/eSfbD40EOh1c31cYDszWOWGYg0yX?=
 =?us-ascii?Q?2zG6QYKhVG3tK0oAEqDG8k/Bqn1CDxQ44XkavNulwbrv6IuCgySO+1Izy56W?=
 =?us-ascii?Q?+X5339MGbU5bh2dbGATjvrdpWaLIk3tdvhgX2Qi1t1FA6XP72C5KVl0L4lPW?=
 =?us-ascii?Q?CTkZxQArYduhnfOXXU+2XoF4yxYIQ/vFt9Ms3yXh9s8m2DuQQq4bKMHQVutD?=
 =?us-ascii?Q?gbJIWv0VfkFk1wiDT7766ADGWdgX+YfCreD8y9QnRvMOE8W+c52BAVF1m+MA?=
 =?us-ascii?Q?iVzFcOcgCb1BGISI+LM79eJ2+uXamsMpuRDExb5R0zGprzhF89yOIFLb+u+r?=
 =?us-ascii?Q?Rodhz+T9XwY3PjXseNbwxzgpvWdwVC9Qy36cNeb+wXBEEHnj3xidwScKKl6Z?=
 =?us-ascii?Q?Kk0nO15LdrjcKRspRSVurOD2KVsgqV1GSqMGYoSbt7jwklYyvuXZnhqSnzLC?=
 =?us-ascii?Q?eWQ/5Xs+NkMqBy6I+SvDCNQHnyFaLKAnb5WyUfv+kPWTJJvWNvZ2rnGCYdpX?=
 =?us-ascii?Q?lZUZwOaGZJQLrdlbVq1hWw/Jt5GQ93AhuQA2m48pjW4GKCM9gTzJ5HSyFQr5?=
 =?us-ascii?Q?c6btnIz+B9Aj9rTrtNrJGLXyK0B9WamRK6UFoVk6SBz7JwUKp1ElnA9FSiaD?=
 =?us-ascii?Q?7bJg7LYTPPIbPVCwakHiwHRcM4sRW5rbQEd73nJvUtFYtbCiIK9cm9S/cBP7?=
 =?us-ascii?Q?SqoOINz5Y8amFqkKs1Xsk22J88J1OlgX5Z12PzxuED2ginj/TzVk1ctgEBv8?=
 =?us-ascii?Q?ZMPl8ZBgseEvbi72zZZETCyH+/avPQIGED789LDTB8b5UGcIHwRiD/oKJDgR?=
 =?us-ascii?Q?oTdGHLP9vOY9iU5naTSo41Ob?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7dec459-9702-434d-8486-08d91a774e74
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:36:37.0798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PjMYmeD9iIAj5HLQ+OTG2Im0bu17LPnvPdh6dwZkzK64pCYW3ugIGC5Q4YNPt4KODqr2pzXt2Ttj7MXPzMakjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements VCPU interrupts and requests which are both
asynchronous events.

The VCPU interrupts can be set/unset using KVM_INTERRUPT ioctl from
user-space. In future, the in-kernel IRQCHIP emulation will use
kvm_riscv_vcpu_set_interrupt() and kvm_riscv_vcpu_unset_interrupt()
functions to set/unset VCPU interrupts.

Important VCPU requests implemented by this patch are:
KVM_REQ_SLEEP       - set whenever VCPU itself goes to sleep state
KVM_REQ_VCPU_RESET  - set whenever VCPU reset is requested

The WFI trap-n-emulate (added later) will use KVM_REQ_SLEEP request
and kvm_riscv_vcpu_has_interrupt() function.

The KVM_REQ_VCPU_RESET request will be used by SBI emulation (added
later) to power-up a VCPU in power-off state. The user-space can use
the GET_MPSTATE/SET_MPSTATE ioctls to get/set power state of a VCPU.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  23 ++++
 arch/riscv/include/uapi/asm/kvm.h |   3 +
 arch/riscv/kvm/vcpu.c             | 182 +++++++++++++++++++++++++++---
 3 files changed, 195 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index cf2a23bbd560..5e1c3140e49d 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -132,6 +132,21 @@ struct kvm_vcpu_arch {
 	/* CPU CSR context upon Guest VCPU reset */
 	struct kvm_vcpu_csr guest_reset_csr;
 
+	/*
+	 * VCPU interrupts
+	 *
+	 * We have a lockless approach for tracking pending VCPU interrupts
+	 * implemented using atomic bitops. The irqs_pending bitmap represent
+	 * pending interrupts whereas irqs_pending_mask represent bits changed
+	 * in irqs_pending. Our approach is modeled around multiple producer
+	 * and single consumer problem where the consumer is the VCPU itself.
+	 */
+	unsigned long irqs_pending;
+	unsigned long irqs_pending_mask;
+
+	/* VCPU power-off state */
+	bool power_off;
+
 	/* Don't run the VCPU (blocked) */
 	bool pause;
 
@@ -155,4 +170,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
 
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
+void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 984d041a3e3b..3d3d703713c6 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -18,6 +18,9 @@
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
+#define KVM_INTERRUPT_SET	-1U
+#define KVM_INTERRUPT_UNSET	-2U
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 };
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 904d908a7544..1c3c3bd72df9 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -11,6 +11,7 @@
 #include <linux/err.h>
 #include <linux/kdebug.h>
 #include <linux/module.h>
+#include <linux/percpu.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/signal.h>
@@ -54,6 +55,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	memcpy(csr, reset_csr, sizeof(*csr));
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
+	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
@@ -97,8 +101,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -111,20 +114,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
+		!vcpu->arch.power_off && !vcpu->arch.pause);
 }
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return false;
+	return (vcpu->arch.guest_context.sstatus & SR_SPP) ? true : false;
 }
 
 vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
@@ -135,7 +136,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
-	/* TODO; */
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+
+	if (ioctl == KVM_INTERRUPT) {
+		struct kvm_interrupt irq;
+
+		if (copy_from_user(&irq, argp, sizeof(irq)))
+			return -EFAULT;
+
+		if (irq.irq == KVM_INTERRUPT_SET)
+			return kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_EXT);
+		else
+			return kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
+	}
+
 	return -ENOIOCTLCMD;
 }
 
@@ -184,18 +199,121 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
+void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long mask, val;
+
+	if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
+		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
+		val = READ_ONCE(vcpu->arch.irqs_pending) & mask;
+
+		csr->hvip &= ~mask;
+		csr->hvip |= val;
+	}
+}
+
+void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
+{
+	unsigned long hvip;
+	struct kvm_vcpu_arch *v = &vcpu->arch;
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	/* Read current HVIP and HIE CSRs */
+	hvip = csr_read(CSR_HVIP);
+	csr->hie = csr_read(CSR_HIE);
+
+	/* Sync-up HVIP.VSSIP bit changes does by Guest */
+	if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
+		if (hvip & (1UL << IRQ_VS_SOFT)) {
+			if (!test_and_set_bit(IRQ_VS_SOFT,
+					      &v->irqs_pending_mask))
+				set_bit(IRQ_VS_SOFT, &v->irqs_pending);
+		} else {
+			if (!test_and_set_bit(IRQ_VS_SOFT,
+					      &v->irqs_pending_mask))
+				clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
+		}
+	}
+}
+
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
+{
+	if (irq != IRQ_VS_SOFT &&
+	    irq != IRQ_VS_TIMER &&
+	    irq != IRQ_VS_EXT)
+		return -EINVAL;
+
+	set_bit(irq, &vcpu->arch.irqs_pending);
+	smp_mb__before_atomic();
+	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+
+	kvm_vcpu_kick(vcpu);
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
+{
+	if (irq != IRQ_VS_SOFT &&
+	    irq != IRQ_VS_TIMER &&
+	    irq != IRQ_VS_EXT)
+		return -EINVAL;
+
+	clear_bit(irq, &vcpu->arch.irqs_pending);
+	smp_mb__before_atomic();
+	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+
+	return 0;
+}
+
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask)
+{
+	return (READ_ONCE(vcpu->arch.irqs_pending) &
+		vcpu->arch.guest_csr.hie & mask) ? true : false;
+}
+
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.power_off = true;
+	kvm_make_request(KVM_REQ_SLEEP, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.power_off = false;
+	kvm_vcpu_wake_up(vcpu);
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	/* TODO: */
+	if (vcpu->arch.power_off)
+		mp_state->mp_state = KVM_MP_STATE_STOPPED;
+	else
+		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+
 	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	/* TODO: */
-	return 0;
+	int ret = 0;
+
+	switch (mp_state->mp_state) {
+	case KVM_MP_STATE_RUNNABLE:
+		vcpu->arch.power_off = false;
+		break;
+	case KVM_MP_STATE_STOPPED:
+		kvm_riscv_vcpu_power_off(vcpu);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
 }
 
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
@@ -219,7 +337,33 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
+
+	if (kvm_request_pending(vcpu)) {
+		if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
+			rcuwait_wait_event(wait,
+				(!vcpu->arch.power_off) && (!vcpu->arch.pause),
+				TASK_INTERRUPTIBLE);
+
+			if (vcpu->arch.power_off || vcpu->arch.pause) {
+				/*
+				 * Awaken to handle a signal, request to
+				 * sleep again later.
+				 */
+				kvm_make_request(KVM_REQ_SLEEP, vcpu);
+			}
+		}
+
+		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+			kvm_riscv_reset_vcpu(vcpu);
+	}
+}
+
+static void kvm_riscv_update_hvip(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	csr_write(CSR_HVIP, csr->hvip);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
@@ -283,6 +427,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
 		smp_mb__after_srcu_read_unlock();
 
+		/*
+		 * We might have got VCPU interrupts updated asynchronously
+		 * so update it in HW.
+		 */
+		kvm_riscv_vcpu_flush_interrupts(vcpu);
+
+		/* Update HVIP CSR for current CPU */
+		kvm_riscv_update_hvip(vcpu);
+
 		if (ret <= 0 ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
@@ -310,6 +463,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		trap.htval = csr_read(CSR_HTVAL);
 		trap.htinst = csr_read(CSR_HTINST);
 
+		/* Syncup interrupts state with HW */
+		kvm_riscv_vcpu_sync_interrupts(vcpu);
+
 		/*
 		 * We may have taken a host interrupt in VS/VU-mode (i.e.
 		 * while executing the guest). This interrupt is still
-- 
2.25.1


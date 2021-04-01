Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C31351AB9
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbhDASCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:54 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24190 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237171AbhDAR7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617299983; x=1648835983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LrzeSSAMnw87FzigHk/ucho0hz2kh71gED4RVNKmibM=;
  b=QePI1kTmN4CacdpD5vUQWvr0mnfslZcUwMpoAATKixxHIOLe8fAbQR2p
   fJ2ky3vmKy5i99V+qN476LHvMG18yqyQx2DGTvYefo3af0LwN5FsALCaG
   FlYBIemxBh6gWKz74f2E5i747mtmYnFDF5KSasE40RA7aboN2Ag8sMUdD
   T/fr7RYAtlIPLzbW7VG2yG8YlCLC2SWigW2cPYITsk99ISrYelozRJl+m
   3pdTpx/dADaF/Mfd5rcWoZ4CZXTLuTob9d0AaYgvkkQHbwtrru+ulGIX1
   hDd+dXefgNKn35fokbX0aVvjclVmOCYwoygRbJdgfEwt9GT2zufL2HOu3
   w==;
IronPort-SDR: pFBbLCP6pAPJQwsH63QISefk5UYt0sWx+LTjR5hIEpmih92dsY9zPG1CcybJiKlVK4f0lCiPHH
 1UItxnv23i+t8Fsv2eCUWI5wt30Wii5cQmthunC1J8BqvUvSsM8ggxSZjgp0SFQ0KQdess+xI3
 nmdO9ykNf+oe9iYxehBLhVDcVc8UGaSDd8Cz66QNfe/MnPI4uTvYLchvyG33qAnYzPlH0vWJNE
 FvOao/bGW9cDdsSHqROFYIM1GHXBFnku0OsPGGfkCkmBAcsS7idMWi7TDFuA+6iS0ceCk98reZ
 Fqk=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168041418"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:37:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8TeDiWMsKRu8cXSVLiVXXStLAnKIkEO/q0L+i2CTBmUScwScsybU4bJ50mw6sFprtSL3d4urnb8i/w1+AyTvJPL0UjgDhbuUWY+yDItKtEQDg9kGsmLhr8zhklv6a8LKvgo6tVDLj2Q8BAxi115fhvARU0juG36oL567z4l3mPgKTzjhvEU9JniYmnuJ5f4vwGwl3YFiMJ9Fj1B7jOPUBzyJ56pObNiTguFlZGhpeL4717OW7CTDqL0Jf4L9XcxmTFRZshpjprvPGzCG2Yg8t38OCOkOzqi4JIt/fjSBfulqK1hGJFGAa3VFPlQaXR0jC2nYKDKIV9xsUH4sHT6lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oSErAGcA8QLCqsopc0ngvg/fBGOoWzIbJDYX3JBTGA=;
 b=SxqBxX1nU+ch+X/SdmLoBB7AiqAmhwgLzvSJ6eo6Tn/xeq06v2rKnNFX5q/raTqQsz9zsyBRlDLaNh0J1tn04uDSj0glZ2+rjJQN8OuNxC1yModipwMvil8l6S+icmg/bOLjZECbMYvtOm7wP/0cXDio2v2McbW7Pyue4pRi32+/br2IKP1BKUwZcPbt/KWxQTQYeAHJA3hgJN57a1QKdtbOzy9UplMTw7bT5IZoPgFBqH1l1JhynCtCj9TyUTpLqYeSy7rTziy92yHAsYbGrFx8odicy2vQt4gNEBCASMhkdJ3B5H/LWbOK0a1zsYBp1fJFepxRjlOx8XDdosJ/uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oSErAGcA8QLCqsopc0ngvg/fBGOoWzIbJDYX3JBTGA=;
 b=WtbhHfDQf0nS29YvVgx27DUragcwHB9efoxbmTnAMhI4hm0e2vP5qoumfDzVEVGjfyaWk16wv7VjQHGQBH2B+GCZwOk38nHOZKxcgMR7GY9ztmO4d8y8rH4qQMqM4PRbBuyI4USp943QKOIcHBYjRdTu2neX8ow+Ac2+egAsPLE=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:36:50 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:36:50 +0000
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
Subject: [PATCH v17 06/17] RISC-V: KVM: Implement VCPU world-switch
Date:   Thu,  1 Apr 2021 19:04:24 +0530
Message-Id: <20210401133435.383959-7-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401133435.383959-1-anup.patel@wdc.com>
References: <20210401133435.383959-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:36:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aab4fe60-dd84-468f-586c-08d8f51333ee
X-MS-TrafficTypeDiagnostic: DM6PR04MB6528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB65282C5D72A1DD16CAC505FF8D7B9@DM6PR04MB6528.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7fDWs19+U1VxSsJt0TaQkUeQYuJJKQxM0DJh8qhAzUSGSctWsjUGXT+Xt1YBJXDTSOFiWxHckyx8M9Aja2w9lUuMy8hB5chSPZNvB6XTzcrFaiLu100W6ZWmjfphCQP2NAG2+E8bnLq1zWFK6an5rj2A3buB5g3hHgo8SajHNsE2yEv8vRj2XeAd/qokBFKZ2OPMMiBGzTQs8URpsbpA2MpbA0YzTyWVysk8yOI4VY7hT3clWEWGj72S3j68vyPghvK7Zn//ON6Sl+QT9lIDyvZzAWFNOfnE25+FRUtlOvfnjbMT+Nd9ebvm/AZLos7LW9rVJVvVLK4rgOmXVYgXae9xMltwA8pv5MUVRnf6oTGh/xReMo9kqGYrQziLm0OfdOva7TRls7xDB3RuiVexAFeVVn3/O848wHc8kz/hbVRP6A3ZeDOuUhDvpLY2ezIT/3QbNelLM1lYrB6eJGMW6ebvCGKBTHDvqJaKkUbES4dbgyxde2GeVFuhQxUgaisi6Q9Lj1dnmPSyFk77nkvURuGY4akiyJu2fTGk9mCEL2AUCe2TbWeyZm5A09E6R/wEqa12JUT34LqILRyvm4VauqVBGSqqBIgA3Dfv4BWXN1fGCQuE2ChmnwL0DSQZPHg0OpCycnmMMjmZR4SsD5CHMJXUxxhTMjipHk5Eh1ChbY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(8886007)(16526019)(36756003)(186003)(4326008)(956004)(2616005)(6666004)(316002)(66556008)(478600001)(26005)(66476007)(2906002)(54906003)(7416002)(1076003)(8936002)(55016002)(86362001)(83380400001)(8676002)(52116002)(110136005)(7696005)(5660300002)(38100700001)(30864003)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9m0/d1CE6LlyzbMqXfYkPyii77L4Q7ETt/8vbw8UhbRyKhWXqKVyTO+vPAsA?=
 =?us-ascii?Q?YQqKiGBa+fvPFZs+AVkk1ik5NfYy/HIWgcpt55/OGUW1vwQ7rTMq+xNagYJy?=
 =?us-ascii?Q?GLA1DIr4X18v/in7ny5C8QPE0gyachM2qXmrzKLdJqXNRthIDrVE3O3kWmuu?=
 =?us-ascii?Q?uftfuESmeITlaBl70Ro56inU5/bJqsX7bOLrebdw/CrnLc3Uc3ml9Cfyrhou?=
 =?us-ascii?Q?MHVw38t5vZE1kguoh7Z7veTRqcABgW7lAoO9U1NjnlXOaB7HFt5c7unnIeKN?=
 =?us-ascii?Q?XB3NOVLPvduYKsmH1USIqhMAjn1tKyWCcP7ZiDNJRzmKCqq3Pd3m9LfkJz3e?=
 =?us-ascii?Q?EfwEyBENXfJ06vGXwllyAZb6TU6slhykq2g47oCQHQ8I/bmepYBAtUVGmn2r?=
 =?us-ascii?Q?o8V8HJ5Ncc8DCfYjGjZ9p/fCAN08M7uvcZ/py8lhscXnzGLl4vEvo3+9c+Tg?=
 =?us-ascii?Q?HuKXfPHhZg53aRiRSBwZDnLEwNnx53gsvjzGEkXyigl7EgEsU1fhRzCIXynC?=
 =?us-ascii?Q?vR1EfVn/VVf03yG/i/Q+WDEIoT7YwtJFRH2yuj+hx4i7+XQaurj9+UPmLn8P?=
 =?us-ascii?Q?gxQ1iqZ2DQkpx4E8QPrH8PPQuOtRuMpLGFPfg5iteNgPYP69g33lSDop+GWr?=
 =?us-ascii?Q?XOrF/LXmdzi/HMuRMQW5qMbW0BZ/TzKtFPztSQZngcwxoR7OsuqWP6A6jV5T?=
 =?us-ascii?Q?nzzQ07ZnoFC3psse8gGYxjhXpAI20qXxt/wrTM1rvePvlRx4Z0aJYYKzQfId?=
 =?us-ascii?Q?e8Jm/h/nKumZ3zLMSZWopDs7JygD4+4ug/DLL3p9HxgkyX6vj3+SVys8urxc?=
 =?us-ascii?Q?VbV3VwbBDbgeBpnZHe8V2PXMzQMrd+JRKrkfFjSqEqVsJqD88BgDJvfud8zX?=
 =?us-ascii?Q?gYsg25c+zDYRYx0ZkyQ0oKv+aC80IdIp/R7rXqEBssrQq0u/GiWle2Rjuly5?=
 =?us-ascii?Q?hSEOapZ96rbmpkSAeC8RSBhDyuWn3OMVUySJ+/wuNj1pvY4SuuJJYrpNcNNL?=
 =?us-ascii?Q?UP37oi/nSYiKBUUzwDtiAXsk6Qyi6P0pSNZMLWZv9S7ffC3zSIFJx0CVFv1V?=
 =?us-ascii?Q?NU4UFxACANzLraL/YUgCbbRU0HpVJSrOXZgnTDhX/LH7HsYJ8tdPeCWnRzfj?=
 =?us-ascii?Q?sIrfffGqkR5MGmtKAt9zMdBAnOB3RqtiridINhMNeRXIxvxAA3iwOqTm9sH4?=
 =?us-ascii?Q?UhW3pe+M02F0H9xUOdqHPx3cX8I4gTCjjTo8JGn21u6m+w/kj4bUBBJl1rIF?=
 =?us-ascii?Q?0pBRCyipoidNwDK7Lyq/XdUYfMdP+X7RHR6NEbHJGjD7sVSRr5KK2n+RgZOy?=
 =?us-ascii?Q?SdMOh1qUs8ICqPd5rux4UulqVnTm7J4dg68RRcFNM7DjDQ=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab4fe60-dd84-468f-586c-08d8f51333ee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:36:49.9066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eR2g9AAGlSw0fq5sQ2jxQ4OrZFG2f5UDXtHjQRd/ljCb/0UPIobxQwSUqU0ZgfgznszSfuh++iWZGuhYqHOzNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements the VCPU world-switch for KVM RISC-V.

The KVM RISC-V world-switch (i.e. __kvm_riscv_switch_to()) mostly
switches general purpose registers, SSTATUS, STVEC, SSCRATCH and
HSTATUS CSRs. Other CSRs are switched via vcpu_load() and vcpu_put()
interface in kvm_arch_vcpu_load() and kvm_arch_vcpu_put() functions
respectively.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  10 +-
 arch/riscv/kernel/asm-offsets.c   |  78 ++++++++++++
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu.c             |  30 ++++-
 arch/riscv/kvm/vcpu_switch.S      | 203 ++++++++++++++++++++++++++++++
 5 files changed, 319 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_switch.S

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 1bf660b1a9d8..ca9b8dfcd406 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -120,6 +120,14 @@ struct kvm_vcpu_arch {
 	/* ISA feature bits (similar to MISA) */
 	unsigned long isa;
 
+	/* SSCRATCH, STVEC, and SCOUNTEREN of Host */
+	unsigned long host_sscratch;
+	unsigned long host_stvec;
+	unsigned long host_scounteren;
+
+	/* CPU context of Host */
+	struct kvm_cpu_context host_context;
+
 	/* CPU context of Guest VCPU */
 	struct kvm_cpu_context guest_context;
 
@@ -169,7 +177,7 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
-static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
+void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 9ef33346853c..21f867d35b65 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -7,7 +7,9 @@
 #define GENERATING_ASM_OFFSETS
 
 #include <linux/kbuild.h>
+#include <linux/mm.h>
 #include <linux/sched.h>
+#include <asm/kvm_host.h>
 #include <asm/thread_info.h>
 #include <asm/ptrace.h>
 
@@ -111,6 +113,82 @@ void asm_offsets(void)
 	OFFSET(PT_BADADDR, pt_regs, badaddr);
 	OFFSET(PT_CAUSE, pt_regs, cause);
 
+	OFFSET(KVM_ARCH_GUEST_ZERO, kvm_vcpu_arch, guest_context.zero);
+	OFFSET(KVM_ARCH_GUEST_RA, kvm_vcpu_arch, guest_context.ra);
+	OFFSET(KVM_ARCH_GUEST_SP, kvm_vcpu_arch, guest_context.sp);
+	OFFSET(KVM_ARCH_GUEST_GP, kvm_vcpu_arch, guest_context.gp);
+	OFFSET(KVM_ARCH_GUEST_TP, kvm_vcpu_arch, guest_context.tp);
+	OFFSET(KVM_ARCH_GUEST_T0, kvm_vcpu_arch, guest_context.t0);
+	OFFSET(KVM_ARCH_GUEST_T1, kvm_vcpu_arch, guest_context.t1);
+	OFFSET(KVM_ARCH_GUEST_T2, kvm_vcpu_arch, guest_context.t2);
+	OFFSET(KVM_ARCH_GUEST_S0, kvm_vcpu_arch, guest_context.s0);
+	OFFSET(KVM_ARCH_GUEST_S1, kvm_vcpu_arch, guest_context.s1);
+	OFFSET(KVM_ARCH_GUEST_A0, kvm_vcpu_arch, guest_context.a0);
+	OFFSET(KVM_ARCH_GUEST_A1, kvm_vcpu_arch, guest_context.a1);
+	OFFSET(KVM_ARCH_GUEST_A2, kvm_vcpu_arch, guest_context.a2);
+	OFFSET(KVM_ARCH_GUEST_A3, kvm_vcpu_arch, guest_context.a3);
+	OFFSET(KVM_ARCH_GUEST_A4, kvm_vcpu_arch, guest_context.a4);
+	OFFSET(KVM_ARCH_GUEST_A5, kvm_vcpu_arch, guest_context.a5);
+	OFFSET(KVM_ARCH_GUEST_A6, kvm_vcpu_arch, guest_context.a6);
+	OFFSET(KVM_ARCH_GUEST_A7, kvm_vcpu_arch, guest_context.a7);
+	OFFSET(KVM_ARCH_GUEST_S2, kvm_vcpu_arch, guest_context.s2);
+	OFFSET(KVM_ARCH_GUEST_S3, kvm_vcpu_arch, guest_context.s3);
+	OFFSET(KVM_ARCH_GUEST_S4, kvm_vcpu_arch, guest_context.s4);
+	OFFSET(KVM_ARCH_GUEST_S5, kvm_vcpu_arch, guest_context.s5);
+	OFFSET(KVM_ARCH_GUEST_S6, kvm_vcpu_arch, guest_context.s6);
+	OFFSET(KVM_ARCH_GUEST_S7, kvm_vcpu_arch, guest_context.s7);
+	OFFSET(KVM_ARCH_GUEST_S8, kvm_vcpu_arch, guest_context.s8);
+	OFFSET(KVM_ARCH_GUEST_S9, kvm_vcpu_arch, guest_context.s9);
+	OFFSET(KVM_ARCH_GUEST_S10, kvm_vcpu_arch, guest_context.s10);
+	OFFSET(KVM_ARCH_GUEST_S11, kvm_vcpu_arch, guest_context.s11);
+	OFFSET(KVM_ARCH_GUEST_T3, kvm_vcpu_arch, guest_context.t3);
+	OFFSET(KVM_ARCH_GUEST_T4, kvm_vcpu_arch, guest_context.t4);
+	OFFSET(KVM_ARCH_GUEST_T5, kvm_vcpu_arch, guest_context.t5);
+	OFFSET(KVM_ARCH_GUEST_T6, kvm_vcpu_arch, guest_context.t6);
+	OFFSET(KVM_ARCH_GUEST_SEPC, kvm_vcpu_arch, guest_context.sepc);
+	OFFSET(KVM_ARCH_GUEST_SSTATUS, kvm_vcpu_arch, guest_context.sstatus);
+	OFFSET(KVM_ARCH_GUEST_HSTATUS, kvm_vcpu_arch, guest_context.hstatus);
+	OFFSET(KVM_ARCH_GUEST_SCOUNTEREN, kvm_vcpu_arch, guest_csr.scounteren);
+
+	OFFSET(KVM_ARCH_HOST_ZERO, kvm_vcpu_arch, host_context.zero);
+	OFFSET(KVM_ARCH_HOST_RA, kvm_vcpu_arch, host_context.ra);
+	OFFSET(KVM_ARCH_HOST_SP, kvm_vcpu_arch, host_context.sp);
+	OFFSET(KVM_ARCH_HOST_GP, kvm_vcpu_arch, host_context.gp);
+	OFFSET(KVM_ARCH_HOST_TP, kvm_vcpu_arch, host_context.tp);
+	OFFSET(KVM_ARCH_HOST_T0, kvm_vcpu_arch, host_context.t0);
+	OFFSET(KVM_ARCH_HOST_T1, kvm_vcpu_arch, host_context.t1);
+	OFFSET(KVM_ARCH_HOST_T2, kvm_vcpu_arch, host_context.t2);
+	OFFSET(KVM_ARCH_HOST_S0, kvm_vcpu_arch, host_context.s0);
+	OFFSET(KVM_ARCH_HOST_S1, kvm_vcpu_arch, host_context.s1);
+	OFFSET(KVM_ARCH_HOST_A0, kvm_vcpu_arch, host_context.a0);
+	OFFSET(KVM_ARCH_HOST_A1, kvm_vcpu_arch, host_context.a1);
+	OFFSET(KVM_ARCH_HOST_A2, kvm_vcpu_arch, host_context.a2);
+	OFFSET(KVM_ARCH_HOST_A3, kvm_vcpu_arch, host_context.a3);
+	OFFSET(KVM_ARCH_HOST_A4, kvm_vcpu_arch, host_context.a4);
+	OFFSET(KVM_ARCH_HOST_A5, kvm_vcpu_arch, host_context.a5);
+	OFFSET(KVM_ARCH_HOST_A6, kvm_vcpu_arch, host_context.a6);
+	OFFSET(KVM_ARCH_HOST_A7, kvm_vcpu_arch, host_context.a7);
+	OFFSET(KVM_ARCH_HOST_S2, kvm_vcpu_arch, host_context.s2);
+	OFFSET(KVM_ARCH_HOST_S3, kvm_vcpu_arch, host_context.s3);
+	OFFSET(KVM_ARCH_HOST_S4, kvm_vcpu_arch, host_context.s4);
+	OFFSET(KVM_ARCH_HOST_S5, kvm_vcpu_arch, host_context.s5);
+	OFFSET(KVM_ARCH_HOST_S6, kvm_vcpu_arch, host_context.s6);
+	OFFSET(KVM_ARCH_HOST_S7, kvm_vcpu_arch, host_context.s7);
+	OFFSET(KVM_ARCH_HOST_S8, kvm_vcpu_arch, host_context.s8);
+	OFFSET(KVM_ARCH_HOST_S9, kvm_vcpu_arch, host_context.s9);
+	OFFSET(KVM_ARCH_HOST_S10, kvm_vcpu_arch, host_context.s10);
+	OFFSET(KVM_ARCH_HOST_S11, kvm_vcpu_arch, host_context.s11);
+	OFFSET(KVM_ARCH_HOST_T3, kvm_vcpu_arch, host_context.t3);
+	OFFSET(KVM_ARCH_HOST_T4, kvm_vcpu_arch, host_context.t4);
+	OFFSET(KVM_ARCH_HOST_T5, kvm_vcpu_arch, host_context.t5);
+	OFFSET(KVM_ARCH_HOST_T6, kvm_vcpu_arch, host_context.t6);
+	OFFSET(KVM_ARCH_HOST_SEPC, kvm_vcpu_arch, host_context.sepc);
+	OFFSET(KVM_ARCH_HOST_SSTATUS, kvm_vcpu_arch, host_context.sstatus);
+	OFFSET(KVM_ARCH_HOST_HSTATUS, kvm_vcpu_arch, host_context.hstatus);
+	OFFSET(KVM_ARCH_HOST_SSCRATCH, kvm_vcpu_arch, host_sscratch);
+	OFFSET(KVM_ARCH_HOST_STVEC, kvm_vcpu_arch, host_stvec);
+	OFFSET(KVM_ARCH_HOST_SCOUNTEREN, kvm_vcpu_arch, host_scounteren);
+
 	/*
 	 * THREAD_{F,X}* might be larger than a S-type offset can handle, but
 	 * these are used in performance-sensitive assembly so we can't resort
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 37b5a59d4f4f..845579273727 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -8,6 +8,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
 kvm-objs := $(common-objs-y)
 
-kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o
+kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 551359c9136c..bf42afad9d9d 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -565,14 +565,40 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	/* TODO: */
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	csr_write(CSR_VSSTATUS, csr->vsstatus);
+	csr_write(CSR_HIE, csr->hie);
+	csr_write(CSR_VSTVEC, csr->vstvec);
+	csr_write(CSR_VSSCRATCH, csr->vsscratch);
+	csr_write(CSR_VSEPC, csr->vsepc);
+	csr_write(CSR_VSCAUSE, csr->vscause);
+	csr_write(CSR_VSTVAL, csr->vstval);
+	csr_write(CSR_HVIP, csr->hvip);
+	csr_write(CSR_VSATP, csr->vsatp);
 
 	kvm_riscv_stage2_update_hgatp(vcpu);
+
+	vcpu->cpu = cpu;
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	vcpu->cpu = -1;
+
+	csr_write(CSR_HGATP, 0);
+
+	csr->vsstatus = csr_read(CSR_VSSTATUS);
+	csr->hie = csr_read(CSR_HIE);
+	csr->vstvec = csr_read(CSR_VSTVEC);
+	csr->vsscratch = csr_read(CSR_VSSCRATCH);
+	csr->vsepc = csr_read(CSR_VSEPC);
+	csr->vscause = csr_read(CSR_VSCAUSE);
+	csr->vstval = csr_read(CSR_VSTVAL);
+	csr->hvip = csr_read(CSR_HVIP);
+	csr->vsatp = csr_read(CSR_VSATP);
 }
 
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
new file mode 100644
index 000000000000..5174b025ff4e
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -0,0 +1,203 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
+#include <asm/csr.h>
+
+	.text
+	.altmacro
+	.option norelax
+
+ENTRY(__kvm_riscv_switch_to)
+	/* Save Host GPRs (except A0 and T0-T6) */
+	REG_S	ra, (KVM_ARCH_HOST_RA)(a0)
+	REG_S	sp, (KVM_ARCH_HOST_SP)(a0)
+	REG_S	gp, (KVM_ARCH_HOST_GP)(a0)
+	REG_S	tp, (KVM_ARCH_HOST_TP)(a0)
+	REG_S	s0, (KVM_ARCH_HOST_S0)(a0)
+	REG_S	s1, (KVM_ARCH_HOST_S1)(a0)
+	REG_S	a1, (KVM_ARCH_HOST_A1)(a0)
+	REG_S	a2, (KVM_ARCH_HOST_A2)(a0)
+	REG_S	a3, (KVM_ARCH_HOST_A3)(a0)
+	REG_S	a4, (KVM_ARCH_HOST_A4)(a0)
+	REG_S	a5, (KVM_ARCH_HOST_A5)(a0)
+	REG_S	a6, (KVM_ARCH_HOST_A6)(a0)
+	REG_S	a7, (KVM_ARCH_HOST_A7)(a0)
+	REG_S	s2, (KVM_ARCH_HOST_S2)(a0)
+	REG_S	s3, (KVM_ARCH_HOST_S3)(a0)
+	REG_S	s4, (KVM_ARCH_HOST_S4)(a0)
+	REG_S	s5, (KVM_ARCH_HOST_S5)(a0)
+	REG_S	s6, (KVM_ARCH_HOST_S6)(a0)
+	REG_S	s7, (KVM_ARCH_HOST_S7)(a0)
+	REG_S	s8, (KVM_ARCH_HOST_S8)(a0)
+	REG_S	s9, (KVM_ARCH_HOST_S9)(a0)
+	REG_S	s10, (KVM_ARCH_HOST_S10)(a0)
+	REG_S	s11, (KVM_ARCH_HOST_S11)(a0)
+
+	/* Save Host and Restore Guest SSTATUS */
+	REG_L	t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	csrrw	t0, CSR_SSTATUS, t0
+	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
+
+	/* Save Host and Restore Guest HSTATUS */
+	REG_L	t1, (KVM_ARCH_GUEST_HSTATUS)(a0)
+	csrrw	t1, CSR_HSTATUS, t1
+	REG_S	t1, (KVM_ARCH_HOST_HSTATUS)(a0)
+
+	/* Save Host and Restore Guest SCOUNTEREN */
+	REG_L	t2, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
+	csrrw	t2, CSR_SCOUNTEREN, t2
+	REG_S	t2, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
+
+	/* Save Host SSCRATCH and change it to struct kvm_vcpu_arch pointer */
+	csrrw	t3, CSR_SSCRATCH, a0
+	REG_S	t3, (KVM_ARCH_HOST_SSCRATCH)(a0)
+
+	/* Save Host STVEC and change it to return path */
+	la	t4, __kvm_switch_return
+	csrrw	t4, CSR_STVEC, t4
+	REG_S	t4, (KVM_ARCH_HOST_STVEC)(a0)
+
+	/* Restore Guest SEPC */
+	REG_L	t0, (KVM_ARCH_GUEST_SEPC)(a0)
+	csrw	CSR_SEPC, t0
+
+	/* Restore Guest GPRs (except A0) */
+	REG_L	ra, (KVM_ARCH_GUEST_RA)(a0)
+	REG_L	sp, (KVM_ARCH_GUEST_SP)(a0)
+	REG_L	gp, (KVM_ARCH_GUEST_GP)(a0)
+	REG_L	tp, (KVM_ARCH_GUEST_TP)(a0)
+	REG_L	t0, (KVM_ARCH_GUEST_T0)(a0)
+	REG_L	t1, (KVM_ARCH_GUEST_T1)(a0)
+	REG_L	t2, (KVM_ARCH_GUEST_T2)(a0)
+	REG_L	s0, (KVM_ARCH_GUEST_S0)(a0)
+	REG_L	s1, (KVM_ARCH_GUEST_S1)(a0)
+	REG_L	a1, (KVM_ARCH_GUEST_A1)(a0)
+	REG_L	a2, (KVM_ARCH_GUEST_A2)(a0)
+	REG_L	a3, (KVM_ARCH_GUEST_A3)(a0)
+	REG_L	a4, (KVM_ARCH_GUEST_A4)(a0)
+	REG_L	a5, (KVM_ARCH_GUEST_A5)(a0)
+	REG_L	a6, (KVM_ARCH_GUEST_A6)(a0)
+	REG_L	a7, (KVM_ARCH_GUEST_A7)(a0)
+	REG_L	s2, (KVM_ARCH_GUEST_S2)(a0)
+	REG_L	s3, (KVM_ARCH_GUEST_S3)(a0)
+	REG_L	s4, (KVM_ARCH_GUEST_S4)(a0)
+	REG_L	s5, (KVM_ARCH_GUEST_S5)(a0)
+	REG_L	s6, (KVM_ARCH_GUEST_S6)(a0)
+	REG_L	s7, (KVM_ARCH_GUEST_S7)(a0)
+	REG_L	s8, (KVM_ARCH_GUEST_S8)(a0)
+	REG_L	s9, (KVM_ARCH_GUEST_S9)(a0)
+	REG_L	s10, (KVM_ARCH_GUEST_S10)(a0)
+	REG_L	s11, (KVM_ARCH_GUEST_S11)(a0)
+	REG_L	t3, (KVM_ARCH_GUEST_T3)(a0)
+	REG_L	t4, (KVM_ARCH_GUEST_T4)(a0)
+	REG_L	t5, (KVM_ARCH_GUEST_T5)(a0)
+	REG_L	t6, (KVM_ARCH_GUEST_T6)(a0)
+
+	/* Restore Guest A0 */
+	REG_L	a0, (KVM_ARCH_GUEST_A0)(a0)
+
+	/* Resume Guest */
+	sret
+
+	/* Back to Host */
+	.align 2
+__kvm_switch_return:
+	/* Swap Guest A0 with SSCRATCH */
+	csrrw	a0, CSR_SSCRATCH, a0
+
+	/* Save Guest GPRs (except A0) */
+	REG_S	ra, (KVM_ARCH_GUEST_RA)(a0)
+	REG_S	sp, (KVM_ARCH_GUEST_SP)(a0)
+	REG_S	gp, (KVM_ARCH_GUEST_GP)(a0)
+	REG_S	tp, (KVM_ARCH_GUEST_TP)(a0)
+	REG_S	t0, (KVM_ARCH_GUEST_T0)(a0)
+	REG_S	t1, (KVM_ARCH_GUEST_T1)(a0)
+	REG_S	t2, (KVM_ARCH_GUEST_T2)(a0)
+	REG_S	s0, (KVM_ARCH_GUEST_S0)(a0)
+	REG_S	s1, (KVM_ARCH_GUEST_S1)(a0)
+	REG_S	a1, (KVM_ARCH_GUEST_A1)(a0)
+	REG_S	a2, (KVM_ARCH_GUEST_A2)(a0)
+	REG_S	a3, (KVM_ARCH_GUEST_A3)(a0)
+	REG_S	a4, (KVM_ARCH_GUEST_A4)(a0)
+	REG_S	a5, (KVM_ARCH_GUEST_A5)(a0)
+	REG_S	a6, (KVM_ARCH_GUEST_A6)(a0)
+	REG_S	a7, (KVM_ARCH_GUEST_A7)(a0)
+	REG_S	s2, (KVM_ARCH_GUEST_S2)(a0)
+	REG_S	s3, (KVM_ARCH_GUEST_S3)(a0)
+	REG_S	s4, (KVM_ARCH_GUEST_S4)(a0)
+	REG_S	s5, (KVM_ARCH_GUEST_S5)(a0)
+	REG_S	s6, (KVM_ARCH_GUEST_S6)(a0)
+	REG_S	s7, (KVM_ARCH_GUEST_S7)(a0)
+	REG_S	s8, (KVM_ARCH_GUEST_S8)(a0)
+	REG_S	s9, (KVM_ARCH_GUEST_S9)(a0)
+	REG_S	s10, (KVM_ARCH_GUEST_S10)(a0)
+	REG_S	s11, (KVM_ARCH_GUEST_S11)(a0)
+	REG_S	t3, (KVM_ARCH_GUEST_T3)(a0)
+	REG_S	t4, (KVM_ARCH_GUEST_T4)(a0)
+	REG_S	t5, (KVM_ARCH_GUEST_T5)(a0)
+	REG_S	t6, (KVM_ARCH_GUEST_T6)(a0)
+
+	/* Save Guest SEPC */
+	csrr	t0, CSR_SEPC
+	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
+
+	/* Restore Host STVEC */
+	REG_L	t1, (KVM_ARCH_HOST_STVEC)(a0)
+	csrw	CSR_STVEC, t1
+
+	/* Save Guest A0 and Restore Host SSCRATCH */
+	REG_L	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
+	csrrw	t2, CSR_SSCRATCH, t2
+	REG_S	t2, (KVM_ARCH_GUEST_A0)(a0)
+
+	/* Save Guest and Restore Host SCOUNTEREN */
+	REG_L	t3, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
+	csrrw	t3, CSR_SCOUNTEREN, t3
+	REG_S	t3, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
+
+	/* Save Guest and Restore Host HSTATUS */
+	REG_L	t4, (KVM_ARCH_HOST_HSTATUS)(a0)
+	csrrw	t4, CSR_HSTATUS, t4
+	REG_S	t4, (KVM_ARCH_GUEST_HSTATUS)(a0)
+
+	/* Save Guest and Restore Host SSTATUS */
+	REG_L	t5, (KVM_ARCH_HOST_SSTATUS)(a0)
+	csrrw	t5, CSR_SSTATUS, t5
+	REG_S	t5, (KVM_ARCH_GUEST_SSTATUS)(a0)
+
+	/* Restore Host GPRs (except A0 and T0-T6) */
+	REG_L	ra, (KVM_ARCH_HOST_RA)(a0)
+	REG_L	sp, (KVM_ARCH_HOST_SP)(a0)
+	REG_L	gp, (KVM_ARCH_HOST_GP)(a0)
+	REG_L	tp, (KVM_ARCH_HOST_TP)(a0)
+	REG_L	s0, (KVM_ARCH_HOST_S0)(a0)
+	REG_L	s1, (KVM_ARCH_HOST_S1)(a0)
+	REG_L	a1, (KVM_ARCH_HOST_A1)(a0)
+	REG_L	a2, (KVM_ARCH_HOST_A2)(a0)
+	REG_L	a3, (KVM_ARCH_HOST_A3)(a0)
+	REG_L	a4, (KVM_ARCH_HOST_A4)(a0)
+	REG_L	a5, (KVM_ARCH_HOST_A5)(a0)
+	REG_L	a6, (KVM_ARCH_HOST_A6)(a0)
+	REG_L	a7, (KVM_ARCH_HOST_A7)(a0)
+	REG_L	s2, (KVM_ARCH_HOST_S2)(a0)
+	REG_L	s3, (KVM_ARCH_HOST_S3)(a0)
+	REG_L	s4, (KVM_ARCH_HOST_S4)(a0)
+	REG_L	s5, (KVM_ARCH_HOST_S5)(a0)
+	REG_L	s6, (KVM_ARCH_HOST_S6)(a0)
+	REG_L	s7, (KVM_ARCH_HOST_S7)(a0)
+	REG_L	s8, (KVM_ARCH_HOST_S8)(a0)
+	REG_L	s9, (KVM_ARCH_HOST_S9)(a0)
+	REG_L	s10, (KVM_ARCH_HOST_S10)(a0)
+	REG_L	s11, (KVM_ARCH_HOST_S11)(a0)
+
+	/* Return to C code */
+	ret
+ENDPROC(__kvm_riscv_switch_to)
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD230351B33
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbhDASGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:06:50 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:63053 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbhDAR76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617299999; x=1648835999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=S11BgWt7bQl6bZXM7gTtcI96QHF8yLloIExyHiUKpb4=;
  b=V9TKd2H1NIRWWfJkJ3oskV44MNt9R0ywqprRhw81toQCLy0I5FsMyJRU
   6wdlrSeoOjp8Pq7/lxpLIuTd2ehkfRI/taPXiEKJXD2qvVMrZgt/vqIYC
   7I8DE8BLnrroRlZCOZMG95hSy0VjokWyvOYWaiig5GVTKH42ixQw8K3OJ
   bMwxaAQHoyOIxHTXhC3Ux/5I2Y3fkyUXJpIWRZHMmviKa60sRd/cHR8Cy
   TBclzlKj4gobrGGkZ2uNzVw/JzmDrwWBJTmxJ3m5gBFYdWXL6DIaULvAM
   /+iyRgYlqt6FC/PhqJsqZaOGJoQIiUtV/PDK9naqbmTx82vINHAtltOj5
   Q==;
IronPort-SDR: o3wLChNvbs4n2eiEsiyTpxFXXFJOJPyDS+ADAFnQNwek/iXRxt87gcYd0zZ6aagbxY0aLIR2v1
 PW3PlYypBSoAVK63R6knWisjoY/QX8HlnL2EBD5Ef9TNV4X4ZOXwZS6zmzOBvW04nG3lpD7ZQg
 5ZCA7VU2k/fbuWwGjaJJSFMTIn80B8ktjEUD3wQW/FDoeDy0zqlslEEoIsrhY6ERpIzgn/IvWA
 GBNmxzt5gGvKZoCyKbt5OYuC3sGvxIpCngmpFM1ka8vJWBjhWP4I5LW2W2mJ0LvdCb2Yv9rbyh
 dY4=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="163447554"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:38:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJZCn2N0AB+DVU2OLocZof4eAflJ/UTMg0rh9V9GHB434But7I9+AZC7m4+ciov3iBN2NEoZRXC5bf6HWSX+MnV2Cebn18rjvXcjGaPoZX7WOgHOKOMmK/fXuISFCv3tbBrQeCIzgh9UapEi8S+CKvq4/lbmrrAgZSbE4JpckxKeS3nTNg53DKin4Ks3bL3Yty7RP0tOp8VPco7onngRQC0idcaPUm5+EGnb/wjzt2JHe0QEUXlF2Dlj8yQGv2g/jDudQzu1u5x03zcGflINUB7T4ktpCo3e6C+/vGuPzCsZ1ZvUwaUTLjAq8TcmLXvLXBOzc4SZKUgO61lWs1SeHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W65VQdFHDthIYCUOSPjpjhIpmTefz5qEOnwvtIthmHo=;
 b=EvCgHvMKkPf8NJYQoGsV5Mv8k97Ip0BGOQFmkB6N2xAIO1iRJaNOfrrnU8o5Ki1zCrMBPyGU8DYfNiI+mO0MF/MrWoOtkYviP/a3Vp4m82S9H6REUQZrGwa1t03eU7zCNGuYwNCTYU4Jhkjs2292IN7to12BEAq3//3FO98gd9Sn8Br7zHF/pBzxdPlYg2ULWdqdnBYxyLc99k2yHmXH2H6lTIZiybN5iLx+WLBhDKqI1XZLAdge8rIfSO9q5Y3jgjENizpsoB8k7biXnXU+F29VK4+KRXqZssLSXMTAvm8+Hb32A6UjW36AcR991lWi2GyFgsXv7bpsUW/IbfsvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W65VQdFHDthIYCUOSPjpjhIpmTefz5qEOnwvtIthmHo=;
 b=iyss8KrXSO0Jf7we/GS/Fqjd5l3i1X152sdocC9IV0RAhSiP/uiXoY0s4bPTEhLHYt9eZOS9YSnfizAqzRZFd7+cMCAlOd4sMmVt1RUop68GbeqTdE6kjtaBGy99o1VhaB1c2e0fLZ7DHApBAGirhrlgtzOiNMRPwQSiGhL5bvQ=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:38:11 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:38:10 +0000
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
Subject: [PATCH v17 12/17] RISC-V: KVM: Add timer functionality
Date:   Thu,  1 Apr 2021 19:04:30 +0530
Message-Id: <20210401133435.383959-13-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:37:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f81ac61-7b71-47bb-9b33-08d8f513640a
X-MS-TrafficTypeDiagnostic: DM6PR04MB6528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB6528D4A9659EDDB403879BB28D7B9@DM6PR04MB6528.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Vbn9bxpcOdVEU2vC0+sFyZBbw9jDUHBoxfc7trWunlXhL61lANIFUJpoI3DI/iNVMgmo9Fi1/Ua/WfbZA8pociVS6c+Q2Hxz/HWuRAmy5Z47UuVrjVQVNZx7NQ9h6NlwiBZ7EVv4o4jEn5SIPlZSeAG8auRHyGEHbDkidGum7UZ97Kj5hOdCt6TXizOxcqoGSTePja9cySjF6HcaI1Som53Pd0wGXaHh+aoguiPH05pvahbesMjRLlxA6nwLFD9FMcIvtBZDaWajm5Cnj9TmoxgcnXh1IjpXSu2OUqobht5m3mszGpEsWIvAfUtCiCMlxchCLpssguJs37N6rbUbIbXoEfRJmNDWaqfsZ4+zQg6wjP+SgBDLnRKxh5QmReBSaTxqcc386xc54TW4FY+VINtm46VSYfe156E2A4Xp/XnLAuy9Kf6IeoE3IvlyL3raee6cDj8QJTa3ADvlyGnPSJJZZDdywLc2SCw///ZETdOrNqp/wY7UP6z81EmZxrKrdREbyJEc493Om9WOGIzdTUxmLQFM3dx+f8Nz0NrEpTj0hGflldEKqeq5hXf/93n1g+2ryCsq+iphzjlNB8KeBWZLJm16K5LxIRiYE1+NfaA2EFskicDLRjgI/d30gBtavjH9ThjCD+DPnWj1JIc/qwj+b04cmVm+Iy1pCb8r0M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(8886007)(16526019)(36756003)(186003)(4326008)(956004)(2616005)(6666004)(316002)(66556008)(478600001)(26005)(66476007)(2906002)(54906003)(7416002)(1076003)(8936002)(55016002)(86362001)(83380400001)(8676002)(52116002)(110136005)(7696005)(5660300002)(38100700001)(30864003)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e6emshDb+l+nQaP9YBt1W33Le5KJmMYK8EGCgnolAgUdr6xowYS69lp8Jgdg?=
 =?us-ascii?Q?layuihZAT5tl9Tcx7BBR1lgbTaGs6dHYj8xalZmopaGP8OTMyp0Q01oS1qOn?=
 =?us-ascii?Q?IUwpERAN27mDCCrED44YJ9n8E9vBGKtJHKIXWXPjM4G9nnUSWvUXF/VLQOVt?=
 =?us-ascii?Q?Jrh4+yz/xhFd202IlKkv7Xctp9xI7L5Pz/VfNA+v7EnWhloFUScqJdwvr3a5?=
 =?us-ascii?Q?ulnQyA0jhx7907Erojrmv90rqn4ZXUJWPdC9vFncCG1lcDdic6OTgzThWwg/?=
 =?us-ascii?Q?8os5igHG5StEMkb4++yVXyU5P/OSvqvWWURGPeDeJ8EmFs1Qf5RKdlx9DcZf?=
 =?us-ascii?Q?xYMHK0HfOic/4c3vDdQrEdbBBc1eTeU76CAelqGBvi2i8ZupVBEd9qdUNuZl?=
 =?us-ascii?Q?oGZTXE1JeVQJtDbF+drS5AnxsvYugkrF2829pspvQ0rYmERt5/Rowuq2twWq?=
 =?us-ascii?Q?EvUQN1d6LBE/EXL3vwI6NohnBzrSwiDdzaq87aBV5puzHMyxrnDyFT1L82q9?=
 =?us-ascii?Q?vhogRrkajGJS/oqg71kR8d8BwObLYDw5RUGI+04Gjdlby6Ynvoz3UnoiMNiA?=
 =?us-ascii?Q?CNy4rgMQNRBDfCap2ON6hdXj6KrbjAGVZlCDRWkI6zVS9nzd4M/wGU12a1mm?=
 =?us-ascii?Q?R/KJtzkDe+c++skwkDzpteVUYvbhlsqOZfdGbA4rC/lR8JPgnmJq5UrfuvuE?=
 =?us-ascii?Q?ZMczyMF6lSX7gQvsI7x5ipW+hmAfmw6b/geR9d58maMvsDgyRP8kneh8BwZY?=
 =?us-ascii?Q?j1NyOOiAi8lJOfNxOf4y+vdDaW8Q5DyT9cUp9zDLpxaAsVuqyiKzhlwGGlOW?=
 =?us-ascii?Q?qW+qpdlRjbaiFb3Y09+NBNHyxNBrb6rDaz2fgA9gX38BzwGGj4ssz3vs8zmJ?=
 =?us-ascii?Q?7mi6JEHgljSi1XA39NjCTpglVyJRhKZ+5YBhCjicjfzY7Zewx6R+Yjq//KvO?=
 =?us-ascii?Q?4zu98YqFhSG6P0FV7js8b9xDZXgUDLnc2vDYN1yw2RpVd8SfmvUWeUO+3FWT?=
 =?us-ascii?Q?s3IkfR4hmQJxVbeBFBF1xWdngnU1LxcB627uA+IlRQhiH8DBLKBYoGyf/iHF?=
 =?us-ascii?Q?3zvly8jmPCcEbkm/UIi5RGhqWw9ORkZc+d+HT+gxy8l4eiXt67DYx7Fu3BqI?=
 =?us-ascii?Q?/fh/5Fe53hC4KOBSkWGk79B1m2Erg+BlSWlSvLhVMlo+KSbmLcU5IWH7RC9c?=
 =?us-ascii?Q?h5CNIlo8ZVHOUGIN6efGrAzvbEqVwGDOaroG28yJH0WmYHZLWnm8uUjJI26H?=
 =?us-ascii?Q?jcpn+q856BBdutqp5Wjt9fUeLAR3IIvpLgi3BSwx3pBOBNeEtcoTkBekHLUh?=
 =?us-ascii?Q?RM9eNAJlWEyggvJIJYfKnu5OAmqPoeDrzKUzYiQ2vrCKPQ=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f81ac61-7b71-47bb-9b33-08d8f513640a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:38:10.8263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jMYcajCz0ZG+cH1Lz+bPtPjzl75wdT+yErfA2Cra9VcUYgHanaqnNcEQwUfNvi1nXEQHuPdpQWUBIKM6Q3aZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528
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
index 4e318137d82a..20308046d5df 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <asm/kvm_vcpu_timer.h>
 
 #ifdef CONFIG_64BIT
 #define KVM_MAX_VCPUS			(1U << 16)
@@ -65,6 +66,9 @@ struct kvm_arch {
 	/* stage2 page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
+
+	/* Guest Timer */
+	struct kvm_guest_timer timer;
 };
 
 struct kvm_mmio_decode {
@@ -180,6 +184,9 @@ struct kvm_vcpu_arch {
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
index dcb2014cb2fc..e242431dca66 100644
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
 
@@ -94,6 +99,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	/* Cleanup VCPU timer */
+	kvm_riscv_vcpu_timer_deinit(vcpu);
+
 	/* Flush the pages pre-allocated for Stage2 page table mappings */
 	kvm_riscv_stage2_flush_cache(vcpu);
 }
@@ -334,6 +342,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -347,6 +357,8 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
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


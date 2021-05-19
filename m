Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C013388572
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353123AbhESDiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:38:15 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26389 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353107AbhESDiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395409; x=1652931409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wO1GXGO8qpzsp5t1cfN3dCXovBrpAZsSu590rmX6Wds=;
  b=FLe8v9sJ+kezJgvh06sR1WM/UbxNT/WELO9BrAdonTxMFD8JpVU0Zz2d
   GtJZxckMdg+adB6pX+m5D0KplIOTEdiaCd72Y2YiacrEd6+zKSzeUo8+w
   pbU7QEWhZZ4C8QVEM599UUZ0iefPsOALfPV0f437fKWToONCIShns54Pc
   AiJBzb/g3IhoepiZSzzsXB0Dqsy4ai7xtW00V3Mnq2Ikadq2TChwRNU1R
   hyqF2iOVp8gMI853lrdXOkUTiCzwvE+fLYt14gfygWSUZ4MitL5lEoFnt
   V8bu4h13ZbyLXRQDDYrNDA0tDOkwi6G9wYvOpkniNGWX6jqWVVH6C5doF
   Q==;
IronPort-SDR: aPdyvMpJfuSz9cbFt2Ws8WVZu9q/sKDmoZhFllsPho35ORSckpvFLCDYJZk0pBVFNMMH4mvCZr
 6IxdDZwysK9IquvdgvFxSuPBtSsyJQf/lcz1jW4P62hz/ERUY971r4sGKOPj79K+dwk3S/OFXd
 qemAK6ks56rb2qNuDeB2m6gkyjhJDiY8gkDCfzlV2SwvA1AEbnMVgE68astjvb95BsCpGHXpZ5
 rvXBEBklwHTwWG93g6XCQCOjBr3CynEJt/LoHMKxWXLwiw/hGslvRlGTKl1CYHve8jwwH5KFEY
 JbQ=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="167950697"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:36:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPLAh6MpTPv79NeoPzMfjDDv0yjZnL2szhw1KgX0rcDrpyq/N7H2qU2INjNTZ8FWd0aZdDLCBQTHUWWEbHUUx2vg5ER8wpe69JhtwjiYnhwrO59o/G+4OQ28zubHIVa/rF5AYFwkWTU9s8LqghdnhGnqg7SnodIVVmusutXsCf34QHABII5grCBl3L0+nv1o7i4eLXEk7JDow4uVG9f7I43PeP4kCUj1yjB0FPUfUSEWq5nSXClK1Doz6nBF+fng2UJOEdvt/73t+rZPz53jdQT9K4jqqH8K13iZzOVVrV3PBjTWWJxufFrhqHOT8F8xi3Vequ7klXFSdGsAkoDAPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0bYIBxZuor8yfaSi/ryOFLWtSR/nt0QOXcgl+M6X3Y=;
 b=CDGdM4n45nsim0Cw0kpyqE1kR7kO3w4tHT2fKPbbGDthMKfm7HZFyUoNV8Zu6NhVKjY/TsbmgC8zJitsovBmRbBZrPMzxGSpqcptZJ5ls4WtipTdCIGPQOP9jTWPJUee8R4otffgkeatQsEpcVcpebwLaXtw/3bflQoHZQvjbmYJH7YtvOmIV3gSe+XwV9Eorgop3eTnf0ifnEFXI60Ngvenj3S0SMdVVY7I1pWYitwTypOeJ3N5KfYelhQEdKp6jmeXhR7ImGPQEgPVhrTsEACVecwdYT75fjueTJwZh51ucGceoDhMqeUygXnW/Xh7FDj6+viNeKrwNKJ9hH1Lew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0bYIBxZuor8yfaSi/ryOFLWtSR/nt0QOXcgl+M6X3Y=;
 b=o7BxVKjLuQKGaSmdSGCjGeIkoBA0nBoQQEmkQTuTEa9paTBRnNACNqZbAfdEO5UIl3AOJWjwoix+15YfB5nQYvrEpbs/ouYtD4pj1a+a5qbhIfwiyanmsfea5PnLooyC0bXgsXpBtMav26uZzXQCDA9+mHWdNZFAkH7hjcPE94M=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:36:47 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:36:46 +0000
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
Subject: [PATCH v18 06/18] RISC-V: KVM: Implement VCPU world-switch
Date:   Wed, 19 May 2021 09:05:41 +0530
Message-Id: <20210519033553.1110536-7-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:36:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91b48e55-7bb9-4158-7128-08d91a775442
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7761A9CAAFB4C8F3FF4778358D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1jd0Xnj2brakUakUf19pjfHkFruIijMC7eqHQagdSRXd7ZTgJMYmBcJEDmM70H5kaUqRdELkOeucaWy2/E7/Cg2dwamM4FRfL+hAiUiPKBMkY4M55rTcuZ2imWBHg/mE9iSFCUi7cwuQa5XUH32GS4iS2M29WR38Gla/4/LgFBPwdu2OMCWuH3v0RiiiIYvbh3xcIPagQqu3RhXOEm/lVzTloXI6ahvChkp1/9LpuMNpFoQY9pW0FTjaJabQa543cYcOjAYTKWoKYxCVtKoVB31+Bjwxy/YRCWooWbJjh8Jdwee1v4MfS/prdA1dzvv4NW5kqmpibetCuSZFu0cw2tVvFXvaDGsfJQg44ft0AUPPBbNmeY3k6HOGQpGfiup1jYmA6gvSjbgJNSt78OGJ4E0cehDzeDeq1r7FIc7y9YLJg8GtopyCXEy5+2pDmPxElITDIuiX8XAddevJoYqvCwKX7FjAieQ2D2OUPeP3E6uGT7+Zk8qAMLa7IGbKAeRvz9qoYgDzacSXf6mnEEGJxg7Z1cLua2SovUUrjiPR4cmwWI0fQz6fGfMZgBBC/OSfibBFg0WlzW3O9O9GNtHNWxMMCfuXx6QfZyXqZQdEL7Bu/O1uxNEvnhSEqtgDFLg8X7jCq+3sy5RuwceNCuhFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(83380400001)(8676002)(66556008)(36756003)(30864003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aVPHCDM3lxRR//kr8wfoyIYjcLj0Bd7IKIJlMBk9D1O8Mu9DzDRvVR/8JHam?=
 =?us-ascii?Q?Rs21s9ZlrmZ9as0oKCw3EJtj3lnrHF2e7pFG38NgF9YfvMvTPt1Rl51Ypjsz?=
 =?us-ascii?Q?ULY4CKmIFipVdabiN3Lit1len/NS0o7V1g9Zm9m31Dc3u+xdJ7PD8dVEA1XD?=
 =?us-ascii?Q?9IFZDq+iYknWgRq3GLfO59pB5kzgDGBcGJAA+efXWMQvKjgp6G+E0c29O3Hj?=
 =?us-ascii?Q?3epBFOmBfI9AOl+KrsCXPExVhNYLBh8pe2wWK4bJFYHjLqsCWs4OdfzGrsOM?=
 =?us-ascii?Q?5Pk4R0r6GkP8a52GbYclKLB/TtkdIumGE0eBiiHt4jvZorEcIoP0d14Vexbb?=
 =?us-ascii?Q?7KqffujC9MldD9+9RyolwfCH3H/vZtmGhL0kzt48mmuW3extemqwO/shEoAk?=
 =?us-ascii?Q?tdUVJkjkI5TPxXAbgk0WJv6TidNX6zSBStkhQykNPpM4urgk/1x/9Pj1ucQE?=
 =?us-ascii?Q?xjVeumN5tQVfgix0tqXAEDbKHa50cUN3BjBB8fJe10CD4mfeYGycWwAy3MnZ?=
 =?us-ascii?Q?wAvp1Yq7Gz4ZnFNBmHoiAxe0SHL/F0E5zKd7xFCcBJxl1txZX8z/Lsqtv8t7?=
 =?us-ascii?Q?/oKdpJYRc+hEtbQinL7ebdHFuO7Ni/EGl6ZB0YMHVTSQc+t09FXM4zwThU7R?=
 =?us-ascii?Q?56rlhKKqqUwrYcXczRCMZDYhS4jHf4EjQLtdNWcoUnKxwDE5g4sx5idzQvHL?=
 =?us-ascii?Q?ze7Q2XxznLI4iUeV7r5XU4LzX8rMDyqIptYfzDGYB3NfAKQNUQ/phYxGEuPq?=
 =?us-ascii?Q?9BXQBlEsieMErVXRsUsExfZH0CzJAoe1h6PHDmifdjcZo45YpPs11sq0+aZK?=
 =?us-ascii?Q?ZwC7sMcx1qX6v0z+qeJSAWIkuGKvpbb3pXxZ/h4hSE+CkvblyoklaYkkAKV4?=
 =?us-ascii?Q?KpkJ02PakuXLXS4qI3roXUgFDEbCD6VotQvXKWD8d2v1imTLWRZX4C2WYvLq?=
 =?us-ascii?Q?FQHZohWIPntU+2/OH5Qbu4NkBPDJjlkLOoJNdssElBAyyzJpAo/8ZT/rYIV3?=
 =?us-ascii?Q?j3CMxeV28zJ1OdsErebkZiCn80/Ml+MwgHMIWQcU9jOteSyTLhS076SmclwN?=
 =?us-ascii?Q?DrAf122+Ap2oFrJfoPI4eYUEi43QhVho0CPCIYVlU9jfVUaUbrPrgLVyMZXq?=
 =?us-ascii?Q?uE/7y6ubSItUAq4yKnCkqjwxZoyuFalMoswNQcFVwrH9c4jFNSqA1E+cHySn?=
 =?us-ascii?Q?EtJKNKY4MRGozH1xKBbs8CjMVI+bbDmAJ9XdWQ3dVuOEz0CgaT/Dfs1XB7nM?=
 =?us-ascii?Q?YCYYaLsnG59TDaxZ/llAemA9u33E8QIEcH4xzSSIbwmTiQDktVkLEhG03ZtO?=
 =?us-ascii?Q?GBRHPPmWyMnZE6y+LupVYgyY?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b48e55-7bb9-4158-7128-08d91a775442
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:36:46.8697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nnehhmr0lbi0W6jQHwX8jCc1FZ+rOCl8ShTo+LZkCVav7iucFo8S6lKttoT1lOjIZp1C+jZ2q9G+37Vap9o3Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
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
 arch/riscv/kvm/Makefile           |  10 +-
 arch/riscv/kvm/riscv_offsets.c    |  92 ++++++++++++++
 arch/riscv/kvm/vcpu.c             |  30 ++++-
 arch/riscv/kvm/vcpu_switch.S      | 204 ++++++++++++++++++++++++++++++
 5 files changed, 342 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/kvm/riscv_offsets.c
 create mode 100644 arch/riscv/kvm/vcpu_switch.S

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 5e1c3140e49d..25b24606a89c 100644
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
 
@@ -168,7 +176,7 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
-static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
+void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 37b5a59d4f4f..f3b60e8045a5 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -8,6 +8,14 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
 kvm-objs := $(common-objs-y)
 
-kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o
+kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
+
+$(obj)/vcpu_switch.o: $(obj)/riscv_offsets.h
+
+$(obj)/riscv_offsets.h: $(obj)/riscv_offsets.s FORCE
+	$(call filechk,offsets,__KVM_RISCV_OFFSETS_H__)
+
+targets += riscv_offsets.s
+clean-files += riscv_offsets.h
diff --git a/arch/riscv/kvm/riscv_offsets.c b/arch/riscv/kvm/riscv_offsets.c
new file mode 100644
index 000000000000..a3d4effe9947
--- /dev/null
+++ b/arch/riscv/kvm/riscv_offsets.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/kbuild.h>
+#include <linux/mm.h>
+#include <asm/kvm_host.h>
+
+int main(void)
+{
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
+	return 0;
+}
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 1df21f9a0d6a..654a4834a317 100644
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
index 000000000000..20237940db03
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -0,0 +1,204 @@
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
+#include <asm/kvm_csr.h>
+
+#include "riscv_offsets.h"
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


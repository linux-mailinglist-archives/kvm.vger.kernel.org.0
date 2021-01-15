Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E2F2F78BA
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731748AbhAOMV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:21:59 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:38938 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbhAOMVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713308; x=1642249308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=t/J5BhuLT+5vJaoywOQClLYe0pLHLd8PHzF4nEQxl8Y=;
  b=PayzXuF2qE5WxN4Ieu6FUcg8cMtOlXv89EiFVj8K3Cvlp65PBywSaUUn
   sYOrgF9SKP/z6stlkZ1cYYXm3rJwsThQjAlB34Njp8j7bSGdbyOqnwMg4
   NwTbxwB5l9WtgGRcByWGvV5GsHs5t76olriNlCZpG2myK/jfQhd1PkxI9
   cdSSWAhuyGEqeFrjMOb07xKzzy2okXYNH4kpoLinWiSlMIXSiuIROsqzG
   Ga0sRQHl7KXupI9kS6dynP/FNErUBfW43ZLghHmEhT+z/DvubejqinaDW
   3SXo3Mf6MA9TDYVW9LsyHbxNrVfg8y4KIVfGo/u91+HH/+MXa+vINhDuy
   g==;
IronPort-SDR: 4tFwYDVAtwgRV/7GP1f/k5hg9lWULdmlTTbtMGXiRzTxVnxzGxwDvQ93Pn9xF8GoAvspQp7r6C
 EkdhHyjY6VlWAECGXmmGxEDBEzg5MBksnEs0Ym6JmWB/ENXOdx488nm8mEWat1i6LeTMVL+Yq5
 +5t5PZbTwYKhEm4XTrkmHz6yrh6mImHyd2iWDVZHqXQHwo0IrN3sLdLR0+f+ETjnrPDd0kzCG1
 03yX+7x2G9T++5K89+kiVyDXj4oT6viyFhq6nfviymm0jMVCvjmr9VhAcvzjoRI7R5OBP84qIS
 bBY=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="157514102"
Received: from mail-bl2nam02lp2053.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.53])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:19:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8PcwBhK47J/hftVehBhLvJxsUrEqKml73G4SNfMSE0+qB0nsc9h7vw0r1Dws9tVgPece3D1kJu/Pxvf7gzX5Db69CqAwqjuE1Q2GF+oqCo5IcWXsn1DivQBijxv6xeNgvJUMZaTP05OSIND4wXFSHTXzeWEJBoA81+XO7eX8YBJiih/wJQDJ9oT9vnPzgzkoqK6mEPNt0Yl2JJU2dyaOoxT/uFde1wwVJLkEPUVL+z0+4dK3x+JM1rbcIrGSOWvxtsIFpWEPKiuETo+KjF5BQKimHkqMX/W5BADvrU9R73Om3aF3RjaQ+xvXW62RCVe+uiSpQ4ZxY8wHKTMiBIT2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pT+3ONsRZew7hKC3TTIXCxmIgYa9u06HktJCk8qmInI=;
 b=Z6DrE9Q+XMweT+qD6vA+iC/66TfIU7/AePq2LvBT1Dq8wPBZzRyOYVXoHkH4kPJwWIqHxKLAhyqMaOyMSCVAeHkJxj7K5FgD5LDoMSqP+cBAJXV6Y7gRX2pXUxr5v9XPwNW8WZrt/JxliRY272ELn0OJoCEmcGkS3EDjepqEIb+BqeUtUiHCMlbzfKVAvQLYeA6ed8U0PYNaDu3M1sY2Njr/7LG9AoQdj1y+QJggYEZG6fhyCWNo+xd2ZsjZarzfRQXYq4+thAkfbmMWnBww2C0mMM3zVpdML/jjU0IqcsmkIA0NYy0tuxaAXXlt7y4Ynq8Z/hiZYIGe4/8pSKbD3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pT+3ONsRZew7hKC3TTIXCxmIgYa9u06HktJCk8qmInI=;
 b=o3rST0M47WTpUpwj3zkIWKnr9MAIsJqsPyLNaJMOWQ5A1UPSHSPI744IaKEyQD5CnoV/QjHm9mUdrmSKJ3TfnsWo/feoCD1Lnv5VJQqrnC8wmeMPJShxPowggmXKghHRtcxclEsEdQxXJdepSm8qEDdNxgBz656c4/MI0UJnZkk=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB3769.namprd04.prod.outlook.com (2603:10b6:3:fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 12:19:30 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:19:30 +0000
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
Subject: [PATCH v16 03/17] RISC-V: KVM: Implement VCPU create, init and destroy functions
Date:   Fri, 15 Jan 2021 17:48:32 +0530
Message-Id: <20210115121846.114528-4-anup.patel@wdc.com>
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
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:19:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db2846bf-50aa-4b97-7223-08d8b94fcf3c
X-MS-TrafficTypeDiagnostic: DM5PR04MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB3769A76E11FBE7CA3D7D0E0F8DA70@DM5PR04MB3769.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OsigkZ4UIPzOlEY9FK8AO6pXnk/CseU13Q1up0R8M/kis26iOI0lD0ySD3FC2Plyq+S/Gglk5JnBnnKH520jaFHCrb+M7DgyMf4QR9UUK+npM4d+s2MzsOm6eYq/CA4CAugatNLeLc5+HuKk5lJ3AJ+5Q6S07kI61wyT6wAFeK5yuBNL1WhOxH8X86Mxlc3zEcDX/UjK7xU3AatvwAu/XyVlGzu4bXqnpNDsIWpcQdD0IHR31UPBaVkjYW70toaX5kDwzeMArn2QbH9m58LpICnrPWivKc4B4O//nLIOVKQHO0lWHMZWrfNDhv2hxmbcFIdikVnqVDD8vWDpzArAQ/FXzW6xvRHqkG87Irq+JMlqtX2wX3Kj29RGoPspCTp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(66476007)(6666004)(55016002)(7696005)(54906003)(66946007)(110136005)(956004)(5660300002)(2616005)(186003)(52116002)(44832011)(478600001)(66556008)(8936002)(26005)(86362001)(2906002)(83380400001)(7416002)(16526019)(8676002)(316002)(4326008)(36756003)(8886007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7R5yVoikJ/mDN26ajly13lotiovwnV0xAeOsfZ0cPdDuThLsyqoMjWIZwl4V?=
 =?us-ascii?Q?upEID3u/WQ/qFvwPr4fJd9rwS0eONZRe2ef1EkQl8uwQxA5J0RZxxkphbAHF?=
 =?us-ascii?Q?crtn/bYaTmRXseLvV7TMzRbnG+O2fnn2MwJafU4PrCmj2uJkFiLrBp92tIDS?=
 =?us-ascii?Q?iXi7sqhVAV9Ho3hH1Un3McmBw+0E0j5NXr2zX7qpMmk/LfqZZv761wtEjAI4?=
 =?us-ascii?Q?Bvyv70E9VCQEFk95dSExCnDnKFxWwwCR50xaRlcADJWrHHNR5Yv1lPq6mLXq?=
 =?us-ascii?Q?miHORIXqsDtTQ1JpVOkOEgQ3y2v5thGWxoeuCKYcG11Gf3Q6gHaG1xwbkQvK?=
 =?us-ascii?Q?ciO41u7nE1lXOdVLHUHPoWNj3h1X2cdKQ/l/moZlOqXEK+8hz+4ZsjpwGuEk?=
 =?us-ascii?Q?Z/TkmfFlc2t0GCLa272vrOd7sEgZcip9QcLSgmGrXIVLmISHW58tc6oIWGgS?=
 =?us-ascii?Q?Ic+jBjAsWpT7qv+9xlyD/w2vtih6BxidvprcTG+aC0x7GOmE4mLxB5MHcTeF?=
 =?us-ascii?Q?ghUc8okaoJnyqQBoi6vmFoIS2PiU4/Lu/STl5dcoeNyCbWO+YBj7AU776pC+?=
 =?us-ascii?Q?ebXp/Efe0sdWkfKmI43a+SgUViFuzzX1ACi3P7GWTccsGgIZbdFyYItdkuJU?=
 =?us-ascii?Q?KV535fTKu1wU3YdpkNoOAroojznk3rwKmCsSQacyxoXAOby4ujuhlSsBE1BY?=
 =?us-ascii?Q?chuORKICdjl1iws3q9b7bwJUruHvLRV7TuRzdFknZ1jmBz75gpu6Oqmoq7dd?=
 =?us-ascii?Q?zPP7ZRQqQUz0B7lwTmQt1PMdpmpwZFzgP/YnjAi3Cz6ccpG9xHeOnp4PWX/S?=
 =?us-ascii?Q?egdhM5TuH6beI/ehvdNamUOe+0BMSSOn+XvyVRLr2iiM135MGSOFiWzFCZbD?=
 =?us-ascii?Q?iFhtpNF4mulbalAZeVEMhdMuPUZCUAIgXe+jZoFilipQEWPZE9mNUAcL+y2k?=
 =?us-ascii?Q?mDrek6/9pkBoSqvz+zpOHkAYA4tKcIirHWTFWKi0G1UZfcdFammC+SPvzmjG?=
 =?us-ascii?Q?9m2x?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db2846bf-50aa-4b97-7223-08d8b94fcf3c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:19:30.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MmiNzr8+RffX67AGdBhM8+yfPpocRMe2YvKVKExEJn2KN3Roeuv4D1R2TEejPiJtWzjuSHtjORX+vmlKrR9qyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB3769
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements VCPU create, init and destroy functions
required by generic KVM module. We don't have much dynamic
resources in struct kvm_vcpu_arch so these functions are quite
simple for KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h | 69 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 55 ++++++++++++++++++++----
 2 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index fdd63bafb714..43e85523a07e 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -63,7 +63,76 @@ struct kvm_cpu_trap {
 	unsigned long htinst;
 };
 
+struct kvm_cpu_context {
+	unsigned long zero;
+	unsigned long ra;
+	unsigned long sp;
+	unsigned long gp;
+	unsigned long tp;
+	unsigned long t0;
+	unsigned long t1;
+	unsigned long t2;
+	unsigned long s0;
+	unsigned long s1;
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+	unsigned long a4;
+	unsigned long a5;
+	unsigned long a6;
+	unsigned long a7;
+	unsigned long s2;
+	unsigned long s3;
+	unsigned long s4;
+	unsigned long s5;
+	unsigned long s6;
+	unsigned long s7;
+	unsigned long s8;
+	unsigned long s9;
+	unsigned long s10;
+	unsigned long s11;
+	unsigned long t3;
+	unsigned long t4;
+	unsigned long t5;
+	unsigned long t6;
+	unsigned long sepc;
+	unsigned long sstatus;
+	unsigned long hstatus;
+};
+
+struct kvm_vcpu_csr {
+	unsigned long vsstatus;
+	unsigned long hie;
+	unsigned long vstvec;
+	unsigned long vsscratch;
+	unsigned long vsepc;
+	unsigned long vscause;
+	unsigned long vstval;
+	unsigned long hvip;
+	unsigned long vsatp;
+	unsigned long scounteren;
+};
+
 struct kvm_vcpu_arch {
+	/* VCPU ran atleast once */
+	bool ran_atleast_once;
+
+	/* ISA feature bits (similar to MISA) */
+	unsigned long isa;
+
+	/* CPU context of Guest VCPU */
+	struct kvm_cpu_context guest_context;
+
+	/* CPU CSR context of Guest VCPU */
+	struct kvm_vcpu_csr guest_csr;
+
+	/* CPU context upon Guest VCPU reset */
+	struct kvm_cpu_context guest_reset_context;
+
+	/* CPU CSR context upon Guest VCPU reset */
+	struct kvm_vcpu_csr guest_reset_csr;
+
 	/* Don't run the VCPU (blocked) */
 	bool pause;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8d8d140a0caf..84deeddbffbe 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -35,6 +35,27 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+#define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
+				 riscv_isa_extension_mask(c) | \
+				 riscv_isa_extension_mask(d) | \
+				 riscv_isa_extension_mask(f) | \
+				 riscv_isa_extension_mask(i) | \
+				 riscv_isa_extension_mask(m) | \
+				 riscv_isa_extension_mask(s) | \
+				 riscv_isa_extension_mask(u))
+
+static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
+
+	memcpy(csr, reset_csr, sizeof(*csr));
+
+	memcpy(cntx, reset_cntx, sizeof(*cntx));
+}
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	return 0;
@@ -42,7 +63,25 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_cpu_context *cntx;
+
+	/* Mark this VCPU never ran */
+	vcpu->arch.ran_atleast_once = false;
+
+	/* Setup ISA features available to VCPU */
+	vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
+
+	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
+	cntx = &vcpu->arch.guest_reset_context;
+	cntx->sstatus = SR_SPP | SR_SPIE;
+	cntx->hstatus = 0;
+	cntx->hstatus |= HSTATUS_VTW;
+	cntx->hstatus |= HSTATUS_SPVP;
+	cntx->hstatus |= HSTATUS_SPV;
+
+	/* Reset VCPU */
+	kvm_riscv_reset_vcpu(vcpu);
+
 	return 0;
 }
 
@@ -55,15 +94,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 }
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	/* TODO: */
-	return 0;
-}
-
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	/* Flush the pages pre-allocated for Stage2 page table mappings */
+	kvm_riscv_stage2_flush_cache(vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
@@ -209,6 +243,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_trap trap;
 	struct kvm_run *run = vcpu->run;
 
+	/* Mark this VCPU ran at least once */
+	vcpu->arch.ran_atleast_once = true;
+
 	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/* Process MMIO value returned from user-space */
@@ -282,7 +319,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * get an interrupt between __kvm_riscv_switch_to() and
 		 * local_irq_enable() which can potentially change CSRs.
 		 */
-		trap.sepc = 0;
+		trap.sepc = vcpu->arch.guest_context.sepc;
 		trap.scause = csr_read(CSR_SCAUSE);
 		trap.stval = csr_read(CSR_STVAL);
 		trap.htval = csr_read(CSR_HTVAL);
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39D41841D3
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCMHzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:55:00 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:9065 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgCMHzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086100; x=1615622100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Pdmq3ipjhE3whQ8zAt4tco5EVRuG2IKSbfqDnKzivsQ=;
  b=Q3iCMm0ph4TiIp8G6suQg/mcvQGAZSDThsgzt9B7nL8KXFvAgokeI4Zb
   JVKXAXBwMN9g7laFqZXt33j1H+TVWf/3V2QhR6JkM0tUXmKTMCIirmBFd
   TddoWoAUV5jeCcgbovqDd3MfwYVZgfd3aobvwYqCeUSO81SfDwg3oCoE+
   sxORrdKzeWLmcyI+ZJA+t1+kEh553VBB0sfV93au3Q8H9th7cJEVoEgo/
   dYsboRiVXelBKT/h3NK+4WLurU8NyFAjzoRIEyGwV7gC9BcYrAq+5PKwk
   bLkoRDZjLwNYpN3ZIi85THtyprUVy9c8GACgzHwPEfbCpCEeb5WD8v1lf
   g==;
IronPort-SDR: pIR52MsozTnxKW6OEELiCWkFbGlULOjeL0fnhyKOIOOin7vaqPZbnQm32d3gUIJPWIh3fqX+0Q
 D+WoljSjjPKNV3F6H2ZAnZIiVjZIf9jy6C4Ug6J0k1rjusWL13E67Z8boq8JMKtv/earawZ41j
 IqGTy1cllIkawFRl9afMeLAqdduazRwyGMrqclnS0z+EJKDfAw6GgxQLT0jb9IFhfCUjPLdyzD
 zXnrsoUQC5yUqCmuC5r2ixQTq7Z1KofYct5APQzr6EOLwbVxmZTAczJlCM/BSlt/Hbnc+Ize+7
 bnQ=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="132827640"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:54:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq2Njjb6mTbOkN33qkBhW5tkru/G8UrYJL950u6bbQpnjT/l1GDsdbrw1h0DoOfUlgmif2i9GjF2d9nFhPPz3Jt+k2FTxj2saz6of2l2zYu93zDkUUNsfmUuPijyElP7/FXHhI3c6TNr40fTXgYDP0rDOxurEQvOvVNeu2RLO+hMPxWLArQ3O2zJv13rd/0fyRFwp15XeNlWYViM07PzXfnGFJCDWIO0LMRaM7Bk/c+YxxL5uaKWQJ6NVKljtjXTluAGTwQCmEKeIydmAsvBk8RtR2RN9xLfJNMrdGENQEyofDorKZ6J3+AudnbCb8hlw0UJlCCsBUwHhNnotqR//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgXPDOGTq9aoUIRFCaT/Tc+7NTIcgIo8kq6MqTku7U0=;
 b=cQoAc9MyiFNlW8Ew4orNbwHCSqxNcAJlhAlGhkUaA8BQTCqLoxAxsH/8v7l5i/WNyESqA1GWwyiOaT3s2iazei5k8C3ItMssFeitL46rxAPaeUjOs+76E8uufA9Hp6INXBIQsogbqk/Or94oRCxRc4jE89BmDfzb+MEmsADmxoREZcj/Tt6TWQUR3g6NrVyr6utVqU8XF5AQ9E6HhhLMto8JSFJusY/ioKPCTZ2dzvLmHLSaqfCXSrOtNXeWGj2pGPwTQWqmBDkXfM0vlXyms4A/1+EGx5PQNsHwitkaiY3ItFKAKN0jBUPgO1tqnmLzyrandwdLJPwKo1V0hlhQvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgXPDOGTq9aoUIRFCaT/Tc+7NTIcgIo8kq6MqTku7U0=;
 b=iIyaMgslpSipUzK5IoOPvQ/fjhEf0GDchxl2kJNV5zsVtGooDY5zRszzqWYgBBd2fzsgWlxs0ZMC0HvmUFxU58waC8Vx/i9aXAlm2E8eGQFZi9/f8g4N1F0qD1sbMnPjMQHGtxTeOnmo7yiGm8FxL7HIs0dWyr/Ae4xLX4nRcus=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6637.namprd04.prod.outlook.com (2603:10b6:208:1ef::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 13 Mar
 2020 07:54:57 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:54:57 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 06/20] RISC-V: KVM: Implement VCPU create, init and destroy functions
Date:   Fri, 13 Mar 2020 13:21:17 +0530
Message-Id: <20200313075131.69837-7-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:54:50 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c6e488d-53ca-4e05-6d73-08d7c723d2ee
X-MS-TrafficTypeDiagnostic: MN2PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB6637EB4B23CE452019B8EF0E8DFA0@MN2PR04MB6637.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(199004)(6666004)(1006002)(4326008)(8886007)(8676002)(81156014)(478600001)(7696005)(5660300002)(8936002)(36756003)(81166006)(52116002)(1076003)(44832011)(66476007)(26005)(316002)(66946007)(956004)(55016002)(186003)(2616005)(16526019)(54906003)(2906002)(7416002)(66556008)(86362001)(110136005)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6637;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MPEF2hVGtMbMxNDCKFTELc4SgFAwZBD1svn0MQ/zd6snwc8ej3Rusi7ZbiRyxlehV0Y9YDA2/FX3WoJUyS1HSy3J7AKQVePOHbeDLeMOQjwOGW113GdDVeOkQEP5DN61aT413pXRSH9bNA1tmRmdauSD9x44qlBd1FaqttBpbQXVSyR3uWqK0w5zjDHH6vdKMM7thxDdu9IMBsInc9H6ZSw8c/vmf9/DOzKXw0Cx27mZEwmzn8aVZyrE+VHzvfhvDhAqAvotdy3NxnuWIiiPreYhj0OnR8spOGXVaMcjgHAzZzT4OwO7a3wlqjHFi5dteGsMWG/OpsnxFVn9S/dHiZUGezm+3l6gL2TigaoUov9wae+aQib+NVXKIB4T4VB6Y0zkIiMJpQrmLfD1up7Xmqdu9H97Pf4ZV7KATaI521MUYrnCiIgFdqk0gHIFnj5FOZVU4JEXlaouGBWjVcN7N3RgsGvMGitG9/GayRvnEOmdSwdFtyqC9/tlUBntr+nk+ODHQX46XwT3zRhnzpOLNQ==
X-MS-Exchange-AntiSpam-MessageData: h69oG8UaMz3rSkUCe5bifh3AVpnYgyF4V6t0+hYGZCGGq0RDtEvMQwbDf3q9tsabmd2UH8lYMdsLN1KBGIXt0Pf6LLrBM4oRV5OzlQIfiuLL/CaomwwzAlz84GALjP9nEo+n0gSWOTc79YmyFpzjiA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6e488d-53ca-4e05-6d73-08d7c723d2ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:54:57.7585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U60GGGzhzqxNgsnSw+IHITVU7jU0t12OZ92vSZeMN2+Do+AxPZJFSOJ4Qg/C+6IKH3EJUddHjNdxSngPLLDoBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6637
Sender: kvm-owner@vger.kernel.org
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
 arch/riscv/include/asm/kvm_host.h | 68 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 53 ++++++++++++++++++++----
 2 files changed, 113 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index e0b633f616a4..297431660be6 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -53,7 +53,75 @@ struct kvm_arch {
 	phys_addr_t pgd_phys;
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
+	unsigned long hip;
+	unsigned long vsatp;
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
index cfef8ec7c7bd..f46d6461a174 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -31,6 +31,27 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
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
@@ -38,7 +59,25 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
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
+	cntx->hstatus |= HSTATUS_SP2V;
+	cntx->hstatus |= HSTATUS_SP2P;
+	cntx->hstatus |= HSTATUS_SPV;
+
+	/* Reset VCPU */
+	kvm_riscv_reset_vcpu(vcpu);
+
 	return 0;
 }
 
@@ -51,15 +90,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
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
@@ -204,6 +238,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	int ret;
 	unsigned long scause, stval, htval, htinst;
 
+	/* Mark this VCPU ran at least once */
+	vcpu->arch.ran_atleast_once = true;
+
 	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/* Process MMIO value returned from user-space */
-- 
2.17.1


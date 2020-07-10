Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5AF21B131
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgGJI0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:26:43 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47933 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgGJI0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:26:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594369599; x=1625905599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=TQsFGxTHXc7SvRTGIs0uHBVrgx2ycgWR+ijqS5JyqjQ=;
  b=q+zn23QtWuaC560/FgbdRmFK4bxsbUZ1UKkfCL7X7Dw2+enRufjfcpjz
   h7ywipR5y21qVo6TCx2HyTf6uAH4t9sZSNNHBhcTHfvAU1x/+6ZdDWPus
   CqHUhRagPRb49o4GsDOI9UBVAbqjRlKOHB2QCBqx9Kn29jo4rCWx1Z60h
   X55wfcaahYT1A/nXav2ajfzGpEqBK8PwvDQCaYeb8z6Mo9WJFuubN/vup
   Hejy5phlf1sBMWRxCGttmaUarq4rcQvNLYHaTPVAhDi66wlKY5QTjhj0L
   kTP5/l2MOkcX0UfXKEg78gexXRGdKSz1+V/JJuMIqhTCC/X76L+qPgJDn
   w==;
IronPort-SDR: t7+EF1xIv7IqrdshEy7gNtJ+v9QsHGQV/uJpybjKj6IubGrCtwB2H6wy0jz8wisL40osRnDx6u
 Xoqa67dbkrT+GIHUE1p/tynEmlL1HMl/NZmGkMTwbsP8KT5XYR2rLtLinYIh55W7tZJYuMvaqp
 glh2k1nfp2qn7B04GZBNk3BmDEtbDuP6RrjAeEtrEETshuAGud97CaNtlqgkyN/d690NuYZ6jr
 HAXXu88rHU9YSXhsAWs/Efgl6gB0TNlPzG9xbIKi26jZBNRqe+BTNE5QrsjrOCYnBWtHEKryCW
 B6s=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="251355599"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 16:26:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WueXT24svN5za5nTA2DD5gKxrMQ44kbLNFta3RI84aeVrg5zIiim36DlJ5Lx5kbRA8S99pXWOHhm+6ridBZDKW/QPi5UZuLPOePuGT8u4dBYBAgBeiNKJyfvdUrArxExAU9QBRO12Ot4AQpm1iirSHVO8/wYhMudZjpTv/NhhOuMn6PzT7lugZnYV5bJ7cjCfev69cAcXQ5MlzrVqzhuKv+JHF3hlNEsv+ISourYdQdbk5qtZNHkQ2TgtdmB8db2y+eM+p9H5832ZgJ37OrqiT0B01sFKKULBHEHVKGVH+05C5zpN12cpXrwUqqla3UyApcIRbXCBrrXEW1wRl1n2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mta8IZDAkBhu4tqk8kIOPcZwc1hD5HtBe7OmIuBUEg0=;
 b=EgSa675knfxE57r1t+Vv7V5peAqgIaFNgFwQj82bRJlI7/C8p+PgvMatIUbBiAVESxD7dQyXLEdOXz9Jo2bxuqZyCFCy39mcbw0vpf7Vz2RvT0bO1S9pNhVLMdgN3P+RQMnNhISVsnFR6oDurwgRG14pyj+woAixQxDd82iUBkTMB0hlMtZgB13mp+LepSEzL7p5vzLhS+o9YQOUc8O2ZRZSWDHeebwS5uEB9wCGWRbYcYlvlMwQx7o4YPuCw714lT6d7oLbEsqMF6d5yRPT0FoGW7QQ3po/SmC0VFP0ImxCyIveY/ow6gjtBeBFiFtCgrgARM2S4UqGeBIc6Hkmig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mta8IZDAkBhu4tqk8kIOPcZwc1hD5HtBe7OmIuBUEg0=;
 b=qaE95fqZVookHk9QPCwJPGFCd+XlTkg1/CAE1GZEVYliG60fqcii0s3Ur8j3xHbfAdPJeeN4J2+PNll3rkowXvMnBZ3oCtiXCBp7iqWH0XNWuLkGc6ghNfgJwk31qwGe0aQA2daeKiN7NW85NnmCsnDz1+0/eEds+s03g313E7k=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0461.namprd04.prod.outlook.com (2603:10b6:3:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Fri, 10 Jul
 2020 08:26:37 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 08:26:37 +0000
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
Subject: [PATCH v13 03/17] RISC-V: KVM: Implement VCPU create, init and destroy functions
Date:   Fri, 10 Jul 2020 13:55:34 +0530
Message-Id: <20200710082548.123180-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710082548.123180-1-anup.patel@wdc.com>
References: <20200710082548.123180-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::21) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 08:26:32 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f3f8e0b-3be3-427d-17ef-08d824aaf697
X-MS-TrafficTypeDiagnostic: DM5PR04MB0461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB0461A193ADEE4851ED5D999A8D650@DM5PR04MB0461.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-Forefront-PRVS: 046060344D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JLXCKN3WIxF+1+NtkfdPmCo5TVH6tLIF9YCSkw4lDCdWrsvBbNw1JgjT8QmCm4zxg/MGwCuT2CoJKraEIr+R7WmndrReCH3m08Vbrvg62Do7JyIORL12mjBN6rA99upa+IvE3P3y7yQ3SZz9OIpCNXBvkOBocy0poNwKgebuJ6u30L/bAEwOqXzE85A5r0kuqn1T71WCUMgJsFoj/VkNWJ5314qcCyF3aH4WYnxOkioyTSUmInVJe6n8TfR76ZjQE8PfN8yvauT1kpp/038pXuUZMU/E/TPU9K+M/NxAG47p99rvFG6S1CscbO7Q0Kv6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(316002)(83380400001)(110136005)(54906003)(7416002)(478600001)(86362001)(8936002)(5660300002)(7696005)(4326008)(2616005)(26005)(956004)(52116002)(8886007)(8676002)(186003)(66946007)(66476007)(55016002)(36756003)(66556008)(44832011)(16526019)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: g/zg+FM+yvUhKL6H4rRWPrMad448P7Kb09kPq2M3y2p39jfWxkpLguD77zcCMGLOmR+yO43Thsxh+L6WBoWKGz+kQbzY1uSxv6jLCVOt8Cz0Ofj2qGpHkTeL30RRz8EOwSO26QMS1mTixHisedoSIG3pcjkU3xjqPfpjZ/8NxazFoZiCYYCskx4YsP2W7i9MZFY9JH2ixGzkCmiW5LLu82Cbnn6twn25eat0HSFVWP8ONlOYDT7uGeFzu62PPVXhFbSn/1ihRyoMrNSLgJI/vSCrdb/2XbFtiLG4C/E0vpFlQ75BTapDwhS67JSo+q23xXdtRTBk7hpZhCifJRrel+w2YdwSGOPSzpPjJSJrdxSpZARPq4O1/yqmo23FrUXmEmDGEaMzZGm8UlO/2lH5xb8xk+A/SEMmyOtXHMjrB2MWYX7nrqO2cwRfxWii3xPnUOB5Itx9ClLQizHRsI/x7jrqNsmgF1rLZTUe9ltL3jg=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3f8e0b-3be3-427d-17ef-08d824aaf697
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 08:26:37.6320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ABKKnmuGq2TUqVY76vC6UJyc+oqm2rtHSNyXHo0QUakAJXYnXhRSUoaMkgeMfBsJfUm42/S2grkZ3fXh/TMJLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0461
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
 arch/riscv/kvm/vcpu.c             | 55 +++++++++++++++++++++----
 2 files changed, 114 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index fdd63bafb714..e0aeed7d5144 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -63,7 +63,75 @@ struct kvm_cpu_trap {
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564EA257941
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgHaMbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:31:21 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55089 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgHaMbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877061; x=1630413061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=t/J5BhuLT+5vJaoywOQClLYe0pLHLd8PHzF4nEQxl8Y=;
  b=q+lfeWpHoAhDkNmOc1/K3rRCeYWryiH2z1B89uJi3sWwjwxSAuIyPnc9
   rC8J5rK3QqoD3dXaZUnkVKghNm/XUgEqGiE2wRdIaR8cXz3SN/TKBN7Xe
   JXtlEHRRR9oFkyEzAo2cZW0/xt6Sp06TDTjSnQp7SwhQB2OiQJyND9ohf
   UFPrUyqHEIgxFKOIQa5JxFzyamC7CmiwjxiyZEYdgjDceyp9I/fJ+aVkU
   K0M39AAi8oWEScEdrbcqQjhWssV/oaWWab3eBswZVAkgY2e0KqIZYAoIU
   tGS85WUwB+7XzQZjYwpvqVLB6e1QNXkAviJlNg7Seam6yHS/alNGUIPdz
   A==;
IronPort-SDR: wEkNZ0h979Lokf60wCIcaipnq8MHpo/Qo8weKEyO9dt9DvAJz1tJ3JiksmTZn5OpucZMnj1cID
 DyPcxPL/469tzxMzrvGUk6cBPd5hnmGli5WUFlRwwgiQW2RzUJSMxs+EE5pP5ae/smUym4hb0r
 WE68pwxmIHiOnswvXcTW8YYyfpg3uY5A+qPCUW2rBQP2UEdMtNhqgzk/jk/rAAAWurh4Pej/fC
 YqVPrKLE0otTaKHkJkaUUMMC1+1cRXsYFKHTxVlKkzfgmq7QhlMgW1HASWEJvzeSB7dFHBybYp
 ZwI=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="146216624"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:30:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MktP+a/+MRYtpENCopV0EfFE9BlFPu+VlFz1v7QKq1chw+JqCaaY98e0+vb8Aqj4EaG99eYCiOIHSZMuyL3MJS3R4AnE19P169MjNyWU+sXc2xc/gZWqCjSpopW9rLw0kiTybB12nZr7CYzxhuq7XcSCR8XDNE7AV8zYOCNnCu7XFJGIVygCpK7YAMUEyp4pyoIvXkE41wEd8Xhkc7fprzGl7EJ1Q4vc7S0wzw8fWO1QJt0c3kV3Cla7vqQkuZzxLhAKupZ3NAfwTxejicr00FzXTLJCIUXPfIselJiLbYEqOg7XIqhlwWI3rkiRQkeq02cssAOILAZsRMV/6wS4+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pT+3ONsRZew7hKC3TTIXCxmIgYa9u06HktJCk8qmInI=;
 b=ifI0ckjVyttT5Wrv6R+gjLUuWOV6uxtpuKyUp/fceGAlLEiFUAQ74t8zFiHN2Z5Y+xhIff//7NIWPuzj8PpbOdnv21Z+yMyvBYqFRYW9I3BNejXF5JAYqmn/k0qPubDaw/Sp4DxP/Bp3W9oXsmEaobG2pU4vB5nw9m2CSJQbvwed58lb0fjyeiVoi0UlIB09YO067+mlJ/o+4iOwnu+FBV9TpfBu1xUFM7qchkSsSQDwbTlahqGd4S/BGKibpUH1/09g4yPl5VIBkxuzsHOkr3tNtB70RXGKtdxi/qRLb2n4C0fqyKpx6/YQx/XItHlLAsiS1pkQ+POP4USpMWSqQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pT+3ONsRZew7hKC3TTIXCxmIgYa9u06HktJCk8qmInI=;
 b=e+0Sb+jLhI720vzcUCUwTgiKOhdC9RD4zL34etHB7z6Rf1RLji/Uu8GUX+IN6fIvDPBc/uPk2yd+ZHaARyf2l88d/3diJQNIuah4Cjm29VHGwt6TLUOBiBoYs6U5ti6K6+E1rkyDt7OICR4dDtCVER8oNRsbVUqOE+4rt6Wodp0=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6124.namprd04.prod.outlook.com (2603:10b6:5:122::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.24; Mon, 31 Aug
 2020 12:30:55 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:30:55 +0000
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
Subject: [PATCH v14 03/17] RISC-V: KVM: Implement VCPU create, init and destroy functions
Date:   Mon, 31 Aug 2020 18:00:01 +0530
Message-Id: <20200831123015.336047-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831123015.336047-1-anup.patel@wdc.com>
References: <20200831123015.336047-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::32) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:30:50 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06750792-27b3-4bfe-24f6-08d84da9b499
X-MS-TrafficTypeDiagnostic: DM6PR04MB6124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB6124DEDF170B676F78E21CD08D510@DM6PR04MB6124.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oq9CbPR0Ix5pAkfiz9BOJgVOYgJFtrO6Ppr2Y30dP4c8dNrOUFAs44b0jSyllaXWX8UkSXpWKKKrGts68k/ypldOX10rZke/IF8vYVKh12dKdlGYPRjRs791MKTsOqk1NSczs+LgHhQ9tSPWtrdQsZ4Ff2NJ3GsaAdwXbiUdPmkRtBrW8eY7mjijkPI+yJPm6HU1r0UBJ3i/pe1VS+5KKf5ruCTR3QakznVB3PIOi7cJgIy0vJBnAW8iIafNPHp9tvHD5LHFV49Pg2uSbIqH0BbLU6usN9a4nBnkhWpGeHffTm5d/nUYIivtSAtQJEQA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(8676002)(8936002)(478600001)(52116002)(86362001)(1076003)(54906003)(7416002)(110136005)(6486002)(66556008)(36756003)(5660300002)(66476007)(4326008)(2906002)(66946007)(2616005)(6666004)(26005)(956004)(316002)(83380400001)(16576012)(186003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: EqIbXjSmN2rWr33DiCcytl1T0cJTua+6re6eONKM6VqhX1+6SI4ha4nQj3HDJRC25G0c6vsFP3sl/jFta4R+/RKVa1KH6Bz6VTIpMLJ1Zj3Vmdz4qlfoLT6o+y51VnauHgfxcP3m2WMB611DjtD3hbudaDwYDU3U40aP2+1nJ+snaN+sJoD/Yuw6OZJgcL7hWcgvCqFPKoZbQwnsiH5Pq8tBNrreK5c5bMrUirqKL0f+4dxxWTBIEbCdHYeCgAEtFmSgdpv0pdY3RKydg0vGk/KbXPbCCrJ8T2GcnhzlKZw9uv8rppbOZHnCPxsHdprs8wJny2fzrB9YHQPwKyAsUsZHrSELgho/Br8wlQMTJ8bt/+RRDunpZ2CV6BSTh4hcFMDUwG7HWLaK4lt78oscJzTUy5z2k/HcRr0F5xnMIhQP9CKKFMjBddxP02NNar7N/GGp0QFWt2oomN3CDLqam6Dgbvxe3Wwjs4NFXj5ACAHEsQbstx4xnuWDh4BDBxSwVyeKVATVHcwRi6MRA/68ubgfvb3M/8WbcwLTaLfExL6ZxBLac7ocpOOc9GH+QWgpvJOSjCiR25jzih6O5mF6YSrR1AIV00zuNtYYULfGFpOvEsrBz9XAHbEVHd/k/XJtfHrS2Ua3ir0i0Ypsuse1mA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06750792-27b3-4bfe-24f6-08d84da9b499
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:30:54.9381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: puUahC9AliW+4OtRKYzD6ltj+nJeYOXy2RxpJxG/sAgVFER+yybpe2ZdD71mBhnh8zk0yG6/Sy0XAGxRyA3Hxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6124
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4985C1BB79F
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgD1HeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:34:08 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57183 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgD1HeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059296; x=1619595296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cjdpjoo7zFMg9iA0T/vlTGf75uo9XCJlvqDI7gzkJ6Q=;
  b=HXWSSDv5OcchWkYBlc/OhzYWm3q3hfsoD7zOidV5Udk9sUCaJRaMM7jM
   bNRiLflXfCha/d/KLR8JrwV9p3FyWFujq+o04PYrWsmmL7+s9Hz668ScY
   huvXqAb2kfa1WhJ7agh6nRM+GWer2TisJeRctP32NjDBdpodhalAUjqYK
   TOOaUb0bTe/6p5FWtUKALDNth5u+qhVrmsjmFJ2Ox9dlf9uZ8CNOcRSlC
   /0ZbJKZZ4pWH3OJxeQzmDJOXQb4HW1wGEVvqpLLoBufcRzwxd0iP1Tihh
   f5ZPQ0mGTZTpHlZ76Bt3Pm/fAmAwEb0/p8DLJueNvyLdmCn5/UAyROnk+
   Q==;
IronPort-SDR: khaMhh5iBSHpEqIyj+C5ugJswJFWDb0RAWfaGr22jmPw/0XVBQxw9LzBjL5q88LWB0ySvRv621
 cuzCPPU0rACDZu6PkRBqKNIpKUqrBt4jQbwp1N/LXQlRtCSCzJ1ExEM3hoeJNG3ufMKCAOxCic
 C7pdPwvZpajs/3/KlrCrV1/HIAwXYKJXCF2Rv9bmY6y5HWwJHguw+Q+ciLSTMUgMz3nTRwCcM+
 ciEf75itCRSRWwnBvlBePxilbwHrEVEpQoRHkrdiA7b2MQGI2hus1z7OAtHV8PIxVyIqk5q/HK
 4pU=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="238865816"
Received: from mail-co1nam04lp2053.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.53])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:34:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/NqIxKVR7x7SEjNznTLu1B/JNdB5tTrtn34bDafJ1L7roAZF9w3FsHSPtceU5eqTJTGx1Ub1mx0DKTWNogqkF8bBctVY3T8U6u//IRtK+ln2yLIqU8Bn4tF7W3IJOpifgQ+76GqJig2pnysBC39wwahdW7aUUrl61m70FnURUq3cbIfYcgciQ0+lQPkNqRyuaDchL0ttyDXirofl0imfhD8K1/vrwOLj+Ij+P2mdE9G42v/hCd2go3d7HqXGzlxDBiP+qu98mosLMlDp+XTsOf7GSYBWLBo5DYzqkNfvHY6y2YtdBSsE4EHyYtahuRnklkC5oXBGSXziEKm3vReRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiJ8GsWkoJzXOKRYFbhqv0NfGVXtizOu+EuK/leWdVo=;
 b=e2CK2YIAWfz7670B3R9ciCyALJLxtt+fTcrxEYq4kmX+viCDF9Mc2jif9w/lV7Ad9oxoohwxG8lOyIizNtrYqctJURoV/S0JiOpbv61Y/iqyCwow2lEtWmCV5GmUHq1jYdLq1uPSLrSEgQZZx1/LcOj1TGgLefCilXNAgrsqZTozkejJYKctJ51O9LFU/3APiguYtXc+MCzehrp4OiKsk2Bqos+4Iw6JdjPj/70YrVv3fBbkooLHkfMlIkwlle+6IlmQ06AfV4CDBq8XGIEgZmKjw/PiI0MVg1CJVK4u737m2qztiBzLwBmLIBPaCQC1/OmoNdZlCSvXM5pNxDyE+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiJ8GsWkoJzXOKRYFbhqv0NfGVXtizOu+EuK/leWdVo=;
 b=I8a/HxEj6/m2kxWMBXdJLTgAMTzNvJCTQjn+ub4Zv1+tn2gh2ukNPc+YCZ8GOtzA2KVoKshDotT33h55QhHkP0jbcTQ0kndKGoh1BU6o68wdk9So4zq9iE/n2yYUnzBFIUhOOeMeEwDRwuL8dtkajVLRu0gYpR5X44Eoxb5m5To=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4538.namprd04.prod.outlook.com (2603:10b6:5:21::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 07:34:04 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:34:04 +0000
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
Subject: [PATCH v12 03/17] RISC-V: KVM: Implement VCPU create, init and destroy functions
Date:   Tue, 28 Apr 2020 13:02:58 +0530
Message-Id: <20200428073312.324684-4-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428073312.324684-1-anup.patel@wdc.com>
References: <20200428073312.324684-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:33:58 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 898f6f3d-da23-4353-cc01-08d7eb46871a
X-MS-TrafficTypeDiagnostic: DM6PR04MB4538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4538014338FD4B5ECF80636E8DAC0@DM6PR04MB4538.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(55016002)(1006002)(8886007)(55236004)(956004)(2906002)(1076003)(2616005)(44832011)(86362001)(8676002)(5660300002)(16526019)(7416002)(478600001)(36756003)(66476007)(54906003)(26005)(186003)(4326008)(110136005)(66946007)(66556008)(8936002)(7696005)(316002)(52116002)(81156014);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I46EaaivXHgSm6CFYwFFl16zfOCw8LnjbXfbbcLYzJ0rowJMA6F/yZAjh/ZVE5eWZmQZrxYU11MqWLh9ZXXqxQq3bdfu+TQl+NIp3TR70auHdZRKQUGSVFcrezh3ylVPYL4EhrmTECcA+6Zq1v4lFuMHe5wrLfeeJZCeMv3xZQkTqTYdnorntX0hN/cXctUwGJKIcdmqIZwGg6Pfrnni1rE8CgKuzWM0AvjTg/ZVmueXPOOPYuJuZiEMCDvWiCpngReM23Gei5TtoN3EZZWemw2lneWieDFZjfnsc6xbY7Ld+04R5d0EZI16GT6yiJKQamALJilAdRXNUoi3iDx3/JApKbgMGcuzKoMFkzHGyiA0QCNrnxEFksFIrcbcdI/n10q2gJI5ZrbVrZLUT+LGfl8Sr/8rUoakx22m6I1PQLA9Jj69ngn6zAQWd49+KdvD
X-MS-Exchange-AntiSpam-MessageData: yJ3kN5GaQmH1jNLn52rL0KkS4aF+ncmtkmsQFGUHuBRmivD+YYslXdi8lQPKMZUMh+uq8mYEmUfTnyz0STarJwtiTGMkK2GWaOEw4ceDq0LErPOHckhUFbV5DP4zOpjMD8tipPx81VVSJ6ocqhhgtfcNnV6D3orvyhqwP3iS8ZE6+X8m8XwoJU/dsEvOmcsbKSFPpx+aLuXX8u2tqR4eJkh7MgMf6cDYUM0Sf/2rQ6L+azNg/T6dPyMV2mwkf+QtcrBTjx+9bLVmwWTlacoHWy0u2C4Hgv2mG61s+VAT3QIjIuFBa1QSqmQP1MKxqXA6Gs8j2BYSxIV49LboKzhSjsDooC3ha6RIMcHXxsUUq/TkS4I4QBPzVqtYCN7QCrlAB7X58U0tE830YhIlvzePjjtwjRQy8Jhj8c69RRAkI9aHhb8aH+rnAM1B/i56ULvQXeSS0w989RoFqQxM8iafaO8Jm4P8KfOiFl8A/y63NdGV6SfMNl1d7op27c8deIqehtvOrS6VVubtiynstJtqHCWZ0NFpDPSnhqMVskLodpalpcb75BMWzU1PZVRrDn7mSFeN/7Jqo4c0MOSytQjIp+HSDdtxlllhySB412K4nP59LL0yyqLzq2a92+XLv0Zm/CCQRhtcfxIhrlxNUYY2IFn6BwyflCMl/qb1kpNfafHOpda9HTz6xgnvfWCleKoxP3Lv7FUdb+/OGhjUzfJKhS29J8GPTVVDhUbLaspXweb+L9nNHxCU/uD6Pdj5DVrz+2Zimk1On2WnN9c0RVVm75lUE1/yFK5LbImaHor/mCM=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898f6f3d-da23-4353-cc01-08d7eb46871a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:34:04.6500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rg+8ZaR/MvpM58cdB/SOtsegzNBCcnNJx5zawlzaPliVqHAGoWTpcoMsbkhCv0bGVtUTTE1v8Z0NvqiZfw+nvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4538
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
 arch/riscv/kvm/vcpu.c             | 54 ++++++++++++++++++++----
 2 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index ad4a5e1a6cd3..51bdd6fe05c7 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -61,7 +61,75 @@ struct kvm_cpu_trap {
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
index b238592db2ba..c37745bd3dbd 100644
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
@@ -38,7 +59,24 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
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
+	cntx->hstatus |= HSTATUS_SPVP;
+	cntx->hstatus |= HSTATUS_SPV;
+
+	/* Reset VCPU */
+	kvm_riscv_reset_vcpu(vcpu);
+
 	return 0;
 }
 
@@ -51,15 +89,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
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
@@ -204,6 +237,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	int ret;
 	struct kvm_cpu_trap trap;
 
+	/* Mark this VCPU ran at least once */
+	vcpu->arch.ran_atleast_once = true;
+
 	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/* Process MMIO value returned from user-space */
@@ -277,7 +313,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
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


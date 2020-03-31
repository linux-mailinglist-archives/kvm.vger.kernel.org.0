Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E31D19946F
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgCaK5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 06:57:00 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55597 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730549AbgCaK5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585652218; x=1617188218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=f93m3Pwqq4MR7uYcNhnJxVoaiq/M82PGbYFkIrrD0xI=;
  b=oBvfgi0wDHBW5M425XcWOzjAhrBHMmKhuCheZpuRTD72K8EwcdA3RVNq
   2hGbREFOSTa2lp1wi6TCJsJoh9AqyBQFDKub58NEm4F/6BKSYTUW81Ovt
   z4z/z00i5nA+uWINC0Ifq7Uk0nnE5nVFVxcoU27hX4noWBbenjtP8Q7LI
   mHofS7q8GGvSaRyx3s9xevehoJmswMZoYkwemqWW2g7Y2l1KXFD9wqeAc
   RVVxZsNezre2wAS+lU08EY+AKLPq5VzTbf7Eh/P9q77TAMqq9bPHeyjDK
   GDxJ0Jo1BNDw5DpSpDd3VzmjqUeU2hTGVia4EMislhZM4A3Sy118oBYuF
   A==;
IronPort-SDR: 1jjB6JF1pQrBaDc4/a4UUDmhIGVLf0QMPeTsuE5NiJGCe58UtJkwABfaFu8X+V9s7gu2L2vB8C
 /WrNUlO7lyWuKr1Z8oOqJWHAhKscEMxoZYYVIdVESsD/wV1jeIW3NO0ksKLsmykxB7YFsOZAff
 FUGOSQfpDDnfPP0R97FlyDkE0VvP4wOx76MKgfGBuNfbQF1v2wSB53DlpzeMDcmbkWGJe9iEJZ
 RxiAqByBdlSz88x6+98GAsiWGul6HySIfEW4vNI05CGpmMrPyrSYBZ+0dJ3Xj3tKprZ5lsqj1Y
 g6k=
X-IronPort-AV: E=Sophos;i="5.72,327,1580745600"; 
   d="scan'208";a="134425762"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2020 18:56:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiXDhx5lNgAk7pht7GNb4Jhf/cGWN8bmhHe8a12yN/DDS+gFZZs4m2blcYiIIs5gZie+pydAGOaasuFVUbuAzGFVK5SxGHdyIZNITsQ2+Y1zMrnTdN8R7DpWZH+ZHGSmHPmrIeJXGhqXpXyd+7/wm3+YDIVy67iDYPEr5i/sWXQt62BoanrPA331cMrDyTVF4ikwaQgyhVGdXll7GtJ+2CWwi1fsf5UOUwLLcK1ovArYdEu8NS4Gd8OTCcifHtiD4IUlt/vva9lNDl8TveNTjPTh45y1UIX7DvBY6lOx0SXd0PqAV686CWjRyDUnIBCK0cjuaVRIAbiFcm/BFCcgiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+SwHHRywNudymqN1xblagTufI5lkoQdNPiZq4QSTVc=;
 b=BK/lAVMHRBtQXYMr0zyDHy7czkM5UCyeOFJmJq/0J26n2mNvGy7bZaDT4z68d/VVXukODF++zGVwO+xvgjudtDG73ickHiX6fyCuCSlsZ4sXDAqVGlKz95NFTnh03/33uHrCQkmX0QjYkNbK9lVfKJscqSqAgGtmWSsl8gAxbbWi5APbfJCVyE52J78lEmaoIwB5AaC8tkPU+sZnac5YJXEFiRWLD5q8sJPnYFzoF0a0OgIGiXyAGzVf+nihJ9DjHIadLG4bq+6tMigCir4Eg0WfP/OdouM6k6t5sHD+pDX9Zpig7VPti0afBT5d+siNFdo+gPq4sjVPZ6V/rRWWog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+SwHHRywNudymqN1xblagTufI5lkoQdNPiZq4QSTVc=;
 b=wybJ2yixaFQSuuuj/P5DGl/6U2zldL3p4xMqGbzmBE8UGk2e8z89GpFyhNUI3IhaXNZF+hcMtG2DFex+hgDd9ElY3Rq7UQusY9m5aWnjPi5ogOLiECSknmLY2biILZIOjuEKR9ioMm+0vQ+XUeak87ECTaxKMLlBlcNCRAhml4M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB5981.namprd04.prod.outlook.com (2603:10b6:208:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 10:56:56 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 10:56:56 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v3 4/8] riscv: Implement Guest/VM VCPU arch functions
Date:   Tue, 31 Mar 2020 16:23:29 +0530
Message-Id: <20200331105333.52296-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331105333.52296-1-anup.patel@wdc.com>
References: <20200331105333.52296-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.117) by BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 10:56:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [49.207.59.117]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f7baca54-d4f5-4505-7fdc-08d7d5623a8e
X-MS-TrafficTypeDiagnostic: MN2PR04MB5981:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB598146EFEDC9C4D3A856050C8DC80@MN2PR04MB5981.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6061.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(7696005)(44832011)(2616005)(36756003)(16526019)(956004)(26005)(8676002)(5660300002)(55016002)(52116002)(186003)(478600001)(6916009)(81156014)(54906003)(8886007)(55236004)(2906002)(86362001)(81166006)(8936002)(1006002)(316002)(66556008)(30864003)(6666004)(66476007)(66946007)(1076003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+h6WcW/qGRIXTMOHSO1l/1hnFAyvb8/0vEyyrj9YqHY4vFVZLormXLSvEidFOwH5MoSx80sZBXWBOF8vi7JgGmS1y+HHhYRY3tVuliFRwcrmO8fr/AS82fAo5TSf+T36Gsn8n0O3w8fDLJcQ7l4+IvmR1OQDvCiRYhowwVZE5mNqX8Aj4/uHE0ZWIKaBHaDTl0c1YjUkZVAFSLUnlswQ6Cyf1CxlL/8tbNZr3EcBrJzgMH2JGZKjpBbzue8jxkUyVQfzpzB7Fm/b2CvH9+sZCQyYGlmDtnq8niZ0eu0zViABRU/PbJefHskb7FqLBIJ0aswNC+QLvVFa0O831J/FiLtMyesXr3+8rgbT3cz/mxY28yMlpKh3k405dJbZR50NChBT/YnUOSJiuaZCEWgShtsxM6yrWRuWJHWz3EdOdwUTLU3YfsulNQDEgENGMAi
X-MS-Exchange-AntiSpam-MessageData: FqIChdf1twd5VX3VOVyzHGbCBt0oBr8JSOSe3rDVlEkBTCrHP9rT+6z6M7OIH0pdYR/iLqAOhpHlF963qAIYQ7pAmFZll9wWV79+VCnk1TyTPIJiT6RDK23mRgeRZ8rpFbM5n7RDyAxe9Xw81fO2pA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7baca54-d4f5-4505-7fdc-08d7d5623a8e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 10:56:56.5891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlZausZG7sxuYdvp63Xla+AcG5TZPs3VL8eTHwcoeyIWPnFfAUMfMn1vYDoNcqqX99umPYLxui0IplsQzG3U1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5981
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements kvm_cpu__<xyz> Guest/VM VCPU arch functions.

These functions mostly deal with:
1. VCPU allocation and initialization
2. VCPU reset
3. VCPU show/dump code
4. VCPU show/dump registers

We also save RISC-V ISA, XLEN, and TIMEBASE frequency for each VCPU
so that it can be later used for generating Guest/VM FDT.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 riscv/include/kvm/kvm-cpu-arch.h |   4 +
 riscv/kvm-cpu.c                  | 311 ++++++++++++++++++++++++++++++-
 2 files changed, 308 insertions(+), 7 deletions(-)

diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
index ae6ae0a..78fcd01 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -12,6 +12,10 @@ struct kvm_cpu {
 
 	unsigned long   cpu_id;
 
+	unsigned long	riscv_xlen;
+	unsigned long	riscv_isa;
+	unsigned long	riscv_timebase;
+
 	struct kvm	*kvm;
 	int		vcpu_fd;
 	struct kvm_run	*kvm_run;
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index e4b8fa5..b0cbaeb 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -17,10 +17,88 @@ int kvm_cpu__get_debug_fd(void)
 	return debug_fd;
 }
 
+static __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
+{
+	return KVM_REG_RISCV | type | idx | size;
+}
+
+#if __riscv_xlen == 64
+#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U64
+#else
+#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U32
+#endif
+
+#define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, \
+					     KVM_REG_RISCV_CONFIG_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_CORE_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CORE, \
+					     KVM_REG_RISCV_CORE_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_CSR_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CSR, \
+					     KVM_REG_RISCV_CSR_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_TIMER_REG(name)	__kvm_reg_id(KVM_REG_RISCV_TIMER, \
+					     KVM_REG_RISCV_TIMER_REG(name), \
+					     KVM_REG_SIZE_U64)
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
-	/* TODO: */
-	return NULL;
+	struct kvm_cpu *vcpu;
+	u64 timebase = 0;
+	unsigned long isa = 0;
+	int coalesced_offset, mmap_size;
+	struct kvm_one_reg reg;
+
+	vcpu = calloc(1, sizeof(struct kvm_cpu));
+	if (!vcpu)
+		return NULL;
+
+	vcpu->vcpu_fd = ioctl(kvm->vm_fd, KVM_CREATE_VCPU, cpu_id);
+	if (vcpu->vcpu_fd < 0)
+		die_perror("KVM_CREATE_VCPU ioctl");
+
+	reg.id = RISCV_CONFIG_REG(isa);
+	reg.addr = (unsigned long)&isa;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (config.isa)");
+
+	reg.id = RISCV_TIMER_REG(frequency);
+	reg.addr = (unsigned long)&timebase;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (timer.frequency)");
+
+	mmap_size = ioctl(kvm->sys_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
+	if (mmap_size < 0)
+		die_perror("KVM_GET_VCPU_MMAP_SIZE ioctl");
+
+	vcpu->kvm_run = mmap(NULL, mmap_size, PROT_RW, MAP_SHARED,
+			     vcpu->vcpu_fd, 0);
+	if (vcpu->kvm_run == MAP_FAILED)
+		die("unable to mmap vcpu fd");
+
+	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
+				 KVM_CAP_COALESCED_MMIO);
+	if (coalesced_offset)
+		vcpu->ring = (void *)vcpu->kvm_run +
+			     (coalesced_offset * PAGE_SIZE);
+
+	reg.id = RISCV_CONFIG_REG(isa);
+	reg.addr = (unsigned long)&isa;
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (config.isa)");
+
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->riscv_isa		= isa;
+	vcpu->riscv_xlen	= __riscv_xlen;
+	vcpu->riscv_timebase	= timebase;
+	vcpu->is_running	= true;
+
+	return vcpu;
 }
 
 void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
@@ -29,7 +107,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
 
 void kvm_cpu__delete(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	free(vcpu);
 }
 
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
@@ -40,12 +118,43 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
 }
 
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mp_state mp_state;
+	struct kvm_one_reg reg;
+	unsigned long data;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_MP_STATE, &mp_state) < 0)
+		die_perror("KVM_GET_MP_STATE failed");
+
+	/*
+	 * If MP state is stopped then it means Linux KVM RISC-V emulates
+	 * SBI v0.2 (or higher) with HART power managment and give VCPU
+	 * will power-up at boot-time by boot VCPU. For such VCPU, we
+	 * don't update PC, A0 and A1 here.
+	 */
+	if (mp_state.mp_state == KVM_MP_STATE_STOPPED)
+		return;
+
+	reg.addr = (unsigned long)&data;
+
+	data	= kvm->arch.kern_guest_start;
+	reg.id	= RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (pc)");
+
+	data	= vcpu->cpu_id;
+	reg.id	= RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (a0)");
+
+	data	= kvm->arch.dtb_guest_start;
+	reg.id	= RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (a1)");
 }
 
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
@@ -55,10 +164,198 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 
 void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (unsigned long)&data;
+
+	dprintf(debug_fd, "\n*PC:\n");
+	reg.id = RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ PC)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
+
+	dprintf(debug_fd, "\n*RA:\n");
+	reg.id = RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ RA)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
 }
 
 void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (unsigned long)&data;
+	dprintf(debug_fd, "\n Registers:\n");
+
+	reg.id		= RISCV_CORE_REG(mode);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (mode)");
+	dprintf(debug_fd, " MODE:  0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (pc)");
+	dprintf(debug_fd, " PC:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (ra)");
+	dprintf(debug_fd, " RA:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.sp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sp)");
+	dprintf(debug_fd, " SP:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.gp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (gp)");
+	dprintf(debug_fd, " GP:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.tp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (tp)");
+	dprintf(debug_fd, " TP:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.t0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t0)");
+	dprintf(debug_fd, " T0:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.t1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t1)");
+	dprintf(debug_fd, " T1:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.t2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t2)");
+	dprintf(debug_fd, " T2:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s0)");
+	dprintf(debug_fd, " S0:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s1)");
+	dprintf(debug_fd, " S1:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a0)");
+	dprintf(debug_fd, " A0:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a1)");
+	dprintf(debug_fd, " A1:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.a2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a2)");
+	dprintf(debug_fd, " A2:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.a3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a3)");
+	dprintf(debug_fd, " A3:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.a4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a4)");
+	dprintf(debug_fd, " A4:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.a5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a5)");
+	dprintf(debug_fd, " A5:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.a6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a6)");
+	dprintf(debug_fd, " A6:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.a7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a7)");
+	dprintf(debug_fd, " A7:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s2)");
+	dprintf(debug_fd, " S2:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s3)");
+	dprintf(debug_fd, " S3:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s4)");
+	dprintf(debug_fd, " S4:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s5)");
+	dprintf(debug_fd, " S5:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s6)");
+	dprintf(debug_fd, " S6:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s7)");
+	dprintf(debug_fd, " S7:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s8);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s8)");
+	dprintf(debug_fd, " S8:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s9);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s9)");
+	dprintf(debug_fd, " S9:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s10);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s10)");
+	dprintf(debug_fd, " S10:   0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.s11);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s11)");
+	dprintf(debug_fd, " S11:   0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.t3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t3)");
+	dprintf(debug_fd, " T3:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.t4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t4)");
+	dprintf(debug_fd, " T4:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.t5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t5)");
+	dprintf(debug_fd, " T5:    0x%lx\n", data);
+
+	reg.id		= RISCV_CORE_REG(regs.t6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t6)");
+	dprintf(debug_fd, " T6:    0x%lx\n", data);
 }
-- 
2.17.1


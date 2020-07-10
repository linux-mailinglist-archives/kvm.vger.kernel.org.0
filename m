Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16E621B1DF
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 11:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgGJJB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 05:01:26 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30305 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgGJJB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 05:01:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594371685; x=1625907685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BQZ1Za9H9U0aUcvgBReFX+tUxwlb3hEC3mtu5JmRPXg=;
  b=I9KaE1ae4DBWJKB9JnI6udQIU892Debl3THPGS1LATBTALJW6CtSeTdU
   ngNWm7kuqNtHAmY0KmkAC22miNpY/lbakcPpfkvFYBH2oJeVDHZ7pqXYc
   1IrhEZ1nLzBcKoetRzCm4uvlB2Q+xUdVLaETW4eMIPyAWwhAiXGu/Yz7o
   bPC6RpgptIyO82m3922YIr4+Qc/P+McmLRow0Bt83hdGUq11M/nlFx8Pr
   XTzI64fTcKh6plfTlWnJPUJTylhs1faTmDtKYU0Kvtb3V1zLmdjcaPw3g
   GgtwqhVktCTeb1Sn0Ri91NpKnITJSgov3kd+oskZLW2lq6kgc42QiSwTE
   g==;
IronPort-SDR: Mr/4aPUSd3mEx34eyKT/iNwRfAwNH+OvrjyjI7oYbssWu1u2iVWCwthJdcZmLaxSwhl2YGv/1R
 cXHPIaM5vH6Y/Bu55TR+wII7p2G/oHgeOBqR785T1ZsZdqg5CT3qZLF5Qh7KieviMfR7QmZVA5
 Oyoj3Y/RjUX0fxr6To2/1AR0T1huPUAjaaHCPkQ4ZvhmDGlGfib2yiFbHFAt+xviHcDvqi+voh
 iPlfFle5pO+zC8T5QiC5g0v4LDyE4HwV8lxYb5lRVdFQJVn8Gg7lGSqEV4Fq04MQAaao1cwvoO
 qUQ=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="251358887"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 17:01:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDdfFVx6drvXilmKwqUSVHVnTObaA3WGUBmpzWjN7k+7/gMDiJF7Vc/PG9k6cE3J0L8tjZgLn59civXhjUKFvangk8egkIowi6m5V20vA85omoahE/noHNwGKOBxXrVbhpeVbnwL8HObAcBKsW9wb9enyN9K7a3zZXOMuoaGMXenu4WKi/pW9VkAZj/OKO+IxdqqrSxj1v46Nb8f1qT4LA8rj/pvhpk9hjaa8A2eBaySilj3C6NoslGkYa2F3vwO1UvfnF1FB05tOKEBOsaEtdWOpweKM2QpwQ4jkvQFiGNeWJDYhJM3ak+hxICbScDLVyOpuqew3e492eE/3tBTVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=DCk7/1zz4wPEoCFSSQthVmJy9kc4fAHtcJsBmAZnD3w1KsgTTxDczzLNI36KaPmnu6DLk+jh5ccJiJsPklTtezpUJ2t6gkpNdLvQkjuv/XgKWTgUipuSJwbT6T3c2fk728ZpuZj62GKfU+8ai06/3miGyU8vClVCASrLvanYcr1iiuAtV6Kk2ojMf1XMjq8b5ta/6ToPCNP9ELB+DXohkFfnlSeE+Gooq9+pyVlxgeYxx936ZnEQMZy54FdHt9pvwg0CGy3uNeIPeiTk7Zf0hOttbpFXrZggeJB2UEo9NazcF2L1Ut9qp86blvOUpV1zyrRIzzwfcxGHnNutP17yGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=yRLcUm0WcvTzkTW/0cQWAaF64FGGweNeoV5LHVmtxNDU9ZJyFOLr403j2ORnML6uG8YgTJKYGC//HzuXMpYeBSbiBtFxw3s3rFxu/cHg+jyh3fwpqw60G4brvkaUf5wJRGCIW2m5lN8daIiGXmaNpSUXIy/eBlux5L6nXGCp6rw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0346.namprd04.prod.outlook.com (2603:10b6:3:6f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 09:01:23 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 09:01:22 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v4 4/8] riscv: Implement Guest/VM VCPU arch functions
Date:   Fri, 10 Jul 2020 14:30:31 +0530
Message-Id: <20200710090035.123941-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710090035.123941-1-anup.patel@wdc.com>
References: <20200710090035.123941-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 09:01:11 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b3552280-06c2-43d6-bd42-08d824afcc9a
X-MS-TrafficTypeDiagnostic: DM5PR04MB0346:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB03463E72638EBF3FB3F1FFEE8D650@DM5PR04MB0346.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SoAOG0u1d6RoYBsbT9i/Frrs0IiOWGPLRy5uf3anvdpHNPMCpOpE0RtcN3CqoDqY3xDJ9wcDQ1+zQCvSDiGXqPvZtRrl4JF+N2bV3+e5mi2BzSRXVVrbvlmTAjpNGGnbAWKM0/jmr/t4LSNqDx/McfN4ybL6YNl8sK/6kwjCiNMEwFSDd4LywJJ1Qlm7AC+S/UjLQox3zQb5fA5/M2JtBKktNN5sbHFLcuL2sr7/2QHgqgcpc6zJJeKc9XGJFmWLu+JmOCytT/CXgNfcKAPqihGG1VwJlOsMosSd/KXgFh9O+dggNJ/KrmoEWDeW3ivUZo6G4UgUA1Kxce0ILnPDOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(66476007)(186003)(66556008)(16526019)(6666004)(30864003)(52116002)(8886007)(1076003)(6916009)(86362001)(7696005)(36756003)(26005)(66946007)(4326008)(5660300002)(8936002)(956004)(2906002)(2616005)(83380400001)(55016002)(478600001)(316002)(44832011)(8676002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: b3hACVH3wOQ8tIK7121OvK+tDsiCrjebOESP6cBqyU6GHGNgqFJh+Twa/55bMYPpQvuML6ghMlNv5INKEtghh/zRWBaTHvE1nfMlbFnUgBw1maQXEnq8C6cCsmDXpfqp6oD4KeC0fmuMdBR9IbhulOliBvMyAo25h1bmmaY13I94wKLVnayzbwvwYkg0HARx76fVgkZLXvWJBUjmDwQD+0mkkHEk5BuIRgdV1aTq9slj6GgJhUt2VVk+P6YBYBIGBhK/gTzdXbMS9OWMyQRUFvjsEzw6LNLNoWiM80s/x3ojC72pldzeYKgILTcy/rwngjzFZ1bVoD80p1wWNSiuCFVM3dn74/O3xv+nxdMdCqXJA6FUgrBmr3d7sNqVxNOkRMPLYVFNhe8pd0N5eMnKCAF+M3fCCbR0QrKIxUJVV3BJhpqsZDxgQU3xc/pIpRcHnDAVVZGW+2RQBM4dty5CaARqMqdCs2DY9mTd5R633i8=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3552280-06c2-43d6-bd42-08d824afcc9a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 09:01:22.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cPEDK4bX1PY7poYMsLAgXeQrGBxpqraK+ZOjCIIRAjNvCqmJ1fH4zyuT91iNTKtZ7AaOJb0aOk6Dny1M7BmYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0346
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

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 riscv/include/kvm/kvm-cpu-arch.h |   4 +
 riscv/kvm-cpu.c                  | 393 ++++++++++++++++++++++++++++++-
 2 files changed, 390 insertions(+), 7 deletions(-)

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
index e4b8fa5..8adaddd 100644
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
@@ -55,10 +164,280 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 
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
+}
+
+static void kvm_cpu__show_csrs(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	struct kvm_riscv_csr csr;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (unsigned long)&data;
+	dprintf(debug_fd, "\n Control Status Registers:\n");
+	dprintf(debug_fd,   " ------------------------\n");
+
+	reg.id		= RISCV_CSR_REG(sstatus);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sstatus)");
+	csr.sstatus = data;
+
+	reg.id		= RISCV_CSR_REG(sie);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sie)");
+	csr.sie = data;
+
+	reg.id		= RISCV_CSR_REG(stvec);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (stvec)");
+	csr.stvec = data;
+
+	reg.id		= RISCV_CSR_REG(sip);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sip)");
+	csr.sip = data;
+
+	reg.id		= RISCV_CSR_REG(satp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (satp)");
+	csr.satp = data;
+
+	reg.id		= RISCV_CSR_REG(stval);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (stval)");
+	csr.stval = data;
+
+	reg.id		= RISCV_CSR_REG(scause);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (SCAUSE)");
+	csr.scause = data;
+
+	reg.id		= RISCV_CSR_REG(sscratch);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sscartch)");
+	csr.sscratch = data;
+	dprintf(debug_fd, " SSTATUS:  0x%016lx\n", csr.sstatus);
+	dprintf(debug_fd, " SIE:      0x%016lx\n", csr.sie);
+	dprintf(debug_fd, " STVEC:    0x%016lx\n", csr.stvec);
+	dprintf(debug_fd, " SIP:      0x%016lx\n", csr.sip);
+	dprintf(debug_fd, " SATP:     0x%016lx\n", csr.satp);
+	dprintf(debug_fd, " STVAL:    0x%016lx\n", csr.stval);
+	dprintf(debug_fd, " SCAUSE:   0x%016lx\n", csr.scause);
+	dprintf(debug_fd, " SSCRATCH: 0x%016lx\n", csr.sscratch);
 }
 
 void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+	struct kvm_riscv_core core;
+
+	reg.addr = (unsigned long)&data;
+
+	reg.id		= RISCV_CORE_REG(mode);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (mode)");
+	core.mode = data;
+
+	reg.id		= RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (pc)");
+	core.regs.pc = data;
+
+	reg.id		= RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (ra)");
+	core.regs.ra = data;
+
+	reg.id		= RISCV_CORE_REG(regs.sp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sp)");
+	core.regs.sp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.gp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (gp)");
+	core.regs.gp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.tp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (tp)");
+	core.regs.tp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t0)");
+	core.regs.t0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t1)");
+	core.regs.t1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t2)");
+	core.regs.t2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s0)");
+	core.regs.s0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s1)");
+	core.regs.s1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a0)");
+	core.regs.a0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a1)");
+	core.regs.a1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a2)");
+	core.regs.a2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a3)");
+	core.regs.a3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a4)");
+	core.regs.a4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a5)");
+	core.regs.a5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a6)");
+	core.regs.a6 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a7)");
+	core.regs.a7 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s2)");
+	core.regs.s2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s3)");
+	core.regs.s3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s4)");
+	core.regs.s4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s5)");
+	core.regs.s5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s6)");
+	core.regs.s6 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s7)");
+	core.regs.s7 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s8);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s8)");
+	core.regs.s8 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s9);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s9)");
+	core.regs.s9 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s10);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s10)");
+	core.regs.s10 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s11);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s11)");
+	core.regs.s11 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t3)");
+	core.regs.t3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t4)");
+	core.regs.t4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t5)");
+	core.regs.t5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t6)");
+	core.regs.t6 = data;
+
+	dprintf(debug_fd, "\n General Purpose Registers:\n");
+	dprintf(debug_fd,   " -------------------------\n");
+	dprintf(debug_fd, " MODE:  0x%lx\n", data);
+	dprintf(debug_fd, " PC: 0x%016lx   RA: 0x%016lx SP: 0x%016lx GP: 0x%016lx\n",
+		core.regs.pc, core.regs.ra, core.regs.sp, core.regs.gp);
+	dprintf(debug_fd, " TP: 0x%016lx   T0: 0x%016lx T1: 0x%016lx T2: 0x%016lx\n",
+		core.regs.tp, core.regs.t0, core.regs.t1, core.regs.t2);
+	dprintf(debug_fd, " S0: 0x%016lx   S1: 0x%016lx A0: 0x%016lx A1: 0x%016lx\n",
+		core.regs.s0, core.regs.s1, core.regs.a0, core.regs.a1);
+	dprintf(debug_fd, " A2: 0x%016lx   A3: 0x%016lx A4: 0x%016lx A5: 0x%016lx\n",
+		core.regs.a2, core.regs.a3, core.regs.a4, core.regs.a5);
+	dprintf(debug_fd, " A6: 0x%016lx   A7: 0x%016lx S2: 0x%016lx S3: 0x%016lx\n",
+		core.regs.a6, core.regs.a7, core.regs.s2, core.regs.s3);
+	dprintf(debug_fd, " S4: 0x%016lx   S5: 0x%016lx S6: 0x%016lx S7: 0x%016lx\n",
+		core.regs.s4, core.regs.s5, core.regs.s6, core.regs.s7);
+	dprintf(debug_fd, " S8: 0x%016lx   S9: 0x%016lx S10: 0x%016lx S11: 0x%016lx\n",
+		core.regs.s8, core.regs.s9, core.regs.s10, core.regs.s11);
+	dprintf(debug_fd, " T3: 0x%016lx   T4: 0x%016lx T5: 0x%016lx T6: 0x%016lx\n",
+		core.regs.t3, core.regs.t4, core.regs.t5, core.regs.t6);
+
+	kvm_cpu__show_csrs(vcpu);
 }
-- 
2.25.1


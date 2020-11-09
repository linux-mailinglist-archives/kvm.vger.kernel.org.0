Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAB22AB746
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgKILhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:37:51 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28161 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729899AbgKILhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:37:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921871; x=1636457871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BQZ1Za9H9U0aUcvgBReFX+tUxwlb3hEC3mtu5JmRPXg=;
  b=luSi72zb7hX5H5nP8JkPCHvXFPTe4WviuBNSVk17puOpuO6d6CcxIVyW
   zh1W6/NBkjKt5j2w/CjA08q9PISQIfPhdm9gErE7u4yO+1qEPhQeicP6l
   gBiT+4espiSu4L9kEu05x2XId7g6U5B9cHbWCgrN/N8CGFsA3WgeGxZPE
   upYgUafI9Rp+JCfVT2EzDs0lTDzt5XYh0rQu0SU/hsyl3cbj8hOYjPpeQ
   9ck8XCoPX+zOWtyJRuxy9Yf5z8nFB02aWKgoiRv2+p29AGGjMABxVtn3z
   nOY3HOEzsbREbgGxbUw3+f3ZRWen075Md+Bq5NytJ0p6e7l4wNnKcx8Aq
   g==;
IronPort-SDR: RhyYBqiLej02bOQ19efQYMUCYg9OzPHmF3uYuQLoVvyv4WRUi6i70PGVP9Cp8+JAFkgvA026fG
 Ts694LJ/7lEZh98Aa9INWOCFifVV7pV3D+yf/2D8S1iTBPSPAnxVFB6SWe6LerdSsaPnNfSc6K
 kvBgcv4lXXNwe+wQAUJQRNagMe0qyoNew/4+ewz9zsrBLN8p8l8K0PAiF+ox45rhAvunOf15c7
 HgA0kWWQHj+9x8E0BGkrzDpEGkVuM0bsKYvP0mtlc3kvs36/WvqO3koDkttbKGeF6tfi+K94OL
 wWs=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="153383053"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:37:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7Gm7EYjHUhc2EkXvlgGJls4uILLP/1qoWl4iGdoOeUQa2vv/RqkVFIyC7l4uOkS6+6WIs1r+SqiHWi0B4RDh5pUaXPOg1RmgzxIZn7MqeblHW9IXuhbrcImhC/MJP9rZ/wDczZzONQgLuPN8FsKM8UYSnIYHuVQEHG8mrunyFocpQBfYJExgnPLbDTAvaDnlJgGPOKVTMrz74qI4QOdIDNSJmlUY+nYX/DnpwDcKf71zuXyk+4jNf6/ZyPCYb3avNR5zU01I9vgQq/BmgFN8iRDuA0b3v8rcHw51K+PWezDuf3tZZJWvvSgd6gJBoYJzVa6Wfu4DMFi6bw90/2A9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=Et93JT0KST8UOT+TPuRX56xgMoqknNIRsDww88mGFmRu1BbpxfUTMICLAy2aDw2gEStTUmZoW6BV4fx2JxUF5IMXiIb3W3XbW86gvfjeUDnM3PKUKtf4ZtoowhSINv6C5pne9XU6zqQrXxtuGQiRlstEU22737m9i2aW9U+qLI7TDmxcpeY7SrQdThGXVHpKM+Qy4wL1dXFEeJ2aOM4PWmW2b++deg8dpoTLWcPSfBmXYRZnqPaUY+/8YUiq3XhUIwP3JUVlDvCf1KkdlXLdnEK7WxeVniNTuigy0M6Ol41UJA0j4fE3ZkOHuiOz9EA2DbXJvWgIgJlAirqQlrKFyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=rYfGRbnH9J5Cykmz/VI6PIWwfNcbvfq+XJN1+9M0jQQ9UBAxheksIZqPryqaEZMyad1vcUaTmJEGPIsEL1ALuybzVKZY8ucHts4qjS5ESED62rxfONUOhJlMkKRkDb7f/U+iMGfxI19yWQBrDkpR8tGWlmG1ugOckOc2bI5po0I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5961.namprd04.prod.outlook.com (2603:10b6:5:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:37:48 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:37:48 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v5 4/8] riscv: Implement Guest/VM VCPU arch functions
Date:   Mon,  9 Nov 2020 17:06:51 +0530
Message-Id: <20201109113655.3733700-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113655.3733700-1-anup.patel@wdc.com>
References: <20201109113655.3733700-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34)
 To DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:37:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d9492cf7-1715-425e-a107-08d884a3e231
X-MS-TrafficTypeDiagnostic: DM6PR04MB5961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5961715736DBB1B7978C4A5B8DEA0@DM6PR04MB5961.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zeXT9MKNMIM8E5dk0AiqTgL7PxPiifHUUa6CYgPODnuRkYnpSGCR7LkhutWftRn/sDhy+WCYVGwlTZw40nv+ojM3CkGdjpBTfA5yUUVsu3qqCEfwJen/o/xw4Jj7BWsdSjp6Lt2OuZtWtkMYFSgaaI1cGWcSnUmO5saiH2ill0VIwXGuiTu8uG/X/xriXXW8BgqqSTZHbgprBr3ho81PNCkcmSOaAKuHOycMdaUJnr9oP5mkiduPHXnJeapHqAoHJUMogydD9PVjg0HiSfL+NXvFTdVX09aWY+Q7c1/pEgaJd5bHStPyobPITIK2b7et0jRpP7z8Lvps8kkynjVHCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(8936002)(8676002)(30864003)(86362001)(956004)(2616005)(44832011)(55016002)(66946007)(2906002)(83380400001)(6666004)(4326008)(66556008)(478600001)(316002)(7696005)(6916009)(66476007)(1076003)(5660300002)(26005)(16526019)(186003)(36756003)(52116002)(8886007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jfIp9yEFFXtISJ+1lc9T82KH4q/GrX4waiVLfdQdFEbkiYcuYGuqlS1mP/omkhWPqS2Ol0ZIZhhomSpWbQ7iHfaXI3CMFtpQfkBjzbUaHmvrpBkfCiOzD36RVh25gpT2LdsMTETOXKTuOuLue4SiMYTESnWYBxSR1gwv8doOvWFTEqQVlVKKpb8tLGcFKWXuxOWq3kJtVpj+Lr62V7XWEn4fZDAZ83e1Y547yEtfrFyeyYRvSqOK83Uax7ycJK6fMMm9RHoMdgkWabtbvB4nPQHYxIH6AVMz9Ecwy6Z9LHwnI4fdfjdZ/rgLl20aWuqMSoLdTw0RNvwyPwdOCF48yNJ3yhn2y+HO6Ot25y5/E4+fHwquC1wfRbrzWIFHAWEVylVr7cSun7VYN04YB0jAWRUZZoazvWUZqU+vEUD8xifQbwvsVKE+8ozjici4eOrdxe/y1CVjQgTfbX+fV/zpYnDtWpzh3ABHrpiUzESDBq0FOQteBWTvLPB+IM4YOsC6mWKXDK5PlnharSQbBaBmqVJQK7XMC9nSEWWRNKnnjCEJCmw9s+hWg5KV9otJvuG2mUSw4vsLuNmeJ2BukdOtAFA2w6yi1YcywIySZacOByP7KUo0iHA4DOTKHeW2WMUJ5fMIsulZcvFku1GDA+fbBA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9492cf7-1715-425e-a107-08d884a3e231
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:37:48.6281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrFdHn62+QzscXpnJ9dGZNL/yjPMYV37wUKv5hjE93XoHJEulDq0Tmu55BXnck1jnnVysylonelKeMnLNPbHZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5961
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


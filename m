Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046632F78D1
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731851AbhAOMXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:23:50 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11807 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730584AbhAOMXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713427; x=1642249427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BQZ1Za9H9U0aUcvgBReFX+tUxwlb3hEC3mtu5JmRPXg=;
  b=AV2fw0IxaC3qN/cDhfeRYK2vsevTcpkodVXYrDmQImguvEmsHlj+C7cf
   5SMIRxaGO7myeVIxF13hWW9cCZzp9Cc+9NuHz67HFCbzCr7nr+zCm6gzs
   7m2vgFWlQqJ5O+u+ktuW2eKMDYD4q4MXhSUVnmLPviY5n9MHGUnnyfWqo
   gFXVmASqrJq/XQ88u10DwjVu4aP6AJbdxoTvZZkUyOAiwVMq3xHBdpAN3
   88sVYfQEhJen+2CNeHwBt4dJttkryKEb2eputXGY26GHcdd/FT1/tf+w6
   hhK6NR3A0o4oHrcHd8/YJhN8gyzn5urbjQJ71wX4Urwyqw2ztUSrr8Z9F
   A==;
IronPort-SDR: 4dVlGUVvgH3KD595wBP/gbsRzjxnd/YTyQwJhytPGT/du7v9dIW9H1fbWQx4yA9S47srktsTkb
 d0m8TNgAlMOUBq/pxTTb8sVzxLJVHyhPgrTqo5O8B7/O90Y/LHE4q8Fo3Lo7mtDa7LTPpSkNyQ
 f57likEtx7yXMNWf6QkmI/7IySSzY/pj9vJornHc6iVRKqPKWUuGJFoDQe9Arv6u2ASkCR5CUY
 Ufo+DfGJQHijy+PDN2MnS+iR+rbOYrDksAR0RKepTzYaMAaHrWkx/4uuNaBe/yGUNC9bbFD3AD
 7DQ=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="161949706"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:22:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZO2hPelK0BxoqelleRKKMIM47j7FGqCuKEoPkI1Bs2/jbnMZq/MmzVl9GLdSHTGVkvP9ju1qArseKy2CJAcH9p0uF8uDRDQFdQ7jz6QZ6H8W4bI66Kp0jCZM1g8rAcWVe5LeUM2NkIiF9eiNx9ow6b6SCwVX1ZN3DzE0V68JJe5hlCYOzxp0f0LXWRIZRMf1Lz2fyyBvns0YTuzMvYMybpsJeeVrIEYSQcHofSodeQK6gZiPbuMcxGcSa3eHfWCKylGkVGvdp11oASkjYzwrfdebjxyW0SnFJmJ6qI9INVMvtthEtdNU2latGF3/Swml6YH0lsaMZwNvClXGmn+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=SbJpah7yrSYB5jCUCUKEz2i4khGZKEj4Gtib7e5GWDyzdMwEGzh2e8EGD0RF4LYeEigiy+hYwUu/AdvEzo8UgfEft79g0b7g/glbFd+aVv+AzaP/Iwj24YRMzcAf+BusN6OyPuqd8L43TWSN75L8JsdFInH6boYx4Nx2t+l8cQQWhpPTCmnafylSczz1p/Kds5lsvhq+P7AXU7GoiLRtxiRedJAsPdNK44BRsJRr3Yp6MIYhppmYhbf3dZovk/diAc1u7QTpAORZ+P9xqo46I4MHf5lsjSC7Fi/MeiS0Hfckynk/pX+Xq1EQebjxF2iuFhglO9PitzpcPZJ5W6lqRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=Tq/q3siUbQHHhXRUAeWxv+3Sc8BrQbCtHdINEnUHiYKVNIDACf5KIOyb9qri8bhRFoIUfYaT6j6NpoLiYme27BzDwZVcaSW+Oe8cW9XoZHxHJ/bwTe/NMd5OKuKsyWZOWCCoB2NBtIHD52sD8XwNvi2cAemAGL4K0QYTq0HaMjQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:22:41 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:22:41 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v6 4/8] riscv: Implement Guest/VM VCPU arch functions
Date:   Fri, 15 Jan 2021 17:51:56 +0530
Message-Id: <20210115122200.114625-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115122200.114625-1-anup.patel@wdc.com>
References: <20210115122200.114625-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:22:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1cb616d3-eff0-407e-a812-08d8b95040a1
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4330407480B569E0AD0B57EB8DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1A+QVCzEGbtPK9ca4l/BUIpy0FI+JzYcZS61Ag1iTAIPeMUzIm56tlouu5NQLqnYLkm0X4toQCvrXL1dnPlwkjrb+5syO7n6evS21/snv2AGxCnF8S0iovnv2SW396eadE7ALNHFAxPA/uJyDxkkzDIWyztTIiP6rYksKvX0KMVDQN+vEkWoYNFiOekhugu9HYFO68AbqYI8foVyb47q6/BM1zIlzgpnSP7XsSYiDcL2MgQbc4lsgZ4dGJoDk1251kj8yDUCEfnA/gMohv8e6HKA35WvWkIHxF6vJSM7SYmEwopjkium7LvFFqm/PL4mmz4N/8YgoeeTugeb0gIBYlwbxBkK2vFx5yQ+zkMuK3wlsktU2ByeT747gW+sbigUIV1Np61xyo/b9/hwb6f52Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(66946007)(316002)(1076003)(66476007)(8936002)(186003)(66556008)(86362001)(16526019)(36756003)(6916009)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(30864003)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RiEj2ztgy28JVmEZuXb+NFER0Ca4mNPoITdh+Kd6fu7TwL/0f4+S/6SOKPZI?=
 =?us-ascii?Q?IhIvRp2lFjMK2lHiDKimx7Fh3QRaDz4EnMVcSVcuD+VV0srdBtGM+va2SebO?=
 =?us-ascii?Q?smwXOdFxuaq88XTlkJiYy4GJzdv8TzILbIBg4npcy9HGJwSd9dJkAkRwq+ot?=
 =?us-ascii?Q?dNW1QxgTCev6LzV8YTx4XG4FCuJp3NAvglQDk61TtyL58n7AXYT1AQoK7+fc?=
 =?us-ascii?Q?4QRov5wm0jDFLp/rG7m+V4F7sBUuKmG5QAUn6USBQFlKfNxO7VgSIih3kzd5?=
 =?us-ascii?Q?Gcu97HBQMPFuwpzRp1DCmmShXJsyLjbg8RGdphcYxdLHaCVqJAXadSsy/Y6V?=
 =?us-ascii?Q?KN3Csrw/n8uWTsoRG8DlNgspoJlJJ+V+joDbZxluGXhmgw/QKxDoVG6/ZXYL?=
 =?us-ascii?Q?zb4S/urDzVJd8zGRD509UECceFw2VDnS+xY1nv00jiHBAAMLL/Ay3xrWQjON?=
 =?us-ascii?Q?Xt1XeGPhmEC3EZ8v5M/idcAL0lI1IgWT5QYul46lQAEcFETQbPPM/b2Ci8kq?=
 =?us-ascii?Q?bthDGQwJUu5O31iKBQI2spZfopBqoyBD7mnSeC5USRsaszGJH69nYULW4PoB?=
 =?us-ascii?Q?h/HD0fMEcwHMmFY/sAOBYU4o+BK+EECayiZIF9YY5AcigD4v6ozNl4gcaGA5?=
 =?us-ascii?Q?wNRW26ujtwW0MZF4zfmWDeXTxLj1VFuiMFho+JW5hTb0D3ZZ+bhDXAOR3/7l?=
 =?us-ascii?Q?46RylgYGdJ4wnz7VbJK0z9UDNYKaey0/dXp9SHRbcQSZCPT+Gb/wIYbBb8cW?=
 =?us-ascii?Q?JdTPDYSNq77bH30ONQiqQLxb3FPX2r5GWm2c2whvQEY/F+6+FW8hB92DGhc5?=
 =?us-ascii?Q?pnBWMdt6UrW8lNSOCOVV578Joc31Ai0SKdCt4bu2lojoOoqxcWL1z8VXDRfU?=
 =?us-ascii?Q?qx704+kfhs2JRucZ3/7NihGfAs4ABviuzuTRmP9OmZE7B2W63DtZhQYctc+h?=
 =?us-ascii?Q?Gyr4PhD/f1YnABTdavZZ50RimDeiGiSCSGL3XDDS0ARUD6101Sfo+JWGb1Hf?=
 =?us-ascii?Q?YjIb?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb616d3-eff0-407e-a812-08d8b95040a1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:22:40.9201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9lbU9Xk6vhAb9C9bQAhLw/YTpA4/1bkV5IS+sGKxyveP0GvwBCn0utXcuzlK01hTmfTE6ACyA2qfOG7AjVykA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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


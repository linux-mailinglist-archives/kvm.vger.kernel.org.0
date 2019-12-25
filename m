Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838CB12A5B7
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 04:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfLYDAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 22:00:30 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60709 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfLYDAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 22:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577242829; x=1608778829;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+eY7UwcGW1TQ1xVqRTxG+DnSYAtMBXh/oQGI0v+94wo=;
  b=GeKLGDmDTBZLwkfBz9ofiiClj/5xbK/tX/C/WKW0dzX+feR/zCoxwYtC
   31g8yipK3KjxdpkuV2xHlOkqZewBPtuNKbJVy/BmyunBlqdfafXLOGLJZ
   3D7uvxYlLh7ueFJIjI8WACsAvnmaJBQgBYp4FCjECv4VjWs65wHabNXuE
   tfpKS3xhS6ZgUN1ZKo2pVdXDKN8qRUbB9CXt16KlBhdk1YMFptEacAHHy
   ovq67bOibDy2cYIJQlYxKwFNez9f+nfM8VKgOQ7vSqyoSbSSqfn/wUDV3
   JLVnTafM99rxROfLUTN8CaJh7jkyGuL9sy7SDHumSBNfLadsDFHiWVD0P
   w==;
IronPort-SDR: xzyJtRzz6aaBDltoGmi2K6AtO3It2oHjnQUIyJcjyYxJ6NoRbdWO8faxGSRgPOt6Jld0dcUG+G
 N3Dh6ES7xnXuNHbhOOyIZGOZ+VF6+icJmV3W37c/iiIwCKDJhpp3YGGtFArtuxS0Ox5+Auk9ta
 aDCywjUTx2ybY+NlswBREHF6Ej7svfgEHD01dMfy0dOZIpSK6xLZ62ksfuGn76hMxvgbb+Fbta
 EBrAmd5KCBC18dp4S3ZkJVoQiadOyemL4IWi5hTiMsMPMY2+NPsNJHFZO5Ew1u13Wp4FiLycgA
 f/A=
X-IronPort-AV: E=Sophos;i="5.69,353,1571673600"; 
   d="scan'208";a="126854682"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 25 Dec 2019 11:00:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbKNV/9tKE0ikMGgsJhQfTgSNbMn1E4dL6lAIrjcHtmQzVtiP2tMJ7krrUc+hPIYejtnqWkNSY5CaBtBH1J9Rf0i9C2Mxe/nrrhoizEpLP+oheRuy5+z1sY9gHoo6nCZWT7kyjKGDQhl4meRGXbDyza2VrLEJCuIO6MfpOOHfI2or+UHbpjNRPKDtIBX8LemS/mwFBlreMh5mP/ZNs9NMuVqbnpg6cfIeoOIP5SvECgF8o8o8/MTYnzOH/ZEntXisBFejWPQ/XBXemQANuXp0ms0xtUhBKyrv9TrRTpERzGfgOasX6y61Nh6/7fYrLxCsfZt1ckEhQDjWqDr21c93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lunjEF3xLLuQo/PJM+P5xoW0YLs8DF8eyWrT6+nz6BY=;
 b=Rz1BhlAWBE/bwvDWF0d7htZbhMt8164txQJxu5wB/+qOe23p0svRir40/UGyTIFftn8YsgN8KCfqQXfU3dL58ImIZW9rXq9z5McVIeruIM7S1bHGKipbwIyHW+YR9Pf6Ncx21WMkfck6PTysn22gZkDDoHkRXpOU/lJxJaNncT9TdFycjR4oKb7mckwSaSzT82IIk6kZaL7cnfgA50d4lE1Qrwf3GQnu37O0V9buLfSEZWziR6lZ5Jrtf75plQWFlpEn9WYmtL+VNObF9EKmZ9z5RulNbPxsn+lWXQl3VZdxz1mWUemdmZNMqvKsnvHPNKaDQ/1MWZEhpcwjTspovw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lunjEF3xLLuQo/PJM+P5xoW0YLs8DF8eyWrT6+nz6BY=;
 b=zLwE/Lh55UvGVdCAI+WTl2cJPy4ewvwPNNBUEVmZKRxME/ZORYSeGe+Aci9x3wsWTER7r6YPGTfPPvC3MH0XWFUEJpWEQNt8zAMHCr/up6vHau1fctJqwIqGXBU1fjzEUP8L2jHOI6Zr9fPjLh+9rTueWvHfCzlk56nkN4OzeZU=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5597.namprd04.prod.outlook.com (20.179.22.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Wed, 25 Dec 2019 03:00:27 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Wed, 25 Dec 2019
 03:00:27 +0000
Received: from wdc.com (106.51.19.73) by MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Wed, 25 Dec 2019 03:00:25 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH 4/8] riscv: Implement Guest/VM VCPU arch functions
Thread-Topic: [kvmtool RFC PATCH 4/8] riscv: Implement Guest/VM VCPU arch
 functions
Thread-Index: AQHVus92sNNicOn2XEqL3+OyR0jqEw==
Date:   Wed, 25 Dec 2019 03:00:27 +0000
Message-ID: <20191225025945.108466-5-anup.patel@wdc.com>
References: <20191225025945.108466-1-anup.patel@wdc.com>
In-Reply-To: <20191225025945.108466-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::26) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.19.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8605f17e-5436-4ef6-2f0a-08d788e69861
x-ms-traffictypediagnostic: MN2PR04MB5597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5597437235CDBC13F14E0A258D280@MN2PR04MB5597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(5660300002)(86362001)(2906002)(4326008)(54906003)(81156014)(81166006)(66946007)(8676002)(1076003)(6916009)(8886007)(71200400001)(44832011)(66556008)(64756008)(1006002)(66446008)(52116002)(66476007)(55236004)(7696005)(16526019)(186003)(316002)(26005)(55016002)(956004)(2616005)(36756003)(478600001)(30864003)(8936002)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5597;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V7o5gYGMWvyz4wqJC/EOvn1Tt7NS+HT0/rs485DrwwL9v2j8YBcr9wmyhfVL8hpuQlW+D83JQXLIfmMPI4h5dRp+Zg2X+1Ie+Orl8/67fCQxqPr/ZtrTWMVAAALX9MUzXz7kFBFF0AGeKpT4Ik3/4Yk2V4uhKYgke9Q8AA2myMvg4pmYs+6wGMvh71N6Co2wWTdmyO2HUHqzdo18p1rOnwbKsEI5MpNUzVLtSRq//P3Q5TLXg3zT/gv+u243+P9/cwKfFmjbWM4hqf/cBKTQ1fj/px0sjd2/At9UtYDtJsqGieAzRN4o9yljAX2btmTTeta1wcGEJVRRbgQzBLWZ7O7k/DdRlIC5UTASavrAuzKkvQoZIcI7axseDzDTFsMDVvOHyZ36dlTnnWp8IjZCZWacjXMV5PdsoYbgbQcqngleqay5uPKmBJ1U0DD2GY3fo/NG5lG8/FdOt6xRikClLCsG+uXwT2qxugJo3zJ/GPMBL5+EOXEXQEJDdbEjhec1
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8605f17e-5436-4ef6-2f0a-08d788e69861
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2019 03:00:27.8674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vVeISnIcGHZONxCrzyX+GN+5yGRmGOiJuIfl4l6iVi7MfuDoUVX1k72M/3YXxmZFruoeE9k7m0VMEPQLI8YNGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5597
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
 riscv/kvm-cpu.c                  | 307 ++++++++++++++++++++++++++++++-
 2 files changed, 304 insertions(+), 7 deletions(-)

diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-a=
rch.h
index 09a50e8..035965e 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -14,6 +14,10 @@ struct kvm_cpu {
=20
 	unsigned long   cpu_id;
=20
+	unsigned long	riscv_xlen;
+	unsigned long	riscv_isa;
+	unsigned long	riscv_timebase;
+
 	struct kvm	*kvm;
 	int		vcpu_fd;
 	struct kvm_run	*kvm_run;
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index e4b8fa5..1565275 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -17,10 +17,84 @@ int kvm_cpu__get_debug_fd(void)
 	return debug_fd;
 }
=20
+static __u64 __kvm_reg_id(__u64 type, __u64 idx)
+{
+	__u64 id =3D KVM_REG_RISCV | type | idx;
+
+	if (sizeof(unsigned long) =3D=3D 8)
+		id |=3D KVM_REG_SIZE_U64;
+	else
+		id |=3D KVM_REG_SIZE_U32;
+
+	return id;
+}
+
+#define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, \
+					     KVM_REG_RISCV_CONFIG_REG(name))
+
+#define RISCV_CORE_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CORE, \
+					     KVM_REG_RISCV_CORE_REG(name))
+
+#define RISCV_CSR_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CSR, \
+					     KVM_REG_RISCV_CSR_REG(name))
+
+#define RISCV_TIMER_REG(name)	__kvm_reg_id(KVM_REG_RISCV_TIMER, \
+					     KVM_REG_RISCV_TIMER_REG(name))
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
-	/* TODO: */
-	return NULL;
+	struct kvm_cpu *vcpu;
+	unsigned long timebase =3D 0, isa =3D 0;
+	int coalesced_offset, mmap_size;
+	struct kvm_one_reg reg;
+
+	vcpu =3D calloc(1, sizeof(struct kvm_cpu));
+	if (!vcpu)
+		return NULL;
+
+	vcpu->vcpu_fd =3D ioctl(kvm->vm_fd, KVM_CREATE_VCPU, cpu_id);
+	if (vcpu->vcpu_fd < 0)
+		die_perror("KVM_CREATE_VCPU ioctl");
+
+	reg.id =3D RISCV_CONFIG_REG(isa);
+	reg.addr =3D (unsigned long)&isa;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (config.isa)");
+
+	reg.id =3D RISCV_TIMER_REG(frequency);
+	reg.addr =3D (unsigned long)&timebase;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (config.timebase)");
+
+	mmap_size =3D ioctl(kvm->sys_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
+	if (mmap_size < 0)
+		die_perror("KVM_GET_VCPU_MMAP_SIZE ioctl");
+
+	vcpu->kvm_run =3D mmap(NULL, mmap_size, PROT_RW, MAP_SHARED,
+			     vcpu->vcpu_fd, 0);
+	if (vcpu->kvm_run =3D=3D MAP_FAILED)
+		die("unable to mmap vcpu fd");
+
+	coalesced_offset =3D ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
+				 KVM_CAP_COALESCED_MMIO);
+	if (coalesced_offset)
+		vcpu->ring =3D (void *)vcpu->kvm_run +
+			     (coalesced_offset * PAGE_SIZE);
+
+	reg.id =3D RISCV_CONFIG_REG(isa);
+	reg.addr =3D (unsigned long)&isa;
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (config.isa)");
+
+	/* Populate the vcpu structure. */
+	vcpu->kvm		=3D kvm;
+	vcpu->cpu_id		=3D cpu_id;
+	vcpu->riscv_isa		=3D isa;
+	vcpu->riscv_xlen	=3D __riscv_xlen;
+	vcpu->riscv_timebase	=3D timebase;
+	vcpu->is_running	=3D true;
+
+	return vcpu;
 }
=20
 void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
@@ -29,7 +103,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
=20
 void kvm_cpu__delete(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	free(vcpu);
 }
=20
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
@@ -40,12 +114,43 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
=20
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
 }
=20
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm *kvm =3D vcpu->kvm;
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
+	if (mp_state.mp_state =3D=3D KVM_MP_STATE_STOPPED)
+		return;
+
+	reg.addr =3D (unsigned long)&data;
+
+	data	=3D kvm->arch.kern_guest_start;
+	reg.id	=3D RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (pc)");
+
+	data	=3D vcpu->cpu_id;
+	reg.id	=3D RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (a0)");
+
+	data	=3D kvm->arch.dtb_guest_start;
+	reg.id	=3D RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (a1)");
 }
=20
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
@@ -55,10 +160,198 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
=20
 void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd =3D kvm_cpu__get_debug_fd();
+
+	reg.addr =3D (unsigned long)&data;
+
+	dprintf(debug_fd, "\n*PC:\n");
+	reg.id =3D RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ PC)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
+
+	dprintf(debug_fd, "\n*RA:\n");
+	reg.id =3D RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ RA)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
 }
=20
 void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd =3D kvm_cpu__get_debug_fd();
+
+	reg.addr =3D (unsigned long)&data;
+	dprintf(debug_fd, "\n Registers:\n");
+
+	reg.id		=3D RISCV_CORE_REG(mode);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (mode)");
+	dprintf(debug_fd, " MODE:  0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (pc)");
+	dprintf(debug_fd, " PC:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (ra)");
+	dprintf(debug_fd, " RA:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.sp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sp)");
+	dprintf(debug_fd, " SP:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.gp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (gp)");
+	dprintf(debug_fd, " GP:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.tp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (tp)");
+	dprintf(debug_fd, " TP:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.t0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t0)");
+	dprintf(debug_fd, " T0:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.t1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t1)");
+	dprintf(debug_fd, " T1:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.t2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t2)");
+	dprintf(debug_fd, " T2:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s0)");
+	dprintf(debug_fd, " S0:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s1)");
+	dprintf(debug_fd, " S1:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a0)");
+	dprintf(debug_fd, " A0:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a1)");
+	dprintf(debug_fd, " A1:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.a2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a2)");
+	dprintf(debug_fd, " A2:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.a3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a3)");
+	dprintf(debug_fd, " A3:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.a4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a4)");
+	dprintf(debug_fd, " A4:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.a5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a5)");
+	dprintf(debug_fd, " A5:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.a6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a6)");
+	dprintf(debug_fd, " A6:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.a7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a7)");
+	dprintf(debug_fd, " A7:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s2)");
+	dprintf(debug_fd, " S2:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s3)");
+	dprintf(debug_fd, " S3:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s4)");
+	dprintf(debug_fd, " S4:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s5)");
+	dprintf(debug_fd, " S5:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s6)");
+	dprintf(debug_fd, " S6:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s7)");
+	dprintf(debug_fd, " S7:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s8);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s8)");
+	dprintf(debug_fd, " S8:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s9);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s9)");
+	dprintf(debug_fd, " S9:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s10);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s10)");
+	dprintf(debug_fd, " S10:   0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.s11);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s11)");
+	dprintf(debug_fd, " S11:   0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.t3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t3)");
+	dprintf(debug_fd, " T3:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.t4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t4)");
+	dprintf(debug_fd, " T4:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.t5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t5)");
+	dprintf(debug_fd, " T5:    0x%lx\n", data);
+
+	reg.id		=3D RISCV_CORE_REG(regs.t6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t6)");
+	dprintf(debug_fd, " T6:    0x%lx\n", data);
 }
--=20
2.17.1


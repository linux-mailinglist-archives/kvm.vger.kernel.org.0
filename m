Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3404E14A400
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgA0MgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:36:18 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45051 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730628AbgA0MgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:36:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580128578; x=1611664578;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k5KQ2PTdzLoy/DM8odM6j0b0hj/ekFquF7HI+weSs68=;
  b=PRoYeJ1jfp1xDcpYh5rVqPn31U36nfib5zR8KdGDbl4LwesrZSGgV+Oq
   W4xWl35HBYsDre2omKjw2JNHrXPMZAWxtlmmQdRJqfMn1Ih0Q4HB47LpN
   YPxbRwi/v/0TKW1/f6pRUbN4W4Ge735pd3q/K3W0tl7+RzKu4+0LL9Arn
   4kejFRV95lOHORL7v4Ii4Xm+7m3ydUk0lzhHyNDIL4igJJgy/RG2rAQTk
   nx+iMwy0qQ3d5AuTsVzwZohPhTbLeGblfwfE+/H4y8pHTYRXcWTobi1/n
   cZC9cUAkcSvTm/ju33/ZZ2qla4tqJkXOigVL2Svo89tmkMOiIDkDXA9IY
   A==;
IronPort-SDR: bzH0XTGtHyFg3QsxbDPRne9Laf33sRbv8bEuYhtFHLPOmMlBBfStPa5mIl6RcORccjLXf+6g/N
 zLJcWg27Lo0Kw7gU4MJo3CwhslgQPX6pZ9DS6vTw6qOkt9bHj8AwwKL7bhwDHMRcsm/euYCfiO
 zbPVJytfeFsHJdvPAUi4rHXlaukS3uaM+uHZT52nV2T8IdUiBveeVRg+K2zWB7eb8WVC8O3jEC
 7VoE/dZyREQjsOCNLLd+weaDyNvX30yjtWMgaUKDEUu/W8xvlSYvl2dPBuaSKGYE8QOMUJ9Vuk
 Fyg=
X-IronPort-AV: E=Sophos;i="5.70,369,1574092800"; 
   d="scan'208";a="129052157"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 20:36:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuPAluwQhUe5WZghaXzTTaZu78nePdFlt14xDFeYcl5CoOjX+xcEAIm1dzYQr5OoDIbtDBnsG4IlWCIeu7GitaSm8/3euyZKQfWldqQNWBQU9olj/EaRDcI/MlQqZx9CNnATopaRkVJ/cBp9Co2Ze2OD0wO10LUqiXMIyRSVMGjOzxt3lyqgVWb6/1H2Z2d91ucIKzeoiKn7WTPvlPtxIelONrWnzEUuYW11cnSSkU+jOVcGBK5TEd7kxyqrA0b0E3guUAtD94Pcm8Snc3Ay5sS3oto7Vpn2k2FAMhFlrYt470f9UCyWwvUxQAYhJhPpFmIuXjKZZozlLsUGWUOhTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go2EhmsJzCzq/Go9gWrpDYtpor9kYS+VKhvR6bogtJ4=;
 b=oPWzBC331vL0FM3dCSNAW7QcWxvmHrdt7p2IV+zDku0Zgfi4+DPYuFTS4w+2KiMNgRYhPcSBIUoGGR9fHUDAgB7owjEIQNKNR4oygLyLbj4PfeCnKr3obLZxUs/Q+jZ801oc5Jl+aVA9MEeJa97Ua3HULcOM+YUP30M3Dav/WN5CLwHGEQlW4cwHteHbipw8/gkdrlS2LUcjGYEe8THS6X3QfFW3i1e+oNrtT6//aKv7Xc0gqsXXk44Th2Ts8h0WNlvmiv4/YsWGfKauQYvLchKS0pAfHx1+61Y/Ree5NQAKpJxeOe9pr32jGVQpkX7dLMYFCwVd6ddyUAhBufx87A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go2EhmsJzCzq/Go9gWrpDYtpor9kYS+VKhvR6bogtJ4=;
 b=KTU5XEXitOyb10jSjJTB9AFnH/QCfJ+iSawSwJvg1amnYOCVvR18Ac7cTaSweAp1xSNEoAslJj9937WMCzp7vF8lqzGzDCrJPG8M55IzWJDSRaIU06RwzgwvxfzsHOqCmxTlljLQY+zevDu9TYWhzXytbijBfF5TJmofT56wY84=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6816.namprd04.prod.outlook.com (10.186.145.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 12:36:15 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 12:36:15 +0000
Received: from wdc.com (49.207.48.168) by MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 12:36:11 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH v2 4/8] riscv: Implement Guest/VM VCPU arch
 functions
Thread-Topic: [kvmtool RFC PATCH v2 4/8] riscv: Implement Guest/VM VCPU arch
 functions
Thread-Index: AQHV1Q5dZTJTZ88F6UiYtHeM3xmjIQ==
Date:   Mon, 27 Jan 2020 12:36:14 +0000
Message-ID: <20200127123527.106825-5-anup.patel@wdc.com>
References: <20200127123527.106825-1-anup.patel@wdc.com>
In-Reply-To: <20200127123527.106825-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.48.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 60da060f-61cd-4bdf-d581-08d7a3257fa7
x-ms-traffictypediagnostic: MN2PR04MB6816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6816643453068E3E1F4249468D0B0@MN2PR04MB6816.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(44832011)(5660300002)(2906002)(55236004)(54906003)(86362001)(7696005)(4326008)(55016002)(478600001)(2616005)(81156014)(956004)(8676002)(52116002)(81166006)(1076003)(8886007)(8936002)(71200400001)(66946007)(26005)(1006002)(66476007)(6916009)(66556008)(30864003)(64756008)(16526019)(316002)(66446008)(36756003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6816;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F8I2UUn2epWhGp5zwb81ArfTpPkklzCMhpAJbt08qee2K3ydBZ7fbuy5RR9pjwKEEe3gviSqtey5Z3uvLCQGu97rIp8qiPZgdbFq08a8mv/0/49r4R7Frt4IQwTo/888vxUV2FI/F/se5LUXbU/ry5o5dqhNtAga5fI+oEA5cWkyM5+YP5OWe5BNTNMjIYpHX6RliVIoll2D6uLrIbKsk2H58J3gE1bRF6Vff0mlTN/1Y0jIoG7RBOcH59CJJmeSMGYZGPh/p6QWO9Pytd5d+JOy6jX64lUZPXjLgbalUf63EtnRP+6ZTCCqEyX7sp0YwF5BL2TP87XcT4o1CRgHjVviK92lb0dYzEdLLl8j5GcvoumfM9qbIDg2342/cVPV8NF0etcmxWwQvS9ORXgBSVamyCsCIhC6bv+OVvgxHnQY27TiqLOQUGG+ALcUQkwr
x-ms-exchange-antispam-messagedata: AMgiOzow3/PezwU6RojkhpjuwOLuZd3whEB4k6f0pSj1A1gKCK54LcbJ8vhuJsEEx+VmVYWtpiNnuBDZXLpHjMDW7yNYuQV+5vtRZ4UmirfD2jHK8x10K7scjhbDXSc+G0mQmW9klXwaH6QH0WExlw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60da060f-61cd-4bdf-d581-08d7a3257fa7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 12:36:14.9176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3VM+AqKCKdSZlYxc9h2rqKYZdJYogaTqrl5juo6s5oD7baNozK4qUUjpX0LH4Bb5hHFQwXnkLhruEFRuxNFiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6816
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
index ae6ae0a..78fcd01 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -12,6 +12,10 @@ struct kvm_cpu {
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
index e4b8fa5..cca192f 100644
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
+	if (__riscv_xlen =3D=3D 64)
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


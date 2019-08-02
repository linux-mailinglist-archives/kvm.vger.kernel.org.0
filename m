Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FAE7EDD5
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390222AbfHBHrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:47:41 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39373 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390136AbfHBHrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732113; x=1596268113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HcUNG+bvSzML3tAhjghFgWzynDkI5mLZ6wunYrD6p9c=;
  b=Ie4FT+ayrTR/LGCa67ZlYNLeQzt0WiHJtTBtQIu6NuXfYS6tq2wDU9b2
   OrWkQRZtAtac5SOmu17UaE3g0oup5nXSzw9JcW+Xy5D9WQcbwBXtEPUX6
   cM0xLPqgKQ8ryF+q1Mcr4d5Y83FAE8CxYsvOPEcgUZ133X/13CoYKMsxo
   GZmCLeKIiY0edh6ZTivSZFK0vVidyqexQkL1b2eczvkKzxI6a5hd+cs88
   TrbYBpkor86mBawkrxlhbWZpG8u/aOgiUleGq6EW/SBVgV2sLX1aCpOky
   Zmzie6WDCFMLMdqnD4ULbj7qDHWqcwBDKx8WQlV/fpcM0GKkXZqkH+j49
   A==;
IronPort-SDR: 9wfHfdQv454SHORk2r2UOLHwxtn9B02Dbyz5Md6ckc/n7JASfiGcUkZqcOhCcrXFBqaVuwYrlU
 fUpnr3NYditZoUaJvQAhjvelDw6fJHo8gZ9WZZDRGtVqDQw3lL7Ki+GpXGYS08hsSaqkRanbXH
 taAzBbCfUW2Lkks15HtP4rqldt3ktIT27SpISHHLSaqxd+lMZPW9Gki6GH3MnPN1GLtkrZofwv
 R8+470x01kgCbrFc/+gSJhoTolizjcTpNqF4tX5DC9tMJzzVh9WZREl01q/pcmcZdzKvWgR2e4
 cSk=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="215006655"
Received: from mail-co1nam05lp2054.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.54])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:48:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSncNJc9kJ3YJAqFovoEadYLAoZJkgQFiAfxrmIRu/5kmhIypsTRTWSJ4Q0AViaeQIyOpxY4QiVDdbIxdIpY2U67UlKK6aDXKu6+EuZCQnNGiWhxYX0sx+CF/DTxClLxs0KZYCDYPkqHerKcYziWvkTwByA5oUg+3/1JL/ahICzbrCyfng8JrKJrs61rwpTLcHZ55lFPdNmHaSkuxqzVMMTJiLs51fQb2FRoMQic5vUKiAzLMDgARgz3cvp3yJFBNNfG9yldYkaTcoCm9YwnefKDfx5+q8g+NbZGglgUyvLLhvP6yo0/w3gp9FBOFrKRhUqo1FIlC+Vz+Jn0nryBRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyzyXT6fqfFYjAeL6speBS20St9euLEIdYUuIzmehds=;
 b=PrvH6sSXTfiyZtQoSXnsaBv26UHCfZPKTSA3Xhw+2hszhWDPawvxR6sAAsbhPvC0gM65v+PvkJxHJ/kCT5cER99M1ORd05BY0/ZmjgPx1tnd+Uhm5ioDwmgQ1cjlyoylNttq68OMwP7e/JVCahsqOrg3abI0ohb6ipLAv3Qm/46/2LEacYy0yCQHOkR5vFZVRj8zrod+fTAbMobkl6JJXEQ8D48dXBmLLMJMqjIdmEpWmPG8j7EzL6skTha9H7DrbjOV98QqulqnbvP1YsUbuqCJMsTmbeSu8tSIbepdPY9KcTo93hpuGsDNMv8uduOR1nBWJT95ZXgn7yVuRrPBag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyzyXT6fqfFYjAeL6speBS20St9euLEIdYUuIzmehds=;
 b=KrdvqcuVXeeg670A7kjr22J4MBy9YSZlmHiDJ+4ePdJv5UfO3vyhiI+Ks3p1Ptf8ddhSXwOAE/T7qfCus/A8pqxvFrnDJ6a+9noB0QkCXY/b96NHm/1nLBs1a7+WF8RvRawXcOcRDB7pdc+osKi7FdjckMsL/CaVkFVpJ2ER6Ys=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6032.namprd04.prod.outlook.com (20.178.245.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 2 Aug 2019 07:47:37 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:47:37 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [RFC PATCH v2 07/19] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Thread-Topic: [RFC PATCH v2 07/19] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Thread-Index: AQHVSQaN4yjklXQ39keUzAS0PHGMsw==
Date:   Fri, 2 Aug 2019 07:47:37 +0000
Message-ID: <20190802074620.115029-8-anup.patel@wdc.com>
References: <20190802074620.115029-1-anup.patel@wdc.com>
In-Reply-To: <20190802074620.115029-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0111.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::27)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdcb3821-5ddb-4d6a-24c4-08d7171dafe1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6032;
x-ms-traffictypediagnostic: MN2PR04MB6032:
x-microsoft-antispam-prvs: <MN2PR04MB603211E6FE63CB11D3C73B108DD90@MN2PR04MB6032.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(189003)(199004)(186003)(386003)(71200400001)(71190400001)(55236004)(6506007)(5660300002)(102836004)(1076003)(7416002)(76176011)(9456002)(52116002)(86362001)(6512007)(53936002)(6486002)(26005)(66066001)(6436002)(8676002)(54906003)(316002)(14454004)(2906002)(478600001)(50226002)(68736007)(476003)(44832011)(11346002)(36756003)(2616005)(486006)(446003)(78486014)(256004)(14444005)(66556008)(66476007)(66946007)(64756008)(81156014)(66446008)(110136005)(99286004)(8936002)(25786009)(7736002)(6116002)(3846002)(4326008)(305945005)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6032;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 81FqvE8XYX1NrlNV+ixbhZ+Udq4hXB1FuRcUyj0XtxwaWvEZKVITCgafmOkVVToLbU99eYoJ59ECuIHjXD24WHkxDRFzf8HweIWjfHh+8/MEvZPDPsqZwxabc1pOL6UqekqnGCiAAtMdwHAKyzw/654hTmpROKbAhEV3Jq/lbw9aIb6b9IcLcyK7xfM67VKp9CYJfXId1m+MvjuOhKqYIXDFlkr/lN5VdsDSMgJqgROWxcGGAChzSeb/2mYuXYpSb/89UKO8WbOUnLTdKiC9iKxQwEpJ6/Jyirdg3qqym0OmYyP3Swz4aauyn0hBxSfYY2bHo/rvSRZ/+87qvtuhx1le+ZM2oWfr+EsFqAlUfcxyfvJLCpNrhK3qVD4vNz8CqjZ4IKm1eQxaDQ04tof1NGKiPD8PrCEgjisKIeH7wzU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdcb3821-5ddb-4d6a-24c4-08d7171dafe1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:47:37.0641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6032
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For KVM RISC-V, we use KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls to access
VCPU config and registers from user-space.

We have three types of VCPU registers:
1. CONFIG - these are VCPU config and capabilities
2. CORE   - these are VCPU general purpose registers
3. CSR    - these are VCPU control and status registers

The CONFIG registers available to user-space are ISA and TIMEBASE. Out
of these, TIMEBASE is a read-only register which inform user-space about
VCPU timer base frequency. The ISA register is a read and write register
where user-space can only write the desired VCPU ISA capabilities before
running the VCPU.

The CORE registers available to user-space are PC, RA, SP, GP, TP, A0-A7,
T0-T6, S0-S11 and MODE. Most of these are RISC-V general registers except
PC and MODE. The PC register represents program counter whereas the MODE
register represent VCPU privilege mode (i.e. S/U-mode).

The CSRs available to user-space are SSTATUS, SIE, STVEC, SSCRATCH, SEPC,
SCAUSE, STVAL, SIP, and SATP. All of these are read/write registers.

In future, more VCPU register types will be added (such as FP) for the
KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  40 ++++-
 arch/riscv/kvm/vcpu.c             | 235 +++++++++++++++++++++++++++++-
 2 files changed, 272 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/as=
m/kvm.h
index 6dbc056d58ba..024f220eb17e 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -23,8 +23,15 @@
=20
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
+	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
+	struct user_regs_struct regs;
+	unsigned long mode;
 };
=20
+/* Possible privilege modes for kvm_regs */
+#define KVM_RISCV_MODE_S	1
+#define KVM_RISCV_MODE_U	0
+
 /* for KVM_GET_FPU and KVM_SET_FPU */
 struct kvm_fpu {
 };
@@ -41,10 +48,41 @@ struct kvm_guest_debug_arch {
 struct kvm_sync_regs {
 };
=20
-/* dummy definition */
+/* for KVM_GET_SREGS and KVM_SET_SREGS */
 struct kvm_sregs {
+	unsigned long sstatus;
+	unsigned long sie;
+	unsigned long stvec;
+	unsigned long sscratch;
+	unsigned long sepc;
+	unsigned long scause;
+	unsigned long stval;
+	unsigned long sip;
+	unsigned long satp;
 };
=20
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
+/* If you need to interpret the index values, here is the key: */
+#define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
+#define KVM_REG_RISCV_TYPE_SHIFT	24
+
+/* Config registers are mapped as type 1 */
+#define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CONFIG_ISA	0x0
+#define KVM_REG_RISCV_CONFIG_TIMEBASE	0x1
+
+/* Core registers are mapped as type 2 */
+#define KVM_REG_RISCV_CORE		(0x02 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CORE_REG(name)	\
+		(offsetof(struct kvm_regs, name) / sizeof(unsigned long))
+
+/* Control and status registers are mapped as type 3 */
+#define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_REG(name)	\
+		(offsetof(struct kvm_sregs, name) / sizeof(unsigned long))
+
 #endif
=20
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8e1ebdf1ef15..c6877d9e229a 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -161,6 +161,215 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu,=
 struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
=20
+static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_ISA:
+		reg_val =3D vcpu->arch.isa;
+		break;
+	case KVM_REG_RISCV_CONFIG_TIMEBASE:
+		reg_val =3D riscv_timebase;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_ISA:
+		if (!vcpu->arch.ran_atleast_once) {
+			vcpu->arch.isa =3D reg_val;
+			vcpu->arch.isa &=3D riscv_isa;
+			vcpu->arch.isa &=3D KVM_RISCV_ISA_ALLOWED;
+		} else {
+			return -ENOTSUPP;
+		}
+		break;
+	case KVM_REG_RISCV_CONFIG_TIMEBASE:
+		return -ENOTSUPP;
+	default:
+		return -EINVAL;
+	};
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CORE_REG(regs.pc))
+		reg_val =3D cntx->sepc;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <=3D KVM_REG_RISCV_CORE_REG(regs.t6))
+		reg_val =3D ((unsigned long *)cntx)[reg_num];
+	else if (reg_num =3D=3D KVM_REG_RISCV_CORE_REG(mode))
+		reg_val =3D (cntx->sstatus & SR_SPP) ?
+				KVM_RISCV_MODE_S : KVM_RISCV_MODE_U;
+	else
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CORE_REG(regs.pc))
+		cntx->sepc =3D reg_val;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <=3D KVM_REG_RISCV_CORE_REG(regs.t6))
+		((unsigned long *)cntx)[reg_num] =3D reg_val;
+	else if (reg_num =3D=3D KVM_REG_RISCV_CORE_REG(mode)) {
+		if (reg_val =3D=3D KVM_RISCV_MODE_S)
+			cntx->sstatus |=3D SR_SPP;
+		else
+			cntx->sstatus &=3D ~SR_SPP;
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >=3D sizeof(struct kvm_sregs) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip))
+		kvm_riscv_vcpu_flush_interrupts(vcpu, false);
+
+	reg_val =3D ((unsigned long *)csr)[reg_num];
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >=3D sizeof(struct kvm_sregs) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	((unsigned long *)csr)[reg_num] =3D reg_val;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip))
+		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CONFIG)
+		return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CORE)
+		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CSR)
+		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+
+	return -EINVAL;
+}
+
+static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CONFIG)
+		return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CORE)
+		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CSR)
+		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+
+	return -EINVAL;
+}
+
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
@@ -185,8 +394,30 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
-	/* TODO: */
-	return -EINVAL;
+	struct kvm_vcpu *vcpu =3D filp->private_data;
+	void __user *argp =3D (void __user *)arg;
+	long r =3D -EINVAL;
+
+	switch (ioctl) {
+	case KVM_SET_ONE_REG:
+	case KVM_GET_ONE_REG: {
+		struct kvm_one_reg reg;
+
+		r =3D -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+
+		if (ioctl =3D=3D KVM_SET_ONE_REG)
+			r =3D kvm_riscv_vcpu_set_reg(vcpu, &reg);
+		else
+			r =3D kvm_riscv_vcpu_get_reg(vcpu, &reg);
+		break;
+	}
+	default:
+		break;
+	}
+
+	return r;
 }
=20
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
--=20
2.17.1


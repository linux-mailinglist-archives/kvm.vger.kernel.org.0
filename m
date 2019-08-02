Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C0D7EDF8
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390305AbfHBHsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:48:42 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64812 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731569AbfHBHsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:48:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732122; x=1596268122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j1+PIkgehirU5mVwmiJM9G1j9n28LPyLji88N+l0Eoo=;
  b=M8zWNVLRo1e3uP58gLc3oxHHM9xhQJTBJBz2cU0grBB+73zDUU7g4RHC
   LYljTMFEYKHcnriWiNmz3dYLuQXhb1qpk3l9sQGGHC8mAupSVR++5R9jv
   Ti5ask52Ua379HGmFjpYfw0K1a4SSp3lWHlBKHk/50z4JIuHjSBOB7yQ0
   reoQjX3SkgTmgoUnXtKSFwRF3E08AyVDwp03xaC5pG4I6thNqD77Cf4Cm
   u057kdTGVaQG3qoI/xCM38sa3FGlIW0ZfQHKk96CUBt0NaO2PB4NOP7wS
   jHzAJHB3g6+s0sUZph5RWYv7FqrQ+UwvMV+Urfb1o7oL25i0MdrXe2RvI
   g==;
IronPort-SDR: dcbD2oRR/ZZI+at0H8YrdNVkvPOnaaQaNXI7FmMiGyRfGMBuhtY8vRFgWLLIKSa6OxPUcmWcwE
 UJlDKg5p7WyBxaGC5nqdSaGcQ1OmyDUyFq1aVKwUo7n+50KpqCH+ML6glG5+K14wVAn/bT7Ely
 aI77SVuk97fpTEv0fVDpkJXSq3ofRmSsNxWGKxGSbz9ysNhEw3xVGQFz5swdoj/7ZORFpczDo6
 hntJLibRHKfmqPtue5DCtdfkxzBnqnXQXbzbLeQDHvkFSerjupKjQwjejJhUMy/+7EAvGmQv1P
 cuI=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="116382577"
Received: from mail-by2nam01lp2050.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.50])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:48:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUsaIH9XSU5hWLou44RGqYG0tA62Jfpg4HCCv+mrVnvOUaCIpIcK6+XCRNpIds5TmYjIZ9ps2KsaIl49CxjQc9T3w8oSukoXO7Cbae/UvcvbaXMfwSEeAz6Qs2iasJMiYCZjPH330+Gy8CRUXVUoRelcVvcViyK16Cy1IvAVUxeCeXPcf9HREMYzKxN80oQluJhsWLa6a3gwUKWzw9ddfk/vTTQFjj+H0EjCphhy14JVeihcjA4jkpSLqHZJR/Xpf/CNuyzhCPl9wxAA5xn5r7JhgQpaHJZlvO+hI+yWT06KecTN+xyjwUr0dlSlV5f7G4J55ZZvvQ+yECVq44fbdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSYq7+uz3grBYRWhkdQOsG1/DGi2yeh+QFdXAta+gkY=;
 b=Jx2snp0E1miLwmG22xzxiyGzwUlXaEOv3N3KFQ4RXkMDVkUqAAO305DUxzQM6hoHPqreo1wosXce0qrwfxTHFxAOu0sVUmmaziEL49Y0lCyfhxifuiByyZf8yDDewdDb4mglS2LtFYt0ahIz0aVerPN+6SzfpDaM29c1jQELTv+qezI2kdPyAe3ktfe4O5B2Phak6lwqSvydQRCvvrJm0k8XmLmX0530tIkScbBrIwIO56M+DsyX9EmNr9YZmjhGdLdoy1gdsM+PTVUfi2Myx15ceAoAkSzHBo8XLfWth5SrNUCVbJQLkT74/G+0xI3LRvkpeF9ilS8SQ/EkWWQFKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSYq7+uz3grBYRWhkdQOsG1/DGi2yeh+QFdXAta+gkY=;
 b=mirTueIWzlsDzGymriQpI0dgHetIu7a5N8Oydc055a5lpsltbyptx1BJU2taUvLwS/Zx5XwxM13YaIdw67IabEmsb/oADGPAMI3eHyaBhVi9BOdTzY3wblAlUZRlAraUPr+bBWQAW3KqxHGaLE7lT/H6d3QTD2O5arwPIw1k3tU=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5566.namprd04.prod.outlook.com (20.178.248.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 07:48:37 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:48:37 +0000
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
Subject: [RFC PATCH v2 16/19] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Topic: [RFC PATCH v2 16/19] RISC-V: KVM: Implement ONE REG interface
 for FP registers
Thread-Index: AQHVSQaxU3hbnoBay0C9NeTjhAbblg==
Date:   Fri, 2 Aug 2019 07:48:37 +0000
Message-ID: <20190802074620.115029-17-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 81529680-71c2-44e2-9160-08d7171dd3a0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB5566;
x-ms-traffictypediagnostic: MN2PR04MB5566:
x-microsoft-antispam-prvs: <MN2PR04MB5566F632828DB77B2D631A9C8DD90@MN2PR04MB5566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(189003)(199004)(36756003)(14454004)(7736002)(54906003)(6116002)(102836004)(110136005)(71190400001)(446003)(4326008)(3846002)(5660300002)(52116002)(66066001)(2906002)(25786009)(6486002)(6506007)(386003)(55236004)(76176011)(316002)(53936002)(6436002)(305945005)(9456002)(81156014)(64756008)(66476007)(78486014)(86362001)(66556008)(66946007)(8936002)(11346002)(476003)(68736007)(81166006)(2616005)(478600001)(486006)(26005)(1076003)(99286004)(50226002)(256004)(71200400001)(66446008)(186003)(6512007)(44832011)(8676002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5566;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k13uP7ovOs6+WH1iUwAGYBVfmwJ9V5TL53h6ch09JaGjUhMB8bTM9YN4/M/67FdO1m5Kx2JuOlhm9/GQxhbQ9g3ssL1I80BMyGdLC6/Be1Ow8xYCus0p1DscyScVbJ03IT3pMjicErRZtWfjNdFie54ruHH1kwWIB3J184hP5rj0ZaMRdB3H7Fh1Mw+j/TvRj86f6OxXXe9AFKUv0b3uAdX47vALOCNVR6azY3bDR0fLejmvma5CaT0ZELtByXZTJefQV+7Oon66ivKTaLjvr+NwvzxtgN6LCO5z7V27Yji6JTZ49HSsG3ShKfz6IgefVC+BPDmHaqIOy6pY8smCYU/VzIMOx01HiDzb8g43ExolOuSLhi2aETflS+wqFNBvgZJhEzz4OuyLIl8SwmN8J0GqLUCCaL0pE5w/lWhPH1k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81529680-71c2-44e2-9160-08d7171dd3a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:48:37.0629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5566
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

Add a KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctl interface for floating
point registers such as F0-F31 and FCSR. This support is added for
both 'F' and 'D' extensions.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  10 +++
 arch/riscv/kvm/vcpu.c             | 100 ++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/as=
m/kvm.h
index 024f220eb17e..c9f03363bb28 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -83,6 +83,16 @@ struct kvm_sregs {
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_sregs, name) / sizeof(unsigned long))
=20
+/* F extension registers are mapped as type4 */
+#define KVM_REG_RISCV_FP_F		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_F_REG(name)	\
+		(offsetof(struct __riscv_f_ext_state, name) / sizeof(u32))
+
+/* D extension registers are mapped as type 5 */
+#define KVM_REG_RISCV_FP_D		(0x05 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_D_REG(name)	\
+		(offsetof(struct __riscv_d_ext_state, name) / sizeof(u64))
+
 #endif
=20
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 995ee27e9b8a..bd79790c5438 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -423,6 +423,94 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu =
*vcpu,
 	return 0;
 }
=20
+static int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
+				     const struct kvm_one_reg *reg,
+				     unsigned long rtype)
+{
+	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
+	unsigned long isa =3D vcpu->arch.isa;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val;
+
+	if ((rtype =3D=3D KVM_REG_RISCV_FP_F) && (isa & RISCV_ISA_EXT_f)) {
+		if (KVM_REG_SIZE(reg->id) !=3D sizeof(u32))
+			return -EINVAL;
+		if (reg_num =3D=3D KVM_REG_RISCV_FP_F_REG(fcsr))
+			reg_val =3D &cntx->fp.f.fcsr;
+		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <=3D reg_num) &&
+			  reg_num <=3D KVM_REG_RISCV_FP_F_REG(f[31]))
+			reg_val =3D &cntx->fp.f.f[reg_num];
+		else
+			return -EINVAL;
+	} else if ((rtype =3D=3D KVM_REG_RISCV_FP_D) && (isa & RISCV_ISA_EXT_d)) =
{
+		if (reg_num =3D=3D KVM_REG_RISCV_FP_D_REG(fcsr)) {
+			if (KVM_REG_SIZE(reg->id) !=3D sizeof(u32))
+				return -EINVAL;
+			reg_val =3D &cntx->fp.d.fcsr;
+		} else if ((KVM_REG_RISCV_FP_D_REG(f[0]) <=3D reg_num) &&
+			   reg_num <=3D KVM_REG_RISCV_FP_D_REG(f[31])) {
+			if (KVM_REG_SIZE(reg->id) !=3D sizeof(u64))
+				return -EINVAL;
+			reg_val =3D &cntx->fp.d.f[reg_num];
+		} else
+			return -EINVAL;
+	} else
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
+				     const struct kvm_one_reg *reg,
+				     unsigned long rtype)
+{
+	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
+	unsigned long isa =3D vcpu->arch.isa;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val;
+
+	if ((rtype =3D=3D KVM_REG_RISCV_FP_F) && (isa & RISCV_ISA_EXT_f)) {
+		if (KVM_REG_SIZE(reg->id) !=3D sizeof(u32))
+			return -EINVAL;
+		if (reg_num =3D=3D KVM_REG_RISCV_FP_F_REG(fcsr))
+			reg_val =3D &cntx->fp.f.fcsr;
+		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <=3D reg_num) &&
+			  reg_num <=3D KVM_REG_RISCV_FP_F_REG(f[31]))
+			reg_val =3D &cntx->fp.f.f[reg_num];
+		else
+			return -EINVAL;
+	} else if ((rtype =3D=3D KVM_REG_RISCV_FP_D) && (isa & RISCV_ISA_EXT_d)) =
{
+		if (reg_num =3D=3D KVM_REG_RISCV_FP_D_REG(fcsr)) {
+			if (KVM_REG_SIZE(reg->id) !=3D sizeof(u32))
+				return -EINVAL;
+			reg_val =3D &cntx->fp.d.fcsr;
+		} else if ((KVM_REG_RISCV_FP_D_REG(f[0]) <=3D reg_num) &&
+			   reg_num <=3D KVM_REG_RISCV_FP_D_REG(f[31])) {
+			if (KVM_REG_SIZE(reg->id) !=3D sizeof(u64))
+				return -EINVAL;
+			reg_val =3D &cntx->fp.d.f[reg_num];
+		} else
+			return -EINVAL;
+	} else
+		return -EINVAL;
+
+	if (copy_from_user(reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 				  const struct kvm_one_reg *reg)
 {
@@ -432,6 +520,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcp=
u,
 		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_FP_F)
+		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_F);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_FP_D)
+		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_D);
=20
 	return -EINVAL;
 }
@@ -445,6 +539,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcp=
u,
 		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_FP_F)
+		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_F);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_FP_D)
+		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_D);
=20
 	return -EINVAL;
 }
--=20
2.17.1


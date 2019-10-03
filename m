Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3F5C97C6
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfJCFI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:08:27 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16217 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfJCFI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079306; x=1601615306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PZBRiBU38f2jrqy1t+akB8Ywq4hOghbEHDzdfzEzS7I=;
  b=WaGSHTXKTBKQqKT5MmfsfyB9zIs1aPc/tjeosShbyfN8OJrepWMgolk/
   emKvNXHxlkzsYhWG818gI5t50RA+1aLZAzT5cx/OxNQMZKalaYLbRcq8D
   +cJHCcVLZMvuSpFGm+zML0gECLGFpBtxTRUtjD+FzNCgP4IQGDgK2o5qa
   4MvLymSUNSw6/bluHWJelJpv20ZvK04A55IPpn1NSa1TPwnd/G7kmjifG
   uGlM6Iz4d3O98XXBJ6dNSjdnkfC6fYsY6MrTrFD4XKw0+YWktlK9II2+x
   Mlv4N3R+F/peLmEunL3qGRag8x5lgCijIS0jP0XIT/wSxeRxeAGtbsS+M
   Q==;
IronPort-SDR: 8/uCRcLXvfecHZmife5vIO7C7NUfvORUV9bxf3nFIiarVfl0QSD8SPGg7mlvUjmRWjBcW6lANg
 PsIZlIDRYx+B+nf7AAMwqmYdo/Jofx3hkzSpzQ7eWtW//mEOO5zZqBhzzDdrV/DuT27QCxzx+b
 XIn1l6SuSxJPJNtodICPTXaE4M5XIZCHXpfLc9Q+ok3UVts5b84iVxXzEMuqnDhbQhDZi9XNZi
 HsjFq4+cRfQn19uM0cE+MHp6ZyF/cKagtOfEKUKk1T9iW069P8YXCIMsqAp1l5ox1HE0KBHPrI
 CUk=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="220620941"
Received: from mail-by2nam05lp2050.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.50])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:08:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/cW1ra60LbnVUp7wzF7UgassL1/TBrKdDClE5IdVvMGiEZl/SUkQsMPXFd+aix0V+7bDPTeyI7TCbMlVP/UmXWZynDQlP5D05YGsGQJc+5Y4Zvgv9Dbc0SG6/IZ2UfUhQ3qp8VC5w57eWBAbMqAVNdyd02VZ2XCeiIlkx2E7egSy4r6u9ujZXJUzYCMHcpaBf+E++orf5az/tD0spP16ks2hMqd6KAaRb8f3ypbNZOX5/SXfCTLDduRcHK7Wd5Z9N9j5vKrvbyIIQ0wGCPfDnYj4VPprSlIPmZgkfrxwlx9EJ3qxVFJx0vDvLtqGrxHJORlXjDVYqkviUKBDvbtuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWVrPy7wNf3FXSrWSDl4i48zJNUOG1vq63QfXlJlT2k=;
 b=MloA96WuFR0lbiKYNwJ/2A8lGiGPISMtr9JMMt4MpYd3S+oFfdGwPboPU11HTfyHpVbHO982iaWFjo5SVHxlZGhLeKSEGuobP3LPd3tWIUqi+WadwPiQs3lS70qi5tt5a5E9LHrjQoCmb23RFNKKZfj3AL2kBU42ed+1N/GPbBP4gNIAc6Pg1B8arpAMHq7ziZoLkZn0aHbjBGuiIOaP/F3qwvSCypshCZrQf+sA1hH+RrEvNUjL9yU0XpMP+n3zgJvpJCVtbRVCB1lWZcailhEEEOUJTSiu3uJuUjM3EDRPwfo2Cgez+wOBgdvFmW7r+xEK961OhZw7xU/nA45BoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWVrPy7wNf3FXSrWSDl4i48zJNUOG1vq63QfXlJlT2k=;
 b=Ql/+gFWWU7YQO1meR3V1+EpIhheIJvdk3eBqx7Iwq0pMhIRrG/k69FRpmdW5cCXpIBF9ZgAYUuuiiruncrad4c/gsrmBVPTIDU+EL7zbkwp/800ihOgc4knhf8EUpZ6aCOXSl1LpWiT93xxMbxxXhO+r98W1+W89aXkl3M+GCrE=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6272.namprd04.prod.outlook.com (20.178.248.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 3 Oct 2019 05:08:22 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:08:22 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v8 15/19] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Topic: [PATCH v8 15/19] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Index: AQHVeaiU7of7gPs79kGPLpzrTZ9duw==
Date:   Thu, 3 Oct 2019 05:08:22 +0000
Message-ID: <20191003050558.9031-16-anup.patel@wdc.com>
References: <20191003050558.9031-1-anup.patel@wdc.com>
In-Reply-To: <20191003050558.9031-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [111.235.74.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09755b12-d369-4b85-79e1-08d747bfb64c
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6272DCBACB79B26E27E976578D9F0@MN2PR04MB6272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(6512007)(6486002)(81166006)(81156014)(8936002)(6116002)(3846002)(8676002)(50226002)(2906002)(110136005)(66066001)(6436002)(316002)(66476007)(66556008)(7416002)(66446008)(36756003)(1076003)(5660300002)(54906003)(7736002)(305945005)(76176011)(25786009)(52116002)(256004)(71190400001)(86362001)(99286004)(71200400001)(2616005)(446003)(14454004)(476003)(102836004)(186003)(26005)(11346002)(44832011)(6506007)(486006)(478600001)(4326008)(66946007)(386003)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6272;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aqRh407RMM2EQz8bdsuZ/JJuRxqJuOz2R788kOW2+O1JPMq/rY1AFf2Ymmghtc17v6ONxta/TqEy6MYMljGYbb4mdL+izlDI6pILPjbFMd8eDGxEkRzLRCSlE/I8FJ+juZZG96j9tJ/bOXMqv3QxRIVSDsG09OaHpfrh+ez5yP3vnYnVPcLfzZmx/CIHemjv3MOlwCEoU019tSfwHzbWG2Bvho+brqV5tLa7cjF4Kt2FghOEzjRmS+Qm+EjmkNpa9unkVrnC7ZD+cWWmqBrqmCrvHYlZV/SNte1+CdDqnYAmhngvHG9SLu1kVK9ksikIkw2HWEm+odh3nz1Rh5YWdP4MANK9QFsHE3S15TILG+gykHeNRSgs2NCuboyEnwnJ8HUInOPfmCndOthMdy+GkiNCSut6mGFO0Yhv3gkJ1a0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09755b12-d369-4b85-79e1-08d747bfb64c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:08:22.2953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4DQU8PaJfwIhIut9ycNi/NYx3Oxufk5lTzC0gaba/2ebFj02+qtZyktJcgF1d2QX58QDsmPQp8GT+SF4m4rlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6272
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
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  10 +++
 arch/riscv/kvm/vcpu.c             | 104 ++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/as=
m/kvm.h
index 997b85f6fded..19811823ab70 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -96,6 +96,16 @@ struct kvm_riscv_csr {
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
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
index 67f9dd66f2db..8f2b058a4714 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -431,6 +431,98 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu =
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
+	if ((rtype =3D=3D KVM_REG_RISCV_FP_F) &&
+	    riscv_isa_extension_available(&isa, f)) {
+		if (KVM_REG_SIZE(reg->id) !=3D sizeof(u32))
+			return -EINVAL;
+		if (reg_num =3D=3D KVM_REG_RISCV_FP_F_REG(fcsr))
+			reg_val =3D &cntx->fp.f.fcsr;
+		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <=3D reg_num) &&
+			  reg_num <=3D KVM_REG_RISCV_FP_F_REG(f[31]))
+			reg_val =3D &cntx->fp.f.f[reg_num];
+		else
+			return -EINVAL;
+	} else if ((rtype =3D=3D KVM_REG_RISCV_FP_D) &&
+		   riscv_isa_extension_available(&isa, d)) {
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
+	if ((rtype =3D=3D KVM_REG_RISCV_FP_F) &&
+	    riscv_isa_extension_available(&isa, f)) {
+		if (KVM_REG_SIZE(reg->id) !=3D sizeof(u32))
+			return -EINVAL;
+		if (reg_num =3D=3D KVM_REG_RISCV_FP_F_REG(fcsr))
+			reg_val =3D &cntx->fp.f.fcsr;
+		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <=3D reg_num) &&
+			  reg_num <=3D KVM_REG_RISCV_FP_F_REG(f[31]))
+			reg_val =3D &cntx->fp.f.f[reg_num];
+		else
+			return -EINVAL;
+	} else if ((rtype =3D=3D KVM_REG_RISCV_FP_D) &&
+		   riscv_isa_extension_available(&isa, d)) {
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
@@ -440,6 +532,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcp=
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
@@ -453,6 +551,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcp=
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


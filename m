Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8C1A8CAE
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732464AbfIDQQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:16:09 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2733 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731736AbfIDQQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613768; x=1599149768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=31SfPGVe5TWj6nux8QaEMl1XlpXcGOSARvTEx6QtzOQ=;
  b=dBv8fpP260CMywUF6Qyp94y+3ql1kr8e/n2mss8jt2ZKtIqOx4PZs4zp
   O8fgpG2oRiRZYaVrLi/OOQ9No0Euj9u9I12jm6pD/LQMQx/u+rRtWjRpM
   J8nmfVntkzZm6VjejxRMkRTBcjcdg/5s5Jp2VC/nKORnVLz1kMmBhQMhY
   bz7oFvpUcbYii9oJKjORAw2eB+zLxqzs3Fvw4vmxJ/zM996yXuhQqVNhm
   +UEvQqFsp6LSFqIHlW9cj+IYlJwcc1cXZn9yC1pPcp8pzPSxuYiJhQMcB
   VC7+vPxTxme7Aqjt1prwxZ0qp4gqI2RgKx8IDDO+r8YmGGAN7LbdCg3rp
   g==;
IronPort-SDR: WmdcET63HFqmmmivKr85udwYvc8ZrBsmD7FVYx/b3t7pHvgjzG7fUbefAPCD+TVNPK2DCGYf8G
 SYeZdMSiMMPpRsmHu9DUaOJZIXmg9Z/OPSa4U9QC6+2mS/8fQpgmQWurlKGGmkPy+t6ViwDi1l
 bMdsVapj7gkJC9zBv4TYgAKKWwZXkDN8EPeuppgBWUkmehAz+NLvFk1EQ6sQn+uSUeJDOKme2S
 hYRkKTuoDAM5dZkpLWNVcrB4nleMX83kwxOyw8uI63rG1EmnB5rwbzTIWYNVYDTHw2Y7cJ/oFA
 CwU=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="118324063"
Received: from mail-dm3nam05lp2052.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.52])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:15:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A56SlFI7S2/bM/28mh7ahx7oKTCeAD1MpQYH/5vxz3qMjyDjJ601GhecYPH1tzmeteZp4+PCS6K9u8ZzjghWIpuKGJEt3LFcMTC3pdRGE2OU7RPjDeG1A9UW969vxFHLcJHbQ0PkyDSmPhyxbiMzzBP8vDnQCwrlLS39LaaMXTfRn+WSeIWBWzBheIhRBF4TThoe9gGYIYjz/16LHO0GhQiaw152Lg8XisUQieD9C+qSpt6jZcnlCdbZlbB31oGQmn48IaIv+I9fnwNMUpYZ6G9KpCMX50uNvvCdUOldqndJmiIcGjh44rS29zg67yc8IZjYFtsGxHvpm70nHbUTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMybPEvi6fujs2mjK9MOUGiLCU9xPUxG8Q5CGafv6tQ=;
 b=ZAdoTL8DsUgk5m1Pqgk2PwxTdlpdUEaeQnlu5HmuBBaXTk0ZJT1h26XCC/GlU+r8eTkM4+4DvRGBa8kLhYnWjCC+hoolUCeGT0PPpMXHz7+RQhJEQ8dhIz09eLUZ0STySUTHYYiu8wOB46gtT3LoyUVuKuK5aKly+QP1Rg2jha8hF1tLQ2Ep+BSbKAl/hYYeNDcZMe7Ho25DoHScysv6CXnSgfoJpkf8AXJM183X66xgYy3h6RB8jyOBOGwKeYaadrQwkNDT1HZ1KTTBepfkZpN0picfF3KBDE65l1pD/ka8EfKZNXun+NV/IMm8NvZDHrdczALk8lHsg9cMT3SbpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMybPEvi6fujs2mjK9MOUGiLCU9xPUxG8Q5CGafv6tQ=;
 b=pSA1Ef51YD2AA1lD2UT/j6/OfroGmH6JLXa9TyOe0eGm4he84QcbUpj0FQkoeyJxzlYuK5V9g0F8vTwmIvUshjm7NLEVGAUhmkBxRRX5zdhLk7LaAJgo3hN/OCtgRtz0Fpi6itDn5Mw0fQ7t5xep4KxmgjPAd94oO8FvO0a9A44=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:15:56 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:15:56 +0000
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
Subject: [PATCH v7 17/21] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Topic: [PATCH v7 17/21] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Index: AQHVYzwHFTKmIp7gX0WyjBgYNjAlvQ==
Date:   Wed, 4 Sep 2019 16:15:55 +0000
Message-ID: <20190904161245.111924-19-anup.patel@wdc.com>
References: <20190904161245.111924-1-anup.patel@wdc.com>
In-Reply-To: <20190904161245.111924-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::24)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.53.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 005f124e-5a91-4081-bd4d-08d731532a52
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5504E3BA9EEE68AAB0FCC2818DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(66066001)(44832011)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pqFsaEWO2cz5N6RtaNW4WrQNhQ55xraPWexsG46iEj33VSzgy7EjQwIKLIqxXQD6RaiM6Mw3ZRmikPac1p0bNgENlAKiZklLgbkupwZ1xbV5bimQGQQ/HxxP7rawIdmyYBMhAf7F6FwS6IXPdlnDeimNK/4O3IxD8ZAyKRUclIew3qthsrjiYb+VeCuB/KVPBNzapN+xl01C37dJj1zrnBabhUsOjXg4gXOlA7l7IqII2YuSblADhP6p6M+ovqZs9vIlyAOqXGFrWX3hW5gvhWXoAR93CHMH3ZGoav8obDPo9L8UMx52Emg0iJEsh1mv5bpwdSdoepDpocEexJhpXGQsiJZHCwo0OltRYcPrOIpFsIUSBBfp7pGSbOgbH62WFEK0cmRLlVM8rgGmopHnElHSbhhV6RYDn7qAoNn6u8M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 005f124e-5a91-4081-bd4d-08d731532a52
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:15:55.9735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NYwV958CJEDnqkudEOa8D53wzm/Vl/AfyrZWRkau4A+5jtrevAlGtPC362l9uWUfD6l4aH+IgisCxJbmmKpnOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
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
index 08c4515ad71b..60184eaf720b 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -89,6 +89,16 @@ struct kvm_riscv_config {
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
index bb3f2a857b22..e52a608f8020 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -427,6 +427,98 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu =
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
@@ -436,6 +528,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcp=
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
@@ -449,6 +547,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcp=
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


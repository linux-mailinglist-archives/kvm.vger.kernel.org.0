Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD0B98E42
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbfHVIqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:46:40 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29114 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731588AbfHVIqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566463650; x=1597999650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ynLnbHgJLa/OWKqvu1iH3ffMJjCAHyWbzG77YN+DY7A=;
  b=KtxtX1UKg8LEI8DCvCvjvWps8JHhVAVb90bWrkXDo58Wtz2oL9hl+KyL
   m9kbAtoCW7hveqTnkD3n0P5ve+JrCPwT8wTgQmY2fFV9SlA8YpIPKZJHv
   AH5XAEgbJlIScZRZIjjxRo4m4XeDDzpOvrRo9Cpx7Uz4BSvzT6TeqUbwi
   VprzyNLloRE1JOh1RfVOvhAjr8VMd6MLaFO+zXlhsZ6tLzwIglPRumQhg
   wuxXAMG7AOg5lpM4BpZXk+VWu1YHAWYartW1+7Nz98UmM17BKTU+W2JTH
   d0kN3x1AbgU26jCowfeseuewUwajAPSTT/jBSBxvRPLQ3Tud3ZDlUqaq5
   Q==;
IronPort-SDR: iGeGK2LCd10lULl6AcJQs4Rj4pVj5bvrzlDvpim9h64Qc0FOD4XXn5PRPB+9WO2xf9vZa4bE5B
 YAcIK4F064I0vbqa4HtNu/o5Qztj4J2crpAOZL5YA2nISZvXVkUDLNae6vsM6Fullq7b3FIwit
 q6cAZliUdlPb+pJ+7bspzzk8ZJ51uL/M+e/os9D/hVy84Fr2mw9cqYHqQl/Bt2fSmq9G/BubLj
 zzKb2UGqtsxMOm1K+LMY1URrtW8FhJARfDj4IgP9v77mieTpn4EzLuROO5IASmvC/6vWt4eBEg
 +zA=
X-IronPort-AV: E=Sophos;i="5.64,416,1559491200"; 
   d="scan'208";a="216834986"
Received: from mail-co1nam05lp2056.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.56])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 16:47:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLO4sAd6fgNZFmvy1rzLDauGIm9gZPciUlckPc4Fhj7ZDfnDaoYG8I63aJoj3iBM/s9h8Kim226CwjifGSVy6Z28IfRT/knNs2LPt2woUn5qOEWecXUt+3eIXBJ9e268m+ZlMnINv6xgVP+RlBBpbvgdOJdxsgPAv+jApK3LlO/bBbDmv8S1E29YX33qqbzajyYlxhw6RzEEXofdWRXaYq/JzA+0yma5rrT5J8Wt+XPrcpzoyED7wTnGOUyezS8c+FFwZ87BUkuUbU8h1cCmBZ8hbdCedaS6GtA/sdjhRsjXICjZbyhnn5Js3Ku9D6p1jqjPk4OCf8VDGqhR6pNaNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uOiukawaUIm59axrQeWYQF7B20eV/AgN3PrVfa3cdw=;
 b=fZLI12woC98zF6C0u6k04BxFrcrItwJkZE4WJGb4MSZD0JfNEbgrRPLU/MyPtvVsVhfOHs9c9KYqiN0dNd5RqLltbVg1YsknII0DFuPu4AjPg7wXyYxyy/kTscO4ipg+D+9eV+sI3sxNdiAA5yyNNPFrBii0UNVQYZVBpHxHU7hp6yI1jNeKSx7ZpsgzWCK5nu6LcDAnjat4QgBpVtBhdOfMatT3jLsFE2IoE4tx2ayBozLtNA4cor5mqaOc1GHAwf4pWSepcHoosParFedZznrahc/xKP7IusBczS0K67UVPy2T7OTA0Dbu/34LLBwhj6b2gymON90UfJ+eG7qu+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uOiukawaUIm59axrQeWYQF7B20eV/AgN3PrVfa3cdw=;
 b=rPLXcLo+jI0lZ5qbi0jvE3+sLCmYxJbw+/183dxkNwKHBSUJimv6uH5/01O/d7jEdO5BuEtOVl3/q4+9UE6qbZtW/wSxFlMff0P+WUvFr3nFLGagEiJQgNO2g4FKXN/ngz+4rtaf0bAbdkhYyLiLgkHRoyMutt0cnmI5s7orj1c=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6047.namprd04.prod.outlook.com (20.178.247.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 08:46:35 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 08:46:35 +0000
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
Subject: [PATCH v5 17/20] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Topic: [PATCH v5 17/20] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Index: AQHVWMYaWZQS0ZLf2EG+HLcDX2ccrw==
Date:   Thu, 22 Aug 2019 08:46:35 +0000
Message-ID: <20190822084131.114764-18-anup.patel@wdc.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
In-Reply-To: <20190822084131.114764-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [199.255.44.175]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4165ed7-e4b4-4958-4e76-08d726dd3cd9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB6047;
x-ms-traffictypediagnostic: MN2PR04MB6047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6047EAE5B15906B8FFB25EB88DA50@MN2PR04MB6047.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(199004)(189003)(2616005)(6506007)(11346002)(54906003)(446003)(3846002)(6116002)(36756003)(476003)(26005)(7416002)(44832011)(316002)(66446008)(186003)(66066001)(66556008)(66946007)(66476007)(64756008)(110136005)(486006)(14454004)(71200400001)(6436002)(52116002)(478600001)(76176011)(102836004)(86362001)(1076003)(305945005)(256004)(5660300002)(7736002)(386003)(6512007)(8936002)(4326008)(53936002)(81166006)(50226002)(8676002)(81156014)(99286004)(25786009)(6486002)(71190400001)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6047;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: reOLtwardSYXq0JRUGIJNKeCsgkDSK/2Z9kvtpwx9B5bjAKCl5qOX1A3PEMd4bszCqWCHvXO3bsFDoq0QX2vx72KtrMynS/KOFON+tIkD8Nw4jVi/5fP9QRlAYRQlcfJR+iwH3KlnxXNDZK32M8Fc025Ftm1uIUO1LT+I5VEbn+2kPPOXcU+aYnCBayyqPxq+Paq2E91hDOoGczwZtD8QA/Sh9aC4vKsspbQq28LCYsCa2NkdHxqcvgSwa6wpIw+WT8uK9cgPBwF94Iv+FmxZ7CxvHP7lm4Fq/F1JXhEigNurKNLZZgAfjhHzwJMFMyCokUjckS8gt8/9QM+8Y9vw8NcsK9VIYwJXpNY1Pvqx7uAmO7N5cqTGLZEq9x4cVgJZUcXG5EHQi2/fMxTrh4nCeamN+PoAmwI73UN+u0edg0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4165ed7-e4b4-4958-4e76-08d726dd3cd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:46:35.4592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q3DQ8rsQVGJqbPTb1oM1LmFauuB8rTsSTIO+INC2JWBYSXj2gt8YmF+o1YgmjKWhGQ9mwpIlT7Y2bq46jiPFAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6047
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
---
 arch/riscv/include/uapi/asm/kvm.h |  10 +++
 arch/riscv/kvm/vcpu.c             | 104 ++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

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
index e7c5fe09c3bc..ad7b67dc80aa 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -426,6 +426,98 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu =
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
@@ -435,6 +527,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcp=
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
@@ -448,6 +546,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcp=
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C3581DBA
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbfHENoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:44:20 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50810 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730147AbfHENoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565012659; x=1596548659;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G+80ibFybBGLjJS80nTL0hjfE8U6lRAqEoYOKxJP67Y=;
  b=kOAkZ21DL2spoZDuFAaC9h4W6Dk1FUZpuEQwR9ezQS/VmMuAlv+l6lor
   qW4HNPZsbVNlOXhHqUmeCgv0ild9SmC7xsvjvk9KdpvyVT/1eW/XedrGn
   agyYxCUqezuwgfZe1QmS9e7gTc1H8gF3nwnaaLDFSpiDLZ5p09VdC1bG4
   I564Vzedxf303QfGK1HBph9k6WoQGE04NNx4vpPLy6zstDoNE20wx+QWk
   FAz8yGGPofGLh8ux3jWBi0kHTxYhRExZMSkMiFF8YAXbCqUNvHxRNt1AB
   V/8L6Jj9H9+Ry/BnZWt8XxPJDGFPHjAkwrnQwkXp3ttkGAGFNkNC8c4ea
   g==;
IronPort-SDR: YsqFwG08ag75dx7n0d//mNPdRNvwgHfRMoqdF1yqfhFKypChMWFk3Mp0XNz/76hC3T8zWPG5zs
 n2K85h32bO+mEAAdJGrsS+HSgTORcRJ4jmSMMe5Y56gil0W1fE4ZbRbL2S6U/6czziFObtdntL
 f8uRDrEeej0X8PNc7QiAuccktsQiHSSTf/PRm6sXM2ZfkW0d+YlPPRiv2GLsr4hg27H7d7bhCf
 XAdKvJjbLn767q/WXDdL3Llo8bnOrj98fv3bkBEvbk2rg6IlZaY1siBglkHkk8UTd1yJDVZBsd
 nj4=
X-IronPort-AV: E=Sophos;i="5.64,350,1559491200"; 
   d="scan'208";a="221493528"
Received: from mail-sn1nam01lp2057.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.57])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2019 21:44:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBMzxdZtJP4bx3yuScZgH+Yu1/H+7S6L8Q6bvhHCRWn2adJi00kfdrpSDQVAxQkGYuG8irAltwizeLSUmMQseJpUbAFSi/2cdb1ZHZF3VQ0RHqRvEgoiRLoTZiwijz4j1A/VHPCAy4NifQmhL9bDCIkGQwdMlxWa9Dd+OJNtcTFDeXmckPMOlO++oekIWVlyfpVnBFDkLF5FKnKvhix3+PnycWHlBTbokjw47pc36IFbIczqNkfy1C8HuQ8d6j/ZBLT27FZFUQJ6KCO5JhOfi7hsw7vrgtVuKkMYR9CqhMA4T3CUymiuqA+jqE6NhyLJotmHxni4JbW7WYvXHL1XEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQliz5sI0nU9QYFjAJD6Pwi6e6LVgBE3dixFpqXvOXU=;
 b=ijN7Wi51tIE/WSaFZjwF6oUYEnT11MB0RWVx/G53QXBm5DiXqaF55c0PtgcJvdp7hoDJe/pNU0NDgGPg/oZokCFE1mAv7EV/Wy1rVTBCihB/LuXBS2eFPYwIGxJClH+BJWUo6tBL4X/yrXFtIm4JT8U92Z6jbpWmByS3ALh5J5MUkUyR8I4EqD8BEDwvcm9Jp6bLoBC95Lzlt+i8I0xAG0jhGrGyEaewF+4dtmAPO31gASEorKcpSdUf6VyxC8RaIhf566AnbZryuXNJT3vvrI1JHRvfLceJ3dmiZ8saQkXoUlJLhu4ifIIYaTZ3LPO3pLHjPKqW2SzoOfZl2vv5Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQliz5sI0nU9QYFjAJD6Pwi6e6LVgBE3dixFpqXvOXU=;
 b=liX5mPDeZedoyLsX5JduD//oSJUElOS2g3gT74a9q1/l/muK7X2gs1Kt6PvZHRtlCRj9zrNnw/09JhkLz/7W0w1J5THs9vRiEt5kJG8NN1npnaCtS1iExiQRezCQVSzkn5/W/aBY3nCaPLmOjlkWskuxVemJ+HDeXfMDLgvHYuc=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6159.namprd04.prod.outlook.com (20.178.249.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Mon, 5 Aug 2019 13:44:17 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 13:44:17 +0000
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
Subject: [PATCH v3 16/19] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Topic: [PATCH v3 16/19] RISC-V: KVM: Implement ONE REG interface for FP
 registers
Thread-Index: AQHVS5PgTp46i/ExM0uj6YiLIF5XTw==
Date:   Mon, 5 Aug 2019 13:44:16 +0000
Message-ID: <20190805134201.2814-17-anup.patel@wdc.com>
References: <20190805134201.2814-1-anup.patel@wdc.com>
In-Reply-To: <20190805134201.2814-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0087.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::27) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9411cf67-31dd-4cd7-029f-08d719ab026e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6159;
x-ms-traffictypediagnostic: MN2PR04MB6159:
x-microsoft-antispam-prvs: <MN2PR04MB6159C07545703CB9BAD2815F8DDA0@MN2PR04MB6159.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(66556008)(66476007)(71190400001)(71200400001)(110136005)(54906003)(66946007)(66446008)(64756008)(86362001)(5660300002)(102836004)(52116002)(55236004)(14454004)(99286004)(386003)(78486014)(316002)(256004)(6506007)(76176011)(2616005)(6486002)(8676002)(9456002)(8936002)(36756003)(3846002)(6116002)(6512007)(4326008)(2906002)(476003)(305945005)(44832011)(81156014)(81166006)(26005)(186003)(486006)(11346002)(25786009)(7736002)(1076003)(50226002)(478600001)(68736007)(446003)(53936002)(66066001)(6436002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6159;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EgnSEt8FK0YCXYYoDJfAyxfc4T5rlUAhXQ6v8QMF3q4O1wJXM8xGMQi89vOfk6/InEw0ILfpyqgn1L0BHtWCkJQzfdwFK/bHyetE9FDMu86yUgiY6AAVlddUj/TZsIepmiFeTFrzebJKBxBq/7KZOaAkyuDhZlY4/3Z4LqYhy3p1QcjLMejJhMdR1lqE2WhwSSya5PWBVQjm2RDtpO3sDtBzksxJB425j3DnLdZ+2qREJo4zYEdVYrXNgC6vdSrDFR2D+JD8OvnT8F0nwhjdvOxD8lFcwiUpfUP0djeflVjjBHLGOyqOT9uBQhnIOMUzPBpo8G5DQRDlgu9GZXEqDt6qAqQT1q2v88GuQhF2QvR8aW+rjK2WUvRtVrQzl2D5Oq+lH1J2GmZFsEAtrvT2NBSIsVDrJUgTGcCKVuy1Oiw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9411cf67-31dd-4cd7-029f-08d719ab026e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 13:44:16.9749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6159
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
index d16f3af1cc57..36bfa429056e 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -425,6 +425,94 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu =
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
@@ -434,6 +522,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcp=
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
@@ -447,6 +541,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcp=
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


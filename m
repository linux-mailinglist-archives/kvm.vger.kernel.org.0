Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921E77EDD0
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390173AbfHBHr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:47:28 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62985 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390117AbfHBHr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732048; x=1596268048;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xiHMPq+WbEWWzvdHCrX1Pqp0I2xFCJOtWMHsvmGQ5nM=;
  b=dydlix66SaKbdmG/6768+/4MFbsJ8ri+KrD4iXiBtHjIQc4dAoOo20h+
   5rEtWHZnrv0PmAlGFa2epEV7IJk0v2VglE7sHmi3V7Lybkz5sRwz7cb5W
   A7daMJmNj2znjsBsF5qdIAk1pmvM2dHI2gNpCLYIHOvMiKh+DVjaWAXFM
   VJ72Fd/h0/5epf83JpAAqG49VrIohieFyisNV+a/34RKBZEGgsLLoYfge
   Gicy5xFxjp4HjIJ82kOplWVn3bs3x4fM8NyloDYNp9oXnneIRcPND5p1o
   3AvpdRbf+P/ncBvLR83ocHIRlnniQW+GIskEvfc/+nOnewTBPAmx5rZSJ
   w==;
IronPort-SDR: hFBfZxkrH30urKP2vtuBUWgGSi50nd5G4LzbQviZfRdsKi8Pnyr4BPwOyU+DUTvsffe+vwDfo1
 lDYAqrXdbQiqM8XLDwtsJFxBtb7w/S3xSJAoJ2AhooAzwzmW++n6ZqXkoyOgO4CILziq32gbGv
 Fi3f1DlFfh2X8jIHmig+PZgofeUem74XChSeY4mRZ8E9aoPc9WLzAAckFETzithiOZrEC61sbN
 kD1hB0ocpW1Gj1OA4TjrJnBKCTyRJ/EtZKK/+Y/vEt+t3BpzVbzxEKNZN6cNHyHCXfD5t9ZzVP
 lYo=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="114783194"
Received: from mail-by2nam01lp2054.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.54])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:47:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgAUJ7HYObVI+vevSEoNNSn8k/fNcRTpua9DIQHhcsS6h6jNLPbgTHfnMtVMcsMSzQ+y1sLgtCKR8Wm6ilMwUatC/CVypBcZVyAsanOAmetfPuoVdx+L14i8OIHJaq4VtOx6tXXyyUbv7lti0wn7FP14wphtdcLbUiIlg2rBxnbDDJQvTd1fLrmhECGnAGKLXjIr6LN/El3HOcQRGgxcJulPdHRDXR3Jb5HfK2TmXOLrox4S3c1gzlAwkviFsI/7gyUAP26Ooyh2aZ6SXXH43KtihSX3bqfH7YA4u9LD+7Lbrx8X5Gzcry13xQlPS8b8onS1h26/hTc/obIYfvx/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0bNtjUf4bRC+A2ilLX9HmvrXhbIo0l6vpSdWkCNJeE=;
 b=TPKOQZOJCr+4lvvCFktTHIRormajz1WLAWSKOrBvOlvAyUeF6yHOpmt0LF3OGba+eefNkTzigdGv3r5RZO1POQo/9kCDBijVVBVlzAXi5lMe6TxpIMxq9SO/Qlo6ibR838fzTCExarmBUt3rPDYFeFFV/eQEmAf83WSZX0RS+D4W5rRWw8A9oi7BY7QlOthX/9iVC9w3fA8OT7rKqySYYdmyTXJmRVwwyqGQcGNSQfoB7e11aabguvZ9C/fKkJzD8tlVmDOWGs6hGI4LrSAieKARJUAkhlvxyxGCIPXDEFFhcQ+w9VKx4YPn+cvEFkdSEyB2Z5tNsne/lpYyABJkHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0bNtjUf4bRC+A2ilLX9HmvrXhbIo0l6vpSdWkCNJeE=;
 b=0P3g6y6hXwkrx533FhbNO1u0N63l/Y1+PEWVnj1zvLEiGuunymoUPY5hkLROAiFdz0ZOQ0D8Xxallnnd9cOojk0qKcPv47UnmgE0CliAU58RyTvEMnQo2DJXLPmf3Q7iP4ecdt+V3eUuC/Pw18smJge8CuZOyXx1wZF0EFeZ9/o=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5566.namprd04.prod.outlook.com (20.178.248.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 07:47:25 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:47:25 +0000
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
Subject: [RFC PATCH v2 05/19] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
Thread-Topic: [RFC PATCH v2 05/19] RISC-V: KVM: Implement VCPU create, init
 and destroy functions
Thread-Index: AQHVSQaGHzmQXdIcL0+sAI11kaypdg==
Date:   Fri, 2 Aug 2019 07:47:25 +0000
Message-ID: <20190802074620.115029-6-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: dfa35205-492d-42d2-98b2-08d7171da8e6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB5566;
x-ms-traffictypediagnostic: MN2PR04MB5566:
x-microsoft-antispam-prvs: <MN2PR04MB5566B29B353056D17F44E80E8DD90@MN2PR04MB5566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(189003)(199004)(36756003)(14454004)(7736002)(54906003)(6116002)(102836004)(110136005)(71190400001)(446003)(4326008)(3846002)(5660300002)(52116002)(66066001)(2906002)(25786009)(6486002)(6506007)(386003)(55236004)(76176011)(316002)(53936002)(6436002)(305945005)(9456002)(81156014)(64756008)(66476007)(78486014)(86362001)(66556008)(66946007)(8936002)(11346002)(476003)(68736007)(81166006)(2616005)(478600001)(486006)(26005)(1076003)(99286004)(50226002)(14444005)(256004)(71200400001)(66446008)(186003)(6512007)(44832011)(8676002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5566;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WfJobhVNrq7W6p9v9CSZ39FnJg8KNagWdoAlZC5cddBLnVwZfA7yPra70sIi5x3fZjOQEkns9RX+81CekpQzCmNMKvHfFo5l9fb6DHuR9irfuRUF/Gm7Vn6PW86KftI/EY/Io6T60ypiO7RXFsP4P9RJYx0V8qXDN57tWFE6qtFvt3rLWRtCBGkN9pI/ntCWLzl0gwzYEbJ9sPmQgdHVN/pKntYucjj33IVxZeizqRz3081FfJ3sf3WM4qdEU2nycPDODowLlR5US0+ZlXT3csV9OZS+COSsA5lrM1lmR1x07DP1+BbflcsaQGtYmRbhWVnKrVHxqFXTEgGXv+TR2pxlagv9n50wADWgdKGWnC2O2m0dxq/qMHDE4Z7W6Ijdk+OqooOP6SKcc8AG2wJsp7yFcanUYHLNImbvm1elWQs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa35205-492d-42d2-98b2-08d7171da8e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:47:25.3578
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

This patch implements VCPU create, init and destroy functions
required by generic KVM module. We don't have much dynamic
resources in struct kvm_vcpu_arch so thest functions are quite
simple for KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h | 68 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 68 +++++++++++++++++++++++++++++--
 2 files changed, 132 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index c612fd054062..7fda09327d39 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -54,7 +54,75 @@ struct kvm_arch {
 	phys_addr_t pgd_phys;
 };
=20
+struct kvm_cpu_context {
+	unsigned long zero;
+	unsigned long ra;
+	unsigned long sp;
+	unsigned long gp;
+	unsigned long tp;
+	unsigned long t0;
+	unsigned long t1;
+	unsigned long t2;
+	unsigned long s0;
+	unsigned long s1;
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+	unsigned long a4;
+	unsigned long a5;
+	unsigned long a6;
+	unsigned long a7;
+	unsigned long s2;
+	unsigned long s3;
+	unsigned long s4;
+	unsigned long s5;
+	unsigned long s6;
+	unsigned long s7;
+	unsigned long s8;
+	unsigned long s9;
+	unsigned long s10;
+	unsigned long s11;
+	unsigned long t3;
+	unsigned long t4;
+	unsigned long t5;
+	unsigned long t6;
+	unsigned long sepc;
+	unsigned long sstatus;
+	unsigned long hstatus;
+};
+
+struct kvm_vcpu_csr {
+	unsigned long vsstatus;
+	unsigned long vsie;
+	unsigned long vstvec;
+	unsigned long vsscratch;
+	unsigned long vsepc;
+	unsigned long vscause;
+	unsigned long vstval;
+	unsigned long vsip;
+	unsigned long vsatp;
+};
+
 struct kvm_vcpu_arch {
+	/* VCPU ran atleast once */
+	bool ran_atleast_once;
+
+	/* ISA feature bits (similar to MISA) */
+	unsigned long isa;
+
+	/* CPU context of Guest VCPU */
+	struct kvm_cpu_context guest_context;
+
+	/* CPU CSR context of Guest VCPU */
+	struct kvm_vcpu_csr guest_csr;
+
+	/* CPU context upon Guest VCPU reset */
+	struct kvm_cpu_context guest_reset_context;
+
+	/* CPU CSR context upon Guest VCPU reset */
+	struct kvm_vcpu_csr guest_reset_csr;
+
 	/* Don't run the VCPU (blocked) */
 	bool pause;
 };
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3ae87c2599e6..45af069c1665 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -31,10 +31,48 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D {
 	{ NULL }
 };
=20
+#define KVM_RISCV_ISA_ALLOWED	(RISCV_ISA_EXT_a | \
+				 RISCV_ISA_EXT_c | \
+				 RISCV_ISA_EXT_d | \
+				 RISCV_ISA_EXT_f | \
+				 RISCV_ISA_EXT_i | \
+				 RISCV_ISA_EXT_m | \
+				 RISCV_ISA_EXT_s | \
+				 RISCV_ISA_EXT_u)
+
+static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+	struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch.guest_reset_csr;
+	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
+	struct kvm_cpu_context *reset_cntx =3D &vcpu->arch.guest_reset_context;
+
+	memcpy(csr, reset_csr, sizeof(*csr));
+
+	memcpy(cntx, reset_cntx, sizeof(*cntx));
+}
+
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
-	/* TODO: */
-	return NULL;
+	int err;
+	struct kvm_vcpu *vcpu;
+
+	vcpu =3D kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	if (!vcpu) {
+		err =3D -ENOMEM;
+		goto out;
+	}
+
+	err =3D kvm_vcpu_init(vcpu, kvm, id);
+	if (err)
+		goto free_vcpu;
+
+	return vcpu;
+
+free_vcpu:
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
+out:
+	return ERR_PTR(err);
 }
=20
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
@@ -48,13 +86,32 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
=20
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_cpu_context *cntx;
+
+	/* Mark this VCPU never ran */
+	vcpu->arch.ran_atleast_once =3D false;
+
+	/* Setup ISA features available to VCPU */
+	vcpu->arch.isa =3D riscv_isa & KVM_RISCV_ISA_ALLOWED;
+
+	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
+	cntx =3D &vcpu->arch.guest_reset_context;
+	cntx->sstatus =3D SR_SPP | SR_SPIE;
+	cntx->hstatus =3D 0;
+	cntx->hstatus |=3D HSTATUS_SP2V;
+	cntx->hstatus |=3D HSTATUS_SP2P;
+	cntx->hstatus |=3D HSTATUS_SPV;
+
+	/* Reset VCPU */
+	kvm_riscv_reset_vcpu(vcpu);
+
 	return 0;
 }
=20
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	kvm_riscv_stage2_flush_cache(vcpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
@@ -207,6 +264,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 	int ret;
 	unsigned long scause, stval;
=20
+	/* Mark this VCPU ran atleast once */
+	vcpu->arch.ran_atleast_once =3D true;
+
 	/* Process MMIO value returned from user-space */
 	if (run->exit_reason =3D=3D KVM_EXIT_MMIO) {
 		ret =3D kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
--=20
2.17.1


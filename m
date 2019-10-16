Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A3ED9670
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393373AbfJPQJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:09:02 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34793 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391855AbfJPQJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:09:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242143; x=1602778143;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fDLT/tvUtxZor/pyJ7arbei5F/B1X1c5CWdgm4TQvIE=;
  b=pNpTAW8lhB7auEOmvV/RdZCDrsVi9HRfIxuyXHPgQXo1zZeAJi3fjc44
   t1hsew9OF9mt5EGQltV40iLFAnhQu7M7p+T3xt2JT7DcJ/FmjH43kV0fO
   eIFsBg/5BSpVLCZ+QrvZRQ5p9rWImSzwyZUHM7z+u0vW8MgnJWmuwTdr9
   uoYrb8CK9A06HDif1m7GJyAfybJwuroO/dgjrJLiO0yHpklDMNRBuKE44
   WULWJQSxjGr4j6G0EDsKnViOKC0r+vMFgqEwe/ffPf3cMVzWIPgGl0Rzi
   WIhtwlspk2h44ulzflWo28203nbMacDFZUNHW/L0tt/tcgw0WGcsBstSO
   A==;
IronPort-SDR: S6YISvND9HcT4DmyGn6zwjmglHyBqWiAWtcqCMkU3TmnFL4brU5uaEaIfS4I2v/02zHVOi8oed
 pTz0vNl1ZbsH/oHv8oSyw41aJBFBxnrvVIDbQXWPPteY5rSx8Q6QsLMvIkiOh2xHft6Pkwu9FU
 S3p2D+B7cp1DTvnvWMpQD95HolMYBrLRhCpymnLirBturKMxbFKWhIvZTe8zjM/2VTck//7jWF
 Psi61GXC4vSxYHCBLHWNg5dSf873Gm45NqgNhfzYDVCGKVrr2uCJBiurNod+ofj+82wHsR2JxY
 tss=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="122255476"
Received: from mail-dm3nam05lp2057.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.57])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:09:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lp7Qwxe1Bq/IscPgdfWJtmo3+y7GWxy8PDohsudTJcZ8rkgRT8WR2OLe6rgZNm0ZaRsaGBuLvYNCc3n2sry6XyIDiAJpmI8tfez/lRULp+62JfF0ASffU/Y0i6z0y94abN0tgy7eFzw//tLPAjO9fw48btyIyikxqzS4uhuDDRE8yRsQPSns1ORgxuAuisPeMKUopjo3yNpgbvbo0xwvzW+x/ircSsSM2QnFHHOZR2A6Jo/r5wUAMpashAQypXAsIWs4uuBl089H0MXghXjV0eEVw4DgRLtGNshR7OjH/stIlbaVrAb99uWk7fL0ZF3BxFkeAbaN6OKMMXiVVMLFaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqmrXHzIruAcNotF2clWWzYvQNRNRKr+C27TLUx8gRQ=;
 b=Ebj05t4QOkgAj+p6TbUOogq9w7XWeZ2HFafXFPNuvMpwSHRSF7/ak+wwFELx5pVRsuDRsYK0zQp/D7giKR0bExVhrG64k+h5P3pjxd1GnR566X3twHbpgpcnVtAJrFyVLxt3Qw9DM3dKciWvOAUzKgmPS7VZDZNZYQmoandlsf+i8efjp44SjKMbpSO56NeYJRDzBKuW+uiKEDdysHlykvUV2FUcRGJ9Ko3pMRP1IomFenyK6aB46pyoVGVjYI46aZI6GQyQpzs9MOcyKa4htbdAF3F6Bkvyus97sNELfC9xSwdf78ohQSIGHFMGjdvLMlWlo4ZDR4kHYYYH7mvlxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqmrXHzIruAcNotF2clWWzYvQNRNRKr+C27TLUx8gRQ=;
 b=duCYVzrTqWBERO7LBy98ZEe2lMEk8mQLZcMGQfwiwLIfM5zKha1cGwCyUK6PDgX03MjMqGGHzFUzhqb0ADjCOA/essZ3EimypldckYh0Il2CBEU9yl6w9rg/eF8iM36E1pFc9BLK0x1OfWjC5gw7ph16DUDY2Gz3a1Zz9UyhtOk=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7038.namprd04.prod.outlook.com (10.186.146.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 16:08:58 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:08:58 +0000
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
Subject: [PATCH v9 04/22] RISC-V: KVM: Implement VCPU create, init and destroy
 functions
Thread-Topic: [PATCH v9 04/22] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
Thread-Index: AQHVhDwE9VIyl5qiXEiF7sxd4rI/CQ==
Date:   Wed, 16 Oct 2019 16:08:58 +0000
Message-ID: <20191016160649.24622-5-anup.patel@wdc.com>
References: <20191016160649.24622-1-anup.patel@wdc.com>
In-Reply-To: <20191016160649.24622-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.27.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c978a7dc-2cd2-4574-8478-08d7525326f7
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB7038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB703821359B8E1125B0D1A05A8D920@MN2PR04MB7038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(199004)(189003)(102836004)(44832011)(486006)(2616005)(476003)(386003)(25786009)(446003)(52116002)(99286004)(186003)(76176011)(55236004)(66066001)(26005)(6506007)(5660300002)(36756003)(11346002)(64756008)(6436002)(66946007)(66446008)(66476007)(66556008)(86362001)(6486002)(4326008)(6512007)(1076003)(305945005)(14454004)(256004)(7736002)(7416002)(478600001)(6116002)(71190400001)(3846002)(54906003)(110136005)(2906002)(316002)(71200400001)(8936002)(9456002)(50226002)(81156014)(81166006)(8676002)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7038;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f6W9uXcHoPzybtuBxkkJx02PBQtSwe4NswtpPcQxtdttLXj2RXQBR1k4PSXxlE1E9q0FSEaf5XtEovarSzsv9d+Z+Yf6LIt9hm+gMfIaSQAKehXtgvM/Bz6/Bhj7I6J+c0ZXf8Xjz4e5zVFfIVHkKq3J+qnAyQT43bS8Umj1bdVnZsWRSZQx9z/skBEr6hes7erhYrlw4UGuZwqVCd/Y6WM0j/6jA0hSQ35tk8eZ9OyZxI6vqLykshcTCg+3hRrhLb4mjeO3bDwbQ/3X3uUyAo+4gVln8qS2eStWlonXhk9EgvSnUeiQnrt1Wz4s0IjH7Dqb50J3XYQugdtUEbg4/ogMhBi5eaGrdDkCMtdbgQ3x3keqFrFfSXzoXprBjHMy/C+l6wqMRgVdx6qiUnQjd0NglLHMDtrMzrDve4GK9UY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c978a7dc-2cd2-4574-8478-08d7525326f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:08:58.7702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jfEJQ1k1dufJstoFxzJ8cU7U7vNFHBy11CKBo1P78qa/anLq/LNs7+fP8fc0xBPyvrldMHccEcD0zxhgxZA/Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7038
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements VCPU create, init and destroy functions
required by generic KVM module. We don't have much dynamic
resources in struct kvm_vcpu_arch so these functions are quite
simple for KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h | 68 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c             | 68 +++++++++++++++++++++++++++++--
 2 files changed, 132 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 9459709656be..dab32c9c3470 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -53,7 +53,75 @@ struct kvm_arch {
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
=20
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 48536cb0c8e7..8272b05d6ce4 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -31,10 +31,48 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D {
 	{ NULL }
 };
=20
+#define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
+				 riscv_isa_extension_mask(c) | \
+				 riscv_isa_extension_mask(d) | \
+				 riscv_isa_extension_mask(f) | \
+				 riscv_isa_extension_mask(i) | \
+				 riscv_isa_extension_mask(m) | \
+				 riscv_isa_extension_mask(s) | \
+				 riscv_isa_extension_mask(u))
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
+	vcpu->arch.isa =3D riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED=
;
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
@@ -199,6 +256,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 	int ret;
 	unsigned long scause, stval;
=20
+	/* Mark this VCPU ran atleast once */
+	vcpu->arch.ran_atleast_once =3D true;
+
 	vcpu->arch.srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
=20
 	/* Process MMIO value returned from user-space */
--=20
2.17.1


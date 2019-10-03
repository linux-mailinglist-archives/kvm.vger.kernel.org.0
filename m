Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EE7C97A5
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfJCFHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:07:06 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:3987 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfJCFHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079224; x=1601615224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fDLT/tvUtxZor/pyJ7arbei5F/B1X1c5CWdgm4TQvIE=;
  b=GzBGd9fWTfsFSyPtUxvr8/CiHJLWm99ltL0hZm8eWfHIjOW+s54gDogG
   iYCB6wkgYqeqKAg4vzP4pNk9tYmGXa2P400PH9+PNztS0Dhzrq7BMGXKc
   KYTIrxg5+AB80QZOQCt4KUwdf7q3WROmL/rcMVGAU5xOSSNtkAs7IAq9f
   WcRN+NMfYm/tjEIRwySuzwz4SL6fB5p/aKyIuafBIj2Gawd5yp3LACe7w
   /RFuAWvoXzfWVahW+mpyAQsGmSkNh+V35UkdCMsHo3SyKIksIMjIX9sFL
   GBpPvs4m9+usVpw/628H8cMfBRC0wFZvewxfPfFNgoSyoHLfYs3ESvMRJ
   w==;
IronPort-SDR: hPDB85gqcOZkUb2fE6hqZVQnpLKlah90v+Dw/rVLlbZDCND7concAkZq7FXbHnb3KF0Wnhgmsm
 HXAv0NZ4u8kNWBHqRfqG3tkAbLZ6alGylSu5qrnsv+x/v+3RtlVSt66Bl1z2iFHJc97zp0poL4
 /Sn3X89o3V2XHPkqy8cWpx6m3BVoWt1KJW2jBzOSl4QdwFPqD4Y4ovGJF6CabphmjMcmPQz8Ok
 TMI+Xw33krbPla5nuAEG789ikw7q0A0mkQRe15IXqgNEZ3zIB3JHulnTbKVxBsgytb7QMsyhbd
 FUY=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="120461312"
Received: from mail-co1nam03lp2051.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.51])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:07:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQj3jGpIQ03JR3ufwMKjbsm3gpunf6eZFYKLrxA/EDc0cH/fWjITGalralT5LTrFB7Lk0lwAVlyl0hz5JFztAqCX5TEwdened4QRGlxZCzOF582NNOR1Tgvwq6pzaOa9wr9P1m1B9jNfg4k2JDk1+eYiOj6l7QR28D8NDBLZuXQOw0rrTOOZVCmAxLIwjJ7YHynTLJcUUb0kJua1qlwmbBTQcZiaMSDkcmz1FR2R/IyPfWxIxXqjIZuNdL0dwguNfupX6tcRPF1Ez3ZDEUEbmwsf0p3qBTBFz5kh9CGc8wEgoCw/wIzaohF2iCVc6aq75ZBSoFhGo6oQ714fsYfe+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqmrXHzIruAcNotF2clWWzYvQNRNRKr+C27TLUx8gRQ=;
 b=czmuWvjbJe4HgWgEQDlR6toUt7RnY4IRPiCncQvOE3OvP/rpW1jKAVVF4R235wq9DFFOtzJKMgTSo3tig2V3HTWgN8VGehmDWrd6709Z7FhvREywyF70cDxHZttwNg5qpqi/zUUC7/YCaQjL/eiIhZzmGoTs18qME9Pc9N+Le9LLQ3YwyZnwhqsvzL1L0ABpaBTDEMw+60K47v86Do9Q2r899u2dSev8FnhH/N/tMGQyigLh1ulGB2zs05RsHmSAdu9PnytjfpBE3rmRi5yrpdaBrfeb/gJjafUnMxuUG+6rdBS53aXMO8E0LTYsYZaIkeoDM+uOwFO9SffxJsEc0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqmrXHzIruAcNotF2clWWzYvQNRNRKr+C27TLUx8gRQ=;
 b=dDIulKoFcNSUppzvUl9UPCVxAtkJQpbLfhMgtFqSOsEERuIihVaPWD4x3xyrWTb4e/AWSYK2cay949/NARkP8UlRyERUU+JqlnjBpo8C1cLgdFRxV4fvzNFu8viTTp010RWBsSlGE+lL6qloiiQQBsE4WGT7q95jseQpiHjjAvE=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Thu, 3 Oct 2019 05:07:01 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:07:01 +0000
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
Subject: [PATCH v8 04/19] RISC-V: KVM: Implement VCPU create, init and destroy
 functions
Thread-Topic: [PATCH v8 04/19] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
Thread-Index: AQHVeahjaOd40LXvJEyLeU+X/Cfsog==
Date:   Thu, 3 Oct 2019 05:07:01 +0000
Message-ID: <20191003050558.9031-5-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: ed6237c5-7bda-452e-b1e8-08d747bf863c
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB699120DA4F542247D5B36C798D9F0@MN2PR04MB6991.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(189003)(199004)(7416002)(52116002)(25786009)(102836004)(76176011)(54906003)(6506007)(1076003)(386003)(7736002)(44832011)(6436002)(486006)(66066001)(71190400001)(71200400001)(11346002)(446003)(6116002)(3846002)(476003)(2616005)(26005)(305945005)(6512007)(36756003)(186003)(14454004)(110136005)(5660300002)(6486002)(66446008)(66476007)(8936002)(66556008)(256004)(64756008)(14444005)(66946007)(86362001)(8676002)(81156014)(81166006)(99286004)(316002)(4326008)(2906002)(478600001)(50226002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6991;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R+YBdmRbXisA7fadUnY8B+LcCurm/VXywrkZoFija+oecPnlIJ7SCakUNP43SlAzmElY2WO4ei+A+zgkY2q6AZd2HyvXMKmBw0nFjlMdIp1nkZIc9oUN5omoN9PyzqdZ83BInLn4ryUtGMyJ6YJ8QPQcgn2usJ4D3L9U2H/DFN3nj+N16wrFaz+SkK+pBVlZsd2TL8yIb7dqxGE/NgHXlSs5pvj0W5M+nsEsiooqI7mZE+K4O/GpZC/58GZMiQqtZYqRJoX4GdyqOG/M9yXSqmZJUt9wenfR7j55RN3bxFf4xUr0JZQdmVyuT4SGqAWTSrlKFhPYxfB5cLQ4EM9hhUifs/ylStIrjgUn9aK76n7zaAA7kZp6vS6mb8YvRT4aDc/D1pptRL/m/rFmschUDUBSIWlbqvYo0W8hc+FXdCc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6237c5-7bda-452e-b1e8-08d747bf863c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:07:01.6122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WEvkuVpR2oQhIKqA1CxaBYQ9ahZGKnBAsfc39n3HUkuTy8dxEA4VzXPEeYePtivPC3Ntx24Rhm5nKCZDEyYSug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6991
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


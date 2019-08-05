Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7CA81D8D
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfHENnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:43:12 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:56694 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730221AbfHENnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565012588; x=1596548588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f8bOFS0agpu86zIpHLzQuLYgjylA5hDCeu61btqRYXY=;
  b=rRoL08IqavJvfOyMrQ8gpXU6b5Y4IalaZOhxdDICM+Gz73kPc/cXRkCu
   KjJCesnGv7bw9tLqyi/kX8BPvz1m7ngEP+OQkWyEOEHe0HKO51gvqkjAY
   ICrBA+vnFzXQ3WF/JbKmfJ4PQWeLRUiJV+o9N2tD4Mvswtjbmul1MLEdF
   Dp/wYKY8KsVD50Am1ANGkdaKkmjvs3U3kPRoVgrjITBZejP4GhKco3L4W
   L1j9qrminQLGj78j0mIL7MjyrhR5MxI2wdSvAW6OEzE0qXI5nQoutBkmX
   PJgyD2aWaCq5EGmnqDhtNX0Xrv8ySnIB4UPCtSPae6OIlglwW8v/vC6ai
   w==;
IronPort-SDR: GnrHCMifbkEIzCXsbLk5Fd58cDFA+49Kvstj52dNIZ1SxZ2VQ01NlpdZoEfUP314K7e+Yq+XiY
 sycMpduyu+Fmgq93hqwtpHOASAhpVNnDrFY4c+kj9+mq6aVQ9nbhOW6BYgYH3T7EGTOGVe+hfc
 fW2aCjk6lB9UcZTVrt370CZHB4aR0nPK2E7A8raamUpuXZTFYyWreU6VdA6WWjYt3jcvap8hzs
 u78vYSKAb0zsk9amo6o3fDjt4mIRWm+LQ7t8yFYDVaZ50jpevNk6lV4AoE0LxIO3y7zN9E1JtI
 lDc=
X-IronPort-AV: E=Sophos;i="5.64,350,1559491200"; 
   d="scan'208";a="115017175"
Received: from mail-by2nam05lp2051.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.51])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2019 21:43:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBXPkorDSw9OSwaNLjBEbWQS70HiMwNXh8Mu2Cs1glWnHqo0TDQNqV8yCaRFfLewJSR59mO09RSRJp3tkyuU1hwSHdxjIwNVi13vOxt1rNfm2oXgKM+N2ZcPek5cawhNFux9NznyQYqPd3IOBt7H7i2UCtN3rr05rZ8o/WOyySEalRbZ2fLHO+zM/28zKFt87mr2Y1cruLZeIG8/jp/qKyXNDjZOn3fZPOR5NIjbVSWtb/ImH62EVAs1p8lpzAXvC9tz5lXpOeYi/ERgt2+FIB4RoDCGJsneFbAI0RECNkxCjWnQYxU1GvMVul+6LgJqwWCohgFdR7OeeKJeNFl+9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn04jmWaaNlWIaYLduvv9A/Ijpoqw4a28DIGldPnxgc=;
 b=lMHFRt06woXRTXWjCt842aoRAvBGAhnsiSrA1DlxOdeKZzy7ords+m16O8pVsxdMfgp9EE5cueKeS9D26844RjLvgSs+njvg9mNIuRuOo08RgmMlKLO8/xCyj/eBjwfCprG3amCMUfmeD8dKQIbh5LKV26du9C5EyMO6HbrozAxxFakFGwiAEiBA7lTx2KubrI2JAXDQ9vi/kj4M5jOykDEyD1B1Z/Z86nrSb64K4ACzZx23IlwT+zlbH8X8Slu45jgtSjX2xRcNEvq9TAKbK8O9g2KJ74+8hypQmTAVDiHn3/OHnLI+Ip0ZxqnOPneRY0rqHCaHo2zA4dJ4D9bVfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn04jmWaaNlWIaYLduvv9A/Ijpoqw4a28DIGldPnxgc=;
 b=dCn1jOI7IpfQa17TO8MDqiXqaOcvkasy+6MvS4FLEVFG5lifw5QSZfxhWZkBO1XZTBiz4j9IqDKGSdhXJvUVPPPIUdcah5i6kGNpZ3brMHzal1TRZqODxvPC2dufcC2O0vmOlipEDcbwgSItSTVQ6G0iZMgJeZGrCdf9VFBB2bE=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6159.namprd04.prod.outlook.com (20.178.249.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Mon, 5 Aug 2019 13:43:05 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 13:43:05 +0000
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
Subject: [PATCH v3 05/19] RISC-V: KVM: Implement VCPU create, init and destroy
 functions
Thread-Topic: [PATCH v3 05/19] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
Thread-Index: AQHVS5O1VKa32PWc8UuXEMlRjqbf5w==
Date:   Mon, 5 Aug 2019 13:43:05 +0000
Message-ID: <20190805134201.2814-6-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: d35900c4-8a30-4973-bedf-08d719aad800
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6159;
x-ms-traffictypediagnostic: MN2PR04MB6159:
x-microsoft-antispam-prvs: <MN2PR04MB6159A179DD450FE58F381A258DDA0@MN2PR04MB6159.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(66556008)(66476007)(71190400001)(71200400001)(110136005)(54906003)(66946007)(66446008)(64756008)(86362001)(5660300002)(102836004)(52116002)(55236004)(14454004)(99286004)(386003)(78486014)(316002)(256004)(14444005)(6506007)(76176011)(2616005)(6486002)(8676002)(9456002)(8936002)(36756003)(3846002)(6116002)(6512007)(4326008)(2906002)(476003)(305945005)(44832011)(81156014)(81166006)(26005)(186003)(486006)(11346002)(25786009)(7736002)(1076003)(50226002)(478600001)(68736007)(446003)(53936002)(66066001)(6436002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6159;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4MN14zin4W8/mrT9gER9sAXAOn/lfgUCLE15NQOXT2nPqfclRWO5lZ7cvu40hA4M40Abf1qIcFbcA0dwfN2xqEezNtxnfLM3QFGuN3wKuIR8wtAHg8i1FWzj40SsZnwXWGHjDofX5JaI9GZv0lnP4pku8sCJjrLI+EP4zdmLd1I9REfEvEDdKu8+ua2ayS/vCkl9t6jR+jA/4up/WrVj5fjmLnPJSw+LU4kX8ZWYl/M7qOXpp5bt8zteCpL+NocFRWeZDOav82ge4DkCpQZ09Er/UVH/941MesmxNwEWQeBBw0GzMbNMk2uZZPXr8TytfRFe/JqxmWnA+UV5sz7NboS4nWPc4X0oW43ddVO8oP/063NIbLvbWnfMqJ8akqPtUnt2rAVTESdM/cV6yIGMyPZ+IbeVR5DiGSOHTdxumrE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35900c4-8a30-4973-bedf-08d719aad800
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 13:43:05.7965
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
index 48536cb0c8e7..ff08d138f7c3 100644
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


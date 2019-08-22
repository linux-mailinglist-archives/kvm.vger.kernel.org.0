Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738DA98E1C
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732567AbfHVIoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:44:12 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:10754 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732561AbfHVIoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566463451; x=1597999451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yOaWat1Ra9Z1x/XfcMpFrcn50bFOsfQLBtbxWgmNQ84=;
  b=BdRWYBQUj7Mn7gg1Nu361UBJ4qOf41YIAThzK3dqrtgkPLgyMndH7DaL
   x/T/9x9Ugx6dG+zfRKiTf/0K/CsB0EuE+nyXYPvnv/kAskSKGbjERQZeO
   MrRJlXXT0ShA0fxXch/nTHJb7vWMCZtzaklFWNJr+dQ+UItMUi4SG8352
   2cSdaq4dcku61IcaNKp+C0JVS522ci7A4aFiK/jbdJJIYeoE4hsxLNLnT
   hEVV+4YstmuF2+r5BGGwGp17YVC43WIqgV5b+7nNOBFYhaM7vakksdNWx
   dxFNJxs/iIM3FoGmzlZ8A1jnKf/mSoxK6N5u5o/FQr2OlTaNDrYH5XY5K
   g==;
IronPort-SDR: aZB/QASCBZj/+UmHVLu3ExxxrEgUxVvm+P29ZFUKYCf/uagQ7gi/vsTjJ4xWJxvDwTgVt53+DV
 QFwn/0JM7x1MxQpkXu/lbGJT7ZssvyGXRuJyvvVLOq1hQKKpgl4E4486t1Z89NTwDA2Kn7AfKP
 0phLMjnRODZszGKgnVs5Kag983AsbtaWOiaigiiHxA4o/6AeyNzDG9av0+QFCOCTIrYpJOHGZm
 yNpYUtfo1dl7ToUIlNf/VMhkUDLM8OAmL7L1IF74IB1uZZIGNUP94h3U+b80XtaEOMiJ7wt5oY
 IQ4=
X-IronPort-AV: E=Sophos;i="5.64,416,1559491200"; 
   d="scan'208";a="222996951"
Received: from mail-bl2nam02lp2056.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.56])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 16:43:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQktmnc+f9Ocshd9Neek8ZYjMUBz5KlkuBSzP65D6lhM9aJaOsidFBoQzK8GzP+myIg1/9vD9zt/t5Lqk3OMa8l2Nc6zfRAWVUGRhpr1GkznOS84NvSWnqb0wPRAlZ2zyH6TfZd+XDfFc5uFdnImpgCpw9Qy/1CDZUNYH+xgUQNBDljKFfQDDCm7OaPMszZaQyuHbGy/zGA94nLl5UhYojtwiWmMYD8wAIcE6jneuJ6uJTLQHwSkpyq+X1RTjILJh5+CJ6PFgpg3u0q3XrGWYeqkGn6ZHRdYlnyn9n3cfZlr95Bj7XaQS86V28DfcE7/K2KqusOKPOfKFbkVp6FsYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0H7/uNxZU9+1CcgeHEf3Cy4ns5EEfk2i2CBUT4hbz4=;
 b=NqbGMC6xNhb2b2r5vnyNvUW6I+kxiRZarJJe26woLMBSA0QK131LVqOmVaPxYvla8B4wliMZ0mv7Fv2+9A/doJk6BTUs/X+z5yTXIddVvhCRuCbscMBF2V7MVWNB3D3DNMdzHdVAl1WY9Xgb1JfhdYk+aOwarq8mAgD30CJ6KcoZ940H1G5zJSKvHCvFMVRR1gIee6SFqDRJC0PhYt1Xh//pofzd5ABhSZxoPonP8FM3cMKWBOn8FZbwscQ2PpN0Gmp+MZDhj8yMbU2VlfXduuhul9aEjWczYMSLN8PKC/T46CZMV26jkanmF0HyPhUT9hhMqaerqQXx9hSnpEMduw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0H7/uNxZU9+1CcgeHEf3Cy4ns5EEfk2i2CBUT4hbz4=;
 b=glJLX83gDtNmEnLPzbMNPGPoQM/Bju1fR+64PYOD1raOOODZMkydzDj/WJse5w6JRCUX0E23uqwMq+M/mqYOcpZga20ZMXdsJfZLvGdAl6+eWnorf6echCZcidcuXYD3VAUoJDT2qsorratafOwS7zrzkOS0LVW3/o0NoNv6YAw=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7071.namprd04.prod.outlook.com (10.186.146.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 08:43:47 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 08:43:47 +0000
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
Subject: [PATCH v5 06/20] RISC-V: KVM: Implement VCPU create, init and destroy
 functions
Thread-Topic: [PATCH v5 06/20] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
Thread-Index: AQHVWMW2erEzmvqWmkSHiTnkudRzTw==
Date:   Thu, 22 Aug 2019 08:43:46 +0000
Message-ID: <20190822084131.114764-7-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 498afda7-8cf6-4af3-1532-08d726dcd85c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB7071;
x-ms-traffictypediagnostic: MN2PR04MB7071:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7071B210E680E0D4B711DAEF8DA50@MN2PR04MB7071.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(199004)(189003)(1076003)(5660300002)(7416002)(14454004)(14444005)(86362001)(478600001)(36756003)(71190400001)(256004)(6116002)(76176011)(4326008)(66066001)(71200400001)(305945005)(7736002)(3846002)(52116002)(99286004)(50226002)(8936002)(8676002)(26005)(81166006)(446003)(11346002)(44832011)(6506007)(486006)(6512007)(186003)(316002)(386003)(476003)(102836004)(2616005)(81156014)(66556008)(66946007)(2906002)(25786009)(53936002)(6486002)(6436002)(66446008)(64756008)(66476007)(110136005)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7071;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: c6X1P9F/fWo2dpbv92NCd3ZoXAVal8hg6ipS0+TAtqWeC9NqYJU5mGTANnnPCPLtQvztn4z3ddw00xe8MRH5duQ0e68YokrQlUtQttttsJsVFE3QHy6sNaRYQZQEYwCq0LWuKmPg6KnL79rpys9RXBs/9mpXqgdNwINX5wEfdSb8sVKpCv5vlVDKAuK5C9PZYqsB8qs5aiJxnDG9HXatQKW28WZpxvx5pzoNOkACxk8dvxV4TS5rqhGrOfsajZscDugPWz1ustokpjZW7HPFQ5HCCIroiEW/gL/vTkeXQTFtrqfMZluz7alopMlUulvYS0HPBjRuNGFLQ1KJ1zRJJpHMb8YS3gjUPXqP9Y6fyXgYNJGpxhu8wsn956eEpqL8Dnc7oXSiI0pSqD4DMtEEPgTd1zTeaLr4wqjwHD9ROPc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 498afda7-8cf6-4af3-1532-08d726dcd85c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:43:46.8993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2fJUPI98D+7EZyblXnEpm8r00p/O/SvtkJUfMJURlQM7IvmVrG3gIw44vjVMmaJI3FT4GV4ahmzI/+nVxyjHgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements VCPU create, init and destroy functions
required by generic KVM module. We don't have much dynamic
resources in struct kvm_vcpu_arch so thest functions are quite
simple for KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
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


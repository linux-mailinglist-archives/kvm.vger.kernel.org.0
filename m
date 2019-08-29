Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173ECA1BEC
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 15:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfH2Nz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 09:55:57 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:35089 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbfH2Nz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 09:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567086956; x=1598622956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dyrF6izOq5sqcNAw3cJtmFoiEXCoEfPHdpn8K0kiMXA=;
  b=cSw4Ff0liZaipad5p841jO+9tJ8mRw21KzuRb+twfYfsw4VQ3qfeTu6P
   wssW0NiAEaiTPeHIqaCpcEFloUQjaAaa2l3ARSM5bmCkXO2xRHnTembp6
   4jyDvDIk9YEVKpefMuRDRSlRxO3ZYRGdxU+gAPF9TU7ZABxS37QpbJfWJ
   XP7STrCWSex1yKc21BjlCus/NPIoePmX+FysVNLgJOxnpy1/HX+ymMs5c
   zgdN1Uk8YBDxJjUCIVHO6a27ryqkdI0Dhi8B48hP6NhB+Zqgt9XlLgt7U
   2nxgRmyM2jDP2ctnyCOGqiZo8FSgOOWp4aEHZ46eD+Bkytj2LuswHpDqz
   w==;
IronPort-SDR: vaJ+CDYBXu0eUx1j0u1lQ5Dnea2EPNDp4d2c9vd7Lp4ih23YRT8GQiAgh4o6appQYTqo8ITrOP
 a/un6GrhC62oYxymqc/FPKezWV7X5EFySez7IzEDvSPnl97BUULaEQAUMlYaOaAZbr4qwcwUTh
 wytY5DziZYKJXOO1zuUNbAKDKI8lD+BHEFtG9aNOxH1Z3jvg1BIaSjWYUBjNdbIf4FRqOl6JQ1
 JdYwl3IRx7x6C+7FtHLwuAsn61Vl7L5abyadbGdrAgdHxHRH5LtmGpLyjPHbXOCIWVBs1wwZuG
 9VQ=
X-IronPort-AV: E=Sophos;i="5.64,443,1559491200"; 
   d="scan'208";a="116951636"
Received: from mail-by2nam05lp2059.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.59])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2019 21:55:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVJwVm7W8Ic+lhJb1m2mwYJx+F+kmAUNWReiXI/hAqNVRGkLxpmNDwsLW+ExZUiN7Lp0TScaXr4KhM8FbbSPqrB/V6I0kV6Mj4hbDxqHqcDHxyiYgfGJQUhKZP8BFuKxnz4wcHr/nW/u9Eb/tn+jrroXzyYKquvKGIj3vWyObPZxxfDwQ0b3v9XaQFP/ipk3iPL7FjdWJeePCOxbhSr0bx/GU1yNkU8/s5jk3btjWf0uRFpfd6cqj8kONDg8sdyivf+jLhoaX1j8QA9I/chetwpJoC+yZhkdPuSpHcOrQTFSs7gqslfWwH1O8WfqH1RwOTcVrxy0SzKNpawjWV9jBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur4t1q5QEmIXmlJHmmVTaWWmvsOpi2JJsk+lUDL39BM=;
 b=Jj82UkSjCRC9UJkcOlE7Fa/jGNgnvqPLoPZ3A2Qs8gjgyaVrjeR7fmKsNYaGbj60Ka1LaxPZdJczDSwYfL18bSlOkeqVFuzAUqd0Hyv0szr1nR/ShBP1Q1IGplk0CFqLfDSS9Fgm21G6dh2cP1/oMyWrARvHr/3ORGJqszjJa6bHkh/lovZuYBWJRhrIvB/HJERMAw1hZrWr3B1YmRMrLJdBCZE7qJ1fhHUuSDNFyuVD8jZDqDzrlAmzkpBtDZAnPpqYUIVerlvfMF2qtYMdBo2pwZOjKo6iFEddjn2F2Pv5JBLXDQn47kXrBdDNLFinkpLB4rckOlRuBpLEBCkzBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur4t1q5QEmIXmlJHmmVTaWWmvsOpi2JJsk+lUDL39BM=;
 b=JiD2weFwdsqVMoT4bwTZQ473DxTD2s0SMB9K/vL/wUjuizsh54GBd5cgjZMHRxY2UYZA31b3wJDtBudynAaUicpF3eKNcw/0750TxZOmuD83OVf0TK4SX42YccBXlrEXH9n4cFzjlELBpy8xb8WkKNlDq3d3WVkWn34bN+A6dwY=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5616.namprd04.prod.outlook.com (20.179.22.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 13:55:53 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.013; Thu, 29 Aug 2019
 13:55:53 +0000
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
Subject: [PATCH v6 06/21] RISC-V: KVM: Implement VCPU create, init and destroy
 functions
Thread-Topic: [PATCH v6 06/21] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
Thread-Index: AQHVXnF56Fw5V/wIH0qXs56XFqN+Fw==
Date:   Thu, 29 Aug 2019 13:55:53 +0000
Message-ID: <20190829135427.47808-7-anup.patel@wdc.com>
References: <20190829135427.47808-1-anup.patel@wdc.com>
In-Reply-To: <20190829135427.47808-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.51.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97683b6b-8249-4e10-64c3-08d72c889b52
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5616;
x-ms-traffictypediagnostic: MN2PR04MB5616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5616D898421C045873E686BF8DA20@MN2PR04MB5616.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(7416002)(52116002)(81166006)(316002)(6506007)(386003)(25786009)(7736002)(81156014)(305945005)(2906002)(36756003)(71190400001)(14454004)(99286004)(1076003)(256004)(14444005)(4326008)(66946007)(76176011)(66446008)(64756008)(66556008)(66476007)(102836004)(6116002)(50226002)(55236004)(476003)(6512007)(3846002)(71200400001)(5660300002)(26005)(186003)(44832011)(86362001)(66066001)(6436002)(446003)(8936002)(6486002)(110136005)(54906003)(2616005)(486006)(53936002)(11346002)(478600001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5616;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BPoM89mwmbC1xvGGvZf5qZ17Wrql7X5LFtptm/Qx9irS7oc1o52tagblZX8fX8ozmV1OkQLbbG/PM8IDceZ13/JxqZsakH7atzWSyi8YybWmGqwZZPPlbZw3TWM903Lp5bMTD9EaatrbwgGi8G8yex35VwMVrmRlYmgwOGqC2xP7YxoHNUAqDr8iNEV0bhh7O+UUHUYc2nflTOrXHJd1QufArJfUFgo4n8OvmHCuvjN+lBv9ql1BuusKoSdnXxKjpEd1eQGa4Pd6nXb0DvGqQx68IVlI89c+lCNS+2n+KwivgDSC5NJ3gTGWoLOVW92gSuUNmboQ99qxSCKizApS2lTHcmlbJXatAbGu0AHWAhfxjn7dfGKMdyby5IKFBGvHgkgouhIAA8mkYB0N/ZKPgqIVBRYswumzyPDTOpVYF3o=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97683b6b-8249-4e10-64c3-08d72c889b52
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 13:55:53.3404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u/4I5ZJqzHujwOTx7tg5SeGYMagJqGRrum/7MzqpTc71SdcFh4+/KumAUNYWEBEHjJcNKJWf4ntaY3IRacZ+sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5616
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


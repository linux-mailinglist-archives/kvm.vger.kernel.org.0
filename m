Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD06A8C9D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732791AbfIDQPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:15:12 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:52123 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731550AbfIDQPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613716; x=1599149716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BvYPq0EfmQm0P7PV/xRstw+QjRSw+xsA+Ew760YCPpo=;
  b=jPv0hWUoCrNIM7bii5yEn13CtWOcuC25s0CFMUOWMkEkKURdmJWuRS9P
   F6hTOyMV8fj4nVPL/LOpsmi9pK7xzYRy73N394JSj4BibwVJBy6LlCXCX
   NfEZUxxyYWPsucj7GNZ43TU+p0kWxZMnKlk3eLgAysrpQafdk+4kUSWst
   xggE59h2U09Js6pzpS7iujc2hy+07Uk/x/AcSUp9IawVLDj7g/zgUwtzt
   2wSyxIruXF7EBBox0nv0rLoxSHTuAZUed/aqfouiCgpGH/LD/crAb0Mbp
   HJfyYlPNYNtZli8n5zj4cEUhFd6DKAH9Ys+tjtAab/OO9YqaKHxMw2AUK
   g==;
IronPort-SDR: dBSdrTXbQg91zdS7YQyLjl4aqNQzVIZOhiw1xaqX2VrSl/DVELR5TsHh3Wpi+1s0abpoaNfGVJ
 EI2/Toimrac66uuU1i+m0zodm7aBuyg9Mpp0KIK1m+tKWo3Pe1idAUxfO3bBad/jn/Rnz5N11w
 8aQmlUY4uwCPoxPItbZe7fFsoHsqX7CLUMN4HkAib7/lf6Z+i78cdScDBiQ0alpLb4bJkfuzi/
 9bUmIG7jyYgsMqInQPhA1AGjUgCvyQyRk2IdWRuvwzmK3ixUOzJCiWWoJZFKaWug498ptZTIBQ
 /zQ=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="218010548"
Received: from mail-sn1nam01lp2054.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.54])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:15:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcw2d7P00EHBxMVz4wbDxaibedzWkihMN8VsTXZYzqjDrvjHIuzWGIyxP/M+VRNoI4z1/PrbH4p+/pyUfiutEgYYl2ZQweMlobMm9mmgLRow3kiG1dx3Ly940gqTuE2YY8sYb2kiKuCzKKDfqVflNGGr2Nl3zNYyvUAC94Ww3uOe25iC6xBDtianuQ8ImpavUxPB4VZRIRHI+7m5aLNi886UJ3cWPfO3ApkT2XxrtEyEhBXnN6hVucW7fD33TAI2nLHjfOY45YDyf01bscFk0xm0HYYg8mGCLZmYKljeLqoF8Fgy92F9ZA8RK80U+Gq0DFJY7ZuDsbGKMcrGEOqWYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEdy9BQWdpVFgJJhObMkngs/vfLEQL08HB3jTsF2nUA=;
 b=oJZ+jBZuu6n13Bc0m4MW5MXwKmFRTLELTPdITRfj+qrlr/TbaBVSCDKytcUpilXk2ORgYHWBB8HD/3zvhpaWQcYWt+I6okzm1WvuG9tvv2T1oN1OCWk4h+iWxc84rGaYbtF0Yf+ijDsXhQNbWe5PmcCpD5rick4L16muazoSm0EYDU7yXCmokAzJwfSsUn22xC6B9ujVi+q0ozm268oxRFxIof2fwwcjxYAi7dCfnfT/krzEMFMxSNFmgqN1wsp2vxTOXnYzbDPAXD+nd1DqxVqg0kypjTYhKYfcEmfdYmDSmnwOhZAX0EdXBbgg2jwQqaGzD/YZZ0OOHgM7uKxLDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEdy9BQWdpVFgJJhObMkngs/vfLEQL08HB3jTsF2nUA=;
 b=RDlRoc2TblGBoNPDwap2IMqVhokXrYYjB3x0Gd8J1iwmPqfD94mljDjaJO2R4i6r9dPmfne3j0Ym0MFZKX/hxNXUsXQcBhfzl5kZwYYwNgnuypbb3TpMQMUKn8Lqzwi2KN5dKXawjyuhCgnK4mOH7X7IhWfWCPSYfvNWOjkAYII=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:15:08 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:15:08 +0000
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
Subject: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
Thread-Topic: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
Thread-Index: AQHVYzvrRPk5HCDQSkeEhNE70JJZAw==
Date:   Wed, 4 Sep 2019 16:15:08 +0000
Message-ID: <20190904161245.111924-12-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 931468e6-da33-40f6-9dd7-08d731530e00
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5504A7AEB584BAE41ED6DC2B8DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(43544003)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(14444005)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(53946003)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(30864003)(66066001)(44832011)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dJXEeoOdHHjYG9NgHP+vVpAPWmarmURi3RdU19kmbQLPVp5YmZZsjYqnr0haARfm9ADEMLXxypqPcx0YKgxzpOLiwfNVblU05665lljqDf21H0cCk7BIQqPNNhNdppFIo5nylT8MQyW3xzoyvM63xTi/FQ83wwP6c0/VIfOI0DO7bQv1L/eRaFVPM7i7ttHg2QSr8AVo5ogZmK71gX3ia+JfN3upfBo+GP7Wika52VQ29lhc+sDTTijIGNARNcUzVJGMtZfzORs5SlynASI+0atyPCiEzJpCDYCjWTiRHNmz5h45nU15arYJJ1cR4oH+07wdiNZZdCi9QW2ksOD1uti0P+00iioorE+A3Plt8WAxw6ARHgkcH06XgXgf6IjtOQJWvDOZOW8kIQpXMH623syzq+Aan9kP3B08g6s8iOM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931468e6-da33-40f6-9dd7-08d731530e00
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:15:08.4881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eWCJZUSAZ8sYWECEPlVCOO563qaw9r2aPfHgXYrIaLoeIv8pjt7cVF+xolWT1cGSs3lddDcgBnN26+fBq79XGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will get stage2 page faults whenever Guest/VM access SW emulated
MMIO device or unmapped Guest RAM.

This patch implements MMIO read/write emulation by extracting MMIO
details from the trapped load/store instruction and forwarding the
MMIO read/write to user-space. The actual MMIO emulation will happen
in user-space and KVM kernel module will only take care of register
updates before resuming the trapped VCPU.

The handling for stage2 page faults for unmapped Guest RAM will be
implemeted by a separate patch later.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h |  20 ++
 arch/riscv/kvm/mmu.c              |   7 +
 arch/riscv/kvm/vcpu_exit.c        | 512 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vcpu_switch.S      |   8 +
 4 files changed, 544 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 18f1097f1d8d..2a5209fff68d 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -53,6 +53,13 @@ struct kvm_arch {
 	phys_addr_t pgd_phys;
 };
=20
+struct kvm_mmio_decode {
+	unsigned long insn;
+	int len;
+	int shift;
+	int return_handled;
+};
+
 struct kvm_cpu_context {
 	unsigned long zero;
 	unsigned long ra;
@@ -141,6 +148,9 @@ struct kvm_vcpu_arch {
 	unsigned long irqs_pending;
 	unsigned long irqs_pending_mask;
=20
+	/* MMIO instruction details */
+	struct kvm_mmio_decode mmio_decode;
+
 	/* VCPU power-off state */
 	bool power_off;
=20
@@ -160,11 +170,21 @@ static inline void kvm_arch_vcpu_block_finish(struct =
kvm_vcpu *vcpu) {}
 int kvm_riscv_setup_vsip(void);
 void kvm_riscv_cleanup_vsip(void);
=20
+int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long h=
va,
+			 bool is_write);
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
=20
+void __kvm_riscv_unpriv_trap(void);
+
+unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
+					 bool read_insn,
+					 unsigned long guest_addr,
+					 unsigned long *trap_scause);
+void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
+				  unsigned long scause, unsigned long stval);
 int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)=
;
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long scause, unsigned long stval);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 04dd089b86ff..2b965f9aac07 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -61,6 +61,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return 0;
 }
=20
+int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long h=
va,
+			 bool is_write)
+{
+	/* TODO: */
+	return 0;
+}
+
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
 {
 	/* TODO: */
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index e4d7c8f0807a..d75a6c35b6c7 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -6,9 +6,437 @@
  *     Anup Patel <anup.patel@wdc.com>
  */
=20
+#include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <asm/csr.h>
+
+#define INSN_MATCH_LB		0x3
+#define INSN_MASK_LB		0x707f
+#define INSN_MATCH_LH		0x1003
+#define INSN_MASK_LH		0x707f
+#define INSN_MATCH_LW		0x2003
+#define INSN_MASK_LW		0x707f
+#define INSN_MATCH_LD		0x3003
+#define INSN_MASK_LD		0x707f
+#define INSN_MATCH_LBU		0x4003
+#define INSN_MASK_LBU		0x707f
+#define INSN_MATCH_LHU		0x5003
+#define INSN_MASK_LHU		0x707f
+#define INSN_MATCH_LWU		0x6003
+#define INSN_MASK_LWU		0x707f
+#define INSN_MATCH_SB		0x23
+#define INSN_MASK_SB		0x707f
+#define INSN_MATCH_SH		0x1023
+#define INSN_MASK_SH		0x707f
+#define INSN_MATCH_SW		0x2023
+#define INSN_MASK_SW		0x707f
+#define INSN_MATCH_SD		0x3023
+#define INSN_MASK_SD		0x707f
+
+#define INSN_MATCH_C_LD		0x6000
+#define INSN_MASK_C_LD		0xe003
+#define INSN_MATCH_C_SD		0xe000
+#define INSN_MASK_C_SD		0xe003
+#define INSN_MATCH_C_LW		0x4000
+#define INSN_MASK_C_LW		0xe003
+#define INSN_MATCH_C_SW		0xc000
+#define INSN_MASK_C_SW		0xe003
+#define INSN_MATCH_C_LDSP	0x6002
+#define INSN_MASK_C_LDSP	0xe003
+#define INSN_MATCH_C_SDSP	0xe002
+#define INSN_MASK_C_SDSP	0xe003
+#define INSN_MATCH_C_LWSP	0x4002
+#define INSN_MASK_C_LWSP	0xe003
+#define INSN_MATCH_C_SWSP	0xc002
+#define INSN_MASK_C_SWSP	0xe003
+
+#define INSN_LEN(insn)		((((insn) & 0x3) < 0x3) ? 2 : 4)
+
+#ifdef CONFIG_64BIT
+#define LOG_REGBYTES		3
+#else
+#define LOG_REGBYTES		2
+#endif
+#define REGBYTES		(1 << LOG_REGBYTES)
+
+#define SH_RD			7
+#define SH_RS1			15
+#define SH_RS2			20
+#define SH_RS2C			2
+
+#define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
+#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
+				 (RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 5, 1) << 6))
+#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 5, 2) << 6))
+#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
+				 (RV_X(x, 12, 1) << 5) | \
+				 (RV_X(x, 2, 2) << 6))
+#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
+				 (RV_X(x, 12, 1) << 5) | \
+				 (RV_X(x, 2, 3) << 6))
+#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
+				 (RV_X(x, 7, 2) << 6))
+#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
+				 (RV_X(x, 7, 3) << 6))
+#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
+#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
+#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
+
+#define SHIFT_RIGHT(x, y)		\
+	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
+
+#define REG_MASK			\
+	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
+
+#define REG_OFFSET(insn, pos)		\
+	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
+
+#define REG_PTR(insn, pos, regs)	\
+	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
+
+#define GET_RM(insn)		(((insn) >> 12) & 7)
+
+#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
+#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
+#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
+#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
+#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
+#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
+#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) =3D (val))
+#define IMM_I(insn)		((s32)(insn) >> 20)
+#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
+				 (s32)(((insn) >> 7) & 0x1f))
+#define MASK_FUNCT3		0x7000
+
+static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			unsigned long fault_addr)
+{
+	int shift =3D 0, len =3D 0;
+	unsigned long ut_scause =3D 0;
+	struct kvm_cpu_context *ct =3D &vcpu->arch.guest_context;
+	ulong insn =3D kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
+						&ut_scause);
+
+	/* Redirect trap if we failed to read instruction */
+	if (ut_scause) {
+		if (ut_scause =3D=3D EXC_LOAD_PAGE_FAULT)
+			ut_scause =3D EXC_INST_PAGE_FAULT;
+		kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause, ct->sepc);
+		return 1;
+	}
+
+	/* Decode length of MMIO and shift */
+	if ((insn & INSN_MASK_LW) =3D=3D INSN_MATCH_LW) {
+		len =3D 4;
+		shift =3D 8 * (sizeof(ulong) - len);
+	} else if ((insn & INSN_MASK_LB) =3D=3D INSN_MATCH_LB) {
+		len =3D 1;
+		shift =3D 8 * (sizeof(ulong) - len);
+	} else if ((insn & INSN_MASK_LBU) =3D=3D INSN_MATCH_LBU) {
+		len =3D 1;
+		shift =3D 8 * (sizeof(ulong) - len);
+#ifdef CONFIG_64BIT
+	} else if ((insn & INSN_MASK_LD) =3D=3D INSN_MATCH_LD) {
+		len =3D 8;
+		shift =3D 8 * (sizeof(ulong) - len);
+	} else if ((insn & INSN_MASK_LWU) =3D=3D INSN_MATCH_LWU) {
+		len =3D 4;
+#endif
+	} else if ((insn & INSN_MASK_LH) =3D=3D INSN_MATCH_LH) {
+		len =3D 2;
+		shift =3D 8 * (sizeof(ulong) - len);
+	} else if ((insn & INSN_MASK_LHU) =3D=3D INSN_MATCH_LHU) {
+		len =3D 2;
+#ifdef CONFIG_RISCV_ISA_C
+#ifdef CONFIG_64BIT
+	} else if ((insn & INSN_MASK_C_LD) =3D=3D INSN_MATCH_C_LD) {
+		len =3D 8;
+		shift =3D 8 * (sizeof(ulong) - len);
+		insn =3D RVC_RS2S(insn) << SH_RD;
+	} else if ((insn & INSN_MASK_C_LDSP) =3D=3D INSN_MATCH_C_LDSP &&
+		   ((insn >> SH_RD) & 0x1f)) {
+		len =3D 8;
+		shift =3D 8 * (sizeof(ulong) - len);
+#endif
+	} else if ((insn & INSN_MASK_C_LW) =3D=3D INSN_MATCH_C_LW) {
+		len =3D 4;
+		shift =3D 8 * (sizeof(ulong) - len);
+		insn =3D RVC_RS2S(insn) << SH_RD;
+	} else if ((insn & INSN_MASK_C_LWSP) =3D=3D INSN_MATCH_C_LWSP &&
+		   ((insn >> SH_RD) & 0x1f)) {
+		len =3D 4;
+		shift =3D 8 * (sizeof(ulong) - len);
+#endif
+	} else {
+		return -ENOTSUPP;
+	}
+
+	/* Fault address should be aligned to length of MMIO */
+	if (fault_addr & (len - 1))
+		return -EIO;
+
+	/* Save instruction decode info */
+	vcpu->arch.mmio_decode.insn =3D insn;
+	vcpu->arch.mmio_decode.shift =3D shift;
+	vcpu->arch.mmio_decode.len =3D len;
+	vcpu->arch.mmio_decode.return_handled =3D 0;
+
+	/* Exit to userspace for MMIO emulation */
+	vcpu->stat.mmio_exit_user++;
+	run->exit_reason =3D KVM_EXIT_MMIO;
+	run->mmio.is_write =3D false;
+	run->mmio.phys_addr =3D fault_addr;
+	run->mmio.len =3D len;
+
+	return 0;
+}
+
+static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			 unsigned long fault_addr)
+{
+	u8 data8;
+	u16 data16;
+	u32 data32;
+	u64 data64;
+	ulong data;
+	int len =3D 0;
+	unsigned long ut_scause =3D 0;
+	struct kvm_cpu_context *ct =3D &vcpu->arch.guest_context;
+	ulong insn =3D kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
+						&ut_scause);
+
+	/* Redirect trap if we failed to read instruction */
+	if (ut_scause) {
+		if (ut_scause =3D=3D EXC_LOAD_PAGE_FAULT)
+			ut_scause =3D EXC_INST_PAGE_FAULT;
+		kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause, ct->sepc);
+		return 1;
+	}
+
+	data =3D GET_RS2(insn, &vcpu->arch.guest_context);
+	data8 =3D data16 =3D data32 =3D data64 =3D data;
+
+	if ((insn & INSN_MASK_SW) =3D=3D INSN_MATCH_SW) {
+		len =3D 4;
+	} else if ((insn & INSN_MASK_SB) =3D=3D INSN_MATCH_SB) {
+		len =3D 1;
+#ifdef CONFIG_64BIT
+	} else if ((insn & INSN_MASK_SD) =3D=3D INSN_MATCH_SD) {
+		len =3D 8;
+#endif
+	} else if ((insn & INSN_MASK_SH) =3D=3D INSN_MATCH_SH) {
+		len =3D 2;
+#ifdef CONFIG_RISCV_ISA_C
+#ifdef CONFIG_64BIT
+	} else if ((insn & INSN_MASK_C_SD) =3D=3D INSN_MATCH_C_SD) {
+		len =3D 8;
+		data64 =3D GET_RS2S(insn, &vcpu->arch.guest_context);
+	} else if ((insn & INSN_MASK_C_SDSP) =3D=3D INSN_MATCH_C_SDSP &&
+		   ((insn >> SH_RD) & 0x1f)) {
+		len =3D 8;
+		data64 =3D GET_RS2C(insn, &vcpu->arch.guest_context);
+#endif
+	} else if ((insn & INSN_MASK_C_SW) =3D=3D INSN_MATCH_C_SW) {
+		len =3D 4;
+		data32 =3D GET_RS2S(insn, &vcpu->arch.guest_context);
+	} else if ((insn & INSN_MASK_C_SWSP) =3D=3D INSN_MATCH_C_SWSP &&
+		   ((insn >> SH_RD) & 0x1f)) {
+		len =3D 4;
+		data32 =3D GET_RS2C(insn, &vcpu->arch.guest_context);
+#endif
+	} else {
+		return -ENOTSUPP;
+	}
+
+	/* Fault address should be aligned to length of MMIO */
+	if (fault_addr & (len - 1))
+		return -EIO;
+
+	/* Save instruction decode info */
+	vcpu->arch.mmio_decode.insn =3D insn;
+	vcpu->arch.mmio_decode.shift =3D 0;
+	vcpu->arch.mmio_decode.len =3D len;
+	vcpu->arch.mmio_decode.return_handled =3D 0;
+
+	/* Copy data to kvm_run instance */
+	switch (len) {
+	case 1:
+		*((u8 *)run->mmio.data) =3D data8;
+		break;
+	case 2:
+		*((u16 *)run->mmio.data) =3D data16;
+		break;
+	case 4:
+		*((u32 *)run->mmio.data) =3D data32;
+		break;
+	case 8:
+		*((u64 *)run->mmio.data) =3D data64;
+		break;
+	default:
+		return -ENOTSUPP;
+	};
+
+	/* Exit to userspace for MMIO emulation */
+	vcpu->stat.mmio_exit_user++;
+	run->exit_reason =3D KVM_EXIT_MMIO;
+	run->mmio.is_write =3D true;
+	run->mmio.phys_addr =3D fault_addr;
+	run->mmio.len =3D len;
+
+	return 0;
+}
+
+static int stage2_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			     unsigned long scause, unsigned long stval)
+{
+	struct kvm_memory_slot *memslot;
+	unsigned long hva;
+	bool writable;
+	gfn_t gfn;
+	int ret;
+
+	gfn =3D stval >> PAGE_SHIFT;
+	memslot =3D gfn_to_memslot(vcpu->kvm, gfn);
+	hva =3D gfn_to_hva_memslot_prot(memslot, gfn, &writable);
+
+	if (kvm_is_error_hva(hva) ||
+	    (scause =3D=3D EXC_STORE_PAGE_FAULT && !writable)) {
+		switch (scause) {
+		case EXC_LOAD_PAGE_FAULT:
+			return emulate_load(vcpu, run, stval);
+		case EXC_STORE_PAGE_FAULT:
+			return emulate_store(vcpu, run, stval);
+		default:
+			return -ENOTSUPP;
+		};
+	}
+
+	ret =3D kvm_riscv_stage2_map(vcpu, stval, hva,
+			(scause =3D=3D EXC_STORE_PAGE_FAULT) ? true : false);
+	if (ret < 0)
+		return ret;
+
+	return 1;
+}
+
+#define STR(x)		XSTR(x)
+#define XSTR(x)		#x
+
+/**
+ * kvm_riscv_vcpu_unpriv_read -- Read machine word from Guest memory
+ *
+ * @vcpu: The VCPU pointer
+ * @read_insn: Flag representing whether we are reading instruction
+ * @guest_addr: Guest address to read
+ * @trap_scause: Output pointer for unprivilege trap cause
+ * @trap_stval: Output pointer for unprivilege trap value
+ */
+unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
+					 bool read_insn,
+					 unsigned long guest_addr,
+					 unsigned long *trap_scause)
+{
+	register unsigned long tilen asm("a0");
+	register unsigned long tscause asm("a1");
+	register unsigned long val asm("a2");
+	register unsigned long addr asm("a3") =3D guest_addr;
+	unsigned long guest_sstatus =3D
+			vcpu->arch.guest_context.sstatus | SR_MXR;
+	unsigned long guest_hstatus =3D
+			vcpu->arch.guest_context.hstatus | HSTATUS_SPRV;
+	unsigned long guest_vsstatus, old_stvec, tmp;
+
+	guest_sstatus =3D csr_swap(CSR_SSTATUS, guest_sstatus);
+	old_stvec =3D csr_swap(CSR_STVEC, (ulong)&__kvm_riscv_unpriv_trap);
+
+	if (read_insn) {
+		guest_vsstatus =3D csr_read_set(CSR_VSSTATUS, SR_MXR);
+		asm volatile ("\n"
+			"csrrw %[hstatus], " STR(CSR_HSTATUS) ", %[hstatus]\n"
+			"li %[tilen], 4\n"
+			"li %[tscause], 0\n"
+			"lhu %[val], (%[addr])\n"
+			"andi %[tmp], %[val], 3\n"
+			"addi %[tmp], %[tmp], -3\n"
+			"bne %[tmp], zero, 2f\n"
+			"lhu %[tmp], 2(%[addr])\n"
+			"sll %[tmp], %[tmp], 16\n"
+			"add %[val], %[val], %[tmp]\n"
+			"2: csrw " STR(CSR_HSTATUS) ", %[hstatus]"
+		: [hstatus] "+&r"(guest_hstatus), [val] "=3D&r" (val),
+		  [tmp] "=3D&r" (tmp), [tilen] "+&r" (tilen),
+		  [tscause] "+&r" (tscause)
+		: [addr] "r" (addr));
+		csr_write(CSR_VSSTATUS, guest_vsstatus);
+	} else {
+		asm volatile ("\n"
+			"csrrw %[hstatus], " STR(CSR_HSTATUS) ", %[hstatus]\n"
+#ifndef CONFIG_RISCV_ISA_C
+			"li %[tilen], 4\n"
+#else
+			"li %[tilen], 2\n"
+#endif
+			"li %[tscause], 0\n"
+#ifdef CONFIG_64BIT
+			"ld %[val], (%[addr])\n"
+#else
+			"lw %[val], (%[addr])\n"
+#endif
+			"csrw " STR(CSR_HSTATUS) ", %[hstatus]"
+		: [hstatus] "+&r"(guest_hstatus),
+		  [val] "=3D&r" (val), [tilen] "+&r" (tilen),
+		  [tscause] "+&r" (tscause)
+		: [addr] "r" (addr));
+	}
+
+	csr_write(CSR_STVEC, old_stvec);
+	csr_write(CSR_SSTATUS, guest_sstatus);
+
+	*trap_scause =3D tscause;
+
+	return val;
+}
+
+/**
+ * kvm_riscv_vcpu_trap_redirect -- Redirect trap to Guest
+ *
+ * @vcpu: The VCPU pointer
+ * @scause: Trap exception cause
+ * @stval: Trap value
+ */
+void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
+				  unsigned long scause, unsigned long stval)
+{
+	unsigned long vsstatus =3D csr_read(CSR_VSSTATUS);
+
+	/* Change Guest SSTATUS.SPP bit */
+	vsstatus &=3D ~SR_SPP;
+	if (vcpu->arch.guest_context.sstatus & SR_SPP)
+		vsstatus |=3D SR_SPP;
+
+	/* Change Guest SSTATUS.SPIE bit */
+	vsstatus &=3D ~SR_SPIE;
+	if (vsstatus & SR_SIE)
+		vsstatus |=3D SR_SPIE;
+
+	/* Clear Guest SSTATUS.SIE bit */
+	vsstatus &=3D ~SR_SIE;
+
+	/* Update Guest SSTATUS */
+	csr_write(CSR_VSSTATUS, vsstatus);
+
+	/* Update Guest SCAUSE, STVAL, and SEPC */
+	csr_write(CSR_VSCAUSE, scause);
+	csr_write(CSR_VSTVAL, stval);
+	csr_write(CSR_VSEPC, vcpu->arch.guest_context.sepc);
+
+	/* Set Guest PC to Guest exception vector */
+	vcpu->arch.guest_context.sepc =3D csr_read(CSR_VSTVEC);
+}
=20
 /**
  * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulat=
ion
@@ -19,7 +447,54 @@
  */
 int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	/* TODO: */
+	u8 data8;
+	u16 data16;
+	u32 data32;
+	u64 data64;
+	ulong insn;
+	int len, shift;
+
+	if (vcpu->arch.mmio_decode.return_handled)
+		return 0;
+
+	vcpu->arch.mmio_decode.return_handled =3D 1;
+	insn =3D vcpu->arch.mmio_decode.insn;
+
+	if (run->mmio.is_write)
+		goto done;
+
+	len =3D vcpu->arch.mmio_decode.len;
+	shift =3D vcpu->arch.mmio_decode.shift;
+
+	switch (len) {
+	case 1:
+		data8 =3D *((u8 *)run->mmio.data);
+		SET_RD(insn, &vcpu->arch.guest_context,
+			(ulong)data8 << shift >> shift);
+		break;
+	case 2:
+		data16 =3D *((u16 *)run->mmio.data);
+		SET_RD(insn, &vcpu->arch.guest_context,
+			(ulong)data16 << shift >> shift);
+		break;
+	case 4:
+		data32 =3D *((u32 *)run->mmio.data);
+		SET_RD(insn, &vcpu->arch.guest_context,
+			(ulong)data32 << shift >> shift);
+		break;
+	case 8:
+		data64 =3D *((u64 *)run->mmio.data);
+		SET_RD(insn, &vcpu->arch.guest_context,
+			(ulong)data64 << shift >> shift);
+		break;
+	default:
+		return -ENOTSUPP;
+	};
+
+done:
+	/* Move to next instruction */
+	vcpu->arch.guest_context.sepc +=3D INSN_LEN(insn);
+
 	return 0;
 }
=20
@@ -30,6 +505,37 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, s=
truct kvm_run *run)
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long scause, unsigned long stval)
 {
-	/* TODO: */
-	return 0;
+	int ret;
+
+	/* If we got host interrupt then do nothing */
+	if (scause & SCAUSE_IRQ_FLAG)
+		return 1;
+
+	/* Handle guest traps */
+	ret =3D -EFAULT;
+	run->exit_reason =3D KVM_EXIT_UNKNOWN;
+	switch (scause) {
+	case EXC_INST_PAGE_FAULT:
+	case EXC_LOAD_PAGE_FAULT:
+	case EXC_STORE_PAGE_FAULT:
+		if ((vcpu->arch.guest_context.hstatus & HSTATUS_SPV) &&
+		    (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
+			ret =3D stage2_page_fault(vcpu, run, scause, stval);
+		break;
+	default:
+		break;
+	};
+
+	/* Print details in-case of error */
+	if (ret < 0) {
+		kvm_err("VCPU exit error %d\n", ret);
+		kvm_err("SEPC=3D0x%lx SSTATUS=3D0x%lx HSTATUS=3D0x%lx\n",
+			vcpu->arch.guest_context.sepc,
+			vcpu->arch.guest_context.sstatus,
+			vcpu->arch.guest_context.hstatus);
+		kvm_err("SCAUSE=3D0x%lx STVAL=3D0x%lx\n",
+			scause, stval);
+	}
+
+	return ret;
 }
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index e1a17df1b379..ee45c331666f 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -192,3 +192,11 @@ __kvm_switch_return:
 	/* Return to C code */
 	ret
 ENDPROC(__kvm_riscv_switch_to)
+
+ENTRY(__kvm_riscv_unpriv_trap)
+	csrr	a1, CSR_SEPC
+	add	a1, a1, a0
+	csrw	CSR_SEPC, a1
+	csrr	a1, CSR_SCAUSE
+	sret
+ENDPROC(__kvm_riscv_unpriv_trap)
--=20
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4928178B2A
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 13:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbfG2L5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 07:57:42 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55787 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387692AbfG2L5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 07:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564401482; x=1595937482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xpDXEcQCHQS/xr8mjqVmmvdc/WphGfK2whnnvihv9M8=;
  b=gLPl8p2jOIVrtT/PMb2VfZmnLBkeR/X53Y6tcBStzuaP4exbY4whQKgn
   +/wAvNPiLoi1qG7s7s6O7bfHPbYe3l5nJszFnZbIsfrXCj/qEu0NUVo1D
   e8pB8H4q3/KSRm6lXWCT3UFhwTTzhQOSfu0+mnOdHej6h1zC9vTwtjymV
   7szfKqB2PvI4dYazac93+YBbKIYbz7S7vwrnl9gxNH9Uhezmyp+clj4Ih
   N95qFdqpkuIMtK4mQQZbAK83fNGeQ25ZdzfQ64PiAdzGhmnCCdSPb+cPs
   QfYGVsnTpgAJYAhlv40o7zwu5D24GKaSY8+cHd+kPx0zPT6GYDtP9J0P4
   Q==;
IronPort-SDR: XWj1eqsTSC2RAWkd4lu8L45GToz442B0M+WxT0G+bEJpBeecSdsDfP875HZViN0rjqdxKJKQsq
 i9sMBbbgz6YBLyP356muaL9nIurj/6a2RRXiqTi7Pb/3+fTnkA/ndOVUzIT8vzwXAIybyf99Tz
 dfjU9Ac1/BwVjNrbETd3CbKYoWBsqRzaXHA7lLyP2q3LtSw1iEp2KpmDriCBgP2yWVQnpYHYjm
 ko33rIg5iDIbMC+RBG1MbDiDCZHDHyJA7honmwpjU/Z9xzi/PtvcsF3JqU594X+XQJUrYfQcCr
 q1A=
X-IronPort-AV: E=Sophos;i="5.64,322,1559491200"; 
   d="scan'208";a="214553098"
Received: from mail-by2nam01lp2054.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.54])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2019 19:57:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LM7IdwnO0ctYNOrFfllsI/RqAEKLr7o+PhARxy4TgCLC1WykyBTLRs4uX1+BHmXMq/VU0tNvb9VhQKbLOvNQeBUNSH0/p2phBnMHEgx+Px5Kwx9RG/9Mj2jQ8fXKQR5maQSbF/ptN2VYtFn3IMaum37F/k6egrI5t+U5aia4Shjf6YvWul/m0RjG/vxWtDyKCTXBn22lFuDleivgQG9Av3/I3W+8sHc0XHW6ya9/L4+t0JcIe0fknm5Ri5CxVFsEkehSuqg+8J2poYjoJJTnnGbta5yBs4WV0hnw0A1W5hR5V4875mrWSdHA5huOYJAPjVSPd8QyDMHR8L8z+mgVLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2FcxQ+LvCmMPq17s19+HkWsiQ1GmFeddPkcnGiLIYY=;
 b=POB3RxzQ+4rrAw711pBBq0cOLiiVKHTuzcAJLCbykxw4x8fkdrUaZAc3r4sk/M/1rwa3Tm6ykfdEFudjzSGvdtt9O2aHnbu22TTH3k/4GjuArkkNxaI4MtSao/uabA46qasgUYR66h+q15+CHQzVuw/4tAA4//xeAfjjZZ6xWbUP4J3FCJ7Jy66NmND/Pepn3cTxntGUlF6q6bkgXmBjorEFdjpn4u5vDj421w3DmIelbfmQdpoYa88FLnV8zdvydisFwWvumlL2a26icE0H6fvWnRtOqr8X4pQSB/ilKMvblf2UY3ZiqzDht2fnO/Luru5codSjAVlRn6/B7P64jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2FcxQ+LvCmMPq17s19+HkWsiQ1GmFeddPkcnGiLIYY=;
 b=shpgNNzzffGktpQmFtOTm3x0mi9NwpcTthjGued2Powm+J7W9mRVsVenGoSfMV+etnB7ZFJbl7cO/7bX2R+PE4pPZiQx2j6i+d90ZfqY2SBdYOw5donsuVS6LmN+Goh2jkL+e4BRr5dCWUdXWWxyNaegXgjUmge1S5BJo9qZo/M=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5678.namprd04.prod.outlook.com (20.179.21.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 11:57:12 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 11:57:12 +0000
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
Subject: [RFC PATCH 08/16] RISC-V: KVM: Handle MMIO exits for VCPU
Thread-Topic: [RFC PATCH 08/16] RISC-V: KVM: Handle MMIO exits for VCPU
Thread-Index: AQHVRgTBV1nnPakppkiiH6g+ziCH+A==
Date:   Mon, 29 Jul 2019 11:57:11 +0000
Message-ID: <20190729115544.17895-9-anup.patel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
In-Reply-To: <20190729115544.17895-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0116.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::32)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.23.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dc42f81-e0a8-4dad-1e37-08d7141be3dd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5678;
x-ms-traffictypediagnostic: MN2PR04MB5678:
x-microsoft-antispam-prvs: <MN2PR04MB5678D36BEBE9F917BAF2EA4B8DDD0@MN2PR04MB5678.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:419;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(43544003)(7416002)(52116002)(6436002)(6486002)(7736002)(476003)(2616005)(2906002)(5660300002)(66066001)(4326008)(446003)(68736007)(11346002)(81156014)(81166006)(14454004)(53936002)(26005)(186003)(78486014)(99286004)(36756003)(44832011)(486006)(305945005)(8676002)(54906003)(110136005)(25786009)(8936002)(478600001)(76176011)(102836004)(71200400001)(30864003)(6512007)(1076003)(66446008)(64756008)(66946007)(256004)(55236004)(316002)(9456002)(86362001)(66476007)(50226002)(66556008)(6506007)(386003)(71190400001)(14444005)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5678;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WxZ5at1u0+YOQIGmOb4UYdB5XIR6Zb6PNughxYt3nOEoOaLOd5LAGl8RCH48XlyNXpSpD4aJkwaEABJwiVtopCNpMYrWKTazni90Q2lW4nOdVBFjFuB87pbtoNchuVgSYb08c/XKJM9+gZnbK/B6WxAcsoRotk84Bj191NH7RenODcdgbCIb8KZ6GoS6ob28t1HpSC01cHsRcWsFKUIgeIE+H7sUISQEvokXlOo/OKArUJftXMvIarBOVIfiHGI7iitbiKwkBIqR8S33in5J9SQwNVjmflNfId3SsLx3KKSVbAG0TzPG3aX6jyHMsg30ufZSly8z1xEhAy6XR+u+Nfhq13jDrUVYT9f4iFFwDVjBUlbKWdDdWedOakZBmE23nz+OBpSH9jBqJrId62svla+5c2GjEpSeBATOPi7hcL8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc42f81-e0a8-4dad-1e37-08d7141be3dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 11:57:11.8164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5678
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
---
 arch/riscv/include/asm/kvm_host.h |  11 +
 arch/riscv/kvm/mmu.c              |   7 +
 arch/riscv/kvm/vcpu_exit.c        | 435 +++++++++++++++++++++++++++++-
 3 files changed, 450 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 006785bd6474..82e568ae0260 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -54,6 +54,12 @@ struct kvm_arch {
 	phys_addr_t pgd_phys;
 };
=20
+struct kvm_mmio_decode {
+	unsigned long insn;
+	int len;
+	int shift;
+};
+
 struct kvm_cpu_context {
 	unsigned long zero;
 	unsigned long ra;
@@ -136,6 +142,9 @@ struct kvm_vcpu_arch {
 	raw_spinlock_t irqs_lock;
 	unsigned long irqs_pending;
=20
+	/* MMIO instruction details */
+	struct kvm_mmio_decode mmio_decode;
+
 	/* VCPU power-off state */
 	bool power_off;
=20
@@ -149,6 +158,8 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu=
 *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
=20
+int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long h=
va,
+			 bool is_write);
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index cead012a8399..963f3c373781 100644
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
index e4d7c8f0807a..4dafefa59338 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -6,9 +6,370 @@
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
+#define STR(x)			XSTR(x)
+#define XSTR(x)			#x
+
+static ulong get_insn(struct kvm_vcpu *vcpu)
+{
+	ulong __sepc =3D vcpu->arch.guest_context.sepc;
+	ulong __hstatus, __sstatus, __vsstatus;
+#ifdef CONFIG_RISCV_ISA_C
+	ulong rvc_mask =3D 3, tmp;
+#endif
+	ulong flags, val;
+
+	local_irq_save(flags);
+
+	__vsstatus =3D csr_read(CSR_VSSTATUS);
+	__sstatus =3D csr_read(CSR_SSTATUS);
+	__hstatus =3D csr_read(CSR_HSTATUS);
+
+	csr_write(CSR_VSSTATUS, __vsstatus | SR_MXR);
+	csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus | SR_MXR);
+	csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
+
+#ifndef CONFIG_RISCV_ISA_C
+	asm ("\n"
+#ifdef CONFIG_64BIT
+		STR(LWU) " %[insn], (%[addr])\n"
+#else
+		STR(LW) " %[insn], (%[addr])\n"
+#endif
+		: [insn] "=3D&r" (val) : [addr] "r" (__sepc));
+#else
+	asm ("and %[tmp], %[addr], 2\n"
+		"bnez %[tmp], 1f\n"
+#ifdef CONFIG_64BIT
+		STR(LWU) " %[insn], (%[addr])\n"
+#else
+		STR(LW) " %[insn], (%[addr])\n"
+#endif
+		"and %[tmp], %[insn], %[rvc_mask]\n"
+		"beq %[tmp], %[rvc_mask], 2f\n"
+		"sll %[insn], %[insn], %[xlen_minus_16]\n"
+		"srl %[insn], %[insn], %[xlen_minus_16]\n"
+		"j 2f\n"
+		"1:\n"
+		"lhu %[insn], (%[addr])\n"
+		"and %[tmp], %[insn], %[rvc_mask]\n"
+		"bne %[tmp], %[rvc_mask], 2f\n"
+		"lhu %[tmp], 2(%[addr])\n"
+		"sll %[tmp], %[tmp], 16\n"
+		"add %[insn], %[insn], %[tmp]\n"
+		"2:"
+	: [vsstatus] "+&r" (__vsstatus), [insn] "=3D&r" (val),
+	  [tmp] "=3D&r" (tmp)
+	: [addr] "r" (__sepc), [rvc_mask] "r" (rvc_mask),
+	  [xlen_minus_16] "i" (__riscv_xlen - 16));
+#endif
+
+	csr_write(CSR_HSTATUS, __hstatus);
+	csr_write(CSR_SSTATUS, __sstatus);
+	csr_write(CSR_VSSTATUS, __vsstatus);
+
+	local_irq_restore(flags);
+
+	return val;
+}
+
+static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			unsigned long fault_addr)
+{
+	int shift =3D 0, len =3D 0;
+	ulong insn =3D get_insn(vcpu);
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
+
+	/* Exit to userspace for MMIO emulation */
+	vcpu->stat.mmio_exit_user++;
+	run->exit_reason =3D KVM_EXIT_MMIO;
+	run->mmio.is_write =3D false;
+	run->mmio.phys_addr =3D fault_addr;
+	run->mmio.len =3D len;
+
+	/* Move to next instruction */
+	vcpu->arch.guest_context.sepc +=3D INSN_LEN(insn);
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
+	ulong insn =3D get_insn(vcpu);
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
+	/* Clear instruction decode info */
+	vcpu->arch.mmio_decode.insn =3D 0;
+	vcpu->arch.mmio_decode.shift =3D 0;
+	vcpu->arch.mmio_decode.len =3D 0;
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
+	/* Move to next instruction */
+	vcpu->arch.guest_context.sepc +=3D INSN_LEN(insn);
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
=20
 /**
  * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulat=
ion
@@ -19,7 +380,44 @@
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
+	if (run->mmio.is_write)
+		return 0;
+
+	insn =3D vcpu->arch.mmio_decode.insn;
+	len =3D vcpu->arch.mmio_decode.len;
+	shift =3D vcpu->arch.mmio_decode.shift;
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
 	return 0;
 }
=20
@@ -30,6 +428,37 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, s=
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
--=20
2.17.1


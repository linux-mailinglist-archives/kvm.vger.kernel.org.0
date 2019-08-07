Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CE784B82
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 14:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfHGM3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 08:29:07 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:14458 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387952AbfHGM3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 08:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565180943; x=1596716943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LJK/Ave72PsAI8/vCQ5O2MevwtdH9wZZUfu65V+58yE=;
  b=p3EfNKHokl80mrkAu88xBaeifzmVZqNYqX5be9uuVOG/D5VE+ef7VdUi
   0gY4BwWQ+h3sG731swq9Z6FJEGYkK5blkX0gtxdOpTzTEfmIcoE36eUEg
   qEcG+1tpLSOOF8DmuIn73piz9nLUD14HayNLe60KTIEherYmjhiRViSjl
   QoZG5bVjlybdlvPjiiWV5sGK05ZhiSXKyR8BNWBw3JlV3p1YhZaFcKCoy
   zXp+q9HDlq03wcaLGQuRBp24BVyHKK6WkbTiUHO4QoGp3YaOBh7s4o5U9
   b30LnaKsgfuhzgP+06VgmNaZIVf8ODCYAb/RueEASSS27/BsjXjZOdPM9
   w==;
IronPort-SDR: Wl0Onmd4KpTW1dNGCa2KQqOmXPWNoqq4PiTO9PsHIxzSuQK1lakRn1HijWmNrV2lDIt9gWf/Tb
 UnRWKfOB/WXqkHSXHlf+zAePiD/oQmjcfEjPT6+GZH96MaRFEwOJo+WWdLA9Us25sLNRtQz+lD
 FW/Yt1EvzuhroFKqZN8OUBgWNEpyrx+lQRc3y8OHHNZ/wxx15fQTtuKxYGr/Hq0npE5L5StfGr
 7vBZ1twWmNNBmKgLFZNMarqdy1HMv38nn2BozpW8SamnLVJqBi3U94Be1W1oD2c8cbLOR+KVPH
 yew=
X-IronPort-AV: E=Sophos;i="5.64,357,1559491200"; 
   d="scan'208";a="116203144"
Received: from mail-sn1nam02lp2050.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.50])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2019 20:29:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fi9nfPyUerCZUsNH3bOgWTamHzA/+bT6ioptXQvhZV6jwoao1EVWu6twHpiZ4YXxNxvxKoJiVAJdM3Ax6bA8TO4FE95G1YnguOg6ZUeR0HzwsRj5KfNZYLn4LwOIMQyH2O7JJKTi0XMQLNabySILoFBChD8a3kpA+G3ndBnDMKY5teayS/ybC0541XtzBshr3/vRux2AnwmOpg2AI6VP6h5LX/BDCnbddmlTzhzlyjMgSYYW/2RaI8FV9MXmxTUMWNWVOHnRalFbOefGJ2XJofYf7Ev0RKMAafCdseIUW630XOkSN4PpFDtVypW8zhYAwANu/ZdKTcym4cW2/PFWSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVYBAjg+2QT2TGeXB9UPwk4iIcAgNCJaLaePojKPLFg=;
 b=e+3g0lMVrYJj29yrDQZxBa0dgsmPqODiyS2GSyd9CLMqwWvWOsMyUkBLqfiuePwwD3XmdLwtEy1YpT/Dl0H8y+vXgJ/sZBhiIHxYxBzKhUpj05bctasktE4YtN5WoBdkaOkjKw2mJTokeVtfnsibUXs5MBXWQZQLIY+cgX0RPl/ZSKwbSco8dHPYhD0yEjimM+0mibBoySj7uaKAmMijFJPAAi1aymagV7IPxfSrDFnA7go+q+Sx/WgJbJnUIZVm6OEWAo0UVujFYYkepj0BDlv9HZC0P6iJyJaPt8frVtvRxV/gTMD/PMCaCPOCRvD9//PCQ33v24ZQbXlk32H4Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVYBAjg+2QT2TGeXB9UPwk4iIcAgNCJaLaePojKPLFg=;
 b=PbEt+hsn6BqmvYM5zzeHwqjrxpA0xUGS1tqy1j9JaVlVi6lgwoiChM7EfbCB6bOnxWKLUDhq9kG8MJY0S/mIwQ9WmJlpZGL9Jgs//kUCU+KCSFdUeUu5aFeLbjVxkjJENfvkElrPq7ltAyf6DBNtvc85SOpSLm4yePDyjHizI2I=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6736.namprd04.prod.outlook.com (10.141.117.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 12:29:00 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 12:29:00 +0000
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
Subject: [PATCH v4 11/20] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Topic: [PATCH v4 11/20] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Index: AQHVTRuwIPnaNBGEi0+X6jARzczRdw==
Date:   Wed, 7 Aug 2019 12:29:00 +0000
Message-ID: <20190807122726.81544-12-anup.patel@wdc.com>
References: <20190807122726.81544-1-anup.patel@wdc.com>
In-Reply-To: <20190807122726.81544-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0097.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::13)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.52.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd9282e7-174b-4ed3-8321-08d71b32d30b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6736;
x-ms-traffictypediagnostic: MN2PR04MB6736:
x-microsoft-antispam-prvs: <MN2PR04MB67365D33315256F468003A998DD40@MN2PR04MB6736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(199004)(189003)(386003)(1076003)(3846002)(446003)(86362001)(186003)(26005)(11346002)(76176011)(52116002)(36756003)(54906003)(6506007)(102836004)(55236004)(2616005)(478600001)(44832011)(66066001)(110136005)(7416002)(476003)(486006)(8676002)(6436002)(6486002)(6512007)(4326008)(81166006)(81156014)(316002)(66476007)(66556008)(305945005)(68736007)(2906002)(53936002)(25786009)(256004)(5660300002)(14454004)(50226002)(7736002)(71190400001)(99286004)(66446008)(6116002)(64756008)(8936002)(71200400001)(66946007)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6736;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xiI6hfI9lgmQk6fO8KNaXWebnfZ69SBxaA0vBJmrVqG9yNHcnxxBpxhBuNFaYCQiOtuC6WWX+W4Qp3k50dpmNvhyVas9ddlWPAl330KYLbuOC+J1YygSyNirSRYyTyGM92P2ETd+COY9VP65HlKJd5ayjqy4Ueo/FzoxFzNUrqasDSz7sv95nDGc6kHe4sc2U7DYPPaIIttUxVMhuz1WtyKitxiffnS2U5e63tt0Hp25rdoNFr98fVtAEjuENJ6j7LCERgy/XRpjBnkoGCTtb9kdg7moUfEektHSB7icgJbyvN55gDPMAWnMaf4ADL0ABF1Xco6qHtO6rnLwY0HYLM5wP1PQESg/4z7muZzsokwRahESLRpjw5rJac6GqgsYmbZMiDijNPwTSbgWH8apEedULcTZFZi0BwpvCserpmA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9282e7-174b-4ed3-8321-08d71b32d30b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 12:29:00.1764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZqLweSAutyUeXscTYWOgM2c915XaBQ9Ul+g8V6+v65PmKf76XcWl6rokRTMs284uHBY0HXU+Zyq0Y80JPVphog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6736
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We get illegal instruction trap whenever Guest/VM executes WFI
instruction.

This patch handles WFI trap by blocking the trapped VCPU using
kvm_vcpu_block() API. The blocked VCPU will be automatically
resumed whenever a VCPU interrupt is injected from user-space
or from in-kernel IRQCHIP emulation.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/kvm/vcpu_exit.c | 88 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index efc06198c259..fbc04fe335ad 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -12,6 +12,9 @@
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
=20
+#define INSN_MASK_WFI		0xffffff00
+#define INSN_MATCH_WFI		0x10500000
+
 #define INSN_MATCH_LB		0x3
 #define INSN_MASK_LB		0x707f
 #define INSN_MATCH_LH		0x1003
@@ -179,6 +182,87 @@ static ulong get_insn(struct kvm_vcpu *vcpu)
 	return val;
 }
=20
+typedef int (*illegal_insn_func)(struct kvm_vcpu *vcpu,
+				 struct kvm_run *run,
+				 ulong insn);
+
+static int truly_illegal_insn(struct kvm_vcpu *vcpu,
+			      struct kvm_run *run,
+			      ulong insn)
+{
+	/* TODO: Redirect trap to Guest VCPU */
+	return -ENOTSUPP;
+}
+
+static int system_opcode_insn(struct kvm_vcpu *vcpu,
+			      struct kvm_run *run,
+			      ulong insn)
+{
+	if ((insn & INSN_MASK_WFI) =3D=3D INSN_MATCH_WFI) {
+		vcpu->stat.wfi_exit_stat++;
+		if (!kvm_arch_vcpu_runnable(vcpu)) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			kvm_vcpu_block(vcpu);
+			vcpu->arch.srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		}
+		vcpu->arch.guest_context.sepc +=3D INSN_LEN(insn);
+		return 1;
+	}
+
+	return truly_illegal_insn(vcpu, run, insn);
+}
+
+static illegal_insn_func illegal_insn_table[32] =3D {
+	truly_illegal_insn, /* 0 */
+	truly_illegal_insn, /* 1 */
+	truly_illegal_insn, /* 2 */
+	truly_illegal_insn, /* 3 */
+	truly_illegal_insn, /* 4 */
+	truly_illegal_insn, /* 5 */
+	truly_illegal_insn, /* 6 */
+	truly_illegal_insn, /* 7 */
+	truly_illegal_insn, /* 8 */
+	truly_illegal_insn, /* 9 */
+	truly_illegal_insn, /* 10 */
+	truly_illegal_insn, /* 11 */
+	truly_illegal_insn, /* 12 */
+	truly_illegal_insn, /* 13 */
+	truly_illegal_insn, /* 14 */
+	truly_illegal_insn, /* 15 */
+	truly_illegal_insn, /* 16 */
+	truly_illegal_insn, /* 17 */
+	truly_illegal_insn, /* 18 */
+	truly_illegal_insn, /* 19 */
+	truly_illegal_insn, /* 20 */
+	truly_illegal_insn, /* 21 */
+	truly_illegal_insn, /* 22 */
+	truly_illegal_insn, /* 23 */
+	truly_illegal_insn, /* 24 */
+	truly_illegal_insn, /* 25 */
+	truly_illegal_insn, /* 26 */
+	truly_illegal_insn, /* 27 */
+	system_opcode_insn, /* 28 */
+	truly_illegal_insn, /* 29 */
+	truly_illegal_insn, /* 30 */
+	truly_illegal_insn  /* 31 */
+};
+
+static int illegal_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			      unsigned long stval)
+{
+	ulong insn =3D stval;
+
+	if (unlikely((insn & 3) !=3D 3)) {
+		if (insn =3D=3D 0)
+			insn =3D get_insn(vcpu);
+		if ((insn & 3) !=3D 3)
+			return truly_illegal_insn(vcpu, run, insn);
+	}
+
+	return illegal_insn_table[(insn & 0x7c) >> 2](vcpu, run, insn);
+}
+
 static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long fault_addr)
 {
@@ -439,6 +523,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
kvm_run *run,
 	ret =3D -EFAULT;
 	run->exit_reason =3D KVM_EXIT_UNKNOWN;
 	switch (scause) {
+	case EXC_INST_ILLEGAL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret =3D illegal_inst_fault(vcpu, run, stval);
+		break;
 	case EXC_INST_PAGE_FAULT:
 	case EXC_LOAD_PAGE_FAULT:
 	case EXC_STORE_PAGE_FAULT:
--=20
2.17.1


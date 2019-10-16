Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712C2D9687
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393584AbfJPQKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:10:05 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34895 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389830AbfJPQKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:10:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242205; x=1602778205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WI2pUum0Vz98zmcCy0oe8jHgcv1NUOJuTi8N6+P2iho=;
  b=odDKGjwkBqqAeI+OZIUDQLvAIjgEWT+/ET34jT8slhuBQcX1nJBYNG8U
   oXozdaiPgNBowm5vy7fbWEll/Xbo7946IRSfYrETnBpH/eO6rYRmuIx0V
   JI4y5OBzE12rsahAKg3vQh84mwqc/tqGXvpV9nhp2uan5+6wlx8tcsR26
   +5NHpZ+/siRHerX8RwuVI8o40p1UFj7l8WP7o+u17c7Cv7H1qPdvEQ+Gh
   3R/5eRZyWHmZzb6RdB4ZwtrumBo1qwg+sTaq21DKoGzgfLtiIhXU+Ra03
   n/lXFcUfW+JkiNFQj2K30Ox9f8n2kpSddow//B/la+L/BIb+E4F3P9480
   A==;
IronPort-SDR: 4WiGKyS675/4RW1SjgXvQCbUU9PFqrLjhmPrYkjHatRRmzKfgYbqxtji1T1jWeJP7bl3XAN1Kt
 QM1p271j49zwFIjNp+kFeTzxtKtWuTNEECSifT25LoodhG6jH/y/0SZUv6B85jAqTusa/0PvrC
 n1/gstq4f5kqq/bgYcBX9jWxoqgA3JosoB/z5QFDSWf5Ph5dhun7unwcRqWyJrEY4p1GSG1ZMX
 RMl8Kb26um636kMIQdul9AOcjhafohtscyI+jEahoZ5C+wbpZId04fxCJeG0wcGtjrilKRMMrv
 7/c=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="122255551"
Received: from mail-dm3nam05lp2054.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.54])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:10:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj5VGyFrLD1xoYGS0NciyGJlbm4OpV3aPgefIF4E+NI/cGE/b1avy6cQtT0VGsWFpvW1SYF6/eyun5PbtRS0qhQSdP1tzDL0hf1+qALsplubsqCUN6ZE1v3UXgNa9aOpS/hlDgbDFq688l/tmWyQqcOp1rHeP/C0AFlc2slaeOKPJLakXwIENrosXGW68eWaaDHLOHzlrKBBdeRsP3xm6tLCBRlSYg4FUg1I5xHIrKNaismorEAhQVoDg0p8QecLrYLYcTpxBptT3/6NStEXTQ3u6qF3zH1ajLhZu85yPg+0iGK/EA91bq0l89LrgJIpbP+LAA9BkUUGWMKQHHt1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XA/uq2gGBUDV+apHlvAM4WpvBC/lxz/mAAIlFZjhQgQ=;
 b=FL0ogAmN57JHix+RKwuPxNd8GB40A4ShcZKUsJocbsF01l9GeluH2kyY78EngiNW4eYqLacVcH7Cxl6ns9+AdVCoD+r7YBdSFjuKkoRETfQp08GLFfikAXR1GJ4beuh3cjUV1qIp73QpYJdo0sAKntn2c61VAXaCs49VvEjH8GhcwJa/+7b6UTyMKIiuPaIe6Z5N/VQ5SwpH13+/TuN2iHs/U/7nisroeqaWkYflz8xm7DPPPhANCrOcIyfWeyW6BaNbwFGhZcs8cdgqnOuSPZTVzFpAquydBCHC5b8Lj1YU1WZ57/uk2HeicObdrQ8zDqK7BbfbWzVmX98PgcfZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XA/uq2gGBUDV+apHlvAM4WpvBC/lxz/mAAIlFZjhQgQ=;
 b=KqSwvUxOIExxCmEQEc+r3PXwXNU4DOarIST84chKEEE3+hzm6uuhCztKvFqhPIGngdBKmNWm3HKbswE9EAZXkSza8r9PZRakQntlX/vfKchoWs5IXkdsqHo9VpGWuwxQI0GYttnJPCEraQ5fMYdYtuKto8Esnm6ju+r7n6vFZkE=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7038.namprd04.prod.outlook.com (10.186.146.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 16:10:00 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:10:00 +0000
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
Subject: [PATCH v9 09/22] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Topic: [PATCH v9 09/22] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Index: AQHVhDwpAG0zepWVoUeHrzGECUXK0Q==
Date:   Wed, 16 Oct 2019 16:10:00 +0000
Message-ID: <20191016160649.24622-10-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: c362939c-b8a6-4e8f-61df-08d752534bae
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB7038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7038A0FCA8862C7AC10447B38D920@MN2PR04MB7038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(199004)(189003)(102836004)(44832011)(486006)(2616005)(476003)(386003)(25786009)(446003)(52116002)(99286004)(186003)(76176011)(55236004)(66066001)(26005)(6506007)(5660300002)(36756003)(11346002)(64756008)(6436002)(66946007)(66446008)(66476007)(66556008)(86362001)(6486002)(4326008)(6512007)(1076003)(305945005)(14454004)(256004)(7736002)(7416002)(478600001)(6116002)(71190400001)(3846002)(54906003)(110136005)(2906002)(316002)(71200400001)(8936002)(9456002)(50226002)(81156014)(81166006)(8676002)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7038;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Ktc+j15KMEvSQT0yhyPEpQURTtVyPOxa/6sMyrUNhwk9NLz13PdjLHpM+ZponebiD1DRLE0EnvrwtvWWoRJwiQ0jyzDltHuPhIOlToxA8NM4SX61Pj/Q8pREEpy8yl1Qxa8EO5dfW93cHNnjvGUVpkDCLnzdFqePQUqG/cziS7ZF/dT7PoDc8o58OMbTQnYcXCSW1eNKFMkLsXd60jt4+HvlOEJhGQtWrI0j9dgMXioYc/bwt8SR2ud20nYovIEyz1+JGAH2+WW4MgyZeYpDyRh4WzilV1SJMxOAXsNjMbT+J+SkLKMNLVhZondayPVHUquxxsHSKCPDX0ZShRXhT25uKr1j/ckmTvBg+sLCYDB7F80JyQzS8Ab/APdKMYpBX0pfSVH9OQ89p4Yl7dZvN2E30z/jY7yVmE4758JDhA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c362939c-b8a6-4e8f-61df-08d752534bae
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:10:00.5684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3oZyya6NeyfuOfQkyqojoINqQzjKBwB1zrjI+1BEOkQkOgauskpRJVwSvgMDubrp0uLqWGLJBBU8Z/eSQcI30Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7038
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
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/kvm/vcpu_exit.c | 72 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index f1378c0a447f..7507b859246b 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -12,6 +12,13 @@
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
=20
+#define INSN_OPCODE_MASK	0x007c
+#define INSN_OPCODE_SHIFT	2
+#define INSN_OPCODE_SYSTEM	28
+
+#define INSN_MASK_WFI		0xffffff00
+#define INSN_MATCH_WFI		0x10500000
+
 #define INSN_MATCH_LB		0x3
 #define INSN_MASK_LB		0x707f
 #define INSN_MATCH_LH		0x1003
@@ -116,6 +123,67 @@
 				 (s32)(((insn) >> 7) & 0x1f))
 #define MASK_FUNCT3		0x7000
=20
+static int truly_illegal_insn(struct kvm_vcpu *vcpu,
+			      struct kvm_run *run,
+			      ulong insn)
+{
+	/* Redirect trap to Guest VCPU */
+	kvm_riscv_vcpu_trap_redirect(vcpu, EXC_INST_ILLEGAL, insn);
+
+	return 1;
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
+static int illegal_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			      unsigned long insn)
+{
+	unsigned long ut_scause =3D 0;
+	struct kvm_cpu_context *ct;
+
+	if (unlikely(INSN_IS_16BIT(insn))) {
+		if (insn =3D=3D 0) {
+			ct =3D &vcpu->arch.guest_context;
+			insn =3D kvm_riscv_vcpu_unpriv_read(vcpu, true,
+							  ct->sepc,
+							  &ut_scause);
+			if (ut_scause) {
+				if (ut_scause =3D=3D EXC_LOAD_PAGE_FAULT)
+					ut_scause =3D EXC_INST_PAGE_FAULT;
+				kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause,
+							     ct->sepc);
+				return 1;
+			}
+		}
+		if (INSN_IS_16BIT(insn))
+			return truly_illegal_insn(vcpu, run, insn);
+	}
+
+	switch ((insn & INSN_OPCODE_MASK) >> INSN_OPCODE_SHIFT) {
+	case INSN_OPCODE_SYSTEM:
+		return system_opcode_insn(vcpu, run, insn);
+	default:
+		return truly_illegal_insn(vcpu, run, insn);
+	}
+}
+
 static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long fault_addr)
 {
@@ -508,6 +576,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
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


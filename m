Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A131898E27
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbfHVIpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:45:08 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:1982 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfHVIpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:45:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566463507; x=1597999507;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TlW/mor/vRKzCwA77XuJO87QP0cB1+L5a1Pv4XT/R0I=;
  b=eCB/URzpdBp7cuucawaLMYsUbM5MISHdtvI+FKW463kYyG9PWKkEIiyi
   iMxoO3dnNehT67G8WojMsoDeoeHKyuES74aEDiwYR8VdMd+0Dv42wChAg
   QhcIeR1zWUaItoI+ccrVFdqRbhxH7KGb7p77e3gX84rXgN8MLJIuE1hLl
   3/w54w86cot+XQW5ojoGQEEa9+arPRetMLnAmjNepo9Oy0E8pUALJG8I1
   RjrDR0tSE3Y8cl/s2N3j6UVSK8Ymqg8CPX0EXz5YkwVF+Y2EBRqE6PZO0
   OiwdgfUGGw81ZG7yNzLRcwyXJpDGLPvFRp2cpgIKPuiYJT6gudfjggF0k
   Q==;
IronPort-SDR: /LglZgdcX0+RrvNogGLRPxiIHjuoqYPNcYk/zweE6zL3uuOGPByoa2Cx2sVyMQ2v4qc/cuDRaH
 OPGkfBcklfrVyfCTQkVUNtdHXMKrBoVAy3we85KfUdBzdyzmEHkmPGUHXZFIbYkyjBX94gEDTc
 0mgrHZUFO4ZmeofQQibS3Qr6aF7MVLvw9OAlgGNcItQNHmxbzUednGX50rD66DMbCY9jVB5tuV
 sMtw8udkwRIcuplh+uQ6YxQPr7s99U+hv21V6OjEKzIVvWRAccDSeF+gz85CWX0cgicFRocZIF
 uxs=
X-IronPort-AV: E=Sophos;i="5.64,416,1559491200"; 
   d="scan'208";a="117334164"
Received: from mail-co1nam05lp2050.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.50])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 16:45:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZV9pZ9O2219bgL+A5W2caZwMNhr3eo4lb2/AEV37Al6a0u5V0D6AmJ0LapjYl96Bs+NTp7yRfSsMwXaispvE68ZaVoGHBwjDs6I/ZWiBuNHHjpWr1ERnl1s/LzW86U0AhMjCl2S5Dvd1EBirXUYNmwtkZXdugTKfdFpK32ATRxVxROFo24QAAp6VCUFMzcIK8i41YXf6fHEUN5/R4V+0PULbKK5n0gP88nm5dUqRjEAy5sgUjo3smqDwDstZ9K+B9vjBNG53jvX8kUNjn+SoFR01Pti0+2YFn0Ujof7mOEGb6dmFvQYBHKlRfxTSxvoHOcMMQk6pt2qJNFWiHS47QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Vl8KbKE0IwnsC4N3jIm61uyrSNZtjws/wDx3vGCXsc=;
 b=ViHbGmo+X66mcVX5FpuDzjZYDvdc0z3POE+H8Bt6nW7ULJgLd6J8MmIjw9d70FOFpYTVRaBGuVzyeOctcNkXy52/B//vNEHMJwgRkClIrGKdPbsqqnv6tSLahNctJ23SGMtD4hNTOaAOU0cTHySOvMgkQUs9eaFrfPS7HqqfltSZ51B7b5NtvSmqE0PWZOmdTaUnwp08oOblFFibuXlEp4BqAJw0/r3PFgnqho0I1t2LnhQeLZRgPeYNO/29+5m+pCa4nsFwyQgm+Pca4Qw2p5H4JQBZa6XdqhWnVdklTVaNr9jhjxmlJDThZTEc/AoIorQi+DGJxI0JKHdkVxwlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Vl8KbKE0IwnsC4N3jIm61uyrSNZtjws/wDx3vGCXsc=;
 b=itCy4j/3EZYYj8g3cQS3LyxgO3/j1Ngdq0Z9ltBJD2/3gebyLf6yWG5LsLPYN6on/L1aybro+IwEO2pvqsX29qtNTMwkLsSEhHwRT5iq5/+eMkhtxCK26gFJ15V2DWMWPZIR9+0lQsDHa925QY/t/G3uZxOL/Y/fN7FPx8nninY=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6047.namprd04.prod.outlook.com (20.178.247.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 08:45:04 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 08:45:04 +0000
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
Subject: [PATCH v5 11/20] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Topic: [PATCH v5 11/20] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Index: AQHVWMXkzbBcHy/U0kOe1MvLiR52hg==
Date:   Thu, 22 Aug 2019 08:45:04 +0000
Message-ID: <20190822084131.114764-12-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 1c61c30e-6977-4bdf-d5da-08d726dd067c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB6047;
x-ms-traffictypediagnostic: MN2PR04MB6047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB60471613718DE9B18A1BAE998DA50@MN2PR04MB6047.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(199004)(189003)(2616005)(6506007)(11346002)(54906003)(446003)(3846002)(6116002)(36756003)(476003)(26005)(7416002)(44832011)(316002)(66446008)(186003)(66066001)(66556008)(66946007)(66476007)(64756008)(110136005)(486006)(14454004)(71200400001)(6436002)(52116002)(478600001)(76176011)(102836004)(86362001)(1076003)(305945005)(256004)(5660300002)(7736002)(14444005)(386003)(6512007)(8936002)(4326008)(53936002)(81166006)(50226002)(8676002)(81156014)(99286004)(25786009)(6486002)(71190400001)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6047;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uBj3wwI4pdo0YANqfgAp+9hX3CuWtEOpjTJipemwIEy/y8irz72zhHC+ZI8GfTTrDh3a6zbmqMwPdefnHUjcdQcuAyGzrhlIrqozH0oK2QhyQrGTpjrHlwsikT0Ie9JL1OzzNDP3zD0n7MMcgGZDu2msATH6pWGUvG9Ag8w770K/Moiidt3lckSDY/MmyLbx61ZIv7fr5QpF7mUOSXQoNvYqZg6fvyQzuULWalr1E7xEN17zcjELMpiI2QSjcmBhHLYDAYdEgtfR/Lfvl3wY4t+YYVlO4Onv6op84h8s7/AbHwVKKbkdmFuXkIF/LnPseYSowscqkxhQ8q/0XQ3oRyhJXb11OCaMBn0oxgxuH6lO8K2UXNVZBXrm6Ja8+wWOHMYsEXG/w94rN3I9k09Augm2zROREs+vgIw9bCZQo6E=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c61c30e-6977-4bdf-d5da-08d726dd067c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:45:04.2722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XtZ3LJx83pllzOl0bJ3+qepLUo3PJuMj1iVsM/p8jRwUby8ObLcjaE+5bM+i6RKbbTOao1qg5f8SRMKd+ZkMEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6047
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


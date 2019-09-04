Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37F4A8CA0
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbfIDQPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:15:19 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13973 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732694AbfIDQPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:15:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613717; x=1599149717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JItzMpO7xd+qw3TOpKTFHLToAqax6SjALlJ5fSFaKkw=;
  b=ZadpS5kB5iD4Z7+VxbLVd7HjRGenegiNt30Buv4Rk6YHh8ylbJDoNQUw
   SuPAuBUZ2rL09pl7fRcVqBtUO9GK/FkfDXNPqSlN3qTZc8d/Fiv4cBPa9
   EZrv4ExNfkL7CjbrxDEoMMcbAy0V30H1nCqWjY0W1URE+nxQuFPJD67eu
   UwoGahiTMO3s/rUgUxzt4bjTArrMs6DvsIBLo58UWplhDzOtmZaE2P1KU
   xq5NDiJ8RR/Do20uKYP2agjCwPMfrTG2FHW47KZNGwAQSnErEDQnyyTSX
   M/9uG/zdSjTfDRS68wNJY+AfZRSaazbgoGL9PrX3fZRq/dEsge0yQuOLk
   Q==;
IronPort-SDR: ZD/G71jpqwyP1xTfqavjElamG/tNOREn7YTqBaO4wXho3OqIdl1MVhk8U2Wl5O1A1s38hV32dB
 PQyz07XhTMU7z3Mown2DuW2d08+DgKCUK3TmW49NdzC+aKmMkRLkJLbF4ChetVFl0J3+1DG6F/
 Lb57mIlz45eGCxFNtGhpKEAWoLS/HRKmaCxaGQQZiR8PHATm2BWQjWN8/roo3BHmv2mw56ggCm
 qDZJo8FJgYI2Ccpd+M+LRqbmxIPHatyqouGHa0HBjtEOXMWOMKsAOnQXxlQV1mxAodW1jpfi94
 75g=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="224155141"
Received: from mail-sn1nam01lp2059.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.59])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:15:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnpfFFO0BC1kTdkLMUGiIesbUT7O6Hv6TEljibKHsiC0V10SgMOoCV19P3GpqGPmPs13jR/cjARwTiq4cGL6vuxmRxr4ay66E6sLXdvFZL54boRre4LWWadd1DwbgS+kMZXdkcFJ6fRXid9dofmaIDQkED4T371oh0ktHxQSY6dENo+HB95DYiw3oW0IEHwdkABPPuy0ZNCVcQ4SlHRw0nAI/8XztmlXVI1aYfFlbs3csWgwjxGXGJX5zjrwfk0zVSeoBorvRnKpKP91TZGjHiP9MHbErqxrUsLKL1HMcW2Ueh3WmyUGrl9nkuf5i5gReYGWO3nzouCRz6V9L0PmVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBpqvexdqDbefpEdj7QPCQdy9IoXJ/mtchiYn9hYK5E=;
 b=e6s0cgyZhZEojn7EomtMxURE+oaFW2y4wZvDAhMpVUkY3uL0YGTpxs+9u5kjPLhD1WO0Xo96H97YTIi67sujPmwlfxqMJIxtc+CZ+q9dOwbrXsQjJRjTeik8aladFuKfszEOPalT9UCBrHc9+oVwhKmnAL9u61x1YMDQT52E+84O75wsMbf7HwZIS2uydMVk8en5MtxUWNOrID3B0Y5fsPQXNXWsftbDWl80x2icbEmk06EIpJbHR932CVK9roJ5H0DCZqvElscxG1zfz+Is7dJiZ6sOPLRpaNJTBrF15ViMtSFqJFH+TLURbyPS6i5p2FoKhADiSL5RMX6v3N1bIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBpqvexdqDbefpEdj7QPCQdy9IoXJ/mtchiYn9hYK5E=;
 b=Pz+Khplzz/CIIgFghCCEEevo/5AvW7UncZeKnj2JLQmwvNlfoNLoXHNIRuAolxW4/zR1uhk5/fV/My5UH7GpwLPUNaoCCZi+SDPnxGu0gcure7+fvXkh+1vt0QWrQ/6EVExlL6XpHQOsRKzSiv0EsuZgwq1YTzAx2QII7YKDxWM=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:15:15 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:15:15 +0000
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
Subject: [PATCH v7 11/21] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Topic: [PATCH v7 11/21] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Index: AQHVYzvvtg4L27ZAEU2vS583Xb6bVg==
Date:   Wed, 4 Sep 2019 16:15:15 +0000
Message-ID: <20190904161245.111924-13-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 7218e161-b5e1-4cc0-c4c0-08d73153121f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB550426A80BDA6656758FBF548DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(14444005)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(66066001)(44832011)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3NBXZTvI+VmVSEnPb/nc03+tRckljKhihS6SfxdPunbWoprC1R1wtnpGh0RwYKCm24Z9+kgb+LAkDhTZ425+rEuyMqDXIVIiwTnTZkXI7YMmPPlr8LkpRAmYJUY95EN4f9U2+yZbXZEb3qW45CGWlDWqQpWzjUQuHasEeMzAD5NppBFl3xMim5q0EeTYVF2NAxif2SuPeCv/ncPXrEMS2juUL3iXbpDU1GCbN2+9s6XIyB1XXJCLl/4lpqQZ8owNJ6doXPy4GOHbN6QY7tnLtgXZd93mym8T5SgJwiKEGzRYxhDlYMU1uTkaIT07mrDNXh6oODBVUjRmcQVOyY8mbFh5x7djM5yBtekTp3VIN/WyR6bno10mSxPcZ3l2rlh4J2aQFRYYbCCLcZx4JtiKD51AzVvAT5Zx14tgkov9SKo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7218e161-b5e1-4cc0-c4c0-08d73153121f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:15:15.3742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kSSTGl3yV7uPNIIP3zsigDc/u5p5hnirfBd60UVTeQQtpdbu4ZGfY8mNJyl7IBBDDSU+h8XjEQGXwrWoDejq8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
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
index d75a6c35b6c7..39469f67b241 100644
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
@@ -112,6 +119,67 @@
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
+	if (unlikely((insn & 3) !=3D 3)) {
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
+		if ((insn & 3) !=3D 3)
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
@@ -515,6 +583,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
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


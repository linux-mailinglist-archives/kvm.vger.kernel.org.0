Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7506412956B
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfLWLgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:36:42 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12745 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbfLWLgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:36:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577101001; x=1608637001;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yRmUE6SsxiDBk+vNSi2XE65FRcjN9AXxgUMFHtO655s=;
  b=HVORofGja99GiRjBYQnyKAVwMiKPG1jUd3WRaXjEUqBomTzdQ6qTt1cs
   VRqVh4SZq5FFnaC0RgJ8VuFXHVmyYekZdPdXkuwITK4TqesCWpbYtpyzK
   ZtB5IWdI10JguL/vdM2JqQDXOl8sy8EQekOUnn1P3X9dN/QM/DSA9Cuw5
   Cd9s7z7r9uCRF8OL2SZB4QfeRHdtinq4n5ExdhluJfelFHqyS2X20Un51
   Wfy/0kSCrXvINjJJJFuIpVWE9rLZ7wwsXdPtAL/zyFCIDlddUSosHuDr+
   wSFlvG96Rn8Sf3kEhrrhkAKr44KAa+JhhieASY3yCAOZQtTgYRMlKAkIc
   Q==;
IronPort-SDR: A7F9+Pf+O2K6ZE788nNcTnQgzqbhMiv2NVl3t6RQ++lID2qIwxogE5FshP8ZD+BRh7rwHHlHn1
 mffrgIRrFKGzkKlUuk9OUr+OdzyJIt5TX6C6TY1kTAETelPjyBVYCJchIjJfP5Hm/6Wg3wE06F
 qCPhVOZAoe5SAMoaoHklMJnCCcHbKIHfwKKoks5ik/VnVbbKDcYQ7uSz5t4S4iXHyp07oWosu4
 goGCs19tHQq5MJIX5o9hPWj1dvI5GHw+WrMll7vcAR1Q2RlKX7CMxoUXz+w6JRFc7zyczpFQXy
 WQc=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="126720950"
Received: from mail-sn1nam02lp2051.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.51])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:36:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9PuMcQt4yzptPozbK5XxEqaGmcVChs+6dSE1A/JxaDsYHELMqV5Ip2gvBmBJrM8JKrYv4+oByDFViPXAH631ynTTgfdVCiDr6NgOf1UjBt9gTGsga7ZurR7nEX8RDPtKY93oBxpdufrKlTPaGszXxa3WXRukQTZDXOG2VqUMWWrT8OwhprbJdQEg82CZyAg+5VwNP2j5CPXlqivl0p1m3L6vELPOkTU9JAZnLEzg20vnj4horLD8MseW3RSQEfcFwccx9vdQBc3IpQGdA5AIjQ3iqH1azTO53gXaNLY+Kry9SpxyyAss9qS1TbYRGXvvxm8muiUIaTrxaQTeTl92w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKgKKU8wi7UzJ7WopBQ/CFn3UFEm0kJjMvPtI7D6MFU=;
 b=LpwX6cqOI7Z6MAD1g9E5lRsQz+F52OLuYlrDPHs5+Hb3CzNUhl295tXemRD/dTtVhRuoC0RDKZkD8Jg/LgEtPYpqCADI9CSTVZLIPSyLmjDukazqyZtqVutVxtUNbGEZ5YTM2mzbADpdzL4Ra+m4RBWIGcosywWAmW+EvyTrTg+iicwuPRO0v5bh1ixr9C74VpDPT2E2qCFbjG5xKWiUGwuJ9gp6y6HsnCMl0ZcgF1gWquiATNEstOhU4Zh1R0wei2jWE8BS7chOSHyEmtxWCJpzKsxoI1aDKdR+VkagFMA6h8R/PviuQ7suIOkW42ay/zGVUw6FJpRCltRGyGHftw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKgKKU8wi7UzJ7WopBQ/CFn3UFEm0kJjMvPtI7D6MFU=;
 b=E1ZJbMCuyMUNiND3fOos2LDEe+qeNVe3MPtJiSUVcwCThq1kbcnKgkSX+OtvuI2D3aLMpbjCJhv91xG8+nbq4eh8ZiTIe9XzZ79sOekYI6LGZioMQlC9I+2802YWwRP39HVh+MfvH3GNtrs9nGwhlM0/11cbM2x1AMfrnX7pz9I=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6096.namprd04.prod.outlook.com (20.178.248.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 11:36:38 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:36:38 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:36:32 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v10 10/19] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Topic: [PATCH v10 10/19] RISC-V: KVM: Handle WFI exits for VCPU
Thread-Index: AQHVuYU8CynIKtw1g066ADEqxXqI4w==
Date:   Mon, 23 Dec 2019 11:36:38 +0000
Message-ID: <20191223113443.68969-11-anup.patel@wdc.com>
References: <20191223113443.68969-1-anup.patel@wdc.com>
In-Reply-To: <20191223113443.68969-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8b51bc4e-f0c8-4bdf-0f0a-08d7879c5f36
x-ms-traffictypediagnostic: MN2PR04MB6096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB60965033F1778057CEF80B538D2E0@MN2PR04MB6096.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(189003)(199004)(4326008)(55236004)(8676002)(66946007)(66446008)(64756008)(26005)(71200400001)(5660300002)(8886007)(7696005)(52116002)(36756003)(66556008)(66476007)(1076003)(86362001)(7416002)(81166006)(478600001)(316002)(2616005)(8936002)(54906003)(16526019)(55016002)(81156014)(186003)(1006002)(956004)(110136005)(2906002)(44832011)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6096;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pioi8aZpfrk+21x8E+PfkI7twHT5aS6V6PCPnq1qGrPbcqbdFd520mXMeL4B7p7gww9bYaP17vn4kAky0+ab+OnNtraSREKrhd0p2p211lJ0aTrJ9B2ZHHoOlPB1JLHLd+efsGR6xRX/vQbmGpLlcWZ6TJq0aqAXJyT7pJ+zIdphbweXMYSYZXeD0Ta3DCRi3Hx7Ie5hrlTJM8wSAjtUpwVTsyvNMCdUVJr/Ryyidzi+qiMcTQZLHF2o7+stWTvb/qoKdBDEcKLgYaKN1s1qsgsRgbG1vC4YT601sMDM89x0DSvMcbWntlF7UyGBZQQfjCPE7qtBVOHf2sj0j8iLRvGE1NLBh0YZ7zPsYLFCV+tDmXIZ5Y9sE6r1NkM0oCBnlLT6y+mkD+N4JT2wC6c1GrlVN+XtWm00WbtgqRb81eDyC1xup1Qgii5vrBO7aBKPmc7axwvCPb1GyiZsmdOfUKIxWn9N/xEDHX65iCeBWr4hO307L8klCXJWhI3QgRc5
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b51bc4e-f0c8-4bdf-0f0a-08d7879c5f36
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:36:38.1189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JYA0bi417iFU96UvzamQQ2YiGJe1hz0gg5JY2YRcY7Ut+2sRVJqpolGWJjRLsGhEJg+IMXaeVMuZJzW3ZyfIHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6096
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
index cbf973c5f2fb..8d0ae1a23b70 100644
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
 			unsigned long fault_addr, unsigned long htinst)
 {
@@ -537,6 +605,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
kvm_run *run,
 	ret =3D -EFAULT;
 	run->exit_reason =3D KVM_EXIT_UNKNOWN;
 	switch (scause) {
+	case EXC_INST_ILLEGAL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret =3D illegal_inst_fault(vcpu, run, stval);
+		break;
 	case EXC_INST_GUEST_PAGE_FAULT:
 	case EXC_LOAD_GUEST_PAGE_FAULT:
 	case EXC_STORE_GUEST_PAGE_FAULT:
--=20
2.17.1


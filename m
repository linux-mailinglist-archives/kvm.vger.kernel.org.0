Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E962014A403
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgA0Mgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:36:33 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:4551 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730724AbgA0Mgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580128592; x=1611664592;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4eT0dHhxPKuMTq5GyqGW6Piv+ihSVH+vomeDkbAPhH8=;
  b=fE03uvwyz8V40j0+fKD79yjsXTGWKwGA1E5KelohxG7HM6bmpo42IEN/
   h/tadNGIuxtb9NdiUS6TK1tgsSyEhld1ERW/KWAs/VqdrhLvgtf+fE986
   T3GBDkctiMCqX6s013RlyfVgDI2/59zMOhyBG25/e3Xvq++Y0HFJG520g
   rmdKpgFLr55yCPvTnCEjvWqqZBGQvr5aeAtP4RqUzhxNEM1sLMpjPkVaq
   MOQn3Fv7JZ73q5A/9qcR/NpJsZd7R9Ejq8umIO25TUtHdGVngoujeIakp
   R76CVZaPnCnL0F8KyXmY5kK/e7goTxVYojzbqiOamBwNlFE2a5BYV+JqO
   w==;
IronPort-SDR: lI2OxW4yBW8ZN7X7sw4SpNYm5ZenA7eKDZvkGSAL28tP9PXy4IoYGrWt1uIIKWSHGbtDZutE8O
 KlnUJY0m8K1uS+qjAEd++Wtyp+wKmdUZ2RzFUExfO7qcTG8ANQuv6PeG+zHI6A7xitG+CJIhgS
 CsgqVqsuDFJLbzvhMnL4dk9tM3gHH5A56z09LVy+naK33yAfI+hb2uBT3BGJVXzR1AOVi19WbW
 gOCe7Vez0bDWqGDBo6pdSNXWe+9XXfukxUNLoajUvsFEpl+spvEFfOmiBKMnK5wu93AEfO0QNc
 aQg=
X-IronPort-AV: E=Sophos;i="5.70,369,1574092800"; 
   d="scan'208";a="128476126"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 20:36:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4AvJuZeqge0UmLu/RPipwJAg+EArIzuF6sXo5TaEAwcksTtAWPPECPJQJafj8DC89LrmyVlafkZxP9QNtMJOw5hgH15uJtF1zK+GxKqvxmbfmNWyjGIf5SDJWEyZae5th94UgLYTNZZ3we4Ct0JVTNmoleJEypkN0gQfg3QpC9fOgBMr7y+s61j+EI++2LOEaaR3UmyzX4QqH5HOwyBjGhJYsAykpTMJOKjebCwl00nav6z4Tympn/Ev7j7A6ZlXeyF7CJp96aaVniGRfzUEKFkvCYCIKhuJu47M49rtkgs2od0c+yFkrSwrCbzMASKmTzy7oZUlYdLfJHe+QQwKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBOEq2Q4G2npg4/L6ttIsYg4kaX1CIav+sVPMUpkePs=;
 b=GtTY7EY6yxBEkPxzAjYxLinbvFBpBni53freRPa0UPEO1SWI9DRohCR7ooe5u3ftOaFBmAvOIgMgsFgIu/ENKgT+pTJ1uclNZOD+vL/GFLtN5zR5eRxe61EiB9TWBuaVmS9BfdFU2AwxHHAlllUB01oTpuoPEo/MhIKAcJC0cNpJgOwvBTCnWRl+UDqYCWFl6V0275UaXiFHLBqyL/GnpkdgYKOoY8CSXuGqs180nb77TZPiUIG1LJ94hsy329rqyVgfrmBpD/Dju7mCahHtmQRdUBXAR8MK0Byor9kyxIjhrW++4Ag+3afExrTJKeIk5LO7Fv7T5+81oxr8fbSSKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBOEq2Q4G2npg4/L6ttIsYg4kaX1CIav+sVPMUpkePs=;
 b=Snt7dX5UJbiElbGzDsrws95Y31HNFxzTB8eUXWAyrbKPyv/MxAJGz8zvP4J88aFAjJqPrjDcpJPEY5j9Z2g4wGI5/XwJ+T04rML/YiDJ1bOUsVLV8m1Ww0/dpQhgNvVtaBkBZX1bM7MZvj/AFNwo+dslaucMG0TC31q4nM7aT3s=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6816.namprd04.prod.outlook.com (10.186.145.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 12:36:31 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 12:36:31 +0000
Received: from wdc.com (49.207.48.168) by MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 12:36:27 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH v2 7/8] riscv: Handle SBI calls forwarded to user
 space
Thread-Topic: [kvmtool RFC PATCH v2 7/8] riscv: Handle SBI calls forwarded to
 user space
Thread-Index: AQHV1Q5mU4UgmnACokuYQdZfX9d4jw==
Date:   Mon, 27 Jan 2020 12:36:30 +0000
Message-ID: <20200127123527.106825-8-anup.patel@wdc.com>
References: <20200127123527.106825-1-anup.patel@wdc.com>
In-Reply-To: <20200127123527.106825-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.48.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3b182ad1-e88c-46ae-e779-08d7a3258903
x-ms-traffictypediagnostic: MN2PR04MB6816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6816D72107B2192CA80382BA8D0B0@MN2PR04MB6816.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(44832011)(5660300002)(2906002)(55236004)(54906003)(86362001)(7696005)(4326008)(55016002)(478600001)(2616005)(81156014)(956004)(8676002)(52116002)(81166006)(1076003)(8886007)(8936002)(71200400001)(66946007)(26005)(1006002)(6666004)(66476007)(6916009)(66556008)(64756008)(16526019)(316002)(66446008)(36756003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6816;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mqVhjFRwblmYWNOpni5gEyCaWJhsQwtWUCdK+gi+zhZKPzzk+J022qICyfD18xtuhWHCiNH61n7cpHYNWWJZmedEBYzBcxyjo0kNxrYrzB501TI7PSnrN46ZijbUUM+AFKKU4KTrt9ZDrlEA/g5Hh22NtU3Zvf5356aHdC1SuY0u60I3qMmcFHqRNCoKhF8fI8ZHrjoo6Z/JY9sSpYca11Ef3J70p6yPTeHRSXML/jptjqW4goDuvyyBwZkT4VwUUNVAvgQDQkhZHcEnO8nqkQn+MAQEx7Vvw7Pqk+hdhpZeU3du1C3/USq8ooCJyK7PHJoSs5mk+B5ZTJJv7D9DWT77hdl8i6Mv6ZmtiBILsz8DeASL//0gpSJ0RiPpcsROnv5oNFN49XpRku6GN1JyKfIwKRcykbZATL8CCMhAmp8e81o4UYWkpSeqFu09cggW
x-ms-exchange-antispam-messagedata: qlef6mwcP5bUvs3oCO+vO7P+V7+rXQ0m5yK8ZJufRkQvNQnZED5bSEMsviaiB3vetYwZGHuG83C7LT4P0u6E17BQpiLeUCRsv2k15ZdDlTQY8wNex5yIScl1uHHLFGNOtTM/evHB75fZ+TwG8kSdTQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b182ad1-e88c-46ae-e779-08d7a3258903
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 12:36:30.7614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pethZ77vPe+r2yS9jMGnY9dzKb4R/z3987YYRkTm257rVhfjZrO+UQDJwv5kLGBrK28k2VnDFF407tPUIvvXrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6816
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel KVM RISC-V module will forward certain SBI calls
to user space. These forwared SBI calls will usually be the
SBI calls which cannot be emulated in kernel space such as
PUTCHAR and GETCHAR calls.

This patch extends kvm_cpu__handle_exit() to handle SBI calls
forwarded to user space.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 riscv/include/kvm/sbi.h | 48 ++++++++++++++++++++++++++++++++++++++++
 riscv/kvm-cpu.c         | 49 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 riscv/include/kvm/sbi.h

diff --git a/riscv/include/kvm/sbi.h b/riscv/include/kvm/sbi.h
new file mode 100644
index 0000000..f4b4182
--- /dev/null
+++ b/riscv/include/kvm/sbi.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Common SBI related defines and macros to be used by RISC-V kernel,
+ * RISC-V KVM and userspace.
+ *
+ * Copyright (c) 2019 Western Digital Corporation or its affiliates.
+ */
+
+#ifndef __RISCV_SBI_H__
+#define __RISCV_SBI_H__
+
+enum sbi_ext_id {
+	SBI_EXT_0_1_SET_TIMER =3D 0x0,
+	SBI_EXT_0_1_CONSOLE_PUTCHAR =3D 0x1,
+	SBI_EXT_0_1_CONSOLE_GETCHAR =3D 0x2,
+	SBI_EXT_0_1_CLEAR_IPI =3D 0x3,
+	SBI_EXT_0_1_SEND_IPI =3D 0x4,
+	SBI_EXT_0_1_REMOTE_FENCE_I =3D 0x5,
+	SBI_EXT_0_1_REMOTE_SFENCE_VMA =3D 0x6,
+	SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID =3D 0x7,
+	SBI_EXT_0_1_SHUTDOWN =3D 0x8,
+	SBI_EXT_BASE =3D 0x10,
+};
+
+enum sbi_ext_base_fid {
+	SBI_BASE_GET_SPEC_VERSION =3D 0,
+	SBI_BASE_GET_IMP_ID,
+	SBI_BASE_GET_IMP_VERSION,
+	SBI_BASE_PROBE_EXT,
+	SBI_BASE_GET_MVENDORID,
+	SBI_BASE_GET_MARCHID,
+	SBI_BASE_GET_MIMPID,
+};
+
+#define SBI_SPEC_VERSION_DEFAULT	0x1
+#define SBI_SPEC_VERSION_MAJOR_OFFSET	24
+#define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
+#define SBI_SPEC_VERSION_MINOR_MASK	0xffffff
+
+/* SBI return error codes */
+#define SBI_SUCCESS		0
+#define SBI_ERR_FAILURE		-1
+#define SBI_ERR_NOT_SUPPORTED	-2
+#define SBI_ERR_INVALID_PARAM   -3
+#define SBI_ERR_DENIED		-4
+#define SBI_ERR_INVALID_ADDRESS -5
+
+#endif
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index cca192f..ffa2063 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -1,6 +1,7 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
+#include "kvm/sbi.h"
 #include "kvm/term.h"
=20
 #include <asm/ptrace.h>
@@ -106,9 +107,55 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
 	free(vcpu);
 }
=20
+static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
+{
+	char ch;
+	bool ret =3D true;
+	int dfd =3D kvm_cpu__get_debug_fd();
+
+	switch (vcpu->kvm_run->riscv_sbi.extension_id) {
+	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
+		ch =3D vcpu->kvm_run->riscv_sbi.args[0];
+		term_putc(&ch, 1, 0);
+		vcpu->kvm_run->riscv_sbi.ret[0] =3D 0;
+		break;
+	case SBI_EXT_0_1_CONSOLE_GETCHAR:
+		if (term_readable(0))
+			vcpu->kvm_run->riscv_sbi.ret[0] =3D
+					term_getc(vcpu->kvm, 0);
+		else
+			vcpu->kvm_run->riscv_sbi.ret[0] =3D SBI_ERR_FAILURE;
+		break;
+	default:
+		dprintf(dfd, "Unhandled SBI call\n");
+		dprintf(dfd, "extension_id=3D0x%lx function_id=3D0x%lx\n",
+			vcpu->kvm_run->riscv_sbi.extension_id,
+			vcpu->kvm_run->riscv_sbi.function_id);
+		dprintf(dfd, "args[0]=3D0x%lx args[1]=3D0x%lx\n",
+			vcpu->kvm_run->riscv_sbi.args[0],
+			vcpu->kvm_run->riscv_sbi.args[1]);
+		dprintf(dfd, "args[2]=3D0x%lx args[3]=3D0x%lx\n",
+			vcpu->kvm_run->riscv_sbi.args[2],
+			vcpu->kvm_run->riscv_sbi.args[3]);
+		dprintf(dfd, "args[4]=3D0x%lx args[5]=3D0x%lx\n",
+			vcpu->kvm_run->riscv_sbi.args[4],
+			vcpu->kvm_run->riscv_sbi.args[5]);
+		ret =3D false;
+		break;
+	};
+
+	return ret;
+}
+
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	switch (vcpu->kvm_run->exit_reason) {
+	case KVM_EXIT_RISCV_SBI:
+		return kvm_cpu_riscv_sbi(vcpu);
+	default:
+		break;
+	};
+
 	return false;
 }
=20
--=20
2.17.1


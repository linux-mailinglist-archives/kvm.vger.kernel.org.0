Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBBE12A5BB
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 04:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfLYDAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 22:00:54 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:18645 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfLYDAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 22:00:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577242868; x=1608778868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OdGcUXEE0YiIz6C8exm2S5IpKJ/QGf5AedbZs4I9roc=;
  b=rtL5YkJc9fyMwRjaykGILIECdT4QvXi4N2StxhlR/oEPXgvk9GWODLeQ
   oEo6li27D5p6P/x+GTKmeJX18/kiR08VsMV/5GS75FFrbxC8WDUrTbfqv
   NIuDEU+y7pRDLV7hRpr3IKGNxtOR0CUkW/qdw4yfGXseTf2zC4CdrYzPD
   7uT6IzQwL+47J8T5kyjoFSSQXGOPRZHytJy5IFlUi4hJqVVtKXNNOGvbY
   MpC93swnOyikhovlME1ZG/nyIytvvUE0peAg80h6lnrP/qVxJxEMNj2t4
   1WtJeW34YyyoPjtNiq7RUqesdhBOsarlBJ+FSHXUuoE89CKGTqFUh4+Tf
   w==;
IronPort-SDR: jhuJ4etaOL20ZT0nXtwpDdpjEzeGca9qjzlzvwkES/9iAYkvtVhO5SaGR7nTsYzZBiAV91vNjh
 w7blbX6dIBpORk4ryaf3Nba90KkjuVb0c2+N3f9s7mNeFBzaPMqOVjkfoWACmWOqxQskLotn+q
 aIUHsbJ3vKslL3s8KYVXlwLN2NjThrSNHJfggg4inscpIvqebmDOdP0Hd6OjVIBuZLI0fp7x0p
 OnFPzI0PZp+980M2de2Uuvpulhw4/XqOqibt11X/5p8n4oVc6Pn8cf7EqTdPHukmx1AIsu7EGs
 AeA=
X-IronPort-AV: E=Sophos;i="5.69,353,1571673600"; 
   d="scan'208";a="227751837"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 25 Dec 2019 11:01:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DU+7ZQ0ePwmxoAh6o6Sg7F0go3UNCG61kwwdpzCC7hRmbw5bM7r7Pl6OCc9mygxLujBieuz90KwcWm4J5pFSKFqwg/mxHq+h1Z5KtlbcMn1YmNe1PdEEWAqg20j01zi+V6SA+bkndwHEQxhvlhkUsxG+VnLROhnI76gNr9vo7rMauiQ0PijdYDxouPL0NnMYpc7qORmVlqr6LpowE4wgqL2zw7SDH/a5CCSp4wGNGWAgWFwqJvgPEML4NJfcZrjdO482R+Deet8LPLXFvkwMJLgPtpQRA2ZMumcVA+tgVe8Qk1U6JcYXSHBwLXMU3WzVelO3lz2sZ9FZXy1KnLuyDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VugAecuM7ochO3Ap8jisuS/jsrAx9JMRyyNw4SCEms=;
 b=NmZ79km9GtToxFyieGqD1REfsl+8AcJlIhT6yEMoLoLJMMwRp3n4KbH8BGfef745pU9mYgdn+8tyigYD2358+zpw5BYuH+BRoKCtgU7WZzRfB3HWMrN/K4bhRPM7ElSe2u5jT6cSjYUAoJ0ybTcRAUS2n8VFg6I8UYZymf8p+tlJJVXjnLjYpE50dXYR1tRsITSVQvBYrgnCJkVs6mjvyp6naA2mrDWfXrvYJPTllzfLZhGrM6tZr8ch//ta9NbGt0AMxDGFs+3nph1FI8uZLAxtXBgMsqex9ns2xToq9ApfIemMi2biLwtXakUd4z6dRZRn8DDFZgqxFHyyrnb3og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VugAecuM7ochO3Ap8jisuS/jsrAx9JMRyyNw4SCEms=;
 b=XNj+5ICQ6bQ1w+6/ZZQE7K3o3o3Ej9EZULjX4BboPdcmhHPoya3EQcg0+5oyZpJyHg+rrePCVyt7mgCx3EA+WUAVxCl9hCp0M8c9ehm5ZyG9uf6Kf78lul4iuaTiD+Wv4QLghvmT5KdEc8vIUpGLlb0IDIdRWFJA+8fdSebuCoM=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5597.namprd04.prod.outlook.com (20.179.22.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Wed, 25 Dec 2019 03:00:40 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Wed, 25 Dec 2019
 03:00:40 +0000
Received: from wdc.com (106.51.19.73) by MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Wed, 25 Dec 2019 03:00:37 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH 7/8] riscv: Handle SBI calls forwarded to user
 space
Thread-Topic: [kvmtool RFC PATCH 7/8] riscv: Handle SBI calls forwarded to
 user space
Thread-Index: AQHVus99rAgl7tfMdE+2bkPQRMU1PQ==
Date:   Wed, 25 Dec 2019 03:00:39 +0000
Message-ID: <20191225025945.108466-8-anup.patel@wdc.com>
References: <20191225025945.108466-1-anup.patel@wdc.com>
In-Reply-To: <20191225025945.108466-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::26) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.19.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 301c0de1-8a69-4c0c-c9e8-08d788e69f75
x-ms-traffictypediagnostic: MN2PR04MB5597:|MN2PR04MB5597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB559751CA0369D035C44F445E8D280@MN2PR04MB5597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(5660300002)(86362001)(2906002)(4326008)(54906003)(81156014)(81166006)(66946007)(8676002)(1076003)(6916009)(8886007)(71200400001)(44832011)(66556008)(64756008)(1006002)(66446008)(52116002)(66476007)(55236004)(7696005)(16526019)(186003)(316002)(26005)(55016002)(956004)(2616005)(36756003)(478600001)(8936002)(32030200002);DIR:OUT;SFP:1501;SCL:5;SRVR:MN2PR04MB5597;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;CAT:OSPM;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /QtJPtTqfIAbZ1OSwTHK8vjuDNkFBzZoBuMxLgzvMEylI68RuiF5t2fSZGgjBoIwf9LUSntJ/DBiye4mvT+y5yhT08BZcrE7I4d9Ku+T17oca8AI4JAU7dyLY2KQ9M2ca8ohSkfK64L5oYs+AZVruoQdrB0MZ4umwBWtIuBe+u9pqZc1uYWNVjmZavh21+jzZ5sMwXJCmX18pMl7pUwmIWk1d5cZgOoodIMyRyC1NCk9pPKkmdh3z9YgxIj4Vym7tBKOYcUhvDcQFx4Yh3burf2eMzy8lOEm0hCs4rO5rVf63xDRrmHQzd1Od5Y5ppQUgc2jVA8KfEQWCMN7e+Z6qic2THJv0Q6Q01QWbmkphwuv3ZH7rZ8l3ywgC1WDONKLkOJjb9dlmr+pfA/wRmQbrHFRNIVP3CnsqoD8a7epD+mX/41TMetVhLovNABdYTfNqoMr5010DZ1TxNzT+yg2qsIa8ftpni5JGB6DRvXq+nk98IJ0RB8PSkP8N0FkQ41O3vqkda+eKQz2h9FczXI/5PVOoFXPbUkkkM62ApAjcvGDYOPmMETczGFnZ+dKteJdHXhyPuoHaW6O+XttNop5b3SuYt4uY3uAUBAf607KrlBE3X0eQJxSksv8h6z2v3IdGZip0AJR8r9e0QN/XNWmJ5lMPwjr6qFLEswh2elCGjsDHAn/AnewrCKU2ol6unXkK7nLa1XN6qR6aIXbl7QQJdz9aYIKz593K9L+FNEfB7XCwlFxtPgWvKcCUnUCFGfXowBmugvsXqubz76zFG47Ag==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301c0de1-8a69-4c0c-c9e8-08d788e69f75
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2019 03:00:39.9474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LLWAgPn3hDqlfZXErv9N96bH99SYp8UyJFw0Y+dRVBxKMoN7V5dUuBev4k4mH2litAmfWedSqpG88AdWrFGWNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5597
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
index 1565275..4f52b92 100644
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


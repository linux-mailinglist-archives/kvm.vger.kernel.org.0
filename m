Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B97D11BC
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 16:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbfJIOud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 10:50:33 -0400
Received: from mail-eopbgr00135.outbound.protection.outlook.com ([40.107.0.135]:7840
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731083AbfJIOud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 10:50:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WO8tQ3Vh/P6dT9y3HdD/2VZPEuiLkURdWxiKY7DH8x+LexicWSe7s9wnjyb4jLbamDn3tzpyjmgg93Shn3ray6zdDlfhxR4MX+W7Rhlqkhy68neWE9b3Rz6hjGWh4MX/yh9exqagbDSfgGidQge3h8pbHEs9qX19Roc4lld2O+ImHAyySeM+htE+gRBp6t2fT/X4XFoiTuaYZOUwX+pnLDnnLzGNzCaSBEuZq2u+1adPUr+qWj3X1wKFwpZjiI3F14tjivGHF0nLeD7Q22darVsfsGa4dfUgrvG/ZYLgzx1Q6VCWyYQnhu55LuXUwfHVKkj3DlVdQrIZPg03yfAPGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F05fU4vT9u91Mr8UjkmHCWAHFFKynVAqhVBDsEiCgtA=;
 b=RwehupzgJARy7mMa+0ph148bNpPyzKxQQH4x3JfjQPmdtFEszM7XZbF6MtEDPUlGUFv6dLwtQX69TQ1JMv+Zz9GX/0i2n4Btqoo3hnqqytgvLZORDjChqAQv2AZ518xUsF+mrCFqmHURtYIwMkCIMnFOF84VCT0uHFP7LOzkGKilpV1Dqzib+EdtqUIr1frp01zz8y2k+v6+3PedRARmlQqekmUFXgWAmagppZuaotemgzS5Mv9Pvrs6xCXBorBKx/fuNMBV2a+uNrLJekx6+qZvRpzKqJuysUh5fFnHvJkfYqyjPbyeVtqJu481M+101LS/8qsT/NUEVwIuMznrWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F05fU4vT9u91Mr8UjkmHCWAHFFKynVAqhVBDsEiCgtA=;
 b=XBu/XJtTjm49oqy5W+AFXi3m2+vMCgTzJCBYnViSg0HcK8s2NKgPJCjJEy+ZCXqfKdZDJwGM94cBsDI5nUmKWSHpd82iPGNKREiJwZBtt4108mZDF3We1hx0rGt5mJaETxYv2RY68clX26+ncI2JWhVCeYiVFqDgdG9XdxET+Ng=
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com (20.179.36.87) by
 AM0PR08MB5122.eurprd08.prod.outlook.com (10.255.30.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 14:50:30 +0000
Received: from AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3]) by AM0PR08MB5537.eurprd08.prod.outlook.com
 ([fe80::a8ea:5223:db78:dd3%7]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 14:50:29 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Michael Kelley <mikelley@microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Joerg Roedel <jroedel@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3] x86/hyperv: make vapic support x2apic mode
Thread-Topic: [PATCH v3] x86/hyperv: make vapic support x2apic mode
Thread-Index: AQHVfrDkN3MUr0xlFEms4FiPcOct8Q==
Date:   Wed, 9 Oct 2019 14:50:29 +0000
Message-ID: <20191009145022.28442-1-rkagan@virtuozzo.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1PR02CA0087.eurprd02.prod.outlook.com
 (2603:10a6:7:29::16) To AM0PR08MB5537.eurprd08.prod.outlook.com
 (2603:10a6:208:148::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3846aca9-3625-4774-620b-08d74cc80759
x-ms-traffictypediagnostic: AM0PR08MB5122:
x-microsoft-antispam-prvs: <AM0PR08MB51222AC54BEE67B4A2A67793C9950@AM0PR08MB5122.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(39840400004)(136003)(396003)(189003)(199004)(25786009)(8936002)(1511001)(7416002)(186003)(6512007)(50226002)(4326008)(99286004)(1076003)(14444005)(52116002)(102836004)(6486002)(71190400001)(71200400001)(256004)(478600001)(81156014)(81166006)(8676002)(26005)(6436002)(486006)(316002)(305945005)(7736002)(2616005)(6506007)(5660300002)(54906003)(66066001)(386003)(36756003)(3846002)(6116002)(2906002)(110136005)(476003)(66946007)(2201001)(86362001)(64756008)(66446008)(66556008)(14454004)(2501003)(66476007)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR08MB5122;H:AM0PR08MB5537.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ek51EBeXAhmlbw5Ve4YQJYo+DggMzjzbJ/rGU5XhnrBMQDYqg5ig/OaufHoUkdP4XC1oIZhktB6YUdsdzj2R8iup2ZQ0qDYjK9X7eHFfFIs7whBD+zeb7K4FeP6tpihdy/xonG41aQxU4G8hWevaqOgDMmjTt8V5NwI68w238giX+S+7poQ8Q5nu7zygKhD6bfi3gayXdjZQW6N3pA6cPWuCM2Ym/lvnD0CwxdRXn2P3cjqVcRWXB9vqV/DAFAW5AMWDLa6aeoJkXjPuxS1J7KDU/TGyaLu1KYdSc9MIHZT4nISqTFyvuqOWD+dENS+iValu60N+KqIPxZZZMiH6gIys+krQzIl46ORVjwDZ8NbUUo9ccsmcj88OsSqV9bPVx+aaYg9+c9gNht1i2oZV0RnC+CQfj/2P4pHuVDlqlpQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3846aca9-3625-4774-620b-08d74cc80759
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 14:50:29.8851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7hF6pRMPbrbr0ONydIBnLB2poupA+BCaIR9i7iN058Uc5Yjf+XMmuVbqS9YDBZT8lbN1TH4shy7QJmrj8NZaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5122
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that there's Hyper-V IOMMU driver, Linux can switch to x2apic mode
when supported by the vcpus.

However, the apic access functions for Hyper-V enlightened apic assume
xapic mode only.

As a result, Linux fails to bring up secondary cpus when run as a guest
in QEMU/KVM with both hv_apic and x2apic enabled.

According to Michael Kelley, when in x2apic mode, the Hyper-V synthetic
apic MSRs behave exactly the same as the corresponding architectural
x2apic MSRs, so there's no need to override the apic accessors.  The
only exception is hv_apic_eoi_write, which benefits from lazy EOI when
available; however, its implementation works for both xapic and x2apic
modes.

Fixes: 29217a474683 ("iommu/hyper-v: Add Hyper-V stub IOMMU driver")
Fixes: 6b48cb5f8347 ("X86/Hyper-V: Enlighten APIC access")
Cc: stable@vger.kernel.org
Suggested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Roman Kagan <rkagan@virtuozzo.com>
---
v2 -> v3:
- do not introduce x2apic-capable hv_apic accessors; leave original
  x2apic accessors instead

v1 -> v2:
- add ifdefs to handle !CONFIG_X86_X2APIC

 arch/x86/hyperv/hv_apic.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index 5c056b8aebef..26eeff5bd535 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -261,10 +261,19 @@ void __init hv_apic_init(void)
=20
 	if (ms_hyperv.hints & HV_X64_APIC_ACCESS_RECOMMENDED) {
 		pr_info("Hyper-V: Using MSR based APIC access\n");
+		/*
+		 * With x2apic, architectural x2apic MSRs are equivalent to the
+		 * respective synthetic MSRs, so there's no need to override
+		 * the apic accessors.  The only exception is
+		 * hv_apic_eoi_write, because it benefits from lazy EOI when
+		 * available, but it works for both xapic and x2apic modes.
+		 */
 		apic_set_eoi_write(hv_apic_eoi_write);
-		apic->read      =3D hv_apic_read;
-		apic->write     =3D hv_apic_write;
-		apic->icr_write =3D hv_apic_icr_write;
-		apic->icr_read  =3D hv_apic_icr_read;
+		if (!x2apic_enabled()) {
+			apic->read      =3D hv_apic_read;
+			apic->write     =3D hv_apic_write;
+			apic->icr_write =3D hv_apic_icr_write;
+			apic->icr_read  =3D hv_apic_icr_read;
+		}
 	}
 }
--=20
2.21.0


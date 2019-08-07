Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B0084B63
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 14:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387777AbfHGM2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 08:28:18 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37725 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729789AbfHGM2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 08:28:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565180897; x=1596716897;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L+rtiKY4HuYglhnBlULe428dgE6r4vWOTN4fKVrQduw=;
  b=b/BTAUBj8IdpjmW3M+E1QisQVnCpU64n6wM5F4qljsDdLnS4In+H9F1b
   BjGU5xBD0zMEUVE1AgbGaOnfIR4FPuLErXNde4k3oiqpP65nl10V9vE+X
   RErbkt5dQQ7YeUQGdVnWS3NfgMbWmhhiXQfAiProTVvTgn8tsc7ztL1xp
   e41E8+p/RapQ7wrjeb3JqQOMlQrfTcYtlRXsxF92nv3faUCUJD2rU4dPi
   /TMjlNgrMnV3pO5tOi3Twv6H9VZquvk8Qz4PRB4ThWLfVwq2C9xpEZJ0V
   hL7PAQI75vuOxTdDTPdQhw1Ix+8A4JSyXWAk1IbF98s71FiwW0BY3lM5y
   g==;
IronPort-SDR: Hn7bAx24s17GGEHoEl5PnAT9gKOcbGSOFqeHFA4sOPLO9VqQwp4weycJbBqFKFuadd2jKuM1P7
 rO3+D9O+9RGnrg/GsGTXZ8136vT7xUCFexy1gcgUdWjB9DYYXVWBJlASoEydEi07iEHNzjwDIw
 qEoOEuQy/GnsBLXpsBd/3Lsc9O2IYruVaiQ9RS6nCjrCXCE2yi1D/W7DqDJoslib4s62htdh9e
 4S4xwLqFjL3y9rvGgTyFfNSnzhB4XwFzLsrPapAaX5l7DMO8eQ/ZLvtPu53tM/XpeyW4ELf0Lm
 UYA=
X-IronPort-AV: E=Sophos;i="5.64,357,1559491200"; 
   d="scan'208";a="119865517"
Received: from mail-co1nam05lp2056.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.56])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2019 20:28:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FniarmrpG+QBMOBO1SnMqoxrjxKdbSb9s+EUeYjV07YNCn56bJy4+Ey7eY49p5jNQ6K34uW1sls4UgR9g66qlkbEn5AoHp29PyVf4Th8fpsUP8RsbGIXRbn5tvVxX+xuabGZ2pmYxfzbJuKFnxHm8gCmsRjhNyJ54igqjIrT1FhcbREzkrmjm1BxewDu5U+tgYMTUtF8LtcHQC0LBexFeuiTk6G+zkxlvlUV9rn1S37Fhiid1x5sTFHJ0P/+EeQjNAQwuLPKdoe41v6arPy81siYiJoVeNzv+IdSpeOsUGT7syLd8o6fB7SFvXdpYieK4TtRN4tLwpWUdxYbt5KlFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUgM7OHxuVF3f2V8udoOdYm39NTAu1UVK8Cv8strlsA=;
 b=c0j91IkFo8p74eVpynxi4MdHH10HYm98QAwuRfO4HAOrauQbYq+R7ExuHWNR9BpaMeW48zGUjFRyKlWd9lIQ1xAdQhvusKBU2ZPDcw/cYnVmrLne84dHIzvMFIKKiHPe8iY5VH72uidJmzf/7vMbKi3OTMfZFVhP4zUhYYsHRFbxHjjj7qgNXFy8lRzNxv5TDGLFI9g5S5xSslDR5qGl1sjgVpcUFqGDNyyawal3jlMbLzJNrfG0q61Y/8NBHqxcGIzc7Lp4Fxezqcpd8HgTAxlknmCbFEmsb6vxwMWG7mosJW8B/ilGXTkJEdj+CcsRoJQro0xzx4bzSo+n+oTisA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUgM7OHxuVF3f2V8udoOdYm39NTAu1UVK8Cv8strlsA=;
 b=UyoPe8ElV4hwG9BASKB46Iwmxn/apFFTTejHuYpcshVptBFmWb/suuqNxf3qeVPCProRlbt/9MSmD4UPPyKDhNVJSQi2HsLeJoXl+XaEMzeINu9yddtOP0DNj4Hg6R+vt/dhqU1Imy84KfJ3umFUvDoNsZzUncHU/g82nYZvDj0=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6736.namprd04.prod.outlook.com (10.141.117.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 12:28:14 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 12:28:14 +0000
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
Subject: [PATCH v4 03/20] RISC-V: Export few kernel symbols
Thread-Topic: [PATCH v4 03/20] RISC-V: Export few kernel symbols
Thread-Index: AQHVTRuVhQ5MxooL1EGJ8eCWbBnSRg==
Date:   Wed, 7 Aug 2019 12:28:14 +0000
Message-ID: <20190807122726.81544-4-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: da8a3802-cdf7-4361-c228-08d71b32b7e3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6736;
x-ms-traffictypediagnostic: MN2PR04MB6736:
x-microsoft-antispam-prvs: <MN2PR04MB673686B7F888B783272465558DD40@MN2PR04MB6736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(199004)(189003)(386003)(4744005)(1076003)(3846002)(446003)(86362001)(186003)(26005)(11346002)(76176011)(52116002)(36756003)(54906003)(6506007)(102836004)(55236004)(2616005)(478600001)(44832011)(66066001)(110136005)(7416002)(476003)(486006)(8676002)(6436002)(6486002)(6512007)(4326008)(81166006)(81156014)(316002)(66476007)(66556008)(305945005)(68736007)(2906002)(53936002)(25786009)(256004)(5660300002)(14454004)(50226002)(7736002)(71190400001)(99286004)(66446008)(6116002)(64756008)(8936002)(71200400001)(66946007)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6736;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1Ttz0zY17IpF8I7bCQYxYDJMoiVeCCano0jb5gSTQZgCqspKmYfJ+b2ofYTvgFgZ0Y1km5SeZ+iqtfiug3AALw9Nd2egZa8t1og+oK0sv/THN+2QUbaPz7ovd0OEpCFJDZF2KZ+WZ/yUygwvmxlCfOpovWlulDcs0xmmO293D7aq0cQLs1ODIApUjX504m8TYkVUetiUrbNR9HbxGkpq0YULTUyvK6rSHr1BQLbCY2wvx6XdjCAYrUtdY5vXOHIJzKJVKk4RHW7nF1QnQX3LGC5tnznEtcnG8YEWxkzWKaGyAUVpAvNCvLArADVDvDTln1noGv+0AOfHNwRjY5PPtKTiRPZDsE+MYKvy8GGXIhQB/697Ux4YH+WAZCOPhfFP+JECCIj2dY2HGNnt4v6HHYn57mvGgfv5uCRT7p2nlpo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8a3802-cdf7-4361-c228-08d71b32b7e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 12:28:14.8203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y/j1HzPlSjjBfKoT19dj9CNvFxx/o9qbIGTZp/xzlhGzf99hb9OE8v2kUSlhmsuDkSL0AZ8hikFrRxnRyglO/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6736
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

Export few symbols used by kvm module. Without this, kvm cannot
be compiled as a module.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/kernel/smp.c  | 2 +-
 arch/riscv/kernel/time.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index 5a9834503a2f..402979f575de 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -193,4 +193,4 @@ void smp_send_reschedule(int cpu)
 {
 	send_ipi_message(cpumask_of(cpu), IPI_RESCHEDULE);
 }
-
+EXPORT_SYMBOL_GPL(smp_send_reschedule);
diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
index 541a2b885814..9dd1f2e64db1 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -9,6 +9,7 @@
 #include <asm/sbi.h>
=20
 unsigned long riscv_timebase;
+EXPORT_SYMBOL_GPL(riscv_timebase);
=20
 void __init time_init(void)
 {
--=20
2.17.1


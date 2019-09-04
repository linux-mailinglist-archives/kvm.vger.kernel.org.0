Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A6AA8C81
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733133AbfIDQOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:14:12 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2511 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732881AbfIDQOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613651; x=1599149651;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X9hkofyoP2OZily7lf39BRn9zHH+YrLfiRwafePdYaE=;
  b=Yq4T/ZmQywohw7DB9dcscF3Ki+wJF2WEghsfEWvOWCLuGWDpSZpvlJwm
   MAcavy+IMjyvAFcHy8MENL8P+r1FKePxDYGsptSsieQN7og9ZzclkZBeq
   yqulhUkcHb+b8PzfgXzcNG38sDz9rHEEPU0WDeuCztmYMd1tqZYV6tg0R
   xj6axV/WIoois9romD8DxR+6AGRs6HhJgliAW/qExQYt7gD0W1GbFHzQw
   98I/TcPs/FW9dDUbHrYiSUXGzNt4QedQiJVBDqs8eStnDvMWPrV5HSBwY
   0R/oHrAvdE7crjyn1rCQCoaB2WPbiW1VfWq3mxJEqijG5BLvmtQ8WX1To
   w==;
IronPort-SDR: xFrvMRfqCYfpy71xqgeYeihRNQ1mtJRaWLELtN8WB/s5noZQPoF7R+ni+s+ODPSyDb0XDAV1Jo
 U4Skc4l78xpcnSSwA3y4aL6Yp5KboFEOpcoCK7OPCnK9qKaIUkrZTZGS6FoxZmJCq70iybkdIN
 RNkLH6lMkoWKvQ1vSsUyNCV0weNgtFAzRhylfIG7RsMBQ3jsVncqigLuVZqaOjmx2TygqFtBRC
 lM7/Z4JoN1BRuwJnihGR66V1sLU0z7z7ocU5+RPEYBdo+eDX60DVJgCGOzftvp/bxcyJgf2Rix
 EvQ=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="118323808"
Received: from mail-sn1nam01lp2051.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.51])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:14:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkP/n6XSGROBDG7xkuBWFBWMvWeRLdlpkG3CW32c5lSPBDqFY1KcpOs0UaH2GLCDCyR3tCJF3/JQ3jFrwTvCNEoPC2rk9fdwhWDWpPSdA0hfAxPCu9rc5650TwTz64miQGwG3HWPZi+gxOhtaQmLeqqktGY78jyQqyGnZsfXLeG74SgoOrt1pd/tdw7CPthQIGQUm+JuTu8AsyrsHxMu49K8iXUFR+Vy6gS76Y7j5djW/g4NGND/+IO+Y52xu0df3pp/FTzSShssR4n1JGArAvCJRWXKhDHhNkHepS2dw+RnOOOmLMUuZhN4osHUAGYUqFaIOTbFZmaCWP/hvVGZyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmFd30wxWYwm0fcXiaDqdfEaAcsVFZewx7xCBZ1Std4=;
 b=XLVs0SYza/16AYTOHl1JVJalnjroGwCVvTMqEA5Ws7qQCy9BUziWkLq91di5V+JGHlZ2GLc3JLSf37lJdVBIGQQt8lVAlcCwWLGGUuVo6SCEy04369sVWLYL1LIbhSpa+kghPrzlLI1N3P73nDBDt4BMR3zsrhD/Gh7tKxWDPVBFWlUKT2Tzevuxouvc6hxmgl4iE1kHkcvXtrMvG1KSxTwFQRjZZ4PFe8CmpOL4LOHxytr8iCDI01b3wuEsrY4OeYlKYcOmZgnso9WVb2IgYDNvrprnLS22GwWe+iZC5qZIEijsYhGpbrUYKWmRsIKzIW7101X8ntivMC4JTZf7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmFd30wxWYwm0fcXiaDqdfEaAcsVFZewx7xCBZ1Std4=;
 b=sYYuMI+vwNGR1lIgG4iEe91H24Iuut1sxg9h9UUd7xZGM11Un3/0AZ0GXiPzftvADs/Wy8GlgK/zxmfPyWkCxWPiGmyGDfDZrbnYDTH419w+bT+2qcPhjlE++ZlfIqqz0P8WZbF3KXnsgOWm92TLGEYkN45Mik2luOa8IJcD5sQ=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:14:07 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:14:07 +0000
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
Subject: [PATCH v7 03/21] RISC-V: Export few kernel symbols
Thread-Topic: [PATCH v7 03/21] RISC-V: Export few kernel symbols
Thread-Index: AQHVYzvG318mjS9q1kmSmXA7VQ4Ybg==
Date:   Wed, 4 Sep 2019 16:14:06 +0000
Message-ID: <20190904161245.111924-5-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 9a25a020-8064-4f44-0847-08d73152e91b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5504EE3BC55BCEA5EA10B9BD8DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(14444005)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(66066001)(44832011)(4744005)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e4yymypeLM7Qk8hOgzobkGAoRStZv9QJDY/7rGGCg6ZYwfvTItVE06ktMl0iS3znB8GUKsjaD5eDt+8/ep87516ywg0DEMD2auP54iLCXejXVlJDdczyKB0Q+wL6Hn1uHwkGydHUCb2l47FN0dIaopZZK63ukd6aiB+fWOL8BRWp7QI9Wu1ZIjSt0PdDrjdlnqJDudJ0uavwk7NpacPEoJd/3+hpxRwLbpMzu7vgD6qTiWR3cOeRfccBiGWP2fmQUqaIkXTFtf8us2bP1qYwmxYmS0ZF5t6loVWWMnQ0ZNmJmJgeGyMD3lEoFppfE7nHT48Q+nnX1U46Xr4BKWLnCmIwt4+WRQvFlQE4o5/MykUCwMmGSJ2wBNTZ1d2LhqFEoRFW02lbEGIrySUvnk91vMjy3BXhp5b0rWsp+oPl8xE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a25a020-8064-4f44-0847-08d73152e91b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:14:06.8324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3T6TVZF5nshrwhu+r4okoiMz9NGQgZtCsTt6i/XHuxdUYF0J5G2P5puIbejPGEHJ4JHyMYkho85xo+u7UIB+jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

Export few symbols used by kvm module. Without this, kvm cannot
be compiled as a module.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
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


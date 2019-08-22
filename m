Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E1F98E0F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732500AbfHVInE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:43:04 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:23511 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730354AbfHVInD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566463384; x=1597999384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2PbV4ez/4/PKze8YcLBKpmYdo3Uum4/QyUC0zfIwOYE=;
  b=Mqb0lvaKEMSMJhhaGZpSsL+VIOC5+OTLXah1kvUvtxpGcgpd4mfhCVb+
   rG+6sHKt+I6jN1DaMvNJEvSF7+Rn2w7J37T7X5i6km7uZwnvRvw2R97dp
   76mTY7eSR+RHvwh+m5BfhK6aBVDj5db/4ERMkJsO9UhS7wWo25qmQEdq5
   zFASmyf0btZldAs2N5OLGCyGuex3oorkIYHtNv2VZVWqhSf2RF3O8Hu+y
   aRc8TAYHGrDxnZaRztYXmxWIf/rKrN/1rgcrDoA8hd665eCRv3fhl0ENV
   YEx/aqG/tWM7tZtFLn2bEqTx67jw03vevMj76/umYEeyR/zVT+NRb9CTx
   Q==;
IronPort-SDR: lq2khGhLKXvDadhbTBCR5hgPEFnzALxfyfxP3HtUlTx0EPjSM//oOKKjbasDaWR30VQ5tu8Akz
 iwKGj872yC0Iuw8jjxuByP60VKVi8T7K6dGba3szTFvzFmEnUJEOTfqhzVlO1LWtzQFKbSYXWu
 MUGWmI4SizXdcxd/Y3V+nniwnDkkQZ2NmsnM7V3BiBjhn0EORiJrMxSZOOIXmq6Zb+MV2VBd0s
 zyPKJdaEijTJteTFjXN4QRZAaD7XkcY6vFj77PpsdHvTbvmREzhN+kc9Kd6dUKN4SdreZ6pwAU
 /Cs=
X-IronPort-AV: E=Sophos;i="5.64,416,1559491200"; 
   d="scan'208";a="120995682"
Received: from mail-sn1nam01lp2052.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.52])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 16:43:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPO/QfPK4nk6KcrfKukpx8BaT1Zy9LD1W3pKHbj1yNQgFJh6N2z8hszY+n1IsecfSBV6ZopgaiET8z2RjbBRX9aBD/H3pf6cDrnR5ZEQMLKbmvQF4emmmrlfUCgPkuvBLhwAYrsqlYwAn3JnSuz//dNXBZTYdhIIg/CmJWTPXZkfAvA5AL7ghI/2Icx5J8uvuqCOKqshWX+edJzed+AZMIVOvKfOOsviIz8dskHpwD68LGdJegeg9VTcZIDIAwq/1HI/QsFrvdLjSqVou1yB61+ft3OLXmQ0P61Iox9Kr57Qb9YDFqsjP9NJFx0yB9O7l+IDJZIj+aD0WWzsdiHUtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RF8mTs79eQpbZXktbzfxnfZ9XN2Mjqek00S1EnVhmC0=;
 b=Yj6yjNnIz76srC6tbWi0TxewCfrzlQa8WKh9BNjAzpSdOO4+Q8+xN/1gOzXfqOAcIgF/yoO+ypWjVW2cuYFE/XG4vx+F2Mo2mCyHf80T7GSFej64H2Te1pHBUzFFTcRhLf491Ut2kKhhAexPd9DuwyxSUkBS0O6T6zw0AR1TFwDE0LoMbTUdCvte5mbmDJyMMdT/PhwBSC5LOCij7khMKFvVeHPNsmI5GV0Vx0Aimxct1kKfFXJdT/0CibXMtEFlaRiEBs7ItCviCCymgDelly68YJFPEZ/iIokmaWjKwCwXtu9n+4xuCZcQKyY7BjwvZWTnMjXX41pGudItJwGOTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RF8mTs79eQpbZXktbzfxnfZ9XN2Mjqek00S1EnVhmC0=;
 b=r5lK4aVBAmyjslZMR6e0FTDiB7QoRrlvAR7n1+9XR8XwNWR+eAsACVMIB5X+u9GW9JWfdEJ4B+1wSv5OnrS7avfG6cgcp/P9suZo02c4e7+xmD7FiTk1+bQeR/doOtmJqcsKotWwsj5sIEJvv966YSCMWSt6d4jEQXOVon7MsP4=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7070.namprd04.prod.outlook.com (10.186.146.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 08:43:01 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 08:43:01 +0000
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
Subject: [PATCH v5 03/20] RISC-V: Export few kernel symbols
Thread-Topic: [PATCH v5 03/20] RISC-V: Export few kernel symbols
Thread-Index: AQHVWMWbkFiohjbmH0CDRoZpWed0xw==
Date:   Thu, 22 Aug 2019 08:43:01 +0000
Message-ID: <20190822084131.114764-4-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 484ac9c3-f869-4127-1a2e-08d726dcbd1a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB7070;
x-ms-traffictypediagnostic: MN2PR04MB7070:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB70702365AB4C9D05D05D3E7B8DA50@MN2PR04MB7070.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(86362001)(25786009)(110136005)(486006)(316002)(52116002)(446003)(54906003)(76176011)(476003)(11346002)(36756003)(14454004)(8676002)(44832011)(14444005)(6506007)(81166006)(256004)(386003)(2906002)(99286004)(2616005)(66446008)(81156014)(66556008)(64756008)(66476007)(3846002)(6512007)(4326008)(1076003)(305945005)(7736002)(50226002)(66946007)(53936002)(4744005)(186003)(26005)(478600001)(6436002)(102836004)(6486002)(5660300002)(71200400001)(6116002)(8936002)(66066001)(71190400001)(7416002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7070;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fzcorXVsPoU0z72lrevTTeCF/JwguMaasYJxLB2uWUVpNYepvmS7dWHrDtzjS4zZ7TGy7zW8ER+D6G1/qsff0zujBPySC/l5exgbBZXoYNkT4GtBryDLeQXMnQ52va7OdNiVljBqVG5RbXw4HYwXiJght6+PQQrWcy8yATZXkXmVFMeaRonLVvWG8yFk4ZIwC37ibZEiPyIBQA3u0vKg4Oty1MvBWj1L7EinxDxtow2c9Egj+IeMIsXqGgD9/ZzLXb/qHoico87lAbmzelix+fbpqbs2vAcOZ/WD6Hba97jemLd1x1anlEWCtCOy1WqqJ6eVOqwrLyOud3oDW6i0X9VDK8CExp8bMJoSPA1ZDkPKaApkwGwBUjHo/FrY+vkBBr0L+7wtuMsxiQ/DUB0rhOSXDyNvRp39CtgIsrRxOAw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 484ac9c3-f869-4127-1a2e-08d726dcbd1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:43:01.1305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: It18V8pTb9C3+3yLfUKk3XfbpbW8VpPaaueWhpBLmOOiqF0FkTBifgALW/sRcT+5bU6qWi4MTqfkMdFyq3a5hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7070
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


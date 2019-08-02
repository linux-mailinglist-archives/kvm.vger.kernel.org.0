Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C1E7EDCA
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390091AbfHBHrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:47:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64660 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfHBHrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732030; x=1596268030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L+rtiKY4HuYglhnBlULe428dgE6r4vWOTN4fKVrQduw=;
  b=JQC8x4Qvzt5L15rvg3W9PPXpoddqQWnVUAn+abU5K4+Zl5wJZ/TAwf5X
   YSrFWIynMlAIsQFaKO8WjFQgrJJvpppUmUW2rfCUjxZsNDSjqVtadNFOe
   gvPoHpfcLdEvV4MKlzoxZjlTgPF9rR2BCQtN56tVOk/yhzDZT4u5gh4Rv
   qru4sxO/WQOPvnUVrAGyzv3UN6wIfj0JAgrVB83yuSe0nIX0b5vtJxhwU
   Bbec2SoblFWX60EXq7upeq8Y9/GuZVB0Ks46n9xJNk9NDV2Y1PllwjzxM
   vmUF+jRDfOWMcyzmtrx/QC7tygTFcK3aQmQo/RiedhwsLeAlv7KGSzo2P
   w==;
IronPort-SDR: lU8Cs5HSIW+BVcWOGfIS3MyBWT6Rh7jKFBT+Ot4cuGef4VlgzLRLyPA8kiTjZ/lnYWCQgyeNtg
 TnEUVC5TllLWNS70yWLH69qZ7JhuNzoCK+n7aFNfNv44PmvD5XERCB5HzubPr+xbrhlMAlTLwo
 I6whqNiiMSi46eziq3w4v9+4hQGjiYsv27wFeE1pLaB1/KdUgQHwm99pgHeTvUBjFo6L14ehz1
 cfjV1W1jVzWz6tYDSBuaKIRwK7Ff0G4vH0M8VcrMPpZrG2DkGPBaBq0CPZPcxNL4UXbzrAQAjD
 8tA=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="116382449"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:47:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THZhTWF2GbjP+5LiS9cbkn05crSmK0eMrUhSl9tyn6KzriJhHlzkiuOTph7CpRyO7zzKplCDQAh2/8et98BQq6CSoHWjIuJjQ9+ktUjb0vrbxnhbx6FmH6HlvUjcgknNl42hcl5CK6QSwz5eDdd+Ol1+MkpUTDDG53SvabIW4jiXARvYCy+TxM32iKzTObdQ3xFEdmZvsJjFbTtEFJvlcMR85B+KADX9aaQWaQIXeoSF0KCbebkWYEpGYR0zdbvExvQcjPBSWzbhSwMO3hUYU/W25iQ+AXZqXmZSxK7hQ4YQrYij+gG+cNvu1eb97ouQoI8iRHMNSNShmnNV/2twrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUgM7OHxuVF3f2V8udoOdYm39NTAu1UVK8Cv8strlsA=;
 b=lwEcRO/JB0FpCiFqrHIpyyk1qAwgVN/IY8K6yZQZ/sITtd52Jog4vp1lGfIuMEProZ56wxm6Gw+14+Z63YPdtT1q/ctiei7GjBb1s9GrLCG/d/BRyGJFKfzbbbccYOFcFUrJ4TH+ZJ6RrHqoSfDFphRThvMcvWjmZT7PJgnfLanacd31nq4zwjOpoFZaF9jiMb5amW+VXEzJDBxR/wHmBaNyx4g/sHzAnAQK4ilCPC8xHro1QFMzUDcoAwSIADX4iKkhpOwb7K4rdlStJqXnQE5x2x56AgC6fWW0y7u5McuKpmJVBMOOawl+3h5O/VDxdsVbFdqkvjFwCjxdeWLDqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUgM7OHxuVF3f2V8udoOdYm39NTAu1UVK8Cv8strlsA=;
 b=pjvX1MlB4pJr4eModVryo2eunCblMcRPV3q+ZHbB8Mh3s7r7RBHWsED5cNAJ+2lkLohSVGy0NOhOfBKZHU/ZoBawaw7fBhFFssjhJX9G2a0hLCq/wR8ajKwUllV+KyUpdD8cAZg6NBdyXA0VQYWDi/D0bto8w6W+a93NX1YhqzM=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5566.namprd04.prod.outlook.com (20.178.248.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 07:47:08 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:47:08 +0000
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
Subject: [RFC PATCH v2 02/19] RISC-V: Export few kernel symbols
Thread-Topic: [RFC PATCH v2 02/19] RISC-V: Export few kernel symbols
Thread-Index: AQHVSQZ8L5ije/GFW0u/4xCtgdYrqQ==
Date:   Fri, 2 Aug 2019 07:47:07 +0000
Message-ID: <20190802074620.115029-3-anup.patel@wdc.com>
References: <20190802074620.115029-1-anup.patel@wdc.com>
In-Reply-To: <20190802074620.115029-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0111.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::27)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67fea376-37fa-4459-ce97-08d7171d9e59
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB5566;
x-ms-traffictypediagnostic: MN2PR04MB5566:
x-microsoft-antispam-prvs: <MN2PR04MB55667A704C1C395B1B76F0E78DD90@MN2PR04MB5566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(189003)(199004)(36756003)(14454004)(7736002)(54906003)(6116002)(102836004)(110136005)(71190400001)(446003)(4326008)(3846002)(5660300002)(52116002)(66066001)(2906002)(25786009)(6486002)(6506007)(386003)(55236004)(76176011)(316002)(53936002)(6436002)(4744005)(305945005)(9456002)(81156014)(64756008)(66476007)(78486014)(86362001)(66556008)(66946007)(8936002)(11346002)(476003)(68736007)(81166006)(2616005)(478600001)(486006)(26005)(1076003)(99286004)(50226002)(14444005)(256004)(71200400001)(66446008)(186003)(6512007)(44832011)(8676002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5566;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2Sz4edot52h24MvyiQz8iRpDAKx8YcOYXikN0CVbq1o3O2NrASZJxGWk6INMH2Zc9Du83VYhZ6fPYioTGCvJMf/oErN9+3ae0VuQGrl3Yw4KzBnQEXbdkloASA7WSfPoExyc9B9d1YlgM/e76FCzvcslXVGPXXinM/5pb94JJjhgW4F5cXRq/DExYzF6y/b4g6ib7qckPyL9iq4B/LK4ymmbb168FEGmaF2q8A5/spM0gG2uEiVJaHa/VAM1u8T8H7l7/d/gOVQvxzbVgul2xROQr96BrRCpX1HNC+GlokjNj9/2pgvpu1huV5Clx8SSqaIestILGACtA/hjfWiwrFvjRcHt3UVHvYmWNtiIcOYYmnaoNUCFDj/G9Ye8ynaaSmVAuRiPbmmlbkoZkU9YiiQoYgewEXP72dLBuLlBiI4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67fea376-37fa-4459-ce97-08d7171d9e59
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:47:07.8278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5566
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


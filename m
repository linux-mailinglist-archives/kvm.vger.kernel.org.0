Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C23A81D84
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbfHENmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:42:51 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58766 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbfHENmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565012571; x=1596548571;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L+rtiKY4HuYglhnBlULe428dgE6r4vWOTN4fKVrQduw=;
  b=PkZp8cdc0GqR1/pbNNnXDW78uPrXmLR5lmBUECp9vmFW3n1sSxxeU4nK
   UDdzXiqF+vW1LSXiCpRSCwmJdJC0PC49S/WeLYD5L44bGSyoRS6Lm3Edd
   jT9cWcebIjGMUjY6CHCjLNkR0JyBiP96/lV2JrLRCslewL77S6tvU9EL1
   +giQpw/CWQLWqpP40zgTQ2VIbpqxRx0ye/fiUN9bYelsDxG6dsoRT2fM0
   OTJ6CEi1hDESLyNTC+Z9Tk1FFNr95rbb/i/zMqCQdcOQbAgaEIOWEZXFS
   ZKInqUVFOpFwFNOvK3ShFt05GwJehQ2Cb25pGBzdM/2SzWERRKMSh2Mgu
   g==;
IronPort-SDR: MATRmZGCwRiq/H56ydF+Okf+rlDSlExZIxZZnnXT9ynUZ3RLuwTmGW5kAtu+x1SpP3hKPnZcSf
 vxy564vjtWnndPPU9MMJ+xD+D7lQd2r/Hc/xCAni9Cb9WFA5hpCeTdSwMnfLL0C2bDU3Z7bqbZ
 yi/NDqJvHhXYmxisaf4IOY79qmOLOoykxz7/TSnw7B+tp+IF5Cvz7wEzQ7Cd6oRlPssFF7FiPx
 DhkYfKauaLGbh3A7GgCn37mbXfqoFevN1Lfs3HMzJ7aid4Jf4WhLfNCxBskVQJMemixHs3xXHP
 8Ig=
X-IronPort-AV: E=Sophos;i="5.64,350,1559491200"; 
   d="scan'208";a="116613089"
Received: from mail-co1nam03lp2052.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.52])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2019 21:42:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Snz0R2ig6HbeVe7a6EdiePFovP1FrznJ9hdXZLGS/TMbKt+AjFyxqxx0/BHj90B07pn/0jnMVs21/suBkfnmxIK3b4WOJdzhYpz1rckRNXEOfEraZscuN0egHFQfZXNO4ftm23snZXwkAkRCKg+9XJiEt1eqx76sEu6zdqcYjmcwJ3jwaugG+KdXuGjG67MPoFvSA9w5Zcl5tpMxuxSF5OU8sK7F3zJxJebOOtf5YX3ZE1qp89IMPqjF8EDfOFh81pR6NayytSKNmqjbnX8d+cVfpYw1KJuuO3kS0uVOnUjkblDcJaggu7qqPR11aTwi65xTTo4JdItTWuhFRyPNcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUgM7OHxuVF3f2V8udoOdYm39NTAu1UVK8Cv8strlsA=;
 b=h2br6xYzmiWEknVta3a9Aa1TQiIn+CYTAYcwnX5joQwvHgn867BCoqoy6fDUnSrL67GL/92AxJEuXx8b/oN8bOsp3A7gFxW8j8JDN9/vAzvw6pZp+ihMiFUdhtmG5hxzahfaRYIZXoDL8KY67n5AJkFTPDKTGh7xGrBfpgn2JOnWhIphK5xbqJzZ1M/VJUEvPS6VTqM06l4Xwk3SFXxnPMQYJGH2jKnx+nFDvPhNUpovDUZCWKmASKwqlMkBCE9Fz9PctQVuX7tro8CKETsgSZ7bAp+1vlQrLH2UWDZW44FxvGlrjiXOazF5wKs+UKoliiC4cxaW71njKxjD4TRC/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUgM7OHxuVF3f2V8udoOdYm39NTAu1UVK8Cv8strlsA=;
 b=WL5vf79F1rz1NsJGMFfP8xPLjWvgrY1w6xGR9a3FzoBlOi69tKpQnrEWbk3+KyWNZLH15HGmje+MymRVimNUaRuQKr06xtgUYW5LUqzV7EfrmHt0qqLImdKlQRUJixmSh68p+hXajziG6m3Ftpgx8qZCNtkydYiOqLhU0w18ASc=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6446.namprd04.prod.outlook.com (52.132.169.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Mon, 5 Aug 2019 13:42:46 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 13:42:46 +0000
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
Subject: [PATCH v3 02/19] RISC-V: Export few kernel symbols
Thread-Topic: [PATCH v3 02/19] RISC-V: Export few kernel symbols
Thread-Index: AQHVS5OqLP7J6XiNVEmHVO5PjuzNqg==
Date:   Mon, 5 Aug 2019 13:42:46 +0000
Message-ID: <20190805134201.2814-3-anup.patel@wdc.com>
References: <20190805134201.2814-1-anup.patel@wdc.com>
In-Reply-To: <20190805134201.2814-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0087.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::27) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3024799-0b13-4ab1-875d-08d719aacc84
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6446;
x-ms-traffictypediagnostic: MN2PR04MB6446:
x-microsoft-antispam-prvs: <MN2PR04MB6446CEF410FC1C6B92E0B48A8DDA0@MN2PR04MB6446.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(102836004)(55236004)(386003)(25786009)(4326008)(6506007)(76176011)(7416002)(53936002)(2906002)(478600001)(3846002)(6116002)(44832011)(2616005)(446003)(476003)(11346002)(86362001)(486006)(1076003)(6436002)(256004)(110136005)(6512007)(316002)(54906003)(14444005)(6486002)(14454004)(66946007)(66476007)(66556008)(36756003)(305945005)(81166006)(5660300002)(71200400001)(71190400001)(68736007)(64756008)(66446008)(4744005)(81156014)(7736002)(8676002)(8936002)(78486014)(99286004)(66066001)(50226002)(52116002)(186003)(9456002)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6446;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rptBgUC05lbInLGyegOeUf31jc3eKASOESdmMUjIFtgM1aUjzBub6+CmI2kT/gU/XxLaqSlA49KVZ+MUoHfQxq7ML2lLF32mgvFf7DFf2XVn+fNSxj+3D1rciVEnh9bzyw3I1/9Nr+CF4oDR0FpVbrL3pMKe/rIawzLaxAeIoDfoKjwSpfv4hM9gfA2iy9kdEsdDIKX++KElpAc+cMxdz5mGrUsI3JWv7Ob99fyc8xavu2j5J/iMtdnnT+ck6M+fEj8b/0axocl65VXtXphAjxJUIcvw0Nxnsn/4EZhtOnW0zTXTuJZSGSaaX+quStlX85UkvQM4QFI3wLGXQOmfL1RSGwSt8zlbomVYI10gnOjcOxRFzN0aJw8T71FpihBO4kmVzGWuYfvJ5PRmxQFmtLuaZHuYAVq3YtF5w/VDFCQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3024799-0b13-4ab1-875d-08d719aacc84
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 13:42:46.7423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6446
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


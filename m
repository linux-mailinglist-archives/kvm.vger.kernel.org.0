Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559C3A8C73
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732946AbfIDQNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:13:37 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2432 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732618AbfIDQNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613616; x=1599149616;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nZCuWC/hnGtV9NjNtwQ2+V9SQNWW7WUp/eygotDSJhg=;
  b=GNa5o+FlSMy1v1eEecSQZmCe0UKIizOuGJfVsc4JnSDVEFz1cbZD0gFc
   M+S6Va7J22EQlJJaq9xZGAFG/pycYpHtY/mgl+3e2AAnvmizFEYQq159y
   OOZZkLQc8AdU+VYNRZE+ShAvF7KSnTDkp92giXITmnpw/oWyeqnXdI/yF
   ckxVsz9iMHtT99y3HqAvKAZjP6SZ0a+gi/du1byFDR7RWXi1BzO1/q5Z4
   FeUzLwxztcC4rRUtCIScgdryfrZktb9sGa42v+5y1f6mgP4tx5g05QuLa
   nTg9mSozs+loxD4oVKSX5VhEclquwoT+u9RpaIug07QE4rBjSSOFaFk7n
   A==;
IronPort-SDR: Cs6FDtRhPPTCGUxUTxXrskBl2zcP7f6AjnOBmLKwraM4FH1Sdn0UWBf1lqpdkn3N4P8cceynaa
 6m/tqIUIm04GPHYoxvnpOnBiiWAlxHm1JGGrMIvUodjGOZ4PuXPySxL3kTgHSZWX2uEpJvWNSi
 cleonoSgDogIINW5WgyjJlSy7Cyk5nAiPQYBkZzSf2eFDCCJMBNsOMNtN59Ot/5ZoYDY6J4W49
 slDrfCB+7xF8mIj3sI+7O7/scdlqG4a5grp4qy82HVrNA9VbrmY6u0y6ydwbDdTdo5WyCRTrn6
 Zi4=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="118323734"
Received: from mail-sn1nam01lp2055.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.55])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:13:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOtcnTIVNbpx8WacUZw1xJmY98I32fTIvOO5OCnNuid8bI3DoKNhj+7YHJEndIVfdBNskJ3qVHwQAz24Qp3+rvdAwE/2XVcOY1qEPdNEPlBMFC+BQeVRp4n8UrGLwV/AUI/5olFAFPfEYuXQwMM1FYpTORufhraJjZt1ff2kn41mADBlQxE7pdk9dIrorBKu4XVDu2IkFK/4CKOwDlQ+zrjAsvc6hYl06P+4rZhdUTNDnkBsdjo8hv28gUBJCDCP9E/NAKg+g84Uq12pBGKxqnWrCsHRqj9OB/MSPAC4Vn6zOrjuwzW2DZ3v0ARK6V3mPryBVBIWGGmmAKgbzUt61g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOipub1TnFw27ovAl2/T5jjXZd6domDugx5jcUvgwqk=;
 b=S99MBX9kevL/BfDgNiBeXI2e6EmzjrXtI6J+WYPskYDQlQcVC/TF37nQj0ll0VaiIA1RPjXa21h7wEalwL8OZl8lWmlMIZnYrui8RnI1R+UCeKYZ3oluLexITkvSW40khwOV2iDHYJO0Jiy85uvhRHE7/+DgGtYTnmbAJxHwbQcbBEzrXS7YgJld5FbZOoBuql7L9VRgXvIibCmhEe9Ef2vKrK07n7N+/3TotCb0E9qYmAIsh4L65jKci0yS9P6cMHmfkxY00F78x9k0nsnji9G6WiB/2pjxr3EbSzbxKsvNyJ7F5AGYYmhrWWJPjQqhy0BreoY81WyQKuaPl5vxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOipub1TnFw27ovAl2/T5jjXZd6domDugx5jcUvgwqk=;
 b=Gu0FXVrY3hMbQJc539ijhBlAnAiD+70m4a350yP2jKwiqgYWwQc+8FrHGtsNbvWxP0/2Qe1wsq893zsIaeiqT3TVJUEJtORNfu4pHumbgJNhVzPs2GYiqbSDUdGm0hW8IdOxNuE0STfathYfnCMCSnlhiSNdJU0+5CshuCrmaZU=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:13:33 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:13:33 +0000
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
Subject: [PATCH] RISC-V: Enable KVM for RV64 and RV32
Thread-Topic: [PATCH] RISC-V: Enable KVM for RV64 and RV32
Thread-Index: AQHVYzuyyrykUVeDWECqlh8462FGQQ==
Date:   Wed, 4 Sep 2019 16:13:33 +0000
Message-ID: <20190904161245.111924-3-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 16664c58-bd50-4a8f-90f4-08d73152d526
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5504451E93789675C9BB87DC8DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:296;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(66066001)(44832011)(4744005)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BPyCsdtE7qOZ2gSNTCy1oe7EoedqlEezFHqDOVUnCNHJP9Yq6InaDppbcyowPQHNHZBjZNQNRAiOMZyo23P6Rf0Gl4RKSnw4LtpKI7c0Nu/R2CFKYfMZQjf4AgKrsre1o5WUp/ozvRMFRNP9vhiBshuWWLaUr/q0dVbJuMhP+mrFMYo/+ZFVAS/LM341ClvaJTkcMjPxenHzEM4fjmkXS55Qg21uDrA9j6T6TsvqJ6MM50p4xOFJxvHypD7E3eiUGdat+kKMBCUk6DJfeOSLjORbKPVSNd0fA2GE8FQnsEGBL47CQdnsv/aI8s8PwR8U9KwjKGcWvre5xvluHAh6qzBv0sUx0g8h1qDhIR/px0+N5ZOgPjconyGOUMZL3Zq1oiXesMRJmrIHxFt96r1xyvWozStfo7gslYEri8rfI/8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16664c58-bd50-4a8f-90f4-08d73152d526
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:13:33.3905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DDIvp0NxByGwpC7Eb1idEhBgkPPTpSZ56myCh6hBPGwEYV/2sAca1QODcQ1leqKZCvm+ntNX7jQwF+roVv6aZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DO NOT UPSTREAM !!!!!

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/configs/defconfig      | 2 ++
 arch/riscv/configs/rv32_defconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index 420a0dbef386..320a7f1da4fc 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -16,6 +16,8 @@ CONFIG_EXPERT=3Dy
 CONFIG_BPF_SYSCALL=3Dy
 CONFIG_SOC_SIFIVE=3Dy
 CONFIG_SMP=3Dy
+CONFIG_VIRTUALIZATION=3Dy
+CONFIG_KVM=3Dy
 CONFIG_MODULES=3Dy
 CONFIG_MODULE_UNLOAD=3Dy
 CONFIG_NET=3Dy
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_de=
fconfig
index 87ee6e62b64b..6223e47cc5f0 100644
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -16,6 +16,8 @@ CONFIG_EXPERT=3Dy
 CONFIG_BPF_SYSCALL=3Dy
 CONFIG_ARCH_RV32I=3Dy
 CONFIG_SMP=3Dy
+CONFIG_VIRTUALIZATION=3Dy
+CONFIG_KVM=3Dy
 CONFIG_MODULES=3Dy
 CONFIG_MODULE_UNLOAD=3Dy
 CONFIG_NET=3Dy
--=20
2.17.1


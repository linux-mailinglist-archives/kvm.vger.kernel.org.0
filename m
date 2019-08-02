Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245D07EDFF
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfHBHtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:49:01 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64843 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388689AbfHBHs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:48:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732138; x=1596268138;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MjMeRXZr0+LctOWO8rZ4gWpwdZSrA2QMVXqEnJfe08M=;
  b=NLr8yMdX4JIM7z37e/pzVE3s8gvtNIvBOJ3imXfOzLGIyCMfp8Mfl8cT
   KsUsi45C+lC0gdc2iktWs0Zq5G+goJeJAGr7BBcvFd82vWQ4RAlJ0Lox5
   38sBchRwJWKQVWj6eh1WYOAquT8VpLJA5B7f2FLCvIitrhTanhKg575dx
   buVpen0jeB4BktWlMWJT3jL9EkZeMPmNju14lbedvbB2kbi9Am0KkB2Dk
   F3vKanQsGaiqLDWhlUVwfvEb06IZrBAKcXeiUbMHHQFVKmk4VSxVf+JhN
   zVlwEGNGGa0jzLMDYC61HIexCzy6jcMnAre06/WVhgrNcdsET9NGlzaGK
   Q==;
IronPort-SDR: G+WvJLSJ7MUeWhn8fogQHqWdnMQQpdV6SiLfecks7OmQ1HLIiaLLgOYZpcJvjKVGuEAxPYIrUx
 QCM1iz1mfNsCm6JZPeTNeewjBTxv1bEhRB5tR6tIFtCKqq1FH2WUhUi5oYRnjJ2AIZ0LiR8EIM
 430u5PxmHfIAEiF27h1jujvgtOJiRB6MQv/V65s6v6KTuvcUhK27yP8v4ksxYAmZmOBeFu784s
 cejV5QZycgJK5LwAmLw0j0UL6K3Iqyc9iUy5doTptFP50avTEuu/S9XQRkYH/RbBD51oiYXK6G
 ZOU=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="116382592"
Received: from mail-sn1nam02lp2057.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.57])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:48:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K90pM67s0iimmvQEvTLMSWxAaAnf2YxybBwbFFM/nPskQJUolTZmegB8HHXKTRGiVj9BtLmO275MCK4q/2X+jwLjTUr1WHHx+bJjao+MJec0bdI5iFEg3jqqMHGgH6MHIYrzYQ0aVXncGmGEuvOx/fWYjvb/3/i/ydqvsecppzjopthHjLRnjhF1/67MYrcDvvtMhUcZIo3Zrcnuf0OXHGZB8VkWRhvz02CkFSTcmZZ5TSPXlZk+3sXyAJDaRoMYWAZ1vKaKsYqSOTrL7BWcIcIB/1G3hlBu8x/zgvT7FkTGoFxIcbVNge/xnrni09Kk9xloMYVOhH74rsZ6xAISxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agg8zROTtmcyh1hyw7c9c5v1fmphsx1gkFLv5DcpvE8=;
 b=e3GsUzXMefUjsYYN2nfTtYYyEWMlPzmQE5gka+6IFPupMuTJ1rQn3mxos5bAY9NPmDaO5Hrnq6vm39PyOwoRhoVLfqj4w2jCjw+CLL+NFaJl6lkBeLFcXjmXwSYg+LPp4XiQmJckfjACB5+nnSOTWVtUXAT750myscfUbrVvky/1jbj256zhib4uopgxyvGy2ihy7ku8/x1HvBksJvDe+IZyO4xtQkNN6UOGe8Wgr7ikUysFl0IIiCtBzXwZUoe4OGIjs7muzPxN+KSpTURyE9XdFntZecpzw9m0XJtwgQfUIbJeNydIOyxHhPiALbzRbWuHh59Eu51qRIR/RzCXTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agg8zROTtmcyh1hyw7c9c5v1fmphsx1gkFLv5DcpvE8=;
 b=pADWNZ0MXQ9h6UB9sHtbnDJYjxtqqf9cn1ydIMG0D8nXAIcXYj+hMJZxwqcoDVViGxlqL0rJnYiqde2Uof2eU6nH/BtvwsNOlR+JMudoiE0LTNZibPQ0XhFOxnQKSQPvOKdp0encKTvV3fWMAfUennt8gMVR4DN3xwB7yeSE44Y=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6208.namprd04.prod.outlook.com (20.178.248.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 2 Aug 2019 07:48:55 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:48:55 +0000
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
Subject: [RFC PATCH v2 19/19] RISC-V: KVM: Add MAINTAINERS entry
Thread-Topic: [RFC PATCH v2 19/19] RISC-V: KVM: Add MAINTAINERS entry
Thread-Index: AQHVSQa78OtIKfJx1UCaYU5z6yZ/nQ==
Date:   Fri, 2 Aug 2019 07:48:54 +0000
Message-ID: <20190802074620.115029-20-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 3403fe1c-2dd0-4f23-419a-08d7171dde30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6208;
x-ms-traffictypediagnostic: MN2PR04MB6208:
x-microsoft-antispam-prvs: <MN2PR04MB6208EFE954389A68FB88814A8DD90@MN2PR04MB6208.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(199004)(189003)(99286004)(7736002)(305945005)(9456002)(50226002)(2906002)(8936002)(14444005)(256004)(3846002)(14454004)(86362001)(5660300002)(6116002)(478600001)(53936002)(316002)(66446008)(64756008)(66476007)(66946007)(66556008)(6512007)(4744005)(68736007)(81166006)(81156014)(102836004)(55236004)(76176011)(71190400001)(386003)(25786009)(6506007)(54906003)(71200400001)(110136005)(78486014)(476003)(8676002)(446003)(44832011)(66066001)(6436002)(52116002)(2616005)(1076003)(186003)(7416002)(486006)(36756003)(6486002)(4326008)(26005)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6208;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NRWHN22mx2GTw+HQH6wNmhGIqxJ+JmrjgPbZDnTIk9ZeYLJgC2PHYiSHeK5k5yeosHmXYo7bBv9k9FjJO5429yQg9Oh8/egK8XlnyTrDp0Gf8ocBwIMKxeEm3N6seaaJ+v2Wxu28u9IwF2xv8RsOYQ5+VGmamz7ZRfxohcNwvxdDkRMoMAN6ZLyCuWeAQLfgOowAIuqRntuLwXmdl5VYYT/7dSNSDfN8u6JhgHErPa9A4cru5clqQFwJXJxBcDuD1SjmTdYaubskAWQGqWJsAyh+kwtP6pcOMDqxbSotlAc1CfrmKbMspnK9LbJBwOeZK5RhLPAhLDo8Ut0qWayWjswuNwD8yB6nCuW6ME4xM+6WqBIWX0p2UlSP8JTvFHSEFPAMD45cQt+VATBovYxRP9FkIKD2tMSLFkJ1SJmwB1U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3403fe1c-2dd0-4f23-419a-08d7171dde30
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:48:55.0076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6208
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add myself as maintainer for KVM RISC-V as Atish as designated reviewer.

For time being, we use my GitHub repo as KVM RISC-V gitrepo. We will
update this once we have common KVM RISC-V gitrepo under kernel.org.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6426db5198f0..3e0e8d7f2db5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8864,6 +8864,16 @@ F:	arch/powerpc/include/asm/kvm*
 F:	arch/powerpc/kvm/
 F:	arch/powerpc/kernel/kvm*
=20
+KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
+M:	Anup Patel <anup.patel@wdc.com>
+R:	Atish Patra <atish.patra@wdc.com>
+L:	linux-riscv@lists.infradead.org
+T:	git git://github.com/avpatel/linux.git
+S:	Maintained
+F:	arch/riscv/include/uapi/asm/kvm*
+F:	arch/riscv/include/asm/kvm*
+F:	arch/riscv/kvm/
+
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
--=20
2.17.1


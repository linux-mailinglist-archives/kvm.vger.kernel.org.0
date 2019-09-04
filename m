Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0062FA8C70
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbfIDQNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:13:30 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13724 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732363AbfIDQN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613609; x=1599149609;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p9HJqoz3LbanyMT//HPJGrEo8pSsdeciqqPDTK4TfEw=;
  b=Qg3zz+A/8RzyHE1w/IGLIfyodH9ao4LqlEL8FsIZBepZ4CFmsjNA638p
   XBTAkjIGnjxMjNJSuR2DhClUn2DFaumPUi6tmNjZFyHnhXiZ5kZ1bv223
   Mjl25bXiQsJBjjc5oDMPMli4sEPywOzBR077ZQ0/0KY/Y19NWU4/q9hqz
   iNqYbbktmDju3ScXl7edMAZheNZRq0VxpGn6IaaU+JdniGu1yp9aA7p/y
   fF5AALtJ3lB45UyIl2i5SyZrk0HJpkltFIfEUQq0lWK5tDGFWmZ90SWLQ
   2wa+JaQBHAsttvGywuuZhEwhkqgAcQaKeizyBoBkShkkjuXSKFxUmbBrN
   w==;
IronPort-SDR: xczU8f+dPMTTMrADxEbBHgHxAeW5DRynHSRbv5I1dm47JMUtjDp/hMecqpWCeaPgL1+IfvX2Rz
 mhrYifkPqb4QRIJOBtmvHOgwzLUp1//z1k4Mb+pHmCLu1yHQ/Gzbinwy5WRwtGWNMk7Q0tQiwj
 eWHp7f4n8WDqA1u3ZL8rqD5bYI7I8kwytCFUtnRfBMG5vuaRZXXytDC5Qq1Ti3HJYxO7RyCaYU
 q8d2lM+XtScVaAfm9aq3eh/AMHgliQ3G4hmakqvN/vDIkzSMDnh/u0ax+iHwNNEChlmK8qLsJH
 MNA=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="224154898"
Received: from mail-sn1nam01lp2058.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.58])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:13:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjM66/zWVZ+rpeoFg4CtO7QZO2vXj5grMCpezla5/iBbrxkl7MjNp4ryrWTXHusgUnp8kBqg31k5SOTtknqzLqnDiMjys5xLNMIH4e2yRY8wT3tCgtT6x8RrXqnt9fROr7tz83L9Gka2jHg+W7dYMATLm1y+27PxTDx8YSfZ8qHoPp7jLoBzESiAX1GKxolGjAsgNSGhP2XNiv/tgIORcLv0Ua5kETNq+AVfnSHEkENM39A7gdyeXDMbEzS/yYzE2rNSdCOm6r0Zl67R32fXcnwMgoYn8D+kyy6ZHDfCU3HL9z4L3oWerWychCeK8UXufe9gtDCasR32MagWn8ydzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDc/jViVNgdkanOMCtGdfLYq+yZEgQWGotyo/fOBKOo=;
 b=A+4v1+PEtZc2IiMkEmeeVXmKD3pWjXocFIjJ01byMXXodXXT0f8JcCCBGiQ8R0ayq3lhU735sTZ+4gPPBZOL11x5UZZQlThiCYGx+YqPUH/9NGW+az/R9l6a0IJ7XtNP6H03pi9MuUUPYxua/TDA2LZAOp54cOUdrfquG5kipT4kZw5phQZWMFVjXqwbL8dKcrxyY4aeDmmmH3Rx36/uzo/C/R4pZ3afwB+PFcWT3Zl9cfLbTXRpoK54H/gSKUGG1LHoppFpyt63oWbGvZWRY3I6kFPv/Wt6rpg6cqE2/AL02DPFM3dF/XgNNymqMW45ZsmQCHkEGdXV+74wyF3/cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDc/jViVNgdkanOMCtGdfLYq+yZEgQWGotyo/fOBKOo=;
 b=ulfq1SIxuqIQ2xvlXAUrJ3BdBG8N8hcDBS1i9bsjce5pKfCz0apyVTePcrKntVUlif16Ctisfm0vDmDrbHP6mWW9qvbHPORplbhZID3eAOvmHjrgBdnvuqeyB4gZAGbtKpZfw4gTSSmI1oxtZJHyk5iZSmA9uYs0sUlGJWviUXw=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:13:26 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:13:26 +0000
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
Subject: [PATCH v7 01/21] KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG interface
Thread-Topic: [PATCH v7 01/21] KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG
 interface
Thread-Index: AQHVYzuuA0IRhfTXVkSOFWG0+DbnTg==
Date:   Wed, 4 Sep 2019 16:13:26 +0000
Message-ID: <20190904161245.111924-2-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: be88dcc4-7823-43ca-31c1-08d73152d106
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5504DD3D27067250F9A048F18DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:147;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(66066001)(44832011)(4744005)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VarK5dFvjnQF3F9v6UQLzbzMhbATNQNYuM8AuJIz+yguplMYXg/kIaPGEQMD/wO3bH9uWZ9EdDtmXzrW9Vo5FOEqvtd6Ki7N0VUjWeZ9Np3jEBrmWtwbChikaZbYv7aj3c6PMNYgMr24hOEcH7hubxhJvPkFtUxK/+gMXmY34kKs9LGU2fPadRYgiyot3PHgGFsMk5GyxFJHAX/P5ZNUYmpmzwimZCJ10WXqykQkEZdsl9x29mWvIt3apwBlELgt0CcdcXgfYEOm1wkDjhsUsO5kDNM0ZFtLiaeq1542rhJPlwh9k4d3M2b3nYsqeK3SH7jc/pQ7ydiomApzB9sKKKWH4HGNBmtzKG+ZSqjG4PX86a7B3sz9Cicq5Nb3ALBlz+nlHNFS8jXO4Mz0iA3f+q1iBiBwNvBN4lg7KN1DhHM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be88dcc4-7823-43ca-31c1-08d73152d106
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:13:26.4305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iKjbwbmxxhNg5bQEffG5XcM6LWLeX6hlIe6YYYhMVbU12D9+w33ceioSwYki29CvO8vSp7HX67wF8HdKjF5xHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will be using ONE_REG interface accessing VCPU registers from
user-space hence we add KVM_REG_RISCV for RISC-V VCPU registers.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d5359e..fcaea3c2fc7e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1142,6 +1142,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
=20
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
--=20
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95DC78AFA
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 13:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387796AbfG2L4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 07:56:30 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55697 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387758AbfG2L4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 07:56:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564401401; x=1595937401;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hH7etl79ZpfJxHHPqbla+Okggd0CtmJEM47yF9QZBpM=;
  b=nBuC2ajMtl6KEdEF94k1L0cZrmqMfYfcSUS69EQHAxQxO6hkBFM9c1Ui
   v/uRnAfbj4LktD+NpQp/xQHyEFBoORKX9imqu9rPdkBhzxTsGidZ15Kkm
   yQZbXzDnpgLxqzuRSgvpGxBDEFgi32DbHzdlbeVxfk33KmBfNK+fv5llG
   RIu9/C/tLk3FNFBb6lp7Si6DJgBhxq6y+ZHOhXXMpXsWrI3ViK4jemTai
   lyUZPj4MTwmkQgkeBI10Ar6LM+VKHET34lDuvG+AD/xz/203kwaRltBEl
   ZCyiDAco/NqD6fFCOmLYbwSNFsCHqizsLnbwkLpOgcp2x0nPdg+TaA6HI
   A==;
IronPort-SDR: z8cNlTar4RhfX6+1PqB16VGcmC87IoJ4E3SwT6WUuFzA2OdZ9hdjf0zgjIrorKFf4EavBwzK7N
 j5OQMoKgq+TKSoGc606AwI37+djepQViRQt3aokeKolOv9Nqi2JktY1Y4MkEd5/4gVS7BpOUx0
 iRbIUvIdY2WDhKK+DAOHiAFsspniXTZVr7XkBdCkk5tqC+AyGNzEonHl40wtOaCR81+BCvbd9B
 aMQ3JCIPq7YsOcqpaS/Rya9bTS56ovmISg9LRE97T3VBTYrh79yQa3HJ3jOqtT6J0/ZbIq7Raw
 4rQ=
X-IronPort-AV: E=Sophos;i="5.64,322,1559491200"; 
   d="scan'208";a="214553052"
Received: from mail-sn1nam04lp2050.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.50])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2019 19:56:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICkHqUxsjfKX7jZAwDfEcOHdYiiYk45mm2bnVngtKkcVifxlQpz7sg/jP62U5w49HO8tye7KAtnAbRyO17Rfe0Zk+LX+T3sPvwQZ0YcaXirIZ/v100MzlZp3hdQa6VA48t3eH7c3qlaw0F7XBDIxgLclWGTbbNjRnJfE/iFGklxZJ/rk3JnEE4GX6QvngXJ4NKKGnUhLJ9e8HYjLgwfu77k94yE+OnXxQy/Emws+B4nuNx8Xj0YDE/ETddHpofmTSFmiETfkXkyA5cu6q6PUvrfNnPopZNEfuu0TaA/0shFVAO+VgHJfwnamZ0YmS9r1EsQ2/GzXk6Cw0K3CLoApXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIf5ar9KJ4QA9rBh1lTCb1fvDMUQSmqrfiZPoUtfzIY=;
 b=KHaXq5l3SXAlY8G4xvBIuFI+RoTfwVRPf/eQ62GGpb2cOciKuIze9zd/FGJ/72yxAKURzKVnhQPU7P+nETgZ5mXQQNrUZyuHx52fIYGouLQwwpc70OXkwtN2oVAfIFHsRfX8x4poFFfmghN4nEO0UeqziQz5BOkNqHrnvD3qLvTIB9uB0vHHC6Ujc1wkLpGzrat584d01S8IM7WYPKXARr3sI6Mbm+bToUGchYMc36C4c/rMRxgbwSs9JiDLpd6lj4yBzD7UF4HpSKLE4hwjSD84YNM9UKB6kwIWj4KmBhHIRnKxC8qjqeqfgrYPs8767+Q5FrbDbrVTmfbwOzCy2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIf5ar9KJ4QA9rBh1lTCb1fvDMUQSmqrfiZPoUtfzIY=;
 b=MTmWFyFhMBN8VjL6bMWPOsyMOtIS4qmJ1s6bZnBYvkQwfZsEnB5rRPFRsS/RFY+pTZAe53OB+1RZTL5XOrhe3G2OkS1tErW8mNWv0MhBvm+WRfiCWMAPJ8pxIQBFYo6DLplwdycuPIxlaABqd8GjyZfdF7oJJs7HmE7hJ483xuU=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5952.namprd04.prod.outlook.com (20.179.21.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 11:56:28 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 11:56:28 +0000
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
Subject: [RFC PATCH 01/16] KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG
 interface
Thread-Topic: [RFC PATCH 01/16] KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG
 interface
Thread-Index: AQHVRgSnaPlunpy9GkSc6WLWyGHt/Q==
Date:   Mon, 29 Jul 2019 11:56:27 +0000
Message-ID: <20190729115544.17895-2-anup.patel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
In-Reply-To: <20190729115544.17895-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0116.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::32)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.23.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45ece69e-3a8e-4874-76e6-08d7141bc996
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5952;
x-ms-traffictypediagnostic: MN2PR04MB5952:
x-microsoft-antispam-prvs: <MN2PR04MB5952142573A63857451E36738DDD0@MN2PR04MB5952.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:147;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(189003)(199004)(478600001)(2906002)(446003)(6436002)(486006)(6512007)(53936002)(36756003)(11346002)(2616005)(44832011)(78486014)(386003)(6506007)(102836004)(55236004)(4326008)(71200400001)(476003)(76176011)(71190400001)(9456002)(7736002)(26005)(50226002)(81166006)(81156014)(8676002)(8936002)(186003)(99286004)(6486002)(68736007)(1076003)(256004)(7416002)(305945005)(66446008)(25786009)(66066001)(6116002)(3846002)(52116002)(14454004)(4744005)(316002)(54906003)(86362001)(66556008)(66476007)(110136005)(66946007)(5660300002)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5952;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dIKZmULRFFohR2fkbqZaEq/HkdZ6FBdwFfi0XgOAL/hyzk3+Fx3/q4zsCByLRYnIIeTFDoNOuCvhMsqdc7OKawY2WQgSly49t8idN7SFSgHC+286h6rKBlkOSXqYP1tqgCOjLGsTHkiP1uyHdK+85OLZHfBuhVeZKAXgft1SGOBcdumVGAjJQ7RZ++KwlG+CGHTtE34Ru4wMK0hNbeyosl5HPulzAKepEKl3udSjL/0i7kpqADIIoPOopd496cAKGvWS/tQjfdyKi0kNq7yH7s5IOmnrlpkochEX8YTql9hKYw8ZupmLznCAfu9lWyWXWISXaeSlp2FHLGrE65+oITuN3JO/cBQqqAvjhuSKMK/aMjFhEK8j+EcqdJ8td8izftsJIQhj8O2ixcu6haYDAJWCERLdmXPtRdQCpvzwSiM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ece69e-3a8e-4874-76e6-08d7141bc996
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 11:56:27.9135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5952
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will be using ONE_REG interface accessing VCPU registers from
user-space hence we add KVM_REG_RISCV for RISC-V VCPU registers.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a7c19540ce21..1b918ed94399 100644
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


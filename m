Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32789ECB8E
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 23:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfKAWmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 18:42:05 -0400
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:60224
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728265AbfKAWlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 18:41:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZd+F+z2sA5R0NuDZUaXDDIE8ZGdCb1O8rtcsPCLvkg0LDIBHY9h8mlp8y1omhcr1tP4vJRJBgaXgxdMMMrkK7gXpz7FDgTlOOfzEmnGTQyN0fihjIDNW3zZRqlAEiU66faQTec7EUznWNe/gGKDPuC5m0RpS97Npe5UZuP1OcwZF4YU+24SX7Nlrypd9YgwnE33Vq57MvIXUmcTNO6L7JLrxuUShXiU/FMOkHSIxxTEFNL9GqBl3o/Q7NzXvcQ0kws/konqq9pldH7hJVAYusKSbMeFVmwOs1SxIpABReMiLvAJsgpbgUI29DYJU+CUh9A66hAQVZrcvbT8mt5Syw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4b9a2qTCriV/klRI55BkX7UMRg2izSVoH+kmnmWlbQ=;
 b=naTCoBWikfS0V1rAfmebv3lIpHT6eEdXuioDOdvoGIdRPrS+Ce4w5Cp0o7z8K3FoxrJRo5XadWYbBTeUNiaavifdhlAQnAq90eqMzTGUNy4PlU2ixV5PjEt690emqzHl47G02EOoeFrmHqPV/KoEdDZp37s3AEwDEH1qvRApPbShlaRMphBIZGapP+pLzeoCaeaIYMCtOuC0UsnIIEoZ8vD6jQrEJ3Kx+uJfCVIof8j1ytta7PZg91WDUO11jUGmhc0E37jaCgRyzGOu9TvKVHt6mNi5QcSfQ9oc2QwrIoXS/VVyMf2/k7MkQ4lJ2z4NpD7ArGfYqow7Wpa4OZip2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4b9a2qTCriV/klRI55BkX7UMRg2izSVoH+kmnmWlbQ=;
 b=OcpZpOtFDmmHITIKaAmrU9LIDxnMd/aCSv/tm/3t5TwCcoZREY87RW+4bAhnUNqN73UbYdS1GF3EZHfKwnsBOQYP19RWqm+ALd9tWDJKutefTbopkcFkw0iM8A8cyQc3GxEnhASWH+cWpSTHnp6lpth+m1QloUpmqGYh2Yysi00=
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3243.namprd12.prod.outlook.com (20.179.105.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 22:41:43 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 22:41:43 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v4 17/17] svm: Allow AVIC with in-kernel irqchip mode
Thread-Topic: [PATCH v4 17/17] svm: Allow AVIC with in-kernel irqchip mode
Thread-Index: AQHVkQWIsd7qYee55Eaxu2bUidBQYA==
Date:   Fri, 1 Nov 2019 22:41:42 +0000
Message-ID: <1572648072-84536-18-git-send-email-suravee.suthikulpanit@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN1PR12CA0047.namprd12.prod.outlook.com
 (2603:10b6:802:20::18) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cde0f1aa-c3fa-4549-0686-08d75f1caad6
x-ms-traffictypediagnostic: DM6PR12MB3243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3243CE81E11E028A485A8F31F3620@DM6PR12MB3243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(66476007)(66446008)(26005)(6506007)(386003)(86362001)(5660300002)(102836004)(4720700003)(305945005)(7736002)(7416002)(76176011)(256004)(14444005)(8936002)(8676002)(186003)(52116002)(6486002)(478600001)(50226002)(71200400001)(71190400001)(81166006)(6436002)(476003)(2906002)(3846002)(6116002)(6512007)(66574012)(99286004)(4326008)(2616005)(316002)(11346002)(446003)(4744005)(486006)(81156014)(14454004)(66946007)(36756003)(110136005)(54906003)(66066001)(64756008)(66556008)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3243;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W+21RR/OH7Yk+a0x0ubOi1Pjz0UpjsfFv3f2U6xrvVqV8DJctwC5gM6TUUMrbT3RydE9Jx6hRGa/XGmx0+89e37jARauqbanC/C6UjFstwnbyXXonXo8s1LeeIEu37OHyjFqVyElbWNQrvCfQ0QozOaTXY/MnvuByTly7OTl3amUHmhd2L5xQn7St/e61UIk+MyT7n6gccGVszQ4zqDK1SEns58Yv6lmaTORJyUQ3Okx2oyn+B6BnGh2vNy/fCYeQFAQ/ofoAAa+ogI7Hvq8uqy5aVzP3UOB6kVuj9PISB17uMSFVppwxEl5CgN/CJW9eWxJwCznUM0aIKltupA19zZ6v2tn2ob/qh3onhEU6CM08sPJTlu7LhTXW2tK5W6tee1Cuvu14POBAjCjqY5n0wGUOQDzxFJr1FjEMmGczfZZ/9mx39G+hbDQG8sPUhf/
Content-Type: text/plain; charset="utf-8"
Content-ID: <4029B512A008CC4B8C99548BDEC6E30C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde0f1aa-c3fa-4549-0686-08d75f1caad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 22:41:42.9888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jGVXDspxK6+090Liexqq3fypWfj5Ge2mrqTvEFXfS/jGkcmSY51xGuKkZJRokbIFqTQLn5lDXV3uZnz7WTq//g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T25jZSBydW4tdGltZSBBVklDIGFjdGl2YXRlL2RlYWN0aXZhdGUgaXMgc3VwcG9ydGVkLCBhbmQg
RU9JIHdvcmthcm91bmQNCmZvciBBVklDIGlzIGltcGxlbWVudGVkLCB3ZSBjYW4gcmVtb3ZlIHRo
ZSBrZXJuZWwgaXJxY2hpcCBzcGxpdCBtb2RlDQpyZXF1aXJlbWVudCBmb3IgQVZJQy4NCg0KSGVu
Y2UsIHJlbW92ZSB0aGUgY2hlY2sgZm9yIGlycWNoaXAgc3BsaXQgbW9kZSB3aGVuIGVuYWJsaW5n
IEFWSUMuDQoNCkNjOiBSYWRpbSBLcsSNbcOhxZkgPHJrcmNtYXJAcmVkaGF0LmNvbT4NCkNjOiBQ
YW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KU2lnbmVkLW9mZi1ieTogU3VyYXZl
ZSBTdXRoaWt1bHBhbml0IDxzdXJhdmVlLnN1dGhpa3VscGFuaXRAYW1kLmNvbT4NCi0tLQ0KIGFy
Y2gveDg2L2t2bS9zdm0uYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0uYyBiL2FyY2gv
eDg2L2t2bS9zdm0uYw0KaW5kZXggOTgxMmZlYi4uYmU5YzFkMyAxMDA2NDQNCi0tLSBhL2FyY2gv
eDg2L2t2bS9zdm0uYw0KKysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQpAQCAtNTE3Miw3ICs1MTcy
LDcgQEAgc3RhdGljIHZvaWQgc3ZtX3NldF92aXJ0dWFsX2FwaWNfbW9kZShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQogDQogc3RhdGljIGJvb2wgc3ZtX2dldF9lbmFibGVfYXBpY3Yoc3RydWN0IGt2
bSAqa3ZtKQ0KIHsNCi0JcmV0dXJuIGF2aWMgJiYgaXJxY2hpcF9zcGxpdChrdm0pOw0KKwlyZXR1
cm4gYXZpYzsNCiB9DQogDQogc3RhdGljIHZvaWQgc3ZtX2h3YXBpY19pcnJfdXBkYXRlKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgaW50IG1heF9pcnIpDQotLSANCjEuOC4zLjENCg0K

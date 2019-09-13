Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0DFB2595
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbfIMTBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 15:01:19 -0400
Received: from mail-eopbgr710060.outbound.protection.outlook.com ([40.107.71.60]:62364
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389163AbfIMTBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 15:01:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEUdDPsewtL9YI47FhOYWf9m2RKSP6oqYsKVCCzrd69LVmqimwFK41KCS7ZDx6D2d7VIfxKDs+Z5xv1E458jrbXUY1LH3k7RDE/TFMsksiYeZx0FnEL8jx2LiDwOMupIhAaLaO4Z746LPS16R54t49ZR/EUDuwOkYle6OEoIMdOliKuKoaDylkvAEH8wQvTtUFu0OcfU93eBuyJZbJElTWk8zE3Emtm2IneUrk1eq/MwYo9CUT5RgJaF4xE2SnrFwFAH4ZWOJPOCjjf8OHXCSjACo045OdTvjB91qO28JJ8ltHHj/XH+uVXY+JHu4x7VPauNvw4BL1ROofZL8udYlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJPIwFhdWsP3d/i29F4g9Mxq2BKGJCh2LO/dIM8UVT0=;
 b=mWFbZ4l5oK+3YvOdrJ8MkH3cjfbnHcfwiVbfBUgGNnXxGN7CgpGMZSOGonz3iGOtU85BlKLSouMvRXZua3FPxqxXNf8tX7frzA8g5Le5eMzabh5JDMz4LCuV2jYfV7e8GrpEX0YfYuYZua0yGRk2x8vPjLxvrz7Zt1tyCfluXqzc4Ub8mwSDZYBupsmzp92ntTdtsHCRhX8bG0EKBbdjW8Ebupp9j1+GUsQ65IlfhyK1i/JFnD7WaE8/XsINqE5o1tbztn0lf1F2CEcxcSvJT/WNAtAw+1Au8CeN+Yhn5MzfPQRmRhLyL8MDH+RKedtUiShMiF8f1cU4ketf8Wgypg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJPIwFhdWsP3d/i29F4g9Mxq2BKGJCh2LO/dIM8UVT0=;
 b=bjTlNzUMGcdzxHKema6J0VV54NctgJx/UCET27/Ko2cUBlbq1TiF0cP7ZnTQF37yJkQt4xNVMRotHWDM53KinNyOCBdxj/z2yIBXsfx9GvPE76MQzrRR1RZhMBVNjvZoHkrRt982IodNlfXrbbgJf9sPJXVxt6eNC2b0Js7btQE=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3596.namprd12.prod.outlook.com (20.178.199.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Fri, 13 Sep 2019 19:01:11 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::201f:ac0f:4576:e997%3]) with mapi id 15.20.2241.022; Fri, 13 Sep 2019
 19:01:11 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v3 16/16] svm: Allow AVIC with in-kernel irqchip mode
Thread-Topic: [PATCH v3 16/16] svm: Allow AVIC with in-kernel irqchip mode
Thread-Index: AQHVamWbPsANoSEXBkO4BBRG/d09aQ==
Date:   Fri, 13 Sep 2019 19:01:11 +0000
Message-ID: <1568401242-260374-17-git-send-email-suravee.suthikulpanit@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN6PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:805:66::34) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a68276d7-4167-4078-c277-08d7387cbe45
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3596;
x-ms-traffictypediagnostic: DM6PR12MB3596:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB35963FEB098826A9BC4CD62DF3B30@DM6PR12MB3596.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(189003)(199004)(66066001)(7416002)(3846002)(6116002)(81156014)(186003)(8676002)(81166006)(54906003)(6436002)(52116002)(110136005)(316002)(4744005)(76176011)(53936002)(5660300002)(71200400001)(71190400001)(6506007)(386003)(102836004)(6512007)(486006)(26005)(66946007)(66574012)(8936002)(66476007)(66556008)(64756008)(66446008)(4720700003)(2906002)(99286004)(50226002)(6486002)(446003)(256004)(14444005)(25786009)(305945005)(478600001)(11346002)(36756003)(476003)(7736002)(14454004)(4326008)(2616005)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3596;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bvg4JvStfWszZEDVEY2XxQNku6xswA22F3bW+Y/C7ccKAICDSA3r9kJvGhPp0B1xd5JZ+9Emo3hK1lX9S5VKkqrzV1E2cA3KoXJy8SYwzEYzHIDNQKKSGmP0FGbLyRjaxtuFKbl+3BGnGd6nc3jqArcU0UdrSquDO2jZ/2wrBVaElJjda/18gK9av2d77vmlEVn5iTftHSrIO27f/6rb5p3U6Sg61roDAOCDTACNEJY7wU/g9i5E0782r9En7/1Qtufp6twDRu+ZA7QFYdzDMEpCNuWjuYNCNGqUne/hHV2HmidprcGqO2bWYiOlGbJuDAPH/zV1BQ9qvYuJgPPo0W7tZGae5MXfEzvv2xK1G7lbRW8J7St+PeaRe/x2qlry6yoBeR9OhMmFmyNfwiPPAkD8MVaAWmMwE+O61p/3lco=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC110F5A11FF8D49A0018830CC974F21@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a68276d7-4167-4078-c277-08d7387cbe45
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:01:11.7696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bO7gNvsJuA9Z5QL2gpClDA4KdcxFTCJq57+ExBua3A7n9j+Tlc0Lagp9au0Tk/Imk4VVv5cIyr8m7t/KmSaCiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3596
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
eDg2L2t2bS9zdm0uYw0KaW5kZXggNDU3ZmZlMS4uNGM2NDljMCAxMDA2NDQNCi0tLSBhL2FyY2gv
eDg2L2t2bS9zdm0uYw0KKysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQpAQCAtNTIwMyw3ICs1MjAz
LDcgQEAgc3RhdGljIHZvaWQgc3ZtX3NldF92aXJ0dWFsX2FwaWNfbW9kZShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQogDQogc3RhdGljIGJvb2wgc3ZtX2dldF9lbmFibGVfYXBpY3Yoc3RydWN0IGt2
bSAqa3ZtKQ0KIHsNCi0JcmV0dXJuIGF2aWMgJiYgaXJxY2hpcF9zcGxpdChrdm0pOw0KKwlyZXR1
cm4gYXZpYzsNCiB9DQogDQogc3RhdGljIHZvaWQgc3ZtX2h3YXBpY19pcnJfdXBkYXRlKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwgaW50IG1heF9pcnIpDQotLSANCjEuOC4zLjENCg0K

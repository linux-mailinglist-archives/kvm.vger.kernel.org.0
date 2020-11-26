Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393072C4F32
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 08:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388353AbgKZHNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 02:13:32 -0500
Received: from mail-eopbgr1300070.outbound.protection.outlook.com ([40.107.130.70]:44583
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388333AbgKZHNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 02:13:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtZ8yXx7cESq2gUAI/Ikjuof0EyfQM9mC2l5CjONk+Gq3jsWi0VddZh5nQer3RwaH5AicGLyi34zWpLx+zPQmq9p5Gh528EP5Y7vrImjaTXrQFRWqiz8xpwXNw6gvYoy42OlmS37wx6pf8QK7T/4d0E4gNV0yZO7c4JQzz5bQuAtK+VpwXSsDTk6kMCrhfuynwPY7eMcORMWREVGXv3Cwzu44cVr5eVC/AnyqibEdXBqdlcubmeFQu/sEUXYBmzC0inux0dSeFfXzycLi8nIQgbdXg5zpjXsoCrL7N874Zv5ft4hRD9G0FtpcoaS2lo/ddUcVHxtA6Oe+XxH+wTgaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TKRrr3oyWGMVGmeIRJ2AOUfHaMeFfHrA8UgydINz24=;
 b=n41GqV4TpTJ/Dk28m3/RwgP1oBJIwDt3g2dZ+nUlgKoMFpcU/ejWv8GPgfyyBPiTCv5TBaqrQwRmGHavVSExEKzKGNT+RYD3R3c0aC3uMuuywrSiCvVrCzbc3VahR9FEwp3+J62zDDf6JkJFa9KO3yYjqvhKzuwrpWsB7MvmiMuHFNUWUA09jQ8WA3U9FqGmbg3ZuYDMEmKIgWxm+pn/0Pla6GIeXUu1dAoPvKXihIuyQTDNNTTdxZuvsCv0hajQFOnMFf990re7LB+VB1nmxUcACZljicSojaIOrf5Sj3C+2hL6s1ogE3ofRK05orVtnJi5NV2SMP/gta1FfcDgkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oppoglobal.onmicrosoft.com; s=selector1-oppoglobal-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TKRrr3oyWGMVGmeIRJ2AOUfHaMeFfHrA8UgydINz24=;
 b=Se8K1To5aHYtBDnSwsimwtWNO1CTllTyEO4Rgd2VaobzuX1GjiHJ76tf9jBJFXJmT1V73HuwFlYHwlMU0rrVwI5VOhnDf60EIxzuITAjfp2VYqypBbL14OQoPhnsyk8hRoqBeDkK+3pjrNCT+7n2YTSi8xc7W7krjok6AqN9Lcc=
Received: from HKAPR02MB4291.apcprd02.prod.outlook.com (2603:1096:203:d3::12)
 by HKAPR02MB4371.apcprd02.prod.outlook.com (2603:1096:203:d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Thu, 26 Nov
 2020 07:13:25 +0000
Received: from HKAPR02MB4291.apcprd02.prod.outlook.com
 ([fe80::b9b8:aaf4:2afd:218b]) by HKAPR02MB4291.apcprd02.prod.outlook.com
 ([fe80::b9b8:aaf4:2afd:218b%3]) with mapi id 15.20.3611.022; Thu, 26 Nov 2020
 07:13:25 +0000
From:   =?utf-8?B?5b2t5rWpKFJpY2hhcmQp?= <richard.peng@oppo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH] kvm:svm: Return the correct error code
Thread-Topic: [PATCH] kvm:svm: Return the correct error code
Thread-Index: AdbDw07DFQcZfob5RjiYdtD4llKu/w==
Date:   Thu, 26 Nov 2020 07:13:25 +0000
Message-ID: <HKAPR02MB42915D77D43D4ED125BD2121E0F90@HKAPR02MB4291.apcprd02.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oppo.com;
x-originating-ip: [58.252.5.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a599748-f468-40eb-8dc0-08d891dac444
x-ms-traffictypediagnostic: HKAPR02MB4371:
x-microsoft-antispam-prvs: <HKAPR02MB437112ABEC0DFF8B82C3DD16E0F90@HKAPR02MB4371.apcprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lhrudQuDxtDp4cnuUvn9SB2AK7ivEXxpELMwYIApoGSfXf556DifLdjoiPGpMdgQ5wRRqkuOQ+hLGkJeNSaR5cCYxanEnZb028LpfSWP0YA2wGf6+32PEseqYLwXK/AH0S06LyC6Fb1OOUVYiyvm9TAyFlREdqxTAyTdxO7ZvP5DTfdv/INJk50WYJZrXH7uzsjKc60VVW2OLvdz0x15TyHKw8do6zmAmHxJ0dmij9YG7wAbaJJ2BXuOdi5eAwDhZwJ7SURqWbqkPZDFF3MEHMFAnfhU6QMS/ve0lvZvixyn3SDpCKCciTTIsYPe2TDlOjtyi1sSx27G9f89jgcHjmt02fZixUzz5MQow1OW/OHPl7Xa6Ha89ArriUgN47Mi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HKAPR02MB4291.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(4744005)(6506007)(8676002)(83380400001)(4326008)(66946007)(52536014)(7696005)(8936002)(2906002)(86362001)(71200400001)(9686003)(55016002)(110136005)(85182001)(76116006)(66446008)(316002)(186003)(5660300002)(478600001)(66556008)(26005)(66476007)(64756008)(33656002)(54906003)(11606006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cjJZemRDS3NxbitWME90SU5MUmpxV1M0cnIyMFRvVC9IV3JXQit1NVYvK3dB?=
 =?utf-8?B?Z2tTY0Mwc1dZTGswVmlvN2RNakZoeEhNY3lnVjhwU3ZWbU1USE1mVzhId3px?=
 =?utf-8?B?dnU0VzlVSUpEYjczRDdVNFY3Vm0rK2pVS2svdlFiMVRwVEhrbWR5KzFWY3g0?=
 =?utf-8?B?OGpCTVRvbTNvbmRQbENwSHJIbWNuc1Frc2hpSjE2bGJOK0ZiWGhvY1J6eXMr?=
 =?utf-8?B?VVAwNlREazcrRzVCTlV0SXN4Z3YxcjArVktpVUQvQ29WY2IwWmtuM1FQNjVq?=
 =?utf-8?B?R1g3NHNiTTd6MVNrZUVmVGhoZ29ZWjBLQkhXN2ZudWM4U0tzd2Y5WFYwZzBr?=
 =?utf-8?B?NldreVc2a2pwaDJ1aXBacThmNnRIRmtMdGdCYTdRd2VHSzhXVlhybEVxM0xw?=
 =?utf-8?B?WGlNYVZzZGlQbjhoR3VOek84QjYveWU2M0o4Q3R5bGZodjZMYkNTb3E2SDV3?=
 =?utf-8?B?cG1EeHNZaWdnTUlabmNLZEFlaHJvUFk5Tmh1MkFrWFV2VDBqMWFqNGJtbXg5?=
 =?utf-8?B?bWxGMXRwa1ZjZnB2SG9mQmc2cEM5YWJVMUxzb0lpczZRdEsyRTdPaDJyZXR5?=
 =?utf-8?B?NWZab1BhYkswSmIzRDJ6dE9FdWhQTTQ4d0paWmNHNnIxOGNzNGZ4Y0dmcUlK?=
 =?utf-8?B?Uk5kOEljcDVJQXBSTVNqWDlkVE05d2FKTkx1YUhDZWV1U0Z2WEN3TkI3RTRv?=
 =?utf-8?B?ZkYzTkhkNndNQlQ4MXRKNS9XLzFsdThPTTQxOUVkdFNkNUdKcTdzaEdLYW94?=
 =?utf-8?B?RXZPUCsySEU4cFFITFVpamZUMkxibXJjc21NMXVSTmVSRHlVNEtMSzBHTk9V?=
 =?utf-8?B?U0JCL0ZYVC8zS3pMelR1Q2cwQUJ4K3RDMTBTKzF5VUl1dm1JbFptNnh5Ty9O?=
 =?utf-8?B?UC8rRm1JT084VjdFYWF5clJVSHI0UVJXRWNLbkZXc2VxSGRYbDNBanNzTUlQ?=
 =?utf-8?B?dVFiZ1B3aXlNYWgycDAvUzFRaHhYam5xRTlzS2g1eFlOZ0ZOMEV5aUpyN3Q0?=
 =?utf-8?B?QkU0SlR2YmNRZnhOT1M1RmJkRDMxeW4vSkpXeTlJZitOY1doSnBSc1N0Y3kv?=
 =?utf-8?B?cEVGMzh1NytxVXBjSmRQMVVzZThBYXhISTl1VFA5QmZ1VjBjMTRlNlhMNm1T?=
 =?utf-8?B?ZFVnZjk0YTZJaEh3alRlM1B6VkY2M1NweExqYmVCTDAvTW5RMS9Wb2FFb1Mx?=
 =?utf-8?B?aEtPSFhyK0EvMmh1OTE5M0t3aUNHQy9NMmRtZmxwM24wRGJXWkNOdFpzTTBM?=
 =?utf-8?B?QVRaN3U1OFlVbGhpTzFUcmFSRWNtS1ZpcFBweDF3S3EvRjFKMjBpRWNEVzBT?=
 =?utf-8?Q?pmM8Jha6zCdfE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HKAPR02MB4291.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a599748-f468-40eb-8dc0-08d891dac444
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2020 07:13:25.3405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8022BFKxVRNZrz8zG//NzvZfzFjG65vKHQ+fua2finVIwUCeRgvpo0nliW8BlI28nTAj+36gP0jTpET1+QwOJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HKAPR02MB4371
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIHJldHVybiB2YWx1ZSBvZiBzZXZfYXNpZF9uZXcgaXMgYXNzaWduZWQgdG8gdGhlIHZhcmlh
YmxlIGFzaWQsIHdoaWNoDQpzaG91bGQgYmUgcmV0dXJuZWQgZGlyZWN0bHkgaWYgdGhlIGFzaWQg
aXMgYW4gZXJyb3IgY29kZS4NCg0KRml4ZXM6IDE2NTRlZmNiYzQzMSAoIktWTTogU1ZNOiBBZGQg
S1ZNX1NFVl9JTklUIGNvbW1hbmQiKQ0KU2lnbmVkLW9mZi1ieTogUGVuZyBIYW8gPHJpY2hhcmQu
cGVuZ0BvcHBvLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2t2bS9zdm0vc2V2LmMgfCAyICstDQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rdm0vc3ZtL3Nldi5jIGIvYXJjaC94ODYva3ZtL3N2bS9zZXYuYw0KaW5kZXgg
NTY2ZjRkMTgxODViLi40MWNlYTZiNjk4NjAgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vc3Zt
L3Nldi5jDQorKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3Nldi5jDQpAQCAtMTc0LDcgKzE3NCw3IEBA
IHN0YXRpYyBpbnQgc2V2X2d1ZXN0X2luaXQoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nl
dl9jbWQgKmFyZ3ApDQoNCiAgICAgICAgYXNpZCA9IHNldl9hc2lkX25ldygpOw0KICAgICAgICBp
ZiAoYXNpZCA8IDApDQotICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCisgICAgICAgICAgICAg
ICByZXR1cm4gYXNpZDsNCg0KICAgICAgICByZXQgPSBzZXZfcGxhdGZvcm1faW5pdCgmYXJncC0+
ZXJyb3IpOw0KICAgICAgICBpZiAocmV0KQ0KLS0NCjIuMTguNA0K

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D72A067A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 17:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfH1PkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 11:40:20 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:39910
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbfH1PkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 11:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw2NMfXyT3wVuBSfA0YQ27t5lz4JwRg6YaHMGY1/4H0=;
 b=3E2L0hWDa9SzKUtXSTO+ymoGscM8gjOZUvtTnaIznU90Mx/cCMBltmRrxaEg/ZC8OLztlZp7/kaPNjbDLnM0FsUdxHzD3oT+8VPvfQLCRjNNFBnVPeQOI47k5ZALjwyTXZJECk6iUpsAPK6b68QN6uqoQvpKXTMk1lmnb2y/sH4=
Received: from DB6PR0802CA0030.eurprd08.prod.outlook.com (2603:10a6:4:a3::16)
 by DB6PR0801MB1848.eurprd08.prod.outlook.com (2603:10a6:4:38::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.21; Wed, 28 Aug
 2019 15:40:13 +0000
Received: from DB5EUR03FT006.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::207) by DB6PR0802CA0030.outlook.office365.com
 (2603:10a6:4:a3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2199.17 via Frontend
 Transport; Wed, 28 Aug 2019 15:40:13 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT006.mail.protection.outlook.com (10.152.20.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2220.16 via Frontend Transport; Wed, 28 Aug 2019 15:40:12 +0000
Received: ("Tessian outbound d33df262a6a7:v27"); Wed, 28 Aug 2019 15:40:07 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 175d16f4609560c1
X-CR-MTA-TID: 64aa7808
Received: from a48569f31930.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.0.55])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 13103645-40C7-4ED8-BBFA-869E3976C9AF.1;
        Wed, 28 Aug 2019 15:40:02 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2055.outbound.protection.outlook.com [104.47.0.55])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a48569f31930.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 28 Aug 2019 15:40:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejuq6AfgfPe2jYlPj2X93ijyHg7iVmBnAzmxBirDpqlWiDhrMeFusp81besB7SYStheAqRDbNOptfOM5K3xbrLF0CjLW0KBJGVjk/pqbenjheW0qPRana1jEVDVXZvlYxBmknK7rTgUQ++SACW27wAtnXiTSJ8WOU2W7rf9Tv49iUbSiQZG+vjyPPLGOwUjVgd1kt09B6WZ2Om3Cdz0tJ/lZXIMLmjLLKShkX/lHMFDjatdTF08kyarxQjVBpB9CpCcRWbc0kedUx5IyBxoqtYCaP59CghSeY3BeKf3OCwE0qPKCxp+K2XKV7P2tL56hnQoZFQvRuyo008A/aYzjwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYhgYAB36mCOYHB7dVJXkcZB/9ya13FlWc2PVnuNQ5o=;
 b=oDwki3Vrs7VxCIxfgoErR6d1DY7Ax5xTgkNJFGA7+71qJwlrvjP44iTpAALqBjSQRNdP3gTIg20LDzHGPElrJ4tRkmdNtIFsC1x9Jh6KzIAlwLJbmYdzHs3ozLMV6dpy3ssYghNRrCZEdpjRMtHbSeAlE7g6SsR0Oc5NRds4H4R4yiTBV4QrikoW9yQ6EtS5ZDok102JYDADd4Wm/ZYET5ttSR0+udw34KWoe8k6pdyfTB4BmlCylcqIJzfyojTy1PRUJJUVyu1rAhlKqocJyvodsfroYNVt4d8NCl1Xq5bBP1gsvoAgow6y8NtCNrVEuU/NORAbMfnGMzh2/hz+jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYhgYAB36mCOYHB7dVJXkcZB/9ya13FlWc2PVnuNQ5o=;
 b=X8vV8U6Kt67xu0DHlq7Ul2Ibt2iwOeghYQjKUKMi3RT1tcBHegADzQBdNTUBCyVOH7Ez+d4El8KikrhUcuVnAvYjl7HnT9nzZNmSo9I5L4UPuMK1c3CTSY4CYYhWIv/Gup9ZvCho3Q0Dd1NKwMCO5UCce2m70vFL7lywZv725l4=
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (10.255.99.17) by
 AM6PR08MB4165.eurprd08.prod.outlook.com (20.179.0.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 15:40:00 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::bd59:b56b:f215:e6e6]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::bd59:b56b:f215:e6e6%7]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 15:40:00 +0000
From:   Alexandru Elisei <Alexandru.Elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>,
        Vladimir Murzin <Vladimir.Murzin@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 01/16] arm: selftest.c: Remove
 redundant check for Exception Level
Thread-Topic: [kvm-unit-tests RFC PATCH 01/16] arm: selftest.c: Remove
 redundant check for Exception Level
Thread-Index: AQHVXaXxTNH3yny/0kighetsJPueYqcQn44AgAAS2IA=
Date:   Wed, 28 Aug 2019 15:39:59 +0000
Message-ID: <7fe6365c-4495-99fd-66e6-4ad2dec2b4d9@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-2-git-send-email-alexandru.elisei@arm.com>
 <20190828143232.nffx5tko3zbjbnbf@kamzik.brq.redhat.com>
In-Reply-To: <20190828143232.nffx5tko3zbjbnbf@kamzik.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0145.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::13) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.106.51]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 05e0973e-aec8-44c2-68a2-08d72bce03ea
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR08MB4165;
X-MS-TrafficTypeDiagnostic: AM6PR08MB4165:|DB6PR0801MB1848:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0801MB184876F70413AA17E103AF0586A30@DB6PR0801MB1848.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:6790;OLM:6790;
x-forefront-prvs: 014304E855
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(66066001)(31686004)(6116002)(4744005)(3846002)(486006)(44832011)(64756008)(11346002)(66946007)(386003)(52116002)(229853002)(256004)(102836004)(26005)(6916009)(446003)(66446008)(71190400001)(71200400001)(53546011)(6506007)(66476007)(66556008)(476003)(99286004)(2616005)(186003)(76176011)(6486002)(5660300002)(2906002)(6436002)(8676002)(36756003)(7736002)(305945005)(54906003)(4326008)(316002)(14454004)(6512007)(86362001)(31696002)(8936002)(81166006)(81156014)(6246003)(25786009)(53936002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB4165;H:AM6PR08MB4756.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: voKCe7vb+NwqLPyMxCAitI3YY3Iix4SBLvpci+MN+p0Vh3GPP26xBMP0bk9CwJvMLMuyvupQDfwkB6ynDjsd7JXQIQzCmMM8nus5kZ31IGTZqQ1MzGW8W6koXRtITgu6uaeOQDuan1UAcY7ZlAm39xNv5o7J38QhDUcbEI/xuxQhsx21KYRlAWqTXJcv5MgTpiYt0QvMVENmKJelAGVYhykSSzIwZqrh6OkcRD4yREw2G5R4rLGvJsU61ipGVD5it1Aesoq4d9yPzVkzE32NTqc86VhyraXtKPvHS5GJjf+AS2jwZHtKYc2yXa1uSxnkXbra7Ff6AbLYodLNb2vVB7rBJKt+LP+XEONII/DIEMbtKtqmh7QP+eF2MUoaBZrw7mUIA/ngVKAJ38ocMBIoMpkZtbwTQsdXRgbXfjmYhi4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C67D3EE090D44E47B359990FC28E9DD6@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4165
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT006.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(39860400002)(396003)(2980300002)(199004)(189003)(40434004)(6512007)(70206006)(478600001)(66066001)(31686004)(86362001)(81156014)(81166006)(7736002)(5660300002)(63370400001)(186003)(8676002)(22756006)(6116002)(8936002)(36756003)(356004)(70586007)(6506007)(6486002)(2486003)(23676004)(31696002)(2906002)(3846002)(76130400001)(26826003)(6246003)(486006)(2616005)(25786009)(476003)(26005)(126002)(446003)(336012)(102836004)(47776003)(5024004)(14444005)(99286004)(14454004)(11346002)(4326008)(436003)(54906003)(229853002)(6862004)(316002)(63350400001)(386003)(50466002)(76176011)(53546011)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0801MB1848;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: f744cb4a-dca3-4194-1430-08d72bcdfc57
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(710020)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0801MB1848;
X-Forefront-PRVS: 014304E855
X-Microsoft-Antispam-Message-Info: byiwfTatg99RSoSEPjO/8s69aor1bcYlri70ZZkHOwCgRvr+SWd51CEieU6DLgTEd8C1CLs+X3r71ARzp2Bf5aAP7CSuiGT/QSVzUFiB6Kg7OVxAf57Yr7uISQj32ktE2OdCEwhKU1/C/pUewU4U8ySW06qcPJYeqQztqnP4peKR5yzuVH4eFVOKWcDnJyDr3fgblJKDGoEBWgZQCdv3ChvnohFik5atAQm7fQwmZahNKOYiVNasLNCHnO++cG7IxEMSdsMf1UYtKz9TBBW+xf+1Yw05NgwTPDxrnb09bE504CLwc6R0oWldS8uVIAePzYL8f/XLP9ts9ptSbVQFzUreRCs4k7YaMLwRbE1gZT8uaLfGfcgTlBBKdQQoWQxHZfK/mygMY2ym4eYLp6hp3aCxUEgSpsMED7S44U/ScUE=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2019 15:40:12.4435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e0973e-aec8-44c2-68a2-08d72bce03ea
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1848
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gOC8yOC8xOSAzOjMyIFBNLCBBbmRyZXcgSm9uZXMgd3JvdGU6DQo+IE9uIFdlZCwgQXVnIDI4
LCAyMDE5IGF0IDAyOjM4OjE2UE0gKzAxMDAsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6DQo+PiBl
eHBlY3RlZF9yZWdzLnBzdGF0ZSBhbHJlYWR5IGhhcyBQU1JfTU9ERV9FTDFoIHNldCBhcyB0aGUg
ZXhwZWN0ZWQNCj4+IEV4Y2VwdGlvbiBMZXZlbC4NCj4gVGhhdCdzIHRydWUgZm9yIHNlbGZ0ZXN0
LXZlY3RvcnMta2VybmVsLCBidXQgbm90IGZvcg0KPiBzZWxmdGVzdC12ZWN0b3JzLXVzZXIuDQoN
Ck9vcHMsIHRoYXQncyB0cnVlLiBUaGlzIHBhdGNoIGlzIGRlZmluaXRlbHkgd3JvbmcsIEknbGwg
ZHJvcCBpdC4NCg0KVGhhbmtzLA0KQWxleA0KPg0KPiBUaGFua3MsDQo+IGRyZXcNCj4NCj4+IFNp
Z25lZC1vZmYtYnk6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4N
Cj4+IC0tLQ0KPj4gIGFybS9zZWxmdGVzdC5jIHwgNCAtLS0tDQo+PiAgMSBmaWxlIGNoYW5nZWQs
IDQgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2FybS9zZWxmdGVzdC5jIGIvYXJt
L3NlbGZ0ZXN0LmMNCj4+IGluZGV4IDI4YTE3ZjdhNzUzMS4uMTc2MjMxZjMyZWUxIDEwMDY0NA0K
Pj4gLS0tIGEvYXJtL3NlbGZ0ZXN0LmMNCj4+ICsrKyBiL2FybS9zZWxmdGVzdC5jDQo+PiBAQCAt
MjEzLDEwICsyMTMsNiBAQCBzdGF0aWMgYm9vbCBjaGVja19yZWdzKHN0cnVjdCBwdF9yZWdzICpy
ZWdzKQ0KPj4gIHsNCj4+ICAgICAgdW5zaWduZWQgaTsNCj4+DQo+PiAtICAgIC8qIGV4Y2VwdGlv
biBoYW5kbGVycyBzaG91bGQgYWx3YXlzIHJ1biBpbiBFTDEgKi8NCj4+IC0gICAgaWYgKGN1cnJl
bnRfbGV2ZWwoKSAhPSBDdXJyZW50RUxfRUwxKQ0KPj4gLSAgICAgICAgICAgIHJldHVybiBmYWxz
ZTsNCj4+IC0NCj4+ICAgICAgZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUocmVncy0+cmVncyk7
ICsraSkgew0KPj4gICAgICAgICAgICAgIGlmIChyZWdzLT5yZWdzW2ldICE9IGV4cGVjdGVkX3Jl
Z3MucmVnc1tpXSkNCj4+ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4+IC0t
DQo+PiAyLjcuNA0KPj4NCklNUE9SVEFOVCBOT1RJQ0U6IFRoZSBjb250ZW50cyBvZiB0aGlzIGVt
YWlsIGFuZCBhbnkgYXR0YWNobWVudHMgYXJlIGNvbmZpZGVudGlhbCBhbmQgbWF5IGFsc28gYmUg
cHJpdmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgcGxlYXNl
IG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBkbyBub3QgZGlzY2xvc2UgdGhlIGNv
bnRlbnRzIHRvIGFueSBvdGhlciBwZXJzb24sIHVzZSBpdCBmb3IgYW55IHB1cnBvc2UsIG9yIHN0
b3JlIG9yIGNvcHkgdGhlIGluZm9ybWF0aW9uIGluIGFueSBtZWRpdW0uIFRoYW5rIHlvdS4NCg==

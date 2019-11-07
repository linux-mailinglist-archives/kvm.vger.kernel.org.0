Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677ECF2BCC
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 11:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387812AbfKGKFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 05:05:43 -0500
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:15619
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbfKGKFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 05:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6z+gCGPMF5YwkrUj8RL7WXtN+o+r5J8ufy/gqCd+sU=;
 b=xHhOOXfnR1A228B81s3Ypr57AmXXyQuNp/or+EuOt0gZG8DQMny2r9sFKz80Cs3s17zUBXtmTqbF18GdVXvSQHF/mXY525n7Zq/3bjvxHVy1aHqnU48VVJp5cVlOyPmp0y6kPXhy9Z7Q+8Cwk2zeMKeweFV74KkXbHIL8YbMjx0=
Received: from VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14)
 by DB7PR08MB4617.eurprd08.prod.outlook.com (2603:10a6:10:75::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20; Thu, 7 Nov
 2019 10:05:32 +0000
Received: from DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::208) by VI1PR08CA0112.outlook.office365.com
 (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20 via Frontend
 Transport; Thu, 7 Nov 2019 10:05:32 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT005.mail.protection.outlook.com (10.152.20.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.21 via Frontend Transport; Thu, 7 Nov 2019 10:05:31 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33"); Thu, 07 Nov 2019 10:05:31 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 52d95fb779d70e73
X-CR-MTA-TID: 64aa7808
Received: from 1de130df6b55.2 (cr-mta-lb-1.cr-mta-net [104.47.12.55])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 745A1C7D-1FC0-4934-9D5B-2473D500553B.1;
        Thu, 07 Nov 2019 10:05:25 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 1de130df6b55.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 07 Nov 2019 10:05:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdoIiiZHTVT/W7QXJ2O3eSsrbMU0viPhwynWxyhmxQPFV6mMlDPbDa448z3Ncg0Jg67/wISoIF7CbZcW6y1QOYWnjiL4GzGeWboo1JB/39OKWeKkJysUyncU3Nil9R8q49bA+yVQvwgiiQ6nRrGTBzEVHFGRX+Y6oIraeG7eYmU3OfcjGViZN9hKq3r9dIsMvCzElQLDoP4QyiNGT+5ehO8eg3ec6eLhCvSiyP25VYWVqaadRL4tmgIV2ffvroGTCbNDedqLr9ouRrIJ2PbiRSUsUa/ArirTtwuTl43EJJKXsWXKYGTbGn9gmsv3I7K7b1NHIjVYaKzWrerBmnxyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJ/CIECqy7iDSaDi4uYJED63IkDjLCw1Hpp3u9P+syQ=;
 b=HFT6z0LbPT+GV7/XKSST91XfoQ71bnZYBIMhyMb2zKL3apxsRwnh1EBE9g3Ws+w6hlQ6YWrggVy9M6hNDRjKStH2IxEOj/1HLUHbpuQxG/vLjVI4xkZFvpW0cNPY6pAvvdOOwoMRtsDl9K2hrs8jtrtZcYex4WDqJcu05WFNXnUqe+qkA27tgN+WJEnuRh7qiKNPWqIhRve7Znbjngq84UI0VnZFW9DLkFeFBhLRcdZfmcnBU8da4qZX2ayX7nPWEp/i6NMtVEy1a8VSIGUN01WjyGDRMK2hj2yw3mfdS0bCHUfEXtw2s3M509fhLnQ2ESmIJTCR+QSXoaVZzeDRcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJ/CIECqy7iDSaDi4uYJED63IkDjLCw1Hpp3u9P+syQ=;
 b=NdLg9KJ9tQdUUnRoY0kDFGllnRd6fKUd4WRfLrPZEqba/+5vu+jhHc/quQ/kaPoCSLKC35Y3LjTwgqcXDlPbPw8JL7szaNkxrIKQ3nBgvfjIhsc+DGIczyKKljbU9bqw2iStc3IQq+6FDjimYPOd0BQaHJE8Xt29/EpmMqbaJ0U=
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (10.255.99.17) by
 AM6PR08MB4199.eurprd08.prod.outlook.com (20.179.3.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 10:05:24 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::58a3:6e7:b619:ea33]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::58a3:6e7:b619:ea33%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 10:05:24 +0000
From:   Alexandru Elisei <Alexandru.Elisei@arm.com>
To:     Andre Przywara <Andre.Przywara@arm.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Julien Grall <julien.grall.oss@gmail.com>
Subject: Re: [PATCH kvmtool 04/16] kvmtool: Add helper to sanitize arch
 specific KVM configuration
Thread-Topic: [PATCH kvmtool 04/16] kvmtool: Add helper to sanitize arch
 specific KVM configuration
Thread-Index: AQHVchPNCTL3BAakuUSTOqqsxrFq96d+n/cAgAEhnoA=
Date:   Thu, 7 Nov 2019 10:05:24 +0000
Message-ID: <9f9a3bb2-4358-b1d3-4384-04fe700ba80b@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <1569245722-23375-5-git-send-email-alexandru.elisei@arm.com>
 <20191106164848.4f2e1fbc@donnerap.cambridge.arm.com>
In-Reply-To: <20191106164848.4f2e1fbc@donnerap.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0341.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::17) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.106.49]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9fd7872d-1220-42e5-a5ea-08d7636a0647
X-MS-TrafficTypeDiagnostic: AM6PR08MB4199:|AM6PR08MB4199:|DB7PR08MB4617:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB4617C8553AD67CCA0195303286780@DB7PR08MB4617.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:5236;OLM:5236;
x-forefront-prvs: 0214EB3F68
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(51914003)(189003)(199004)(36756003)(6512007)(229853002)(7736002)(66066001)(8676002)(305945005)(14454004)(478600001)(8936002)(99286004)(6436002)(5660300002)(6116002)(6862004)(6246003)(81166006)(81156014)(6486002)(25786009)(6636002)(37006003)(316002)(64756008)(102836004)(26005)(66446008)(11346002)(66556008)(186003)(66476007)(31696002)(386003)(6506007)(53546011)(446003)(66946007)(2616005)(44832011)(486006)(52116002)(476003)(14444005)(2906002)(54906003)(3846002)(256004)(71200400001)(71190400001)(31686004)(86362001)(4326008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB4199;H:AM6PR08MB4756.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: baCLrQO4trzS6Trrf6Gb62wZ8TO6zidqp/690YkJs9Zyi4N88+b34eOQi8g4zg1ydALsxp6ySqfROKNKjKLSJpHJ/oZUu/A15VyXQjjB8GH1ntIGJfhcKXFw+FXNQLFiPKkNyYWMRaVaYL6BFV8TUqpZaLyYdqiQct3wceYsGBMhmKAz3AIbC47oYtQj2DwjjULrqLgCMQ5aw92pt/ZRQCx3rqn/3pED/PPF9GPKrQywBo/2N5WrOOQuu9KfCOyjku8a9yuRN3ufHk73M/vMcLOfr7EmKPZ489JprzCDpDpbozi2ls8OspW1ujj5ixJWVjFzgBi7D/k7LulJ6OUJUQWIYuc6j8u7m/YceSxL4XocDhCLi5+i9ICCOgrwUhv5U/mmnwOX5T0Id73PJZcXIWpyqmenE/VPONS0XzYvoCbAeDSn/ecBqCx4BzoXwE8z
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AFA7ECB46E1EE4FA9AF92ABD6B0C958@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4199
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Alexandru.Elisei@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(136003)(376002)(1110001)(339900001)(40434004)(51914003)(189003)(199004)(53546011)(386003)(14454004)(6506007)(316002)(478600001)(81156014)(26826003)(107886003)(446003)(229853002)(2616005)(50466002)(2486003)(81166006)(2906002)(8676002)(36756003)(26005)(47776003)(23676004)(99286004)(102836004)(31696002)(6246003)(86362001)(6486002)(6512007)(8936002)(14444005)(22756006)(186003)(37006003)(105606002)(6636002)(5024004)(305945005)(7736002)(70206006)(336012)(356004)(70586007)(76130400001)(5660300002)(31686004)(6862004)(6116002)(76176011)(436003)(4326008)(486006)(11346002)(66066001)(25786009)(54906003)(476003)(3846002)(126002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR08MB4617;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 7761464d-a800-4715-b209-08d7636a01d1
X-Forefront-PRVS: 0214EB3F68
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IzqFPv5zyG8xhfLrwoKBdDU+UQRZxvN7MSTyQEBVBGrloeO2QwEgjJp5ItKpU6urfp8qJIhPp2f7sCmmx01prvminhLvBlBppXdH3STHgDDLQlkWj61NVhLiMMsH/wfEo4jY8BHD0dyNvNmHifteDT5iynz2QQ4lxNxvAwLi5Ek35RV4ktUmB1obwzQ0VOEZr1dyM710G9Q+VT7V5jy4swBkab7ckHGBRo7Q0EhPo+QDbqP/089CdJtWxR4olhpzjwasYR3/8UU8KKvHEbLeaC3Lb+zVmQw31l6fmQvqKR2Udk2PVwRWwzvAjJhJXkfmMV1LZ67XcAiH+mS+mZqFZ5Uh9qPbixyF4R/HFosRZy9vtqmTy/hcsYaH7r/3oME0wX6IbLQ9Z4FV/hrsQWlMFr7jDRrbE3WLb55+MMFkVgxgbvWq1mzBVB74hpp0fGI3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2019 10:05:31.8535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd7872d-1220-42e5-a5ea-08d7636a0647
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB4617
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGksDQoNCk9uIDExLzYvMTkgNDo0OCBQTSwgQW5kcmUgUHJ6eXdhcmEgd3JvdGU6DQoNCj4gT24g
TW9uLCAyMyBTZXAgMjAxOSAxNDozNToxMCArMDEwMA0KPiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4
YW5kcnUuZWxpc2VpQGFybS5jb20+IHdyb3RlOg0KPg0KPiBIaSwNCj4NCj4+IGt2bXRvb2wgYWNj
ZXB0cyBnZW5lcmljIGFuZCBhcmNoaXRlY3R1cmUgc3BlY2lmaWMgcGFyYW1ldGVycy4gV2hlbiBj
cmVhdGluZw0KPj4gYSB2aXJ0dWFsIG1hY2hpbmUsIG9ubHkgdGhlIGdlbmVyaWMgcGFyYW1ldGVy
cyBhcmUgY2hlY2tlZCBhZ2FpbnN0IHNhbmUNCj4+IHZhbHVlcy4gQWRkIGEgZnVuY3Rpb24gdG8g
c2FuaXRpemUgdGhlIGFyY2hpdGVjdHVyZSBzcGVjaWZpYyBjb25maWd1cmF0aW9uDQo+PiBvcHRp
b25zIGFuZCBjYWxsIGl0IGJlZm9yZSB0aGUgaW5pdGlhbGl6YXRpb24gcm91dGluZXMuDQo+Pg0K
Pj4gVGhpcyBwYXRjaCB3YXMgaW5zcGlyZWQgYnkgSnVsaWVuIEdyYWxsJ3MgcGF0Y2guDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogSnVsaWVuIEdyYWxsIDxqdWxpZW4uZ3JhbGxAYXJtLmNvbT4NCj4g
VGhhdCdzIGEgYml0IGNvbmZ1c2luZzogSWYgaXQgaXMgYmFzZWQgb24gSnVsaWVuJ3MgcGF0Y2gs
IHlvdSBzaG91bGQga2VlcCBoaW0gYXMgdGhlIGF1dGhvciwgYWRkaW5nIGEgc2hvcnQgY29tbWVu
dCBoZXJlIGFib3V0IHdoYXQgKnlvdSogY2hhbmdlZC4NCj4gSWYgaXQncyBub3QsIHlvdSBzaG91
bGQgbm90IGhhdmUgYSBTLW8tYjogbGluZSBmcm9tIEp1bGllbi4NCg0KSSB3YXNuJ3QgcmVhbGx5
IHN1cmUgd2hhdCB0byBkbyBpbiB0aGlzIGNhc2UuIEknbGwga2VlcCBoaW0gYXQgdGhlIGF1dGhv
ciwgdGhhbmtzDQpmb3IgdGhlIHN1Z2dlc3Rpb24uDQoNClRoYW5rcywNCkFsZXgNCj4NCj4+IFNp
Z25lZC1vZmYtYnk6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4N
Cj4gVGhlIGNvZGUgbG9va3MgZ29vZCB0byBtZToNCj4NCj4gUmV2aWV3ZWQtYnk6IEFuZHJlIFBy
enl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPg0KPg0KPiBDaGVlcnMsDQo+IEFuZHJlLg0K
Pg0KPj4gLS0tDQo+PiAgYXJtL2FhcmNoNjQvaW5jbHVkZS9rdm0va3ZtLWFyY2guaCB8ICAyICst
DQo+PiAgYXJtL2luY2x1ZGUvYXJtLWNvbW1vbi9rdm0tYXJjaC5oICB8ICA0ICsrKysNCj4+ICBh
cm0va3ZtLmMgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTEgKysrKysrKysrLS0NCj4+ICBi
dWlsdGluLXJ1bi5jICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKysNCj4+ICBtaXBzL2luY2x1
ZGUva3ZtL2t2bS1hcmNoLmggICAgICAgIHwgIDQgKysrKw0KPj4gIG1pcHMva3ZtLmMgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgNSArKysrKw0KPj4gIHBvd2VycGMvaW5jbHVkZS9rdm0va3Zt
LWFyY2guaCAgICAgfCAgNCArKysrDQo+PiAgcG93ZXJwYy9rdm0uYyAgICAgICAgICAgICAgICAg
ICAgICB8ICA1ICsrKysrDQo+PiAgeDg2L2luY2x1ZGUva3ZtL2t2bS1hcmNoLmggICAgICAgICB8
ICA0ICsrKysNCj4+ICB4ODYva3ZtLmMgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMjQgKysr
KysrKysrKysrLS0tLS0tLS0tLS0tDQo+PiAgMTAgZmlsZXMgY2hhbmdlZCwgNTAgaW5zZXJ0aW9u
cygrKSwgMTUgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2FybS9hYXJjaDY0L2lu
Y2x1ZGUva3ZtL2t2bS1hcmNoLmggYi9hcm0vYWFyY2g2NC9pbmNsdWRlL2t2bS9rdm0tYXJjaC5o
DQo+PiBpbmRleCA5ZGU2MjNhYzZjYjkuLjFiM2QwYTVmYjFiNCAxMDA2NDQNCj4+IC0tLSBhL2Fy
bS9hYXJjaDY0L2luY2x1ZGUva3ZtL2t2bS1hcmNoLmgNCj4+ICsrKyBiL2FybS9hYXJjaDY0L2lu
Y2x1ZGUva3ZtL2t2bS1hcmNoLmgNCj4+IEBAIC01LDcgKzUsNyBAQA0KPj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAweDgwMDAgICAgICAgICAgICAgICAgICAgICAgICAgIDogICAgICAg
XA0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAweDgwMDAwKQ0KPj4NCj4+IC0jZGVm
aW5lIEFSTV9NQVhfTUVNT1JZKGt2bSkgKChrdm0pLT5jZmcuYXJjaC5hYXJjaDMyX2d1ZXN0ICA/
ICAgICAgIFwNCj4+ICsjZGVmaW5lIEFSTV9NQVhfTUVNT1JZKGNmZykgKChjZmcpLT5hcmNoLmFh
cmNoMzJfZ3Vlc3QgICAgICA/ICAgICAgIFwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgQVJNX0xPTUFQX01BWF9NRU1PUlkgICAgICAgICAgICA6ICAgICAgIFwNCj4+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgQVJNX0hJTUFQX01BWF9NRU1PUlkpDQo+Pg0KPj4gZGlmZiAt
LWdpdCBhL2FybS9pbmNsdWRlL2FybS1jb21tb24va3ZtLWFyY2guaCBiL2FybS9pbmNsdWRlL2Fy
bS1jb21tb24va3ZtLWFyY2guaA0KPj4gaW5kZXggYjlkNDg2ZDVlYWMyLi45NjU5NzhkN2NmYjUg
MTAwNjQ0DQo+PiAtLS0gYS9hcm0vaW5jbHVkZS9hcm0tY29tbW9uL2t2bS1hcmNoLmgNCj4+ICsr
KyBiL2FybS9pbmNsdWRlL2FybS1jb21tb24va3ZtLWFyY2guaA0KPj4gQEAgLTc0LDQgKzc0LDgg
QEAgc3RydWN0IGt2bV9hcmNoIHsNCj4+ICAgICAgdTY0ICAgICBkdGJfZ3Vlc3Rfc3RhcnQ7DQo+
PiAgfTsNCj4+DQo+PiArc3RydWN0IGt2bV9jb25maWc7DQo+PiArDQo+PiArdm9pZCBrdm1fX2Fy
Y2hfc2FuaXRpemVfY2ZnKHN0cnVjdCBrdm1fY29uZmlnICpjZmcpOw0KPj4gKw0KPj4gICNlbmRp
ZiAvKiBBUk1fQ09NTU9OX19LVk1fQVJDSF9IICovDQo+PiBkaWZmIC0tZ2l0IGEvYXJtL2t2bS5j
IGIvYXJtL2t2bS5jDQo+PiBpbmRleCAxOThjZWU1YzA5OTcuLjVkZWNjMTM4ZmQzZSAxMDA2NDQN
Cj4+IC0tLSBhL2FybS9rdm0uYw0KPj4gKysrIGIvYXJtL2t2bS5jDQo+PiBAQCAtNTcsMTEgKzU3
LDE4IEBAIHZvaWQga3ZtX19hcmNoX3NldF9jbWRsaW5lKGNoYXIgKmNtZGxpbmUsIGJvb2wgdmlk
ZW8pDQo+PiAgew0KPj4gIH0NCj4+DQo+PiArdm9pZCBrdm1fX2FyY2hfc2FuaXRpemVfY2ZnKHN0
cnVjdCBrdm1fY29uZmlnICpjZmcpDQo+PiArew0KPj4gKyAgICBpZiAoY2ZnLT5yYW1fc2l6ZSA+
IEFSTV9NQVhfTUVNT1JZKGNmZykpIHsNCj4+ICsgICAgICAgICAgICBjZmctPnJhbV9zaXplID0g
QVJNX01BWF9NRU1PUlkoY2ZnKTsNCj4+ICsgICAgICAgICAgICBwcl93YXJuaW5nKCJDYXBwaW5n
IG1lbW9yeSB0byAlbGx1TUIiLCBjZmctPnJhbV9zaXplID4+IDIwKTsNCj4+ICsgICAgfQ0KPj4g
K30NCj4+ICsNCj4+ICB2b2lkIGt2bV9fYXJjaF9pbml0KHN0cnVjdCBrdm0gKmt2bSkNCj4+ICB7
DQo+PiAgICAgIHVuc2lnbmVkIGxvbmcgYWxpZ25tZW50Ow0KPj4gICAgICAvKiBDb252ZW5pZW5j
ZSBhbGlhc2VzICovDQo+PiAtICAgIHU2NCByYW1fc2l6ZSA9IGt2bS0+Y2ZnLnJhbV9zaXplOw0K
Pj4gICAgICBjb25zdCBjaGFyICpodWdldGxiZnNfcGF0aCA9IGt2bS0+Y2ZnLmh1Z2V0bGJmc19w
YXRoOw0KPj4NCj4+ICAgICAgLyoNCj4+IEBAIC04Nyw3ICs5NCw3IEBAIHZvaWQga3ZtX19hcmNo
X2luaXQoc3RydWN0IGt2bSAqa3ZtKQ0KPj4gICAgICAgICAgICAgICAgICAgICAgYWxpZ25tZW50
ID0gU1pfMk07DQo+PiAgICAgIH0NCj4+DQo+PiAtICAgIGt2bS0+cmFtX3NpemUgPSBtaW4ocmFt
X3NpemUsICh1NjQpQVJNX01BWF9NRU1PUlkoa3ZtKSk7DQo+PiArICAgIGt2bS0+cmFtX3NpemUg
PSBrdm0tPmNmZy5yYW1fc2l6ZTsNCj4+ICAgICAga3ZtLT5hcmNoLnJhbV9hbGxvY19zaXplID0g
a3ZtLT5yYW1fc2l6ZSArIGFsaWdubWVudDsNCj4+ICAgICAga3ZtLT5hcmNoLnJhbV9hbGxvY19z
dGFydCA9IG1tYXBfYW5vbl9vcl9odWdldGxiZnMoa3ZtLCBodWdldGxiZnNfcGF0aCwNCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGt2bS0+YXJjaC5yYW1f
YWxsb2Nfc2l6ZSk7DQo+PiBkaWZmIC0tZ2l0IGEvYnVpbHRpbi1ydW4uYyBiL2J1aWx0aW4tcnVu
LmMNCj4+IGluZGV4IGM4NjdjOGJhMDg5Mi4uNTMyYzA2ZjkwYmEwIDEwMDY0NA0KPj4gLS0tIGEv
YnVpbHRpbi1ydW4uYw0KPj4gKysrIGIvYnVpbHRpbi1ydW4uYw0KPj4gQEAgLTY0Miw2ICs2NDIs
OCBAQCBzdGF0aWMgc3RydWN0IGt2bSAqa3ZtX2NtZF9ydW5faW5pdChpbnQgYXJnYywgY29uc3Qg
Y2hhciAqKmFyZ3YpDQo+Pg0KPj4gICAgICBrdm0tPmNmZy5yZWFsX2NtZGxpbmUgPSByZWFsX2Nt
ZGxpbmU7DQo+Pg0KPj4gKyAgICBrdm1fX2FyY2hfc2FuaXRpemVfY2ZnKCZrdm0tPmNmZyk7DQo+
PiArDQo+PiAgICAgIGlmIChrdm0tPmNmZy5rZXJuZWxfZmlsZW5hbWUpIHsNCj4+ICAgICAgICAg
ICAgICBwcmludGYoIiAgIyAlcyBydW4gLWsgJXMgLW0gJUx1IC1jICVkIC0tbmFtZSAlc1xuIiwg
S1ZNX0JJTkFSWV9OQU1FLA0KPj4gICAgICAgICAgICAgICAgICAgICBrdm0tPmNmZy5rZXJuZWxf
ZmlsZW5hbWUsDQo+PiBkaWZmIC0tZ2l0IGEvbWlwcy9pbmNsdWRlL2t2bS9rdm0tYXJjaC5oIGIv
bWlwcy9pbmNsdWRlL2t2bS9rdm0tYXJjaC5oDQo+PiBpbmRleCBmZGMwOWQ4MzAyNjMuLmYwYmZm
ZjUwYzdjOSAxMDA2NDQNCj4+IC0tLSBhL21pcHMvaW5jbHVkZS9rdm0va3ZtLWFyY2guaA0KPj4g
KysrIGIvbWlwcy9pbmNsdWRlL2t2bS9rdm0tYXJjaC5oDQo+PiBAQCAtNDcsNCArNDcsOCBAQCBz
dHJ1Y3Qga3ZtX2FyY2ggew0KPj4gICAgICBib29sIGlzNjRiaXQ7DQo+PiAgfTsNCj4+DQo+PiAr
c3RydWN0IGt2bV9jb25maWc7DQo+PiArDQo+PiArdm9pZCBrdm1fX2FyY2hfc2FuaXRpemVfY2Zn
KHN0cnVjdCBrdm1fY29uZmlnICpjZmcpOw0KPj4gKw0KPj4gICNlbmRpZiAvKiBLVk1fX0tWTV9B
UkNIX0ggKi8NCj4+IGRpZmYgLS1naXQgYS9taXBzL2t2bS5jIGIvbWlwcy9rdm0uYw0KPj4gaW5k
ZXggZTJhMGM2M2IxNGI4Li42M2Q2NTFmMjlmNzAgMTAwNjQ0DQo+PiAtLS0gYS9taXBzL2t2bS5j
DQo+PiArKysgYi9taXBzL2t2bS5jDQo+PiBAQCAtNTYsNiArNTYsMTEgQEAgdm9pZCBrdm1fX2Fy
Y2hfc2V0X2NtZGxpbmUoY2hhciAqY21kbGluZSwgYm9vbCB2aWRlbykNCj4+DQo+PiAgfQ0KPj4N
Cj4+ICt2b2lkIGt2bV9fYXJjaF9zYW5pdGl6ZV9jZmcoc3RydWN0IGt2bV9jb25maWcgKmNmZykN
Cj4+ICt7DQo+PiArICAgIC8qIFdlIGRvbid0IGhhdmUgYW55IGFyY2ggc3BlY2lmaWMgY29uZmln
dXJhdGlvbi4gKi8NCj4+ICt9DQo+PiArDQo+PiAgLyogQXJjaGl0ZWN0dXJlLXNwZWNpZmljIEtW
TSBpbml0ICovDQo+PiAgdm9pZCBrdm1fX2FyY2hfaW5pdChzdHJ1Y3Qga3ZtICprdm0pDQo+PiAg
ew0KPj4gZGlmZiAtLWdpdCBhL3Bvd2VycGMvaW5jbHVkZS9rdm0va3ZtLWFyY2guaCBiL3Bvd2Vy
cGMvaW5jbHVkZS9rdm0va3ZtLWFyY2guaA0KPj4gaW5kZXggODEyNmI5NmNiNjZhLi40MmVhN2Rm
MTMyNWYgMTAwNjQ0DQo+PiAtLS0gYS9wb3dlcnBjL2luY2x1ZGUva3ZtL2t2bS1hcmNoLmgNCj4+
ICsrKyBiL3Bvd2VycGMvaW5jbHVkZS9rdm0va3ZtLWFyY2guaA0KPj4gQEAgLTY0LDQgKzY0LDgg
QEAgc3RydWN0IGt2bV9hcmNoIHsNCj4+ICAgICAgc3RydWN0IHNwYXByX3BoYiAgICAgICAgKnBo
YjsNCj4+ICB9Ow0KPj4NCj4+ICtzdHJ1Y3Qga3ZtX2NvbmZpZzsNCj4+ICsNCj4+ICt2b2lkIGt2
bV9fYXJjaF9zYW5pdGl6ZV9jZmcoc3RydWN0IGt2bV9jb25maWcgKmNmZyk7DQo+PiArDQo+PiAg
I2VuZGlmIC8qIEtWTV9fS1ZNX0FSQ0hfSCAqLw0KPj4gZGlmZiAtLWdpdCBhL3Bvd2VycGMva3Zt
LmMgYi9wb3dlcnBjL2t2bS5jDQo+PiBpbmRleCAwMzRiYzQ2MDhhZDkuLjczOTY1NjQwY2Y4MiAx
MDA2NDQNCj4+IC0tLSBhL3Bvd2VycGMva3ZtLmMNCj4+ICsrKyBiL3Bvd2VycGMva3ZtLmMNCj4+
IEBAIC04Nyw2ICs4NywxMSBAQCB2b2lkIGt2bV9fYXJjaF9zZXRfY21kbGluZShjaGFyICpjbWRs
aW5lLCBib29sIHZpZGVvKQ0KPj4gICAgICAvKiBXZSBkb24ndCBuZWVkIGFueXRoaW5nIHVudXN1
YWwgaW4gaGVyZS4gKi8NCj4+ICB9DQo+Pg0KPj4gK3ZvaWQga3ZtX19hcmNoX3Nhbml0aXplX2Nm
ZyhzdHJ1Y3Qga3ZtX2NvbmZpZyAqY2ZnKQ0KPj4gK3sNCj4+ICsgICAgLyogV2UgZG9uJ3QgaGF2
ZSBhbnkgYXJjaCBzcGVjaWZpYyBjb25maWd1cmF0aW9uLiAqLw0KPj4gK30NCj4+ICsNCj4+ICAv
KiBBcmNoaXRlY3R1cmUtc3BlY2lmaWMgS1ZNIGluaXQgKi8NCj4+ICB2b2lkIGt2bV9fYXJjaF9p
bml0KHN0cnVjdCBrdm0gKmt2bSkNCj4+ICB7DQo+PiBkaWZmIC0tZ2l0IGEveDg2L2luY2x1ZGUv
a3ZtL2t2bS1hcmNoLmggYi94ODYvaW5jbHVkZS9rdm0va3ZtLWFyY2guaA0KPj4gaW5kZXggYmZk
ZDM0MzhhOWRlLi4yY2M2NWYzMGZjZDIgMTAwNjQ0DQo+PiAtLS0gYS94ODYvaW5jbHVkZS9rdm0v
a3ZtLWFyY2guaA0KPj4gKysrIGIveDg2L2luY2x1ZGUva3ZtL2t2bS1hcmNoLmgNCj4+IEBAIC00
MCw0ICs0MCw4IEBAIHN0cnVjdCBrdm1fYXJjaCB7DQo+PiAgICAgIHN0cnVjdCBpbnRlcnJ1cHRf
dGFibGUgIGludGVycnVwdF90YWJsZTsNCj4+ICB9Ow0KPj4NCj4+ICtzdHJ1Y3Qga3ZtX2NvbmZp
ZzsNCj4+ICsNCj4+ICt2b2lkIGt2bV9fYXJjaF9zYW5pdGl6ZV9jZmcoc3RydWN0IGt2bV9jb25m
aWcgKmNmZyk7DQo+PiArDQo+PiAgI2VuZGlmIC8qIEtWTV9fS1ZNX0FSQ0hfSCAqLw0KPj4gZGlm
ZiAtLWdpdCBhL3g4Ni9rdm0uYyBiL3g4Ni9rdm0uYw0KPj4gaW5kZXggNWFiYjQxZTM3MGJiLi5k
ZjVkNDgxMDZjODAgMTAwNjQ0DQo+PiAtLS0gYS94ODYva3ZtLmMNCj4+ICsrKyBiL3g4Ni9rdm0u
Yw0KPj4gQEAgLTEyOSw2ICsxMjksMTcgQEAgdm9pZCBrdm1fX2FyY2hfc2V0X2NtZGxpbmUoY2hh
ciAqY21kbGluZSwgYm9vbCB2aWRlbykNCj4+ICAgICAgICAgICAgICBzdHJjYXQoY21kbGluZSwg
IiBlYXJseXByaW50az1zZXJpYWwgaTgwNDIubm9hdXg9MSIpOw0KPj4gIH0NCj4+DQo+PiArdm9p
ZCBrdm1fX2FyY2hfc2FuaXRpemVfY2ZnKHN0cnVjdCBrdm1fY29uZmlnICpjZmcpDQo+PiArew0K
Pj4gKyAgICAvKiB2aWRtb2RlIHNob3VsZCBiZSBlaXRoZXIgc3BlY2lmaWVkIG9yIHNldCBieSBk
ZWZhdWx0ICovDQo+PiArICAgIGlmIChjZmctPnZuYyB8fCBjZmctPnNkbCB8fCBjZmctPmd0aykg
ew0KPj4gKyAgICAgICAgICAgIGlmICghY2ZnLT5hcmNoLnZpZG1vZGUpDQo+PiArICAgICAgICAg
ICAgICAgICAgICBjZmctPmFyY2gudmlkbW9kZSA9IDB4MzEyOw0KPj4gKyAgICB9IGVsc2Ugew0K
Pj4gKyAgICAgICAgICAgIGNmZy0+YXJjaC52aWRtb2RlID0gMDsNCj4+ICsgICAgfQ0KPj4gK30N
Cj4+ICsNCj4+ICAvKiBBcmNoaXRlY3R1cmUtc3BlY2lmaWMgS1ZNIGluaXQgKi8NCj4+ICB2b2lk
IGt2bV9fYXJjaF9pbml0KHN0cnVjdCBrdm0gKmt2bSkNCj4+ICB7DQo+PiBAQCAtMjM5LDcgKzI1
MCw2IEBAIHN0YXRpYyBib29sIGxvYWRfYnppbWFnZShzdHJ1Y3Qga3ZtICprdm0sIGludCBmZF9r
ZXJuZWwsIGludCBmZF9pbml0cmQsDQo+PiAgICAgIHNpemVfdCBjbWRsaW5lX3NpemU7DQo+PiAg
ICAgIHNzaXplX3QgZmlsZV9zaXplOw0KPj4gICAgICB2b2lkICpwOw0KPj4gLSAgICB1MTYgdmlk
bW9kZTsNCj4+DQo+PiAgICAgIC8qDQo+PiAgICAgICAqIFNlZSBEb2N1bWVudGF0aW9uL3g4Ni9i
b290LnR4dCBmb3IgZGV0YWlscyBubyBiekltYWdlIG9uLWRpc2sgYW5kDQo+PiBAQCAtMjgyLDIz
ICsyOTIsMTMgQEAgc3RhdGljIGJvb2wgbG9hZF9iemltYWdlKHN0cnVjdCBrdm0gKmt2bSwgaW50
IGZkX2tlcm5lbCwgaW50IGZkX2luaXRyZCwNCj4+ICAgICAgICAgICAgICBtZW1jcHkocCwga2Vy
bmVsX2NtZGxpbmUsIGNtZGxpbmVfc2l6ZSAtIDEpOw0KPj4gICAgICB9DQo+Pg0KPj4gLSAgICAv
KiB2aWRtb2RlIHNob3VsZCBiZSBlaXRoZXIgc3BlY2lmaWVkIG9yIHNldCBieSBkZWZhdWx0ICov
DQo+PiAtICAgIGlmIChrdm0tPmNmZy52bmMgfHwga3ZtLT5jZmcuc2RsIHx8IGt2bS0+Y2ZnLmd0
aykgew0KPj4gLSAgICAgICAgICAgIGlmICgha3ZtLT5jZmcuYXJjaC52aWRtb2RlKQ0KPj4gLSAg
ICAgICAgICAgICAgICAgICAgdmlkbW9kZSA9IDB4MzEyOw0KPj4gLSAgICAgICAgICAgIGVsc2UN
Cj4+IC0gICAgICAgICAgICAgICAgICAgIHZpZG1vZGUgPSBrdm0tPmNmZy5hcmNoLnZpZG1vZGU7
DQo+PiAtICAgIH0gZWxzZSB7DQo+PiAtICAgICAgICAgICAgdmlkbW9kZSA9IDA7DQo+PiAtICAg
IH0NCj4+IC0NCj4+ICAgICAga2Vybl9ib290ICAgICAgID0gZ3Vlc3RfcmVhbF90b19ob3N0KGt2
bSwgQk9PVF9MT0FERVJfU0VMRUNUT1IsIDB4MDApOw0KPj4NCj4+ICAgICAga2Vybl9ib290LT5o
ZHIuY21kX2xpbmVfcHRyICAgICA9IEJPT1RfQ01ETElORV9PRkZTRVQ7DQo+PiAgICAgIGtlcm5f
Ym9vdC0+aGRyLnR5cGVfb2ZfbG9hZGVyICAgPSAweGZmOw0KPj4gICAgICBrZXJuX2Jvb3QtPmhk
ci5oZWFwX2VuZF9wdHIgICAgID0gMHhmZTAwOw0KPj4gICAgICBrZXJuX2Jvb3QtPmhkci5sb2Fk
ZmxhZ3MgICAgICAgIHw9IENBTl9VU0VfSEVBUDsNCj4+IC0gICAga2Vybl9ib290LT5oZHIudmlk
X21vZGUgICAgICAgICA9IHZpZG1vZGU7DQo+PiArICAgIGtlcm5fYm9vdC0+aGRyLnZpZF9tb2Rl
ICAgICAgICAgPSBrdm0tPmNmZy5hcmNoLnZpZG1vZGU7DQo+Pg0KPj4gICAgICAvKg0KPj4gICAg
ICAgKiBSZWFkIGluaXRyZCBpbWFnZSBpbnRvIGd1ZXN0IG1lbW9yeQ0KSU1QT1JUQU5UIE5PVElD
RTogVGhlIGNvbnRlbnRzIG9mIHRoaXMgZW1haWwgYW5kIGFueSBhdHRhY2htZW50cyBhcmUgY29u
ZmlkZW50aWFsIGFuZCBtYXkgYWxzbyBiZSBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUg
aW50ZW5kZWQgcmVjaXBpZW50LCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkg
YW5kIGRvIG5vdCBkaXNjbG9zZSB0aGUgY29udGVudHMgdG8gYW55IG90aGVyIHBlcnNvbiwgdXNl
IGl0IGZvciBhbnkgcHVycG9zZSwgb3Igc3RvcmUgb3IgY29weSB0aGUgaW5mb3JtYXRpb24gaW4g
YW55IG1lZGl1bS4gVGhhbmsgeW91Lg0K

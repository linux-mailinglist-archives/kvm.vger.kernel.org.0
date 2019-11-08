Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01DD8F4DA8
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 14:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfKHN7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 08:59:45 -0500
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:15127
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726281AbfKHN7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 08:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjgHKYjq7oqSbSpxEDwfFng1XHT2lFXMf86ysMRkC8o=;
 b=iLiQDc4iDBRwoRlhCu1McEtq9z65g46bGcQ3ZtVtILMoB4BwQrmGwttSu+c0QY/cXLdr1OktJr5EHQsAgeAKslGbEwC9ZcwtBePCtauKRVF927tjuBs9gjkY+lJWCQ1bTLvDRsYbSwbmQMHR29a55CUCyouxSAweBxt7NrB51JE=
Received: from DB6PR0802CA0035.eurprd08.prod.outlook.com (2603:10a6:4:a3::21)
 by HE1PR08MB2649.eurprd08.prod.outlook.com (2603:10a6:7:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.24; Fri, 8 Nov
 2019 13:59:35 +0000
Received: from DB5EUR03FT017.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::201) by DB6PR0802CA0035.outlook.office365.com
 (2603:10a6:4:a3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.22 via Frontend
 Transport; Fri, 8 Nov 2019 13:59:35 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT017.mail.protection.outlook.com (10.152.20.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.21 via Frontend Transport; Fri, 8 Nov 2019 13:59:35 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33"); Fri, 08 Nov 2019 13:59:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 005bd53b5cd89064
X-CR-MTA-TID: 64aa7808
Received: from fe762897a665.2 (cr-mta-lb-1.cr-mta-net [104.47.14.53])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id CED5BD97-489A-4458-9FFF-3FA289A7E106.1;
        Fri, 08 Nov 2019 13:59:28 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id fe762897a665.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 08 Nov 2019 13:59:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKiAxF2g3Zol48ZipN3EvvBpfbCoTp8JA35iY9Eqb6DRVac6yHUfRgtCIXqjOJK+7Www2Tyb1eRncLA1kkgat6u3E8FCGyXSxwRS4zCzyax2Q8394lRh7pEmylql2xutksCVNx8tYJJfLNQqvIgAfGTVzxYi7Vf3ZYq7QSLg9+297heeVIluNtpaeRY2Slwf5dQ3MK9/tTHA99sjvsn+4NR62DtKRf2BQ3Od3la3KaeYdZeEN3DyfVUQXJUEEzssFBhqALVx5d113xxAztkXk6SaMf19LkvPWXeanqzVtdKVcuJUzp1r9K8GBbuaAoMYOb4nQft5t+MYxnFcdm1yyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4asgjvfl/TpWaq4QD4U+QVpdjCtmTYRgOZ7kECgQQLE=;
 b=RF+PIWtKdyVFyv5c5HcHlLCubFE3J2eih7jWFlQgop7+ZTr65noGXqH+7qDJJuCDQYDQaDmKL6pe7N3H5ZP0PLLuxWmd5ZxepLiTNscb7V397RUVTk4SCmN9qsORGGxaYShPNzGYSpO/kMTtmrCzwdL8xd7pVBaY6nkGQxGfATx0LWbBMDsnX3HufGgCG9/NJqB7D1cXbN3u390ruHD2lkjyfHsCbasCPgcYxdGjNYUKbXG0hd1R3FXhiB05gctPaSplkLPnbX3kYxb3rF4qbRLRpypfYI+UzSaZ5KU3luJ8fz7Ba1/aR2xoLO1ylSj3j3OSU7ipGrhHygvTX+0gMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4asgjvfl/TpWaq4QD4U+QVpdjCtmTYRgOZ7kECgQQLE=;
 b=oEIOPihFDYVdsqqreefR6TvUiUqdIvnAice01X0RurguQlPYyxPU3s9sqQ9tVTdL5pBHu3gVDHsSR0OMwfbqKF/BVFx7ikrVh4I2UX2jEi8Cu8ljwTqQlS7B4YbGpqtud82+JXU774+2mRzGe8O7AF/oAV80ny5S6wtR1tkSkeo=
Received: from AM6PR08MB3176.eurprd08.prod.outlook.com (52.135.164.25) by
 AM6PR08MB3286.eurprd08.prod.outlook.com (52.135.161.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 13:59:26 +0000
Received: from AM6PR08MB3176.eurprd08.prod.outlook.com
 ([fe80::f9b1:6623:ab49:7b13]) by AM6PR08MB3176.eurprd08.prod.outlook.com
 ([fe80::f9b1:6623:ab49:7b13%3]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 13:59:26 +0000
From:   Ard Biesheuvel <Ard.Biesheuvel@arm.com>
To:     Christoffer Dall <Christoffer.Dall@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Memory regions and VMAs across architectures
Thread-Topic: Memory regions and VMAs across architectures
Thread-Index: AQHVliZl1EGI7TljeEqvAqrUR5wJl6eBTRyA
Date:   Fri, 8 Nov 2019 13:59:26 +0000
Message-ID: <d49efeb7-3cad-9400-5e67-8a1e80ef7407@arm.com>
References: <20191108111920.GD17608@e113682-lin.lund.arm.com>
In-Reply-To: <20191108111920.GD17608@e113682-lin.lund.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN2PR01CA0056.prod.exchangelabs.com (2603:10b6:800::24) To
 AM6PR08MB3176.eurprd08.prod.outlook.com (2603:10a6:209:46::25)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Ard.Biesheuvel@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.140.96.140]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fde5fb30-a168-4607-5f03-08d76453e311
X-MS-TrafficTypeDiagnostic: AM6PR08MB3286:|AM6PR08MB3286:|HE1PR08MB2649:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR08MB2649607C553A86FE5AE7DED2887B0@HE1PR08MB2649.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 0215D7173F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(199004)(189003)(6436002)(6506007)(486006)(476003)(7736002)(71200400001)(2616005)(386003)(66066001)(256004)(110136005)(316002)(446003)(14444005)(11346002)(6512007)(66946007)(66476007)(66556008)(64756008)(66446008)(31686004)(6246003)(2906002)(6486002)(44832011)(102836004)(52116002)(229853002)(86362001)(478600001)(99286004)(4326008)(186003)(25786009)(71190400001)(36756003)(14454004)(54906003)(53546011)(26005)(81156014)(305945005)(81166006)(3846002)(31696002)(6116002)(76176011)(2501003)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB3286;H:AM6PR08MB3176.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: nI03puv6OIyLODdfk+mgHsgQji/c/HNP89ivdDp81+WpIyn0QUDxlbnY3WkfUGWvN66PvT8K6tXV+XbQlKjk0OoVCfadX69qJoHwPxHFsQZgsSTmdFgdYpm7uAcOk2NZR516RnuJdj6shc1R72Y0AnO7gy+ttPqgi2bDjbJqzLJm9kjJoyVgsSvUHGtOHsYQgbB2WaFVxhXHfBBxrmc3+P4muUFwioMEDxFQuvPqpKfs7U+Q87xhEBVP8s8foDurjJOOpbHctao1faVmRTkpn6OavSx/aM9ctwlyosmYxevPeT8LWo2aWRSVhgvkfiBEXRIw1Yykeutu7ZUDTvSQ1aDDzaghH6zMnsYD/Y+hnyaQfCLcUPZMjbU5GL6M9D+BynfmfkUGZEsrCLuGoPTqISOYoVCcZVqnC/bYkLJTSZ7b7eflF0HNhCTmL02kYQyP
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED42909F6BFB084D9B660B1E9E2A52A5@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3286
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ard.Biesheuvel@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT017.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(1110001)(339900001)(199004)(40434004)(189003)(5024004)(14444005)(50466002)(7736002)(2906002)(305945005)(356004)(2501003)(3846002)(6116002)(110136005)(31696002)(22756006)(316002)(25786009)(8676002)(478600001)(81166006)(81156014)(186003)(26826003)(336012)(76130400001)(436003)(476003)(486006)(2616005)(446003)(11346002)(126002)(54906003)(86362001)(31686004)(70206006)(70586007)(14454004)(8936002)(5660300002)(6246003)(23676004)(2486003)(66066001)(102836004)(99286004)(76176011)(107886003)(4326008)(47776003)(53546011)(26005)(105606002)(229853002)(6512007)(6486002)(36756003)(386003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR08MB2649;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 2abd0225-7547-478f-0daa-08d76453ddd0
X-Forefront-PRVS: 0215D7173F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ya+iYPwKY44cCBsP1OESh3tI4Q5Zto2KLbSDiXB/1zORnbqVNd48GRP6nYwqh3yo89hW8g+FsKDobM4FsZPhTanmuoaUis9bj4kbfPGiC2G4Tar9nWeo0MFq6+BhWEoK9O+wKn/v29eM4JwaRZQ1Yu0E7S2TbDZlH4/eETK6Fqubota1y16xj8JdKttVPxaRAgF4XXr/ROGCN/tcORCSGzuFH2tHFvHqzGWWKv8bOuw75uRvDXcJfYD7PjNv+3/2HPlmECeVuAIuScDWg/IJfIgFK2QfcvRFySsFIdMUlopufBatYLc/D7k+ILxkC2fxzJ21WeM3l3LuPua8a239PmZDE5bdJ9H1xz3TeqfGyYDSdEYbKPeOy2pTxI8dQ3+vdFhGvtGcLSe2PjnSPMueor7bDF881/yZI5ASPwBR+RbfD+FIe5LoGRc4ePOTsuFU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 13:59:35.0283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fde5fb30-a168-4607-5f03-08d76453e311
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2649
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTEvOC8xOSAxMjoxOSBQTSwgQ2hyaXN0b2ZmZXIgRGFsbCB3cm90ZToNCj4gSGksDQo+DQo+
IEkgaGFkIGEgbG9vayBhdCBvdXIgcmVsYXRpdmVseSBjb21wbGljYXRlZCBsb2dpYyBpbg0KPiBr
dm1fYXJjaF9wcmVwYXJlX21lbW9yeV9yZWdpb24oKSwgYW5kIHdhcyB3b25kZXJpbmcgaWYgdGhl
cmUgd2FzIHJvb20gdG8NCj4gdW5pZnkgc29tZSBvZiB0aGlzIGhhbmRsaW5nIGJldHdlZW4gYXJj
aGl0ZWN0dXJlcy4NCj4NCj4gKElmIHlvdSBoYXZlbid0IHNlZW4gb3VyIGltcGxlbWVudGF0aW9u
LCB5b3UgY2FuIGZpbmQgaXQgaW4NCj4gdmlydC9rdm0vYXJtL21tdS5jLCBhbmQgaXQgaGFzIGxv
dmVseSBBU0NJSSBhcnQhKQ0KPg0KPiBJIHRoZW4gaGFkIGEgbG9vayBhdCB0aGUgeDg2IGNvZGUs
IGJ1dCB0aGF0IGRvZXNuJ3QgYWN0dWFsbHkgZG8gYW55dGhpbmcNCj4gd2hlbiBjcmVhdGluZyBt
ZW1vcnkgcmVnaW9ucywgd2hpY2ggbWFrZXMgbWUgd29uZGVyIHdoeSB0aGUgYXJoaXRlY3R1cmVz
DQo+IGRpZmZlciBpbiB0aGlzIGFzcGVjdC4NCj4NCj4gVGhlIHJlYXNvbiB3ZSBhZGRlZCB0aGUg
bG9naWMgdGhhdCB3ZSBoYXZlIGZvciBhcm0vYXJtNjQgaXMgdGhhdCB3ZQ0KPiBkb24ndCByZWFs
bHkgd2FudCB0byB0YWtlIGZhdWx0cyBmb3IgSS9PIGFjY2Vzc2VzLiAgSSdtIG5vdCBhY3R1YWxs
eQ0KPiBzdXJlIGlmIHRoaXMgaXMgYSBjb3JyZXRuZXNzIHRoaW5nLCBvciBhbiBvcHRpbWl6YXRp
b24gZWZmb3J0LCBhbmQgdGhlDQo+IG9yaWdpbmFsIGNvbW1pdCBtZXNzYWdlIGRvZXNuJ3QgcmVh
bGx5IGV4cGxhaW4uICBBcmQsIHlvdSB3cm90ZSB0aGF0DQo+IGNvZGUsIGRvIHlvdSByZWNhbGwg
dGhlIGRldGFpbHM/DQo+DQoNCkkgaGF2ZSBhIHZhZ3VlIHJlY29sbGVjdGlvbiBvZiBpbXBsZW1l
bnRpbmcgZXhlY3V0aW9uIGZyb20gcmVhZC1vbmx5DQpndWVzdCBtZW1vcnkgaW4gb3JkZXIgdG8g
c3VwcG9ydCBleGVjdXRlLWluLXBsYWNlIGZyb20gZW11bGF0ZWQgTk9SDQpmbGFzaCBpbiBVRUZJ
LCBhbmQgZ29pbmcgZG93biBhIHJhYmJpdCBob2xlIGRlYnVnZ2luZyByYW5kb20sIHNlZW1pbmds
eQ0KdW5yZWxhdGVkIGNyYXNoZXMgaW4gdGhlIGhvc3Qgd2hpY2ggdHVybmVkIG91dCB0byBiZSBj
YXVzZWQgYnkgdGhlIHplcm8NCnBhZ2UgZ2V0dGluZyBjb3JydXB0ZWQgYmVjYXVzZSBpdCB3YXMg
bWFwcGVkIHJlYWQtd3JpdGUgaW4gdGhlIGd1ZXN0IHRvDQpiYWNrIHVuaW5pdGlhbGl6ZWQgcmVn
aW9ucyBvZiB0aGUgTk9SIGZsYXNoLg0KDQpUaGF0IGRvZXNuJ3QgcXVpdGUgYW5zd2VyIHlvdXIg
cXVlc3Rpb24sIHRob3VnaCAtIEkgdGhpbmsgaXQgd2FzIGp1c3QgYW4NCm9wdGltaXphdGlvbiAu
Li4NCg0KPiBJbiBhbnkgY2FzZSwgd2hhdCB3ZSBkbyBpcyB0byBjaGVjayBmb3IgZWFjaCBWTUEg
YmFja2luZyBhIG1lbXNsb3QsIHdlDQo+IGNoZWNrIGlmIHRoZSBtZW1zbG90IGZsYWdzIGFuZCB2
bWEgZmxhZ3MgYXJlIGEgcmVhc29uYWJsZSBtYXRjaCwgYW5kIHdlDQo+IHRyeSB0byBkZXRlY3Qg
SS9PIG1hcHBpbmdzIGJ5IGxvb2tpbmcgZm9yIHRoZSBWTV9QRk5NQVAgZmxhZyBvbiB0aGUgVk1B
DQo+IGFuZCBwcmUtcG9wdWxhdGUgc3RhZ2UgMiBwYWdlIHRhYmxlcyAob3VyIGVxdWl2YWxlbnQg
b2YgRVBUL05QVC8uLi4pLg0KPiBIb3dldmVyLCB0aGVyZSBhcmUgc29tZSB0aGluZ3Mgd2hpY2gg
YXJlIG5vdCBjbGVhciB0byBtZToNCj4NCj4gRmlyc3QsIHdoYXQgcHJldmVudHMgdXNlciBzcGFj
ZSBmcm9tIG1lc3NpbmcgYXJvdW5kIHdpdGggdGhlIFZNQXMgYWZ0ZXINCj4ga3ZtX2FyY2hfcHJl
cGFyZV9tZW1vcnlfcmVnaW9uKCkgY29tcGxldGVzPyAgSWYgbm90aGluZywgdGhlbiB3aGF0IGlz
DQo+IHRoZSB2YWx1ZSBvZiB0aGUgY2hla3Mgd2UgcGVyZm9ybSB3cnQuIHRvIFZNQXM/DQo+DQo+
IFNlY29uZCwgd2h5IHdvdWxkIGFybS9hcm02NCBuZWVkIHNwZWNpYWwgaGFuZGxpbmcgZm9yIEkv
TyBtYXBwaW5ncw0KPiBjb21wYXJlZCB0byBvdGhlciBhcmNoaXRlY3R1cmVzLCBhbmQgaG93IGlz
IHRoaXMgZGVhbHQgd2l0aCBmb3INCj4geDg2L3MzOTAvcG93ZXIvLi4uID8NCj4NCj4NCj4gVGhh
bmtzLA0KPg0KPiAgICAgIENocmlzdG9mZmVyDQo+DQoNCklNUE9SVEFOVCBOT1RJQ0U6IFRoZSBj
b250ZW50cyBvZiB0aGlzIGVtYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgYXJlIGNvbmZpZGVudGlh
bCBhbmQgbWF5IGFsc28gYmUgcHJpdmlsZWdlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVk
IHJlY2lwaWVudCwgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVkaWF0ZWx5IGFuZCBkbyBu
b3QgZGlzY2xvc2UgdGhlIGNvbnRlbnRzIHRvIGFueSBvdGhlciBwZXJzb24sIHVzZSBpdCBmb3Ig
YW55IHB1cnBvc2UsIG9yIHN0b3JlIG9yIGNvcHkgdGhlIGluZm9ybWF0aW9uIGluIGFueSBtZWRp
dW0uIFRoYW5rIHlvdS4NCg==

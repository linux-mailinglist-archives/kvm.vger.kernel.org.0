Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001C18B81A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 14:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbfHMMI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 08:08:29 -0400
Received: from mail-eopbgr00090.outbound.protection.outlook.com ([40.107.0.90]:51265
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727466AbfHMMI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 08:08:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miV80Bc8Xmbh90xMxxv0XvgRlr64l9zYuRrEVCKs7AB5JHt9cvZFdV9keFsRXU02QYrAEgL7AOEv0PurAK7iQ2XgPwzMyMSBWOKa2BBVhjyL0te3pqMUaqTNOF0CYfDraJTRY+yjNaAlaDIa6QtzdL0K+1XpZ9D++4+knU1z9UT7vPYfxDiAmDAs8kxMT0ZRfA8U2O3GeXpd1ezeUg6OOAiEG9CL79qzVKp+dBFSqPRvqqez9ktiwN5w4RzozX/QqvEmcuqDVoxiOmOBj1jdgFmdUyia+SYcJjg2XSZ3lOUjFifMqX8rn5vBQRERgGyOQL73Yw95Km2AeM71o2PbIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c87z5jLmdpKI7AxzmIpYCSnrYKsBnCw0AplJcZjRNJ0=;
 b=Ne382CT0IA2Qk3U5nDSUXnW+dAau1dxZSlVtmvpZvVDhhLqfyUnuHBIb3+RLXrQK4gzF8xEIDaBLEMPEUQvOlRLcQXVcr3BzvNvXxgEL/i6IiBx2jm8pJPGzZjSeoZood7OgaII2YCis8fT3uiz59GC81wSrMmPQbOXVvL7qetAJlodCbcBQo+u6PuWYvI1CD0+FQESfnzkwTFJRrE67IBQJDwhjW3RayX1C698meG9rD9aypiZLLzNr/b+7VAv+NySm3ouTFepKUkax0OojJbx3DKrn1geOORpj9KCyV+j9nvsTFhPCRFj+A9b5MH8n85/uLH268gx5+Bc9JAiQBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c87z5jLmdpKI7AxzmIpYCSnrYKsBnCw0AplJcZjRNJ0=;
 b=YjYLjGFag29HDg+j/mgNtbz2p82t4smH6Orj+W/TD2oCmgFA0SSX9YCe+mrwHrlfpLsclAF2JsFxQ6PD9eCvVqGbMSedrshTurO1Ow+3XorD031dyMN3jNsHxCEN0ZeKstWADrCGPcvLHCdmjFuBSJAaR7U7164JhK0kGCVwemo=
Received: from VI1PR08MB4399.eurprd08.prod.outlook.com (20.179.28.141) by
 VI1PR08MB4045.eurprd08.prod.outlook.com (20.178.127.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Tue, 13 Aug 2019 12:08:24 +0000
Received: from VI1PR08MB4399.eurprd08.prod.outlook.com
 ([fe80::303d:1bb9:76b2:99d7]) by VI1PR08MB4399.eurprd08.prod.outlook.com
 ([fe80::303d:1bb9:76b2:99d7%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 12:08:24 +0000
From:   Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "berto@igalia.com" <berto@igalia.com>,
        "mdroth@linux.vnet.ibm.com" <mdroth@linux.vnet.ibm.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Denis Lunev <den@virtuozzo.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH 0/3] Reduce the number of Valgrind reports in unit tests.
Thread-Topic: [PATCH 0/3] Reduce the number of Valgrind reports in unit tests.
Thread-Index: AQHVRvApPaDWpTeAN0+LmmlSaHsyr6b5QmSA///OmICAAAC6gA==
Date:   Tue, 13 Aug 2019 12:08:24 +0000
Message-ID: <374427ee-3a0a-eabd-ddcd-d9db5f494867@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <fe62e531-dbe9-c96e-d2c0-28fd123df347@virtuozzo.com>
 <92c9ff07-178e-0c7a-c0a0-2c21f3f481db@redhat.com>
In-Reply-To: <92c9ff07-178e-0c7a-c0a0-2c21f3f481db@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0138.eurprd05.prod.outlook.com
 (2603:10a6:7:28::25) To VI1PR08MB4399.eurprd08.prod.outlook.com
 (2603:10a6:803:102::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=andrey.shinkevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79d2e3b6-4370-4bb3-c9f3-08d71fe6f0cf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB4045;
x-ms-traffictypediagnostic: VI1PR08MB4045:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR08MB40452D31F338DF679FD6C1F6F4D20@VI1PR08MB4045.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39840400004)(396003)(366004)(376002)(189003)(199004)(53936002)(86362001)(66556008)(4744005)(305945005)(66946007)(478600001)(31696002)(7736002)(81166006)(66476007)(64756008)(6246003)(107886003)(2201001)(14454004)(66446008)(8676002)(14444005)(256004)(36756003)(3846002)(81156014)(2906002)(71190400001)(71200400001)(31686004)(6116002)(4326008)(99286004)(6486002)(25786009)(76176011)(44832011)(2616005)(316002)(8936002)(476003)(229853002)(486006)(6512007)(7416002)(5660300002)(2501003)(66066001)(11346002)(52116002)(6436002)(446003)(26005)(110136005)(53546011)(6506007)(386003)(102836004)(186003)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB4045;H:VI1PR08MB4399.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kaDE12mLwLfh6sh522aLML3zNIRL2mpTYLWU+cCrrxvlwrqdJ6NSQBiJwenTx+UEaTuxhxZcT1lkK0eHsQHVRV0SZh+sXd6zvTHnWYPLhmhpzXuuPizsldgDrp9J9jRYBwuMEB4yaKz+D1MZlWXHxMdvnbrW1g2dDRITWLvdrazKJgCUZq9Zicb3/qZmG44utdqdxeXLf6pme+5U7R65/yzG6pA/0pZYquqFByEJiWAySQ3Xk7AnLjfDfL3yK3uUgsCcHX1XN+HapQU/LPEL/eJpVH66CYLYO3NqTMBoRgzseExtg5sWzHbZ6bHN1PZBS4MlHe1SRLbNPabPbzwQWSLUkMBcaI/EtAAN2pLGWXAwFlI9K/fEpVCduxe0Bz00KwNumGVbXKpiiY/HWHna6rN+MClz9TxBj9y36YNiz1U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <056A5B01C3FF1A4EB38322A537DB5AAB@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d2e3b6-4370-4bb3-c9f3-08d71fe6f0cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 12:08:24.1192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gMnFHBqeexGsgGGCZSQioALiRDNZIb1UgrCuCki8Q3VCscfNmnMbNEg4Gw7N7RwtglAjSizkkEUlq4E8R0YuklPKdwJWLU/LdaAtth5rZGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4045
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDEzLzA4LzIwMTkgMTU6MDUsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IE9uIDEzLzA4
LzE5IDE0OjAyLCBBbmRyZXkgU2hpbmtldmljaCB3cm90ZToNCj4+IFBJTkdJTkcuLi4NCj4gDQo+
IEkgdGhvdWdodCBJIGhhZCBhbHJlYWR5IHNhaWQgSSBxdWV1ZWQgdGhlIHNlcmllcz8NCj4gDQo+
IFBhb2xvDQo+IA0KDQpUaGFuayB5b3UgUGFvbG8uDQpJIGFtIGNsZWFyIG5vdy4NCg0KQW5kcmV5
DQoNCj4+IE9uIDMwLzA3LzIwMTkgMTk6MDEsIEFuZHJleSBTaGlua2V2aWNoIHdyb3RlOg0KPj4+
IFJ1bm5pbmcgdW5pdCB0ZXN0cyB1bmRlciB0aGUgVmFsZ3JpbmQgbWF5IGhlbHAgdG8gZGV0ZWN0
IFFFTVUgbWVtb3J5IGlzc3Vlcw0KPj4+IChzdWdnZXN0ZWQgYnkgRGVuaXMgVi4gTHVuZXYpLiBT
b21lIG9mIHRoZSBWYWxncmluZCByZXBvcnRzIHJlbGF0ZSB0byB0aGUNCj4+PiB1bml0IHRlc3Qg
Y29kZSBpdHNlbGYuIExldCdzIGVsaW1pbmF0ZSB0aGUgZGV0ZWN0ZWQgbWVtb3J5IGlzc3VlcyB0
byBlYXNlDQo+Pj4gbG9jYXRpbmcgY3JpdGljYWwgb25lcy4NCj4+Pg0KPj4+IEFuZHJleSBTaGlu
a2V2aWNoICgzKToNCj4+PiAgICAgdGVzdC10aHJvdHRsZTogRml4IHVuaW5pdGlhbGl6ZWQgdXNl
IG9mIGJ1cnN0X2xlbmd0aA0KPj4+ICAgICB0ZXN0czogRml4IHVuaW5pdGlhbGl6ZWQgYnl0ZSBp
biB0ZXN0X3Zpc2l0b3JfaW5fZnV6eg0KPj4+ICAgICBpMzg2L2t2bTogaW5pdGlhbGl6ZSBzdHJ1
Y3QgYXQgZnVsbCBiZWZvcmUgaW9jdGwgY2FsbA0KPj4+DQo+Pj4gICAgdGFyZ2V0L2kzODYva3Zt
LmMgICAgICAgICAgICAgICAgIHwgMyArKysNCj4+PiAgICB0ZXN0cy90ZXN0LXN0cmluZy1pbnB1
dC12aXNpdG9yLmMgfCA4ICsrKy0tLS0tDQo+Pj4gICAgdGVzdHMvdGVzdC10aHJvdHRsZS5jICAg
ICAgICAgICAgIHwgMiArKw0KPj4+ICAgIDMgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCsp
LCA1IGRlbGV0aW9ucygtKQ0KPj4+DQo+Pg0KPiANCg0KLS0gDQpXaXRoIHRoZSBiZXN0IHJlZ2Fy
ZHMsDQpBbmRyZXkgU2hpbmtldmljaA0K

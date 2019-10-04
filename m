Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19915CB77D
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 11:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388263AbfJDJlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 05:41:08 -0400
Received: from mail-eopbgr00122.outbound.protection.outlook.com ([40.107.0.122]:8686
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388240AbfJDJlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 05:41:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyKuJw0gu/m3KGSZD5has77maMpp972X4zAWVPFiBGqm8qd7UVh6tyrjcfvQ+messQibgYS9j+VZRb/A824S2OPHebf2JOdhctoDFb9J8VWDJN78VSiE+skFyPKmokoaI1akFwIU6KZ034Gym/UZ4lwwavCa7BpNEiqUFkJwqmjqCuzsblOj6+yyODnvTPKxgFYbyrOF12jPKxRnkLpCMJmSe+xf1ueZfE+2jfpH81+B5vLT3HN4v6hOGVyRKWKD01XKMNiruuC6KHIb+UJDlgZB4oPz8djvdV0AJEaolglj2aOzalSssInpzqiwmuRmK4TWu9zmG8GLHrhZ5tp1Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrVuOHWhVY/rdcBwVdjKJm7ujtfoqvghq5Z6YN183nw=;
 b=cUWCnNBTkuc4rNG8gPDCyjniFI4Ky6TKoEYDdyf4nicWRb6aite4rN+klKzoEJZ1/GIfD9P2bXKiuGIx/9Qq19sEoWfTDLivQM5zYDiHYW1YuDDAvUyMd7PiWz96JF+TYbhcG6Icz8UyF+JybY6hEhu3B2CXwxnix/11C/jWOVf9dc0DZvpklEaQ3etZj2Qbew7T76RIS0IEVbOxEAMVtdlf6sbFnng9RS5NXRmoTQN3IhbXnLcobEg3BAMVBAheST7hmZQIP6ZsY0HadxYzhSpYSvDi5lwSOKP2uBT/gytbP3RT9fHCVYpPDkvPBQuadfKK4HG9I+8sEsnrlGp16g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bitdefender.com; dmarc=pass action=none
 header.from=bitdefender.com; dkim=pass header.d=bitdefender.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bitdefender.onmicrosoft.com; s=selector2-bitdefender-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrVuOHWhVY/rdcBwVdjKJm7ujtfoqvghq5Z6YN183nw=;
 b=R3PegsOth1upIactU0XTkRRmaVWnY4vVtDan6RAUo9E4VSU711DGJaiTWjcfRb8mHf0PemAYOWob7h8XU0/mtvQk2cw1AIPN1L3Vz6Gwgh5+4YGcf0wDICUIJLv/qRRivhceiYH0oKbrPi22DaBbJz4vjwUxY/9jEpTpjV2BO58=
Received: from DB7PR02MB3979.eurprd02.prod.outlook.com (20.177.121.157) by
 DB7PR02MB5243.eurprd02.prod.outlook.com (20.178.84.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 4 Oct 2019 09:41:04 +0000
Received: from DB7PR02MB3979.eurprd02.prod.outlook.com
 ([fe80::a9d4:6e4d:dca:97a7]) by DB7PR02MB3979.eurprd02.prod.outlook.com
 ([fe80::a9d4:6e4d:dca:97a7%7]) with mapi id 15.20.2305.023; Fri, 4 Oct 2019
 09:41:04 +0000
From:   Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>
CC:     =?utf-8?B?QWRhbGJlcnQgTGF6xINy?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?utf-8?B?U2FtdWVsIExhdXLDqW4=?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        =?utf-8?B?TWloYWkgRG9uyJt1?= <mdontu@bitdefender.com>
Subject: RE: DANGER WILL ROBINSON, DANGER
Thread-Topic: DANGER WILL ROBINSON, DANGER
Thread-Index: AQHVTs8soTQpQXiOD0KEAgMKguVJzKb471OAgAOvxoCAAA/uAIAMAODggBTcuICABjXSgIAA6j0wgCNkfQD//6DNAIAACCgAgAAiMwCAAAz2gIAAM+oAgAFHhoCAAAJQgIAADPFwgAAf2QCAABLZgIAA3zQA
Date:   Fri, 4 Oct 2019 09:41:04 +0000
Message-ID: <DB7PR02MB39795E622880231C8F8A6478BB9E0@DB7PR02MB3979.eurprd02.prod.outlook.com>
References: <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
 <f26710a4-424f-730c-a676-901bae451409@redhat.com>
 <20191002170429.GA8189@redhat.com>
 <dd0ca0d3-f502-78a1-933a-7e1b5fb90baa@redhat.com>
 <20191003154233.GA4421@redhat.com>
 <d62a6720-e069-4e03-6a3a-798c020786f7@redhat.com>
 <DB7PR02MB39796440DC81A5B53E86F029BB9F0@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191003183108.GA3557@redhat.com>
 <afe2cf69-5c2c-95af-88ce-f3814fece2e2@redhat.com>
In-Reply-To: <afe2cf69-5c2c-95af-88ce-f3814fece2e2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mcirjaliu@bitdefender.com; 
x-originating-ip: [91.199.104.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6912604d-1426-403a-01c0-08d748aef994
x-ms-traffictypediagnostic: DB7PR02MB5243:|DB7PR02MB5243:|DB7PR02MB5243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR02MB5243387671F46CFA8A732B3ABB9E0@DB7PR02MB5243.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(54906003)(66066001)(6246003)(9686003)(86362001)(107886003)(5660300002)(25786009)(7416002)(81166006)(8936002)(2906002)(446003)(81156014)(305945005)(316002)(55016002)(7736002)(486006)(110136005)(74316002)(52536014)(186003)(8676002)(476003)(11346002)(478600001)(7696005)(76176011)(6436002)(76116006)(102836004)(256004)(66446008)(66476007)(229853002)(66946007)(14454004)(4326008)(71200400001)(53546011)(99286004)(71190400001)(66556008)(3846002)(33656002)(64756008)(26005)(6116002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DB7PR02MB5243;H:DB7PR02MB3979.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: bitdefender.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tj5SPotdXFCTVWTC09UOvCfwSzYngqhRYszKy/9HwfEDgito1pbjaeCoyJNl8FnqBlMScrD82o94QtfPWWzMp25MARXYLaRaUx9MC97YP8jfxdM1kgh9xu4vwqQuYpREgKtfYXvgjqA1i/jUQIoR25NDYMCK6uUBhI3Hq2Sj1RbkcxXtg85QIagT8RO0Zn8s7W8WtF65BGXD0UVtUeOSNhxHyx9Wk9pMLndZJVW6xp2yN5iZX4a9y6oezX3z4OW55DMzQpVCfRxJRKOuiMG/TOGGuYGSDN/b4dl+nTDO0t8j+O51foep35gm7axhsxDsFHp6t6re/HbjSYSG1utD/ycuMQbJzh4YMzaPKJj6Ip6cSFIYJZxReZ1PPAnaVSenYoR7udIFjD5fGJmvRZXsAocA/+bXd+NCC7eII+07FAQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bitdefender.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6912604d-1426-403a-01c0-08d748aef994
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 09:41:04.3641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 487baf29-f1da-469a-9221-243f830c36f3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UIOCIpfuCKckr2w3Ml7U83yFrw5Lut+UkZH4wxwQJpKD6F7S6fElZLBP14tAiIL/H0xFC2qKWMzl5hpO4xyBQDNzd/4B802/d/zy1REmASY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR02MB5243
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAwMy8xMC8xOSAyMDozMSwgSmVyb21lIEdsaXNzZSB3cm90ZToNCj4gPiBTbyBpbiBzdW1t
YXJ5LCB0aGUgc291cmNlIHFlbXUgcHJvY2VzcyBoYXMgYW5vbnltb3VzIHZtYSAocmVndWxhciBs
aWJjDQo+ID4gbWFsbG9jIGZvciBpbnN0YW5jZSkuIFRoZSBpbnRyb3NwZWN0b3IgcWVtdSBwcm9j
ZXNzIHdoaWNoIG1pcnJvciB0aGUNCj4gPiB0aGUgc291cmNlIHFlbXUgdXNlIG1tYXAgb24gL2Rl
di9rdm0gKGFzc3VtaW5nIHlvdSBjYW4gcmV1c2UgdGhlDQo+IGt2bQ0KPiA+IGRldmljZSBmaWxl
IGZvciB0aGlzIG90aGVyd2lzZSB5b3UgY2FuIGludHJvZHVjZSBhIG5ldyBrdm0gZGV2aWNlDQo+
ID4gZmlsZSkuDQo+IA0KPiBJdCBzaG91bGQgYmUgYSBuZXcgZGV2aWNlLCBzb21ldGhpbmcgbGlr
ZSAvZGV2L2t2bW1lbS4gIEJpdERlZmVuZGVyJ3MgUkZDDQo+IHBhdGNoZXMgYWxyZWFkeSBoYXZl
IHRoZSByaWdodCB1c2Vyc3BhY2UgQVBJLCB0aGF0IHdhcyBub3QgYW4gaXNzdWUuDQoNCkkgZ2V0
IGl0IHNvIGZhci4gSSBoYXZlIGEgcGF0Y2ggdGhhdCBkb2VzIG1pcnJvcmluZyBpbiBhIHNlcGFy
YXRlIFZNQS4NCldlIGNyZWF0ZSBhbiBleHRyYSBWTUEgd2l0aCBWTV9QRk5NQVAvVk1fTUlYRURN
QVAgdGhhdCBtaXJyb3JzIHRoZSANCnNvdXJjZSBWTUEgaW4gdGhlIG90aGVyIFFFTVUgYW5kIGlz
IHJlZnJlc2hlZCBieSB0aGUgZGV2aWNlIE1NVSBub3RpZmllci4NCg0KVGhpcyBpcyBhIHNpbXBs
ZSBjaG9pY2UgZm9yIGFuIGludHJvc3BlY3RvciBwcm9jZXNzIHRoYXQgcnVucyBvbiB0aGUgc2Ft
ZSBob3N0IA0KYXMgdGhlIHNvdXJjZSBRRU1VLiBCdXQgaG93IGRvIEkgbWFrZSB0aGUgbmV3IFZN
QSBhY2Nlc3NpYmxlIGFzIG1lbW9yeSANCnRvIHRoZSBndWVzdCBWTSBpbnNpZGUgdGhlIGludHJv
c3BlY3RvciBRRU1VPyBJIHdhcyB0aGlua2luZyBvZiAyIHNvbHV0aW9uczoNCg0KQ3JlYXRlIGEg
bmV3IG1lbXNsb3QgYmFzZWQgb24gdGhlIG1pcnJvciBWTUEsIGhvdHBsdWcgaXQgaW50byB0aGUg
Z3Vlc3QgYXMNCm5ldyBtZW1vcnkgZGV2aWNlIChpcyB0aGlzIHBvc3NpYmxlPykgYW5kIGhhdmUg
YSBndWVzdC1zaWRlIGRyaXZlciBhbGxvY2F0ZSANCnBhZ2VzIGZyb20gdGhhdCBhcmVhLg0KDQpv
cg0KDQpSZWRpcmVjdCAoc29tZSkgR0ZOLT5IVkEgdHJhbnNsYXRpb25zIGludG8gdGhlIG5ldyBW
TUEgYmFzZWQgb24gYSB0YWJsZSANCm9mIGFkZHJlc3NlcyByZXF1aXJlZCBieSB0aGUgaW50cm9z
cGVjdG9yIHByb2Nlc3MuDQoNCk1pcmNlYQ0K

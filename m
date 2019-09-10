Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E2EAE4E3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 09:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfIJHt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 03:49:56 -0400
Received: from mail-eopbgr10091.outbound.protection.outlook.com ([40.107.1.91]:44102
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726716AbfIJHt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 03:49:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3Ep0OBxahAxUixdpLP+oCXy4SkUZviz/jEElVhnrfqrrk/U2+8qyBYMmN0L/Tw+eNg4yfLeuUX3/vQj+nBARRUUotTF35NJUHAL/P+X0+/6dGBZEJIEEchc8fITWgqEXaoC3t0y6ynTlixgrv4GkssNE1Mw60n7oip733Kpb39batPGAeoGZxiZ/qwv53ck6lMsbfqeXrNYUomNYyOKSQUDIBhwz8fLWxZgxOvl/LoIX5ReNAZITsheetdmh4Mg1mSxSK/zs/LYL3LtF5PUJkcl5IBbmQBUQDJ2QpHhQNuW4XBj0N6jmVXRFjhS4fTPRTLPWTCTKmkGRW7IQQ/bAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASETWczpefwet6aunu87Wv9waZJEk4Wclhfh8inzY9k=;
 b=Q8qirSqAp8q9gnCGaOxF6Q2VXk3byz6xQDP5GBtx/XRdxei+l7Ybe0y/NQ5dQ9y2ht8oZ3xH5FyGy8lHpbdMfFXDELXIe2jyAPIRFjdUOpObBayO1+OrOQxiHXhrqKV8oib7O6ki5UmXURpTZKtciCzUgVX7SHQNuUCgsnYyjIboxg1/fbPX6QbZJ7L3OuH4aR9xBcToLIe0vY5dkzOpyaW9w0T2tR+Vb84mNNEvFUQ19Fhxzx95dnz9Vdww3W6zWsXOZJJZECp7pK/o3F+iS55+xL+V0Ndq7Zb4sq8M+dSxUV2CazMvD+3jbfYcbqoBPR/+NLWf6WMtQ3SAjsM4ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bitdefender.com; dmarc=pass action=none
 header.from=bitdefender.com; dkim=pass header.d=bitdefender.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bitdefender.onmicrosoft.com; s=selector2-bitdefender-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASETWczpefwet6aunu87Wv9waZJEk4Wclhfh8inzY9k=;
 b=lQQbIR4kjg/h/+TWX/KRvmbObAI6dk6HJHuypOY84odYIf+pUbo8ruXySxks++/5JoA8dZuCUMPaJwL1Ml/rAoCb8srbnUcOeF6khj/M6Cg23+6CTriPlj6MPCKIRu1UtMFwT7j62TXVmZnrg5VL6VMUgkCdj8Nr9dbQU9clA5g=
Received: from DB7PR02MB3979.eurprd02.prod.outlook.com (20.177.121.157) by
 DB7PR02MB4744.eurprd02.prod.outlook.com (20.177.192.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 07:49:51 +0000
Received: from DB7PR02MB3979.eurprd02.prod.outlook.com
 ([fe80::a9d4:6e4d:dca:97a7]) by DB7PR02MB3979.eurprd02.prod.outlook.com
 ([fe80::a9d4:6e4d:dca:97a7%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 07:49:51 +0000
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
Thread-Index: AQHVTs8soTQpQXiOD0KEAgMKguVJzKb471OAgAOvxoCAAA/uAIAMAODggBTcuICABjXSgIAA6j0w
Date:   Tue, 10 Sep 2019 07:49:51 +0000
Message-ID: <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
 <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
 <20190815191929.GA9253@redhat.com> <20190815201630.GA25517@redhat.com>
 <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
 <20190905180955.GA3251@redhat.com>
 <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
In-Reply-To: <5b0966de-b690-fb7b-5a72-bc7906459168@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mcirjaliu@bitdefender.com; 
x-originating-ip: [91.199.104.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 258488b6-e5ca-4f01-0064-08d735c37674
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB7PR02MB4744;
x-ms-traffictypediagnostic: DB7PR02MB4744:|DB7PR02MB4744:|DB7PR02MB4744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR02MB4744D110DFB6D71DAC1B9FC1BBB60@DB7PR02MB4744.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(366004)(39860400002)(396003)(199004)(189003)(99286004)(4326008)(53936002)(6246003)(55016002)(9686003)(7696005)(76176011)(86362001)(107886003)(66556008)(64756008)(66446008)(66946007)(6436002)(66476007)(110136005)(316002)(5660300002)(54906003)(3846002)(6116002)(478600001)(305945005)(66066001)(74316002)(14444005)(33656002)(6506007)(53546011)(2906002)(14454004)(7416002)(71200400001)(7736002)(71190400001)(81156014)(186003)(81166006)(26005)(8676002)(8936002)(102836004)(25786009)(76116006)(52536014)(229853002)(256004)(486006)(476003)(446003)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB7PR02MB4744;H:DB7PR02MB3979.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bitdefender.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4UoWRl3lVzjSa2PwmsFoUyNqAv7Cp6QUshLxr/fOkrPJW4KvLF7SKURzdcI71zBNjvrTJV/Ckl236D90HJBffp2y8aFZdG7cSE8er8NUZ1gtEkBXa7RXPhoY1XoJEeiqc7iy+pXvDYVuk46wp0N6j1LS/eZ9UYoOXhdkucZbsLMS4nfMKK9psKkWuMZaMvlcGA8TW78WnyZ/wTV+vfwqAT+IWn8s00JhvkeGQ9ZPYs8mnLxY0zvECMk1x4wev3pU6evH/ARAg/QQSu8nU3iJw6G1OdUSYO9kSA7zHkEJms+5Nc1mMYyRkrn+SNcS/b/6Nkn+ZcuC1tc2Bk00YY7F+J6hpZcYDB9JYctYdItDiBVVCCLJHJlfoYi2qU9v+otL5xtFlfo+Uw12Co8WDvN7HLrNdQc2z65woz6ggee2UCs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bitdefender.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258488b6-e5ca-4f01-0064-08d735c37674
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 07:49:51.6724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 487baf29-f1da-469a-9221-243f830c36f3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t9in6MLiGE7e2+GD9/OEIkYZBTOTcsSHgEi9BQSCDi1e30PyuTFK0w/OZ5p5KmLQBWazSSF9b63c+ta3bfq3+78cTwUv+bLwwkjxZZn5KwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR02MB4744
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAwNS8wOS8xOSAyMDowOSwgSmVyb21lIEdsaXNzZSB3cm90ZToNCj4gPiBOb3Qgc3VyZSBp
IHVuZGVyc3RhbmQsIHlvdSBhcmUgc2F5aW5nIHRoYXQgdGhlIHNvbHV0aW9uIGkgb3V0bGluZQ0K
PiA+IGFib3ZlIGRvZXMgbm90IHdvcmsgPyBJZiBzbyB0aGVuIGkgdGhpbmsgeW91IGFyZSB3cm9u
ZywgaW4gdGhlIGFib3ZlDQo+ID4gc29sdXRpb24gdGhlIGltcG9ydGluZyBwcm9jZXNzIG1tYXAg
YSBkZXZpY2UgZmlsZSBhbmQgdGhlIHJlc3VsdGluZw0KPiA+IHZtYSBpcyB0aGVuIHBvcHVsYXRl
ZCB1c2luZyBpbnNlcnRfcGZuKCkgYW5kIGNvbnN0YW50bHkga2VlcA0KPiA+IHN5bmNocm9uaXpl
IHdpdGggdGhlIHRhcmdldCBwcm9jZXNzIHRocm91Z2ggbWlycm9yaW5nIHdoaWNoIG1lYW5zIHRo
YXQNCj4gPiB5b3UgbmV2ZXIgaGF2ZSB0byBsb29rIGF0IHRoZSBzdHJ1Y3QgcGFnZSAuLi4geW91
IGNhbiBtaXJyb3IgYW55IGtpbmQNCj4gPiBvZiBtZW1vcnkgZnJvbSB0aGUgcmVtb3RlIHByb2Nl
c3MuDQo+IA0KPiBJZiBpbnNlcnRfcGZuIGluIHR1cm4gY2FsbHMgTU1VIG5vdGlmaWVycyBmb3Ig
dGhlIHRhcmdldCBWTUEgKHdoaWNoIHdvdWxkIGJlDQo+IHRoZSBLVk0gTU1VIG5vdGlmaWVyKSwg
dGhlbiB0aGF0IHdvdWxkIHdvcmsuICBUaG91Z2ggSSBndWVzcyBpdCB3b3VsZCBiZQ0KPiBwb3Nz
aWJsZSB0byBjYWxsIE1NVSBub3RpZmllciB1cGRhdGUgY2FsbGJhY2tzIGFyb3VuZCB0aGUgY2Fs
bCB0byBpbnNlcnRfcGZuLg0KDQpDYW4ndCBkbyB0aGF0Lg0KRmlyc3QsIGluc2VydF9wZm4oKSB1
c2VzIHNldF9wdGVfYXQoKSB3aGljaCB3b24ndCB0cmlnZ2VyIHRoZSBNTVUgbm90aWZpZXIgb24N
CnRoZSB0YXJnZXQgVk1BLiBJdCdzIGFsc28gc3RhdGljLCBzbyBJJ2xsIGhhdmUgdG8gYWNjZXNz
IGl0IHRocnUgdm1mX2luc2VydF9wZm4oKQ0Kb3Igdm1mX2luc2VydF9taXhlZCgpLg0KDQpPdXIg
bW9kZWwgKHRoZSBpbXBvcnRpbmcgcHJvY2VzcyBpcyBlbmNhcHN1bGF0ZWQgaW4gYW5vdGhlciBW
TSkgZm9yY2VzIHVzDQp0byBtaXJyb3IgY2VydGFpbiBwYWdlcyBmcm9tIHRoZSBhbm9uIFZNQSBi
YWNraW5nIG9uZSBWTSdzIHN5c3RlbSBSQU0gdG8gDQp0aGUgb3RoZXIgVk0ncyBhbm9uIFZNQS4g
DQoNClVzaW5nIHRoZSBmdW5jdGlvbnMgYWJvdmUgbWVhbnMgc2V0dGluZyBWTV9QRk5NQVB8Vk1f
TUlYRURNQVAgb24gDQp0aGUgdGFyZ2V0IGFub24gVk1BLCBidXQgSSBndWVzcyB0aGlzIGJyZWFr
cyB0aGUgVk1BLiBJcyB0aGlzIHJlY29tbWVuZGVkPw0KDQpUaGVuLCBtYXBwaW5nIGFub24gcGFn
ZXMgZnJvbSBvbmUgVk1BIHRvIGFub3RoZXIgd2l0aG91dCBmaXhpbmcgdGhlIA0KcmVmY291bnQg
YW5kIHRoZSBtYXBjb3VudCBicmVha3MgdGhlIGRhZW1vbnMgdGhhdCB0aGluayB0aGV5J3JlIHdv
cmtpbmcgDQpvbiBhIHB1cmUgYW5vbiBWTUEgKGtjb21wYWN0ZCwga2h1Z2VwYWdlZCkuDQoNCk1p
cmNlYQ0K

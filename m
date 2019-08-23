Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB389AFC6
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 14:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388363AbfHWMj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 08:39:29 -0400
Received: from mail-eopbgr10129.outbound.protection.outlook.com ([40.107.1.129]:28993
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731709AbfHWMj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 08:39:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8QdPGNrifsMJGEgOIU0nVeFJSt82zjKi27gcTKmWuKsvZ0JnudmJWzzd1F2e1zmOKfqLykp7by/2T2iTAQt1ZohgvG237AkvXtn5SP8v4ftwIH7ORBDsiCrbpsWxlSJGVhh6rRXQHPJ+GIpCFklTukOLZYLCHqDF9IeEv90RGQWwRH00b8ver4sVCSGXDYXnid+mGrLemaWPQJ3o/Lu2N1WvJ+4H7IDGXMOorL6UUxdcTwNqCrCeGaHp0A86cdLD/zJyySBmOyW6XbeJTeNjtKKcltfFHOYaff7j4RcbvOa7IeRzmtXoV5TeTBrFO9AYLoQAg4gGISVpLVsgnAs9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOrWAl+puiYulIwKcUdj+QGeMze8NCRfGcGJpExpCm8=;
 b=ec3rr9nv/afCbBsu3yhPWuc2UXqpO1Hpn6lX46/S/26paHpQd8cRLUV8ob5fJYIAtxAJgGkTG3/objmlQOwWFc9UishFJrQeqkQ3e3H8eSdWkZnWogt2C9hoiNqCXiZDO1CDZ2oifxTWh+FyogJpxFK/iKutfi9jQTms+wqDHwXP2JudvXYKnT8r06wPJQij+ecrRLzSkjOkxhdqR5aenVYhTEKDXpyk/xocSASq4enGUqA5Ey70J+dpu4W3V08Vv+QDhMv54VQpHLBiviBu/bzuO+VcEeLdNQBxhg8WCKQRC+1AhWkwob2cIy73Y3umNQhwAF8qlJE2dxvb9dTEQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bitdefender.com; dmarc=pass action=none
 header.from=bitdefender.com; dkim=pass header.d=bitdefender.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bitdefender.onmicrosoft.com; s=selector2-bitdefender-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOrWAl+puiYulIwKcUdj+QGeMze8NCRfGcGJpExpCm8=;
 b=JyrEymlkXizEQwer07me0rQOkbF3VGJ97C+aMJ1pukpT1jriyyhI1hHiU2dDC44gWghXDN00gDKgsqXLOLlwuJeX+ZOpbU7BURlv2yIdBaQ3F5ME8xe48IYngmWvvCmBbhy1SdOipcXmlGiKMsnfh75bYyNNbQeTyGt4DQiX8YM=
Received: from VI1PR02MB3984.eurprd02.prod.outlook.com (20.177.58.97) by
 VI1PR02MB3888.eurprd02.prod.outlook.com (52.134.25.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 23 Aug 2019 12:39:22 +0000
Received: from VI1PR02MB3984.eurprd02.prod.outlook.com
 ([fe80::952d:f2ef:cc90:fd7b]) by VI1PR02MB3984.eurprd02.prod.outlook.com
 ([fe80::952d:f2ef:cc90:fd7b%5]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 12:39:21 +0000
From:   Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>
To:     Jerome Glisse <jglisse@redhat.com>,
        =?utf-8?B?QWRhbGJlcnQgTGF6xINy?= <alazar@bitdefender.com>
CC:     Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Thread-Index: AQHVTs8soTQpQXiOD0KEAgMKguVJzKb471OAgAOvxoCAAA/uAIAMAODg
Date:   Fri, 23 Aug 2019 12:39:21 +0000
Message-ID: <VI1PR02MB398411CA9A56081FF4D1248EBBA40@VI1PR02MB3984.eurprd02.prod.outlook.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
 <1565694095.D172a51.28640.@15f23d3a749365d981e968181cce585d2dcb3ffa>
 <20190815191929.GA9253@redhat.com> <20190815201630.GA25517@redhat.com>
In-Reply-To: <20190815201630.GA25517@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mcirjaliu@bitdefender.com; 
x-originating-ip: [91.199.104.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a98a0a50-e735-440d-8f09-08d727c6ec60
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR02MB3888;
x-ms-traffictypediagnostic: VI1PR02MB3888:|VI1PR02MB3888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR02MB3888C939D5E68820A02A8A74BBA40@VI1PR02MB3888.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(39860400002)(346002)(366004)(199004)(189003)(76176011)(229853002)(110136005)(53936002)(71190400001)(71200400001)(14454004)(305945005)(86362001)(6246003)(7736002)(107886003)(25786009)(74316002)(6636002)(2906002)(14444005)(256004)(66066001)(5660300002)(6116002)(3846002)(33656002)(54906003)(66574012)(7416002)(316002)(66476007)(66946007)(186003)(66446008)(64756008)(66556008)(52536014)(4326008)(476003)(76116006)(486006)(446003)(11346002)(26005)(81166006)(99286004)(8676002)(81156014)(102836004)(6506007)(6436002)(55016002)(7696005)(9686003)(8936002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR02MB3888;H:VI1PR02MB3984.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: bitdefender.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nNG+XVj/Yra7okDoqQ/RkEUqtXAD0kb1r1NP9eOqrAAZkhzj69G5sv/apx8YWV8sxnmwqvlcYCGCRiCEcA9VK07gMIJvXSlMj8+gh2O/Mgx9YeZ68AN13l3aRuW8lNY0YEHeX8CdbCzYxutyWo9IMAZYXS0BlWc+88037SU+/g4I6QzoN0nFJjd+A6wTl0KzMqnND31kd80ajtp2lQKWC3gsNBjHRCKVLYdKU3fa4tyGZwe+tAFNlQ4QSpsBzS6GvkOnSajBHuchOfUbnU7GT1LqsvgnRTUOLRz893lzA9L5LF8X1QCOq08OV0IOnQQsWG8jRnyd1AXkW+GHoWDH0pVClelnjUV7Dc+15Ilk46kBG6hMkY4DXnxQ2kfEG2uLQk0QRY70a8IL1POITikUIFQCBeue8TPePBHfjOrDo5w=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bitdefender.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98a0a50-e735-440d-8f09-08d727c6ec60
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 12:39:21.6597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 487baf29-f1da-469a-9221-243f830c36f3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fNZYcyFg+gNnmR52t5/IadYlY4MLnFFolGrlTXaF0SSLSVtrF2fFBpyN+k2lya5JR4udeCkRdckLwG4cXr6E/nZkclocqJ2hRyDm8V1Qzes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR02MB3888
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBUaHUsIEF1ZyAxNSwgMjAxOSBhdCAwMzoxOToyOVBNIC0wNDAwLCBKZXJvbWUgR2xpc3Nl
IHdyb3RlOg0KPiA+IE9uIFR1ZSwgQXVnIDEzLCAyMDE5IGF0IDAyOjAxOjM1UE0gKzAzMDAsIEFk
YWxiZXJ0IExhesSDciB3cm90ZToNCj4gPiA+IE9uIEZyaSwgOSBBdWcgMjAxOSAwOToyNDo0NCAt
MDcwMCwgTWF0dGhldyBXaWxjb3ggPHdpbGx5QGluZnJhZGVhZC5vcmc+DQo+IHdyb3RlOg0KPiA+
ID4gPiBPbiBGcmksIEF1ZyAwOSwgMjAxOSBhdCAwNzowMDoyNlBNICswMzAwLCBBZGFsYmVydCBM
YXrEg3Igd3JvdGU6DQo+ID4gPiA+ID4gKysrIGIvaW5jbHVkZS9saW51eC9wYWdlLWZsYWdzLmgN
Cj4gPiA+ID4gPiBAQCAtNDE3LDggKzQxNywxMCBAQCBQQUdFRkxBRyhJZGxlLCBpZGxlLCBQRl9B
TlkpDQo+ID4gPiA+ID4gICAqLw0KPiA+ID4gPiA+ICAjZGVmaW5lIFBBR0VfTUFQUElOR19BTk9O
CTB4MQ0KPiA+ID4gPiA+ICAjZGVmaW5lIFBBR0VfTUFQUElOR19NT1ZBQkxFCTB4Mg0KPiA+ID4g
PiA+ICsjZGVmaW5lIFBBR0VfTUFQUElOR19SRU1PVEUJMHg0DQo+ID4gPiA+DQo+ID4gPiA+IFVo
LiAgSG93IGRvIHlvdSBrbm93IHBhZ2UtPm1hcHBpbmcgd291bGQgb3RoZXJ3aXNlIGhhdmUgYml0
IDINCj4gY2xlYXI/DQo+ID4gPiA+IFdobydzIGd1YXJhbnRlZWluZyB0aGF0Pw0KPiA+ID4gPg0K
PiA+ID4gPiBUaGlzIGlzIGFuIGF3ZnVsbHkgYmlnIHBhdGNoIHRvIHRoZSBtZW1vcnkgbWFuYWdl
bWVudCBjb2RlLCBidXJpZWQNCj4gPiA+ID4gaW4gdGhlIG1pZGRsZSBvZiBhIGdpZ2FudGljIHNl
cmllcyB3aGljaCBhbG1vc3QgZ3VhcmFudGVlcyBub2JvZHkNCj4gPiA+ID4gd291bGQgbG9vayBh
dCBpdC4gIEkgY2FsbCBzaGVuYW5pZ2Fucy4NCj4gPiA+ID4NCj4gPiA+ID4gPiBAQCAtMTAyMSw3
ICsxMDIyLDcgQEAgdm9pZCBwYWdlX21vdmVfYW5vbl9ybWFwKHN0cnVjdCBwYWdlDQo+ICpwYWdl
LCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkNCj4gPiA+ID4gPiAgICogX19wYWdlX3NldF9h
bm9uX3JtYXAgLSBzZXQgdXAgbmV3IGFub255bW91cyBybWFwDQo+ID4gPiA+ID4gICAqIEBwYWdl
OglQYWdlIG9yIEh1Z2VwYWdlIHRvIGFkZCB0byBybWFwDQo+ID4gPiA+ID4gICAqIEB2bWE6CVZN
IGFyZWEgdG8gYWRkIHBhZ2UgdG8uDQo+ID4gPiA+ID4gLSAqIEBhZGRyZXNzOglVc2VyIHZpcnR1
YWwgYWRkcmVzcyBvZiB0aGUgbWFwcGluZw0KPiA+ID4gPiA+ICsgKiBAYWRkcmVzczoJVXNlciB2
aXJ0dWFsIGFkZHJlc3Mgb2YgdGhlIG1hcHBpbmcNCj4gPiA+ID4NCj4gPiA+ID4gQW5kIG1peGlu
ZyBpbiBmbHVmZiBjaGFuZ2VzIGxpa2UgdGhpcyBpcyBhIHJlYWwgbm8tbm8uICBUcnkgYWdhaW4u
DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gTm8gYmFkIGludGVudGlvbnMsIGp1c3Qgb3ZlcnplYWxv
dXMuDQo+ID4gPiBJIGRpZG4ndCB3YW50IHRvIGhpZGUgYW55dGhpbmcgZnJvbSBvdXIgcGF0Y2hl
cy4NCj4gPiA+IE9uY2Ugd2UgYWR2YW5jZSB3aXRoIHRoZSBpbnRyb3NwZWN0aW9uIHBhdGNoZXMg
cmVsYXRlZCB0byBLVk0gd2UnbGwNCj4gPiA+IGJlIGJhY2sgd2l0aCB0aGUgcmVtb3RlIG1hcHBp
bmcgcGF0Y2gsIHNwbGl0IGFuZCBjbGVhbmVkLg0KPiA+DQo+ID4gVGhleSBhcmUgbm90IGJpdCBs
ZWZ0IGluIHN0cnVjdCBwYWdlICEgTG9va2luZyBhdCB0aGUgcGF0Y2ggaXQgc2VlbXMNCj4gPiB5
b3Ugd2FudCB0byBoYXZlIHlvdXIgb3duIHBpbiBjb3VudCBqdXN0IGZvciBLVk0uIFRoaXMgaXMg
YmFkLCB3ZSBhcmUNCj4gPiBhbHJlYWR5IHRyeWluZyB0byBzb2x2ZSB0aGUgR1VQIHRoaW5nIChz
ZWUgYWxsIHZhcmlvdXMgcGF0Y2hzZXQgYWJvdXQNCj4gPiBHVVAgcG9zdGVkIHJlY2VudGx5KS4N
Cj4gPg0KPiA+IFlvdSBuZWVkIHRvIHJldGhpbmsgaG93IHlvdSB3YW50IHRvIGFjaGlldmUgdGhp
cy4gV2h5IG5vdCBzaW1wbHkgYQ0KPiA+IHJlbW90ZSByZWFkKCkvd3JpdGUoKSBpbnRvIHRoZSBw
cm9jZXNzIG1lbW9yeSBpZSBLVk1JIHdvdWxkIGNhbGwgYW4NCj4gPiBpb2N0bCB0aGF0IGFsbG93
IHRvIHJlYWQgb3Igd3JpdGUgaW50byBhIHJlbW90ZSBwcm9jZXNzIG1lbW9yeSBsaWtlDQo+ID4g
cHRyYWNlKCkgYnV0IG9uIHN0ZXJvaWQgLi4uDQo+ID4NCj4gPiBBZGRpbmcgdGhpcyB3aG9sZSBi
aWcgY29tcGxleCBpbmZyYXN0cnVjdHVyZSB3aXRob3V0IGp1c3RpZmljYXRpb24gb2YNCj4gPiB3
aHkgd2UgbmVlZCB0byBhdm9pZCByb3VuZCB0cmlwIGlzIGp1c3QgdG9vIG11Y2ggcmVhbGx5Lg0K
PiANCj4gVGhpbmtpbmcgYSBiaXQgbW9yZSBhYm91dCB0aGlzLCB5b3UgY2FuIGFjaGlldmUgdGhl
IHNhbWUgdGhpbmcgd2l0aG91dA0KPiBhZGRpbmcgYSBzaW5nbGUgbGluZSB0byBhbnkgbW0gY29k
ZS4gSW5zdGVhZCBvZiBoYXZpbmcgbW1hcCB3aXRoDQo+IFBST1RfTk9ORSB8IE1BUF9MT0NLRUQg
eW91IGhhdmUgdXNlcnNwYWNlIG1tYXAgc29tZSBrdm0gZGV2aWNlDQo+IGZpbGUgKGkgYW0gYXNz
dW1pbmcgdGhpcyBpcyBzb21ldGhpbmcgeW91IGFscmVhZHkgaGF2ZSBhbmQgY2FuIGNvbnRyb2wg
dGhlDQo+IG1tYXAgY2FsbGJhY2spLg0KPiANCj4gU28gbm93IGtlcm5lbCBzaWRlIHlvdSBoYXZl
IGEgdm1hIHdpdGggYSB2bV9vcGVyYXRpb25zX3N0cnVjdCB1bmRlciB5b3VyDQo+IGNvbnRyb2wg
dGhpcyBtZWFucyB0aGF0IGV2ZXJ5dGhpbmcgeW91IHdhbnQgdG8gYmxvY2sgbW0gd2lzZSBmcm9t
IHdpdGhpbg0KPiB0aGUgaW5zcGVjdG9yIHByb2Nlc3MgY2FuIGJlIGJsb2NrIHRocm91Z2ggdGhv
c2UgY2FsbC0gYmFja3MNCj4gKGZpbmRfc3BlY2lhbF9wYWdlKCkgc3BlY2lmaWNhbHkgZm9yIHdo
aWNoIHlvdSBoYXZlIHRvIHJldHVybiBOVUxMIGFsbCB0aGUNCj4gdGltZSkuDQo+IA0KPiBUbyBt
aXJyb3IgdGFyZ2V0IHByb2Nlc3MgbWVtb3J5IHlvdSBjYW4gdXNlIGhtbV9taXJyb3IsIHdoZW4g
eW91DQo+IHBvcHVsYXRlIHRoZSBpbnNwZWN0b3IgcHJvY2VzcyBwYWdlIHRhYmxlIHlvdSB1c2Ug
aW5zZXJ0X3BmbigpIChtbWFwIG9mDQo+IHRoZSBrdm0gZGV2aWNlIGZpbGUgbXVzdCBtYXJrIHRo
aXMgdm1hIGFzIFBGTk1BUCkuDQo+IA0KPiBCeSBmb2xsb3dpbmcgdGhlIGhtbV9taXJyb3IgQVBJ
LCBhbnl0aW1lIHRoZSB0YXJnZXQgcHJvY2VzcyBoYXMgYSBjaGFuZ2UgaW4NCj4gaXRzIHBhZ2Ug
dGFibGUgKGllIHZpcnR1YWwgYWRkcmVzcyAtPiBwYWdlKSB5b3Ugd2lsbCBnZXQgYSBjYWxsYmFj
ayBhbmQgYWxsIHlvdQ0KPiBoYXZlIHRvIGRvIGlzIGNsZWFyIHRoZSBwYWdlIHRhYmxlIHdpdGhp
biB0aGUgaW5zcGVjdG9yIHByb2Nlc3MgYW5kIGZsdXNoIHRsYg0KPiAodXNlIHphcF9wYWdlX3Jh
bmdlKS4NCj4gDQo+IE9uIHBhZ2UgZmF1bHQgd2l0aGluIHRoZSBpbnNwZWN0b3IgcHJvY2VzcyB0
aGUgZmF1bHQgY2FsbGJhY2sgb2Ygdm1fb3BzIHdpbGwNCj4gZ2V0IGNhbGwgYW5kIGZyb20gdGhl
cmUgeW91IGNhbGwgaG1tX21pcnJvciBmb2xsb3dpbmcgaXRzIEFQSS4NCj4gDQo+IE9oIGFsc28g
bWFyayB0aGUgdm1hIHdpdGggVk1fV0lQRU9ORk9SSyB0byBhdm9pZCBhbnkgaXNzdWUgaWYgdGhl
DQo+IGluc3BlY3RvciBwcm9jZXNzIHVzZSBmb3JrKCkgKHlvdSBjb3VsZCBzdXBwb3J0IGZvcmsg
YnV0IHRoZW4geW91IHdvdWxkDQo+IG5lZWQgdG8gbWFyayB0aGUgdm1hIGFzIFNIQVJFRCBhbmQg
dXNlIHVubWFwX21hcHBpbmdfcGFnZXMgaW5zdGVhZCBvZg0KPiB6YXBfcGFnZV9yYW5nZSkuDQo+
IA0KPiANCj4gVGhlcmUgZXZlcnl0aGluZyB5b3Ugd2FudCB0byBkbyB3aXRoIGFscmVhZHkgdXBz
dHJlYW0gbW0gY29kZS4NCg0KSSdtIHRoZSBhdXRob3Igb2YgcmVtb3RlIG1hcHBpbmcsIHNvIEkg
b3dlIGV2ZXJ5Ym9keSBzb21lIGV4cGxhbmF0aW9ucy4NCk15IHJlcXVpcmVtZW50IHdhcyB0byBt
YXAgcGFnZXMgZnJvbSBvbmUgUUVNVSBwcm9jZXNzIHRvIGFub3RoZXIgUUVNVSANCnByb2Nlc3Mg
KG91ciBpbnNwZWN0b3IgcHJvY2VzcyB3b3JrcyBpbiBhIHZpcnR1YWwgbWFjaGluZSBvZiBpdHMg
b3duKS4gU28gSSBoYWQgDQp0byBpbXBsZW1lbnQgYSBLU00tbGlrZSBwYWdlIHNoYXJpbmcgYmV0
d2VlbiBwcm9jZXNzZXMsIHdoZXJlIGFuIGFub24gcGFnZQ0KZnJvbSB0aGUgdGFyZ2V0IFFFTVUn
cyB3b3JraW5nIG1lbW9yeSBpcyBwcm9tb3RlZCB0byBhIHJlbW90ZSBwYWdlIGFuZCANCm1hcHBl
ZCBpbiB0aGUgaW5zcGVjdG9yIFFFTVUncyB3b3JraW5nIG1lbW9yeSAoYm90aCBhbm9uIFZNQXMp
LiANClRoZSBleHRyYSBwYWdlIGZsYWcgaXMgZm9yIGRpZmZlcmVudGlhdGluZyB0aGUgcGFnZSBm
b3Igcm1hcCB3YWxraW5nLg0KDQpUaGUgbWFwcGluZyByZXF1ZXN0cyBjb21lIGF0IFBBR0VfU0la
RSBncmFudWxhcml0eSBmb3IgcmFuZG9tIGFkZHJlc3NlcyANCndpdGhpbiB0aGUgdGFyZ2V0L2lu
c3BlY3RvciBRRU1Vcywgc28gSSBjb3VsZG4ndCBkbyBhbnkgbGluZWFyIG1hcHBpbmcgdGhhdA0K
d291bGQga2VlcCB0aGluZ3Mgc2ltcGxlci4gDQoNCkkgaGF2ZSBhbiBleHRyYSBwYXRjaCB0aGF0
IGRvZXMgcmVtb3RlIG1hcHBpbmcgYnkgbWlycm9yaW5nIGFuIGVudGlyZSBWTUENCmZyb20gdGhl
IHRhcmdldCBwcm9jZXNzIGJ5IHdheSBvZiBhIGRldmljZSBmaWxlLiBUaGlzIHRoaW5nIGNyZWF0
ZXMgYSBzZXBhcmF0ZSANCm1pcnJvciBWTUEgaW4gbXkgaW5zcGVjdG9yIHByb2Nlc3MgKGF0IHRo
ZSBtb21lbnQgYSBRRU1VKSwgYnV0IHRoZW4gSSANCmJ1bXBlZCBpbnRvIHRoZSBLVk0gaHZhLT5n
cGEgbWFwcGluZywgd2hpY2ggbWFrZXMgaXQgaGFyZCB0byBvdmVycmlkZSANCm1hcHBpbmdzIHdp
dGggYWRkcmVzc2VzIG91dHNpZGUgbWVtc2xvdCBhc3NvY2lhdGVkIFZNQXMuDQoNCk1pcmNlYQ0K

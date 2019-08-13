Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602C88BBB6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfHMOkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 10:40:07 -0400
Received: from mail-eopbgr70081.outbound.protection.outlook.com ([40.107.7.81]:46821
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728216AbfHMOkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 10:40:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgDsuiAhinQymZJGlMklWfL0+wXQNe3zciJgH2MINk8kuuai45/SyWA7s09id4xbwZK9QNHs1YPvQXQL0iFS41+FgegklzYxwc276upqwH7RoFtwAbgVWinR0xLZRiWrP8jNRtz2XfQo3THthWX/yTCZCngK6Wei//do7n+KWoyqUbHyoVjuSdEM/jlwkMOuu0bTvtUZ2/8iVK2hEdjFLN3iozmrWrk6/Fi4DNK6ltuJYAmqs2nHBLX67vUfARoLOcB7HqoNkk6+fGp/mnRuiu7Yil9ZpGZ/dk6XyJJg020P3I1hgpwIiUPcuuxijqAla02WHODbJUpCPJ1ZeUBf0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmxsXizD5N068+QNdWuJ9R//RXsMhRJp7sDtgHh4Ijc=;
 b=MddShll713RLHHomeDreVYfzPRLGEf9FWuhzFw6cQ3w8CGdyVCLEyZ9MaGElRKl2T+lNZaLLuEgsbAr24NAkw3XPdaoJlNIOMNh+7YE0dzccOngaiUoRc65YQJJPFDoqssNkKN3PXoHjTEgp8l5O+IPV9qIH/yNvIWz/MtMzk9+aEuihceBZNAvGuftWxJRu2bUG3t5LNx92OkSUNqiWsLo+DdIYSREKIHQ9/m5bCJzFUPogQw+dwzlNOYKxygwGaXmZVSeFh8aLsZfes/e3hTrp5elCjUFPXkLezGm/95zSNHEcjzgmYCVoJtr5Y7HFGl/wf8pUOetQBxW9ATMC2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmxsXizD5N068+QNdWuJ9R//RXsMhRJp7sDtgHh4Ijc=;
 b=VOI40xzhSVaUO6ZHG8+gvhImshMF342qu3oeUFx3TPaZP7LZJhO0Mja8EEtpChq9r7Jyoqv2vvwB+jI91KV8Kg8kPHRi/SlkZTu4x6m9DcMt1uq7syxjXYTIPr+zVH8yeKHk7hGb2U4p/Tosspn61oHg7nqriI15EK/N9+TFz5w=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4260.eurprd05.prod.outlook.com (52.134.91.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Tue, 13 Aug 2019 14:40:02 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 14:40:02 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEA==
Date:   Tue, 13 Aug 2019 14:40:02 +0000
Message-ID: <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
 <20190808141255.45236-1-parav@mellanox.com> <20190808170247.1fc2c4c4@x1.home>
 <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
In-Reply-To: <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fddcf63b-2e8a-4f97-b6fa-08d71ffc1fd4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4260;
x-ms-traffictypediagnostic: AM0PR05MB4260:
x-microsoft-antispam-prvs: <AM0PR05MB4260AD99AD24BA8ED46DCCC4D1D20@AM0PR05MB4260.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(13464003)(199004)(189003)(81156014)(66446008)(102836004)(6506007)(6246003)(53546011)(55236004)(26005)(74316002)(186003)(305945005)(76176011)(86362001)(53936002)(66946007)(66476007)(7696005)(64756008)(5660300002)(52536014)(81166006)(8676002)(7736002)(66556008)(14454004)(76116006)(55016002)(476003)(256004)(14444005)(4326008)(9686003)(478600001)(54906003)(110136005)(486006)(99286004)(316002)(6116002)(3846002)(11346002)(66066001)(2906002)(229853002)(9456002)(33656002)(25786009)(71200400001)(71190400001)(8936002)(6436002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4260;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4e/ydPjN5HX2iiIkTsre5zOnwOJinVa0yubGo4r3TytKAkpVx6hizT+b1xjwKBV+e9U2SolxkJmwwDslMjH4sGOuURM6bZ1AYNqFuFF4wyMyjY+bpToiY9XjRMyM/YbZEVsgnewNFf2jKsuXO/m76CTgGbAVXOYHhhi4gvYtDqHgTyZGjJ37xVM4N01feL6+nY3s0fO4gTbPUr+miW0f0M5NoSY2nY5esY6fMwdoe1ImR7Cmwn6KeYP7haYnpC2XNYml2VhzjYKX+GxpjYAM4R9axOyhZ1ODRs+mUU0V7eNHcb6ORuxpT3KEm5rNIRCiJO7Aj9tZJz6O5G3ZKpqhUypN0d6ivfO/6KO98jk5uPgovYPALTSXbZI4FBAS3NTF8gaVRPU+O96vZzsToH9xhd5WZqW0c2X0cSZosjyXHQE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddcf63b-2e8a-4f97-b6fa-08d71ffc1fd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 14:40:02.1358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ddNpxNLacAdddVyKBzIsQcTdMKo5Tyvoy1I03wQq8xe79UJmWYcigYt9UICszuJNjH8Lvsf9xlI3O5y6GkCglQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4260
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2lydGkgV2Fua2hlZGUg
PGt3YW5raGVkZUBudmlkaWEuY29tPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAxMiwgMjAxOSA1
OjA2IFBNDQo+IFRvOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29t
PjsgUGFyYXYgUGFuZGl0DQo+IDxwYXJhdkBtZWxsYW5veC5jb20+DQo+IENjOiBrdm1Admdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBjb2h1Y2tAcmVkaGF0LmNv
bTsNCj4gY2ppYUBudmlkaWEuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMC8yXSBTaW1w
bGlmeSBtdHR5IGRyaXZlciBhbmQgbWRldiBjb3JlDQo+IA0KPiANCj4gDQo+IE9uIDgvOS8yMDE5
IDQ6MzIgQU0sIEFsZXggV2lsbGlhbXNvbiB3cm90ZToNCj4gPiBPbiBUaHUsICA4IEF1ZyAyMDE5
IDA5OjEyOjUzIC0wNTAwDQo+ID4gUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+IHdy
b3RlOg0KPiA+DQo+ID4+IEN1cnJlbnRseSBtdHR5IHNhbXBsZSBkcml2ZXIgdXNlcyBtZGV2IHN0
YXRlIGFuZCBVVUlEIGluIGNvbnZvbHVhdGVkDQo+ID4+IHdheSB0byBnZW5lcmF0ZSBhbiBpbnRl
cnJ1cHQuDQo+ID4+IEl0IHVzZXMgc2V2ZXJhbCB0cmFuc2xhdGlvbnMgZnJvbSBtZGV2X3N0YXRl
IHRvIG1kZXZfZGV2aWNlIHRvIG1kZXYgdXVpZC4NCj4gPj4gQWZ0ZXIgd2hpY2ggaXQgZG9lcyBs
aW5lYXIgc2VhcmNoIG9mIGxvbmcgdXVpZCBjb21wYXJpc2lvbiB0byBmaW5kDQo+ID4+IG91dCBt
ZGV2X3N0YXRlIGluIG10dHlfdHJpZ2dlcl9pbnRlcnJ1cHQoKS4NCj4gPj4gbWRldl9zdGF0ZSBp
cyBhbHJlYWR5IGF2YWlsYWJsZSB3aGlsZSBnZW5lcmF0aW5nIGludGVycnVwdCBmcm9tIHdoaWNo
DQo+ID4+IGFsbCBzdWNoIHRyYW5zbGF0aW9ucyBhcmUgZG9uZSB0byByZWFjaCBiYWNrIHRvIG1k
ZXZfc3RhdGUuDQo+ID4+DQo+ID4+IFRoaXMgdHJhbnNsYXRpb25zIGFyZSBkb25lIGR1cmluZyBp
bnRlcnJ1cHQgZ2VuZXJhdGlvbiBwYXRoLg0KPiA+PiBUaGlzIGlzIHVubmVjZXNzYXJ5IGFuZCBy
ZWR1YW5kYW50Lg0KPiA+DQo+ID4gSXMgdGhlIGludGVycnVwdCBoYW5kbGluZyBlZmZpY2llbmN5
IG9mIHRoaXMgcGFydGljdWxhciBzYW1wbGUgZHJpdmVyDQo+ID4gcmVhbGx5IHJlbGV2YW50LCBv
ciBpcyBpdHMgcHVycG9zZSBtb3JlIHRvIGlsbHVzdHJhdGUgdGhlIEFQSSBhbmQNCj4gPiBwcm92
aWRlIGEgcHJvb2Ygb2YgY29uY2VwdD8gIElmIHdlIGdvIHRvIHRoZSB0cm91YmxlIHRvIG9wdGlt
aXplIHRoZQ0KPiA+IHNhbXBsZSBkcml2ZXIgYW5kIHJlbW92ZSB0aGlzIGludGVyZmFjZSBmcm9t
IHRoZSBBUEksIHdoYXQgZG8gd2UgbG9zZT8NCj4gPg0KPiA+IFRoaXMgaW50ZXJmYWNlIHdhcyBh
ZGRlZCB2aWEgY29tbWl0Og0KPiA+DQo+ID4gOTllMzEyM2UzZDcyIHZmaW8tbWRldjogTWFrZSBt
ZGV2X2RldmljZSBwcml2YXRlIGFuZCBhYnN0cmFjdA0KPiA+IGludGVyZmFjZXMNCj4gPg0KPiA+
IFdoZXJlIHRoZSBnb2FsIHdhcyB0byBjcmVhdGUgYSBtb3JlIGZvcm1hbCBpbnRlcmZhY2UgYW5k
IGFic3RyYWN0DQo+ID4gZHJpdmVyIGFjY2VzcyB0byB0aGUgc3RydWN0IG1kZXZfZGV2aWNlLiAg
SW4gcGFydCB0aGlzIHNlcnZlZCB0byBtYWtlDQo+ID4gb3V0LW9mLXRyZWUgbWRldiB2ZW5kb3Ig
ZHJpdmVycyBtb3JlIHN1cHBvcnRhYmxlOyB0aGUgb2JqZWN0IGlzDQo+ID4gY29uc2lkZXJlZCBv
cGFxdWUgYW5kIGFjY2VzcyBpcyBwcm92aWRlZCB2aWEgYW4gQVBJIHJhdGhlciB0aGFuDQo+ID4g
dGhyb3VnaCBkaXJlY3Qgc3RydWN0dXJlIGZpZWxkcy4NCj4gPg0KPiA+IEkgYmVsaWV2ZSB0aGF0
IHRoZSBOVklESUEgR1JJRCBtZGV2IGRyaXZlciBkb2VzIG1ha2UgdXNlIG9mIHRoaXMNCj4gPiBp
bnRlcmZhY2UgYW5kIGl0J3MgbGlrZWx5IGluY2x1ZGVkIGluIHRoZSBzYW1wbGUgZHJpdmVyIHNw
ZWNpZmljYWxseQ0KPiA+IHNvIHRoYXQgdGhlcmUgaXMgYW4gaW4ta2VybmVsIHVzZXIgZm9yIGl0
IChpZS4gc3BlY2lmaWNhbGx5IHRvIGF2b2lkDQo+ID4gaXQgYmVpbmcgcmVtb3ZlZCBzbyBjYXN1
YWxseSkuICBBbiBpbnRlcmVzdGluZyBmZWF0dXJlIG9mIHRoZSBOVklESUENCj4gPiBtZGV2IGRy
aXZlciBpcyB0aGF0IEkgYmVsaWV2ZSBpdCBoYXMgcG9ydGlvbnMgdGhhdCBydW4gaW4gdXNlcnNw
YWNlLg0KPiA+IEFzIHdlIGtub3csIG1kZXZzIGFyZSBuYW1lZCB3aXRoIGEgVVVJRCwgc28gSSBj
YW4gaW1hZ2luZSB0aGVyZSBhcmUNCj4gPiBzb21lIGVmZmljaWVuY2llcyB0byBiZSBnYWluZWQg
aW4gaGF2aW5nIGRpcmVjdCBhY2Nlc3MgdG8gdGhlIFVVSUQgZm9yDQo+ID4gYSBkZXZpY2Ugd2hl
biBpbnRlcmFjdGluZyB3aXRoIHVzZXJzcGFjZSwgcmF0aGVyIHRoYW4gcmVwZWF0ZWRseQ0KPiA+
IHBhcnNpbmcgaXQgZnJvbSBhIGRldmljZSBuYW1lLg0KPiANCj4gVGhhdCdzIHJpZ2h0Lg0KPiAN
Cj4gPiAgSXMgdGhhdCByZWFsbHkgc29tZXRoaW5nIHdlIHdhbnQgdG8gbWFrZSBtb3JlIGRpZmZp
Y3VsdCBpbiBvcmRlciB0bw0KPiA+IG9wdGltaXplIGEgc2FtcGxlIGRyaXZlcj8gIEtub3dpbmcg
dGhhdCBhbiBtZGV2IGRldmljZSB1c2VzIGEgVVVJRCBmb3INCj4gPiBpdCdzIG5hbWUsIGFzIHRv
b2xzIGxpa2UgbGlidmlydCBhbmQgbWRldmN0bCBleHBlY3QsIGlzIGl0IHJlYWxseQ0KPiA+IHdv
cnRod2hpbGUgdG8gcmVtb3ZlIHN1Y2ggYSB0cml2aWFsIEFQST8NCj4gPg0KPiA+PiBIZW5jZSwN
Cj4gPj4gUGF0Y2gtMSBzaW1wbGlmaWVzIG10dHkgc2FtcGxlIGRyaXZlciB0byBkaXJlY3RseSB1
c2UgbWRldl9zdGF0ZS4NCj4gPj4NCj4gPj4gUGF0Y2gtMiwgU2luY2Ugbm8gcHJvZHVjdGlvbiBk
cml2ZXIgdXNlcyBtZGV2X3V1aWQoKSwgc2ltcGxpZmllcyBhbmQNCj4gPj4gcmVtb3ZlcyByZWRh
bmRhbnQgbWRldl91dWlkKCkgZXhwb3J0ZWQgc3ltYm9sLg0KPiA+DQo+ID4gcy9ubyBwcm9kdWN0
aW9uIGRyaXZlci9ubyBpbi1rZXJuZWwgcHJvZHVjdGlvbiBkcml2ZXIvDQo+ID4NCj4gPiBJJ2Qg
YmUgaW50ZXJlc3RlZCB0byBoZWFyIGhvdyB0aGUgTlZJRElBIGZvbGtzIG1ha2UgdXNlIG9mIHRo
aXMgQVBJDQo+ID4gaW50ZXJmYWNlLiAgVGhhbmtzLA0KPiA+DQo+IA0KPiBZZXMsIE5WSURJQSBt
ZGV2IGRyaXZlciBkbyB1c2UgdGhpcyBpbnRlcmZhY2UuIEkgZG9uJ3QgYWdyZWUgb24gcmVtb3Zp
bmcNCj4gbWRldl91dWlkKCkgaW50ZXJmYWNlLg0KPiANCldlIG5lZWQgdG8gYXNrIEdyZWcgb3Ig
TGludXMgb24gdGhlIGtlcm5lbCBwb2xpY3kgb24gd2hldGhlciBhbiBBUEkgc2hvdWxkIGV4aXN0
IHdpdGhvdXQgaW4ta2VybmVsIGRyaXZlci4NCldlIGRvbid0IGFkZCBzdWNoIEFQSSBpbiBuZXRk
ZXYsIHJkbWEgYW5kIHBvc3NpYmx5IG90aGVyIHN1YnN5c3RlbS4NCldoZXJlIGNhbiB3ZSBmaW5k
IHRoaXMgbWRldiBkcml2ZXIgaW4tdHJlZT8NCg==

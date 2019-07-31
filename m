Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E037B7DD
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 03:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfGaB4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 21:56:02 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:28543 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfGaB4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 21:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564538162; x=1596074162;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EzIkLL33VfiaDDUjvmHCkM+3WyciIBxzfLE+FrI2JX4=;
  b=RtWQBvR1+HnWanFvtxZpfnxAYXmvfZaRqPChGvbtkbnTAggdYSiIYWw2
   9ES8Axy7M0dqhezNAoarmQuZdIh33FWMGDGh0IAXUbjSA9OEZEjO0qxmz
   KK6axDxAAA/CErJ/K4ZO7l89lT9F8s33BwYsaJCoQaeN3fvcs82z1ufOG
   573XR2SKffECDlwqkHD3e2nOi+XynDryc+LV4nwKNJlebwJacNGZVlmIK
   0gudB4k5Srzi80UuiD1Nv40yIL/eV2FJ60LcTG43hAPe831ZGqii56sMJ
   R+JUqJbreMZfweXG+T5bcstOUq3nDmXs1rG+aQwfMffffH2F5DUZwFIMl
   Q==;
IronPort-SDR: 5N9bK50D871o+QHmPZCmTRj5VRV4GjVXnn+LZdnbqtND7tliUEEfhSBdeXaXbUFYKnU+iUyOTd
 fG9fBwOInGATVbFFVrXK6ot+ZNlN+Pu1ErQ8t6wo4wW/wqra/1hsr2HEmFo8b0fnvH/nUlSdtd
 CbyM6bZPMvuInPLcB5iJK+GB/NmXeiUzvrmJs3VqFC2pq/lf5JXM459IzO9otEqQCDpkVHti+H
 tAfZf28HDD/NE8DmOz2JQAVQz+EMuPEDwWr3y7zP/hR+RZhV7P2qFVhaG5ABhx294UO+lCFRED
 Oow=
X-IronPort-AV: E=Sophos;i="5.64,328,1559491200"; 
   d="scan'208";a="119220292"
Received: from mail-by2nam05lp2055.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.55])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2019 09:56:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uio0qAt1waLd5VdTbxaaawoBZF06vXoRu3l5aXqQiLzKkNBaZGcW8+gS8Ci0FT87P12yi3GnR85cPeHW+HZtVgrTyTIqxQiRXr1by/tzv6MRcH8SQ9bG6/1Be/D0mLlENa7lEiDPtkvvvsQLAlU0ta3NnIEJIUpdGr1sFTUma86oVAJPZ1shisWSKJI5bIecGG7LrOJAlLc9+zdrOhVHbOoE9tKsERXUBOxeY0bjvMTELEfZ2iYeApZQBRucW2wT3pfn7/7p5GTy+PE5nw4RaFchxLP8IIhu6jSQZTQWPupeGMw1QYU4SkjLSnmijx/pPbe/ipzp3yMUgWDNWQOFbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzIkLL33VfiaDDUjvmHCkM+3WyciIBxzfLE+FrI2JX4=;
 b=iVxOWkAYWb62vRgnj03mYg3l0/fO2BPKY46A8jELo5sOk/DrXCT9i3D92DpR2JNezC5Ows+riyiGeIhVYt/5+37U70jcvM2coX6vDPp5cWv4TsWmuhNNIBb3T1TYCMmGj+SWzc5pYi/Fy7IBzAWSZR8OkzqyAhbBcqV7MlZsWnSEJhLguGrn5RZZ75nDjMhxv2qlw9qv+fuIRt+Hz2/fbwiqvOEvRfLy0EZ/Z7tMUVJEY0vLQugB733ZZwNrhZgsjRp5SEyQ9L9eXw1Z7gEd3VZEJUywSoHHaDomDbGQXJ/d59/3yEqqFf8mWKfMQ+d8+B2XubLx181liGWmwbdcYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzIkLL33VfiaDDUjvmHCkM+3WyciIBxzfLE+FrI2JX4=;
 b=k/LjvsRiKrWv4YVOvVckmsmyiRjzQiOd+yGWgNWxVtgX1UEruFEWiF9TL6t9Qz3TMnQXFk/t2cjybsHiAhZuMoKBvC5QEeXYbWG7zljKSJhB8dEYkVeYoIvzMrh4S8oqblNLbM50uT5FVlM7TdhGDk566GUPiWMgsNhG2OOQYiM=
Received: from BYAPR04MB3782.namprd04.prod.outlook.com (52.135.214.142) by
 BYAPR04MB4598.namprd04.prod.outlook.com (52.135.238.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Wed, 31 Jul 2019 01:55:59 +0000
Received: from BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926]) by BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926%7]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 01:55:59 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "palmer@sifive.com" <palmer@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>
CC:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH 13/16] RISC-V: KVM: Add timer functionality
Thread-Topic: [RFC PATCH 13/16] RISC-V: KVM: Add timer functionality
Thread-Index: AQHVRgTUPAB7n90qAEyqoYXnGhI7+KbjB0QAgADy5IA=
Date:   Wed, 31 Jul 2019 01:55:59 +0000
Message-ID: <7fe9e845c33e49e4c215e12b1ee1b5ed86a95bc1.camel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
         <20190729115544.17895-14-anup.patel@wdc.com>
         <abedb067-b91f-8821-9bce-d27f6c4efdee@redhat.com>
In-Reply-To: <abedb067-b91f-8821-9bce-d27f6c4efdee@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Atish.Patra@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f3e1aa5-aacd-4351-0986-08d7155a3c37
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4598;
x-ms-traffictypediagnostic: BYAPR04MB4598:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BYAPR04MB45982766F9391E322B792EE7FADF0@BYAPR04MB4598.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(189003)(199004)(446003)(229853002)(110136005)(76176011)(476003)(11346002)(54906003)(2201001)(2616005)(71200400001)(316002)(8676002)(81156014)(7416002)(256004)(8936002)(7736002)(966005)(486006)(81166006)(6506007)(14454004)(66066001)(305945005)(53546011)(68736007)(5660300002)(6246003)(26005)(478600001)(71190400001)(3846002)(6116002)(6636002)(25786009)(6306002)(66946007)(53936002)(6512007)(118296001)(102836004)(186003)(86362001)(66476007)(4326008)(2501003)(36756003)(6486002)(2906002)(66446008)(64756008)(99286004)(76116006)(6436002)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4598;H:BYAPR04MB3782.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KBPg7aI1bItGwl35cvKVqoMbhvKSUDM9bqd8SXYB8fKJ+RHQD78/XUBqDY6ZyOAO5CJOfemG888MXplGdWxJ2+uy8RuXRz9jDPeK2csKuAWSFmceE828Du/GdlQ4RwD9XPwBtR0LFFrRPJF1KVdowvXkyQB4SX3peouFXT6ftg/1rDhiSL3tCKwPn1BRCZAYoQXGjiuu/sWrXO22oEpsmPPckQUBF805s74vwAHhM3ulPAuIIRJ0tDpAwLmLTSRtABou3BxMN3jscrzXzUdpABz+zo2hVSxj57n+lijF5X19vhdbbieP0LJyGkg99udfFiRcpomRPNx1bp0jL6QGqiH3m60DB+pJwAG4OqRFnqFaVTP/DuZFJJgJIxCLE2mRt8oE/vD1D82qU6ChfxopGkI6JgoaizV3G2iLcB2smOQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13B323065899E54CB3E7D3A54271A60D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3e1aa5-aacd-4351-0986-08d7155a3c37
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 01:55:59.6574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atish.Patra@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4598
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTMwIGF0IDEzOjI2ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAyOS8wNy8xOSAxMzo1NywgQW51cCBQYXRlbCB3cm90ZToNCj4gPiArCWlmIChkZWx0YV9u
cyA+IFZDUFVfVElNRVJfUFJPR1JBTV9USFJFU0hPTERfTlMpIHsNCj4gPiArCQlocnRpbWVyX3N0
YXJ0KCZ0LT5ocnQsIGt0aW1lX2FkZF9ucyhrdGltZV9nZXQoKSwNCj4gPiBkZWx0YV9ucyksDQo+
IA0KPiBJIHRoaW5rIHRoZSBndWVzdCB3b3VsZCBwcmVmZXIgaWYgeW91IHNhdmVkIHRoZSB0aW1l
IGJlZm9yZSBlbmFibGluZw0KPiBpbnRlcnJ1cHRzIG9uIHRoZSBob3N0LCBhbmQgdXNlIHRoYXQg
aGVyZSBpbnN0ZWFkIG9mIGt0aW1lX2dldCgpLg0KPiBPdGhlcndpc2UgdGhlIHRpbWVyIGNvdWxk
IGJlIGRlbGF5ZWQgYXJiaXRyYXJpbHkgYnkgaG9zdCBpbnRlcnJ1cHRzLg0KPiANCj4gKEJlY2F1
c2UgdGhlIFJJU0MtViBTQkkgdGltZXIgaXMgcmVsYXRpdmUgb25seS0tLXdoaWNoIGlzDQo+IHVu
Zm9ydHVuYXRlLS0tDQoNCkp1c3QgdG8gY2xhcmlmeTogUklTQy1WIFNCSSB0aW1lciBjYWxsIHBh
c3NlcyBhYnNvbHV0ZSB0aW1lLg0KDQpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92
NS4zLXJjMi9zb3VyY2UvZHJpdmVycy9jbG9ja3NvdXJjZS90aW1lci1yaXNjdi5jI0wzMg0KDQpU
aGF0J3Mgd2h5IHdlIGNvbXB1dGUgYSBkZWx0YSBiZXR3ZWVuIGFic29sdXRlIHRpbWUgcGFzc2Vk
IHZpYSBTQkkgYW5kDQpjdXJyZW50IHRpbWUuIGhydGltZXIgaXMgcHJvZ3JhbW1lZCB0byB0cmln
Z2VyIG9ubHkgYWZ0ZXIgdGhlIGRlbHRhDQp0aW1lIGZyb20gbm93Lg0KDQoNCj4gZ3Vlc3RzIHdp
bGwgYWxyZWFkeSBwYXkgYSBsYXRlbmN5IHByaWNlIGR1ZSB0byB0aGUgZXh0cmENCj4gY29zdCBv
ZiB0aGUgU0JJIGNhbGwgY29tcGFyZWQgdG8gYSBiYXJlIG1ldGFsIGltcGxlbWVudGF0aW9uLiAN
Cg0KWWVzLiBUaGVyZSBhcmUgb25nb2luZyBkaXNjdXNzaW9ucyB0byByZW1vdmUgdGhpcyBTQkkg
Y2FsbCBjb21wbGV0ZWx5LiANCkhvcGVmdWxseSwgdGhhdCB3aWxsIGhhcHBlbiBiZWZvcmUgYW55
IHJlYWwgaGFyZHdhcmUgd2l0aA0KdmlydHVhbGl6YXRpb24gc3VwcG9ydCBzaG93cyB1cCA6KS4N
Cg0KPiAgU29vbmVyIG9yDQo+IGxhdGVyIHlvdSBtYXkgd2FudCB0byBpbXBsZW1lbnQgc29tZXRo
aW5nIGxpa2UgeDg2J3MgaGV1cmlzdGljIHRvDQo+IGFkdmFuY2UgdGhlIHRpbWVyIGRlYWRsaW5l
IGJ5IGEgZmV3IGh1bmRyZWQgbmFub3NlY29uZHM7IHBlcmhhcHMgYWRkDQo+IGENCj4gVE9ETyBu
b3cpLg0KPiANCg0KSSBhbSBub3QgYXdhcmUgb2YgdGhpcyBhcHByb2FjaC4gSSB3aWxsIHRha2Ug
YSBsb29rLiBUaGFua3MuDQoNClJlZ2FyZHMsDQpBdGlzaA0KPiBQYW9sbw0KPiANCj4gPiArCQkJ
CUhSVElNRVJfTU9ERV9BQlMpOw0KPiA+ICsJCXQtPmlzX3NldCA9IHRydWU7DQo+ID4gKwl9IGVs
c2UNCj4gPiArCQlrdm1fcmlzY3ZfdmNwdV9zZXRfaW50ZXJydXB0KHZjcHUsIElSUV9TX1RJTUVS
KTsNCj4gPiArDQo+IA0KPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXw0KPiBsaW51eC1yaXNjdiBtYWlsaW5nIGxpc3QNCj4gbGludXgtcmlzY3ZAbGlzdHMu
aW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LXJpc2N2DQoNCg==

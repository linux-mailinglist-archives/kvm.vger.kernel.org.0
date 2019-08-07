Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA8385337
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 20:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389400AbfHGSsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 14:48:09 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:49782 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389310AbfHGSsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 14:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565203689; x=1596739689;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/5YonVRLW2yKki6aZkgXx3v3RLqtovvvOIpbZIXYHpg=;
  b=bE5s2nfWwLMa797qE12r3Tt0Ch/c0NxibjRskUECVICXV2Nasg1umKeR
   tD1qSBSRuJFyHoYccVuYD/C2Apuegwu5xhp9NJMzXCD0pm9ngtTsqH5VM
   Wch2FIeSquSac1kxUceTLNRvnDcRSkLZA8SbOgd4NxkbZONm8fF6Y3J1V
   RXU2cw/AC/HKoYu+bo/G4kYjZZDID3vHnoxQD3+joK+KzFEUESA99KLyl
   ELly3MN2h/+kf7+Gt5StgaU8fL4yKWaIk0icg/BL9bo0zKbCg6VqvDSvb
   gblnhxKBAaow1LvtnbQPp1maxlY1nijfVtKk0xepwSFId9//sq6FmNVo2
   A==;
IronPort-SDR: wuPjjE3Yi8m4mImHPtuvz8oabR6dugvX9mGTz7CJGo9n5ImWtkj5Z6mIz1CKM6V2I8Csxy7aXw
 wtRWPw9mAJZ0PMO1/UiTxSCymBukQN7D6WalaT5oseJyDQpA/s43++gKG1u0H+0GUQG8WN12Jj
 L+0XzkpCzdO0xQcM7xn2AQYLKodh1ppdfQgK6KAu8mKvyiD43d9Jd1x7pELWrsmBhRkKeaZGlE
 6pDIxBA0O6A06tKWPNO8iv99EcEyA5dbQIxpcb2ifP9c1ZJZuPj0IZsOIATgeZWtL5zzJNr3JX
 Ri0=
X-URL-LookUp-ScanningError: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559491200"; 
   d="scan'208";a="115289244"
Received: from mail-sn1nam04lp2058.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.58])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2019 02:47:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/mjA3V2NLkZmxf01SGG0YSruIHJq/OxDTMFNAZLTL3Zh4RGqwe419MYDSYmjNLDphDUCP6G1ZhHYsyH63ZmTjCJCG0pR9OGgmloEzJ8fLXrnRT8qScFqFBwsjgKE3rfwXN7mUmzqB+yTP20IlOasbXpAMY0UGJCyrHiLhv04OpcDCKabJd8UozfBASnoIidXkfzxHPxuSkIBBKv6QDZvclf5qUyw+KNXREUWqC3xNOt8JWQzvoB5p18Ol7UG3VKqXkgskh/LIXwjVs1wwT6DbEdRCLujCVrvOTHYm2Rf6qFDzAuCLeqQo9WHC2k5iKroiEKyt3LUm76i2ZCG6hxIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5YonVRLW2yKki6aZkgXx3v3RLqtovvvOIpbZIXYHpg=;
 b=GykXTJT7X32qjwh4uqJIZEbktDXY4xcTO3eOPog1m1HRrM80f0IBXqbUcvXkQRklIOQzsETX/pFfkRPIVNdgXFI4rFYMpOwnHehmM/l4lFiNlG687FAMErImiBlBbfL1S3iWYASzd5vtffgEihN25sbpjYNbkm41aB0BKluxwI0kzTa2zpmvjJ6WRHRq+ztmrquxblcAyNkD6cxdt9jfl11WKOQ2+zTmyTRYDWoNZoDAVCF0WEb1lEWp4ERh1SFFeIjvqR1abbZF1TA6dI112DmVHPGLIK7v6KlyUfn73S3ZuNpb3S2i8AzYKXGkCGNSkCNMkP9eBmkT8BRZx2D1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5YonVRLW2yKki6aZkgXx3v3RLqtovvvOIpbZIXYHpg=;
 b=EHEQXl/XA4ZhIqFNh9ile06Hjtb3ahYyUWCFenrWpGF0q5B1G7/WAZb/ghRmZCx1wLbhPGp/6uOPc1dEaA9Gtp3EBNqVHNmKdxResPv/xXl9ks/+NnWhiTp5KVkHJDplJtgeqhj+MjGbzLhQ/RRb8iOyNohYwBaWf6hNTTwrV8o=
Received: from BYAPR04MB3782.namprd04.prod.outlook.com (52.135.214.142) by
 BYAPR04MB4679.namprd04.prod.outlook.com (52.135.240.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Wed, 7 Aug 2019 18:47:53 +0000
Received: from BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926]) by BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926%7]) with mapi id 15.20.2115.005; Wed, 7 Aug 2019
 18:47:53 +0000
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
        "hch@infradead.org" <hch@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 02/20] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
Thread-Topic: [PATCH v4 02/20] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
Thread-Index: AQHVTRuUzwWCWNtkKEePaQqrt349jabwBwQA
Date:   Wed, 7 Aug 2019 18:47:53 +0000
Message-ID: <750dc9365c02d20616ae8ca22ac454d0e54e994e.camel@wdc.com>
References: <20190807122726.81544-1-anup.patel@wdc.com>
         <20190807122726.81544-3-anup.patel@wdc.com>
In-Reply-To: <20190807122726.81544-3-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Atish.Patra@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e4edf90-89cd-48fe-36af-08d71b67c181
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4679;
x-ms-traffictypediagnostic: BYAPR04MB4679:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BYAPR04MB4679FEE545FD5E62E642E11EFAD40@BYAPR04MB4679.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(189003)(199004)(118296001)(8676002)(2616005)(476003)(11346002)(446003)(81166006)(81156014)(2201001)(256004)(6306002)(71190400001)(71200400001)(486006)(6512007)(3846002)(6116002)(8936002)(6436002)(53936002)(7736002)(6486002)(25786009)(5660300002)(229853002)(66066001)(6246003)(316002)(2501003)(26005)(66556008)(478600001)(2906002)(66946007)(14454004)(7416002)(186003)(99286004)(110136005)(4326008)(66446008)(64756008)(54906003)(102836004)(6506007)(966005)(305945005)(86362001)(76176011)(36756003)(6636002)(66476007)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4679;H:BYAPR04MB3782.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oYOjKZBZdxRBL3WJE0KAfQTBAMgz/df9NwAePo1XOlyQjA+Ac8DF3WfK0WofJCsZCawHp0wMNk7iuky5/hfvn0C/dMOulHBDM//B7VhbHdwgCzpx62KVn+gdH+xe28apWSR5al6D4FfDAIuQ6e0OvKyZXkwsb8kC/WRayqL97OoaoUWrj64y6TNn1/MrlwVC5Jbzfd+8Nf7KKrrbc3frTVgqxey21KCojKI+vze9/e5xRgjE4vacE/uGZE82jAaQNr8OOm0TlHaaNTLF4aTQkUKmugo/BhnV9/2glkvV1ZKLcV/uIzM5/Z+INzKclBoN923/aDAj9q++BP8PUicHNMdzZCewyDKMQvhYnjFNmkkbwv2cxBq7Gao0x5ybl2WRKhF+h9qKl4jYi3/Dg8gj3Eqr/dbNQ8kFGd0HUqLpAK8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB4C7231F5A34A48BB3CB320AABA7F92@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4edf90-89cd-48fe-36af-08d71b67c181
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 18:47:53.6008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atish.Patra@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4679
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDE5LTA4LTA3IGF0IDEyOjI4ICswMDAwLCBBbnVwIFBhdGVsIHdyb3RlOg0KPiBU
aGlzIHBhdGNoIGFkZHMgcmlzY3ZfaXNhIGJpdG1hcCB3aGljaCByZXByZXNlbnRzIEhvc3QgSVNB
IGZlYXR1cmVzDQo+IGNvbW1vbiBhY3Jvc3MgYWxsIEhvc3QgQ1BVcy4gVGhlIHJpc2N2X2lzYSBp
cyBub3Qgc2FtZSBhcyBlbGZfaHdjYXANCj4gYmVjYXVzZSBlbGZfaHdjYXAgd2lsbCBvbmx5IGhh
dmUgSVNBIGZlYXR1cmVzIHJlbGV2YW50IGZvciB1c2VyLXNwYWNlDQo+IGFwcHMgd2hlcmVhcyBy
aXNjdl9pc2Egd2lsbCBoYXZlIElTQSBmZWF0dXJlcyByZWxldmFudCB0byBib3RoIGtlcm5lbA0K
PiBhbmQgdXNlci1zcGFjZSBhcHBzLg0KPiANCj4gT25lIG9mIHRoZSB1c2UtY2FzZSBmb3Igcmlz
Y3ZfaXNhIGJpdG1hcCBpcyBpbiBLVk0gaHlwZXJ2aXNvciB3aGVyZQ0KPiB3ZSB3aWxsIHVzZSBp
dCB0byBkbyBmb2xsb3dpbmcgb3BlcmF0aW9uczoNCj4gDQo+IDEuIENoZWNrIHdoZXRoZXIgaHlw
ZXJ2aXNvciBleHRlbnNpb24gaXMgYXZhaWxhYmxlDQo+IDIuIEZpbmQgSVNBIGZlYXR1cmVzIHRo
YXQgbmVlZCB0byBiZSB2aXJ0dWFsaXplZCAoZS5nLiBmbG9hdGluZw0KPiAgICBwb2ludCBzdXBw
b3J0LCB2ZWN0b3IgZXh0ZW5zaW9uLCBldGMuKQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW51cCBQ
YXRlbCA8YW51cC5wYXRlbEB3ZGMuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBdGlzaCBQYXRyYSA8
YXRpc2gucGF0cmFAd2RjLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL2h3
Y2FwLmggfCAyNiArKysrKysrKysrKw0KPiAgYXJjaC9yaXNjdi9rZXJuZWwvY3B1ZmVhdHVyZS5j
IHwgNzkNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAgMiBmaWxlcyBj
aGFuZ2VkLCAxMDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL2h3Y2FwLmgNCj4gYi9hcmNoL3Jpc2N2L2luY2x1
ZGUvYXNtL2h3Y2FwLmgNCj4gaW5kZXggN2VjYjdjNmE1N2IxLi45YjY1NzM3NWFhNTEgMTAwNjQ0
DQo+IC0tLSBhL2FyY2gvcmlzY3YvaW5jbHVkZS9hc20vaHdjYXAuaA0KPiArKysgYi9hcmNoL3Jp
c2N2L2luY2x1ZGUvYXNtL2h3Y2FwLmgNCj4gQEAgLTgsNiArOCw3IEBADQo+ICAjaWZuZGVmIF9f
QVNNX0hXQ0FQX0gNCj4gICNkZWZpbmUgX19BU01fSFdDQVBfSA0KPiAgDQo+ICsjaW5jbHVkZSA8
bGludXgvYml0cy5oPg0KPiAgI2luY2x1ZGUgPHVhcGkvYXNtL2h3Y2FwLmg+DQo+ICANCj4gICNp
Zm5kZWYgX19BU1NFTUJMWV9fDQo+IEBAIC0yMiw1ICsyMywzMCBAQCBlbnVtIHsNCj4gIH07DQo+
ICANCj4gIGV4dGVybiB1bnNpZ25lZCBsb25nIGVsZl9od2NhcDsNCj4gKw0KPiArI2RlZmluZSBS
SVNDVl9JU0FfRVhUX2EJCSgnYScgLSAnYScpDQo+ICsjZGVmaW5lIFJJU0NWX0lTQV9FWFRfYwkJ
KCdjJyAtICdhJykNCj4gKyNkZWZpbmUgUklTQ1ZfSVNBX0VYVF9kCQkoJ2QnIC0gJ2EnKQ0KPiAr
I2RlZmluZSBSSVNDVl9JU0FfRVhUX2YJCSgnZicgLSAnYScpDQo+ICsjZGVmaW5lIFJJU0NWX0lT
QV9FWFRfaAkJKCdoJyAtICdhJykNCj4gKyNkZWZpbmUgUklTQ1ZfSVNBX0VYVF9pCQkoJ2knIC0g
J2EnKQ0KPiArI2RlZmluZSBSSVNDVl9JU0FfRVhUX20JCSgnbScgLSAnYScpDQo+ICsjZGVmaW5l
IFJJU0NWX0lTQV9FWFRfcwkJKCdzJyAtICdhJykNCj4gKyNkZWZpbmUgUklTQ1ZfSVNBX0VYVF91
CQkoJ3UnIC0gJ2EnKQ0KDQpBcyBwZXIgdGhlIGRpc2N1c3Npb24gaW4gZm9sbG93aW5nIHRocmVh
ZHMsICdTJyAmICdVJyBhcmUgbm90IHZhbGlkIElTQQ0KZXh0ZW5zaW9ucy4gU28gd2Ugc2hvdWxk
IGRyb3AgdGhlbSBmcm9tIGhlcmUgYXMgd2VsbC4gDQoNCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQu
b3JnL3BpcGVybWFpbC9saW51eC1yaXNjdi8yMDE5LUF1Z3VzdC8wMDU3NzEuaHRtbA0KDQpodHRw
czovL2xpc3RzLm5vbmdudS5vcmcvYXJjaGl2ZS9odG1sL3FlbXUtZGV2ZWwvMjAxOS0wOC9tc2cw
MTIxNy5odG1sDQoNCg0KPiArI2RlZmluZSBSSVNDVl9JU0FfRVhUX3ppY3NyCSgoJ3onIC0gJ2En
KSArIDEpDQo+ICsjZGVmaW5lIFJJU0NWX0lTQV9FWFRfemlmZW5jZWkJKCgneicgLSAnYScpICsg
MikNCj4gKyNkZWZpbmUgUklTQ1ZfSVNBX0VYVF96YW0JKCgneicgLSAnYScpICsgMykNCj4gKyNk
ZWZpbmUgUklTQ1ZfSVNBX0VYVF96dHNvCSgoJ3onIC0gJ2EnKSArIDQpDQo+ICsNCj4gKyNkZWZp
bmUgUklTQ1ZfSVNBX0VYVF9NQVgJMjU2DQo+ICsNCj4gK3Vuc2lnbmVkIGxvbmcgcmlzY3ZfaXNh
X2V4dGVuc2lvbl9iYXNlKGNvbnN0IHVuc2lnbmVkIGxvbmcNCj4gKmlzYV9iaXRtYXApOw0KPiAr
DQo+ICsjZGVmaW5lIHJpc2N2X2lzYV9leHRlbnNpb25fbWFzayhleHQpIEJJVF9NQVNLKFJJU0NW
X0lTQV9FWFRfIyNleHQpDQo+ICsNCj4gK2Jvb2wgX19yaXNjdl9pc2FfZXh0ZW5zaW9uX2F2YWls
YWJsZShjb25zdCB1bnNpZ25lZCBsb25nDQo+ICppc2FfYml0bWFwLCBpbnQgYml0KTsNCj4gKyNk
ZWZpbmUgcmlzY3ZfaXNhX2V4dGVuc2lvbl9hdmFpbGFibGUoaXNhX2JpdG1hcCwgZXh0KQlcDQo+
ICsJX19yaXNjdl9pc2FfZXh0ZW5zaW9uX2F2YWlsYWJsZShpc2FfYml0bWFwLA0KPiBSSVNDVl9J
U0FfRVhUXyMjZXh0KQ0KPiArDQo+ICAjZW5kaWYNCj4gICNlbmRpZg0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC9yaXNjdi9rZXJuZWwvY3B1ZmVhdHVyZS5jDQo+IGIvYXJjaC9yaXNjdi9rZXJuZWwvY3B1
ZmVhdHVyZS5jDQo+IGluZGV4IGIxYWRlOWE0OTM0Ny4uNGNlNzFjZTVlMjkwIDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3Jpc2N2L2tlcm5lbC9jcHVmZWF0dXJlLmMNCj4gKysrIGIvYXJjaC9yaXNjdi9r
ZXJuZWwvY3B1ZmVhdHVyZS5jDQo+IEBAIC02LDIxICs2LDY0IEBADQo+ICAgKiBDb3B5cmlnaHQg
KEMpIDIwMTcgU2lGaXZlDQo+ICAgKi8NCj4gIA0KPiArI2luY2x1ZGUgPGxpbnV4L2JpdG1hcC5o
Pg0KPiAgI2luY2x1ZGUgPGxpbnV4L29mLmg+DQo+ICAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5o
Pg0KPiAgI2luY2x1ZGUgPGFzbS9od2NhcC5oPg0KPiAgI2luY2x1ZGUgPGFzbS9zbXAuaD4NCj4g
IA0KPiAgdW5zaWduZWQgbG9uZyBlbGZfaHdjYXAgX19yZWFkX21vc3RseTsNCj4gKw0KPiArLyog
SG9zdCBJU0EgYml0bWFwICovDQo+ICtzdGF0aWMgREVDTEFSRV9CSVRNQVAocmlzY3ZfaXNhLCBS
SVNDVl9JU0FfRVhUX01BWCkgX19yZWFkX21vc3RseTsNCj4gKw0KPiAgI2lmZGVmIENPTkZJR19G
UFUNCj4gIGJvb2wgaGFzX2ZwdSBfX3JlYWRfbW9zdGx5Ow0KPiAgI2VuZGlmDQo+ICANCj4gKy8q
Kg0KPiArICogcmlzY3ZfaXNhX2V4dGVuc2lvbl9iYXNlIC0gR2V0IGJhc2UgZXh0ZW5zaW9uIHdv
cmQNCj4gKyAqDQo+ICsgKiBAaXNhX2JpdG1hcCBJU0EgYml0bWFwIHRvIHVzZQ0KPiArICogQHJl
dHVybnMgYmFzZSBleHRlbnNpb24gd29yZCBhcyB1bnNpZ25lZCBsb25nIHZhbHVlDQo+ICsgKg0K
PiArICogTk9URTogSWYgaXNhX2JpdG1hcCBpcyBOVUxMIHRoZW4gSG9zdCBJU0EgYml0bWFwIHdp
bGwgYmUgdXNlZC4NCj4gKyAqLw0KPiArdW5zaWduZWQgbG9uZyByaXNjdl9pc2FfZXh0ZW5zaW9u
X2Jhc2UoY29uc3QgdW5zaWduZWQgbG9uZw0KPiAqaXNhX2JpdG1hcCkNCj4gK3sNCj4gKwlpZiAo
IWlzYV9iaXRtYXApDQo+ICsJCXJldHVybiByaXNjdl9pc2FbMF07DQo+ICsJcmV0dXJuIGlzYV9i
aXRtYXBbMF07DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTChyaXNjdl9pc2FfZXh0ZW5zaW9u
X2Jhc2UpOw0KPiArDQo+ICsvKioNCj4gKyAqIF9fcmlzY3ZfaXNhX2V4dGVuc2lvbl9hdmFpbGFi
bGUgLSBDaGVjayB3aGV0aGVyIGdpdmVuIGV4dGVuc2lvbg0KPiArICogaXMgYXZhaWxhYmxlIG9y
IG5vdA0KPiArICoNCj4gKyAqIEBpc2FfYml0bWFwIElTQSBiaXRtYXAgdG8gdXNlDQo+ICsgKiBA
Yml0IGJpdCBwb3NpdGlvbiBvZiB0aGUgZGVzaXJlZCBleHRlbnNpb24NCj4gKyAqIEByZXR1cm5z
IHRydWUgb3IgZmFsc2UNCj4gKyAqDQo+ICsgKiBOT1RFOiBJZiBpc2FfYml0bWFwIGlzIE5VTEwg
dGhlbiBIb3N0IElTQSBiaXRtYXAgd2lsbCBiZSB1c2VkLg0KPiArICovDQo+ICtib29sIF9fcmlz
Y3ZfaXNhX2V4dGVuc2lvbl9hdmFpbGFibGUoY29uc3QgdW5zaWduZWQgbG9uZw0KPiAqaXNhX2Jp
dG1hcCwgaW50IGJpdCkNCj4gK3sNCj4gKwljb25zdCB1bnNpZ25lZCBsb25nICpibWFwID0gKGlz
YV9iaXRtYXApID8gaXNhX2JpdG1hcCA6DQo+IHJpc2N2X2lzYTsNCj4gKw0KPiArCWlmIChiaXQg
Pj0gUklTQ1ZfSVNBX0VYVF9NQVgpDQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKw0KPiArCXJldHVy
biB0ZXN0X2JpdChiaXQsIGJtYXApID8gdHJ1ZSA6IGZhbHNlOw0KPiArfQ0KPiArRVhQT1JUX1NZ
TUJPTF9HUEwoX19yaXNjdl9pc2FfZXh0ZW5zaW9uX2F2YWlsYWJsZSk7DQo+ICsNCj4gIHZvaWQg
cmlzY3ZfZmlsbF9od2NhcCh2b2lkKQ0KPiAgew0KPiAgCXN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9k
ZTsNCj4gIAljb25zdCBjaGFyICppc2E7DQo+IC0Jc2l6ZV90IGk7DQo+ICsJY2hhciBwcmludF9z
dHJbQklUU19QRVJfTE9ORysxXTsNCj4gKwlzaXplX3QgaSwgaiwgaXNhX2xlbjsNCj4gIAlzdGF0
aWMgdW5zaWduZWQgbG9uZyBpc2EyaHdjYXBbMjU2XSA9IHswfTsNCj4gIA0KPiAgCWlzYTJod2Nh
cFsnaSddID0gaXNhMmh3Y2FwWydJJ10gPSBDT01QQVRfSFdDQVBfSVNBX0k7DQo+IEBAIC0zMiw4
ICs3NSwxMSBAQCB2b2lkIHJpc2N2X2ZpbGxfaHdjYXAodm9pZCkNCj4gIA0KPiAgCWVsZl9od2Nh
cCA9IDA7DQo+ICANCj4gKwliaXRtYXBfemVybyhyaXNjdl9pc2EsIFJJU0NWX0lTQV9FWFRfTUFY
KTsNCj4gKw0KPiAgCWZvcl9lYWNoX29mX2NwdV9ub2RlKG5vZGUpIHsNCj4gIAkJdW5zaWduZWQg
bG9uZyB0aGlzX2h3Y2FwID0gMDsNCj4gKwkJdW5zaWduZWQgbG9uZyB0aGlzX2lzYSA9IDA7DQo+
ICANCj4gIAkJaWYgKHJpc2N2X29mX3Byb2Nlc3Nvcl9oYXJ0aWQobm9kZSkgPCAwKQ0KPiAgCQkJ
Y29udGludWU7DQo+IEBAIC00Myw4ICs4OSwyMCBAQCB2b2lkIHJpc2N2X2ZpbGxfaHdjYXAodm9p
ZCkNCj4gIAkJCWNvbnRpbnVlOw0KPiAgCQl9DQo+ICANCj4gLQkJZm9yIChpID0gMDsgaSA8IHN0
cmxlbihpc2EpOyArK2kpDQo+ICsJCWkgPSAwOw0KPiArCQlpc2FfbGVuID0gc3RybGVuKGlzYSk7
DQo+ICsjaWYgZGVmaW5lZChDT05GSUdfMzJCSVQpDQo+ICsJCWlmICghc3RybmNtcChpc2EsICJy
djMyIiwgNCkpDQo+ICsJCQlpICs9IDQ7DQo+ICsjZWxpZiBkZWZpbmVkKENPTkZJR182NEJJVCkN
Cj4gKwkJaWYgKCFzdHJuY21wKGlzYSwgInJ2NjQiLCA0KSkNCj4gKwkJCWkgKz0gNDsNCj4gKyNl
bmRpZg0KPiArCQlmb3IgKDsgaSA8IGlzYV9sZW47ICsraSkgew0KPiAgCQkJdGhpc19od2NhcCB8
PSBpc2EyaHdjYXBbKHVuc2lnbmVkDQo+IGNoYXIpKGlzYVtpXSldOw0KPiArCQkJaWYgKCdhJyA8
PSBpc2FbaV0gJiYgaXNhW2ldIDw9ICd6JykNCj4gKwkJCQl0aGlzX2lzYSB8PSAoMVVMIDw8IChp
c2FbaV0gLSAnYScpKTsNCj4gKwkJfQ0KPiAgDQo+ICAJCS8qDQo+ICAJCSAqIEFsbCAib2theSIg
aGFydCBzaG91bGQgaGF2ZSBzYW1lIGlzYS4gU2V0IEhXQ0FQDQo+IGJhc2VkIG9uDQo+IEBAIC01
NSw2ICsxMTMsMTEgQEAgdm9pZCByaXNjdl9maWxsX2h3Y2FwKHZvaWQpDQo+ICAJCQllbGZfaHdj
YXAgJj0gdGhpc19od2NhcDsNCj4gIAkJZWxzZQ0KPiAgCQkJZWxmX2h3Y2FwID0gdGhpc19od2Nh
cDsNCj4gKw0KPiArCQlpZiAocmlzY3ZfaXNhWzBdKQ0KPiArCQkJcmlzY3ZfaXNhWzBdICY9IHRo
aXNfaXNhOw0KPiArCQllbHNlDQo+ICsJCQlyaXNjdl9pc2FbMF0gPSB0aGlzX2lzYTsNCj4gIAl9
DQo+ICANCj4gIAkvKiBXZSBkb24ndCBzdXBwb3J0IHN5c3RlbXMgd2l0aCBGIGJ1dCB3aXRob3V0
IEQsIHNvIG1hc2sgdGhvc2UNCj4gb3V0DQo+IEBAIC02NCw3ICsxMjcsMTcgQEAgdm9pZCByaXNj
dl9maWxsX2h3Y2FwKHZvaWQpDQo+ICAJCWVsZl9od2NhcCAmPSB+Q09NUEFUX0hXQ0FQX0lTQV9G
Ow0KPiAgCX0NCj4gIA0KPiAtCXByX2luZm8oImVsZl9od2NhcCBpcyAweCVseFxuIiwgZWxmX2h3
Y2FwKTsNCj4gKwltZW1zZXQocHJpbnRfc3RyLCAwLCBzaXplb2YocHJpbnRfc3RyKSk7DQo+ICsJ
Zm9yIChpID0gMCwgaiA9IDA7IGkgPCBCSVRTX1BFUl9MT05HOyBpKyspDQo+ICsJCWlmIChyaXNj
dl9pc2FbMF0gJiBCSVRfTUFTSyhpKSkNCj4gKwkJCXByaW50X3N0cltqKytdID0gKGNoYXIpKCdh
JyArIGkpOw0KPiArCXByX2luZm8oInJpc2N2OiBJU0EgZXh0ZW5zaW9ucyAlc1xuIiwgcHJpbnRf
c3RyKTsNCj4gKw0KPiArCW1lbXNldChwcmludF9zdHIsIDAsIHNpemVvZihwcmludF9zdHIpKTsN
Cj4gKwlmb3IgKGkgPSAwLCBqID0gMDsgaSA8IEJJVFNfUEVSX0xPTkc7IGkrKykNCj4gKwkJaWYg
KGVsZl9od2NhcCAmIEJJVF9NQVNLKGkpKQ0KPiArCQkJcHJpbnRfc3RyW2orK10gPSAoY2hhciko
J2EnICsgaSk7DQo+ICsJcHJfaW5mbygicmlzY3Y6IEVMRiBjYXBhYmlsaXRpZXMgJXNcbiIsIHBy
aW50X3N0cik7DQo+ICANCj4gICNpZmRlZiBDT05GSUdfRlBVDQo+ICAJaWYgKGVsZl9od2NhcCAm
IChDT01QQVRfSFdDQVBfSVNBX0YgfCBDT01QQVRfSFdDQVBfSVNBX0QpKQ0KDQotLSANClJlZ2Fy
ZHMsDQpBdGlzaA0K

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA3A792D6
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387601AbfG2SJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 14:09:07 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18972 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfG2SJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 14:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564423746; x=1595959746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=m1ap86BO2Gk75JInEVj0bFftx1hwSOuDBr0lN7L29X4=;
  b=mW7EukssSSHWWPpP9p6NoFiUydTFN92xNp3wYK/jagalgtQFyHMEKVn9
   YepZ98mVxmDD+kPgoukDpK9qQtkTZwMTx2LfbWpLKZeUG++pf6oK0OouN
   iU+pJq/ij1YS+6+fDr1rFLZhAIxoWW5XL2QYICusUwKRzbG5qbcuxompM
   /juljT31EcV0nPB3iqkorjqWWy7FmiUSNbEgFOTJOzuvlXAh/1jCqLbPz
   UgWdq5H69dfesyj7cCb+n6Ib57gDjFqzmwAg31ZJgW6oxHTvmkVDtbp54
   2oQzkbZM4gcPy2SqtVWgfVUH0xHX3FXlQBA+hRlenMAbjx8berNiXBbDa
   g==;
IronPort-SDR: NRbDZLN7srWUxa+eFY8+zuYC0NKCCKF5Ri4HDp1Z42DFgyRVjoyOMg0zdh7y/ovrp+eb4hJPym
 AGFil+Mxzk32Y9jSypeujVWOhPYiEYngn/y5A0In0abFAmt1K6YKGz8kx7hLuougef0ZFjfPvM
 oyee+heKSxrX2KyZtu3J4gnHpY+ZXs0xKmBM8LASX9zhNEyyiYsNQClgL/rHNUPfL9fyZqPvU+
 oqyesfBuZ7i1m28DFvo4787HERXP870EhRXuTF4MHV5NVxquXfCyaihcONUiFboQMasDhpD262
 TB4=
X-IronPort-AV: E=Sophos;i="5.64,323,1559491200"; 
   d="scan'208";a="119101644"
Received: from mail-bn3nam01lp2050.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.50])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jul 2019 02:02:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2O6L/lUN5payJgL9dc6Jt1iYbNaniOL9x/2uyXqTInJoIFe3o4NICHIwX/ETKSIDmdDkdgvK8Vm16RWJGiX1D95bIOJOeCdXcA+WAcDeW/YmWdyTYuzX8qBw9KJKTDGdJRip5v0jdFnuKC/+LwwaNbjc0AVnSJtDb5a0Zlmv/VUiwGpUguKUJ0UyB2IG/BIUlvC6ACpQmd+JYCQX7W3b7iidr0hxQqx10t3qkU5asng75Q3j0MVBFwKa5G9uE/BBWnRH854BIrn297cGlLuRmmOBq2n0c7EksfL4UhA62XdxLh1+sNsavJBlsZKWfRkxDmP5JK702eku8ComLysSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1ap86BO2Gk75JInEVj0bFftx1hwSOuDBr0lN7L29X4=;
 b=Tr9A/NndrwY6BVt/wn52RVwg62RNjXIRoEMJHRtGDGSEAsOgofjpARgIXgsaZCqyqHZ3Q8N1W6/znNZqx1aYaaO1ZpzB4GtU3VFPuGmulS/Wyg0E+tme0Tjfny5aMgpFoP1hsvpLKw/ZWBg/FhoNNaojgRbp62gSiABTzj+u9VeYSqZBRFeAwVN0xHLNlDBMl1uHz4M+bc05jplpWJZ755g5866qHX3i7u6YHxp6OwM+3twtUeS9b4nr1PK+UbRZ6ybmH8Ub9dNo0cfY6scFXtYk+Xg21TjP+sFVdfH7nKMBb8pu9sNpUfhQKdxAS2I9MPgdZxe2XAYeEf/ruf8jpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1ap86BO2Gk75JInEVj0bFftx1hwSOuDBr0lN7L29X4=;
 b=k33f+1lZBYGOqc6IAy4cb7iDTs3p5vEOBUoCFdBMRlix/FrI3SAoZGl0/ApHTCXaMoEi2fmtNPLz8gg1HN2jxNX9+fluCwcOqGW0Qx3+HnGoq4UAbXKlXJnZMmXe0dwWxH+zmV5IQCk2Wr2+JyUn/3LUS8inWfXKsChJsIrETQg=
Received: from BYAPR04MB3782.namprd04.prod.outlook.com (52.135.214.142) by
 BYAPR04MB5798.namprd04.prod.outlook.com (20.179.58.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 18:02:01 +0000
Received: from BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926]) by BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 18:02:01 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "schwab@suse.de" <schwab@suse.de>, Anup Patel <Anup.Patel@wdc.com>
CC:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "palmer@sifive.com" <palmer@sifive.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 13/16] RISC-V: KVM: Add timer functionality
Thread-Topic: [RFC PATCH 13/16] RISC-V: KVM: Add timer functionality
Thread-Index: AQHVRgTUPAB7n90qAEyqoYXnGhI7+Kbhqzp6gAA4LAA=
Date:   Mon, 29 Jul 2019 18:02:00 +0000
Message-ID: <d26a4582fad27d0f475cf8bca4d3e6c49987d37d.camel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
         <20190729115544.17895-14-anup.patel@wdc.com> <mvmpnlsc39p.fsf@suse.de>
In-Reply-To: <mvmpnlsc39p.fsf@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Atish.Patra@wdc.com; 
x-originating-ip: [199.255.45.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3bfab8a-f6b2-4007-1ccb-08d7144edafc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5798;
x-ms-traffictypediagnostic: BYAPR04MB5798:
x-microsoft-antispam-prvs: <BYAPR04MB57987ABDE94C9121B09287BEFADD0@BYAPR04MB5798.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(199004)(189003)(4326008)(54906003)(66946007)(66446008)(66556008)(64756008)(66476007)(36756003)(6436002)(6246003)(6486002)(110136005)(76116006)(6512007)(53936002)(229853002)(316002)(305945005)(2501003)(6636002)(5660300002)(14444005)(256004)(7416002)(71200400001)(2906002)(478600001)(71190400001)(6506007)(26005)(76176011)(25786009)(8936002)(66066001)(81156014)(8676002)(14454004)(86362001)(102836004)(11346002)(99286004)(2616005)(7736002)(6116002)(446003)(118296001)(3846002)(476003)(486006)(68736007)(186003)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5798;H:BYAPR04MB3782.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0KXiHRonWZS8zOhqLWFJM0PPXqR3STyEVRc1ghg+MZhCLpgqa6jF9j7lUGBIIM6R61K065uykNAS9JyT2roaQPGVF7e0MsePb96r84TKMaUTb/HbwlR+tQXZXy0or0AgreCj6LHOIUt4eab8YfLLAQMHY5UiHUU0WtMApNMAhpGceRYOe9DXkTF3JnlKj94ADBOUEL/WSTbVxawuCFMu9YMOjQ2LHyqJSJKXwIp1ixUH3XVQKVTzPjsG/B7Mhsm+FErKrf9SBfq8BGfT46mPtql3Ps8HVh9GS8DldnsPFo7jx7k8PXeBZ//RdAG7FQ0iu0X8vTGlm1jE2qB4hV6BqmH+le+EGyoMCRIzQgxnZkMu6EdM86cE/aUBC7+J1FT0/0h+dREB45UAb47zoSPWPRWm6i02NgsTbKva9wzP4cA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <188500A9F4740740A282010C76595F07@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3bfab8a-f6b2-4007-1ccb-08d7144edafc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 18:02:00.8615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atish.Patra@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5798
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTI5IGF0IDE2OjQwICswMjAwLCBBbmRyZWFzIFNjaHdhYiB3cm90ZToN
Cj4gT24gSnVsIDI5IDIwMTksIEFudXAgUGF0ZWwgPEFudXAuUGF0ZWxAd2RjLmNvbT4gd3JvdGU6
DQo+IA0KPiA+IEZyb206IEF0aXNoIFBhdHJhIDxhdGlzaC5wYXRyYUB3ZGMuY29tPg0KPiA+IA0K
PiA+IFRoZSBSSVNDLVYgaHlwZXJ2aXNvciBzcGVjaWZpY2F0aW9uIGRvZXNuJ3QgaGF2ZSBhbnkg
dmlydHVhbCB0aW1lcg0KPiA+IGZlYXR1cmUuDQo+ID4gDQo+ID4gRHVlIHRvIHRoaXMsIHRoZSBn
dWVzdCBWQ1BVIHRpbWVyIHdpbGwgYmUgcHJvZ3JhbW1lZCB2aWEgU0JJIGNhbGxzLg0KPiA+IFRo
ZSBob3N0IHdpbGwgdXNlIGEgc2VwYXJhdGUgaHJ0aW1lciBldmVudCBmb3IgZWFjaCBndWVzdCBW
Q1BVIHRvDQo+ID4gcHJvdmlkZSB0aW1lciBmdW5jdGlvbmFsaXR5LiBXZSBpbmplY3QgYSB2aXJ0
dWFsIHRpbWVyIGludGVycnVwdCB0bw0KPiA+IHRoZSBndWVzdCBWQ1BVIHdoZW5ldmVyIHRoZSBn
dWVzdCBWQ1BVIGhydGltZXIgZXZlbnQgZXhwaXJlcy4NCj4gPiANCj4gPiBUaGUgZm9sbG93aW5n
IGZlYXR1cmVzIGFyZSBub3Qgc3VwcG9ydGVkIHlldCBhbmQgd2lsbCBiZSBhZGRlZCBpbg0KPiA+
IGZ1dHVyZToNCj4gPiAxLiBBIHRpbWUgb2Zmc2V0IHRvIGFkanVzdCBndWVzdCB0aW1lIGZyb20g
aG9zdCB0aW1lDQo+ID4gMi4gQSBzYXZlZCBuZXh0IGV2ZW50IGluIGd1ZXN0IHZjcHUgZm9yIHZt
IG1pZ3JhdGlvbg0KPiANCj4gSSdtIGdldHRpbmcgdGhpcyBlcnJvcjoNCj4gDQo+IEluIGZpbGUg
aW5jbHVkZWQgZnJvbSA8Y29tbWFuZC1saW5lPjoNCj4gLi9pbmNsdWRlL2Nsb2Nrc291cmNlL3Rp
bWVyLXJpc2N2Lmg6MTI6MzA6IGVycm9yOiB1bmtub3duIHR5cGUgbmFtZQ0KPiDigJh1MzLigJkN
Cj4gICAgMTIgfCB2b2lkIHJpc2N2X2NzX2dldF9tdWx0X3NoaWZ0KHUzMiAqbXVsdCwgdTMyICpz
aGlmdCk7DQo+ICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn4NCj4gLi9p
bmNsdWRlL2Nsb2Nrc291cmNlL3RpbWVyLXJpc2N2Lmg6MTI6NDE6IGVycm9yOiB1bmtub3duIHR5
cGUgbmFtZQ0KPiDigJh1MzLigJkNCj4gICAgMTIgfCB2b2lkIHJpc2N2X2NzX2dldF9tdWx0X3No
aWZ0KHUzMiAqbXVsdCwgdTMyICpzaGlmdCk7DQo+ICAgICAgIHwgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIF5+fg0KPiBtYWtlWzFdOiAqKiogW3NjcmlwdHMvTWFrZWZp
bGUuYnVpbGQ6MzAxOiBpbmNsdWRlL2Nsb2Nrc291cmNlL3RpbWVyLQ0KPiByaXNjdi5oLnNdIEVy
cm9yIDENCj4gDQo+IEFuZHJlYXMuDQo+IA0KDQpTdHJhbmdlLiBXZSBuZXZlciBzYXcgdGhpcyBl
cnJvci4gQnV0IEkgdGhpbmsgd2Ugc2hvdWxkIGFkZCB0aGlzIG9uZSB0bw0KdGhlIGhlYWRlciBm
aWxlIChpbmNsdWRlL2Nsb2Nrc291cmNlL3RpbWVyLXJpc2N2LmgpIA0KDQojaW5jbHVkZSA8bGlu
dXgvdHlwZXMuaD4NCg0KQ2FuIHlvdSB0cnkgaXQgYXQgeW91ciBlbmQgYW5kIGNvbmZpcm0gcGxl
YXNlID8NCg0KUmVnYXJkcywNCkF0aXNoDQoNCg==

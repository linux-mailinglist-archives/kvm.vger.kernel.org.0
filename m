Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F77279A9C
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 23:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfG2VIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 17:08:49 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:35903 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfG2VIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 17:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564434529; x=1595970529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WT99HgsiSLRKqsljjUoE9XwJ1kGXUPdlDPeLmaM+9YQ=;
  b=BLH33HdIhDKuvYOPQ0/PTBPRksfj2xRA8siGd5eFTNa26bAR/TmvOrT2
   p5iav+bafbBa/OlXXi+90yHIX6/aUIljvnRekrg7e+SgiQBIpCspQ4G5e
   qBC6dEB5AJrEMZH2yjb2RpQjqsM1So17YY/ntGl41LPNZ4nuMLvHa8BS/
   bILOs5+0s7GyZtawvaUvbqYqv5kF27cFBBX0l/uJpQ9pAuKoVBmiu9UwZ
   R5PjYGrDAFIZsZliruT/5SiMFShpk0JMoEFS/yzzSFF03HfLfjqJ2rbL6
   tYwGbjDNPlzhUdvvrWpnA3Eoy54NmJpK5BhUrHTbj6mP4ukG4t0s/ogYM
   g==;
IronPort-SDR: Yl+zMQ+/dcPV7wXoaNyRaLYDNYR1Jjn3dcVCn/qY3Qo6T3az1nw+P8SArW2xHZR2abUK5R+TWI
 Gn8ar0IUoInKrc60RIsn5fT03tcns8Ds0ROY1IIKrTNuhOq488jeMaDsZGOyH/q+1etGSKdqtn
 B52yNcFtvr27SMIo/KXACTIx41koYtmVJAi8T8JQzyVjqMp728i2H+RSSkNFrYAit3wlxJDEKd
 mUE9CNSFJvQJ/x0JUUemHhIV2B/JzSjx/Bd3uiQ9e6FcWVnDzJ/o8FkFO/UcZLY8JlxsA6kiJk
 HVk=
X-IronPort-AV: E=Sophos;i="5.64,324,1559491200"; 
   d="scan'208";a="115443431"
Received: from mail-sn1nam04lp2059.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.59])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jul 2019 05:08:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOp4id6k0J2rnEI99FT0ZZN8FZonwXNZWOvYbqJbSNw3FqmblWZ8S39slaZYWr5THJQT4fM2ut+vhefWDjm1mCehj8/EjBMSq7ldps4kBkETi2EWMadDD1Xb/UbGnKPDkCVgM8SxJSLL5zTPYW8R59ZyvGfn1uMAbj7qtCKJbuTpy4iWaIZOxxTO+UCLZpSubFFaYKs2HhlWgTS5LUAa5KNuVsX2gJROD1jM0DQRB1EueETFZSUQynPjdSqIeK6AoalDH9NBVpwEStUCU3bwMdin4kIkJkCbVT0jMn4coeKI6KI9lflJRAvyqEhVswlWuOOZ3c7gJCuV5VUL5x14PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT99HgsiSLRKqsljjUoE9XwJ1kGXUPdlDPeLmaM+9YQ=;
 b=jXwsVbUPnMZuM0uBQuHRyDIyjmeNhOTbGXSIJjX5bdxm1Kf882SOnNZBHO013ZV2IuC89R2Oamzlf3fDXIEAwbWuq33uVC5nMivJlQOGROuIf5eV7eAC0XdpTpWzmB3y6wiH5y7eDbsGsnXaZTxOyE/rgw/I6yTx8/RqmDk9728yBmHlW9SiMn6yVuUKLPDFz2GQT0CF27+fN7dVIFDLv97Vn2RcO8akMA5WEWFRQTYwTcsseqh9bGJ1f5JU98C3R5ICBTJyp85Y5TaNQsw9R4aJG1/bVS+0XO8wwhcCmDYOTBBGzM6QmOgbv7Azc3xVii6Cypoiq9c2fP0bxVUrAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT99HgsiSLRKqsljjUoE9XwJ1kGXUPdlDPeLmaM+9YQ=;
 b=KVcboa31dd0nWr2O+qK+UGYwIAF3tB7Jt1f5syLRrGEWrecN/owFCttfVSK9KQ/yiGrzTfQupiMJMfVzJr/rWSRUJ4cBSt9Tg/On9jjEIgE+oS4SrJeC4vLJmX+iVvDK6Fxl9QWhD4LviBZmz4YX9MhDApPkBLgK3XyMn4r9qmA=
Received: from BYAPR04MB3782.namprd04.prod.outlook.com (52.135.214.142) by
 BYAPR04MB4023.namprd04.prod.outlook.com (52.135.215.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 21:08:45 +0000
Received: from BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926]) by BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::ac9a:967e:70a5:e926%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:08:45 +0000
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVRgTdLbP8aD0d50+SPOvQQEaYeqbh/v2AgAAC3ICAAATnAIAAENOA
Date:   Mon, 29 Jul 2019 21:08:45 +0000
Message-ID: <9914fa698cb0f2d72e2e92d98136100ea36e4c47.camel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
         <20190729115544.17895-16-anup.patel@wdc.com>
         <b461c82f-960a-306e-b76b-f2c329cabf21@redhat.com>
         <0e19ff14a51e210af91c4b0f2e649b8f5e140ce1.camel@wdc.com>
         <b6c884cc-e156-d125-b3a2-c8a843de34c2@redhat.com>
In-Reply-To: <b6c884cc-e156-d125-b3a2-c8a843de34c2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Atish.Patra@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 600d3425-f131-4a4d-bcaf-08d71468f196
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4023;
x-ms-traffictypediagnostic: BYAPR04MB4023:
x-microsoft-antispam-prvs: <BYAPR04MB4023F882EC0432E7A719F02FFADD0@BYAPR04MB4023.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(189003)(199004)(316002)(53546011)(76176011)(2906002)(4744005)(71190400001)(66556008)(64756008)(66446008)(66946007)(478600001)(86362001)(6512007)(486006)(66476007)(7736002)(14444005)(6506007)(76116006)(446003)(66066001)(305945005)(256004)(11346002)(68736007)(71200400001)(5660300002)(2616005)(476003)(7416002)(25786009)(99286004)(8676002)(14454004)(6436002)(53936002)(118296001)(2501003)(6246003)(8936002)(36756003)(110136005)(6116002)(4326008)(6486002)(3846002)(229853002)(6636002)(102836004)(2201001)(26005)(81156014)(54906003)(186003)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4023;H:BYAPR04MB3782.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SOXly4XCR1WWuptyVO3HGtexM827OCy8aMMv6N8SgAd4YZA89vb3mmGfrOhmq44fehUIU8wTw8DKNvSaO6Hqw8z2o/wxcVReIFtt1TBHMUGPHZCvZ/de9PXhevCVFkIDQ+rLiyQ70/ucA7GdI9qY3Zdlr7ESpNVzsuPD8sXCb9/KQ7FeEdNKLHuCVTAiFvQI5zbQtk6qt8nFRtMP/hTBC8iLY2Puqa0Uk26G0JEuSFIwV6c7SxGcV7efKiW9McqbjJzRiMe0eClcii2E76sbkXuc0iCGXiFAqbIH80tPFWDw96NJezqggRUl/gFENTXy/6fOlOUsbSsARlRrg9MC4v2+OPdvBtJ6y+YfQo0y9Hci1WtfS9FgHQ5+BokJaVZudJPlVmRH2+lAzvc7RccWQkTynyhrtBrXITfFXSbgoZs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0FE8B5DD99C9344B145D264ABBBADF2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600d3425-f131-4a4d-bcaf-08d71468f196
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:08:45.6147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atish.Patra@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4023
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTI5IGF0IDIyOjA4ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAyOS8wNy8xOSAyMTo1MSwgQXRpc2ggUGF0cmEgd3JvdGU6DQo+ID4gT24gTW9uLCAyMDE5
LTA3LTI5IGF0IDIxOjQwICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPiA+ID4gT24gMjkv
MDcvMTkgMTM6NTcsIEFudXAgUGF0ZWwgd3JvdGU6DQo+ID4gPiA+ICsJY3NyX3dyaXRlKENTUl9I
U1RBVFVTLCB2Y3B1LT5hcmNoLmd1ZXN0X2NvbnRleHQuaHN0YXR1cyANCj4gPiA+ID4gfA0KPiA+
ID4gPiBIU1RBVFVTX1NQUlYpOw0KPiA+ID4gPiArCWNzcl93cml0ZShDU1JfU1NUQVRVUywgdmNw
dS0NCj4gPiA+ID4gPmFyY2guZ3Vlc3RfY29udGV4dC5zc3RhdHVzKTsNCj4gPiA+ID4gKwl2YWwg
PSAqYWRkcjsNCj4gPiA+IA0KPiA+ID4gV2hhdCBoYXBwZW5zIGlmIHRoaXMgbG9hZCBmYXVsdHM/
DQo+ID4gPiANCj4gPiANCj4gPiBJdCBzaG91bGQgcmVkaXJlY3QgdGhlIHRyYXAgYmFjayB0byBW
UyBtb2RlLiBDdXJyZW50bHksIGl0IGlzIG5vdA0KPiA+IGltcGxlbWVudGVkLiBJdCBpcyBvbiB0
aGUgVE8tRE8gbGlzdCBmb3IgZnV0dXJlIGl0ZXJhdGlvbiBvZiB0aGUNCj4gPiBzZXJpZXMuDQo+
IA0KPiBPaywgcGxlYXNlIGFkZCBUT0RPIGNvbW1lbnRzIGZvciB0aGUgbW9yZSBpbXBvcnRhbnQg
dGFza3MgbGlrZSB0aGlzDQo+IG9uZQ0KPiAoYW5kL29yIHBvc3QgYSBzb21ld2hhdCBjb21wbGV0
ZSBsaXN0IGluIHJlcGx5IHRvIDAwLzE2KS4NCj4gDQoNClN1cmUuIFdpbGwgYWRkIGEgVE9ETyBj
b21tZW50IGhlcmUgYW5kIHB1dCB0aGUgY29tcGxldGUgVE9ETyBsaXN0IGluDQpjb3ZlciBsZXR0
ZXIgYXMgd2VsbC4NCg0KUmVnYXJkcywNCkF0aXNoDQo+IFRoYW5rcyENCj4gDQo+IFBhb2xvDQo+
IA0KDQo=

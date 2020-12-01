Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D02C946A
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 02:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387945AbgLABHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 20:07:16 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1719 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgLABHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 20:07:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606784834; x=1638320834;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GJZJx8ZBzYnXnGZ6+VuH/+jy32Ma2GbCpeiY3pibzY4=;
  b=GDoMnl8EOVMiHw0KyRpllHHedxJpWK9oKZIsdZGWv4gGsH1vp6Q3gW5m
   1xUrPUUHhFKPzEglwScGxPWp97IbqvMMvREL7xGqB8Or77iZmRDQp+/T7
   6phmGFtaft7xaRejv76Zs/CVHwHT2Z67GO33vV8vjAMk5qOH+J1/Aqw+J
   5bNNLpbPHNj5Mviat5O1zK9x6KLL6QGnCku02ijTmmbSP8YBPUuW67s7R
   a2GS5nZIWISof/msi6xYXFxh/0fivtA5SUjofnnwuFUxrvVMcI0LzYP2F
   T3hRpALoOx58OtXHdsnSxfg0Gdc9Ci1mG8XYn46xRlhmCgCY3Riweikr/
   g==;
IronPort-SDR: XLO46kjN95uhcYrHjTRXekFMRyK+lGnUZUx8uC7auW7BkHKzziQKog+UhH4zio7mc/FW+q5KEK
 /FA3uEU/1gDE9GpcoBU08+fmeTsLP/Q0W4xvIBKN7mxDJLko/otL31bmo7abXVfDkvu+d0Lzc6
 uQJcPHtVk1pbyRhYlzOjxcEziUF7jR4GfRq4gVuT2NM2W1fhPivdyYBtsISFArZ5xqveyJb9el
 FK4wlsRi1TtMeHQfJ1F5C0GAjLLXVhCUyzgLwVc0kFT05BpX7v6ET1aBblKGRAOo3sPVhjW7Oz
 QZE=
X-IronPort-AV: E=Sophos;i="5.78,382,1599494400"; 
   d="scan'208";a="155064332"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2020 09:06:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liOr8/57fFj8rr6DA4PIU1qAuwlXmRTTrcX06En+DYTMhwyHg6GEVb6QQV2EMUum//kkgKYXDCu1+43J1NPx4SsF47nNUR9iiO2xf7xiHXRl/40mFXvZ1GShN6AhtskFvrnD+K9LTqJFX7Ngd/JZ5H3K27Hx2g+rABVRRGyRV+Zdsy8G+P/XXjLjVBEscGpD/B9i/8/cdXP5L2riz7/73dHwqmutQV4qfcszHZOUTynQB/U3Xw5Sx0bNpZfE3Ut0Ld2zeIbDKtT2tMez9uZtS+HsGx/bhgPUK1c/GJK70S688GmBiXi5lZXccZ4i5D7mLh+7pCmEyY2oldhI/BdgWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJZJx8ZBzYnXnGZ6+VuH/+jy32Ma2GbCpeiY3pibzY4=;
 b=YtHwX4o1X0ISs35kOnmXV4DryVKvx7I8F2FM93FF6Unq/Mi8OR1UG9P0K4oh8waOU1aD7vS3AHjalg08J5NufxkP5/0ZYX4myZtsE5Xg+B8Q2gSBliduf3/1Tbi+Y55luA3sYuwGRH3XHiQrGxRRq+K/MSKBHleYAaesA2GjrAHbzJFlNkAVpVu223AZz+juMJLgArSwE18ConGQ3hvBCwE0urZdibd9o63sGTVZGWXOzwSoEl+nJFMNeXo34q6tOGyGRxuwXj5wsED0SnztcGs+2pV7na52/GsmrSJLdTy4Ae9X7CjfD0nBIxRb8xNo3KzrPxGuEHVtX/2McYWebQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJZJx8ZBzYnXnGZ6+VuH/+jy32Ma2GbCpeiY3pibzY4=;
 b=HtPwSJNrBf53vOYFd5LzjDHRqiZBvBbgKW2CwJr+z4UmovbBPvYD+8ym2FyYcy2aCaHoPVy2KzkQobCVTYd8en64r4I9OUgxXWK5M4nekpLOoJ46eFpvlZmGAzmp16MKS01+XU8t48DWLir97vyDU+60wiRbKWlrSagqWSRL1fQ=
Received: from BY5PR04MB6724.namprd04.prod.outlook.com (2603:10b6:a03:219::15)
 by BYAPR04MB5447.namprd04.prod.outlook.com (2603:10b6:a03:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Tue, 1 Dec
 2020 01:06:05 +0000
Received: from BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::1979:59c7:4906:3de9]) by BY5PR04MB6724.namprd04.prod.outlook.com
 ([fe80::1979:59c7:4906:3de9%3]) with mapi id 15.20.3611.022; Tue, 1 Dec 2020
 01:06:05 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "anup@brainfault.org" <anup@brainfault.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "wangkefeng.wang@huawei.com" <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH 0/6] Add SBI v0.2 support for KVM
Thread-Topic: [PATCH 0/6] Add SBI v0.2 support for KVM
Thread-Index: AQHWab/O9a87kiZfWEGc4txdcSb5ZancV0MAgAXRigA=
Date:   Tue, 1 Dec 2020 01:06:05 +0000
Message-ID: <47dc03619f0299480282e30bea560b600e673c50.camel@wdc.com>
References: <20200803175846.26272-1-atish.patra@wdc.com>
         <CAAhSdy0hrKNwOA4428Vf4mf32gZSw1cKiSXhhXB1s==yq7jEpA@mail.gmail.com>
In-Reply-To: <CAAhSdy0hrKNwOA4428Vf4mf32gZSw1cKiSXhhXB1s==yq7jEpA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: brainfault.org; dkim=none (message not signed)
 header.d=none;brainfault.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 183ec592-da55-4e95-da1a-08d89595475b
x-ms-traffictypediagnostic: BYAPR04MB5447:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5447CA30BDE6651273500E39FAF40@BYAPR04MB5447.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R2AsIT1BMNLs9rYsMPkDNQg3HKQq9up2rbqEje1ubR5gexooWRM4KfBET1LACSRjmUT9l7wSIXVpr+Atk9Cqg62QWZzlLTKxb0eCHoqp5WDGd5EvDI2994rBwKVW+u7X0ciMO+KD1PQVaj7WO9W0KJtxfHegYOi3aQ5gObGFyIHYx947yGDvEdpwkoT7WJqNbUpV0clWC6SKF62IxHKxoRaismg/ZzMN2VktkE4QLDv3iU50ns+UPXnzPG10NeHRmwtez+Mokw9czIwGkywjSI8dVCOmxoof3pmY1m6fu8YSzQil4ZUUrHuqWMeoxj3dDDyr8uLW11Y6tl5n5f3semGyxzGDHuWXFQWX5uIjKrnzDlVhKeD/4ACOJ2h5SWVP3MWiTbjhEOl7AYT/SGHBzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6724.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(36756003)(26005)(2616005)(54906003)(186003)(316002)(5660300002)(7416002)(66946007)(66556008)(64756008)(66446008)(66476007)(6506007)(6512007)(53546011)(76116006)(8936002)(2906002)(4001150100001)(966005)(8676002)(86362001)(6486002)(71200400001)(83380400001)(6916009)(4326008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: T/Hd6VNc333o7wX4WDAtYlgBC8iZp06JQTjZ2Ic/wpOoIxrA5dyiAKa+r4wUdYf5Puq6Jmrn8w0mcEwKLYQrWuzopky7mInpB2tl2DsqwI6tjoOxTt1mkVYRG42zy1u4I9NhV8AfZMjfNrTJ/cuxecNwr4cHAGNgfb06MqoRCr3/jd/CLVrY33Q53FQPl+IuBqaiAmOLfjnnoiD7n95BxMSLhzD0CXLLF0s9KwDbBsbRigFsQCXnmJUuu6Pd37fZlQRf0O5McBpv7e7LcM58NtU7hxsjCAL7g3YI5X7IHwVWb55YwdT0RSDgVP2srFQOGOB/2aPf6Pa6Dei7k/uuJS1d0YD6gpZva00vYyZ25jwkiUp18qNmFukSOYPqzNm9bYVJd6s6PrjaQ4c2hzE0QdlPcGbuEMSpa8ivH4WWqUUZBazdRpu8ee9BTxdIDQabsk5QTfZEUF3waaXedROLYglbKRWVYkKUGhVuZ38CasL8kZNBoK1IoKeuSxdSuALAH72dqkpxPBTFpNjirEAWyU8SCfTf9Y37aA4ZSilAE68bElGjKe7BrMeGClKL1WQ1MruzupKVHFe+YReDRelyD1IG2ambyBPunAhyUJc2ty9VS2TQav/qCZH7hBqows1tF7FxMCg8EGRqoNXBXU4j6p5tPe0Y18bAOEqFljs3jb/9Jv1O74hlJZUA8Xw6Bw52aOoV+1RRR7gYKGFcBWQtDz05RWMgQNILvoSzNMUDzyfVLaPVmwzUH0JB/OOqbkCF
Content-Type: text/plain; charset="utf-8"
Content-ID: <09986476A8868B4A8898C99D8519CCEB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6724.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183ec592-da55-4e95-da1a-08d89595475b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 01:06:05.1289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rZ7KI9iuFsyLw6sJbhnsk+pG6l/9I7HD4GElnUSzub2OstI9mz176SHD7yWyCojNvb+m6qb70maWOihSyohq1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTI3IGF0IDEzOjQ0ICswNTMwLCBBbnVwIFBhdGVsIHdyb3RlOg0KPiBP
biBNb24sIEF1ZyAzLCAyMDIwIGF0IDExOjI5IFBNIEF0aXNoIFBhdHJhIDxhdGlzaC5wYXRyYUB3
ZGMuY29tPg0KPiB3cm90ZToNCj4gPiANCj4gPiBUaGUgU3VwZXJ2aXNvciBCaW5hcnkgSW50ZXJm
YWNlKFNCSSkgc3BlY2lmaWNhdGlvblsxXSBub3cgZGVmaW5lcyBhDQo+ID4gYmFzZSBleHRlbnNp
b24gdGhhdCBwcm92aWRlcyBleHRlbmRhYmlsaXR5IHRvIGFkZCBmdXR1cmUgZXh0ZW5zaW9ucw0K
PiA+IHdoaWxlIG1haW50YWluaW5nIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgd2l0aCBwcmV2aW91
cyB2ZXJzaW9ucy4NCj4gPiBUaGUgbmV3IHZlcnNpb24gaXMgZGVmaW5lZCBhcyAwLjIgYW5kIG9s
ZGVyIHZlcnNpb24gaXMgbWFya2VkIGFzDQo+ID4gMC4xLg0KPiA+IA0KPiA+IFRoaXMgc2VyaWVz
IGFkZHMgZm9sbG93aW5nIGZlYXR1cmVzIHRvIFJJU0MtViBMaW51eCBLVk0uDQo+ID4gMS4gQWRk
cyBzdXBwb3J0IGZvciBTQkkgdjAuMiBpbiBLVk0NCj4gPiAyLiBTQkkgSGFydCBzdGF0ZSBtYW5h
Z2VtZW50IGV4dGVuc2lvbiAoSFNNKSBpbiBLVk0NCj4gPiAzLiBPcmRlcmVkIGJvb3Rpbmcgb2Yg
Z3Vlc3QgdmNwdXMgaW4gZ3Vlc3QgTGludXgNCj4gPiANCj4gPiBUaGlzIHNlcmllcyBkZXBlbmRz
IG9uIHRoZSBiYXNlIGt2bSBzdXBwb3J0IHNlcmllc1syXS4NCj4gPiANCj4gPiBHdWVzdCBrZXJu
ZWwgbmVlZHMgdG8gYWxzbyBzdXBwb3J0IFNCSSB2MC4yIGFuZCBIU00gZXh0ZW5zaW9uIGluDQo+
ID4gS2VybmVsDQo+ID4gdG8gYm9vdCBtdWx0aXBsZSB2Y3B1cy4gTGludXgga2VybmVsIHN1cHBv
cnRzIGJvdGggc3RhcnRpbmcgdjUuNy4NCj4gPiBJbiBhYnNlbnNlIG9mIHRoYXQsIGd1ZXN0IGNh
biBvbmx5IGJvb3QgMXZjcHUuDQo+ID4gDQo+ID4gWzFdICANCj4gPiBodHRwczovL2dpdGh1Yi5j
b20vcmlzY3YvcmlzY3Ytc2JpLWRvYy9ibG9iL21hc3Rlci9yaXNjdi1zYmkuYWRvYw0KPiA+IFsy
XSAgDQo+ID4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvcGlwZXJtYWlsL2xpbnV4LXJpc2N2
LzIwMjAtSnVseS8wMDEwMjguaHRtbA0KPiA+IA0KPiA+IEF0aXNoIFBhdHJhICg2KToNCj4gPiBS
SVNDLVY6IEFkZCBhIG5vbi12b2lkIHJldHVybiBmb3Igc2JpIHYwMiBmdW5jdGlvbnMNCj4gPiBS
SVNDLVY6IE1hcmsgdGhlIGV4aXN0aW5nIFNCSSB2MC4xIGltcGxlbWVudGF0aW9uIGFzIGxlZ2Fj
eQ0KPiA+IFJJU0MtVjogUmVvcmdhbml6ZSBTQkkgY29kZSBieSBtb3ZpbmcgbGVnYWN5IFNCSSB0
byBpdHMgb3duIGZpbGUNCj4gPiBSSVNDLVY6IEFkZCBTQkkgdjAuMiBiYXNlIGV4dGVuc2lvbg0K
PiA+IFJJU0MtVjogQWRkIHYwLjEgcmVwbGFjZW1lbnQgU0JJIGV4dGVuc2lvbnMgZGVmaW5lZCBp
biB2MDINCj4gPiBSSVNDLVY6IEFkZCBTQkkgSFNNIGV4dGVuc2lvbiBpbiBLVk0NCj4gPiANCj4g
PiBhcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL2t2bV92Y3B1X3NiaS5oIHzCoCAzMiArKysrKw0KPiA+
IGFyY2gvcmlzY3YvaW5jbHVkZS9hc20vc2JpLmjCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDE3ICsr
LQ0KPiA+IGFyY2gvcmlzY3Yva2VybmVsL3NiaS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8wqAgMzIgKystLS0NCj4gPiBhcmNoL3Jpc2N2L2t2bS9NYWtlZmlsZcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfMKgwqAgNCArLQ0KPiA+IGFyY2gvcmlzY3Yva3ZtL3ZjcHUuY8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAxOSArKysNCj4gPiBhcmNoL3Jpc2N2L2t2
bS92Y3B1X3NiaS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTk0ICsrKysrKysrKysrKy0t
LS0tLS0tLS0tDQo+ID4gLS0tDQo+ID4gYXJjaC9yaXNjdi9rdm0vdmNwdV9zYmlfYmFzZS5jwqDC
oMKgwqDCoMKgwqAgfMKgIDczICsrKysrKysrKysNCj4gPiBhcmNoL3Jpc2N2L2t2bS92Y3B1X3Ni
aV9oc20uY8KgwqDCoMKgwqDCoMKgwqAgfCAxMDkgKysrKysrKysrKysrKysrDQo+ID4gYXJjaC9y
aXNjdi9rdm0vdmNwdV9zYmlfbGVnYWN5LmPCoMKgwqDCoMKgIHwgMTI5ICsrKysrKysrKysrKysr
KysrDQo+ID4gYXJjaC9yaXNjdi9rdm0vdmNwdV9zYmlfcmVwbGFjZS5jwqDCoMKgwqAgfCAxMzYg
KysrKysrKysrKysrKysrKysrDQo+ID4gMTAgZmlsZXMgY2hhbmdlZCwgNjE5IGluc2VydGlvbnMo
KyksIDEyNiBkZWxldGlvbnMoLSkNCj4gPiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9yaXNjdi9p
bmNsdWRlL2FzbS9rdm1fdmNwdV9zYmkuaA0KPiA+IGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL3Jp
c2N2L2t2bS92Y3B1X3NiaV9iYXNlLmMNCj4gPiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9yaXNj
di9rdm0vdmNwdV9zYmlfaHNtLmMNCj4gPiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9yaXNjdi9r
dm0vdmNwdV9zYmlfbGVnYWN5LmMNCj4gPiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9yaXNjdi9r
dm0vdmNwdV9zYmlfcmVwbGFjZS5jDQo+ID4gDQo+ID4gLS0NCj4gPiAyLjI0LjANCj4gPiANCj4g
DQo+IFBsZWFzZSBpbXBsZW1lbnQgdGhlIFNCSSBTUlNUIGV4dGVuc2lvbiBpbiB5b3VyIHNlcmll
cy4NCj4gDQoNClllYWguIEkgd2lsbCB1cGRhdGUgdGhlIHNlcmllcyBhcyBwZXIgbmV3IFNSU1Qg
ZXh0ZW5zaW9uLg0KDQo+IEFsc28sIHRoZSBQQVRDSDEgY2FuIGJlIG1lcmdlZCBzZXBhcmF0ZWx5
IHNvIEkgd291bGQgc3VnZ2VzdA0KPiB5b3UgdG8gc2VuZCB0aGlzIHBhdGNoIHNlcGFyYXRlbHku
DQo+IA0KDQpTdXJlIHdpbGwgZG8gdGhhdC4NCg0KPiBSZWdhcmRzLA0KPiBBbnVwDQoNCi0tIA0K
UmVnYXJkcywNCkF0aXNoDQo=

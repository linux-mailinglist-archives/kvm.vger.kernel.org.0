Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221C2EF765
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 09:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbfKEIkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 03:40:35 -0500
Received: from mail-eopbgr10122.outbound.protection.outlook.com ([40.107.1.122]:29310
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727727AbfKEIkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 03:40:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDflwlgEKXfVNB5IUVjDEOTJ9emFUkIckZYC0yVvPmq14E+jdSKB3Kcyh+ejAabiBwFtODalyc6B4IiWsp6sj5nDc3f/5DmfIG0kMa+JA8RVZ1tGxU64iV7ZgX58NWDxAFojlnh0KS/m3wpXqpIAJXj57PwMKPm/cJLv9I7RvyGJ2IiQSGuuaEwStdxqyIfd2vGgMgl/RjTDM/CVVZ+UIMsCMHq9TMErIjzxPji0SosP27RqnKz0enOt85YdH85jI1Mh79SyiNXbjToBPpnBZCQ8Rx93/7Gy4criEhKsY4jVpM4a3f5Vzb2ivPV46cHUD9GPwIkVRdU/7mrN7jwOtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YP/RiRz7SiiovX7RUAXKCyPC0QC6ZLVXAZIyrH7ww28=;
 b=Ph5uQJi3hlgsx/EOmBcbgqcr5MaoikBeLOy2PVSbZMh1xheju6OTNoAGENRALji4F+Qj7eNDE5BONIE4V5WIKsNJ6IHJqXrvN5oGGqB2KEDbFLa1lQvgniaPM3apnS8CVm/b1BP4RfqEX+SC4Dc3hhBwJJ/myCY7yBK39bU+YJLAVZhFvHolH4T/a9UBamRUbKhPRQaSca/LbWUQatiQAYHQkr6xChReFUA1GVTq6PRYCdkEBuXd4fFiPcJXiCf2k+z4OJDSZkvAzx9AvAfGcZ+dKab4czRxRQmOJi4IPrd2HDm9SNoYCW9KjqjMZFk7cBpn3OA7EJ+Tyij9DBc+gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YP/RiRz7SiiovX7RUAXKCyPC0QC6ZLVXAZIyrH7ww28=;
 b=A2pZXQhvZv7NyUdep9PguSi7ikDj54s9uo/vjzvMvqlUVZJENdLBlQchUtWWoDwF2b6XiKm3MpecxCAHWjEqyjT31hQgL3YKz5oYN4UDE6S5IDgjKJN8X7ZfkXE1gPiYFuyn1FpEXL8BaZcrgAv4HztBWTT+XZ644EbapNdFXRU=
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com (10.172.218.15) by
 AM4PR0802MB2147.eurprd08.prod.outlook.com (10.172.219.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 08:40:28 +0000
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89]) by AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89%12]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 08:40:28 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     "Graf (AWS), Alexander" <graf@amazon.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Schoenherr, Jan H." <jschoenh@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Lukaszewicz, Rimas" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Topic: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Index: AQHVkQWIuGEgJ7JXrk6/VQ6c7w+tYad3peqAgAO6v4CAADC9AIAAm4CAgAAaYwA=
Date:   Tue, 5 Nov 2019 08:40:28 +0000
Message-ID: <20191105084024.GA10988@rkaganb.lan>
References: <4e4bd2c3-50c4-b23e-2924-728a37a5f157@redhat.com>
 <7060AA92-0ACD-40F6-868A-5A7234F46C55@amazon.de>
In-Reply-To: <7060AA92-0ACD-40F6-868A-5A7234F46C55@amazon.de>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,        "Graf (AWS),
 Alexander" <graf@amazon.de>,   Paolo Bonzini <pbonzini@redhat.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,    "rkrcmar@redhat.com"
 <rkrcmar@redhat.com>,  "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,    "Schoenherr, Jan H."
 <jschoenh@amazon.de>,  "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Lukaszewicz, Rimas" <rimasluk@amazon.com>,     "Grimm, Jon" <Jon.Grimm@amd.com>
x-originating-ip: [2a02:2168:9049:de00::ed5]
x-clientproxiedby: HE1PR0101CA0010.eurprd01.prod.exchangelabs.com
 (2603:10a6:3:77::20) To AM4PR0802MB2242.eurprd08.prod.outlook.com
 (2603:10a6:200:5f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cf80ca0-00f2-458c-6182-08d761cbcf5f
x-ms-traffictypediagnostic: AM4PR0802MB2147:
x-microsoft-antispam-prvs: <AM4PR0802MB21478D86C8ABD62F1055B23FC97E0@AM4PR0802MB2147.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(39840400004)(376002)(396003)(189003)(199004)(14454004)(81156014)(8676002)(14444005)(6246003)(305945005)(71190400001)(81166006)(71200400001)(86362001)(66946007)(66476007)(66556008)(476003)(11346002)(446003)(66446008)(64756008)(486006)(33656002)(36756003)(8936002)(316002)(186003)(46003)(6506007)(386003)(76176011)(102836004)(54906003)(58126008)(6436002)(6116002)(7416002)(6916009)(9686003)(7736002)(229853002)(6486002)(2906002)(52116002)(99286004)(25786009)(478600001)(4326008)(5660300002)(1076003)(6512007)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM4PR0802MB2147;H:AM4PR0802MB2242.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IatHeS+1mEsD+/71Hi21pifEX2tj0u8CACZJqzTdMRjh7g2EaW/XHEVxXB8I8zJ39GrSV0FyM0/T0F2/Pi9mgfpxhE0ConAje7cW5DZe2DXgwoUzsA5l50KD0nIP/kBXJid4Po2112IkwFq0gaTjXKCdta3zZvGyW/fbdz3YLt6ptByf4/DSvO6ADdut8Pmehcg+t+7W1d9HnIiA5CjYcSfP90AAWV5c++6FshLcCbbQrh8kWVJ8oCUWUsdTgren3Ld3qXko2721XJ25GZZyJGIxXBvdGenUwdHh0xyiiNP1MEzCul16Gongl0CMQzyzI7SHziT1j6SFEwsNLBKgikDPPxv6P0c2ACBb/fMzqzaddQ/7JFOll/YPKxlM88nN+mEfj9OxPxYX7iK60vV7tKjA+mzeEfwKO+ren+vuFZc1rI+PnhmrUEjq+FwVQiO3
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B8C349F54FA6648A85F68AFD1D44DF5@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf80ca0-00f2-458c-6182-08d761cbcf5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 08:40:28.4463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJBT2rF0vg81H+XMab25mmHEH9eKtjikIYKIqFuNuuJCWHdElpkuJMV2BEJvL0WvbDK6QZ6ZuDpWt4kB+Bm3Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0802MB2147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCBOb3YgMDUsIDIwMTkgYXQgMDc6MDU6NTdBTSArMDAwMCwgR3JhZiAoQVdTKSwgQWxl
eGFuZGVyIHdyb3RlOg0KPiANCj4gDQo+ID4gQW0gMDQuMTEuMjAxOSB1bSAyMjo1MCBzY2hyaWVi
IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+Og0KPiA+IA0KPiA+IO+7v09uIDA0
LzExLzE5IDE5OjU0LCBTdXRoaWt1bHBhbml0LCBTdXJhdmVlIHdyb3RlOg0KPiA+PiBJIHNlZSB5
b3UgcG9pbnQuDQo+ID4+IA0KPiA+Pj4gV2UgY2FuIHdvcmsgYXJvdW5kIGl0IGJ5IGFkZGluZyBh
IGdsb2JhbCBtYXNrIG9mIGluaGliaXQgcmVhc29ucyB0aGF0DQo+ID4+PiBhcHBseSB0byB0aGUg
dmVuZG9yLCBhbmQgaW5pdGlhbGl6aW5nIGl0IGFzIHNvb24gYXMgcG9zc2libGUgaW4gdm14LmMv
c3ZtLmMuDQo+ID4+PiANCj4gPj4+IFRoZW4ga3ZtX3JlcXVlc3RfYXBpY3ZfdXBkYXRlIGNhbiBp
Z25vcmUgcmVhc29ucyB0aGF0IHRoZSB2ZW5kb3IgZG9lc24ndA0KPiA+Pj4gY2FyZSBhYm91dC4N
Cj4gPj4gDQo+ID4+IFdoYXQgYWJvdXQgd2UgZW5oYW5jZSB0aGUgcHJlX3VwZGF0ZV9hcGl2Y19l
eGVjX2N0cmwoKSB0byBhbHNvIHJldHVybiANCj4gPj4gc3VjY2Vzcy9mYWlsLiBJbiBoZXJlLCB0
aGUgdmVuZG9yIHNwZWNpZmljIGNvZGUgY2FuIGRlY2lkZSB0byB1cGRhdGUgDQo+ID4+IEFQSUN2
IHN0YXRlIG9yIG5vdC4NCj4gPiANCj4gPiBUaGF0IHdvcmtzIGZvciBtZSwgdG9vLiAgU29tZXRo
aW5nIGxpa2UgcmV0dXJuIGZhbHNlIGZvciBkZWFjdGl2YXRlIGFuZA0KPiA+IHRydWUgZm9yIGFj
dGl2YXRlLg0KPiANCj4gSSdtIHRyeWluZyB0byB3cmFwIG15IGhlYWQgYXJvdW5kIGhvdyB0aGF0
IHdpbGwgd29yayB3aXRoIGxpdmUNCj4gbWlncmF0aW9uLiBEbyB3ZSBhbHNvIG5lZWQgdG8gc2F2
ZS9yZXN0b3JlIHRoZSBkZWFjdGl2YXRlIHJlYXNvbnM/DQoNCk5vcGUsIHRoaXMgaXMgYWxsIGlu
dmlzaWJsZSB0byB1c2VybGFuZC4gIFRoZSB0YXJnZXQgd2lsbCBkZWR1Y2UgdGhlDQpkZWFjdGl2
YXRpb24gcmVhc29ucyBvbiBpdHMgb3duIGZyb20gdGhlIHVzZXItdmlzaWJsZSBzZXR1cCBsaWtl
IFBJVA0KY29uZmlndXJhdGlvbiwgSHlwZXItViBTeW5JQywgZXRjLg0KDQpSb21hbi4NCg==

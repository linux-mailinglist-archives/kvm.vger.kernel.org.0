Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563ED245E41
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 09:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgHQHoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 03:44:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:43518 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgHQHoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 03:44:10 -0400
IronPort-SDR: RJrJgxC/l3JBdmRB/V/iKv2HZhDGsORutXuZCDNzrj/x9lMl2Gnzv4X9PAef37K72DGKFIMhW3
 QGroTpODnxGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="152298098"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="152298098"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 00:43:59 -0700
IronPort-SDR: tsVqMlXrpHhkkAKIa0XBNobL+qNQSzCVdbL7eZ5tSEA3ImioS5eDC4Youbw3mfJVXCMoOMGhzy
 PVk93UgKjjhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="328537783"
Received: from orsmsx602-2.jf.intel.com (HELO ORSMSX602.amr.corp.intel.com) ([10.22.229.82])
  by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2020 00:43:58 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Aug 2020 00:43:58 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Aug 2020 00:43:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Aug 2020 00:43:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEWDJiZw7CysayIwtFH3csJ2OXa5JFqfwh2rw0k9TG5g0DZMchVzvSdVssJnEJlEd3HP13C4s2aMBTjuFcB5UleCf2T8uEzOFZI1J83PXAPLdOCqbZna8VM5w9hi6zsDbh2V9gb7wYYlwroH92d9w0LBHZPngRIzWKdRr56t/G934Z2nl10GRYngQf7AJjF/i8OjVBlu2+r8PPo1z7NgZzDhJtpsaI1yUPNENf3+0qFaADQceP+r5STxcOu0wDj0PneggefXgo75v2cn6iDmI1b7qarVPn9u8/rqm8dKvYjN9u1yqfz2xgMXiJKxQAbgkjwssg9fP5zxeNSoE9eH1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6Eo3zL5WXJPKDuDr04VEVGa9jrLssHguoTLuYNqYcY=;
 b=hc9HHarrMCi6zkHRx+w4F4kLFFpiAc+0xerqKh4UMqlmkWYNky1D6gVzkGkSqu+Ai845zj85na6jpk8C+KtfRtwQm2nUceRsnAGq0cw+dm188JoldznSYTLDvYuIX2me2QuQhji6qe8FIsWuZwULXODwkOZIfGQUpsPXjc+Dttj68q56KiwlKmyHsBDjndIrb8eLUFYDrMW9jBYqb7r6ftbc1+6aV1DNaY6xS0VY5dRMsV+9EjKy0ovYCsnKxmV0owJrlJPC1oS/odgddGaW95qYQDzC7JczKLWT6IlaMJ2836ZANOdpn4VYeCHyM7lPn+2aR1rmk9xMDiRkWaCjKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6Eo3zL5WXJPKDuDr04VEVGa9jrLssHguoTLuYNqYcY=;
 b=oy90Nmn3+1dyINX1a5CO7J9nM8QlgPi/jyakDevSnUM6YjoycUQw5a92t27Iw99qkHHzd+p/rtQhGtwtB6yBj8XHTRVKyrEBJC560Jrbxb47ykMJpjzRRb0DjWru2rq7XrPCf2a/OTAmSN9vXDvYALSwjeO9l8lE3Jom6VDTQFE=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1434.namprd11.prod.outlook.com (2603:10b6:4:9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.23; Mon, 17 Aug 2020 07:43:56 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3283.027; Mon, 17 Aug
 2020 07:43:56 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Eric Auger <eric.auger.pro@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 14/15] vfio: Document dual stage control
Thread-Topic: [PATCH v6 14/15] vfio: Document dual stage control
Thread-Index: AQHWZKdJ3vOT/2BJCk+0yd/zBgmH2qk6vfCAgAE7MtCAABENAIAAAFlA
Date:   Mon, 17 Aug 2020 07:43:56 +0000
Message-ID: <DM5PR11MB1435D842940003FD945EA287C35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-15-git-send-email-yi.l.liu@intel.com>
 <aa1297cb-2bde-0cea-70a4-fc8f56d745e6@redhat.com>
 <DM5PR11MB143519ABA63F46D7864E9EA2C35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <77c8b564-d8b8-4169-3556-5e0d91d3ea9b@gmail.com>
In-Reply-To: <77c8b564-d8b8-4169-3556-5e0d91d3ea9b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2e4d5e6-7d38-4d98-b2d1-08d842814bd8
x-ms-traffictypediagnostic: DM5PR11MB1434:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB14341715CDFAD7D9FEAF006AC35F0@DM5PR11MB1434.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OWRT8oRguwTCIy4UMYAS5P1Jg4vdSaHVh4+4yujwWEp+fvgHdsPKSiT2PHsFhEbIKBbC5YPSv8K/VYVXi3Q4dqeaoIcj2J/KGsA322xfktiqDLdRMk2VtSzxF1HeeMRqwUW/reLFqQEEwKanJpjRfMDu7Rh9oHxXLijAmoqqDgklLCGUTuS/Td92N+ynJhZctoyPynERXA+F8QmxRdj34HsTWaEfpPxAQIsEyQq0AE4pb8Y6o0iyh+enBjrYCW76D72dY37zLyr2qDg9G1Nt0rrl1pmyTaTt2W6IkmNA26yZ8qM7zJ0AAgHqQCziVLfiD5NCqxVkH0z7DNQ3rlF8uwafPmbCUoSi7Jt/YlHTR21D6utLB7AZEZpwWKbggH5KQ/xXZeoCEG7kvPCCKkiJ0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(66476007)(64756008)(66446008)(8676002)(83380400001)(86362001)(316002)(110136005)(54906003)(66556008)(52536014)(76116006)(66946007)(53546011)(9686003)(55016002)(7416002)(5660300002)(71200400001)(26005)(186003)(2906002)(8936002)(4326008)(33656002)(7696005)(478600001)(966005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iv2Za31U/zeWVXXhvOqeucr/6tpFXWCUKUQHm1WfiqZw/Ejt6njeM7NAvgD1Bp1l411exRglKYfJczzkd8eyYIkZ6c5arwXpdqIvqtHKBAUFXBPhXle1qCzfjaYKnijRyWnRclHTWf4fGxnjlPCYFb+3QwixUmWQomThLG3NnM3InKTQehPWi9SobEnL+0Afts0KJO5J8AUeDzbp+foPF2PuaSzlSsbK0R8iYXR6FY/s4D+9gTYL9C7h0beAWQkUYpuJTu/kKzyuljFTuSdvuKxpYeal7JAZBFzkMRZnpcKMFc3bHtyXmmUeOot2cPcHlWB/WXk9E/UQKkxlCsIHewnWnTSNtcm6YD6vbVnNpNgz7DoAvxPuwv5sexdx7hwDJgHLJub1EVpcdSlpISJsPd77poiaiHxOCgtnro2tgw6nA+/2+zjyjQNk+Rv9HHVaowpjDq6reyAmEs18+lVClRtXBB48yUCQZ3svhrfJjPjBudvhsLyZnQKcU8+jLNolyBNxSeyE4Nvx9SRFG2r9PLpWS3VEexbM0aA+Y2pKsA0CT5uy+hS4jg9xZx/9XgcRzxLnv2i9hvuQVsNW4gmajGh3M+tRPHNX5WOHp5NZIe5KsOhlxoDSz98w1h7Y+qPqAm42qmHs+GoAxnWgOJO1SQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2e4d5e6-7d38-4d98-b2d1-08d842814bd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 07:43:56.1923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qol1Gyt+Aa0ZFc8+wIPywiOu26Vht5t7a8gflYrNaGbSOPaJCrkBG8ZLYCJ6bMdTT1wxL+rESxp2zCGrSMUQJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1434
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyLnByb0BnbWFpbC5jb20+
DQo+IFNlbnQ6IE1vbmRheSwgQXVndXN0IDE3LCAyMDIwIDM6NDEgUE0NCj4gDQo+IEhpIFlpLA0K
PiANCj4gT24gOC8xNy8yMCA5OjAwIEFNLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gSGkgRXJpYywN
Cj4gPg0KPiA+PiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4+
IFNlbnQ6IFN1bmRheSwgQXVndXN0IDE2LCAyMDIwIDc6NTIgUE0NCj4gPj4NCj4gPj4gSGkgWWks
DQo+ID4+DQo+ID4+IE9uIDcvMjgvMjAgODoyNyBBTSwgTGl1IFlpIEwgd3JvdGU6DQo+ID4+PiBG
cm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4+Pg0KPiA+Pj4gVGhl
IFZGSU8gQVBJIHdhcyBlbmhhbmNlZCB0byBzdXBwb3J0IG5lc3RlZCBzdGFnZSBjb250cm9sOiBh
IGJ1bmNoDQo+ID4+PiBvZj4gbmV3DQo+ID4+IGlvY3RscyBhbmQgdXNhZ2UgZ3VpZGVsaW5lLg0K
PiA+Pj4NCj4gPj4+IExldCdzIGRvY3VtZW50IHRoZSBwcm9jZXNzIHRvIGZvbGxvdyB0byBzZXQg
dXAgbmVzdGVkIG1vZGUuDQo+ID4+Pg0KPiA+Pj4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5A
aW50ZWwuY29tPg0KPiA+Pj4gQ0M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRl
bC5jb20+DQo+ID4+PiBDYzogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0
LmNvbT4NCj4gPj4+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4+
PiBDYzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+
ID4+PiBDYzogSm9lcmcgUm9lZGVsIDxqb3JvQDhieXRlcy5vcmc+DQo+ID4+PiBDYzogTHUgQmFv
bHUgPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4NCj4gPj4+IFJldmlld2VkLWJ5OiBTdGVmYW4g
SGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBFcmlj
IEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBMaXUg
WWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+Pj4gLS0tDQo+ID4+PiB2NSAtPiB2NjoNCj4g
Pj4+ICopIHR3ZWFrIHBlciBFcmljJ3MgY29tbWVudHMuDQo+ID4+Pg0KPiA+Pj4gdjMgLT4gdjQ6
DQo+ID4+PiAqKSBhZGQgcmV2aWV3LWJ5IGZyb20gU3RlZmFuIEhham5vY3ppDQo+ID4+Pg0KPiA+
Pj4gdjIgLT4gdjM6DQo+ID4+PiAqKSBhZGRyZXNzIGNvbW1lbnRzIGZyb20gU3RlZmFuIEhham5v
Y3ppDQo+ID4+Pg0KPiA+Pj4gdjEgLT4gdjI6DQo+ID4+PiAqKSBuZXcgaW4gdjIsIGNvbXBhcmVk
IHdpdGggRXJpYydzIG9yaWdpbmFsIHZlcnNpb24sIHBhc2lkIHRhYmxlIGJpbmQNCj4gPj4+ICAg
IGFuZCBmYXVsdCByZXBvcnRpbmcgaXMgcmVtb3ZlZCBhcyB0aGlzIHNlcmllcyBkb2Vzbid0IGNv
dmVyIHRoZW0uDQo+ID4+PiAgICBPcmlnaW5hbCB2ZXJzaW9uIGZyb20gRXJpYy4NCj4gPj4+ICAg
IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIwLzMvMjAvNzAwDQo+ID4+PiAtLS0NCj4gPj4+ICBE
b2N1bWVudGF0aW9uL2RyaXZlci1hcGkvdmZpby5yc3QgfCA3NQ0KPiA+PiArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPj4+ICAxIGZpbGUgY2hhbmdlZCwgNzUgaW5z
ZXJ0aW9ucygrKQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RyaXZl
ci1hcGkvdmZpby5yc3QNCj4gPj4+IGIvRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0
DQo+ID4+PiBpbmRleCBmMWE0ZDNjLi5jMGQ0M2YwIDEwMDY0NA0KPiA+Pj4gLS0tIGEvRG9jdW1l
bnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0DQo+ID4+PiArKysgYi9Eb2N1bWVudGF0aW9uL2Ry
aXZlci1hcGkvdmZpby5yc3QNCj4gPj4+IEBAIC0yMzksNiArMjM5LDgxIEBAIGdyb3VwIGFuZCBj
YW4gYWNjZXNzIHRoZW0gYXMgZm9sbG93czo6DQo+ID4+PiAgCS8qIEdyYXR1aXRvdXMgZGV2aWNl
IHJlc2V0IGFuZCBnby4uLiAqLw0KPiA+Pj4gIAlpb2N0bChkZXZpY2UsIFZGSU9fREVWSUNFX1JF
U0VUKTsNCj4gPj4+DQo+ID4+PiArSU9NTVUgRHVhbCBTdGFnZSBDb250cm9sDQo+ID4+PiArLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+PiArDQo+ID4+PiArU29tZSBJT01NVXMgc3VwcG9y
dCAyIHN0YWdlcy9sZXZlbHMgb2YgdHJhbnNsYXRpb24uIFN0YWdlDQo+ID4+PiArY29ycmVzcG9u
ZHMgdG8gdGhlIEFSTSB0ZXJtaW5vbG9neSB3aGlsZSBsZXZlbCBjb3JyZXNwb25kcyB0byBJbnRl
bCdzDQo+IHRlcm1pbm9sb2d5Lg0KPiA+Pj4gK0luIHRoZSBmb2xsb3dpbmcgdGV4dCB3ZSB1c2Ug
ZWl0aGVyIHdpdGhvdXQgZGlzdGluY3Rpb24uDQo+ID4+PiArDQo+ID4+PiArVGhpcyBpcyB1c2Vm
dWwgd2hlbiB0aGUgZ3Vlc3QgaXMgZXhwb3NlZCB3aXRoIGEgdmlydHVhbCBJT01NVSBhbmQNCj4g
Pj4+ICtzb21lIGRldmljZXMgYXJlIGFzc2lnbmVkIHRvIHRoZSBndWVzdCB0aHJvdWdoIFZGSU8u
IFRoZW4gdGhlIGd1ZXN0DQo+ID4+PiArT1MgY2FuIHVzZSBzdGFnZS0xIChHSU9WQSAtPiBHUEEg
b3IgR1ZBLT5HUEEpLCB3aGlsZSB0aGUgaHlwZXJ2aXNvcg0KPiA+Pj4gK3VzZXMgc3RhZ2UNCj4g
Pj4+ICsyIGZvciBWTSBpc29sYXRpb24gKEdQQSAtPiBIUEEpLg0KPiA+Pj4gKw0KPiA+Pj4gK1Vu
ZGVyIGR1YWwgc3RhZ2UgdHJhbnNsYXRpb24sIHRoZSBndWVzdCBnZXRzIG93bmVyc2hpcCBvZiB0
aGUNCj4gPj4+ICtzdGFnZS0xIHBhZ2UgdGFibGVzIGFuZCBhbHNvIG93bnMgc3RhZ2UtMSBjb25m
aWd1cmF0aW9uIHN0cnVjdHVyZXMuDQo+ID4+PiArVGhlIGh5cGVydmlzb3Igb3ducyB0aGUgcm9v
dCBjb25maWd1cmF0aW9uIHN0cnVjdHVyZSAoZm9yIHNlY3VyaXR5DQo+ID4+PiArcmVhc29uKSwg
aW5jbHVkaW5nIHN0YWdlLTIgY29uZmlndXJhdGlvbi4NCj4gPj4gVGhpcyBpcyBvbmx5IHRydWUg
Zm9yIHZ0ZC4gT24gQVJNIHRoZSBzdGFnZTIgY2ZnIGlzIHRoZSBDb250ZXh0DQo+ID4+IERlc2Ny
aXB0b3IgdGFibGUgKGFrYSBQQVNJRCB0YWJsZSkuIHJvb3QgY2ZnIG9ubHkgc3RvcmUgdGhlIEdQ
QSBvZg0KPiA+PiB0aGUgQ0QgdGFibGUuDQo+ID4NCj4gPiBJJ3ZlIGEgY2hlY2sgd2l0aCB5b3Ug
b24gdGhlIG1lYW5pbmcgb2YgImNvbmZpZ3VyYXRpb24gc3RydWN0dXJlcyIuDQo+ID4gRm9yIFZ0
LWQsIGRvZXMgaXQgbWVhbiB0aGUgcm9vdCB0YWJsZS9jb250ZXh0IHRhYmxlL3Bhc2lkIHRhYmxl
PyBpZg0KPiA+IEknbSBjb3JyZWN0LCB0aGVuIGhvdyBhYm91dCBiZWxvdyBkZXNjcmlwdGlvbj8N
Cj4gWWVzIEkgYWdyZWUNCg0KdGhhbmtzLg0KDQo+ID4NCj4gPiAiVW5kZXIgZHVhbCBzdGFnZSB0
cmFuc2xhdGlvbiwgdGhlIGd1ZXN0IGdldHMgb3duZXJzaGlwIG9mIHRoZSBzdGFnZS0xDQo+ID4g
Y29uZmlndXJhdGlvbiBzdHJ1Y3R1cmVzIG9yIHBhZ2UgdGFibGVzLg0KPiBBY3R1YWxseSBvbiBB
Uk0gdGhlIGd1ZXN0IGJvdGggb3ducyB0aGUgUzEgY29uZmlndXJhdGlvbiAoQ0QgdGFibGUpIGFu
ZA0KPiBTMSBwYWdlIHRhYmxlcyA7LSkNCg0KSSBzZWUuIHNvIG9uIEFSTSBwbGF0Zm9ybSwgZ3Vl
c3Qgb3ducyBib3RoIGNvbmZpZ3VyYXRpb24gYW5kIHBhZ2UgdGFibGUuDQoNCj4gb24gSW50ZWwg
SSB1bmRlcnN0YW5kIHRoZSBndWVzdCBvbmx5IG93bnMgdGhlIFMxIHBhZ2UgdGFibGVzLg0KDQp5
ZXMsIG9uIEludGVsLCBndWVzdCBvbmx5IG93bnMgdGhlIFMxIHBhZ2UgdGFibGVzLg0KDQo+IElm
IGNvbmZpcm1lZCwgeW91IG1heSB1c2Ugc3VjaCBraW5kIG9mIGV4cGxpY2l0IHN0YXRlbWVudC4N
Cg0Kd2lsbCBkby4NCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0K
PiANCj4gIFRoaXMgZGVwZW5kcyBvbiB2ZW5kb3IuIFRoZQ0KPiA+IGh5cGVydmlzb3Igb3ducyB0
aGUgcm9vdCBjb25maWd1cmF0aW9uIHN0cnVjdHVyZSAoZm9yIHNlY3VyaXR5DQo+ID4gcmVhc29u
KSwgaW5jbHVkaW5nIHN0YWdlLTIgY29uZmlndXJhdGlvbi4iDQo+ID4NCj4gPj4gIFRoaXMgd29y
a3MgYXMgbG9uZyBhcyBjb25maWd1cmF0aW9uIHN0cnVjdHVyZXMgYW5kIHBhZ2UgdGFibGUNCj4g
Pj4+ICtmb3JtYXRzIGFyZSBjb21wYXRpYmxlIGJldHdlZW4gdGhlIHZpcnR1YWwgSU9NTVUgYW5k
IHRoZSBwaHlzaWNhbCBJT01NVS4NCj4gPj4+ICsNCj4gPj4+ICtBc3N1bWluZyB0aGUgSFcgc3Vw
cG9ydHMgaXQsIHRoaXMgbmVzdGVkIG1vZGUgaXMgc2VsZWN0ZWQgYnkNCj4gPj4+ICtjaG9vc2lu
ZyB0aGUgVkZJT19UWVBFMV9ORVNUSU5HX0lPTU1VIHR5cGUgdGhyb3VnaDoNCj4gPj4+ICsNCj4g
Pj4+ICsgICAgaW9jdGwoY29udGFpbmVyLCBWRklPX1NFVF9JT01NVSwgVkZJT19UWVBFMV9ORVNU
SU5HX0lPTU1VKTsNCj4gPj4+ICsNCj4gPj4+ICtUaGlzIGZvcmNlcyB0aGUgaHlwZXJ2aXNvciB0
byB1c2UgdGhlIHN0YWdlLTIsIGxlYXZpbmcgc3RhZ2UtMQ0KPiA+Pj4gK2F2YWlsYWJsZSBmb3Ig
Z3Vlc3QgdXNhZ2UuIFRoZSBzdGFnZS0xIGZvcm1hdCBhbmQgYmluZGluZyBtZXRob2QNCj4gPj4+
ICthcmUgdmVuZG9yIHNwZWNpZmljDQo+ID4+IC4gVGhlcmUgYXJlIHJlcG9ydGVkIGluIHRoZSBu
ZXN0aW5nIGNhcGFiaWxpdHkgLi4uDQo+ID4NCj4gPiBnb3QgaXQuDQo+ID4NCj4gPiAiVGhlIHN0
YWdlLTEgZm9ybWF0IGFuZCBiaW5kaW5nIG1ldGhvZCBhcmUgcmVwb3J0ZWQgaW4gbmVzdGluZyBj
YXBhYmlsaXR5LiINCj4gPg0KPiA+Pj4gK2FuZCByZXBvcnRlZCBpbiBuZXN0aW5nIGNhcCAoVkZJ
T19JT01NVV9UWVBFMV9JTkZPX0NBUF9ORVNUSU5HKQ0KPiA+Pj4gK3Rocm91Z2gNCj4gPj4+ICtW
RklPX0lPTU1VX0dFVF9JTkZPOg0KPiA+Pj4gKw0KPiA+Pj4gKyAgICBpb2N0bChjb250YWluZXIt
PmZkLCBWRklPX0lPTU1VX0dFVF9JTkZPLCAmbmVzdGluZ19pbmZvKTsNCj4gPj4+ICsNCj4gPj4+
ICtUaGUgbmVzdGluZyBjYXAgaW5mbyBpcyBhdmFpbGFibGUgb25seSBhZnRlciBORVNUSU5HX0lP
TU1VIGlzIHNlbGVjdGVkLg0KPiA+Pj4gK0lmIHVuZGVybHlpbmcgSU9NTVUgZG9lc24ndCBzdXBw
b3J0IG5lc3RpbmcsIFZGSU9fU0VUX0lPTU1VIGZhaWxzDQo+ID4+PiArYW5kDQo+ID4+IElmIHRo
ZSB1bmRlcmx5aW5nDQo+ID4NCj4gPiBnb3QgaXQuDQo+ID4NCj4gPj4+ICt1c2Vyc3BhY2Ugc2hv
dWxkIHRyeSBvdGhlciBJT01NVSB0eXBlcy4gRGV0YWlscyBvZiB0aGUgbmVzdGluZyBjYXANCj4g
Pj4+ICtpbmZvIGNhbiBiZSBmb3VuZCBpbiBEb2N1bWVudGF0aW9uL3VzZXJzcGFjZS1hcGkvaW9t
bXUucnN0Lg0KPiA+Pj4gKw0KPiA+Pj4gK1RoZSBzdGFnZS0xIHBhZ2UgdGFibGUgY2FuIGJlIGJv
dW5kIHRvIHRoZSBJT01NVSBpbiB0d28gbWV0aG9kczoNCj4gPj4+ICtkaXJlY3RseT4NCj4gPj4g
K29yIGluZGlyZWN0bHkuIERpcmVjdCBiaW5kaW5nIHJlcXVpcmVzIHVzZXJzcGFjZSB0byBub3Rp
ZnkgVkZJTyBvZg0KPiA+PiArZXZlcnkNCj4gPj4gTm90IHN1cmUgd2Ugc2hhbGwgdXNlIHRoaXMg
ZGlyZWN0L2luZGlyZWN0IHRlcm1pbm9sb2d5LiBJIGRvbid0IHRoaW5rDQo+ID4+IHRoaXMgaXMg
cGFydCBvZiBlaXRoZXIgQVJNIG9yIEludGVsIFNQRUMuDQo+ID4+DQo+ID4+IFN1Z2dlc3Rpb246
IE9uIEludGVsLCB0aGUgc3RhZ2UxIHBhZ2UgdGFibGUgaW5mbyBhcmUgbWVkaWF0ZWQgYnkgdGhl
DQo+ID4+IHVzZXJzcGFjZSBmb3IgZWFjaCBQQVNJRC4gT24gQVJNLCB0aGUgdXNlcnNwYWNlIGRp
cmVjdGx5IHBhc3NlcyB0aGUNCj4gPj4gR1BBIG9mIHRoZSB3aG9sZSBQQVNJRCB0YWJsZS4gQ3Vy
cmVudGx5IG9ubHkgSW50ZWwncyBiaW5kaW5nIGlzIHN1cHBvcnRlZC4NCj4gPg0KPiA+IGdvdCBp
dC4gdGhpcyBpcyB3aGF0IHdlIHdhbnQgdG8gc2F5IGJ5IGRpdGVjdC9pbmRpcmVjdCB0ZXJtaW5v
bG9neS4NCj4gPg0KPiA+IFJlZ2FyZHMsDQo+ID4gWWkgTGl1DQo+ID4NCj4gPj4+ICtndWVzdCBz
dGFnZS0xIHBhZ2UgdGFibGUgYmluZGluZywgd2hpbGUgaW5kaXJlY3QgYmluZGluZyBhbGxvd3MN
Cj4gPj4+ICt1c2Vyc3BhY2UgdG8gYmluZCBvbmNlIHdpdGggYW4gaW50ZXJtZWRpYXRlIHN0cnVj
dHVyZSAoZS5nLiBQQVNJRA0KPiA+Pj4gK3RhYmxlKSB3aGljaCBpbmRpcmVjdGx5IGxpbmtzIHRv
IGd1ZXN0IHN0YWdlLTEgcGFnZSB0YWJsZXMuIFRoZQ0KPiA+Pj4gK2FjdHVhbCBiaW5kaW5nIG1l
dGhvZCBkZXBlbmRzIG9uIElPTU1VIHZlbmRvci4gQ3VycmVudGx5IG9ubHkgdGhlDQo+ID4+PiAr
ZGlyZWN0IGJpbmRpbmcgY2FwYWJpbGl0eSAoDQo+ID4+PiArSU9NTVVfTkVTVElOR19GRUFUX0JJ
TkRfUEdUQkwpIGlzIHN1cHBvcnRlZDoNCj4gPj4+ICsNCj4gPj4+ICsgICAgbmVzdGluZ19vcC0+
ZmxhZ3MgPSBWRklPX0lPTU1VX05FU1RJTkdfT1BfQklORF9QR1RCTDsNCj4gPj4+ICsgICAgbWVt
Y3B5KCZuZXN0aW5nX29wLT5kYXRhLCAmYmluZF9kYXRhLCBzaXplb2YoYmluZF9kYXRhKSk7DQo+
ID4+PiArICAgIGlvY3RsKGNvbnRhaW5lci0+ZmQsIFZGSU9fSU9NTVVfTkVTVElOR19PUCwgbmVz
dGluZ19vcCk7DQo+ID4+PiArDQo+ID4+PiArV2hlbiBtdWx0aXBsZSBzdGFnZS0xIHBhZ2UgdGFi
bGVzIGFyZSBzdXBwb3J0ZWQgb24gYSBkZXZpY2UsIGVhY2gNCj4gPj4+ICtwYWdlIHRhYmxlIGlz
IGFzc29jaWF0ZWQgd2l0aCBhIFBBU0lEIChQcm9jZXNzIEFkZHJlc3MgU3BhY2UgSUQpIHRvDQo+
ID4+PiArZGlmZmVyZW50aWF0ZSB3aXRoIGVhY2ggb3RoZXIuIEluIHN1Y2ggY2FzZSwgdXNlcnNw
YWNlIHNob3VsZA0KPiA+Pj4gK2luY2x1ZGUgUEFTSUQgaW4gdGhlIGJpbmRfZGF0YSB3aGVuIGlz
c3VpbmcgZGlyZWN0IGJpbmRpbmcgcmVxdWVzdC4NCj4gPj4+ICsNCj4gPj4+ICtQQVNJRCBjb3Vs
ZCBiZSBtYW5hZ2VkIHBlci1kZXZpY2Ugb3Igc3lzdGVtLXdpZGUgd2hpY2gsIGFnYWluLA0KPiA+
Pj4gK2RlcGVuZHMgb24gSU9NTVUgdmVuZG9yIGFuZCBpcyByZXBvcnRlZCBpbiBuZXN0aW5nIGNh
cCBpbmZvLiBXaGVuDQo+ID4+PiArc3lzdGVtLXdpZGUgcG9saWN5IGlzIHJlcG9ydGVkIChJT01N
VV9ORVNUSU5HX0ZFQVRfU1lTV0lERV9QQVNJRCksDQo+ID4+PiArZS5nLiBhcyBieSBJbnRlbCBw
bGF0Zm9ybXMsIHVzZXJzcGFjZSAqbXVzdCogYWxsb2NhdGUgUEFTSUQgZnJvbQ0KPiA+Pj4gK1ZG
SU8gYmVmb3JlIGF0dGVtcHRpbmcgYmluZGluZyBvZg0KPiA+Pj4gK3N0YWdlLTEgcGFnZSB0YWJs
ZToNCj4gPj4+ICsNCj4gPj4+ICsgICAgcmVxLmZsYWdzID0gVkZJT19JT01NVV9BTExPQ19QQVNJ
RDsNCj4gPj4+ICsgICAgaW9jdGwoY29udGFpbmVyLCBWRklPX0lPTU1VX1BBU0lEX1JFUVVFU1Qs
ICZyZXEpOw0KPiA+Pj4gKw0KPiA+Pj4gK09uY2UgdGhlIHN0YWdlLTEgcGFnZSB0YWJsZSBpcyBi
b3VuZCB0byB0aGUgSU9NTVUsIHRoZSBndWVzdCBpcw0KPiA+Pj4gK2FsbG93ZWQgdG8gZnVsbHkg
bWFuYWdlIGl0cyBtYXBwaW5nIGF0IGl0cyBkaXNwb3NhbC4gVGhlIElPTU1VDQo+ID4+PiArd2Fs
a3MgbmVzdGVkIHN0YWdlLTEgYW5kIHN0YWdlLTIgcGFnZSB0YWJsZXMgd2hlbiBzZXJ2aW5nIERN
QQ0KPiA+Pj4gK3JlcXVlc3RzIGZyb20gYXNzaWduZWQgZGV2aWNlLCBhbmQgbWF5IGNhY2hlIHRo
ZSBzdGFnZS0xIG1hcHBpbmcgaW4NCj4gPj4+ICt0aGUgSU9UTEIuIFdoZW4gcmVxdWlyZWQgKElP
TU1VX05FU1RJTkdfIEZFQVRfQ0FDSEVfSU5WTEQpLA0KPiA+Pj4gK3VzZXJzcGFjZSAqbXVzdCog
Zm9yd2FyZCBndWVzdCBzdGFnZS0xIGludmFsaWRhdGlvbiB0byB0aGUgaG9zdCwgc28gdGhlIElP
VExCDQo+IGlzIGludmFsaWRhdGVkOg0KPiA+Pj4gKw0KPiA+Pj4gKyAgICBuZXN0aW5nX29wLT5m
bGFncyA9IFZGSU9fSU9NTVVfTkVTVElOR19PUF9DQUNIRV9JTlZMRDsNCj4gPj4+ICsgICAgbWVt
Y3B5KCZuZXN0aW5nX29wLT5kYXRhLCAmY2FjaGVfaW52X2RhdGEsIHNpemVvZihjYWNoZV9pbnZf
ZGF0YSkpOw0KPiA+Pj4gKyAgICBpb2N0bChjb250YWluZXItPmZkLCBWRklPX0lPTU1VX05FU1RJ
TkdfT1AsIG5lc3Rpbmdfb3ApOw0KPiA+Pj4gKw0KPiA+Pj4gK0ZvcndhcmRlZCBpbnZhbGlkYXRp
b25zIGNhbiBoYXBwZW4gYXQgdmFyaW91cyBncmFudWxhcml0eSBsZXZlbHMNCj4gPj4+ICsocGFn
ZSBsZXZlbCwgY29udGV4dCBsZXZlbCwgZXRjLikNCj4gPj4+ICsNCj4gPj4+ICBWRklPIFVzZXIg
QVBJDQo+ID4+Pg0KPiA+Pj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPj4+IC0tLS0tLS0tLS0tDQo+ID4+Pg0K
PiA+Pj4NCj4gPj4gVGhhbmtzDQo+ID4+DQo+ID4+IEVyaWMNCj4gPg0K

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6432D2259B8
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 10:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgGTILZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 04:11:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:41109 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgGTILY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 04:11:24 -0400
IronPort-SDR: RNShMwIQgVYGZi4l5qMTvnhhIFMDD5l9OYYWXTzEKVhU/gNEwBlpRrvbp6F2IXbN4vlWKKl6l5
 Xb0Z8EFP0Yfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="149856122"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="149856122"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 01:11:19 -0700
IronPort-SDR: vnKXm9khiMs7MhJ2rdjCzm8Wl+56hSq02lvfimykMqqzHDS4mnyqh3rbQEiYBkIpCoNka9c6tH
 cfB4axUiwoTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="309755929"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jul 2020 01:11:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 01:11:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Jul 2020 01:11:18 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 20 Jul 2020 01:11:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Jul 2020 01:11:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlipglF7BSI4oFcNXXIQrvHOAxS+Vnhhh3A0dBYq4tVOB7pgBOqYnRgVPHP6a1HE/ybFogMCsFR5uYC/Xgq5fGqxQDyaUvWIn9t8CaL56bYqvTJjXwi8cMTbUcXME5DvHjzn84VUFkA46zOgFKHm4RvNfd/HuN6YvCz0YnU2xnU1yf71nVR7OWRZW1uZ/KIgc70cCRJWBmtzestUwWsOucC50Pm6+JSwQuvgoFpZJKqAY+3hsHqFeh4w31PZh4jVzOXbbALDQ4g7QSP4Pl/pKGGIm3vb9grf/aTy+pcZdvw4Z2i4+YFiye6utVT+6YyK+g9BJ3mMe5YRanpUB+2qdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6DQTSlyuOtS/imL7bsMquuG6/91BpIwmal0aGI6xkk=;
 b=OO1WKPhxb34yji1RhvDLQDKLzfUw0K67ZbJUMw9mVkHWi1ZmApjET+QRT520V/tSQo+TaUn2FpsPhDkCyb9W7hfz/spxPTSzQlkCoZSFFF9zcgEdzixPqUp6sS71WMcxy+JTEtpQVPAIvRkNQ0mHzjTx1ffHBC2XL6Ti4iSFjHbPxPCSSTvGbeXbLdyLHIQa0seR5L7lUecZGReh9ImBsPsWz9iwt/RR3HOaW4P3rz1e3HDPMhBqaqE1atwUmnWxlSkpBIjYDYZVxzdvrrq0BW1+smyEuuO2rHgUE/DUIT8A8bjx36QC7maKyPoIqgR/g/mAy5jeqFDJb8qYkVVvmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6DQTSlyuOtS/imL7bsMquuG6/91BpIwmal0aGI6xkk=;
 b=GxybFqIMozFZgMOIFe/OCX68c+PMjyWsSxBk1sSzOwCWMmASBUZIYO5M6Ru6imohndzZeYIi2U1bjvoAiLtOLkqAOpi57hx+gtwFMMJ/c6wsw33Xy7/ZIi5S9c6uQkfNLl86v4MA6c8hGmCbtFXDHvXLX9Wa6ZoM7guq58OVRCA=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3289.namprd11.prod.outlook.com (2603:10b6:5:5f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.25; Mon, 20 Jul 2020 08:11:13 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 08:11:13 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
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
Subject: RE: [PATCH v5 06/15] iommu/vt-d: Support setting ioasid set to domain
Thread-Topic: [PATCH v5 06/15] iommu/vt-d: Support setting ioasid set to
 domain
Thread-Index: AQHWWD2wmreG48S8TkuGZch2ZJs3a6kPFLoAgAEUy6A=
Date:   Mon, 20 Jul 2020 08:11:13 +0000
Message-ID: <DM5PR11MB1435D32E0973DA6C0AF562F7C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-7-git-send-email-yi.l.liu@intel.com>
 <e2c45f9d-af78-5da9-c7c2-061b476b6b0a@redhat.com>
In-Reply-To: <e2c45f9d-af78-5da9-c7c2-061b476b6b0a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de800d2b-31ba-43ec-1f7c-08d82c8477ed
x-ms-traffictypediagnostic: DM6PR11MB3289:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB328979D245BC93354D822EB2C37B0@DM6PR11MB3289.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4bfhkvH7Wf6ut9eeHFkmLHy0lHGedwWwZTjToH+35h0xKnZJBh2DajS72wrcZ+itrF0vs4jvu10/sXoAY99xZDm7wOudX1Z7BfBuWMxPO9Zjcs4DhtnwdoBJy8yETsxgqTzEjvvqAynkZknU7hQkTnfjg15yZfeFx1sfq64IvHBFwY6sCv+1ymOdzHaPeSW+YpSHFaf5NDOqeptErit7r5aFppL7E9mWKr6ylJLqGjVywEk3x/Eox03LFiAc5O+lE/loIcqprF+UY16YSaDW+/yZ1ufEOYrAIddCc9eS+9TZclw5QAByTxIsk0Wkqj/VZQAMXPmjAKAZUwBtvKfUUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(26005)(53546011)(5660300002)(7696005)(7416002)(186003)(33656002)(52536014)(6506007)(110136005)(2906002)(71200400001)(8936002)(83380400001)(4326008)(9686003)(66476007)(54906003)(8676002)(478600001)(66946007)(66446008)(86362001)(66556008)(55016002)(316002)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kJEcepUtHyAuw27udNn6mpzGdyn/z7o6NuaRmYfhHWJJoZMhpwB6pQz5JjWX7/T9caUsUN4xPOTX5cZ6awCiuRn0gCaQj0jXK9h8uWNWKM+21al9PFtdeZvpS2W4alF22BRWsZrQ+oFgQ244NPGIOO+yKYPIZ7Ktxto7kaxzbOCVJjfWIjr/D4eMHSugDV82TVR6Uwu7iOCs1bhjIQi4DXVREOr06nCvm/5M6n8SH24kqelilxY50ETrpNuyloIndENe4USEPNIwQd1pp1i29p82isjMsYhjOIfqFRAPSuMdA7xiWQqnEmvloP5T2o03YUkqTSzrrpPYyxd+5yS1rGnPcKTlRLwgOKjSi5Np6p+40EQWxM4jhcOYPp8u5mRHecPRhfiFJt3/aHqWnZ2EKgV7ueHICRxanT89CH1HqeJX+EaqzV7ApD5yCurKpWiGO1i5Z+OKh97iq/wSTvoPDDPFK95R7zug4uq8AS9c6GRDhV69tv0t98wLX2hi6pS7
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de800d2b-31ba-43ec-1f7c-08d82c8477ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 08:11:13.1229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mPN4wezv9CtDjR3CgTc90COglhNdkveaAXUD2aRZBelRyjCG0D1p6K8gewO+GNczvcqlCjavYi0k6iW2cSqn6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3289
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFN1bmRheSwgSnVseSAxOSwgMjAyMCAxMTozOCBQTQ0KPiANCj4gWWksDQo+IA0KPiBP
biA3LzEyLzIwIDE6MjEgUE0sIExpdSBZaSBMIHdyb3RlOg0KPiA+IEZyb20gSU9NTVUgcC5vLnYu
LCBQQVNJRHMgYWxsb2NhdGVkIGFuZCBtYW5hZ2VkIGJ5IGV4dGVybmFsIGNvbXBvbmVudHMNCj4g
PiAoZS5nLiBWRklPKSB3aWxsIGJlIHBhc3NlZCBpbiBmb3IgZ3Bhc2lkX2JpbmQvdW5iaW5kIG9w
ZXJhdGlvbi4gSU9NTVUNCj4gPiBuZWVkcyBzb21lIGtub3dsZWRnZSB0byBjaGVjayB0aGUgUEFT
SUQgb3duZXJzaGlwLCBoZW5jZSBhZGQgYW4NCj4gPiBpbnRlcmZhY2UgZm9yIHRob3NlIGNvbXBv
bmVudHMgdG8gdGVsbCB0aGUgUEFTSUQgb3duZXIuDQo+ID4NCj4gPiBJbiBsYXRlc3Qga2VybmVs
IGRlc2lnbiwgUEFTSUQgb3duZXJzaGlwIGlzIG1hbmFnZWQgYnkgSU9BU0lEIHNldA0KPiA+IHdo
ZXJlIHRoZSBQQVNJRCBpcyBhbGxvY2F0ZWQgZnJvbS4gVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQg
Zm9yIHNldHRpbmcNCj4gPiBpb2FzaWQgc2V0IElEIHRvIHRoZSBkb21haW5zIHVzZWQgZm9yIG5l
c3RpbmcvdlNWQS4gU3Vic2VxdWVudCBTVkENCj4gPiBvcGVyYXRpb25zIG9uIHRoZSBQQVNJRCB3
aWxsIGJlIGNoZWNrZWQgYWdhaW5zdCBpdHMgSU9BU0lEIHNldCBmb3IgcHJvcGVyDQo+IG93bmVy
c2hpcC4NCj4gU3Vic2VxdWVudCBTVkEgb3BlcmF0aW9ucyB3aWxsIGNoZWNrIHRoZSBQQVNJRCBh
Z2FpbnN0IGl0cyBJT0FTSUQgc2V0IGZvciBwcm9wZXINCj4gb3duZXJzaGlwLg0KDQpnb3QgaXQu
DQoNCj4gPg0KPiA+IENjOiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBD
QzogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogQWxl
eCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiBDYzogRXJpYyBB
dWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+IENjOiBKZWFuLVBoaWxpcHBlIEJydWNr
ZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4NCj4gPiBDYzogSm9lcmcgUm9lZGVsIDxqb3Jv
QDhieXRlcy5vcmc+DQo+ID4gQ2M6IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0K
PiA+IC0tLQ0KPiA+IHY0IC0+IHY1Og0KPiA+ICopIGFkZHJlc3MgY29tbWVudHMgZnJvbSBFcmlj
IEF1Z2VyLg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMgfCAyMiAr
KysrKysrKysrKysrKysrKysrKysrDQo+ID4gaW5jbHVkZS9saW51eC9pbnRlbC1pb21tdS5oIHwg
IDQgKysrKw0KPiA+ICBpbmNsdWRlL2xpbnV4L2lvbW11LmggICAgICAgfCAgMSArDQo+ID4gIDMg
ZmlsZXMgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0K
PiA+IGluZGV4IDcyYWU2YTIuLjRkNTQxOTggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pb21t
dS9pbnRlbC9pb21tdS5jDQo+ID4gKysrIGIvZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jDQo+
ID4gQEAgLTE3OTMsNiArMTc5Myw3IEBAIHN0YXRpYyBzdHJ1Y3QgZG1hcl9kb21haW4gKmFsbG9j
X2RvbWFpbihpbnQgZmxhZ3MpDQo+ID4gIAlpZiAoZmlyc3RfbGV2ZWxfYnlfZGVmYXVsdCgpKQ0K
PiA+ICAJCWRvbWFpbi0+ZmxhZ3MgfD0gRE9NQUlOX0ZMQUdfVVNFX0ZJUlNUX0xFVkVMOw0KPiA+
ICAJZG9tYWluLT5oYXNfaW90bGJfZGV2aWNlID0gZmFsc2U7DQo+ID4gKwlkb21haW4tPmlvYXNp
ZF9zaWQgPSBJTlZBTElEX0lPQVNJRF9TRVQ7DQo+ID4gIAlJTklUX0xJU1RfSEVBRCgmZG9tYWlu
LT5kZXZpY2VzKTsNCj4gPg0KPiA+ICAJcmV0dXJuIGRvbWFpbjsNCj4gPiBAQCAtNjAzOSw2ICs2
MDQwLDI3IEBAIGludGVsX2lvbW11X2RvbWFpbl9zZXRfYXR0cihzdHJ1Y3QgaW9tbXVfZG9tYWlu
DQo+ICpkb21haW4sDQo+ID4gIAkJfQ0KPiA+ICAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRl
dmljZV9kb21haW5fbG9jaywgZmxhZ3MpOw0KPiA+ICAJCWJyZWFrOw0KPiA+ICsJY2FzZSBET01B
SU5fQVRUUl9JT0FTSURfU0lEOg0KPiA+ICsJew0KPiA+ICsJCWludCBzaWQgPSAqKGludCAqKWRh
dGE7DQo+ID4gKw0KPiA+ICsJCWlmICghKGRtYXJfZG9tYWluLT5mbGFncyAmIERPTUFJTl9GTEFH
X05FU1RJTkdfTU9ERSkpIHsNCj4gPiArCQkJcmV0ID0gLUVOT0RFVjsNCj4gPiArCQkJYnJlYWs7
DQo+ID4gKwkJfQ0KPiA+ICsJCXNwaW5fbG9ja19pcnFzYXZlKCZkZXZpY2VfZG9tYWluX2xvY2ss
IGZsYWdzKTsNCj4gSSB0aGluayB0aGUgbG9jayBzaG91bGQgYmUgdGFrZW4gYmVmb3JlIHRoZSBE
T01BSU5fRkxBR19ORVNUSU5HX01PREUgY2hlY2suDQo+IE90aGVyd2lzZSwgdGhlIGZsYWdzIGNh
biBiZSB0aGVyZXRpY2FsbHkgY2hhbmdlZCBpbmJldHdlZW4gdGhlIGNoZWNrIGFuZCB0aGUgdGVz
dA0KPiBiZWxvdz8NCg0KSSBzZWUuIHdpbGwgY29ycmVjdCBpdC4NCg0KVGhhbmtzLA0KWWkgTGl1
DQoNCj4gVGhhbmtzDQo+IA0KPiBFcmljDQo+ID4gKwkJaWYgKGRtYXJfZG9tYWluLT5pb2FzaWRf
c2lkICE9IElOVkFMSURfSU9BU0lEX1NFVCAmJg0KPiA+ICsJCSAgICBkbWFyX2RvbWFpbi0+aW9h
c2lkX3NpZCAhPSBzaWQpIHsNCj4gPiArCQkJcHJfd2Fybl9yYXRlbGltaXRlZCgibXVsdGkgaW9h
c2lkX3NldCAoJWQ6JWQpIHNldHRpbmciLA0KPiA+ICsJCQkJCSAgICBkbWFyX2RvbWFpbi0+aW9h
c2lkX3NpZCwgc2lkKTsNCj4gPiArCQkJcmV0ID0gLUVCVVNZOw0KPiA+ICsJCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZkZXZpY2VfZG9tYWluX2xvY2ssIGZsYWdzKTsNCj4gPiArCQkJYnJlYWs7
DQo+ID4gKwkJfQ0KPiA+ICsJCWRtYXJfZG9tYWluLT5pb2FzaWRfc2lkID0gc2lkOw0KPiA+ICsJ
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRldmljZV9kb21haW5fbG9jaywgZmxhZ3MpOw0KPiA+
ICsJCWJyZWFrOw0KPiA+ICsJfQ0KPiA+ICAJZGVmYXVsdDoNCj4gPiAgCQlyZXQgPSAtRUlOVkFM
Ow0KPiA+ICAJCWJyZWFrOw0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2ludGVsLWlv
bW11LmggYi9pbmNsdWRlL2xpbnV4L2ludGVsLWlvbW11LmgNCj4gPiBpbmRleCAzZjIzYzI2Li4w
ZDBhYjMyIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaA0KPiA+
ICsrKyBiL2luY2x1ZGUvbGludXgvaW50ZWwtaW9tbXUuaA0KPiA+IEBAIC01NDksNiArNTQ5LDEw
IEBAIHN0cnVjdCBkbWFyX2RvbWFpbiB7DQo+ID4gIAkJCQkJICAgMiA9PSAxR2lCLCAzID09IDUx
MkdpQiwgNCA9PSAxVGlCICovDQo+ID4gIAl1NjQJCW1heF9hZGRyOwkvKiBtYXhpbXVtIG1hcHBl
ZCBhZGRyZXNzICovDQo+ID4NCj4gPiArCWludAkJaW9hc2lkX3NpZDsJLyoNCj4gPiArCQkJCQkg
KiB0aGUgaW9hc2lkIHNldCB3aGljaCB0cmFja3MgYWxsDQo+ID4gKwkJCQkJICogUEFTSURzIHVz
ZWQgYnkgdGhlIGRvbWFpbi4NCj4gPiArCQkJCQkgKi8NCj4gPiAgCWludAkJZGVmYXVsdF9wYXNp
ZDsJLyoNCj4gPiAgCQkJCQkgKiBUaGUgZGVmYXVsdCBwYXNpZCB1c2VkIGZvciBub24tU1ZNDQo+
ID4gIAkJCQkJICogdHJhZmZpYyBvbiBtZWRpYXRlZCBkZXZpY2VzLg0KPiA+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L2lvbW11LmggYi9pbmNsdWRlL2xpbnV4L2lvbW11LmggaW5kZXgNCj4g
PiA3Y2E5ZDQ4Li5lODRhMWQ1IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvaW9tbXUu
aA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvaW9tbXUuaA0KPiA+IEBAIC0xMjQsNiArMTI0LDcg
QEAgZW51bSBpb21tdV9hdHRyIHsNCj4gPiAgCURPTUFJTl9BVFRSX0ZTTF9QQU1VVjEsDQo+ID4g
IAlET01BSU5fQVRUUl9ORVNUSU5HLAkvKiB0d28gc3RhZ2VzIG9mIHRyYW5zbGF0aW9uICovDQo+
ID4gIAlET01BSU5fQVRUUl9ETUFfVVNFX0ZMVVNIX1FVRVVFLA0KPiA+ICsJRE9NQUlOX0FUVFJf
SU9BU0lEX1NJRCwNCj4gPiAgCURPTUFJTl9BVFRSX01BWCwNCj4gPiAgfTsNCj4gPg0KPiA+DQoN
Cg==

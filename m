Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D417215844
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgGFN03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:26:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:17516 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbgGFN03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 09:26:29 -0400
IronPort-SDR: /M11et//o3nqf3UB+J0YO94/IMs7bcqcws7MyL3AxFkFBiWXGtfL+WPuy2CblArACvqHjJ7zc5
 i2EmoJS7+cwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9673"; a="165476031"
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="165476031"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 06:26:18 -0700
IronPort-SDR: PlfddyEk1bL/1wHCJhz1LRBKWsyYCwQ7l52m67FgQYY0/Rj3i2N4KfhCTFrgsV+EWlRihxxeEp
 24FJmg7fOuLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="267920016"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jul 2020 06:26:18 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Jul 2020 06:26:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Jul 2020 06:26:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SU6KDqY+87PkfKNkMHAQm4DlfEGQ/AQGaMOt6K+rQd9eJRZMFNzNomq4DAtFdCLoTT4SnHzhtwlnguBOILKJHOx6uZzEfEonqOGB7+mpYGfyj8hmFh+KtzCOEv7/Ft0FEYUh+a8hd/nCyylqkhQ2HGucvUaTgIBJ+Oshahf22VwfiVuChTMTrnCBnmIJTh/m4BmmHWIWLyf4QFW1NZNskjydhW+4QFO50o+Kj6//ZivVHqGZr9Wu+kpfgYFqfpbK1v4+26py2IlpK/7RAC+ulj0Hd7JABMwwsh+BkXzeazgrTHnuH19JSuCucwfPFJ5/I1X0TLve0eKz7t4uJVLo7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiOZxDh1JoZOfE0etzh0xWvjUMdIxADic7Q0TwX/UOw=;
 b=L7XbLMRr75N6drj54Tjy8gtCwLOMSYVs7DxGwMoUNWB6q80jgzAVhrNQh+WmciFaIHclz3rDHQTMnrS/cG1yRzpHGaGiPn3R3IuK5qrvNwuAKO9YqLyIzxYDmuwE4rY6kqDOFl3EsFmaKh6J91Eexph3mCFwX7Ur3/RV7lEFySk6GUEroFAyZX9FZT5DvQjey3craDI0GshPONC6cMtOpsSGv08/w7fhdYUi07Tuw0Y5MsAW/WuEJxX/LOYdfDIsQpWvceFJ9t2Lke7S3gEFbV0vI4nzBZ7n/6JUDhnvRwlDNcIKtugTS1S2vbm+CFCfVU4jz2slLQrf+2Rcj5YUXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiOZxDh1JoZOfE0etzh0xWvjUMdIxADic7Q0TwX/UOw=;
 b=ONUCHVK2ydL9CnM7LmE0bukz4V2vKQYMqetwucJp+wepJaM+5+SK6EDqs4rAJOOzg7oa2BztrSjum5OWM7D6T2zfqEL7QGrzXkS5eSma+8j5GSRXjQC9V4EtRbYS6uLy4NawlFkSxazyWvGKkdFlN091oNVeLoFYZ/UwgPqhe04=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3595.namprd11.prod.outlook.com (2603:10b6:5:142::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.23; Mon, 6 Jul 2020 13:26:15 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 13:26:15 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v4 03/15] iommu/smmu: Report empty domain nesting info
Thread-Topic: [PATCH v4 03/15] iommu/smmu: Report empty domain nesting info
Thread-Index: AQHWUfUaPoulLLqnPkWWSyUjWN1VMaj6XtmAgAAiPXCAAAvZAIAAAMyg
Date:   Mon, 6 Jul 2020 13:26:15 +0000
Message-ID: <DM5PR11MB143534C547D61ABAE5CCEDBFC3690@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-4-git-send-email-yi.l.liu@intel.com>
 <d791bad4-57b9-8e97-acbb-76b13e4154f8@redhat.com>
 <DM5PR11MB143543A04F5AF15EC7CBEC8BC3690@DM5PR11MB1435.namprd11.prod.outlook.com>
 <4d1a11b4-dcf3-b3a1-8802-3dd3ae97b3a4@redhat.com>
In-Reply-To: <4d1a11b4-dcf3-b3a1-8802-3dd3ae97b3a4@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae76ee19-0f86-49d6-6c38-08d821b028ea
x-ms-traffictypediagnostic: DM6PR11MB3595:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB35952A0212EA2A28981B944CC3690@DM6PR11MB3595.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lm3BKdRefNldk/Yo56RvZQrp3e8zXWvyQ0cv5WF6IRnSm7eF2eZorNjU3ClriCMjRGF+OLs9Ri9bDOaIj393DTQFwP+dE1ZdY4/mJBA6ythx/iJo82S+L5ItHIF/vIfXwoA5WZHwXBiuYWYM8u9Qc3+qRa34SFdkIWr5GKXwqC0FzYx1gv3wiZj7GJQ5wFrD5nnBqRhEQ0OE4HADQMDN7fWaJLe1qcInjm2tVdAQ2WXG5gL/PhljRLDsJdrPhT3V9w/uTUg03ayXKN7HzR2nndww2ekqdGg24AoK3m4BsCJXIgswuHSwBf2goQGUbr9hmO+XR4SnMhZN7D3QH+5dgd0Me9XOsWNL3n+Xi9D0wpyJbj52QggKVXmgxUw6J45sYiNl9YIsxELcO6+fmFH3Ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(54906003)(316002)(110136005)(8936002)(8676002)(66446008)(4326008)(66946007)(66556008)(53546011)(9686003)(2906002)(55016002)(66476007)(64756008)(6506007)(186003)(76116006)(7696005)(26005)(71200400001)(86362001)(52536014)(5660300002)(966005)(7416002)(478600001)(33656002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yjTuqapc8t76NZhlGFddGInBCqwfpturJlNcGBeNMGD97QmAbBQx47E/jrdUPZ0u9K7UH93mj2D2xTb25UL/5p43NVvbIWkINhP5G3sXx3jZL+X3Fga2ma0kdY/eALpXp0NvZUfhbP81esuoyl5YRluhtvNmI1gkzHg4lGzY25TqIG0zuv/9tPL4WCiFJXoH/a1hJpv+MsMOKfGrZiGqSEw/bW0WdoiJ6BYiu2DIgs/9JhHn7DKtiusrityFnyk3/sMhUzvN4E21lGGWq+FlCP2dQJRhhL7Kjui8OJsuyWHvC1C0rEs7/jwNBIbFKCOVoSMteTnRHVP0gH66RroRzgNw20lzrRzeARKjh9+y2TjYG5eSHNZdmKBrjuDspwQ8i7W1AN30cP636fvLAb0f7AnW1xO8cPjs2KeDP+ENK+Dc3cNfdO/+CQ44IE2X61b4JKD2j4w0EucRynG3CLlJ/fUddAA4aOtIDQJOkEzdLm3SL0dB0jKw2Au9c6HVJFx2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae76ee19-0f86-49d6-6c38-08d821b028ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 13:26:15.5868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vDO0/P7j/YI0lNflq0WHm0wdjOujg3+ayRp6j2I6ASy3BZmqbdXC3mII1xA5fRtfLo8L1+wHnkU65j4KCyTpRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3595
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgSnVseSA2LCAyMDIwIDk6MjIgUE0NCj4gDQo+IEhpIFlpLA0KPiANCj4g
T24gNy82LzIwIDI6NDYgUE0sIExpdSwgWWkgTCB3cm90ZToNCj4gPiBIaSBFcmljLA0KPiA+DQo+
ID4+IEZyb206IEF1Z2VyIEVyaWMgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPj4NCj4gPj4g
SGkgWWksDQo+ID4+DQo+ID4+IFBsZWFzZSBhZGQgYSBjb21taXQgbWVzc2FnZTogaW5zdGVhZCBv
ZiByZXR1cm5pbmcgYSBib29sZWFuIGZvcg0KPiA+PiBET01BSU5fQVRUUl9ORVNUSU5HLCBhcm1f
c21tdV9kb21haW5fZ2V0X2F0dHIoKSByZXR1cm5zIGENCj4gPj4gaW9tbXVfbmVzdGluZ19pbmZv
IGhhbmRsZS4NCj4gPg0KPiA+IHdpbGwgZG8uIHRoYW5rcyBmb3IgdGhlIHN1Z2dlc3Rpb24uDQo+
ID4NCj4gPj4NCj4gPj4gT24gNy80LzIwIDE6MjYgUE0sIExpdSBZaSBMIHdyb3RlOg0KPiA+Pj4g
Q2M6IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+DQo+ID4+PiBDYzogUm9iaW4gTXVycGh5
IDxyb2Jpbi5tdXJwaHlAYXJtLmNvbT4NCj4gPj4+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2Vy
QHJlZGhhdC5jb20+DQo+ID4+PiBDYzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxp
cHBlQGxpbmFyby5vcmc+DQo+ID4+PiBTdWdnZXN0ZWQtYnk6IEplYW4tUGhpbGlwcGUgQnJ1Y2tl
ciA8amVhbi1waGlsaXBwZUBsaW5hcm8ub3JnPg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogTGl1IFlp
IEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEphY29iIFBhbiA8
amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4+PiAtLS0NCj4gPj4+ICBkcml2ZXJz
L2lvbW11L2FybS1zbW11LXYzLmMgfCAyOSArKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0K
PiA+Pj4gIGRyaXZlcnMvaW9tbXUvYXJtLXNtbXUuYyAgICB8IDI5ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tDQo+ID4+PiAgMiBmaWxlcyBjaGFuZ2VkLCA1NCBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2Fy
bS1zbW11LXYzLmMNCj4gPj4+IGIvZHJpdmVycy9pb21tdS9hcm0tc21tdS12My5jIGluZGV4IGY1
Nzg2NzcuLjBjNDVkNGQgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL2lvbW11L2FybS1zbW11
LXYzLmMNCj4gPj4+ICsrKyBiL2RyaXZlcnMvaW9tbXUvYXJtLXNtbXUtdjMuYw0KPiA+Pj4gQEAg
LTMwMTksNiArMzAxOSwzMiBAQCBzdGF0aWMgc3RydWN0IGlvbW11X2dyb3VwDQo+ID4+ICphcm1f
c21tdV9kZXZpY2VfZ3JvdXAoc3RydWN0IGRldmljZSAqZGV2KQ0KPiA+Pj4gIAlyZXR1cm4gZ3Jv
dXA7DQo+ID4+PiAgfQ0KPiA+Pj4NCj4gPj4+ICtzdGF0aWMgaW50IGFybV9zbW11X2RvbWFpbl9u
ZXN0aW5nX2luZm8oc3RydWN0IGFybV9zbW11X2RvbWFpbg0KPiA+PiAqc21tdV9kb21haW4sDQo+
ID4+PiArCQkJCQl2b2lkICpkYXRhKQ0KPiA+Pj4gK3sNCj4gPj4+ICsJc3RydWN0IGlvbW11X25l
c3RpbmdfaW5mbyAqaW5mbyA9IChzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvICopIGRhdGE7DQo+
ID4+PiArCXUzMiBzaXplOw0KPiA+Pj4gKw0KPiA+Pj4gKwlpZiAoIWluZm8gfHwgc21tdV9kb21h
aW4tPnN0YWdlICE9IEFSTV9TTU1VX0RPTUFJTl9ORVNURUQpDQo+ID4+PiArCQlyZXR1cm4gLUVO
T0RFVjsNCj4gPj4+ICsNCj4gPj4+ICsJc2l6ZSA9IHNpemVvZihzdHJ1Y3QgaW9tbXVfbmVzdGlu
Z19pbmZvKTsNCj4gPj4+ICsNCj4gPj4+ICsJLyoNCj4gPj4+ICsJICogaWYgcHJvdmlkZWQgYnVm
ZmVyIHNpemUgaXMgbm90IGVxdWFsIHRvIHRoZSBzaXplLCBzaG91bGQNCj4gPj4+ICsJICogcmV0
dXJuIDAgYW5kIGFsc28gdGhlIGV4cGVjdGVkIGJ1ZmZlciBzaXplIHRvIGNhbGxlci4NCj4gPj4+
ICsJICovDQo+ID4+PiArCWlmIChpbmZvLT5zaXplICE9IHNpemUpIHsNCj4gPj4gPCBzaXplPw0K
PiA+DQo+ID4gPCBzaXplIG1heSB3b3JrIGFzIHdlbGwuIGJ1dCBJJ2QgbGlrZSB0aGUgY2FsbGVy
IHByb3ZpZGUgZXhhY3QgYnVmZmVyDQo+ID4gc2l6ZS4gbm90IHN1cmUgaWYgaXQgaXMgZGVtYW5k
IGluIGtlcm5lbC4gZG8geW91IGhhdmUgYW55IHN1Z2dlc3Rpb24/DQo+IA0KPiBJIGp1c3Qgc3Vn
Z2VzdGVkIHRoYXQgYnkgYW5hbG9neSB3aXRoIHRoZSBWRklPIGFyZ3N6DQoNCkkgc2VlLiB3aWxs
IGNoYW5nZSBpdC4NCg0KPiANCj4gPg0KPiA+Pj4gKwkJaW5mby0+c2l6ZSA9IHNpemU7DQo+ID4+
PiArCQlyZXR1cm4gMDsNCj4gPj4+ICsJfQ0KPiA+Pj4gKw0KPiA+Pj4gKwkvKiByZXBvcnQgYW4g
ZW1wdHkgaW9tbXVfbmVzdGluZ19pbmZvIGZvciBub3cgKi8NCj4gPj4+ICsJbWVtc2V0KGluZm8s
IDB4MCwgc2l6ZSk7DQo+ID4+PiArCWluZm8tPnNpemUgPSBzaXplOw0KPiA+PiBGb3IgaW5mbywg
dGhlIGN1cnJlbnQgU01NVSBORVNURUQgbW9kZSBpcyBub3QgZW5hYmxpbmcgYW55IG5lc3Rpbmcu
DQo+ID4+IEl0IGp1c3QgZm9yY2VzIHRoZSB1c2FnZSBvZiB0aGUgMnN0IHN0YWdlIGluc3RlYWQg
b2Ygc3RhZ2UxIGZvciBzaW5nbGUgc3RhZ2UNCj4gdHJhbnNsYXRpb24uDQo+ID4NCj4gPiB5ZXAu
IFRoZSBpbnRlbnRpb24gaXMgYXMgYmVsb3c6DQo+ID4NCj4gPiAiIEhvd2V2ZXIgaXQgcmVxdWly
ZXMgY2hhbmdpbmcgdGhlIGdldF9hdHRyKE5FU1RJTkcpIGltcGxlbWVudGF0aW9ucw0KPiA+IGlu
IGJvdGggU01NVSBkcml2ZXJzIGFzIGEgcHJlY3Vyc29yIG9mIHRoaXMgc2VyaWVzLCB0byBhdm9p
ZCBicmVha2luZw0KPiA+IFZGSU9fVFlQRTFfTkVTVElOR19JT01NVSBvbiBBcm0uIFNpbmNlIHdl
IGhhdmVuJ3QgeWV0IGRlZmluZWQgdGhlDQo+ID4gbmVzdGluZ19pbmZvIHN0cnVjdHMgZm9yIFNN
TVV2MiBhbmQgdjMsIEkgc3VwcG9zZSB3ZSBjb3VsZCByZXR1cm4gYW4NCj4gPiBlbXB0eSBzdHJ1
Y3QgaW9tbXVfbmVzdGluZ19pbmZvIGZvciBub3c/Ig0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LWlvbW11LzIwMjAwNjE3MTQzOTA5LkdBODg2NTkwQG15cmljYS8NCj4gPg0KPiA+
IGRvIHlvdSB0aGluayBhbnkgb3RoZXIgbmVlZHMgdG8gYmUgZG9uZSBmb3Igbm93Pw0KPiANCj4g
SSB1bmRlcnN0YW5kIHRoaXMgaXMgYSBwcmVyZXF1aXNpdGUuIEl0IHdhcyBtb3JlIGFzIGFuIGlu
Zm9ybWF0aW9uLg0KPiBSZXR1cm5pbmcgYSB2b2lkIHN0cnVjdCBpcyBhIGJpdCB3ZWlyZCBidXQg
YXQgdGhlIG1vbWVudCBJIGRvbid0IGhhdmUgYW55dGhpbmcgYmV0dGVyLg0KDQpnb3QgeW91LiBk
byB5b3UgdGhpbmsgaXQgaXMgbmVjZXNzYXJ5IHRvIGFkZCB5b3VyIHN0YXRlbWVudCBhcyBhIGNv
bW1lbnQgaGVyZT8NCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0K
PiA+DQo+ID4gUmVnYXJkcywNCj4gPiBZaSBMaXUNCj4gPg0KPiA+PiBUaGFua3MNCj4gPj4NCj4g
Pj4gRXJpYw0KPiA+Pj4gKwlyZXR1cm4gMDsNCj4gPj4+ICt9DQo+ID4+PiArDQo+ID4+PiAgc3Rh
dGljIGludCBhcm1fc21tdV9kb21haW5fZ2V0X2F0dHIoc3RydWN0IGlvbW11X2RvbWFpbiAqZG9t
YWluLA0KPiA+Pj4gIAkJCQkgICAgZW51bSBpb21tdV9hdHRyIGF0dHIsIHZvaWQgKmRhdGEpICB7
IEBAIC0NCj4gPj4gMzAyOCw4ICszMDU0LDcgQEANCj4gPj4+IHN0YXRpYyBpbnQgYXJtX3NtbXVf
ZG9tYWluX2dldF9hdHRyKHN0cnVjdCBpb21tdV9kb21haW4gKmRvbWFpbiwNCj4gPj4+ICAJY2Fz
ZSBJT01NVV9ET01BSU5fVU5NQU5BR0VEOg0KPiA+Pj4gIAkJc3dpdGNoIChhdHRyKSB7DQo+ID4+
PiAgCQljYXNlIERPTUFJTl9BVFRSX05FU1RJTkc6DQo+ID4+PiAtCQkJKihpbnQgKilkYXRhID0g
KHNtbXVfZG9tYWluLT5zdGFnZSA9PQ0KPiA+PiBBUk1fU01NVV9ET01BSU5fTkVTVEVEKTsNCj4g
Pj4+IC0JCQlyZXR1cm4gMDsNCj4gPj4+ICsJCQlyZXR1cm4gYXJtX3NtbXVfZG9tYWluX25lc3Rp
bmdfaW5mbyhzbW11X2RvbWFpbiwNCj4gPj4gZGF0YSk7DQo+ID4+PiAgCQlkZWZhdWx0Og0KPiA+
Pj4gIAkJCXJldHVybiAtRU5PREVWOw0KPiA+Pj4gIAkJfQ0KPiA+Pj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvaW9tbXUvYXJtLXNtbXUuYyBiL2RyaXZlcnMvaW9tbXUvYXJtLXNtbXUuYw0KPiA+Pj4g
aW5kZXggMjQzYmM0Yy4uOTA4NjA3ZCAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvaW9tbXUv
YXJtLXNtbXUuYw0KPiA+Pj4gKysrIGIvZHJpdmVycy9pb21tdS9hcm0tc21tdS5jDQo+ID4+PiBA
QCAtMTUwNiw2ICsxNTA2LDMyIEBAIHN0YXRpYyBzdHJ1Y3QgaW9tbXVfZ3JvdXANCj4gPj4gKmFy
bV9zbW11X2RldmljZV9ncm91cChzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ID4+PiAgCXJldHVybiBn
cm91cDsNCj4gPj4+ICB9DQo+ID4+Pg0KPiA+Pj4gK3N0YXRpYyBpbnQgYXJtX3NtbXVfZG9tYWlu
X25lc3RpbmdfaW5mbyhzdHJ1Y3QgYXJtX3NtbXVfZG9tYWluDQo+ID4+ICpzbW11X2RvbWFpbiwN
Cj4gPj4+ICsJCQkJCXZvaWQgKmRhdGEpDQo+ID4+PiArew0KPiA+Pj4gKwlzdHJ1Y3QgaW9tbXVf
bmVzdGluZ19pbmZvICppbmZvID0gKHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8gKikgZGF0YTsN
Cj4gPj4+ICsJdTMyIHNpemU7DQo+ID4+PiArDQo+ID4+PiArCWlmICghaW5mbyB8fCBzbW11X2Rv
bWFpbi0+c3RhZ2UgIT0gQVJNX1NNTVVfRE9NQUlOX05FU1RFRCkNCj4gPj4+ICsJCXJldHVybiAt
RU5PREVWOw0KPiA+Pj4gKw0KPiA+Pj4gKwlzaXplID0gc2l6ZW9mKHN0cnVjdCBpb21tdV9uZXN0
aW5nX2luZm8pOw0KPiA+Pj4gKw0KPiA+Pj4gKwkvKg0KPiA+Pj4gKwkgKiBpZiBwcm92aWRlZCBi
dWZmZXIgc2l6ZSBpcyBub3QgZXF1YWwgdG8gdGhlIHNpemUsIHNob3VsZA0KPiA+Pj4gKwkgKiBy
ZXR1cm4gMCBhbmQgYWxzbyB0aGUgZXhwZWN0ZWQgYnVmZmVyIHNpemUgdG8gY2FsbGVyLg0KPiA+
Pj4gKwkgKi8NCj4gPj4+ICsJaWYgKGluZm8tPnNpemUgIT0gc2l6ZSkgew0KPiA+Pj4gKwkJaW5m
by0+c2l6ZSA9IHNpemU7DQo+ID4+PiArCQlyZXR1cm4gMDsNCj4gPj4+ICsJfQ0KPiA+Pj4gKw0K
PiA+Pj4gKwkvKiByZXBvcnQgYW4gZW1wdHkgaW9tbXVfbmVzdGluZ19pbmZvIGZvciBub3cgKi8N
Cj4gPj4+ICsJbWVtc2V0KGluZm8sIDB4MCwgc2l6ZSk7DQo+ID4+PiArCWluZm8tPnNpemUgPSBz
aXplOw0KPiA+Pj4gKwlyZXR1cm4gMDsNCj4gPj4+ICt9DQo+ID4+PiArDQo+ID4+PiAgc3RhdGlj
IGludCBhcm1fc21tdV9kb21haW5fZ2V0X2F0dHIoc3RydWN0IGlvbW11X2RvbWFpbiAqZG9tYWlu
LA0KPiA+Pj4gIAkJCQkgICAgZW51bSBpb21tdV9hdHRyIGF0dHIsIHZvaWQgKmRhdGEpICB7IEBA
IC0NCj4gPj4gMTUxNSw4ICsxNTQxLDcgQEANCj4gPj4+IHN0YXRpYyBpbnQgYXJtX3NtbXVfZG9t
YWluX2dldF9hdHRyKHN0cnVjdCBpb21tdV9kb21haW4gKmRvbWFpbiwNCj4gPj4+ICAJY2FzZSBJ
T01NVV9ET01BSU5fVU5NQU5BR0VEOg0KPiA+Pj4gIAkJc3dpdGNoIChhdHRyKSB7DQo+ID4+PiAg
CQljYXNlIERPTUFJTl9BVFRSX05FU1RJTkc6DQo+ID4+PiAtCQkJKihpbnQgKilkYXRhID0gKHNt
bXVfZG9tYWluLT5zdGFnZSA9PQ0KPiA+PiBBUk1fU01NVV9ET01BSU5fTkVTVEVEKTsNCj4gPj4+
IC0JCQlyZXR1cm4gMDsNCj4gPj4+ICsJCQlyZXR1cm4gYXJtX3NtbXVfZG9tYWluX25lc3Rpbmdf
aW5mbyhzbW11X2RvbWFpbiwNCj4gPj4gZGF0YSk7DQo+ID4+PiAgCQlkZWZhdWx0Og0KPiA+Pj4g
IAkJCXJldHVybiAtRU5PREVWOw0KPiA+Pj4gIAkJfQ0KPiA+Pj4NCj4gPg0KDQo=

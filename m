Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F302F2B2E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 10:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390761AbhALJWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 04:22:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:55238 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731334AbhALJWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 04:22:04 -0500
IronPort-SDR: nK8eD5SIawTvoLJmPzNG9MWg6itaChmS9KDhvDW4WjrePhogcy4XM7xcfgqVwi7yLAcf8agPOb
 PfbJQUtO4mew==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="196630335"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="196630335"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 01:21:23 -0800
IronPort-SDR: +Rit3b93EXzXJdByVGk1Jl22GTRpNmRJ4yzaVtc07MjEWt6tS43SYxDj47itrMpLe7+HGvEnAG
 7gZSvjaQCZrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="404410012"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jan 2021 01:21:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Jan 2021 01:21:23 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Jan 2021 01:21:22 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Jan 2021 01:21:22 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 12 Jan 2021 01:21:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISXGdshAJGLrYWNvlRylLZQB/RvQVp/BuRhapNHXOHWlRqhhuR6c3gp9/3/Un2scXVR6LrIGKf8kpLS1DyKoSKtr5d13ZG1ixa/55rMOkqLDkEUNpBI+U2NIy1LIt7VRaQOO5y8M2sxrLBJ5dPOtbyO7cPBOTVTYPHe+X8cBlRT2k3aB0PZH7WDtDENu2V1F1oZCdrBcUtBmxl540hL9oT7YSKpXCblrYv+aaA5n9DmYeOrGAglFOpqlFcvfmPLAaWOFdJOs+0IKRNt2CXbUvHgBaQOPWNO9a6qeRkfYwZkmQfIVsDCD9+IKZR9KZhlNr8QS+JICpZBzgbAqUiDVgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loo0jx7kG+6oKarLzpBG5Jy9/pwfnS+FPzMxV82P2ck=;
 b=jkF0ffg2Y46lA4+Mbc8KvCl8AvBo1YBReUytMeTOLmNfIcgLe0ZO/0kUFu1Jl7+nSaKSVAvAZFKgKHgIa8GsG4eioRU39l4aTRf8tFsi4l1BKatJDu6/keMInFGJNxkWudQs/q7Gxjp+aa35AAJbKJF/6YBFgPkW3P00CPq1VvfwZ2llT96TH2BoF2pniHroNiuujOx1EbHmzaLk1q/qkV6VkSJhUAIXrmYQjgm3ni6fQ5iUev1R4Sz6Ghsb7Mv0u2jPQEG8uGLb+Y5VLBu7w9q23Uqtx/68bqSDFz0I2MGrlLIwsCVEbNPbAOBcmHV1/7oJsArDGtFfEmtzP/fGCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loo0jx7kG+6oKarLzpBG5Jy9/pwfnS+FPzMxV82P2ck=;
 b=TH6Jo3CWr0EUHzWBXcD70F/Jg+OAajQLJgu70LsPmlbTscxMd7JQ7YBDKDj+EDDByX2AVc8VrnU0beRDsaihUDSO7uNNsOnpnWZxmO5GCN3epe4wfO5pcUUqnnfzAHAROsWHX6/2MD3zt+vgkxXv3RI1UapwScAzj1BpCIeLahA=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1481.namprd11.prod.outlook.com (2603:10b6:4:9::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Tue, 12 Jan 2021 09:21:20 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::649c:8aff:2053:e93]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::649c:8aff:2053:e93%3]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 09:21:20 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Vivek Gautam <vivek.gautam@arm.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
Thread-Topic: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
Thread-Index: AQHWh19ACfcP7ssg8UC1cgpZfCvfJKokT6+AgAAjF2A=
Date:   Tue, 12 Jan 2021 09:21:20 +0000
Message-ID: <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <1599734733-6431-3-git-send-email-yi.l.liu@intel.com>
 <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
In-Reply-To: <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97f826a2-bebe-4d9f-95e9-08d8b6db6c71
x-ms-traffictypediagnostic: DM5PR11MB1481:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB148181A7AEC761CE0C81689FC3AA0@DM5PR11MB1481.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z/RkMfarZrAcr2OcJ8JQ/9n0SUp1Gf+vq3zCrCneQLBaQE3pzyeH7S78YSSrDqn9HZWsmNxRJ5aiXlVwLe0znkXSxUnt8ikNnhaNkpTLMcO09l6ZJzdzMLg/iLRBl9SY2/8FEOn+9amEc/+eq2WNaabCjCO2stlWHFookqMYaYOCMMU+YdByGXmpddlPydQBa4a612hoD1MME4q3twwwO3o1jYjlU4sUY4e9DuWA0LKHovEXu0crVrGFTvofZEjkLbJT14Tb3a8bnIUOMslhV6DMFDAU6GBg8VKqxigta8Mzu1ILw9y5lb56U6pTGwUkGMAE1lC0f2g9zzk4hwPks2hgHzp+5ET/NKSFpOEsjfhLM55qsFjzxzirxHo5rGNpT1hsvU1JD3xKNGyU48BDBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(83380400001)(54906003)(478600001)(53546011)(66556008)(6916009)(186003)(2906002)(316002)(8936002)(66446008)(52536014)(5660300002)(66946007)(64756008)(4326008)(86362001)(71200400001)(9686003)(55016002)(7416002)(76116006)(33656002)(8676002)(66476007)(7696005)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vXbAz80yH1C/kRqqKJ2VaKfHXNyX8rayQGTG7XYkGW8ouYo+TZvsCZMHY4Rbvc3YFmGciONVmtm7ZE0vbVd09dTm0Rm2aJa4+gNmUsTKGzdFXKz0poLHZmzf3Ag6jM9S943TtQ1J/BkeX/AxAqhSS65OyXL8SUW0Mr0BM0Z/1b2Lh89HzmVl720paKEgkVASVM/f3wswK0orjSfUFYNFzojTpmgjY5oA1oNGwfpZegbL+9CRdXUoroX2cslKsnb2bRr+Y7maSN02Mw3OBMeOLbPFPd2wIBhVCAXgoJ2VFIpoglf+TK6IxkLQJ2zWXcCC81k3KsgiAiooimn6y+Bm5tv+mNXaaQ36xjgpiH6jbBQf1o7YNMyi9Vb7hCYFoxpvE5mi9PnIfoy0IXi7PbimAmwdBiFGu0zl9Usm491Tjwn7zVXUJjRKnHz9sEA2KiC7N6cVI9kbz1KnvAETzc5/wpKS/iS6DXQ0VJx980H2SgD0QrbmJXzjvKXNg8jojqfis8Lw7axRpLLA+mwKAKqihq0abtOBjPOFl5Ydp1u7Ywhf2G031kHj//mSIPVkyZeQ5lkjKo3UbktNVuyvEJ9LTSuJKHtd1yoIQf8ctqfdgwJGF6BV1MroSu6B5YuHeSItyeTL+nQNIYDdcrw2IJNwk/uDzF+xG6XILaFxfk5l/Ov9mFSgQME9lWOJCjexYb8u8FRmUU4mfdJEOOHve98pMLsPWPSqxq9aK6O24j6RTP3qPnG0tKcIZjrKMf6j4cOk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f826a2-bebe-4d9f-95e9-08d8b6db6c71
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 09:21:20.4262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vbup7jxgioVkAHPqr/hP8FJxyxTGsplJ/M2T/H5+RHrUvVpC1b+27KoWHWHb6ZyUbF+qFAx4jR14UIRM18iZjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1481
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgVml2ZWssDQoNCj4gRnJvbTogVml2ZWsgR2F1dGFtIDx2aXZlay5nYXV0YW1AYXJtLmNvbT4N
Cj4gU2VudDogVHVlc2RheSwgSmFudWFyeSAxMiwgMjAyMSAyOjUwIFBNDQo+IA0KPiBIaSBZaSwN
Cj4gDQo+IA0KPiBPbiBUaHUsIFNlcCAxMCwgMjAyMCBhdCA0OjEzIFBNIExpdSBZaSBMIDx5aS5s
LmxpdUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBpcyBhZGRlZCBhcyBp
bnN0ZWFkIG9mIHJldHVybmluZyBhIGJvb2xlYW4gZm9yDQo+IERPTUFJTl9BVFRSX05FU1RJTkcs
DQo+ID4gaW9tbXVfZG9tYWluX2dldF9hdHRyKCkgc2hvdWxkIHJldHVybiBhbiBpb21tdV9uZXN0
aW5nX2luZm8gaGFuZGxlLg0KPiBGb3INCj4gPiBub3csIHJldHVybiBhbiBlbXB0eSBuZXN0aW5n
IGluZm8gc3RydWN0IGZvciBub3cgYXMgdHJ1ZSBuZXN0aW5nIGlzIG5vdA0KPiA+IHlldCBzdXBw
b3J0ZWQgYnkgdGhlIFNNTVVzLg0KPiA+DQo+ID4gQ2M6IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5l
bC5vcmc+DQo+ID4gQ2M6IFJvYmluIE11cnBoeSA8cm9iaW4ubXVycGh5QGFybS5jb20+DQo+ID4g
Q2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGls
aXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4gU3VnZ2VzdGVkLWJ5
OiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiAtLS0NCj4g
PiB2NSAtPiB2NjoNCj4gPiAqKSBhZGQgcmV2aWV3LWJ5IGZyb20gRXJpYyBBdWdlci4NCj4gPg0K
PiA+IHY0IC0+IHY1Og0KPiA+ICopIGFkZHJlc3MgY29tbWVudHMgZnJvbSBFcmljIEF1Z2VyLg0K
PiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12My9hcm0tc21tdS12My5j
IHwgMjkNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gPiAgZHJpdmVycy9pb21t
dS9hcm0vYXJtLXNtbXUvYXJtLXNtbXUuYyAgICAgICB8IDI5DQo+ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNTQgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2FybS9hcm0t
c21tdS12My9hcm0tc21tdS12My5jDQo+IGIvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMv
YXJtLXNtbXUtdjMuYw0KPiA+IGluZGV4IDcxOTYyMDcuLjAxNmUyZTUgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMNCj4gPiBAQCAtMzAx
OSw2ICszMDE5LDMyIEBAIHN0YXRpYyBzdHJ1Y3QgaW9tbXVfZ3JvdXANCj4gKmFybV9zbW11X2Rl
dmljZV9ncm91cChzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ID4gICAgICAgICByZXR1cm4gZ3JvdXA7
DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgaW50IGFybV9zbW11X2RvbWFpbl9uZXN0aW5nX2lu
Zm8oc3RydWN0IGFybV9zbW11X2RvbWFpbg0KPiAqc21tdV9kb21haW4sDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZvaWQgKmRhdGEpDQo+ID4gK3sNCj4gPiAr
ICAgICAgIHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8gKmluZm8gPSAoc3RydWN0IGlvbW11X25l
c3RpbmdfaW5mbw0KPiAqKWRhdGE7DQo+ID4gKyAgICAgICB1bnNpZ25lZCBpbnQgc2l6ZTsNCj4g
PiArDQo+ID4gKyAgICAgICBpZiAoIWluZm8gfHwgc21tdV9kb21haW4tPnN0YWdlICE9IEFSTV9T
TU1VX0RPTUFJTl9ORVNURUQpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRU5PREVWOw0K
PiA+ICsNCj4gPiArICAgICAgIHNpemUgPSBzaXplb2Yoc3RydWN0IGlvbW11X25lc3RpbmdfaW5m
byk7DQo+ID4gKw0KPiA+ICsgICAgICAgLyoNCj4gPiArICAgICAgICAqIGlmIHByb3ZpZGVkIGJ1
ZmZlciBzaXplIGlzIHNtYWxsZXIgdGhhbiBleHBlY3RlZCwgc2hvdWxkDQo+ID4gKyAgICAgICAg
KiByZXR1cm4gMCBhbmQgYWxzbyB0aGUgZXhwZWN0ZWQgYnVmZmVyIHNpemUgdG8gY2FsbGVyLg0K
PiA+ICsgICAgICAgICovDQo+ID4gKyAgICAgICBpZiAoaW5mby0+YXJnc3ogPCBzaXplKSB7DQo+
ID4gKyAgICAgICAgICAgICAgIGluZm8tPmFyZ3N6ID0gc2l6ZTsNCj4gPiArICAgICAgICAgICAg
ICAgcmV0dXJuIDA7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgLyogcmVwb3J0
IGFuIGVtcHR5IGlvbW11X25lc3RpbmdfaW5mbyBmb3Igbm93ICovDQo+ID4gKyAgICAgICBtZW1z
ZXQoaW5mbywgMHgwLCBzaXplKTsNCj4gPiArICAgICAgIGluZm8tPmFyZ3N6ID0gc2l6ZTsNCj4g
PiArICAgICAgIHJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IGFybV9z
bW11X2RvbWFpbl9nZXRfYXR0cihzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZW51bSBpb21tdV9hdHRyIGF0dHIsIHZv
aWQgKmRhdGEpDQo+ID4gIHsNCj4gPiBAQCAtMzAyOCw4ICszMDU0LDcgQEAgc3RhdGljIGludCBh
cm1fc21tdV9kb21haW5fZ2V0X2F0dHIoc3RydWN0DQo+IGlvbW11X2RvbWFpbiAqZG9tYWluLA0K
PiA+ICAgICAgICAgY2FzZSBJT01NVV9ET01BSU5fVU5NQU5BR0VEOg0KPiA+ICAgICAgICAgICAg
ICAgICBzd2l0Y2ggKGF0dHIpIHsNCj4gPiAgICAgICAgICAgICAgICAgY2FzZSBET01BSU5fQVRU
Ul9ORVNUSU5HOg0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICooaW50ICopZGF0YSA9IChz
bW11X2RvbWFpbi0+c3RhZ2UgPT0NCj4gQVJNX1NNTVVfRE9NQUlOX05FU1RFRCk7DQo+ID4gLSAg
ICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgcmV0dXJuIGFybV9zbW11X2RvbWFpbl9uZXN0aW5nX2luZm8oc21tdV9kb21haW4sDQo+IGRh
dGEpOw0KPiANCj4gVGhhbmtzIGZvciB0aGUgcGF0Y2guDQo+IFRoaXMgd291bGQgdW5uZWNlc3Nh
cmlseSBvdmVyZmxvdyAnZGF0YScgZm9yIGFueSBjYWxsZXIgdGhhdCdzIGV4cGVjdGluZyBvbmx5
DQo+IGFuIGludCBkYXRhLiBEdW1wIGZyb20gb25lIHN1Y2ggaXNzdWUgdGhhdCBJIHdhcyBzZWVp
bmcgd2hlbiB0ZXN0aW5nDQo+IHRoaXMgY2hhbmdlIGFsb25nIHdpdGggbG9jYWwga3ZtdG9vbCBj
aGFuZ2VzIGlzIHBhc3RlZCBiZWxvdyBbMV0uDQo+IA0KPiBJIGNvdWxkIGdldCBhcm91bmQgd2l0
aCB0aGUgaXNzdWUgYnkgYWRkaW5nIGFub3RoZXIgKGlvbW11X2F0dHIpIC0NCj4gRE9NQUlOX0FU
VFJfTkVTVElOR19JTkZPIHRoYXQgcmV0dXJucyAoaW9tbXVfbmVzdGluZ19pbmZvKS4NCg0Kbmlj
ZSB0byBoZWFyIGZyb20geW91LiBBdCBmaXJzdCwgd2UgcGxhbm5lZCB0byBoYXZlIGEgc2VwYXJh
dGUgaW9tbXVfYXR0cg0KZm9yIGdldHRpbmcgbmVzdGluZ19pbmZvLiBIb3dldmVyLCB3ZSBjb25z
aWRlcmVkIHRoZXJlIGlzIG5vIGV4aXN0aW5nIHVzZXINCndoaWNoIGdldHMgRE9NQUlOX0FUVFJf
TkVTVElORywgc28gd2UgZGVjaWRlZCB0byByZXVzZSBpdCBmb3IgaW9tbXUgbmVzdGluZw0KaW5m
by4gQ291bGQgeW91IHNoYXJlIG1lIHRoZSBjb2RlIGJhc2UgeW91IGFyZSB1c2luZz8gSWYgdGhl
IGVycm9yIHlvdQ0KZW5jb3VudGVyZWQgaXMgZHVlIHRvIHRoaXMgY2hhbmdlLCBzbyB0aGVyZSBz
aG91bGQgYmUgYSBwbGFjZSB3aGljaCBnZXRzDQpET01BSU5fQVRUUl9ORVNUSU5HLg0KDQpSZWdh
cmRzLA0KWWkgTGl1DQoNCj4gVGhhbmtzICYgcmVnYXJkcw0KPiBWaXZlaw0KPiANCj4gWzFdLS0t
LS0tLS0tLS0tLS0NCj4gWyAgODExLjc1NjUxNl0gdmZpby1wY2kgMDAwMDowODowMC4xOiB2Zmlv
X2VjYXBfaW5pdDogaGlkaW5nIGVjYXANCj4gMHgxYkAweDEwOA0KPiBbICA4MTEuNzU2NTE2XSBL
ZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogc3RhY2stcHJvdGVjdG9yOiBLZXJuZWwNCj4gc3Rh
Y2sgaXMgY29ycnVwdGVkIGluOiB2ZmlvX3BjaV9vcGVuKzB4NjQ0LzB4NjQ4DQo+IFsgIDgxMS43
NTY1MTZdIENQVTogMCBQSUQ6IDE3NSBDb21tOiBsa3ZtLWNsZWFudXAtbmUgTm90IHRhaW50ZWQN
Cj4gNS4xMC4wLXJjNS0wMDA5Ni1nZjAxNTA2MWUxNGNmICM0Mw0KPiBbICA4MTEuNzU2NTE2XSBD
YWxsIHRyYWNlOg0KPiBbICA4MTEuNzU2NTE2XSAgZHVtcF9iYWNrdHJhY2UrMHgwLzB4MWIwDQo+
IFsgIDgxMS43NTY1MTZdICBzaG93X3N0YWNrKzB4MTgvMHg2OA0KPiBbICA4MTEuNzU2NTE2XSAg
ZHVtcF9zdGFjaysweGQ4LzB4MTM0DQo+IFsgIDgxMS43NTY1MTZdICBwYW5pYysweDE3NC8weDMz
Yw0KPiBbICA4MTEuNzU2NTE2XSAgX19zdGFja19jaGtfZmFpbCsweDNjLzB4NDANCj4gWyAgODEx
Ljc1NjUxNl0gIHZmaW9fcGNpX29wZW4rMHg2NDQvMHg2NDgNCj4gWyAgODExLjc1NjUxNl0gIHZm
aW9fZ3JvdXBfZm9wc191bmxfaW9jdGwrMHg0YmMvMHg2NDgNCj4gWyAgODExLjc1NjUxNl0gIDB4
MA0KPiBbICA4MTEuNzU2NTE2XSBTTVA6IHN0b3BwaW5nIHNlY29uZGFyeSBDUFVzDQo+IFsgIDgx
MS43NTY1OTddIEtlcm5lbCBPZmZzZXQ6IGRpc2FibGVkDQo+IFsgIDgxMS43NTY1OTddIENQVSBm
ZWF0dXJlczogMHgwMDQwMDA2LDZhMDBhYTM4DQo+IFsgIDgxMS43NTY2MDJdIE1lbW9yeSBMaW1p
dDogbm9uZQ0KPiBbICA4MTEuNzY4NDk3XSAtLS1bIGVuZCBLZXJuZWwgcGFuaWMgLSBub3Qgc3lu
Y2luZzogc3RhY2stcHJvdGVjdG9yOg0KPiBLZXJuZWwgc3RhY2sgaXMgY29ycnVwdGVkIGluOiB2
ZmlvX3BjaV9vcGVuKzB4NjQ0LzB4NjQ4IF0NCj4gLS0tLS0tLS0tLS0tLQ0K

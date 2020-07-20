Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5F1226039
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgGTMzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 08:55:48 -0400
Received: from mga07.intel.com ([134.134.136.100]:45023 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728487AbgGTMzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 08:55:47 -0400
IronPort-SDR: yg6nkCLXFTSdmnqqNN93Ykh9PP65uPcV8L/LtkkdZRue0x1Pnq4ebuk5+KNhqc9od+53ORSpmA
 09PxjisUwT+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="214579810"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="214579810"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 05:55:46 -0700
IronPort-SDR: JTZscmiM3M2/kRoY6nFvzqRMVgx81rXAkbbJnHvnzUxTHp5ub2XpI//lZqUIVsXx/njP3t7bVw
 D4Mj8m6Go6Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="283503680"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2020 05:55:45 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 05:55:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Jul 2020 05:55:45 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 20 Jul 2020 05:55:44 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Jul 2020 05:55:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCckEqySA+ujNi/qIkoYrxVEhqGfGHdETbR2DyGCshPS5UnFsbkM9Py4w+Q8cimGyK+29MFW43JAt9eMmyr1Ty+B8/oZOdNTHHfjsgJ5Ja5zOLaMuDSk6KoYYCQs+ChphXIG7Twmn/brE5q/tIbaOtRkrnu4K49N77KOGvb1RD4V7DsANZ+Baq60U2Yb+WYtmCktzQL/bHwdw76kLjKPr3FPNVFXUNirmfUzKNN1QCRqsnMVt5TUurVouRJYxsYpDUx2QASzQ9qdJNqpOPebFF7cZ3Yqd7qPRCAEqEPEOftxarPo2Y1ZTakGjzrlhHoGYZci6bQciPVnkc7+7QwJrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gchef5zTAnKNtG6eRQWbmEr3MSanqeVCFwDyHt+j1Ms=;
 b=BSoxKC+rO71wmSDUekAPIAcORXPW+cN1iNs9wY2CFHvWB657z57GzQEKHV3wCnw/TVw01JzpgRAlGRT9+2jx8ZN7H41YU8jwGwHXNrbT3plnlP7fNNsM2uVks/Qp8NB0tIHZ53CBBpHL1vXCecjTHsREuH61E3cWoSCelFYF9tHOLbIzz56u8ic5YGugD+9cShwyoK6Y8rt2XWdqWb4KYaSVra/6CuQN+x+BKhxvu6maC7OJn5cgbmIdGj14BfCUoFY82SeuVH75OmSJW5nCKbtqEOszNE5utAbHcCoRTdf1ooPQIcqzXhg/q7bLVHiw3+W5SE+8+WpWzFex5kMwyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gchef5zTAnKNtG6eRQWbmEr3MSanqeVCFwDyHt+j1Ms=;
 b=A3ilxDU+mdsYldmWVf23NnL39IDT6d+1x0K9E/Q1Kf0DRcOJtDqjUmx2GmyuZb7m/oXgzyxD5v7yWHE8u73YBvHvX8M6hEU/u5bPZkSspBiBYn8K6mE48imnV54qD4UYAWU6UXNgP3ylvfGaAYY/cPaR3K1cYxTgCg4Ad3hAWLk=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3994.namprd11.prod.outlook.com (2603:10b6:5:193::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.17; Mon, 20 Jul 2020 12:55:42 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 12:55:42 +0000
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
Subject: RE: [PATCH v5 09/15] iommu/vt-d: Check ownership for PASIDs from
 user-space
Thread-Topic: [PATCH v5 09/15] iommu/vt-d: Check ownership for PASIDs from
 user-space
Thread-Index: AQHWWD2mfecmeDXWOkCzHg/KKlvw3qkPHIEAgAEt7vCAACpBgIAAA2nQ
Date:   Mon, 20 Jul 2020 12:55:42 +0000
Message-ID: <DM5PR11MB1435E4B45DA5D78151A28426C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-10-git-send-email-yi.l.liu@intel.com>
 <b55a09f7-c0ce-f2ff-a725-87a8e042ab80@redhat.com>
 <DM5PR11MB14351CB472AEEAFB864A4DFEC37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <e31c2b5e-b3c1-b42d-a280-83ed61f311c0@redhat.com>
In-Reply-To: <e31c2b5e-b3c1-b42d-a280-83ed61f311c0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f2d3282-817a-466a-fc08-08d82cac3602
x-ms-traffictypediagnostic: DM6PR11MB3994:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB399450C9216843F5D4B3B379C37B0@DM6PR11MB3994.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DAYZhLD4KZbV0oSb8ANLdcovUVAyziQ7ZQ6SpplUta35cJK4Wn5nnpLQBJ99e43fQZAku6COTBcPkBIMeBt/4P2pmEy/wQeS/Pxt2rjJvPQp/oypoDkmY+qnu1vQocjNxeoZoXCGx+OIm7rCn1/HQ7lL5SoRGHIeJ/0iFMoG2tllngbK4NfQOzprwPT2jNQKCHglyR6waTOcNKlRPkxGQuFe6ZbteWEMxCNhk7FgKyvJr27E0Vdk4gmpqRZ3kPgdkQyMoXbZ6LZ/6twBNJtBbRLue6rae164CpDSfKx/TwlZSzmfXVpad56CM73UwKdb3eSDnPZiQobQRpelOvHPpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(26005)(8936002)(478600001)(2906002)(55016002)(66946007)(5660300002)(6506007)(9686003)(66556008)(66446008)(52536014)(76116006)(64756008)(86362001)(66476007)(53546011)(110136005)(186003)(83380400001)(7696005)(316002)(7416002)(54906003)(71200400001)(8676002)(33656002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: I7hKczPQMlUuCzqPYuxqmkTXwSTSzLL/HXi5msN02YI2AB8iLohwDpz0fCRQBNEMtz8yYpuGfL6NTAnHkxNAnyAb9RLxeTnrUeef4WkjujC/cmfinW0Ts/MBNFEvMBpgGBH1ROPq7m0RUyhuDcpbsj2HuVAyPuZjjeEKQCSAFYGnjsEWsaI9XWy1A7SAPWOBA8VmsEXYgxmmndm/BPOXLxqh2YIJidTGRCGGIFGqFlu8Ri0osT1udV0uP1iGT7+/AFRYAJaaRjLuXfbG68cz9buKtl1M8jQi9o8zYfIKmCIx0Pngnq+mPI+e07kl59gLg+rMVlxbk8JbwfHQAtUq4oPwHTyPI9lwTbhTRUFeL9BVGWV7DZb92u7UgJUC5g0vxa4gOfaxa+rUBUT8NkTCfyFd9SQTg4ko7mmMiwFEUM7AnhMcB+jn7pkgs+SrfFGrjgN19bK3YNvULv54zhxGsop2BJ3Pp1nS2L0L8k/4/06mJhTrAL7BD/TzcAjrLib0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2d3282-817a-466a-fc08-08d82cac3602
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 12:55:42.4367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: COTC1M+M7FiP+wgq2Xj2UloVcnqoJSt0kL9eWu1+K0RnyqOIzeqTAnCzvPpY+1jfvuXUBeLOWyql6Jkk2WLocg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3994
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNl
bnQ6IE1vbmRheSwgSnVseSAyMCwgMjAyMCA4OjM4IFBNDQo+IA0KPiBZaSwNCj4gDQo+IE9uIDcv
MjAvMjAgMTI6MTggUE0sIExpdSwgWWkgTCB3cm90ZToNCj4gPiBIaSBFcmljLA0KPiA+DQo+ID4+
IEZyb206IEF1Z2VyIEVyaWMgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPj4gU2VudDogTW9u
ZGF5LCBKdWx5IDIwLCAyMDIwIDEyOjA2IEFNDQo+ID4+DQo+ID4+IEhpIFlpLA0KPiA+Pg0KPiA+
PiBPbiA3LzEyLzIwIDE6MjEgUE0sIExpdSBZaSBMIHdyb3RlOg0KPiA+Pj4gV2hlbiBhbiBJT01N
VSBkb21haW4gd2l0aCBuZXN0aW5nIGF0dHJpYnV0ZSBpcyB1c2VkIGZvciBndWVzdCBTVkEsIGEN
Cj4gPj4+IHN5c3RlbS13aWRlIFBBU0lEIGlzIGFsbG9jYXRlZCBmb3IgYmluZGluZyB3aXRoIHRo
ZSBkZXZpY2UgYW5kIHRoZSBkb21haW4uDQo+ID4+PiBGb3Igc2VjdXJpdHkgcmVhc29uLCB3ZSBu
ZWVkIHRvIGNoZWNrIHRoZSBQQVNJRCBwYXNzc2VkIGZyb20gdXNlci1zcGFjZS4NCj4gPj4gcGFz
c2VkDQo+ID4NCj4gPiBnb3QgaXQuDQo+ID4NCj4gPj4+IGUuZy4gcGFnZSB0YWJsZSBiaW5kL3Vu
YmluZCBhbmQgUEFTSUQgcmVsYXRlZCBjYWNoZSBpbnZhbGlkYXRpb24uDQo+ID4+Pg0KPiA+Pj4g
Q2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+Pj4gQ0M6IEphY29iIFBh
biA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4+PiBDYzogQWxleCBXaWxsaWFt
c29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPj4+IENjOiBFcmljIEF1Z2VyIDxl
cmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4+PiBDYzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxq
ZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4+PiBDYzogSm9lcmcgUm9lZGVsIDxqb3JvQDhi
eXRlcy5vcmc+DQo+ID4+PiBDYzogTHUgQmFvbHUgPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4N
Cj4gPj4+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4+
PiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29t
Pg0KPiA+Pj4gLS0tDQo+ID4+PiAgZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jIHwgMTAgKysr
KysrKysrKw0KPiA+Pj4gIGRyaXZlcnMvaW9tbXUvaW50ZWwvc3ZtLmMgICB8ICA3ICsrKysrLS0N
Cj4gPj4+ICAyIGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYyBi
L2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+Pj4gaW5kZXggNGQ1NDE5OC4uYTk1MDRj
YiAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+Pj4g
KysrIGIvZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jDQo+ID4+PiBAQCAtNTQzNiw2ICs1NDM2
LDcgQEAgaW50ZWxfaW9tbXVfc3ZhX2ludmFsaWRhdGUoc3RydWN0IGlvbW11X2RvbWFpbg0KPiA+
PiAqZG9tYWluLCBzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4+PiAgCQlpbnQgZ3JhbnUgPSAwOw0K
PiA+Pj4gIAkJdTY0IHBhc2lkID0gMDsNCj4gPj4+ICAJCXU2NCBhZGRyID0gMDsNCj4gPj4+ICsJ
CXZvaWQgKnBkYXRhOw0KPiA+Pj4NCj4gPj4+ICAJCWdyYW51ID0gdG9fdnRkX2dyYW51bGFyaXR5
KGNhY2hlX3R5cGUsIGludl9pbmZvLT5ncmFudWxhcml0eSk7DQo+ID4+PiAgCQlpZiAoZ3JhbnUg
PT0gLUVJTlZBTCkgew0KPiA+Pj4gQEAgLTU0NTYsNiArNTQ1NywxNSBAQCBpbnRlbF9pb21tdV9z
dmFfaW52YWxpZGF0ZShzdHJ1Y3QgaW9tbXVfZG9tYWluDQo+ID4+ICpkb21haW4sIHN0cnVjdCBk
ZXZpY2UgKmRldiwNCj4gPj4+ICAJCQkgKGludl9pbmZvLT5ncmFudS5hZGRyX2luZm8uZmxhZ3Mg
Jg0KPiA+PiBJT01NVV9JTlZfQUREUl9GTEFHU19QQVNJRCkpDQo+ID4+PiAgCQkJcGFzaWQgPSBp
bnZfaW5mby0+Z3JhbnUuYWRkcl9pbmZvLnBhc2lkOw0KPiA+Pj4NCj4gPj4+ICsJCXBkYXRhID0g
aW9hc2lkX2ZpbmQoZG1hcl9kb21haW4tPmlvYXNpZF9zaWQsIHBhc2lkLCBOVUxMKTsNCj4gPj4+
ICsJCWlmICghcGRhdGEpIHsNCj4gPj4+ICsJCQlyZXQgPSAtRUlOVkFMOw0KPiA+Pj4gKwkJCWdv
dG8gb3V0X3VubG9jazsNCj4gPj4+ICsJCX0gZWxzZSBpZiAoSVNfRVJSKHBkYXRhKSkgew0KPiA+
Pj4gKwkJCXJldCA9IFBUUl9FUlIocGRhdGEpOw0KPiA+Pj4gKwkJCWdvdG8gb3V0X3VubG9jazsN
Cj4gPj4+ICsJCX0NCj4gPj4+ICsNCj4gPj4+ICAJCXN3aXRjaCAoQklUKGNhY2hlX3R5cGUpKSB7
DQo+ID4+PiAgCQljYXNlIElPTU1VX0NBQ0hFX0lOVl9UWVBFX0lPVExCOg0KPiA+Pj4gIAkJCS8q
IEhXIHdpbGwgaWdub3JlIExTQiBiaXRzIGJhc2VkIG9uIGFkZHJlc3MgbWFzayAqLw0KPiA+Pj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvc3ZtLmMgYi9kcml2ZXJzL2lvbW11L2lu
dGVsL3N2bS5jDQo+ID4+PiBpbmRleCBkMmMwZTFhLi4yMTJkZWUwIDEwMDY0NA0KPiA+Pj4gLS0t
IGEvZHJpdmVycy9pb21tdS9pbnRlbC9zdm0uYw0KPiA+Pj4gKysrIGIvZHJpdmVycy9pb21tdS9p
bnRlbC9zdm0uYw0KPiA+Pj4gQEAgLTMxOSw3ICszMTksNyBAQCBpbnQgaW50ZWxfc3ZtX2JpbmRf
Z3Bhc2lkKHN0cnVjdCBpb21tdV9kb21haW4NCj4gKmRvbWFpbiwNCj4gPj4gc3RydWN0IGRldmlj
ZSAqZGV2LA0KPiA+Pj4gIAlkbWFyX2RvbWFpbiA9IHRvX2RtYXJfZG9tYWluKGRvbWFpbik7DQo+
ID4+Pg0KPiA+Pj4gIAltdXRleF9sb2NrKCZwYXNpZF9tdXRleCk7DQo+ID4+PiAtCXN2bSA9IGlv
YXNpZF9maW5kKElOVkFMSURfSU9BU0lEX1NFVCwgZGF0YS0+aHBhc2lkLCBOVUxMKTsNCj4gSSBt
ZWFudCB3aGlsZSB1c2luZyBJTlZBTElEX0lPQVNJRF9TRVQgaW5zdGVhZCBvZiB0aGUgYWN0dWFs
DQo+IGRtYXJfZG9tYWluLT5pb2FzaWRfc2lkLiBCdXQgSSB0aGluayBJJ3ZlIG5vdyByZWNvdmVy
ZWQsIHRoZSBhc3NldCBpcw0KPiBzaW1wbHkgbm90IHVzZWQgOy0pDQoNCm9oLCBJIHRoaW5rIHNo
b3VsZCBiZSB1c2luZyBkbWFyX2RvbWFpbi0+aW9hc2lkX3NpZCBmcm9tIHRoZSBiZWdpbm5pbmcu
DQpkb2VzIGl0IGxvb2sgZ29vZCBzbyBmYXI/IDotKQ0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4g
Pj4gSSBkbyBub3QgZ2V0IHdoYXQgdGhlIGNhbGwgd2FzIHN1cHBvc2VkIHRvIGRvIGJlZm9yZSB0
aGF0IHBhdGNoPw0KPiA+DQo+ID4geW91IG1lYW4gcGF0Y2ggMTAvMTUgYnkgInRoYXQgcGF0Y2gi
LCByaWdodD8gdGhlIG93bmVyc2hpcCBjaGVjayBzaG91bGQNCj4gPiBiZSBkb25lIGFzIHRvIHBy
ZXZlbnQgaWxsZWdhbCBiaW5kIHJlcXVlc3QgZnJvbSB1c2Vyc3BhY2UuIGJlZm9yZSBwYXRjaA0K
PiA+IDEwLzE1LCBpdCBzaG91bGQgYmUgYWRkZWQuDQo+ID4NCj4gPj4+ICsJc3ZtID0gaW9hc2lk
X2ZpbmQoZG1hcl9kb21haW4tPmlvYXNpZF9zaWQsIGRhdGEtPmhwYXNpZCwgTlVMTCk7DQo+ID4+
PiAgCWlmIChJU19FUlIoc3ZtKSkgew0KPiA+Pj4gIAkJcmV0ID0gUFRSX0VSUihzdm0pOw0KPiA+
Pj4gIAkJZ290byBvdXQ7DQo+ID4+PiBAQCAtNDM2LDYgKzQzNiw3IEBAIGludCBpbnRlbF9zdm1f
dW5iaW5kX2dwYXNpZChzdHJ1Y3QgaW9tbXVfZG9tYWluDQo+ID4+ICpkb21haW4sDQo+ID4+PiAg
CQkJICAgIHN0cnVjdCBkZXZpY2UgKmRldiwgaW9hc2lkX3QgcGFzaWQpDQo+ID4+PiAgew0KPiA+
Pj4gIAlzdHJ1Y3QgaW50ZWxfaW9tbXUgKmlvbW11ID0gaW50ZWxfc3ZtX2RldmljZV90b19pb21t
dShkZXYpOw0KPiA+Pj4gKwlzdHJ1Y3QgZG1hcl9kb21haW4gKmRtYXJfZG9tYWluOw0KPiA+Pj4g
IAlzdHJ1Y3QgaW50ZWxfc3ZtX2RldiAqc2RldjsNCj4gPj4+ICAJc3RydWN0IGludGVsX3N2bSAq
c3ZtOw0KPiA+Pj4gIAlpbnQgcmV0ID0gLUVJTlZBTDsNCj4gPj4+IEBAIC00NDMsOCArNDQ0LDEw
IEBAIGludCBpbnRlbF9zdm1fdW5iaW5kX2dwYXNpZChzdHJ1Y3QgaW9tbXVfZG9tYWluDQo+ID4+
ICpkb21haW4sDQo+ID4+PiAgCWlmIChXQVJOX09OKCFpb21tdSkpDQo+ID4+PiAgCQlyZXR1cm4g
LUVJTlZBTDsNCj4gPj4+DQo+ID4+PiArCWRtYXJfZG9tYWluID0gdG9fZG1hcl9kb21haW4oZG9t
YWluKTsNCj4gPj4+ICsNCj4gPj4+ICAJbXV0ZXhfbG9jaygmcGFzaWRfbXV0ZXgpOw0KPiA+Pj4g
LQlzdm0gPSBpb2FzaWRfZmluZChJTlZBTElEX0lPQVNJRF9TRVQsIHBhc2lkLCBOVUxMKTsNCj4g
Pj4+ICsJc3ZtID0gaW9hc2lkX2ZpbmQoZG1hcl9kb21haW4tPmlvYXNpZF9zaWQsIHBhc2lkLCBO
VUxMKTsNCj4gPj4ganVzdCB0byBtYWtlIHN1cmUsIGFib3V0IHRoZSBsb2NraW5nLCBjYW4ndCBk
b21haW4tPmlvYXNpZF9zaWQgY2hhbmdlDQo+ID4+IHVuZGVyIHRoZSBob29kPw0KPiA+DQo+ID4g
SSBndWVzcyBub3QuIGludGVsX3N2bV91bmJpbmRfZ3Bhc2lkKCkgYW5kIGlvbW11X2RvbWFpbl9z
ZXRfYXR0cigpDQo+ID4gaXMgY2FsbGVkIGJ5IHZmaW8gdG9kYXksIGFuZCB3aXRoaW4gdmZpbywg
dGhlcmUgaXMgdmZpb19pb21tdS0+bG9jay4NCj4gT0sNCj4gDQo+IFRoYW5rcw0KPiANCj4gRXJp
Yw0KPiA+DQo+ID4gUmVnYXJkcywNCj4gPiBZaSBMaXUNCj4gPg0KPiA+Pg0KPiA+PiBUaGFua3MN
Cj4gPj4NCj4gPj4gRXJpYw0KPiA+Pj4gIAlpZiAoIXN2bSkgew0KPiA+Pj4gIAkJcmV0ID0gLUVJ
TlZBTDsNCj4gPj4+ICAJCWdvdG8gb3V0Ow0KPiA+Pj4NCj4gPg0KDQo=

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B2E225A5B
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 10:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgGTItq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 04:49:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:44637 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgGTItq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 04:49:46 -0400
IronPort-SDR: XQ9/ov4DUP15fBsKE4joHcUoRShA3DcUrmot9Xw6GrIpiTI8pxIJaWKyc/yyveFOT6half7Gg1
 d3G4F3VC+QXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="149859740"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="149859740"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 01:49:43 -0700
IronPort-SDR: QwyUGhNCYdX+MS2siVseSF0tGrX/6CimmdHwrNsGaAISalp1Oec31JSd/g+lc1llM0G4i5wSkK
 HHyAN6ZGn7Mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="283447570"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2020 01:49:43 -0700
Received: from fmsmsx125.amr.corp.intel.com (10.18.125.40) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 01:49:43 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX125.amr.corp.intel.com (10.18.125.40) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 01:49:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Jul 2020 01:49:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaXtC8L02dAPJVHLRDTeKJl4+6iHnp1vjMwpuNRGQWUwPUNMmnCT/ZbGp8xgT1VxnevaZOgejHVdeOoMpqRC59RI8wxO63Ef/D9FwQaZLLdCHYAZyj4AxuHbkqUhpA6y31KZwTiVK3jBqITECC6tJh8MAoKJOcq2xHL78n/F7Q82PhtlNxvc6xehqMIMFLpaq0C7Y7vrr3uqrwFfpDoNm+m+9qoBka+/6eeTf2YUmMxOPUfRCUs3Nn0bLXtty958GXP8UIQy/it1dZQA54q1/aV6PGLOJ9ZWllFm93/Dj7ZjOhyppAFhE1+L1tVoL+vES6AQA6KfYl0xhbU79T4pRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHT2dLXi2ZzhTQlZZY1lk6EKaBTXriZPYrCPG/baqVw=;
 b=d5Tr/zNju/7O3MzbgR2nNfX5fJmsZo4qJoEEUz02nbfh4bbHGq9IL9+CvpHRO7eyDKzhE/lO0mxywo5TBxOglJFLKBasT3XPnYbVTCHeCSF7Y0SQKju9SfkcPFVjsw1T+zJHmvu0/4fCL/eJx8Ul+FNsBW8fhQ3a60x15c0wX/+6MN4pfDyzoDCvz7JkI/470TTmQyGvlyPuLwXkiAsxrBOEB66hLmww55AtDXr7AnlpOmlUhiZHBhYyhZvMXDEFUJuWvLSjzkxh4MLyNc3kTZ7Kl6CclAsCbYw/EmJdCpm5NOGr2RkH6chqVAv1//WU+Vrf+d8PFnrnx3C5UQ0TAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHT2dLXi2ZzhTQlZZY1lk6EKaBTXriZPYrCPG/baqVw=;
 b=rzsbNZv6MnQeKTIZWkBYY2JjeSrkZW7MDj0fZ+li0OCmjcoZ+LjlYgELBpNBY4RBolG4V1tr3/Rt1xQtopXH8SckygjLcdcLknaZEIYT8hrusmsbgwz9kzSvx2Csrx9u7zLrspf05J5Xo17lT5T5BqKmYeBqFZ7weFkPOWp6JEE=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1996.namprd11.prod.outlook.com (2603:10b6:3:13::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.25; Mon, 20 Jul 2020 08:49:41 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 08:49:41 +0000
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
Subject: RE: [PATCH v5 05/15] vfio: Add PASID allocation/free support
Thread-Topic: [PATCH v5 05/15] vfio: Add PASID allocation/free support
Thread-Index: AQHWWD2nUFc6pY9OvEK1LW9mFCFZBqkPFNcAgAEQv2CAAAi6AIAAAP+g
Date:   Mon, 20 Jul 2020 08:49:41 +0000
Message-ID: <DM5PR11MB14353C2D9929384A45E8B285C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-6-git-send-email-yi.l.liu@intel.com>
 <7ce733ec-e27a-0a80-f78c-eeeb41a4ecf0@redhat.com>
 <DM5PR11MB14351019ED0DEE3E27A98D70C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <7d982308-f39c-ab5f-2318-a36600284402@redhat.com>
In-Reply-To: <7d982308-f39c-ab5f-2318-a36600284402@redhat.com>
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
x-ms-office365-filtering-correlation-id: 602bb015-400a-47ce-2307-08d82c89d7e2
x-ms-traffictypediagnostic: DM5PR11MB1996:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB199674F08CCE1A2EDA6794E1C37B0@DM5PR11MB1996.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jZQfR2xXigA8ytw/3V4+W9VnGpmrsiSlyRp95shXQ/oUVe4zKHVfuHeeHNihng2a9OqXHXjXL3wgEsuMSNdivN78BMslPk779HcKsnAx0J3Yhzp/+RbLj7sek+5KYIaVJAvFwtVmfugvfqmTg/uNYpcuSwlGm/mRIhUGGbVmMDBSPhxLdz/vECkMHTxb0NjPLakapnJud+GdUEuK8a1mExSMXiVXI7lBksq5BpWe47hgszw0AC1IFH83fUHYDZ5JWZhyEaEZCRA8c53zJRxU2B8qpnDYs3zxc5Iv2kcflqJLAc3k2SqEabGONzpt311jqggZ2qY/jMtq9M0Dh7INhruXhWKPbxXjLXE+rVWKYTPn4zzxKm1HMfGJuREJscHgy5OumuzFAykguGceqkBbYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(9686003)(186003)(26005)(316002)(7696005)(55016002)(83380400001)(33656002)(6506007)(4326008)(64756008)(8676002)(2906002)(52536014)(8936002)(110136005)(54906003)(71200400001)(5660300002)(966005)(86362001)(76116006)(66446008)(66946007)(7416002)(66476007)(478600001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LXNhQlcQyOJ9IaAO0Zfw8vqob7Qk0p9FPFqpMI5udkCXMJy+Au9MeY6v+XvxUfRNKCkDwmNXrZ7GtF6eOWKnlLhOLd460qzi/13P3eDCPWw9qEziXxYK76mSOIPdEKypZDkgooPLWeLo0Uddfnl9NDVhuvCumvpVzf3WcH6+TOlcEn9KuSrzsbd8S5Mhw/aiIvBU8zgYEUAjeCVmIj8mPuI1eb23Nvo4YijVkrYbiFWshjwrTjqfh0A9F36aaG0AWTumQ++Z2j+eR/2tQpT4fNHS9cSq82zL0kFB8BQGgK0ovzSAx4egHXSphOu8X4wC2OSF2q2wFRW+6zZoAQU5qVfiiXWPds/oV+c61oxi1AVXLm90pfWtIiRPfNtYwNHh/kvOYNLCgioBkmLdIuIbyVodM1xHPLdgSGm/NEpNyl8yVYGYtksLVtUJAk1dcvJ+TvgPY5zGl1/4veKJMVy45E4pqQSFeWcWpItMbxI74mVNGpX/F5lvhRii54YtRYur
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 602bb015-400a-47ce-2307-08d82c89d7e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 08:49:41.5129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9AxzM/Vl8Rvr/xo0PzBqfqrrU1OMnniRHPbY5MqwDjcgjfc7ubWxCD4bCGxn88i1yttwAh56Cpt1F/g3bm0tGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1996
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgSnVseSAyMCwgMjAyMCA0OjI2IFBNDQpbLi4uXQ0KPiA+Pj4gK2ludCB2
ZmlvX3Bhc2lkX2FsbG9jKHN0cnVjdCB2ZmlvX21tICp2bW0sIGludCBtaW4sIGludCBtYXgpIHsN
Cj4gPj4+ICsJaW9hc2lkX3QgcGFzaWQ7DQo+ID4+PiArCXN0cnVjdCB2ZmlvX3Bhc2lkICp2aWQ7
DQo+ID4+PiArDQo+ID4+PiArCXBhc2lkID0gaW9hc2lkX2FsbG9jKHZtbS0+aW9hc2lkX3NpZCwg
bWluLCBtYXgsIE5VTEwpOw0KPiA+Pj4gKwlpZiAocGFzaWQgPT0gSU5WQUxJRF9JT0FTSUQpDQo+
ID4+PiArCQlyZXR1cm4gLUVOT1NQQzsNCj4gPj4+ICsNCj4gPj4+ICsJdmlkID0ga3phbGxvYyhz
aXplb2YoKnZpZCksIEdGUF9LRVJORUwpOw0KPiA+Pj4gKwlpZiAoIXZpZCkgew0KPiA+Pj4gKwkJ
aW9hc2lkX2ZyZWUocGFzaWQpOw0KPiA+Pj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ID4+PiArCX0N
Cj4gPj4+ICsNCj4gPj4+ICsJdmlkLT5wYXNpZCA9IHBhc2lkOw0KPiA+Pj4gKw0KPiA+Pj4gKwlt
dXRleF9sb2NrKCZ2bW0tPnBhc2lkX2xvY2spOw0KPiA+Pj4gKwl2ZmlvX2xpbmtfcGFzaWQodm1t
LCB2aWQpOw0KPiA+Pj4gKwltdXRleF91bmxvY2soJnZtbS0+cGFzaWRfbG9jayk7DQo+ID4+PiAr
DQo+ID4+PiArCXJldHVybiBwYXNpZDsNCj4gPj4+ICt9DQo+ID4+IEkgYW0gbm90IHRvdGFsbHkg
Y29udmluY2VkIGJ5IHlvdXIgcHJldmlvdXMgcmVwbHkgb24gRVhQT1JUX1NZTUJPTF9HUCgpDQo+
ID4+IGlycmVsZXZhbmNlIGluIHRoaXMgcGF0Y2guIEJ1dCB3ZWxsIDstKQ0KPiA+DQo+ID4gSSBy
ZWNhbGxlZCBteSBtZW1vcnksIEkgdGhpbmsgaXQncyBtYWRlIHBlciBhIGNvbW1lbnQgZnJvbSBD
aHJpcy4NCj4gPiBJIGd1ZXNzIGl0IG1heSBtYWtlIHNlbnNlIHRvIGV4cG9ydCBzeW1ib2xzIHRv
Z2V0aGVyIHdpdGggdGhlIGV4YWN0DQo+ID4gZHJpdmVyIHVzZXIgb2YgaXQgaW4gdGhpcyBwYXRj
aCBhcyB3ZWxsIDotKSBidXQgbWF5YmUgSSBtaXN1bmRlcnN0b29kDQo+ID4gaGltLiBpZiB5ZXMs
IEkgbWF5IGFkZCB0aGUgc3ltYm9sIGV4cG9ydCBiYWNrIGluIHRoaXMgcGF0Y2guDQo+ID4NCj4g
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1pb21tdS8yMDIwMDMzMTA3NTMzMS5HQTI2
NTgzQGluZnJhZGVhZC5vcmcvI3QNCj4gT0sgSSBkb24ndCBrbm93IHRoZSBiZXN0IHByYWN0aWNl
IGhlcmUuIEFueXdheSB0aGVyZSBpcyBubyBjYWxsZXIgYXQNCj4gdGhpcyBzdGFnZSBlaXRoZXIu
IEkgdGhpbmsgeW91IG1heSBkZXNjcmliZSBpbiB0aGUgY29tbWl0IG1lc3NhZ2UgdGhlDQo+IHZm
aW9faW9tbXVfdHlwZTEgd2lsbCBiZSB0aGUgZXZlbnR1YWwgdXNlciBvZiB0aGUgZXhwb3J0ZWQg
ZnVuY3Rpb25zIGluDQo+IHRoaXMgbW9kdWxlLCB3aGF0IGFyZSB0aGUgZXhhY3QgZXhwb3J0ZWQg
ZnVuY3Rpb25zIGhlcmUuIFlvdSBtYXkgYWxzbw0KPiBleHBsYWluIHRoZSBtb3RpdmF0aW9uIGJl
aGluZCBjcmVhdGluZyBhIHNlcGFyYXRlIG1vZHVsZS4NCg0KZ290IGl0LiB3aWxsIGFkZCBpdC4N
Cg0KUmVnYXJkcywNCllpIExpdQ0KDQoNCg==

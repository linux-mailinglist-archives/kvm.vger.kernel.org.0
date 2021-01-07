Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B772ECAC6
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 08:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbhAGHDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 02:03:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:5681 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbhAGHDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 02:03:52 -0500
IronPort-SDR: NmwZzqELOX42ixy1ipmdE61GlNsd2aieL1YQUFpeA3j06857tk6hr2RQLp2lszAQdZ4n86uyYL
 iejLRJ9zKeCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="177538256"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="177538256"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 23:03:07 -0800
IronPort-SDR: hlH46tlwmu/j3uGWMnDCBQSrjLRPp304j0zhdvuYV7/SbrqBHWmMwjjLM5avXDx/ICUmgRxshr
 FiLemFextXjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="422470312"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 06 Jan 2021 23:03:06 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Jan 2021 23:03:06 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 6 Jan 2021 23:03:06 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 6 Jan 2021 23:02:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUVKQlprjqYMcc5sbuY+TeStbOIGAiOBS4j0ZloGr5kQM7tWY4fKURKmslMMcW14RUjheUiN9FbaOs5fAH7WYYal3T2DCOfTxi4+Pml0CG5UsBQkoitwAYWWjYJaqhMCvGQGHnBOgH+EBv7z6OQIVPqa1mO0Htf3e9GkUJBz2aO7DCYdUwC5awZEU6yEdF139Jiz6oBgcxLFnBQp4Ll5lKy98XqMwBi5fcvmrtfSx9V6ziKuwDrru5WhYXJOfc/K9yT4K5T2Ff+ijrsjGNU/Z46RNvbQmhC+coo/0NYRqcA9O4dKYkPphMSisTMhHsvXndnYY7pgJ0JWQl/hd+RAbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFYPTTs3vm5/iyYHnNLYI0wcbTfNKQIs7QYB5AQfbi4=;
 b=WnbgXU3+PlGXz/BTvhCI2/jdSud7uDQtml9v6O9FBC/05CHR26yT/nQxX6NTh+xz/srqUbsdtDSHRN8+swXAFzlS49QwEgYlJJp8soo3bgl6M2MtPkKIte7HlPIuXaN1/KxsyYJN/7s0NMUAleDYAJzJ/95vw65/k4EOc4fFDtASjXB/+ngs3pVebQXfU3EViGusXBqY6ZN8E1nnB7MA8797rqv1mnwUgYJN5CIPdwP+u9sX3HpxFHhA6NYyYTXw4nlqGjaH3Eg6/Rb7jEDt/b7V+0ysSIcMge8Lsz27HadsVyNMTld6fsnNgSyaJACa81I0ynn+ZXd+u9nGVzouaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFYPTTs3vm5/iyYHnNLYI0wcbTfNKQIs7QYB5AQfbi4=;
 b=MaTsnhU7kaHbpkFmqYbtspNMX5pQLgHeLd+enI1NwxbD6FWMLhs8CataaM37krwG6Se3nu00+RBnlNmREO+9Tn6WIWExDbLQ/7yr8FlTKDMHIvQtz3Wm2KazvdIhBgIHzURLHkV151CK/cbB2S48rPwtbkZYl0bttatls/fBRx0=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2125.namprd11.prod.outlook.com (2603:10b6:301:4d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 07:01:38 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::1d96:5d95:3a17:2419]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::1d96:5d95:3a17:2419%4]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 07:01:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [RFC PATCH 1/1] platform-msi: Add platform check for subdevice
 irq domain
Thread-Topic: [RFC PATCH 1/1] platform-msi: Add platform check for subdevice
 irq domain
Thread-Index: AQHWzo8FNXctlQoCAkC5wQs8oLuLIanv/iqAgCvpD4A=
Date:   Thu, 7 Jan 2021 07:01:38 +0000
Message-ID: <MWHPR11MB1886B23293B64C26B5C4B0458CAF0@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20201210004624.345282-1-baolu.lu@linux.intel.com>
 <dad0bf6e271532badd84f2a811449be566f537a9.camel@infradead.org>
In-Reply-To: <dad0bf6e271532badd84f2a811449be566f537a9.camel@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3aab20d4-cc98-4fbb-f5ea-08d8b2da143f
x-ms-traffictypediagnostic: MWHPR1101MB2125:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2125012AB7AE27499711A5C88CAF0@MWHPR1101MB2125.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a0IPJc0sbdQMRjz68T8cQ9BtsbVUzougnYpkej5qwt4bPQx0q2Ercy0sfjMqgvIjuFHtgCkk4FNj8xF+3VY7FQ6TVTvsbQ45ESsj1rWbw1KHZ8Lb65FokRayr385oXikvCvWlWxw076ge9VcyJAwwyo5NWCSwtyQLu37JMIAzfNQx4ENxuZ5hIvDd6P5KPPkZRj8pSyOsBB9EgdDoUgwkPSBx4PnBrXfpTmgUmL9r268wMuN5Z/Y0uYRVdPsVMZ5EXeJZGH5Cwc1vLTYq0hvIZDncrLpNeK5AOpOetlsiTU5JlzauoZDcGWPU2VnVnYGgXQpw9smHdpBbpDKs8Azc4eIoxc450aMpXYjVBbnojGJWQBjuwzS+MHtL20HfV04RC1gQNNkDfjeUaq+YeDu+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(64756008)(33656002)(76116006)(66476007)(66446008)(8936002)(66946007)(7416002)(52536014)(4001150100001)(8676002)(316002)(110136005)(2906002)(71200400001)(54906003)(26005)(66556008)(186003)(7696005)(86362001)(45080400002)(55016002)(4326008)(478600001)(6636002)(6506007)(5660300002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R3U4ZGRKeFBkRXlaTFYrUFRvNThRcXlraitjYldWL1VaejhhQkxia3BvU0hm?=
 =?utf-8?B?Q1pNRHh3cTlyQVRYbko1OWhvc0ZUaEpzeWFmSzZkVE5xanRrV0VwSUxPMmJF?=
 =?utf-8?B?enczWWpLSnE0M25yN25pQ1pBaVdrdmZTcG1YMHhhTHVPb2dGTVZtZ1BNZHRy?=
 =?utf-8?B?U1RXTmlMMXRYQ3lnNmw4OWtFNWNQTmtYS1pRVU5CRmN2ZVRCdktaM0d1M3hS?=
 =?utf-8?B?RmVmYnczS1RJd2w4OGg4MWJRcDNCcjFPT0dweWZTbFpXbkIwUlMzaGlHNEZM?=
 =?utf-8?B?M2x1R1dFNmNPRUNiZUZBWi9vWjQ5K3RrbGhwaDVHUTcvL09IZWp4M1FaWmtx?=
 =?utf-8?B?VzIvcFBRbGVlNHBodElYSUJ6eFhxQkVnMXplRVF5NW5NM1pJMDgzUDNMVnha?=
 =?utf-8?B?QWFLUFBiQjJibXVzR0pNNzZ1QU1ydXhDRDB6SUhJQWVwRzFxNzdTcjJsa1hQ?=
 =?utf-8?B?L2tSZ2F3WFN1N2hPcEkwSHdaTnNaVFRic3Ezd1Y5STF1eDBIbWtueTFRRkp0?=
 =?utf-8?B?V0dZTjBqTDZrRW9QR0t4SEE4Mnc0NXgvSUF1UGd0T0doU0hFS3RBNEQ5NTE0?=
 =?utf-8?B?MGNZYlQ1eS9XYmVzdWtvcTFucGZwVjREYzhyNW1HaEc4U1o1dk9nZ0JyRzBG?=
 =?utf-8?B?ZXA3enlvdzhjcHc3Z0Z5QjVWKzRCUG5NYUFkT0FlVW9UZmt1UE9iUzJKS2Y1?=
 =?utf-8?B?OUxMWGR4T3VvVWpJNGdpbTU5Qm03SVQxV1lIdGxDUSt6dEkvdFFhQjVHSEll?=
 =?utf-8?B?WTR6YWt0R2lmUmMxMzkvaUVpYW1zNWtzekJhSUE2TDZES244M0gxQTAxTEt3?=
 =?utf-8?B?Vk5KYVhISlVLOHZ0QWFvMUhHSzNyME54c2Y2VEhpdjJOTis4UHVJQWhtbmRx?=
 =?utf-8?B?Q1NQQWtMKy9PR0xIL3djM1o3YVhRNlh4ZGVXbjdjVkU5N1hrU3VPRzdXZzd2?=
 =?utf-8?B?THJFU2w0c25Qb1VoOGFQb2xXMnNnRForTGV5aDNCOWg4Y3FScmtZYVVQTkN3?=
 =?utf-8?B?QXJtUFBaMi9hbnlHOUF6R3IxMGtEWHMzY2pmWTVRQnNIZGJpdkdFNmhlakNx?=
 =?utf-8?B?S0hlNG1zTVRHNjdMYzlsQ3U2MFo1MUhOVzNFWHl3UjJJM1FkeWRIU09VU0lY?=
 =?utf-8?B?N2dYRzBkb0svUEtRcFRvZ2ZUVnZPS0xHOEF2c3RYT0dyZ0pOd2t6UllBTTF2?=
 =?utf-8?B?VTNNY1BXdFVSZGs3WUZvMmFuanhpM0sxV2EyQlF0OGloUC9mTnJrK3JhRktm?=
 =?utf-8?B?M0NDYmxtMkF5WVY1bGZTRythdi83VEgyUE4zNGpRU3RWOEJmS2pjWk4ySi9h?=
 =?utf-8?Q?dt0UNMltCxpQM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aab20d4-cc98-4fbb-f5ea-08d8b2da143f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2021 07:01:38.4566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A6xPcVqmF7enhRp+W6FsxGGJVeq4vdxMr9/eDT93syH0yyZ9B9cP1eVYjhTCI8hwE6UYERv9Xw7ipqkTu+H2sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2125
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBEYXZpZCBXb29kaG91c2UgPGR3bXcyQGluZnJhZGVhZC5vcmc+DQo+IFNlbnQ6IFRo
dXJzZGF5LCBEZWNlbWJlciAxMCwgMjAyMCA0OjIzIFBNDQo+IA0KPiBPbiBUaHUsIDIwMjAtMTIt
MTAgYXQgMDg6NDYgKzA4MDAsIEx1IEJhb2x1IHdyb3RlOg0KPiA+ICsvKg0KPiA+ICsgKiBXZSB3
YW50IHRvIGZpZ3VyZSBvdXQgd2hpY2ggY29udGV4dCB3ZSBhcmUgcnVubmluZyBpbi4gQnV0IHRo
ZQ0KPiBoYXJkd2FyZQ0KPiA+ICsgKiBkb2VzIG5vdCBpbnRyb2R1Y2UgYSByZWxpYWJsZSB3YXkg
KGluc3RydWN0aW9uLCBDUFVJRCBsZWFmLCBNU1IsDQo+IHdoYXRldmVyKQ0KPiA+ICsgKiB3aGlj
aCBjYW4gYmUgbWFuaXB1bGF0ZWQgYnkgdGhlIFZNTSB0byBsZXQgdGhlIE9TIGZpZ3VyZSBvdXQg
d2hlcmUgaXQNCj4gcnVucy4NCj4gPiArICogU28gd2UgZ28gd2l0aCB0aGUgYmVsb3cgcHJvYmFi
bHlfb25fYmFyZV9tZXRhbCgpIGZ1bmN0aW9uIGFzIGENCj4gcmVwbGFjZW1lbnQNCj4gPiArICog
Zm9yIGRlZmluaXRlbHlfb25fYmFyZV9tZXRhbCgpIHRvIGdvIGZvcndhcmQgb25seSBmb3IgdGhl
IHZlcnkgc2ltcGxlDQo+IHJlYXNvbg0KPiA+ICsgKiB0aGF0IHRoaXMgaXMgdGhlIG9ubHkgb3B0
aW9uIHdlIGhhdmUuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IHBv
c3NpYmxlX3ZtbV92ZW5kb3JfbmFtZVtdID0gew0KPiA+ICsgICAgICAgIlFFTVUiLCAiQm9jaHMi
LCAiS1ZNIiwgIlhlbiIsICJWTXdhcmUiLCAiVk1XIiwgIlZNd2FyZSBJbmMuIiwNCj4gPiArICAg
ICAgICJpbm5vdGVrIEdtYkgiLCAiT3JhY2xlIENvcnBvcmF0aW9uIiwgIlBhcmFsbGVscyIsICJC
SFlWRSIsDQo+ID4gKyAgICAgICAiTWljcm9zb2Z0IENvcnBvcmF0aW9uIg0KPiA+ICt9Ow0KPiAN
Cj4gUGVvcGxlIGRvIHVzZSBTZWFCSU9TICgiQm9jaHMiKSBvbiBiYXJlIG1ldGFsLg0KPiANCj4g
WW91J2xsIGFsc28gc2VlICJBbWF6b24gRUMyIiBvbiB2aXJ0IGluc3RhbmNlcyBhcyB3ZWxsIGFz
IGJhcmUgbWV0YWwNCj4gaW5zdGFuY2VzLiBBbHRob3VnaCBpbiB0aGF0IGNhc2UgSSBiZWxpZXZl
IHRoZSB2aXJ0IGluc3RhbmNlcyBkbyBoYXZlDQo+IHRoZSAndmlydHVhbCBtYWNoaW5lJyBmbGFn
IHNldCBpbiBiaXQgNCBvZiB0aGUgQklPUyBDaGFyYWN0ZXJpc3RpY3MNCj4gRXh0ZW5zaW9uIEJ5
dGUgMiwgYW5kIHRoZSBiYXJlIG1ldGFsIG9idmlvdXNseSBkb24ndC4NCj4gDQoNCkFyZSB0aG9z
ZSB2aXJ0dWFsIGluc3RhbmNlcyBoYXZpbmcgQ1BVSUQgaHlwZXJ2aXNvciBiaXQgc2V0PyBJZiB5
ZXMsDQp0aGV5IGNhbiBiZSBkaWZmZXJlbnRpYXRlZCBmcm9tIGJhcmUgbWV0YWwgaW5zdGFuY2Vz
IHcvbyBjaGVja2luZw0KdGhlIHZlbmRvciBsaXN0Lg0KDQpidHcgZG8geW91IGtub3cgd2hldGhl
ciB0aGlzICd2aXJ0dWFsIG1hY2hpbmUnIGZsYWcgaXMgd2lkZWx5IHVzZWQNCmluIHZpcnR1YWxp
emF0aW9uIGVudmlyb25tZW50cz8gSWYgeWVzLCB3ZSBwcm9iYWJseSBzaG91bGQgYWRkIGNoZWNr
DQpvbiB0aGlzIGZsYWcgZXZlbiBiZWZvcmUgY2hlY2tpbmcgRE1JX1NZU19WRU5ET1IuIEl0IHNv
dW5kcyBtb3JlDQpnZW5lcmFsLi4uDQoNClRoYW5rcw0KS2V2aW4NCg0K

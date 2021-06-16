Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654573A9338
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 08:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhFPGz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 02:55:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:29658 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231446AbhFPGz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 02:55:27 -0400
IronPort-SDR: A0QcTosRc04mKmajxHP/n3s2G1mdSHtabdXX5k7OkbsUS3knmEZ15puAQvfvDBv9WMfoYMKg3A
 9+05mH9v9uAA==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="193245843"
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="scan'208";a="193245843"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 23:53:18 -0700
IronPort-SDR: kohHek4BdtsWkA8IEd5RB3/0PVLZ0fxjdsVmJyPDe+z+AjK5NPvXCgXDMDxhvUUig0WKMwMZAK
 vvDERKTCkVDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="scan'208";a="450531202"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga008.jf.intel.com with ESMTP; 15 Jun 2021 23:53:18 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 15 Jun 2021 23:53:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 15 Jun 2021 23:53:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 15 Jun 2021 23:53:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpCw5x6Ovf2biH8+dPzgFUFMzZJF8XMkFpk4sWiCzmXky53fOH2+/zUH3w3bYq4x9a3KGs0FI346hF9ex9vyQMS3Vkz5HKiQqSYN5W+rWYx75vhY+mUVxrU3bKXw7Lk25HE+jkrHlHP8wmobQVwLnAj6YPy0ysa2BEMw+3VJY0tIw3Ok4Klor+uTi5A+xJjegsZGtSNe0Ly8ZiOScSV1O4iwtFZMotsGiH9en8q34a+10jJdva4R20UYexLH01ocOyFMEoyVCCG8DfdCwoRoKFZJL6+xigi+aP+BzbP4btUSrRpUMw4T36033O7fVZ72JjtDQT/NiUxt3sE5Npg5Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQEXL4u4fZULH0ZCMujUhaUWfWI6DWu1c58Be29vfBM=;
 b=AR4Tz3P5ud0ybdhcdbyRMOmGgxrA6yaTScLJJV8V6OLtEpl+Rw26T2T/eswURNeKT1cZyKEOSN6851neZMDNgkZmGc4WAhLdcJq1y5LVpqjlO2+5z/ELULRynSX+3aaqywHQtBgPpaJSaAbvV3koLCWD7HbPgA53qIufITQAMQfX52okBRbqVloATMzaHvbNVSHdMWekdIXMKYErPMB4rKKrA9X2h7oiaVE4KsCCnCs2z/GMHw/KYT+IUHc5KsfvaFaM+xGrv552IsCwthlUECFlSp1outCNZda5jvUMlDqhkxwxBkqD6E1WDC1Var8LqbEdPCk0bMn855s1hoeJOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQEXL4u4fZULH0ZCMujUhaUWfWI6DWu1c58Be29vfBM=;
 b=EbL1qINMcPXg6l/NgXWhXX1xpGQRlB38tn0PPx0L7qls6CtTWGw308fnBMPGkjhGFckC3UVG9dNCBpgdHow2W4ZrtjxEyYUhoM6DiiqsoBFT6luoCTIRD6CrtzTrIQ+KEUmQzNkANj23bsoeZ5YyTAPM/D3c6+4PgNx3TjYbexA=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Wed, 16 Jun
 2021 06:53:16 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4219.026; Wed, 16 Jun
 2021 06:53:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shenming Lu <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAAR+AnQACzmaQAAbNgBMAAZP6eAABgIaTAAISnFgAAc52cQ
Date:   Wed, 16 Jun 2021 06:53:16 +0000
Message-ID: <MWHPR11MB18864A728DC40F109EE9FF508C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <YMDC8tOMvw4FtSek@8bytes.org>
        <20210609150009.GE1002214@nvidia.com>   <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
        <20210611153850.7c402f0b.alex.williamson@redhat.com>
        <MWHPR11MB1886C2A0A8AA3000EBD5F8E18C319@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210614133819.GH1002214@nvidia.com>
        <MWHPR11MB1886A6B3AC4AD249405E5B178C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615105601.4d7b8906.alex.williamson@redhat.com>
In-Reply-To: <20210615105601.4d7b8906.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.71.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bc2ff1f-52c2-4be6-fd72-08d930936b47
x-ms-traffictypediagnostic: MW3PR11MB4587:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB458757ECBF386F1500B58DD48C0F9@MW3PR11MB4587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lz3UE5dq9Tbgbq/uobl0nNJOVqzTJnxD+ZvFoBKTjWWyxnyEbAgsRo+u1vIpSJKHzb2DT4IDizsQST9NmHqhQDsu4MwjJlZiEOEL9qbkYwRfrvr8AaMItgeBuqbUQuUDvXf4CoXfsxaUqtFhpn9BDa55drQv8AoPCykxh1Nl86t4lsmln7M2V46GWFTNNBRCjWmFXOXCFSkh7NEomhX9VgVDCYInXajiVMawIvVNuFA3e5dl9QbYbwDiRWH9HHRkz2BYCN2yOUp8Go5UA6fSZYWicV9vgFun0TYgp2xNbwE5YOaGLkNSkiGu5HNQNPWqRAiUS+PoxFd3EI+5+o2vzt5b5LywIq2PGaZ7XB9XZgJPSCq2AlEVXGM70ll3uyibo4xzps+BmfeBnzLV7V0OcoUKh94lJhli77G30Ljo8IXAYFnSoURp3+A8z8aHNGFXyxqXsK2CXIo6Ue1uOlI+BVqM0kTm0+PEjQMGzupRnEsaPUBfAc6CAU25DaY+du40B6ovkTWGVd4ZwtI7O3spyudKCGbxMGK080ZCstF7ejz7Z3CKekEPYDWTawdEtyoU756nDOSNroZtgaffAaNyP2R6v+BYfEBVjKAkm/UcUPc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(376002)(346002)(8936002)(83380400001)(71200400001)(33656002)(6916009)(52536014)(5660300002)(478600001)(7696005)(122000001)(9686003)(38100700002)(7416002)(66946007)(186003)(2906002)(55016002)(86362001)(54906003)(76116006)(66476007)(316002)(6506007)(8676002)(66446008)(4326008)(64756008)(66556008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0JLSCtjM1d2YUJPWnZDSkFQRVBWRXlTSEQ0djBlNkZocDBNNkM4dDZjMDFu?=
 =?utf-8?B?R1o1WHdIbTV6eWVqWEU4U1B5WEVlWXA5WnB2enJTMzA0L2hGV05ZZUNVcU8r?=
 =?utf-8?B?dC9oRFdCMEYxWllYdXp2V0IyWkZsOFVGcFF2dU8raUhrSkhrRFpodHlXZDZ5?=
 =?utf-8?B?YXVYQkhZVVdPQ2RGOGZRYlI0UmpjdVBBYWczS0FnOFRhckxCTXRhaDhmaEJL?=
 =?utf-8?B?K29aWFFHUGxVWFFxbnJHZmdJRkR2cEVPMUpUYUc0MjFhMERMVFZ5Wmc1eEt4?=
 =?utf-8?B?MzFVcVVXOU5FbCtaa0lKVFYxRXBvUUVRekk3MWladlo4TEluR0c0WFBBTlpj?=
 =?utf-8?B?dnF4c09MN09zL3FmbktkM3p6WnZybTRXbVpYeGZWYWtBdU5Ib29VZ2xVcElS?=
 =?utf-8?B?TGhJeTFMQ2xHTkV4NEVjRzBZZndTNHBUZnNrNDdPK05tM2dkOWw3RlVnK0lM?=
 =?utf-8?B?RFo2OU1qRXVuRTUxOGc1L0c1N3Q0WjhITnhFVW1XSGhZSVg5M0dTeDRiWm1W?=
 =?utf-8?B?anYxUzZzVUxGYXNHd3hKZnRDWE5YdFZXUmkvOUVuWHI2ZGdMNmlwQ2JWaHo4?=
 =?utf-8?B?WnFvd2dJUFRWYW03K0xKa3RMSW5VNm0rbGtBdlUwbzVGc0JhOG0wRjM3b3Mw?=
 =?utf-8?B?U3RFcUhpMThpRlBucTV6Z2d5N3JHakFMeTN4RXVCT0RzMXcvYVVVUHIxVmh4?=
 =?utf-8?B?UXEwb3hyZlZkY1JkOHQyM3lwMTA5RFZoSGVRU3NLWVQzQTZ6WDA2bW5lamh4?=
 =?utf-8?B?Q2xHaGNndHB0RXRyKzJCblZiNGpySUlIV2VxOUloZ0ZlelgzRS80bHI0bUFh?=
 =?utf-8?B?bkZZN0xwSituNjdrVUlwUm9tcmZlRDRneEdLZUtYMy9Ob2tDVjgzZGFhSEZ2?=
 =?utf-8?B?RzJQdllYc3ZSQksvUmxqbW9Lb2hPRmh1cStlL2FaeTJZYXBiRllYdjBrMXlF?=
 =?utf-8?B?R21rbjFCYXJkVnBnQUNMTnlXYmZOdHpXWTlNODd6b0lqTU9BekV3dGdpR0hk?=
 =?utf-8?B?NDlwZ2NQK2xXdS9uTmpPa0Z6RnRoRERXUW9BaTYzeFRIcnIyak1odGtWb3lU?=
 =?utf-8?B?Vk8xUWtQRnFsNzRzYmx4MFRCekNKZ2F4SWxNbHlFZmd3bDhoanV2aWRVN0E1?=
 =?utf-8?B?L3RpRUI2SjhTY2Jwa0k4QXFGNlp6djc1LzhrOGtKR0xYRFc2dXEyZjdjRkxs?=
 =?utf-8?B?UTBOckRZc1ZXcXZkUHAxQ3h5YzNleHhIYmFpTkpJZDVSeFllcVVjQUdqdkxm?=
 =?utf-8?B?Rm1lV21VVGg4S056ZTFLZG5hc2Q2NUJYTTlQWlh1cXpGUnFrUTFReFlVeUdm?=
 =?utf-8?B?ZDJHbkUyMGVNemptcjhvQzFEcmRuaU11OTM0QTBwcHdDdWxjVkd3QU8yRUp0?=
 =?utf-8?B?ZlJoYjBFSlVoUHpkUUlpbEJtclc2c0U2d282Qm9qaVgwTVM1a01vbXRpUUY0?=
 =?utf-8?B?dnptSTZiWDBmaVlUTzlYVG8yNU1MVlA0Q2hoOTNvalVsOFUrczZmQjgxaTBZ?=
 =?utf-8?B?WTJXczBHNFpJWWxxOCt4TTRHbW5FQmh2b1Nod2g0K1dzMzNEcTBmeXV2STQ1?=
 =?utf-8?B?RGRYdy9FL0t5ZVNzeWNCU2R1dW90SGdvYUc1dEdWVlU5ajNMNndERDE5RmxU?=
 =?utf-8?B?MkpnT3drZ1puU2xwUVg3TXdXZ2MzTjB3YWFIRy9XcW9GaldCWVI0bU5sY2hs?=
 =?utf-8?B?NnBvTm9xUlZSaEJVSndzMTFtblErRGRyTlc0Tllmald5N3gxYi9DWHdBNXNN?=
 =?utf-8?Q?n9NWikDhti5ls3JnZ9LbUMZzmHNuMTba/u4Ci7J?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc2ff1f-52c2-4be6-fd72-08d930936b47
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 06:53:16.5832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: raj25z1o5RvSHEHfe10i7HzxxeXhaxhOpsDTNSBrxlqP3eUhHdRiD5F//7Ek8H3RFS2zK26FBG1JYkKki5vwXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIEp1bmUgMTYsIDIwMjEgMTI6NTYgQU0NCj4gDQo+IE9uIFR1ZSwgMTUg
SnVuIDIwMjEgMDE6MjE6MzUgKzAwMDANCj4gIlRpYW4sIEtldmluIiA8a2V2aW4udGlhbkBpbnRl
bC5jb20+IHdyb3RlOg0KPiANCj4gPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRp
YS5jb20+DQo+ID4gPiBTZW50OiBNb25kYXksIEp1bmUgMTQsIDIwMjEgOTozOCBQTQ0KPiA+ID4N
Cj4gPiA+IE9uIE1vbiwgSnVuIDE0LCAyMDIxIGF0IDAzOjA5OjMxQU0gKzAwMDAsIFRpYW4sIEtl
dmluIHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gSWYgYSBkZXZpY2UgY2FuIGJlIGFsd2F5cyBibG9j
a2VkIGZyb20gYWNjZXNzaW5nIG1lbW9yeSBpbiB0aGUgSU9NTVUNCj4gPiA+ID4gYmVmb3JlIGl0
J3MgYm91bmQgdG8gYSBkcml2ZXIgb3IgbW9yZSBzcGVjaWZpY2FsbHkgYmVmb3JlIHRoZSBkcml2
ZXINCj4gPiA+ID4gbW92ZXMgaXQgdG8gYSBuZXcgc2VjdXJpdHkgY29udGV4dCwgdGhlbiB0aGVy
ZSBpcyBubyBuZWVkIGZvciBWRklPDQo+ID4gPiA+IHRvIHRyYWNrIHdoZXRoZXIgSU9BU0lEZmQg
aGFzIHRha2VuIG92ZXIgb3duZXJzaGlwIG9mIHRoZSBETUENCj4gPiA+ID4gY29udGV4dCBmb3Ig
YWxsIGRldmljZXMgd2l0aGluIGEgZ3JvdXAuDQo+ID4gPg0KPiA+ID4gSSd2ZSBiZWVuIGFzc3Vt
aW5nIHdlJ2QgZG8gc29tZXRoaW5nIGxpa2UgdGhpcywgd2hlcmUgd2hlbiBhIGRldmljZSBpcw0K
PiA+ID4gZmlyc3QgdHVybmVkIGludG8gYSBWRklPIGl0IHRlbGxzIHRoZSBJT01NVSBsYXllciB0
aGF0IHRoaXMgZGV2aWNlDQo+ID4gPiBzaG91bGQgYmUgRE1BIGJsb2NrZWQgdW5sZXNzIGFuIElP
QVNJRCBpcyBhdHRhY2hlZCB0bw0KPiA+ID4gaXQuIERpc2Nvbm5lY3RpbmcgYW4gSU9BU0lEIHJl
dHVybnMgaXQgdG8gYmxvY2tlZC4NCj4gPg0KPiA+IE9yIGp1c3QgbWFrZSBzdXJlIGEgZGV2aWNl
IGlzIGluIGJsb2NrLURNQSB3aGVuIGl0J3MgdW5ib3VuZCBmcm9tIGENCj4gPiBkcml2ZXIgb3Ig
YSBzZWN1cml0eSBjb250ZXh0LiBUaGVuIG5vIG5lZWQgdG8gZXhwbGljaXRseSB0ZWxsIElPTU1V
IGxheWVyDQo+ID4gdG8gZG8gc28gd2hlbiBpdCdzIGJvdW5kIHRvIGEgbmV3IGRyaXZlci4NCj4g
Pg0KPiA+IEN1cnJlbnRseSB0aGUgZGVmYXVsdCBkb21haW4gdHlwZSBhcHBsaWVzIGV2ZW4gd2hl
biBhIGRldmljZSBpcyBub3QNCj4gPiBib3VuZC4gVGhpcyBpbXBsaWVzIHRoYXQgaWYgaW9tbXU9
cGFzc3Rocm91Z2ggYSBkZXZpY2UgaXMgYWx3YXlzDQo+ID4gYWxsb3dlZCB0byBhY2Nlc3MgYXJi
aXRyYXJ5IHN5c3RlbSBtZW1vcnkgd2l0aCBvciB3aXRob3V0IGEgZHJpdmVyLg0KPiA+IEkgZmVl
bCB0aGUgY3VycmVudCBkb21haW4gdHlwZSAoaWRlbnRpdHksIGRtYSwgdW5tYW5nZWQpIHNob3Vs
ZCBhcHBseQ0KPiA+IG9ubHkgd2hlbiBhIGRyaXZlciBpcyBsb2FkZWQuLi4NCj4gDQo+IE5vdGUg
dGhhdCB2ZmlvIGRvZXMgbm90IGN1cnJlbnRseSByZXF1aXJlIGFsbCBkZXZpY2VzIGluIHRoZSBn
cm91cCB0bw0KPiBiZSBib3VuZCB0byBkcml2ZXJzLiAgT3RoZXIgZGV2aWNlcyB3aXRoaW4gdGhl
IGdyb3VwLCB0aG9zZSBib3VuZCB0bw0KPiB2ZmlvIGRyaXZlcnMsIGNhbiBiZSB1c2VkIGluIHRo
aXMgY29uZmlndXJhdGlvbi4gIFRoaXMgaXMgbm90DQo+IG5lY2Vzc2FyaWx5IHJlY29tbWVuZGVk
IHRob3VnaCBhcyBhIG5vbi12ZmlvLCBub24tc3R1YiBkcml2ZXIgYmluZGluZw0KPiB0byBvbmUg
b2YgdGhvc2UgZGV2aWNlcyBjYW4gdHJpZ2dlciBhIEJVR19PTi4NCg0KVGhpcyBpcyBhIGdvb2Qg
bGVhcm5pbmcgdGhhdCBJIGRpZG4ndCByZWFsaXplIGJlZm9yZS4g8J+Yig0KDQpBcyBleHBsYWlu
ZWQgaW4gcHJldmlvdXMgbWFpbCwgd2UgbmVlZCByZXVzZSB0aGUgZ3JvdXBfdmlhYmxlIG1lY2hh
bmlzbQ0KdG8gdHJpZ2dlciBCVUdfT04uDQoNCj4gDQo+ID4gPiA+IElmIHRoaXMgd29ya3MgSSBk
aWRuJ3Qgc2VlIHRoZSBuZWVkIGZvciB2ZmlvIHRvIGtlZXAgdGhlIHNlcXVlbmNlLg0KPiA+ID4g
PiBWRklPIHN0aWxsIGtlZXBzIGdyb3VwIGZkIHRvIGNsYWltIG93bmVyc2hpcCBvZiBhbGwgZGV2
aWNlcyBpbiBhDQo+ID4gPiA+IGdyb3VwLg0KPiA+ID4NCj4gPiA+IEFzIEFsZXggc2F5cyB5b3Ug
c3RpbGwgaGF2ZSB0byBkZWFsIHdpdGggdGhlIHByb2JsZW0gdGhhdCBkZXZpY2UgQSBpbg0KPiA+
ID4gYSBncm91cCBjYW4gZ2FpbiBjb250cm9sIG9mIGRldmljZSBCIGluIHRoZSBzYW1lIGdyb3Vw
Lg0KPiA+DQo+ID4gVGhlcmUgaXMgbm8gaXNvbGF0aW9uIGluIHRoZSBncm91cCB0aGVuIGhvdyBj
b3VsZCB2ZmlvIHByZXZlbnQgZGV2aWNlDQo+ID4gQSBmcm9tIGdhaW5pbmcgY29udHJvbCBvZiBk
ZXZpY2UgQj8gZm9yIGV4YW1wbGUgd2hlbiBib3RoIGFyZSBhdHRhY2hlZA0KPiA+IHRvIHRoZSBz
YW1lIEdQQSBhZGRyZXNzIHNwYWNlIHdpdGggZGV2aWNlIE1NSU8gYmFyIGluY2x1ZGVkLCBkZXZB
DQo+ID4gY2FuIGRvIHAycCB0byBkZXZCLiBJdCdzIGFsbCB1c2VyJ3MgcG9saWN5IGhvdyB0byBk
ZWFsIHdpdGggZGV2aWNlcyB3aXRoaW4NCj4gPiB0aGUgZ3JvdXAuDQo+IA0KPiBUaGUgbGF0dGVy
IGlzIHVzZXIgcG9saWN5LCB5ZXMsIGJ1dCBpdCdzIGEgc3lzdGVtIHNlY3VyaXR5IGlzc3VlIHRo
YXQNCj4gdGhlIHVzZXIgY2Fubm90IHVzZSBkZXZpY2UgQSB0byBjb250cm9sIGRldmljZSBCIGlm
IHRoZSB1c2VyIGRvZXNuJ3QNCj4gaGF2ZSBhY2Nlc3MgdG8gYm90aCBkZXZpY2VzLCBpZS4gZG9l
c24ndCBvd24gdGhlIGdyb3VwLiAgdmZpbyB3b3VsZA0KPiBwcmV2ZW50IHRoaXMgYnkgbm90IGFs
bG93aW5nIGFjY2VzcyB0byBkZXZpY2UgQSB3aGlsZSBkZXZpY2UgQiBpcw0KPiBpbnNlY3VyZSBh
bmQgd291bGQgcmVxdWlyZSB0aGF0IGFsbCBkZXZpY2VzIHdpdGhpbiB0aGUgZ3JvdXAgcmVtYWlu
IGluDQo+IGEgc2VjdXJlLCB1c2VyIG93bmVkIHN0YXRlIGZvciB0aGUgZXh0ZW50IG9mIGFjY2Vz
cyB0byBkZXZpY2UgQS4NCj4gDQo+ID4gPiBUaGlzIG1lYW5zIGRldmljZSBBIGFuZCBCIGNhbiBu
b3QgYmUgdXNlZCBmcm9tIHRvIHR3byBkaWZmZXJlbnQNCj4gPiA+IHNlY3VyaXR5IGNvbnRleHRz
Lg0KPiA+DQo+ID4gSXQgZGVwZW5kcyBvbiBob3cgdGhlIHNlY3VyaXR5IGNvbnRleHQgaXMgZGVm
aW5lZC4gRnJvbSBpb21tdSBsYXllcg0KPiA+IHAuby52LCBhbiBJT0FTSUQgaXMgYSBzZWN1cml0
eSBjb250ZXh0IHdoaWNoIGlzb2xhdGVzIGEgZGV2aWNlIGZyb20NCj4gPiB0aGUgcmVzdCBvZiB0
aGUgc3lzdGVtIChidXQgbm90IHRoZSBzaWJsaW5nIGluIHRoZSBzYW1lIGdyb3VwKS4gQXMgeW91
DQo+ID4gc3VnZ2VzdGVkIGVhcmxpZXIsIGl0J3MgY29tcGxldGVseSBzYW5lIGlmIGFuIHVzZXIg
d2FudHMgdG8gYXR0YWNoDQo+ID4gZGV2aWNlcyBpbiBhIGdyb3VwIHRvIGRpZmZlcmVudCBJT0FT
SURzLiBIZXJlIEkganVzdCB0YWxrIGFib3V0IHRoaXMgZmFjdC4NCj4gDQo+IFRoaXMgaXMgc2Fu
ZSwgeWVzLCBidXQgdGhhdCBkb2Vzbid0IGdpdmUgdXMgbGljZW5zZSB0byBhbGxvdyB0aGUgdXNl
cg0KPiB0byBhY2Nlc3MgZGV2aWNlIEEgcmVnYXJkbGVzcyBvZiB0aGUgc3RhdGUgb2YgZGV2aWNl
IEIuDQo+IA0KPiA+ID4NCj4gPiA+IElmIHRoZSAvZGV2L2lvbW11IEZEIGlzIHRoZSBzZWN1cml0
eSBjb250ZXh0IHRoZW4gdGhlIHRyYWNraW5nIGlzDQo+ID4gPiBuZWVkZWQgdGhlcmUuDQo+ID4g
Pg0KPiA+DQo+ID4gQXMgSSByZXBsaWVkIHRvIEFsZXgsIG15IHBvaW50IGlzIHRoYXQgVkZJTyBk
b2Vzbid0IG5lZWQgdG8ga25vdyB0aGUNCj4gPiBhdHRhY2hpbmcgc3RhdHVzIG9mIGVhY2ggZGV2
aWNlIGluIGEgZ3JvdXAgYmVmb3JlIGl0IGNhbiBhbGxvdyB1c2VyIHRvDQo+ID4gYWNjZXNzIGEg
ZGV2aWNlLiBBcyBsb25nIGFzIGEgZGV2aWNlIGluIGEgZ3JvdXAgZWl0aGVyIGluIGJsb2NrIERN
QQ0KPiA+IG9yIHN3aXRjaCB0byBhIG5ldyBhZGRyZXNzIHNwYWNlIGNyZWF0ZWQgdmlhIC9kZXYv
aW9tbXUgRkQsIHRoZXJlJ3MNCj4gPiBubyBwcm9ibGVtIHRvIGFsbG93IHVzZXIgYWNjZXNzaW5n
IGl0LiBVc2VyIGNhbm5vdCBkbyBoYXJtIHRvIHRoZQ0KPiA+IHdvcmxkIG91dHNpZGUgb2YgdGhl
IGdyb3VwLiBVc2VyIGtub3dzIHRoZXJlIGlzIG5vIGlzb2xhdGlvbiB3aXRoaW4NCj4gPiB0aGUg
Z3JvdXAuIHRoYXQgaXMgaXQuDQo+IA0KPiBUaGlzIGlzIHNlbGYgY29udHJhZGljdG9yeSwgInZm
aW8gZG9lc24ndCBuZWVkIHRvIGtub3cgdGhlIGF0dGFjaG1lbnQNCj4gc3RhdHVzIi4uLiAiW2Fd
cyBsb25nIGFzIGEgZGV2aWNlIGluIGEgZ3JvdXAgZWl0aGVyIGluIGJsb2NrIERNQSBvcg0KPiBz
d2l0Y2ggdG8gYSBuZXcgYWRkcmVzcyBzcGFjZSIuICBTbyB2ZmlvIGRvZXMgbmVlZCB0byBrbm93
IHRoZSBsYXR0ZXIuDQo+IEhvdyBkb2VzIGl0IGtub3cgdGhhdD8gIFRoYW5rcywNCj4gDQoNCk15
IHBvaW50IHdhcyB0aGF0LCBpZiBhIGRldmljZSBjYW4gb25seSBiZSBpbiB0d28gc3RhdGVzOiBi
bG9jay1ETUEgb3IgDQphdHRhY2hlZCB0byBhIG5ldyBhZGRyZXNzIHNwYWNlLCB3aGljaCBib3Ro
IGFyZSBzZWN1cmUsIHRoZW4gdmZpbyANCmRvZXNuJ3QgbmVlZCB0byB0cmFjayB3aGljaCBzdGF0
ZSBhIGRldmljZSBpcyBhY3R1YWxseSBpbi4NCg0KVGhhbmtzDQpLZXZpbg0K

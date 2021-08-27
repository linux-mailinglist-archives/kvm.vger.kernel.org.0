Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620B23F9235
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 04:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbhH0CIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 22:08:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:6768 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243918AbhH0CIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 22:08:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="197445818"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="197445818"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 19:07:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="426983057"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 26 Aug 2021 19:07:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 19:07:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 19:07:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 26 Aug 2021 19:07:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 26 Aug 2021 19:07:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNlH1Q2bjSfSr+i8v7JMNwsUruPzGlSHwEOY/Qf1WfOmeORXLSfZ49P/UMF1dKEhM4S1kb7hN9PhhZCbrB3eJXxtNNML1CQb7K09c/llUmq2LXIolrdwmLu54AIbXiwTZ/jAX9Ri0dbuvsxmHkLEIadsR6hufz/tYo+1eIocpPMTvIpIMpSHijpH2gQJejSzqoIw2P3xe7bnqMZ2W0wY/veVN1R5sLWB96vvoRjlT6SB4iSmO0kfmsPjmpglMMSGFaLs5loXUTVdVbxEXq2HLPJGG0s0IzUar7rUtALa29nRCyuPX49vrNU5Pz4HaxOam8mPpvG2teWMsrJA7rRCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWCOHLamtbBOzhfUMJTGuzsylHJoR0CVPhCuhvRSmG0=;
 b=OUho8akWgbT5N8bl+Y7oTfZjeDzy0kotk+RLPgW3C84cbQUEGz1zzQmYKukE78RepzGlMu3GH/12xTGFGnSzTZozdEjeXOVI/EyLmlz3nF+MiZR4L3jzguoZayvGww45eeXIkvjMN+tZ8hwqbTewM9RXKHuA7yCIWgcApPw13sngknKrykzEjpbEoWEUtVYTXxjm+On2LhzQ48H0CMEnacjjOgqIWmcqljsAQXpbOSVGldpNNM433XMOhptM7inyqcmGqDws8ryC9Rvkv/42sNWHlUEWArnPK8D3A+75tbc0B85AKNZkKFvZGz6eJ5MIU3j3wasj60wNVb80u+6u6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWCOHLamtbBOzhfUMJTGuzsylHJoR0CVPhCuhvRSmG0=;
 b=uTwLWhUpbIRszFuMAf482CWJ7c4dn1afbjsIPKDgQ0TydI9UyW/qC7DtXMzPeW7gp8ZuxXZLBo5hXj0LX5lx/gzG48m2kzxrGfyBdEhemEHDF514amtLo+AKcTy4M285Dnq0HrU8fJY+R4wPcaR6+/Y9nRN8lEwX/N0Zxl855G0=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5757.namprd11.prod.outlook.com (2603:10b6:408:165::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18; Fri, 27 Aug
 2021 02:07:44 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%7]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 02:07:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Thread-Topic: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Thread-Index: AQHXmn//8kQMQ2y/aUiCCg4Fh+pLSauGM0mAgAA99QCAAClg4A==
Date:   Fri, 27 Aug 2021 02:07:43 +0000
Message-ID: <BN9PR11MB54337718010D68E1F9FE60458CC89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210826133424.3362-1-hch@lst.de>
 <20210826133424.3362-5-hch@lst.de>
 <20210826135413.239e6d4e.alex.williamson@redhat.com>
 <20210826233558.GT1721383@nvidia.com>
In-Reply-To: <20210826233558.GT1721383@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1385b420-6b0a-4ad0-4964-08d968ff751b
x-ms-traffictypediagnostic: BN0PR11MB5757:
x-microsoft-antispam-prvs: <BN0PR11MB57570AC8D1EE0F08A0F3352C8CC89@BN0PR11MB5757.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YZbQbBrb3C4pt+P+OohubCc/mQkEL+z2idsGPogl1pG0TAyhTz5Qd/6ZA2XzquSkzZlqiEwoDxuAprUbwuGx9mjz5Ym3ZHyTtGQnxL1LfXIFiOnU8cnRgBfRnn9RbPKL7nxOFwjaQFK+Nlv+VqA2eijC6/d8JzyQbzveo2uPr8gkNFfjf/OXDelHf3fbYkm2HXMQFd+4puqn6PhfdkIiXQeVGY6oRstttfbtMdH23Z1wPTrMZG1ljFTBtk/p8mbM540kKx4DkbD1nIUnYIlBP8C+qZzUF/IrPDErJopp52DI9SXm2X2MboEvLO4QVGeJ5JYV6gE7FvDvSJ8bVB7/CS/GHVG/RwC51JPkLgWN7KRw1ZKget9xDdiEf1AqfqGziBCjdvOvw6dZE3+4nzz8pei18GPGlKbVw5afGikdYE000yHMn1Bsfzndnxxvnph/60LoFdt1mJx3IFVkHjsv6otk8ltJf+a5644M47DsdFfmSE30IeMAOiZtvG1n3huwHg+fl6h72q3d07/Zv3h+K9PXmIrWMJfVo6zpYbXJE8TNx8AQyUPdGQ/BtM3O6jjONa0X4sL1H6ndE8Vmtr43qK4QXAjNfTYN1OfHGheJ7si3J49ecXtErGUsTnHet6tSrxrxbteuLT3WQxVpAjHJI37whMFTL3pSukiFmusdYMICEFB5CKZvZtw83GU2u077LCj04iE1nG6Dk30N2OxTyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(26005)(55016002)(186003)(9686003)(86362001)(122000001)(83380400001)(508600001)(38100700002)(6506007)(71200400001)(64756008)(76116006)(8676002)(110136005)(316002)(54906003)(66556008)(38070700005)(52536014)(2906002)(8936002)(7696005)(4326008)(66446008)(66476007)(5660300002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjYzQ0JHTjFFNWF0TVFkdWxhNVVCcFcvMnMzencvTkRNckFZVnBiSVJVNzB0?=
 =?utf-8?B?c3NvV2pSbzZ2ZzBDQnRlUTBBeDA5bVl4dW5GZlBNU1M3RkQzcE1rWjNyTEU1?=
 =?utf-8?B?TUYrekhUNy8rNmthMEw3UkpORFkra3lwaWZFcXFoaGd0NUV6WHF2d3kvcEh4?=
 =?utf-8?B?VThMbWdkYWFYTVkwb044U1RIdWhqM0I5Y2ZsdHUzZU5Cb09UZHUrY2d0SE5v?=
 =?utf-8?B?VkFxTnVFVS9lNlFKNWl0ZWtoeEtQUTkxMENDUXZ2b0Rkdk5raFJwMnREckNU?=
 =?utf-8?B?TFE5UVdHQUp6TTdhKzNyai9RdEthemoxZWJ6aUxDOStia3cvM1h2YVM0Rk0v?=
 =?utf-8?B?WlgyVk14eFVYbHhlblpGVnhkcFlmc3h4cmtFQkpQWDdqVHpJSWVRb2kvZGh4?=
 =?utf-8?B?YnhQQllCeTc0bU1xdUoreXh5QSszVmhaZm9TVUlTMEZZUmhGcUFlcGs0eURS?=
 =?utf-8?B?anpLc2VvTUFwV2VCVW5XQ0dScWsxQlJOdVJSdC9BQnBQSzlYbHpnMm9CdHpi?=
 =?utf-8?B?clJKNUVSZ09PTzVEQ3o1SzNIbTQwTkZBbmFvSGUxVVNGQ2h1TEhhWVlKckI3?=
 =?utf-8?B?S1k3SElhOWovTnppcEUyTDBhUFh6Q3ZGTDRSMlBLbEhUcUllUmFKWlNXMytP?=
 =?utf-8?B?NHEyWEJnZHNuQmRBREZHRXY4a3ZMVkJBV1QxMFF5MXhUNUVVM051WUgvRmFW?=
 =?utf-8?B?R214YzlMNktaRlNPb2MzWkxBTEJCdlVidnpuNjBkWk9GZ21CSmNtdkoxZmRO?=
 =?utf-8?B?eU5iekJxSlMrNnVsTVIvbU13Ujdkelh0TExBTmM3by9XbWFpZEpXMFQxdDBP?=
 =?utf-8?B?STNmeHZMVlVjTFQzb0xPeWl6ZG5zL0gwNE56WmdNQlV6bEZkeE1oem1XL2RH?=
 =?utf-8?B?UjJiZUNyNjBFVlduR2ZDY0pyaGFSS0YvS1dFU0RYUlp5NlFFK01WR2JpbWM4?=
 =?utf-8?B?bDBHNzFOWWp2RE5RSmNRSlI3Q1FXdlhkQWlRUEpvTXZXVnVaK0doajA1K3hB?=
 =?utf-8?B?b2M0UW11ZlpCTjRtQzJVWUZPSHVVcXczSld3bEY1emxQZnJUVVg0bkZxSnVX?=
 =?utf-8?B?N24yQ1V5a3FRd3VDSEM2SjAzMkozb3hncjJZSW95Qm02cFBINlFYNklpSHRQ?=
 =?utf-8?B?c1NIc0ViMHE3VG4zYVpFUkVYYTI1VFhaWGpsSmpkRytXZG1EYkNaVGRlaE9j?=
 =?utf-8?B?MDhqZklaalNIOENKZjJyWTNXamk3VnpHcnRLWFJXV0dGQ1U5eXJmOGN2NGNZ?=
 =?utf-8?B?a3NscnBJaWc1Y2lOanZZZmlrTlZITWpreVVIdHRTWHVWZEVxVThGNXI0NnVZ?=
 =?utf-8?B?Ry9mNHV3NnI1NkVlNnhVNmppMDNpRDhEZUZHbWhXK2xZRWI0c1paZ21LNXV2?=
 =?utf-8?B?WVlHOVF2cWZyLzhrZm9MMldsTjVBUlZpUnJBQ1JKdFhoZE11YjZReU00cGRI?=
 =?utf-8?B?ZFJRZWxIbXpteEdWS0s1UWRudkZjZHVGV3NQeWJLYnM3UnZmckQ2MStmMDBU?=
 =?utf-8?B?U2xyUDBGSkMxZHRVbnBJLzNZamlaR29JaGNDa3pYNndIVjhoU0YvL3NiUDl6?=
 =?utf-8?B?MUxDMHhGaDNQOVlGalBwZFB4bTZhV1RVd3ZRN1laZ1dJNkNwalNVODZXbktu?=
 =?utf-8?B?V0ZYdTUzK0cyYURraTFJTkVJZHA0NzV6eUQ0WGJ1QXM0UUo1Mlg0Wkt1L2RN?=
 =?utf-8?B?ZjBpQk1McGo2VEJLVTRtcGE5TEMxamQ3ZXFleUVNYkFPdU5oN0cvWndyNmcy?=
 =?utf-8?Q?cGXHDeaEpS/MSh1/l+LPDhUJv992r/tlVUn09s5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1385b420-6b0a-4ad0-4964-08d968ff751b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 02:07:43.9202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V6bN/YxaAi8zhksBDALM6ehjKgehnb9VUJAYWXDMpKGNzrsy9IlL0q13OuqUhNAd+HOBP+yewhGr87v4/cZcPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5757
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEF1Z3VzdCAyNywgMjAyMSA3OjM2IEFNDQo+IA0KPiBPbiBUaHUsIEF1ZyAyNiwgMjAyMSBhdCAw
MTo1NDoxM1BNIC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gT24gVGh1LCAyNiBB
dWcgMjAyMSAxNTozNDoxNCArMDIwMA0KPiA+IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
PiB3cm90ZToNCj4gPg0KPiA+ID4gRmFjdG9yIG91dCBhIGhlbHBlciB0byBmaW5kIG9yIGFsbG9j
YXRlIHRoZSB2ZmlvX2dyb3VwIHRvIHJlZHVjZSB0aGUNCj4gPiA+IHNwYWdldHRoaSBjb2RlIGlu
IHZmaW9fcmVnaXN0ZXJfZ3JvdXBfZGV2IGEgbGl0dGxlLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1v
ZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiA+ID4gUmV2aWV3ZWQtYnk6
IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+ID4gPiAgZHJpdmVycy92ZmlvL3Zm
aW8uYyB8IDU5ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
PiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspLCAyNSBkZWxldGlvbnMoLSkN
Cj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL3ZmaW8uYyBiL2RyaXZlcnMv
dmZpby92ZmlvLmMNCj4gPiA+IGluZGV4IDE4ZTRjNzkwNmQxYjNmLi44NTJmZTIyMTI1NTIwZCAx
MDA2NDQNCj4gPiA+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvLmMNCj4gPiA+IEBAIC04MjMsMTAg
KzgyMywzOCBAQCB2b2lkIHZmaW9fdW5pbml0X2dyb3VwX2RldihzdHJ1Y3QgdmZpb19kZXZpY2UN
Cj4gKmRldmljZSkNCj4gPiA+ICB9DQo+ID4gPiAgRVhQT1JUX1NZTUJPTF9HUEwodmZpb191bmlu
aXRfZ3JvdXBfZGV2KTsNCj4gPiA+DQo+ID4gPiArc3RydWN0IHZmaW9fZ3JvdXAgKnZmaW9fZ3Jv
dXBfZmluZF9vcl9hbGxvYyhzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ID4gPiArew0KPiA+ID4gKwlz
dHJ1Y3QgaW9tbXVfZ3JvdXAgKmlvbW11X2dyb3VwOw0KPiA+ID4gKwlzdHJ1Y3QgdmZpb19ncm91
cCAqZ3JvdXA7DQo+ID4gPiArDQo+ID4gPiArCWlvbW11X2dyb3VwID0gdmZpb19pb21tdV9ncm91
cF9nZXQoZGV2KTsNCj4gPiA+ICsJaWYgKCFpb21tdV9ncm91cCkNCj4gPiA+ICsJCXJldHVybiBF
UlJfUFRSKC1FSU5WQUwpOw0KPiA+ID4gKw0KPiA+ID4gKwkvKiBhIGZvdW5kIHZmaW9fZ3JvdXAg
YWxyZWFkeSBob2xkcyBhIHJlZmVyZW5jZSB0byB0aGUgaW9tbXVfZ3JvdXANCj4gKi8NCj4gPiA+
ICsJZ3JvdXAgPSB2ZmlvX2dyb3VwX2dldF9mcm9tX2lvbW11KGlvbW11X2dyb3VwKTsNCj4gPiA+
ICsJaWYgKGdyb3VwKQ0KPiA+ID4gKwkJZ290byBvdXRfcHV0Ow0KPiA+ID4gKw0KPiA+ID4gKwkv
KiBhIG5ld2x5IGNyZWF0ZWQgdmZpb19ncm91cCBrZWVwcyB0aGUgcmVmZXJlbmNlLiAqLw0KPiA+
ID4gKwlncm91cCA9IHZmaW9fY3JlYXRlX2dyb3VwKGlvbW11X2dyb3VwKTsNCj4gPiA+ICsJaWYg
KElTX0VSUihncm91cCkpDQo+ID4gPiArCQlnb3RvIG91dF9wdXQ7DQo+ID4gPiArCXJldHVybiBn
cm91cDsNCj4gPiA+ICsNCj4gPiA+ICtvdXRfcHV0Og0KPiA+ID4gKyNpZmRlZiBDT05GSUdfVkZJ
T19OT0lPTU1VDQo+ID4gPiArCWlmIChpb21tdV9ncm91cF9nZXRfaW9tbXVkYXRhKGlvbW11X2dy
b3VwKSA9PSAmbm9pb21tdSkNCj4gPiA+ICsJCWlvbW11X2dyb3VwX3JlbW92ZV9kZXZpY2UoZGV2
KTsNCj4gPiA+ICsjZW5kaWYNCj4gPg0KPiA+IFdoZW4gd2UgZ2V0IGhlcmUgdmlhIHRoZSBmaXJz
dCBnb3RvIGFib3ZlLCBpdCBkb2Vzbid0IG1hdGNoIHRoZSBjb2RlDQo+ID4gd2UncmUgcmVtb3Zp
bmcgYmVsb3cuDQo+IA0KPiBJZiB3ZSBhcmUgaW4gbm9pb21tdSBtb2RlIHRoZW4gdGhlIGdyb3Vw
IGlzIGEgbmV3IHNpbmdsZXRvbiBncm91cCBhbmQNCj4gdmZpb19ncm91cF9nZXRfZnJvbV9pb21t
dSgpIGNhbm5vdCBzdWNjZWVkLCBzbyB0aGUgb3V0X3B1dCBjYW5ub3QNCj4gdHJpZ2dlciBmb3Ig
dGhlIG5vaW9tbXUgcGF0aC4NCj4gDQo+IFRoaXMgaXMgYWxsIGltcHJvdmVkIGluIHBhdGNoIDYg
d2hlcmUgdGhlIGxvZ2ljIGJlY29tZXMgY2xlYXI6DQoNCnBhdGNoIDUuIPCfmIoNCg0KPiANCj4g
Kwlpb21tdV9ncm91cCA9IGlvbW11X2dyb3VwX2dldChkZXYpOw0KPiArI2lmZGVmIENPTkZJR19W
RklPX05PSU9NTVUNCj4gKwlpZiAoIWlvbW11X2dyb3VwICYmIG5vaW9tbXUgJiYgIWlvbW11X3By
ZXNlbnQoZGV2LT5idXMpKSB7DQo+ICsJCS8qDQo+ICsJCSAqIFdpdGggbm9pb21tdSBlbmFibGVk
LCBjcmVhdGUgYW4gSU9NTVUgZ3JvdXAgZm9yDQo+IGRldmljZXMgdGhhdA0KPiArCQkgKiBkb24n
dCBhbHJlYWR5IGhhdmUgb25lIGFuZCBkb24ndCBoYXZlIGFuIGlvbW11X29wcyBvbg0KPiB0aGVp
cg0KPiArCQkgKiBidXMuICBUYWludCB0aGUga2VybmVsIGJlY2F1c2Ugd2UncmUgYWJvdXQgdG8g
Z2l2ZSBhIERNQQ0KPiArCQkgKiBjYXBhYmxlIGRldmljZSB0byBhIHVzZXIgd2l0aG91dCBJT01N
VSBwcm90ZWN0aW9uLg0KPiArCQkgKi8NCj4gKwkJZ3JvdXAgPSB2ZmlvX25vaW9tbXVfZ3JvdXBf
YWxsb2MoZGV2KTsNCj4gKwkJaWYgKGdyb3VwKSB7DQo+ICsJCQlhZGRfdGFpbnQoVEFJTlRfVVNF
UiwgTE9DS0RFUF9TVElMTF9PSyk7DQo+ICsJCQlkZXZfd2FybihkZXYsICJBZGRpbmcga2VybmVs
IHRhaW50IGZvciB2ZmlvLQ0KPiBub2lvbW11IGdyb3VwIG9uIGRldmljZVxuIik7DQo+ICsJCX0N
Cj4gKwkJcmV0dXJuIGdyb3VwOw0KPiANCj4gRWcgd2UgbmV2ZXIgZG8gYSBwb2ludGxlc3MgdmZp
b19ncm91cF9nZXRfZnJvbV9pb21tdSgpIG9uIGEgbm8taW9tbXUNCj4gZ3JvdXAgaW4gdGhlIGZp
cnN0IHBsYWNlLCB3ZSBqdXN0IGNyZWF0ZSBldmVyeXRoaW5nIGRpcmVjdGx5Lg0KPiANCj4gSXQg
d291bGQgYmUgZmluZSB0byBhZGQgYW4gZXh0cmEgbGFiZWwgYW5kIHRoZW4gcmVtb3ZlIGl0IGlu
IHBhdGNoIDYsDQo+IGJ1dCBpdCBpcyBhbHNvIGZpbmUgdGhpcyB3YXkgYW5kIHByb3Blcmx5IGNs
ZWFuZWQgYnkgdGhlIGVuZC4NCj4gDQoNCmVpdGhlciB3YXkgaXMgZmluZSBhcyBubyBmdW5jdGlv
biBpcyBicm9rZW4gaW4gYmlzZWN0IHdpdGggYWJvdmUgZXhwbGFuYXRpb24uDQpidXQgbXkgc2xp
Z2h0IHByZWZlcmVuY2UgaXMgdG8gYWRkIHRoZSBsYWJlbCBhcyBpdCBkb2VzIG1ha2UgdGhpcyBw
YXRjaA0KY2xlYXJlciBmb3Igb3RoZXIgcmV2aWV3ZXJzIChvciB3aXRoIGEgc2ltcGxlIGV4cGxh
bmF0aW9uIGluIHRoZSBjb21taXQgbXNnKS4NCg0KVGhhbmtzDQpLZXZpbg0K

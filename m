Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B44930ECB8
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 07:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhBDGxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 01:53:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:40833 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhBDGxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 01:53:15 -0500
IronPort-SDR: xBblZv4RaFoGdgVGVvK43iUALt41jQ5qVUZSv4flfeo9jc1ypbwSshDTWMc/nlM5FuhYRp6NMI
 64jezfdeBrmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="242691699"
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="242691699"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 22:52:33 -0800
IronPort-SDR: eReyGFNDyL+IeyhuWdqbkgWOxhCudY5ULQK1h65yY5CSsePNRAs725WC8TeXP4WATVrbo2Sshs
 jgvHST5Nni7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="508035581"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 03 Feb 2021 22:52:32 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 22:52:31 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 22:52:31 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 3 Feb 2021 22:52:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 3 Feb 2021 22:52:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fS6qEPqeAzwpgi2K9Uu5nJY9cHrTs4TYLDk9N2mYA5DRx5DrxpfPE5W061vjd6G1PNg2VuwKbbwlFEUW2bR0WhOyVmp8Js7Q6jCkmM7rN8QRuNhnIM5nzvKJLVXBMSFXZENLBHO6LDtKWVbUza4J9He8eRnV0TrGXSb32PF2MNCqyiFX3Q5df9f2gYZfb7C9Qp2QuOnhfaawhdT+HGDvUgBRYH5kSc7ckCPoTM6PuV7AZ5ZN3prH+utt7KH5nW2XaQCLHZBCdedsfHHEmJIGnUmygyMnCBFY1eH4NlP+4EfErJlWkUCrVcJRcst/HHlc2uQ3AI8jmkpfn5+p6GFg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCOJBMMOifjuPvuWlXiv6SfVnmAN1i9G/6U0rO06HOo=;
 b=XYBX6b6OCk/XQr7Gr3Zl/q2MokibeZs0f8ocf2FpctMXur172ZRlA1ZbSBLpglRJohU/8AyO/TE6pDHrBjhux02kYAc4f8o4ed/Sw0dpnWZ1m+ytLBnBfjiZBVdfujCeMBB8h+uRx4LUc5eSxJqDTL0vpPgKwaPBEB+h7DbNlmJt71IUe1zHAzEmoRGHo2ZAINjbhh/4dCmobu26sMaEuXVZ/w0o4zBEKl0aZvROf2XGoTObopdxoXpzumel1iNnC2DEy8nqAsteRHS7fF4quZ46xHNaTzbfP5IM1Q6ADPXWs4QW6d/cvH+ZzyxN65YcnbZa2i8ZhEcqKZTW4S+vng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCOJBMMOifjuPvuWlXiv6SfVnmAN1i9G/6U0rO06HOo=;
 b=D74LPlFsUlZaEVFaNd8OnjzyzYCOU+FpdQCgH/tX56p/7bOYhEGWM29JsjiRUCZ/BS+C9QPT+SUFATy3UnNAzlDv06q83SXzjHpqf+ztrY1iTmNxsb4wwBf76pVemMpmnhDizYD+QBLVec3e8tEPaLC/NoA1CWHHQDP65J9itYc=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (10.175.54.9) by
 CO1PR11MB5010.namprd11.prod.outlook.com (20.182.136.201) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.20; Thu, 4 Feb 2021 06:52:10 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46%6]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 06:52:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shenming Lu <lushenming@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Topic: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Thread-Index: AQHW8vkytb+JKYXDyUeYG8HWtmg34ao/PksAgAOljRCAAZMegIADINTA
Date:   Thu, 4 Feb 2021 06:52:10 +0000
Message-ID: <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
 <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
In-Reply-To: <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 971421c1-3376-49af-46e0-08d8c8d9656a
x-ms-traffictypediagnostic: CO1PR11MB5010:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5010448BC6245EE9B14478C28CB39@CO1PR11MB5010.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uuik1HdsWugPW5cMOU29AZEV27JZCNR6157jOxlr6qDWKm9UMcCZhwHj3gaB2u6gmM8eSBxjgkJBKqVOFNu3WlFxqcvioLwguv7GBZULG9T+0HKA62QKbNWgvvuLp6OQUXNyLtCKXRe5BY01rsUxWuWzsRDFsK/o9LhA79GW9rX6MTEztmRvdU5Jkc4zq/OsGYdMKeZO1qYRSCx5VFYGFsvfSEM2bXDOwYgTrPhROh207a8z/yVnCGofCPnOJLIUTkp3Y3sNAmrAxja2g32lbv6uOlOjt9pja8vnJhj7W1F0HN4xM3svYavDG8LGDIW75IoI9TN0emc6PfYy9fgYrneVBzXORjKFSMnxA8XMBgsukCZ7jA5671nMetD+vOjbsZuH+MjtZwcXVl7/9elRz1Uf9/DbuvDksE/8CvRSeIHdnsTDu/0RkykjLyRWGVWZ8L0M0ZJrU0Yd+udxM0EDlzWEDRKdtVseLjribDZotBn2qq5JOgi31pA2wy7kPRfpHJ98Z+w4T3o7Jzp+Ydo9naVQ+IlJ8FNUm8vzOC4jeIJTpmNEB1eeuAoE8wUcWWhlCdIJazzxM3NgPgj2rBnVqW5bfmfYiiQ26TFsGHtS6/k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(186003)(55016002)(26005)(316002)(110136005)(966005)(53546011)(54906003)(66556008)(64756008)(5660300002)(52536014)(83380400001)(8676002)(9686003)(66946007)(86362001)(66476007)(76116006)(478600001)(33656002)(6506007)(2906002)(4326008)(71200400001)(66446008)(7696005)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZzNIb0s2T1lzOENLdDBXS1MrTG9yRmN4L3U2K1E2SWlCeVFzTlhza20zSXlw?=
 =?utf-8?B?TDlyR1ppdWRKaFE5V1F2cXNWZndHN2ptUHNlcThwMGhHWVU4bHFiNnlDZC9q?=
 =?utf-8?B?SDYyMUl1akJFZ0pmaGZTUEExek4vTHJFcmx4NzZwNDN6Q1pzTzgvY0dhYVl6?=
 =?utf-8?B?bTRCWWhmYm52ZE9rTWJaVURPVWN6aVMvRUlQaVFLVTNoTDVZdEw3cHFjQmZX?=
 =?utf-8?B?KytCRXQrNWtXaW1kNXRMb3pBK1RpQnBSSWdLZEN6Nnk0R1NKQ0tIQS9FRnk1?=
 =?utf-8?B?aC9ab1BOTmRRVm80UmJhRE5JZmRLbzBnN2N0MFhnaEVJY1FLU05GemNRSTYw?=
 =?utf-8?B?Mk96REQvSzIzOGtrUXZSUE95RjdqUlM0ZVZQUVJEOXRvb0o3b2wvcEJ6Q3Fr?=
 =?utf-8?B?Y3B1UzVMbHBxL3lDb0Z2dzFHa0owSHdQV2ZlV3d6SEpXL3poNjBUd3JScGZj?=
 =?utf-8?B?RFdBQUZsK0NGYmRNVTJkS3F2OTVsQzcrSXAvQTY0UXU2YXhwNm16eldBa25H?=
 =?utf-8?B?NUlGdjRGaVFOa1FzbWhQZFFvR21OamFmYkJxcFJ5VGlpMVpFWW1ZQitpRVBD?=
 =?utf-8?B?S2tCdVUrQzhsSDdSc05FM3lvellVVE5QT3hJbFF1WFNWWmdJWXNDRFRhUVc0?=
 =?utf-8?B?a2tOMjd3N2JlSGl0VGVwUDJsT0EwTVVTaHF1WHhFcnlDdFd3d2U4VXZEMXJi?=
 =?utf-8?B?WnhtYy83bkVQOW5Fejl0cE1ESVV6WDR5cGJtYjQyOUhSeUlDOXpBTGdPdUx0?=
 =?utf-8?B?QTVQekxPVnZTcmgyK1JIVVA4d0YzTmNoN0l6d2RMZmhaZmxpSWNILzU3cWF0?=
 =?utf-8?B?ekFXMEp3ejUyQlVHV1BKSC9oRW91ZVVsS2U3YzJ5MmxadHlHMEl3QkRPVUxo?=
 =?utf-8?B?cjA5Z2pGN0VuTk14b0IvL3NpdUJXWVNTdmIrb3lUbFJ5MkNmNnZrcFZMdFow?=
 =?utf-8?B?bjdUNXZzV1pPUitGZHczb1pHQmpZZGh1VS9GV3gzQmtQbzZodlJINEJmYmht?=
 =?utf-8?B?TjRCbG5pSlVpOTRXR3hYNVZ6a2RnZHQ3VEhEQjZzL1RWRjBPU1pYSDFsU1Rx?=
 =?utf-8?B?Nkw1Sk1kQzRhbmhqMk5wNnRidGJJdW5iRXQxSjhFM2dxMVJYanlDdmtXMWpl?=
 =?utf-8?B?NkZ2LzdpbnJnUGhCYlVZNTY0MkFIM1NtSzlVSUdDNkQ1MW9yQm9MekpzNmh6?=
 =?utf-8?B?bmRLUHhzVkxOckRWUWZaQVNiZmFYajhORDNyMThqajVSLzd4LzdVc0Qrd2Zx?=
 =?utf-8?B?MmswMU9rcFpZSW9oSnY3aTczTENSajg0ckpodzlERnU4VGttemgxcG11SHFS?=
 =?utf-8?B?Y0VZbEFjaGlwOHBJOGdRZW83ZG9CQ3kvWmxRdHVYV2RSTmFjbzMxS2ErVjA2?=
 =?utf-8?B?Z043dzFlRlViZ2VTeTZwT2xmLy9RSGFOejRVSFMveWxRWGFPaWNqNU5jTk9k?=
 =?utf-8?B?eHA3NFFDM2F5OUR1MExMZHFmcUt1SGpGNExyOHR2NWhNWWZaS1VrR3Y4QW5P?=
 =?utf-8?B?RmhxWC9jUE0yb3Y5N0p6VElhaSthUG5XQWxFRUFuTysxQng4S0NDd0dZMUI2?=
 =?utf-8?B?cjBXei9BeVRtRWFaRWpZNXByN1g4dDU2OXNaNnhzM291dTRpZDNFU1BnblYy?=
 =?utf-8?B?SDM5ZTJ5RmwxWFQydERqa284YXN1NStJMTUxeVVSUDhaMzBIU0FDMis4YkpD?=
 =?utf-8?B?U25SY0ViSHE2N295UHl4am90MGhvS2k4VEtXU0tJUkRWUHJOQmdkejBoNVBk?=
 =?utf-8?Q?sXULKKDTQ6RI2pexyL+AMmtxPqks68RtIjgdXhU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 971421c1-3376-49af-46e0-08d8c8d9656a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 06:52:10.6418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w1iNteuIQgEdxwcNVXb664PS0aIIXJ0hHSAmGXEK/ZE0DQxT2WIx9wsd8mDLipr5ZbG03O+DnenZ0h3giJ46dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5010
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBGZWJydWFyeSAyLCAyMDIxIDI6NDIgUE0NCj4gDQo+IE9uIDIwMjEvMi8xIDE1OjU2LCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbT4NCj4gPj4gU2VudDogU2F0dXJkYXksIEphbnVhcnkgMzAsIDIwMjEg
Njo1OCBBTQ0KPiA+Pg0KPiA+PiBPbiBNb24sIDI1IEphbiAyMDIxIDE3OjAzOjU4ICswODAwDQo+
ID4+IFNoZW5taW5nIEx1IDxsdXNoZW5taW5nQGh1YXdlaS5jb20+IHdyb3RlOg0KPiA+Pg0KPiA+
Pj4gSGksDQo+ID4+Pg0KPiA+Pj4gVGhlIHN0YXRpYyBwaW5uaW5nIGFuZCBtYXBwaW5nIHByb2Js
ZW0gaW4gVkZJTyBhbmQgcG9zc2libGUgc29sdXRpb25zDQo+ID4+PiBoYXZlIGJlZW4gZGlzY3Vz
c2VkIGEgbG90IFsxLCAyXS4gT25lIG9mIHRoZSBzb2x1dGlvbnMgaXMgdG8gYWRkIEkvTw0KPiA+
Pj4gcGFnZSBmYXVsdCBzdXBwb3J0IGZvciBWRklPIGRldmljZXMuIERpZmZlcmVudCBmcm9tIHRo
b3NlIHJlbGF0aXZlbHkNCj4gPj4+IGNvbXBsaWNhdGVkIHNvZnR3YXJlIGFwcHJvYWNoZXMgc3Vj
aCBhcyBwcmVzZW50aW5nIGEgdklPTU1VIHRoYXQNCj4gPj4gcHJvdmlkZXMNCj4gPj4+IHRoZSBE
TUEgYnVmZmVyIGluZm9ybWF0aW9uIChtaWdodCBpbmNsdWRlIHBhcmEtdmlydHVhbGl6ZWQNCj4g
b3B0aW1pemF0aW9ucyksDQo+ID4+PiBJT1BGIG1haW5seSBkZXBlbmRzIG9uIHRoZSBoYXJkd2Fy
ZSBmYXVsdGluZyBjYXBhYmlsaXR5LCBzdWNoIGFzIHRoZQ0KPiBQQ0llDQo+ID4+PiBQUkkgZXh0
ZW5zaW9uIG9yIEFybSBTTU1VIHN0YWxsIG1vZGVsLiBXaGF0J3MgbW9yZSwgdGhlIElPUEYgc3Vw
cG9ydA0KPiBpbg0KPiA+Pj4gdGhlIElPTU1VIGRyaXZlciBpcyBiZWluZyBpbXBsZW1lbnRlZCBp
biBTVkEgWzNdLiBTbyBkbyB3ZSBjb25zaWRlciB0bw0KPiA+Pj4gYWRkIElPUEYgc3VwcG9ydCBm
b3IgVkZJTyBwYXNzdGhyb3VnaCBiYXNlZCBvbiB0aGUgSU9QRiBwYXJ0IG9mIFNWQSBhdA0KPiA+
Pj4gcHJlc2VudD8NCj4gPj4+DQo+ID4+PiBXZSBoYXZlIGltcGxlbWVudGVkIGEgYmFzaWMgZGVt
byBvbmx5IGZvciBvbmUgc3RhZ2Ugb2YgdHJhbnNsYXRpb24NCj4gKEdQQQ0KPiA+Pj4gLT4gSFBB
IGluIHZpcnR1YWxpemF0aW9uLCBub3RlIHRoYXQgaXQgY2FuIGJlIGNvbmZpZ3VyZWQgYXQgZWl0
aGVyIHN0YWdlKSwNCj4gPj4+IGFuZCB0ZXN0ZWQgb24gSGlzaWxpY29uIEt1bnBlbmc5MjAgYm9h
cmQuIFRoZSBuZXN0ZWQgbW9kZSBpcyBtb3JlDQo+ID4+IGNvbXBsaWNhdGVkDQo+ID4+PiBzaW5j
ZSBWRklPIG9ubHkgaGFuZGxlcyB0aGUgc2Vjb25kIHN0YWdlIHBhZ2UgZmF1bHRzIChzYW1lIGFz
IHRoZSBub24tDQo+ID4+IG5lc3RlZA0KPiA+Pj4gY2FzZSksIHdoaWxlIHRoZSBmaXJzdCBzdGFn
ZSBwYWdlIGZhdWx0cyBuZWVkIHRvIGJlIGZ1cnRoZXIgZGVsaXZlcmVkIHRvDQo+ID4+PiB0aGUg
Z3Vlc3QsIHdoaWNoIGlzIGJlaW5nIGltcGxlbWVudGVkIGluIFs0XSBvbiBBUk0uIE15IHRob3Vn
aHQgb24gdGhpcw0KPiA+Pj4gaXMgdG8gcmVwb3J0IHRoZSBwYWdlIGZhdWx0cyB0byBWRklPIHJl
Z2FyZGxlc3Mgb2YgdGhlIG9jY3VyZWQgc3RhZ2UgKHRyeQ0KPiA+Pj4gdG8gY2FycnkgdGhlIHN0
YWdlIGluZm9ybWF0aW9uKSwgYW5kIGhhbmRsZSByZXNwZWN0aXZlbHkgYWNjb3JkaW5nIHRvIHRo
ZQ0KPiA+Pj4gY29uZmlndXJlZCBtb2RlIGluIFZGSU8uIE9yIHRoZSBJT01NVSBkcml2ZXIgbWln
aHQgZXZvbHZlIHRvIHN1cHBvcnQNCj4gPj4gbW9yZS4uLg0KPiA+Pj4NCj4gPj4+IE1pZ2h0IFRP
RE86DQo+ID4+PiAgLSBPcHRpbWl6ZSB0aGUgZmF1bHRpbmcgcGF0aCwgYW5kIG1lYXN1cmUgdGhl
IHBlcmZvcm1hbmNlIChpdCBtaWdodCBzdGlsbA0KPiA+Pj4gICAgYmUgYSBiaWcgaXNzdWUpLg0K
PiA+Pj4gIC0gQWRkIHN1cHBvcnQgZm9yIFBSSS4NCj4gPj4+ICAtIEFkZCBhIE1NVSBub3RpZmll
ciB0byBhdm9pZCBwaW5uaW5nLg0KPiA+Pj4gIC0gQWRkIHN1cHBvcnQgZm9yIHRoZSBuZXN0ZWQg
bW9kZS4NCj4gPj4+IC4uLg0KPiA+Pj4NCj4gPj4+IEFueSBjb21tZW50cyBhbmQgc3VnZ2VzdGlv
bnMgYXJlIHZlcnkgd2VsY29tZS4gOi0pDQo+ID4+DQo+ID4+IEkgZXhwZWN0IHBlcmZvcm1hbmNl
IHRvIGJlIHByZXR0eSBiYWQgaGVyZSwgdGhlIGxvb2t1cCBpbnZvbHZlZCBwZXINCj4gPj4gZmF1
bHQgaXMgZXhjZXNzaXZlLiAgVGhlcmUgYXJlIGNhc2VzIHdoZXJlIGEgdXNlciBpcyBub3QgZ29p
bmcgdG8gYmUNCj4gPj4gd2lsbGluZyB0byBoYXZlIGEgc2xvdyByYW1wIHVwIG9mIHBlcmZvcm1h
bmNlIGZvciB0aGVpciBkZXZpY2VzIGFzIHRoZXkNCj4gPj4gZmF1bHQgaW4gcGFnZXMsIHNvIHdl
IG1pZ2h0IG5lZWQgdG8gY29uc2lkZXJpbmcgbWFraW5nIHRoaXMNCj4gPj4gY29uZmlndXJhYmxl
IHRocm91Z2ggdGhlIHZmaW8gaW50ZXJmYWNlLiAgT3VyIHBhZ2UgbWFwcGluZyBhbHNvIG9ubHkN
Cj4gPg0KPiA+IFRoZXJlIGlzIGFub3RoZXIgZmFjdG9yIHRvIGJlIGNvbnNpZGVyZWQuIFRoZSBw
cmVzZW5jZSBvZiBJT01NVV8NCj4gPiBERVZfRkVBVF9JT1BGIGp1c3QgaW5kaWNhdGVzIHRoZSBk
ZXZpY2UgY2FwYWJpbGl0eSBvZiB0cmlnZ2VyaW5nIEkvTw0KPiA+IHBhZ2UgZmF1bHQgdGhyb3Vn
aCB0aGUgSU9NTVUsIGJ1dCBub3QgZXhhY3RseSBtZWFucyB0aGF0IHRoZSBkZXZpY2UNCj4gPiBj
YW4gdG9sZXJhdGUgSS9PIHBhZ2UgZmF1bHQgZm9yIGFyYml0cmFyeSBETUEgcmVxdWVzdHMuDQo+
IA0KPiBZZXMsIHNvIEkgYWRkIGEgaW9wZl9lbmFibGVkIGZpZWxkIGluIFZGSU8gdG8gaW5kaWNh
dGUgdGhlIHdob2xlIHBhdGggZmF1bHRpbmcNCj4gY2FwYWJpbGl0eSBhbmQgc2V0IGl0IHRvIHRy
dWUgYWZ0ZXIgcmVnaXN0ZXJpbmcgYSBWRklPIHBhZ2UgZmF1bHQgaGFuZGxlci4NCj4gDQo+ID4g
SW4gcmVhbGl0eSwgbWFueQ0KPiA+IGRldmljZXMgYWxsb3cgSS9PIGZhdWx0aW5nIG9ubHkgaW4g
c2VsZWN0aXZlIGNvbnRleHRzLiBIb3dldmVyLCB0aGVyZQ0KPiA+IGlzIG5vIHN0YW5kYXJkIHdh
eSAoZS5nLiBQQ0lTSUcpIGZvciB0aGUgZGV2aWNlIHRvIHJlcG9ydCB3aGV0aGVyDQo+ID4gYXJi
aXRyYXJ5IEkvTyBmYXVsdCBpcyBhbGxvd2VkLiBUaGVuIHdlIG1heSBoYXZlIHRvIG1haW50YWlu
IGRldmljZQ0KPiA+IHNwZWNpZmljIGtub3dsZWRnZSBpbiBzb2Z0d2FyZSwgZS5nLiBpbiBhbiBv
cHQtaW4gdGFibGUgdG8gbGlzdCBkZXZpY2VzDQo+ID4gd2hpY2ggYWxsb3dzIGFyYml0cmFyeSBm
YXVsdHMuIEZvciBkZXZpY2VzIHdoaWNoIG9ubHkgc3VwcG9ydCBzZWxlY3RpdmUNCj4gPiBmYXVs
dGluZywgYSBtZWRpYXRvciAoZWl0aGVyIHRocm91Z2ggdmVuZG9yIGV4dGVuc2lvbnMgb24gdmZp
by1wY2ktY29yZQ0KPiA+IG9yIGEgbWRldiB3cmFwcGVyKSBtaWdodCBiZSBuZWNlc3NhcnkgdG8g
aGVscCBsb2NrIGRvd24gbm9uLWZhdWx0YWJsZQ0KPiA+IG1hcHBpbmdzIGFuZCB0aGVuIGVuYWJs
ZSBmYXVsdGluZyBvbiB0aGUgcmVzdCBtYXBwaW5ncy4NCj4gDQo+IEZvciBkZXZpY2VzIHdoaWNo
IG9ubHkgc3VwcG9ydCBzZWxlY3RpdmUgZmF1bHRpbmcsIHRoZXkgY291bGQgdGVsbCBpdCB0byB0
aGUNCj4gSU9NTVUgZHJpdmVyIGFuZCBsZXQgaXQgZmlsdGVyIG91dCBub24tZmF1bHRhYmxlIGZh
dWx0cz8gRG8gSSBnZXQgaXQgd3Jvbmc/DQoNCk5vdCBleGFjdGx5IHRvIElPTU1VIGRyaXZlci4g
VGhlcmUgaXMgYWxyZWFkeSBhIHZmaW9fcGluX3BhZ2VzKCkgZm9yDQpzZWxlY3RpdmVseSBwYWdl
LXBpbm5pbmcuIFRoZSBtYXR0ZXIgaXMgdGhhdCAndGhleScgaW1wbHkgc29tZSBkZXZpY2UNCnNw
ZWNpZmljIGxvZ2ljIHRvIGRlY2lkZSB3aGljaCBwYWdlcyBtdXN0IGJlIHBpbm5lZCBhbmQgc3Vj
aCBrbm93bGVkZ2UNCmlzIG91dHNpZGUgb2YgVkZJTy4NCg0KRnJvbSBlbmFibGluZyBwLm8udiB3
ZSBjb3VsZCBwb3NzaWJseSBkbyBpdCBpbiBwaGFzZWQgYXBwcm9hY2guIEZpcnN0IA0KaGFuZGxl
cyBkZXZpY2VzIHdoaWNoIHRvbGVyYXRlIGFyYml0cmFyeSBETUEgZmF1bHRzLCBhbmQgdGhlbiBl
eHRlbmRzDQp0byBkZXZpY2VzIHdpdGggc2VsZWN0aXZlLWZhdWx0aW5nLiBUaGUgZm9ybWVyIGlz
IHNpbXBsZXIsIGJ1dCB3aXRoIG9uZQ0KbWFpbiBvcGVuIHdoZXRoZXIgd2Ugd2FudCB0byBtYWlu
dGFpbiBzdWNoIGRldmljZSBJRHMgaW4gYSBzdGF0aWMNCnRhYmxlIGluIFZGSU8gb3IgcmVseSBv
biBzb21lIGhpbnRzIGZyb20gb3RoZXIgY29tcG9uZW50cyAoZS5nLiBQRg0KZHJpdmVyIGluIFZG
IGFzc2lnbm1lbnQgY2FzZSkuIExldCdzIHNlZSBob3cgQWxleCB0aGlua3MgYWJvdXQgaXQuDQoN
Cj4gDQo+ID4NCj4gPj4gZ3Jvd3MgaGVyZSwgc2hvdWxkIG1hcHBpbmdzIGV4cGlyZSBvciBkbyB3
ZSBuZWVkIGEgbGVhc3QgcmVjZW50bHkNCj4gPj4gbWFwcGVkIHRyYWNrZXIgdG8gYXZvaWQgZXhj
ZWVkaW5nIHRoZSB1c2VyJ3MgbG9ja2VkIG1lbW9yeSBsaW1pdD8gIEhvdw0KPiA+PiBkb2VzIGEg
dXNlciBrbm93IHdoYXQgdG8gc2V0IGZvciBhIGxvY2tlZCBtZW1vcnkgbGltaXQ/ICBUaGUgYmVo
YXZpb3INCj4gPj4gaGVyZSB3b3VsZCBsZWFkIHRvIGNhc2VzIHdoZXJlIGFuIGlkbGUgc3lzdGVt
IG1pZ2h0IGJlIG9rLCBidXQgYXMgc29vbg0KPiA+PiBhcyBsb2FkIGluY3JlYXNlcyB3aXRoIG1v
cmUgaW5mbGlnaHQgRE1BLCB3ZSBzdGFydCBzZWVpbmcNCj4gPj4gInVucHJlZGljdGFibGUiIEkv
TyBmYXVsdHMgZnJvbSB0aGUgdXNlciBwZXJzcGVjdGl2ZS4gIFNlZW1zIGxpa2UgdGhlcmUNCj4g
Pj4gYXJlIGxvdHMgb2Ygb3V0c3RhbmRpbmcgY29uc2lkZXJhdGlvbnMgYW5kIEknZCBhbHNvIGxp
a2UgdG8gaGVhciBmcm9tDQo+ID4+IHRoZSBTVkEgZm9sa3MgYWJvdXQgaG93IHRoaXMgbWVzaGVz
IHdpdGggdGhlaXIgd29yay4gIFRoYW5rcywNCj4gPj4NCj4gPg0KPiA+IFRoZSBtYWluIG92ZXJs
YXAgYmV0d2VlbiB0aGlzIGZlYXR1cmUgYW5kIFNWQSBpcyB0aGUgSU9QRiByZXBvcnRpbmcNCj4g
PiBmcmFtZXdvcmssIHdoaWNoIGN1cnJlbnRseSBzdGlsbCBoYXMgZ2FwIHRvIHN1cHBvcnQgYm90
aCBpbiBuZXN0ZWQNCj4gPiBtb2RlLCBhcyBkaXNjdXNzZWQgaGVyZToNCj4gPg0KPiA+IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWFjcGkvWUFheGptSlcrWk12cmhhY0BteXJpY2EvDQo+
ID4NCj4gPiBPbmNlIHRoYXQgZ2FwIGlzIHJlc29sdmVkIGluIHRoZSBmdXR1cmUsIHRoZSBWRklP
IGZhdWx0IGhhbmRsZXIganVzdA0KPiA+IGFkb3B0cyBkaWZmZXJlbnQgYWN0aW9ucyBhY2NvcmRp
bmcgdG8gdGhlIGZhdWx0LWxldmVsOiAxc3QgbGV2ZWwgZmF1bHRzDQo+ID4gYXJlIGZvcndhcmRl
ZCB0byB1c2Vyc3BhY2UgdGhydSB0aGUgdlNWQSBwYXRoIHdoaWxlIDJuZC1sZXZlbCBmYXVsdHMN
Cj4gPiBhcmUgZml4ZWQgKG9yIHdhcm5lZCBpZiBub3QgaW50ZW5kZWQpIGJ5IFZGSU8gaXRzZWxm
IHRocnUgdGhlIElPTU1VDQo+ID4gbWFwcGluZyBpbnRlcmZhY2UuDQo+IA0KPiBJIHVuZGVyc3Rh
bmQgd2hhdCB5b3UgbWVhbiBpczoNCj4gRnJvbSB0aGUgcGVyc3BlY3RpdmUgb2YgVkZJTywgZmly
c3QsIHdlIG5lZWQgdG8gc2V0IEZFQVRfSU9QRiwgYW5kIHRoZW4NCj4gcmVnc3RlciBpdHMNCj4g
b3duIGhhbmRsZXIgd2l0aCBhIGZsYWcgdG8gaW5kaWNhdGUgRkxBVCBvciBORVNURUQgYW5kIHdo
aWNoIGxldmVsIGlzDQo+IGNvbmNlcm5lZCwNCj4gdGh1cyB0aGUgVkZJTyBoYW5kbGVyIGNhbiBo
YW5kbGUgdGhlIHBhZ2UgZmF1bHRzIGRpcmVjdGx5IGFjY29yZGluZyB0byB0aGUNCj4gY2Fycmll
ZA0KPiBsZXZlbCBpbmZvcm1hdGlvbi4NCj4gDQo+IElzIHRoZXJlIGFueSBwbGFuIGZvciBldm9s
dmluZyhpbXBsZW1lbnRpbmcpIHRoZSBJT01NVSBkcml2ZXIgdG8gc3VwcG9ydA0KPiB0aGlzPyBP
cg0KPiBjb3VsZCB3ZSBoZWxwIHRoaXM/ICA6LSkNCj4gDQoNClllcywgaXQncyBpbiBwbGFuIGJ1
dCBqdXN0IG5vdCBoYXBwZW5lZCB5ZXQuIFdlIGFyZSBzdGlsbCBmb2N1c2luZyBvbiBndWVzdA0K
U1ZBIHBhcnQgdGh1cyBvbmx5IHRoZSAxc3QtbGV2ZWwgcGFnZSBmYXVsdCAoK1lpL0phY29iKS4g
SXQncyBhbHdheXMgd2VsY29tZWQgDQp0byBjb2xsYWJvcmF0ZS9oZWxwIGlmIHlvdSBoYXZlIHRp
bWUuIPCfmIoNCg0KVGhhbmtzDQpLZXZpbg0K

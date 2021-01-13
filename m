Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774E62F4434
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 06:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbhAMF5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 00:57:38 -0500
Received: from mga18.intel.com ([134.134.136.126]:7814 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbhAMF5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 00:57:38 -0500
IronPort-SDR: 9VxGGN9IFHziHvc8MpDdoc4DupcuPwSD6sK7yVgAwKMyE7xSqdS07Lk5+SI+b9N5Z/av14trFY
 OPzgipuwH60g==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="165831109"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="165831109"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 21:56:56 -0800
IronPort-SDR: 2j/3wwk5ZHrfFrV2GK+6Ac6LRjeCPLyh5EauPJwkB/Qh5gwss/f2erZ4qGGRiCypOWZGSqFq1L
 WUxkkt7POXGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="424440911"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 12 Jan 2021 21:56:56 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Jan 2021 21:56:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Jan 2021 21:56:55 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 12 Jan 2021 21:56:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Teaed8uqhZIArY23dZbv0cIZ+yUFl94SRfeD1lY08mC19v3yeBYx06SQZPw8srqleSymG4pYGDxCfULuZSJEPtpRUPslSyf6aGqlkTdNdBXUbyEvT3jPOV5WEsm3WRD+HhuLa2EOpFiVr3mN7i/VZJe+kvoi3n0RdGPcvd/ukuJIBp3xZnlMFXLsjmmq6NtSuUKHY+Si28c8T0+Yxagxk1Vuy64II22QcnMX2T593arjdv8gKvNIro/diR+K6Je00a5xPjDITVd1sH4orBGtryh2GD1txPbjrq2g+KeUgH0hnPDgEqIWp9RgwGE79z2xhKiehsDtaVW0t5JNyXxNJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuVWgsoYtmepPT8cUgKwM2zXimzLkiKjH4TMFpqNVHw=;
 b=Qm3uDU92DHwck74xCzshXbq6OeSomUwM+Ul3JATat0FWMhJIv3UfF16BlK2r4Tmw6/Wz6onYG4wf9nJP2hcw3f/BxYx6RKor9R5f3zCZ8Ym+Kf9c/t15wXtpqAAMyHYU3mVsFjj+JclF/6ZJkx8Dpumul/mz190f/AxdpK9fIBPrQ+/CQ621mGN8so1UwEsk9yv4GqHNfbXytidku5Jga40XCNiafIXRiW0HF4DMC+Iobg4Bu0L1xU/+AyfzefJp3mg74tQCcMooFmzVphxgAikhCc2zK0LGIVmg3U1vChoi+flE1P12P5rJpGJgDZcuBNlEognNWW8mOviLd3S5Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuVWgsoYtmepPT8cUgKwM2zXimzLkiKjH4TMFpqNVHw=;
 b=YWfX5PRCOPQP1UPtcg6ZykoYp7e025aa255WDN49r4d2q7VU2fWsM8ne9K5PqVKqEi6qLt2RtTt7jBzni/1SgV2R0p6d6tL6v24dE+ghFjz42MW84hdoW3rGI4aJ+CBBrzpplJnkr77a3nPHqWwZn+fAKmoMiTXAMHceMhc8jCg=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3580.namprd11.prod.outlook.com (2603:10b6:5:138::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.12; Wed, 13 Jan 2021 05:56:49 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::649c:8aff:2053:e93]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::649c:8aff:2053:e93%3]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 05:56:49 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Vivek Gautam <vivek.gautam@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "Sun, Yi Y" <yi.y.sun@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        Will Deacon <will@kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>, Robin Murphy <robin.murphy@arm.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
Subject: RE: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
Thread-Topic: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
Thread-Index: AQHWh19ACfcP7ssg8UC1cgpZfCvfJKokT6+AgAAjF2CAACQ7gIABOtBw
Date:   Wed, 13 Jan 2021 05:56:48 +0000
Message-ID: <DM5PR11MB1435D9ED79B2BE9C8F235428C3A90@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <1599734733-6431-3-git-send-email-yi.l.liu@intel.com>
 <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
 <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
In-Reply-To: <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9555387c-87f6-4bc0-ec50-08d8b7880469
x-ms-traffictypediagnostic: DM6PR11MB3580:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB358063B65E2B372C1A4059FDC3A90@DM6PR11MB3580.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aPEsNrIaT9TC4KGx5A1OFmGs315emwHEhxLMBNB/adr83/3NO0y9RafOYk7Vqnn+i3ua3maJX5yVlo2xnQQ3r9bwEnJUhDc4ESQyy12cXDAIlJSffy6UUgAAo4FARL6ccHmSK8hlGSbKJaH6acDqE6czbpjMEyUpPBsx7qHr4ucAWW5q4WX3H6qTdcE+sbuzpX+gLStkJqEQIhqu8g6MAgTDCLxSFW7fTki7JIewXWB0JbLGvBkZhrISvdV/n2PaiM9vED18jHREFD5Z0xeKwlCx2FCh5+AztbKw03V2QacJ3DJ15z01Y4P2Qdz34CDtdGRhL3MS/SAvLOq3r9E/8EFT1y+JLbb7MfTwglfSCjVplymUsMCJss5yDJrHcfIuqqd4m5AmstUrEpRqIMhP6hkWZfWvRKIqk6zEo1HZHCqc+HH+LNUL+qRoknKNNzZhriFCA2SmRlzGUgksKZgpsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(186003)(4326008)(26005)(8676002)(110136005)(478600001)(9686003)(7696005)(6506007)(107886003)(54906003)(2906002)(5660300002)(316002)(83380400001)(71200400001)(66556008)(66446008)(53546011)(55016002)(7416002)(66476007)(64756008)(8936002)(966005)(66946007)(76116006)(52536014)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TkdTQ0E0Vk44R25wOUlqOEdkRVBiK1g0d2cyZ2gvcWt5YlZrOExrTkZYY0Jp?=
 =?utf-8?B?QzQxL0FtanBwRmUrdWxqc3Qvb1c3YkQweHFyOGY5ZHZGL1kxU1c1VWl5QXh6?=
 =?utf-8?B?VmgxdS9iWFg5Mjh4cCszVkY1TDQ0cXRsVWo2VFE1cHhmSGUwSVAyMW9KTUV3?=
 =?utf-8?B?QlA2bHlOaVpFeGNzVlJYSTBCQzkwS25jQUtSQ1RNQ1NmakpPc01PbGRRdUhi?=
 =?utf-8?B?Sk8xNUVVWXFLTWJyYXh4M2FkMVM4RE16YXloazRmMW1iUTV0MFBGMEVOaFEy?=
 =?utf-8?B?SE1IeWxOZ3VrbnFiczNHMEFNUGpKcnZHVzdOZ0NmWXBPWUNGVGF1RHNnSTd6?=
 =?utf-8?B?UlFEakk5VXRIM2FXYm1pN0xLbmpNY0lwa1BjaGhScm96Y2FBSnBwOEhmZG4x?=
 =?utf-8?B?Y3JPZTR3ZWk5WjBRSkN4TDhOdURyd1JJSnFDcjBNbXpBVkdYMFV1TTZlSGRY?=
 =?utf-8?B?cXFCUzYwQVFIaGRGaVJnNHFJM2RHQ0hVNERpbG1hckkrV0RlNGUwUHpXOWFv?=
 =?utf-8?B?dldFdFMySU5rMUlDOW8zS25BRyt4aE01cmMyTGR0V3ViT1VvQTVIbHg1WWNW?=
 =?utf-8?B?ZmNUTkFtdkNPOVJvWURtYkRjSjhKUVVnNG9MMjZMR0dGYWdQM28xaEIzUi9j?=
 =?utf-8?B?MWx6T2VyTEtGbEhhNEp1NVZLTzBaSUwwbUM5NWJQSHJyMHNZMHBLekFueHlU?=
 =?utf-8?B?N1UrQm92OWp0UUR5VzB1U0thaExSRjJFUjdwV2hScXpMejdYaEc3anMvUFA0?=
 =?utf-8?B?bWpXaU1xNm9pSC9VeXliVVY0bWoreW9mWm9NWlBvNjAwYmYxVWgrdkR0Q3Bv?=
 =?utf-8?B?V3RqNDZEMWlVamhVOFdsdlp4SlZKNlA2d3YrRG93ZGEwWGFTQjFjYUt1M2Y5?=
 =?utf-8?B?TmFsclZDMXArSWtSSnovK0F6TjlyTWJ6K3hvWnNTa0xoV0tvUFdPSGNmaStz?=
 =?utf-8?B?ZDIyNGpHUG5IQkNzQStWTnVTSFdrbnd5NlZiUnM2SjllYkxXcWJMNkkxTENs?=
 =?utf-8?B?M2VXU2toaTFGL2JqU3Z2Q0VGQjVWUG11QkFma00yOTM3QnFXK1BjK2lkWXhm?=
 =?utf-8?B?YUpla0pWakhEbFovSE94Y2dUbVpCdzd6S2tHRHdqZHcwZVlmL0k1ZUZxUVFM?=
 =?utf-8?B?QkxTMXVYbHhpSStzaW1Dem1SMWg3QnFjajlSS29YRjFqL2dQcWVPR1JnZko5?=
 =?utf-8?B?Q0w5bnNlT01iRUloRzJBMlhFMUxOYk9zNTloZ1lzWmErWFdjSzdQTEJTWWpi?=
 =?utf-8?B?VjI5cDc5bEdQcnZTS0MxSm1hQ1RNbG13cHQ2ZUhwdlgxNjRtUzVIQkcyR0pq?=
 =?utf-8?Q?/FnD2Cgz0s/eg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9555387c-87f6-4bc0-ec50-08d8b7880469
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 05:56:48.8591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KlSMvdJWTkXF+CutbxzVM+W4MRMy+vvchWl0GSaa8/xvT53ofqaML1mSkCHEaDds574IWSgsgF76u9VJfzdJBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3580
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgVml2ZWssDQoNCj4gRnJvbTogVml2ZWsgR2F1dGFtIDx2aXZlay5nYXV0YW1AYXJtLmNvbT4N
Cj4gU2VudDogVHVlc2RheSwgSmFudWFyeSAxMiwgMjAyMSA3OjA2IFBNDQo+IA0KPiBIaSBZaSwN
Cj4gDQo+IA0KPiBPbiBUdWUsIEphbiAxMiwgMjAyMSBhdCAyOjUxIFBNIExpdSwgWWkgTCA8eWku
bC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IEhpIFZpdmVrLA0KPiA+DQo+ID4gPiBG
cm9tOiBWaXZlayBHYXV0YW0gPHZpdmVrLmdhdXRhbUBhcm0uY29tPg0KPiA+ID4gU2VudDogVHVl
c2RheSwgSmFudWFyeSAxMiwgMjAyMSAyOjUwIFBNDQo+ID4gPg0KPiA+ID4gSGkgWWksDQo+ID4g
Pg0KPiA+ID4NCj4gPiA+IE9uIFRodSwgU2VwIDEwLCAyMDIwIGF0IDQ6MTMgUE0gTGl1IFlpIEwg
PHlpLmwubGl1QGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IFRoaXMgcGF0Y2gg
aXMgYWRkZWQgYXMgaW5zdGVhZCBvZiByZXR1cm5pbmcgYSBib29sZWFuIGZvcg0KPiA+ID4gRE9N
QUlOX0FUVFJfTkVTVElORywNCj4gPiA+ID4gaW9tbXVfZG9tYWluX2dldF9hdHRyKCkgc2hvdWxk
IHJldHVybiBhbiBpb21tdV9uZXN0aW5nX2luZm8NCj4gaGFuZGxlLg0KPiA+ID4gRm9yDQo+ID4g
PiA+IG5vdywgcmV0dXJuIGFuIGVtcHR5IG5lc3RpbmcgaW5mbyBzdHJ1Y3QgZm9yIG5vdyBhcyB0
cnVlIG5lc3RpbmcgaXMgbm90DQo+ID4gPiA+IHlldCBzdXBwb3J0ZWQgYnkgdGhlIFNNTVVzLg0K
PiA+ID4gPg0KPiA+ID4gPiBDYzogV2lsbCBEZWFjb24gPHdpbGxAa2VybmVsLm9yZz4NCj4gPiA+
ID4gQ2M6IFJvYmluIE11cnBoeSA8cm9iaW4ubXVycGh5QGFybS5jb20+DQo+ID4gPiA+IENjOiBF
cmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4gPiA+IENjOiBKZWFuLVBoaWxp
cHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4NCj4gPiA+ID4gU3VnZ2VzdGVk
LWJ5OiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4NCj4g
PiA+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+
ID4gU2lnbmVkLW9mZi1ieTogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNv
bT4NCj4gPiA+ID4gUmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+IHY1IC0+IHY2Og0KPiA+ID4gPiAqKSBhZGQgcmV2aWV3
LWJ5IGZyb20gRXJpYyBBdWdlci4NCj4gPiA+ID4NCj4gPiA+ID4gdjQgLT4gdjU6DQo+ID4gPiA+
ICopIGFkZHJlc3MgY29tbWVudHMgZnJvbSBFcmljIEF1Z2VyLg0KPiA+ID4gPiAtLS0NCj4gPiA+
ID4gIGRyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMgfCAyOQ0KPiA+
ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gPiA+ID4gIGRyaXZlcnMvaW9tbXUv
YXJtL2FybS1zbW11L2FybS1zbW11LmMgICAgICAgfCAyOQ0KPiA+ID4gKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0NCj4gPiA+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNTQgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkNCj4gPiA+ID4NCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
aW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMNCj4gPiA+IGIvZHJpdmVycy9pb21t
dS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYw0KPiA+ID4gPiBpbmRleCA3MTk2MjA3Li4w
MTZlMmU1IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9kcml2ZXJzL2lvbW11L2FybS9hcm0tc21tdS12
My9hcm0tc21tdS12My5jDQo+ID4gPiA+ICsrKyBiL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11
LXYzL2FybS1zbW11LXYzLmMNCj4gPiA+ID4gQEAgLTMwMTksNiArMzAxOSwzMiBAQCBzdGF0aWMg
c3RydWN0IGlvbW11X2dyb3VwDQo+ID4gPiAqYXJtX3NtbXVfZGV2aWNlX2dyb3VwKHN0cnVjdCBk
ZXZpY2UgKmRldikNCj4gPiA+ID4gICAgICAgICByZXR1cm4gZ3JvdXA7DQo+ID4gPiA+ICB9DQo+
ID4gPiA+DQo+ID4gPiA+ICtzdGF0aWMgaW50IGFybV9zbW11X2RvbWFpbl9uZXN0aW5nX2luZm8o
c3RydWN0DQo+IGFybV9zbW11X2RvbWFpbg0KPiA+ID4gKnNtbXVfZG9tYWluLA0KPiA+ID4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm9pZCAqZGF0YSkNCj4gPiA+
ID4gK3sNCj4gPiA+ID4gKyAgICAgICBzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvICppbmZvID0g
KHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8NCj4gPiA+ICopZGF0YTsNCj4gPiA+ID4gKyAgICAg
ICB1bnNpZ25lZCBpbnQgc2l6ZTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgIGlmICghaW5m
byB8fCBzbW11X2RvbWFpbi0+c3RhZ2UgIT0NCj4gQVJNX1NNTVVfRE9NQUlOX05FU1RFRCkNCj4g
PiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRU5PREVWOw0KPiA+ID4gPiArDQo+ID4gPiA+
ICsgICAgICAgc2l6ZSA9IHNpemVvZihzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvKTsNCj4gPiA+
ID4gKw0KPiA+ID4gPiArICAgICAgIC8qDQo+ID4gPiA+ICsgICAgICAgICogaWYgcHJvdmlkZWQg
YnVmZmVyIHNpemUgaXMgc21hbGxlciB0aGFuIGV4cGVjdGVkLCBzaG91bGQNCj4gPiA+ID4gKyAg
ICAgICAgKiByZXR1cm4gMCBhbmQgYWxzbyB0aGUgZXhwZWN0ZWQgYnVmZmVyIHNpemUgdG8gY2Fs
bGVyLg0KPiA+ID4gPiArICAgICAgICAqLw0KPiA+ID4gPiArICAgICAgIGlmIChpbmZvLT5hcmdz
eiA8IHNpemUpIHsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGluZm8tPmFyZ3N6ID0gc2l6ZTsN
Cj4gPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+ID4gPiArICAgICAgIH0NCj4g
PiA+ID4gKw0KPiA+ID4gPiArICAgICAgIC8qIHJlcG9ydCBhbiBlbXB0eSBpb21tdV9uZXN0aW5n
X2luZm8gZm9yIG5vdyAqLw0KPiA+ID4gPiArICAgICAgIG1lbXNldChpbmZvLCAweDAsIHNpemUp
Ow0KPiA+ID4gPiArICAgICAgIGluZm8tPmFyZ3N6ID0gc2l6ZTsNCj4gPiA+ID4gKyAgICAgICBy
ZXR1cm4gMDsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiAgc3RhdGljIGludCBhcm1f
c21tdV9kb21haW5fZ2V0X2F0dHIoc3RydWN0IGlvbW11X2RvbWFpbg0KPiAqZG9tYWluLA0KPiA+
ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbnVtIGlvbW11X2F0dHIg
YXR0ciwgdm9pZCAqZGF0YSkNCj4gPiA+ID4gIHsNCj4gPiA+ID4gQEAgLTMwMjgsOCArMzA1NCw3
IEBAIHN0YXRpYyBpbnQNCj4gYXJtX3NtbXVfZG9tYWluX2dldF9hdHRyKHN0cnVjdA0KPiA+ID4g
aW9tbXVfZG9tYWluICpkb21haW4sDQo+ID4gPiA+ICAgICAgICAgY2FzZSBJT01NVV9ET01BSU5f
VU5NQU5BR0VEOg0KPiA+ID4gPiAgICAgICAgICAgICAgICAgc3dpdGNoIChhdHRyKSB7DQo+ID4g
PiA+ICAgICAgICAgICAgICAgICBjYXNlIERPTUFJTl9BVFRSX05FU1RJTkc6DQo+ID4gPiA+IC0g
ICAgICAgICAgICAgICAgICAgICAgICooaW50ICopZGF0YSA9IChzbW11X2RvbWFpbi0+c3RhZ2Ug
PT0NCj4gPiA+IEFSTV9TTU1VX0RPTUFJTl9ORVNURUQpOw0KPiA+ID4gPiAtICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gMDsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0
dXJuDQo+IGFybV9zbW11X2RvbWFpbl9uZXN0aW5nX2luZm8oc21tdV9kb21haW4sDQo+ID4gPiBk
YXRhKTsNCj4gPiA+DQo+ID4gPiBUaGFua3MgZm9yIHRoZSBwYXRjaC4NCj4gPiA+IFRoaXMgd291
bGQgdW5uZWNlc3NhcmlseSBvdmVyZmxvdyAnZGF0YScgZm9yIGFueSBjYWxsZXIgdGhhdCdzIGV4
cGVjdGluZw0KPiBvbmx5DQo+ID4gPiBhbiBpbnQgZGF0YS4gRHVtcCBmcm9tIG9uZSBzdWNoIGlz
c3VlIHRoYXQgSSB3YXMgc2VlaW5nIHdoZW4gdGVzdGluZw0KPiA+ID4gdGhpcyBjaGFuZ2UgYWxv
bmcgd2l0aCBsb2NhbCBrdm10b29sIGNoYW5nZXMgaXMgcGFzdGVkIGJlbG93IFsxXS4NCj4gPiA+
DQo+ID4gPiBJIGNvdWxkIGdldCBhcm91bmQgd2l0aCB0aGUgaXNzdWUgYnkgYWRkaW5nIGFub3Ro
ZXIgKGlvbW11X2F0dHIpIC0NCj4gPiA+IERPTUFJTl9BVFRSX05FU1RJTkdfSU5GTyB0aGF0IHJl
dHVybnMgKGlvbW11X25lc3RpbmdfaW5mbykuDQo+ID4NCj4gPiBuaWNlIHRvIGhlYXIgZnJvbSB5
b3UuIEF0IGZpcnN0LCB3ZSBwbGFubmVkIHRvIGhhdmUgYSBzZXBhcmF0ZSBpb21tdV9hdHRyDQo+
ID4gZm9yIGdldHRpbmcgbmVzdGluZ19pbmZvLiBIb3dldmVyLCB3ZSBjb25zaWRlcmVkIHRoZXJl
IGlzIG5vIGV4aXN0aW5nIHVzZXINCj4gPiB3aGljaCBnZXRzIERPTUFJTl9BVFRSX05FU1RJTkcs
IHNvIHdlIGRlY2lkZWQgdG8gcmV1c2UgaXQgZm9yIGlvbW11DQo+IG5lc3RpbmcNCj4gPiBpbmZv
LiBDb3VsZCB5b3Ugc2hhcmUgbWUgdGhlIGNvZGUgYmFzZSB5b3UgYXJlIHVzaW5nPyBJZiB0aGUg
ZXJyb3IgeW91DQo+ID4gZW5jb3VudGVyZWQgaXMgZHVlIHRvIHRoaXMgY2hhbmdlLCBzbyB0aGVy
ZSBzaG91bGQgYmUgYSBwbGFjZSB3aGljaCBnZXRzDQo+ID4gRE9NQUlOX0FUVFJfTkVTVElORy4N
Cj4gDQo+IEkgYW0gY3VycmVudGx5IHdvcmtpbmcgb24gdG9wIG9mIEVyaWMncyB0cmVlIGZvciBu
ZXN0ZWQgc3RhZ2Ugc3VwcG9ydCBbMV0uDQo+IE15IGJlc3QgZ3Vlc3Mgd2FzIHRoYXQgdGhlIHZm
aW9fcGNpX2RtYV9mYXVsdF9pbml0KCkgbWV0aG9kIFsyXSB0aGF0IGlzDQo+IHJlcXVlc3Rpbmcg
RE9NQUlOX0FUVFJfTkVTVElORyBjYXVzZXMgc3RhY2sgb3ZlcmZsb3csIGFuZCBjb3JydXB0aW9u
Lg0KPiBUaGF0J3Mgd2hlbiBJIGFkZGVkIGEgbmV3IGF0dHJpYnV0ZS4NCg0KSSBzZWUuIEkgdGhp
bmsgdGhlcmUgbmVlZHMgYSBjaGFuZ2UgaW4gdGhlIGNvZGUgdGhlcmUuIFNob3VsZCBhbHNvIGV4
cGVjdA0KYSBuZXN0aW5nX2luZm8gcmV0dXJuZWQgaW5zdGVhZCBvZiBhbiBpbnQgYW55bW9yZS4g
QEVyaWMsIGhvdyBhYm91dCB5b3VyDQpvcGluaW9uPw0KDQoJZG9tYWluID0gaW9tbXVfZ2V0X2Rv
bWFpbl9mb3JfZGV2KCZ2ZGV2LT5wZGV2LT5kZXYpOw0KCXJldCA9IGlvbW11X2RvbWFpbl9nZXRf
YXR0cihkb21haW4sIERPTUFJTl9BVFRSX05FU1RJTkcsICZpbmZvKTsNCglpZiAocmV0IHx8ICEo
aW5mby5mZWF0dXJlcyAmIElPTU1VX05FU1RJTkdfRkVBVF9QQUdFX1JFU1ApKSB7DQoJCS8qDQoJ
CSAqIE5vIG5lZWQgZ28gZnV0aGVyIGFzIG5vIHBhZ2UgcmVxdWVzdCBzZXJ2aWNlIHN1cHBvcnQu
DQoJCSAqLw0KCQlyZXR1cm4gMDsNCgl9DQoNCmh0dHBzOi8vZ2l0aHViLmNvbS9sdXhpczE5OTkv
bGludXgtdnN2YS9ibG9iL3ZzdmEtbGludXgtNS45LXJjNi12OCUyQlBSUS9kcml2ZXJzL3ZmaW8v
cGNpL3ZmaW9fcGNpLmMNCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+IEkgd2lsbCBzb29uIHB1Ymxp
c2ggbXkgcGF0Y2hlcyB0byB0aGUgbGlzdCBmb3IgcmV2aWV3LiBMZXQgbWUga25vdw0KPiB5b3Vy
IHRob3VnaHRzLg0KPiANCj4gWzFdIGh0dHBzOi8vZ2l0aHViLmNvbS9lYXVnZXIvbGludXgvdHJl
ZS81LjEwLXJjNC0yc3RhZ2UtdjEzDQo+IFsyXSBodHRwczovL2dpdGh1Yi5jb20vZWF1Z2VyL2xp
bnV4L2Jsb2IvNS4xMC1yYzQtMnN0YWdlLQ0KPiB2MTMvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3Bj
aS5jI0w0OTQNCj4gDQo+IFRoYW5rcw0KPiBWaXZlaw0KPiANCj4gPg0KPiA+IFJlZ2FyZHMsDQo+
ID4gWWkgTGl1DQo+IA0KPiBbc25pcF0NCg==

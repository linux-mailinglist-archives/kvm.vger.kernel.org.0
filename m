Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A4F245CDD
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 09:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgHQHCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 03:02:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:62483 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHQHBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 03:01:08 -0400
IronPort-SDR: HRxiWZaBl3h8w046pa5QZnLKS2j8lJKElfW2jDicpssfoCVVfy+dYiI8SffXYz+feqH5QL3ZOC
 MRxDnmLNGMOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="134707387"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="134707387"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 00:00:42 -0700
IronPort-SDR: 9biGiep6qgqcQZUiiQE5S/hcTf2DQjMCxOxIDY+iX2kgL3fNogdLyB1EySI7J+kSHEtnmU52p0
 1pjK4lHWVOBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="279048148"
Received: from fmsmsx602-2.cps.intel.com (HELO fmsmsx602.amr.corp.intel.com) ([10.18.84.212])
  by fmsmga008.fm.intel.com with ESMTP; 17 Aug 2020 00:00:42 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Aug 2020 00:00:42 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Aug 2020 00:00:42 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Aug 2020 00:00:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 17 Aug 2020 00:00:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPM5gRLGk99ZsI3OxeX4nHx6wIS+MOy0UZ3LlXq07lDW8Qxj5HH2sLocj6CuXYPWY5OCLfAsKyVtY2rQcy5u4w2xz7KRFi8TtYtAPja5A9G324lAJV+i60VoJZHDtWal6dK9HiDI7j4ffhQKtt/djzEh4Vp/GSs/d/n5cAJ1/Mv/v+PueKewm97c6Ep2Y3C+iksquHlPSVZuS2IKw6LX2cTBHi28h471G6bMzTdN6ISG7aOjkz+wu1IDooIKWo5pCNPLNXVRLK0BJy4Qp9ndYRHWhyfAPt20+LdXmvB3lgCEVbad5p2P/J+KwKlDy1O8WObjQ63yxBHE6Q6n4tk0Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXVs1s9D0EGeMjByQgj36Xrco7yZczKQzPw6vlg9y00=;
 b=f93A6ijVavWt5fr+MzjWAOhsZThsNCkQouOj8ty1L106KcSLCNlkxNTf7RcSsT4nFLUZwZj8kY77eEjC0RGVs53YxyuL5UnImihOk4WHr74DtFVlW3sBxHpSYVI+DRFa87K3R6+m3rejl4VffowdKoHJ5DcCPpIS/OLdbxEQehJv4IkYyASl+akQS7tiTEm+zE/TLtzXRDA+iw67lyEYvwN7myEpOxXL1qZGynm13nE5dMxsBNrd4vAMWDtWGjjKR/IRWZubS4UQ3v5eCI6WMYL71Li77ULV0vEPeJrTmk3M06DODY+yf6V9qSVh5j1HXZeCN/Swe38a76HO7wlbkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXVs1s9D0EGeMjByQgj36Xrco7yZczKQzPw6vlg9y00=;
 b=s+85FJQxrdUq48zTEY+kOfcDZ9eED/21/sgbsL1EbeWETaPFVVsPBZV9v7RugIRY6u31p77QFNPjidefJrulVEcb/TPawbucX6NepH6qToVjehV7mE4r0xo7Lpz1529TnHm5Fzbxa+1ZG2tDO1lOFHYXIa2kQNO6qAikQhe2Yio=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1692.namprd11.prod.outlook.com (2603:10b6:3:d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.22; Mon, 17 Aug 2020 07:00:40 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3283.027; Mon, 17 Aug
 2020 07:00:39 +0000
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
Subject: RE: [PATCH v6 14/15] vfio: Document dual stage control
Thread-Topic: [PATCH v6 14/15] vfio: Document dual stage control
Thread-Index: AQHWZKdJ3vOT/2BJCk+0yd/zBgmH2qk6vfCAgAE7MtA=
Date:   Mon, 17 Aug 2020 07:00:39 +0000
Message-ID: <DM5PR11MB143519ABA63F46D7864E9EA2C35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-15-git-send-email-yi.l.liu@intel.com>
 <aa1297cb-2bde-0cea-70a4-fc8f56d745e6@redhat.com>
In-Reply-To: <aa1297cb-2bde-0cea-70a4-fc8f56d745e6@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.230.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbf7e510-bd54-4bf3-7b9d-08d8427b403b
x-ms-traffictypediagnostic: DM5PR11MB1692:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1692C64D853C05EEE8AA3EB6C35F0@DM5PR11MB1692.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRF9zw2KXJ34PsVeUseR0hjndp+JmYBpAmr7Xl4kxL85gIYIbtZhsG//ni2r3ykCNlDO3rD3ZI32jOQ869EE0qZPTkJ6TpC9LZr6+dh8vAB46kCkBd+wwd7lfuI849hbPqV7dLljGH4/jMB2EBa4ypCFiTO2PAZR4hqmCfdcANKeHnvpiwZTKZqwcPgW+RLIKXTDv85o4ZyB3HLkN3WadXhP5rpR1wgWr7/mSTlJGAgL99mcrZ5aM+r3wga9X7mA8uANJKZvm9ZPBhxgpPYyd0Vt0IShPGDVgy4Ixqkw3bS/Jj/SAODJSEo7x8ftR74MZDFZyEQc41Deiv0vBD6paZ4AFm2zeufgDQszEUw3He0WYdzbf6+PmWp7+9Jf4hjMFkJPosfDsLBL8OfSwD+l3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(66446008)(110136005)(53546011)(64756008)(66476007)(2906002)(66556008)(55016002)(5660300002)(66946007)(6506007)(8676002)(26005)(7416002)(76116006)(54906003)(186003)(9686003)(71200400001)(478600001)(33656002)(316002)(966005)(8936002)(83380400001)(7696005)(86362001)(4326008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EFa56UcHlyqHgyMDfWpVnt5weAYw2NxfudldohvyjYo4E9ANCPq5lGAycMdSM4FMmxJofzF7WLkFlH3FNClDTdJUY62PX76XCP4OZ76arsz/43pLhQUpam5GdyzMl81iwUsPi7cyySiKTI9xhYReBEaXotGhOqRs6AqfWR7/b5iCN9Z9NV/fwh3nYL8jawPU05J7O/HaHc+oKgS1i+AuPtK73vcEiEOxMZ0ybAYmSpTsmCBEU141bf51nSzv0ZSglltNVPx9x0yC0Zf/AbE30J5/EnNGy+9EiQH0rlxMQWRalYeBwbXLY4AgVuWiWLKU3rpAqh1amwQ/Q32HzwvkNUcFlbuIGQNMm2pDQ9ggrwtgXUB2u9CCUW/L5xlbZq+dTqj2PXe2HXhk3MZrHYKuVsBtoR2raHF50BV33UrcPOSk8N8aEfv/JYEMEhLiB5FptZJaMklYid3yAqzkmGIr1kn4w/1yLMxSjHEcIsUxcruR7I79vUjzBX3SzR6dTDFQITi67k1gYywVm0Wzmfy6RmlCrXB4Qqs0aRoC/dM3+zHYsrT0EsnJpqeIKzFMc/6/vLYeuWYId+1kaiSNa+RPEsx8fszxRuNKLvZWP9rMQFlJVJsdv6BPCkuFuoQXZYwt/jM97E8k61I8Wn7MeT871g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf7e510-bd54-4bf3-7b9d-08d8427b403b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 07:00:39.7516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xt+jXQF+GL10Llpbn207afOMNs+OG2oRjDaHaMfBao6JGQrUnev7dlYjJAnV3EHYfFs5TwYytfUV9mzxjxOGAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1692
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFN1bmRheSwgQXVndXN0IDE2LCAyMDIwIDc6NTIgUE0NCj4gDQo+IEhpIFlpLA0KPiAN
Cj4gT24gNy8yOC8yMCA4OjI3IEFNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBGcm9tOiBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4NCj4gPiBUaGUgVkZJTyBBUEkgd2FzIGVu
aGFuY2VkIHRvIHN1cHBvcnQgbmVzdGVkIHN0YWdlIGNvbnRyb2w6IGEgYnVuY2ggb2Y+IG5ldw0K
PiBpb2N0bHMgYW5kIHVzYWdlIGd1aWRlbGluZS4NCj4gPg0KPiA+IExldCdzIGRvY3VtZW50IHRo
ZSBwcm9jZXNzIHRvIGZvbGxvdyB0byBzZXQgdXAgbmVzdGVkIG1vZGUuDQo+ID4NCj4gPiBDYzog
S2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQ0M6IEphY29iIFBhbiA8amFj
b2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxl
eC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJA
cmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBl
QGxpbmFyby5vcmc+DQo+ID4gQ2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KPiA+
IENjOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5
OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gdjUgLT4gdjY6DQo+
ID4gKikgdHdlYWsgcGVyIEVyaWMncyBjb21tZW50cy4NCj4gPg0KPiA+IHYzIC0+IHY0Og0KPiA+
ICopIGFkZCByZXZpZXctYnkgZnJvbSBTdGVmYW4gSGFqbm9jemkNCj4gPg0KPiA+IHYyIC0+IHYz
Og0KPiA+ICopIGFkZHJlc3MgY29tbWVudHMgZnJvbSBTdGVmYW4gSGFqbm9jemkNCj4gPg0KPiA+
IHYxIC0+IHYyOg0KPiA+ICopIG5ldyBpbiB2MiwgY29tcGFyZWQgd2l0aCBFcmljJ3Mgb3JpZ2lu
YWwgdmVyc2lvbiwgcGFzaWQgdGFibGUgYmluZA0KPiA+ICAgIGFuZCBmYXVsdCByZXBvcnRpbmcg
aXMgcmVtb3ZlZCBhcyB0aGlzIHNlcmllcyBkb2Vzbid0IGNvdmVyIHRoZW0uDQo+ID4gICAgT3Jp
Z2luYWwgdmVyc2lvbiBmcm9tIEVyaWMuDQo+ID4gICAgaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIw
MjAvMy8yMC83MDANCj4gPiAtLS0NCj4gPiAgRG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8u
cnN0IHwgNzUNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4g
IDEgZmlsZSBjaGFuZ2VkLCA3NSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
RG9jdW1lbnRhdGlvbi9kcml2ZXItYXBpL3ZmaW8ucnN0IGIvRG9jdW1lbnRhdGlvbi9kcml2ZXIt
YXBpL3ZmaW8ucnN0DQo+ID4gaW5kZXggZjFhNGQzYy4uYzBkNDNmMCAxMDA2NDQNCj4gPiAtLS0g
YS9Eb2N1bWVudGF0aW9uL2RyaXZlci1hcGkvdmZpby5yc3QNCj4gPiArKysgYi9Eb2N1bWVudGF0
aW9uL2RyaXZlci1hcGkvdmZpby5yc3QNCj4gPiBAQCAtMjM5LDYgKzIzOSw4MSBAQCBncm91cCBh
bmQgY2FuIGFjY2VzcyB0aGVtIGFzIGZvbGxvd3M6Og0KPiA+ICAJLyogR3JhdHVpdG91cyBkZXZp
Y2UgcmVzZXQgYW5kIGdvLi4uICovDQo+ID4gIAlpb2N0bChkZXZpY2UsIFZGSU9fREVWSUNFX1JF
U0VUKTsNCj4gPg0KPiA+ICtJT01NVSBEdWFsIFN0YWdlIENvbnRyb2wNCj4gPiArLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQo+ID4gKw0KPiA+ICtTb21lIElPTU1VcyBzdXBwb3J0IDIgc3RhZ2Vz
L2xldmVscyBvZiB0cmFuc2xhdGlvbi4gU3RhZ2UgY29ycmVzcG9uZHMNCj4gPiArdG8gdGhlIEFS
TSB0ZXJtaW5vbG9neSB3aGlsZSBsZXZlbCBjb3JyZXNwb25kcyB0byBJbnRlbCdzIHRlcm1pbm9s
b2d5Lg0KPiA+ICtJbiB0aGUgZm9sbG93aW5nIHRleHQgd2UgdXNlIGVpdGhlciB3aXRob3V0IGRp
c3RpbmN0aW9uLg0KPiA+ICsNCj4gPiArVGhpcyBpcyB1c2VmdWwgd2hlbiB0aGUgZ3Vlc3QgaXMg
ZXhwb3NlZCB3aXRoIGEgdmlydHVhbCBJT01NVSBhbmQgc29tZQ0KPiA+ICtkZXZpY2VzIGFyZSBh
c3NpZ25lZCB0byB0aGUgZ3Vlc3QgdGhyb3VnaCBWRklPLiBUaGVuIHRoZSBndWVzdCBPUyBjYW4N
Cj4gPiArdXNlIHN0YWdlLTEgKEdJT1ZBIC0+IEdQQSBvciBHVkEtPkdQQSksIHdoaWxlIHRoZSBo
eXBlcnZpc29yIHVzZXMgc3RhZ2UNCj4gPiArMiBmb3IgVk0gaXNvbGF0aW9uIChHUEEgLT4gSFBB
KS4NCj4gPiArDQo+ID4gK1VuZGVyIGR1YWwgc3RhZ2UgdHJhbnNsYXRpb24sIHRoZSBndWVzdCBn
ZXRzIG93bmVyc2hpcCBvZiB0aGUgc3RhZ2UtMSBwYWdlDQo+ID4gK3RhYmxlcyBhbmQgYWxzbyBv
d25zIHN0YWdlLTEgY29uZmlndXJhdGlvbiBzdHJ1Y3R1cmVzLiBUaGUgaHlwZXJ2aXNvciBvd25z
DQo+ID4gK3RoZSByb290IGNvbmZpZ3VyYXRpb24gc3RydWN0dXJlIChmb3Igc2VjdXJpdHkgcmVh
c29uKSwgaW5jbHVkaW5nIHN0YWdlLTINCj4gPiArY29uZmlndXJhdGlvbi4NCj4gVGhpcyBpcyBv
bmx5IHRydWUgZm9yIHZ0ZC4gT24gQVJNIHRoZSBzdGFnZTIgY2ZnIGlzIHRoZSBDb250ZXh0DQo+
IERlc2NyaXB0b3IgdGFibGUgKGFrYSBQQVNJRCB0YWJsZSkuIHJvb3QgY2ZnIG9ubHkgc3RvcmUg
dGhlIEdQQSBvZiB0aGUNCj4gQ0QgdGFibGUuDQoNCkkndmUgYSBjaGVjayB3aXRoIHlvdSBvbiB0
aGUgbWVhbmluZyBvZiAiY29uZmlndXJhdGlvbiBzdHJ1Y3R1cmVzIi4NCkZvciBWdC1kLCBkb2Vz
IGl0IG1lYW4gdGhlIHJvb3QgdGFibGUvY29udGV4dCB0YWJsZS9wYXNpZCB0YWJsZT8gaWYNCkkn
bSBjb3JyZWN0LCB0aGVuIGhvdyBhYm91dCBiZWxvdyBkZXNjcmlwdGlvbj8NCg0KIlVuZGVyIGR1
YWwgc3RhZ2UgdHJhbnNsYXRpb24sIHRoZSBndWVzdCBnZXRzIG93bmVyc2hpcCBvZiB0aGUgc3Rh
Z2UtMQ0KY29uZmlndXJhdGlvbiBzdHJ1Y3R1cmVzIG9yIHBhZ2UgdGFibGVzLiBUaGlzIGRlcGVu
ZHMgb24gdmVuZG9yLiBUaGUNCmh5cGVydmlzb3Igb3ducyB0aGUgcm9vdCBjb25maWd1cmF0aW9u
IHN0cnVjdHVyZSAoZm9yIHNlY3VyaXR5IHJlYXNvbiksDQppbmNsdWRpbmcgc3RhZ2UtMiBjb25m
aWd1cmF0aW9uLiINCg0KPiAgVGhpcyB3b3JrcyBhcyBsb25nIGFzIGNvbmZpZ3VyYXRpb24gc3Ry
dWN0dXJlcyBhbmQgcGFnZSB0YWJsZQ0KPiA+ICtmb3JtYXRzIGFyZSBjb21wYXRpYmxlIGJldHdl
ZW4gdGhlIHZpcnR1YWwgSU9NTVUgYW5kIHRoZSBwaHlzaWNhbCBJT01NVS4NCj4gPiArDQo+ID4g
K0Fzc3VtaW5nIHRoZSBIVyBzdXBwb3J0cyBpdCwgdGhpcyBuZXN0ZWQgbW9kZSBpcyBzZWxlY3Rl
ZCBieSBjaG9vc2luZyB0aGUNCj4gPiArVkZJT19UWVBFMV9ORVNUSU5HX0lPTU1VIHR5cGUgdGhy
b3VnaDoNCj4gPiArDQo+ID4gKyAgICBpb2N0bChjb250YWluZXIsIFZGSU9fU0VUX0lPTU1VLCBW
RklPX1RZUEUxX05FU1RJTkdfSU9NTVUpOw0KPiA+ICsNCj4gPiArVGhpcyBmb3JjZXMgdGhlIGh5
cGVydmlzb3IgdG8gdXNlIHRoZSBzdGFnZS0yLCBsZWF2aW5nIHN0YWdlLTEgYXZhaWxhYmxlDQo+
ID4gK2ZvciBndWVzdCB1c2FnZS4gVGhlIHN0YWdlLTEgZm9ybWF0IGFuZCBiaW5kaW5nIG1ldGhv
ZCBhcmUgdmVuZG9yIHNwZWNpZmljDQo+IC4gVGhlcmUgYXJlIHJlcG9ydGVkIGluIHRoZSBuZXN0
aW5nIGNhcGFiaWxpdHkgLi4uDQoNCmdvdCBpdC4NCg0KIlRoZSBzdGFnZS0xIGZvcm1hdCBhbmQg
YmluZGluZyBtZXRob2QgYXJlIHJlcG9ydGVkIGluIG5lc3RpbmcgY2FwYWJpbGl0eS4iDQoNCj4g
PiArYW5kIHJlcG9ydGVkIGluIG5lc3RpbmcgY2FwIChWRklPX0lPTU1VX1RZUEUxX0lORk9fQ0FQ
X05FU1RJTkcpIHRocm91Z2gNCj4gPiArVkZJT19JT01NVV9HRVRfSU5GTzoNCj4gPiArDQo+ID4g
KyAgICBpb2N0bChjb250YWluZXItPmZkLCBWRklPX0lPTU1VX0dFVF9JTkZPLCAmbmVzdGluZ19p
bmZvKTsNCj4gPiArDQo+ID4gK1RoZSBuZXN0aW5nIGNhcCBpbmZvIGlzIGF2YWlsYWJsZSBvbmx5
IGFmdGVyIE5FU1RJTkdfSU9NTVUgaXMgc2VsZWN0ZWQuDQo+ID4gK0lmIHVuZGVybHlpbmcgSU9N
TVUgZG9lc24ndCBzdXBwb3J0IG5lc3RpbmcsIFZGSU9fU0VUX0lPTU1VIGZhaWxzIGFuZA0KPiBJ
ZiB0aGUgdW5kZXJseWluZw0KDQpnb3QgaXQuDQoNCj4gPiArdXNlcnNwYWNlIHNob3VsZCB0cnkg
b3RoZXIgSU9NTVUgdHlwZXMuIERldGFpbHMgb2YgdGhlIG5lc3RpbmcgY2FwIGluZm8NCj4gPiAr
Y2FuIGJlIGZvdW5kIGluIERvY3VtZW50YXRpb24vdXNlcnNwYWNlLWFwaS9pb21tdS5yc3QuDQo+
ID4gKw0KPiA+ICtUaGUgc3RhZ2UtMSBwYWdlIHRhYmxlIGNhbiBiZSBib3VuZCB0byB0aGUgSU9N
TVUgaW4gdHdvIG1ldGhvZHM6IGRpcmVjdGx5Pg0KPiArb3IgaW5kaXJlY3RseS4gRGlyZWN0IGJp
bmRpbmcgcmVxdWlyZXMgdXNlcnNwYWNlIHRvIG5vdGlmeSBWRklPIG9mIGV2ZXJ5DQo+IE5vdCBz
dXJlIHdlIHNoYWxsIHVzZSB0aGlzIGRpcmVjdC9pbmRpcmVjdCB0ZXJtaW5vbG9neS4gSSBkb24n
dCB0aGluaw0KPiB0aGlzIGlzIHBhcnQgb2YgZWl0aGVyIEFSTSBvciBJbnRlbCBTUEVDLg0KPiAN
Cj4gU3VnZ2VzdGlvbjogT24gSW50ZWwsIHRoZSBzdGFnZTEgcGFnZSB0YWJsZSBpbmZvIGFyZSBt
ZWRpYXRlZCBieSB0aGUNCj4gdXNlcnNwYWNlIGZvciBlYWNoIFBBU0lELiBPbiBBUk0sIHRoZSB1
c2Vyc3BhY2UgZGlyZWN0bHkgcGFzc2VzIHRoZSBHUEENCj4gb2YgdGhlIHdob2xlIFBBU0lEIHRh
YmxlLiBDdXJyZW50bHkgb25seSBJbnRlbCdzIGJpbmRpbmcgaXMgc3VwcG9ydGVkLg0KDQpnb3Qg
aXQuIHRoaXMgaXMgd2hhdCB3ZSB3YW50IHRvIHNheSBieSBkaXRlY3QvaW5kaXJlY3QgdGVybWlu
b2xvZ3kuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0KPiA+ICtndWVzdCBzdGFnZS0xIHBhZ2UgdGFi
bGUgYmluZGluZywgd2hpbGUgaW5kaXJlY3QgYmluZGluZyBhbGxvd3MgdXNlcnNwYWNlDQo+ID4g
K3RvIGJpbmQgb25jZSB3aXRoIGFuIGludGVybWVkaWF0ZSBzdHJ1Y3R1cmUgKGUuZy4gUEFTSUQg
dGFibGUpIHdoaWNoDQo+ID4gK2luZGlyZWN0bHkgbGlua3MgdG8gZ3Vlc3Qgc3RhZ2UtMSBwYWdl
IHRhYmxlcy4gVGhlIGFjdHVhbCBiaW5kaW5nIG1ldGhvZA0KPiA+ICtkZXBlbmRzIG9uIElPTU1V
IHZlbmRvci4gQ3VycmVudGx5IG9ubHkgdGhlIGRpcmVjdCBiaW5kaW5nIGNhcGFiaWxpdHkgKA0K
PiA+ICtJT01NVV9ORVNUSU5HX0ZFQVRfQklORF9QR1RCTCkgaXMgc3VwcG9ydGVkOg0KPiA+ICsN
Cj4gPiArICAgIG5lc3Rpbmdfb3AtPmZsYWdzID0gVkZJT19JT01NVV9ORVNUSU5HX09QX0JJTkRf
UEdUQkw7DQo+ID4gKyAgICBtZW1jcHkoJm5lc3Rpbmdfb3AtPmRhdGEsICZiaW5kX2RhdGEsIHNp
emVvZihiaW5kX2RhdGEpKTsNCj4gPiArICAgIGlvY3RsKGNvbnRhaW5lci0+ZmQsIFZGSU9fSU9N
TVVfTkVTVElOR19PUCwgbmVzdGluZ19vcCk7DQo+ID4gKw0KPiA+ICtXaGVuIG11bHRpcGxlIHN0
YWdlLTEgcGFnZSB0YWJsZXMgYXJlIHN1cHBvcnRlZCBvbiBhIGRldmljZSwgZWFjaCBwYWdlDQo+
ID4gK3RhYmxlIGlzIGFzc29jaWF0ZWQgd2l0aCBhIFBBU0lEIChQcm9jZXNzIEFkZHJlc3MgU3Bh
Y2UgSUQpIHRvIGRpZmZlcmVudGlhdGUNCj4gPiArd2l0aCBlYWNoIG90aGVyLiBJbiBzdWNoIGNh
c2UsIHVzZXJzcGFjZSBzaG91bGQgaW5jbHVkZSBQQVNJRCBpbiB0aGUNCj4gPiArYmluZF9kYXRh
IHdoZW4gaXNzdWluZyBkaXJlY3QgYmluZGluZyByZXF1ZXN0Lg0KPiA+ICsNCj4gPiArUEFTSUQg
Y291bGQgYmUgbWFuYWdlZCBwZXItZGV2aWNlIG9yIHN5c3RlbS13aWRlIHdoaWNoLCBhZ2Fpbiwg
ZGVwZW5kcyBvbg0KPiA+ICtJT01NVSB2ZW5kb3IgYW5kIGlzIHJlcG9ydGVkIGluIG5lc3Rpbmcg
Y2FwIGluZm8uIFdoZW4gc3lzdGVtLXdpZGUgcG9saWN5DQo+ID4gK2lzIHJlcG9ydGVkIChJT01N
VV9ORVNUSU5HX0ZFQVRfU1lTV0lERV9QQVNJRCksIGUuZy4gYXMgYnkgSW50ZWwgcGxhdGZvcm1z
LA0KPiA+ICt1c2Vyc3BhY2UgKm11c3QqIGFsbG9jYXRlIFBBU0lEIGZyb20gVkZJTyBiZWZvcmUg
YXR0ZW1wdGluZyBiaW5kaW5nIG9mDQo+ID4gK3N0YWdlLTEgcGFnZSB0YWJsZToNCj4gPiArDQo+
ID4gKyAgICByZXEuZmxhZ3MgPSBWRklPX0lPTU1VX0FMTE9DX1BBU0lEOw0KPiA+ICsgICAgaW9j
dGwoY29udGFpbmVyLCBWRklPX0lPTU1VX1BBU0lEX1JFUVVFU1QsICZyZXEpOw0KPiA+ICsNCj4g
PiArT25jZSB0aGUgc3RhZ2UtMSBwYWdlIHRhYmxlIGlzIGJvdW5kIHRvIHRoZSBJT01NVSwgdGhl
IGd1ZXN0IGlzIGFsbG93ZWQgdG8NCj4gPiArZnVsbHkgbWFuYWdlIGl0cyBtYXBwaW5nIGF0IGl0
cyBkaXNwb3NhbC4gVGhlIElPTU1VIHdhbGtzIG5lc3RlZCBzdGFnZS0xDQo+ID4gK2FuZCBzdGFn
ZS0yIHBhZ2UgdGFibGVzIHdoZW4gc2VydmluZyBETUEgcmVxdWVzdHMgZnJvbSBhc3NpZ25lZCBk
ZXZpY2UsIGFuZA0KPiA+ICttYXkgY2FjaGUgdGhlIHN0YWdlLTEgbWFwcGluZyBpbiB0aGUgSU9U
TEIuIFdoZW4gcmVxdWlyZWQgKElPTU1VX05FU1RJTkdfDQo+ID4gK0ZFQVRfQ0FDSEVfSU5WTEQp
LCB1c2Vyc3BhY2UgKm11c3QqIGZvcndhcmQgZ3Vlc3Qgc3RhZ2UtMSBpbnZhbGlkYXRpb24gdG8N
Cj4gPiArdGhlIGhvc3QsIHNvIHRoZSBJT1RMQiBpcyBpbnZhbGlkYXRlZDoNCj4gPiArDQo+ID4g
KyAgICBuZXN0aW5nX29wLT5mbGFncyA9IFZGSU9fSU9NTVVfTkVTVElOR19PUF9DQUNIRV9JTlZM
RDsNCj4gPiArICAgIG1lbWNweSgmbmVzdGluZ19vcC0+ZGF0YSwgJmNhY2hlX2ludl9kYXRhLCBz
aXplb2YoY2FjaGVfaW52X2RhdGEpKTsNCj4gPiArICAgIGlvY3RsKGNvbnRhaW5lci0+ZmQsIFZG
SU9fSU9NTVVfTkVTVElOR19PUCwgbmVzdGluZ19vcCk7DQo+ID4gKw0KPiA+ICtGb3J3YXJkZWQg
aW52YWxpZGF0aW9ucyBjYW4gaGFwcGVuIGF0IHZhcmlvdXMgZ3JhbnVsYXJpdHkgbGV2ZWxzIChw
YWdlDQo+ID4gK2xldmVsLCBjb250ZXh0IGxldmVsLCBldGMuKQ0KPiA+ICsNCj4gPiAgVkZJTyBV
c2VyIEFQSQ0KPiA+ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4NCj4gPg0KPiBUaGFua3MN
Cj4gDQo+IEVyaWMNCg0K

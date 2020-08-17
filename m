Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CF0245C80
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 08:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgHQGbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 02:31:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:36276 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgHQGbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 02:31:11 -0400
IronPort-SDR: iOhTQt2UHWAliP9FODUb+mj46CbajW+xOlYOkenHho/dFJn6+9SNKt7OBUpknqs+0vvA04dNeq
 fLm4/0DRG55g==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="152291394"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="152291394"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 23:30:58 -0700
IronPort-SDR: 9sjl7DlZBUVxhluMHW76zwsi3g8unUv+RrUGcTu3e+2UUvCe2GEgMrQQ356/bgUJVXljCjbXjC
 1Ulmi8PeqDnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="336188149"
Received: from fmsmsx601-2.cps.intel.com (HELO fmsmsx601.amr.corp.intel.com) ([10.18.84.211])
  by orsmga007.jf.intel.com with ESMTP; 16 Aug 2020 23:30:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 16 Aug 2020 23:30:57 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 16 Aug 2020 23:30:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx156.amr.corp.intel.com (10.18.116.74) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 16 Aug 2020 23:30:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 16 Aug 2020 23:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmHFxDlqna3cYMyqy3k1IdYjCfBnWN2hWejirG3/5g1ZEusR6D/V8qFMTRknNM3aIBw+wPNh8Qa1K6swZpqxXDw75UiBJA+WuW1p8l3QZyZADrNH8YrML1++g1PqxoTHjcoYcbCg9GOioFMBXSjqLoqeT4vB7X2WGNHa0B/QBlEov1lTJzkvxzbS7ZaBkxpvmUnCFyc9s7dyEprDo/55/Fx2PsAKbsV1ZrTW7hbRqrPfIa+oeu+2tl6QBMKFTakfDgRQzJGbWdPHpSE+wzTG3IV3sRdSj0oLzahBUE+XuPWUfrFU8RVum0FjnSDeeSqUMQB+t2YABMsYZ9g2SJTCSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovIARKH7ArULcoswuEAyiCeLregs4RoiRzn425UzWnc=;
 b=G6l1zICFtVl1EPsm50QAIAOdK8yKu0phVAPGgnSD3/LB1fa6LX39cORyds9qC57KkO0U61ABYic/EErgKbtZ8FSYdBf7A8+HuVfDvamI4UfDpkcwznDpaK+HwW069i4GcWI0QrU2du1lf6bXpqKZ8sO8Fau7sr7RuvP4eX8Rxn60RAjkVgnnRpyJltUYUIZLyzg3zbyHEiIKGFb0uFLW9kEqqNp8Yf2WdQfVamY2XRGa9o/IcGWz1x3tkBiEw1F+hUY8XYhccnLDmBEWI7wxRUebwPngUWuToP1ns1GiY2jFD/L2Zy7xXWeTiQEgXJlc+H8gIUZuEhtckTaxjmKM3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovIARKH7ArULcoswuEAyiCeLregs4RoiRzn425UzWnc=;
 b=EwMXGgKNzjx/iaFX9nIk9/xMUek1kSTbWoQMRUHkAALE+ANlWx+MXVYMBarPYybUsrJQmA+uCCykmJ70NCQChYFS6bLqKcfa9gAWeUTdBRngBTVkNrFFmD99j3e0/BdKJdBwm+W+Sjqlbc3maNLRUfu7btBNENqFNR06k0pzXRM=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4441.namprd11.prod.outlook.com (2603:10b6:5:200::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.15; Mon, 17 Aug 2020 06:30:56 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3283.027; Mon, 17 Aug
 2020 06:30:56 +0000
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
Subject: RE: [PATCH v6 11/15] vfio/type1: Allow invalidating first-level/stage
 IOMMU cache
Thread-Topic: [PATCH v6 11/15] vfio/type1: Allow invalidating
 first-level/stage IOMMU cache
Thread-Index: AQHWZKdIe1LgYQpv3k6k7A0drA9ljak6uVmAgAE0uTA=
Date:   Mon, 17 Aug 2020 06:30:55 +0000
Message-ID: <DM5PR11MB14352249DD871385C7811782C35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-12-git-send-email-yi.l.liu@intel.com>
 <f0c7cfc1-ee6b-c98e-77bd-1af3dbaf2a6f@redhat.com>
In-Reply-To: <f0c7cfc1-ee6b-c98e-77bd-1af3dbaf2a6f@redhat.com>
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
x-ms-office365-filtering-correlation-id: 843acc68-68e0-4c40-84bd-08d8427718fc
x-ms-traffictypediagnostic: DM6PR11MB4441:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4441D1FA74D4419C1704191BC35F0@DM6PR11MB4441.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ML86/xSMPEhwFUcsvVCoaxX9WWKe+usVMsEC9AdNopuS3UUtWnWlHm3m7yxyHAMCAORuPcTRtkR+DQFTpBCVtZwUJ48AOOrkm2r0HhQbNUCU416ba3PyKZAk9Oi3u4QL0F82E16lIjd1srgeY7LiOxxooVZJPP19f9zi4wBU8+zYxxmwkdDMVSM4Hge/jAWcmTV4Krtk1ofQOJ7pMseaqgBtFG2jPfNN3kqv0j4zAXGMEtr+KV1mP2JnHDZRzfQLlVCzTcSyM32XaKIhcxhgVfoNyvNsjm2Hwy8p3S8s5CO65FZsVG/DPgXXb1A/bvVs5fSZV9MBeDAo9UB56xduBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(4326008)(2906002)(33656002)(83380400001)(66946007)(66446008)(8676002)(64756008)(66556008)(66476007)(76116006)(86362001)(8936002)(110136005)(478600001)(54906003)(5660300002)(7416002)(71200400001)(53546011)(55016002)(7696005)(6506007)(26005)(52536014)(9686003)(186003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8HUaknad7GIy5Sjfjj5gDpnv/TZqBmuoZSuOexFGKlDX/HWxm+PMgvOzXcJ9Tg92BVoTOi5N6YvUczCVELKNNT6KHnAOQfGxc8eDNryAs5Yexh6QhR7hmn4xoa2kbNVekoiQGrdXDA2gJ9Nwf8TZM3/3H+n1AkfhtWFN9k0dW65WuxnvK1kDvzmGbyoJNQDalC/+HrhiQRjB1gclklU5IeHohWQaTegMyiuCR77NF00VmqM3btGtpHWB1SdE6YhuK3HgO0dTozld1Eo+wBLlc98UbJvfyJgo5EjQFvSOSfuQLRinet4WUxSQj8BrPEjDWYonZqvo/xSo3J9rtcNRYv6sh8eFj2Z9QQcwg0S+7ZlQtvorkD5LWpr6O7hKh1ZEK7r6gYFoDvfYdfJTw3T9qdYahVyO4xv5tYlxAzsttLYnY/1Yn94MzzMU2ZgyVYv3qWzFBkKTIZj/XH7rjiniL3UekRubCUTPq7g8MQJAC2aJ03R4s5xzQI1BVtF/mFDiYKGK2v7djVSfKRGlmAlEUzcYhzppm3lUOPH81+Iwbxj1o6vqnsZkQGZAicYeGnGs8aySPxewLxRPU3yIHVXj4Efb6Nx6mp7piVVljKq8vRyrgIC8ZOnm5xFnJaYOx5xx8LTQllXV26Ov/8hZRijk8Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843acc68-68e0-4c40-84bd-08d8427718fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 06:30:55.9509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qeq+TgVSevLdUYo1PxT+LZ/+z2yl3KTSKx9QqkwrPzL9ZW2q/puuNOTIzvsLn5X2RGE9SI/flrCLKUmAE15fIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4441
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFN1bmRheSwgQXVndXN0IDE2LCAyMDIwIDc6MzUgUE0NCj4gDQo+IEhpIFlpLA0KPiAN
Cj4gT24gNy8yOC8yMCA4OjI3IEFNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIHBy
b3ZpZGVzIGFuIGludGVyZmFjZSBhbGxvd2luZyB0aGUgdXNlcnNwYWNlIHRvIGludmFsaWRhdGUN
Cj4gPiBJT01NVSBjYWNoZSBmb3IgZmlyc3QtbGV2ZWwgcGFnZSB0YWJsZS4gSXQgaXMgcmVxdWly
ZWQgd2hlbiB0aGUgZmlyc3QNCj4gPiBsZXZlbCBJT01NVSBwYWdlIHRhYmxlIGlzIG5vdCBtYW5h
Z2VkIGJ5IHRoZSBob3N0IGtlcm5lbCBpbiB0aGUgbmVzdGVkDQo+ID4gdHJhbnNsYXRpb24gc2V0
dXAuDQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4g
Q0M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEFs
ZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMg
QXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGlsaXBwZSBCcnVj
a2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4gQ2M6IEpvZXJnIFJvZWRlbCA8am9y
b0A4Ynl0ZXMub3JnPg0KPiA+IENjOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4g
U2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+
ID4gLS0tDQo+ID4gdjEgLT4gdjI6DQo+ID4gKikgcmVuYW1lIGZyb20gInZmaW8vdHlwZTE6IEZs
dXNoIHN0YWdlLTEgSU9NTVUgY2FjaGUgZm9yIG5lc3RpbmcgdHlwZSINCj4gPiAqKSByZW5hbWUg
dmZpb19jYWNoZV9pbnZfZm4oKSB0byB2ZmlvX2Rldl9jYWNoZV9pbnZhbGlkYXRlX2ZuKCkNCj4g
PiAqKSB2ZmlvX2Rldl9jYWNoZV9pbnZfZm4oKSBhbHdheXMgc3VjY2Vzc2Z1bA0KPiA+ICopIHJl
bW92ZSBWRklPX0lPTU1VX0NBQ0hFX0lOVkFMSURBVEUsIGFuZCByZXVzZQ0KPiBWRklPX0lPTU1V
X05FU1RJTkdfT1ANCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEu
YyB8IDQyDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4g
IGluY2x1ZGUvdWFwaS9saW51eC92ZmlvLmggICAgICAgfCAgMyArKysNCj4gPiAgMiBmaWxlcyBj
aGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92
ZmlvL3ZmaW9faW9tbXVfdHlwZTEuYw0KPiA+IGIvZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlw
ZTEuYyBpbmRleCAyNDU0MzZlLi5iZjk1YTBmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmZp
by92ZmlvX2lvbW11X3R5cGUxLmMNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90
eXBlMS5jDQo+ID4gQEAgLTMwNTYsNiArMzA1Niw0NSBAQCBzdGF0aWMgbG9uZyB2ZmlvX2lvbW11
X2hhbmRsZV9wZ3RibF9vcChzdHJ1Y3QNCj4gdmZpb19pb21tdSAqaW9tbXUsDQo+ID4gIAlyZXR1
cm4gcmV0Ow0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIGludCB2ZmlvX2Rldl9jYWNoZV9pbnZh
bGlkYXRlX2ZuKHN0cnVjdCBkZXZpY2UgKmRldiwgdm9pZA0KPiA+ICsqZGF0YSkgew0KPiA+ICsJ
c3RydWN0IGRvbWFpbl9jYXBzdWxlICpkYyA9IChzdHJ1Y3QgZG9tYWluX2NhcHN1bGUgKilkYXRh
Ow0KPiA+ICsJdW5zaWduZWQgbG9uZyBhcmcgPSAqKHVuc2lnbmVkIGxvbmcgKilkYy0+ZGF0YTsN
Cj4gPiArDQo+ID4gKwlpb21tdV91YXBpX2NhY2hlX2ludmFsaWRhdGUoZGMtPmRvbWFpbiwgZGV2
LCAodm9pZCBfX3VzZXIgKilhcmcpOw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+
ID4gK3N0YXRpYyBsb25nIHZmaW9faW9tbXVfaW52YWxpZGF0ZV9jYWNoZShzdHJ1Y3QgdmZpb19p
b21tdSAqaW9tbXUsDQo+ID4gKwkJCQkJdW5zaWduZWQgbG9uZyBhcmcpDQo+ID4gK3sNCj4gPiAr
CXN0cnVjdCBkb21haW5fY2Fwc3VsZSBkYyA9IHsgLmRhdGEgPSAmYXJnIH07DQo+ID4gKwlzdHJ1
Y3QgaW9tbXVfbmVzdGluZ19pbmZvICppbmZvOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4g
KwltdXRleF9sb2NrKCZpb21tdS0+bG9jayk7DQo+ID4gKwkvKg0KPiA+ICsJICogQ2FjaGUgaW52
YWxpZGF0aW9uIGlzIHJlcXVpcmVkIGZvciBhbnkgbmVzdGluZyBJT01NVSwNCj4gU28gd2h5IGRv
IHdlIGV4cG9zZSB0aGUgSU9NTVVfTkVTVElOR19GRUFUX0NBQ0hFX0lOVkxEIGNhcGFiaWxpdHk/
IDotKQ0KDQppdCdzIGEgc3RhbGUgY29tbWVudC4gc2hvdWxkIGJlIHJlbW92ZWQuIDotKQ0KDQo+
ID4gKwkgKiBzbyBubyBuZWVkIHRvIGNoZWNrIHN5c3RlbS13aWRlIFBBU0lEIHN1cHBvcnQuDQo+
ID4gKwkgKi8NCj4gPiArCWluZm8gPSBpb21tdS0+bmVzdGluZ19pbmZvOw0KPiA+ICsJaWYgKCFp
bmZvIHx8ICEoaW5mby0+ZmVhdHVyZXMgJiBJT01NVV9ORVNUSU5HX0ZFQVRfQ0FDSEVfSU5WTEQp
KSB7DQo+ID4gKwkJcmV0ID0gLUVPUE5PVFNVUFA7DQo+ID4gKwkJZ290byBvdXRfdW5sb2NrOw0K
PiA+ICsJfQ0KPiA+ICsNCj4gPiArCXJldCA9IHZmaW9fZ2V0X25lc3RpbmdfZG9tYWluX2NhcHN1
bGUoaW9tbXUsICZkYyk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCWdvdG8gb3V0X3VubG9jazsN
Cj4gPiArDQo+ID4gKwlpb21tdV9ncm91cF9mb3JfZWFjaF9kZXYoZGMuZ3JvdXAtPmlvbW11X2dy
b3VwLCAmZGMsDQo+ID4gKwkJCQkgdmZpb19kZXZfY2FjaGVfaW52YWxpZGF0ZV9mbik7DQo+ID4g
Kw0KPiA+ICtvdXRfdW5sb2NrOg0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZpb21tdS0+bG9jayk7DQo+
ID4gKwlyZXR1cm4gcmV0Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgbG9uZyB2ZmlvX2lv
bW11X3R5cGUxX25lc3Rpbmdfb3Aoc3RydWN0IHZmaW9faW9tbXUgKmlvbW11LA0KPiA+ICAJCQkJ
CXVuc2lnbmVkIGxvbmcgYXJnKQ0KPiA+ICB7DQo+ID4gQEAgLTMwNzgsNiArMzExNyw5IEBAIHN0
YXRpYyBsb25nIHZmaW9faW9tbXVfdHlwZTFfbmVzdGluZ19vcChzdHJ1Y3QNCj4gdmZpb19pb21t
dSAqaW9tbXUsDQo+ID4gIAljYXNlIFZGSU9fSU9NTVVfTkVTVElOR19PUF9VTkJJTkRfUEdUQkw6
DQo+ID4gIAkJcmV0ID0gdmZpb19pb21tdV9oYW5kbGVfcGd0Ymxfb3AoaW9tbXUsIGZhbHNlLCBh
cmcgKyBtaW5zeik7DQo+ID4gIAkJYnJlYWs7DQo+ID4gKwljYXNlIFZGSU9fSU9NTVVfTkVTVElO
R19PUF9DQUNIRV9JTlZMRDoNCj4gPiArCQlyZXQgPSB2ZmlvX2lvbW11X2ludmFsaWRhdGVfY2Fj
aGUoaW9tbXUsIGFyZyArIG1pbnN6KTsNCj4gPiArCQlicmVhazsNCj4gPiAgCWRlZmF1bHQ6DQo+
ID4gIAkJcmV0ID0gLUVJTlZBTDsNCj4gPiAgCX0NCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91
YXBpL2xpbnV4L3ZmaW8uaCBiL2luY2x1ZGUvdWFwaS9saW51eC92ZmlvLmgNCj4gPiBpbmRleCA5
NTAxY2ZiLi40OGUyZmI1IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC92Zmlv
LmgNCj4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oDQo+ID4gQEAgLTEyMjUsNiAr
MTIyNSw4IEBAIHN0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX3Bhc2lkX3JlcXVlc3Qgew0KPiA+ICAg
KiArLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0rDQo+ID4gICAqIHwgVU5CSU5EX1BHVEJMICAgIHwgICAgICBzdHJ1Y3QgaW9t
bXVfZ3Bhc2lkX2JpbmRfZGF0YSAgICAgICAgICAgIHwNCj4gPiAgICoNCj4gPiArLS0tLS0tLS0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0r
DQo+ID4gKyAqIHwgQ0FDSEVfSU5WTEQgICAgIHwgICAgICBzdHJ1Y3QgaW9tbXVfY2FjaGVfaW52
YWxpZGF0ZV9pbmZvICAgICAgIHwNCj4gPiArICoNCj4gPiArICstLS0tLS0tLS0tLS0tLS0tLSst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsNCj4gPiAgICoN
Cj4gPiAgICogcmV0dXJuczogMCBvbiBzdWNjZXNzLCAtZXJybm8gb24gZmFpbHVyZS4NCj4gPiAg
ICovDQo+ID4gQEAgLTEyMzcsNiArMTIzOSw3IEBAIHN0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX25l
c3Rpbmdfb3Agew0KPiA+DQo+ID4gICNkZWZpbmUgVkZJT19JT01NVV9ORVNUSU5HX09QX0JJTkRf
UEdUQkwJKDApDQo+ID4gICNkZWZpbmUgVkZJT19JT01NVV9ORVNUSU5HX09QX1VOQklORF9QR1RC
TAkoMSkNCj4gPiArI2RlZmluZSBWRklPX0lPTU1VX05FU1RJTkdfT1BfQ0FDSEVfSU5WTEQJKDIp
DQo+IEFjY29yZGluZyB0byBteSBwcmV2aW91cyBjb21tZW50LCB5b3UgbWF5IHJlZmluZSBWRklP
X05FU1RJTkdfT1BfTUFTSyB0b28NCg0KeWVzLCBJJ3ZlIG5vdGljZWQgaXQuIGFsc28gcmVwbGll
ZCBpbiBwYXRjaCAxMC8xNS4NCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+IFRoYW5rcw0KPiANCj4g
RXJpYw0KPiA+DQo+ID4gICNkZWZpbmUgVkZJT19JT01NVV9ORVNUSU5HX09QCQlfSU8oVkZJT19U
WVBFLCBWRklPX0JBU0UgKyAxOSkNCj4gPg0KPiA+DQoNCg==

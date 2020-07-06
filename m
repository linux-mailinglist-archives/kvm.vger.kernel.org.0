Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19D1215790
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 14:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgGFMsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 08:48:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:12531 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgGFMsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 08:48:00 -0400
IronPort-SDR: rBjzSfHDei3DsWmB+MZlzvpkDHf/ggaw1/1Iv1h98GGklSSmMbirYeT/qvl6qD8X6Ild65ywG3
 CZbIPi85WdFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9673"; a="144912050"
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="144912050"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:47:58 -0700
IronPort-SDR: SiADBshIJ1U/v9lDc6V7Uuzar9kO05jKjiQYWssqcKf+QRswSOtCfNbPGltf7ivngvVbmNpaoW
 rD8IrWi473tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="456711916"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga005.jf.intel.com with ESMTP; 06 Jul 2020 05:47:58 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Jul 2020 05:47:57 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 6 Jul 2020 05:47:57 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 6 Jul 2020 05:47:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 6 Jul 2020 05:47:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hu9X7CU/ZW75n4voCvt5a1danbn2r6Z1crb/AQezn/XXltrzDINFzsy+2QX17ZVVVGXVG2rPcnpIK7YFjKoMbgqGBc8AqYriBbkQbm1Ax/oq58TkH/SHyom7Nzji9o9hm+B3kj3hC5mR5YXMQ04xiGJAk2nv/udnqAh6emSDM3ztWFJeTLp1sqyrZFuKxdG+rpWfN8K3SvtcKdonQGBQH6CFn53zPKQOSHPaN4hVJ0W4f4Xm9Y6U/jEsijC7kXzMTzwc4pg5iyE4juG2TGJJ1nlsi45GqDB/76CYOJ2xEFhDorImwjCO5Kes9Zr3DkIUc/4Xq+cJAcyGchrRNdlVcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uP6rmP0bFLpktkYaR4+8WjiyZaqwH0MJcvL+sFLWIhQ=;
 b=ng+wWXdlVR41kIopKj5alEghOrZGA2QEUO65eFaU739GQLiDE7ao+42/DPsadaSO7AXw2MEPismauTJ4aajZgpdKvGOqusk5bSVVupptD3dN7vfSQW/0vSnY4UxUPDkRym+CA8fAP+KlM6j/LayH++MIgM+cN2CyOm2RuytQlFS0MjVJKhOsz7NWnGS37ghfpGHg2ZOLCX5u16Gar3Omla03SflhHyVCyWAbXyGYVxyY6drtyb2lHOQ4RpODuyuI2seNy4Kq5lkmyYMc+loAGJi5YHFG2zHF3kjCz+hIzEOwJxmC56EDw37dD7paaWP69WRIR5df1Lb836K/d7LcwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uP6rmP0bFLpktkYaR4+8WjiyZaqwH0MJcvL+sFLWIhQ=;
 b=PH/NZuYrRE61ttwZ/I7IysiJ6MLX6r56V7nhcTK8Z3fCOjoiZjeoC4gLjWKr2zH2L4eOq581UaGZYB/6iF/HSD2PBgPAgQQYOYXL04735+UYrtBeI66wBwkVpF6t/OLqTMEFt3u4ij0Jh4FFvOu6aen+LGNRpCdhC/fGAcX6Vh4=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (10.172.35.146) by
 DM6PR11MB4155.namprd11.prod.outlook.com (20.176.126.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.23; Mon, 6 Jul 2020 12:46:53 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 12:46:53 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v4 03/15] iommu/smmu: Report empty domain nesting info
Thread-Topic: [PATCH v4 03/15] iommu/smmu: Report empty domain nesting info
Thread-Index: AQHWUfUaPoulLLqnPkWWSyUjWN1VMaj6XtmAgAAiPXA=
Date:   Mon, 6 Jul 2020 12:46:53 +0000
Message-ID: <DM5PR11MB143543A04F5AF15EC7CBEC8BC3690@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-4-git-send-email-yi.l.liu@intel.com>
 <d791bad4-57b9-8e97-acbb-76b13e4154f8@redhat.com>
In-Reply-To: <d791bad4-57b9-8e97-acbb-76b13e4154f8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e22a3f58-afbe-4bd5-3674-08d821aaa903
x-ms-traffictypediagnostic: DM6PR11MB4155:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4155CE19A5A984ECD679EF05C3690@DM6PR11MB4155.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i+zlfz4WDye0BKWoE/F2tRMAIgoGB24OOKAmhyKlbGpx5COMsVC96etDCSgjHTr3nMg9PlcIodetTX58qZVqFNN8yFgsQB1/MztLnwfjeLLjlzjRjNr0ytJngT5kdngmG7tQ1VhBV3jHfaOl8Hz8yFbM/dULH5MzS09/eggBB7ol1kCC0ILDTMKvdPHA5Pr+1tzh9x87CA5n7IOMxRc5mshORQnFNmJwHijLD6+g4w1ItNw0ibhZEvyV+IEIYwqXKjnfjOeGgQ89YaP/cuM8Xo2VUh5vYQkexJRJmYTkDrlgA+Qs3K4FnKvaXgY0EspiOUrUuggLu24qzdOU/L5lKS/SPjAz1vv6wDgWo5WwSSGygJs8p7ry+SXwA8ohlTkQrMonOf1Xg8PgX8CnZFiBvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(83380400001)(71200400001)(7416002)(478600001)(110136005)(54906003)(316002)(966005)(33656002)(7696005)(8676002)(52536014)(64756008)(66556008)(66476007)(66446008)(66946007)(8936002)(6506007)(4326008)(186003)(86362001)(53546011)(76116006)(2906002)(9686003)(55016002)(26005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1Ra8GMbEHyJbPBtXtf7nWCRfeIG32bDC12QUYYiBMoA7Y2a9Qoj7HDV8nWMsHFO2wWaKx0db1XlSUcKEgRoz/+YMJdVQccufH1f7iccOmRSTMD63SyibA2ENviX+espLGqBVQuv+YfCTunPwGOJXXdTjqDNe4HEa+vyneqYSNmBc1qVZUob3fHiGVqVdtSS9LKzhiSN3LTvDV9CJ57/KKgJhoEa+kL8EoZ4WOaOCDIbi/O/ZpfiwKBnXHDJHE4llwG0YYX6AdCS/Rd6GsPh7cp67eEIn9DIEPWT7GAn617Je+V3IC1sxeFBJE45fYZIBBRZoTTiLQP9IqsnIhyW5yOy8cfGTFnfJLoo2zZEzZfZ51qo8H3WaTQYwTQhzHbvF9s3XL23HxNfOyXj4MKdefEdYIT7QRCtn9fM4+l2lC6cMldkCQxI1YtJ4KUcWMR9Q3fH0F9Sug5FK4JZFqmrhG2VDUipVBHLkvd5hGI2QwHt8x9/zAoZhOmWiJVkl/I1a
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e22a3f58-afbe-4bd5-3674-08d821aaa903
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 12:46:53.5552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HITQbkkx4xjsFRGE/m09A1MLHmnBq2YRN7uxv2cRTOwkojhbUoBxGU3gclv1EFBA3m8YdRO1ZVhy4xQ4/+BuEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4155
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IA0KPiBIaSBZaSwNCj4gDQo+IFBsZWFzZSBhZGQgYSBjb21taXQgbWVzc2FnZTogaW5zdGVhZCBv
ZiByZXR1cm5pbmcgYSBib29sZWFuIGZvcg0KPiBET01BSU5fQVRUUl9ORVNUSU5HLCBhcm1fc21t
dV9kb21haW5fZ2V0X2F0dHIoKSByZXR1cm5zIGENCj4gaW9tbXVfbmVzdGluZ19pbmZvIGhhbmRs
ZS4NCg0Kd2lsbCBkby4gdGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4NCg0KPiANCj4gT24gNy80
LzIwIDE6MjYgUE0sIExpdSBZaSBMIHdyb3RlOg0KPiA+IENjOiBXaWxsIERlYWNvbiA8d2lsbEBr
ZXJuZWwub3JnPg0KPiA+IENjOiBSb2JpbiBNdXJwaHkgPHJvYmluLm11cnBoeUBhcm0uY29tPg0K
PiA+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEplYW4t
UGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1waGlsaXBwZUBsaW5hcm8ub3JnPg0KPiA+IFN1Z2dlc3Rl
ZC1ieTogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+
ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+
IC0tLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMgfCAyOSArKysrKysrKysrKysr
KysrKysrKysrKysrKystLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2FybS1zbW11LmMgICAgfCAyOSAr
KysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDU0IGlu
c2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9pb21tdS9hcm0tc21tdS12My5jIGIvZHJpdmVycy9pb21tdS9hcm0tc21tdS12My5jDQo+ID4g
aW5kZXggZjU3ODY3Ny4uMGM0NWQ0ZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2lvbW11L2Fy
bS1zbW11LXYzLmMNCj4gPiArKysgYi9kcml2ZXJzL2lvbW11L2FybS1zbW11LXYzLmMNCj4gPiBA
QCAtMzAxOSw2ICszMDE5LDMyIEBAIHN0YXRpYyBzdHJ1Y3QgaW9tbXVfZ3JvdXANCj4gKmFybV9z
bW11X2RldmljZV9ncm91cChzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ID4gIAlyZXR1cm4gZ3JvdXA7
DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgaW50IGFybV9zbW11X2RvbWFpbl9uZXN0aW5nX2lu
Zm8oc3RydWN0IGFybV9zbW11X2RvbWFpbg0KPiAqc21tdV9kb21haW4sDQo+ID4gKwkJCQkJdm9p
ZCAqZGF0YSkNCj4gPiArew0KPiA+ICsJc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyAqaW5mbyA9
IChzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvICopIGRhdGE7DQo+ID4gKwl1MzIgc2l6ZTsNCj4g
PiArDQo+ID4gKwlpZiAoIWluZm8gfHwgc21tdV9kb21haW4tPnN0YWdlICE9IEFSTV9TTU1VX0RP
TUFJTl9ORVNURUQpDQo+ID4gKwkJcmV0dXJuIC1FTk9ERVY7DQo+ID4gKw0KPiA+ICsJc2l6ZSA9
IHNpemVvZihzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvKTsNCj4gPiArDQo+ID4gKwkvKg0KPiA+
ICsJICogaWYgcHJvdmlkZWQgYnVmZmVyIHNpemUgaXMgbm90IGVxdWFsIHRvIHRoZSBzaXplLCBz
aG91bGQNCj4gPiArCSAqIHJldHVybiAwIGFuZCBhbHNvIHRoZSBleHBlY3RlZCBidWZmZXIgc2l6
ZSB0byBjYWxsZXIuDQo+ID4gKwkgKi8NCj4gPiArCWlmIChpbmZvLT5zaXplICE9IHNpemUpIHsN
Cj4gPCBzaXplPw0KDQo8IHNpemUgbWF5IHdvcmsgYXMgd2VsbC4gYnV0IEknZCBsaWtlIHRoZSBj
YWxsZXIgcHJvdmlkZSBleGFjdCBidWZmZXIgc2l6ZS4gbm90IHN1cmUNCmlmIGl0IGlzIGRlbWFu
ZCBpbiBrZXJuZWwuIGRvIHlvdSBoYXZlIGFueSBzdWdnZXN0aW9uPw0KDQo+ID4gKwkJaW5mby0+
c2l6ZSA9IHNpemU7DQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJLyog
cmVwb3J0IGFuIGVtcHR5IGlvbW11X25lc3RpbmdfaW5mbyBmb3Igbm93ICovDQo+ID4gKwltZW1z
ZXQoaW5mbywgMHgwLCBzaXplKTsNCj4gPiArCWluZm8tPnNpemUgPSBzaXplOw0KPiBGb3IgaW5m
bywgdGhlIGN1cnJlbnQgU01NVSBORVNURUQgbW9kZSBpcyBub3QgZW5hYmxpbmcgYW55IG5lc3Rp
bmcuIEl0IGp1c3QgZm9yY2VzDQo+IHRoZSB1c2FnZSBvZiB0aGUgMnN0IHN0YWdlIGluc3RlYWQg
b2Ygc3RhZ2UxIGZvciBzaW5nbGUgc3RhZ2UgdHJhbnNsYXRpb24uDQoNCnllcC4gVGhlIGludGVu
dGlvbiBpcyBhcyBiZWxvdzoNCg0KIiBIb3dldmVyIGl0IHJlcXVpcmVzIGNoYW5naW5nIHRoZSBn
ZXRfYXR0cihORVNUSU5HKSBpbXBsZW1lbnRhdGlvbnMgaW4gYm90aA0KU01NVSBkcml2ZXJzIGFz
IGEgcHJlY3Vyc29yIG9mIHRoaXMgc2VyaWVzLCB0byBhdm9pZCBicmVha2luZw0KVkZJT19UWVBF
MV9ORVNUSU5HX0lPTU1VIG9uIEFybS4gU2luY2Ugd2UgaGF2ZW4ndCB5ZXQgZGVmaW5lZCB0aGUN
Cm5lc3RpbmdfaW5mbyBzdHJ1Y3RzIGZvciBTTU1VdjIgYW5kIHYzLCBJIHN1cHBvc2Ugd2UgY291
bGQgcmV0dXJuIGFuIGVtcHR5DQpzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvIGZvciBub3c/Ig0K
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtaW9tbXUvMjAyMDA2MTcxNDM5MDkuR0E4ODY1
OTBAbXlyaWNhLw0KDQpkbyB5b3UgdGhpbmsgYW55IG90aGVyIG5lZWRzIHRvIGJlIGRvbmUgZm9y
IG5vdz8NCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KPiA+ICsJ
cmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyBpbnQgYXJtX3NtbXVfZG9tYWlu
X2dldF9hdHRyKHN0cnVjdCBpb21tdV9kb21haW4gKmRvbWFpbiwNCj4gPiAgCQkJCSAgICBlbnVt
IGlvbW11X2F0dHIgYXR0ciwgdm9pZCAqZGF0YSkgIHsgQEAgLQ0KPiAzMDI4LDggKzMwNTQsNyBA
QA0KPiA+IHN0YXRpYyBpbnQgYXJtX3NtbXVfZG9tYWluX2dldF9hdHRyKHN0cnVjdCBpb21tdV9k
b21haW4gKmRvbWFpbiwNCj4gPiAgCWNhc2UgSU9NTVVfRE9NQUlOX1VOTUFOQUdFRDoNCj4gPiAg
CQlzd2l0Y2ggKGF0dHIpIHsNCj4gPiAgCQljYXNlIERPTUFJTl9BVFRSX05FU1RJTkc6DQo+ID4g
LQkJCSooaW50ICopZGF0YSA9IChzbW11X2RvbWFpbi0+c3RhZ2UgPT0NCj4gQVJNX1NNTVVfRE9N
QUlOX05FU1RFRCk7DQo+ID4gLQkJCXJldHVybiAwOw0KPiA+ICsJCQlyZXR1cm4gYXJtX3NtbXVf
ZG9tYWluX25lc3RpbmdfaW5mbyhzbW11X2RvbWFpbiwNCj4gZGF0YSk7DQo+ID4gIAkJZGVmYXVs
dDoNCj4gPiAgCQkJcmV0dXJuIC1FTk9ERVY7DQo+ID4gIAkJfQ0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2lvbW11L2FybS1zbW11LmMgYi9kcml2ZXJzL2lvbW11L2FybS1zbW11LmMgaW5kZXgN
Cj4gPiAyNDNiYzRjLi45MDg2MDdkIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW9tbXUvYXJt
LXNtbXUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaW9tbXUvYXJtLXNtbXUuYw0KPiA+IEBAIC0xNTA2
LDYgKzE1MDYsMzIgQEAgc3RhdGljIHN0cnVjdCBpb21tdV9ncm91cA0KPiAqYXJtX3NtbXVfZGV2
aWNlX2dyb3VwKHN0cnVjdCBkZXZpY2UgKmRldikNCj4gPiAgCXJldHVybiBncm91cDsNCj4gPiAg
fQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQgYXJtX3NtbXVfZG9tYWluX25lc3RpbmdfaW5mbyhzdHJ1
Y3QgYXJtX3NtbXVfZG9tYWluDQo+ICpzbW11X2RvbWFpbiwNCj4gPiArCQkJCQl2b2lkICpkYXRh
KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvICppbmZvID0gKHN0cnVj
dCBpb21tdV9uZXN0aW5nX2luZm8gKikgZGF0YTsNCj4gPiArCXUzMiBzaXplOw0KPiA+ICsNCj4g
PiArCWlmICghaW5mbyB8fCBzbW11X2RvbWFpbi0+c3RhZ2UgIT0gQVJNX1NNTVVfRE9NQUlOX05F
U1RFRCkNCj4gPiArCQlyZXR1cm4gLUVOT0RFVjsNCj4gPiArDQo+ID4gKwlzaXplID0gc2l6ZW9m
KHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8pOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBp
ZiBwcm92aWRlZCBidWZmZXIgc2l6ZSBpcyBub3QgZXF1YWwgdG8gdGhlIHNpemUsIHNob3VsZA0K
PiA+ICsJICogcmV0dXJuIDAgYW5kIGFsc28gdGhlIGV4cGVjdGVkIGJ1ZmZlciBzaXplIHRvIGNh
bGxlci4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKGluZm8tPnNpemUgIT0gc2l6ZSkgew0KPiA+ICsJ
CWluZm8tPnNpemUgPSBzaXplOw0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsJfQ0KPiA+ICsNCj4g
PiArCS8qIHJlcG9ydCBhbiBlbXB0eSBpb21tdV9uZXN0aW5nX2luZm8gZm9yIG5vdyAqLw0KPiA+
ICsJbWVtc2V0KGluZm8sIDB4MCwgc2l6ZSk7DQo+ID4gKwlpbmZvLT5zaXplID0gc2l6ZTsNCj4g
PiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IGFybV9zbW11X2Rv
bWFpbl9nZXRfYXR0cihzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sDQo+ID4gIAkJCQkgICAg
ZW51bSBpb21tdV9hdHRyIGF0dHIsIHZvaWQgKmRhdGEpICB7IEBAIC0NCj4gMTUxNSw4ICsxNTQx
LDcgQEANCj4gPiBzdGF0aWMgaW50IGFybV9zbW11X2RvbWFpbl9nZXRfYXR0cihzdHJ1Y3QgaW9t
bXVfZG9tYWluICpkb21haW4sDQo+ID4gIAljYXNlIElPTU1VX0RPTUFJTl9VTk1BTkFHRUQ6DQo+
ID4gIAkJc3dpdGNoIChhdHRyKSB7DQo+ID4gIAkJY2FzZSBET01BSU5fQVRUUl9ORVNUSU5HOg0K
PiA+IC0JCQkqKGludCAqKWRhdGEgPSAoc21tdV9kb21haW4tPnN0YWdlID09DQo+IEFSTV9TTU1V
X0RPTUFJTl9ORVNURUQpOw0KPiA+IC0JCQlyZXR1cm4gMDsNCj4gPiArCQkJcmV0dXJuIGFybV9z
bW11X2RvbWFpbl9uZXN0aW5nX2luZm8oc21tdV9kb21haW4sDQo+IGRhdGEpOw0KPiA+ICAJCWRl
ZmF1bHQ6DQo+ID4gIAkJCXJldHVybiAtRU5PREVWOw0KPiA+ICAJCX0NCj4gPg0KDQo=

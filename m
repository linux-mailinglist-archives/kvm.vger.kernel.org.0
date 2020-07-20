Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B165F225CCE
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 12:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgGTKmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 06:42:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:27961 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbgGTKme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 06:42:34 -0400
IronPort-SDR: OLeXMbRs6yCIC3lmPQSDlug4oYCCBW/6uNihisvvgrJyL+bcizfgDhlln14FeETh4+nFcJGuaV
 TiJB849dZndg==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="129965590"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="129965590"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 03:42:12 -0700
IronPort-SDR: AB/nf99esmAnhR5cNrg+15JLKS8IbSiM4YG1cAYS3ZDESRW9lo//gcVNH444+KN+gZPiiJQL+W
 Lsxh3W7Y4aEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="361982069"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2020 03:42:12 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 03:42:11 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX157.amr.corp.intel.com (10.22.240.23) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 03:42:11 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Jul 2020 03:42:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lI7NEdSGZxxrKqrcOkTk8AbbgJTM1MQ+uT9eKG9amfanTNeBy70DCisHe6TjhDEMGEvZewN7rFcRc/Rw2NgxLmFVXq6eK/xaIK5OA6YeawvIk1oJE0r4q6V4nk5awByGOt0gYgFWEZO4n2izPNBUyLd1BYQA1hhmo0QagIajEIwBcns1Fyypil7yM4MI4p5wlzcrKY6r2E608QqZ7Jxf/5MLRuPi4qnWzGY82dtBrD5N07DNaHbvzud3xdboJ5FYOK2iicNdhffw9EINjhpdzEQ0oleZ7YoTY0eM+KyPDYO7IJUFvI9jsyvC4/gtOokO0XEqBXIF+T0Sy+jkPfIZAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dgep/nIFLMVVCL30fZZtFgHT3ZrDpiysMwp4VeqB2nI=;
 b=O4/PkpwWFrU8CR94NCNgB6VOTyd52BsCsBceU9WhP92EY7SZQV8qUWfdVH5HhQr6djOpY4Mut3xFdmZ1D/L9epSiIx/mGNyYhqN3HaldQKqA4jSub5B51x5UwUNZ2fzuVGb1xk6GMBjhxkC/nXxVv5CTnlX9iW0XpQWZz+hRRFElLvRrU0Y5YjIgVhG7svkd+JFe7OPfCuQ5fHEZ5JTsGS92x/9ORPacGVsR6ezjXpqwloJQcm0h+e0QuvNfobOjYyLxrc/jjZBt1W7hHjkOAyBxE0Y8kcdd1hVIZZ0MhJ3IAVi5OwEBYu9aT0fyNGV2VQjahrDGu0vhQu9bOIcsTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dgep/nIFLMVVCL30fZZtFgHT3ZrDpiysMwp4VeqB2nI=;
 b=s1bpca1o31CzeWOFiEinnri5KY89FczJZx4p7W51ELMatu+lW9u8fL5e5NZDWSCT30DsCx9pOygDIM9C3koGWLpvInFf1v6XN+BBqK8tS1+sgnd6PuBf9iZ6AZPxijLmklDFaxdlRbINbDa5E5hYza1ksjSsSHTL7RPIif53Iv8=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1484.namprd11.prod.outlook.com (2603:10b6:4:8::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.25; Mon, 20 Jul 2020 10:42:09 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 10:42:09 +0000
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
Subject: RE: [PATCH v5 11/15] vfio/type1: Allow invalidating first-level/stage
 IOMMU cache
Thread-Topic: [PATCH v5 11/15] vfio/type1: Allow invalidating
 first-level/stage IOMMU cache
Thread-Index: AQHWWD2mrOp6LhPXfUac/4tF0bwgdKkQQ32AgAAPvnA=
Date:   Mon, 20 Jul 2020 10:42:08 +0000
Message-ID: <DM5PR11MB143567E84D2EAF51895AADC1C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-12-git-send-email-yi.l.liu@intel.com>
 <3b44dc59-cd78-2b72-965e-2f169cacdade@redhat.com>
In-Reply-To: <3b44dc59-cd78-2b72-965e-2f169cacdade@redhat.com>
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
x-ms-office365-filtering-correlation-id: 3e4d8060-74d9-4c0c-2aad-08d82c998daa
x-ms-traffictypediagnostic: DM5PR11MB1484:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB14845BFBB1EAC83EEDD97659C37B0@DM5PR11MB1484.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RZZJ3aQ7RtG9oFIJrM+RlEtJTCDbyOHJshy5f2XqB9qB33niprnSuJ2VeDk3JZeLIOmWQsfgBdNDFHifA37ubylVElvI9evluKFXJumQWnVWBS3LIrPp1wxvchvK2r+Oolb3hyyYT0ZYyegK+bbfUTFPNiywxFGzFzcZF8orvnrKFebIfdMuzGI0O4eGpKklEaF198xa4bTae8L+SjPj0wLDwubiw/81uJnjwmfl6U1oXX+wi/7uk+t7sdi6nVsy2zaGDqmJFJyAeyR3Xtl8gvLDFC+q+uJmhWLFbB0EPd26k4h78Q4i2/eaPZtaal8Q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(5660300002)(316002)(83380400001)(110136005)(54906003)(186003)(4326008)(2906002)(52536014)(33656002)(64756008)(478600001)(7696005)(9686003)(66556008)(66946007)(66476007)(86362001)(76116006)(71200400001)(6506007)(7416002)(55016002)(8676002)(8936002)(66446008)(53546011)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Qu0RhmwUljwK52UE7kWzzxihtOb3RFTCAbJ7JO/hFhCv0U+ebUB7xh3EZMGpihOy3HjDxq7vjd+c4JrjO6pwW0hR4Zjr5/+W0j9C82BzTb3yrYozOUY6/gYgtd8MciVEsFBMAq82KKkfYGF4bU+mAH8rxFAxSUuMNqOyETRl0h/WveMOKnGBvBFyPVvDeILznauIw6oU36xxovGX2Pz6sF62FF+wJXpHMPkHxaLz/8/idkJq0/msFa5IrAEFALRDy7IfCINF35Byw9y9v6Ehv8EmqSAoNNQh0vtUDPb3pBuDxVYzE2V7ZS0398t63H5p2etADqeODMPcJDXumjR9fqIZkvNZoHOoI1u6qjjB9SSdWXDRK92urJnni4KKezy4NcT5Q0S+qmY8LOZvHOkabQ2/gQquhG4FG+uVzCqjUntQvJF6+En/NF3HPZkcMIWDhHCUOLfG+EWGcJuFeTdlZ2kdI5msyWxEGdviwRYj+NatR4jvKP/CH1wbo1Anvk6q
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4d8060-74d9-4c0c-2aad-08d82c998daa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 10:42:09.0143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5IJf+tnSgSzP6mxIBQxGEjNuydb2gfa+RuWp8T/ORCOwiNfQNPFx9zLW1uLEuUcWuGO3oaxk3Fjg92ZsyVzqLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1484
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgSnVseSAyMCwgMjAyMCA1OjQyIFBNDQo+IA0KPiBZaSwNCj4gDQo+IE9u
IDcvMTIvMjAgMToyMSBQTSwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBwcm92aWRl
cyBhbiBpbnRlcmZhY2UgYWxsb3dpbmcgdGhlIHVzZXJzcGFjZSB0byBpbnZhbGlkYXRlDQo+ID4g
SU9NTVUgY2FjaGUgZm9yIGZpcnN0LWxldmVsIHBhZ2UgdGFibGUuIEl0IGlzIHJlcXVpcmVkIHdo
ZW4gdGhlIGZpcnN0DQo+ID4gbGV2ZWwgSU9NTVUgcGFnZSB0YWJsZSBpcyBub3QgbWFuYWdlZCBi
eSB0aGUgaG9zdCBrZXJuZWwgaW4gdGhlIG5lc3RlZA0KPiA+IHRyYW5zbGF0aW9uIHNldHVwLg0K
PiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENDOiBK
YWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBBbGV4IFdp
bGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+IENjOiBFcmljIEF1Z2Vy
IDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8
amVhbi1waGlsaXBwZUBsaW5hcm8ub3JnPg0KPiA+IENjOiBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5
dGVzLm9yZz4NCj4gPiBDYzogTHUgQmFvbHUgPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IC0t
LQ0KPiA+IHYxIC0+IHYyOg0KPiA+ICopIHJlbmFtZSBmcm9tICJ2ZmlvL3R5cGUxOiBGbHVzaCBz
dGFnZS0xIElPTU1VIGNhY2hlIGZvciBuZXN0aW5nIHR5cGUiDQo+ID4gKikgcmVuYW1lIHZmaW9f
Y2FjaGVfaW52X2ZuKCkgdG8gdmZpb19kZXZfY2FjaGVfaW52YWxpZGF0ZV9mbigpDQo+ID4gKikg
dmZpb19kZXZfY2FjaGVfaW52X2ZuKCkgYWx3YXlzIHN1Y2Nlc3NmdWwNCj4gPiAqKSByZW1vdmUg
VkZJT19JT01NVV9DQUNIRV9JTlZBTElEQVRFLCBhbmQgcmV1c2UNCj4gVkZJT19JT01NVV9ORVNU
SU5HX09QDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdmZpby92ZmlvX2lvbW11X3R5cGUxLmMgfCA1
MA0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBpbmNs
dWRlL3VhcGkvbGludXgvdmZpby5oICAgICAgIHwgIDMgKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdl
ZCwgNTMgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92
ZmlvX2lvbW11X3R5cGUxLmMgYi9kcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jDQo+ID4g
aW5kZXggZjBmMjFmZi4uOTYwY2M1OSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vdmZp
b19pb21tdV90eXBlMS5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL3ZmaW9faW9tbXVfdHlwZTEu
Yw0KPiA+IEBAIC0zMDczLDYgKzMwNzMsNTMgQEAgc3RhdGljIGxvbmcgdmZpb19pb21tdV9oYW5k
bGVfcGd0Ymxfb3Aoc3RydWN0DQo+IHZmaW9faW9tbXUgKmlvbW11LA0KPiA+ICAJcmV0dXJuIHJl
dDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQgdmZpb19kZXZfY2FjaGVfaW52YWxpZGF0
ZV9mbihzdHJ1Y3QgZGV2aWNlICpkZXYsIHZvaWQgKmRhdGEpDQo+ID4gK3sNCj4gPiArCXN0cnVj
dCBkb21haW5fY2Fwc3VsZSAqZGMgPSAoc3RydWN0IGRvbWFpbl9jYXBzdWxlICopZGF0YTsNCj4g
PiArCXVuc2lnbmVkIGxvbmcgYXJnID0gKih1bnNpZ25lZCBsb25nICopZGMtPmRhdGE7DQo+ID4g
Kw0KPiA+ICsJaW9tbXVfY2FjaGVfaW52YWxpZGF0ZShkYy0+ZG9tYWluLCBkZXYsICh2b2lkIF9f
dXNlciAqKWFyZyk7DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGlj
IGxvbmcgdmZpb19pb21tdV9pbnZhbGlkYXRlX2NhY2hlKHN0cnVjdCB2ZmlvX2lvbW11ICppb21t
dSwNCj4gPiArCQkJCQl1bnNpZ25lZCBsb25nIGFyZykNCj4gPiArew0KPiA+ICsJc3RydWN0IGRv
bWFpbl9jYXBzdWxlIGRjID0geyAuZGF0YSA9ICZhcmcgfTsNCj4gPiArCXN0cnVjdCB2ZmlvX2dy
b3VwICpncm91cDsNCj4gPiArCXN0cnVjdCB2ZmlvX2RvbWFpbiAqZG9tYWluOw0KPiA+ICsJaW50
IHJldCA9IDA7DQo+ID4gKwlzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvICppbmZvOw0KPiA+ICsN
Cj4gPiArCW11dGV4X2xvY2soJmlvbW11LT5sb2NrKTsNCj4gPiArCS8qDQo+ID4gKwkgKiBDYWNo
ZSBpbnZhbGlkYXRpb24gaXMgcmVxdWlyZWQgZm9yIGFueSBuZXN0aW5nIElPTU1VLA0KPiA+ICsJ
ICogc28gbm8gbmVlZCB0byBjaGVjayBzeXN0ZW0td2lkZSBQQVNJRCBzdXBwb3J0Lg0KPiA+ICsJ
ICovDQo+ID4gKwlpbmZvID0gaW9tbXUtPm5lc3RpbmdfaW5mbzsNCj4gPiArCWlmICghaW5mbyB8
fCAhKGluZm8tPmZlYXR1cmVzICYgSU9NTVVfTkVTVElOR19GRUFUX0NBQ0hFX0lOVkxEKSkgew0K
PiA+ICsJCXJldCA9IC1FT1BOT1RTVVBQOw0KPiA+ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gPiAr
CX0NCj4gPiArDQo+ID4gKwlncm91cCA9IHZmaW9fZmluZF9uZXN0aW5nX2dyb3VwKGlvbW11KTsN
Cj4gc28gSSBzZWUgeW91IHJldXNlIGl0IGhlcmUuIEJ1dCBzdGlsbCB3b25kZXJpbmcgaWYgeW91
IGNhbnQndCBkaXJlY3RseQ0KPiBzZXQgZGMuZG9tYWluIGFuZCBkYy5ncm91cCBncm91cCBiZWxv
dyB1c2luZyBsaXN0X2ZpcnRfZW50cnk/DQoNCkkgZ3Vlc3MgeWVzIGZvciBjdXJyZW50IGltcGxl
bWVudGF0aW9uLiBJIGFsc28gY29uc2lkZXJlZCBpZiBJIGNhbg0KZ2V0IGEgaGVscGVyIGZ1bmN0
aW9uIHRvIHJldHJ1biBhIGRjIHdpdGggZ3JvdXAgYW5kIGRvbWFpbiBmaWVsZA0KaW5pdGlhbGl6
ZWQgYXMgaXQgaXMgY29tbW9uIGNvZGUgdXNlZCBieSBib3RoIGJpbmQvdW5iaW5kIGFuZCBjYWNo
ZV9pbnYNCnBhdGguIHBlcmhhcHMgc29tZXRoaW5nIGxpa2UgZ2V0X2RvbWFpbl9jYXBzdWxlX2Zv
cl9uZXN0aW5nKCkNCg0KPiA+ICsJaWYgKCFncm91cCkgew0KPiA+ICsJCXJldCA9IC1FSU5WQUw7
DQo+ID4gKwkJZ290byBvdXRfdW5sb2NrOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWRvbWFpbiA9
IGxpc3RfZmlyc3RfZW50cnkoJmlvbW11LT5kb21haW5fbGlzdCwNCj4gPiArCQkJCSAgc3RydWN0
IHZmaW9fZG9tYWluLCBuZXh0KTsNCj4gPiArCWRjLmdyb3VwID0gZ3JvdXA7DQo+ID4gKwlkYy5k
b21haW4gPSBkb21haW4tPmRvbWFpbjsNCj4gPiArCWlvbW11X2dyb3VwX2Zvcl9lYWNoX2Rldihn
cm91cC0+aW9tbXVfZ3JvdXAsICZkYywNCj4gPiArCQkJCSB2ZmlvX2Rldl9jYWNoZV9pbnZhbGlk
YXRlX2ZuKTsNCj4gPiArDQo+ID4gK291dF91bmxvY2s6DQo+ID4gKwltdXRleF91bmxvY2soJmlv
bW11LT5sb2NrKTsNCj4gPiArCXJldHVybiByZXQ7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRp
YyBsb25nIHZmaW9faW9tbXVfdHlwZTFfbmVzdGluZ19vcChzdHJ1Y3QgdmZpb19pb21tdSAqaW9t
bXUsDQo+ID4gIAkJCQkJdW5zaWduZWQgbG9uZyBhcmcpDQo+ID4gIHsNCj4gPiBAQCAtMzA5NSw2
ICszMTQyLDkgQEAgc3RhdGljIGxvbmcgdmZpb19pb21tdV90eXBlMV9uZXN0aW5nX29wKHN0cnVj
dA0KPiB2ZmlvX2lvbW11ICppb21tdSwNCj4gPiAgCWNhc2UgVkZJT19JT01NVV9ORVNUSU5HX09Q
X1VOQklORF9QR1RCTDoNCj4gPiAgCQlyZXQgPSB2ZmlvX2lvbW11X2hhbmRsZV9wZ3RibF9vcChp
b21tdSwgZmFsc2UsIGFyZyArIG1pbnN6KTsNCj4gPiAgCQlicmVhazsNCj4gPiArCWNhc2UgVkZJ
T19JT01NVV9ORVNUSU5HX09QX0NBQ0hFX0lOVkxEOg0KPiA+ICsJCXJldCA9IHZmaW9faW9tbXVf
aW52YWxpZGF0ZV9jYWNoZShpb21tdSwgYXJnICsgbWluc3opOw0KPiA+ICsJCWJyZWFrOw0KPiA+
ICAJZGVmYXVsdDoNCj4gPiAgCQlyZXQgPSAtRUlOVkFMOw0KPiA+ICAJfQ0KPiA+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8u
aA0KPiA+IGluZGV4IGE4YWQ3ODYuLjg0NWE1ODAwIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUv
dWFwaS9saW51eC92ZmlvLmgNCj4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oDQo+
ID4gQEAgLTEyMjUsNiArMTIyNSw4IEBAIHN0cnVjdCB2ZmlvX2lvbW11X3R5cGUxX3Bhc2lkX3Jl
cXVlc3Qgew0KPiA+ICAgKiArLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+ID4gICAqIHwgVU5CSU5EX1BHVEJMICAgIHwg
ICAgICBzdHJ1Y3QgaW9tbXVfZ3Bhc2lkX2JpbmRfZGF0YSAgICAgICAgICAgIHwNCj4gPiAgICog
Ky0tLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tKw0KPiA+ICsgKiB8IENBQ0hFX0lOVkxEICAgICB8ICAgICAgc3RydWN0IGlvbW11
X2NhY2hlX2ludmFsaWRhdGVfaW5mbyAgICAgICB8DQo+ID4gKyAqICstLS0tLS0tLS0tLS0tLS0t
LSstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsNCj4gPiAg
ICoNCj4gPiAgICogcmV0dXJuczogMCBvbiBzdWNjZXNzLCAtZXJybm8gb24gZmFpbHVyZS4NCj4g
PiAgICovDQo+ID4gQEAgLTEyMzcsNiArMTIzOSw3IEBAIHN0cnVjdCB2ZmlvX2lvbW11X3R5cGUx
X25lc3Rpbmdfb3Agew0KPiA+DQo+ID4gICNkZWZpbmUgVkZJT19JT01NVV9ORVNUSU5HX09QX0JJ
TkRfUEdUQkwJKDApDQo+ID4gICNkZWZpbmUgVkZJT19JT01NVV9ORVNUSU5HX09QX1VOQklORF9Q
R1RCTAkoMSkNCj4gPiArI2RlZmluZSBWRklPX0lPTU1VX05FU1RJTkdfT1BfQ0FDSEVfSU5WTEQJ
KDIpDQo+ID4NCj4gPiAgI2RlZmluZSBWRklPX0lPTU1VX05FU1RJTkdfT1AJCV9JTyhWRklPX1RZ
UEUsIFZGSU9fQkFTRSArIDE5KQ0KPiA+DQo+ID4NCj4gT3RoZXJ3aXNlIGxvb2tzIGdvb2QgdG8g
bWUNCg0KdGhhbmtzLA0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gVGhhbmtzDQo+IA0KPiBFcmlj
DQoNCg==

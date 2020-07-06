Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBA4215726
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 14:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgGFMVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 08:21:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:55862 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbgGFMVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 08:21:32 -0400
IronPort-SDR: iz+nS1gp1ajzpJuS0LKJe2/I0jWtg2pFyA3HWl0LSgz+JoNU2BZRToVGOTvjbvS24+/gHbjFJ/
 QEuiV0RCZkHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9673"; a="148901982"
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="148901982"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:21:27 -0700
IronPort-SDR: fmipxoNdk+Xq8a1Kf8k8iLHO5fbzIUfIGz36fTc6c6KU8cqhj5WnyJNY67YSaXc3J/mf8YF9WE
 6XM9jZIWsuCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="296992510"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga002.jf.intel.com with ESMTP; 06 Jul 2020 05:21:26 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Jul 2020 05:21:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 6 Jul 2020 05:21:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Spj8j5QHw1JLmElSoP29h6ktP8m7jGWAxI0KL7f08eXs4NmQ0gPUJH2Fwi0L2Ox6Q3aKc2O8759OllLLKRfGjsN8o1f2g+TALammOPeDPjzsw8WCPBcBbhuzo1XWo5RtvUjIuMfyhHkzk6rxeRloMIZB2Zt3QO6sQ0wBHF7yJ/xbDcQ45J5dnXs49HORDW3sGoW39xdr3mRqtXaOvSMNFmmfdmNs3OYss2KR9Mom5V6k5iz6tekke+jqhz1aJNZ1yBpqqDnD0ozLD7c3Z9cgCesoYiMFzLKEF7amagWBmJ6+xrAnm4Y183AZotTFBwY8pfbMfozaG6q+Gt3hmgpp7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJeFqEUawpf62hVaj65b3Giw5ag2dvR2lOGJotoO0/Q=;
 b=EBQ8lArzyJOUNoH1DLYPl1M/95Nnv8wK+yzOcrg/fUjLxvC0MDg1dVSmpBkr2+EELxRlRgruCAnjM0H/rd6qx9Su0DPHhb2tj5NEWFPAb9xi2CzrF9AOcBuNRc3M8BLTbLnR2cAOxH9GpvZJRB3CGNSng02XLKVb+jiOFo0Gw95m+EcaITAjB+4XunJHrx0IAocfCbXW9Tt9A9gqJ0SXx0ZvmeEc0z8dl5fZkgaU6KuCH2jpWyk+8ziJICwI9A+tZlZj1FKZuLHa8HYH7sxwy0PU8LICzzLY1/sG100JVn5oqCQOMYByJ+Hw2UOX0G0qGNSL6TcHnrGdyO1FJ7ialA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJeFqEUawpf62hVaj65b3Giw5ag2dvR2lOGJotoO0/Q=;
 b=u0QNXF3sr+77vMFIfeaxyvarotOh4ugOdGNL9tbqyJ3SnHfxL9Wky6IfShMjg0gguYQw3mfCQw5gzfYv7I5XaQZa3us41ot2I59WJOua++ZLI/hcG2d6gS2831PnkUvamicr6RTjNI1DFZCmaoow3dn/sfs+NeiVTuqyUigYYkI=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB2009.namprd11.prod.outlook.com (2603:10b6:3:15::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.27; Mon, 6 Jul 2020 12:20:26 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 12:20:26 +0000
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
Subject: RE: [PATCH v4 02/15] iommu: Report domain nesting info
Thread-Topic: [PATCH v4 02/15] iommu: Report domain nesting info
Thread-Index: AQHWUfUZPmXy4q2mvk6wmPCF23Zkz6j6TVgAgAArcYA=
Date:   Mon, 6 Jul 2020 12:20:26 +0000
Message-ID: <DM5PR11MB14352CBCB1966C0B9E418C7CC3690@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-3-git-send-email-yi.l.liu@intel.com>
 <b9479f61-7f9e-e0ae-5125-ab15f59b1ece@redhat.com>
In-Reply-To: <b9479f61-7f9e-e0ae-5125-ab15f59b1ece@redhat.com>
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
x-ms-office365-filtering-correlation-id: f54fc402-e0a8-476e-c389-08d821a6f733
x-ms-traffictypediagnostic: DM5PR11MB2009:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB2009E71816A010378C908AE0C3690@DM5PR11MB2009.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xn/I0IrawQEYPv2g/8z4nxiV2CERDn7r9cb36/0iFqmBg3ckdjT4uarVyoT7fmULkq9E/YyCVzy2MVMWAOwzhMyrKk6odWOWnnM5Utyw0oSVYAr5Ots4Xo+tTj9jdyCP0rN51mLWiBYcFfUGbiaGQEUEJ3ekke/C2pkajK50d5r2bCvwXatfuQyhIeKy3y3TKA0jLlEZOiAmVWakogJWRIQSFRrAgHLuRo8Rd/9MRsdbMlajMuZ82houPIv7z0gb8XyHw7jHiHUdXjg37v9lg7SZVpKM6kyMRYKOB871wg3ZPb3qgt2OkoDVkX5Y4EFkf6UcgXNNQesSmQ0Xtu4sHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(54906003)(33656002)(5660300002)(86362001)(52536014)(76116006)(478600001)(83380400001)(110136005)(7416002)(316002)(4326008)(186003)(7696005)(8936002)(71200400001)(8676002)(66476007)(66946007)(66556008)(64756008)(66446008)(26005)(55016002)(9686003)(2906002)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Ix293tchpAxIBm8yt7PJtbBdr2a5btxivflIsFjYlhSJRgky/T1PjntIyggT8gCwNlCNbdJcX2i1YUYbNPbGIahQyq3uaTnOrostbDlcG37pTpm2gJ4VLsbaefNVP7Dmy+FcVwxqGSLJ2Tg0jWOyqzvMAgZkWSH8ZIF6ddYZf4UynzKS4vEvtVJShEgxLeT4P+rjlz27rf/obu8mxypfX1CKhKdqiqnuBlO8mghtVimgildRRfzs5wS/w/Jbmv1yCZjO4fAC2CZjdo05m6fuwQ9rfE69ar2wjfEiT+CkDgZXPCTq4FU4UdZ5dyRUGUtOajtrAt047hRZit1Nszqdk8noewvJeDc3UwRp2i1dFtktCEkc/qRkHbiIv5zQyRv8JzVhdi18VflK2nz7W5zaXt6K6hO3qAW9wKQEzqCQF+KeNWpBdYSGo2WPxqJ3o8eEbdd5Tcuf7lKKul880NMWCSPZoHzXfa4oZzBhU1vGClq8tyB+X80LCE0eM6zF94NL
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f54fc402-e0a8-476e-c389-08d821a6f733
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 12:20:26.7658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GMFu4wmdq5pchzoiLkxIsLVbm3kPZPGKkTxyqeOZlJwVjLfa80bE0/oeapxd/qsOwLhRMOn6n902/cWP1QT7uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2009
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgSnVseSA2LCAyMDIwIDU6MzQgUE0NCj4gDQo+IE9uIDcvNC8yMCAxOjI2
IFBNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBJT01NVXMgdGhhdCBzdXBwb3J0IG5lc3RpbmcgdHJh
bnNsYXRpb24gbmVlZHMgcmVwb3J0IHRoZSBjYXBhYmlsaXR5IGluZm8NCj4gbmVlZCB0byByZXBv
cnQNCj4gPiB0byB1c2Vyc3BhY2UsIGUuZy4gdGhlIGZvcm1hdCBvZiBmaXJzdCBsZXZlbC9zdGFn
ZSBwYWdpbmcgc3RydWN0dXJlcy4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggcmVwb3J0cyBuZXN0aW5n
IGluZm8gYnkgRE9NQUlOX0FUVFJfTkVTVElORy4gQ2FsbGVyIGNhbiBnZXQNCj4gPiBuZXN0aW5n
IGluZm8gYWZ0ZXIgc2V0dGluZyBET01BSU5fQVRUUl9ORVNUSU5HLg0KPiA+DQo+ID4gQ2M6IEtl
dmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENDOiBKYWNvYiBQYW4gPGphY29i
Lmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgu
d2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+IENjOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJl
ZGhhdC5jb20+DQo+ID4gQ2M6IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1waGlsaXBwZUBs
aW5hcm8ub3JnPg0KPiA+IENjOiBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz4NCj4gPiBD
YzogTHUgQmFvbHUgPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEphY29i
IFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gdjMgLT4g
djQ6DQo+ID4gKikgc3BsaXQgdGhlIFNNTVUgZHJpdmVyIGNoYW5nZXMgdG8gYmUgYSBzZXBhcmF0
ZSBwYXRjaA0KPiA+ICopIG1vdmUgdGhlIEBhZGRyX3dpZHRoIGFuZCBAcGFzaWRfYml0cyBmcm9t
IHZlbmRvciBzcGVjaWZpYw0KPiA+ICAgIHBhcnQgdG8gZ2VuZXJpYyBwYXJ0Lg0KPiA+ICopIHR3
ZWFrIHRoZSBkZXNjcmlwdGlvbiBmb3IgdGhlIEBmZWF0dXJlcyBmaWVsZCBvZiBzdHJ1Y3QNCj4g
PiAgICBpb21tdV9uZXN0aW5nX2luZm8uDQo+ID4gKikgYWRkIGRlc2NyaXB0aW9uIG9uIHRoZSBA
ZGF0YVtdIGZpZWxkIG9mIHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8NCj4gPg0KPiA+IHYyIC0+
IHYzOg0KPiA+ICopIHJlbXZvZSBjYXAvZWNhcF9tYXNrIGluIGlvbW11X25lc3RpbmdfaW5mby4N
Cj4gPiAqKSByZXVzZSBET01BSU5fQVRUUl9ORVNUSU5HIHRvIGdldCBuZXN0aW5nIGluZm8uDQo+
ID4gKikgcmV0dXJuIGFuIGVtcHR5IGlvbW11X25lc3RpbmdfaW5mbyBmb3IgU01NVSBkcml2ZXJz
IHBlciBKZWFuJw0KPiA+ICAgIHN1Z2dlc3Rpb24uDQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvdWFw
aS9saW51eC9pb21tdS5oIHwgNzgNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNzggaW5zZXJ0aW9ucygrKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9pb21tdS5oIGIvaW5jbHVkZS91
YXBpL2xpbnV4L2lvbW11LmgNCj4gPiBpbmRleCAxYWZjNjYxLi4xYmZjMDMyIDEwMDY0NA0KPiA+
IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9pb21tdS5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2lvbW11LmgNCj4gPiBAQCAtMzMyLDQgKzMzMiw4MiBAQCBzdHJ1Y3QgaW9tbXVfZ3Bh
c2lkX2JpbmRfZGF0YSB7DQo+ID4gIAl9IHZlbmRvcjsNCj4gPiAgfTsNCj4gPg0KPiA+ICsvKg0K
PiA+ICsgKiBzdHJ1Y3QgaW9tbXVfbmVzdGluZ19pbmZvIC0gSW5mb3JtYXRpb24gZm9yIG5lc3Rp
bmctY2FwYWJsZSBJT01NVS4NCj4gPiArICoJCQkJdXNlciBzcGFjZSBzaG91bGQgY2hlY2sgaXQg
YmVmb3JlIHVzaW5nDQo+ID4gKyAqCQkJCW5lc3RpbmcgY2FwYWJpbGl0eS4NCj4gYWxpZ25tZW50
Pw0KDQpvaCwgeWVzLCB3aWxsIGRvIGl0Lg0KDQo+ID4gKyAqDQo+ID4gKyAqIEBzaXplOglzaXpl
IG9mIHRoZSB3aG9sZSBzdHJ1Y3R1cmUNCj4gPiArICogQGZvcm1hdDoJUEFTSUQgdGFibGUgZW50
cnkgZm9ybWF0LCB0aGUgc2FtZSBkZWZpbml0aW9uIHdpdGgNCj4gPiArICoJCUBmb3JtYXQgb2Yg
c3RydWN0IGlvbW11X2dwYXNpZF9iaW5kX2RhdGEuDQo+IHRoZSBzYW1lIGRlZmluaXRpb24gYXMg
c3RydWN0IGlvbW11X2dwYXNpZF9iaW5kX2RhdGEgQGZvcm1hdD8NCg0KcmlnaHQuIHlvdXJzIGlz
IG11Y2ggYmV0dGVyLg0KDQo+ID4gKyAqIEBmZWF0dXJlczoJc3VwcG9ydGVkIG5lc3RpbmcgZmVh
dHVyZXMuDQo+ID4gKyAqIEBmbGFnczoJY3VycmVudGx5IHJlc2VydmVkIGZvciBmdXR1cmUgZXh0
ZW5zaW9uLg0KPiA+ICsgKiBAYWRkcl93aWR0aDoJVGhlIG91dHB1dCBhZGRyIHdpZHRoIG9mIGZp
cnN0IGxldmVsL3N0YWdlIHRyYW5zbGF0aW9uDQo+ID4gKyAqIEBwYXNpZF9iaXRzOglNYXhpbXVt
IHN1cHBvcnRlZCBQQVNJRCBiaXRzLCAwIHJlcHJlc2VudHMgbm8gUEFTSUQNCj4gPiArICoJCXN1
cHBvcnQuDQo+ID4gKyAqIEBkYXRhOgl2ZW5kb3Igc3BlY2lmaWMgY2FwIGluZm8uIGRhdGFbXSBz
dHJ1Y3R1cmUgdHlwZSBjYW4gYmUgZGVkdWNlZA0KPiA+ICsgKgkJZnJvbSBAZm9ybWF0IGZpZWxk
Lg0KPiA+ICsgKg0KPiA+ICsgKg0KPiArPT09PT09PT09PT09PT09Kz09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA9PT0rDQo+ID4gKyAqIHwgZmVh
dHVyZSAgICAgICB8ICBOb3RlcyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfA0KPiA+ICsgKg0KPiArPT09PT09PT09PT09PT09Kz09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA9PT0rDQo+ID4gKyAqIHwgU1lT
V0lERV9QQVNJRCB8ICBQQVNJRHMgYXJlIG1hbmFnZWQgaW4gc3lzdGVtLXdpZGUsIGluc3RlYWQg
b2YgcGVyICAgfA0KPiA+ICsgKiB8ICAgICAgICAgICAgICAgfCAgZGV2aWNlLiBXaGVuIGEgZGV2
aWNlIGlzIGFzc2lnbmVkIHRvIHVzZXJzcGFjZSBvciAgIHwNCj4gPiArICogfCAgICAgICAgICAg
ICAgIHwgIFZNLCBwcm9wZXIgdUFQSSAodXNlcnNwYWNlIGRyaXZlciBmcmFtZXdvcmsgdUFQSSwg
ICB8DQo+ID4gKyAqIHwgICAgICAgICAgICAgICB8ICBlLmcuIFZGSU8pIG11c3QgYmUgdXNlZCB0
byBhbGxvY2F0ZS9mcmVlIFBBU0lEcyBmb3IgfA0KPiA+ICsgKiB8ICAgICAgICAgICAgICAgfCAg
dGhlIGFzc2lnbmVkIGRldmljZS4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4g
PiArICogKy0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+ID4gKyAqIHwgQklORF9QR1RCTCAgICB8ICBUaGUgb3du
ZXIgb2YgdGhlIGZpcnN0IGxldmVsL3N0YWdlIHBhZ2UgdGFibGUgbXVzdCAgfA0KPiA+ICsgKiB8
ICAgICAgICAgICAgICAgfCAgZXhwbGljaXRseSBiaW5kIHRoZSBwYWdlIHRhYmxlIHRvIGFzc29j
aWF0ZWQgUEFTSUQgIHwNCj4gPiArICogfCAgICAgICAgICAgICAgIHwgIChlaXRoZXIgdGhlIG9u
ZSBzcGVjaWZpZWQgaW4gYmluZCByZXF1ZXN0IG9yIHRoZSAgICB8DQo+ID4gKyAqIHwgICAgICAg
ICAgICAgICB8ICBkZWZhdWx0IFBBU0lEIG9mIGlvbW11IGRvbWFpbiksIHRocm91Z2ggdXNlcnNw
YWNlICAgfA0KPiA+ICsgKiB8ICAgICAgICAgICAgICAgfCAgZHJpdmVyIGZyYW1ld29yayB1QVBJ
IChlLmcuIFZGSU9fSU9NTVVfTkVTVElOR19PUCkuIHwNCj4gPiArICogKy0tLS0tLS0tLS0tLS0t
LSstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0r
DQo+ID4gKyAqIHwgQ0FDSEVfSU5WTEQgICB8ICBUaGUgb3duZXIgb2YgdGhlIGZpcnN0IGxldmVs
L3N0YWdlIHBhZ2UgdGFibGUgbXVzdCAgfA0KPiA+ICsgKiB8ICAgICAgICAgICAgICAgfCAgZXhw
bGljaXRseSBpbnZhbGlkYXRlIHRoZSBJT01NVSBjYWNoZSB0aHJvdWdoIHVBUEkgIHwNCj4gPiAr
ICogfCAgICAgICAgICAgICAgIHwgIHByb3ZpZGVkIGJ5IHVzZXJzcGFjZSBkcml2ZXIgZnJhbWV3
b3JrIChlLmcuIFZGSU8pICB8DQo+ID4gKyAqIHwgICAgICAgICAgICAgICB8ICBhY2NvcmRpbmcg
dG8gdmVuZG9yLXNwZWNpZmljIHJlcXVpcmVtZW50IHdoZW4gICAgICAgfA0KPiA+ICsgKiB8ICAg
ICAgICAgICAgICAgfCAgY2hhbmdpbmcgdGhlIHBhZ2UgdGFibGUuICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwNCj4gPiArICogKy0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo+IERvIHlvdSBmb3Jlc2VlIGNh
c2VzIHdoZXJlIEJJTkRfUEdUQkwgYW5kIENBQ0hFX0lOVkxEIHNob3VsZG4ndCBiZQ0KPiBleHBv
c2VkIGFzIGZlYXR1cmVzPw0KDQpzb3JyeSwgSSBkaWRuJ3QgcXVpdGUgZ2V0IGl0LiBjb3VsZCB5
b3UgZXhwbGFpbiBhIGxpdHRsZSBiaXQgbW9yZS4gOi0pDQoNCj4gPiArICoNCj4gPiArICogQGRh
dGFbXSB0eXBlcyBkZWZpbmVkIGZvciBAZm9ybWF0Og0KPiA+ICsgKg0KPiArPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0rPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
PiA9PT0rDQo+ID4gKyAqIHwgQGZvcm1hdCAgICAgICAgICAgICAgICAgICAgICAgIHwgQGRhdGFb
XSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ICsgKg0KPiArPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0rPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
PiA9PT0rDQo+ID4gKyAqIHwgSU9NTVVfUEFTSURfRk9STUFUX0lOVEVMX1ZURCAgIHwgc3RydWN0
IGlvbW11X25lc3RpbmdfaW5mb192dGQgICAgICAgfA0KPiA+ICsgKiArLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsN
Cj4gPiArICoNCj4gPiArICovDQo+ID4gK3N0cnVjdCBpb21tdV9uZXN0aW5nX2luZm8gew0KPiA+
ICsJX191MzIJc2l6ZTsNCj4gPiArCV9fdTMyCWZvcm1hdDsNCj4gPiArCV9fdTMyCWZlYXR1cmVz
Ow0KPiA+ICsjZGVmaW5lIElPTU1VX05FU1RJTkdfRkVBVF9TWVNXSURFX1BBU0lECSgxIDw8IDAp
DQo+ID4gKyNkZWZpbmUgSU9NTVVfTkVTVElOR19GRUFUX0JJTkRfUEdUQkwJCSgxIDw8IDEpDQo+
ID4gKyNkZWZpbmUgSU9NTVVfTkVTVElOR19GRUFUX0NBQ0hFX0lOVkxECQkoMSA8PCAyKQ0KPiBJ
biBvdGhlciBzdHJ1Y3RzIHRoZSB2YWx1ZXMgc2VlbSB0byBiZSBkZWZpbmVkIGJlZm9yZSB0aGUg
ZmllbGQNCg0Kbm90IHN1cmUuIDotKSBJIG1pbWljcyB0aGUgYmVsb3cgc3RydWN0IGZyb20gdWFw
aS92ZmlvLmgNCg0Kc3RydWN0IHZmaW9faW9tbXVfdHlwZTFfZG1hX21hcCB7DQogICAgICAgIF9f
dTMyICAgYXJnc3o7DQogICAgICAgIF9fdTMyICAgZmxhZ3M7DQojZGVmaW5lIFZGSU9fRE1BX01B
UF9GTEFHX1JFQUQgKDEgPDwgMCkgICAgICAgICAvKiByZWFkYWJsZSBmcm9tIGRldmljZSAqLw0K
I2RlZmluZSBWRklPX0RNQV9NQVBfRkxBR19XUklURSAoMSA8PCAxKSAgICAgICAgLyogd3JpdGFi
bGUgZnJvbSBkZXZpY2UgKi8NCiAgICAgICAgX191NjQgICB2YWRkcjsgICAgICAgICAgICAgICAg
ICAgICAgICAgIC8qIFByb2Nlc3MgdmlydHVhbCBhZGRyZXNzICovDQogICAgICAgIF9fdTY0ICAg
aW92YTsgICAgICAgICAgICAgICAgICAgICAgICAgICAvKiBJTyB2aXJ0dWFsIGFkZHJlc3MgKi8N
CiAgICAgICAgX191NjQgICBzaXplOyAgICAgICAgICAgICAgICAgICAgICAgICAgIC8qIFNpemUg
b2YgbWFwcGluZyAoYnl0ZXMpICovDQp9Ow0KDQo+ID4gKwlfX3UzMglmbGFnczsNCj4gPiArCV9f
dTE2CWFkZHJfd2lkdGg7DQo+ID4gKwlfX3UxNglwYXNpZF9iaXRzOw0KPiA+ICsJX191MzIJcGFk
ZGluZzsNCj4gPiArCV9fdTgJZGF0YVtdOw0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArLyoNCj4gPiAr
ICogc3RydWN0IGlvbW11X25lc3RpbmdfaW5mb192dGQgLSBJbnRlbCBWVC1kIHNwZWNpZmljIG5l
c3RpbmcgaW5mbw0KPiA+ICsgKg0KPiBzcHVyaW91cyBsaW5lDQoNCnllcywgd2lsbCByZW1vdmUg
dGhpcyBsaW5lLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gPiArICoNCj4gPiArICogQGZsYWdz
OglWVC1kIHNwZWNpZmljIGZsYWdzLiBDdXJyZW50bHkgcmVzZXJ2ZWQgZm9yIGZ1dHVyZQ0KPiA+
ICsgKgkJZXh0ZW5zaW9uLg0KPiA+ICsgKiBAY2FwX3JlZzoJRGVzY3JpYmUgYmFzaWMgY2FwYWJp
bGl0aWVzIGFzIGRlZmluZWQgaW4gVlQtZCBjYXBhYmlsaXR5DQo+ID4gKyAqCQlyZWdpc3Rlci4N
Cj4gPiArICogQGVjYXBfcmVnOglEZXNjcmliZSB0aGUgZXh0ZW5kZWQgY2FwYWJpbGl0aWVzIGFz
IGRlZmluZWQgaW4gVlQtZA0KPiA+ICsgKgkJZXh0ZW5kZWQgY2FwYWJpbGl0eSByZWdpc3Rlci4N
Cj4gPiArICovDQo+ID4gK3N0cnVjdCBpb21tdV9uZXN0aW5nX2luZm9fdnRkIHsNCj4gPiArCV9f
dTMyCWZsYWdzOw0KPiA+ICsJX191MzIJcGFkZGluZzsNCj4gPiArCV9fdTY0CWNhcF9yZWc7DQo+
ID4gKwlfX3U2NAllY2FwX3JlZzsNCj4gPiArfTsNCj4gPiArDQo+ID4gICNlbmRpZiAvKiBfVUFQ
SV9JT01NVV9IICovDQo+ID4NCj4gVGhhbmtzDQo+IA0KPiBFcmljDQoNCg==

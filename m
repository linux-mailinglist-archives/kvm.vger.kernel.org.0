Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F70D225C84
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 12:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgGTKSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 06:18:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:53302 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728007AbgGTKSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 06:18:12 -0400
IronPort-SDR: SXpsYbedff84NJq8FEnkOcZNvqH6yP08z+2P3HLWum6qIKViPM/mPTeVrd5KWWS+yTgoXSehx/
 L9PVFFOOIs/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="147383021"
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="147383021"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 03:18:10 -0700
IronPort-SDR: cee4CPk2U0awZsOchZna2M9bkVUe+lg0V1FJLVASw0jsS3YmYHl5bJEihrjZTkAXfMWaZHM2zI
 etV+aogQENPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,374,1589266800"; 
   d="scan'208";a="326023439"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jul 2020 03:18:09 -0700
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 03:18:09 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX162.amr.corp.intel.com (10.22.240.85) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 03:18:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 03:18:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncgBl3G3K3c4bqIyvnJqVXFHS8wMZkEI62tGfbrMT9uSQJeaJ2QeqhZvXiMIeN1LbvL2XrmVRFuaMiFwRbMYoBpvH6JG3oERxW6v5H4AOewFHM3y3EQGM4R43WtHmvGkSA5hbH84lnFv/6tbsKzfwcw9F3uoEM0yWOaeq/VVUycCWBwx2HAoGLZgBNKKcAL7RoS3DJ6GHRq4IV7lpFxImL0WpYXJtq3sKNSqobnv6XYHq2Naj7BMLWzQBbYg1oQZ63f3R2Ht0joD6q7B9hdpDAoIrSTz0gxYpsPrvPsf3kgt56dgwhEAG68BgpbM4zSr+lhHBbtbvKLbvIz1tV6U9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYW6Emf3irXKctjOfgjMxEQvLPfH1QXxqTfq0MxaGvw=;
 b=BqPa74Kq88NnrOl5fQ59HJ4g4vwVao4SL0RIjmkO9M1y0wyLEUkdpW3FShDXV7yRdHAG/zlLX1/U0d9MhryxsNRaSCkOA78EQHBTMfG1eVfo3ZhkKX7Nvn66kmBSnkLEFFCEEywalRz28IDCpZuGWyyUzkpgtTvIsNuboO8gZmxDxnYS3C/I+6PiVHl9AJ0i5K+8cJmLasPChCdA6hcO40QV9hNF7xXNu7nm5jL20BDbSKyNHfU6iGi2DB3+ax/nZfwF8/R+Z7aPxXY/1pPj2008/xojuuOkf1IyBgcWcQFWaFhDhTdXtMwvc946k+I7eSySLw7Oaop1/B3yrFMKiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYW6Emf3irXKctjOfgjMxEQvLPfH1QXxqTfq0MxaGvw=;
 b=WZgCAFrSFh2M7ZSUxSF5xzYXVbsxiz5ECpKNk4g4zrBhl+o+CiUn+C7A0ErX85hIgpO19TcGwXHDtJmOjWh/IuHA1VUkBocW6VI3kfRW3RlpGEC2C8hGaeF8MLP8IHcoUsMOgg24uD6LuoLhWzE9+ErhX4SMaw4GhRH9dXVy2XY=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1434.namprd11.prod.outlook.com (2603:10b6:4:9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.17; Mon, 20 Jul 2020 10:18:08 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 10:18:07 +0000
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
Subject: RE: [PATCH v5 09/15] iommu/vt-d: Check ownership for PASIDs from
 user-space
Thread-Topic: [PATCH v5 09/15] iommu/vt-d: Check ownership for PASIDs from
 user-space
Thread-Index: AQHWWD2mfecmeDXWOkCzHg/KKlvw3qkPHIEAgAEt7vA=
Date:   Mon, 20 Jul 2020 10:18:07 +0000
Message-ID: <DM5PR11MB14351CB472AEEAFB864A4DFEC37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-10-git-send-email-yi.l.liu@intel.com>
 <b55a09f7-c0ce-f2ff-a725-87a8e042ab80@redhat.com>
In-Reply-To: <b55a09f7-c0ce-f2ff-a725-87a8e042ab80@redhat.com>
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
x-ms-office365-filtering-correlation-id: b0c2b743-8516-4355-470f-08d82c9632ae
x-ms-traffictypediagnostic: DM5PR11MB1434:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB143428779005CC22A63FBBEEC37B0@DM5PR11MB1434.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 14cK+qlcm8CBeqZTvSWMu0ZtuYxpUW7SBrPUmaYALIC1mHFJgWFhJM68Tk7BOdWcSJAFrir7EY3V1IagsGgxwQCq6zVeAM3NGnSusQcjn+2RRakM9CK7gy1F5rqCB6GZoXErNE4v+rA/+Wvbce7Br/yAKhkE2OyIbt+c7GuX5rs10TrD+9cClRCOvzqUPEQJr8a/zQQQbHuFJ3ygvwC2qciiW0qd/Y0Ka+i6cfZNzJaZtjKzGUehu8aaNCavoomAr/0i4818CXjSJ+QCrAO/7KtS7ov2j3RrAGpI+iiIroASQYQUYS0MUaQby/mcnpxxwaHGqldwrexdDlYl9bBVHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(71200400001)(316002)(8936002)(7696005)(186003)(6506007)(52536014)(2906002)(86362001)(53546011)(26005)(110136005)(54906003)(478600001)(8676002)(76116006)(83380400001)(64756008)(66946007)(66476007)(66556008)(66446008)(55016002)(5660300002)(9686003)(33656002)(4326008)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: L2K7jViKne+NhzUItZE9o9Fp7SHTDJI9XNysm2vRWbnK+72G4PN22W3VarmdV+/IK5PwyeWQpQSV6E7lFoMEWW22lZlgtuYTMD+CBAvzaSdna0Uq9j3X/Ae7QefEgai4uzTSey9/qeHWNhVP508vOmWhUSOOxtxJlVBXbXfV/I1RS42ldFtHKqWf2KejN25H+gvJUyyk8W/8jCerPHfYDXpOqiLXqCv8RNlaKFEAEPfMsBrI+WVK/iCn97JcMUP9eaBdx7OjjxKOv6T+Olyua0OUvims/3cnCpQaujuNOChT31BXfYV8+RMMo6KJoEa1vCL2nm/N+FT4peSQBlW99wDUjHZDx0iBRlq1gLytS8koEBK9O/FP9Guxn+vdzJ9A47hBJ2C0yqeBOl8o2aaHrbEOMkN0iqX2A9detZydqrdhnHIDOoWrdzthptI00a0MUnSh+Ys6Pjbp/l+gRhcsVQJJDUcPVFRnKFCoSN6OZpZAPf6kV7JajyfBL8++6rFm
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c2b743-8516-4355-470f-08d82c9632ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 10:18:07.8604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bg3DIFXdDUOCQj1T2bLwH8MCDcEyM4QsC/+z0xXkudjGVeLfNNo6topO2H8oWOQZTxUyQ5OKys8MKRdkfY5XMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1434
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgSnVseSAyMCwgMjAyMCAxMjowNiBBTQ0KPiANCj4gSGkgWWksDQo+IA0K
PiBPbiA3LzEyLzIwIDE6MjEgUE0sIExpdSBZaSBMIHdyb3RlOg0KPiA+IFdoZW4gYW4gSU9NTVUg
ZG9tYWluIHdpdGggbmVzdGluZyBhdHRyaWJ1dGUgaXMgdXNlZCBmb3IgZ3Vlc3QgU1ZBLCBhDQo+
ID4gc3lzdGVtLXdpZGUgUEFTSUQgaXMgYWxsb2NhdGVkIGZvciBiaW5kaW5nIHdpdGggdGhlIGRl
dmljZSBhbmQgdGhlIGRvbWFpbi4NCj4gPiBGb3Igc2VjdXJpdHkgcmVhc29uLCB3ZSBuZWVkIHRv
IGNoZWNrIHRoZSBQQVNJRCBwYXNzc2VkIGZyb20gdXNlci1zcGFjZS4NCj4gcGFzc2VkDQoNCmdv
dCBpdC4NCg0KPiA+IGUuZy4gcGFnZSB0YWJsZSBiaW5kL3VuYmluZCBhbmQgUEFTSUQgcmVsYXRl
ZCBjYWNoZSBpbnZhbGlkYXRpb24uDQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlh
bkBpbnRlbC5jb20+DQo+ID4gQ0M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRl
bC5jb20+DQo+ID4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5j
b20+DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzog
SmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4gQ2M6
IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KPiA+IENjOiBMdSBCYW9sdSA8YmFvbHUu
bHVAbGludXguaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxp
dUBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFu
QGxpbnV4LmludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9pb21tdS9pbnRlbC9pb21t
dS5jIHwgMTAgKysrKysrKysrKw0KPiA+ICBkcml2ZXJzL2lvbW11L2ludGVsL3N2bS5jICAgfCAg
NyArKysrKy0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2ludGVsL2lvbW11
LmMgYi9kcml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMNCj4gPiBpbmRleCA0ZDU0MTk4Li5hOTUw
NGNiIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYw0KPiA+IEBAIC01NDM2LDYgKzU0MzYsNyBA
QCBpbnRlbF9pb21tdV9zdmFfaW52YWxpZGF0ZShzdHJ1Y3QgaW9tbXVfZG9tYWluDQo+ICpkb21h
aW4sIHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiAgCQlpbnQgZ3JhbnUgPSAwOw0KPiA+ICAJCXU2
NCBwYXNpZCA9IDA7DQo+ID4gIAkJdTY0IGFkZHIgPSAwOw0KPiA+ICsJCXZvaWQgKnBkYXRhOw0K
PiA+DQo+ID4gIAkJZ3JhbnUgPSB0b192dGRfZ3JhbnVsYXJpdHkoY2FjaGVfdHlwZSwgaW52X2lu
Zm8tPmdyYW51bGFyaXR5KTsNCj4gPiAgCQlpZiAoZ3JhbnUgPT0gLUVJTlZBTCkgew0KPiA+IEBA
IC01NDU2LDYgKzU0NTcsMTUgQEAgaW50ZWxfaW9tbXVfc3ZhX2ludmFsaWRhdGUoc3RydWN0IGlv
bW11X2RvbWFpbg0KPiAqZG9tYWluLCBzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4gIAkJCSAoaW52
X2luZm8tPmdyYW51LmFkZHJfaW5mby5mbGFncyAmDQo+IElPTU1VX0lOVl9BRERSX0ZMQUdTX1BB
U0lEKSkNCj4gPiAgCQkJcGFzaWQgPSBpbnZfaW5mby0+Z3JhbnUuYWRkcl9pbmZvLnBhc2lkOw0K
PiA+DQo+ID4gKwkJcGRhdGEgPSBpb2FzaWRfZmluZChkbWFyX2RvbWFpbi0+aW9hc2lkX3NpZCwg
cGFzaWQsIE5VTEwpOw0KPiA+ICsJCWlmICghcGRhdGEpIHsNCj4gPiArCQkJcmV0ID0gLUVJTlZB
TDsNCj4gPiArCQkJZ290byBvdXRfdW5sb2NrOw0KPiA+ICsJCX0gZWxzZSBpZiAoSVNfRVJSKHBk
YXRhKSkgew0KPiA+ICsJCQlyZXQgPSBQVFJfRVJSKHBkYXRhKTsNCj4gPiArCQkJZ290byBvdXRf
dW5sb2NrOw0KPiA+ICsJCX0NCj4gPiArDQo+ID4gIAkJc3dpdGNoIChCSVQoY2FjaGVfdHlwZSkp
IHsNCj4gPiAgCQljYXNlIElPTU1VX0NBQ0hFX0lOVl9UWVBFX0lPVExCOg0KPiA+ICAJCQkvKiBI
VyB3aWxsIGlnbm9yZSBMU0IgYml0cyBiYXNlZCBvbiBhZGRyZXNzIG1hc2sgKi8NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9pb21tdS9pbnRlbC9zdm0uYyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwv
c3ZtLmMNCj4gPiBpbmRleCBkMmMwZTFhLi4yMTJkZWUwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvaW9tbXUvaW50ZWwvc3ZtLmMNCj4gPiArKysgYi9kcml2ZXJzL2lvbW11L2ludGVsL3N2bS5j
DQo+ID4gQEAgLTMxOSw3ICszMTksNyBAQCBpbnQgaW50ZWxfc3ZtX2JpbmRfZ3Bhc2lkKHN0cnVj
dCBpb21tdV9kb21haW4gKmRvbWFpbiwNCj4gc3RydWN0IGRldmljZSAqZGV2LA0KPiA+ICAJZG1h
cl9kb21haW4gPSB0b19kbWFyX2RvbWFpbihkb21haW4pOw0KPiA+DQo+ID4gIAltdXRleF9sb2Nr
KCZwYXNpZF9tdXRleCk7DQo+ID4gLQlzdm0gPSBpb2FzaWRfZmluZChJTlZBTElEX0lPQVNJRF9T
RVQsIGRhdGEtPmhwYXNpZCwgTlVMTCk7DQo+IEkgZG8gbm90IGdldCB3aGF0IHRoZSBjYWxsIHdh
cyBzdXBwb3NlZCB0byBkbyBiZWZvcmUgdGhhdCBwYXRjaD8NCg0KeW91IG1lYW4gcGF0Y2ggMTAv
MTUgYnkgInRoYXQgcGF0Y2giLCByaWdodD8gdGhlIG93bmVyc2hpcCBjaGVjayBzaG91bGQNCmJl
IGRvbmUgYXMgdG8gcHJldmVudCBpbGxlZ2FsIGJpbmQgcmVxdWVzdCBmcm9tIHVzZXJzcGFjZS4g
YmVmb3JlIHBhdGNoDQoxMC8xNSwgaXQgc2hvdWxkIGJlIGFkZGVkLg0KDQo+ID4gKwlzdm0gPSBp
b2FzaWRfZmluZChkbWFyX2RvbWFpbi0+aW9hc2lkX3NpZCwgZGF0YS0+aHBhc2lkLCBOVUxMKTsN
Cj4gPiAgCWlmIChJU19FUlIoc3ZtKSkgew0KPiA+ICAJCXJldCA9IFBUUl9FUlIoc3ZtKTsNCj4g
PiAgCQlnb3RvIG91dDsNCj4gPiBAQCAtNDM2LDYgKzQzNiw3IEBAIGludCBpbnRlbF9zdm1fdW5i
aW5kX2dwYXNpZChzdHJ1Y3QgaW9tbXVfZG9tYWluDQo+ICpkb21haW4sDQo+ID4gIAkJCSAgICBz
dHJ1Y3QgZGV2aWNlICpkZXYsIGlvYXNpZF90IHBhc2lkKQ0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3Qg
aW50ZWxfaW9tbXUgKmlvbW11ID0gaW50ZWxfc3ZtX2RldmljZV90b19pb21tdShkZXYpOw0KPiA+
ICsJc3RydWN0IGRtYXJfZG9tYWluICpkbWFyX2RvbWFpbjsNCj4gPiAgCXN0cnVjdCBpbnRlbF9z
dm1fZGV2ICpzZGV2Ow0KPiA+ICAJc3RydWN0IGludGVsX3N2bSAqc3ZtOw0KPiA+ICAJaW50IHJl
dCA9IC1FSU5WQUw7DQo+ID4gQEAgLTQ0Myw4ICs0NDQsMTAgQEAgaW50IGludGVsX3N2bV91bmJp
bmRfZ3Bhc2lkKHN0cnVjdCBpb21tdV9kb21haW4NCj4gKmRvbWFpbiwNCj4gPiAgCWlmIChXQVJO
X09OKCFpb21tdSkpDQo+ID4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ID4NCj4gPiArCWRtYXJfZG9t
YWluID0gdG9fZG1hcl9kb21haW4oZG9tYWluKTsNCj4gPiArDQo+ID4gIAltdXRleF9sb2NrKCZw
YXNpZF9tdXRleCk7DQo+ID4gLQlzdm0gPSBpb2FzaWRfZmluZChJTlZBTElEX0lPQVNJRF9TRVQs
IHBhc2lkLCBOVUxMKTsNCj4gPiArCXN2bSA9IGlvYXNpZF9maW5kKGRtYXJfZG9tYWluLT5pb2Fz
aWRfc2lkLCBwYXNpZCwgTlVMTCk7DQo+IGp1c3QgdG8gbWFrZSBzdXJlLCBhYm91dCB0aGUgbG9j
a2luZywgY2FuJ3QgZG9tYWluLT5pb2FzaWRfc2lkIGNoYW5nZQ0KPiB1bmRlciB0aGUgaG9vZD8N
Cg0KSSBndWVzcyBub3QuIGludGVsX3N2bV91bmJpbmRfZ3Bhc2lkKCkgYW5kIGlvbW11X2RvbWFp
bl9zZXRfYXR0cigpDQppcyBjYWxsZWQgYnkgdmZpbyB0b2RheSwgYW5kIHdpdGhpbiB2ZmlvLCB0
aGVyZSBpcyB2ZmlvX2lvbW11LT5sb2NrLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCj4gDQo+IFRo
YW5rcw0KPiANCj4gRXJpYw0KPiA+ICAJaWYgKCFzdm0pIHsNCj4gPiAgCQlyZXQgPSAtRUlOVkFM
Ow0KPiA+ICAJCWdvdG8gb3V0Ow0KPiA+DQoNCg==

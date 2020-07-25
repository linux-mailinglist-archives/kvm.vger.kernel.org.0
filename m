Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C893A22D63E
	for <lists+kvm@lfdr.de>; Sat, 25 Jul 2020 10:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgGYIyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jul 2020 04:54:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:43775 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgGYIyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jul 2020 04:54:35 -0400
IronPort-SDR: S2o/z5+njbvn2GbgQfM7BMtf9gqklmS9Pxc7HAXE5pqU379qeWG0e5/W28ne9NbgAWRCE9uJlv
 1ZzKa1wMoMhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="148726648"
X-IronPort-AV: E=Sophos;i="5.75,394,1589266800"; 
   d="scan'208";a="148726648"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2020 01:54:03 -0700
IronPort-SDR: dxhChe4rCbP52RQBH4T9Fgs7esZoFioTr0EdVLBB7o60QoONHgIVMcuSwFssWLFyIlS5M+O7QU
 08hghuxvyU3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,394,1589266800"; 
   d="scan'208";a="285164033"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga003.jf.intel.com with ESMTP; 25 Jul 2020 01:54:03 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 25 Jul 2020 01:54:03 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 Jul 2020 01:54:02 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 25 Jul 2020 01:54:02 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.52) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Sat, 25 Jul 2020 01:54:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcRYvctijYjiWghvGd3FDYY0TfVk1TnJt4BwoAgJrfhGriHIaWyf+xO5IEHhAhAmvRX/MWvcBdRs3RJZsdA2V689XKjPXGFhQLWoGxoMwP9h9wzjEOU5Vxbpf5WXCvVrC1BHgKrhXgivZeXfqp88JB/wy3GBEmzG1lj2oe6a2WLFaKoXKoZ6G0xr7X9V5GdGAKN0Ll8gz4nv+YPuf0RjXIqVXv8CQr2sC4asLYQU5PeuVap6aLPhQaAD+LHQ7vS/Lb5GTgizrZNj34jQZuMjagdnF6K9nOYjKU/Mz/3LWTt0LdhsQ9+ZB4vcfTHeHYfEmiDAe6zKZSG7z8EGAgz+hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agzwjwHHAPd+rn91EC6oaIcwrlBmgIZ3BVWvN8lpEXs=;
 b=A+UO822fdMJK6AVXZeOKKNW/byLd4vCPnL+aoqTNW5U1/5QsF5ZFpgTQfebLgS3VFBEYds7DZM4pYLBP73OqELW1Tf+sHIriI9znWVM34NJ51hT0JB+0bjYjdd3N2kV6Ge7o/pwxv5hAw8uds3olxNtRgs5T0k6oVZ3vcRgwEJnbBaVDDboqsZ4fbONHf7EPGhi6ZPF0GHWuLZNiYQ9LQKce9MI+7NdpZVToaq5kqPXRzZXo3zEX0JQn6qK4s64pE4cv3kLE+CgLTOaIwwekHA2yASfqJBNCn8H3caHbqEwnIaAP2f93AnzEbO+7/tiaxHVxdCEKNckssDdpqkL5fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agzwjwHHAPd+rn91EC6oaIcwrlBmgIZ3BVWvN8lpEXs=;
 b=TA+iPYscruwMqhZa6Ns7hZsJdiMskBIZ75mDnckSY5k2Zrh8Xa8LP84tLyvdis0OFMwXS6zucrDjuLok9bKsQopM5tZc1EiEYUFDnIf9Ui5sgZ/3cYfdUxONFHD2/cU41FwIIPelgghvS+KShy0tBFr4Htl2WC05dvZsDvD9b8k=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB2986.namprd11.prod.outlook.com (2603:10b6:5:61::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.23; Sat, 25 Jul 2020 08:54:01 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3216.028; Sat, 25 Jul
 2020 08:54:01 +0000
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
Subject: RE: [PATCH v5 14/15] vfio: Document dual stage control
Thread-Topic: [PATCH v5 14/15] vfio: Document dual stage control
Thread-Index: AQHWWD2o7HgeyPCxwU6S5j5AbWTuiKkNYUMAgAqNBHA=
Date:   Sat, 25 Jul 2020 08:54:00 +0000
Message-ID: <DM5PR11MB143514B963919006B9F79792C3740@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-15-git-send-email-yi.l.liu@intel.com>
 <a97ee4e4-4592-8dd8-fbb1-6c2c5579d625@redhat.com>
In-Reply-To: <a97ee4e4-4592-8dd8-fbb1-6c2c5579d625@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.202]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f294115d-a0d8-4349-fa31-08d8307846a9
x-ms-traffictypediagnostic: DM6PR11MB2986:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB2986D2E105904A09633E67B4C3740@DM6PR11MB2986.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NCCCwMFs6ymBBj8oJIqhJDfiDaHysvFwztprOHEwR8e6+ls6JgNPZQ39/ZGLXfT7YBZe5qzlENBZgt/zR3+e5Q8+jO3jxANBuky0C0VlqyF8yBsF9QCHTyj3y3SVTrvedZoicq0/qTANe3Q5x9iArOpyJrU+BAg5V/JPks9LipAQCROcMJCWDDKxRPcfvc4jWHEevDntCSodWT4fNZg0/VfjGQSEJFNMXV3Pixg1NW175vtTyY5mmNkIlm0rm2zTBhrow807eru2CxXdjCXz5hkrSxWiPb2xXlMSH84Zewe2RYJJJsEtUpH2LeOCLg9GfNmutlKSzYcD78RNMbXxjWrAxltssKm02IbqGmSo+cFONJItKHsiTsgQ61hHoavzfQ4gifq6rX/T2PN2UdNG8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(316002)(66446008)(4326008)(9686003)(53546011)(26005)(83380400001)(7696005)(6506007)(966005)(86362001)(55016002)(76116006)(7416002)(66946007)(64756008)(66556008)(66476007)(54906003)(71200400001)(186003)(52536014)(5660300002)(33656002)(8936002)(478600001)(2906002)(8676002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2WINr6VQ/TQVQqSqFStdFopiF5Po1PdsvbaEqp+SuW4BcpyPOskHwcD7sUgBjv2lfoICM4Z1WOnPDR578dng51Spbj4AsOTbSC101WPa1HGP/IRTDmrl2KxPNtjWxAwEi4v7HJOQ/+of2LZJ6z7bKFO77AzHOjZIKIljuNtXJdvwi6aCjYQdbU99T7ANFzbvcOhBEEDgzGY0kJBxDwerji6Hxur4zSl2maFmc/jNk9o/3pIWnDYgGmoP4dDFku6zP+RdCb1YIXG3jfNt86AU+vWXVj7pQdpRkXPmJM2tQAy6AQOnLVRIIDK9Lbh5wWCrjbcaqSDi4nPU418eK1yV1sYI2eSryB4V1YX6wW+g5n7comYQX9yAA2viXpCnFT5Xk6y6JTKpwRC6SjXPWP4zzcoe2YMU1i4Ctchar5ZnSLwJXhYQbBTuqlrEeywwCs2tSDdNH+G4xa0Zm8mzaGsu3pZQsB1tKmoRHRbWjQ1tKW2dQTxx7cUjCdW3kQGk5t9f
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f294115d-a0d8-4349-fa31-08d8307846a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2020 08:54:00.7760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KU4/Zuj8a2o5ecHW1HMCZUKN22lJeRzj5f8wuc/Y9RIZclRDQCxTRiT34RlgcggHwRKKHQ9bLZr6jBrUzwWLgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2986
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFNhdHVyZGF5LCBKdWx5IDE4LCAyMDIwIDk6NDAgUE0NCj4gDQo+IEhpIFlpLA0KPiAN
Cj4gT24gNy8xMi8yMCAxOjIxIFBNLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBGcm9tOiBFcmljIEF1
Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4NCj4gPiBUaGUgVkZJTyBBUEkgd2FzIGVu
aGFuY2VkIHRvIHN1cHBvcnQgbmVzdGVkIHN0YWdlIGNvbnRyb2w6IGEgYnVuY2ggb2YNCj4gPiBu
ZXcgaW90Y2xzIGFuZCB1c2FnZSBndWlkZWxpbmUuDQo+IGlvY3Rscw0KDQpnb3QgaXQuDQoNCj4g
Pg0KPiA+IExldCdzIGRvY3VtZW50IHRoZSBwcm9jZXNzIHRvIGZvbGxvdyB0byBzZXQgdXAgbmVz
dGVkIG1vZGUuDQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+
DQo+ID4gQ0M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4g
Q2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gQ2M6
IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGlsaXBw
ZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc+DQo+ID4gQ2M6IEpvZXJnIFJvZWRl
bCA8am9yb0A4Ynl0ZXMub3JnPg0KPiA+IENjOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50
ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhh
dC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQu
Y29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+
ID4gLS0tDQo+ID4gdjMgLT4gdjQ6DQo+ID4gKikgYWRkIHJldmlldy1ieSBmcm9tIFN0ZWZhbiBI
YWpub2N6aQ0KPiA+DQo+ID4gdjIgLT4gdjM6DQo+ID4gKikgYWRkcmVzcyBjb21tZW50cyBmcm9t
IFN0ZWZhbiBIYWpub2N6aQ0KPiA+DQo+ID4gdjEgLT4gdjI6DQo+ID4gKikgbmV3IGluIHYyLCBj
b21wYXJlZCB3aXRoIEVyaWMncyBvcmlnaW5hbCB2ZXJzaW9uLCBwYXNpZCB0YWJsZSBiaW5kDQo+
ID4gICAgYW5kIGZhdWx0IHJlcG9ydGluZyBpcyByZW1vdmVkIGFzIHRoaXMgc2VyaWVzIGRvZXNu
J3QgY292ZXIgdGhlbS4NCj4gPiAgICBPcmlnaW5hbCB2ZXJzaW9uIGZyb20gRXJpYy4NCj4gPiAg
ICBodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMC8zLzIwLzcwMA0KPiA+IC0tLQ0KPiA+ICBEb2N1
bWVudGF0aW9uL2RyaXZlci1hcGkvdmZpby5yc3QgfCA2Nw0KPiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDY3IGluc2VydGlvbnMo
KykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RyaXZlci1hcGkvdmZpby5y
c3QgYi9Eb2N1bWVudGF0aW9uL2RyaXZlci1hcGkvdmZpby5yc3QNCj4gPiBpbmRleCBmMWE0ZDNj
Li4wNjcyYzQ1IDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vZHJpdmVyLWFwaS92Zmlv
LnJzdA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZHJpdmVyLWFwaS92ZmlvLnJzdA0KPiA+IEBA
IC0yMzksNiArMjM5LDczIEBAIGdyb3VwIGFuZCBjYW4gYWNjZXNzIHRoZW0gYXMgZm9sbG93czo6
DQo+ID4gIAkvKiBHcmF0dWl0b3VzIGRldmljZSByZXNldCBhbmQgZ28uLi4gKi8NCj4gPiAgCWlv
Y3RsKGRldmljZSwgVkZJT19ERVZJQ0VfUkVTRVQpOw0KPiA+DQo+ID4gK0lPTU1VIER1YWwgU3Rh
Z2UgQ29udHJvbA0KPiA+ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiArDQo+ID4gK1Nv
bWUgSU9NTVVzIHN1cHBvcnQgMiBzdGFnZXMvbGV2ZWxzIG9mIHRyYW5zbGF0aW9uLiBTdGFnZSBj
b3JyZXNwb25kcyB0bw0KPiA+ICt0aGUgQVJNIHRlcm1pbm9sb2d5IHdoaWxlIGxldmVsIGNvcnJl
c3BvbmRzIHRvIEludGVsJ3MgVlREIHRlcm1pbm9sb2d5Lg0KPiA+ICtJbiB0aGUgZm9sbG93aW5n
IHRleHQgd2UgdXNlIGVpdGhlciB3aXRob3V0IGRpc3RpbmN0aW9uLg0KPiA+ICsNCj4gPiArVGhp
cyBpcyB1c2VmdWwgd2hlbiB0aGUgZ3Vlc3QgaXMgZXhwb3NlZCB3aXRoIGEgdmlydHVhbCBJT01N
VSBhbmQgc29tZQ0KPiA+ICtkZXZpY2VzIGFyZSBhc3NpZ25lZCB0byB0aGUgZ3Vlc3QgdGhyb3Vn
aCBWRklPLiBUaGVuIHRoZSBndWVzdCBPUyBjYW4gdXNlDQo+ID4gK3N0YWdlIDEgKEdJT1ZBIC0+
IEdQQSBvciBHVkEtPkdQQSksIHdoaWxlIHRoZSBoeXBlcnZpc29yIHVzZXMgc3RhZ2UgMiBmb3IN
Cj4gPiArVk0gaXNvbGF0aW9uIChHUEEgLT4gSFBBKS4NCj4gPiArDQo+ID4gK1VuZGVyIGR1YWwg
c3RhZ2UgdHJhbnNsYXRpb24sIHRoZSBndWVzdCBnZXRzIG93bmVyc2hpcCBvZiB0aGUgc3RhZ2Ug
MSBwYWdlDQo+ID4gK3RhYmxlcyBhbmQgYWxzbyBvd25zIHN0YWdlIDEgY29uZmlndXJhdGlvbiBz
dHJ1Y3R1cmVzLiBUaGUgaHlwZXJ2aXNvciBvd25zDQo+ID4gK3RoZSByb290IGNvbmZpZ3VyYXRp
b24gc3RydWN0dXJlIChmb3Igc2VjdXJpdHkgcmVhc29uKSwgaW5jbHVkaW5nIHN0YWdlIDINCj4g
PiArY29uZmlndXJhdGlvbi4gVGhpcyB3b3JrcyBhcyBsb25nIGFzIGNvbmZpZ3VyYXRpb24gc3Ry
dWN0dXJlcyBhbmQgcGFnZSB0YWJsZQ0KPiA+ICtmb3JtYXRzIGFyZSBjb21wYXRpYmxlIGJldHdl
ZW4gdGhlIHZpcnR1YWwgSU9NTVUgYW5kIHRoZSBwaHlzaWNhbCBJT01NVS4NCj4gPiArDQo+ID4g
K0Fzc3VtaW5nIHRoZSBIVyBzdXBwb3J0cyBpdCwgdGhpcyBuZXN0ZWQgbW9kZSBpcyBzZWxlY3Rl
ZCBieSBjaG9vc2luZyB0aGUNCj4gPiArVkZJT19UWVBFMV9ORVNUSU5HX0lPTU1VIHR5cGUgdGhy
b3VnaDoNCj4gPiArDQo+ID4gKyAgICBpb2N0bChjb250YWluZXIsIFZGSU9fU0VUX0lPTU1VLCBW
RklPX1RZUEUxX05FU1RJTkdfSU9NTVUpOw0KPiA+ICsNCj4gPiArVGhpcyBmb3JjZXMgdGhlIGh5
cGVydmlzb3IgdG8gdXNlIHRoZSBzdGFnZSAyLCBsZWF2aW5nIHN0YWdlIDEgYXZhaWxhYmxlDQo+
ID4gK2ZvciBndWVzdCB1c2FnZS4gVGhlIGd1ZXN0IHN0YWdlIDEgZm9ybWF0IGRlcGVuZHMgb24g
SU9NTVUgdmVuZG9yLCBhbmQNCj4gPiAraXQgaXMgdGhlIHNhbWUgd2l0aCB0aGUgbmVzdGluZyBj
b25maWd1cmF0aW9uIG1ldGhvZC4gVXNlciBzcGFjZSBzaG91bGQNCj4gPiArY2hlY2sgdGhlIGZv
cm1hdCBhbmQgY29uZmlndXJhdGlvbiBtZXRob2QgYWZ0ZXIgc2V0dGluZyBuZXN0aW5nIHR5cGUg
YnkNCj4gPiArdXNpbmc6DQo+ID4gKw0KPiA+ICsgICAgaW9jdGwoY29udGFpbmVyLT5mZCwgVkZJ
T19JT01NVV9HRVRfSU5GTywgJm5lc3RpbmdfaW5mbyk7DQo+ID4gKw0KPiA+ICtEZXRhaWxzIGNh
biBiZSBmb3VuZCBpbiBEb2N1bWVudGF0aW9uL3VzZXJzcGFjZS1hcGkvaW9tbXUucnN0LiBGb3Ig
SW50ZWwNCj4gPiArVlQtZCwgZWFjaCBzdGFnZSAxIHBhZ2UgdGFibGUgaXMgYm91bmQgdG8gaG9z
dCBieToNCj4gPiArDQo+ID4gKyAgICBuZXN0aW5nX29wLT5mbGFncyA9IFZGSU9fSU9NTVVfTkVT
VElOR19PUF9CSU5EX1BHVEJMOw0KPiA+ICsgICAgbWVtY3B5KCZuZXN0aW5nX29wLT5kYXRhLCAm
YmluZF9kYXRhLCBzaXplb2YoYmluZF9kYXRhKSk7DQo+ID4gKyAgICBpb2N0bChjb250YWluZXIt
PmZkLCBWRklPX0lPTU1VX05FU1RJTkdfT1AsIG5lc3Rpbmdfb3ApOw0KPiA+ICsNCj4gPiArQXMg
bWVudGlvbmVkIGFib3ZlLCBndWVzdCBPUyBtYXkgdXNlIHN0YWdlIDEgZm9yIEdJT1ZBLT5HUEEg
b3IgR1ZBLT5HUEEuDQo+IHRoZSBndWVzdCBPUywgaGVyZSBhbmQgYmVsb3c/DQoNCmdvdCBpdC4N
Cg0KPiA+ICtHVkEtPkdQQSBwYWdlIHRhYmxlcyBhcmUgYXZhaWxhYmxlIHdoZW4gUEFTSUQgKFBy
b2Nlc3MgQWRkcmVzcyBTcGFjZSBJRCkNCj4gPiAraXMgZXhwb3NlZCB0byBndWVzdC4gZS5nLiBn
dWVzdCB3aXRoIFBBU0lELWNhcGFibGUgZGV2aWNlcyBhc3NpZ25lZC4gRm9yDQo+ID4gK3N1Y2gg
cGFnZSB0YWJsZSBiaW5kaW5nLCB0aGUgYmluZF9kYXRhIHNob3VsZCBpbmNsdWRlIFBBU0lEIGlu
Zm8sIHdoaWNoDQo+ID4gK2lzIGFsbG9jYXRlZCBieSBndWVzdCBpdHNlbGYgb3IgYnkgaG9zdC4g
VGhpcyBkZXBlbmRzIG9uIGhhcmR3YXJlIHZlbmRvci4NCj4gPiArZS5nLiBJbnRlbCBWVC1kIHJl
cXVpcmVzIHRvIGFsbG9jYXRlIFBBU0lEIGZyb20gaG9zdC4gVGhpcyByZXF1aXJlbWVudCBpcw0K
PiANCj4gPiArZGVmaW5lZCBieSB0aGUgVmlydHVhbCBDb21tYW5kIFN1cHBvcnQgaW4gVlQtZCAz
LjAgc3BlYywgZ3Vlc3Qgc29mdHdhcmUNCj4gPiArcnVubmluZyBvbiBWVC1kIHNob3VsZCBhbGxv
Y2F0ZSBQQVNJRCBmcm9tIGhvc3Qga2VybmVsLg0KPiBiZWNhdXNlIFZURCAzLjAgcmVxdWlyZXMg
dGhlIHVuaWNpdHkgb2YgdGhlIFBBU0lELCBzeXN0ZW0gd2lkZSwgaW5zdGVhZA0KPiBvZiB0aGUg
YWJvdmUgcmVwZXRpdGlvbi4NCg0KSSBzZWUuIHBlcmhhcHMgYmV0dGVyIHRvIHNheSBJbnRlbCBw
bGF0Zm9ybS4gOi0pIHdpbGwgcmVmaW5lIGl0Lg0KDQo+IA0KPiAgVG8gYWxsb2NhdGUgUEFTSUQN
Cj4gPiArZnJvbSBob3N0LCB1c2VyIHNwYWNlIHNob3VsZCBjaGVjayB0aGUgSU9NTVVfTkVTVElO
R19GRUFUX1NZU1dJREVfUEFTSUQNCj4gPiArYml0IG9mIHRoZSBuZXN0aW5nIGluZm8gcmVwb3J0
ZWQgZnJvbSBob3N0IGtlcm5lbC4gVkZJTyByZXBvcnRzIHRoZSBuZXN0aW5nDQo+ID4gK2luZm8g
YnkgVkZJT19JT01NVV9HRVRfSU5GTy4gVXNlciBzcGFjZSBjb3VsZCBhbGxvY2F0ZSBQQVNJRCBm
cm9tIGhvc3QgYnk6DQo+IGlmIFNZU1dJREVfUEFTSUQgcmVxdWlyZW1lbnQgaXMgZXhwb3NlZCwg
dGhlIHVzZXJzcGFjZSAqbXVzdCogYWxsb2NhdGUgLi4uDQoNCmdvdCBpdC4NCg0KPiA+ICsNCj4g
PiArICAgIHJlcS5mbGFncyA9IFZGSU9fSU9NTVVfQUxMT0NfUEFTSUQ7DQo+ID4gKyAgICBpb2N0
bChjb250YWluZXIsIFZGSU9fSU9NTVVfUEFTSURfUkVRVUVTVCwgJnJlcSk7DQo+ID4gKw0KPiA+
ICtXaXRoIGZpcnN0IHN0YWdlL2xldmVsIHBhZ2UgdGFibGUgYm91bmQgdG8gaG9zdCwgaXQgYWxs
b3dzIHRvIGNvbWJpbmUgdGhlDQo+ID4gK2d1ZXN0IHN0YWdlIDEgdHJhbnNsYXRpb24gYWxvbmcg
d2l0aCB0aGUgaHlwZXJ2aXNvciBzdGFnZSAyIHRyYW5zbGF0aW9uIHRvDQo+ID4gK2dldCBmaW5h
bCBhZGRyZXNzLg0KPiA+ICsNCj4gPiArV2hlbiB0aGUgZ3Vlc3QgaW52YWxpZGF0ZXMgc3RhZ2Ug
MSByZWxhdGVkIGNhY2hlcywgaW52YWxpZGF0aW9ucyBtdXN0IGJlDQo+ID4gK2ZvcndhcmRlZCB0
byB0aGUgaG9zdCB0aHJvdWdoDQo+ID4gKw0KPiA+ICsgICAgbmVzdGluZ19vcC0+ZmxhZ3MgPSBW
RklPX0lPTU1VX05FU1RJTkdfT1BfQ0FDSEVfSU5WTEQ7DQo+ID4gKyAgICBtZW1jcHkoJm5lc3Rp
bmdfb3AtPmRhdGEsICZpbnZfZGF0YSwgc2l6ZW9mKGludl9kYXRhKSk7DQo+ID4gKyAgICBpb2N0
bChjb250YWluZXItPmZkLCBWRklPX0lPTU1VX05FU1RJTkdfT1AsIG5lc3Rpbmdfb3ApOw0KPiA+
ICsNCj4gPiArVGhvc2UgaW52YWxpZGF0aW9ucyBjYW4gaGFwcGVuIGF0IHZhcmlvdXMgZ3JhbnVs
YXJpdHkgbGV2ZWxzLCBwYWdlLCBjb250ZXh0LA0KPiA+ICsuLi4NCj4gPiArDQo+ID4gIFZGSU8g
VXNlciBBUEkNCj4gPiAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBJIHNlZSB5b3UgZHJvcHBl
ZCB0aGUgdW5yZWNvdmVyYWJsZSBlcnJvciByZXBvcnRpbmcgcGFydCBvZiB0aGUgb3JpZ2luYWwN
Cj4gY29udHJpYnV0aW9uLiBCeSB0aGUgd2F5IGRvbid0IHlvdSBuZWVkIGFueSBlcnJvciBoYW5k
bGluZyBmb3IgZWl0aGVyIG9mDQo+IHRoZSB1c2UgY2FzZXMgb24gdnRkPw0KDQp5ZXMsIEkgZHJv
cHBlZCB0aGUgZXJyb3IgcmVwb3J0aW5nIHBhcnQsIHRoZSByZWFzb24gaXMgdGhlIHNlcmllcyBk
b2VzbuKAmXQNCmluY2x1ZGUgdGhlIGVycm9yIHJlcG9ydGluZyBzdXBwb3J0LiBndWVzcyBhZGRp
bmcgaXQgd2hlbiB0aGUgZXJyb3INCnJlcG9ydGluZyBpcyBzZW50IG91dC4NCg0KUmVnYXJkcywN
CllpIExpdQ0KDQo+ID4NCj4gPg0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCg0K

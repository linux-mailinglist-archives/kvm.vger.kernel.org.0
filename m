Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBAE226050
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 15:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGTNAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 09:00:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:21575 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgGTNAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 09:00:34 -0400
IronPort-SDR: IB29xyGOoF2tMVg/dw0CnhnRSinXFlnwEjzj+YC1ODgNGhDsoDf/r6hhmBVqrDtd4NHkhChZlP
 AHKHz31UJ27Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9687"; a="129469145"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="129469145"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 06:00:17 -0700
IronPort-SDR: JdONsuqgKYK9ARt2Nm5PMCXYydE8D7eK71cXjB3AvmL0zo7Fhg12DhoWVVKJAAIH7QcHRgJOr9
 dRUC7R3Sugyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="487233624"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jul 2020 06:00:17 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Jul 2020 06:00:16 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 20 Jul 2020 06:00:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Jul 2020 06:00:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yf+18PMfJsbw4dZuSXjVePkEHZVlferIuJitLFSF3OCP+/OCtPw9QRW7v4dnrl04HJADVi8Le5SRitum8BGD4JkOmutHwzRpB3BwyNddDJt9l888o96GzBAggjWKRPlK43Hv4dX2184zEKnt3xq61i23/0kxeO+lsmXIJi6lZCWYG5x0W4xhmE2f8CxOYQE6ZnH52+fBOXASgQiQUqWIfdY/lob5Cy+9q8m/Vu/iBXScM4fPRxX3etaJEYQShiZi7edZWf7FYfGb/54gPCV3ab3epmwj6CHe7HAI78iIZ+PMJk/1CdbLYnujr5o9PPpjVXcMMz6R5US2FgZXi34y3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pl8vfuW0QH9mxKLIpUOPIjA/vdzixjdaQkifaEZrr0Q=;
 b=nL7Ormy+xRAISx+Roxr2DrNh2KwOhXOqqmJ9o/o+MorkFEYDIEB12XF4gFoiGtEOOIZCEHkFNM9oSA948sI48e94i7zTGOWJBWBs60MSW6x/po42oqG6WJR2RGs5ofelXjk0uTXAX3fPfjHcztkesdOs/hkUjd0AzTnQEJx1pZRcWNbnLsveqSqCp+QlLnr+WR+4BdqEkZE5cE3imXzDT5M7Ssehw/6Fpxc5VoQIxwzzrNLDy7+nOYrF11Y+FTO4a0NIftA9eXffPZcZ5gERw7fa5J+FSlpEu47f82Rt+hYhPLB6rCjVLzI3VbvRw7mTouiuIt33bOb4mdt3Xf1/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pl8vfuW0QH9mxKLIpUOPIjA/vdzixjdaQkifaEZrr0Q=;
 b=PkpoY4R+Zlepu51AEOBJ0JEiIf1SCNor/ZhYAjEB22QR2VsXUce75nfOdkdQRcyI224N4PRyZBsHOMWX2VODYCUsyTPy1LnQnACx3GOs/3eydoNbxv9NstYTmCkGayurLGloXqOW/gSnasTrKDNDwhqfVIyxkugC5A0+QNoGNiY=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3291.namprd11.prod.outlook.com (2603:10b6:5:d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Mon, 20 Jul 2020 13:00:14 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3195.025; Mon, 20 Jul
 2020 13:00:14 +0000
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
Subject: RE: [PATCH v5 13/15] vfio/pci: Expose PCIe PASID capability to guest
Thread-Topic: [PATCH v5 13/15] vfio/pci: Expose PCIe PASID capability to guest
Thread-Index: AQHWWD2mzUJ6HDvde0eWOdamhXnigKkQdAEAgAAFwTA=
Date:   Mon, 20 Jul 2020 13:00:14 +0000
Message-ID: <DM5PR11MB143507550E22674C76F881C0C37B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-14-git-send-email-yi.l.liu@intel.com>
 <63d4c058-246d-1a11-af66-e97fd5ec9bd3@redhat.com>
In-Reply-To: <63d4c058-246d-1a11-af66-e97fd5ec9bd3@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8ca0755-aa8b-4b5e-6882-08d82cacd863
x-ms-traffictypediagnostic: DM6PR11MB3291:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3291275FA30F671FE9B7CA08C37B0@DM6PR11MB3291.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HKKCqVwlviiGLSmzV3rN1h/ReiT76kTDrpgDHVu3kQ6vNQGd2YHiQDI66FOHeM6HSmB4Nt9FoYOipftkyF1QdpfeITjAlFi5DhsjAhIZueljH+j4fA+INGtvssRQrxnsCry6qhIdYnx64NuqjmPI3nze1XTe5/EGCrME8lAN9KwwMXyJBNV5CRcPLzvZh4+FApePioWxFOb+5Rp8mYtEUd4OPVbzIesR/C6X5GIS+JV+F4gk5IvE1jh0VcaGcgYYdX7eCJ69uID+QRwu9LoTanoBX1D0k9a/Of6E+I0YKR8LSgPxdB+Kj+KRbzjuIvpKSDdQwqAXx+pz+guDfWAZVq/dJnvU7VWqkigq57p997ckpp4EM1MCB9KdF4+l7IEHnYP9OKAh+g09vOaWgtau6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(76116006)(186003)(55016002)(66446008)(66476007)(66946007)(33656002)(86362001)(9686003)(478600001)(26005)(966005)(64756008)(4326008)(66556008)(6506007)(8676002)(83380400001)(71200400001)(316002)(5660300002)(110136005)(53546011)(7416002)(2906002)(8936002)(54906003)(7696005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: SzWF5Z9wFc00rDUGYoJt2V+tQJ1zPcWAj4/X608guE2atZ7BUD00gyfj5VeHihLrKVlqN9JdwhIXtRirkOx0fcPqWFLzWRZh77bL4N2UnJiAmilo9PI65yP3/WZGdCbgqgnC2ghNOCV3X1i3YWbGxppH3wIBO+9oyOUJvYztoTVL2lOwy89a+hPux63DiTNVvmPYdF0Z9dI4SSYtdMrniVBWNGDaelLMzjR2ACLcjXQeGplUJzuxHTrioNYoCesuBIKh/TACvqngYmXfx0z3ifHDDaESh+6Wb8Zi6m1M9lFRY2CoUQNstzTeMLL5vMiAGyxNx2f90U01Xu5rUD3QLMA6pDGGvk4YtqELqPhH0PzQb9jy0fj5VP1wy6K79cVW4OlKOdoUTXFYxXJ1ecshZgfLrBHNxWrweCXjDqmAy6N2gjvaYVYd8T4jy0rn0zEWlvIY3viAxyBFKGy14LUfohy3YIeY4YuTU58uusgVByrW0jT5nZrJbfl1E29EbMMH
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ca0755-aa8b-4b5e-6882-08d82cacd863
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 13:00:14.8646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TQM8XteiVfkYXoP7W6bS65U1x9T/bar0F0I9EWiRT9kgjrRLC9cEwveO28eXybFWIZCIzSsMs8MBjuhReW7BCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3291
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IE1vbmRheSwgSnVseSAyMCwgMjAyMCA4OjM1IFBNDQo+IA0KPiBZaSwNCj4gDQo+IE9u
IDcvMTIvMjAgMToyMSBQTSwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBleHBvc2Vz
IFBDSWUgUEFTSUQgY2FwYWJpbGl0eSB0byBndWVzdCBmb3IgYXNzaWduZWQgZGV2aWNlcy4NCj4g
PiBFeGlzdGluZyB2ZmlvX3BjaSBkcml2ZXIgaGlkZXMgaXQgZnJvbSBndWVzdCBieSBzZXR0aW5n
IHRoZSBjYXBhYmlsaXR5DQo+ID4gbGVuZ3RoIGFzIDAgaW4gcGNpX2V4dF9jYXBfbGVuZ3RoW10u
DQo+ID4NCj4gPiBBbmQgdGhpcyBwYXRjaCBvbmx5IGV4cG9zZXMgUEFTSUQgY2FwYWJpbGl0eSBm
b3IgZGV2aWNlcyB3aGljaCBoYXMgUENJZQ0KPiA+IFBBU0lEIGV4dGVuZGVkIHN0cnV0dXJlIGlu
IGl0cyBjb25maWd1cmF0aW9uIHNwYWNlLiBTbyBWRnMsIHdpbGwgd2lsbA0KPiBzL3dpbGwvLw0K
DQpnb3QgaXQuDQoNCj4gPiBub3Qgc2VlIFBBU0lEIGNhcGFiaWxpdHkgb24gVkZzIGFzIFZGIGRv
ZXNuJ3QgaW1wbGVtZW50IFBBU0lEIGV4dGVuZGVkDQo+IHN1Z2dlc3RlZCByZXdvcmRpbmc6IFZG
cyB3aWxsIG5vdCBleHBvc2UgdGhlIFBBU0lEIGNhcGFiaWxpdHkgYXMgdGhleSBkbw0KPiBub3Qg
aW1wbGVtZW50IHRoZSBQQVNJRCBleHRlbmRlZCBzdHJ1Y3R1cmUgaW4gdGhlaXIgY29uZmlnIHNw
YWNlPw0KDQptYWtlIHNlbnNlLiB3aWxsIG1vZGlmeSBpdC4NCg0KPiA+IHN0cnVjdHVyZSBpbiBp
dHMgY29uZmlndXJhdGlvbiBzcGFjZS4gRm9yIFZGLCBpdCBpcyBhIFRPRE8gaW4gZnV0dXJlLg0K
PiA+IFJlbGF0ZWQgZGlzY3Vzc2lvbiBjYW4gYmUgZm91bmQgaW4gYmVsb3cgbGluazoNCj4gPg0K
PiA+IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIwLzQvNy82OTMNCj4gDQo+ID4NCj4gPiBDYzog
S2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQ0M6IEphY29iIFBhbiA8amFj
b2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxl
eC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gQ2M6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJA
cmVkaGF0LmNvbT4NCj4gPiBDYzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBl
QGxpbmFyby5vcmc+DQo+ID4gQ2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KPiA+
IENjOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gdjEgLT4gdjI6
DQo+ID4gKikgYWRkZWQgaW4gdjIsIGJ1dCBpdCB3YXMgc2VudCBpbiBhIHNlcGFyYXRlIHBhdGNo
c2VyaWVzIGJlZm9yZQ0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2Nv
bmZpZy5jIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVs
ZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNp
X2NvbmZpZy5jIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb25maWcuYw0KPiA+IGluZGV4
IGQ5ODg0M2YuLjA3ZmYyZTYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92ZmlvL3BjaS92Zmlv
X3BjaV9jb25maWcuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29uZmln
LmMNCj4gPiBAQCAtOTUsNyArOTUsNyBAQCBzdGF0aWMgY29uc3QgdTE2IHBjaV9leHRfY2FwX2xl
bmd0aFtQQ0lfRVhUX0NBUF9JRF9NQVggKw0KPiAxXSA9IHsNCj4gPiAgCVtQQ0lfRVhUX0NBUF9J
RF9MVFJdCT0JUENJX0VYVF9DQVBfTFRSX1NJWkVPRiwNCj4gPiAgCVtQQ0lfRVhUX0NBUF9JRF9T
RUNQQ0ldCT0JMCwJLyogbm90IHlldCAqLw0KPiA+ICAJW1BDSV9FWFRfQ0FQX0lEX1BNVVhdCT0J
MCwJLyogbm90IHlldCAqLw0KPiA+IC0JW1BDSV9FWFRfQ0FQX0lEX1BBU0lEXQk9CTAsCS8qIG5v
dCB5ZXQgKi8NCj4gPiArCVtQQ0lfRVhUX0NBUF9JRF9QQVNJRF0JPQlQQ0lfRVhUX0NBUF9QQVNJ
RF9TSVpFT0YsDQo+ID4gIH07DQo+ID4NCj4gPiAgLyoNCj4gPg0KPiBSZXZpZXdlZC1ieTogRXJp
YyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KDQp0aGFua3MuDQoNClJlZ2FyZHMsDQpZ
aSBMaXUNCg0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCg0K

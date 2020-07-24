Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF4222C373
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 12:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgGXKkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 06:40:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:31451 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgGXKkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 06:40:10 -0400
IronPort-SDR: tqKvTP9EE52FRzF2rR1iMQ3Lnaeldu8+PPqtMXcUNdI/Fd/Sq68lmtN3A3NufhJSrb9wXpruoZ
 AO1eI+gFLZFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="149877908"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="149877908"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 03:40:05 -0700
IronPort-SDR: sS4lHlbeyAqWrkbY56hsbcluYYX7xw7D4IVpK7r2YvxGhuJCY+kPSvmTK0aErb6zXI6IT7ksuM
 mD7McNL26xbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="319275670"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga008.jf.intel.com with ESMTP; 24 Jul 2020 03:40:05 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Jul 2020 03:40:05 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX113.amr.corp.intel.com (10.22.240.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Jul 2020 03:40:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Jul 2020 03:40:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6ZdEkn7FNObI09rb7FWztvlb9TaTuyHw6X6s5Dq/IECdxtJ9fviZHhYedy35erVGGNT7nCjaJhR9jw60F2J1sh3JjiafkmcpJlYFwT3sfxw1BwgUKLJzxg1YisvANzsBXpF2V9+gwLiPeImI+Xr2DwaM1Cch/7KYkpRD0etL3Ua+4HaOkNcbb9aUKFo0xxB9+pmoiKGWHrbANrNVSMjR5UvoQdFI2QJXHWFjEQ9twNgr0UTzlavuc7Ws8YBRHckeaL1Oy/foytA8JV740ou+SZd5S99vMFyRM1kXuYLs5WS8fQRv9LeKRNUCdjzB6KtZ11Mz8GNltLnDhihjWML4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0RLQBnNxPs+kUo9gz5ljCAxzef+1UuVxPGWjkdSiWs=;
 b=byXR1vFRezvIIx9ABO0T72aGyh43UNXyh0Y5HACx+1beGkRTvZkULx0UIH+RCPx1Cewye+7RjL++owkFcmI28e1YLTm3CDTaLZj350zRiWxWBNLdou4USV8dii/K5z+OQdyBKfc+mxwe3qkZZN6+11mwNrfMkdmERYm1bWRoAQzfjeQNSXYR+hQbepDZ+nH+S70P1OK/grBrucShLX232PKrZg/i4RDwgx0KWptAnLdALejiZJmcpe8S7oHc/A8H95c7Lz8iKWNAE/bZQ1OpggB8OJ0i8yIkKN8+g6wied4vgj6TsCV4krGgDHHO8DyoARsfUYd0L1tf35vCt9yQGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P0RLQBnNxPs+kUo9gz5ljCAxzef+1UuVxPGWjkdSiWs=;
 b=rUrOGF8byBmH/e5H9wxIKVgPi696f20DPMwZuDMCTSBfGWIX32zTZzmmcI6FaFA7j5EeHkD6FJkYN6kLtLKFqi2nQM+RWffUsC3sbidKlnK56BzysE5eVmyaz6myfOYugJ0O6dhlbj1z2djZ6hK9KtBFae8Lnl9limZqiAgOmBU=
Received: from SN6PR11MB2880.namprd11.prod.outlook.com (2603:10b6:805:58::15)
 by SN6PR11MB2958.namprd11.prod.outlook.com (2603:10b6:805:da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.25; Fri, 24 Jul
 2020 10:40:00 +0000
Received: from SN6PR11MB2880.namprd11.prod.outlook.com
 ([fe80::ec8b:8f35:800d:13f4]) by SN6PR11MB2880.namprd11.prod.outlook.com
 ([fe80::ec8b:8f35:800d:13f4%3]) with mapi id 15.20.3216.023; Fri, 24 Jul 2020
 10:39:59 +0000
From:   "Trahe, Fiona" <fiona.trahe@intel.com>
To:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "vdronov@redhat.com" <vdronov@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Chambers, Mark A" <mark.a.chambers@intel.com>,
        "McFadden, Gordon" <gordon.mcfadden@intel.com>,
        "Atta, Ahsan" <ahsan.atta@intel.com>,
        qat-linux <qat-linux@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 0/5] vfio/pci: add denylist and disable qat
Thread-Topic: [PATCH v4 0/5] vfio/pci: add denylist and disable qat
Thread-Index: AQHWYZcuEL3PT1IzKUy60wrGztz9PqkWiU4A
Date:   Fri, 24 Jul 2020 10:39:59 +0000
Message-ID: <SN6PR11MB288054DCE37102306FB38E9EE4770@SN6PR11MB2880.namprd11.prod.outlook.com>
References: <20200724084800.6136-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20200724084800.6136-1-giovanni.cabiddu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [51.37.123.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd46558a-b382-4442-4d34-08d82fbdea58
x-ms-traffictypediagnostic: SN6PR11MB2958:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2958D130A50EE57D10ACCB07E4770@SN6PR11MB2958.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V8IkJWxTIT920aSg3QfXHabU+saiHnMNz9NCbOPXG3kEyVg8j3xuMQ/Rc2slr/e4w1oW3R4paTZpvVWQPaO3glcFPNUhpvk5yVOyydWlceDNOBFl1qlXbbdO9mJqKyvy9vMW016pIuZtIcbwss8kfB6cstMuCUcF1LKpZYqHGOHbjz0oEk2mbNv+sjLAtOFkUvhR2VVSvFDc23jLadXc6SaUq3+Pu+kenERMHOLiTNfvCZOl0IhW8SA0MS1CGDDqReJEMDxWpoqMte4nvKfow+hWu0EDiGruOYgdw5HT6r/QM7hI6rC82MBgazUQeT1s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2880.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(52536014)(186003)(26005)(5660300002)(8936002)(2906002)(86362001)(7416002)(8676002)(76116006)(6506007)(66946007)(66556008)(64756008)(66446008)(66476007)(53546011)(7696005)(71200400001)(9686003)(4326008)(33656002)(83380400001)(478600001)(54906003)(55016002)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: q+KFBNTMjSeYrnsyCACfXMvoC8nVEdDSSlN8N6+7qH5KbwpG64MK0lmn4Bz41bDrV+xr9x+q2I6CUcwjaZIBVTMvlwNdrnLGSALdhC+YqXWj6UAtVTKFhbRZtRM5//uMRIck/jvnvrCpnr2orKyycUPuNJukgUyE3g3oS3bBmZc1Rs6RxU2+C+lhyZJae5/wdyb6ZFI0YeJbvhdrgXZmhXR42Bf73yjprs7bOFzB0AMfIslrhsPJeOl36R/jAo7nJwZfAje7xa9cQK8twrM6im8eGiEneqEst+CdrYUQrLsRh9CX+0juP/0+2HMbsTS8stR3kVVINcTfxSP2/zfIvmgoeiea97GhH4+PAXMz1I+taATRPpJXh/lCfRIKVFoJ7PfVHf/s+BBB8VU46LyPkCd5+VRjOQiSaL6FP7oReAJJCsDSu4USfc1cJGZosfmK4Ufak3iod+iqG/WRtZ3w19kNdotC+PDYhIRjtOcU/H0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2880.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd46558a-b382-4442-4d34-08d82fbdea58
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 10:39:59.8865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nVyZaxFNH3C+0l9kJuDkknKsRGbojEbqSRsuiXDnhp6ALYhPIPvP+irwXfOAswnqNtBAxxDorV5ULoTdGSnKRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2958
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ2FiaWRkdSwgR2lvdmFu
bmkgPGdpb3Zhbm5pLmNhYmlkZHVAaW50ZWwuY29tPg0KPiBTZW50OiBGcmlkYXksIEp1bHkgMjQs
IDIwMjAgOTo0OCBBTQ0KPiBUbzogYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb207IGhlcmJlcnRA
Z29uZG9yLmFwYW5hLm9yZy5hdQ0KPiBDYzogY29odWNrQHJlZGhhdC5jb207IG5ob3JtYW5AcmVk
aGF0LmNvbTsgdmRyb25vdkByZWRoYXQuY29tOyBiaGVsZ2Fhc0Bnb29nbGUuY29tOw0KPiBDaGFt
YmVycywgTWFyayBBIDxtYXJrLmEuY2hhbWJlcnNAaW50ZWwuY29tPjsgTWNGYWRkZW4sIEdvcmRv
biA8Z29yZG9uLm1jZmFkZGVuQGludGVsLmNvbT47DQo+IEF0dGEsIEFoc2FuIDxhaHNhbi5hdHRh
QGludGVsLmNvbT47IFRyYWhlLCBGaW9uYSA8ZmlvbmEudHJhaGVAaW50ZWwuY29tPjsgcWF0LWxp
bnV4IDxxYXQtDQo+IGxpbnV4QGludGVsLmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXBjaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBDYWJpZGR1LCBHaW92YW5uaSA8Z2lvdmFubmku
Y2FiaWRkdUBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCB2NCAwLzVdIHZmaW8vcGNpOiBh
ZGQgZGVueWxpc3QgYW5kIGRpc2FibGUgcWF0DQo+IA0KPiBUaGlzIHBhdGNoc2V0IGRlZmluZXMg
YSBkZW55bGlzdCBvZiBkZXZpY2VzIGluIHRoZSB2ZmlvLXBjaSBtb2R1bGUgYW5kIGFkZHMNCj4g
dGhlIGN1cnJlbnQgZ2VuZXJhdGlvbiBvZiBJbnRlbChSKSBRdWlja0Fzc2lzdCBkZXZpY2VzIHRv
IGl0IGFzIHRoZXkgYXJlDQo+IG5vdCBkZXNpZ25lZCB0byBydW4gaW4gYW4gdW50cnVzdGVkIGVu
dmlyb25tZW50Lg0KPiANCj4gQnkgZGVmYXVsdCwgaWYgYSBkZXZpY2UgaXMgaW4gdGhlIGRlbnls
aXN0LCB0aGUgcHJvYmUgb2YgdmZpby1wY2kgZmFpbHMuDQo+IElmIGEgdXNlciB3YW50cyB0byB1
c2UgYSBkZXZpY2UgaW4gdGhlIGRlbnlsaXN0LCBoZSBuZWVkcyB0byBkaXNhYmxlIHRoZQ0KPiBm
dWxsIGRlbnlsaXN0IHByb3ZpZGluZyB0aGUgb3B0aW9uIGRpc2FibGVfZGVueWxpc3Q9MSBhdCB0
aGUgbG9hZCBvZg0KPiB2ZmlvLXBjaSBvciBzcGVjaWZ5aW5nIHRoYXQgcGFyYW1ldGVyIGluIGEg
Y29uZmlnIGZpbGUgaW4gL2V0Yy9tb2Rwcm9iZS5kLg0KPiANCj4gVGhpcyBzZXJpZXMgYWxzbyBt
b3ZlcyB0aGUgZGV2aWNlIGlkcyBkZWZpbml0aW9ucyBwcmVzZW50IGluIHRoZSBxYXQgZHJpdmVy
DQo+IHRvIGxpbnV4L3BjaV9pZHMuaCBzaW5jZSB0aGV5IHdpbGwgYmUgc2hhcmVkIGJldHdlZW4g
dGhlIHZmaW8tcGNpIGFuZCB0aGUgcWF0DQo+IGRyaXZlcnMgYW5kIHJlcGxhY2VzIHRoZSBjdXN0
b20gQURGX1NZU1RFTV9ERVZJQ0UgbWFjcm8gd2l0aCBQQ0lfVkRFVklDRS4NCj4gDQo+IFRoZSBz
ZXJpZXMgaXMgYXBwbGljYWJsZSB0byBIZXJiZXJ0J3MgdHJlZS4gUGF0Y2hlcyAxIHRvIDMgYXBw
bHkgYWxzbyB0bw0KPiBBbGV4J3MgdHJlZSAobmV4dCkuIFBhdGNoZXMgNCBhbmQgNSBhcmUgb3B0
aW9uYWwgYW5kIGNhbiBiZSBhcHBsaWVkIGF0IGEgbGF0ZXINCj4gc3RhZ2UuDQo+IA0KPiBDaGFu
Z2VzIGZyb20gdjM6DQo+ICAtIFBhdGNoICMxOiBpbmNsdWRlZCBBY2tlZC1ieSB0YWcsIGFmdGVy
IGFjayBmcm9tIEJqb3JuIEhlbGdhYXMNCj4gIC0gUGF0Y2ggIzI6IHMvcHJldmVudHMvYWxsb3dz
LyBpbiBtb2R1bGUgcGFyYW1ldGVyIGRlc2NyaXB0aW9uDQo+IA0KPiBDaGFuZ2VzIGZyb20gdjI6
DQo+ICAtIFJlbmFtZWQgYmxvY2tsaXN0IGluIGRlbnlsaXN0DQo+ICAtIFBhdGNoICMyOiByZXdv
cmRlZCBtb2R1bGUgcGFyYW1ldGVyIGRlc2NyaXB0aW9uIHRvIGNsYXJpZnkgd2h5IGEgZGV2aWNl
IGlzDQo+ICAgIGluIHRoZSBkZW55bGlzdA0KPiAgLSBQYXRjaCAjMjogcmV3b3JkZWQgd2Fybmlu
ZyB0aGF0IG9jY3VycyB3aGVuIGRlbnlsaXN0IGlzIGVuYWJsZWQgYW5kIGRldmljZQ0KPiAgICBp
cyBwcmVzZW50IGluIHRoYXQgbGlzdA0KPiANCj4gQ2hhbmdlcyBmcm9tIHYxOg0KPiAgLSBSZXdv
cmtlZCBjb21taXQgbWVzc2FnZXM6DQo+ICAgIFBhdGNoZXMgIzEsICMyIGFuZCAjMzogY2FwaXRh
bGl6ZWQgZmlyc3QgY2hhcmFjdGVyIGFmdGVyIGNvbHVtbiB0byBjb21wbHkgdG8NCj4gICAgc3Vi
amVjdCBsaW5lIGNvbnZlbnRpb24NCj4gICAgUGF0Y2ggIzM6IENhcGl0YWxpemVkIFFBVCBhY3Jv
bnltIGFuZCBhZGRlZCBsaW5rIGFuZCBkb2MgbnVtYmVyIGZvciBkb2N1bWVudA0KPiAgICAiSW50
ZWzCriBRdWlja0Fzc2lzdCBUZWNobm9sb2d5IChJbnRlbMKuIFFBVCkgU29mdHdhcmUgZm9yIExp
bnV4Ig0KPiANCj4gR2lvdmFubmkgQ2FiaWRkdSAoNSk6DQo+ICAgUENJOiBBZGQgSW50ZWwgUXVp
Y2tBc3Npc3QgZGV2aWNlIElEcw0KPiAgIHZmaW8vcGNpOiBBZGQgZGV2aWNlIGRlbnlsaXN0DQo+
ICAgdmZpby9wY2k6IEFkZCBRQVQgZGV2aWNlcyB0byBkZW55bGlzdA0KPiAgIGNyeXB0bzogcWF0
IC0gcmVwbGFjZSBkZXZpY2UgaWRzIGRlZmluZXMNCj4gICBjcnlwdG86IHFhdCAtIHVzZSBQQ0lf
VkRFVklDRQ0KPiANCj4gIGRyaXZlcnMvY3J5cHRvL3FhdC9xYXRfYzN4eHgvYWRmX2Rydi5jICAg
ICAgICB8IDExICsrLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9xYXQvcWF0X2MzeHh4dmYvYWRmX2Ry
di5jICAgICAgfCAxMSArKy0tLQ0KPiAgZHJpdmVycy9jcnlwdG8vcWF0L3FhdF9jNjJ4L2FkZl9k
cnYuYyAgICAgICAgIHwgMTEgKystLS0NCj4gIGRyaXZlcnMvY3J5cHRvL3FhdC9xYXRfYzYyeHZm
L2FkZl9kcnYuYyAgICAgICB8IDExICsrLS0tDQo+ICAuLi4vY3J5cHRvL3FhdC9xYXRfY29tbW9u
L2FkZl9hY2NlbF9kZXZpY2VzLmggfCAgNiAtLS0NCj4gIGRyaXZlcnMvY3J5cHRvL3FhdC9xYXRf
Y29tbW9uL3FhdF9oYWwuYyAgICAgICB8ICA3ICstLQ0KPiAgZHJpdmVycy9jcnlwdG8vcWF0L3Fh
dF9jb21tb24vcWF0X3VjbG8uYyAgICAgIHwgIDkgKystLQ0KPiAgZHJpdmVycy9jcnlwdG8vcWF0
L3FhdF9kaDg5NXhjYy9hZGZfZHJ2LmMgICAgIHwgMTEgKystLS0NCj4gIGRyaXZlcnMvY3J5cHRv
L3FhdC9xYXRfZGg4OTV4Y2N2Zi9hZGZfZHJ2LmMgICB8IDExICsrLS0tDQo+ICBkcml2ZXJzL3Zm
aW8vcGNpL3ZmaW9fcGNpLmMgICAgICAgICAgICAgICAgICAgfCA0OCArKysrKysrKysrKysrKysr
KysrDQo+ICBpbmNsdWRlL2xpbnV4L3BjaV9pZHMuaCAgICAgICAgICAgICAgICAgICAgICAgfCAg
NiArKysNCj4gIDExIGZpbGVzIGNoYW5nZWQsIDg3IGluc2VydGlvbnMoKyksIDU1IGRlbGV0aW9u
cygtKQ0KPiANCj4gLS0NCj4gMi4yNi4yDQpSZXZpZXdlZC1ieTogRmlvbmEgVHJhaGUgPGZpb25h
LnRyYWhlQGludGVsLmNvbT4NCg0K

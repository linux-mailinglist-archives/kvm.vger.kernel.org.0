Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FB328B06A
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 10:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgJLIjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 04:39:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:32933 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgJLIjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 04:39:02 -0400
IronPort-SDR: ijZG9ZmKaSMWTd2exfqp5NSqJ/qRuZ1lAX3apkv48GCWnJXtcf13GDcXrAH2CVp72JDvR+43zq
 PZ2ZZBKi2caA==
X-IronPort-AV: E=McAfee;i="6000,8403,9771"; a="145028683"
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="145028683"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 01:39:02 -0700
IronPort-SDR: euLG8Sa/3LTQ6v4wGskxBLFi7jaX3B+jdBwZDfgLfxMR9BWn6qqAz5ey51p4RZkS/h/bF/BMKT
 9Q2fhcH2EkEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="313374461"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 12 Oct 2020 01:39:02 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 01:39:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Oct 2020 01:39:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 12 Oct 2020 01:38:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2FgDYMIPRl75pSg2CMjLQKl1/lw5Re+sr7Am+jglGsPOrIu8PthGOTFDJNXI+QSCXeX2k/dwr+T4VUfWD/vkMlpusdZpvYbeRmCbYxGf5Ds1xqVhY6yIgaZyGK/WcefSKfKzyaoTCxKMv9O34ivo4eYEn+ZGm30o/eFLmHKLN0WAcsPIHmdVMeKL9agM0RgvtZmIW7+R1cR+anMO/UL+85lw0zFj++48rCCj+d5GGr/OcodPrtmvl/mgzlAlOpfabeIxc643EZc9HLmF6RE1KlcDnjxaMIe1xZIxR+teIwsn3zW2o+QdSbnXkD1S7iw9d4gdmXkwiod8xURdGAziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ItKLua+ugVrbTuEJp88AEEcT7Gx/XR+5bsIslM57dc=;
 b=iSn4C/Jgeic1Ih96OJ5Q0UyHojGaJvLeHODJp0lb/O9ZOY2NN1dcIK1xu9y92epr6Ff6zi5Q1PUP30IunuLuGEe87Jt0KaSC13LLbyGp16bURCzCGFHaIXH4Mp36ibXKlV46ITdoASNsEpEGI71P5NdvXgm8spVfeVy0KmukPKlS0MKrOiD5EZn42ynrcBhIzJHs+khxY+DVk9zjNF6ip6IH89I4nx6cPQsZ7dhopqstsfe/TeJmkn4dqXYcjJYcgJAwvUOG7L3VGms1U0wZZYU0wR4sireicEIz11IzmODO/cYAzfoYPuZg1XtC1t+ranaogf6b7yCd1VP7hUSbqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ItKLua+ugVrbTuEJp88AEEcT7Gx/XR+5bsIslM57dc=;
 b=ZQn5MDjlRGyV9zJ5DwhI3HnPnGtxgqAu4JJzcJxyERVFEDT/0GfVy4yEpTEof4yM/ihHE1s82j+mtG9G4R8Vw4j3NPdh2UxdVK5QP319THZi/AQ/W2BymhOJATXE+rVIX1c4j7fDOpn03WvcDioyjHvzKCMsYjSl5RhC5/z0wj8=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2159.namprd11.prod.outlook.com (2603:10b6:301:53::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Mon, 12 Oct
 2020 08:38:54 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b%8]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 08:38:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared Virtual
 Addressing to VMs
Thread-Topic: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Thread-Index: AdagceQQLvqwjRCrQOaq1hZ7MgDUUA==
Date:   Mon, 12 Oct 2020 08:38:54 +0000
Message-ID: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14d2cf80-fd71-4263-f614-08d86e8a40e3
x-ms-traffictypediagnostic: MWHPR1101MB2159:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB215900183B22013FC861CA378C070@MWHPR1101MB2159.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NTP+fVhRkzbnYgFJ//3ZaqfJdL5DVliyHAQvdc4VliZalhRz+6A8Iw/gDXxhT3519BkvUPb1bFpPB/oBcvYedDePssz3rH/IAvMpt/7dtQgLxlCx+9WXRSyH5vCY2CVXk9nvaE0ez8M3C3Fs4PVTaA17IGkVwxv+ColtR8SxuEMT4nGoasfW6Q1nMnZBB+P3GEhcXh75n7FjAW7R09lbygMfjkEVkjDXJGz2AUw/BrqRe/cXRRb1sKvc5XDoFMeqQJ8cQI2xhHbLzNG9n8sbXVtIXWFlgsTSYUaopAbmPLHMn8NJsh+kww0KMqY7sbG2e2KNAx9Nvk2d4WHX0ud08A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(54906003)(8936002)(8676002)(110136005)(186003)(71200400001)(4326008)(5660300002)(66556008)(66476007)(478600001)(76116006)(33656002)(2906002)(66946007)(64756008)(52536014)(66446008)(86362001)(26005)(316002)(9686003)(6506007)(55016002)(7696005)(83380400001)(7416002)(83730400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2Kea+GMCDdIBqLg4lHt+G23+CcH3fJcit+T0Gqyld5UYtgPxsbguGV9I3npldc4YWa2icEoxriAUP7N9t546aGMFGX+ijNCq6HnhFOURZ2ySai09z5nQIJ0VNfq4mWbY6pwgRWiQIoPyGCdCT9sYqQ2X5gaYR3rBIhKCyUJDzpkRvfgVOwkL+OIQt9NttB81R8V+Stl86bhF65jNtoqnFAVxpm3XUtEw7yKjzwaXGCxfoctPrismNiTwkrdI8thUfflBPM7OKSim5ahBYqMPIplQiSoHfc/ul9RLh++ARTPWRV8iAD0h8za0SIefdWm4jFA9lb3AR8KeNJrXWma+VkZW1WTLIKfW4g9TwOfxScLkn5tu9r6aoBzIWhY8VJUZUowhJthV03itWWXK6Bk9qftalR+ufgWFKtab0g8E0rmhdlteqOCANgTmdepUzKS1LXPjfxAFi85FE1arHJ2ANT8SQ1MQy/3Cg/FL0YjBcLJg53tHvJI+oj8bnIy0oKEwX1dfu5FUWNkehq4PEJtnPV5OKw+67MP9GTHmDDQoc/9W5Pyg+bsIwQOVx0T2KEx1H/p5qOPEtSlUMFKfzV+N22YU8QDPtgPzq/gQOSMrZ0wfGsY+DXeo4VVgJlcGZaFPQeX1WxhyzXKcQc27uXSHRw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d2cf80-fd71-4263-f614-08d86e8a40e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 08:38:54.3280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IrxmoOk5Mjs+3AcVDGcf4MsV4vDDTlGcJJ7Iwz/+4l0zEI6oquDKzlWcsp0Q7ph9zsJdcT6aFE7yiRM/xgo7cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2159
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTZW50OiBNb25kYXks
IFNlcHRlbWJlciAxNCwgMjAyMCAxMjoyMCBQTQ0KPg0KWy4uLl0NCiA+IElmIGl0J3MgcG9zc2li
bGUsIEkgd291bGQgc3VnZ2VzdCBhIGdlbmVyaWMgdUFQSSBpbnN0ZWFkIG9mIGEgVkZJTw0KPiBz
cGVjaWZpYyBvbmUuDQo+IA0KPiBKYXNvbiBzdWdnZXN0IHNvbWV0aGluZyBsaWtlIC9kZXYvc3Zh
LiBUaGVyZSB3aWxsIGJlIGEgbG90IG9mIG90aGVyDQo+IHN1YnN5c3RlbXMgdGhhdCBjb3VsZCBi
ZW5lZml0IGZyb20gdGhpcyAoZS5nIHZEUEEpLg0KPiANCj4gSGF2ZSB5b3UgZXZlciBjb25zaWRl
cmVkIHRoaXMgYXBwcm9hY2g/DQo+IA0KDQpIaSwgSmFzb24sDQoNCldlIGRpZCBzb21lIHN0dWR5
IG9uIHRoaXMgYXBwcm9hY2ggYW5kIGJlbG93IGlzIHRoZSBvdXRwdXQuIEl0J3MgYQ0KbG9uZyB3
cml0aW5nIGJ1dCBJIGRpZG4ndCBmaW5kIGEgd2F5IHRvIGZ1cnRoZXIgYWJzdHJhY3Qgdy9vIGxv
c2luZyANCm5lY2Vzc2FyeSBjb250ZXh0LiBTb3JyeSBhYm91dCB0aGF0Lg0KDQpPdmVyYWxsIHRo
ZSByZWFsIHB1cnBvc2Ugb2YgdGhpcyBzZXJpZXMgaXMgdG8gZW5hYmxlIElPTU1VIG5lc3RlZA0K
dHJhbnNsYXRpb24gY2FwYWJpbGl0eSB3aXRoIHZTVkEgYXMgb25lIG1ham9yIHVzYWdlLCB0aHJv
dWdoDQpiZWxvdyBuZXcgdUFQSXM6DQoJMSkgUmVwb3J0L2VuYWJsZSBJT01NVSBuZXN0ZWQgdHJh
bnNsYXRpb24gY2FwYWJpbGl0eTsNCgkyKSBBbGxvY2F0ZS9mcmVlIFBBU0lEOw0KCTMpIEJpbmQv
dW5iaW5kIGd1ZXN0IHBhZ2UgdGFibGU7DQoJNCkgSW52YWxpZGF0ZSBJT01NVSBjYWNoZTsNCgk1
KSBIYW5kbGUgSU9NTVUgcGFnZSByZXF1ZXN0L3Jlc3BvbnNlIChub3QgaW4gdGhpcyBzZXJpZXMp
Ow0KMS8zLzQpIGlzIHRoZSBtaW5pbWFsIHNldCBmb3IgdXNpbmcgSU9NTVUgbmVzdGVkIHRyYW5z
bGF0aW9uLCB3aXRoIA0KdGhlIG90aGVyIHR3byBvcHRpb25hbC4gRm9yIGV4YW1wbGUsIHRoZSBn
dWVzdCBtYXkgZW5hYmxlIHZTVkEgb24gDQphIGRldmljZSB3aXRob3V0IHVzaW5nIFBBU0lELiBP
ciwgaXQgbWF5IGJpbmQgaXRzIGdJT1ZBIHBhZ2UgdGFibGUgDQp3aGljaCBkb2Vzbid0IHJlcXVp
cmUgcGFnZSBmYXVsdCBzdXBwb3J0LiBGaW5hbGx5LCBhbGwgb3BlcmF0aW9ucyBjYW4gDQpiZSBh
cHBsaWVkIHRvIGVpdGhlciBwaHlzaWNhbCBkZXZpY2Ugb3Igc3ViZGV2aWNlLg0KDQpUaGVuIHdl
IGV2YWx1YXRlZCBlYWNoIHVBUEkgd2hldGhlciBnZW5lcmFsaXppbmcgaXQgaXMgYSBnb29kIHRo
aW5nIA0KYm90aCBpbiBjb25jZXB0IGFuZCByZWdhcmRpbmcgdG8gY29tcGxleGl0eS4NCg0KRmly
c3QsIHVubGlrZSBvdGhlciB1QVBJcyB3aGljaCBhcmUgYWxsIGJhY2tlZCBieSBpb21tdV9vcHMs
IFBBU0lEIA0KYWxsb2NhdGlvbi9mcmVlIGlzIHRocm91Z2ggdGhlIElPQVNJRCBzdWItc3lzdGVt
LiBGcm9tIHRoaXMgYW5nbGUNCndlIGZlZWwgZ2VuZXJhbGl6aW5nIFBBU0lEIG1hbmFnZW1lbnQg
ZG9lcyBtYWtlIHNvbWUgc2Vuc2UuIA0KRmlyc3QsIFBBU0lEIGlzIGp1c3QgYSBudW1iZXIgYW5k
IG5vdCByZWxhdGVkIHRvIGFueSBkZXZpY2UgYmVmb3JlIA0KaXQncyBib3VuZCB0byBhIHBhZ2Ug
dGFibGUgYW5kIElPTU1VIGRvbWFpbi4gU2Vjb25kLCBQQVNJRCBpcyBhIA0KZ2xvYmFsIHJlc291
cmNlIChhdCBsZWFzdCBvbiBJbnRlbCBWVC1kKSwgd2hpbGUgaGF2aW5nIHNlcGFyYXRlIFZGSU8v
DQpWRFBBIGFsbG9jYXRpb24gaW50ZXJmYWNlcyBtYXkgZWFzaWx5IGNhdXNlIGNvbmZ1c2lvbiBp
biB1c2Vyc3BhY2UsDQplLmcuIHdoaWNoIGludGVyZmFjZSB0byBiZSB1c2VkIGlmIGJvdGggVkZJ
Ty9WRFBBIGRldmljZXMgZXhpc3QuIA0KTW9yZW92ZXIsIGFuIHVuaWZpZWQgaW50ZXJmYWNlIGFs
bG93cyBjZW50cmFsaXplZCBjb250cm9sIG92ZXIgaG93IA0KbWFueSBQQVNJRHMgYXJlIGFsbG93
ZWQgcGVyIHByb2Nlc3MuDQoNCk9uZSB1bmNsZWFyIHBhcnQgd2l0aCB0aGlzIGdlbmVyYWxpemF0
aW9uIGlzIGFib3V0IHRoZSBwZXJtaXNzaW9uLg0KRG8gd2Ugb3BlbiB0aGlzIGludGVyZmFjZSB0
byBhbnkgcHJvY2VzcyBvciBvbmx5IHRvIHRob3NlIHdoaWNoDQpoYXZlIGFzc2lnbmVkIGRldmlj
ZXM/IElmIHRoZSBsYXR0ZXIsIHdoYXQgd291bGQgYmUgdGhlIG1lY2hhbmlzbQ0KdG8gY29vcmRp
bmF0ZSBiZXR3ZWVuIHRoaXMgbmV3IGludGVyZmFjZSBhbmQgc3BlY2lmaWMgcGFzc3Rocm91Z2gg
DQpmcmFtZXdvcmtzPyBBIG1vcmUgdHJpY2t5IGNhc2UsIHZTVkEgc3VwcG9ydCBvbiBBUk0gKEVy
aWMvSmVhbg0KcGxlYXNlIGNvcnJlY3QgbWUpIHBsYW5zIHRvIGRvIHBlci1kZXZpY2UgUEFTSUQg
bmFtZXNwYWNlIHdoaWNoDQppcyBidWlsdCBvbiBhIGJpbmRfcGFzaWRfdGFibGUgaW9tbXUgY2Fs
bGJhY2sgdG8gYWxsb3cgZ3Vlc3QgZnVsbHkgDQptYW5hZ2UgaXRzIFBBU0lEcyBvbiBhIGdpdmVu
IHBhc3N0aHJvdWdoIGRldmljZS4gSSdtIG5vdCBzdXJlIA0KaG93IHN1Y2ggcmVxdWlyZW1lbnQg
Y2FuIGJlIHVuaWZpZWQgdy9vIGludm9sdmluZyBwYXNzdGhyb3VnaA0KZnJhbWV3b3Jrcywgb3Ig
d2hldGhlciBBUk0gY291bGQgYWxzbyBzd2l0Y2ggdG8gZ2xvYmFsIFBBU0lEIA0Kc3R5bGUuLi4N
Cg0KU2Vjb25kLCBJT01NVSBuZXN0ZWQgdHJhbnNsYXRpb24gaXMgYSBwZXIgSU9NTVUgZG9tYWlu
DQpjYXBhYmlsaXR5LiBTaW5jZSBJT01NVSBkb21haW5zIGFyZSBtYW5hZ2VkIGJ5IFZGSU8vVkRQ
QQ0KIChhbGxvYy9mcmVlIGRvbWFpbiwgYXR0YWNoL2RldGFjaCBkZXZpY2UsIHNldC9nZXQgZG9t
YWluIGF0dHJpYnV0ZSwNCmV0Yy4pLCByZXBvcnRpbmcvZW5hYmxpbmcgdGhlIG5lc3RpbmcgY2Fw
YWJpbGl0eSBpcyBhbiBuYXR1cmFsIA0KZXh0ZW5zaW9uIHRvIHRoZSBkb21haW4gdUFQSSBvZiBl
eGlzdGluZyBwYXNzdGhyb3VnaCBmcmFtZXdvcmtzLiANCkFjdHVhbGx5LCBWRklPIGFscmVhZHkg
aW5jbHVkZXMgYSBuZXN0aW5nIGVuYWJsZSBpbnRlcmZhY2UgZXZlbiANCmJlZm9yZSB0aGlzIHNl
cmllcy4gU28gaXQgZG9lc24ndCBtYWtlIHNlbnNlIHRvIGdlbmVyYWxpemUgdGhpcyB1QVBJIA0K
b3V0Lg0KDQpUaGVuIHRoZSB0cmlja3kgcGFydCBjb21lcyB3aXRoIHRoZSByZW1haW5pbmcgb3Bl
cmF0aW9ucyAoMy80LzUpLA0Kd2hpY2ggYXJlIGFsbCBiYWNrZWQgYnkgaW9tbXVfb3BzIHRodXMg
ZWZmZWN0aXZlIG9ubHkgd2l0aGluIGFuIA0KSU9NTVUgZG9tYWluLiBUbyBnZW5lcmFsaXplIHRo
ZW0sIHRoZSBmaXJzdCB0aGluZyBpcyB0byBmaW5kIGEgd2F5IA0KdG8gYXNzb2NpYXRlIHRoZSBz
dmFfRkQgKG9wZW5lZCB0aHJvdWdoIGdlbmVyaWMgL2Rldi9zdmEpIHdpdGggYW4gDQpJT01NVSBk
b21haW4gdGhhdCBpcyBjcmVhdGVkIGJ5IFZGSU8vVkRQQS4gVGhlIHNlY29uZCB0aGluZyBpcyAN
CnRvIHJlcGxpY2F0ZSB7ZG9tYWluPC0+ZGV2aWNlL3N1YmRldmljZX0gYXNzb2NpYXRpb24gaW4g
L2Rldi9zdmEgDQpwYXRoIGJlY2F1c2Ugc29tZSBvcGVyYXRpb25zIChlLmcuIHBhZ2UgZmF1bHQp
IGlzIHRyaWdnZXJlZC9oYW5kbGVkIA0KcGVyIGRldmljZS9zdWJkZXZpY2UuIFRoZXJlZm9yZSwg
L2Rldi9zdmEgbXVzdCBwcm92aWRlIGJvdGggcGVyLQ0KZG9tYWluIGFuZCBwZXItZGV2aWNlIHVB
UElzIHNpbWlsYXIgdG8gd2hhdCBWRklPL1ZEUEEgYWxyZWFkeSANCmRvZXMuIE1vcmVvdmVyLCBt
YXBwaW5nIHBhZ2UgZmF1bHQgdG8gc3ViZGV2aWNlIHJlcXVpcmVzIHByZS0NCnJlZ2lzdGVyaW5n
IHN1YmRldmljZSBmYXVsdCBkYXRhIHRvIElPTU1VIGxheWVyIHdoZW4gYmluZGluZyANCmd1ZXN0
IHBhZ2UgdGFibGUsIHdoaWxlIHN1Y2ggZmF1bHQgZGF0YSBjYW4gYmUgb25seSByZXRyaWV2ZWQg
ZnJvbSANCnBhcmVudCBkcml2ZXIgdGhyb3VnaCBWRklPL1ZEUEEuIA0KDQpIb3dldmVyLCB3ZSBm
YWlsZWQgdG8gZmluZCBhIGdvb2Qgd2F5IGV2ZW4gYXQgdGhlIDFzdCBzdGVwIGFib3V0DQpkb21h
aW4gYXNzb2NpYXRpb24uIFRoZSBpb21tdSBkb21haW5zIGFyZSBub3QgZXhwb3NlZCB0byB0aGUN
CnVzZXJzcGFjZSwgYW5kIHRoZXJlIGlzIG5vIDE6MSBtYXBwaW5nIGJldHdlZW4gZG9tYWluIGFu
ZCBkZXZpY2UuDQpJbiBWRklPLCBhbGwgZGV2aWNlcyB3aXRoaW4gdGhlIHNhbWUgVkZJTyBjb250
YWluZXIgc2hhcmUgdGhlIGFkZHJlc3MNCnNwYWNlIGJ1dCB0aGV5IG1heSBiZSBvcmdhbml6ZWQg
aW4gbXVsdGlwbGUgSU9NTVUgZG9tYWlucyBiYXNlZA0Kb24gdGhlaXIgYnVzIHR5cGUuIEhvdyAo
c2hvdWxkIHdlIGxldCkgdGhlIHVzZXJzcGFjZSBrbm93IHRoZQ0KZG9tYWluIGluZm9ybWF0aW9u
IGFuZCBvcGVuIGFuIHN2YV9GRCBmb3IgZWFjaCBkb21haW4gaXMgdGhlIG1haW4NCnByb2JsZW0g
aGVyZS4NCg0KSW4gdGhlIGVuZCB3ZSBqdXN0IHJlYWxpemVkIHRoYXQgZG9pbmcgc3VjaCBnZW5l
cmFsaXphdGlvbiBkb2Vzbid0DQpyZWFsbHkgbGVhZCB0byBhIGNsZWFyIGRlc2lnbiBhbmQgaW5z
dGVhZCByZXF1aXJlcyB0aWdodCBjb29yZGluYXRpb24gDQpiZXR3ZWVuIC9kZXYvc3ZhIGFuZCBW
RklPL1ZEUEEgZm9yIGFsbW9zdCBldmVyeSBuZXcgdUFQSSANCihlc3BlY2lhbGx5IGFib3V0IHN5
bmNocm9uaXphdGlvbiB3aGVuIHRoZSBkb21haW4vZGV2aWNlIA0KYXNzb2NpYXRpb24gaXMgY2hh
bmdlZCBvciB3aGVuIHRoZSBkZXZpY2Uvc3ViZGV2aWNlIGlzIGJlaW5nIHJlc2V0Lw0KZHJhaW5l
ZCkuIEZpbmFsbHkgaXQgbWF5IGJlY29tZSBhIHVzYWJpbGl0eSBidXJkZW4gdG8gdGhlIHVzZXJz
cGFjZQ0Kb24gcHJvcGVyIHVzZSBvZiB0aGUgdHdvIGludGVyZmFjZXMgb24gdGhlIGFzc2lnbmVk
IGRldmljZS4NCiANCkJhc2VkIG9uIGFib3ZlIGFuYWx5c2lzIHdlIGZlZWwgdGhhdCBqdXN0IGdl
bmVyYWxpemluZyBQQVNJRCBtZ210Lg0KbWlnaHQgYmUgYSBnb29kIHRoaW5nIHRvIGxvb2sgYXQg
d2hpbGUgdGhlIHJlbWFpbmluZyBvcGVyYXRpb25zIGFyZSANCmJldHRlciBiZWluZyBWRklPL1ZE
UEEgc3BlY2lmaWMgdUFQSXMuIGFueXdheSBpbiBjb25jZXB0IHRob3NlIGFyZSANCmp1c3QgYSBz
dWJzZXQgb2YgdGhlIHBhZ2UgdGFibGUgbWFuYWdlbWVudCBjYXBhYmlsaXRpZXMgdGhhdCBhbiAN
CklPTU1VIGRvbWFpbiBhZmZvcmRzLiBTaW5jZSBhbGwgb3RoZXIgYXNwZWN0cyBvZiB0aGUgSU9N
TVUgZG9tYWluIA0KaXMgbWFuYWdlZCBieSBWRklPL1ZEUEEgYWxyZWFkeSwgY29udGludWluZyB0
aGlzIHBhdGggZm9yIG5ldyBuZXN0aW5nDQpjYXBhYmlsaXR5IHNvdW5kcyBuYXR1cmFsLiBUaGVy
ZSBpcyBhbm90aGVyIG9wdGlvbiBieSBnZW5lcmFsaXppbmcgdGhlIA0KZW50aXJlIElPTU1VIGRv
bWFpbiBtYW5hZ2VtZW50IChzb3J0IG9mIHRoZSBlbnRpcmUgdmZpb19pb21tdV8NCnR5cGUxKSwg
YnV0IGl0J3MgdW5jbGVhciB3aGV0aGVyIHN1Y2ggaW50cnVzaXZlIGNoYW5nZSBpcyB3b3J0aHdo
aWxlIA0KKGVzcGVjaWFsbHkgd2hlbiBWRklPL1ZEUEEgYWxyZWFkeSBnb2VzIGRpZmZlcmVudCBy
b3V0ZSBldmVuIGluIGxlZ2FjeQ0KbWFwcGluZyB1QVBJOiBtYXAvdW5tYXAgdnMuIElPVExCKS4N
Cg0KVGhvdWdodHM/DQoNClRoYW5rcw0KS2V2aW4NCg==

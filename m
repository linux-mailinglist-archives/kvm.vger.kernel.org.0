Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5055F198C96
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 08:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbgCaGyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 02:54:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:45081 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgCaGyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 02:54:04 -0400
IronPort-SDR: eexCSy5W3s6NFu7DD9PNV5Lylz7bgdIz3fI6K2ObPr5z1XEM8vNZhLFoyKya5dT9EEuid8zaIG
 4psCwCxe26gg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 23:54:04 -0700
IronPort-SDR: b7WrdR08ZGzVnCvuPjL0BaWtlr5tgwUP4QlO2znxESDjJ5OVemfWoLu9XIbBUDbJ9QjRT7NBSZ
 MDxEwAzL4+DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="248958536"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2020 23:54:03 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 23:54:03 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Mar 2020 23:54:02 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Mar 2020 23:54:02 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.146]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 14:53:59 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>, Auger Eric <eric.auger@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>
Subject: RE: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Thread-Topic: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Thread-Index: AQHWBkpi4SFlYLfwBEaCXIDf+JnUMqhga2yAgABF7QCAAY8pcA==
Date:   Tue, 31 Mar 2020 06:53:58 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21A72A@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <e709e36f-dc50-2e70-3a1e-62f08533e454@redhat.com>
 <20200330144640.GC522868@xz-x1>
In-Reply-To: <20200330144640.GC522868@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6
IE1vbmRheSwgTWFyY2ggMzAsIDIwMjAgMTA6NDcgUE0NCj4gVG86IEF1Z2VyIEVyaWMgPGVyaWMu
YXVnZXJAcmVkaGF0LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAwMC8yMl0gaW50ZWxf
aW9tbXU6IGV4cG9zZSBTaGFyZWQgVmlydHVhbCBBZGRyZXNzaW5nIHRvDQo+IFZNcw0KPiANCj4g
T24gTW9uLCBNYXIgMzAsIDIwMjAgYXQgMTI6MzY6MjNQTSArMDIwMCwgQXVnZXIgRXJpYyB3cm90
ZToNCj4gPiBJIHRoaW5rIGluIGdlbmVyYWwsIGFzIGxvbmcgYXMgdGhlIGtlcm5lbCBkZXBlbmRl
bmNpZXMgYXJlIG5vdA0KPiA+IHJlc29sdmVkLCB0aGUgUUVNVSBzZXJpZXMgaXMgc3VwcG9zZWQg
dG8gc3RheSBpbiBSRkMgc3RhdGUuDQo+IA0KPiBZZWFoIEkgYWdyZWUuIEkgdGhpbmsgdGhlIHN1
YmplY3QgaXMgbm90IGV4dHJlbWVseSBpbXBvcnRhbnQsIGJ1dCB3ZSBkZWZpbml0ZWx5IHNob3Vs
ZA0KPiB3YWl0IGZvciB0aGUga2VybmVsIHBhcnQgdG8gYmUgcmVhZHkgYmVmb3JlIG1lcmdpbmcg
dGhlIHNlcmllcy4NCj4gDQo+IFNpZGUgbm90ZTogSSBvZmZlcmVkIHF1aXRlIGEgZmV3IHItYnMg
Zm9yIHRoZSBzZXJpZXMgKGFuZCBJIHN0aWxsIHBsYW4gdG8gbW92ZSBvbg0KPiByZWFkaW5nIGl0
IHRoaXMgd2VlayBzaW5jZSB0aGVyZSdzIGEgbmV3IHZlcnNpb24sIGFuZCB0cnkgdG8gb2ZmZXIg
bW9yZSByLWJzIHdoZW4gSQ0KPiBzdGlsbCBoYXZlIHNvbWUgY29udGV4dCBpbiBteSBicmFpbi1j
YWNoZSksIGhvd2V2ZXIgdGhleSdyZSBtb3N0bHkgb25seSBmb3IgbXlzZWxmDQo+IHRvIGF2b2lk
IHJlLXJlYWRpbmcgdGhlIHdob2xlIHNlcmllcyBhZ2FpbiBpbiB0aGUgZnV0dXJlIGVzcGVjaWFs
bHkgYmVjYXVzZSBpdCdzDQo+IGh1Z2UuLi4gOikNCg0KQWdyZWVkLiBJJ2xsIHJlbmFtZSB0aGUg
bmV4dCB2ZXJzaW9uIGFzIFJGQ3Y2IHRoZW4uIEJUVy4gYWx0aG91Z2ggdGhlcmUNCmlzIGRlcGVu
ZGVuY3kgb24ga2VybmVsIHNpZGUsIGJ1dCBJIHRoaW5rIHdlJ2QgZ2V0IGFncmVlbWVudCBvbiB0
aGUNCmludGVyYWN0aW9uIG1lY2hhbmlzbSBiZXR3ZWVuIHZmaW8gYW5kIHZJT01NVSB3aXRoaW4g
UUVNVS4gQWxzbywgZm9yIHRoZQ0KVlQtZCBzcGVjaWZpYyBjaGFuZ2VzIChlLmcuIHRoZSBwYXNp
ZCBjYWNoZSBpbnZhbGlkYXRpb24gcGF0Y2hlcyBhbmQgdGhlDQpwYXNpZC1iYXNlZC1pb3RsYiBp
bnZhbGlkYXRpb25zKSwgd2UgY2FuIGFjdHVhbGx5IGdldCB0aGVtIHJlYWR5IGFzIHRoZXkNCmhh
dmUgbm8gZGVwZW5kZW5jeSBvbiBrZXJuZWwgc2lkZSBjaGFuZ2UuIFBsZWFzZSBoZWxwLiA6LSkN
Cg0KUmVnYXJkcywNCllpIExpdQ0K

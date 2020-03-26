Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F5819369F
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 04:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgCZDRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 23:17:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:27457 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbgCZDRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 23:17:17 -0400
IronPort-SDR: jQvf1mrRsSp1YQ1wJcKoiDzZcUCdCISSJxHMdHeJ32IlYZdW3QN6om+N9FXADba0r/oSqH6Lhf
 XDUE/DZEFlSw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 20:17:16 -0700
IronPort-SDR: 4XctIjodf/2i/mDbajyNmLuhzdxhi5SCDtvwf/pYvN/hCcEjd6qgp74RTAMtIx2xsUFKcEJIrp
 /Oxr8Xd4vm2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="240557101"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga008.fm.intel.com with ESMTP; 25 Mar 2020 20:17:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 20:17:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 25 Mar 2020 20:17:16 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 25 Mar 2020 20:17:16 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.137]) with mapi id 14.03.0439.000;
 Thu, 26 Mar 2020 11:17:12 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>
Subject: RE: [PATCH v1 15/22] intel_iommu: replay guest pasid bindings to
 host
Thread-Topic: [PATCH v1 15/22] intel_iommu: replay guest pasid bindings to
 host
Thread-Index: AQHWAEW2TKrNzFeLS0yo5PxjKqQ+KahXhXqAgAHBPcD//6CTAIABTvqw
Date:   Thu, 26 Mar 2020 03:17:12 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A2038A1@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-16-git-send-email-yi.l.liu@intel.com>
 <20200324180013.GZ127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A202251@SHSMSX104.ccr.corp.intel.com>
 <20200325150634.GC354390@xz-x1>
In-Reply-To: <20200325150634.GC354390@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
TWFyY2ggMjUsIDIwMjAgMTE6MDcgUE0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwu
Y29tPg0KPiBDYzogcWVtdS1kZXZlbEBub25nbnUub3JnOyBhbGV4LndpbGxpYW1zb25AcmVkaGF0
LmNvbTsNCj4gZXJpYy5hdWdlckByZWRoYXQuY29tOyBwYm9uemluaUByZWRoYXQuY29tOyBtc3RA
cmVkaGF0LmNvbTsNCj4gZGF2aWRAZ2lic29uLmRyb3BiZWFyLmlkLmF1OyBUaWFuLCBLZXZpbiA8
a2V2aW4udGlhbkBpbnRlbC5jb20+OyBUaWFuLCBKdW4gSg0KPiA8anVuLmoudGlhbkBpbnRlbC5j
b20+OyBTdW4sIFlpIFkgPHlpLnkuc3VuQGludGVsLmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7
IFd1LA0KPiBIYW8gPGhhby53dUBpbnRlbC5jb20+OyBqZWFuLXBoaWxpcHBlQGxpbmFyby5vcmc7
IEphY29iIFBhbg0KPiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+OyBZaSBTdW4gPHlp
Lnkuc3VuQGxpbnV4LmludGVsLmNvbT47IFJpY2hhcmQNCj4gSGVuZGVyc29uIDxydGhAdHdpZGRs
ZS5uZXQ+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMTUvMjJdIGludGVsX2lvbW11OiByZXBs
YXkgZ3Vlc3QgcGFzaWQgYmluZGluZ3MgdG8gaG9zdA0KPiANCj4gT24gV2VkLCBNYXIgMjUsIDIw
MjAgYXQgMDE6MTQ6MjZQTSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4g
DQo+ID4gPiA+ICsvKioNCj4gPiA+ID4gKyAqIENhbGxlciBvZiB0aGlzIGZ1bmN0aW9uIHNob3Vs
ZCBob2xkIGlvbW11X2xvY2suDQo+ID4gPiA+ICsgKi8NCj4gPiA+ID4gK3N0YXRpYyBib29sIHZ0
ZF9zbV9wYXNpZF90YWJsZV93YWxrX29uZShJbnRlbElPTU1VU3RhdGUgKnMsDQo+ID4gPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZG1hX2FkZHJfdCBwdF9iYXNl
LA0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCBz
dGFydCwNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBp
bnQgZW5kLA0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHZ0ZF9wYXNpZF90YWJsZV93YWxrX2luZm8gKmluZm8pDQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsg
ICAgVlREUEFTSURFbnRyeSBwZTsNCj4gPiA+ID4gKyAgICBpbnQgcGFzaWQgPSBzdGFydDsNCj4g
PiA+ID4gKyAgICBpbnQgcGFzaWRfbmV4dDsNCj4gPiA+ID4gKyAgICBWVERQQVNJREFkZHJlc3NT
cGFjZSAqdnRkX3Bhc2lkX2FzOw0KPiA+ID4gPiArICAgIFZURFBBU0lEQ2FjaGVFbnRyeSAqcGNf
ZW50cnk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICB3aGlsZSAocGFzaWQgPCBlbmQpIHsNCj4g
PiA+ID4gKyAgICAgICAgcGFzaWRfbmV4dCA9IHBhc2lkICsgMTsNCj4gPiA+ID4gKw0KPiA+ID4g
PiArICAgICAgICBpZiAoIXZ0ZF9nZXRfcGVfaW5fcGFzaWRfbGVhZl90YWJsZShzLCBwYXNpZCwg
cHRfYmFzZSwgJnBlKQ0KPiA+ID4gPiArICAgICAgICAgICAgJiYgdnRkX3BlX3ByZXNlbnQoJnBl
KSkgew0KPiA+ID4gPiArICAgICAgICAgICAgdnRkX3Bhc2lkX2FzID0gdnRkX2FkZF9maW5kX3Bh
c2lkX2FzKHMsDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBpbmZvLT52dGRfYnVzLCBpbmZvLT5kZXZmbiwgcGFzaWQpOw0KPiA+ID4NCj4gPiA+IEZvciB0
aGlzIGNodW5rOg0KPiA+ID4NCj4gPiA+ID4gKyAgICAgICAgICAgIHBjX2VudHJ5ID0gJnZ0ZF9w
YXNpZF9hcy0+cGFzaWRfY2FjaGVfZW50cnk7DQo+ID4gPiA+ICsgICAgICAgICAgICBpZiAocy0+
cGFzaWRfY2FjaGVfZ2VuID09IHBjX2VudHJ5LT5wYXNpZF9jYWNoZV9nZW4pIHsNCj4gPiA+ID4g
KyAgICAgICAgICAgICAgICB2dGRfdXBkYXRlX3BlX2luX2NhY2hlKHMsIHZ0ZF9wYXNpZF9hcywg
JnBlKTsNCj4gPiA+ID4gKyAgICAgICAgICAgIH0gZWxzZSB7DQo+ID4gPiA+ICsgICAgICAgICAg
ICAgICAgdnRkX2ZpbGxfaW5fcGVfaW5fY2FjaGUocywgdnRkX3Bhc2lkX2FzLCAmcGUpOw0KPiA+
ID4gPiArICAgICAgICAgICAgfQ0KPiA+ID4NCj4gPiA+IFdlIGFscmVhZHkgZ290ICZwZSwgdGhl
biB3b3VsZCBpdCBiZSBlYXNpZXIgdG8gc2ltcGx5IGNhbGw6DQo+ID4gPg0KPiA+ID4gICAgICAg
ICAgICAgICAgdnRkX3VwZGF0ZV9wZV9pbl9jYWNoZShzLCB2dGRfcGFzaWRfYXMsICZwZSk7DQo+
ID4gPg0KPiA+ID4gPw0KPiA+DQo+ID4gSWYgdGhlIHBhc2lkX2NhY2hlX2dlbiBpcyBlcXVhbCB0
byBpb21tdV9zdGF0ZSdzLCB0aGVuIGl0IG1lYW5zIHRoZXJlIGlzDQo+ID4gYSBjaGFuY2UgdGhh
dCB0aGUgY2FjaGVkIHBhc2lkIGVudHJ5IGlzIGVxdWFsIHRvIHBlIGhlcmUuIFdoaWxlIGZvciB0
aGUNCj4gPiBlbHNlIGNhc2UsIGl0IGlzIHN1cmVseSB0aGVyZSBpcyBubyB2YWxpZCBwYXNpZCBl
bnRyeSBpbiB0aGUgcGFzaWRfYXMuIEFuZA0KPiA+IHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gdnRk
X3VwZGF0ZV9wZV9pbl9jYWNoZSgpIGFuZA0KPiA+IHZ0ZF9maWxsX2luX3BlX2luX2NhY2hlKCkg
aXMgd2hldGhlciBkbyBhIGNvbXBhcmUgYmV0d2VlbiB0aGUgbmV3IHBhc2lkIGVudHJ5DQo+ID4g
YW5kIGNhY2hlZCBwYXNpZCBlbnRyeS4NCj4gPg0KPiA+ID4gU2luY2UgSUlVQyB0aGUgY2FjaGVf
Z2VuIGlzIG9ubHkgaGVscGZ1bCB0byBhdm9pZCBsb29raW5nIHVwIHRoZSAmcGUuDQo+ID4gPiBB
bmQgdGhlIHZ0ZF9wYXNpZF9lbnRyeV9jb21wYXJlKCkgY2hlY2sgc2hvdWxkIGJlIGV2ZW4gbW9y
ZSBzb2xpZCB0aGFuDQo+ID4gPiB0aGUgY2FjaGVfZ2VuLg0KPiA+DQo+ID4gQnV0IGlmIHRoZSBj
YWNoZV9nZW4gaXMgbm90IGVxdWFsIHRoZSBvbmUgaW4gaW9tbXVfc3RhdGUsIHRoZW4gdGhlIGNh
Y2hlZA0KPiA+IHBhc2lkIGVudHJ5IGlzIG5vdCB2YWxpZCBhdCBhbGwuIFRoZSBjb21wYXJlIGlz
IG9ubHkgbmVlZGVkIGFmdGVyIHRoZSBjYWNoZV9nZW4NCj4gPiBpcyBjaGVja2VkLg0KPiANCj4g
V2FpdC4uLiBJZiAidGhlIHBhc2lkIGVudHJ5IGNvbnRleHQiIGlzIGFscmVhZHkgZXhhY3RseSB0
aGUgc2FtZSBhcw0KPiB0aGUgImNhY2hlZCBwYXNpZCBlbnRyeSBjb250ZXh0Iiwgd2h5IHdlIHN0
aWxsIGNhcmUgdGhlIGdlbmVyYXRpb24NCj4gbnVtYmVyPyAgSSdkIGp1c3QgdXBkYXRlIHRoZSBn
ZW5lcmF0aW9uIHRvIGxhdGVzdCBhbmQgY2FjaGUgaXQgYWdhaW4uDQo+IE1heWJlIHRoZXJlJ3Mg
YSB0cmlja3kgcG9pbnQgd2hlbiAmcGU9PWNhY2hlIGJ1dCBnZW5lcmF0aW9uIG51bWJlciBpcw0K
PiBvbGQsIHRoZW4gSUlVQyB3aGF0IHdlIGNhbiBkbyBiZXR0ZXIgaXMgc2ltcGx5IHVwZGF0ZSB0
aGUgZ2VuZXJhdGlvbg0KPiBudW1iZXIgdG8gbGF0ZXN0Lg0KPiANCj4gQnV0IE9LIC0gbGV0J3Mg
a2VlcCB0aGF0LiAgSSBkb24ndCBzZWUgYW55dGhpbmcgaW5jb3JyZWN0IHdpdGggY3VycmVudA0K
PiBjb2RlIGVpdGhlci4NCg0KSSBzZWUuIEFjdHVhbGx5LCBJIHRoaW5rIGl0J3MgYWxzbyBmaW5l
IHRvIGZvbGxvdyB5b3VyIHN1Z2dlc3Rpb24gdG8gYWxsDQp2dGRfdXBkYXRlX3BlX2luX2NhY2hl
KHMsIHZ0ZF9wYXNpZF9hcywgJnBlKTsgZm9yIHRoZSBlbHNlIHN3aXRjaC4NCklmIHN3aXRjaCB0
byB1c2UgcmVwbGF5IGZvciBQU0ksIHRoZW4gSSBtYXkgZHJvcCB2dGRfZmlsbF9pbl9wZV9pbl9j
YWNoZSgpDQphcyBpdCBpcyBpbnRyb2R1Y2VkIG1haW5seSBmb3IgUFNJLg0KDQpSZWdhcmRzLA0K
WWkgTGl1DQoNCg==

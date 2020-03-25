Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743A719244F
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 10:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgCYJhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 05:37:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:60380 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgCYJhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 05:37:42 -0400
IronPort-SDR: xHo6eUKhr4hH2SCTPyjc4MvI2IyFHDI78pjp11M3Jrufm/6ug9PU6zh1ic/+E2ORieTYCfGUxX
 t4+wNvd9An9w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 02:37:42 -0700
IronPort-SDR: vhPjM/cowDlQDWyPp9g8cDTlRnVOlTcGWufI14tK3cz67FB29nlKsk1CIcqtF35xUflW9rwh1d
 xZn0wNGBUPHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,303,1580803200"; 
   d="scan'208";a="393574042"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2020 02:37:41 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 02:37:41 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx158.amr.corp.intel.com (10.18.116.75) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 02:37:41 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.155]) with mapi id 14.03.0439.000;
 Wed, 25 Mar 2020 17:37:37 +0800
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
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: RE: [PATCH v1 07/22] intel_iommu: add set/unset_iommu_context
 callback
Thread-Topic: [PATCH v1 07/22] intel_iommu: add set/unset_iommu_context
 callback
Thread-Index: AQHWAEW1iID+2pWxMk+TzTXpt3GsyKhWLYeAgAFYgbD//9PfAIABtbwQ
Date:   Wed, 25 Mar 2020 09:37:37 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A201DFC@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-8-git-send-email-yi.l.liu@intel.com>
 <20200323212911.GQ127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A20041A@SHSMSX104.ccr.corp.intel.com>
 <20200324152416.GV127076@xz-x1>
In-Reply-To: <20200324152416.GV127076@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1h
cmNoIDI0LCAyMDIwIDExOjI0IFBNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MSAwNy8yMl0gaW50ZWxfaW9tbXU6IGFkZCBzZXQv
dW5zZXRfaW9tbXVfY29udGV4dCBjYWxsYmFjaw0KPiANCj4gT24gVHVlLCBNYXIgMjQsIDIwMjAg
YXQgMTE6MTU6MjRBTSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gDQo+
ID4gPiA+ICBzdHJ1Y3QgVlRESU9UTEJFbnRyeSB7DQo+ID4gPiA+IEBAIC0yNzEsNiArMjgyLDgg
QEAgc3RydWN0IEludGVsSU9NTVVTdGF0ZSB7DQo+ID4gPiA+ICAgICAgLyoNCj4gPiA+ID4gICAg
ICAgKiBQcm90ZWN0cyBJT01NVSBzdGF0ZXMgaW4gZ2VuZXJhbC4gIEN1cnJlbnRseSBpdCBwcm90
ZWN0cyB0aGUNCj4gPiA+ID4gICAgICAgKiBwZXItSU9NTVUgSU9UTEIgY2FjaGUsIGFuZCBjb250
ZXh0IGVudHJ5IGNhY2hlIGluIFZUREFkZHJlc3NTcGFjZS4NCj4gPiA+ID4gKyAgICAgKiBQcm90
ZWN0IHRoZSB1cGRhdGUvdXNhZ2Ugb2YgSG9zdElPTU1VQ29udGV4dCBwb2ludGVyIGNhY2hlZCBp
bg0KPiA+ID4gPiArICAgICAqIFZUREJ1cy0+ZGV2X2ljeCBhcnJheSBhcyBhcnJheSBlbGVtZW50
cyBtYXkgYmUgdXBkYXRlZCBieQ0KPiA+ID4gPiArIGhvdHBsdWcNCj4gPiA+DQo+ID4gPiBJIHRo
aW5rIHRoZSBjb250ZXh0IHVwZGF0ZSBkb2VzIG5vdCBuZWVkIHRvIGJlIHVwZGF0ZWQsIGJlY2F1
c2UgdGhleQ0KPiA+ID4gc2hvdWxkIGFsd2F5cyBiZSB3aXRoIHRoZSBCUUwsIHJpZ2h0Pw0KPiA+
DQo+ID4gSG1tbW0sIG1heWJlIEkgdXNlZCBiYWQgZGVzY3JpcHRpb24uIE15IHB1cnBvc2UgaXMg
dG8gcHJvdGVjdCB0aGUNCj4gPiBzdG9yZWQgSG9zdElPTU1VQ29udGV4dCBwb2ludGVyIGluIHZJ
T01NVS4gV2l0aA0KPiA+IHBjaV9kZXZpY2Vfc2V0L3Vuc2V0X2lvbW11X2NvbnRleHQsDQo+ID4g
dklPTU1VIGhhdmUgYSBjb3B5IG9mIEhvc3RJT01NVUNvbnRleHQuIElmIFZGSU8gY29udGFpbmVy
IGlzIHJlbGVhc2VkDQo+ID4gKGUuZy4gaG90cHVsZyBvdXQgZGV2aWNlKSwgSG9zdElPTU1VQ29u
dGV4dCB3aWxsIGFsb3MgYmUgcmVsZWFzZWQuDQo+ID4gVGhpcyB3aWxsIHRyaWdnZXIgdGhlIHBj
aV9kZXZpY2VfdW5zZXRfaW9tbXVfY29udGV4dCgpIHRvIGNsZWFuIHRoZQ0KPiA+IGNvcHkuIFRv
IGF2b2lkIHVzaW5nIGEgc3RhbGVkIEhvc3RJT01NVUNvbnRleHQgaW4gdklPTU1VLCB2SU9NTVUN
Cj4gPiBzaG91bGQgaGF2ZSBhIGxvY2sgdG8gYmxvY2sgdGhlIHBjaV9kZXZpY2VfdW5zZXRfaW9t
bXVfY29udGV4dCgpDQo+ID4gY2FsbGluZyB1bnRpbCBvdGhlciB0aHJlYWRzIGZpbmlzaGVkIHRo
ZWlyIEhvc3RJT01NVUNvbnRleHQgdXNhZ2UuIERvDQo+ID4geW91IHdhbnQgYSBkZXNjcmlwdGlv
biB1cGRhdGUgaGVyZSBvciBvdGhlciBwcmVmZXJlbmNlPw0KPiANCj4gWWVhaCwgYnV0IGhvdCBw
bHVnL3VucGx1ZyB3aWxsIHN0aWxsIHRha2UgdGhlIEJRTD8NCj4NCj4gQWggYnR3IEkgdGhpbmsg
aXQncyBhbHNvIE9LIHRvIHRha2UgdGhlIGxvY2sgaWYgeW91IHdhbnQgb3Igbm90IHN1cmUgYWJv
dXQgd2hldGhlcg0KPiB3ZSdsbCBhbHdheXMgdGFrZSB0aGUgQlFMIGluIHRoZXNlIHBhdGhzLiAN
Cg0KSSBndWVzcyBiZXR0ZXIgdG8gaGF2ZSBhbiBpbnRlcm5hbCBzeW5jIHRvIGF2b2lkIHJlZmVy
ZW5jZSBzdGFsZXMgSG9zdElPTU1VQ29udGV4dC4gOi0pDQoNCj4gQnV0IGlmIHNvLCBpbnN0ZWFk
IG9mIGFkZGluZyBhbm90aGVyDQo+ICJQcm90ZWN0IHRoZSAuLi4iIHNlbnRlbmNlIHRvIHRoZSBj
b21tZW50LCB3b3VsZCB5b3UgbWluZCBsaXN0IG91dCB3aGF0IHRoZSBsb2NrIGlzDQo+IHByb3Rl
Y3Rpbmc/DQo+IA0KPiAgIC8qDQo+ICAgICogaW9tbXVfbG9jayBwcm90ZWN0czoNCj4gICAgKiAt
IHBlci1JT01NVSBJT1RMQiBjYWNoZXMNCj4gICAgKiAtIGNvbnRleHQgZW50cnkgY2FjaGVzDQo+
ICAgICogLSAuLi4NCj4gICAgKi8NCj4gDQo+IE9yIGFueXRoaW5nIGJldHRlciB0aGFuIHRoYXQu
ICBUaGFua3MsDQoNCkl0IGxvb2tzIGdvb2QgdG8gbWUuIExldCBtZSB1cGRhdGUgaXQgaW4gbmV4
dCB2ZXJzaW9uLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=

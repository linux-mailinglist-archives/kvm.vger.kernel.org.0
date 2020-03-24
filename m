Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CAB190A10
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCXKBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:01:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:23182 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgCXKBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 06:01:05 -0400
IronPort-SDR: I0LrHhXT01PAdCDbJxz02rpHS9D6n34gs6bwm2PKL7Q2KazpcFxTNi329kKa3seGai7UYNyu4c
 38VrrtVhhWJg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 03:01:05 -0700
IronPort-SDR: KYOP6eP0u/BHet1K/7xFsyBxc1A19yEIEIt9QwoyudjSunHVmh5O/7CPRteaggzf4TjKdl7Fyw
 7F3H6QvsrzZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="446165647"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2020 03:01:05 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Mar 2020 03:01:05 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 24 Mar 2020 03:01:04 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 24 Mar 2020 03:01:04 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.201]) with mapi id 14.03.0439.000;
 Tue, 24 Mar 2020 18:01:00 +0800
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
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v1 04/22] hw/iommu: introduce HostIOMMUContext
Thread-Topic: [PATCH v1 04/22] hw/iommu: introduce HostIOMMUContext
Thread-Index: AQHWAEW0rB33oVdQrU+mDi1gUUEnsahWJQuAgAFKGUA=
Date:   Tue, 24 Mar 2020 10:00:59 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A200268@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-5-git-send-email-yi.l.liu@intel.com>
 <20200323205849.GO127076@xz-x1>
In-Reply-To: <20200323205849.GO127076@xz-x1>
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
cmNoIDI0LCAyMDIwIDQ6NTkgQU0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxIDA0LzIyXSBody9pb21tdTogaW50cm9kdWNlIEhv
c3RJT01NVUNvbnRleHQNCj4gDQo+IE9uIFN1biwgTWFyIDIyLCAyMDIwIGF0IDA1OjM2OjAxQU0g
LTA3MDAsIExpdSBZaSBMIHdyb3RlOg0KWy4uLl0NCj4gPiArDQo+ID4gK3ZvaWQgaG9zdF9pb21t
dV9jdHhfaW5pdCh2b2lkICpfaG9zdF9pY3gsIHNpemVfdCBpbnN0YW5jZV9zaXplLA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqbXJ0eXBlbmFtZSwNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgIHVpbnQ2NF90IGZsYWdzKQ0KPiA+ICt7DQo+ID4gKyAgICBI
b3N0SU9NTVVDb250ZXh0ICpob3N0X2ljeDsNCj4gPiArDQo+ID4gKyAgICBvYmplY3RfaW5pdGlh
bGl6ZShfaG9zdF9pY3gsIGluc3RhbmNlX3NpemUsIG1ydHlwZW5hbWUpOw0KPiA+ICsgICAgaG9z
dF9pY3ggPSBIT1NUX0lPTU1VX0NPTlRFWFQoX2hvc3RfaWN4KTsNCj4gPiArICAgIGhvc3RfaWN4
LT5mbGFncyA9IGZsYWdzOw0KPiA+ICsgICAgaG9zdF9pY3gtPmluaXRpYWxpemVkID0gdHJ1ZTsN
Cj4gPiArfQ0KPiA+ICsNCj4gPiArdm9pZCBob3N0X2lvbW11X2N0eF9kZXN0cm95KEhvc3RJT01N
VUNvbnRleHQgKmhvc3RfaWN4KQ0KPiA+ICt7DQo+ID4gKyAgICBob3N0X2ljeC0+ZmxhZ3MgPSAw
eDA7DQo+ID4gKyAgICBob3N0X2ljeC0+aW5pdGlhbGl6ZWQgPSBmYWxzZTsNCj4gPiArfQ0KPiAN
Cj4gQ2FuIHdlIHNpbXBseSBwdXQgdGhpcyBpbnRvIC5pbnN0YW5jZV9maW5hbGl6ZSgpIGFuZCBi
ZSBjYWxsZWQNCj4gYXV0b21hdGljYWxseSB3aGVuIHRoZSBvYmplY3QgbG9zZXMgdGhlIGxhc3Qg
cmVmY291bnQ/DQo+IA0KPiBBY3R1YWxseSBhbiBlYXNpZXIgd2F5IG1heSBiZSBkcm9wcGluZyB0
aGlzIGRpcmVjdGx5Li4gIElmIHRoZSBvYmplY3QNCj4gaXMgdG8gYmUgZGVzdHJveWVkIHRoZW4g
SU1ITyB3ZSBkb24ndCBuZWVkIHRvIGNhcmUgYWJvdXQgZmxhZ3MgYXQgYWxsLA0KPiB3ZSBqdXN0
IGZyZWUgbWVtb3JpZXMgd2UgdXNlLCBidXQgZm9yIHRoaXMgb2JqZWN0IGl0J3Mgbm9uZS4NCg0K
cmlnaHQsIEknbGwgZHJvcCB0aGlzIGZ1bmN0aW9uLiA6LSkNCg0KPiA+ICsNCj4gPiArc3RhdGlj
IHZvaWQgaG9zdF9pY3hfaW5pdF9mbihPYmplY3QgKm9iaikNCj4gPiArew0KPiA+ICsgICAgSG9z
dElPTU1VQ29udGV4dCAqaG9zdF9pY3ggPSBIT1NUX0lPTU1VX0NPTlRFWFQob2JqKTsNCj4gPiAr
DQo+ID4gKyAgICBob3N0X2ljeC0+ZmxhZ3MgPSAweDA7DQo+ID4gKyAgICBob3N0X2ljeC0+aW5p
dGlhbGl6ZWQgPSBmYWxzZTsNCj4gDQo+IEhlcmUgaXMgYWxzbyBhIGJpdCBzdHJhbmdlLi4uICBJ
SVVDIHRoZSBvbmx5IHdheSB0byBpbml0IHRoaXMgb2JqZWN0DQo+IGlzIHZpYSBob3N0X2lvbW11
X2N0eF9pbml0KCkgd2hlcmUgYWxsIHRoZXNlIGZsYWdzIHdpbGwgYmUgc2V0LiAgQnV0DQo+IGlm
IHNvLCB0aGVuIHdlJ3JlIHNldHRpbmcgYWxsIHRoZXNlIHR3aWNlIGFsd2F5cy4gIE1heWJlIHRo
aXMgZnVuY3Rpb24NCj4gY2FuIGJlIGRyb3BwZWQgdG9vPw0KDQp5ZXMsIGl0IGlzLiBBdCBsZWFz
dCwgaXQgaXMgbm90IG5lY2Vzc2FyeSBmb3Igbm93LiBXaWxsIGRyb3AgaXQuDQoNClRoYW5rcywN
CllpIExpdQ0KDQo=

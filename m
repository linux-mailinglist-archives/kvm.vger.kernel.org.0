Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919E9152740
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 08:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgBEH5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 02:57:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:21022 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgBEH5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 02:57:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 23:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="264134166"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga002.fm.intel.com with ESMTP; 04 Feb 2020 23:57:23 -0800
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 23:57:23 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx121.amr.corp.intel.com (10.18.125.36) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 23:57:23 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.98]) with mapi id 14.03.0439.000;
 Wed, 5 Feb 2020 15:57:21 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Thread-Topic: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Thread-Index: AQHV26+tAcTUgIsbdUG5kuoMQU0tFqgMLjsw
Date:   Wed, 5 Feb 2020 07:57:21 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1ABFE0@SHSMSX104.ccr.corp.intel.com>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
In-Reply-To: <158085337582.9445.17682266437583505502.stgit@gimli.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjVkODg5ZjktYjRmZS00NjM2LWJjZDAtYTM1YmE3YzZhZTlkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidmhDZUpCSFJcL2ZwMkRmV2lIRU9uVkZpMlZqa2dLaTFQd1ZUUytpcnd2aE5wUjFkNnFpNlRyVnNUT25ZaDh3VisifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQWxleCwNCg0KU2lsbHkgcXVlc3Rpb25zIG9uIHRoZSBiYWNrZ3JvdW5kOg0KDQo+IEZyb206
IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdl
ZG5lc2RheSwgRmVicnVhcnkgNSwgMjAyMCA3OjA2IEFNDQo+IFN1YmplY3Q6IFtSRkMgUEFUQ0gg
MC83XSB2ZmlvL3BjaTogU1ItSU9WIHN1cHBvcnQNCj4gDQo+IFRoZXJlIHNlZW1zIHRvIGJlIGFu
IG9uZ29pbmcgZGVzaXJlIHRvIHVzZSB1c2Vyc3BhY2UsIHZmaW8tYmFzZWQNCj4gZHJpdmVycyBm
b3IgYm90aCBTUi1JT1YgUEYgYW5kIFZGIGRldmljZXMuIA0KDQpJcyB0aGlzIHNlcmllcyB0byBt
YWtlIFBGIGJlIGJvdW5kLWFibGUgdG8gdmZpby1wY2kgZXZlbiBTUi1JT1YgaXMNCmVuYWJsZWQg
b24gc3VjaCBQRnM/IElmIHllcywgaXMgaXQgYWxsb3dlZCB0byBhc3NpZ24gUEYgdG8gYSBWTT8g
b3INCml0IGNhbiBvbmx5IGJlIHVzZWQgYnkgdXNlcnNwYWNlIGFwcGxpY2F0aW9ucyBsaWtlIERQ
REs/DQoNCj4gVGhlIGZ1bmRhbWVudGFsIGlzc3VlDQo+IHdpdGggdGhpcyBjb25jZXB0IGlzIHRo
YXQgdGhlIFZGIGlzIG5vdCBmdWxseSBpbmRlcGVuZGVudCBvZiB0aGUgUEYNCj4gZHJpdmVyLiAg
TWluaW1hbGx5IHRoZSBQRiBkcml2ZXIgbWlnaHQgYmUgYWJsZSB0byBkZW55IHNlcnZpY2UgdG8g
dGhlDQo+IFZGLCBWRiBkYXRhIHBhdGhzIG1pZ2h0IGJlIGRlcGVuZGVudCBvbiB0aGUgc3RhdGUg
b2YgdGhlIFBGIGRldmljZSwNCj4gb3IgdGhlIFBGIG15IGhhdmUgc29tZSBkZWdyZWUgb2YgYWJp
bGl0eSB0byBpbnNwZWN0IG9yIG1hbmlwdWxhdGUgdGhlDQo+IFZGIGRhdGEuICBJdCB0aGVyZWZv
cmUgd291bGQgc2VlbSBpcnJlc3BvbnNpYmxlIHRvIHVubGVhc2ggVkZzIG9udG8NCj4gdGhlIHN5
c3RlbSwgbWFuYWdlZCBieSBhIHVzZXIgb3duZWQgUEYuDQo+IA0KPiBXZSBhZGRyZXNzIHRoaXMg
aW4gYSBmZXcgd2F5cyBpbiB0aGlzIHNlcmllcy4gIEZpcnN0LCB3ZSBjYW4gdXNlIGEgYnVzDQo+
IG5vdGlmaWVyIGFuZCB0aGUgZHJpdmVyX292ZXJyaWRlIGZhY2lsaXR5IHRvIG1ha2Ugc3VyZSBW
RnMgYXJlIGJvdW5kDQo+IHRvIHRoZSB2ZmlvLXBjaSBkcml2ZXIgYnkgZGVmYXVsdC4gIFRoaXMg
c2hvdWxkIGVsaW1pbmF0ZSB0aGUgY2hhbmNlDQo+IHRoYXQgYSBWRiBpcyBhY2NpZGVudGFsbHkg
Ym91bmQgYW5kIHVzZWQgYnkgaG9zdCBkcml2ZXJzLiAgV2UgZG9uJ3QNCj4gaG93ZXZlciByZW1v
dmUgdGhlIGFiaWxpdHkgZm9yIGEgaG9zdCBhZG1pbiB0byBjaGFuZ2UgdGhpcyBvdmVycmlkZS4N
Cj4gDQo+IFRoZSBuZXh0IGlzc3VlIHdlIG5lZWQgdG8gYWRkcmVzcyBpcyBob3cgd2UgbGV0IHVz
ZXJzcGFjZSBkcml2ZXJzDQo+IG9wdC1pbiB0byB0aGlzIHBhcnRpY2lwYXRpb24gd2l0aCB0aGUg
UEYgZHJpdmVyLiAgV2UgZG8gbm90IHdhbnQgYW4NCj4gYWRtaW4gdG8gYmUgYWJsZSB0byB1bndp
dHRpbmdseSBhc3NpZ24gb25lIG9mIHRoZXNlIFZGcyB0byBhIHRlbmFudA0KPiB0aGF0IGlzbid0
IHdvcmtpbmcgaW4gY29sbGFib3JhdGlvbiB3aXRoIHRoZSBQRiBkcml2ZXIuICBXZSBjb3VsZCB1
c2UNCj4gSU9NTVUgZ3JvdXBpbmcsIGJ1dCB0aGlzIHNlZW1zIHRvIHB1c2ggdG9vIGZhciB0b3dh
cmRzIHRpZ2h0bHkgY291cGxlZA0KPiBQRiBhbmQgVkYgZHJpdmVycy4gIFRoaXMgc2VyaWVzIGlu
dHJvZHVjZXMgYSAiVkYgdG9rZW4iLCBpbXBsZW1lbnRlZA0KPiBhcyBhIFVVSUQsIGFzIGEgc2hh
cmVkIHNlY3JldCBiZXR3ZWVuIFBGIGFuZCBWRiBkcml2ZXJzLiAgVGhlIHRva2VuDQo+IG5lZWRz
IHRvIGJlIHNldCBieSB0aGUgUEYgZHJpdmVyIGFuZCB1c2VkIGFzIHBhcnQgb2YgdGhlIGRldmlj
ZQ0KPiBtYXRjaGluZyBieSB0aGUgVkYgZHJpdmVyLiAgUHJvdmlzaW9ucyBpbiB0aGUgY29kZSBh
bHNvIGFjY291bnQgZm9yDQo+IHJlc3RhcnRpbmcgdGhlIFBGIGRyaXZlciB3aXRoIGFjdGl2ZSBW
RiBkcml2ZXJzLCByZXF1aXJpbmcgdGhlIFBGIHRvDQo+IHVzZSB0aGUgY3VycmVudCB0b2tlbiB0
byByZS1nYWluIGFjY2VzcyB0byB0aGUgUEYuDQoNCkhvdyBhYm91dCB0aGUgc2NlbmFyaW8gaW4g
d2hpY2ggUEYgZHJpdmVyIGlzIHZmaW8tYmFzZWQgdXNlcnNwYWNlDQpkcml2ZXIgYnV0IFZGIGRy
aXZlcnMgYXJlIG1peGVkLiBUaGlzIG1lYW5zIG5vdCBhbGwgVkZzIGFyZSBib3VuZA0KdG8gdmZp
by1iYXNlZCB1c2Vyc3BhY2UgZHJpdmVyLiBJcyBpdCBhbHNvIHN1cHBvcnRlZCBoZXJlPyA6LSkN
Cg0KUmVnYXJkcywNCllpIExpdQ0K

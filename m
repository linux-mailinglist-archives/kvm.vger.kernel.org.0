Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2813152743
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 08:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgBEH5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 02:57:34 -0500
Received: from mga07.intel.com ([134.134.136.100]:58582 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgBEH5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 02:57:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 23:57:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="235491067"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2020 23:57:32 -0800
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 23:57:32 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 23:57:32 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.97]) with mapi id 14.03.0439.000;
 Wed, 5 Feb 2020 15:57:30 +0800
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
Subject: RE: [RFC PATCH 3/7] vfio/pci: Introduce VF token
Thread-Topic: [RFC PATCH 3/7] vfio/pci: Introduce VF token
Thread-Index: AQHV26+4PVHFRLPPL0yrU9jxlm4a8KgMOO/w
Date:   Wed, 5 Feb 2020 07:57:29 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1ABFF0@SHSMSX104.ccr.corp.intel.com>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
 <158085756068.9445.6284766069491778316.stgit@gimli.home>
In-Reply-To: <158085756068.9445.6284766069491778316.stgit@gimli.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODJlMGY4MDUtZmJlNi00ZWE5LWIyNDQtNGFhNmQzNGNkOGEyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUnVQNjgzZDk0UTRROTFPTkpINnR1K1lVMXJNR1JpVjJjSnZaMVl0SEg1MG0zdlZDSHByVXlCWmcxK0VoMXJWeCJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDUsIDIwMjAgNzowNiBBTQ0KPiBUbzoga3ZtQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUkZDIFBBVENIIDMvN10gdmZpby9wY2k6IEludHJvZHVj
ZSBWRiB0b2tlbg0KPiANCj4gSWYgd2UgZW5hYmxlIFNSLUlPViBvbiBhIHZmaW8tcGNpIG93bmVk
IFBGLCB0aGUgcmVzdWx0aW5nIFZGcyBhcmUgbm90DQo+IGZ1bGx5IGlzb2xhdGVkIGZyb20gdGhl
IFBGLiAgVGhlIFBGIGNhbiBhbHdheXMgY2F1c2UgYSBkZW5pYWwgb2YNCj4gc2VydmljZSB0byB0
aGUgVkYsIGlmIG5vdCBhY2Nlc3MgZGF0YSBwYXNzZWQgdGhyb3VnaCB0aGUgVkYgZGlyZWN0bHku
DQo+IFRoaXMgaXMgd2h5IHZmaW8tcGNpIGN1cnJlbnRseSBkb2VzIG5vdCBiaW5kIHRvIFBGcyB3
aXRoIFNSLUlPViBlbmFibGVkDQo+IGFuZCBkb2VzIG5vdCBwcm92aWRlIGFjY2VzcyBpdHNlbGYg
dG8gZW5hYmxpbmcgU1ItSU9WIG9uIGEgUEYuICBUaGUNCj4gSU9NTVUgZ3JvdXBpbmcgbWVjaGFu
aXNtIG1pZ2h0IGFsbG93IHVzIGEgc29sdXRpb24gdG8gdGhpcyBsYWNrIG9mDQo+IGlzb2xhdGlv
biwgaG93ZXZlciB0aGUgZGVmaWNpZW5jeSBpc24ndCBhY3R1YWxseSBpbiB0aGUgRE1BIHBhdGgs
IHNvDQo+IG11Y2ggYXMgdGhlIHBvdGVudGlhbCBjb29wZXJhdGlvbiBiZXR3ZWVuIFBGIGFuZCBW
RiBkZXZpY2VzLiAgQWxzbywNCj4gaWYgd2Ugd2VyZSB0byBmb3JjZSBWRnMgaW50byB0aGUgc2Ft
ZSBJT01NVSBncm91cCBhcyB0aGUgUEYsIHdlIHNldmVyZWx5DQo+IGxpbWl0IHRoZSB1dGlsaXR5
IG9mIGhhdmluZyBpbmRlcGVuZGVudCBkcml2ZXJzIG1hbmFnaW5nIFBGcyBhbmQgVkZzDQo+IHdp
dGggdmZpby4NCj4gDQo+IFRoZXJlZm9yZSB3ZSBpbnRyb2R1Y2UgdGhlIGNvbmNlcHQgb2YgYSBW
RiB0b2tlbi4gIFRoZSB0b2tlbiBpcw0KPiBpbXBsZW1lbnRlZCBhcyBhIFVVSUQgYW5kIHJlcHJl
c2VudHMgYSBzaGFyZWQgc2VjcmV0IHdoaWNoIG11c3QgYmUgc2V0DQo+IGJ5IHRoZSBQRiBkcml2
ZXIgYW5kIHVzZWQgYnkgdGhlIFZGIGRyaXZlcnMgaW4gb3JkZXIgdG8gYWNjZXNzIGEgdmZpbw0K
PiBkZXZpY2UgZmlsZSBkZXNjcmlwdG9yIGZvciB0aGUgVkYuICBUaGUgaW9jdGwgdG8gc2V0IHRo
ZSBWRiB0b2tlbiB3aWxsDQo+IGJlIHByb3ZpZGVkIGluIGEgbGF0ZXIgY29tbWl0LCB0aGlzIGNv
bW1pdCBpbXBsZW1lbnRzIHRoZSB1bmRlcmx5aW5nDQo+IGluZnJhc3RydWN0dXJlLiAgVGhlIGNv
bmNlcHQgaGVyZSBpcyB0byBhdWdtZW50IHRoZSBzdHJpbmcgdGhlIHVzZXINCj4gcGFzc2VzIHRv
IG1hdGNoIGEgZGV2aWNlIHdpdGhpbiBhIGdyb3VwIGluIG9yZGVyIHRvIHJldHJpZXZlIGFjY2Vz
cyB0bw0KPiB0aGUgZGV2aWNlIGRlc2NyaXB0b3IuICBGb3IgZXhhbXBsZSwgcmF0aGVyIHRoYW4g
cGFzc2luZyBvbmx5IHRoZSBQQ0kNCj4gZGV2aWNlIG5hbWUgKGV4LiAiMDAwMDowMzowMC4wIikg
dGhlIHVzZXIgd291bGQgYWxzbyBwYXNzIGEgdmZfdG9rZW4NCj4gVVVJRCAoZXguICIyYWI3NDky
NC1jMzM1LTQ1ZjQtOWIxNi04NTY5ZTViMDgyNTgiKS4gIFRoZSBkZXZpY2UgbWF0Y2gNCj4gc3Ry
aW5nIHRoZXJlZm9yZSBiZWNvbWVzOg0KPiANCj4gIjAwMDA6MDM6MDAuMCB2Zl90b2tlbj0yYWI3
NDkyNC1jMzM1LTQ1ZjQtOWIxNi04NTY5ZTViMDgyNTgiDQo+IA0KPiBUaGlzIHN5bnRheCBpcyBl
eHBlY3RlZCB0byBiZSBleHRlbnNpYmxlIHRvIGZ1dHVyZSBvcHRpb25zIGFzIHdlbGwsIHdpdGgN
Cj4gdGhlIHN0YW5kYXJkIGJlaW5nOg0KPiANCj4gIiRERVZJQ0VfTkFNRSAkT1BUSU9OMT0kVkFM
VUUxICRPUFRJT04yPSRWQUxVRTIiDQo+IA0KPiBUaGUgZGV2aWNlIG5hbWUgbXVzdCBiZSBmaXJz
dCBhbmQgb3B0aW9uPXZhbHVlIHBhaXJzIGFyZSBzZXBhcmF0ZWQgYnkNCj4gc3BhY2VzLg0KPiAN
Cj4gVGhlIHZmX3Rva2VuIG9wdGlvbiBpcyBvbmx5IHJlcXVpcmVkIGZvciBWRnMgd2hlcmUgdGhl
IFBGIGRldmljZSBpcw0KPiBib3VuZCB0byB2ZmlvLXBjaS4gIFRoZXJlIGlzIG5vIGNoYW5nZSBm
b3IgUEZzIHVzaW5nIGV4aXN0aW5nIGhvc3QNCj4gZHJpdmVycy4NCj4gDQo+IE5vdGUgdGhhdCBp
biBvcmRlciB0byBwcm90ZWN0IGV4aXN0aW5nIFZGIHVzZXJzLCBub3Qgb25seSBpcyBpdCByZXF1
aXJlZA0KPiB0byBzZXQgYSB2Zl90b2tlbiBvbiB0aGUgUEYgYmVmb3JlIFZGcyBkZXZpY2VzIGNh
biBiZSBhY2Nlc3NlZCwgYnV0IGFsc28NCj4gaWYgdGhlcmUgYXJlIGV4aXN0aW5nIFZGIHVzZXJz
LCAocmUpb3BlbmluZyB0aGUgUEYgZGV2aWNlIG11c3QgYWxzbw0KPiBwcm92aWRlIHRoZSBjdXJy
ZW50IHZmX3Rva2VuIGFzIGF1dGhlbnRpY2F0aW9uLiAgVGhpcyBpcyBpbnRlbmRlZCB0bw0KPiBw
cmV2ZW50IGEgVkYgZHJpdmVyIHN0YXJ0aW5nIHdpdGggYSB0cnVzdGVkIFBGIGRyaXZlciBhbmQg
bGF0ZXIgYmVpbmcNCj4gcmVwbGFjZWQgYnkgYW4gdW5rbm93biBkcml2ZXIuICBBIHZmX3Rva2Vu
IGlzIG5vdCByZXF1aXJlZCB0byBvcGVuIHRoZQ0KPiBQRiBkZXZpY2Ugd2hlbiBub25lIG9mIHRo
ZSBWRiBkZXZpY2VzIGFyZSBpbiB1c2UgYnkgdmZpby1wY2kgZHJpdmVycy4NCg0KU28gdmZpb190
b2tlbiBpcyBhIGtpbmQgb2YgcGVyLVBGIHRva2VuPw0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCg==

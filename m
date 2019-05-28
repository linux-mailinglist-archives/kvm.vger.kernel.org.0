Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416DC2BCEF
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 03:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfE1BnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 21:43:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:3308 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727271AbfE1BnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 21:43:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 18:42:59 -0700
X-ExtLoop1: 1
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga007.fm.intel.com with ESMTP; 27 May 2019 18:42:59 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 27 May 2019 18:42:58 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX157.amr.corp.intel.com (10.18.116.73) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 27 May 2019 18:42:58 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.129]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.150]) with mapi id 14.03.0415.000;
 Tue, 28 May 2019 09:42:57 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
Subject: RE: [PATCH 1/2] vfio: ABI for setting mdev display flip eventfd
Thread-Topic: [PATCH 1/2] vfio: ABI for setting mdev display flip eventfd
Thread-Index: AQHVFGkBZrgUKUW3hkmSal0+smAhlaZ+e0YAgAFF88A=
Date:   Tue, 28 May 2019 01:42:57 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC87620FF2@SHSMSX101.ccr.corp.intel.com>
References: <20190527084312.8872-1-tina.zhang@intel.com>
 <20190527084312.8872-2-tina.zhang@intel.com>
 <20190527080430.28f40888@x1.home>
In-Reply-To: <20190527080430.28f40888@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDQwMTZkZTEtMWVlOC00OTdkLTkzZGEtNjE3M2M3Zjc4MWQ1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidXpaRkw3MVpkR1l3Tk0yVjU0NERYREI2SUVpdnRGcHl1QVJHeE1DbDFTbXBaKzRoNXcrY2lhcEEwc0xyNUJ5ZiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogaW50ZWwtZ3Z0LWRldiBb
bWFpbHRvOmludGVsLWd2dC1kZXYtYm91bmNlc0BsaXN0cy5mcmVlZGVza3RvcC5vcmddIE9uDQo+
IEJlaGFsZiBPZiBBbGV4IFdpbGxpYW1zb24NCj4gU2VudDogTW9uZGF5LCBNYXkgMjcsIDIwMTkg
MTA6MDUgUE0NCj4gVG86IFpoYW5nLCBUaW5hIDx0aW5hLnpoYW5nQGludGVsLmNvbT4NCj4gQ2M6
IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IHpo
ZW55dXdAbGludXguaW50ZWwuY29tOyBZdWFuLCBIYW5nIDxoYW5nLnl1YW5AaW50ZWwuY29tPjsN
Cj4ga3JheGVsQHJlZGhhdC5jb207IGludGVsLWd2dC1kZXZAbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
OyBMdiwgWmhpeXVhbg0KPiA8emhpeXVhbi5sdkBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggMS8yXSB2ZmlvOiBBQkkgZm9yIHNldHRpbmcgbWRldiBkaXNwbGF5IGZsaXAgZXZlbnRm
ZA0KPiANCj4gT24gTW9uLCAyNyBNYXkgMjAxOSAxNjo0MzoxMSArMDgwMA0KPiBUaW5hIFpoYW5n
IDx0aW5hLnpoYW5nQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPiA+IEFkZCBWRklPX0RFVklDRV9T
RVRfR0ZYX0ZMSVBfRVZFTlRGRCBpb2N0bCBjb21tYW5kIHRvIHNldCBldmVudGZkDQo+ID4gYmFz
ZWQgc2lnbmFsaW5nIG1lY2hhbmlzbSB0byBkZWxpdmVyIHZHUFUgZnJhbWVidWZmZXIgcGFnZSBm
bGlwIGV2ZW50DQo+ID4gdG8gdXNlcnNwYWNlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogVGlu
YSBaaGFuZyA8dGluYS56aGFuZ0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvdWFw
aS9saW51eC92ZmlvLmggfCAxMiArKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEy
IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgv
dmZpby5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+IGluZGV4IDAyYmI3YWQ2ZTk4
Ni4uMjczMDA1OTc3MTdmIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC92Zmlv
LmgNCj4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oDQo+ID4gQEAgLTY5Niw2ICs2
OTYsMTggQEAgc3RydWN0IHZmaW9fZGV2aWNlX2lvZXZlbnRmZCB7DQo+ID4NCj4gPiAgI2RlZmlu
ZSBWRklPX0RFVklDRV9JT0VWRU5URkQJCV9JTyhWRklPX1RZUEUsIFZGSU9fQkFTRSArDQo+IDE2
KQ0KPiA+DQo+ID4gKy8qKg0KPiA+ICsgKiBWRklPX0RFVklDRV9TRVRfR0ZYX0ZMSVBfRVZFTlRG
RCAtIF9JT1coVkZJT19UWVBFLCBWRklPX0JBU0UNCj4gKyAxNywNCj4gPiArX19zMzIpDQo+ID4g
KyAqDQo+ID4gKyAqIFNldCBldmVudGZkIGJhc2VkIHNpZ25hbGluZyBtZWNoYW5pc20gdG8gZGVs
aXZlciB2R1BVIGZyYW1lYnVmZmVyDQo+ID4gK3BhZ2UNCj4gPiArICogZmxpcCBldmVudCB0byB1
c2Vyc3BhY2UuIEEgdmFsdWUgb2YgLTEgaXMgdXNlZCB0byBzdG9wIHRoZSBwYWdlDQo+ID4gK2Zs
aXANCj4gPiArICogZGVsaXZlcmluZy4NCj4gPiArICoNCj4gPiArICogUmV0dXJuOiAwIG9uIHN1
Y2Nlc3MsIC1lcnJubyBvbiBmYWlsdXJlLg0KPiA+ICsgKi8NCj4gPiArDQo+ID4gKyNkZWZpbmUg
VkZJT19ERVZJQ0VfU0VUX0dGWF9GTElQX0VWRU5URkQgX0lPKFZGSU9fVFlQRSwNCj4gVkZJT19C
QVNFICsNCj4gPiArMTcpDQo+ID4gKw0KPiA+ICAvKiAtLS0tLS0tLSBBUEkgZm9yIFR5cGUxIFZG
SU8gSU9NTVUgLS0tLS0tLS0gKi8NCj4gPg0KPiA+ICAvKioNCj4gDQo+IFdoeSBjYW4ndCB3ZSB1
c2UgVkZJT19ERVZJQ0VfU0VUX0lSUVMgZm9yIHRoaXM/ICBXZSBjYW4gYWRkIGEgY2FwYWJpbGl0
eQ0KPiB0byB2ZmlvX2lycV9pbmZvIGluIHRoZSBzYW1lIHdheSB0aGF0IHdlIGRpZCBmb3IgcmVn
aW9ucyB0byBkZXNjcmliZSBkZXZpY2UNCj4gc3BlY2lmaWMgSVJRIHN1cHBvcnQuICBUaGFua3Ms
DQpBZGQgYSBuZXcga2luZCBvZiBpbmRleCwgbGlrZSB0aGlzPw0KZW51bSB7DQogICAgICAgIFZG
SU9fUENJX0lOVFhfSVJRX0lOREVYLA0KICAgICAgICBWRklPX1BDSV9NU0lfSVJRX0lOREVYLA0K
ICAgICAgICBWRklPX1BDSV9NU0lYX0lSUV9JTkRFWCwNCiAgICAgICAgVkZJT19QQ0lfRVJSX0lS
UV9JTkRFWCwNCiAgICAgICAgVkZJT19QQ0lfUkVRX0lSUV9JTkRFWCwNCisgICAgICBWRklPX1BD
SV9HRlhfRkxJUF9FVkVOVF9JTkRFWCwNCiAgICAgICAgVkZJT19QQ0lfTlVNX0lSUVMNCn07DQpQ
ZXJoYXBzIHRoaXMgaXMgd2hhdCB3ZSBkb24ndCB3YW50LiBUaGlzIFZGSU9fUENJX0dGWF9GTElQ
X0VWRU5UX0lOREVYIGlzIHNwZWNpZmljIHRvIGdyYXBoaWNzIGNhcmQgYW5kIGl0J3MgYWN0dWFs
bHkgYW4gZXZlbnQgd2hpY2ggaXMgcmVwb3J0ZWQgYnkgSU5UWC9NU0kvIE1TSVggSVJRLg0KVGhh
bmtzLg0KDQpCUiwNClRpbmENCj4gDQo+IEFsZXgNCj4gX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18NCj4gaW50ZWwtZ3Z0LWRldiBtYWlsaW5nIGxpc3QNCj4g
aW50ZWwtZ3Z0LWRldkBsaXN0cy5mcmVlZGVza3RvcC5vcmcNCj4gaHR0cHM6Ly9saXN0cy5mcmVl
ZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1ndnQtZGV2DQo=

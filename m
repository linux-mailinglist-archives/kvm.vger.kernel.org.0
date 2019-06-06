Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91C236A48
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 04:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFFC5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 22:57:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:52297 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfFFC5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 22:57:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 19:57:42 -0700
X-ExtLoop1: 1
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 05 Jun 2019 19:57:41 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 5 Jun 2019 19:57:41 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 5 Jun 2019 19:57:41 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.137]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.10]) with mapi id 14.03.0415.000;
 Thu, 6 Jun 2019 10:57:39 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "kraxel@redhat.com" <kraxel@redhat.com>,
        "Zhang, Tina" <tina.zhang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [RFC PATCH v2 1/3] vfio: Use capability chains to handle device
 specific irq
Thread-Topic: [RFC PATCH v2 1/3] vfio: Use capability chains to handle
 device specific irq
Thread-Index: AQHVGrx1ebYylKGK4UKyy6MOQKDPAaaL7AoAgABXwgCAAA40AIABn6Bw
Date:   Thu, 6 Jun 2019 02:57:38 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19CA6BA5F@SHSMSX104.ccr.corp.intel.com>
References: <20190604095534.10337-1-tina.zhang@intel.com>
 <20190604095534.10337-2-tina.zhang@intel.com>
 <20190605040446.GW9684@zhen-hp.sh.intel.com>
 <237F54289DF84E4997F34151298ABEBC87646B5C@SHSMSX101.ccr.corp.intel.com>
 <20190605100942.bceke6yqjynuwk3z@sirius.home.kraxel.org>
In-Reply-To: <20190605100942.bceke6yqjynuwk3z@sirius.home.kraxel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTA5YmFhMzItZDY3My00NDFmLWE1ZjEtYTVhZWE4MmZjZDA4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaSt2cXc2ZVFzOWNxUXE3VlJlNnlwaExza1Z2RWs5dmY1YnlFd1VxS0JGaGIweEtpSWxPOEttXC9PdVY4dFp5M1MifQ==
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBrcmF4ZWxAcmVkaGF0LmNvbQ0KPiBTZW50OiBXZWRuZXNkYXksIEp1bmUgNSwgMjAx
OSA2OjEwIFBNDQo+IA0KPiAgIEhpLA0KPiANCj4gPiA+IFJlYWxseSBuZWVkIHRvIHNwbGl0IGZv
ciBkaWZmZXJlbnQgcGxhbmVzPyBJJ2QgbGlrZSBhDQo+ID4gPiBWRklPX0lSUV9TVUJUWVBFX0dG
WF9ESVNQTEFZX0VWRU5UDQo+ID4gPiBzbyB1c2VyIHNwYWNlIGNhbiBwcm9iZSBjaGFuZ2UgZm9y
IGFsbC4NCj4gDQo+ID4gVXNlciBzcGFjZSBjYW4gY2hvb3NlIHRvIHVzZXIgZGlmZmVyZW50IGhh
bmRsZXJzIGFjY29yZGluZyB0byB0aGUNCj4gPiBzcGVjaWZpYyBldmVudC4gRm9yIGV4YW1wbGUs
IHVzZXIgc3BhY2UgbWlnaHQgbm90IHdhbnQgdG8gaGFuZGxlIGV2ZXJ5DQo+ID4gY3Vyc29yIGV2
ZW50IGR1ZSB0byBwZXJmb3JtYW5jZSBjb25zaWRlcmF0aW9uLiBCZXNpZGVzLCBpdCBjYW4gcmVk
dWNlDQo+ID4gdGhlIHByb2JlIHRpbWVzLCBhcyB3ZSBkb24ndCBuZWVkIHRvIHByb2JlIHR3aWNl
IHRvIG1ha2Ugc3VyZSBpZiBib3RoDQo+ID4gY3Vyc29yIHBsYW5lIGFuZCBwcmltYXJ5IHBsYW5l
IGhhdmUgYmVlbiB1cGRhdGVkLg0KPiANCj4gSSdkIHN1Z2dlc3QgdG8gdXNlIHRoZSB2YWx1ZSBw
YXNzZWQgdmlhIGV2ZW50ZmQgZm9yIHRoYXQsIGkuZS4gaW5zdGVhZA0KPiBvZiBzZW5kaW5nICIx
IiB1bmNvbmRpdGlvbmFsbHkgc2VuZCBhIG1hc2sgb2YgY2hhbmdlZCBwbGFuZXMuDQo+IA0KDQpz
b3VuZHMgcmVhc29uYWJsZS4NCg==

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047E919D9FF
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404197AbgDCPWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 11:22:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:60819 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404080AbgDCPWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 11:22:35 -0400
IronPort-SDR: 8tQ4SmmFyTJE+t9Pq0MjeXS6oqUxuzqiqzL0dU3006YU12nbC8H06PfQwU/8se4ZTv/+A1AXlK
 MbOf0qUlIFGQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 08:22:35 -0700
IronPort-SDR: 6dkDtNX7hVyCjotVyN12MuoogVOD2MPmbHdAtS+MiWhB1Fv4twoT6DUBdwgXAM0XLmhytL30OV
 czKa44hf5ugg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,340,1580803200"; 
   d="scan'208";a="273985029"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga004.fm.intel.com with ESMTP; 03 Apr 2020 08:22:34 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 08:22:34 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 08:22:34 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.214]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 23:22:30 +0800
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
Subject: RE: [PATCH v2 22/22] intel_iommu: modify x-scalable-mode to be
 string option
Thread-Topic: [PATCH v2 22/22] intel_iommu: modify x-scalable-mode to be
 string option
Thread-Index: AQHWBkpm59x7Ktlcj0O62O8lV3b/nahm+2cAgACPQEA=
Date:   Fri, 3 Apr 2020 15:22:30 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A220E75@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-23-git-send-email-yi.l.liu@intel.com>
 <20200403144916.GM103677@xz-x1>
In-Reply-To: <20200403144916.GM103677@xz-x1>
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

PiBGcm9tOiAgUGV0ZXIgWHUgPCBwZXRlcnhAcmVkaGF0LmNvbT4NCj4gU2VudDogRnJpZGF5LCBB
cHJpbCAzLCAyMDIwIDEwOjQ5IFBNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAyMi8yMl0gaW50ZWxfaW9tbXU6IG1vZGlmeSB4
LXNjYWxhYmxlLW1vZGUgdG8gYmUgc3RyaW5nDQo+IG9wdGlvbg0KPiANCj4gT24gU3VuLCBNYXIg
MjksIDIwMjAgYXQgMDk6MjU6MDFQTSAtMDcwMCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gSW50ZWwg
VlQtZCAzLjAgaW50cm9kdWNlcyBzY2FsYWJsZSBtb2RlLCBhbmQgaXQgaGFzIGEgYnVuY2ggb2YN
Cj4gPiBjYXBhYmlsaXRpZXMgcmVsYXRlZCB0byBzY2FsYWJsZSBtb2RlIHRyYW5zbGF0aW9uLCB0
aHVzIHRoZXJlIGFyZSBtdWx0aXBsZQ0KPiBjb21iaW5hdGlvbnMuDQo+ID4gV2hpbGUgdGhpcyB2
SU9NTVUgaW1wbGVtZW50YXRpb24gd2FudHMgc2ltcGxpZnkgaXQgZm9yIHVzZXIgYnkNCj4gPiBw
cm92aWRpbmcgdHlwaWNhbCBjb21iaW5hdGlvbnMuIFVzZXIgY291bGQgY29uZmlnIGl0IGJ5DQo+
ID4gIngtc2NhbGFibGUtbW9kZSIgb3B0aW9uLiBUaGUgdXNhZ2UgaXMgYXMgYmVsb3c6DQo+ID4N
Cj4gPiAiLWRldmljZSBpbnRlbC1pb21tdSx4LXNjYWxhYmxlLW1vZGU9WyJsZWdhY3kifCJtb2Rl
cm4ifCJvZmYiXSINCj4gPg0KPiA+ICAtICJsZWdhY3kiOiBnaXZlcyBzdXBwb3J0IGZvciBTTCBw
YWdlIHRhYmxlDQo+ID4gIC0gIm1vZGVybiI6IGdpdmVzIHN1cHBvcnQgZm9yIEZMIHBhZ2UgdGFi
bGUsIHBhc2lkLCB2aXJ0dWFsIGNvbW1hbmQNCj4gPiAgLSAib2ZmIjogbm8gc2NhbGFibGUgbW9k
ZSBzdXBwb3J0DQo+ID4gIC0gIGlmIG5vdCBjb25maWd1cmVkLCBtZWFucyBubyBzY2FsYWJsZSBt
b2RlIHN1cHBvcnQsIGlmIG5vdCBwcm9wZXINCj4gPiAgICAgY29uZmlndXJlZCwgd2lsbCB0aHJv
dyBlcnJvcg0KPiA+DQo+ID4gTm90ZTogdGhpcyBwYXRjaCBpcyBzdXBwb3NlZCB0byBiZSBtZXJn
ZWQgd2hlbiAgdGhlIHdob2xlIHZTVkEgcGF0Y2gNCj4gPiBzZXJpZXMgd2VyZSBtZXJnZWQuDQo+
ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gQ2M6IEph
Y29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IFBldGVyIFh1
IDxwZXRlcnhAcmVkaGF0LmNvbT4NCj4gPiBDYzogWWkgU3VuIDx5aS55LnN1bkBsaW51eC5pbnRl
bC5jb20+DQo+ID4gQ2M6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQo+ID4g
Q2M6IFJpY2hhcmQgSGVuZGVyc29uIDxydGhAdHdpZGRsZS5uZXQ+DQo+ID4gQ2M6IEVkdWFyZG8g
SGFia29zdCA8ZWhhYmtvc3RAcmVkaGF0LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBMaXUgWWkg
TCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlpIFN1biA8eWkueS5z
dW5AbGludXguaW50ZWwuY29tPg0KPiANCj4gUmV2aWV3ZWQtYnk6IFBldGVyIFh1IDxwZXRlcnhA
cmVkaGF0LmNvbT4NCnRoYW5rcyBmb3IgeW91ciBoZWxwLiA6LSkNCg0KUmVnYXJkcywNCllpIExp
dQ0K

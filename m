Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3958F57EC3
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 10:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfF0Iz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 04:55:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:39937 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfF0IzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 04:55:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 01:55:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,423,1557212400"; 
   d="scan'208";a="156170938"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 27 Jun 2019 01:55:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 01:55:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 01:55:23 -0700
Received: from shsmsx104.ccr.corp.intel.com (10.239.4.70) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Jun 2019 01:55:23 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.87]) by
 SHSMSX104.ccr.corp.intel.com ([169.254.5.185]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 16:55:22 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [RFC PATCH v3 1/4] vfio: Define device specific irq type
 capability
Thread-Topic: [RFC PATCH v3 1/4] vfio: Define device specific irq type
 capability
Thread-Index: AQHVLJqY892xL/jYXUCHg0oNNo51Q6augUsAgACuxqA=
Date:   Thu, 27 Jun 2019 08:55:21 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC87683644@SHSMSX101.ccr.corp.intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
 <20190627033802.1663-2-tina.zhang@intel.com>
 <20190627061942.k5onxbm27dju3iv5@sirius.home.kraxel.org>
In-Reply-To: <20190627061942.k5onxbm27dju3iv5@sirius.home.kraxel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZWFhMDI3NzQtZDYwMC00YjQ4LTg2NzEtYmY4MjQxM2UyNWE3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWWRINGo5MDRjMDBpcThxZ1JQb2JaTUZjQlFObEdLM3JDU2pBYzBQT2g0RXFJNmMzbHNHeWVPSUpGSUVzZXorOCJ9
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
IEJlaGFsZiBPZiBHZXJkIEhvZmZtYW5uDQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDI3LCAyMDE5
IDI6MjAgUE0NCj4gVG86IFpoYW5nLCBUaW5hIDx0aW5hLnpoYW5nQGludGVsLmNvbT4NCj4gQ2M6
IFRpYW4sIEtldmluIDxrZXZpbi50aWFuQGludGVsLmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyB6aGVueXV3QGxpbnV4LmludGVsLmNv
bTsgWXVhbiwgSGFuZw0KPiA8aGFuZy55dWFuQGludGVsLmNvbT47IGFsZXgud2lsbGlhbXNvbkBy
ZWRoYXQuY29tOyBMdiwgWmhpeXVhbg0KPiA8emhpeXVhbi5sdkBpbnRlbC5jb20+OyBpbnRlbC1n
dnQtZGV2QGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgV2FuZywgWmhpIEENCj4gPHpoaS5hLndhbmdA
aW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCB2MyAxLzRdIHZmaW86IERlZmlu
ZSBkZXZpY2Ugc3BlY2lmaWMgaXJxIHR5cGUNCj4gY2FwYWJpbGl0eQ0KPiANCj4gICBIaSwNCj4g
DQo+ID4gK3N0cnVjdCB2ZmlvX2lycV9pbmZvX2NhcF90eXBlIHsNCj4gPiArCXN0cnVjdCB2Zmlv
X2luZm9fY2FwX2hlYWRlciBoZWFkZXI7DQo+ID4gKwlfX3UzMiB0eXBlOyAgICAgLyogZ2xvYmFs
IHBlciBidXMgZHJpdmVyICovDQo+ID4gKwlfX3UzMiBzdWJ0eXBlOyAgLyogdHlwZSBzcGVjaWZp
YyAqLw0KPiANCj4gRG8gd2UgcmVhbGx5IG5lZWQgYm90aCB0eXBlIGFuZCBzdWJ0eXBlPw0KVGhl
biwgaWYgb25lIGRldmljZSBoYXMgc2V2ZXJhbCBpcnFzLCBob3cgY2FuIHdlIGlkZW50aWZ5IHRo
ZW0/DQpUaGFua3MuDQoNCkJSLA0KdGluYQ0KPiANCj4gY2hlZXJzLA0KPiAgIEdlcmQNCj4gDQo+
IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IGludGVs
LWd2dC1kZXYgbWFpbGluZyBsaXN0DQo+IGludGVsLWd2dC1kZXZAbGlzdHMuZnJlZWRlc2t0b3Au
b3JnDQo+IGh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50
ZWwtZ3Z0LWRldg0K

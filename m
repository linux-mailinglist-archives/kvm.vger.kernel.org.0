Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD335B4A72
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 11:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfIQJ1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 05:27:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:6874 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727447AbfIQJ1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 05:27:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 02:27:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,515,1559545200"; 
   d="scan'208";a="270483217"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga001.jf.intel.com with ESMTP; 17 Sep 2019 02:27:11 -0700
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 17 Sep 2019 02:27:11 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx109.amr.corp.intel.com (10.18.116.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 17 Sep 2019 02:27:10 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.92]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.195]) with mapi id 14.03.0439.000;
 Tue, 17 Sep 2019 17:27:08 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     "kraxel@redhat.com" <kraxel@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
Subject: RE: [PATCH v5 0/6] Deliver vGPU display refresh event to userspace
Thread-Topic: [PATCH v5 0/6] Deliver vGPU display refresh event to userspace
Thread-Index: AQHVU9tUM+mrk1EK3UW2FOPyJRIR1KcZNxaggAMX1YCAE3M5kA==
Date:   Tue, 17 Sep 2019 09:27:08 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC87734BB6@SHSMSX101.ccr.corp.intel.com>
References: <20190816023528.30210-1-tina.zhang@intel.com>
 <237F54289DF84E4997F34151298ABEBC8771E7AE@SHSMSX101.ccr.corp.intel.com>
 <20190905074857.n3akutnoarnfvg4y@sirius.home.kraxel.org>
In-Reply-To: <20190905074857.n3akutnoarnfvg4y@sirius.home.kraxel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmNhNzQ0MTctZjBjNy00ZmI3LThiMzItYTg0MTBiNDJkN2U3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibmc3aVwvMmlTQnVoYkwwVzRseHlpd3pEUFZcLzh1VHlzcEk0ZlRPMEl3UCtQZ08xYlhQejQ0ejZ6WHdcL3lENWtWeCJ9
x-ctpclassification: CTP_NT
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogaW50ZWwtZ3Z0LWRldiBb
bWFpbHRvOmludGVsLWd2dC1kZXYtYm91bmNlc0BsaXN0cy5mcmVlZGVza3RvcC5vcmddIE9uDQo+
IEJlaGFsZiBPZiBrcmF4ZWxAcmVkaGF0LmNvbQ0KPiBTZW50OiBUaHVyc2RheSwgU2VwdGVtYmVy
IDUsIDIwMTkgMzo0OSBQTQ0KPiBUbzogWmhhbmcsIFRpbmEgPHRpbmEuemhhbmdAaW50ZWwuY29t
Pg0KPiBDYzoga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsgWXVhbiwgSGFuZw0KPiA8aGFuZy55dWFuQGludGVsLmNvbT47IGFsZXgud2lsbGlhbXNvbkBy
ZWRoYXQuY29tOyBMdiwgWmhpeXVhbg0KPiA8emhpeXVhbi5sdkBpbnRlbC5jb20+OyBpbnRlbC1n
dnQtZGV2QGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY1IDAv
Nl0gRGVsaXZlciB2R1BVIGRpc3BsYXkgcmVmcmVzaCBldmVudCB0byB1c2Vyc3BhY2UNCj4gDQo+
ICAgSGksDQo+IA0KPiA+IE9wdGlvbiAyOiBRRU1VIHByb3ZpZGVzIHRoZSBlbXVsYXRlZCBkaXNw
bGF5IHJlZnJlc2ggZXZlbnQgdG8gdGhlDQo+ID4gdmdwdXMgcHJvdmlkZWQgYnkgdmVuZG9yIGRy
aXZlci4gRm9yIHZncHVzLCB0aGUgZGlzcGxheSByZWZyZXNoIGV2ZW50DQo+ID4gY2FuIGJlIGNv
bnNpZGVyZWQgYXMgdGhlIHZibGFuayBldmVudCB3aGljaCBpcyBsZXZlcmFnZWQgYnkgZ3Vlc3QN
Cj4gPiB3aW5kb3cgbWFuYWdlciB0byBkbyB0aGUgcGxhbmUgdXBkYXRlIG9yIG1vZGUtc2V0dGlu
Zy4NCj4gDQo+ID4gUGVvcGxlIGFyZSBhc2tpbmcgaWYgb3B0aW9uIDIgY291bGQgYmUgYSBiZXR0
ZXIgY2hvaWNlLg0KPiANCj4gQ2VydGFpbmx5IHdvcnRoIHRyeWluZywgbWF5YmUgaXQgZXZlbiBt
YWtlcyBzZW5zZSB0byBpbXBsZW1lbnQgYm90aCBhbmQNCj4gbGV0IHFlbXUgcGljayBvbmUsIHBv
c3NpYmx5IGV2ZW4gc3dpdGNoIHRoZW0gYXQgcnVudGltZS4NCj4gDQo+IHFlbXUgY2FuIGNoYW5n
ZSB0aGUgcmVmcmVzaCByYXRlLiAgdm5jIGFuZCBzZGwgdXNlIHRoYXQgdG8gcmVkdWNlIHRoZQ0K
PiByZWZyZXNoIHJhdGUgaW4gY2FzZSBub2JvZHkgaXMgbG9va2luZyAobm8gdm5jIGNsaWVudCBj
b25uZWN0ZWQsIHNkbCB3aW5kb3cNCj4gbWluaW1pemVkKS4gIEl0IHN1cmVseSBtYWtlcyBzZW5z
ZSB0byBtYWtlIHRoYXQgdmlzaWJsZSB0byB0aGUgZ3Vlc3Qgc28gaXQgY2FuDQo+IHRocm90dGxl
IGRpc3BsYXkgdXBkYXRlcyB0b28uICBJJ20gbm90IHN1cmUgdmJsYW5rIGlzIHRoZSB3YXkgdG8g
Z28gdGhvdWdoLA0KPiBndWVzdHMgbWlnaHQgcnVuIGludG8gdmJsYW5rIGlycSB0aW1lb3V0cyBp
biBjYXNlIHRoZSByZWZyZXNoIHJhdGUgaXMgdmVyeQ0KPiBsb3cgLi4uDQoNCkluZGVlZCwgbG93
IHZibGFuayByYXRlIGlzbid0IGV4cGVjdGVkIGJ5IGd1ZXN0IGdmeCBkcml2ZXIuIEl0IGNvbXBs
YWlucyBhYm91dCB0aGUgdGltZW91dCBlcnJvciBhbGwgdGhlIHRpbWUsIHdoZW4gdGhlIHZibGFu
ayBpcyBsb3cuIA0KDQpDdXJyZW50bHksIGd2dC1nIHByb3ZpZGVzIGZ1bGwgdmlydHVhbGl6ZWQg
ZGlzcGxheSBtb2RlbCAoYS5rLmEuIG5vdCBwdikuIEFuZCB0aGUgb3B0aW9uIDIgaXMgbW9yZSBs
aWtlIGEgcHYgc29sdXRpb24gZm9yIHBlcmZvcm1hbmNlIG9wdGltaXphdGlvbiwgd2hpY2ggaXMg
b2YgY291cnNlIGEgdmVyeSBnb29kIHByb3Bvc2FsLiBTaW5jZSB0aGUgdHdvIG9wdGlvbnMgaGF2
ZSBubyBkZXBlbmRlbmN5LCB0aGlzIHBhdGNoLXNldCBsaW1pdHMgaXRzIHNjb3BlIHRvIG9ubHkg
aW5jbHVkZSBvcHRpb24gMS4gVGhhbmtzLg0KDQoNCkJSLA0KVGluYQ0KDQo+IA0KPiBjaGVlcnMs
DQo+ICAgR2VyZA0KPiANCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18NCj4gaW50ZWwtZ3Z0LWRldiBtYWlsaW5nIGxpc3QNCj4gaW50ZWwtZ3Z0LWRldkBs
aXN0cy5mcmVlZGVza3RvcC5vcmcNCj4gaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFp
bG1hbi9saXN0aW5mby9pbnRlbC1ndnQtZGV2DQo=

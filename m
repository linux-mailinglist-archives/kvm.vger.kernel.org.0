Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6880D2B330E
	for <lists+kvm@lfdr.de>; Sun, 15 Nov 2020 09:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgKOIxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 03:53:43 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:62370 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgKOIxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Nov 2020 03:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1605430388; x=1636966388;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=wJlE2B85yxSzYP5MYO/Vfi1f0tvx0dvp2w6jHv4XH4Y=;
  b=Wso1KW08kTdBEge+cnxSYPMP1Jco+FVVLCVYkbUy9eqccbSHGm4mxvQw
   GNSXk+s2HWWqhptPzrGh9fLQpeQcvaTpHbZXRuIeZ+WWuM0bwOP+YzG5R
   cNXNUNrYNye8o9Jcz0wpXgAbjscZsFnxAhV2QZrshcYNnd85uW4/rdy2/
   E=;
X-IronPort-AV: E=Sophos;i="5.77,480,1596499200"; 
   d="scan'208";a="65060743"
Subject: Re: [kvm:queue 40/54] arch/x86/kvm/../../../virt/kvm/eventfd.c:198:23:
 error: passing argument 1 of 'eventfd_ctx_do_read' from incompatible
 pointer type
Thread-Topic: [kvm:queue 40/54] arch/x86/kvm/../../../virt/kvm/eventfd.c:198:23: error:
 passing argument 1 of 'eventfd_ctx_do_read' from incompatible pointer type
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 15 Nov 2020 08:50:30 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id C996EA1F08;
        Sun, 15 Nov 2020 08:50:27 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 15 Nov 2020 08:50:27 +0000
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 15 Nov 2020 08:50:27 +0000
Received: from EX13D08UEE001.ant.amazon.com ([10.43.62.126]) by
 EX13D08UEE001.ant.amazon.com ([10.43.62.126]) with mapi id 15.00.1497.006;
 Sun, 15 Nov 2020 08:50:27 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "lkp@intel.com" <lkp@intel.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "farrah.chen@intel.com" <farrah.chen@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "robert.hu@intel.com" <robert.hu@intel.com>,
        "danmei.wei@intel.com" <danmei.wei@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Thread-Index: AQHWuw6NjOnXivX/UUSj/kY9CPDFHanI4pkA
Date:   Sun, 15 Nov 2020 08:50:27 +0000
Message-ID: <f90cf58df3aee209e08bc6293da3be79b7262696.camel@amazon.co.uk>
References: <202011151341.2stsjDsg-lkp@intel.com>
In-Reply-To: <202011151341.2stsjDsg-lkp@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.55]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F42F311D3C8BAC47A06BDA1BC9F7793E@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIwLTExLTE1IGF0IDEzOjE0ICswODAwLCBrZXJuZWwgdGVzdCByb2JvdCB3cm90
ZToNCj4gDQo+IEFsbCBlcnJvcnMgKG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+KToNCj4gDQo+ICAg
IGFyY2gveDg2L2t2bS8uLi8uLi8uLi92aXJ0L2t2bS9ldmVudGZkLmM6IEluIGZ1bmN0aW9uDQo+
ICdpcnFmZF93YWtldXAnOg0KPiA+PiBhcmNoL3g4Ni9rdm0vLi4vLi4vLi4vdmlydC9rdm0vZXZl
bnRmZC5jOjE5ODoyMzogZXJyb3I6IHBhc3NpbmcNCj4gYXJndW1lbnQgMSBvZiAnZXZlbnRmZF9j
dHhfZG9fcmVhZCcgZnJvbSBpbmNvbXBhdGlibGUgcG9pbnRlciB0eXBlIFstDQo+IFdlcnJvcj1p
bmNvbXBhdGlibGUtcG9pbnRlci10eXBlc10NCj4gICAgICAxOTggfCAgIGV2ZW50ZmRfY3R4X2Rv
X3JlYWQoJmlycWZkLT5ldmVudGZkLCAmY250KTsNCj4gICAgICAgICAgfCAgICAgICAgICAgICAg
ICAgICAgICAgXn5+fn5+fn5+fn5+fn5+DQo+ICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAg
ICAgIHwNCj4gICAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGV2ZW50ZmRf
Y3R4ICoqDQoNCkhtLCB0aGF0IGFtcGVyc2FuZCBpc24ndCBzdXBwb3NlZCB0byBiZSB0aGVyZTsg
aXQgYXJyaXZlZCB3aGVuIEkgbW92ZWQNCnRoZSAnZHJhaW4gZXZlbnRzJyBwYXJ0IG9mIHRoZSBz
ZXJpZXMgYWZ0ZXIgdGhlIGV4Y2x1c2l2aXR5Lg0KDQpUaGVyZSB3YXMgYSBuZXcgdmVyc2lvbiBv
ZiB0aGUgcGF0Y2gsIGFuZCBJIHRob3VnaHQgd2UnZCBkaXNjdXNzZWQgb24NCklSQyB0aGF0IGl0
IHdhc24ndCB3b3J0aCByZXNlbmRpbmcgaW4gZW1haWwgYW5kIHlvdSdkIGZpeCBpdCB1cCBvbg0K
YXBwbHlpbmc/DQoNClNpbmNlIHRoaXMgaXMgc3RpbGwgb25seSBpbiB0aGUgcXVldWUgYW5kIG5v
dCB5ZXQgaW4gYSBwZXJtYW5lbnQgYnJhbmNoDQp5b3UgY2FuIHN0aWxsIGZpeCBpdCB1cCwgcmln
aHQ/DQoNCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9ldmVudGZkLmMgYi92aXJ0L2t2bS9ldmVudGZk
LmMNCmluZGV4IDE0N2FkYzg2MmI5NS4uZTk5Njk4OWNkNTgwIDEwMDY0NA0KLS0tIGEvdmlydC9r
dm0vZXZlbnRmZC5jDQorKysgYi92aXJ0L2t2bS9ldmVudGZkLmMNCkBAIC0xOTUsNyArMTk1LDcg
QEAgaXJxZmRfd2FrZXVwKHdhaXRfcXVldWVfZW50cnlfdCAqd2FpdCwgdW5zaWduZWQgbW9kZSwg
aW50IHN5bmMsIHZvaWQgKmtleSkNCiANCiAJaWYgKGZsYWdzICYgRVBPTExJTikgew0KIAkJdTY0
IGNudDsNCi0JCWV2ZW50ZmRfY3R4X2RvX3JlYWQoJmlycWZkLT5ldmVudGZkLCAmY250KTsNCisJ
CWV2ZW50ZmRfY3R4X2RvX3JlYWQoaXJxZmQtPmV2ZW50ZmQsICZjbnQpOw0KIA0KIAkJaWR4ID0g
c3JjdV9yZWFkX2xvY2soJmt2bS0+aXJxX3NyY3UpOw0KIAkJZG8gew0KCgoKQW1hem9uIERldmVs
b3BtZW50IENlbnRyZSAoTG9uZG9uKSBMdGQuIFJlZ2lzdGVyZWQgaW4gRW5nbGFuZCBhbmQgV2Fs
ZXMgd2l0aCByZWdpc3RyYXRpb24gbnVtYmVyIDA0NTQzMjMyIHdpdGggaXRzIHJlZ2lzdGVyZWQg
b2ZmaWNlIGF0IDEgUHJpbmNpcGFsIFBsYWNlLCBXb3JzaGlwIFN0cmVldCwgTG9uZG9uIEVDMkEg
MkZBLCBVbml0ZWQgS2luZ2RvbS4KCgo=


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E419165F4E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgBTN4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:56:37 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:34883 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgBTN4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:56:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1582206996; x=1613742996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6qRdb2tHAjpNw5HxV4uP0hoa7Zzgw6Kqa078Vn8d190=;
  b=i21ChyGeUIIfLTy76yfgNa9jdwrzx3cPRQGuVw7Mc4L9Vei6O1gO6Xvs
   5wnO4Ucq2ZKLdNAtslPP/eGcSs0EfNHJGJVB5yo37FCT8DbPDb9H6UtZC
   OP3ilC1cBmnbb6MNLAfeX2H1DVH+WTdVeKOVMCR+ErwExtvgisvwjPwV4
   s=;
IronPort-SDR: wo2CTn8HSGq9XguOwKHujm9WgWfPn/NXmA5jPzTfTb+B/pt4Sdg7JXx/m7QeCdVyHX4aytsS43
 SUTF86rdYH9g==
X-IronPort-AV: E=Sophos;i="5.70,464,1574121600"; 
   d="scan'208";a="17947101"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 Feb 2020 13:56:31 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 13F73A1ECB;
        Thu, 20 Feb 2020 13:56:20 +0000 (UTC)
Received: from EX13D32EUC004.ant.amazon.com (10.43.164.121) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Thu, 20 Feb 2020 13:56:19 +0000
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D32EUC004.ant.amazon.com (10.43.164.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 20 Feb 2020 13:56:18 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1367.000;
 Thu, 20 Feb 2020 13:56:18 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>,
        "Peter Maydell" <peter.maydell@linaro.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     Fam Zheng <fam@euphon.net>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Stefano Stabellini" <sstabellini@kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?utf-8?B?SGVydsOpIFBvdXNzaW5lYXU=?= <hpoussin@reactos.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "Aleksandar Rikalo" <aleksandar.rikalo@rt-rk.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Stefan Weil <sw@weilnetz.de>,
        "Alistair Francis" <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Eric Auger <eric.auger@redhat.com>,
        "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@kaod.org>,
        John Snow <jsnow@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Igor Mitsyanko" <i.mitsyanko@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael Walle" <michael@walle.cc>,
        "qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: RE: [Xen-devel] [PATCH v3 03/20] exec: Let qemu_ram_*() functions
 take a const pointer argument
Thread-Topic: [Xen-devel] [PATCH v3 03/20] exec: Let qemu_ram_*() functions
 take a const pointer argument
Thread-Index: AQHV5+62bDvzVj67r0Cu6rYKUNoaGagkGwNQ
Date:   Thu, 20 Feb 2020 13:56:18 +0000
Message-ID: <a7c2db54d9b04909a5c733ebe5cc5bd9@EX13D32EUC003.ant.amazon.com>
References: <20200220130548.29974-1-philmd@redhat.com>
 <20200220130548.29974-4-philmd@redhat.com>
In-Reply-To: <20200220130548.29974-4-philmd@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.112]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBYZW4tZGV2ZWwgPHhlbi1kZXZl
bC1ib3VuY2VzQGxpc3RzLnhlbnByb2plY3Qub3JnPiBPbiBCZWhhbGYgT2YNCj4gUGhpbGlwcGUg
TWF0aGlldS1EYXVkw6kNCj4gU2VudDogMjAgRmVicnVhcnkgMjAyMCAxMzowNg0KPiBUbzogUGV0
ZXIgTWF5ZGVsbCA8cGV0ZXIubWF5ZGVsbEBsaW5hcm8ub3JnPjsgcWVtdS1kZXZlbEBub25nbnUu
b3JnDQo+IENjOiBGYW0gWmhlbmcgPGZhbUBldXBob24ubmV0PjsgRG1pdHJ5IEZsZXl0bWFuDQo+
IDxkbWl0cnkuZmxleXRtYW5AZ21haWwuY29tPjsga3ZtQHZnZXIua2VybmVsLm9yZzsgTWljaGFl
bCBTLiBUc2lya2luDQo+IDxtc3RAcmVkaGF0LmNvbT47IEphc29uIFdhbmcgPGphc293YW5nQHJl
ZGhhdC5jb20+OyBHZXJkIEhvZmZtYW5uDQo+IDxrcmF4ZWxAcmVkaGF0LmNvbT47IEVkZ2FyIEUu
IElnbGVzaWFzIDxlZGdhci5pZ2xlc2lhc0BnbWFpbC5jb20+OyBTdGVmYW5vDQo+IFN0YWJlbGxp
bmkgPHNzdGFiZWxsaW5pQGtlcm5lbC5vcmc+OyBNYXR0aGV3IFJvc2F0bw0KPiA8bWpyb3NhdG9A
bGludXguaWJtLmNvbT47IHFlbXUtYmxvY2tAbm9uZ251Lm9yZzsgRGF2aWQgSGlsZGVuYnJhbmQN
Cj4gPGRhdmlkQHJlZGhhdC5jb20+OyBIYWxpbCBQYXNpYyA8cGFzaWNAbGludXguaWJtLmNvbT47
IENocmlzdGlhbg0KPiBCb3JudHJhZWdlciA8Ym9ybnRyYWVnZXJAZGUuaWJtLmNvbT47IEhlcnbD
qSBQb3Vzc2luZWF1DQo+IDxocG91c3NpbkByZWFjdG9zLm9yZz47IE1hcmNlbCBBcGZlbGJhdW0g
PG1hcmNlbC5hcGZlbGJhdW1AZ21haWwuY29tPjsNCj4gQW50aG9ueSBQZXJhcmQgPGFudGhvbnku
cGVyYXJkQGNpdHJpeC5jb20+OyB4ZW4tDQo+IGRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnOyBB
bGVrc2FuZGFyIFJpa2FsbyA8YWxla3NhbmRhci5yaWthbG9AcnQtDQo+IHJrLmNvbT47IFJpY2hh
cmQgSGVuZGVyc29uIDxydGhAdHdpZGRsZS5uZXQ+OyBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqQ0K
PiA8cGhpbG1kQHJlZGhhdC5jb20+OyBMYXVyZW50IFZpdmllciA8bHZpdmllckByZWRoYXQuY29t
PjsgVGhvbWFzIEh1dGgNCj4gPHRodXRoQHJlZGhhdC5jb20+OyBFZHVhcmRvIEhhYmtvc3QgPGVo
YWJrb3N0QHJlZGhhdC5jb20+OyBTdGVmYW4gV2VpbA0KPiA8c3dAd2VpbG5ldHouZGU+OyBBbGlz
dGFpciBGcmFuY2lzIDxhbGlzdGFpckBhbGlzdGFpcjIzLm1lPjsgUmljaGFyZA0KPiBIZW5kZXJz
b24gPHJpY2hhcmQuaGVuZGVyc29uQGxpbmFyby5vcmc+OyBQYXVsIER1cnJhbnQgPHBhdWxAeGVu
Lm9yZz47DQo+IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT47IHFlbXUtczM5MHhA
bm9uZ251Lm9yZzsgcWVtdS0NCj4gYXJtQG5vbmdudS5vcmc7IEPDqWRyaWMgTGUgR29hdGVyIDxj
bGdAa2FvZC5vcmc+OyBKb2huIFNub3cNCj4gPGpzbm93QHJlZGhhdC5jb20+OyBEYXZpZCBHaWJz
b24gPGRhdmlkQGdpYnNvbi5kcm9wYmVhci5pZC5hdT47IElnb3INCj4gTWl0c3lhbmtvIDxpLm1p
dHN5YW5rb0BnbWFpbC5jb20+OyBDb3JuZWxpYSBIdWNrIDxjb2h1Y2tAcmVkaGF0LmNvbT47DQo+
IE1pY2hhZWwgV2FsbGUgPG1pY2hhZWxAd2FsbGUuY2M+OyBxZW11LXBwY0Bub25nbnUub3JnOyBQ
YW9sbyBCb256aW5pDQo+IDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTdWJqZWN0OiBbWGVuLWRl
dmVsXSBbUEFUQ0ggdjMgMDMvMjBdIGV4ZWM6IExldCBxZW11X3JhbV8qKCkgZnVuY3Rpb25zDQo+
IHRha2UgYSBjb25zdCBwb2ludGVyIGFyZ3VtZW50DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQaGls
aXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQHJlZGhhdC5jb20+DQoNClJldmlld2VkLWJ5OiBQ
YXVsIER1cnJhbnQgPHBhdWxAeGVuLm9yZz4NCg==

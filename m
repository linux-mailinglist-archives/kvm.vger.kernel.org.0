Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A90C34648E
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhCWQLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:11:16 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:1881 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbhCWQKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1616515850; x=1648051850;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=GXkTj4pGq3nW0nYO9duitGCSspcTFWw3vJ2TTU/l3CI=;
  b=UEMH1xci+jJhYOr3rnJdJYIwvI9N61YOflNpYo55jmYv+xujpWSAIT0F
   pyYmFhlHl/y+W/Pjz4D/hgEfF0a3MDtwSCWtnkLQQyHZqzLtvyg/Yr+yB
   Qk+JegizQoWTzZ0dATZM7tJQwDOtMVWq1QUofrWHl1VZjeJ/bcNYsu71/
   s=;
X-IronPort-AV: E=Sophos;i="5.81,272,1610409600"; 
   d="scan'208";a="95621463"
Subject: Re: [PATCH v8] drivers/misc: sysgenid: add system generation id driver
Thread-Topic: [PATCH v8] drivers/misc: sysgenid: add system generation id driver
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Mar 2021 16:10:43 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id D1A08A2217;
        Tue, 23 Mar 2021 16:10:30 +0000 (UTC)
Received: from EX13D20UWA004.ant.amazon.com (10.43.160.62) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 23 Mar 2021 16:10:30 +0000
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13D20UWA004.ant.amazon.com (10.43.160.62) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 23 Mar 2021 16:10:29 +0000
Received: from EX13D08EUB004.ant.amazon.com ([10.43.166.158]) by
 EX13D08EUB004.ant.amazon.com ([10.43.166.158]) with mapi id 15.00.1497.012;
 Tue, 23 Mar 2021 16:10:28 +0000
From:   "Catangiu, Adrian Costin" <acatan@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "areber@redhat.com" <areber@redhat.com>,
        "ovzxemul@gmail.com" <ovzxemul@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>
Thread-Index: AQHXFDSs8xrEX8MfBEC6uKT7aIuSv6qRn1uAgABX0gA=
Date:   Tue, 23 Mar 2021 16:10:27 +0000
Message-ID: <E6E517FF-A37C-427C-B16F-066A965B8F42@amazon.com>
References: <1615213083-29869-1-git-send-email-acatan@amazon.com>
 <YEY2b1QU5RxozL0r@kroah.com>
 <a61c976f-b362-bb60-50a5-04073360e702@amazon.com>
 <YFnlZQZOasOwxUDn@kroah.com>
In-Reply-To: <YFnlZQZOasOwxUDn@kroah.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.52]
Content-Type: text/plain; charset="utf-8"
Content-ID: <885DAA1B17363842AE11B1CE7A23F8B4@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgR3JlZywNCg0KQWZ0ZXIgeW91ciBwcmV2aW91cyByZXBseSBvbiB0aGlzIHRocmVhZCB3ZSBz
dGFydGVkIGNvbnNpZGVyaW5nIHRvIHByb3ZpZGUgdGhpcyBpbnRlcmZhY2UgYW5kIGZyYW1ld29y
ay9mdW5jdGlvbmFsaXR5IHRocm91Z2ggYSB1c2Vyc3BhY2Ugc2VydmljZSBpbnN0ZWFkIG9mIGEg
a2VybmVsIGludGVyZmFjZS4NClRoZSBsYXRlc3QgaXRlcmF0aW9uIG9uIHRoaXMgZXZvbHZpbmcg
cGF0Y2gtc2V0IGRvZXNu4oCZdCBoYXZlIHN0cm9uZyByZWFzb25zIGZvciBsaXZpbmcgaW4gdGhl
IGtlcm5lbCBhbnltb3JlIC0gdGhlIG9ubHkgb2JqZWN0aXZlbHkgc3Ryb25nIGFkdmFudGFnZSB3
b3VsZCBiZSBlYXNpZXIgZHJpdmluZyBvZiBlY29zeXN0ZW0gaW50ZWdyYXRpb247IGJ1dCBJIGFt
IG5vdCBzdXJlIHRoYXQncyBhIGdvb2QgZW5vdWdoIHJlYXNvbiB0byBjcmVhdGUgYSBuZXcga2Vy
bmVsIGludGVyZmFjZS4NCg0KSSBhbSBub3cgbG9va2luZyBpbnRvIGFkZGluZyB0aGlzIHRocm91
Z2ggU3lzdGVtZC4gRWl0aGVyIGFzIGEgcGx1Z2dhYmxlIHNlcnZpY2Ugb3IgbWF5YmUgZXZlbiBh
IHN5c3RlbWQgYnVpbHRpbiBvZmZlcmluZy4NCg0KV2hhdCBhcmUgeW91ciB0aG91Z2h0cyBvbiBp
dD8NCg0KVGhhbmtzLA0KQWRyaWFuLg0KDQrvu79PbiAyMy8wMy8yMDIxLCAxNDo1NywgIkdyZWcg
S0giIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQoNCiAgICBDQVVUSU9OOiBU
aGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERv
IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZp
cm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KICAgIE9u
IE1vbiwgTWFyIDA4LCAyMDIxIGF0IDA1OjAzOjU4UE0gKzAxMDAsIEFsZXhhbmRlciBHcmFmIHdy
b3RlOg0KICAgID4NCiAgICA+DQogICAgPiBPbiAwOC4wMy4yMSAxNTozNiwgR3JlZyBLSCB3cm90
ZToNCiAgICA+ID4NCiAgICA+ID4gT24gTW9uLCBNYXIgMDgsIDIwMjEgYXQgMDQ6MTg6MDNQTSAr
MDIwMCwgQWRyaWFuIENhdGFuZ2l1IHdyb3RlOg0KICAgID4gPiA+ICtzdGF0aWMgc3RydWN0IG1p
c2NkZXZpY2Ugc3lzZ2VuaWRfbWlzYyA9IHsNCiAgICA+ID4gPiArICAgICAubWlub3IgPSBNSVND
X0RZTkFNSUNfTUlOT1IsDQogICAgPiA+ID4gKyAgICAgLm5hbWUgPSAic3lzZ2VuaWQiLA0KICAg
ID4gPiA+ICsgICAgIC5mb3BzID0gJmZvcHMsDQogICAgPiA+ID4gK307DQogICAgPiA+DQogICAg
PiA+IE11Y2ggY2xlYW5lciwgYnV0Og0KICAgID4gPg0KICAgID4gPiA+ICtzdGF0aWMgaW50IF9f
aW5pdCBzeXNnZW5pZF9pbml0KHZvaWQpDQogICAgPiA+ID4gK3sNCiAgICA+ID4gPiArICAgICBp
bnQgcmV0Ow0KICAgID4gPiA+ICsNCiAgICA+ID4gPiArICAgICBzeXNnZW5pZF9kYXRhLm1hcF9i
dWYgPSBnZXRfemVyb2VkX3BhZ2UoR0ZQX0tFUk5FTCk7DQogICAgPiA+ID4gKyAgICAgaWYgKCFz
eXNnZW5pZF9kYXRhLm1hcF9idWYpDQogICAgPiA+ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVO
T01FTTsNCiAgICA+ID4gPiArDQogICAgPiA+ID4gKyAgICAgYXRvbWljX3NldCgmc3lzZ2VuaWRf
ZGF0YS5nZW5lcmF0aW9uX2NvdW50ZXIsIDApOw0KICAgID4gPiA+ICsgICAgIGF0b21pY19zZXQo
JnN5c2dlbmlkX2RhdGEub3V0ZGF0ZWRfd2F0Y2hlcnMsIDApOw0KICAgID4gPiA+ICsgICAgIGlu
aXRfd2FpdHF1ZXVlX2hlYWQoJnN5c2dlbmlkX2RhdGEucmVhZF93YWl0cSk7DQogICAgPiA+ID4g
KyAgICAgaW5pdF93YWl0cXVldWVfaGVhZCgmc3lzZ2VuaWRfZGF0YS5vdXRkYXRlZF93YWl0cSk7
DQogICAgPiA+ID4gKyAgICAgc3Bpbl9sb2NrX2luaXQoJnN5c2dlbmlkX2RhdGEubG9jayk7DQog
ICAgPiA+ID4gKw0KICAgID4gPiA+ICsgICAgIHJldCA9IG1pc2NfcmVnaXN0ZXIoJnN5c2dlbmlk
X21pc2MpOw0KICAgID4gPiA+ICsgICAgIGlmIChyZXQgPCAwKSB7DQogICAgPiA+ID4gKyAgICAg
ICAgICAgICBwcl9lcnIoIm1pc2NfcmVnaXN0ZXIoKSBmYWlsZWQgZm9yIHN5c2dlbmlkXG4iKTsN
CiAgICA+ID4gPiArICAgICAgICAgICAgIGdvdG8gZXJyOw0KICAgID4gPiA+ICsgICAgIH0NCiAg
ICA+ID4gPiArDQogICAgPiA+ID4gKyAgICAgcmV0dXJuIDA7DQogICAgPiA+ID4gKw0KICAgID4g
PiA+ICtlcnI6DQogICAgPiA+ID4gKyAgICAgZnJlZV9wYWdlcyhzeXNnZW5pZF9kYXRhLm1hcF9i
dWYsIDApOw0KICAgID4gPiA+ICsgICAgIHN5c2dlbmlkX2RhdGEubWFwX2J1ZiA9IDA7DQogICAg
PiA+ID4gKw0KICAgID4gPiA+ICsgICAgIHJldHVybiByZXQ7DQogICAgPiA+ID4gK30NCiAgICA+
ID4gPiArDQogICAgPiA+ID4gK3N0YXRpYyB2b2lkIF9fZXhpdCBzeXNnZW5pZF9leGl0KHZvaWQp
DQogICAgPiA+ID4gK3sNCiAgICA+ID4gPiArICAgICBtaXNjX2RlcmVnaXN0ZXIoJnN5c2dlbmlk
X21pc2MpOw0KICAgID4gPiA+ICsgICAgIGZyZWVfcGFnZXMoc3lzZ2VuaWRfZGF0YS5tYXBfYnVm
LCAwKTsNCiAgICA+ID4gPiArICAgICBzeXNnZW5pZF9kYXRhLm1hcF9idWYgPSAwOw0KICAgID4g
PiA+ICt9DQogICAgPiA+ID4gKw0KICAgID4gPiA+ICttb2R1bGVfaW5pdChzeXNnZW5pZF9pbml0
KTsNCiAgICA+ID4gPiArbW9kdWxlX2V4aXQoc3lzZ2VuaWRfZXhpdCk7DQogICAgPiA+DQogICAg
PiA+IFNvIHlvdSBkbyB0aGlzIGZvciBhbnkgYml0IG9mIGhhcmR3YXJlIHRoYXQgaGFwcGVucyB0
byBiZSBvdXQgdGhlcmU/DQogICAgPiA+IFdpbGwgdGhhdCByZWFsbHkgd29yaz8gIFlvdSBkbyBu
b3QgaGF2ZSBhbnkgaHdpZCB0byB0cmlnZ2VyIG9mZiBvZiB0bw0KICAgID4gPiBrbm93IHRoYXQg
dGhpcyBpcyBhIHZhbGlkIGRldmljZSB5b3UgY2FuIGhhbmRsZT8NCiAgICA+DQogICAgPiBUaGUg
aW50ZXJmYWNlIGlzIGFscmVhZHkgdXNlZnVsIGluIGEgcHVyZSBjb250YWluZXIgY29udGV4dCB3
aGVyZSB0aGUNCiAgICA+IGdlbmVyYXRpb24gY2hhbmdlIHJlcXVlc3QgaXMgdHJpZ2dlcmVkIGJ5
IHNvZnR3YXJlLg0KICAgID4NCiAgICA+IEFuZCB5ZXMsIHRoZXJlIGFyZSBoYXJkd2FyZSB0cmln
Z2VycywgYnV0IE1pY2hhZWwgd2FzIHF1aXRlIHVuaGFwcHkgYWJvdXQNCiAgICA+IHBvdGVudGlh
bCByYWNlcyBiZXR3ZWVuIFZNR2VuSUQgY2hhbmdlIGFuZCBTeXNHZW5JRCBjaGFuZ2UgYW5kIHRo
dXMgd2FudGVkDQogICAgPiB0byBpZGVhbGx5IHNlcGFyYXRlIHRoZSBpbnRlcmZhY2VzLiBTbyB3
ZSB3ZW50IGFoZWFkIGFuZCBpc29sYXRlZCB0aGUNCiAgICA+IFN5c0dlbklEIG9uZSwgYXMgaXQn
cyBhbHJlYWR5IHVzZWZ1bCBhcyBpcy4NCiAgICA+DQogICAgPiBIYXJkd2FyZSBkcml2ZXJzIHRv
IGluamVjdCBjaGFuZ2UgZXZlbnRzIGludG8gU3lzR2VuSUQgY2FuIHRoZW4gZm9sbG93DQogICAg
PiBsYXRlciwgZm9yIGFsbCBkaWZmZXJlbnQgaGFyZHdhcmUgcGxhdGZvcm1zLiBCdXQgU3lzR2Vu
SUQgYXMgaW4gdGhpcyBwYXRjaA0KICAgID4gaXMgYSBjb21wbGV0ZWx5IGhhcmR3YXJlIGFnbm9z
dGljIGNvbmNlcHQuDQoNCiAgICBPaywgdGhpcyBpcyBnb2luZyB0byBwbGF5IGhhdm9jIHdpdGgg
ZnV6emVycyBhbmQgb3RoZXIgImF1dG9tYXRlZA0KICAgIHRlc3RlcnMiLCBzaG91bGQgYmUgZnVu
IHRvIHdhdGNoISAgOikNCg0KICAgIExldCdzIHF1ZXVlIHRoaXMgdXAgYW5kIHNlZSB3aGF0IGhh
cHBlbnMuLi4NCg0KICAgIHRoYW5rcywNCg0KICAgIGdyZWcgay1oDQoNCgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNm
LiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUs
IFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIv
MjYyMS8yMDA1Lgo=


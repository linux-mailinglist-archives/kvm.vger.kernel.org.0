Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27041324748
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 00:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhBXXBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 18:01:43 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:60220 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhBXXBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 18:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614207700; x=1645743700;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=hVGYeWL8BzQFMK+Thejfp/GrKUl+IMBQ9zDAz5P0VSo=;
  b=PZyg9S/f1R+PSsKCnZ6HsI0nXRdbxbdTpxYQf7E3D8xlUo5R5wOfsSy9
   PvunFoNuu0mIQUXXFiUdaaiedmsBSF4DpBVeXqeuA+pn795U5NF0uDlS7
   Pjduxk9GalfqCUguEK+NE29fSxW2hxeKj+5Bh1PQekNG0OYxfvAI2OrqD
   I=;
X-IronPort-AV: E=Sophos;i="5.81,203,1610409600"; 
   d="scan'208";a="87841545"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 24 Feb 2021 23:00:58 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id E0FA6A1F1B;
        Wed, 24 Feb 2021 23:00:47 +0000 (UTC)
Received: from EX13D20UWA004.ant.amazon.com (10.43.160.62) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 23:00:47 +0000
Received: from EX13D01UWA003.ant.amazon.com (10.43.160.107) by
 EX13D20UWA004.ant.amazon.com (10.43.160.62) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 23:00:46 +0000
Received: from EX13D01UWA003.ant.amazon.com ([10.43.160.107]) by
 EX13d01UWA003.ant.amazon.com ([10.43.160.107]) with mapi id 15.00.1497.010;
 Wed, 24 Feb 2021 23:00:46 +0000
From:   "MacCarthaigh, Colm" <colmmacc@amazon.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>
CC:     "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
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
Subject: Re: [PATCH v7 1/2] drivers/misc: sysgenid: add system generation id
 driver
Thread-Topic: [PATCH v7 1/2] drivers/misc: sysgenid: add system generation id
 driver
Thread-Index: AQHXCwDjfClcwtiNEEGBvSi4FTnt7w==
Date:   Wed, 24 Feb 2021 23:00:46 +0000
Message-ID: <7DE31E14-D6E9-41EA-9A43-6608ACC7CD87@amazon.com>
Accept-Language: en-IE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.44.20121301
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.244]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1A111C137DBAA4BB71F7D8D56D5B152@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDIvMjQvMjEsIDI6NDQgUE0sICJNaWNoYWVsIFMuIFRzaXJraW4iIDxtc3RAcmVkaGF0
LmNvbT4gd3JvdGU6DQogICAgPiBUaGUgbW1hcCBtZWNoYW5pc20gYWxsb3dzIHRoZSBQUk5HIHRv
IHJlc2VlZCBhZnRlciBhIGdlbmlkIGNoYW5nZS4gQmVjYXVzZQ0KICAgID4gd2UgZG9uJ3QgaGF2
ZSBhbiBldmVudCBtZWNoYW5pc20gZm9yIHRoaXMgY29kZSBwYXRoLCB0aGF0IGNhbiBoYXBwZW4g
bWludXRlcw0KICAgID4gYWZ0ZXIgdGhlIHJlc3VtZS4gQnV0IHRoYXQncyBvaywgd2UgImp1c3Qi
IGhhdmUgdG8gZW5zdXJlIHRoYXQgbm9ib2R5IGlzDQogICAgPiBjb25zdW1pbmcgc2VjcmV0IGRh
dGEgYXQgdGhlIHBvaW50IG9mIHRoZSBzbmFwc2hvdC4NCg0KDQogICAgU29tZXRoaW5nIEkgYW0g
c3RpbGwgbm90IGNsZWFyIG9uIGlzIHdoZXRoZXIgaXQncyByZWFsbHkgaW1wb3J0YW50IHRvDQog
ICAgc2tpcCB0aGUgc3lzdGVtIGNhbGwgaGVyZS4gSWYgbm90IEkgdGhpbmsgaXQncyBwcnVkZW50
IHRvIGp1c3Qgc3RpY2sNCiAgICB0byByZWFkIGZvciBub3csIEkgdGhpbmsgdGhlcmUncyBhIHNs
aWdodGx5IGxvd2VyIGNoYW5jZSB0aGF0DQogICAgaXQgd2lsbCBnZXQgbWlzdXNlZC4gbW1hcCB3
aGljaCBnaXZlcyB5b3UgYSBsYWdneSBnZW4gaWQgdmFsdWUNCiAgICByZWFsbHkgc2VlbXMgbGlr
ZSBpdCB3b3VsZCBiZSBoYXJkIHRvIHVzZSBjb3JyZWN0bHkuDQoNCkl0J3Mgbm90IHVuY29tbW9u
IGZvciB0aGVzZSB1c2VyLXNwYWNlIFBSTkdzIHRvIHVzZWQgcXVpdGUgYSBsb3QgaW4gdmVyeSBw
ZXJmb3JtYW5jZSBjcml0aWNhbCBwYXRocy4gSWYgeW91IG5lZ290aWF0ZSBhIFRMUyBzZXNzaW9u
IHRoYXQgdXNlcyBhbiBleHBsaWNpdCBJViwgdGhlIFJORyBpcyBiZWluZyBjYWxsZWQgZm9yIGV2
ZXJ5IFRMUyByZWNvcmQgc2VudC4gU2FtZSBmb3IgSVBTZWMgZGVwZW5kaW5nIG9uIHRoZSBjaXBo
ZXItc3VpdGUuIEV2ZXJ5IFRMUyBoZWxsbyBtZXNzYWdlIGhhcyAyOC0zMiBieXRlcyBvZiBkYXRh
IGZyb20gdGhlIFJORywgb3IgaWYgeW91J3ZlIGdvdCBFQ0RTQSBhcyB5b3VyIHNpZ25hdHVyZSBh
bGdvcml0aG0sIGl0J3MgaW5saW5lIGFnYWluLiBVc2luZyBSU0FfUFNTPyBTYW1lIGFnYWluLiBN
YW55IFBvc3QtUXVhbnR1bSBhbGdvcml0aG1zIGFyZSBldmVuIG1vcmUgdmVyYWNpb3VzbHkgZW50
cm9weSBodW5ncnkuICBXZSBleGFtaW5lIHRoZSBjb21waWxlZCBpbnN0cnVjdGlvbnMgZm9yIG91
cnMgYnkgaGFuZCB0byBjaGVjayBpdCdzIGFsbCBhcyB0aWdodCBhcyBpdCBjYW4gYmUuIA0KDQpU
byBnaXZlIG1vcmUgb2YgYW4gaWRlYSwgc2V2ZXJhbCBjcnlwdG8gbGlicmFyaWVzIHRvb2sgb3V0
IHRoZSBnZXRwaWQoKSBndWFyZHMgdGhleSBoYWQgZm9yIGZvcmsgZGV0ZWN0aW9uIGluIHRoZSBS
TkdzLCB0aG91Z2ggVkRTTyBjb3VsZCBoYXZlIGhlbHBlZCB0aGVyZSBhbmQgSSdtIG5vdCBzdXJl
IHRoZXkgd291bGQgaGF2ZSBuZWVkZWQgdG8gaWYgVkRTTyB3ZXJlIG1vcmUgd2lkZWx5IHVzZWQg
YXQgdGhlIHRpbWUuICBJIGRvbid0IHRoaW5rIHdlJ2QgZ2V0IGEgcGF0Y2ggaW50byBPcGVuU1NM
L2xpYmNyeXB0byB0aGF0IGludm9sdmVzIGEgZnVsbCBzeXNjYWxsLiBWRFNPIG1pZ2h0IGJlIG9r
LCBidXQgZXZlbiB0aGF0J3Mgbm90IGdvaW5nIHRvIGhhdmUgdGhlIHNwZWVkIHRoYXQgYSBzaW5n
bGUgbWVtb3J5IGxvb2t1cCBjYW4gZG8gd2l0aCB0aGUgbW1hcC9tYWR2aXNlIGFwcHJvYWNoIC4u
LiBzaW5jZSB3ZSBhbHJlYWR5IGhhdmUgdG8gdXNlIFdJUEVPTkZPUksuDQoNCkluIHByYWN0aWNl
IEkgZG9uJ3QgdGhpbmsgaXQgd2lsbCBiZSB0aGF0IGhhcmQgdG8gdXNlIGNvcnJlY3RseTsgc25h
cHNob3RzIGFuZCByZXN0b3JlcyBvZiB0aGlzIG5hdHVyZSByZWFsbHkgaGF2ZSB0byBoYXBwZW4g
b25seSB3aGVuIHRoZSBhY3Rpdml0eSBpcyBxdWllc2NlbnQuIElmIG9wZXJhdGlvbnMgYXJlIGlu
LWZsaWdodCwgaXQncyBub3QgZWFzeSB0byByZWFzb24gYWJvdXQgdGhlIHBvdGVudGlhbCBtdWx0
aS1yZXN0b3JlIHByb2JsZW1zIGF0IGFsbCBhbmQgaXQgb25seSBtYWtlcyBzZW5zZSB0byB0aGlu
ayBhYm91dCB0cmFuc2FjdGlvbmFsIGNvcnJlY3RuZXNzIGF0IHRoZSBsZXZlbCBvZiBhbGwgdHJh
bnNhY3Rpb25zIHRoYXQgbWF5IGhhdmUgYmVlbiBpbi1mbGlnaHQuIFRoZSBtbWFwIHNvbHV0aW9u
IGlzIG1vcmUgYWJvdXQgaW50ZWdyYXRpbmcgd2l0aCBleGlzdGluZyBsaWJyYXJ5IEFQSXMgYW5k
IHNlbWFudGljcyB0aGFuIGl0IGlzIGFib3V0IHNvbWVob3cgc29sdmluZyB0aGF0IGF0IHRoZSBr
ZXJuZWwgbGV2ZWwuIFRoYXQgcGFydCBoYXMgdG8gYmUgc29sdmVkIGF0IHRoZSBzeXN0ZW0gbGV2
ZWwuDQoNCi0gDQpDb2xtDQoNCg==

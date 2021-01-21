Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849542FE79C
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 11:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbhAUK3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 05:29:24 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:22982 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbhAUK3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 05:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1611224950; x=1642760950;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=hqeYFR4tFeQmudUNvthDELGWhM89CIKBNi0DsWXyEWk=;
  b=Q8S906t5OTVl40iIFi9oZUD+dhbUYO19vJlPhAsqVH9cXHxBg62CTm4c
   DKdFJXa2tP4oNBgAm8A3ECW1gpn900G1uDtRX9TWBuGW4nO43Gd89EAxT
   W9adoQWCCqGc0chH9F7hfPosRmHqcu7QCCIL6mgvNp5KnWJBK8bzzJ+KZ
   8=;
X-IronPort-AV: E=Sophos;i="5.79,363,1602547200"; 
   d="scan'208";a="112527416"
Subject: Re: [PATCH v4 0/2] System Generation ID driver and VMGENID backend
Thread-Topic: [PATCH v4 0/2] System Generation ID driver and VMGENID backend
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Jan 2021 10:28:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id A95A7A1766;
        Thu, 21 Jan 2021 10:28:18 +0000 (UTC)
Received: from EX13D01UWB003.ant.amazon.com (10.43.161.94) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 Jan 2021 10:28:18 +0000
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13d01UWB003.ant.amazon.com (10.43.161.94) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 Jan 2021 10:28:16 +0000
Received: from EX13D08EUB004.ant.amazon.com ([10.43.166.158]) by
 EX13D08EUB004.ant.amazon.com ([10.43.166.158]) with mapi id 15.00.1497.010;
 Thu, 21 Jan 2021 10:28:16 +0000
From:   "Catangiu, Adrian Costin" <acatan@amazon.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
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
Thread-Index: AQHW6NzBCUlWHHU+FkK+vi5glcJcE6oj8LeAgA4fV4A=
Date:   Thu, 21 Jan 2021 10:28:16 +0000
Message-ID: <9952EF0C-CD1D-4EDB-BAB8-21F72C0BF90D@amazon.com>
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <20210112074658-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210112074658-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.195]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3101E87ED31714D98C7F1E02527BB78@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTIvMDEvMjAyMSwgMTQ6NDksICJNaWNoYWVsIFMuIFRzaXJraW4iIDxtc3RAcmVkaGF0LmNv
bT4gd3JvdGU6DQoNCiAgICBPbiBUdWUsIEphbiAxMiwgMjAyMSBhdCAwMjoxNTo1OFBNICswMjAw
LCBBZHJpYW4gQ2F0YW5naXUgd3JvdGU6DQogICAgPiBUaGUgZmlyc3QgcGF0Y2ggaW4gdGhlIHNl
dCBpbXBsZW1lbnRzIGEgZGV2aWNlIGRyaXZlciB3aGljaCBleHBvc2VzIGENCiAgICA+IHJlYWQt
b25seSBkZXZpY2UgL2Rldi9zeXNnZW5pZCB0byB1c2Vyc3BhY2UsIHdoaWNoIGNvbnRhaW5zIGEN
CiAgICA+IG1vbm90b25pY2FsbHkgaW5jcmVhc2luZyB1MzIgZ2VuZXJhdGlvbiBjb3VudGVyLiBM
aWJyYXJpZXMgYW5kDQogICAgPiBhcHBsaWNhdGlvbnMgYXJlIGV4cGVjdGVkIHRvIG9wZW4oKSB0
aGUgZGV2aWNlLCBhbmQgdGhlbiBjYWxsIHJlYWQoKQ0KICAgID4gd2hpY2ggYmxvY2tzIHVudGls
IHRoZSBTeXNHZW5JZCBjaGFuZ2VzLiBGb2xsb3dpbmcgYW4gdXBkYXRlLCByZWFkKCkNCiAgICA+
IGNhbGxzIG5vIGxvbmdlciBibG9jayB1bnRpbCB0aGUgYXBwbGljYXRpb24gYWNrbm93bGVkZ2Vz
IHRoZSBuZXcNCiAgICA+IFN5c0dlbklkIGJ5IHdyaXRlKClpbmcgaXQgYmFjayB0byB0aGUgZGV2
aWNlLiBOb24tYmxvY2tpbmcgcmVhZCgpIGNhbGxzDQogICAgPiByZXR1cm4gRUFHQUlOIHdoZW4g
dGhlcmUgaXMgbm8gbmV3IFN5c0dlbklkIGF2YWlsYWJsZS4gQWx0ZXJuYXRpdmVseSwNCiAgICA+
IGxpYnJhcmllcyBjYW4gbW1hcCgpIHRoZSBkZXZpY2UgdG8gZ2V0IGEgc2luZ2xlIHNoYXJlZCBw
YWdlIHdoaWNoDQogICAgPiBjb250YWlucyB0aGUgbGF0ZXN0IFN5c0dlbklkIGF0IG9mZnNldCAw
Lg0KDQogICAgTG9va2luZyBhdCBzb21lIHNwZWNpZmljYXRpb25zLCB0aGUgZ2VuIElEIG1pZ2h0
IGFjdHVhbGx5IGJlIGxvY2F0ZWQNCiAgICBhdCBhbiBhcmJpdHJhcnkgYWRkcmVzcy4gSG93IGFi
b3V0IGluc3RlYWQgb2YgaGFyZC1jb2RpbmcgdGhlIG9mZnNldCwNCiAgICB3ZSBleHBvc2UgaXQg
ZS5nLiBpbiBzeXNmcz8NCg0KVGhlIGZ1bmN0aW9uYWxpdHkgaXMgc3BsaXQgYmV0d2VlbiBTeXNH
ZW5JRCB3aGljaCBleHBvc2VzIGFuIGludGVybmFsIHUzMg0KY291bnRlciB0byB1c2Vyc3BhY2Us
IGFuZCBhbiAob3B0aW9uYWwpIFZtR2VuSUQgYmFja2VuZCB3aGljaCBkcml2ZXMNClN5c0dlbklE
IGdlbmVyYXRpb24gY2hhbmdlcyBiYXNlZCBvbiBodyB2bWdlbmlkIHVwZGF0ZXMuDQoNClRoZSBo
dyBVVUlEIHlvdSdyZSByZWZlcnJpbmcgdG8gKHZtZ2VuaWQpIGlzIG5vdCBtbWFwLWVkIHRvIHVz
ZXJzcGFjZSBvcg0Kb3RoZXJ3aXNlIGV4cG9zZWQgdG8gdXNlcnNwYWNlLiBJdCBpcyBvbmx5IHVz
ZWQgaW50ZXJuYWxseSBieSB0aGUgdm1nZW5pZA0KZHJpdmVyIHRvIGZpbmQgb3V0IGFib3V0IFZN
IGdlbmVyYXRpb24gY2hhbmdlcyBhbmQgZHJpdmUgdGhlIG1vcmUgZ2VuZXJpYw0KU3lzR2VuSUQu
DQoNClRoZSBTeXNHZW5JRCB1MzIgbW9ub3RvbmljIGluY3JlYXNpbmcgY291bnRlciBpcyB0aGUg
b25lIHRoYXQgaXMgbW1hcGVkIHRvDQp1c2Vyc3BhY2UsIGJ1dCBpdCBpcyBhIHNvZnR3YXJlIGNv
dW50ZXIuIEkgZG9uJ3Qgc2VlIGFueSB2YWx1ZSBpbiB1c2luZyBhIGR5bmFtaWMNCm9mZnNldCBp
biB0aGUgbW1hcGVkIHBhZ2UuIE9mZnNldCAwIGlzIGZhc3QgYW5kIGVhc3kgYW5kIG1vc3QgaW1w
b3J0YW50bHkgaXQgaXMNCnN0YXRpYyBzbyBubyBuZWVkIHRvIGR5bmFtaWNhbGx5IGNhbGN1bGF0
ZSBvciBmaW5kIGl0IGF0IHJ1bnRpbWUuDQoNClRoYW5rcywNCkFkcmlhbi4NCg0KCgoKQW1hem9u
IERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAy
N0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcw
MDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVy
IEoyMi8yNjIxLzIwMDUuCg==


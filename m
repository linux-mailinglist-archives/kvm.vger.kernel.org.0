Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C462FEAA1
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 13:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbhAUMtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 07:49:46 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:50040 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731075AbhAUMtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 07:49:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1611233359; x=1642769359;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=YGqUQ1UUFyxHwrMSqEqyzgCapYq/vp03G99HlwzxUsM=;
  b=HjQ+yxF+qyFGznz1qXfog473E7pF5ZthjHgD90JGnT05f7Hv4aGvSx9y
   aCbxpz5ooc8/Usd/WWZUJplYBesxcHV+K5sQ6Ap3ORGqGjwpWw2fAyPuY
   w6UjCFazW4C4Nh+16xB5nwtejJ1Y10CsEfjXiugfsseTL3O2bLt6cVlJ3
   Q=;
X-IronPort-AV: E=Sophos;i="5.79,363,1602547200"; 
   d="scan'208";a="912380983"
Subject: Re: [PATCH v4 1/2] drivers/misc: sysgenid: add system generation id driver
Thread-Topic: [PATCH v4 1/2] drivers/misc: sysgenid: add system generation id driver
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 21 Jan 2021 12:48:27 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id BB3C5120DDC;
        Thu, 21 Jan 2021 12:48:25 +0000 (UTC)
Received: from EX13D01UWA004.ant.amazon.com (10.43.160.99) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 Jan 2021 12:48:25 +0000
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13d01UWA004.ant.amazon.com (10.43.160.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 Jan 2021 12:48:24 +0000
Received: from EX13D08EUB004.ant.amazon.com ([10.43.166.158]) by
 EX13D08EUB004.ant.amazon.com ([10.43.166.158]) with mapi id 15.00.1497.010;
 Thu, 21 Jan 2021 12:48:23 +0000
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
Thread-Index: AQHW6NzJ6Ner/CpAZ0GLGgCheKaWxKoj9m4AgA5AxgA=
Date:   Thu, 21 Jan 2021 12:48:23 +0000
Message-ID: <3159F7DB-C72B-4727-9C83-7E7619FC7D98@amazon.com>
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <1610453760-13812-2-git-send-email-acatan@amazon.com>
 <20210112080427-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210112080427-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.192]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E59309106369F468D00E8FFBB8BA324@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTIvMDEvMjAyMSwgMTU6MDksICJNaWNoYWVsIFMuIFRzaXJraW4iIDxtc3RAcmVkaGF0LmNv
bT4gd3JvdGU6DQoNCiAgICBPbiBUdWUsIEphbiAxMiwgMjAyMSBhdCAwMjoxNTo1OVBNICswMjAw
LCBBZHJpYW4gQ2F0YW5naXUgd3JvdGU6DQogICAgDQogICAgPiArMykgTWFwcGVkIG1lbW9yeSBw
b2xsaW5nIHNpbXBsaWZpZWQgZXhhbXBsZTo6DQogICAgPiArDQogICAgPiArICAgICAvKg0KICAg
ID4gKyAgICAgICogYXBwL2xpYnJhcnkgZnVuY3Rpb24gdGhhdCBwcm92aWRlcyBjYWNoZWQgc2Vj
cmV0cw0KICAgID4gKyAgICAgICovDQogICAgPiArICAgICBjaGFyICogc2FmZV9jYWNoZWRfc2Vj
cmV0KGFwcF9kYXRhX3QgKmFwcCkNCiAgICA+ICsgICAgIHsNCiAgICA+ICsgICAgICAgICAgICAg
Y2hhciAqc2VjcmV0Ow0KICAgID4gKyAgICAgICAgICAgICB2b2xhdGlsZSB1bnNpZ25lZCAqY29u
c3QgZ2VuaWRfcHRyID0gZ2V0X3N5c2dlbmlkX21hcHBpbmcoYXBwKTsNCiAgICA+ICsgICAgIGFn
YWluOg0KICAgID4gKyAgICAgICAgICAgICBzZWNyZXQgPSBfX2NhY2hlZF9zZWNyZXQoYXBwKTsN
CiAgICA+ICsNCiAgICA+ICsgICAgICAgICAgICAgaWYgKHVubGlrZWx5KCpnZW5pZF9wdHIgIT0g
YXBwLT5jYWNoZWRfZ2VuaWQpKSB7DQogICAgPiArICAgICAgICAgICAgICAgICAgICAgYXBwLT5j
YWNoZWRfZ2VuaWQgPSAqZ2VuaWRfcHRyOw0KICAgID4gKyAgICAgICAgICAgICAgICAgICAgIGJh
cnJpZXIoKTsNCiAgICA+ICsNCiAgICA+ICsgICAgICAgICAgICAgICAgICAgICAvLyByZWJ1aWxk
IHdvcmxkIHRoZW4gY29uZmlybSB0aGUgZ2VuaWQgdXBkYXRlICh0aHJ1IHdyaXRlKQ0KICAgID4g
KyAgICAgICAgICAgICAgICAgICAgIHJlYnVpbGRfY2FjaGVzKGFwcCk7DQogICAgPiArDQogICAg
PiArICAgICAgICAgICAgICAgICAgICAgYWNrX3N5c2dlbmlkX3VwZGF0ZShhcHApOw0KICAgID4g
Kw0KICAgID4gKyAgICAgICAgICAgICAgICAgICAgIGdvdG8gYWdhaW47DQogICAgPiArICAgICAg
ICAgICAgIH0NCiAgICA+ICsNCiAgICA+ICsgICAgICAgICAgICAgcmV0dXJuIHNlY3JldDsNCg0K
DQoNCiAgICBIbW0uIFRoaXMgc2VlbXMgdG8gcmVseSBvbiB0aGUgYXNzdW1wdGlvbiB0aGF0IGlm
IHlvdSBoYXZlDQogICAgcmVhZCB0aGUgSUQgYW5kIGl0IGRpZCBub3QgY2hhbmdlLCB0aGVuIGFs
bCBpcyB3ZWxsLg0KDQogICAgUHJvYmxlbSBpcywgaW4gdGhlIGludGVycnVwdCBkcml2ZW4gaW1w
bGVtZW50YXRpb24NCiAgICB0aGlzIGlzIG5vdCBhIHNhZmUgYXNzdW1wdGlvbiB0byBtYWtlOiBJ
RA0KICAgIGZyb20gaHlwZXJ2aXNvciBtaWdodCBoYXZlIGNoYW5nZWQgYnV0IGludGVycnVwdA0K
ICAgIGNvdWxkIGJlIGRlbGF5ZWQuDQoNCg0KICAgIElmIHdlIG1hcCB0aGUgaHlwZXJ2aXNvciBJ
RCB0byB1c2Vyc3BhY2UgdGhlbiB3ZSB3b24ndA0KICAgIGhhdmUgdGhpcyByYWNlIC4uLiB3b3J0
aCB3b3JyeSBhYm91dD8gd2h5IG5vdD8NCg0KVGhpcyBpcyBhIHZlcnkgZ29vZCBwb2ludCEgVW5m
b3J0dW5hdGVseSwgdGhlcmUgaXMgbm8gaW1tZWRpYXRlIHNvbHV0aW9uIGhlcmUuDQpUaGUgY3Vy
cmVudCBwYXRjaC1zZXQgbWFrZXMgdGhpcyB0cmFkZS1vZmYgaW4gb3JkZXIgdG8gZ2FpbiB0aGUg
Z2VuZXJpY2l0eSBvZg0KYSBzeXN0ZW0tbGV2ZWwgZ2VuZXJhdGlvbiBJRCB3aGljaCBpcyBub3Qg
bGltaXRlZCB0byBWTXMgdXNlY2FzZXMsIGJ1dCBjYW4gYWxzbw0KYmUgdXNlZCB3aXRoIHRoaW5n
cyBsaWtlIENSSVUuDQoNCkRpcmVjdGx5IG1hcHBpbmcgdGhlIHZtZ2VuaWQgVVVJRCB0byB1c2Vy
c3BhY2Ugd2FzIHRoZSBpbml0aWFsIGRlc2lnbiBvZiB0aGlzDQpwYXRjaC1zZXQgKHNlZSB2MSks
IGJ1dCBpdCB3YXMgYXJndWVkIGFnYWluc3QgYW5kIGV2b2x2ZWQgaW50byBjdXJyZW50IHN0YXRl
Lg0KDQpJIHdvdWxkIHBlcnNvbmFsbHkgcmF0aGVyIGVuaGFuY2UgdGhlIEhXIHN1cHBvcnQgKHZt
Z2VuaWQgZGV2aWNlIGZvciBleGFtcGxlKQ0KdG8gYWxzbyBleHBvc2UgYSBjb25maWd1cmFibGUg
dTMyIFZtIEdlbiBDb3VudGVyIGFsb25nc2lkZSB0aGUgMTI4LWJpdCBVVUlEOw0KYW5kIGFkZCBz
dXBwb3J0IGluIFN5c0dlbklEIHRvIG9mZmxvYWQgdGhlIGNvdW50ZXIgdG8gSFcgd2hlbiBhcHBs
aWNhYmxlLg0KDQoNClRoZSBicm9hZGVyIHZpZXcgaXMgd2UgbmVlZCB0byBzdHJpa2UgdGhlIHJp
Z2h0IGJhbGFuY2UgYmV0d2VlbiBhIGZ1bmN0aW9uYWwsDQpzYWZlIG1lY2hhbmlzbSB3aXRoIHRv
ZGF5J3MgdGVjaG5vbG9neSwgYnV0IGFsc28gZGVzaWduIGEgZnV0dXJlLXByb29mIGdlbmVyaWMN
Cm1lY2hhbmlzbS4NCg0KRml4aW5nIHRoZSByYWNlIHlvdSBtZW50aW9uZWQgaW4gU3lzR2VuSUQg
b25seSBtb3ZlcyB0aGUgcmFjZSBhIGJpdCBmdXJ0aGVyIHVwDQp0aGUgc3RhY2sgLSB5b3UgZ2Vu
ZXJhdGUgdGhlIHNlY3JldCByYWNlLWZyZWUgYnV0IHRoZSBzZWNyZXQgY2FuIHN0aWxsIGJlIGR1
cGxpY2F0ZWQNCmluIHRoZSBuZXh0IGxheWVyLiBUbyBtYWtlIGFueSBtZWNoYW5pc20gY29tcGxl
dGVseSBzYWZlIHdlIG5lZWQgdG8gY29uY2VwdHVhbGx5DQpkaXNjb25uZWN0IG91cnNlbHZlcyBm
cm9tIGJlbGlldmluZyB0aGF0IGEgcmVzdG9yZWQgc25hcHNob3QgaXMgaW1tZWRpYXRlbHkgYXZh
aWxhYmxlLg0KVGhlcmUgbmVlZHMgdG8gYmUgc29tZSBlbnRpdHkgdGhhdCBtb3ZlcyB0aGUgcmVz
dG9yZWQgVk0vY29udGFpbmVyL3N5c3RlbQ0KZnJvbSBhIHRyYW5zaWVudCBzdGF0ZSB0byAiYXZh
aWxhYmxlIi4gVGhhdCBlbnRpdHkgY2FuIGJlIGEgcHJvY2VzcyBpbnNpZGUgdGhlIFZNLA0KYnV0
IGl0IGNhbiBhbHNvIGJlIHNvbWV0aGluZyBvdXRzaWRlIHRoZSBWTSwgaW4gdGhlIGh5cGVydmlz
b3Igb3IgaW4gdGhlIHN0YWNrDQpzdXJyb3VuZGluZyBpdC4gVGhhdCBlbnRpdHkgaXMgcmVzcG9u
c2libGUgZm9yIG1hbmFnaW5nIHRoZSB0cmFuc2l0aW9uIG9mIHRoZSBWTQ0Kb3IgY29udGFpbmVy
IGZyb20gdHJhbnNpZW50IC0+IGF2YWlsYWJsZS4gSXQgaXMgcmVzcG9uc2libGUgZm9yIG5vdCBh
bGxvd2luZyB0aGUgVk0vDQpjb250YWluZXIgdG8gYmUgdXNlZCBvciB1c2FibGUgdW50aWwgdGhh
dCB0cmFuc2l0aW9uIGlzIGNvbXBsZXRlLg0KDQpJbiB0aGUgZmlyc3QgZ2VuZXJhdGlvbnMgb2Yg
Vk0gY2xvbmVzIGFuZCBDUklVIHByb2R1Y3Rpb24gZGVwbG95bWVudHMsIEkgZXhwZWN0DQp0aGlz
IGVudGl0eSB0byBiZSBhIHN0YWNrLXNwZWNpZmljIGNvbXBvbmVudCB3aXRoIGludGltYXRlIGtu
b3dsZWRnZSBvZiB0aGUgc3lzdGVtDQpjb21wb25lbnRzLCB0cmFuc2llbnQgc3RhdGVzLCBsaWZl
Y3ljbGUsIGV0Yy4gV2hpY2ggdGhpcyBwYXRjaC1zZXQgZW5hYmxlcy4NCg0KDQpUaGFua3MsDQpB
ZHJpYW4uDQoNCg0KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwu
IHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwg
SWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlh
LiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0713171B1
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 21:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhBJUwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 15:52:35 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:35374 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbhBJUwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 15:52:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1612990353; x=1644526353;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=b/hVfJzVr3iovIfahA8yrygNKjutw97QkUAEKn27q1k=;
  b=N2zRxVmFKVEskEnBdAyXadHrfkrjSd4wkHiAKfN/0nEx6U8OozUKHqm7
   sg2ob+/WRwGUDhUZmI/vyhwmjQTdPSnEjpBlFDiJl2bTjUSKy1yntMnp9
   ED+paDkjs7sA6r2DAcbt6bjghfsG4g0ZSJLmlSweNP1xCygXZ0+CkqS7F
   o=;
X-IronPort-AV: E=Sophos;i="5.81,169,1610409600"; 
   d="scan'208";a="81584434"
Subject: Re: [PATCH 5/5] KVM: x86/xen: Explicitly pad struct compat_vcpu_info to 64
 bytes
Thread-Topic: [PATCH 5/5] KVM: x86/xen: Explicitly pad struct compat_vcpu_info to 64 bytes
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 10 Feb 2021 20:51:45 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 14980AD1A3;
        Wed, 10 Feb 2021 20:51:44 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 20:51:42 +0000
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 20:51:42 +0000
Received: from EX13D08UEB001.ant.amazon.com ([10.43.60.245]) by
 EX13D08UEB001.ant.amazon.com ([10.43.60.245]) with mapi id 15.00.1497.010;
 Wed, 10 Feb 2021 20:51:42 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHW/9pOzhEdoEl9PkGnB5lokEkwtKpR3VyA
Date:   Wed, 10 Feb 2021 20:51:42 +0000
Message-ID: <8752a59b694671d25308d644cba661c4ec128094.camel@amazon.co.uk>
References: <20210210182609.435200-1-seanjc@google.com>
         <20210210182609.435200-6-seanjc@google.com>
In-Reply-To: <20210210182609.435200-6-seanjc@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.147]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B315C3D99015494D8BE1427259E824C4@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIxLTAyLTEwIGF0IDEwOjI2IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgYSAyIGJ5dGUgcGFkIHRvIHN0cnVjdCBjb21wYXRfdmNwdV9pbmZvIHNvIHRo
YXQgdGhlIHN1bSBzaXplIG9mIGl0cw0KPiBmaWVsZHMgaXMgYWN0dWFsbHkgNjQgYnl0ZXMuICBU
aGUgZWZmZWN0aXZlIHNpemUgd2l0aG91dCB0aGUgcGFkZGluZyBpcw0KPiBhbHNvIDY0IGJ5dGVz
IGR1ZSB0byB0aGUgY29tcGlsZXIgYWxpZ25pbmcgZXZ0Y2huX3BlbmRpbmdfc2VsIHRvIGEgNC1i
eXRlDQo+IGJvdW5kYXJ5LCBidXQgZGVwZW5kaW5nIG9uIGNvbXBpbGVyIGFsaWdubWVudCBpcyBz
dWJ0bGUgYW5kIHVubmVjZXNzYXJ5Lg0KDQpJIHRoaW5rIHRoZXJlJ3MgYXQgbGVhc3Qgb25lIEJV
SUxEX0JVR19PTigpIHdoaWNoIHdvdWxkIGhhdmUgdHJpZ2dlcmVkDQppZiB0aGUgY29tcGlsZXIg
ZXZlciBkaWQgc3RvcCBob25vdXJpbmcgdGhlIEVMRiBBQkkuIEFuZCBpbiBmYWN0IGluIGENCnBh
cmFsbGVsIHVuaXZlcnNlIHdoZXJlIHRoZSBBQkkgcGVybWl0cyBzdWNoIHBhY2tpbmcsIHRoZSBw
YWRkaW5nIHdvdWxkDQpiZSAqd3JvbmcqLCBzaW5jZSB0aGUgb3JpZ2luYWwgWGVuIHN0cnVjdCBk
b2Vzbid0IGhhdmUgdGhlIHBhZGRpbmcuIA0KDQpJdCAqZG9lcyogaGF2ZSBhbiBleHBsaWNpdCB1
aW50OF90IHRvIHJlcGxhY2UgZXZ0Y2huX3VwY2FsbF9tYXNrIGJ1dCBpdA0KZG9lc24ndCBoYXZl
IHRoZSBmb2xsb3dpbmcgdHdvIGJ5dGVzOyBjYW5vbmljYWxseSB3ZSAqYXJlKiBzdXBwb3NlZCB0
bw0KdGFrZSBvdXIgY2hhbmNlcyB3aXRoIHRoZSBBQkkgdGhlcmUuIEFsdGhvdWdoIG9mIGNvdXJz
ZSB0aGUgcmVsZXZhbnQNCkFCSSBpcyB0aGUgKjMyLWJpdCogQUJJIGluIHRoZSBjb21wYXQgY2Fz
ZSwgbm90IHRoZSA2NC1iaXQgQUJJLiBUaGV5DQpib3RoIGFsaWduIDMyLWJpdCB2YWx1ZXMgdG8g
MzIgYml0cyB0aG91Z2guDQoNCiAgICB1aW50OF90IGV2dGNobl91cGNhbGxfcGVuZGluZzsNCiNp
ZmRlZiBYRU5fSEFWRV9QVl9VUENBTExfTUFTSw0KICAgIHVpbnQ4X3QgZXZ0Y2huX3VwY2FsbF9t
YXNrOw0KI2Vsc2UgLyogWEVOX0hBVkVfUFZfVVBDQUxMX01BU0sgKi8NCiAgICB1aW50OF90IHBh
ZDA7DQojZW5kaWYgLyogWEVOX0hBVkVfUFZfVVBDQUxMX01BU0sgKi8NCiAgICB4ZW5fdWxvbmdf
dCBldnRjaG5fcGVuZGluZ19zZWw7DQogICAgc3RydWN0IGFyY2hfdmNwdV9pbmZvIGFyY2g7DQog
ICAgc3RydWN0IHZjcHVfdGltZV9pbmZvIHRpbWU7DQp9OyAvKiA2NCBieXRlcyAoeDg2KSAqLw0K
DQpTbyBpdCBpc24ndCBjbGVhciB0aGUgYWRkaXRpb25hbGx5IHBhZGRpbmcgcmVhbGx5IGJ1eXMg
dXMgYW55dGhpbmc7IGlmDQp3ZSBwbGF5IHRoaXMgZ2FtZSB3aXRob3V0IGtub3dpbmcgdGhlIEFC
SSB3ZSdkIGJlIHNjcmV3ZWQgYW55d2F5LiBCdXQNCml0IGRvZXNuJ3QgaHVydC4NCg0KPiBPcHBv
cnR1bmlzdGljYWxseSByZXBsYWNlIHNwYWNlcyB3aXRoIHRhYmxlcyBpbiB0aGUgb3RoZXIgZmll
bGRzLg0KDQpUaGF0IHBhcnQgSSBjZXJ0YWlubHkgYXBwcm92ZSBvZi4gDQoNClJldmlld2VkLWJ5
OiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1hem9uLmNvLnVrPg0KCgoKQW1hem9uIERldmVsb3Bt
ZW50IENlbnRyZSAoTG9uZG9uKSBMdGQuIFJlZ2lzdGVyZWQgaW4gRW5nbGFuZCBhbmQgV2FsZXMg
d2l0aCByZWdpc3RyYXRpb24gbnVtYmVyIDA0NTQzMjMyIHdpdGggaXRzIHJlZ2lzdGVyZWQgb2Zm
aWNlIGF0IDEgUHJpbmNpcGFsIFBsYWNlLCBXb3JzaGlwIFN0cmVldCwgTG9uZG9uIEVDMkEgMkZB
LCBVbml0ZWQgS2luZ2RvbS4KCgo=


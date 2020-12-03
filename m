Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C02CE151
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 23:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgLCWGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 17:06:12 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:4729 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCWGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 17:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607033171; x=1638569171;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=NJkzfki/00T/A9FZ9WHVaO8rKb/C2gl2qXQ81IHQXcs=;
  b=bCg0TiBIE8oLVZ5/QpMMo06PKYfT4LxdnujsLy9lXhrjOHBvnWSU+dby
   wnK2AD/KvEwnFmhsPltGKBoTk0zGwGfeSoTi9dJv4t/OEp5KhdZoAKqcb
   2lFJOfCE7Y2XTfuI7MH+0JKJ/HBhYT4CiaCczZWq67XyIbAZXQPS6zyHd
   E=;
X-IronPort-AV: E=Sophos;i="5.78,390,1599523200"; 
   d="scan'208";a="900457271"
Subject: Re: [PATCH v3 4/4] selftests: kvm: Test MSR exiting to userspace
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 03 Dec 2020 22:05:24 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 990F5A20BA;
        Thu,  3 Dec 2020 22:05:23 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 22:05:23 +0000
Received: from Alexanders-Mac-mini.local (10.43.160.21) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 22:05:21 +0000
To:     Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        "kvm list" <kvm@vger.kernel.org>
References: <20201012194716.3950330-1-aaronlewis@google.com>
 <20201012194716.3950330-5-aaronlewis@google.com>
 <CAAAPnDGP13jh5cC1xBF_gL4VStoNPd01UjWvkDqdctDRNKw0bQ@mail.gmail.com>
 <1e7c370b-1904-4b54-db8a-c9d475bb4bf5@redhat.com>
 <CAAAPnDFpfiYRs7GZ0o0wSXdzD2AFxLy=XOhRyhcEaQKmaYJzGw@mail.gmail.com>
 <71f1c9c0-b92c-76f9-0878-e3b8b184b7f0@redhat.com>
 <CAAAPnDHkZaPZP6ht3y1A5mXkP=T6mDppy-zygKje1Hs5s8huWw@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <db1e99c9-e328-53bf-45de-dd15585d3467@amazon.com>
Date:   Thu, 3 Dec 2020 23:05:20 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:84.0)
 Gecko/20100101 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDHkZaPZP6ht3y1A5mXkP=T6mDppy-zygKje1Hs5s8huWw@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13d09UWA001.ant.amazon.com (10.43.160.247) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwMy4xMi4yMCAyMjo0NywgQWFyb24gTGV3aXMgd3JvdGU6Cj4gQ0FVVElPTjogVGhpcyBl
bWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRo
ZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4KPiAKPiAKPiAKPiBPbiBUaHUs
IERlYyAzLCAyMDIwIGF0IDk6NDggQU0gUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNv
bT4gd3JvdGU6Cj4+Cj4+IE9uIDAyLzEyLzIwIDE2OjMxLCBBYXJvbiBMZXdpcyB3cm90ZToKPj4+
IE9uIE1vbiwgTm92IDksIDIwMjAgYXQgOTowOSBBTSBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPiB3cm90ZToKPj4+Pgo+Pj4+IE9uIDA5LzExLzIwIDE3OjU4LCBBYXJvbiBMZXdp
cyB3cm90ZToKPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEFhcm9uIExld2lzPGFhcm9ubGV3aXNAZ29v
Z2xlLmNvbT4KPj4+Pj4+IFJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZjxncmFmQGFtYXpvbi5j
b20+Cj4+Pj4+PiAtLS0KPj4+Pj4+ICAgICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vLmdp
dGlnbm9yZSAgICAgICAgfCAgIDEgKwo+Pj4+Pj4gICAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2t2bS9NYWtlZmlsZSAgICAgICAgICB8ICAgMSArCj4+Pj4+PiAgICAgdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMva3ZtL2xpYi9rdm1fdXRpbC5jICAgIHwgICAyICsKPj4+Pj4+ICAgICAuLi4va3Zt
L3g4Nl82NC91c2Vyc3BhY2VfbXNyX2V4aXRfdGVzdC5jICAgICAgfCA1NjAgKysrKysrKysrKysr
KysrKysrCj4+Pj4+PiAgICAgNCBmaWxlcyBjaGFuZ2VkLCA1NjQgaW5zZXJ0aW9ucygrKQo+Pj4+
Pj4gICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2
XzY0L3VzZXJzcGFjZV9tc3JfZXhpdF90ZXN0LmMKPj4+Pj4+Cj4+Pj4+IEl0IGxvb2tzIGxpa2Ug
dGhlIHJlc3Qgb2YgdGhpcyBwYXRjaHNldCBoYXMgYmVlbiBhY2NlcHRlZCB1cHN0cmVhbS4KPj4+
Pj4gSXMgdGhpcyBvbmUgb2theSB0byBiZSB0YWtlbiB0b28/Cj4+Pj4+Cj4+Pj4KPj4+PiBJIG5l
ZWRlZCBtb3JlIHRpbWUgdG8gdW5kZXJzdGFuZCB0aGUgb3ZlcmxhcCBiZXR3ZWVuIHRoZSB0ZXN0
cywgYnV0IHllcy4KPj4+Pgo+Pj4+IFBhb2xvCj4+Pj4KPj4+Cj4+PiBQaW5naW5nIHRoaXMgdGhy
ZWFkLgo+Pj4KPj4+IEp1c3Qgd2FudGVkIHRvIGNoZWNrIGlmIHRoaXMgd2lsbCBiZSB1cHN0cmVh
bWVkIHNvb24gb3IgaWYgdGhlcmUgYXJlCj4+PiBhbnkgcXVlc3Rpb25zIGFib3V0IGl0Lgo+Pgo+
PiBZZXMsIEknbSBxdWV1aW5nIGl0LiAgQW55IG9iamVjdGlvbnMgdG8gcmVwbGFjaW5nIHg4Nl82
NC91c2VyX21zcl90ZXN0LmMKPj4gY29tcGxldGVseSwgc2luY2UgdGhpcyB0ZXN0IGlzIGVmZmVj
dGl2ZWx5IGEgc3VwZXJzZXQ/Cj4+Cj4+IFBhb2xvCj4+Cj4gCj4gSGkgUGFvbG8sCj4gCj4gVGhl
IG1haW4gZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSB0d28gdGVzdHMgaXMgbXkgdGVzdCBkb2VzIG5v
dCBleGVyY2lzZQo+IHRoZSBLVk1fTVNSX0ZJTFRFUl9ERUZBVUxUX0RFTlkgZmxhZy4gIElmIEFs
ZXggaXMgb2theSB3aXRoIHRoYXQgdGVzdAo+IGJlaW5nIHJlcGxhY2VkIEknbSBva2F5IHdpdGgg
aXQuIEhvd2V2ZXIsIEkgd291bGRuJ3QgYmUgb3Bwb3NlZCB0bwo+IGFkZGluZyBpdCBmcm9tIHVz
ZXJfbXNyX3Rlc3QuYyBpbnRvIG1pbmUuICBUaGF0IHdheSB0aGV5IGFyZSBhbGwgaW4KPiBvbmUg
cGxhY2UuCgpJIHRoaW5rIHRoYXQgd291bGQgYmUgYmVzdC4gV291bGQgeW91IGhhcHBlbiB0byBo
YXZlIHNvbWUgdGltZSB0byBqdXN0IAptZXJnZSB0aGVtIHF1aWNrbHk/IEl0J3MgcHJvYmFibHkg
YmVzdCB0byBmaXJzdCBhcHBseSBib3RoLCBhbmQgdGhlbiAKaGF2ZSBvbmUgcGF0Y2ggdGhhdCBt
ZXJnZXMgdGhlbS4gOikKCgpUaGFua3MhCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50
ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVl
aHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFt
IEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJs
aW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==


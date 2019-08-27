Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405539E23F
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 10:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbfH0IVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 04:21:12 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:20647 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbfH0IVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 04:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566894071; x=1598430071;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Pp8hA+F32QXnV3/VDGwJ40qoSaR8Yax8k9gBgAQuFNU=;
  b=QXGLrCYMKlkULkHubv42BbGMttHJd8bO8uSrbpWyK/0wu/QM7hmU0XYh
   pOjIb8rSQUyz53IKSiGl6Jm+OHeKmS2IiE1xDogN34XecK85F9i3P+sLf
   qbr+PtzNvYO3OIWeaOsR7diPImm+Cefvq8lB7zyAjBErQdlevLzqlDa4e
   c=;
X-IronPort-AV: E=Sophos;i="5.64,436,1559520000"; 
   d="scan'208";a="417880360"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 27 Aug 2019 08:21:05 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 14CE9A2450;
        Tue, 27 Aug 2019 08:21:03 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 27 Aug 2019 08:21:02 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.243) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 27 Aug 2019 08:21:00 +0000
Subject: Re: [PATCH v2 04/15] kvm: x86: Add per-VM APICv state debugfs
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-5-git-send-email-suravee.suthikulpanit@amd.com>
 <a48080a5-7ece-280d-2c1f-9d3f4c273a8d@amazon.com>
 <049c0f98-bd89-ee3c-7869-92972f2d7c31@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <f9c62280-efb4-197d-1444-fce8f3d15132@amazon.com>
Date:   Tue, 27 Aug 2019 10:20:57 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <049c0f98-bd89-ee3c-7869-92972f2d7c31@amd.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.243]
X-ClientProxiedBy: EX13D31UWC004.ant.amazon.com (10.43.162.27) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi4wOC4xOSAyMTo0MSwgU3V0aGlrdWxwYW5pdCwgU3VyYXZlZSB3cm90ZToKPiBBbGV4
LAo+IAo+IE9uIDgvMTkvMjAxOSA0OjU3IEFNLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4KPj4K
Pj4gT24gMTUuMDguMTkgMTg6MjUsIFN1dGhpa3VscGFuaXQsIFN1cmF2ZWUgd3JvdGU6Cj4+PiBD
dXJyZW50bHksIHRoZXJlIGlzIG5vIHdheSB0byB0ZWxsIHdoZXRoZXIgQVBJQ3YgaXMgYWN0aXZl
Cj4+PiBvbiBhIHBhcnRpY3VsYXIgVk0uIFRoaXMgb2Z0ZW4gY2F1c2UgY29uZnVzaW9uIHNpbmNl
IEFQSUN2Cj4+PiBjYW4gYmUgZGVhY3RpdmF0ZWQgYXQgcnVudGltZS4KPj4+Cj4+PiBJbnRyb2R1
Y2UgYSBkZWJ1Z2ZzIGVudHJ5IHRvIHJlcG9ydCBBUElDdiBzdGF0ZSBvZiBhIFZNLgo+Pj4gVGhp
cyBjcmVhdGVzIGEgcmVhZC1vbmx5IGZpbGU6Cj4+Pgo+Pj4gIMKgwqDCoCAvc3lzL2tlcm5lbC9k
ZWJ1Zy9rdm0vNzA4NjAtMTQvYXBpY3Ytc3RhdGUKPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBTdXJh
dmVlIFN1dGhpa3VscGFuaXQgPHN1cmF2ZWUuc3V0aGlrdWxwYW5pdEBhbWQuY29tPgo+Pgo+PiBT
aG91bGRuJ3QgdGhpcyBmaXJzdCBhbmQgZm9yZW1vc3QgYmUgYSBWTSBpb2N0bCBzbyB0aGF0IHVz
ZXIgc3BhY2UgY2FuIGlucXVpcmUgaXRzIG93biBzdGF0ZT8KPj4KPj4KPj4gQWxleAo+IAo+IEkg
aW50cm9kdWNlIHRoaXMgbWFpbmx5IGZvciBkZWJ1Z2dpbmcgc2ltaWxhciB0byBob3cgS1ZNIGlz
IGN1cnJlbnRseSBwcm92aWRlcwo+IHNvbWUgcGVyLVZDUFUgaW5mb3JtYXRpb246Cj4gCj4gICAg
ICAgL3N5cy9rZXJuZWwvZGVidWcva3ZtLzE1OTU3LTE0L3ZjcHUwLwo+ICAgICAgICAgICBsYXBp
Y190aW1lcl9hZHZhbmNlX25zCj4gICAgICAgICAgIHRzYy1vZmZzZXQKPiAgICAgICAgICAgdHNj
LXNjYWxpbmctcmF0aW8KPiAgICAgICAgICAgdHNjLXNjYWxpbmctcmF0aW8tZnJhYy1iaXRzCj4g
Cj4gSSdtIG5vdCBzdXJlIGlmIHRoaXMgbmVlZHMgdG8gYmUgVk0gaW9jdGwgYXQgdGhpcyBwb2lu
dC4gSWYgdGhpcyBpbmZvcm1hdGlvbiBpcwo+IHVzZWZ1bCBmb3IgdXNlci1zcGFjZSB0b29sIHRv
IGlucXVpcmUgdmlhIGlvY3RsLCB3ZSBjYW4gYWxzbyBwcm92aWRlIGl0LgoKSSdtIG1vc3RseSB0
aGlua2luZyBvZiBzb21ldGhpbmcgbGlrZSAiaW5mbyBhcGljIiBpbiBRRU1VIHdoaWNoIHRvIG1l
IApzZWVtcyBsaWtlIHRoZSBuYXR1cmFsIHBsYWNlIGZvciBBUElDIGluZm9ybWF0aW9uIGV4cG9z
dXJlIHRvIGEgdXNlci4gClRoZSBwcm9ibGVtIHdpdGggZGVidWdmcyBpcyB0aGF0IGl0J3Mgbm90
IGFjY2Vzc2libGUgdG8gdGhlIHVzZXIgdGhhdCAKY3JlYXRlZCB0aGUgVk0sIGJ1dCBvbmx5IHJv
b3QsIHJpZ2h0PwoKVGhhdCBzYWlkLCBJIGRvbid0IGZlZWwgdmVyeSBzdHJvbmdseSBoZXJlLgoK
CkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0
ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdl
ciwgUmFsZiBIZXJicmljaApFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVy
ZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkK
Cgo=


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00778293971
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 12:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393372AbgJTKzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 06:55:39 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:31161 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392324AbgJTKzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 06:55:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1603191339; x=1634727339;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=U3yVkHvQcrDS2rt3RLujo6WsTk7VispOOKaDDDybcRk=;
  b=B0HjdIyZMzFdLNlmXN9PFIoxY8CcpF7ClT5Mj2O+HX3uph0iwLf3OOmg
   Cp6iNdHDat42EV7LQXGHREm/9J7pb4U4V8208nPqL9c8UW4lpVEsawpNa
   vqsoak+4+uzrSHFZyIpG1R0JWZrwp0YDvXhOVmXd7aDBaSJc6EK/5tOOi
   8=;
X-IronPort-AV: E=Sophos;i="5.77,396,1596499200"; 
   d="scan'208";a="78136956"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 Oct 2020 10:55:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 6232AA1891;
        Tue, 20 Oct 2020 10:52:25 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 10:52:24 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.231) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 10:52:22 +0000
Subject: Re: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201019170519.1855564-1-pbonzini@redhat.com>
 <618E2129-7AB5-4F0D-A6C9-E782937FE935@amazon.de>
 <c9dd6726-2783-2dfd-14d1-5cec6f69f051@redhat.com>
 <bce2aee1-bfac-0640-066b-068fa5f12cf8@amazon.de>
 <6edd5e08-92c2-40ff-57be-37b92d1ca2bc@redhat.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <47eb1a4a-d015-b573-d773-e34e578ad753@amazon.de>
Date:   Tue, 20 Oct 2020 12:52:20 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <6edd5e08-92c2-40ff-57be-37b92d1ca2bc@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.231]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMC4xMC4yMCAxMjozNCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiAKPiBPbiAyMC8xMC8y
MCAxMTo0OCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Cj4+ICAgICAgY291bnQ6IDEsCj4+ICAg
ICAgZGVmYXVsdF9hbGxvdzogZmFsc2UsCj4+ICAgICAgcmFuZ2VzOiBbCj4+ICAgICAgICAgIHsK
Pj4gICAgICAgICAgICAgIGZsYWdzOiBLVk1fTVNSX0ZJTFRFUl9SRUFELAo+PiAgICAgICAgICAg
ICAgbm1zcnM6IDEsCj4+ICAgICAgICAgICAgICBiYXNlOiBNU1JfRUZFUiwKPj4gICAgICAgICAg
ICAgIGJpdG1hcDogeyAxIH0sCj4+ICAgICAgICAgIH0sCj4+ICAgICAgXSwKPj4gfQo+Pgo+PiBU
aGF0IGZpbHRlciB3b3VsZCBzZXQgYWxsIHgyYXBpYyByZWdpc3RlcnMgdG8gImRlbnkiLCBidXQg
d291bGQgbm90IGJlCj4+IGNhdWdodCBieSB0aGUgY29kZSBhYm92ZS4gQ29udmVyc2VseSwgYSBy
YW5nZSB0aGF0IGV4cGxpY2l0bHkgYWxsb3dzCj4+IHgyYXBpYyByYW5nZXMgd2l0aCBkZWZhdWx0
X2FsbG93PTAgd291bGQgYmUgcmVqZWN0ZWQgYnkgdGhpcyBwYXRjaC4KPiAKPiBZZXMsIGJ1dCB0
aGUgaWRlYSBpcyB0aGF0IHgyYXBpYyByZWdpc3RlcnMgYXJlIGFsd2F5cyBhbGxvd2VkLCBldmVu
Cj4gb3ZlcnJpZGluZyBkZWZhdWx0X2FsbG93LCBhbmQgdGhlcmVmb3JlIGl0IG1ha2VzIG5vIHNl
bnNlIHRvIGhhdmUgdGhlbQo+IGluIGEgcmFuZ2UuICBUaGUgcGF0Y2ggaXMgb25seSBtYWtpbmcg
dGhpbmdzIGZhaWwgZWFybHkgZm9yIHVzZXJzcGFjZSwKPiB0aGUgcG9saWN5IGlzIGRlZmluZWQg
YnkgU2VhbidzIHBhdGNoLgoKSSBkb24ndCB0aGluayB3ZSBzaG91bGQgZmFpbCBvbiB0aGUgZm9s
bG93aW5nOgoKewogICAgIGRlZmF1bHRfYWxsb3c6IGZhbHNlLAogICAgIHJhbmdlczogWwogICAg
ICAgICB7CiAgICAgICAgICAgICBmbGFnczogS1ZNX01TUl9GSUxURVJfUkVBRCwKICAgICAgICAg
ICAgIG5tc3JzOiA0MDk2LAogICAgICAgICAgICAgYmFzZTogMCwKICAgICAgICAgICAgIGJpdG1h
cDogeyAxLCAxLCAxLCAxLCBbLi4uXSB9LAogICAgICAgICB9LAogICAgICAgICB7CiAgICAgICAg
ICAgICBmbGFnczogS1ZNX01TUl9GSUxURVJfUkVBRCwKICAgICAgICAgICAgIG5tc3JzOiA0MDk2
LAogICAgICAgICAgICAgYmFzZTogMHhjMDAwMDAwMCwKICAgICAgICAgICAgIGJpdG1hcDogeyAx
LCAxLCAxLCAxLCBbLi4uXSB9LAogICAgICAgICB9LAogICAgIF0sCn0KCmFzIGEgd2F5IHRvIHNh
eSAiZXZlcnl0aGluZyBpbiBub3JtYWwgcmFuZ2VzIGlzIGFsbG93ZWQsIHRoZSByZXN0IHBsZWFz
ZSAKZGVmbGVjdCIuIE9yIGV2ZW4ganVzdCB0byBzZXQgZGVmYXVsdCBwb2xpY2llcyB3aXRoIGxl
c3MgcmFuZ2VzLgoKT3IgdG8gc2F5IGl0IGRpZmZlcmVudGx5OiBXaHkgY2FuJ3Qgd2UganVzdCBj
aGVjayBleHBsaWNpdGx5IGFmdGVyIApzZXR0aW5nIHVwIGFsbCBmaWx0ZXIgbGlzdHMgd2hldGhl
ciB4MmFwaWMgTVNScyBhcmUgKmRlbmllZCo/IElmIHNvLCAKY2xlYXIgdGhlIGZpbHRlciBhbmQg
cmV0dXJuIC1FSU5WQUwuCgpUaGF0IHN0aWxsIGxlYXZlcyB0aGUgY2FzZSB3aGVyZSB4MmFwaWMg
aXMgbm90IGhhbmRsZWQgaW4ta2VybmVsLCBidXQgCkknbSBwZXJmZWN0bHkgaGFwcHkgdG8gaWdu
b3JlIHRoYXQgb25lIGFzICJ1c2VyIHNwYWNlIHNob3VsZCBub3QgY2FyZSIgOikuCgoKQWxleAoK
CgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAox
MDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25h
dGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRl
ciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=


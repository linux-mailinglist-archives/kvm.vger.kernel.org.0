Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45FC3717B2
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhECPRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:17:44 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:3487 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhECPRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 11:17:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620055010; x=1651591010;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YvKWiwSmRU4Dr+hSZRypkOyqPn4bUuzOfIykqm0WEEc=;
  b=qQs137GWT61MD73tN8WYop68dhXvzH+Vg+v+VW8ScMPg0mhjIzWQH570
   v/CoYhUmaXJ8rmm3o+rPfGYNzTpXndrkkVHnND6fmC/FyoGdb1RK3Vd5d
   lOC3TEPfJcWivPvN+7yaGSyECcocZufjoRciW3gpNyLE1KKj0IMGICJH5
   g=;
X-IronPort-AV: E=Sophos;i="5.82,270,1613433600"; 
   d="scan'208";a="109798666"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 03 May 2021 15:16:43 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 1C4B6A058C;
        Mon,  3 May 2021 15:16:41 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 May 2021 15:16:40 +0000
Received: from [192.168.25.94] (10.43.162.200) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 May
 2021 15:16:39 +0000
Message-ID: <5a39d304-a5e9-a67f-b99a-68c1418f9b69@amazon.com>
Date:   Mon, 3 May 2021 17:16:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:89.0)
 Gecko/20100101 Thunderbird/89.0
Subject: Re: [PATCH] doc/kvm: Fix wrong entry for KVM_CAP_X86_MSR_FILTER
Content-Language: en-US
To:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
CC:     Alexander Graf <graf@amazon.de>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210503120059.9283-1-sidcha@amazon.de>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20210503120059.9283-1-sidcha@amazon.de>
X-Originating-IP: [10.43.162.200]
X-ClientProxiedBy: EX13D20UWA001.ant.amazon.com (10.43.160.34) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwMy4wNS4yMSAxNDowMCwgU2lkZGhhcnRoIENoYW5kcmFzZWthcmFuIHdyb3RlOgo+IFRo
ZSBjYXBhYmlsaXR5IHRoYXQgZXhwb3NlcyBuZXcgaW9jdGwgS1ZNX1g4Nl9TRVRfTVNSX0ZJTFRF
UiB0bwo+IHVzZXJzcGFjZSBpcyBzcGVjaWZpZWQgaW5jb3JyZWN0bHkgYXMgdGhlIGlvY3RsIGl0
c2VsZiAoaW5zdGVhZCBvZgo+IEtWTV9DQVBfWDg2X01TUl9GSUxURVIpLiBUaGlzIHBhdGNoIGZp
eGVzIGl0Lgo+IAo+IEZpeGVzOiAxYTE1NTI1NGZmOTMgKCJLVk06IHg4NjogSW50cm9kdWNlIE1T
UiBmaWx0ZXJpbmciKQo+IENjOiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uZGU+Cj4gU2ln
bmVkLW9mZi1ieTogU2lkZGhhcnRoIENoYW5kcmFzZWthcmFuIDxzaWRjaGFAYW1hem9uLmRlPgoK
UmV2aWV3ZWQtYnk6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+CgpBbGV4Cgo+IC0t
LQo+ICAgRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0IHwgNCArKy0tCj4gICAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQg
YS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3Zt
L2FwaS5yc3QKPiBpbmRleCAzMDdmMmZjZjFiMDIuLmU3NzhmNGFhMDhmNCAxMDA2NDQKPiAtLS0g
YS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QKPiArKysgYi9Eb2N1bWVudGF0aW9uL3Zp
cnQva3ZtL2FwaS5yc3QKPiBAQCAtNDcxMyw3ICs0NzEzLDcgQEAgS1ZNX1BWX1ZNX1ZFUklGWQo+
ICAgNC4xMjYgS1ZNX1g4Nl9TRVRfTVNSX0ZJTFRFUgo+ICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQo+ICAgCj4gLTpDYXBhYmlsaXR5OiBLVk1fWDg2X1NFVF9NU1JfRklMVEVSCj4gKzpD
YXBhYmlsaXR5OiBLVk1fQ0FQX1g4Nl9NU1JfRklMVEVSCj4gICA6QXJjaGl0ZWN0dXJlczogeDg2
Cj4gICA6VHlwZTogdm0gaW9jdGwKPiAgIDpQYXJhbWV0ZXJzOiBzdHJ1Y3Qga3ZtX21zcl9maWx0
ZXIKPiBAQCAtNjU4Niw3ICs2NTg2LDcgQEAgYWNjZXNzZXMgdGhhdCB3b3VsZCB1c3VhbGx5IHRy
aWdnZXIgYSAjR1AgYnkgS1ZNIGludG8gdGhlIGd1ZXN0IHdpbGwKPiAgIGluc3RlYWQgZ2V0IGJv
dW5jZWQgdG8gdXNlciBzcGFjZSB0aHJvdWdoIHRoZSBLVk1fRVhJVF9YODZfUkRNU1IgYW5kCj4g
ICBLVk1fRVhJVF9YODZfV1JNU1IgZXhpdCBub3RpZmljYXRpb25zLgo+ICAgCj4gLTguMjcgS1ZN
X1g4Nl9TRVRfTVNSX0ZJTFRFUgo+ICs4LjI3IEtWTV9DQVBfWDg2X01TUl9GSUxURVIKPiAgIC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAgCj4gICA6QXJjaGl0ZWN0dXJlczogeDg2Cj4g
CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4
CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpv
bmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVu
dGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71131E491B
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 13:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409888AbfJYLAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 07:00:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:63656 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407262AbfJYLAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 07:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1572001212; x=1603537212;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=V2Jn6XbW2xiy/TKvBN/MhcDOh1lT8VoZ3oiAsRp4Qec=;
  b=t+mXo8NEhQTlK7gqorxjxlDjsxePt7mRt1us/oPcOPthLAunNuIo7GiB
   31Jn/42v9Zh5xcCCFYO2EQ4ddirp0lUD8nRHWm1MGSZx0atydkJykiwg1
   XBTg5IQehzZjXQ9QfyIaEupoDADeJqcbylZKO+4jk9UoBBNNnW7XSwHDj
   Q=;
IronPort-SDR: 0cbJVlmODRDZWjkXv7NNGIs8qa04HoihJeofI/kE+OhOKykhynD7SkvXm6qFZ27cdzp8xGR33L
 y8FbXnn7d6zw==
X-IronPort-AV: E=Sophos;i="5.68,228,1569283200"; 
   d="scan'208";a="79873"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 Oct 2019 11:00:10 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 0BE87A0172;
        Fri, 25 Oct 2019 11:00:09 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 25 Oct 2019 11:00:09 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.16) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 25 Oct 2019 11:00:05 +0000
Subject: Re: [PATCH v2 00/14] KVM: x86: Remove emulation_result enums
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
 <8dec39ac-7d69-b1fd-d07c-cf9d014c4af3@redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <686b499e-7700-228e-3602-8e0979177acb@amazon.com>
Date:   Fri, 25 Oct 2019 13:00:03 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8dec39ac-7d69-b1fd-d07c-cf9d014c4af3@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.16]
X-ClientProxiedBy: EX13D16UWC002.ant.amazon.com (10.43.162.161) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTcuMDkuMTkgMTc6MTQsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gT24gMjcvMDgvMTkgMjM6
NDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+IFJld29yayB0aGUgZW11bGF0b3IgYW5k
IGl0cyB1c2VycyB0byBoYW5kbGUgZmFpbHVyZSBzY2VuYXJpb3MgZW50aXJlbHkKPj4gd2l0aGlu
IHRoZSBlbXVsYXRvci4KPj4KPj4ge3g4Nixrdm19X2VtdWxhdGVfaW5zdHJ1Y3Rpb24oKSBjdXJy
ZW50bHkgcmV0dXJucyBhIHRyaS1zdGF0ZSB2YWx1ZSB0bwo+PiBpbmRpY2F0ZSBzdWNjZXNzL2Nv
bnRpbnVlLCB1c2Vyc3BhY2UgZXhpdCBuZWVkZWQsIGFuZCBmYWlsdXJlLiAgVGhlCj4+IGludGVu
dCBvZiByZXR1cm5pbmcgRU1VTEFURV9GQUlMIGlzIHRvIGxldCB0aGUgY2FsbGVyIGhhbmRsZSBm
YWlsdXJlIGluCj4+IGEgbWFubmVyIHRoYXQgaXMgYXBwcm9wcmlhdGUgZm9yIHRoZSBjdXJyZW50
IGNvbnRleHQuICBJbiBwcmFjdGljZSwKPj4gdGhlIGVtdWxhdG9yIGhhcyBlbmRlZCB1cCB3aXRo
IGEgbWl4dHVyZSBvZiBmYWlsdXJlIGhhbmRsaW5nLCBpLmUuCj4+IHdoZXRoZXIgb3Igbm90IHRo
ZSBlbXVsYXRvciB0YWtlcyBhY3Rpb24gb24gZmFpbHVyZSBpcyBkZXBlbmRlbnQgb24gdGhlCj4+
IHNwZWNpZmljIGZsYXZvciBvZiBlbXVsYXRpb24uCj4+Cj4+IFRoZSBtaXhlZCBoYW5kbGluZyBo
YXMgcHJvdmVuIHRvIGJlIHJhdGhlciBmcmFnaWxlLCBlLmcuIG1hbnkgZmxvd3MKPj4gaW5jb3Jy
ZWN0bHkgYXNzdW1lIHRoZWlyIHNwZWNpZmljIGZsYXZvciBvZiBlbXVsYXRpb24gY2Fubm90IGZh
aWwgb3IKPj4gdGhhdCB0aGUgZW11bGF0b3Igc2V0cyBzdGF0ZSB0byByZXBvcnQgdGhlIGZhaWx1
cmUgYmFjayB0byB1c2Vyc3BhY2UuCj4+Cj4+IE1vdmUgZXZlcnl0aGluZyBpbnNpZGUgdGhlIGVt
dWxhdG9yLCBwaWVjZSBieSBwaWVjZSwgc28gdGhhdCB0aGUKPj4gZW11bGF0aW9uIHJvdXRpbmVz
IGNhbiByZXR1cm4gJzAnIGZvciBleGl0IHRvIHVzZXJzcGFjZSBhbmQgJzEnIGZvcgo+PiByZXN1
bWUgdGhlIGd1ZXN0LCBqdXN0IGxpa2UgZXZlcnkgb3RoZXIgVk0tRXhpdCBoYW5kbGVyLgo+Pgo+
PiBQYXRjaCAxMy8xNCBpcyBhIHRhbmdlbnRpYWxseSByZWxhdGVkIGJ1ZyBmaXggdGhhdCBjb25m
bGljdHMgaGVhdmlseSB3aXRoCj4+IHRoaXMgc2VyaWVzLCBzbyBJIHRhY2tlZCBpdCBvbiBoZXJl
Lgo+Pgo+PiBQYXRjaCAxNC8xNCBkb2N1bWVudHMgdGhlIGVtdWxhdGlvbiB0eXBlcy4gIEkgYWRk
ZWQgaXQgYXMgYSBzZXBhcmF0ZQo+PiBwYXRjaCBhdCB0aGUgdmVyeSBlbmQgc28gdGhhdCB0aGUg
Y29tbWVudHMgY291bGQgcmVmZXJlbmNlIHRoZSBmaW5hbAo+PiBzdGF0ZSBvZiB0aGUgY29kZSBi
YXNlLCBlLmcuIGluY29ycG9yYXRlIHRoZSBydWxlIGNoYW5nZSBmb3IgdXNpbmcKPj4gRU1VTFRZ
UEVfU0tJUCB0aGF0IGlzIGludHJvZHVjZWQgaW4gcGF0Y2ggMTMvMTQuCj4+Cj4+IHYxOgo+PiAg
ICAtIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvY292ZXIvMTExMTAzMzEvCj4+Cj4+IHYy
Ogo+PiAgICAtIENvbGxlY3QgcmV2aWV3cy4gW1ZpdGFseSBhbmQgTGlyYW5dCj4+ICAgIC0gU3F1
YXNoIFZNd2FyZSBlbXVsdHlwZSBjaGFuZ2VzIGludG8gYSBzaW5nbGUgcGF0Y2guIFtMaXJhbl0K
Pj4gICAgLSBBZGQgY29tbWVudHMgaW4gVk1YL1NWTSBmb3IgVk13YXJlICNHUCBoYW5kbGluZy4g
W1ZpdGFseV0KPj4gICAgLSBUYWNrIG9uIHRoZSBFUFQgbWlzY29uZmlnIGJ1ZyBmaXguCj4+ICAg
IC0gQWRkIGEgcGF0Y2ggdG8gY29tbWVudC9kb2N1bWVudCB0aGUgZW11bHR5cGVzLiBbTGlyYW5d
Cj4+Cj4+IFNlYW4gQ2hyaXN0b3BoZXJzb24gKDE0KToKPj4gICAgS1ZNOiB4ODY6IFJlbG9jYXRl
IE1NSU8gZXhpdCBzdGF0cyBjb3VudGluZwo+PiAgICBLVk06IHg4NjogQ2xlYW4gdXAgaGFuZGxl
X2VtdWxhdGlvbl9mYWlsdXJlKCkKPj4gICAgS1ZNOiB4ODY6IFJlZmFjdG9yIGt2bV92Y3B1X2Rv
X3NpbmdsZXN0ZXAoKSB0byByZW1vdmUgb3V0IHBhcmFtCj4+ICAgIEtWTTogeDg2OiBEb24ndCBh
dHRlbXB0IFZNV2FyZSBlbXVsYXRpb24gb24gI0dQIHdpdGggbm9uLXplcm8gZXJyb3IKPj4gICAg
ICBjb2RlCj4+ICAgIEtWTTogeDg2OiBNb3ZlICNHUCBpbmplY3Rpb24gZm9yIFZNd2FyZSBpbnRv
IHg4Nl9lbXVsYXRlX2luc3RydWN0aW9uKCkKPj4gICAgS1ZNOiB4ODY6IEFkZCBleHBsaWNpdCBm
bGFnIGZvciBmb3JjZWQgZW11bGF0aW9uIG9uICNVRAo+PiAgICBLVk06IHg4NjogTW92ZSAjVUQg
aW5qZWN0aW9uIGZvciBmYWlsZWQgZW11bGF0aW9uIGludG8gZW11bGF0aW9uIGNvZGUKPj4gICAg
S1ZNOiB4ODY6IEV4aXQgdG8gdXNlcnNwYWNlIG9uIGVtdWxhdGlvbiBza2lwIGZhaWx1cmUKPj4g
ICAgS1ZNOiB4ODY6IEhhbmRsZSBlbXVsYXRpb24gZmFpbHVyZSBkaXJlY3RseSBpbiBrdm1fdGFz
a19zd2l0Y2goKQo+PiAgICBLVk06IHg4NjogTW92ZSB0cmlwbGUgZmF1bHQgcmVxdWVzdCBpbnRv
IFJNIGludCBpbmplY3Rpb24KPj4gICAgS1ZNOiBWTVg6IFJlbW92ZSBFTVVMQVRFX0ZBSUwgaGFu
ZGxpbmcgaW4gaGFuZGxlX2ludmFsaWRfZ3Vlc3Rfc3RhdGUoKQo+PiAgICBLVk06IHg4NjogUmVt
b3ZlIGVtdWxhdGlvbl9yZXN1bHQgZW51bXMsIEVNVUxBVEVfe0RPTkUsRkFJTCxVU0VSX0VYSVR9
Cj4+ICAgIEtWTTogVk1YOiBIYW5kbGUgc2luZ2xlLXN0ZXAgI0RCIGZvciBFTVVMVFlQRV9TS0lQ
IG9uIEVQVCBtaXNjb25maWcKPj4gICAgS1ZNOiB4ODY6IEFkZCBjb21tZW50cyB0byBkb2N1bWVu
dCB2YXJpb3VzIGVtdWxhdGlvbiB0eXBlcwo+Pgo+PiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmggfCAgNDAgKysrKysrKy0tCj4+ICAgYXJjaC94ODYva3ZtL21tdS5jICAgICAgICAg
ICAgICB8ICAxNiArLS0tCj4+ICAgYXJjaC94ODYva3ZtL3N2bS5jICAgICAgICAgICAgICB8ICA2
MiArKysrKystLS0tLS0tLQo+PiAgIGFyY2gveDg2L2t2bS92bXgvdm14LmMgICAgICAgICAgfCAx
NDcgKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0KPj4gICBhcmNoL3g4Ni9rdm0veDg2
LmMgICAgICAgICAgICAgIHwgMTMzICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tCj4+ICAg
YXJjaC94ODYva3ZtL3g4Ni5oICAgICAgICAgICAgICB8ICAgMiArLQo+PiAgIDYgZmlsZXMgY2hh
bmdlZCwgMTk1IGluc2VydGlvbnMoKyksIDIwNSBkZWxldGlvbnMoLSkKPj4KPiAKPiBRdWV1ZWQs
IHRoYW5rcyAoYSBjb3VwbGUgY29uZmxpY3RzIGhhZCB0byBiZSBzb3J0ZWQgb3V0LCBidXQgbm90
aGluZwo+IHJlcXVpcmluZyBhIHJlc3BpbikuCgpVZ2gsIEkganVzdCBzdHVtYmxlZCBvdmVyIHRo
aXMgY29tbWl0LiBJcyB0aGlzIHJlYWxseSB0aGUgcmlnaHQgCmRpcmVjdGlvbiB0byBtb3ZlIHRv
d2FyZHM/CgpJIGFwcHJlY2lhdGUgdGhlIG1vdmUgdG8gcmVkdWNlIHRoZSBlbXVsYXRvciBsb2dp
YyBmcm9tIHRoZSBtYW55LWZvbGQgCmVudW0gaW50byBhIHNpbXBsZSBiaW5hcnkgIndvcmtlZCIg
b3IgIm5lZWRzIGEgdXNlciBzcGFjZSBleGl0Ii4gQnV0IGFyZSAKIjAiIGFuZCAiMSIgcmVhbGx5
IHRoZSByaWdodCBuYW1lcyBmb3IgdGhhdD8gSSBmaW5kIHRoZSByZWFkYWJpbGl0eSBvZiAKdGhl
IGN1cnJlbnQgaW50ZXJjZXB0IGhhbmRsZXJzIGJhZCBlbm91Z2gsIHRyaWNrbGluZyB0aGF0IGlu
dG8gZXZlbiBtb3JlIApjb2RlIHNvdW5kcyBsaWtlIGEgc2l0dWF0aW9uIHRoYXQgd2lsbCBkZWNy
ZWFzZSByZWFkYWJpbGl0eSBldmVuIG1vcmUuCgpXaHkgY2FuJ3Qgd2UganVzdCB1c2UgbmFtZXMg
dGhyb3VnaG91dD8gU29tZXRoaW5nIGxpa2UKCmVudW0ga3ZtX3JldHVybiB7CiAgICAgS1ZNX1JF
VF9VU0VSX0VYSVQgPSAwLAogICAgIEtWTV9SRVRfR1VFU1QgPSAxLAp9OwoKYW5kIHRoZW4gY29u
c2lzdGVudGx5IHVzZSB0aGVtIGFzIHJldHVybiB2YWx1ZXM/IFRoYXQgd2F5IGFueW9uZSB3aG8g
aGFzIApub3Qgd29ya2VkIG9uIGt2bSBiZWZvcmUgY2FuIHN0aWxsIG1ha2Ugc2Vuc2Ugb2YgdGhl
IGNvZGUuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApL
cmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4g
U2NobGFlZ2VyLCBSYWxmIEhlcmJyaWNoCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkg
MjM3IDg3OQoKCg==


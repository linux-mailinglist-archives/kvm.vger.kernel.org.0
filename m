Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE17C24C755
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 23:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgHTVtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 17:49:49 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:2525 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgHTVtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 17:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597960184; x=1629496184;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=AOaBEQbTlnOMdSpO3W+owf/evz+WPycEccGV0y18fBw=;
  b=f5iAiN5Srl6n0PomAasqSnIjHZ+JaP9lRvo8x7p8RCtl6ulDbV2AUJDa
   49wRyT23fpiTcNKLPEcqPi1jwlEhkiBScUcTx5FORHu5ouFVfSiw5XYny
   y580dC5NjYeoA9xakmTBg2TE/DGRE/aZwkQ/AOhzDfdYkdvzjW0etQRXR
   A=;
X-IronPort-AV: E=Sophos;i="5.76,334,1592870400"; 
   d="scan'208";a="48911359"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 20 Aug 2020 21:49:42 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 2C966A1808;
        Thu, 20 Aug 2020 21:49:41 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Aug 2020 21:49:40 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.71) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Aug 2020 21:49:39 +0000
Subject: Re: [PATCH v3 04/12] KVM: x86: Add ioctl for accepting a userspace
 provided MSR list
To:     Jim Mattson <jmattson@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-5-aaronlewis@google.com>
 <b8bbbd5d-9411-407d-7757-f31e1ee54ae2@amazon.com>
 <CALMp9eT5_zq52kzQjSM2gK=oQ1UMFNZhNgK0px=Y2FLzxHxqhA@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <c9ea8956-69e1-ae28-888a-06f230a84a53@amazon.com>
Date:   Thu, 20 Aug 2020 23:49:36 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eT5_zq52kzQjSM2gK=oQ1UMFNZhNgK0px=Y2FLzxHxqhA@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D02UWC002.ant.amazon.com (10.43.162.6) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgSmltLAoKT24gMjAuMDguMjAgMTk6MzAsIEppbSBNYXR0c29uIHdyb3RlOgo+IAo+IAo+IE9u
IFdlZCwgQXVnIDE5LCAyMDIwIGF0IDI6MDAgQU0gQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9u
LmNvbT4gd3JvdGU6Cj4gCj4+IFdoeSB3b3VsZCB3ZSBzdGlsbCBuZWVkIHRoaXMgd2l0aCB0aGUg
YWxsb3cgbGlzdCBhbmQgdXNlciBzcGFjZSAjR1AKPj4gZGVmbGVjdGlvbiBsb2dpYyBpbiBwbGFj
ZT8KPiAKPiBDb252ZXJzaW9uIHRvIGFuIGFsbG93IGxpc3QgaXMgY3VtYmVyc29tZSB3aGVuIHlv
dSBoYXZlIGEgc2hvcnQgZGVueQo+IGxpc3QuIFN1cHBvc2UgdGhhdCBJIHdhbnQgdG8gaW1wbGVt
ZW50IHRoZSBmb2xsb3dpbmcgZGVueSBsaXN0Ogo+IHtJQTMyX0FSQ0hfQ0FQQUJJTElUSUVTLCBI
Vl9YNjRfTVNSX1JFRkVSRU5DRV9UU0MsCj4gTVNSX0dPT0dMRV9UUlVFX1RJTUUsIE1TUl9HT09H
TEVfRkRSX1RSQUNFLCBNU1JfR09PR0xFX0hCSX0uIFdoYXQKPiB3b3VsZCB0aGUgY29ycmVzcG9u
ZGluZyBkZW55IGxpc3QgbG9vayBsaWtlPyBHaXZlbiB5b3VyIGN1cnJlbnQKPiBpbXBsZW1lbnRh
dGlvbiwgSSBkb24ndCB0aGluayB0aGUgY29ycmVzcG9uZGluZyBhbGxvdyBsaXN0IGNhbgo+IGFj
dHVhbGx5IGJlIGNvbnN0cnVjdGVkLiBJIHdhbnQgdG8gYWxsb3cgMl4zMi01IE1TUnMsIGJ1dCBJ
IGNhbiBhbGxvdwo+IGF0IG1vc3QgMTIyODgwLCBpZiBJJ3ZlIGRvbmUgdGhlIG1hdGggY29ycmVj
dGx5LiAoMTAgcmFuZ2VzLCBlYWNoCj4gc3Bhbm5pbmcgYXQgbW9zdCAweDYwMCBieXRlcyB3b3J0
aCBvZiBiaXRtYXAuKQoKVGhlcmUgYXJlIG9ubHkgdmVyeSBmZXcgTVNSIHJhbmdlcyB0aGF0IGFj
dHVhbGx5IGRhdGEuIFNvIGluIHlvdXIgY2FzZSwgCnRvIGFsbG93IGFsbCBNU1JzIHRoYXQgTGlu
dXgga25vd3MgYWJvdXQgaW4gbXNyLWluZGV4LmgsIHlvdSB3b3VsZCBuZWVkCgogICBbMHgwMDAw
MDAwMCAtIDB4MDAwMDIwMDBdCiAgIFsweDQwMDAwMDAwIC0gMHg0MDAwMDIwMF0KICAgWzB4NGI1
NjRkMDAgLSAweDRiNTY0ZTAwXQogICBbMHg4MDg2ODAwMCAtIDB4ODA4NjgwMjBdCiAgIFsweGMw
MDAwMDAwIC0gMHhjMDAwMDIwMF0KICAgWzB4YzAwMTAwMDAgLSAweGMwMDEyMDAwXQogICBbMHhj
MDAyMDAwMCAtIDB4YzAwMjAwMTBdCgp3aGljaCBhcmUgNyByZWdpb25zLiBGb3IgZ29vZCBtZWFz
dXJlLCB5b3UgY2FuIHByb2JhYmx5IHBhZCBldmVyeSBvbmUgb2YgCnRoZW0gdG8gdGhlIGZ1bGwg
MHgzMDAwIE1TUnMgdGhleSBjYW4gc3Bhbi4KCkZvciBNU1JzIHRoYXQgS1ZNIGFjdHVhbGx5IGhh
bmRsZXMgaW4ta2VybmVsIChvdGhlcnMgZG9uJ3QgbmVlZCB0byBiZSAKYWxsb3dlZCksIHRoZSBs
aXN0IHNocmlua3MgdG8gNToKCiAgIFsweDAwMDAwMDAwIC0gMHgwMDAwMTAwMF0KICAgWzB4NDAw
MDAwMDAgLSAweDQwMDAwMjAwXQogICBbMHg0YjU2NGQwMCAtIDB4NGI1NjRlMDBdCiAgIFsweGMw
MDAwMDAwIC0gMHhjMDAwMDIwMF0KICAgWzB4YzAwMTAwMDAgLSAweGMwMDEyMDAwXQoKTGV0J3Mg
ZXh0ZW5kIHRoZW0gYSBiaXQgdG8gbWFrZSByZWFzb25pbmcgZWFzaWVyOgoKICAgWzB4MDAwMDAw
MDAgLSAweDAwMDAzMDAwXQogICBbMHg0MDAwMDAwMCAtIDB4NDAwMDMwMDBdCiAgIFsweDRiNTY0
ZDAwIC0gMHg0YjU2NzAwMF0KICAgWzB4YzAwMDAwMDAgLSAweGMwMDAzMDAwXQogICBbMHhjMDAx
MDAwMCAtIDB4YzAwMTMwMDBdCgpXaGF0IGFyZSB0aGUgb2RkcyB0aGF0IHlvdSB3aWxsIHdhbnQg
dG8gaW1wbGljaXRseSAod2l0aG91dCBhIG5ldyBDQVAsIAp0aGF0IHdvdWxkIG5lZWQgdXNlciBz
cGFjZSBhZGp1c3RtZW50cyBhbnl3YXkpIGhhdmUgYSByYW5kb20gbmV3IE1TUiAKaGFuZGxlZCBp
bi1rZXJuZWwgd2l0aCBhbiBpZGVudGlmaWVyIHRoYXQgaXMgb3V0c2lkZSBvZiB0aG9zZSByYW5n
ZXM/CgpJJ20gZmFpcmx5IGNvbmZpZGVudCB0aGF0IHRyZW5kcyB0b3dhcmRzIDAuCgpUaGUgb25s
eSByZWFsIGRvd25zaWRlIEkgY2FuIHNlZSBpcyB0aGF0IHdlIGp1c3Qgd2FzdGVkIH44a2Igb2Yg
UkFNLiAKTm90aGluZyBJIHdvdWxkIHJlYWxseSBnZXQgaHVuZyB1cCBvbiB0aG91Z2guCgo+IFBl
cmhhcHMgd2Ugc2hvdWxkIGFkb3B0IGFsbG93L2RlbnkgcnVsZXMgc2ltaWxhciB0byB0aG9zZSBh
Y2NlcHRlZCBieQo+IG1vc3QgZmlyZXdhbGxzLiBJbnN0ZWFkIG9mIHBvcnRzLCB3ZSBoYXZlIE1T
UiBpbmRpY2VzLiBJbnN0ZWFkIG9mCj4gcHJvdG9jb2xzLCB3ZSBoYXZlIFJFQUQsIFdSSVRFLCBv
ciBSRUFEL1dSSVRFLiBTdXBwb3NlIHRoYXQgd2UKPiBzdXBwb3J0ZWQgdXAgdG8gPG4+IHJ1bGVz
IG9mIHRoZSBmb3JtOiB7c3RhcnQgaW5kZXgsIGVuZCBpbmRleCwgYWNjZXNzCj4gbW9kZXMsIGFs
bG93IG9yIGRlbnl9PyBSdWxlcyB3b3VsZCBiZSBwcm9jZXNzZWQgaW4gdGhlIG9yZGVyIGdpdmVu
LAo+IGFuZCB0aGUgZmlyc3QgcnVsZSB0aGF0IG1hdGNoZWQgYSBnaXZlbiBhY2Nlc3Mgd291bGQg
dGFrZSBwcmVjZWRlbmNlLgo+IEZpbmFsbHksIHVzZXJzcGFjZSBjb3VsZCBzcGVjaWZ5IHRoZSBk
ZWZhdWx0IGJlaGF2aW9yIChlaXRoZXIgYWxsb3cgb3IKPiBkZW55KSBmb3IgYW55IE1TUiBhY2Nl
c3MgdGhhdCBkaWRuJ3QgbWF0Y2ggYW55IG9mIHRoZSBydWxlcy4KPiAKPiBUaG91Z2h0cz8KClRo
YXQgd291bGRuJ3Qgc2NhbGUgd2VsbCBpZiB5b3Ugd2FudCB0byBhbGxvdyBhbGwgYXJjaGl0ZWN0
dXJhbGx5IHVzZWZ1bCAKTVNScyBpbiBhIHB1cmVseSBhbGxvdyBsaXN0IGZhc2hpb24uIFlvdSdk
IGhhdmUgdG8gY3JlYXRlIGh1bmRyZWRzIG9mIApydWxlcyAtIG9yIGF0IGxlYXN0IGEgZmV3IGRv
emVuIGlmIHlvdSBjb21iaW5lIGNvbnRpZ3VvdXMgcmFuZ2VzLgoKSWYgeW91IHJlYWxseSBkZXNw
ZXJhdGVseSBiZWxpZXZlIGEgZGVueSBsaXN0IGlzIGEgYmV0dGVyIGZpdCBmb3IgeW91ciAKdXNl
IGNhc2UsIHdlIGNvdWxkIHJlZGVzaWduIHRoZSBpbnRlcmZhY2UgZGlmZmVyZW50bHk6CgpzdHJ1
Y3QgbXNyX3NldF9hY2Nlc3NsaXN0IHsKI2RlZmluZSBNU1JfQUNDRVNTTElTVF9ERUZBVUxUX0FM
TE9XIDAKI2RlZmluZSBNU1JfQUNDRVNTTElTVF9ERUZBVUxUX0RFTlkgIDEKICAgICB1MzIgZmxh
Z3M7CiAgICAgc3RydWN0IHsKICAgICAgICAgdTMyIGZsYWdzOwogICAgICAgICB1MzIgbm1zcnM7
IC8qIE1TUnMgaW4gYml0bWFwICovCiAgICAgICAgIHUzMiBiYXNlOyAvKiBmaXJzdCBNU1IgYWRk
cmVzcyB0byBiaXRtYXAgKi8KICAgICAgICAgdm9pZCAqYml0bWFwOyAvKiBwb2ludGVyIHRvIGJp
dG1hcCwgMSBtZWFucyBhbGxvdywgMCBkZW55ICovCiAgICAgfSBsaXN0c1sxMF07Cn07Cgp3aGlj
aCBtZWFucyBpbiB5b3VyIHVzZSBjYXNlLCB5b3UgY2FuIGRvCgp1NjQgZGVueSA9IDA7CnN0cnVj
dCBtc3Jfc2V0X2FjY2Vzc2xpc3QgYWNjZXNzID0gewogICAgIC5mbGFncyA9IE1TUl9BQ0NFU1NM
SVNUX0RFRkFVTFRfQUxMT1csCiAgICAgLmxpc3RzID0gewogICAgICAgICB7CiAgICAgICAgICAg
ICAubm1zcnMgPSAxLAogICAgICAgICAgICAgLmJhc2UgPSBJQTMyX0FSQ0hfQ0FQQUJJTElUSUVT
LAogICAgICAgICAgICAgLmJpdG1hcCA9ICZkZW55LAogICAgICAgICB9LCB7CiAgICAgICAgIHsK
ICAgICAgICAgICAgIC5ubXNycyA9IDEsCiAgICAgICAgICAgICAuYmFzZSA9IEhWX1g2NF9NU1Jf
UkVGRVJFTkNFX1RTQywKICAgICAgICAgICAgIC5iaXRtYXAgPSAmZGVueSwKICAgICAgICAgfSwg
ewogICAgICAgICB7CiAgICAgICAgICAgICAubm1zcnMgPSAxLAogICAgICAgICAgICAgLyogY2Fu
IHByb2JhYmx5IGJlIGNvbWJpbmVkIHdpdGggdGhlIG9uZXMgYmVsb3c/ICovCiAgICAgICAgICAg
ICAuYmFzZSA9IE1TUl9HT09HTEVfVFJVRV9USU1FLAogICAgICAgICAgICAgLmJpdG1hcCA9ICZk
ZW55LAogICAgICAgICB9LCB7CiAgICAgICAgIHsKICAgICAgICAgICAgIC5ubXNycyA9IDEsCiAg
ICAgICAgICAgICAuYmFzZSA9IE1TUl9HT09HTEVfRkRSX1RSQUNFLAogICAgICAgICAgICAgLmJp
dG1hcCA9ICZkZW55LAogICAgICAgICB9LCB7CiAgICAgICAgIHsKICAgICAgICAgICAgIC5ubXNy
cyA9IDEsCiAgICAgICAgICAgICAuYmFzZSA9IE1TUl9HT09HTEVfSEJJLAogICAgICAgICAgICAg
LmJpdG1hcCA9ICZkZW55LAogICAgICAgICB9LAogICAgIH0KfTsKCm1zcl9zZXRfYWNjZXNzbGlz
dChrdm1fZmQsICZhY2Nlc3MpOwoKd2hpbGUgSSBjYW4gZG8gdGhlIHNhbWUgZGFuY2UgYXMgYmVm
b3JlLCBidXQgd2l0aCBhIHNpbmdsZSBjYWxsIHJhdGhlciAKdGhhbiBtdWx0aXBsZSBvbmVzLgoK
V2hhdCBkbyB5b3UgdGhpbms/CgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdl
cm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5n
OiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRz
Z2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVz
dC1JRDogREUgMjg5IDIzNyA4NzkKCgo=


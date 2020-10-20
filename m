Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63E293892
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 11:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404790AbgJTJzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 05:55:20 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:14009 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404577AbgJTJzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 05:55:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1603187719; x=1634723719;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=/DxSLhphaBCVEkABHTKTdeogLf9sDq3PuegJ5sNW2kk=;
  b=N9dd7eLFVCdbAMGYkuUnf7hqv6pwX/5sjGSCUDSSLXKwhRjDYbTEIlI1
   tWlqnh5jgNOCy8GkpuyDM/B26sTStD13b8MgJ9EJ0UbVHZ12qBuNNTa/v
   AaK91dHT5+eDBY32wSYkmxxtZQDRIV6Fz+ulwlSrY4iX46xue3UtKe2Yu
   4=;
X-IronPort-AV: E=Sophos;i="5.77,396,1596499200"; 
   d="scan'208";a="60319327"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 20 Oct 2020 09:55:12 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id E637EA2330;
        Tue, 20 Oct 2020 09:55:04 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 09:55:04 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.71) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 09:54:58 +0000
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>
CC:     Willy Tarreau <w@1wt.eu>, Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, <oridgar@gmail.com>,
        <ghammer@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Qemu Developers" <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        "Michal Hocko" <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Pavel Machek" <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>, <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu>
 <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com>
 <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu>
 <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu>
 <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
 <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
 <aacdff7a-2af1-4f46-6ab2-2a9d5b865d35@amazon.de>
 <2e505365-db4a-6054-8bc8-f9a81978c6d4@de.ibm.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <b2f8ecec-35e8-93c6-b4cb-bb89ee8baa2d@amazon.de>
Date:   Tue, 20 Oct 2020 11:54:56 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <2e505365-db4a-6054-8bc8-f9a81978c6d4@de.ibm.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D04UWA002.ant.amazon.com (10.43.160.31) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDIwLjEwLjIwIDExOjM1LCBDaHJpc3RpYW4gQm9ybnRyYWVnZXIgd3JvdGU6Cj4gT24gMTcu
MTAuMjAgMjA6MDksIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+PiBIaSBKYXNvbiwKPj4KPj4gT24g
MTcuMTAuMjAgMTU6MjQsIEphc29uIEEuIERvbmVuZmVsZCB3cm90ZToKPj4+Cj4+PiBBZnRlciBk
aXNjdXNzaW5nIHRoaXMgb2ZmbGluZSB3aXRoIEphbm4gYSBiaXQsIEkgaGF2ZSBhIGZldyBnZW5l
cmFsCj4+PiBjb21tZW50cyBvbiB0aGUgZGVzaWduIG9mIHRoaXMuCj4+Pgo+Pj4gRmlyc3QsIHRo
ZSBVVUlEIGNvbW11bmljYXRlZCBieSB0aGUgaHlwZXJ2aXNvciBzaG91bGQgYmUgY29uc3VtZWQg
YnkKPj4+IHRoZSBrZXJuZWwgLS0gYWRkZWQgYXMgYW5vdGhlciBpbnB1dCB0byB0aGUgcm5nIC0t
IGFuZCB0aGVuIHVzZXJzcGFjZQo+Pgo+PiBXZSBkZWZpbml0ZWx5IHdhbnQgYSBrZXJuZWwgaW50
ZXJuYWwgbm90aWZpZXIgYXMgd2VsbCwgeWVzIDopLgo+Pgo+Pj4gc2hvdWxkIGJlIG5vdGlmaWVk
IHRoYXQgaXQgc2hvdWxkIHJlc2VlZCBhbnkgdXNlcnNwYWNlIFJOR3MgdGhhdCBpdAo+Pj4gbWF5
IGhhdmUsIHdpdGhvdXQgYWN0dWFsbHkgY29tbXVuaWNhdGluZyB0aGF0IFVVSUQgdG8gdXNlcnNw
YWNlLiBJT1csCj4+Cj4+IEkgYWxzbyB0ZW5kIHRvIGFncmVlIHRoYXQgaXQgbWFrZXMgc2Vuc2Ug
dG8gZGlzY29ubmVjdCB0aGUgYWN0dWFsIFVVSUQgd2UgcmVjZWl2ZSBmcm9tIHRoZSBub3RpZmlj
YXRpb24gdG8gdXNlciBzcGFjZS4gVGhpcyB3b3VsZCBhbGxvdyB1cyB0byBjcmVhdGUgYSBnZW5l
cmljIG1lY2hhbmlzbSBmb3IgVk0gc2F2ZS9yZXN0b3JlIGN5Y2xlcyBhY3Jvc3MgZGlmZmVyZW50
IGh5cGVydmlzb3JzLiBMZXQgbWUgYWRkIFBQQyBhbmQgczM5MHggcGVvcGxlIHRvIHRoZSBDQyBs
aXN0IHRvIHNlZSB3aGV0aGVyIHRoZXkgaGF2ZSBhbnl0aGluZyByZW1vdGVseSBzaW1pbGFyIHRv
IHRoZSBWbUdlbklEIG1lY2hhbmlzbS4gRm9yIHg4NiBhbmQgYWFyY2g2NCwgdGhlIEFDUEkgYW5k
IG1lbW9yeSBiYXNlZCBWbUdlbklEIGltcGxlbWVudGVkIGhlcmUgaXMgdGhlIG1vc3Qgb2J2aW91
cyBvcHRpb24gdG8gaW1wbGVtZW50IElNSE8uIEl0J3MgYWxzbyBhbHJlYWR5IGltcGxlbWVudGVk
IGluIGFsbCBtYWpvciBoeXBlcnZpc29ycy4KPiAKPiBIbW0sIHdoYXQgd2UgZG8gaGF2ZSBjb25m
aWd1cmF0aW9ucyAoZS5nLiBzdGZsZSBiaXRzKSBhbmQgd2UgZG8gaGF2ZSBhIG5vdGlmaWNhdGlv
biBtZWNoYW5pc20gdmlhIHNjbHAgdGhhdCBub3RpZmllcyBndWVzdHMgd2hlbiB0aGluZ3MgY2hh
bmdlLgo+IEFzIG9mIHRvZGF5IG5laXRoZXIgS1ZNIG5vciBMaW51eCBpbXBsZW1lbnQgdGhlIHNj
bHAgY2hhbmdlIG5vdGlmaWNhdGlvbiBtZWNoYW5pc20sIGJ1dCBJIGRvIHNlZSB2YWx1ZSBpbiBz
dWNoIGEgdGhpbmcuCgpzdGZsZSBvbmx5IHN0b3JlcyBhcmNoaXRlY3RlZCBDUFUgY2FwYWJpbGl0
aWVzLCBubz8gVGhlIFVVSUQgaXMgYWJvdXQgCnVuaXF1ZWx5IGlkZW50aWZ5aW5nIGNsb25lcyBv
ZiB0aGUgc2FtZSBiYXNlIGltYWdlLCBzbyB0aGV5IGNhbiAKcmVlc3RhYmxpc2ggdGhlaXIgdW5p
cXVlbmVzcy4KClRoYXQgc2FpZCwgeW91ciBpbnRlcmVzdCBtZWFucyB0aGF0IHRoZXJlIG1heSBi
ZSBhIG1lY2hhbmlzbSBvbiBzMzkwIG9uZSAKZGF5LCBzbyB3ZSBzaG91bGQgdGhpbmsgYWJvdXQg
bWFraW5nIGl0IG1vcmUgZ2VuZXJpYy4KCj4gCj4+Cj4+PiBJIGFncmVlIHdpdGggSmFubiB0aGVy
ZS4gVGhlbiwgaXQncyB0aGUgZnVuY3Rpb25pbmcgb2YgdGhpcwo+Pj4gbm90aWZpY2F0aW9uIG1l
Y2hhbmlzbSB0byB1c2Vyc3BhY2UgdGhhdCBpcyBpbnRlcmVzdGluZyB0byBtZS4KPj4KPj4gQWJz
b2x1dGVseSEgUGxlYXNlIGhhdmUgYSBsb29rIGF0IHRoZSBwcmV2aW91cyBkaXNjdXNzaW9uIGhl
cmU6Cj4+Cj4+Cj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXBtL0I3NzkzQjdBLTM2
NjAtNDc2OS05QjlBLUZGQ0YyNTA3MjhCQkBhbWF6b24uY29tLwo+Pgo+PiBUaGUgdXNlciBzcGFj
ZSBpbnRlcmZhY2UgaXMgYWJzb2x1dGVseSB3aGF0IHRoaXMgaXMgYWJvdXQuCj4gCj4gWWVzLiBQ
YXNzaW5nIGEgbm90aWZpY2F0aW9uIHRvIHVzZXJzcGFjZSBpcyBlc3NlbnRpYWwuIFdoZXJlIEkg
ZG8gbm90IHNlZSBhIHNvbHV0aW9uIHlldCBpcyB0aGUgcmFjZSBiZXR3ZWVuIG5vdGlmaWNhdGlv
biBhbmQKPiBhbHJlYWR5IHJ1bm5pbmcgd2l0aCB0aGUgb2xkIGtub3dsZWRnZS4KCldpdGggYSBw
b3N0LW1vcnRlbSBpbnRlcmZhY2UsIHdlIHdpbGwgYWx3YXlzIGhhdmUgYSB0aW55IHJhY2Ugd2lu
ZG93LiAKSSdtIG5vdCByZWFsbHkgY29udmluY2VkIHRoYXQgdGhpcyBpcyBhIHNlcmlvdXMgcHJv
YmxlbSB5ZXQgdGhvdWdoLgoKSW4gb3JkZXIgdG8gZG8gZXh0cmFjdCBhbnl0aGluZyBvZmYgYSB2
aXJ0dWFsIG1hY2hpbmUgdGhhdCB3YXMgY2xvbmVkLCAKeW91IG5lZWQgdG8gY29tbXVuaWNhdGUg
d2l0aCBpdC4gSWYgeW91IGZvciBleGFtcGxlIHN0b3AgdGhlIG5ldHdvcmsgCmxpbmsgdW50aWwg
YWxsIG9mIHRoaXMgZGV2aWNlJ3MgdXNlcnMgaGF2ZSBpbmRpY2F0ZWQgdGhleSBhcmUgZmluaXNo
ZWQgCmFkanVzdGluZywgdGhlIHJhY2Ugc2hvdWxkIGJlIHNtYWxsIGVub3VnaCBmb3IgYW55IHBy
YWN0aWNhbCBwdXJwb3NlcyBJIApjYW4gdGhpbmsgb2YuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxv
cG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2Vz
Y2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5n
ZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIK
U2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=


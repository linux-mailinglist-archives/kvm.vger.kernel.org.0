Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49E12B92D9
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 13:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgKSMvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 07:51:43 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:56083 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgKSMvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 07:51:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1605790302; x=1637326302;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=seGsIDsNhmWuP2Cjs6gFXzfbcZ1elM5hlAecchVtBF4=;
  b=vwCrC9btAp/7cFGB17DVQTGPT3PMtfX25WPRDCTErwtC0XEYeMDpWE7B
   W6kQFMFeGHogoX34xl3kSKclisxk1qQDZQKLBXSSahZH/hhu4g48y2v6N
   4kcdCKyqd5Az29oiOI3LqCclqQdcWHxe/72VFMj7lZ4YYixBiR1j5ZiWB
   w=;
X-IronPort-AV: E=Sophos;i="5.77,490,1596499200"; 
   d="scan'208";a="67415804"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 Nov 2020 12:51:32 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 9D0B6A1CCD;
        Thu, 19 Nov 2020 12:51:29 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 12:51:29 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.146) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 12:51:20 +0000
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>
CC:     Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        "Eric Biggers" <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Qemu Developers" <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        "Michal Hocko" <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Pavel Machek" <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        "Pavel Emelyanov" <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        "Mike Rapoport" <rppt@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <300d4404-3efe-880e-ef30-692eabbff5f7@de.ibm.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <da1a1fa7-a1de-d0e6-755b-dd587687765e@amazon.de>
Date:   Thu, 19 Nov 2020 13:51:18 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <300d4404-3efe-880e-ef30-692eabbff5f7@de.ibm.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D41UWB004.ant.amazon.com (10.43.161.135) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOS4xMS4yMCAxMzowMiwgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyIHdyb3RlOgo+IAo+IE9u
IDE2LjExLjIwIDE2OjM0LCBDYXRhbmdpdSwgQWRyaWFuIENvc3RpbiB3cm90ZToKPj4gLSBCYWNr
Z3JvdW5kCj4+Cj4+IFRoZSBWTSBHZW5lcmF0aW9uIElEIGlzIGEgZmVhdHVyZSBkZWZpbmVkIGJ5
IE1pY3Jvc29mdCAocGFwZXI6Cj4+IGh0dHA6Ly9nby5taWNyb3NvZnQuY29tL2Z3bGluay8/TGlu
a0lkPTI2MDcwOSkgYW5kIHN1cHBvcnRlZCBieQo+PiBtdWx0aXBsZSBoeXBlcnZpc29yIHZlbmRv
cnMuCj4+Cj4+IFRoZSBmZWF0dXJlIGlzIHJlcXVpcmVkIGluIHZpcnR1YWxpemVkIGVudmlyb25t
ZW50cyBieSBhcHBzIHRoYXQgd29yawo+PiB3aXRoIGxvY2FsIGNvcGllcy9jYWNoZXMgb2Ygd29y
bGQtdW5pcXVlIGRhdGEgc3VjaCBhcyByYW5kb20gdmFsdWVzLAo+PiB1dWlkcywgbW9ub3Rvbmlj
YWxseSBpbmNyZWFzaW5nIGNvdW50ZXJzLCBldGMuCj4+IFN1Y2ggYXBwcyBjYW4gYmUgbmVnYXRp
dmVseSBhZmZlY3RlZCBieSBWTSBzbmFwc2hvdHRpbmcgd2hlbiB0aGUgVk0KPj4gaXMgZWl0aGVy
IGNsb25lZCBvciByZXR1cm5lZCB0byBhbiBlYXJsaWVyIHBvaW50IGluIHRpbWUuCj4+Cj4+IFRo
ZSBWTSBHZW5lcmF0aW9uIElEIGlzIGEgc2ltcGxlIGNvbmNlcHQgbWVhbnQgdG8gYWxsZXZpYXRl
IHRoZSBpc3N1ZQo+PiBieSBwcm92aWRpbmcgYSB1bmlxdWUgSUQgdGhhdCBjaGFuZ2VzIGVhY2gg
dGltZSB0aGUgVk0gaXMgcmVzdG9yZWQKPj4gZnJvbSBhIHNuYXBzaG90LiBUaGUgaHcgcHJvdmlk
ZWQgVVVJRCB2YWx1ZSBjYW4gYmUgdXNlZCB0bwo+PiBkaWZmZXJlbnRpYXRlIGJldHdlZW4gVk1z
IG9yIGRpZmZlcmVudCBnZW5lcmF0aW9ucyBvZiB0aGUgc2FtZSBWTS4KPj4KPj4gLSBQcm9ibGVt
Cj4+Cj4+IFRoZSBWTSBHZW5lcmF0aW9uIElEIGlzIGV4cG9zZWQgdGhyb3VnaCBhbiBBQ1BJIGRl
dmljZSBieSBtdWx0aXBsZQo+PiBoeXBlcnZpc29yIHZlbmRvcnMgYnV0IG5laXRoZXIgdGhlIHZl
bmRvcnMgb3IgdXBzdHJlYW0gTGludXggaGF2ZSBubwo+PiBkZWZhdWx0IGRyaXZlciBmb3IgaXQg
bGVhdmluZyB1c2VycyB0byBmZW5kIGZvciB0aGVtc2VsdmVzLgo+IAo+IEkgc2VlIHRoYXQgdGhl
IHFlbXUgaW1wbGVtZW50YXRpb24gaXMgc3RpbGwgdW5kZXIgZGlzY3Vzc2lvbi4gV2hhdCBpcwoK
VWgsIHRoZSBBQ1BJIFZtZ2VuaWQgZGV2aWNlIGVtdWxhdGlvbiBpcyBpbiBRRU1VIHNpbmNlIDIu
OS4wIDopLgoKPiB0aGUgc3RhdHVzIG9mIHRoZSBvdGhlciBleGlzdGluZyBpbXBsZW1lbnRhdGlv
bnMuIERvIHRoZXkgYWxyZWFkeSBleGlzdD8KPiBJbiBvdGhlciB3b3JkcyBpcyBBQ1BJIGEgZ2l2
ZW4/Cj4gSSB0aGluayB0aGUgbWFqb3JpdHkgb2YgdGhpcyBkcml2ZXIgY291bGQgYmUgdXNlZCB3
aXRoIGp1c3QgYSBkaWZmZXJlbnQKPiBiYWNrZW5kIGZvciBwbGF0Zm9ybXMgd2l0aG91dCBBQ1BJ
IHNvIGluIGFueSBjYXNlIHdlIGNvdWxkIGZhY3RvciBvdXQKPiB0aGUgYmFja2VuZCAoYWNwaSwg
dmlydGlvLCB3aGF0ZXZlcikgYnV0IGlmIHdlIGFyZSBvcGVuIHdlIGNvdWxkIG1heWJlCj4gc3Rh
cnQgd2l0aCBzb21ldGhpbmcgZWxzZS4KCkkgYWdyZWUgMTAwJS4gSSBkb24ndCB0aGluayB3ZSBy
ZWFsbHkgbmVlZCBhIG5ldyBmcmFtZXdvcmsgaW4gdGhlIGtlcm5lbCAKZm9yIHRoYXQuIFdlIGNh
biBqdXN0IGhhdmUgZm9yIGV4YW1wbGUgYW4gczM5MHggc3BlY2lmaWMgZHJpdmVyIHRoYXQgCmFs
c28gcHJvdmlkZXMgdGhlIHNhbWUgbm90aWZpY2F0aW9uIG1lY2hhbmlzbSB0aHJvdWdoIGEgZGV2
aWNlIG5vZGUgdGhhdCAKaXMgYWxzbyBuYW1lZCAiL2Rldi92bWdlbmlkIiwgbm8/CgpPciBhbHRl
cm5hdGl2ZWx5IHdlIGNhbiBzcGxpdCB0aGUgZ2VuZXJpYyBwYXJ0IG9mIHRoaXMgZHJpdmVyIGFz
IHNvb24gYXMgCmEgc2Vjb25kIG9uZSBjb21lcyBhbG9uZyBhbmQgdGhlbiBoYXZlIGJvdGggZHJp
dmVyIGluY2x1ZGUgdGhhdCBnZW5lcmljIApsb2dpYy4KClRoZSBvbmx5IHBpZWNlIHdoZXJlIEkn
bSB1bnN1cmUgaXMgaG93IHRoaXMgd2lsbCBpbnRlcmFjdCB3aXRoIENSSVUuIENhbiAKY29udGFp
bmVycyBlbXVsYXRlIGlvY3RscyBhbmQgZGV2aWNlIG5vZGVzPwoKCkFsZXgKCgoKQW1hem9uIERl
dmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGlu
Ckdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MK
RWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3
MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK


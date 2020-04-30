Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF61BF688
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 13:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgD3LVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 07:21:20 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:22570 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgD3LVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 07:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588245677; x=1619781677;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=98FUj36SL/vRPPmJ6RhDdsR9YKDkvsJ4y8WUGm+k+nU=;
  b=s9si9XuuMSaZueE8GXiOzniTnxyh8+s95SFMZPT0z+uHsvS3zb4hxe5q
   lJokSdOUSrkosWsmVBucZ37nRUAYeTEpV0jYr/MMFohsjolc3gsDPedmB
   dXv+JTHH3R1l7S9jqPiRqzR3uvx8FxSsy4rIJDYTiLn+L5EpxZV/KXh+o
   4=;
IronPort-SDR: 54WCQPmgzSp5u/PSaYU3Xckd8gaq8DMj6y/GMRRGAGzaepn93sAq5JE8K1LWkpvEXDfcQwjlHI
 0nKbOl6qDFlQ==
X-IronPort-AV: E=Sophos;i="5.73,334,1583193600"; 
   d="scan'208";a="32097944"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 30 Apr 2020 11:21:15 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id B8178A21CD;
        Thu, 30 Apr 2020 11:21:14 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 11:21:14 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.203) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Apr 2020 11:21:10 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
 <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
 <80489572-72a1-dbe7-5306-60799711dae0@amazon.com>
 <0467ce02-92f3-8456-2727-c4905c98c307@redhat.com>
 <5f8de7da-9d5c-0115-04b5-9f08be0b34b0@amazon.com>
 <095e3e9d-c9e5-61d0-cdfc-2bb099f02932@redhat.com>
 <602565db-d9a6-149a-0e1a-fe9c14a90ce7@amazon.com>
 <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
 <0a4c7a95-af86-270f-6770-0a283cec30df@amazon.com>
 <0c919928-00ed-beda-e984-35f7b6ca42fb@redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <702b2eaa-e425-204e-e19d-649282bfe170@amazon.com>
Date:   Thu, 30 Apr 2020 13:21:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0c919928-00ed-beda-e984-35f7b6ca42fb@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D22UWB003.ant.amazon.com (10.43.161.76) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMC4wNC4yMCAxMjozNCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiAKPiBPbiAyOC8wNC8y
MCAxNzowNywgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Cj4+IFdoeSBkb24ndCB3ZSBidWlsZCBz
b21ldGhpbmcgbGlrZSB0aGUgZm9sbG93aW5nIGluc3RlYWQ/Cj4+Cj4+ICAgIHZtID0gbmVfY3Jl
YXRlKHZjcHVzID0gNCkKPj4gICAgbmVfc2V0X21lbW9yeSh2bSwgaHZhLCBsZW4pCj4+ICAgIG5l
X2xvYWRfaW1hZ2Uodm0sIGFkZHIsIGxlbikKPj4gICAgbmVfc3RhcnQodm0pCj4+Cj4+IFRoYXQg
d2F5IHdlIHdvdWxkIGdldCB0aGUgRUlGIGxvYWRpbmcgaW50byBrZXJuZWwgc3BhY2UuICJMT0FE
X0lNQUdFIgo+PiB3b3VsZCBvbmx5IGJlIGF2YWlsYWJsZSBpbiB0aGUgdGltZSB3aW5kb3cgYmV0
d2VlbiBzZXRfbWVtb3J5IGFuZCBzdGFydC4KPj4gSXQgYmFzaWNhbGx5IGltcGxlbWVudHMgYSBt
ZW1jcHkoKSwgYnV0IGl0IHdvdWxkIGNvbXBsZXRlbHkgaGlkZSB0aGUKPj4gaGlkZGVuIHNlbWFu
dGljcyBvZiB3aGVyZSBhbiBFSUYgaGFzIHRvIGdvLCBzbyBmdXR1cmUgZGV2aWNlIHZlcnNpb25z
Cj4+IChvciBldmVuIG90aGVyIGVuY2xhdmUgaW1wbGVtZW50ZXJzKSBjb3VsZCBjaGFuZ2UgdGhl
IGxvZ2ljLgo+IAo+IENhbiB3ZSBhZGQgYSBmaWxlIGZvcm1hdCBhcmd1bWVudCBhbmQgZmxhZ3Mg
dG8gbmVfbG9hZF9pbWFnZSwgdG8gYXZvaWQKPiBoYXZpbmcgYSB2MiBpb2N0bCBsYXRlcj8KCkkg
dGhpbmsgZmxhZ3MgYWxvbmcgc2hvdWxkIGJlIGVub3VnaCwgbm8/IEEgbmV3IGZvcm1hdCB3b3Vs
ZCBqdXN0IGJlIGEgZmxhZy4KClRoYXQgc2FpZCwgYW55IG9mIHRoZSBjb21tYW5kcyBhYm92ZSBz
aG91bGQgaGF2ZSBmbGFncyBJTUhPLgoKPiBBbHNvLCB3b3VsZCB5b3UgY29uc2lkZXIgYSBtb2Rl
IHdoZXJlIG5lX2xvYWRfaW1hZ2UgaXMgbm90IGludm9rZWQgYW5kCj4gdGhlIGVuY2xhdmUgc3Rh
cnRzIGluIHJlYWwgbW9kZSBhdCAweGZmZmZmZjA/CgpDb25zaWRlciwgc3VyZS4gQnV0IEkgZG9u
J3QgcXVpdGUgc2VlIGFueSBiaWcgYmVuZWZpdCBqdXN0IHlldC4gVGhlIApjdXJyZW50IGFic3Ry
YWN0aW9uIGxldmVsIGZvciB0aGUgYm9vdGVkIHBheWxvYWRzIGlzIG11Y2ggaGlnaGVyLiBUaGF0
IAphbGxvd3MgdXMgdG8gc2ltcGxpZnkgdGhlIGRldmljZSBtb2RlbCBkcmFtYXRpY2FsbHk6IFRo
ZXJlIGlzIG5vIG5lZWQgdG8gCmNyZWF0ZSBhIHZpcnR1YWwgZmxhc2ggcmVnaW9uIGZvciBleGFt
cGxlLgoKSW4gYWRkaXRpb24sIGJ5IG1vdmluZyBmaXJtd2FyZSBpbnRvIHRoZSB0cnVzdGVkIGJh
c2UsIGZpcm13YXJlIGNhbiAKZXhlY3V0ZSB2YWxpZGF0aW9uIG9mIHRoZSB0YXJnZXQgaW1hZ2Uu
IElmIHlvdSBtYWtlIGl0IGFsbCBmbGF0LCBob3cgZG8gCnlvdSB2ZXJpZnkgd2hldGhlciB3aGF0
IHlvdSdyZSBib290aW5nIGlzIHdoYXQgeW91IHRoaW5rIHlvdSdyZSBib290aW5nPwoKU28gaW4g
YSBudXRzaGVsbCwgZm9yIGEgUFYgdmlydHVhbCBtYWNoaW5lIHNwYXduaW5nIGludGVyZmFjZSwg
SSB0aGluayAKaXQgd291bGQgbWFrZSBzZW5zZSB0byBoYXZlIG1lbW9yeSBmdWxseSBvd25lZCBi
eSB0aGUgcGFyZW50LiBJbiB0aGUgCmVuY2xhdmUgd29ybGQsIEkgd291bGQgcmF0aGVyIG5vdCBs
aWtlIHRvIGdpdmUgdGhlIHBhcmVudCB0b28gbXVjaCAKY29udHJvbCBvdmVyIHdoYXQgbWVtb3J5
IGFjdHVhbGx5IG1lYW5zLCBvdXRzaWRlIG9mIGRvbmF0aW5nIGEgYnVja2V0IG9mIGl0LgoKCkFs
ZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4g
MzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwg
Sm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcg
dW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579E41F38A4
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgFIKuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 06:50:08 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:47935 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgFIKri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 06:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1591699658; x=1623235658;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=d8gMaNNmximhyQzG6Kal58H6sh8+EGIvUeK+r0l4uhw=;
  b=DspMUEnik5GLo3FFXW6z58Xu7H/Ti6PHGmmdE+iglBYgA/94VkqNy4TY
   b0G6HUrA7Lc8L8ushOdtpKwS25GZ1Lhw98BajI/2zx/VffKMH/CqHB6VX
   2NDbomAhDBDkdjG+ZQNj8KiE1NkaZ/kUl6izCxbIJlMLI4xOdcLR4FO0c
   o=;
IronPort-SDR: kq+seaYbxzGfg3eMe4BizMCjWNXOpeOl06/slLYLaSvA8UKmf7nG/PXJctyulywzbmoVFVMmXp
 E0eg/OFLSBWw==
X-IronPort-AV: E=Sophos;i="5.73,491,1583193600"; 
   d="scan'208";a="36584521"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 09 Jun 2020 10:47:36 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 2BDAFA23B0;
        Tue,  9 Jun 2020 10:47:34 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 10:47:34 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.208) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Jun 2020 10:47:29 +0000
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
 <20200526123300.GA2798@kroah.com>
 <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
 <20200526131708.GA9296@kroah.com>
 <29ebdc29-2930-51af-8a54-279c1e449a48@amazon.de>
 <20200526222402.GC179549@kroah.com>
 <b4f17cbd-7471-fe61-6e7e-1399bd96e24e@amazon.de>
 <20200528131259.GA3345766@kroah.com>
 <a37b0156c076d3875f906e970071cb230e526df1.camel@kernel.crashing.org>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <f83838cf-8a20-8c9c-be87-4c6625563bd6@amazon.de>
Date:   Tue, 9 Jun 2020 12:47:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <a37b0156c076d3875f906e970071cb230e526df1.camel@kernel.crashing.org>
Content-Language: en-US
X-Originating-IP: [10.43.162.208]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwMS4wNi4yMCAwNTowNCwgQmVuamFtaW4gSGVycmVuc2NobWlkdCB3cm90ZToKPiAKPiAK
PiBPbiBUaHUsIDIwMjAtMDUtMjggYXQgMTU6MTIgKzAyMDAsIEdyZWcgS0ggd3JvdGU6Cj4+IFNv
IGF0IHJ1bnRpbWUsIGFmdGVyIGFsbCBpcyBib290ZWQgYW5kIHVwIGFuZCBnb2luZywgeW91IGp1
c3QgcmlwcGVkCj4+IGNvcmVzIG91dCBmcm9tIHVuZGVyIHNvbWVvbmUncyBmZWV0PyAgOikKPj4K
Pj4gQW5kIHRoZSBjb2RlIHJlYWxseSBoYW5kbGVzIHdyaXRpbmcgdG8gdGhhdCB2YWx1ZSB3aGls
ZSB0aGUgbW9kdWxlIGlzCj4+IGFscmVhZHkgbG9hZGVkIGFuZCB1cCBhbmQgcnVubmluZz8gIEF0
IGEgcXVpY2sgZ2xhbmNlLCBpdCBkaWRuJ3Qgc2VlbQo+PiBsaWtlIGl0IHdvdWxkIGhhbmRsZSB0
aGF0IHZlcnkgd2VsbCBhcyBpdCBvbmx5IGlzIGNoZWNrZWQgYXQgbmVfaW5pdCgpCj4+IHRpbWUu
Cj4+Cj4+IE9yIGFtIEkgbWlzc2luZyBzb21ldGhpbmc/Cj4+Cj4+IEFueXdheSwgeWVzLCBpZiB5
b3UgY2FuIGR5bmFtaWNhbGx5IGRvIHRoaXMgYXQgcnVudGltZSwgdGhhdCdzIGdyZWF0LAo+PiBi
dXQgaXQgZmVlbHMgYWNrd2FyZCB0byBtZSB0byByZWx5IG9uIG9uZSBjb25maWd1cmF0aW9uIHRo
aW5nIGFzIGEKPj4gbW9kdWxlIHBhcmFtZXRlciwgYW5kIGV2ZXJ5dGhpbmcgZWxzZSB0aHJvdWdo
IHRoZSBpb2N0bCBpbnRlcmZhY2UuCj4+IFVuaWZpY2F0aW9uIHdvdWxkIHNlZW0gdG8gYmUgYSBn
b29kIHRoaW5nLCByaWdodD8KPiAKPiBJIHBlcnNvbmFsbHkgc3RpbGwgcHJlZmVyIGEgc3lzZnMg
ZmlsZSA6KSBJIHJlYWxseSBkb24ndCBsaWtlIG1vZHVsZQo+IHBhcmFtZXRlcnMgYXMgYSB3YXkg
dG8gZG8gc3VjaCB0aGluZ3MuCgpJIHRoaW5rIHdlJ3JlIGdvaW5nIGluIGNpcmNsZXMgOikuCgpB
IG1vZHVsZSBwYXJhbWV0ZXIgaW5pdGlhbGl6ZWQgd2l0aCBtb2R1bGVfcGFyYW1fY2IgZ2l2ZXMg
dXMgYSBzeXNmcyAKZmlsZSB0aGF0IGNhbiBhbHNvIGhhdmUgYSBkZWZhdWx0IHBhcmFtZXRlciBz
ZXQgdGhyb3VnaCBlYXNpbHkgYXZhaWxhYmxlIAp0b29saW5nLgoKVGhlIGlvY3RsIGhhcyB0d28g
ZG93bnNpZGVzOgoKICAgMSkgSXQgcmVsaWVzIG9uIGFuIGV4dGVybmFsIGFwcGxpY2F0aW9uCiAg
IDIpIFRoZSBwZXJtaXNzaW9uIGNoZWNrIHdvdWxkIGJlIHN0cmljdGx5IGxpbWl0ZWQgdG8gQ0FQ
X0FETUlOLCBzeXNmcyAKZmlsZXMgY2FuIGhhdmUgZGlmZmVyZW50IHBlcm1pc3Npb25zCgpTbyBJ
IGZhaWwgdG8gc2VlIGhvdyBhIG1vZHVsZSBwYXJhbWV0ZXIgaXMgKm5vdCogZ2l2aW5nIGJvdGgg
b2YgeW91IGFuZCAKbWUgd2hhdCB3ZSB3YW50PyBPZiBjb3Vyc2Ugb25seSBpZiBpdCBpbXBsZW1l
bnRzIHRoZSBjYWxsYmFjay4gSXQgd2FzIAptaXNzaW5nIHRoYXQgYW5kIGFwb2xvZ2l6ZSBmb3Ig
dGhhdCBvdmVyc2lnaHQuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1h
bnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBD
aHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2Vy
aWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1J
RDogREUgMjg5IDIzNyA4NzkKCgo=


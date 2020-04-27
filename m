Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B521BA0A8
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 12:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgD0KAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 06:00:23 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:31030 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgD0KAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 06:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587981621; x=1619517621;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UHE+kIEcVDdAVEwv2C1XAIoryuhn239l8foOtDGiZRc=;
  b=GXM0c+XlSYtIwBatS5wtMEE8dXUd9Mrfw8A313hUsTbu6TwDs5sjSRpf
   d1KNXFRsjIaX1lcKWJZC1EXxZdUej3dlJIDUBhiVZBbw64+La5up7ONo2
   Hq7pBsQ5CSLBosneinJUoKYi1ouseux7tXnoYejdISgyRPR6Uqn64cOdg
   0=;
IronPort-SDR: kX7ERtiVTNTx5MtX5Ou848cOMqFDQ9pasI7beB0l1oDlR6k8SAw+Pc7RafxQ/qBsxaoQMVg0wW
 ES2WcT8gUZCQ==
X-IronPort-AV: E=Sophos;i="5.73,323,1583193600"; 
   d="scan'208";a="39652240"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 27 Apr 2020 10:00:20 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 8747DA2282;
        Mon, 27 Apr 2020 10:00:18 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 10:00:18 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.217) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 10:00:10 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
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
 <fe8940ff-9deb-1b2b-8f30-2ecfe26ce27b@amazon.com>
 <617eb49c-0ad9-8cf4-54bc-6d2cdfbb189a@redhat.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <47b7dc92-793c-75ce-6a8b-46b8a1f2bc88@amazon.com>
Date:   Mon, 27 Apr 2020 13:00:00 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <617eb49c-0ad9-8cf4-54bc-6d2cdfbb189a@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D16UWC003.ant.amazon.com (10.43.162.15) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy8wNC8yMDIwIDEyOjQ2LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDI3LzA0LzIw
IDExOjIyLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Pj4KPj4+IDEpIGhhdmluZyB0
aGUga2VybmVsIGFuZCBpbml0cmQgbG9hZGVkIGJ5IHRoZSBwYXJlbnQgVk0gaW4gZW5jbGF2ZQo+
Pj4gbWVtb3J5IGhhcyB0aGUgYWR2YW50YWdlIHRoYXQgeW91IHNhdmUgbWVtb3J5IG91dHNpZGUg
dGhlIGVuY2xhdmUgbWVtb3J5Cj4+PiBmb3Igc29tZXRoaW5nIHRoYXQgaXMgb25seSBuZWVkZWQg
aW5zaWRlIHRoZSBlbmNsYXZlCj4+IEhlcmUgeW91IHdhbnRlZCB0byBzYXkgZGlzYWR2YW50YWdl
PyA6KVdydCBzYXZpbmcgbWVtb3J5LCBpdCdzIGFib3V0Cj4+IGFkZGl0aW9uYWwgbWVtb3J5IGZy
b20gdGhlIHBhcmVudCAvIHByaW1hcnkgVk0gbmVlZGVkIGZvciBoYW5kbGluZyB0aGUKPj4gZW5j
bGF2ZSBpbWFnZSBzZWN0aW9ucyAoc3VjaCBhcyB0aGUga2VybmVsLCByYW1kaXNrKSBhbmQgc2V0
dGluZyB0aGUgRUlGCj4+IGF0IGEgY2VydGFpbiBvZmZzZXQgaW4gZW5jbGF2ZSBtZW1vcnk/Cj4g
Tm8sIGl0J3MgYW4gYWR2YW50YWdlLiAgSWYgdGhlIHBhcmVudCBWTSBjYW4gbG9hZCBldmVyeXRo
aW5nIGluIGVuY2xhdmUKPiBtZW1vcnksIGl0IGNhbiByZWFkKCkgaW50byBpdCBkaXJlY3RseS4g
IEl0IGRvZXNuJ3QgdG8gd2FzdGUgaXRzIG93bgo+IG1lbW9yeSBmb3IgYSBrZXJuZWwgYW5kIGlu
aXRyZCwgd2hvc2Ugb25seSByZWFzb24gdG8gZXhpc3QgaXMgdG8gYmUKPiBjb3BpZWQgaW50byBl
bmNsYXZlIG1lbW9yeS4KCk9rLCBnb3QgaXQsIHNhdmluZyB3YXMgcmVmZXJyaW5nIHRvIGFjdHVh
bGx5IG5vdCB1c2luZyBhZGRpdGlvbmFsIG1lbW9yeS4KClRoYW5rIHlvdSBmb3IgY2xhcmlmaWNh
dGlvbi4KCkFuZHJhCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIu
TC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAy
LCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFu
aWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K


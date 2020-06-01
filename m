Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0B91E9E68
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 08:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgFAGnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 02:43:00 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:13203 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgFAGnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 02:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590993780; x=1622529780;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=000o4dqQVLTRLnJFxiPKRxM6NO01qqe9oZA//aW5sZo=;
  b=jRPWNC8sW3CY+JI8WRSpRnCyL6+faB9wPQahR6ueP3A16sew7RbkMbH7
   9PMuEGS2rAi+uCVI8CMpacioibpIuR67DtvilCZhTjsNJJFyJ7WjTtiE/
   xv+1y1m5+MMwVVGAY1ps94378S37aER7U4XjG67IEeBTzNF3ml3UQwVic
   A=;
IronPort-SDR: GYttp4Mwo1NhmCWAJV9M4ryKRvzmbh9G+ybTLmFQflyRsURm7N9LlQsuE9lsP1TQIAMY5JxFoH
 duvQCG5itP5A==
X-IronPort-AV: E=Sophos;i="5.73,459,1583193600"; 
   d="scan'208";a="48565904"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 01 Jun 2020 06:42:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 872B1A2242;
        Mon,  1 Jun 2020 06:42:54 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 06:42:54 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.100) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 06:42:44 +0000
Subject: Re: [PATCH v3 04/18] nitro_enclaves: Init PCI device driver
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-5-andraprs@amazon.com>
 <20200526064819.GC2580530@kroah.com>
 <b4bd54ca-8fe2-8ebd-f4fc-012ed2ac498a@amazon.com>
 <eb08c9ab66d1f9a8aa8732da693928d12ad613ec.camel@kernel.crashing.org>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <7b063909-cbd5-f02d-595a-10341d30dd49@amazon.com>
Date:   Mon, 1 Jun 2020 09:42:34 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <eb08c9ab66d1f9a8aa8732da693928d12ad613ec.camel@kernel.crashing.org>
Content-Language: en-US
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D24UWA004.ant.amazon.com (10.43.160.233) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwMS8wNi8yMDIwIDA1OjU1LCBCZW5qYW1pbiBIZXJyZW5zY2htaWR0IHdyb3RlOgo+IE9u
IFR1ZSwgMjAyMC0wNS0yNiBhdCAyMTozNSArMDMwMCwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3
cm90ZToKPj4gVGhpcyB3YXMgbmVlZGVkIHRvIGhhdmUgYW4gaWRlbnRpZmllciBmb3IgdGhlIG92
ZXJhbGwgTkUgbG9naWMgLSBQQ0kKPj4gZGV2LCBpb2N0bCBhbmQgbWlzYyBkZXYuCj4+Cj4+IFRo
ZSBpb2N0bCBhbmQgbWlzYyBkZXYgbG9naWMgaGFzIHByXyogbG9ncywgYnV0IEkgY2FuIHVwZGF0
ZSB0aGVtIHRvCj4+IGRldl8qIHdpdGggbWlzYyBkZXYsIHRoZW4gcmVtb3ZlIHRoaXMgcHJlZml4
Lgo+IE9yICNkZWZpbmUgcHJfZm10LCBidXQgZGV2XyBpcyBiZXR0ZXIuCgpZZXAsIHRoZSBjb2Rl
YmFzZSBub3cgaW5jbHVkZXMgZGV2XyogdXNhZ2Ugb3ZlcmFsbC4KClRoYW5rcywKQW5kcmEKCgoK
QW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2Zm
aWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3Vu
dHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24g
bnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


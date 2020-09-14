Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B15269317
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 19:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgINRYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 13:24:55 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45374 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgINRYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 13:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600104240; x=1631640240;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=2iQFonidT7fWQUWyw8u47esTrEsM+cNF81wcQLjt6KA=;
  b=BQj1KrU20YMT9jBK1PyajfuapaJ+Y88o7dMRh8bemeW7JdWeZfVPdml4
   QQTkXEdqjH4bR2HDjcz+SZXESON689NrGVX/7xSVBGAK+JyKXftiU4dk7
   DTQuMIxRJVQ458m3WqT0qprPeASVeqbj3XMTIu6nz2wkHIWICYG5Vl8oy
   g=;
X-IronPort-AV: E=Sophos;i="5.76,426,1592870400"; 
   d="scan'208";a="53938959"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 14 Sep 2020 17:23:58 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 26606A18EC;
        Mon, 14 Sep 2020 17:23:57 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.71) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Sep 2020 17:23:48 +0000
Subject: Re: [PATCH v9 14/18] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200911141141.33296-1-andraprs@amazon.com>
 <20200911141141.33296-15-andraprs@amazon.com>
 <20200914155913.GB3525000@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <c3a33dcf-794c-31ef-ced5-4f87ba21dd28@amazon.com>
Date:   Mon, 14 Sep 2020 20:23:38 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200914155913.GB3525000@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D24UWA001.ant.amazon.com (10.43.160.138) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNC8wOS8yMDIwIDE4OjU5LCBHcmVnIEtIIHdyb3RlOgo+IE9uIEZyaSwgU2VwIDExLCAy
MDIwIGF0IDA1OjExOjM3UE0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gU2lnbmVk
LW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+PiBSZXZpZXdl
ZC1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4KPiBJIGNhbid0IHRha2UgcGF0
Y2hlcyB3aXRob3V0IGFueSBjaGFuZ2Vsb2cgdGV4dCBhdCBhbGwsIHNvcnJ5Lgo+Cj4gU2FtZSBm
b3IgYSBmZXcgb3RoZXIgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcyA6KAo+CgpJIGNhbiBtb3ZlIHRo
ZSBjaGFuZ2Vsb2cgdGV4dCBiZWZvcmUgdGhlIFNvYiB0YWcocykgZm9yIGFsbCB0aGUgcGF0Y2hl
cy4gCkkgYWxzbyBjYW4gYWRkIGEgc3VtbWFyeSBwaHJhc2UgaW4gdGhlIGNvbW1pdCBtZXNzYWdl
IGZvciB0aGUgY29tbWl0cyAKbGlrZSB0aGlzIG9uZSB0aGF0IGhhdmUgb25seSB0aGUgY29tbWl0
IHRpdGxlIGFuZCBTb2IgJiBSYiB0YWdzLgoKV291bGQgdGhlc2UgdXBkYXRlcyB0byB0aGUgY29t
bWl0IG1lc3NhZ2VzIG1hdGNoIHRoZSBleHBlY3RhdGlvbnM/CgpMZXQgbWUga25vdyBpZiByZW1h
aW5pbmcgZmVlZGJhY2sgdG8gZGlzY3VzcyBhbmQgSSBzaG91bGQgaW5jbHVkZSBhcyAKdXBkYXRl
cyBpbiB2MTAuIE90aGVyd2lzZSwgSSBjYW4gc2VuZCB0aGUgbmV3IHJldmlzaW9uIHdpdGggdGhl
IHVwZGF0ZWQgCmNvbW1pdCBtZXNzYWdlcy4KClRoYW5rcyBmb3IgcmV2aWV3LgoKQW5kcmEKCgoK
QW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2Zm
aWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3Vu
dHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24g
bnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


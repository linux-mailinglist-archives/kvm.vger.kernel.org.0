Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA3A1CA4B6
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 09:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgEHHAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 03:00:51 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:54684 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgEHHAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 03:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588921250; x=1620457250;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=GZjxTmZ6n9VF4rYtF0IiJq83oKOiFAcF3d/RgIq5rZQ=;
  b=G5AADGdGEq9N1wH49M5K9y0uAhbL8Xp16T9nb2utrP5ZqqYIUY5X9cfa
   /gr2g81nnBVflhisCJCR0wm96aYWfg0NljhkSi0zozwk/SOY+ruh2WW20
   CWyboI1R6pGta1rlko3YEkOoR2lwV9GkknweN0MDhcjIXdqCHh2T6dpE8
   w=;
IronPort-SDR: /qskcKU7Z4ipo0ZmYlOqD03LBFdFhYKxJNIeJI6xxbptduVISDTt+0FsGYbsO5YmrbP1IDTmnK
 aNlAJc4KpLoA==
X-IronPort-AV: E=Sophos;i="5.73,366,1583193600"; 
   d="scan'208";a="42056765"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 08 May 2020 07:00:48 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 8AB38C06AF;
        Fri,  8 May 2020 07:00:46 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 8 May 2020 07:00:45 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.37) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 8 May 2020 07:00:38 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Pavel Machek <pavel@ucw.cz>, Paolo Bonzini <pbonzini@redhat.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com> <20200507174438.GB1216@bug>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <620bf5ae-eade-37da-670d-a8704d9b4397@amazon.com>
Date:   Fri, 8 May 2020 10:00:27 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507174438.GB1216@bug>
Content-Language: en-US
X-Originating-IP: [10.43.162.37]
X-ClientProxiedBy: EX13D19UWC003.ant.amazon.com (10.43.162.184) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNy8wNS8yMDIwIDIwOjQ0LCBQYXZlbCBNYWNoZWsgd3JvdGU6Cj4KPiBIaSEKPgo+Pj4g
aXQgdXNlcyBpdHMgb3duIG1lbW9yeSBhbmQgQ1BVcyArIGl0cyB2aXJ0aW8tdnNvY2sgZW11bGF0
ZWQgZGV2aWNlIGZvcgo+Pj4gY29tbXVuaWNhdGlvbiB3aXRoIHRoZSBwcmltYXJ5IFZNLgo+Pj4K
Pj4+IFRoZSBtZW1vcnkgYW5kIENQVXMgYXJlIGNhcnZlZCBvdXQgb2YgdGhlIHByaW1hcnkgVk0s
IHRoZXkgYXJlIGRlZGljYXRlZAo+Pj4gZm9yIHRoZSBlbmNsYXZlLiBUaGUgTml0cm8gaHlwZXJ2
aXNvciBydW5uaW5nIG9uIHRoZSBob3N0IGVuc3VyZXMgbWVtb3J5Cj4+PiBhbmQgQ1BVIGlzb2xh
dGlvbiBiZXR3ZWVuIHRoZSBwcmltYXJ5IFZNIGFuZCB0aGUgZW5jbGF2ZSBWTS4KPj4+Cj4+PiBU
aGVzZSB0d28gY29tcG9uZW50cyBuZWVkIHRvIHJlZmxlY3QgdGhlIHNhbWUgc3RhdGUgZS5nLiB3
aGVuIHRoZQo+Pj4gZW5jbGF2ZSBhYnN0cmFjdGlvbiBwcm9jZXNzICgxKSBpcyB0ZXJtaW5hdGVk
LCB0aGUgZW5jbGF2ZSBWTSAoMikgaXMKPj4+IHRlcm1pbmF0ZWQgYXMgd2VsbC4KPj4+Cj4+PiBX
aXRoIHJlZ2FyZCB0byB0aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsLCB0aGUgcHJpbWFyeSBWTSBo
YXMgaXRzIG93bgo+Pj4gZW11bGF0ZWQgdmlydGlvLXZzb2NrIFBDSSBkZXZpY2UuIFRoZSBlbmNs
YXZlIFZNIGhhcyBpdHMgb3duIGVtdWxhdGVkCj4+PiB2aXJ0aW8tdnNvY2sgZGV2aWNlIGFzIHdl
bGwuIFRoaXMgY2hhbm5lbCBpcyB1c2VkLCBmb3IgZXhhbXBsZSwgdG8gZmV0Y2gKPj4+IGRhdGEg
aW4gdGhlIGVuY2xhdmUgYW5kIHRoZW4gcHJvY2VzcyBpdC4gQW4gYXBwbGljYXRpb24gdGhhdCBz
ZXRzIHVwIHRoZQo+Pj4gdnNvY2sgc29ja2V0IGFuZCBjb25uZWN0cyBvciBsaXN0ZW5zLCBkZXBl
bmRpbmcgb24gdGhlIHVzZSBjYXNlLCBpcyB0aGVuCj4+PiBkZXZlbG9wZWQgdG8gdXNlIHRoaXMg
Y2hhbm5lbDsgdGhpcyBoYXBwZW5zIG9uIGJvdGggZW5kcyAtIHByaW1hcnkgVk0KPj4+IGFuZCBl
bmNsYXZlIFZNLgo+Pj4KPj4+IExldCBtZSBrbm93IGlmIGZ1cnRoZXIgY2xhcmlmaWNhdGlvbnMg
YXJlIG5lZWRlZC4KPj4gVGhhbmtzLCB0aGlzIGlzIGFsbCB1c2VmdWwuICBIb3dldmVyIGNhbiB5
b3UgcGxlYXNlIGNsYXJpZnkgdGhlCj4+IGxvdy1sZXZlbCBkZXRhaWxzIGhlcmU/Cj4gSXMgdGhl
IHZpcnR1YWwgbWFjaGluZSBtYW5hZ2VyIG9wZW4tc291cmNlPyBJZiBzbywgSSBndWVzcyBwb2lu
dGVyIGZvciBzb3VyY2VzCj4gd291bGQgYmUgdXNlZnVsLgoKSGkgUGF2ZWwsCgpUaGFua3MgZm9y
IHJlYWNoaW5nIG91dC4KClRoZSBWTU0gdGhhdCBpcyB1c2VkIGZvciB0aGUgcHJpbWFyeSAvIHBh
cmVudCBWTSBpcyBub3Qgb3BlbiBzb3VyY2UuCgpBbmRyYQoKCgoKQW1hem9uIERldmVsb3BtZW50
IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFy
IFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5p
YS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIw
MDUuCg==


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B8C3F9B67
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 17:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245423AbhH0PE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 11:04:27 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:15929 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245364AbhH0PEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 11:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630076606; x=1661612606;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=56ObOdm8sPuO1N68sjiDnNbwkH2z9H6p0M38mab9cRI=;
  b=TOen4FeEWouEP2HLN3byVZXnE/Gb0lYGO6bq/ijSgzEetYrhrmsxyr2i
   FUENcP7dIRtPEABh2ichTwu5Ie/DV64oKvemqUr1dG1MuwsEmklgBrfmU
   qZqLEg0dgqqnW7qxaM5r6bJzj1RI2KO7mGhOKIv/mY6bVFOAjiINF60dR
   M=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="22471799"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-28209b7b.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 27 Aug 2021 15:03:18 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-28209b7b.us-east-1.amazon.com (Postfix) with ESMTPS id 88E48C3087;
        Fri, 27 Aug 2021 15:03:15 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.164) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 15:03:09 +0000
Subject: Re: [PATCH v2 1/7] nitro_enclaves: Enable Arm64 support
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20210827133230.29816-1-andraprs@amazon.com>
 <20210827133230.29816-2-andraprs@amazon.com> <YSj15tWpwQ41BFy3@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <f5b75895-5ba8-7715-9deb-6c003477e334@amazon.com>
Date:   Fri, 27 Aug 2021 18:02:57 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSj15tWpwQ41BFy3@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.164]
X-ClientProxiedBy: EX13D11UWB003.ant.amazon.com (10.43.161.206) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy8wOC8yMDIxIDE3OjI1LCBHcmVnIEtIIHdyb3RlOgo+IE9uIEZyaSwgQXVnIDI3LCAy
MDIxIGF0IDA0OjMyOjI0UE0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gVXBkYXRl
IHRoZSBrZXJuZWwgY29uZmlnIHRvIGVuYWJsZSB0aGUgTml0cm8gRW5jbGF2ZXMga2VybmVsIGRy
aXZlciBmb3IKPj4gQXJtNjQgc3VwcG9ydC4KPj4KPj4gQ2hhbmdlbG9nCj4+Cj4+IHYxIC0+IHYy
Cj4+Cj4+ICogTm8gY2hhbmdlcy4KPj4KPiBjaGFuZ2Vsb2dzIGZvciBkaWZmZXJlbnQgYWxsIGdv
IGJlbG93IHRoZSAtLS0gbGluZSwgYXMgaXMgZG9jdW1lbnRlZC4KPiBObyBuZWVkIGZvciB0aGVt
IGhlcmUgaW4gdGhlIGNoYW5nZWxvZyB0ZXh0IGl0c2VsZiwgcmlnaHQ/Cj4KPiBQbGVhc2UgZml4
IHVwIGFuZCBzZW5kIGEgdjMgc2VyaWVzLgoKQWxyaWdodCwgSSBjYW4gbW9kaWZ5IHRoZSBwYXRj
aGVzIHNvIHRoYXQgdGhlIGNoYW5nZWxvZyBpcyBhZnRlciB0aGUgbGluZS4KCkkgZm9sbG93ZWQg
dGhlIHNhbWUgcGF0dGVybiBhcyB0aGUgaW5pdGlhbCB0aW1lLCB3aGVuIEkgcmVjZWl2ZWQgCmZl
ZWRiYWNrIHRvIGhhdmUgdGhlIGNoYW5nZWxvZ3MgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLCBiZWZv
cmUgU29CKHMpLgoKQnV0IHRoYXQncyBmaW5lIHdpdGggbWUsIEkgY2FuIHN3aXRjaCB0byB0aGlz
IHdheSBvZiBkb2luZyBpdCwgYXMgCm1lbnRpb25lZCBhbHNvIGluIHRoZSBkb2NzLgoKVGhhbmtz
LApBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVn
aXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNp
LCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJl
Z2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K


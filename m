Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB2825FCC7
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 17:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgIGPOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 11:14:34 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:61867 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbgIGPOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 11:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599491650; x=1631027650;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=YjMSHQHURdbx/t6NUVi9Q5Iws7vt3dA1WAArwTiPwsI=;
  b=nGCE0gaQ7gaQQNwf+JT2m+LKIAIW31CI38f3gJ53znGZJ0LVzEx1gbDU
   ZVJPDWtcpldQMXPFUzyf0tQC7rPyQlYK1UHxrBdk6bIVF58Sqqc+I4zyg
   StKlGxdbxWqyuV5nKd1Nk7OSprpo3ZhS667j8FoqgYWy4bpk/bsHAaDXv
   Y=;
X-IronPort-AV: E=Sophos;i="5.76,402,1592870400"; 
   d="scan'208";a="52576723"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Sep 2020 15:14:08 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id D9334A23D5;
        Mon,  7 Sep 2020 15:14:05 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.192) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Sep 2020 15:13:55 +0000
Subject: Re: [PATCH v8 17/18] nitro_enclaves: Add overview documentation
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
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-18-andraprs@amazon.com>
 <20200907090126.GD1101646@kroah.com>
 <44a8a921-1fb4-87ab-b8f2-c168c615dbbd@amazon.com>
 <20200907140803.GA3719869@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b8a1e66c-7674-7354-599e-159efd260ba9@amazon.com>
Date:   Mon, 7 Sep 2020 18:13:50 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907140803.GA3719869@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.192]
X-ClientProxiedBy: EX13D46UWB002.ant.amazon.com (10.43.161.70) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNy8wOS8yMDIwIDE3OjA4LCBHcmVnIEtIIHdyb3RlOgo+IE9uIE1vbiwgU2VwIDA3LCAy
MDIwIGF0IDA0OjQzOjExUE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDA3LzA5LzIwMjAgMTI6MDEsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBGcmksIFNlcCAw
NCwgMjAyMCBhdCAwODozNzoxN1BNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+Pj4g
U2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+Pj4+
IFJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgo+Pj4+IC0tLQo+
Pj4+IENoYW5nZWxvZwo+Pj4+Cj4+Pj4gdjcgLT4gdjgKPj4+Pgo+Pj4+ICogQWRkIGluZm8gYWJv
dXQgdGhlIHByaW1hcnkgLyBwYXJlbnQgVk0gQ0lEIHZhbHVlLgo+Pj4+ICogVXBkYXRlIHJlZmVy
ZW5jZSBsaW5rIGZvciBodWdlIHBhZ2VzLgo+Pj4+ICogQWRkIHJlZmVyZW5jZSBsaW5rIGZvciB0
aGUgeDg2IGJvb3QgcHJvdG9jb2wuCj4+Pj4gKiBBZGQgbGljZW5zZSBtZW50aW9uIGFuZCB1cGRh
dGUgZG9jIHRpdGxlIC8gY2hhcHRlciBmb3JtYXR0aW5nLgo+Pj4+Cj4+Pj4gdjYgLT4gdjcKPj4+
Pgo+Pj4+ICogTm8gY2hhbmdlcy4KPj4+Pgo+Pj4+IHY1IC0+IHY2Cj4+Pj4KPj4+PiAqIE5vIGNo
YW5nZXMuCj4+Pj4KPj4+PiB2NCAtPiB2NQo+Pj4+Cj4+Pj4gKiBObyBjaGFuZ2VzLgo+Pj4+Cj4+
Pj4gdjMgLT4gdjQKPj4+Pgo+Pj4+ICogVXBkYXRlIGRvYyB0eXBlIGZyb20gLnR4dCB0byAucnN0
Lgo+Pj4+ICogVXBkYXRlIGRvY3VtZW50YXRpb24gYmFzZWQgb24gdGhlIGNoYW5nZXMgZnJvbSB2
NC4KPj4+Pgo+Pj4+IHYyIC0+IHYzCj4+Pj4KPj4+PiAqIE5vIGNoYW5nZXMuCj4+Pj4KPj4+PiB2
MSAtPiB2Mgo+Pj4+Cj4+Pj4gKiBOZXcgaW4gdjIuCj4+Pj4gLS0tCj4+Pj4gICAgRG9jdW1lbnRh
dGlvbi9uaXRyb19lbmNsYXZlcy9uZV9vdmVydmlldy5yc3QgfCA5NSArKysrKysrKysrKysrKysr
KysrKwo+Pj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCA5NSBpbnNlcnRpb25zKCspCj4+Pj4gICAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vbml0cm9fZW5jbGF2ZXMvbmVfb3ZlcnZpZXcu
cnN0Cj4+PiBBIHdob2xlIG5ldyBzdWJkaXIsIGZvciBhIHNpbmdsZSBkcml2ZXIsIGFuZCBub3Qg
dGllZCBpbnRvIHRoZSBrZXJuZWwKPj4+IGRvY3VtZW50YXRpb24gYnVpbGQgcHJvY2VzcyBhdCBh
bGw/ICBOb3QgZ29vZCA6KAo+Pj4KPj4gV291bGQgdGhlICJ2aXJ0IiBkaXJlY3RvcnkgYmUgYSBi
ZXR0ZXIgb3B0aW9uIGZvciB0aGlzIGRvYyBmaWxlPwo+IFllcy4KCkFscmlnaHQsIEknbGwgdXBk
YXRlIHRoZSBkb2MgZmlsZSBsb2NhdGlvbiwgdGhlIGluZGV4IGZpbGUgYW5kIHRoZSAKTUFJTlRB
SU5FUlMgZW50cnkgdG8gcmVmbGVjdCB0aGUgbmV3IGRvYyBmaWxlIGxvY2F0aW9uLgoKVGhhbmtz
LApBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVn
aXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNp
LCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJl
Z2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K


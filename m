Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885A02C6C06
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 20:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgK0TFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 14:05:35 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:65435 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729994AbgK0TEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 14:04:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606503882; x=1638039882;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=DSdcTDRQLgP6jheFII76+mQS/8C+1zMiWnZKLb2dyzA=;
  b=m0aow+DqRgpGhuHoxbi9VPr+K08wdGHpOTiSZ/+bm9TNpFoRoZU07Ve7
   zi/GwG1o5ISa5xXnqSTfkvQecUsmhJ4Tk4a1mN6+WgfRsEd+dQEW/G1ta
   HrngjCWTaA24nKz3wKxqXVwsSImW8UzaiY+0gDpoMczGAHVE97HOFC4y1
   I=;
X-IronPort-AV: E=Sophos;i="5.78,375,1599523200"; 
   d="scan'208";a="99817617"
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 27 Nov 2020 19:04:22 +0000
Received: from EX13D08EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 2BE4DC05BB;
        Fri, 27 Nov 2020 19:04:19 +0000 (UTC)
Received: from 4c32759f87cf.ant.amazon.com (10.43.160.125) by
 EX13D08EUB004.ant.amazon.com (10.43.166.158) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 27 Nov 2020 19:04:05 +0000
To:     Jann Horn <jannh@google.com>
CC:     "Graf (AWS), Alexander" <graf@amazon.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
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
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <CAG48ez2VAu6oARGVZ+muDK9_6_38KVUTJf7utz5Nn=AsmN17nA@mail.gmail.com>
 <CAG48ez13ZAAOVmA89PRKRqr9UezV2_bj8Q6_6sSPzcqfzbsuQQ@mail.gmail.com>
From:   "Catangiu, Adrian Costin" <acatan@amazon.com>
Message-ID: <e4acbcdb-7ee4-5dfb-ffbf-19eb49cef9c6@amazon.com>
Date:   Fri, 27 Nov 2020 21:04:01 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAG48ez13ZAAOVmA89PRKRqr9UezV2_bj8Q6_6sSPzcqfzbsuQQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
X-Originating-IP: [10.43.160.125]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D08EUB004.ant.amazon.com (10.43.166.158)
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U29ycnkgSmFubiBmb3IgbWlzc2luZyB5b3VyIG9yaWdpbmFsIGVtYWlsLgoKT24gMjcvMTEvMjAy
MCAyMDoyMiwgSmFubiBIb3JuIHdyb3RlOgo+IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRl
ZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUuCj4KPgo+Cj4gW3Jlc2VuZCBpbiB0aGUgaG9wZSB0aGF0
IGFtYXpvbiB3aWxsIGFjY2VwdCBteSBtYWlsIHRoaXMgdGltZSBpbnN0ZWFkCj4gb2YgcmVwbHlp
bmcgIjU1MCBUb28gbWFueSBpbnZhbGlkIHJlY2lwaWVudHMiIGFnYWluXQo+Cj4gT24gRnJpLCBO
b3YgMjAsIDIwMjAgYXQgMTE6MjkgUE0gSmFubiBIb3JuIDxqYW5uaEBnb29nbGUuY29tPiB3cm90
ZToKPj4gT24gTW9uLCBOb3YgMTYsIDIwMjAgYXQgNDozNSBQTSBDYXRhbmdpdSwgQWRyaWFuIENv
c3Rpbgo+PiA8YWNhdGFuQGFtYXpvbi5jb20+IHdyb3RlOgo+Pj4gVGhpcyBwYXRjaCBpcyBhIGRy
aXZlciB0aGF0IGV4cG9zZXMgYSBtb25vdG9uaWMgaW5jcmVtZW50YWwgVmlydHVhbAo+Pj4gTWFj
aGluZSBHZW5lcmF0aW9uIHUzMiBjb3VudGVyIHZpYSBhIGNoYXItZGV2IEZTIGludGVyZmFjZSB0
aGF0Cj4+PiBwcm92aWRlcyBzeW5jIGFuZCBhc3luYyBWbUdlbiBjb3VudGVyIHVwZGF0ZXMgbm90
aWZpY2F0aW9ucy4gSXQgYWxzbwo+Pj4gcHJvdmlkZXMgVm1HZW4gY291bnRlciByZXRyaWV2YWwg
YW5kIGNvbmZpcm1hdGlvbiBtZWNoYW5pc21zLgo+Pj4KPj4+IFRoZSBodyBwcm92aWRlZCBVVUlE
IGlzIG5vdCBleHBvc2VkIHRvIHVzZXJzcGFjZSwgaXQgaXMgaW50ZXJuYWxseQo+Pj4gdXNlZCBi
eSB0aGUgZHJpdmVyIHRvIGtlZXAgYWNjb3VudGluZyBmb3IgdGhlIGV4cG9zZWQgVm1HZW4gY291
bnRlci4KPj4+IFRoZSBjb3VudGVyIHN0YXJ0cyBmcm9tIHplcm8gd2hlbiB0aGUgZHJpdmVyIGlz
IGluaXRpYWxpemVkIGFuZAo+Pj4gbW9ub3RvbmljYWxseSBpbmNyZW1lbnRzIGV2ZXJ5IHRpbWUg
dGhlIGh3IFVVSUQgY2hhbmdlcyAodGhlIFZNCj4+PiBnZW5lcmF0aW9uIGNoYW5nZXMpLgo+Pj4K
Pj4+IE9uIGVhY2ggaHcgVVVJRCBjaGFuZ2UsIHRoZSBuZXcgaHlwZXJ2aXNvci1wcm92aWRlZCBV
VUlEIGlzIGFsc28gZmVkCj4+PiB0byB0aGUga2VybmVsIFJORy4KPj4gQXMgZm9yIHYxOgo+Pgo+
PiBJcyB0aGVyZSBhIHJlYXNvbmFibGUgdXNlY2FzZSBmb3IgdGhlICJjb25maXJtYXRpb24iIG1l
Y2hhbmlzbT8gSXQKPj4gZG9lc24ndCBzZWVtIHZlcnkgdXNlZnVsIHRvIG1lLgoKSSB0aGluayBp
dCBhZGRzIHZhbHVlIGluIGNvbXBsZXggc2NlbmFyaW9zIHdpdGggbXVsdGlwbGUgdXNlcnMgb2Yg
dGhlCm1lY2hhbmlzbSwgcG90ZW50aWFsbHkgYXQgdmFyeWluZyBsYXllcnMgb2YgdGhlIHN0YWNr
LCBkaWZmZXJlbnQKcHJvY2Vzc2VzIGFuZC9vciBydW50aW1lIGxpYnJhcmllcy4KClRoZSBkcml2
ZXIgb2ZmZXJzIGEgbmF0dXJhbCBwbGFjZSB0byBoYW5kbGUgbWluaW1hbCBvcmNoZXN0cmF0aW9u
CnN1cHBvcnQgYW5kIG9mZmVyIHZpc2liaWxpdHkgaW4gc3lzdGVtLXdpZGUgc3RhdHVzLgoKQSBo
aWdoLWxldmVsIHNlcnZpY2UgdGhhdCB0cnVzdHMgYWxsIHN5c3RlbSBjb21wb25lbnRzIHRvIHBy
b3Blcmx5IHVzZQp0aGUgY29uZmlybWF0aW9uIG1lY2hhbmlzbSBjYW4gYWN0dWFsbHkgYmxvY2sg
YW5kIHdhaXQgcGF0aWVudGx5IGZvciB0aGUKc3lzdGVtIHRvIGFkanVzdCB0byB0aGUgbmV3IHdv
cmxkLiBFdmVuIGlmIGl0IGRvZXNuJ3QgdHJ1c3QgYWxsCmNvbXBvbmVudHMgaXQgY2FuIHN0aWxs
IGRvIGEgYmVzdC1lZmZvcnQsIHRpbWVvdXQgYmxvY2suCgo+Pgo+PiBIb3cgZG8geW91IGVudmlz
aW9uIGludGVncmF0aW5nIHRoaXMgd2l0aCBsaWJyYXJpZXMgdGhhdCBoYXZlIHRvIHdvcmsKPj4g
aW4gcmVzdHJpY3RpdmUgc2VjY29tcCBzYW5kYm94ZXM/IElmIHRoaXMgd2FzIGluIHRoZSB2RFNP
LCB0aGF0IHdvdWxkCj4+IGJlIG11Y2ggZWFzaWVyLgoKU2luY2UgdGhpcyBtZWNoYW5pc20gdGFy
Z2V0cyBhbGwgb2YgdXNlcnNwYWNlIHN0YWNrLCB0aGUgdXNlY2FzZSBncmVhdGx5CnZhcnkuIEkg
ZG91YnQgd2UgY2FuIGhhdmUgYSBzaW5nbGUgc2lsdmVyIGJ1bGxldCBpbnRlcmZhY2UuCgpGb3Ig
ZXhhbXBsZSwgdGhlIG1tYXAgaW50ZXJmYWNlIHRhcmdldHMgdXNlciBzcGFjZSBSTkdzLCB3aGVy
ZSBhcyBmYXN0CmFuZCBhcyByYWNlIGZyZWUgYXMgcG9zc2libGUgaXMga2V5LiBCdXQgdGhlcmUg
YWxzbyBoaWdoZXIgbGV2ZWwKYXBwbGljYXRpb25zIHRoYXQgZG9uJ3QgbWFuYWdlIHRoZWlyIG93
biBtZW1vcnkgb3IgZG9uJ3QgaGF2ZSBhY2Nlc3MgdG8KbG93LWxldmVsIHByaW1pdGl2ZXMgc28g
dGhleSBjYW4ndCB1c2UgdGhlIG1tYXAgb3IgZXZlbiB2RFNPIGludGVyZmFjZXMuClRoYXQncyB3
aGF0IHRoZSByZXN0IG9mIHRoZSBsb2dpYyBpcyB0aGVyZSBmb3IsIHRoZSByZWFkK3BvbGwgaW50
ZXJmYWNlCmFuZCBhbGwgb2YgdGhlIG9yY2hlc3RyYXRpb24gbG9naWMuCgpMaWtlIHlvdSBjb3Jy
ZWN0bHkgcG9pbnQgb3V0LCB0aGVyZSBhcmUgYWxzbyBzY2VuYXJpb3MgbGlrZSB0aWdodApzZWNj
b21wIGphaWxzIHdoZXJlIGV2ZW4gdGhlIEZTIGludGVyZmFjZXMgaXMgaW5hY2Nlc3NpYmxlLiBG
b3IgY2FzZXMKbGlrZSB0aGlzIGFuZCBvdGhlcnMsIEkgYmVsaWV2ZSB3ZSB3aWxsIGhhdmUgdG8g
d29yayBpbmNyZW1lbnRhbGx5IHRvCmJ1aWxkIHVwIHRoZSBpbnRlcmZhY2UgZGl2ZXJzaXR5IHRv
IGNhdGVyIHRvIGFsbCB0aGUgdXNlciBzY2VuYXJpb3MKZGl2ZXJzaXR5LgoKClRoYW5rcywKCkFk
cmlhbi4KCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVn
aXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNp
LCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJl
Z2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K


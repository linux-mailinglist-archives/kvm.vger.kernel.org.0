Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF18E3F9815
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244982AbhH0KXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:23:41 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:51643 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244956AbhH0KXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630059772; x=1661595772;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=sKhGIzn3i9OrLDjqVA7v9OoA0Orr3NgeaahdP7rLdFY=;
  b=Xy1HRpoUfOjDtvBfeXMerABzC+1EhdB1SC3BtD9q5iFWFUgd05NfJvNl
   1s/ALz85TDOfY7RHfzc5+LcqOt0YSA/c9c5/ZOzyTRewcryTMCxYQnkmY
   tTL023ycqzSXp2tA+i6EIWHujXE8GP+x8eHABjU+GO38269iD75Hegdlc
   U=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="132681528"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-25e59222.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 27 Aug 2021 10:22:44 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-25e59222.us-east-1.amazon.com (Postfix) with ESMTPS id F2EA4A2419;
        Fri, 27 Aug 2021 10:22:42 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.187) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 10:22:36 +0000
Subject: Re: [PATCH v1 3/3] nitro_enclaves: Add fixes for checkpatch and docs
 reports
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
References: <20210826173451.93165-1-andraprs@amazon.com>
 <20210826173451.93165-4-andraprs@amazon.com> <YSilspuLarIKRquD@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <6a6a2ed2-03d0-3faf-7f74-630fccf4cf86@amazon.com>
Date:   Fri, 27 Aug 2021 13:22:28 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSilspuLarIKRquD@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.187]
X-ClientProxiedBy: EX13D49UWB004.ant.amazon.com (10.43.163.111) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy8wOC8yMDIxIDExOjQzLCBHcmVnIEtIIHdyb3RlOgo+IE9uIFRodSwgQXVnIDI2LCAy
MDIxIGF0IDA4OjM0OjUxUE0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gRml4IHRo
ZSByZXBvcnRlZCBpc3N1ZXMgZnJvbSBjaGVja3BhdGNoIGFuZCBrZXJuZWwtZG9jIHNjcmlwdHMu
Cj4+Cj4+IFVwZGF0ZSB0aGUgY29weXJpZ2h0IHN0YXRlbWVudHMgdG8gaW5jbHVkZSAyMDIxLCB3
aGVyZSBjaGFuZ2VzIGhhdmUgYmVlbgo+PiBtYWRlIG92ZXIgdGhpcyB5ZWFyLgo+Pgo+PiBTaWdu
ZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4gUGxlYXNl
IGJyZWFrIHRoaXMgdXAgaW50byAib25lIHBhdGNoIHBlciBsb2dpY2FsIGNoYW5nZSIgZG8gbm90
IG1peAo+IGRpZmZlcmVudCB0aGluZ3MgaW4gdGhlIHNhbWUgY29tbWl0LgoKU3VyZSwgSSBjYW4g
c3BsaXQgdGhpcyBwYXRjaCBpbiBtdWx0aXBsZSBvbmVzIGZvciB2Mi4KClRoYW5rcywKQW5kcmEK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQg
b2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBD
b3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRp
b24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


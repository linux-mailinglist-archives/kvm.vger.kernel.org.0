Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534503F9810
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244975AbhH0KVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:21:01 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:22544 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbhH0KVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630059612; x=1661595612;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=M6ipT9UYceu6gs4TdSIrUMHCcpovQTG+zQBp5mFUolc=;
  b=KhzhbKQynbH5CVMOAi2xmig4jAkXmBI/U/KZX8VjmBO83QD2dmYDxDx8
   Atg5y2dTbG9kWGQ4O7vqf0/yFgf+8n8DWKYhnewzLihdQEM+1COCuyzU2
   EpaC0lDsORHBTD7qPdJaQFD489tT56XjqUVpzK27vaUJsvfgdFSzUD7Yk
   E=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="953489569"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 27 Aug 2021 10:20:04 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id D8FB9A2E3D;
        Fri, 27 Aug 2021 10:20:00 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.216) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 10:19:55 +0000
Subject: Re: [PATCH v1 1/3] nitro_enclaves: Enable Arm support
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
 <20210826173451.93165-2-andraprs@amazon.com> <YSilmGyvEAc46ujH@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <7bed3e99-d69a-bf9b-b33a-acc3e3726fb0@amazon.com>
Date:   Fri, 27 Aug 2021 13:19:46 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSilmGyvEAc46ujH@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.216]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy8wOC8yMDIxIDExOjQzLCBHcmVnIEtIIHdyb3RlOgo+IE9uIFRodSwgQXVnIDI2LCAy
MDIxIGF0IDA4OjM0OjQ5UE0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gVXBkYXRl
IHRoZSBrZXJuZWwgY29uZmlnIHRvIGVuYWJsZSB0aGUgTml0cm8gRW5jbGF2ZXMga2VybmVsIGRy
aXZlciBmb3IKPj4gQXJtIHN1cHBvcnQuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJhIFBhcmFz
Y2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4gLS0tCj4+ICAgZHJpdmVycy92aXJ0L25pdHJv
X2VuY2xhdmVzL0tjb25maWcgfCA4ICsrLS0tLS0tCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5z
ZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmly
dC9uaXRyb19lbmNsYXZlcy9LY29uZmlnIGIvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL0tj
b25maWcKPj4gaW5kZXggOGM5Mzg3YTIzMmRmOC4uZjUzNzQwYjk0MWMwZiAxMDA2NDQKPj4gLS0t
IGEvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL0tjb25maWcKPj4gKysrIGIvZHJpdmVycy92
aXJ0L25pdHJvX2VuY2xhdmVzL0tjb25maWcKPj4gQEAgLTEsMTcgKzEsMTMgQEAKPj4gICAjIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4+ICAgIwo+PiAtIyBDb3B5cmlnaHQgMjAy
MCBBbWF6b24uY29tLCBJbmMuIG9yIGl0cyBhZmZpbGlhdGVzLiBBbGwgUmlnaHRzIFJlc2VydmVk
Lgo+PiArIyBDb3B5cmlnaHQgMjAyMC0yMDIxIEFtYXpvbi5jb20sIEluYy4gb3IgaXRzIGFmZmls
aWF0ZXMuIEFsbCBSaWdodHMgUmVzZXJ2ZWQuCj4+Cj4+ICAgIyBBbWF6b24gTml0cm8gRW5jbGF2
ZXMgKE5FKSBzdXBwb3J0Lgo+PiAgICMgTml0cm8gaXMgYSBoeXBlcnZpc29yIHRoYXQgaGFzIGJl
ZW4gZGV2ZWxvcGVkIGJ5IEFtYXpvbi4KPj4KPj4gLSMgVE9ETzogQWRkIGRlcGVuZGVuY3kgZm9y
IEFSTTY0IG9uY2UgTkUgaXMgc3VwcG9ydGVkIG9uIEFybSBwbGF0Zm9ybXMuIEZvciBub3csCj4+
IC0jIHRoZSBORSBrZXJuZWwgZHJpdmVyIGNhbiBiZSBidWlsdCBmb3IgYWFyY2g2NCBhcmNoLgo+
PiAtIyBkZXBlbmRzIG9uIChBUk02NCB8fCBYODYpICYmIEhPVFBMVUdfQ1BVICYmIFBDSSAmJiBT
TVAKPj4gLQo+PiAgIGNvbmZpZyBOSVRST19FTkNMQVZFUwo+PiAgICAgICAgdHJpc3RhdGUgIk5p
dHJvIEVuY2xhdmVzIFN1cHBvcnQiCj4+IC0gICAgIGRlcGVuZHMgb24gWDg2ICYmIEhPVFBMVUdf
Q1BVICYmIFBDSSAmJiBTTVAKPj4gKyAgICAgZGVwZW5kcyBvbiAoQVJNNjQgfHwgWDg2KSAmJiBI
T1RQTFVHX0NQVSAmJiBQQ0kgJiYgU01QCj4gU28gbm8gY29kZSBjaGFuZ2UgbmVlZGVkPyAgSWYg
bm90LCB0aGV5IHdoeSBkbyB3ZSBoYXZlIGEgY3B1IHR5cGUgYXQgYWxsCj4gaGVyZT8KClllcywg
bm8gY29kZWJhc2UgY2hhbmdlcyBuZWVkZWQgc28gZmFyLgoKSSd2ZSBsb29rZWQgZHVyaW5nIHRo
ZSBpbml0aWFsIHBoYXNlIG9mIHRoZSB1cHN0cmVhbWluZyBwcm9jZXNzIHRvIGFsc28gCmNoZWNr
IHRoZSBBUk02NCBidWlsZCBhbmQgdXNlIC8gaW1wbGVtZW50IGZ1bmN0aW9uYWxpdHkgdGhhdCB3
b3VsZCBub3QgCmJlIHg4NiBzcGVjaWZpYywgaWYgcG9zc2libGUuIEFuZCBpdCB3b3JrZWQgZ29v
ZCwgZm9yIG5vdyBubyBuZWNlc3NhcnkgCnVwZGF0ZXMuCgpUaGUgc3VwcG9ydGVkIGFyY2hpdGVj
dHVyZXMgZm9yIHRoZSBOaXRybyBFbmNsYXZlcyBvdmVyYWxsIHByb2plY3Qgd2lsbCAKYmUgeDg2
IGFuZCBBUk02NCAoeDg2IHN1cHBvcnQgaGFzIGJlZW4gcmVsZWFzZWQsIEFSTTY0IHN1cHBvcnQg
aXMgdG8gYmUgCnJlbGVhc2VkKSwgc28gbWVudGlvbmluZyB0aGVzZSBleHBsaWNpdGx5IGhlcmUu
IE5vIG90aGVyIGFyY2hpdGVjdHVyZXMgCmhhdmUgYmVlbiBjb25zaWRlcmVkIHNvIGZhci4KClRo
YW5rcywKQW5kcmEKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwu
IHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwg
SWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlh
LiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


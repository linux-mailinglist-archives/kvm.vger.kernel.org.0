Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5DE44F320
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 13:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbhKMMrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Nov 2021 07:47:55 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:59404 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbhKMMry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Nov 2021 07:47:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1636807502; x=1668343502;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Zy8wju8zow4/DtC36nApgBbjpJVmv6D+3kczCE/wpTM=;
  b=Yk5oEsRDMcohettY6Pk2VVdlj8jn3kqoaDRKkXcYG4M/+neZsEqj/nTl
   91FKpPc7hUHYra0HLbASFjWuMEv1IygwaxEbAXaWFKAhfo59+oQzLK0my
   57w7g/2ht3C1D2izfQsPqTCbmuuvCNSY24Sq5bcvl604krstreQA9lVxG
   8=;
X-IronPort-AV: E=Sophos;i="5.87,232,1631577600"; 
   d="scan'208";a="41222640"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 13 Nov 2021 12:44:48 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com (Postfix) with ESMTPS id 95E7EC08F1;
        Sat, 13 Nov 2021 12:44:45 +0000 (UTC)
Received: from [192.168.30.21] (10.43.162.153) by EX13D16EUB003.ant.amazon.com
 (10.43.166.99) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Sat, 13 Nov
 2021 12:44:39 +0000
Message-ID: <d4a029e4-bb44-b066-598e-17bbd3ae8bed@amazon.com>
Date:   Sat, 13 Nov 2021 14:44:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH] nitro_enclaves: Remove redundant 'flush_workqueue()'
 calls
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <lexnv@amazon.com>, <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "ne-devel-upstream@amazon.com" <ne-devel-upstream@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <d57f5c7e362837a8dfcde0d726a76b56f114e619.1636736947.git.christophe.jaillet@wanadoo.fr>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
In-Reply-To: <d57f5c7e362837a8dfcde0d726a76b56f114e619.1636736947.git.christophe.jaillet@wanadoo.fr>
X-Originating-IP: [10.43.162.153]
X-ClientProxiedBy: EX13D35UWC004.ant.amazon.com (10.43.162.180) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxMi8xMS8yMDIxIDE5OjA5LCBDaHJpc3RvcGhlIEpBSUxMRVQgd3JvdGU6Cj4gCj4gJ2Rl
c3Ryb3lfd29ya3F1ZXVlKCknIGFscmVhZHkgZHJhaW5zIHRoZSBxdWV1ZSBiZWZvcmUgZGVzdHJv
eWluZyBpdCwgc28KPiB0aGVyZSBpcyBubyBuZWVkIHRvIGZsdXNoIGl0IGV4cGxpY2l0bHkuCj4g
Cj4gUmVtb3ZlIHRoZSByZWR1bmRhbnQgJ2ZsdXNoX3dvcmtxdWV1ZSgpJyBjYWxscy4KPiAKPiBU
aGlzIHdhcyBnZW5lcmF0ZWQgd2l0aCBjb2NjaW5lbGxlOgo+IAo+IEBACj4gZXhwcmVzc2lvbiBF
Owo+IEBACj4gLSAgICAgICBmbHVzaF93b3JrcXVldWUoRSk7Cj4gICAgICAgICAgZGVzdHJveV93
b3JrcXVldWUoRSk7Cj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoZSBKQUlMTEVUIDxjaHJp
c3RvcGhlLmphaWxsZXRAd2FuYWRvby5mcj4KPiAtLS0KPiAgIGRyaXZlcnMvdmlydC9uaXRyb19l
bmNsYXZlcy9uZV9wY2lfZGV2LmMgfCAxIC0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9u
KC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9wY2lf
ZGV2LmMgYi9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfcGNpX2Rldi5jCj4gaW5kZXgg
NDBiNDllYzhlMzBiLi42YjgxZThmM2E1ZGMgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy92aXJ0L25p
dHJvX2VuY2xhdmVzL25lX3BjaV9kZXYuYwo+ICsrKyBiL2RyaXZlcnMvdmlydC9uaXRyb19lbmNs
YXZlcy9uZV9wY2lfZGV2LmMKPiBAQCAtMzc2LDcgKzM3Niw2IEBAIHN0YXRpYyB2b2lkIG5lX3Rl
YXJkb3duX21zaXgoc3RydWN0IHBjaV9kZXYgKnBkZXYpCj4gICAgICAgICAgZnJlZV9pcnEocGNp
X2lycV92ZWN0b3IocGRldiwgTkVfVkVDX0VWRU5UKSwgbmVfcGNpX2Rldik7Cj4gCj4gICAgICAg
ICAgZmx1c2hfd29yaygmbmVfcGNpX2Rldi0+bm90aWZ5X3dvcmspOwo+IC0gICAgICAgZmx1c2hf
d29ya3F1ZXVlKG5lX3BjaV9kZXYtPmV2ZW50X3dxKTsKPiAgICAgICAgICBkZXN0cm95X3dvcmtx
dWV1ZShuZV9wY2lfZGV2LT5ldmVudF93cSk7Cj4gCj4gICAgICAgICAgZnJlZV9pcnEocGNpX2ly
cV92ZWN0b3IocGRldiwgTkVfVkVDX1JFUExZKSwgbmVfcGNpX2Rldik7Cj4gLS0KPiAyLjMwLjIK
PiAKClRoYW5rIHlvdSBmb3IgdGhlIHBhdGNoLgoKUmV2aWV3ZWQtYnk6IEFuZHJhIFBhcmFzY2hp
diA8YW5kcmFwcnNAYW1hem9uLmNvbT4KClRoYW5rcywKQW5kcmEKCgoKQW1hem9uIERldmVsb3Bt
ZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExh
emFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9t
YW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIx
LzIwMDUuCg==


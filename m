Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A36B43CEBF
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 18:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239534AbhJ0Qau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 12:30:50 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:61600 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238295AbhJ0Qau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 12:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1635352105; x=1666888105;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uhdqI/5fJKqafKg8E+s9R22dHtZ3+dwppaLBsR5Vfb8=;
  b=HFrNARvigs5xUFe4Mrb4TXTae3HHrKtrbHRWY8A7brDxUIBMq4BMJFDf
   SoaU8ZVrrhnS8h1b2JYOoFDyioFv1TRGj1r7LwRowcQXydV73HGXA9I7q
   g0pQbbzVVex8WRaN0RXoYO7Wf5crSlxbRpyRTpXQXztPWz0SKn7RkzN7O
   Y=;
X-IronPort-AV: E=Sophos;i="5.87,187,1631577600"; 
   d="scan'208";a="37342986"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 27 Oct 2021 16:28:16 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id D919342832;
        Wed, 27 Oct 2021 16:28:15 +0000 (UTC)
Received: from [10.85.98.65] (10.43.162.153) by EX13D16EUB003.ant.amazon.com
 (10.43.166.99) with Microsoft SMTP Server (TLS) id 15.0.1497.24; Wed, 27 Oct
 2021 16:28:08 +0000
Message-ID: <cc1abeaf-4ea1-0e89-4449-dd87cd321cc7@amazon.com>
Date:   Wed, 27 Oct 2021 19:27:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH] nitro_enclaves: Fix implicit type conversion
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
CC:     <linux-kernel@vger.kernel.org>, <lexnv@amazon.com>,
        <alcioa@amazon.com>, Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "ne-devel-upstream@amazon.com" <ne-devel-upstream@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1635241504-2591251-1-git-send-email-jiasheng@iscas.ac.cn>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
In-Reply-To: <1635241504-2591251-1-git-send-email-jiasheng@iscas.ac.cn>
X-Originating-IP: [10.43.162.153]
X-ClientProxiedBy: EX13D48UWA001.ant.amazon.com (10.43.163.52) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi8xMC8yMDIxIDEyOjQ1LCBKaWFzaGVuZyBKaWFuZyB3cm90ZToKPiAKPiBUaGUgdmFy
aWFibGUgJ2NwdScgaXMgZGVmaW5lZCBhcyB1bnNpZ25lZCBpbnQuCj4gSG93ZXZlciBpbiB0aGUg
Zm9yX2VhY2hfY3B1LCBpdHMgdmFsdWUgaXMgYXNzaWduZWQgdG8gLTEuCj4gVGhhdCBkb2Vzbid0
IG1ha2Ugc2Vuc2UgYW5kIGluIHRoZSBjcHVtYXNrX25leHQoKSBpdCBpcyBpbXBsaWNpdGx5Cj4g
dHlwZSBjb252ZXJzZWQgdG8gaW50Lgo+IEl0IGlzIHVuaXZlcnNhbGx5IGFjY2VwdGVkIHRoYXQg
dGhlIGltcGxpY2l0IHR5cGUgY29udmVyc2lvbiBpcwo+IHRlcnJpYmxlLgo+IEFsc28sIGhhdmlu
ZyB0aGUgZ29vZCBwcm9ncmFtbWluZyBjdXN0b20gd2lsbCBzZXQgYW4gZXhhbXBsZSBmb3IKPiBv
dGhlcnMuCj4gVGh1cywgaXQgbWlnaHQgYmUgYmV0dGVyIHRvIGNoYW5nZSB0aGUgZGVmaW5pdGlv
biBvZiAnY3B1JyBmcm9tCj4gdW5zaWduZWQgaW50IHRvIGludC4KPiAKPiBGaXhlczogZmY4YTRk
MyAoIm5pdHJvX2VuY2xhdmVzOiBBZGQgbG9naWMgZm9yIHNldHRpbmcgYW4gZW5jbGF2ZSB2Q1BV
IikKPiBTaWduZWQtb2ZmLWJ5OiBKaWFzaGVuZyBKaWFuZyA8amlhc2hlbmdAaXNjYXMuYWMuY24+
Cj4gLS0tCj4gICBkcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyB8IDIg
Ky0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+IAo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyBi
L2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jCj4gaW5kZXggZTIxZTFl
OC4uMzhkMWZkOSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVf
bWlzY19kZXYuYwo+ICsrKyBiL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rl
di5jCj4gQEAgLTE2OCw3ICsxNjgsNyBAQCBzdGF0aWMgYm9vbCBuZV9jaGVja19lbmNsYXZlc19j
cmVhdGVkKHZvaWQpCj4gICBzdGF0aWMgaW50IG5lX3NldHVwX2NwdV9wb29sKGNvbnN0IGNoYXIg
Km5lX2NwdV9saXN0KQo+ICAgewo+ICAgICAgICAgIGludCBjb3JlX2lkID0gLTE7Cj4gLSAgICAg
ICB1bnNpZ25lZCBpbnQgY3B1ID0gMDsKPiArICAgICAgIGludCBjcHUgPSAwOwo+ICAgICAgICAg
IGNwdW1hc2tfdmFyX3QgY3B1X3Bvb2w7Cj4gICAgICAgICAgdW5zaWduZWQgaW50IGNwdV9zaWJs
aW5nID0gMDsKPiAgICAgICAgICB1bnNpZ25lZCBpbnQgaSA9IDA7Cj4gLS0KPiAyLjcuNAo+IAoK
VGhhbmsgeW91IGZvciB0aGUgcGF0Y2guIENhbiB5b3UgcGxlYXNlIHVwZGF0ZSB0aGUgb3RoZXIg
b2NjdXJyZW5jZXMgaW4gCnRoZSBzYW1lIGZpbGUgZS5nLiB3aGVuIGEgbG9jYWwgdmFyaWFibGUg
aXMgdXNlZCBmb3IgdGhlICJmb3JfZWFjaF9jcHUiIApsb29wLgoKVGhhbmtzLApBbmRyYQoKWzFd
IApodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxk
cy9saW51eC5naXQvdHJlZS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYu
YyNuMTcxClsyXSAKaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25l
X21pc2NfZGV2LmMjbjE3MwpbM10gCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL2RyaXZlcnMvdmlydC9uaXRyb19l
bmNsYXZlcy9uZV9taXNjX2Rldi5jI24zNzcKWzRdIApodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvdHJlZS9kcml2ZXJzL3Zp
cnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyNuNTE5Cls1XSAKaHR0cHM6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUv
ZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX21pc2NfZGV2LmMjbjU2NQpbNl0gCmh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4
LmdpdC90cmVlL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jI24xMDIw
Cls3XSAKaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9y
dmFsZHMvbGludXguZ2l0L3RyZWUvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX21pc2Nf
ZGV2LmMjbjEzNjMKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwu
IHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwg
SWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlh
LiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


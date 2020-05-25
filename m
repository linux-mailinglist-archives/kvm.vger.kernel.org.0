Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3131E1551
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 22:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390651AbgEYUuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 16:50:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:64614 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgEYUuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 16:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590439813; x=1621975813;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6+yyJokQ78NJbMiUjKAlYDUfTFBLR/t7dFlO+vroyaE=;
  b=j2bTZBWEnJ1me/DfwuPao0vHoaTIXK/Gxqq/fBIaGkFWmMbDrLO/4WwM
   bEexLzcerp5Pl09F/Gb0hUS7ZUgWn0loi3ZSDjUoSwjDkeH6TqWAl7s72
   6MdIqgCGaQPplMfnpOA+/opp9rZK8X93nku5nklISl5etOIjGx7LxASvf
   A=;
IronPort-SDR: SFyHkaUqvEMZim+hPrSaYSCTPNJtfo5/OG/NYtJuBZdEW8sdnyfDPbhGGngvpb03I5rfR2gCSs
 BxNt/ig0SgTA==
X-IronPort-AV: E=Sophos;i="5.73,434,1583193600"; 
   d="scan'208";a="45832444"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 May 2020 20:50:11 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id BB602141722;
        Mon, 25 May 2020 20:50:08 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 20:50:08 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.253) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 20:49:59 +0000
Subject: Re: [PATCH v2 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-8-andraprs@amazon.com>
 <20200522070708.GC771317@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <fa3a72ef-ba0a-ada9-48bf-bd7cef0a8174@amazon.com>
Date:   Mon, 25 May 2020 23:49:50 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522070708.GC771317@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNS8yMDIwIDEwOjA3LCBHcmVnIEtIIHdyb3RlOgo+IE9uIEZyaSwgTWF5IDIyLCAy
MDIwIGF0IDA5OjI5OjM1QU0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gK3N0YXRp
YyBjaGFyICpuZV9jcHVzOwo+PiArbW9kdWxlX3BhcmFtKG5lX2NwdXMsIGNoYXJwLCAwNjQ0KTsK
Pj4gK01PRFVMRV9QQVJNX0RFU0MobmVfY3B1cywgIjxjcHUtbGlzdD4gLSBDUFUgcG9vbCB1c2Vk
IGZvciBOaXRybyBFbmNsYXZlcyIpOwo+IFRoaXMgaXMgbm90IHRoZSAxOTkwJ3MsIGRvbid0IHVz
ZSBtb2R1bGUgcGFyYW1ldGVycyBpZiB5b3UgY2FuIGhlbHAgaXQuCj4gV2h5IGlzIHRoaXMgbmVl
ZGVkLCBhbmQgd2hlcmUgaXMgaXQgZG9jdW1lbnRlZD8KClRoaXMgaXMgYSBDUFUgcG9vbCB0aGF0
IGNhbiBiZSBzZXQgYnkgdGhlIHJvb3QgdXNlciBhbmQgdGhhdCBpbmNsdWRlcyAKQ1BVcyBzZXQg
YXNpZGUgdG8gYmUgdXNlZCBmb3IgdGhlIGVuY2xhdmUocykgc2V0dXA7IHRoZXNlIENQVXMgYXJl
IApvZmZsaW5lZC4gRnJvbSB0aGlzIENQVSBwb29sLCB0aGUga2VybmVsIGxvZ2ljIGNob29zZXMg
dGhlIENQVXMgdGhhdCBhcmUgCnNldCBmb3IgdGhlIGNyZWF0ZWQgZW5jbGF2ZShzKS4KClRoZSBj
cHUtbGlzdCBmb3JtYXQgaXMgbWF0Y2hpbmcgdGhlIHNhbWUgdGhhdCBpcyBkb2N1bWVudGVkIGhl
cmU6CgpodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9hZG1pbi1ndWlkZS9r
ZXJuZWwtcGFyYW1ldGVycy5odG1sCgpJJ3ZlIGFsc28gdGhvdWdodCBvZiBoYXZpbmcgYSBzeXNm
cyBlbnRyeSBmb3IgdGhlIHNldHVwIG9mIHRoaXMgZW5jbGF2ZSAKQ1BVIHBvb2wuCgo+Cj4+ICsv
KiBDUFUgcG9vbCB1c2VkIGZvciBOaXRybyBFbmNsYXZlcy4gKi8KPj4gK3N0cnVjdCBuZV9jcHVf
cG9vbCB7Cj4+ICsJLyogQXZhaWxhYmxlIENQVXMgaW4gdGhlIHBvb2wuICovCj4+ICsJY3B1bWFz
a192YXJfdCBhdmFpbDsKPj4gKwlzdHJ1Y3QgbXV0ZXggbXV0ZXg7Cj4+ICt9Owo+PiArCj4+ICtz
dGF0aWMgc3RydWN0IG5lX2NwdV9wb29sIG5lX2NwdV9wb29sOwo+PiArCj4+ICtzdGF0aWMgaW50
IG5lX29wZW4oc3RydWN0IGlub2RlICpub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKPj4gK3sKPj4g
KwlyZXR1cm4gMDsKPj4gK30KPiBJZiBvcGVuIGRvZXMgbm90aGluZywganVzdCBkb24ndCBldmVu
IHByb3ZpZGUgaXQuCgpJIHJlbW92ZWQgdGhpcyBhbmQgb3RoZXIgZmlsZSBvcHMgb2NjdXJyZW5j
ZXMgdGhhdCBkbyBub3RoaW5nIGZvciBub3cuCgo+Cj4+ICsKPj4gK3N0YXRpYyBsb25nIG5lX2lv
Y3RsKHN0cnVjdCBmaWxlICpmaWxlLCB1bnNpZ25lZCBpbnQgY21kLCB1bnNpZ25lZCBsb25nIGFy
ZykKPj4gK3sKPj4gKwlzd2l0Y2ggKGNtZCkgewo+PiArCj4+ICsJZGVmYXVsdDoKPj4gKwkJcmV0
dXJuIC1FTk9UVFk7Cj4+ICsJfQo+PiArCj4+ICsJcmV0dXJuIDA7Cj4+ICt9Cj4gU2FtZSBmb3Ig
aW9jdGwuCgpUaGlzIGxvZ2ljIGlzIGNvbXBsZXRlZCBpbiB0aGUgbmV4dCBwYXRjaCBpbiB0aGUg
c2VyaWVzLgoKPgo+PiArCj4+ICtzdGF0aWMgaW50IG5lX3JlbGVhc2Uoc3RydWN0IGlub2RlICpp
bm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCj4+ICt7Cj4+ICsJcmV0dXJuIDA7Cj4+ICt9Cj4gU2Ft
ZSBmb3IgcmVsZWFzZS4KCkRvbmUsIEkgcmVtb3ZlZCBpdCBmb3Igbm93LgoKPgo+PiArCj4+ICtz
dGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBuZV9mb3BzID0gewo+PiArCS5vd25l
cgkJPSBUSElTX01PRFVMRSwKPj4gKwkubGxzZWVrCQk9IG5vb3BfbGxzZWVrLAo+PiArCS51bmxv
Y2tlZF9pb2N0bAk9IG5lX2lvY3RsLAo+PiArCS5vcGVuCQk9IG5lX29wZW4sCj4+ICsJLnJlbGVh
c2UJPSBuZV9yZWxlYXNlLAo+PiArfTsKPj4gKwo+PiArc3RydWN0IG1pc2NkZXZpY2UgbmVfbWlz
Y2RldmljZSA9IHsKPj4gKwkubWlub3IJPSBNSVNDX0RZTkFNSUNfTUlOT1IsCj4+ICsJLm5hbWUJ
PSBORV9ERVZfTkFNRSwKPj4gKwkuZm9wcwk9ICZuZV9mb3BzLAo+PiArCS5tb2RlCT0gMDY2MCwK
Pj4gK307Cj4+ICsKPj4gK3N0YXRpYyBpbnQgX19pbml0IG5lX2luaXQodm9pZCkKPj4gK3sKPj4g
Kwl1bnNpZ25lZCBpbnQgY3B1ID0gMDsKPj4gKwl1bnNpZ25lZCBpbnQgY3B1X3NpYmxpbmcgPSAw
Owo+PiArCWludCByYyA9IC1FSU5WQUw7Cj4+ICsKPj4gKwltZW1zZXQoJm5lX2NwdV9wb29sLCAw
LCBzaXplb2YobmVfY3B1X3Bvb2wpKTsKPiBXaHkgZGlkIHlvdSBqdXN0IHNldCBhIHN0cnVjdHVy
ZSB0byAwIHRoYXQgd2FzIGFscmVhZHkgaW5pdGlhbGl6ZWQgYnkKPiB0aGUgc3lzdGVtIHRvIDA/
ICBBcmUgeW91IHN1cmUgYWJvdXQgdGhpcz8KClRydWUsIHRoaXMgaXMgbm90IG5lZWRlZC4gUmVt
b3ZlZCB0aGUgbWVtc2V0KCkgY2FsbC4KCj4KPj4gKwo+PiArCWlmICghemFsbG9jX2NwdW1hc2tf
dmFyKCZuZV9jcHVfcG9vbC5hdmFpbCwgR0ZQX0tFUk5FTCkpCj4+ICsJCXJldHVybiAtRU5PTUVN
Owo+PiArCj4+ICsJbXV0ZXhfaW5pdCgmbmVfY3B1X3Bvb2wubXV0ZXgpOwo+PiArCj4+ICsJcmMg
PSBjcHVsaXN0X3BhcnNlKG5lX2NwdXMsIG5lX2NwdV9wb29sLmF2YWlsKTsKPj4gKwlpZiAocmMg
PCAwKSB7Cj4+ICsJCXByX2Vycl9yYXRlbGltaXRlZChORSAiRXJyb3IgaW4gY3B1bGlzdCBwYXJz
ZSBbcmM9JWRdXG4iLCByYyk7Cj4gQWdhaW4sIGRyb3AgYWxsIHJhdGVsaW1pdGVkIHN0dWZmIHBs
ZWFzZS4KClVwZGF0ZWQgdG8gcHJfZXJyKCkuCgpUaGFuayB5b3UuCgpBbmRyYQoKCgpBbWF6b24g
RGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3
QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAw
MDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIg
SjIyLzI2MjEvMjAwNS4K


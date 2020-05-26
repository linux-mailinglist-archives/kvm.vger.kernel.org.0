Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB4E1E2DD8
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 21:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392511AbgEZTYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 15:24:51 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:24566 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403898AbgEZTHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 15:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590520041; x=1622056041;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=YIt6AL12a3C5b+12pAPxl2an5c1FAkLevMmwCT632D0=;
  b=Ctp/VWvopVWFTlX5iGXAjVDaShxtM64ozPoMV02DMbqNmmGrt2d5Ychs
   atZG4UgLDp+t6Kcd/KG2DVNGX3cnBhf/som0O2padyWH0XzykwsWcxKP8
   N0m+6+cc/cJ+DOX/jFH97p7NPviHEtkQWvgYgNaNWObY3g8za6oRFgmDv
   U=;
IronPort-SDR: KZ53qbEU54y20zeVN8G/Z3rMs2wmEyyu52wxzr0pjanhUchwX4iHFDsCXksnrj02AU19IRi8/J
 qrQeVSuChVQQ==
X-IronPort-AV: E=Sophos;i="5.73,437,1583193600"; 
   d="scan'208";a="32235504"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 26 May 2020 18:35:53 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id AE5F5A1D05;
        Tue, 26 May 2020 18:35:51 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 18:35:51 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.208) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 18:35:41 +0000
Subject: Re: [PATCH v3 04/18] nitro_enclaves: Init PCI device driver
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
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-5-andraprs@amazon.com>
 <20200526064819.GC2580530@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b4bd54ca-8fe2-8ebd-f4fc-012ed2ac498a@amazon.com>
Date:   Tue, 26 May 2020 21:35:33 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526064819.GC2580530@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.208]
X-ClientProxiedBy: EX13D29UWC003.ant.amazon.com (10.43.162.80) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi8wNS8yMDIwIDA5OjQ4LCBHcmVnIEtIIHdyb3RlOgo+IE9uIFR1ZSwgTWF5IDI2LCAy
MDIwIGF0IDAxOjEzOjIwQU0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gVGhlIE5p
dHJvIEVuY2xhdmVzIFBDSSBkZXZpY2UgaXMgdXNlZCBieSB0aGUga2VybmVsIGRyaXZlciBhcyBh
IG1lYW5zIG9mCj4+IGNvbW11bmljYXRpb24gd2l0aCB0aGUgaHlwZXJ2aXNvciBvbiB0aGUgaG9z
dCB3aGVyZSB0aGUgcHJpbWFyeSBWTSBhbmQKPj4gdGhlIGVuY2xhdmVzIHJ1bi4gSXQgaGFuZGxl
cyByZXF1ZXN0cyB3aXRoIHJlZ2FyZCB0byBlbmNsYXZlIGxpZmV0aW1lLgo+Pgo+PiBTZXR1cCB0
aGUgUENJIGRldmljZSBkcml2ZXIgYW5kIGFkZCBzdXBwb3J0IGZvciBNU0ktWCBpbnRlcnJ1cHRz
Lgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUtQ2F0YWxpbiBWYXNpbGUgPGxleG52QGFt
YXpvbi5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBDaW9ib3RhcnUgPGFsY2lvYUBh
bWF6b24uY29tPgo+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFt
YXpvbi5jb20+Cj4+IC0tLQo+PiBDaGFuZ2Vsb2cKPj4KPj4gdjIgLT4gdjMKPj4KPj4gKiBSZW1v
dmUgdGhlIEdQTCBhZGRpdGlvbmFsIHdvcmRpbmcgYXMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXIg
aXMgYWxyZWFkeSBpbgo+PiBwbGFjZS4KPj4gKiBSZW1vdmUgdGhlIFdBUk5fT04gY2FsbHMuCj4+
ICogUmVtb3ZlIGxpbnV4L2J1ZyBpbmNsdWRlIHRoYXQgaXMgbm90IG5lZWRlZC4KPj4gKiBVcGRh
dGUgc3RhdGljIGNhbGxzIHNhbml0eSBjaGVja3MuCj4+ICogUmVtb3ZlICJyYXRlbGltaXRlZCIg
ZnJvbSB0aGUgbG9ncyB0aGF0IGFyZSBub3QgaW4gdGhlIGlvY3RsIGNhbGwgcGF0aHMuCj4+ICog
VXBkYXRlIGt6ZnJlZSgpIGNhbGxzIHRvIGtmcmVlKCkuCj4+Cj4+IHYxIC0+IHYyCj4+Cj4+ICog
QWRkIGxvZyBwYXR0ZXJuIGZvciBORS4KPj4gKiBVcGRhdGUgUENJIGRldmljZSBzZXR1cCBmdW5j
dGlvbnMgdG8gcmVjZWl2ZSBQQ0kgZGV2aWNlIGRhdGEgc3RydWN0dXJlIGFuZAo+PiB0aGVuIGdl
dCBwcml2YXRlIGRhdGEgZnJvbSBpdCBpbnNpZGUgdGhlIGZ1bmN0aW9ucyBsb2dpYy4KPj4gKiBS
ZW1vdmUgdGhlIEJVR19PTiBjYWxscy4KPj4gKiBBZGQgdGVhcmRvd24gZnVuY3Rpb24gZm9yIE1T
SS1YIHNldHVwLgo+PiAqIFVwZGF0ZSBnb3RvIGxhYmVscyB0byBtYXRjaCB0aGVpciBwdXJwb3Nl
Lgo+PiAqIEltcGxlbWVudCBUT0RPIGZvciBORSBQQ0kgZGV2aWNlIGRpc2FibGUgc3RhdGUgY2hl
Y2suCj4+ICogVXBkYXRlIGZ1bmN0aW9uIG5hbWUgZm9yIE5FIFBDSSBkZXZpY2UgcHJvYmUgLyBy
ZW1vdmUuCj4+IC0tLQo+PiAgIGRyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9wY2lfZGV2
LmMgfCAyNTIgKysrKysrKysrKysrKysrKysrKysrKysKPj4gICAxIGZpbGUgY2hhbmdlZCwgMjUy
IGluc2VydGlvbnMoKykKPj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy92aXJ0L25pdHJv
X2VuY2xhdmVzL25lX3BjaV9kZXYuYwo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0L25p
dHJvX2VuY2xhdmVzL25lX3BjaV9kZXYuYyBiL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9u
ZV9wY2lfZGV2LmMKPj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQKPj4gaW5kZXggMDAwMDAwMDAwMDAw
Li4wYjY2MTY2Nzg3YjYKPj4gLS0tIC9kZXYvbnVsbAo+PiArKysgYi9kcml2ZXJzL3ZpcnQvbml0
cm9fZW5jbGF2ZXMvbmVfcGNpX2Rldi5jCj4+IEBAIC0wLDAgKzEsMjUyIEBACj4+ICsvLyBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAo+PiArLyoKPj4gKyAqIENvcHlyaWdodCAyMDIw
IEFtYXpvbi5jb20sIEluYy4gb3IgaXRzIGFmZmlsaWF0ZXMuIEFsbCBSaWdodHMgUmVzZXJ2ZWQu
Cj4+ICsgKi8KPj4gKwo+PiArLyogTml0cm8gRW5jbGF2ZXMgKE5FKSBQQ0kgZGV2aWNlIGRyaXZl
ci4gKi8KPj4gKwo+PiArI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+Cj4+ICsjaW5jbHVkZSA8bGlu
dXgvZGV2aWNlLmg+Cj4+ICsjaW5jbHVkZSA8bGludXgvbGlzdC5oPgo+PiArI2luY2x1ZGUgPGxp
bnV4L211dGV4Lmg+Cj4+ICsjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Cj4+ICsjaW5jbHVkZSA8
bGludXgvbml0cm9fZW5jbGF2ZXMuaD4KPj4gKyNpbmNsdWRlIDxsaW51eC9wY2kuaD4KPj4gKyNp
bmNsdWRlIDxsaW51eC90eXBlcy5oPgo+PiArI2luY2x1ZGUgPGxpbnV4L3dhaXQuaD4KPj4gKwo+
PiArI2luY2x1ZGUgIm5lX21pc2NfZGV2LmgiCj4+ICsjaW5jbHVkZSAibmVfcGNpX2Rldi5oIgo+
PiArCj4+ICsjZGVmaW5lIERFRkFVTFRfVElNRU9VVF9NU0VDUyAoMTIwMDAwKSAvKiAxMjAgc2Vj
ICovCj4+ICsKPj4gKyNkZWZpbmUgTkUgIm5pdHJvX2VuY2xhdmVzOiAiCj4gV2h5IGlzIHRoaXMg
bmVlZGVkPyAgVGhlIGRldl8qIGZ1bmN0aW9ucyBzaG91bGQgZ2l2ZSB5b3UgYWxsIHRoZQo+IGlu
Zm9ybWF0aW9uIHRoYXQgeW91IG5lZWQgdG8gcHJvcGVybHkgZGVzY3JpYmUgdGhlIGRyaXZlciBh
bmQgZGV2aWNlIGluCj4gcXVlc3Rpb24uICBObyBleHRyYSAicHJlZml4ZXMiIHNob3VsZCBiZSBu
ZWVkZWQgYXQgYWxsLgoKVGhpcyB3YXMgbmVlZGVkIHRvIGhhdmUgYW4gaWRlbnRpZmllciBmb3Ig
dGhlIG92ZXJhbGwgTkUgbG9naWMgLSBQQ0kgCmRldiwgaW9jdGwgYW5kIG1pc2MgZGV2LgoKVGhl
IGlvY3RsIGFuZCBtaXNjIGRldiBsb2dpYyBoYXMgcHJfKiBsb2dzLCBidXQgSSBjYW4gdXBkYXRl
IHRoZW0gdG8gCmRldl8qIHdpdGggbWlzYyBkZXYsIHRoZW4gcmVtb3ZlIHRoaXMgcHJlZml4LgoK
VGhhbmsgeW91LgoKQW5kcmEKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkg
Uy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxv
b3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBS
b21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


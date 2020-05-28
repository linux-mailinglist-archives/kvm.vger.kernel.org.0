Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2191E6762
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 18:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405022AbgE1Q01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 12:26:27 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:45832 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404861AbgE1Q00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 12:26:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590683186; x=1622219186;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Y5p4OAGFRjuPFhQIF2YvToWNaYzp09Re2Mjo3Q34L2U=;
  b=O/1IdOkaYPSevyIdsGfr/Xm978RNJ5nOrJde52COzfTn3g4yAD9uj2xq
   nOQ41M0bgNFxNnEy2qEsp3KYZolz/SBF/y1Q+Nlc+zeBD8upddh3oQKQh
   2WlCaf91pjAz5ZMyN1IovC7uqF4oyjBJjp9uzl0wMkYnP6RCv9+jFlZUo
   A=;
IronPort-SDR: o1FYT48HR3nsygGADzqRthFJrdAwtw6If/EzL8Kxi3oPIP/u5SLxGSxh9p5XiKKuBalNk2hHIQ
 5O7MOy3xwFrg==
X-IronPort-AV: E=Sophos;i="5.73,445,1583193600"; 
   d="scan'208";a="38648480"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 May 2020 16:26:23 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 782F4A263A;
        Thu, 28 May 2020 16:26:21 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 16:26:20 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.140) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 16:26:12 +0000
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
 <b4bd54ca-8fe2-8ebd-f4fc-012ed2ac498a@amazon.com>
 <20200526221944.GA179549@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <0f3a1a89-e219-9f20-b956-54c3c559cb1d@amazon.com>
Date:   Thu, 28 May 2020 19:26:04 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526221944.GA179549@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D16UWC004.ant.amazon.com (10.43.162.72) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy8wNS8yMDIwIDAxOjE5LCBHcmVnIEtIIHdyb3RlOgo+IE9uIFR1ZSwgTWF5IDI2LCAy
MDIwIGF0IDA5OjM1OjMzUE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDI2LzA1LzIwMjAgMDk6NDgsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBUdWUsIE1heSAy
NiwgMjAyMCBhdCAwMToxMzoyMEFNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+Pj4g
VGhlIE5pdHJvIEVuY2xhdmVzIFBDSSBkZXZpY2UgaXMgdXNlZCBieSB0aGUga2VybmVsIGRyaXZl
ciBhcyBhIG1lYW5zIG9mCj4+Pj4gY29tbXVuaWNhdGlvbiB3aXRoIHRoZSBoeXBlcnZpc29yIG9u
IHRoZSBob3N0IHdoZXJlIHRoZSBwcmltYXJ5IFZNIGFuZAo+Pj4+IHRoZSBlbmNsYXZlcyBydW4u
IEl0IGhhbmRsZXMgcmVxdWVzdHMgd2l0aCByZWdhcmQgdG8gZW5jbGF2ZSBsaWZldGltZS4KPj4+
Pgo+Pj4+IFNldHVwIHRoZSBQQ0kgZGV2aWNlIGRyaXZlciBhbmQgYWRkIHN1cHBvcnQgZm9yIE1T
SS1YIGludGVycnVwdHMuCj4+Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUtQ2F0YWxp
biBWYXNpbGUgPGxleG52QGFtYXpvbi5jb20+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1
IENpb2JvdGFydSA8YWxjaW9hQGFtYXpvbi5jb20+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmEg
UGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+Pj4+IC0tLQo+Pj4+IENoYW5nZWxvZwo+
Pj4+Cj4+Pj4gdjIgLT4gdjMKPj4+Pgo+Pj4+ICogUmVtb3ZlIHRoZSBHUEwgYWRkaXRpb25hbCB3
b3JkaW5nIGFzIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyIGlzIGFscmVhZHkgaW4KPj4+PiBwbGFj
ZS4KPj4+PiAqIFJlbW92ZSB0aGUgV0FSTl9PTiBjYWxscy4KPj4+PiAqIFJlbW92ZSBsaW51eC9i
dWcgaW5jbHVkZSB0aGF0IGlzIG5vdCBuZWVkZWQuCj4+Pj4gKiBVcGRhdGUgc3RhdGljIGNhbGxz
IHNhbml0eSBjaGVja3MuCj4+Pj4gKiBSZW1vdmUgInJhdGVsaW1pdGVkIiBmcm9tIHRoZSBsb2dz
IHRoYXQgYXJlIG5vdCBpbiB0aGUgaW9jdGwgY2FsbCBwYXRocy4KPj4+PiAqIFVwZGF0ZSBremZy
ZWUoKSBjYWxscyB0byBrZnJlZSgpLgo+Pj4+Cj4+Pj4gdjEgLT4gdjIKPj4+Pgo+Pj4+ICogQWRk
IGxvZyBwYXR0ZXJuIGZvciBORS4KPj4+PiAqIFVwZGF0ZSBQQ0kgZGV2aWNlIHNldHVwIGZ1bmN0
aW9ucyB0byByZWNlaXZlIFBDSSBkZXZpY2UgZGF0YSBzdHJ1Y3R1cmUgYW5kCj4+Pj4gdGhlbiBn
ZXQgcHJpdmF0ZSBkYXRhIGZyb20gaXQgaW5zaWRlIHRoZSBmdW5jdGlvbnMgbG9naWMuCj4+Pj4g
KiBSZW1vdmUgdGhlIEJVR19PTiBjYWxscy4KPj4+PiAqIEFkZCB0ZWFyZG93biBmdW5jdGlvbiBm
b3IgTVNJLVggc2V0dXAuCj4+Pj4gKiBVcGRhdGUgZ290byBsYWJlbHMgdG8gbWF0Y2ggdGhlaXIg
cHVycG9zZS4KPj4+PiAqIEltcGxlbWVudCBUT0RPIGZvciBORSBQQ0kgZGV2aWNlIGRpc2FibGUg
c3RhdGUgY2hlY2suCj4+Pj4gKiBVcGRhdGUgZnVuY3Rpb24gbmFtZSBmb3IgTkUgUENJIGRldmlj
ZSBwcm9iZSAvIHJlbW92ZS4KPj4+PiAtLS0KPj4+PiAgICBkcml2ZXJzL3ZpcnQvbml0cm9fZW5j
bGF2ZXMvbmVfcGNpX2Rldi5jIHwgMjUyICsrKysrKysrKysrKysrKysrKysrKysrCj4+Pj4gICAg
MSBmaWxlIGNoYW5nZWQsIDI1MiBpbnNlcnRpb25zKCspCj4+Pj4gICAgY3JlYXRlIG1vZGUgMTAw
NjQ0IGRyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9wY2lfZGV2LmMKPj4+Pgo+Pj4+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfcGNpX2Rldi5jIGIvZHJp
dmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX3BjaV9kZXYuYwo+Pj4+IG5ldyBmaWxlIG1vZGUg
MTAwNjQ0Cj4+Pj4gaW5kZXggMDAwMDAwMDAwMDAwLi4wYjY2MTY2Nzg3YjYKPj4+PiAtLS0gL2Rl
di9udWxsCj4+Pj4gKysrIGIvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX3BjaV9kZXYu
Ywo+Pj4+IEBAIC0wLDAgKzEsMjUyIEBACj4+Pj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wCj4+Pj4gKy8qCj4+Pj4gKyAqIENvcHlyaWdodCAyMDIwIEFtYXpvbi5jb20sIElu
Yy4gb3IgaXRzIGFmZmlsaWF0ZXMuIEFsbCBSaWdodHMgUmVzZXJ2ZWQuCj4+Pj4gKyAqLwo+Pj4+
ICsKPj4+PiArLyogTml0cm8gRW5jbGF2ZXMgKE5FKSBQQ0kgZGV2aWNlIGRyaXZlci4gKi8KPj4+
PiArCj4+Pj4gKyNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgo+Pj4+ICsjaW5jbHVkZSA8bGludXgv
ZGV2aWNlLmg+Cj4+Pj4gKyNpbmNsdWRlIDxsaW51eC9saXN0Lmg+Cj4+Pj4gKyNpbmNsdWRlIDxs
aW51eC9tdXRleC5oPgo+Pj4+ICsjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Cj4+Pj4gKyNpbmNs
dWRlIDxsaW51eC9uaXRyb19lbmNsYXZlcy5oPgo+Pj4+ICsjaW5jbHVkZSA8bGludXgvcGNpLmg+
Cj4+Pj4gKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgo+Pj4+ICsjaW5jbHVkZSA8bGludXgvd2Fp
dC5oPgo+Pj4+ICsKPj4+PiArI2luY2x1ZGUgIm5lX21pc2NfZGV2LmgiCj4+Pj4gKyNpbmNsdWRl
ICJuZV9wY2lfZGV2LmgiCj4+Pj4gKwo+Pj4+ICsjZGVmaW5lIERFRkFVTFRfVElNRU9VVF9NU0VD
UyAoMTIwMDAwKSAvKiAxMjAgc2VjICovCj4+Pj4gKwo+Pj4+ICsjZGVmaW5lIE5FICJuaXRyb19l
bmNsYXZlczogIgo+Pj4gV2h5IGlzIHRoaXMgbmVlZGVkPyAgVGhlIGRldl8qIGZ1bmN0aW9ucyBz
aG91bGQgZ2l2ZSB5b3UgYWxsIHRoZQo+Pj4gaW5mb3JtYXRpb24gdGhhdCB5b3UgbmVlZCB0byBw
cm9wZXJseSBkZXNjcmliZSB0aGUgZHJpdmVyIGFuZCBkZXZpY2UgaW4KPj4+IHF1ZXN0aW9uLiAg
Tm8gZXh0cmEgInByZWZpeGVzIiBzaG91bGQgYmUgbmVlZGVkIGF0IGFsbC4KPj4gVGhpcyB3YXMg
bmVlZGVkIHRvIGhhdmUgYW4gaWRlbnRpZmllciBmb3IgdGhlIG92ZXJhbGwgTkUgbG9naWMgLSBQ
Q0kgZGV2LAo+PiBpb2N0bCBhbmQgbWlzYyBkZXYuCj4gV2h5PyAgVGhleSBhcmUgYWxsIGRpZmZl
cmVudCAiZGV2aWNlcyIsIGFuZCByZWZlciB0byBkaWZmZXJlbnQKPiBpbnRlcmZhY2VzLiAgU3Rp
Y2sgdG8gd2hhdCB0aGUgZGV2XyogZ2l2ZXMgeW91IGZvciB0aGVtLiAgWW91IHByb2JhYmx5Cj4g
d2FudCB0byBzdGljayB3aXRoIHRoZSBwY2kgZGV2IGZvciBhbG1vc3QgYWxsIG9mIHRob3NlIGFu
eXdheS4KPgo+PiBUaGUgaW9jdGwgYW5kIG1pc2MgZGV2IGxvZ2ljIGhhcyBwcl8qIGxvZ3MsIGJ1
dCBJIGNhbiB1cGRhdGUgdGhlbSB0byBkZXZfKgo+PiB3aXRoIG1pc2MgZGV2LCB0aGVuIHJlbW92
ZSB0aGlzIHByZWZpeC4KPiBUaGF0IHdvdWxkIGJlIGdvb2QsIHRoYW5rcy4KClRoYXQncyBhbHJl
YWR5IGluIHY0LCB0aGUgcHJfKiBsb2dzIGFyZSBub3cgcmVwbGFjZWQgd2l0aCBkZXZfKi4KClRo
YW5rcywKQW5kcmEKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwu
IHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwg
SWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlh
LiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


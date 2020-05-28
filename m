Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3CF1E685C
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 19:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405438AbgE1RJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 13:09:49 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:59176 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgE1RJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 13:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590685787; x=1622221787;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Y47PD9Fgt1BpAPCnLD3kkehkyhpdAZIUSbUqVBrWCEQ=;
  b=TtWlT2D6wJZmWrAsIiQjaV6ahrOHzQAAuaQIRhpPUIFasKTVqg8eBw6O
   pZXju5qTLrPdW2jg4fxT6TMyGsQoPIWD9gJNMpzijdvdmFLsv7mLTOFqL
   IyVKjrmekU26qGdPq3vydMuckNFotabF5IWzCMCxIEo8VpbOdDMFcBjTj
   4=;
IronPort-SDR: W7t8AI/CpDTG5V31eWTPKNgImk05ZFAZUU9Ld1WEMb0RcKMLAneaSKaNep7WBSe2EkgcjCBmUq
 5PAR+rMIyRLw==
X-IronPort-AV: E=Sophos;i="5.73,445,1583193600"; 
   d="scan'208";a="32862205"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 28 May 2020 17:06:37 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 32D04A1881;
        Thu, 28 May 2020 17:06:35 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 17:06:34 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.48) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 17:06:25 +0000
Subject: Re: [PATCH v3 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alexander Graf <graf@amazon.de>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-8-andraprs@amazon.com>
 <20200526065133.GD2580530@kroah.com>
 <72647fa4-79d9-7754-9843-a254487703ea@amazon.de>
 <20200526123300.GA2798@kroah.com>
 <59007eb9-fad3-9655-a856-f5989fa9fdb3@amazon.de>
 <20200526131708.GA9296@kroah.com>
 <29ebdc29-2930-51af-8a54-279c1e449a48@amazon.de>
 <20200526222402.GC179549@kroah.com>
 <b4f17cbd-7471-fe61-6e7e-1399bd96e24e@amazon.de>
 <20200528131259.GA3345766@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <46b2e9c5-6186-5c37-197c-8acd0bce358e@amazon.com>
Date:   Thu, 28 May 2020 20:06:19 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200528131259.GA3345766@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D16UWB003.ant.amazon.com (10.43.161.194) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyOC8wNS8yMDIwIDE2OjEyLCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gVGh1LCBNYXkgMjgs
IDIwMjAgYXQgMDM6MDE6MzZQTSArMDIwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Cj4+IE9u
IDI3LjA1LjIwIDAwOjI0LCBHcmVnIEtIIHdyb3RlOgo+Pj4gT24gVHVlLCBNYXkgMjYsIDIwMjAg
YXQgMDM6NDQ6MzBQTSArMDIwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Pj4KPj4+PiBPbiAy
Ni4wNS4yMCAxNToxNywgR3JlZyBLSCB3cm90ZToKPj4+Pj4gT24gVHVlLCBNYXkgMjYsIDIwMjAg
YXQgMDI6NDQ6MThQTSArMDIwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Pj4+Pgo+Pj4+Pj4g
T24gMjYuMDUuMjAgMTQ6MzMsIEdyZWcgS0ggd3JvdGU6Cj4+Pj4+Pj4gT24gVHVlLCBNYXkgMjYs
IDIwMjAgYXQgMDE6NDI6NDFQTSArMDIwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Pj4+Pj4+
Cj4+Pj4+Pj4+IE9uIDI2LjA1LjIwIDA4OjUxLCBHcmVnIEtIIHdyb3RlOgo+Pj4+Pj4+Pj4gT24g
VHVlLCBNYXkgMjYsIDIwMjAgYXQgMDE6MTM6MjNBTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdy
b3RlOgo+Pj4+Pj4+Pj4+ICsjZGVmaW5lIE5FICJuaXRyb19lbmNsYXZlczogIgo+Pj4+Pj4+Pj4g
QWdhaW4sIG5vIG5lZWQgZm9yIHRoaXMuCj4+Pj4+Pj4+Pgo+Pj4+Pj4+Pj4+ICsjZGVmaW5lIE5F
X0RFVl9OQU1FICJuaXRyb19lbmNsYXZlcyIKPj4+Pj4+Pj4+IEtCVUlMRF9NT0ROQU1FPwo+Pj4+
Pj4+Pj4KPj4+Pj4+Pj4+PiArI2RlZmluZSBORV9JTUFHRV9MT0FEX09GRlNFVCAoOCAqIDEwMjRV
TCAqIDEwMjRVTCkKPj4+Pj4+Pj4+PiArCj4+Pj4+Pj4+Pj4gK3N0YXRpYyBjaGFyICpuZV9jcHVz
Owo+Pj4+Pj4+Pj4+ICttb2R1bGVfcGFyYW0obmVfY3B1cywgY2hhcnAsIDA2NDQpOwo+Pj4+Pj4+
Pj4+ICtNT0RVTEVfUEFSTV9ERVNDKG5lX2NwdXMsICI8Y3B1LWxpc3Q+IC0gQ1BVIHBvb2wgdXNl
ZCBmb3IgTml0cm8gRW5jbGF2ZXMiKTsKPj4+Pj4+Pj4+IEFnYWluLCBwbGVhc2UgZG8gbm90IGRv
IHRoaXMuCj4+Pj4+Pj4+IEkgYWN0dWFsbHkgYXNrZWQgaGVyIHRvIHB1dCB0aGlzIG9uZSBpbiBz
cGVjaWZpY2FsbHkuCj4+Pj4+Pj4+Cj4+Pj4+Pj4+IFRoZSBjb25jZXB0IG9mIHRoaXMgcGFyYW1l
dGVyIGlzIHZlcnkgc2ltaWxhciB0byBpc29sY3B1cz0gYW5kIG1heGNwdXM9IGluCj4+Pj4+Pj4+
IHRoYXQgaXQgdGFrZXMgQ1BVcyBhd2F5IGZyb20gTGludXggYW5kIGluc3RlYWQgZG9uYXRlcyB0
aGVtIHRvIHRoZQo+Pj4+Pj4+PiB1bmRlcmx5aW5nIGh5cGVydmlzb3IsIHNvIHRoYXQgaXQgY2Fu
IHNwYXduIGVuY2xhdmVzIHVzaW5nIHRoZW0uCj4+Pj4+Pj4+Cj4+Pj4+Pj4+ICAgICBGcm9tIGFu
IGFkbWluJ3MgcG9pbnQgb2YgdmlldywgdGhpcyBpcyBhIHNldHRpbmcgSSB3b3VsZCBsaWtlIHRv
IGtlZXAKPj4+Pj4+Pj4gcGVyc2lzdGVkIGFjcm9zcyByZWJvb3RzLiBIb3cgd291bGQgdGhpcyB3
b3JrIHdpdGggc3lzZnM/Cj4+Pj4+Pj4gSG93IGFib3V0IGp1c3QgYXMgdGhlICJpbml0aWFsIiBp
b2N0bCBjb21tYW5kIHRvIHNldCB0aGluZ3MgdXA/ICBEb24ndAo+Pj4+Pj4+IGdyYWIgYW55IGNw
dSBwb29scyB1bnRpbCBhc2tlZCB0by4gIE90aGVyd2lzZSwgd2hhdCBoYXBwZW5zIHdoZW4geW91
Cj4+Pj4+Pj4gbG9hZCB0aGlzIG1vZHVsZSBvbiBhIHN5c3RlbSB0aGF0IGNhbid0IHN1cHBvcnQg
aXQ/Cj4+Pj4+PiBUaGF0IHdvdWxkIGdpdmUgYW55IHVzZXIgd2l0aCBhY2Nlc3MgdG8gdGhlIGVu
Y2xhdmUgZGV2aWNlIHRoZSBhYmlsaXR5IHRvCj4+Pj4+PiByZW1vdmUgQ1BVcyBmcm9tIHRoZSBz
eXN0ZW0uIFRoYXQncyBjbGVhcmx5IGEgQ0FQX0FETUlOIHRhc2sgaW4gbXkgYm9vay4KPj4+Pj4g
T2ssIHdoYXQncyB3cm9uZyB3aXRoIHRoYXQ/Cj4+Pj4gV291bGQgeW91IHdhbnQgcmFuZG9tIHVz
ZXJzIHRvIGdldCB0aGUgYWJpbGl0eSB0byBob3QgdW5wbHVnIENQVXMgZnJvbSB5b3VyCj4+Pj4g
c3lzdGVtPyBBdCB1bmxpbWl0ZWQgcXVhbnRpdHk/IEkgZG9uJ3QgOikuCj4+PiBBIHJhbmRvbSB1
c2VyLCBubywgYnV0IG9uZSB3aXRoIGFkbWluIHJpZ2h0cywgd2h5IG5vdD8gIFRoZXkgY2FuIGRv
IHRoYXQKPj4+IGFscmVhZHkgdG9kYXkgb24geW91ciBzeXN0ZW0sIHRoaXMgaXNuJ3QgbmV3Lgo+
Pj4KPj4+Pj4+IEhlbmNlIHRoaXMgd2hvbGUgc3BsaXQ6IFRoZSBhZG1pbiBkZWZpbmVzIHRoZSBD
UFUgUG9vbCwgdXNlcnMgY2FuIHNhZmVseQo+Pj4+Pj4gY29uc3VtZSB0aGlzIHBvb2wgdG8gc3Bh
d24gZW5jbGF2ZXMgZnJvbSBpdC4KPj4+Pj4gQnV0IGhhdmluZyB0aGUgYWRtaW4gZGVmaW5lIHRo
YXQgYXQgbW9kdWxlIGxvYWQgLyBib290IHRpbWUsIGlzIGEgbWFqb3IKPj4+Pj4gcGFpbi4gIFdo
YXQgdG9vbHMgZG8gdGhleSBoYXZlIHRoYXQgYWxsb3cgdGhlbSB0byBkbyB0aGF0IGVhc2lseT8K
Pj4+PiBUaGUgbm9ybWFsIHRvb2xib3g6IGVkaXRpbmcgL2V0Yy9kZWZhdWx0L2dydWIsIGFkZGlu
ZyBhbiAvZXRjL21vZHByb2JlLmQvCj4+Pj4gZmlsZS4KPj4+IEVkaXRpbmcgZ3J1YiBmaWxlcyBp
cyBob3JyaWQsIGNvbWUgb24uLi4KPj4gSXQncyBub3QgZWRpdGluZyBncnViIGZpbGVzLCBpdCdz
IGVkaXRpbmcgdGVtcGxhdGUgY29uZmlnIGZpbGVzIHRoYXQgdGhlbgo+PiBhcmUgdXNlZCBhcyBp
bnB1dCBmb3IgZ3J1YiBjb25maWcgZmlsZSBnZW5lcmF0aW9uIDopLgo+Pgo+Pj4+IFdoZW4gYnV0
IGF0IG1vZHVsZSBsb2FkIC8gYm9vdCB0aW1lIHdvdWxkIHlvdSBkZWZpbmUgaXQ/IEkgcmVhbGx5
IGRvbid0IHdhbnQKPj4+PiB0byBoYXZlIGEgZGV2aWNlIG5vZGUgdGhhdCBpbiB0aGVvcnkgInRo
ZSB3b3JsZCIgY2FuIHVzZSB3aGljaCB0aGVuIGFsbG93cwo+Pj4+IGFueSB1c2VyIG9uIHRoZSBz
eXN0ZW0gdG8gaG90IHVucGx1ZyBldmVyeSBDUFUgYnV0IDAgZnJvbSBteSBzeXN0ZW0uCj4+PiBC
dXQgeW91IGhhdmUgdGhhdCBhbHJlYWR5IHdoZW4gdGhlIFBDSSBkZXZpY2UgaXMgZm91bmQsIHJp
Z2h0PyAgV2hhdCBpcwo+Pj4gdGhlIGluaXRpYWwgaW50ZXJmYWNlIHRvIHRoZSBkcml2ZXI/ICBX
aGF0J3Mgd3Jvbmcgd2l0aCB1c2luZyB0aGF0Pwo+Pj4KPj4+IE9yIGFtIEkgcmVhbGx5IG1pc3Np
bmcgc29tZXRoaW5nIGFzIHRvIGhvdyB0aGlzIGFsbCBmaXRzIHRvZ2V0aGVyIHdpdGgKPj4+IHRo
ZSBkaWZmZXJlbnQgcGllY2VzPyAgU2VlaW5nIHRoZSBwYXRjaGVzIGFzLWlzIGRvZXNuJ3QgcmVh
bGx5IHByb3ZpZGUgYQo+Pj4gZ29vZCBvdmVydmlldywgc29ycnkuCj4+IE9rLCBsZXQgbWUgd2Fs
ayB5b3UgdGhyb3VnaCB0aGUgY29yZSBkb25hdGlvbiBwcm9jZXNzLgo+Pgo+PiBJbWFnaW5lIHlv
dSBoYXZlIGEgcGFyZW50IFZNIHdpdGggOCBjb3Jlcy4gRXZlcnkgb25lIG9mIHRob3NlIHZpcnR1
YWwgY29yZXMKPj4gaXMgMToxIG1hcHBlZCB0byBhIHBoeXNpY2FsIGNvcmUuCj4+Cj4+IFlvdSBl
bnVtZXJhdGUgdGhlIFBDSSBkZXZpY2UsIHlvdSBzdGFydCB3b3JraW5nIHdpdGggaXQuIE5vbmUg
b2YgdGhhdAo+PiBjaGFuZ2VzIHlvdXIgdG9wb2xvZ3kuCj4+Cj4+IFlvdSBub3cgY3JlYXRlIGFu
IGVuY2xhdmUgc3Bhbm5pbmcgMiBjb3Jlcy4gVGhlIGh5cGVydmlzb3Igd2lsbCByZW1vdmUgdGhl
Cj4+IDE6MSBtYXAgZm9yIHRob3NlIDIgY29yZXMgYW5kIGluc3RlYWQgbWFyayB0aGVtIGFzICJm
cmVlIGZsb2F0aW5nIiBvbiB0aGUKPj4gcmVtYWluaW5nIDYgY29yZXMuIEl0IHRoZW4gdXNlcyB0
aGUgMiBmcmVlZCB1cCBjb3JlcyBhbmQgY3JlYXRlcyBhIDE6MSBtYXAKPj4gZm9yIHRoZSBlbmNs
YXZlJ3MgMiBjb3Jlcwo+Pgo+PiBUbyBlbnN1cmUgdGhhdCB3ZSBzdGlsbCBzZWUgYSByZWFsaXN0
aWMgbWFwcGluZyBvZiBjb3JlIHRvcG9sb2d5LCB3ZSBuZWVkIHRvCj4+IHJlbW92ZSB0aG9zZSAy
IGNvcmVzIGZyb20gdGhlIHBhcmVudCBWTSdzIHNjb3BlIG9mIGV4ZWN1dGlvbi4gVGhlIHdheSB0
aGlzCj4+IGlzIGRvbmUgdG9kYXkgaXMgYnkgZ29pbmcgdGhyb3VnaCBDUFUgb2ZmbGluaW5nLgo+
Pgo+PiBUaGUgZmlyc3QgYW5kIG9idmlvdXMgb3B0aW9uIHdvdWxkIGJlIHRvIG9mZmxpbmUgYWxs
IHJlc3BlY3RpdmUgQ1BVcyB3aGVuIGFuCj4+IGVuY2xhdmUgZ2V0cyBjcmVhdGVkLiBCdXQgdW5w
cml2aWxlZ2VkIHVzZXJzIHNob3VsZCBiZSBhYmxlIHRvIHNwYXduCj4+IGVuY2xhdmVzLiBTbyBo
b3cgZG8gSSBlbnN1cmUgdGhhdCBteSB1bnByaXZpbGVnZWQgdXNlciBkb2Vzbid0IGp1c3Qgb2Zm
bGluZQo+PiBhbGwgb2YgbXkgcGFyZW50IFZNJ3MgQ1BVcz8KPj4KPj4gVGhlIG9wdGlvbiBpbXBs
ZW1lbnRlZCBoZXJlIGlzIHRoYXQgd2UgZm9sZCB0aGlzIGludG8gYSB0d28tc3RhZ2UgYXBwcm9h
Y2guCj4+IFRoZSBhZG1pbiByZXNlcnZlcyBhICJwb29sIiBvZiBjb3JlcyBmb3IgZW5jbGF2ZXMg
dG8gdXNlLiBVbnByaXZpbGVnZWQgdXNlcnMKPj4gY2FuIHRoZW4gY29uc3VtZSBjb3JlcyBmcm9t
IHRoYXQgcG9vbCwgYnV0IG5vdCBtb3JlIHRoYW4gdGhvc2UuCj4+Cj4+IFRoYXQgd2F5LCB1bnBy
aXZpbGVnZWQgdXNlcnMgaGF2ZSBubyBpbmZsdWVuY2Ugb3ZlciB3aGV0aGVyIGEgY29yZSBpcwo+
PiBlbmFibGVkIG9yIG5vdC4gVGhleSBjYW4gb25seSBjb25zdW1lIHRoZSBwb29sIG9mIGNvcmVz
IHRoYXQgd2FzIGRlZGljYXRlZAo+PiBmb3IgZW5jbGF2ZSB1c2UuCj4+Cj4+IEl0IGFsc28gaGFz
IHRoZSBiaWcgYWR2YW50YWdlIHRoYXQgeW91IGRvbid0IGhhdmUgZHluYW1pY2FsbHkgY2hhbmdp
bmcgQ1BVCj4+IHRvcG9sb2d5IGluIHlvdXIgc3lzdGVtLiBMb25nIGxpdmluZyBwcm9jZXNzZXMg
dGhhdCBhZGp1c3QgdGhlaXIgZW52aXJvbm1lbnQKPj4gdG8gdGhlIHRvcG9sb2d5IGNhbiBzdGls
bCBkbyBzbywgd2l0aG91dCBjb3JlcyBnZXR0aW5nIHB1bGxlZCBvdXQgdW5kZXIKPj4gdGhlaXIg
ZmVldC4KPiBPaywgdGhhdCBtYWtlcyBtb3JlIHNlbnNlLCBidXQ6Cj4KPj4+Pj4+IFNvIEkgcmVh
bGx5IGRvbid0IHRoaW5rIGFuIGlvY3RsIHdvdWxkIGJlIGEgZ3JlYXQgdXNlciBleHBlcmllbmNl
LiBTYW1lIGZvcgo+Pj4+Pj4gYSBzeXNmcyBmaWxlIC0gYWx0aG91Z2ggdGhhdCdzIHByb2JhYmx5
IHNsaWdodGx5IGJldHRlciB0aGFuIHRoZSBpb2N0bC4KPj4+Pj4gWW91IGFscmVhZHkgYXJlIHVz
aW5nIGlvY3RscyB0byBjb250cm9sIHRoaXMgdGhpbmcsIHJpZ2h0PyAgV2hhdCdzIHdyb25nCj4+
Pj4+IHdpdGggIm9uZSBtb3JlIj8gOikKPj4+PiBTbyB3aGF0IHdlICpjb3VsZCogZG8gaXMgYWRk
IGFuIGlvY3RsIHRvIHNldCB0aGUgcG9vbCBzaXplIHdoaWNoIHRoZW4gZG9lcyBhCj4+Pj4gQ0FQ
X0FETUlOIGNoZWNrLiBUaGF0IGhvd2V2ZXIgbWVhbnMgeW91IG5vdyBhcmUgaW4gcHJpb3JpdHkg
aGVsbDoKPj4+Pgo+Pj4+IEEgdXNlciB0aGF0IHdhbnRzIHRvIHNwYXduIGFuIGVuY2xhdmUgYXMg
cGFydCBvZiBhbiBuZ2lueCBzZXJ2aWNlIHdvdWxkIG5lZWQKPj4+PiB0byBjcmVhdGUgYW5vdGhl
ciBzZXJ2aWNlIHRvIHNldCB0aGUgcG9vbCBzaXplIGFuZCBpbmRpY2F0ZSB0aGUgZGVwZW5kZW5j
eQo+Pj4+IGluIHN5c3RlbWQgY29udHJvbCBmaWxlcy4KPj4+Pgo+Pj4+IElzIHRoYXQgcmVhbGx5
IGJldHRlciB0aGFuIGEgbW9kdWxlIHBhcmFtZXRlcj8KPj4+IG1vZHVsZSBwYXJhbWV0ZXJzIGFy
ZSBoYXJkIHRvIGNoYW5nZSwgYW5kIG1hbmFnZSBjb250cm9sIG92ZXIgd2hvIHJlYWxseQo+Pj4g
aXMgY2hhbmdpbmcgdGhlbS4KPj4gV2hhdCBpcyBoYXJkIGFib3V0Cj4+Cj4+ICQgZWNobyAxLTUg
PiAvc3lzL21vZHVsZS9uaXRyb19lbmNsYXZlcy9wYXJhbWV0ZXJzL25lX2NwdXMKPiBTbyBhdCBy
dW50aW1lLCBhZnRlciBhbGwgaXMgYm9vdGVkIGFuZCB1cCBhbmQgZ29pbmcsIHlvdSBqdXN0IHJp
cHBlZAo+IGNvcmVzIG91dCBmcm9tIHVuZGVyIHNvbWVvbmUncyBmZWV0PyAgOikKPgo+IEFuZCB0
aGUgY29kZSByZWFsbHkgaGFuZGxlcyB3cml0aW5nIHRvIHRoYXQgdmFsdWUgd2hpbGUgdGhlIG1v
ZHVsZSBpcwo+IGFscmVhZHkgbG9hZGVkIGFuZCB1cCBhbmQgcnVubmluZz8gIEF0IGEgcXVpY2sg
Z2xhbmNlLCBpdCBkaWRuJ3Qgc2VlbQo+IGxpa2UgaXQgd291bGQgaGFuZGxlIHRoYXQgdmVyeSB3
ZWxsIGFzIGl0IG9ubHkgaXMgY2hlY2tlZCBhdCBuZV9pbml0KCkKPiB0aW1lLgo+Cj4gT3IgYW0g
SSBtaXNzaW5nIHNvbWV0aGluZz8KCkl0J3MgY2hlY2tlZCBmb3Igbm93IGF0IG1vZHVsZSBpbml0
LCB0cnVlLgoKSSBzdGFydGVkIHdpdGggaW5pdCBhbmQgaXQgcmVtYWluZWQgYXMgYSBUT0RPIG9u
IG15IHNpZGUgdG8gYWRhcHQgdGhlIApsb2dpYyB0byBiZSBhYmxlIHRvIGhhbmRsZSB0aGUgc2V0
dXAgdmlhIHRoZSBzeXNmcyBmaWxlIGZvciB0aGUgbW9kdWxlLgoKClRoYW5rcywKQW5kcmEKCj4K
PiBBbnl3YXksIHllcywgaWYgeW91IGNhbiBkeW5hbWljYWxseSBkbyB0aGlzIGF0IHJ1bnRpbWUs
IHRoYXQncyBncmVhdCwKPiBidXQgaXQgZmVlbHMgYWNrd2FyZCB0byBtZSB0byByZWx5IG9uIG9u
ZSBjb25maWd1cmF0aW9uIHRoaW5nIGFzIGEKPiBtb2R1bGUgcGFyYW1ldGVyLCBhbmQgZXZlcnl0
aGluZyBlbHNlIHRocm91Z2ggdGhlIGlvY3RsIGludGVyZmFjZS4KPiBVbmlmaWNhdGlvbiB3b3Vs
ZCBzZWVtIHRvIGJlIGEgZ29vZCB0aGluZywgcmlnaHQ/Cj4KPiB0aGFua3MsCj4KPiBncmVnIGst
aAoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVy
ZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFz
aSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3Ry
YXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


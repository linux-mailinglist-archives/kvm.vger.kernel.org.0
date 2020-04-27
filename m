Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D941BACFA
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgD0Sj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:39:57 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:27582 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgD0Sjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588012794; x=1619548794;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0zw8csosQ2772lO+gJ66gnbee1AQRPxZsNUMtHWW5VE=;
  b=YgpeyT2WfuZLJtQLxmLVYXylEtiXglc99KFnHpgnryuTFSVN9SGTIz+/
   p/iLvNNjYS/z6dBhuYbIno+fv2Knad3zeToOgeIZSXIdeyk12hoMzzxlp
   NuQkWd+oarsNJ0/kiHMdzmXGNZwAClXUlJsbouxycJZTTQbO/NCbDyr6v
   M=;
IronPort-SDR: fabMjVoImFNaUL1nJnqy7tUnW3p1yASBvPgPI0kaZ8zLTUOsOvXpIWXa6pZfCJHUuFK+sOY6SZ
 7viFQzrNgycQ==
X-IronPort-AV: E=Sophos;i="5.73,325,1583193600"; 
   d="scan'208";a="39777564"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 27 Apr 2020 18:39:52 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 5D8921A09BB;
        Mon, 27 Apr 2020 18:39:51 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 18:39:50 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.180) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Apr 2020 18:39:43 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2aa9c865-61c1-fc73-c85d-6627738d2d24@huawei.com>
 <7ac3f702-9c5f-5021-ebe3-42f1c93afbdf@amazon.com>
 <f701e084-7d2d-35dd-31ec-adc7d2a9e893@amazon.com>
 <77af0b1c-9884-5a75-02bd-1cc63c57971c@huawei.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <4be2bd36-633c-8ac0-b503-91e54007f944@amazon.com>
Date:   Mon, 27 Apr 2020 21:39:32 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <77af0b1c-9884-5a75-02bd-1cc63c57971c@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D34UWC002.ant.amazon.com (10.43.162.137) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi8wNC8yMDIwIDA0OjU1LCBMb25ncGVuZyAoTWlrZSwgQ2xvdWQgSW5mcmFzdHJ1Y3R1
cmUgU2VydmljZSAKUHJvZHVjdCBEZXB0Likgd3JvdGU6Cj4KPiBPbiAyMDIwLzQvMjQgMTc6NTQs
IFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+Cj4+IE9uIDI0LzA0LzIwMjAgMTE6MTks
IFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+Pgo+Pj4gT24gMjQvMDQvMjAyMCAwNjow
NCwgTG9uZ3BlbmcgKE1pa2UsIENsb3VkIEluZnJhc3RydWN0dXJlIFNlcnZpY2UgUHJvZHVjdAo+
Pj4gRGVwdC4pIHdyb3RlOgo+Pj4+IE9uIDIwMjAvNC8yMyAyMToxOSwgUGFyYXNjaGl2LCBBbmRy
YS1JcmluYSB3cm90ZToKPj4+Pj4gT24gMjIvMDQvMjAyMCAwMDo0NiwgUGFvbG8gQm9uemluaSB3
cm90ZToKPj4+Pj4+IE9uIDIxLzA0LzIwIDIwOjQxLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+
Pj4+Pj4gQW4gZW5jbGF2ZSBjb21tdW5pY2F0ZXMgd2l0aCB0aGUgcHJpbWFyeSBWTSB2aWEgYSBs
b2NhbCBjb21tdW5pY2F0aW9uCj4+Pj4+Pj4gY2hhbm5lbCwKPj4+Pj4+PiB1c2luZyB2aXJ0aW8t
dnNvY2sgWzJdLiBBbiBlbmNsYXZlIGRvZXMgbm90IGhhdmUgYSBkaXNrIG9yIGEgbmV0d29yayBk
ZXZpY2UKPj4+Pj4+PiBhdHRhY2hlZC4KPj4+Pj4+IElzIGl0IHBvc3NpYmxlIHRvIGhhdmUgYSBz
YW1wbGUgb2YgdGhpcyBpbiB0aGUgc2FtcGxlcy8gZGlyZWN0b3J5Pwo+Pj4+PiBJIGNhbiBhZGQg
aW4gdjIgYSBzYW1wbGUgZmlsZSBpbmNsdWRpbmcgdGhlIGJhc2ljIGZsb3cgb2YgaG93IHRvIHVz
ZSB0aGUgaW9jdGwKPj4+Pj4gaW50ZXJmYWNlIHRvIGNyZWF0ZSAvIHRlcm1pbmF0ZSBhbiBlbmNs
YXZlLgo+Pj4+Pgo+Pj4+PiBUaGVuIHdlIGNhbiB1cGRhdGUgLyBidWlsZCBvbiB0b3AgaXQgYmFz
ZWQgb24gdGhlIG9uZ29pbmcgZGlzY3Vzc2lvbnMgb24gdGhlCj4+Pj4+IHBhdGNoIHNlcmllcyBh
bmQgdGhlIHJlY2VpdmVkIGZlZWRiYWNrLgo+Pj4+Pgo+Pj4+Pj4gSSBhbSBpbnRlcmVzdGVkIGVz
cGVjaWFsbHkgaW46Cj4+Pj4+Pgo+Pj4+Pj4gLSB0aGUgaW5pdGlhbCBDUFUgc3RhdGU6IENQTDAg
dnMuIENQTDMsIGluaXRpYWwgcHJvZ3JhbSBjb3VudGVyLCBldGMuCj4+Pj4+Pgo+Pj4+Pj4gLSB0
aGUgY29tbXVuaWNhdGlvbiBjaGFubmVsOyBkb2VzIHRoZSBlbmNsYXZlIHNlZSB0aGUgdXN1YWwg
bG9jYWwgQVBJQwo+Pj4+Pj4gYW5kIElPQVBJQyBpbnRlcmZhY2VzIGluIG9yZGVyIHRvIGdldCBp
bnRlcnJ1cHRzIGZyb20gdmlydGlvLXZzb2NrLCBhbmQKPj4+Pj4+IHdoZXJlIGlzIHRoZSB2aXJ0
aW8tdnNvY2sgZGV2aWNlICh2aXJ0aW8tbW1pbyBJIHN1cHBvc2UpIHBsYWNlZCBpbiBtZW1vcnk/
Cj4+Pj4+Pgo+Pj4+Pj4gLSB3aGF0IHRoZSBlbmNsYXZlIGlzIGFsbG93ZWQgdG8gZG86IGNhbiBp
dCBjaGFuZ2UgcHJpdmlsZWdlIGxldmVscywKPj4+Pj4+IHdoYXQgaGFwcGVucyBpZiB0aGUgZW5j
bGF2ZSBwZXJmb3JtcyBhbiBhY2Nlc3MgdG8gbm9uZXhpc3RlbnQgbWVtb3J5LCBldGMuCj4+Pj4+
Pgo+Pj4+Pj4gLSB3aGV0aGVyIHRoZXJlIGFyZSBzcGVjaWFsIGh5cGVyY2FsbCBpbnRlcmZhY2Vz
IGZvciB0aGUgZW5jbGF2ZQo+Pj4+PiBBbiBlbmNsYXZlIGlzIGEgVk0sIHJ1bm5pbmcgb24gdGhl
IHNhbWUgaG9zdCBhcyB0aGUgcHJpbWFyeSBWTSwgdGhhdCBsYXVuY2hlZAo+Pj4+PiB0aGUgZW5j
bGF2ZS4gVGhleSBhcmUgc2libGluZ3MuCj4+Pj4+Cj4+Pj4+IEhlcmUgd2UgbmVlZCB0byB0aGlu
ayBvZiB0d28gY29tcG9uZW50czoKPj4+Pj4KPj4+Pj4gMS4gQW4gZW5jbGF2ZSBhYnN0cmFjdGlv
biBwcm9jZXNzIC0gYSBwcm9jZXNzIHJ1bm5pbmcgaW4gdGhlIHByaW1hcnkgVk0gZ3Vlc3QsCj4+
Pj4+IHRoYXQgdXNlcyB0aGUgcHJvdmlkZWQgaW9jdGwgaW50ZXJmYWNlIG9mIHRoZSBOaXRybyBF
bmNsYXZlcyBrZXJuZWwgZHJpdmVyIHRvCj4+Pj4+IHNwYXduIGFuIGVuY2xhdmUgVk0gKHRoYXQn
cyAyIGJlbG93KS4KPj4+Pj4KPj4+Pj4gSG93IGRvZXMgYWxsIGdldHMgdG8gYW4gZW5jbGF2ZSBW
TSBydW5uaW5nIG9uIHRoZSBob3N0Pwo+Pj4+Pgo+Pj4+PiBUaGVyZSBpcyBhIE5pdHJvIEVuY2xh
dmVzIGVtdWxhdGVkIFBDSSBkZXZpY2UgZXhwb3NlZCB0byB0aGUgcHJpbWFyeSBWTS4gVGhlCj4+
Pj4+IGRyaXZlciBmb3IgdGhpcyBuZXcgUENJIGRldmljZSBpcyBpbmNsdWRlZCBpbiB0aGUgY3Vy
cmVudCBwYXRjaCBzZXJpZXMuCj4+Pj4+Cj4+Pj4gSGkgUGFyYXNjaGl2LAo+Pj4+Cj4+Pj4gVGhl
IG5ldyBQQ0kgZGV2aWNlIGlzIGVtdWxhdGVkIGluIFFFTVUgPyBJZiBzbywgaXMgdGhlcmUgYW55
IHBsYW4gdG8gc2VuZCB0aGUKPj4+PiBRRU1VIGNvZGUgPwo+Pj4gSGksCj4+Pgo+Pj4gTm9wZSwg
bm90IHRoYXQgSSBrbm93IG9mIHNvIGZhci4KPj4gQW5kIGp1c3QgdG8gYmUgYSBiaXQgbW9yZSBj
bGVhciwgdGhlIHJlcGx5IGFib3ZlIHRha2VzIGludG8gY29uc2lkZXJhdGlvbiB0aGF0Cj4+IGl0
J3Mgbm90IGVtdWxhdGVkIGluIFFFTVUuCj4+Cj4gVGhhbmtzLgo+Cj4gR3V5cyBpbiB0aGlzIHRo
cmVhZCBhcmUgbXVjaCBtb3JlIGludGVyZXN0ZWQgaW4gdGhlIGRlc2lnbiBvZiBlbmNsYXZlIFZN
IGFuZCB0aGUKPiBuZXcgZGV2aWNlLCBidXQgdGhlcmUncyBubyBhbnkgZG9jdW1lbnQgYWJvdXQg
dGhpcyBkZXZpY2UgeWV0LCBzbyBJIHRoaW5rIHRoZQo+IGVtdWxhdGUgY29kZSBpcyBhIGdvb2Qg
YWx0ZXJuYXRpdmUuIEhvd2V2ZXIsIEFsZXggc2FpZCB0aGUgZGV2aWNlIHNwZWNpZmljIHdpbGwK
PiBiZSBwdWJsaXNoZWQgbGF0ZXIsIHNvIEknbGwgd2FpdCBmb3IgaXQuCgpUcnVlLCB0aGF0IHdh
cyBtZW50aW9uZWQgd3J0IGRldmljZSBzcGVjLiBUaGUgZGV2aWNlIGludGVyZmFjZSBjb3VsZCAK
YWxzbyBiZSB1cGRhdGVkIGJhc2VkIG9uIHRoZSBvbmdvaW5nIGRpc2N1c3Npb25zIG9uIHRoZSBw
YXRjaCBzZXJpZXMuIApSZWZzIHRvIHRoZSBkZXZpY2Ugc3BlYyBzaG91bGQgYmUgaW5jbHVkZWQg
ZS5nLiBpbiB0aGUgLmggZmlsZSBvZiB0aGUgClBDSSBkZXZpY2UsIG9uY2UgaXQncyBhdmFpbGFi
bGUuCgpUaGFua3MsCkFuZHJhCgo+Cj4+IFRoYW5rcywKPj4gQW5kcmEKPj4KPj4+Pj4gVGhlIGlv
Y3RsIGxvZ2ljIGlzIG1hcHBlZCB0byBQQ0kgZGV2aWNlIGNvbW1hbmRzIGUuZy4gdGhlIE5FX0VO
Q0xBVkVfU1RBUlQKPj4+Pj4gaW9jdGwKPj4+Pj4gbWFwcyB0byBhbiBlbmNsYXZlIHN0YXJ0IFBD
SSBjb21tYW5kIG9yIHRoZSBLVk1fU0VUX1VTRVJfTUVNT1JZX1JFR0lPTiBtYXBzIHRvCj4+Pj4+
IGFuIGFkZCBtZW1vcnkgUENJIGNvbW1hbmQuIFRoZSBQQ0kgZGV2aWNlIGNvbW1hbmRzIGFyZSB0
aGVuIHRyYW5zbGF0ZWQgaW50bwo+Pj4+PiBhY3Rpb25zIHRha2VuIG9uIHRoZSBoeXBlcnZpc29y
IHNpZGU7IHRoYXQncyB0aGUgTml0cm8gaHlwZXJ2aXNvciBydW5uaW5nIG9uCj4+Pj4+IHRoZQo+
Pj4+PiBob3N0IHdoZXJlIHRoZSBwcmltYXJ5IFZNIGlzIHJ1bm5pbmcuCj4+Pj4+Cj4+Pj4+IDIu
IFRoZSBlbmNsYXZlIGl0c2VsZiAtIGEgVk0gcnVubmluZyBvbiB0aGUgc2FtZSBob3N0IGFzIHRo
ZSBwcmltYXJ5IFZNIHRoYXQKPj4+Pj4gc3Bhd25lZCBpdC4KPj4+Pj4KPj4+Pj4gVGhlIGVuY2xh
dmUgVk0gaGFzIG5vIHBlcnNpc3RlbnQgc3RvcmFnZSBvciBuZXR3b3JrIGludGVyZmFjZSBhdHRh
Y2hlZCwgaXQgdXNlcwo+Pj4+PiBpdHMgb3duIG1lbW9yeSBhbmQgQ1BVcyArIGl0cyB2aXJ0aW8t
dnNvY2sgZW11bGF0ZWQgZGV2aWNlIGZvciBjb21tdW5pY2F0aW9uCj4+Pj4+IHdpdGggdGhlIHBy
aW1hcnkgVk0uCj4+Pj4+Cj4+Pj4+IFRoZSBtZW1vcnkgYW5kIENQVXMgYXJlIGNhcnZlZCBvdXQg
b2YgdGhlIHByaW1hcnkgVk0sIHRoZXkgYXJlIGRlZGljYXRlZCBmb3IKPj4+Pj4gdGhlCj4+Pj4+
IGVuY2xhdmUuIFRoZSBOaXRybyBoeXBlcnZpc29yIHJ1bm5pbmcgb24gdGhlIGhvc3QgZW5zdXJl
cyBtZW1vcnkgYW5kIENQVQo+Pj4+PiBpc29sYXRpb24gYmV0d2VlbiB0aGUgcHJpbWFyeSBWTSBh
bmQgdGhlIGVuY2xhdmUgVk0uCj4+Pj4+Cj4+Pj4+Cj4+Pj4+IFRoZXNlIHR3byBjb21wb25lbnRz
IG5lZWQgdG8gcmVmbGVjdCB0aGUgc2FtZSBzdGF0ZSBlLmcuIHdoZW4gdGhlIGVuY2xhdmUKPj4+
Pj4gYWJzdHJhY3Rpb24gcHJvY2VzcyAoMSkgaXMgdGVybWluYXRlZCwgdGhlIGVuY2xhdmUgVk0g
KDIpIGlzIHRlcm1pbmF0ZWQgYXMKPj4+Pj4gd2VsbC4KPj4+Pj4KPj4+Pj4gV2l0aCByZWdhcmQg
dG8gdGhlIGNvbW11bmljYXRpb24gY2hhbm5lbCwgdGhlIHByaW1hcnkgVk0gaGFzIGl0cyBvd24g
ZW11bGF0ZWQKPj4+Pj4gdmlydGlvLXZzb2NrIFBDSSBkZXZpY2UuIFRoZSBlbmNsYXZlIFZNIGhh
cyBpdHMgb3duIGVtdWxhdGVkIHZpcnRpby12c29jawo+Pj4+PiBkZXZpY2UKPj4+Pj4gYXMgd2Vs
bC4gVGhpcyBjaGFubmVsIGlzIHVzZWQsIGZvciBleGFtcGxlLCB0byBmZXRjaCBkYXRhIGluIHRo
ZSBlbmNsYXZlIGFuZAo+Pj4+PiB0aGVuIHByb2Nlc3MgaXQuIEFuIGFwcGxpY2F0aW9uIHRoYXQg
c2V0cyB1cCB0aGUgdnNvY2sgc29ja2V0IGFuZCBjb25uZWN0cyBvcgo+Pj4+PiBsaXN0ZW5zLCBk
ZXBlbmRpbmcgb24gdGhlIHVzZSBjYXNlLCBpcyB0aGVuIGRldmVsb3BlZCB0byB1c2UgdGhpcyBj
aGFubmVsOyB0aGlzCj4+Pj4+IGhhcHBlbnMgb24gYm90aCBlbmRzIC0gcHJpbWFyeSBWTSBhbmQg
ZW5jbGF2ZSBWTS4KPj4+Pj4KPj4+Pj4gTGV0IG1lIGtub3cgaWYgZnVydGhlciBjbGFyaWZpY2F0
aW9ucyBhcmUgbmVlZGVkLgo+Pj4+Pgo+Pj4+Pj4+IFRoZSBwcm9wb3NlZCBzb2x1dGlvbiBpcyBm
b2xsb3dpbmcgdGhlIEtWTSBtb2RlbCBhbmQgdXNlcyB0aGUgS1ZNIEFQSSB0bwo+Pj4+Pj4+IGJl
IGFibGUKPj4+Pj4+PiB0byBjcmVhdGUgYW5kIHNldCByZXNvdXJjZXMgZm9yIGVuY2xhdmVzLiBB
biBhZGRpdGlvbmFsIGlvY3RsIGNvbW1hbmQsCj4+Pj4+Pj4gYmVzaWRlcwo+Pj4+Pj4+IHRoZSBv
bmVzIHByb3ZpZGVkIGJ5IEtWTSwgaXMgdXNlZCB0byBzdGFydCBhbiBlbmNsYXZlIGFuZCBzZXR1
cCB0aGUKPj4+Pj4+PiBhZGRyZXNzaW5nCj4+Pj4+Pj4gZm9yIHRoZSBjb21tdW5pY2F0aW9uIGNo
YW5uZWwgYW5kIGFuIGVuY2xhdmUgdW5pcXVlIGlkLgo+Pj4+Pj4gUmV1c2luZyBzb21lIEtWTSBp
b2N0bHMgaXMgZGVmaW5pdGVseSBhIGdvb2QgaWRlYSwgYnV0IEkgd291bGRuJ3QgcmVhbGx5Cj4+
Pj4+PiBzYXkgaXQncyB0aGUgS1ZNIEFQSSBzaW5jZSB0aGUgVkNQVSBmaWxlIGRlc2NyaXB0b3Ig
aXMgYmFzaWNhbGx5IG5vbgo+Pj4+Pj4gZnVuY3Rpb25hbCAod2l0aG91dCBLVk1fUlVOIGFuZCBt
bWFwIGl0J3Mgbm90IHJlYWxseSB0aGUgS1ZNIEFQSSkuCj4+Pj4+IEl0IHVzZXMgcGFydCBvZiB0
aGUgS1ZNIEFQSSBvciBhIHNldCBvZiBLVk0gaW9jdGxzIHRvIG1vZGVsIHRoZSB3YXkgYSBWTSBp
cwo+Pj4+PiBjcmVhdGVkIC8gdGVybWluYXRlZC4gVGhhdCdzIHRydWUsIEtWTV9SVU4gYW5kIG1t
YXAtaW5nIHRoZSB2Y3B1IGZkIGFyZSBub3QKPj4+Pj4gaW5jbHVkZWQuCj4+Pj4+Cj4+Pj4+IFRo
YW5rcyBmb3IgdGhlIGZlZWRiYWNrIHJlZ2FyZGluZyB0aGUgcmV1c2Ugb2YgS1ZNIGlvY3Rscy4K
Pj4+Pj4KPj4+Pj4gQW5kcmEKPj4+Pj4KPj4+Pj4KPj4+Pj4KPj4+Pj4KPj4+Pj4gQW1hem9uIERl
dmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0Eg
U2YuIExhemFyCj4+Pj4+IFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHks
IDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbgo+Pj4+PiBSb21hbmlhLiBSZWdpc3RyYXRp
b24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCj4+Cj4+Cj4+Cj4+IEFtYXpvbiBEZXZlbG9wbWVudCBD
ZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphcgo+
PiBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFu
aWEuIFJlZ2lzdGVyZWQgaW4KPj4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYy
MS8yMDA1Lgo+IC0tLQo+IFJlZ2FyZHMsCj4gTG9uZ3BlbmcoTWlrZSkKCgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNm
LiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUs
IFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIv
MjYyMS8yMDA1Lgo=


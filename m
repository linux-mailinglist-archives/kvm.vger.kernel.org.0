Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFCD27473E
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgIVRH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 13:07:27 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:18910 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVRH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 13:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600794446; x=1632330446;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=+66RGc6UUVFZ+2+Mk7EQ3yHIFNko439zQH8U23IJGF8=;
  b=HiSbNEuz4JWneFiZDEH1OZcv0MNkOuBK9h4W/BIUHIhZg7ViLJnVD6RZ
   rlfzehLPz/f5srG58qrdjXfdDofC1yvFaJMGDIl179FnAj18RaSXWBa63
   ie/zGix4lumuZaWAMORGOVqa7aFYwMys1yZ81lMoTyxSmjvWuIvXOiZxk
   c=;
X-IronPort-AV: E=Sophos;i="5.77,291,1596499200"; 
   d="scan'208";a="70170606"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Sep 2020 17:07:18 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 1951BA1928;
        Tue, 22 Sep 2020 17:07:17 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.244) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 22 Sep 2020 17:07:07 +0000
Subject: Re: [PATCH v9 14/18] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200911141141.33296-1-andraprs@amazon.com>
 <20200911141141.33296-15-andraprs@amazon.com>
 <20200914155913.GB3525000@kroah.com>
 <c3a33dcf-794c-31ef-ced5-4f87ba21dd28@amazon.com>
 <d7eaac0d-8855-ca83-6b10-ab4f983805a2@amazon.com>
 <358e7470-b841-52fe-0532-e1154ef0e93b@amazon.com>
 <20200922162049.GA2299429@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b6acfeb5-b68f-f949-b737-1e6c859000f2@amazon.com>
Date:   Tue, 22 Sep 2020 20:06:58 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200922162049.GA2299429@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.244]
X-ClientProxiedBy: EX13D34UWC001.ant.amazon.com (10.43.162.112) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wOS8yMDIwIDE5OjIwLCBHcmVnIEtIIHdyb3RlOgo+IE9uIFR1ZSwgU2VwIDIyLCAy
MDIwIGF0IDA1OjEzOjAyUE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDIxLzA5LzIwMjAgMTU6MzQsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Pgo+Pj4gT24gMTQvMDkvMjAyMCAyMDoyMywgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToK
Pj4+Pgo+Pj4+IE9uIDE0LzA5LzIwMjAgMTg6NTksIEdyZWcgS0ggd3JvdGU6Cj4+Pj4+IE9uIEZy
aSwgU2VwIDExLCAyMDIwIGF0IDA1OjExOjM3UE0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90
ZToKPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9u
LmNvbT4KPj4+Pj4+IFJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29t
Pgo+Pj4+PiBJIGNhbid0IHRha2UgcGF0Y2hlcyB3aXRob3V0IGFueSBjaGFuZ2Vsb2cgdGV4dCBh
dCBhbGwsIHNvcnJ5Lgo+Pj4+Pgo+Pj4+PiBTYW1lIGZvciBhIGZldyBvdGhlciBwYXRjaGVzIGlu
IHRoaXMgc2VyaWVzIDooCj4+Pj4+Cj4+Pj4gSSBjYW4gbW92ZSB0aGUgY2hhbmdlbG9nIHRleHQg
YmVmb3JlIHRoZSBTb2IgdGFnKHMpIGZvciBhbGwgdGhlCj4+Pj4gcGF0Y2hlcy4gSSBhbHNvIGNh
biBhZGQgYSBzdW1tYXJ5IHBocmFzZSBpbiB0aGUgY29tbWl0IG1lc3NhZ2UgZm9yCj4+Pj4gdGhl
IGNvbW1pdHMgbGlrZSB0aGlzIG9uZSB0aGF0IGhhdmUgb25seSB0aGUgY29tbWl0IHRpdGxlIGFu
ZCBTb2IgJgo+Pj4+IFJiIHRhZ3MuCj4+Pj4KPj4+PiBXb3VsZCB0aGVzZSB1cGRhdGVzIHRvIHRo
ZSBjb21taXQgbWVzc2FnZXMgbWF0Y2ggdGhlIGV4cGVjdGF0aW9ucz8KPj4+Pgo+Pj4+IExldCBt
ZSBrbm93IGlmIHJlbWFpbmluZyBmZWVkYmFjayB0byBkaXNjdXNzIGFuZCBJIHNob3VsZCBpbmNs
dWRlIGFzCj4+Pj4gdXBkYXRlcyBpbiB2MTAuIE90aGVyd2lzZSwgSSBjYW4gc2VuZCB0aGUgbmV3
IHJldmlzaW9uIHdpdGggdGhlCj4+Pj4gdXBkYXRlZCBjb21taXQgbWVzc2FnZXMuCj4+Pj4KPj4+
PiBUaGFua3MgZm9yIHJldmlldy4KPj4+IEhlcmUgd2UgZ28sIEkgcHVibGlzaGVkIHYxMCwgaW5j
bHVkaW5nIHRoZSB1cGRhdGVkIGNvbW1pdCBtZXNzYWdlcyBhbmQKPj4+IHJlYmFzZWQgb24gdG9w
IG9mIHY1LjktcmM2Lgo+Pj4KPj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMDA5
MjExMjE3MzIuNDQyOTEtMS1hbmRyYXByc0BhbWF6b24uY29tLwo+Pj4KPj4+IEFueSBhZGRpdGlv
bmFsIGZlZWRiYWNrLCBvcGVuIHRvIGRpc2N1c3MuCj4+Pgo+Pj4gSWYgYWxsIGxvb2tzIGdvb2Qs
IHdlIGNhbiBtb3ZlIGZvcndhcmQgYXMgd2UndmUgdGFsa2VkIGJlZm9yZSwgdG8gaGF2ZQo+Pj4g
dGhlIHBhdGNoIHNlcmllcyBvbiB0aGUgY2hhci1taXNjIGJyYW5jaCBhbmQgdGFyZ2V0IHY1LjEw
LXJjMS4KPj4gVGhhbmtzIGZvciBtZXJnaW5nIHRoZSBwYXRjaCBzZXJpZXMgb24gdGhlIGNoYXIt
bWlzYy10ZXN0aW5nIGJyYW5jaCBhbmQgZm9yCj4+IHRoZSByZXZpZXcgc2Vzc2lvbnMgd2UndmUg
aGFkLgo+Pgo+PiBMZXQncyBzZWUgaG93IGFsbCBnb2VzIG5leHQ7IGlmIGFueXRoaW5nIGluIHRo
ZSBtZWFudGltZSB0byBiZSBkb25lIChlLmcuCj4+IGFuZCBub3QgY29taW5nIHZpYSBhdXRvLWdl
bmVyYXRlZCBtYWlscyksIGp1c3QgbGV0IG1lIGtub3cuCj4gV2lsbCBkbywgdGhhbmtzIGZvciBz
dGlja2luZyB3aXRoIHRoaXMgYW5kIGNsZWFuaW5nIGl0IHVwIHRvIGxvb2sgYSBsb3QKPiBiZXR0
ZXIgdGhhbiB0aGUgb3JpZ2luYWwgc3VibWlzc2lvbi4KCkFuZCB0aGlzIGFsc28gY2FtZSB3aXRo
IGEgY291cGxlIG9mIGxlc3NvbnMgbGVhcm50IHRoYXQgSSd2ZSBhcHBsaWVkIG9yIAp3aWxsIGFw
cGx5IGZvciBvdGhlciBwaWVjZXMgb2YgY29kZWJhc2UgYXMgd2VsbCwgZWl0aGVyIGZvciB0aGUg
TGludXggCmtlcm5lbCBvciBvdGhlciBwcm9qZWN0cy4KCj4KPiBOb3cgY29tZXMgdGhlIHJlYWwg
d29yaywgbWFpbnRhaW5pbmcgaXQgZm9yIHRoZSBuZXh0IDEwIHllYXJzIDopCgpJIGFncmVlLCBt
YWludGVuYW5jZSBpcyBlcXVhbGx5IGltcG9ydGFudC4gVGhlcmUgaXMgYW4gb25nb2luZyBwcm9j
ZXNzIAp0byBtYWtlIHN1cmUgdGhlIHdob2xlIGVjb3N5c3RlbSBjb250aW51ZXMgdG8gd29yay4K
CkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdp
c3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ks
IElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVn
aXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEADA1B622B
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 19:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgDWRnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 13:43:08 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:56444 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729802AbgDWRnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 13:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587663788; x=1619199788;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=lKoBnQnPq6a/Nvda5FLTya3nZLiBDj88VNDQsgB4hpc=;
  b=Uc1ixM7vTTJvFP3+e2GYqoS93/1ViuK7v58zJ0IZ1jNNDQSfzaNx2ZSO
   56TgvUyNLmCgpEXzNs6uL+2o1dmQgeBjjHH/3OrzbztjNKlIDJLzfNP/D
   9/CJRTnvoTPH1Zh5bDw/d4yC+wyGuRkQE1bc2SgsDPKtkaRbOJ3eIv+6l
   g=;
IronPort-SDR: 2MJ3rH2oWyZP0+KnxzepRZqaMi5CTDiimRgRrm/xTbVmauf6Uuusp22JI6yaf192DbDqaAV68j
 nhfn9DqNyFaw==
X-IronPort-AV: E=Sophos;i="5.73,307,1583193600"; 
   d="scan'208";a="27007447"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 23 Apr 2020 17:42:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 1F3E7281F80;
        Thu, 23 Apr 2020 17:42:54 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Apr 2020 17:42:53 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.217) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Apr 2020 17:42:46 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>
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
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
Date:   Thu, 23 Apr 2020 20:42:36 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D43UWC002.ant.amazon.com (10.43.162.172) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy8wNC8yMDIwIDE2OjQyLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDIzLzA0LzIw
IDE1OjE5LCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+PiAyLiBUaGUgZW5jbGF2ZSBp
dHNlbGYgLSBhIFZNIHJ1bm5pbmcgb24gdGhlIHNhbWUgaG9zdCBhcyB0aGUgcHJpbWFyeSBWTQo+
PiB0aGF0IHNwYXduZWQgaXQuCj4+Cj4+IFRoZSBlbmNsYXZlIFZNIGhhcyBubyBwZXJzaXN0ZW50
IHN0b3JhZ2Ugb3IgbmV0d29yayBpbnRlcmZhY2UgYXR0YWNoZWQsCj4+IGl0IHVzZXMgaXRzIG93
biBtZW1vcnkgYW5kIENQVXMgKyBpdHMgdmlydGlvLXZzb2NrIGVtdWxhdGVkIGRldmljZSBmb3IK
Pj4gY29tbXVuaWNhdGlvbiB3aXRoIHRoZSBwcmltYXJ5IFZNLgo+Pgo+PiBUaGUgbWVtb3J5IGFu
ZCBDUFVzIGFyZSBjYXJ2ZWQgb3V0IG9mIHRoZSBwcmltYXJ5IFZNLCB0aGV5IGFyZSBkZWRpY2F0
ZWQKPj4gZm9yIHRoZSBlbmNsYXZlLiBUaGUgTml0cm8gaHlwZXJ2aXNvciBydW5uaW5nIG9uIHRo
ZSBob3N0IGVuc3VyZXMgbWVtb3J5Cj4+IGFuZCBDUFUgaXNvbGF0aW9uIGJldHdlZW4gdGhlIHBy
aW1hcnkgVk0gYW5kIHRoZSBlbmNsYXZlIFZNLgo+Pgo+PiBUaGVzZSB0d28gY29tcG9uZW50cyBu
ZWVkIHRvIHJlZmxlY3QgdGhlIHNhbWUgc3RhdGUgZS5nLiB3aGVuIHRoZQo+PiBlbmNsYXZlIGFi
c3RyYWN0aW9uIHByb2Nlc3MgKDEpIGlzIHRlcm1pbmF0ZWQsIHRoZSBlbmNsYXZlIFZNICgyKSBp
cwo+PiB0ZXJtaW5hdGVkIGFzIHdlbGwuCj4+Cj4+IFdpdGggcmVnYXJkIHRvIHRoZSBjb21tdW5p
Y2F0aW9uIGNoYW5uZWwsIHRoZSBwcmltYXJ5IFZNIGhhcyBpdHMgb3duCj4+IGVtdWxhdGVkIHZp
cnRpby12c29jayBQQ0kgZGV2aWNlLiBUaGUgZW5jbGF2ZSBWTSBoYXMgaXRzIG93biBlbXVsYXRl
ZAo+PiB2aXJ0aW8tdnNvY2sgZGV2aWNlIGFzIHdlbGwuIFRoaXMgY2hhbm5lbCBpcyB1c2VkLCBm
b3IgZXhhbXBsZSwgdG8gZmV0Y2gKPj4gZGF0YSBpbiB0aGUgZW5jbGF2ZSBhbmQgdGhlbiBwcm9j
ZXNzIGl0LiBBbiBhcHBsaWNhdGlvbiB0aGF0IHNldHMgdXAgdGhlCj4+IHZzb2NrIHNvY2tldCBh
bmQgY29ubmVjdHMgb3IgbGlzdGVucywgZGVwZW5kaW5nIG9uIHRoZSB1c2UgY2FzZSwgaXMgdGhl
bgo+PiBkZXZlbG9wZWQgdG8gdXNlIHRoaXMgY2hhbm5lbDsgdGhpcyBoYXBwZW5zIG9uIGJvdGgg
ZW5kcyAtIHByaW1hcnkgVk0KPj4gYW5kIGVuY2xhdmUgVk0uCj4+Cj4+IExldCBtZSBrbm93IGlm
IGZ1cnRoZXIgY2xhcmlmaWNhdGlvbnMgYXJlIG5lZWRlZC4KPiBUaGFua3MsIHRoaXMgaXMgYWxs
IHVzZWZ1bC4gIEhvd2V2ZXIgY2FuIHlvdSBwbGVhc2UgY2xhcmlmeSB0aGUKPiBsb3ctbGV2ZWwg
ZGV0YWlscyBoZXJlPwo+Cj4+PiAtIHRoZSBpbml0aWFsIENQVSBzdGF0ZTogQ1BMMCB2cy4gQ1BM
MywgaW5pdGlhbCBwcm9ncmFtIGNvdW50ZXIsIGV0Yy4KClRoZSBlbmNsYXZlIFZNIGhhcyBpdHMg
b3duIGtlcm5lbCBhbmQgZm9sbG93cyB0aGUgd2VsbC1rbm93biBMaW51eCBib290IApwcm90b2Nv
bCwgaW4gdGhlIGVuZCBnZXR0aW5nIHRvIHRoZSB1c2VyIGFwcGxpY2F0aW9uIGFmdGVyIGluaXQg
ZmluaXNoZXMgCml0cyB3b3JrLCBzbyB0aGF0J3MgQ1BMMy4KCj4+PiAtIHRoZSBjb21tdW5pY2F0
aW9uIGNoYW5uZWw7IGRvZXMgdGhlIGVuY2xhdmUgc2VlIHRoZSB1c3VhbCBsb2NhbCBBUElDCj4+
PiBhbmQgSU9BUElDIGludGVyZmFjZXMgaW4gb3JkZXIgdG8gZ2V0IGludGVycnVwdHMgZnJvbSB2
aXJ0aW8tdnNvY2ssIGFuZAo+Pj4gd2hlcmUgaXMgdGhlIHZpcnRpby12c29jayBkZXZpY2UgKHZp
cnRpby1tbWlvIEkgc3VwcG9zZSkgcGxhY2VkIGluCj4+PiBtZW1vcnk/CnZzb2NrIGlzIHVzaW5n
IGV2ZW50ZmQgZm9yIHNpZ25hbGxpbmc7IHdydCBlbmNsYXZlIFZNLCBpdCBzZWVzIHRoZSB1c3Vh
bCAKaW50ZXJmYWNlcyB0byBnZXQgaW50ZXJydXB0cyBmcm9tIHZpcnRpbyBkZXYuCgpJdCdzIHBs
YWNlZCBiZWxvdyB0aGUgdHlwaWNhbCA0R0I7IGluIGdlbmVyYWwsIGl0IG1heSBkZXBlbmQgYmFz
ZWQgb24gYXJjaC4KCj4+PiAtIHdoYXQgdGhlIGVuY2xhdmUgaXMgYWxsb3dlZCB0byBkbzogY2Fu
IGl0IGNoYW5nZSBwcml2aWxlZ2UgbGV2ZWxzLAo+Pj4gd2hhdCBoYXBwZW5zIGlmIHRoZSBlbmNs
YXZlIHBlcmZvcm1zIGFuIGFjY2VzcyB0byBub25leGlzdGVudCBtZW1vcnksCj4+PiBldGMuCgpJ
ZiB0YWxraW5nIGFib3V0IHRoZSBlbmNsYXZlIGFic3RyYWN0aW9uIHByb2Nlc3MsIGl0IGlzIHJ1
bm5pbmcgaW4gdGhlIApwcmltYXJ5IFZNIGFzIGEgdXNlciBzcGFjZSBwcm9jZXNzLCBzbyBpdCB3
aWxsIGdldCBpbnRvIHByaW1hcnkgVk0gZ3Vlc3QgCmtlcm5lbCBpZiBwcml2aWxlZ2VkIGluc3Ry
dWN0aW9ucyBuZWVkIHRvIGJlIGV4ZWN1dGVkLgoKU2FtZSBoYXBwZW5zIHdpdGggdGhlIHVzZXIg
c3BhY2UgYXBwbGljYXRpb24gcnVubmluZyBpbiB0aGUgZW5jbGF2ZSBWTS4gCkFuZCB0aGUgVk0g
aXRzZWxmIHdpbGwgZ2V0IHRvIHRoZSBoeXBlcnZpc29yIHJ1bm5pbmcgb24gdGhlIGhvc3QgZm9y
IApwcml2aWxlZ2VkIGluc3RydWN0aW9ucy4gVGhlIE5pdHJvIGh5cGVydmlzb3IgaXMgYmFzZWQg
b24gY29yZSBLVk0gCnRlY2hub2xvZ3kuCgpBY2Nlc3MgdG8gbm9uZXhpc3RlbnQgbWVtb3J5IGdl
dHMgZmF1bHRzLgoKPj4+IC0gd2hldGhlciB0aGVyZSBhcmUgc3BlY2lhbCBoeXBlcmNhbGwgaW50
ZXJmYWNlcyBmb3IgdGhlIGVuY2xhdmUKClRoZSBwYXRoIHRvd2FyZHMgY3JlYXRpbmcgLyBzZXR0
aW5nIHJlc291cmNlcyAvIHRlcm1pbmF0aW5nIGFuIGVuY2xhdmUgCihoZXJlIHJlZmVycmluZyB0
byBlbmNsYXZlIFZNKSBpcyB0b3dhcmRzIHRoZSBpb2N0bCBpbnRlcmZhY2UsIHdpdGggdGhlIApj
b3JyZXNwb25kaW5nIG1pc2MgZGV2aWNlLCBhbmQgdGhlIGVtdWxhdGVkIFBDSSBkZXZpY2UuIFRo
YXQncyB0aGUgCmludGVyZmFjZSB1c2VkIHRvIG1hbmFnZSBlbmNsYXZlcy4gT25jZSBib290ZWQs
IHRoZSBlbmNsYXZlIHJlc291cmNlcyAKc2V0dXAgaXMgbm90IG1vZGlmaWVkIGFueW1vcmUuIEFu
ZCB0aGUgd2F5IHRvIGNvbW11bmljYXRlIHdpdGggdGhlIAplbmNsYXZlIGFmdGVyIGJvb3Rpbmcs
IHdpdGggdGhlIGFwcGxpY2F0aW9uIHJ1bm5pbmcgaW4gdGhlIGVuY2xhdmUsIGlzIAp2aWEgdGhl
IHZzb2NrIGNvbW0gY2hhbm5lbC4KCgpUaGFua3MsCkFuZHJhCgo+IFRoYW5rcywKPgo+IFBhb2xv
Cj4KCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3Rl
cmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElh
c2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0
cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=


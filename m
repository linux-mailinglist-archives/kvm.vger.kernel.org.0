Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587A825FB9F
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 15:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgIGNqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 09:46:14 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:47370 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbgIGNnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599486213; x=1631022213;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=tt6wtfdb3398uJssYij92A1z15vJIiwy4hdYo2eToCU=;
  b=O6LLROK7t/YJ527m/XO++o2zlCwMYScvCM/jTM4VtfGpb9kPO/t7gcS6
   yA7MiTU2CLJl1egbEiDNa2i2RSzvY9El3FFASaQ82OEMfwBJM08sDxaNz
   C5hEw189a4YadQAyGk6RdxGA5IHBpWG+jM5Fz39qGho6PG78Bd4yWddr0
   o=;
X-IronPort-AV: E=Sophos;i="5.76,401,1592870400"; 
   d="scan'208";a="66028583"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 07 Sep 2020 13:43:30 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id BDED9C05E1;
        Mon,  7 Sep 2020 13:43:27 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.85) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Sep 2020 13:43:17 +0000
Subject: Re: [PATCH v8 17/18] nitro_enclaves: Add overview documentation
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
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-18-andraprs@amazon.com>
 <20200907090126.GD1101646@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <44a8a921-1fb4-87ab-b8f2-c168c615dbbd@amazon.com>
Date:   Mon, 7 Sep 2020 16:43:11 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907090126.GD1101646@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D36UWA001.ant.amazon.com (10.43.160.71) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNy8wOS8yMDIwIDEyOjAxLCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gRnJpLCBTZXAgMDQs
IDIwMjAgYXQgMDg6Mzc6MTdQTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+PiBTaWdu
ZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+IFJldmll
d2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgo+PiAtLS0KPj4gQ2hhbmdl
bG9nCj4+Cj4+IHY3IC0+IHY4Cj4+Cj4+ICogQWRkIGluZm8gYWJvdXQgdGhlIHByaW1hcnkgLyBw
YXJlbnQgVk0gQ0lEIHZhbHVlLgo+PiAqIFVwZGF0ZSByZWZlcmVuY2UgbGluayBmb3IgaHVnZSBw
YWdlcy4KPj4gKiBBZGQgcmVmZXJlbmNlIGxpbmsgZm9yIHRoZSB4ODYgYm9vdCBwcm90b2NvbC4K
Pj4gKiBBZGQgbGljZW5zZSBtZW50aW9uIGFuZCB1cGRhdGUgZG9jIHRpdGxlIC8gY2hhcHRlciBm
b3JtYXR0aW5nLgo+Pgo+PiB2NiAtPiB2Nwo+Pgo+PiAqIE5vIGNoYW5nZXMuCj4+Cj4+IHY1IC0+
IHY2Cj4+Cj4+ICogTm8gY2hhbmdlcy4KPj4KPj4gdjQgLT4gdjUKPj4KPj4gKiBObyBjaGFuZ2Vz
Lgo+Pgo+PiB2MyAtPiB2NAo+Pgo+PiAqIFVwZGF0ZSBkb2MgdHlwZSBmcm9tIC50eHQgdG8gLnJz
dC4KPj4gKiBVcGRhdGUgZG9jdW1lbnRhdGlvbiBiYXNlZCBvbiB0aGUgY2hhbmdlcyBmcm9tIHY0
Lgo+Pgo+PiB2MiAtPiB2Mwo+Pgo+PiAqIE5vIGNoYW5nZXMuCj4+Cj4+IHYxIC0+IHYyCj4+Cj4+
ICogTmV3IGluIHYyLgo+PiAtLS0KPj4gICBEb2N1bWVudGF0aW9uL25pdHJvX2VuY2xhdmVzL25l
X292ZXJ2aWV3LnJzdCB8IDk1ICsrKysrKysrKysrKysrKysrKysrCj4+ICAgMSBmaWxlIGNoYW5n
ZWQsIDk1IGluc2VydGlvbnMoKykKPj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlv
bi9uaXRyb19lbmNsYXZlcy9uZV9vdmVydmlldy5yc3QKPiBBIHdob2xlIG5ldyBzdWJkaXIsIGZv
ciBhIHNpbmdsZSBkcml2ZXIsIGFuZCBub3QgdGllZCBpbnRvIHRoZSBrZXJuZWwKPiBkb2N1bWVu
dGF0aW9uIGJ1aWxkIHByb2Nlc3MgYXQgYWxsPyAgTm90IGdvb2QgOigKPgoKV291bGQgdGhlICJ2
aXJ0IiBkaXJlY3RvcnkgYmUgYSBiZXR0ZXIgb3B0aW9uIGZvciB0aGlzIGRvYyBmaWxlPwoKSSBj
YW4gdGhlbiBhZGQgdGhlIGRvYyBuYW1lIHRvIHRoZSBjb3JyZXNwb25kaW5nIGluZGV4IGZpbGUg
YXMgd2VsbC4KClRoYW5rcywKQW5kcmEKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9t
YW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJD
NSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJl
ZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==


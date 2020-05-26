Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E961E1CE9
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 10:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgEZIHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 04:07:21 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:47947 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgEZIHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 04:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590480441; x=1622016441;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UjkBL4IyFRcZnIBW+9GI3K0GuOJ5B4jSDRBwvVKtrso=;
  b=jD+E6mGw3VQmPyNd5vxavAXeeE01ZGKjVHWdcjYUuEl9MhlQxqbMjaFW
   ++XVbFv7rGBxvSpBXtbRPJI4zXQPsaDLr5KqHCn1ZU43RGushwtDnjYPi
   DZst74gtQyq2Q/4YB9dxdvt3U2BZCDw7dQaavfX2mHgne9DMNReCcM4BR
   0=;
IronPort-SDR: eOP+c+rZVu9A1XBly4jinEMvP9i74ohQUKKqsFC462Z6fufwFKqnaf7jvVgM5mRjiN4/G4u2LF
 xSQAj45LYrBg==
X-IronPort-AV: E=Sophos;i="5.73,436,1583193600"; 
   d="scan'208";a="32214342"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 26 May 2020 08:07:08 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 17F60A23A9;
        Tue, 26 May 2020 08:07:06 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 08:07:05 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.26) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 08:06:57 +0000
Subject: Re: [PATCH v2 16/18] nitro_enclaves: Add sample for ioctl interface
 usage
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
 <20200522062946.28973-17-andraprs@amazon.com>
 <20200522070853.GE771317@kroah.com>
 <09c68ec6-f0fd-e400-1ff2-681ac51c568c@amazon.com>
 <20200526064118.GA2580410@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <2b0a2fe9-444d-110f-97b5-127637e60009@amazon.com>
Date:   Tue, 26 May 2020 11:06:46 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526064118.GA2580410@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D11UWB001.ant.amazon.com (10.43.161.53) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi8wNS8yMDIwIDA5OjQxLCBHcmVnIEtIIHdyb3RlOgo+IE9uIE1vbiwgTWF5IDI1LCAy
MDIwIGF0IDExOjU3OjI2UE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDIyLzA1LzIwMjAgMTA6MDgsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBGcmksIE1heSAy
MiwgMjAyMCBhdCAwOToyOTo0NEFNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+Pj4g
U2lnbmVkLW9mZi1ieTogQWxleGFuZHJ1IFZhc2lsZSA8bGV4bnZAYW1hem9uLmNvbT4KPj4+PiBT
aWduZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+PiBJ
IGtub3cgSSBkb24ndCB0YWtlIGNvbW1pdHMgd2l0aCBubyBjaGFuZ2Vsb2cgdGV4dCA6KAo+PiBJ
bmNsdWRlZCBpbiB2MyB0aGUgY2hhbmdlbG9nIGZvciBlYWNoIHBhdGNoIGluIHRoZSBzZXJpZXMs
IGluIGFkZGl0aW9uIHRvCj4+IHRoZSBvbmUgaW4gdGhlIGNvdmVyIGxldHRlcjsgd2hlcmUgbm8g
Y2hhbmdlcywgSSBqdXN0IG1lbnRpb25lZCB0aGF0LiA6KQo+IEJ1dCB5b3UgZGlkbid0IGNjOiBt
ZSBvbiB0aGF0IHZlcnNpb24gOigKCkkganVzdCBhZGRlZCB5b3Ugb24gdGhlIENDIGxpc3QsIGZy
b20gdjQgZ29pbmcgb24gc2hvdWxkIGJlIGFsbCBnb29kIHdydCAKdGhpcy4KClRoYW5rcywKQW5k
cmEKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3Rl
cmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElh
c2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0
cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F901E9EF7
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 09:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgFAHUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 03:20:38 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:65023 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFAHUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 03:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590996037; x=1622532037;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=hQASGLU2Qp68wJMFjT6/GjP8eU7Wfp1GPuYXep3bfpQ=;
  b=P98YoLhUobHgnsIwDH/vBpTn8M1kiaQC67k82ba9kztPSs0uBfGzc6+M
   xO2M8aWFwnQVEHpjXQHAsHgOEnbE9TUxfuFjpWvzLPT206sHI3YrUx4T6
   ToziZ+Pgh0YIsqOsY3AVsMxqN2F7i0iHxqby+0h97/tiOwo7MCxM47wqu
   U=;
IronPort-SDR: YcOPAN0qfLaoBD+0f+iGEaNjFWuvytSoBhSirDa4zJeZ3pdbULkR9ZkBH5mTIW+GAax7jJbP64
 QEeAOMyZmJcA==
X-IronPort-AV: E=Sophos;i="5.73,459,1583193600"; 
   d="scan'208";a="40309876"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Jun 2020 07:20:35 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 37D59A28A3;
        Mon,  1 Jun 2020 07:20:32 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 07:20:32 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.109) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 07:20:23 +0000
Subject: Re: [PATCH v3 01/18] nitro_enclaves: Add ioctl interface definition
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-2-andraprs@amazon.com>
 <20200527084959.GA29137@stefanha-x1.localdomain>
 <a95de3ee4b722d418fd6cf662233cb024928804e.camel@kernel.crashing.org>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <d639afa5-cca6-3707-4c80-40ee1bf5bcb5@amazon.com>
Date:   Mon, 1 Jun 2020 10:20:18 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <a95de3ee4b722d418fd6cf662233cb024928804e.camel@kernel.crashing.org>
Content-Language: en-US
X-Originating-IP: [10.43.162.109]
X-ClientProxiedBy: EX13D42UWB001.ant.amazon.com (10.43.161.35) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwMS8wNi8yMDIwIDA2OjAyLCBCZW5qYW1pbiBIZXJyZW5zY2htaWR0IHdyb3RlOgo+IE9u
IFdlZCwgMjAyMC0wNS0yNyBhdCAwOTo0OSArMDEwMCwgU3RlZmFuIEhham5vY3ppIHdyb3RlOgo+
PiBXaGF0IGFib3V0IGZlYXR1cmUgYml0cyBvciBhIEFQSSB2ZXJzaW9uIG51bWJlciBmaWVsZD8g
SWYgeW91IGFkZAo+PiBmZWF0dXJlcyB0byB0aGUgTkUgZHJpdmVyLCBob3cgd2lsbCB1c2Vyc3Bh
Y2UgZGV0ZWN0IHRoZW0/Cj4+Cj4+IEV2ZW4gaWYgeW91IGludGVuZCB0byBhbHdheXMgY29tcGls
ZSB1c2Vyc3BhY2UgYWdhaW5zdCB0aGUgZXhhY3Qga2VybmVsCj4+IGhlYWRlcnMgdGhhdCB0aGUg
cHJvZ3JhbSB3aWxsIHJ1biBvbiwgaXQgY2FuIHN0aWxsIGJlIHVzZWZ1bCB0byBoYXZlIGFuCj4+
IEFQSSB2ZXJzaW9uIGZvciBpbmZvcm1hdGlvbmFsIHB1cnBvc2VzIGFuZCB0byBlYXNpbHkgcHJl
dmVudCB1c2VyCj4+IGVycm9ycyAocnVubmluZyBhIG5ldyB1c2Vyc3BhY2UgYmluYXJ5IG9uIGFu
IG9sZCBrZXJuZWwgd2hlcmUgdGhlIEFQSSBpcwo+PiBkaWZmZXJlbnQpLgo+Pgo+PiBGaW5hbGx5
LCByZXNlcnZlZCBzdHJ1Y3QgZmllbGRzIG1heSBjb21lIGluIGhhbmR5IGluIHRoZSBmdXR1cmUu
IFRoYXQKPj4gd2F5IHVzZXJzcGFjZSBhbmQgdGhlIGtlcm5lbCBkb24ndCBuZWVkIHRvIGV4cGxp
Y2l0bHkgaGFuZGxlIG11bHRpcGxlCj4+IHN0cnVjdCBzaXplcy4KPiBCZXdhcmUsIEdyZWcgbWln
aHQgZGlzYWdyZWUgOikKPgo+IFRoYXQgc2FpZCwgeWVzLCBhdCBsZWFzdCBhIHdheSB0byBxdWVy
eSB0aGUgQVBJIHZlcnNpb24gd291bGQgYmUKPiB1c2VmdWwuCgpJIHNlZSB0aGVyZSBhcmUgc2V2
ZXJhbCB0aG91Z2h0cyB3aXRoIHJlZ2FyZCB0byBleHRlbnNpb25zIHBvc3NpYmlsaXRpZXMuIDop
CgpJIGFkZGVkIGFuIGlvY3RsIGZvciBnZXR0aW5nIHRoZSBBUEkgdmVyc2lvbiwgd2UgaGF2ZSBu
b3cgYSB3YXkgdG8gcXVlcnkgCnRoYXQgaW5mby4gQWxzbywgSSB1cGRhdGVkIHRoZSBzYW1wbGUg
aW4gdGhpcyBwYXRjaCBzZXJpZXMgdG8gY2hlY2sgZm9yIAp0aGUgQVBJIHZlcnNpb24uCgpUaGFu
a3MsCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiBy
ZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElh
c2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4g
UmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=


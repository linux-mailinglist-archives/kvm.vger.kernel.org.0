Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EE01E156F
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 22:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390934AbgEYU56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 16:57:58 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:18116 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388880AbgEYU55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 16:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590440276; x=1621976276;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=gFkQgAi+L2ZAXoihH38v8ZdLhtitzSj9jHCXCnZJqk0=;
  b=H9K86xLhEuVQ0QbUZDnTIIkDWYqvzVrtKW72n9Q4Wf76qlDYejBpMN1o
   xpHihPKtchYeZqGYv83m2CSSOxGm8WVm5X/qRDaAD3MAn27hIqZHBVjBn
   e7FekRDw6MgYuQmdk5xpI/kLKHYQp4wEQs3/RG/rPCj1cYGisO1BPypGO
   Y=;
IronPort-SDR: eQJD8dZZ0oqi0CvDjMD3bU+XwWaUJv7IPMdeI0Qbf/rxbIHsOPzQYTfnpOapvFX7IgFgnlGG0C
 v+d5uudM33bg==
X-IronPort-AV: E=Sophos;i="5.73,434,1583193600"; 
   d="scan'208";a="32212850"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 25 May 2020 20:57:42 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 20982A1D6D;
        Mon, 25 May 2020 20:57:41 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 20:57:40 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 20:57:32 +0000
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
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <09c68ec6-f0fd-e400-1ff2-681ac51c568c@amazon.com>
Date:   Mon, 25 May 2020 23:57:26 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522070853.GE771317@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D11UWB004.ant.amazon.com (10.43.161.90) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNS8yMDIwIDEwOjA4LCBHcmVnIEtIIHdyb3RlOgo+IE9uIEZyaSwgTWF5IDIyLCAy
MDIwIGF0IDA5OjI5OjQ0QU0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gU2lnbmVk
LW9mZi1ieTogQWxleGFuZHJ1IFZhc2lsZSA8bGV4bnZAYW1hem9uLmNvbT4KPj4gU2lnbmVkLW9m
Zi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+IEkga25vdyBJIGRv
bid0IHRha2UgY29tbWl0cyB3aXRoIG5vIGNoYW5nZWxvZyB0ZXh0IDooCgpJbmNsdWRlZCBpbiB2
MyB0aGUgY2hhbmdlbG9nIGZvciBlYWNoIHBhdGNoIGluIHRoZSBzZXJpZXMsIGluIGFkZGl0aW9u
IAp0byB0aGUgb25lIGluIHRoZSBjb3ZlciBsZXR0ZXI7IHdoZXJlIG5vIGNoYW5nZXMsIEkganVz
dCBtZW50aW9uZWQgdGhhdC4gOikKClRoYW5rIHlvdS4KCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9w
bWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBM
YXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJv
bWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYy
MS8yMDA1Lgo=


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0AB39F0E8
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhFHI3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:29:43 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:51650 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhFHI3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 04:29:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623140871; x=1654676871;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PiOnhgNEvmhKQQ8E04TWZ+nTZWAX8WGgm5qVfYhMf2s=;
  b=Etf+TmfFAR8sJm0CqATQ5tyz12ZNY/TSeFU/810dopmhXSGS2U4/MObw
   c1jLa4rdb3l1u2iAQfX9t78qU8GS5LXC9cGDwgl24SQLYrSZ1RT4rK8c3
   eBDZNL46hQJqTVuGqDEHvkG1YZmgooKB7RfUvWxh0TMXgVcGWXLABgJFM
   s=;
X-IronPort-AV: E=Sophos;i="5.83,257,1616457600"; 
   d="scan'208";a="5461049"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 08 Jun 2021 08:27:39 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id EAB12A1DF3;
        Tue,  8 Jun 2021 08:27:38 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 08:27:38 +0000
Received: from [192.168.19.4] (10.43.160.137) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Jun
 2021 08:27:36 +0000
Message-ID: <cacf8101-ff35-9238-f567-c3638b2c15a2@amazon.com>
Date:   Tue, 8 Jun 2021 10:27:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:90.0)
 Gecko/20100101 Thunderbird/90.0
Subject: Re: [PATCH 1/6] hyper-v: Overlay abstraction for synic event and msg
 pages
Content-Language: en-US
To:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <cover.1621885749.git.sidcha@amazon.de>
 <a997ef48d649f553869b614ba7d256a97f59a48e.1621885749.git.sidcha@amazon.de>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <a997ef48d649f553869b614ba7d256a97f59a48e.1621885749.git.sidcha@amazon.de>
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC4wNS4yMSAyMTo1NCwgU2lkZGhhcnRoIENoYW5kcmFzZWthcmFuIHdyb3RlOgo+IENh
cHR1cmUgb3ZlcmxheSBwYWdlIHNlbWFudGljIHZhcmlhYmxlcyBpbnRvICdzdHJ1Y3Qgb3Zlcmxh
eV9wYWdlJyBhbmQKPiBhZGQgbWV0aG9kcyB0aGF0IG9wZXJhdGUgb3ZlciBpdC4gQWRhcHQgZXhp
c3Rpbmcgc3luaWMgZXZlbnQgYW5kIG1lc2FnZQo+IHBhZ2VzIHRvIHVzZSB0aGVzZSBtZXRob2Rz
IHRvIHNldHVwIGFuZCBtYW5hZ2Ugb3ZlcmxheXMuCj4gCj4gU2luY2UgYWxsIG92ZXJsYXkgcGFn
ZXMgdXNlIGJpdCAwIG9mIHRoZSBHUEEgdG8gaW5kaWNhdGUgaWYgdGhlIG92ZXJsYXkKPiBpcyBl
bmFibGVkLCB0aGUgY2hlY2tzIGZvciB0aGlzIGJpdCBpcyBtb3ZlZCBpbnRvIHRoZSB1bmlmaWVk
IG92ZXJsYXlpbmcKPiBtZXRob2QgaHlwZXJ2X292ZXJsYXlfdXBkYXRlKCkgc28gdGhlIGNhbGxl
ciBkb2VzIG5vdCBuZWVkIHRvIGNhcmUgYWJvdXQKPiBpdC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBT
aWRkaGFydGggQ2hhbmRyYXNla2FyYW4gPHNpZGNoYUBhbWF6b24uZGU+CgpSZXZpZXdlZC1ieTog
QWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9w
bWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNj
aGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdl
dHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpT
aXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==


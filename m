Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15D91DE1A1
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 10:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgEVIRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 04:17:23 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:28914 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgEVIRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 04:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590135442; x=1621671442;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Z8rUm/A2m6bvi5mTR/bMF0UFqQb3/CbeEUoi12Jwpdg=;
  b=nsOne74vOFispacCO0dhcl/vNTWZa+Z6YWyO7M4X4eZfuQmE/G9wKabY
   +wzM1tCZb4RjTJJmnjwkI5u017EabV191fEvLWvAsic+cCCAg1eHMAqbi
   PTs/Fl5+0A4EovFGTs66eE0EwAEmRMqo/zu9aIK91oLG99ATZjxbBCaXC
   o=;
IronPort-SDR: u8DNnzZTYkayaDxo6XzytBFmsk6YJjA1pruZF7NSybVb0ngy8yzQR2S9OmNciVduPyogj4aM5i
 hCEVDpCzzmrQ==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="31786815"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 May 2020 08:17:10 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id E0DDFA215B;
        Fri, 22 May 2020 08:17:08 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 08:17:08 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 08:17:00 +0000
Subject: Re: [PATCH v2 01/18] nitro_enclaves: Add ioctl interface definition
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
 <20200522062946.28973-2-andraprs@amazon.com>
 <20200522070015.GA771317@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <ee64da05-8020-fc86-cd72-b3fc828c86ca@amazon.com>
Date:   Fri, 22 May 2020 11:16:49 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522070015.GA771317@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D22UWB002.ant.amazon.com (10.43.161.28) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNS8yMDIwIDEwOjAwLCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gRnJpLCBNYXkgMjIs
IDIwMjAgYXQgMDk6Mjk6MjlBTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+PiAtLS0g
L2Rldi9udWxsCj4+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9uaXRyb19lbmNsYXZlcy5oCj4+
IEBAIC0wLDAgKzEsNzcgQEAKPj4gKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4w
IFdJVEggTGludXgtc3lzY2FsbC1ub3RlICovCj4+ICsvKgo+PiArICogQ29weXJpZ2h0IDIwMjAg
QW1hem9uLmNvbSwgSW5jLiBvciBpdHMgYWZmaWxpYXRlcy4gQWxsIFJpZ2h0cyBSZXNlcnZlZC4K
Pj4gKyAqCj4+ICsgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRp
c3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeSBpdAo+PiArICogdW5kZXIgdGhlIHRlcm1zIGFuZCBj
b25kaXRpb25zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSwKPj4gKyAqIHZlcnNp
b24gMiwgYXMgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24uCj4+ICsg
Kgo+PiArICogVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQg
d2lsbCBiZSB1c2VmdWwsCj4+ICsgKiBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQg
ZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgo+PiArICogTUVSQ0hBTlRBQklMSVRZIG9yIEZJ
VE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiBTZWUgdGhlCj4+ICsgKiBHTlUgR2VuZXJh
bCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgo+PiArICoKPj4gKyAqIFlvdSBzaG91
bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
Cj4+ICsgKiBhbG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCBzZWUgPGh0dHA6Ly93d3cu
Z251Lm9yZy9saWNlbnNlcy8+Lgo+PiArICovCj4gTm90ZSwgaWYgeW91IGhhdmUgdGhlIFNQRFgg
bGluZSwgeW91IGNhbiBnZXQgcmlkIG9mIGFsbCBvZiB0aGUKPiBib2lsZXJwbGF0ZSAiR1BMIHRl
eHQiIGFzIHdlbGwuICBXZSBoYXZlIGJlZW4gZG9pbmcgdGhhdCBmb3IgbG90cyBvZgo+IGtlcm5l
bCBmaWxlcywgbm8gbmVlZCB0byBhZGQgbW9yZSB0byBpbmNyZWFzZSBvdXIgd29ya2xvYWQuCgpB
Y2suIFRoYW5rcyBmb3IgdGhlIGhlYWRzLXVwLCBHcmVnLgoKUmVtb3ZlZCBpbiB2MyBmcm9tIGFs
bCB0aGUgbmV3IGZpbGVzIGluIHRoaXMgcGF0Y2ggc2VyaWVzLgoKQW5kcmEKCgoKCkFtYXpvbiBE
ZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdB
IFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAw
NDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBK
MjIvMjYyMS8yMDA1Lgo=


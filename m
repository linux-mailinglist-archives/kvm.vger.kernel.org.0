Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605B31E6791
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 18:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405136AbgE1Qh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 12:37:28 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:50124 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405088AbgE1QhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 12:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590683844; x=1622219844;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ShGieAlB1fCAj5Iy+xyLopAcjCT2+LXZg8SdNEj8Pr4=;
  b=SD5A/8WF0V4ybajDogG+6hJQviXEYlDV5ReZ6zTKOUZxFexBXdPFmXS7
   Ny2A4ng3syv4fb/2P2sNHEbJ6j0xGFr9L5GBgPAYB/6yvVc4dOqZvwqsh
   WusFaoNL+m241zvUTi28nKVO4b0j7ibRU2io/vyEgApHUI5qJER3+lksb
   8=;
IronPort-SDR: PsJwySsBiy26uaimzxrZkePCCqn82LwyC71jWoND0Ky9jWeip0eRd/rTcTgRMrhi/C3npaeuQ5
 /eZ6bJ2TVRXg==
X-IronPort-AV: E=Sophos;i="5.73,445,1583193600"; 
   d="scan'208";a="38653622"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 May 2020 16:37:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id CC9672835AF;
        Thu, 28 May 2020 16:37:19 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 16:37:19 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.34) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 May 2020 16:37:11 +0000
Subject: Re: [PATCH v3 02/18] nitro_enclaves: Define the PCI device interface
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
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-3-andraprs@amazon.com>
 <20200526064455.GA2580530@kroah.com>
 <bd25183c-3b2d-7671-f699-78988a39a633@amazon.com>
 <20200526222109.GB179549@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <ceca466d-4c2e-8693-08c7-1fea5ab68cb7@amazon.com>
Date:   Thu, 28 May 2020 19:37:06 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526222109.GB179549@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D36UWB003.ant.amazon.com (10.43.161.118) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy8wNS8yMDIwIDAxOjIxLCBHcmVnIEtIIHdyb3RlOgo+IE9uIFR1ZSwgTWF5IDI2LCAy
MDIwIGF0IDA4OjAxOjM2UE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDI2LzA1LzIwMjAgMDk6NDQsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBUdWUsIE1heSAy
NiwgMjAyMCBhdCAwMToxMzoxOEFNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+Pj4g
K3N0cnVjdCBlbmNsYXZlX2dldF9zbG90X3JlcSB7Cj4+Pj4gKwkvKiBDb250ZXh0IElEIChDSUQp
IGZvciB0aGUgZW5jbGF2ZSB2c29jayBkZXZpY2UuICovCj4+Pj4gKwl1NjQgZW5jbGF2ZV9jaWQ7
Cj4+Pj4gK30gX19hdHRyaWJ1dGVfXyAoKF9fcGFja2VkX18pKTsKPj4+IENhbiB5b3UgcmVhbGx5
ICJwYWNrIiBhIHNpbmdsZSBtZW1iZXIgc3RydWN0dXJlPwo+Pj4KPj4+IEFueXdheSwgd2UgaGF2
ZSBiZXR0ZXIgd2F5cyB0byBzcGVjaWZ5IHRoaXMgaW5zdGVhZCBvZiB0aGUgInJhdyIKPj4+IF9f
YXR0cmlidXRlX18gb3B0aW9uLiAgQnV0IGZpcnN0IHNlZSBpZiB5b3UgcmVhbGx5IG5lZWQgYW55
IG9mIHRoZXNlLCBhdAo+Pj4gZmlyc3QgZ2xhbmNlLCBJIGRvIG5vdCB0aGluayB5b3UgZG8gYXQg
YWxsLCBhbmQgdGhleSBjYW4gYWxsIGJlIHJlbW92ZWQuCj4+IFRoZXJlIGFyZSBhIGNvdXBsZSBv
ZiBkYXRhIHN0cnVjdHVyZXMgd2l0aCBtb3JlIHRoYW4gb25lIG1lbWJlciBhbmQgbXVsdGlwbGUK
Pj4gZmllbGQgc2l6ZXMuIEFuZCBmb3IgdGhlIG9uZXMgdGhhdCBhcmUgbm90LCBnYXRoZXJlZCBh
cyBmZWVkYmFjayBmcm9tCj4+IHByZXZpb3VzIHJvdW5kcyBvZiByZXZpZXcgdGhhdCBzaG91bGQg
Y29uc2lkZXIgYWRkaW5nIGEgImZsYWdzIiBmaWVsZCBpbgo+PiB0aGVyZSBmb3IgZnVydGhlciBl
eHRlbnNpYmlsaXR5Lgo+IFBsZWFzZSBkbyBub3QgZG8gdGhhdCBpbiBpb2N0bHMuICBKdXN0IGNy
ZWF0ZSBuZXcgY2FsbHMgaW5zdGVhZCBvZgo+IHRyeWluZyB0byAiZXh0ZW5kIiBleGlzdGluZyBv
bmVzLiAgSXQncyBhbHdheXMgbXVjaCBlYXNpZXIuCj4KPj4gSSBjYW4gbW9kaWZ5IHRvIGhhdmUg
Il9fcGFja2VkIiBpbnN0ZWFkIG9mIHRoZSBhdHRyaWJ1dGUgY2FsbG91dC4KPiBNYWtlIHN1cmUg
eW91IGV2ZW4gbmVlZCB0aGF0LCBhcyBJIGRvbid0IHRoaW5rIHlvdSBkbyBmb3Igc3RydWN0dXJl
cwo+IGxpa2UgdGhlIGFib3ZlIG9uZSwgcmlnaHQ/CgpGb3IgdGhlIG9uZXMgbGlrZSB0aGUgYWJv
dmUsIG5vdCwgSSBqdXN0IGN1c3RvbWl6ZWQgdGhlIHVzYWdlIG9mICJfX3BhY2tlZCIuCgpUaGFu
a3MsCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiBy
ZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElh
c2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4g
UmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97B51B65D0
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 22:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgDWU4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 16:56:18 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:46606 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgDWU4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 16:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587675378; x=1619211378;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0S83oBfqDWuSdd9AaloZ5eml95gdIqfKx3IPqDHjd5E=;
  b=UsXa2sz6it2/aYuk5tpqayjeUym+p849O+dzvWUUOtegcXM1kvtki3FC
   /ENcZvDX4aJvTADlbg30glD9/MiEY0fRehsbtbgHLyHPuRuqlXdkD5Fm1
   Z2Bu+6574fO1hWo0azlAZvlqELCmQ/f4aZ3XgMUEY5JXy5NJKnb377Y9Q
   o=;
IronPort-SDR: Zn8vzOeSfp5/fGSWpeLFwk5ovrbGiLXR+m876/QFJU9ehkXeF2nnw5Ljs05sN7D3GoMPQ5ZacH
 k/q3huFcpNCw==
X-IronPort-AV: E=Sophos;i="5.73,309,1583193600"; 
   d="scan'208";a="40543903"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Apr 2020 20:56:16 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id CD264A2977;
        Thu, 23 Apr 2020 20:56:15 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Apr 2020 20:56:15 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.203) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Apr 2020 20:56:11 +0000
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
 <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <80489572-72a1-dbe7-5306-60799711dae0@amazon.com>
Date:   Thu, 23 Apr 2020 22:56:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D27UWA001.ant.amazon.com (10.43.160.19) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wNC4yMCAxOTo1MSwgUGFvbG8gQm9uemluaSB3cm90ZToKPiAKPiBPbiAyMy8wNC8y
MCAxOTo0MiwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToKPj4+Cj4+Pj4+IC0gdGhlIGlu
aXRpYWwgQ1BVIHN0YXRlOiBDUEwwIHZzLiBDUEwzLCBpbml0aWFsIHByb2dyYW0gY291bnRlciwg
ZXRjLgo+Pgo+PiBUaGUgZW5jbGF2ZSBWTSBoYXMgaXRzIG93biBrZXJuZWwgYW5kIGZvbGxvd3Mg
dGhlIHdlbGwta25vd24gTGludXggYm9vdAo+PiBwcm90b2NvbCwgaW4gdGhlIGVuZCBnZXR0aW5n
IHRvIHRoZSB1c2VyIGFwcGxpY2F0aW9uIGFmdGVyIGluaXQgZmluaXNoZXMKPj4gaXRzIHdvcmss
IHNvIHRoYXQncyBDUEwzLgo+IAo+IENQTDMgaXMgaG93IHRoZSB1c2VyIGFwcGxpY2F0aW9uIHJ1
biwgYnV0IGRvZXMgdGhlIGVuY2xhdmUncyBMaW51eCBib290Cj4gcHJvY2VzcyBzdGFydCBpbiBy
ZWFsIG1vZGUgYXQgdGhlIHJlc2V0IHZlY3RvciAoMHhmZmZmZmZmMCksIGluIDE2LWJpdAo+IHBy
b3RlY3RlZCBtb2RlIGF0IHRoZSBMaW51eCBiekltYWdlIGVudHJ5IHBvaW50LCBvciBhdCB0aGUg
RUxGIGVudHJ5IHBvaW50PwoKVGhlcmUgaXMgbm8gImVudHJ5IHBvaW50IiBwZXIgc2UuIFlvdSBw
cmVwb3B1bGF0ZSBhdCB0YXJnZXQgYnpJbWFnZSBpbnRvIAp0aGUgZW5jbGF2ZSBtZW1vcnkgb24g
Ym9vdCB3aGljaCB0aGVuIGZvbGxvd3MgdGhlIHN0YW5kYXJkIGJvb3QgCnByb3RvY29sLiBFdmVy
eXRoaW5nIGJlZm9yZSB0aGF0IChlbmNsYXZlIGZpcm13YXJlLCBldGMuKSBpcyBwcm92aWRlZCBi
eSAKdGhlIGVuY2xhdmUgZW52aXJvbm1lbnQuCgpUaGluayBvZiBpdCBsaWtlIGEgbWVjaGFuaXNt
IHRvIGxhdW5jaCBhIHNlY29uZCBRRU1VIGluc3RhbmNlIG9uIHRoZSAKaG9zdCwgYnV0IGFsbCB5
b3UgY2FuIGFjdHVhbGx5IGNvbnRyb2wgYXJlIHRoZSAtc21wLCAtbSwgLWtlcm5lbCBhbmQgCi1p
bml0cmQgcGFyYW1ldGVycy4gVGhlIG9ubHkgSS9PIGNoYW5uZWwgeW91IGhhdmUgYmV0d2VlbiB5
b3VyIFZNIGFuZCAKdGhhdCBuZXcgVk0gaXMgYSB2c29jayBjaGFubmVsIHdoaWNoIGlzIGNvbmZp
Z3VyZWQgYnkgdGhlIGhvc3Qgb24geW91ciAKYmVoYWxmLgoKCkFsZXgKCgoKQW1hem9uIERldmVs
b3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdl
c2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWlu
Z2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBC
ClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK


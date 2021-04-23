Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9082368FED
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 11:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhDWJ7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 05:59:35 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:5981 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhDWJ7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 05:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619171939; x=1650707939;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=cXNC7uikYdwCUpELACGEwC1FHUvytv+1LulwpirWLME=;
  b=TFLeAM/b9Fek+VCwknqpvLKGLF+zAjkKnr83lfE46uzdnfDWYvMW85MX
   ln0iyYx4FzATVaxmcuKL8Fzg3Uw4DtFDZe/wd5YxGFM7f20IdLdk1d5tY
   833XK7J/MVbLFNvDTd8BxAq3kUTiOv0sSjziZEMIAy72SEiwX1rCgKyYt
   E=;
X-IronPort-AV: E=Sophos;i="5.82,245,1613433600"; 
   d="scan'208";a="103560581"
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 23 Apr 2021 09:58:50 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 51796A1CAC;
        Fri, 23 Apr 2021 09:58:49 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 23 Apr 2021 09:58:49 +0000
Received: from [10.95.82.45] (10.43.161.41) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 09:58:34 +0000
Message-ID: <ded8db53-0e58-654a-fff2-de536bcbc961@amazon.com>
Date:   Fri, 23 Apr 2021 11:58:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:89.0)
 Gecko/20100101 Thunderbird/89.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC:     Evgeny Iakovlev <eyakovl@amazon.de>, Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210423090333.21910-1-sidcha@amazon.de>
 <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
 <213887af-78b8-03ad-b3f9-c2194cb27b13@redhat.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <213887af-78b8-03ad-b3f9-c2194cb27b13@redhat.com>
X-Originating-IP: [10.43.161.41]
X-ClientProxiedBy: EX13D31UWA004.ant.amazon.com (10.43.160.217) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wNC4yMSAxMTo1MCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBDQVVUSU9OOiBUaGlz
IGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5v
dCAKPiBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZp
cm0gdGhlIHNlbmRlciBhbmQgCj4ga25vdyB0aGVjb250ZW50IGlzIHNhZmUuCj4gCj4gCj4gCj4g
T24gMjMvMDQvMjEgMTE6MjQsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+PiBJIGNhbiBzZWUgaG93
IHRoYXQgbWF5IGdldCBpbnRlcmVzdGluZyBmb3Igb3RoZXIgb3ZlcmxheSBwYWdlcyBsYXRlciwK
Pj4gYnV0IHRoaXMgb25lIGluIHBhcnRpY3VsYXIgaXMganVzdCBhbiBNU1Igd3JpdGUsIG5vPyBJ
cyB0aGVyZSBhbnkgcmVhc29uCj4+IHdlIGNhbid0IGp1c3QgdXNlIHRoZSB1c2VyIHNwYWNlIE1T
UiBoYW5kbGluZyBsb2dpYyBpbnN0ZWFkPwo+Pgo+PiBXaGF0J3MgbWlzc2luZyB0aGVuIGlzIGEg
d2F5IHRvIHB1bGwgdGhlIGhjYWxsIHBhZ2UgY29udGVudHMgZnJvbSBLVk0uCj4+IEJ1dCBldmVu
IHRoZXJlIEknbSBub3QgY29udmluY2VkIHRoYXQgS1ZNIHNob3VsZCBiZSB0aGUgcmVmZXJlbmNl
IHBvaW50Cj4+IGZvciBpdHMgY29udGVudHMuIElzbid0IHVzZXIgc3BhY2UgaW4gYW4gYXMgZ29v
ZCBwb3NpdGlvbiB0byBhc3NlbWJsZSBpdD8KPiAKPiBJbiB0aGVvcnkgdXNlcnNwYWNlIGRvZXNu
J3Qga25vdyBob3cgS1ZNIHdpc2hlcyB0byBpbXBsZW1lbnQgdGhlCj4gaHlwZXJjYWxsIHBhZ2Us
IGVzcGVjaWFsbHkgaWYgWGVuIGh5cGVyY2FsbHMgYXJlIGVuYWJsZWQgYXMgd2VsbC4KCkknbSBu
b3Qgc3VyZSBJIGFncmVlIHdpdGggdGhhdCBzZW50aW1lbnQgOikuIFVzZXIgc3BhY2UgaXMgdGhl
IG9uZSB0aGF0IApzZXRzIHRoZSB4ZW4gY29tcGF0IG1vZGUuIEFsbCB3ZSBuZWVkIHRvIGRvIGlz
IGRlY2xhcmUgdGhlIE9SaW5nIGFzIHBhcnQgCm9mIHRoZSBLVk0gQUJJLiBXaGljaCB3ZSBlZmZl
Y3RpdmVseSBhcmUgZG9pbmcgYWxyZWFkeSwgYmVjYXVzZSBpdCdzIApwYXJ0IG9mIHRoZSBBQkkg
dG8gdGhlIGd1ZXN0LCBubz8KCj4gCj4gQnV0IHVzZXJzcGFjZSBoYXMgdHdvIHBsYXVzaWJsZSB3
YXlzIHRvIGdldCB0aGUgcGFnZSBjb250ZW50czoKPiAKPiAxKSBhZGQgYSBpb2N0bCB0byB3cml0
ZSB0aGUgaHlwZXJjYWxsIHBhZ2UgY29udGVudHMgdG8gYW4gYXJiaXRyYXJ5Cj4gdXNlcnNwYWNl
IGFkZHJlc3MKPiAKPiAyKSBhZnRlciB1c2Vyc3BhY2UgdXBkYXRlcyB0aGUgbWVtc2xvdHMgdG8g
YWRkIHRoZSBvdmVybGF5IHBhZ2UgYXQgdGhlCj4gcmlnaHQgcGxhY2UsIHVzZSBLVk1fU0VUX01T
UiBmcm9tIHVzZXJzcGFjZSAod2hpY2ggd29uJ3QgYmUgZmlsdGVyZWQKPiBiZWNhdXNlIGl0J3Mg
aG9zdCBpbml0aWF0ZWQpCj4gCj4gVGhlIHNlY29uZCBoYXMgdGhlIGFkdmFudGFnZSBvZiBub3Qg
bmVlZGluZyBhbnkgbmV3IGNvZGUgYXQgYWxsLCBidXQKPiBpdCdzIGEgYml0IG1vcmUgdWdseS4K
ClRoZSBtb3JlIG9mIGFsbCBvZiB0aGF0IGh5cGVyLXYgY29kZSB3ZSBjYW4gaGF2ZSBsaXZlIGlu
IHVzZXIgc3BhY2UsIHRoZSAKaGFwcGllciBJIGFtIDopLgoKCkFsZXgKCgoKQW1hem9uIERldmVs
b3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdl
c2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWlu
Z2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBC
ClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK


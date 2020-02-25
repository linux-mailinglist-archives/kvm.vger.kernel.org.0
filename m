Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F048516BA90
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 08:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgBYH0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 02:26:11 -0500
Received: from out0-141.mail.aliyun.com ([140.205.0.141]:46939 "EHLO
        out0-141.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYH0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 02:26:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1582615534; h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type;
        bh=MyP2VYm6zQxeLDqMP64k6CcffU+U8M2ZC8LHKjDk8bg=;
        b=K2Ve2LO/mAKUwK9dK6JBkupp8BTScujoitCLDgg+S3dpm6QnK5nyQbM97FUKFJlZf6uFRiVb7JxxTRUo6Du2Dvdj5jebWMHZM9eKlWyo85DLTR1noJCrRvs13Qm0I01NgmzP+/SmvE+fAa63JUn74ajfMv18+2Hs0DE2T+oEue0=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01a16378;MF=bangcai.hrg@alibaba-inc.com;NM=1;PH=DW;RN=16;SR=0;TI=W4_5790132_DEFAULT_0AC26464_1582614793747_o7001c540a;
Received: from WS-web (bangcai.hrg@alibaba-inc.com[W4_5790132_DEFAULT_0AC26464_1582614793747_o7001c540a]) by e02c03293.eu6 at Tue, 25 Feb 2020 15:25:30 +0800
Date:   Tue, 25 Feb 2020 15:25:30 +0800
From:   "=?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?=" <bangcai.hrg@alibaba-inc.com>
To:     "Nadav Amit" <namit@vmware.com>
Cc:     "peterz" <peterz@infradead.org>, "kernellwp" <kernellwp@gmail.com>,
        "pbonzini" <pbonzini@redhat.com>,
        "dave.hansen" <dave.hansen@intel.com>, "mingo" <mingo@redhat.com>,
        "tglx" <tglx@linutronix.de>, "x86" <x86@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "dave.hansen" <dave.hansen@linux.intel.com>, "bp" <bp@alien8.de>,
        "luto" <luto@kernel.org>, "kvm" <kvm@vger.kernel.org>,
        "=?UTF-8?B?5p6X5rC45ZCsKOa1t+aeqyk=?=" <yongting.lyt@alibaba-inc.com>,
        "=?UTF-8?B?5ZC05ZCv57++KOWQr+e/vik=?=" <qixuan.wqx@alibaba-inc.com>,
        "herongguang" <herongguang@linux.alibaba.com>
Reply-To: "=?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?=" 
          <bangcai.hrg@alibaba-inc.com>
Message-ID: <600a0d33-b995-453e-b678-0436908cd857.bangcai.hrg@alibaba-inc.com>
Subject: =?UTF-8?B?5Zue5aSN77yaW1JGQ10gUXVlc3Rpb24gYWJvdXQgYXN5bmMgVExCIGZsdXNoIGFuZCBLVk0g?=
  =?UTF-8?B?cHYgdGxiIGltcHJvdmVtZW50cw==?=
X-Mailer: [Alimail-Mailagent revision 59873560][W4_5790132][DEFAULT][Chrome]
MIME-Version: 1.0
References: <07348bb2-c8a5-41d0-afca-26c1056570a5.bangcai.hrg@alibaba-inc.com>,<C6DFCB69-25A6-43FE-92E9-C9E675CAB615@vmware.com>
x-aliyun-mail-creator: W4_5790132_DEFAULT_M2ITW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzgwLjAuMzk4Ny4xMTYgU2FmYXJpLzUzNy4zNg==3L
In-Reply-To: <C6DFCB69-25A6-43FE-92E9-C9E675CAB615@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pj4gT24gRmViIDI0LCAyMDIwLCBhdCA4OjEyIFBNLCDkvZXlrrnlhYko6YKm6YeHKSA8YmFuZ2Nh
aS5ocmdAYWxpYmFiYS1pbmMuY29tPiB3cm90ZToKPj4gCj4+IEhpIHRoZXJlLAo+PiAKPj4gSSBz
YXcgdGhpcyBhc3luYyBUTEIgZmx1c2ggcGF0Y2ggYXQKPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvcGF0Y2h3b3JrL3BhdGNoLzEwODI0ODEvICwgYW5kIEkgYW0gd29uZGVyaW5nCj4+IGFmdGVy
IG9uZSB5ZWFyLCBkbyB5b3UgdGhpbmsgaWYgdGhpcyBwYXRjaCBpcyBwcmFjdGljYWwgb3IgdGhl
cmUgYXJlCj4+IGZ1bmN0aW9uYWwgZmxhd3M/IEZyb20gbXkgUE9WLCBOYWRhdidzIHBhdGNoIHNl
ZW1zIGhhcyBubyBvYnZpb3VzIGZsYXcuCj4+IEJ1dCBJIGFtIG5vdCBmYW1pbGlhciBhYm91dCB0
aGUgcmVsYXRpb25zaGlwIGJldHdlZW4gQ1BVJ3Mgc3BlY3VsYXRpb24KPj4gZXhlYyBhbmQgc3Rh
bGUgVExCLCBzaW5jZSBpdCdzIHVzdWFsbHkgdHJhbnNwYXJlbnQgZnJvbSBwcm9ncmFtaW5nLiBJ
bgo+PiB3aGljaCBjb25kaXRpb24gd291bGQgbWFjaGluZSBjaGVjayBvY2N1cnM/IElzIHRoZXJl
IHNvbWUgcmVmZXJlbmNlIEkgY2FuCj4+IGxlYXJuPwoKPiBJIHdhcy9hbSBoZWxkIGJhY2sgYnkg
cGVyc29uYWwgaXNzdWVzIHRoYXQgY29uc3VtZSBteSBmcmVlIHRpbWUsIHdoaWNoCj4gcHJldmVu
dGVkIG1lIGZyb20gc2VuZGluZyBhIG5ldyB2ZXJzaW9uIHNvIGZhci4KCkdvb2QgdG8gaGVhciB0
aGF0IDopCgo+IEFzIGZvciB0aGUgcGF0Y2gtc2V0IC0gdGhlIGdyZWF0ZXN0IGJlbmVmaXQgaW4g
cGVyZm9ybWFuY2UgY29tZXMgZnJvbQo+IHJ1bm5pbmcgbG9jYWwvcmVtb3RlIFRMQiBmbHVzaGVz
IGNvbmN1cnJlbnRseSwgYW5kIEkgd2lsbCByZXNwaW4gYW5vdGhlcgo+IHZlcnNpb24gb2YgdGhh
dCBpbiB0d28gd2Vla3MgdGltZS4gSSB3aWxsIHNlbmQgdGhlIGFzeW5jIGZsdXNoZXMgYWZ0ZXJ3
YXJkcy4KCkluIG5vbi1vdmVyY29tbWl0bWVudCB2aXJ0dWFsaXphdGlvbiBlbnZpcm9ubWVudCwg
SSB0aGluayB0aGlzIHdpbGwgYmUgCmJlbmVmaWNpYWwuIFNpbmNlIHRoZSBhc3luYyBpbXBsZW1l
bnRhdGlvbiBzdGlsbCBuZWVkIHJlbW90ZSBDUFXigJlzIElQSSAKcmVzcG9uc2UsIHB2IHRsYiBm
bHVzaCBjYW4gYWRkcmVzcyB0aGlzIHNjZW5hcmlv4oCZcyBuZWVkLgoKRG8geW91IGhhdmUgYW55
IHJlZmVyZW5jZSBhYm91dCByZWxhdGlvbnNoaXAgYmV0d2VlbiBDUFUncyBzcGVjdWxhdGlvbgph
bmQgc3RhbGUgVExCLCBlc3BlY2lhbGx5IGNhdXNpbmcgbWFjaGluZSBjaGVjaz8gSSB3YW50IHRv
IGxlYXJuIGFib3V0IHRoaXMsIAp0aGFua3Mu

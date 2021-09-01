Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433663FE252
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 20:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhIASZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 14:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhIASZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 14:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74BDE60724;
        Wed,  1 Sep 2021 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630520673;
        bh=oG3UR1b0S7YAGQmjwOu2Zyz76lEjCq5yTG2uKcqa9KA=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=D2NMnlXUrEvbrtKVjx1kK9teKjOL1MmzspE9zIhUB8I8pr/QmwdCdlzB3fJZ3NJaq
         BmOfYD5GBZ7WSGE15fcR3lX01UAuobSCBdrlakocz/KcZanPAMfyx5Qp7UFP9DK/+V
         aGq7TyTodjIk2sWMi6vqmH9sk08ZS8ZtMkXwv+CHWDVoW5exGjNiK2Bx5YbHMq/W5n
         RSDQPpW5lt4Xq9rm7ZOXsW9rSpqUkl6AmB728IRzWOawBDrlpiQreMOE7CXJvimEeO
         SrMFLJw7jARcFVct7ccZxZ/2EwrcXuOIJeQLJK5K3h1i39K8Bud8I1V9nrCeioL0zA
         1K99rX12e06KA==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 96A2427C0054;
        Wed,  1 Sep 2021 14:24:30 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 14:24:30 -0400
X-ME-Sender: <xms:WcUvYdOZ0Yl17QKXtxHsmN4R7cJdvAiE0LSEuPkW6FpOYfxEoIZL5w>
    <xme:WcUvYf8s7A6lp8AGK87O6ovdjO-iA6ewicgqVb7pZbAZT89RGE_gPmF6sRqBTu5eS
    fVQnWItjnLVA2TRWeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnhepgeejgffhtdelvdefgeefleevtdfgveekuefgkeffvdevfeefteei
    heeuteevkeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudek
    heeifedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuh
    igrdhluhhtohdruhhs
X-ME-Proxy: <xmx:WcUvYcSacB-8SjHG8oSvgtnICiblKn0fNYWRuBm1-Lkk5E58EyqjxQ>
    <xmx:WcUvYZtpkXdko9ingMa5gIN2f7CBIOXc2kuXRyW9raXhAu9cVSnvJg>
    <xmx:WcUvYVf98o7hivpMENtc1-r24VTEViSaVpdkErLywciUUydYMqNcgA>
    <xmx:XsUvYaNDMZ6-bscufmIVhpATsJW_tZgHKO7NTKYDCyiVSNaVz9LhxA5wjYg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id DB913A002E4; Wed,  1 Sep 2021 14:24:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <40115c03-255b-4328-b0a2-fb60d707c4a2@www.fastmail.com>
In-Reply-To: <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <YSlkzLblHfiiPyVM@google.com>
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
 <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
 <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
 <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
Date:   Wed, 01 Sep 2021 11:24:04 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "James Bottomley" <jejb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>, "kvm list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@alien8.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Joerg Roedel" <jroedel@suse.de>,
        "Andi Kleen" <ak@linux.intel.com>,
        "David Rientjes" <rientjes@google.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Varad Gautam" <varad.gautam@suse.com>,
        "Dario Faggioli" <dfaggioli@suse.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-mm@kvack.org,
        linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Sathyanarayanan Kuppuswamy" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Yu Zhang" <yu.c.zhang@linux.intel.com>
Subject: =?UTF-8?Q?Re:_[RFC]_KVM:_mm:_fd-based_approach_for_supporting_KVM_guest_?=
 =?UTF-8?Q?private_memory?=
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Wed, Sep 1, 2021, at 9:18 AM, James Bottomley wrote:
> On Wed, 2021-09-01 at 08:54 -0700, Andy Lutomirski wrote:
> [...]
> > If you want to swap a page on TDX, you can't.  Sorry, go directly to
> > jail, do not collect $200.
> 
> Actually, even on SEV-ES you can't either.  You can read the encrypted
> page and write it out if you want, but unless you swap it back to the
> exact same physical memory location, the encryption key won't work. 
> Since we don't guarantee this for swap, I think swap won't actually
> work for any confidential computing environment.
> 
> > So I think there are literally zero code paths that currently call
> > try_to_unmap() that will actually work like that on TDX.  If we run
> > out of memory on a TDX host, we can kill the guest completely and
> > reclaim all of its memory (which probably also involves killing QEMU
> > or whatever other user program is in charge), but that's really our
> > only option.
> 
> I think our only option for swap is guest co-operation.  We're going to
> have to inflate a balloon or something in the guest and have the guest
> driver do some type of bounce of the page, where it becomes an
> unencrypted page in the guest (so the host can read it without the
> physical address keying of the encryption getting in the way) but
> actually encrypted with a swap transfer key known only to the guest.  I
> assume we can use the page acceptance infrastructure currently being
> discussed elsewhere to do swap back in as well ... the host provides
> the guest with the encrypted swap page and the guest has to decrypt it
> and place it in encrypted guest memory.

I think the TD module could, without hardware changes, fairly efficiently re-encrypt guest pages for swap.  The TD module has access to the full CPU crypto capabilities, so this wouldn't be slow.  It would just require convincing the TD module team to implement such a feature.

It would be very, very nice for whatever swap support ends up existing to work without guest cooperation -- even if the guest is cooperative, we don't want to end up waiting for the guest to help when the host is under memory pressure.

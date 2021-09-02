Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71703FF50F
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 22:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344353AbhIBUnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 16:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232045AbhIBUnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 16:43:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31A8060FDA;
        Thu,  2 Sep 2021 20:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630615376;
        bh=rWIymJXj+z/ROnyg3o5j/Hn6mBCszau7W/Lim8edb4A=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=lZl9S5JcZecn4dzUrXeaGD0pBee4WU3gjZKJ9NXRJHcTEniagn6SEmZxstuB5eUYl
         5wAz9oPTsLg9hfa9mRCybTd4mx5lnFrV3u67dSjhAgAbvUuujLItVNR0VJNj2DAfCf
         khdOwzp21TM1TaI0k+8W5Eowdi9bbXTMG86RxVufzK/X4hA3RDIoNDg1/ykUBCnddm
         q02AOxZoXCPnsuQggYahQoRN590utXvDFJrPskDSzB4+9NyjVoPBqP3Ofq/1hQbM7k
         HSH3JJ9S2fEEBd9o5AaDjfmJRwMN6phbq8X+qsPG8NsgPmKPMMMnyEePgeAOwcLNQo
         p6biWSMye4b7A==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 4B85727C0054;
        Thu,  2 Sep 2021 16:42:53 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Thu, 02 Sep 2021 16:42:53 -0400
X-ME-Sender: <xms:STcxYXELiZptWKXuifzlO5zbzy63ylvm9raSa9yKctg3SnsvfaHBIw>
    <xme:STcxYUWBw76fkb8Xlaqdhq1zNgxN21O_kiDtviOTM8avEB5TDjDvcGUJSamtw8G9K
    bRAJdsqMW0mRuxQxug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvhedgudehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnhepgeejgffhtdelvdefgeefleevtdfgveekuefgkeffvdevfeefteei
    heeuteevkeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudek
    heeifedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuh
    igrdhluhhtohdruhhs
X-ME-Proxy: <xmx:SjcxYZJgXti8WB1x2l19F3OIFYUE13lO1jgoHUoZaDnnSYPhQreNlg>
    <xmx:SjcxYVG2bdIxaH_ChYxQy-PuEaaiuec56bk-Uk-49bsMYlzuxbp7Lw>
    <xmx:SjcxYdUqc7dih4AB7UGjaiNrmkm2OZAEeDEixjNeKnyBP9vGhoBJ6A>
    <xmx:TTcxYQqdAbs8fIfe0Z8hXr-CAoBmRNw3DLbfD2cyfDH9oW7X3qFLjRw4sEc>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E78B2A002E4; Thu,  2 Sep 2021 16:42:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <a979ba51-8693-43a0-bebb-b8b1938ff74c@www.fastmail.com>
In-Reply-To: <ef14702f-4f31-8784-8583-0b79bb7d0a07@intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
 <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
 <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org> <YTCZAjdci5yx+n6l@suse.de>
 <b10b09b0-d5ea-b72a-106a-4e1b0df4dc66@kernel.org>
 <YTEei9RBDHnRfe/B@google.com>
 <ef14702f-4f31-8784-8583-0b79bb7d0a07@intel.com>
Date:   Thu, 02 Sep 2021 13:42:28 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Dave Hansen" <dave.hansen@intel.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Joerg Roedel" <jroedel@suse.de>,
        "Yu Zhang" <yu.c.zhang@linux.intel.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>, "kvm list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@alien8.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
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
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: =?UTF-8?Q?Re:_[RFC]_KVM:_mm:_fd-based_approach_for_supporting_KVM_guest_?=
 =?UTF-8?Q?private_memory?=
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Thu, Sep 2, 2021, at 12:07 PM, Dave Hansen wrote:
> On 9/2/21 11:57 AM, Sean Christopherson wrote:
> > On Thu, Sep 02, 2021, Andy Lutomirski wrote:
> >> On 9/2/21 2:27 AM, Joerg Roedel wrote:
> >>> On Wed, Sep 01, 2021 at 09:07:59AM -0700, Andy Lutomirski wrote:
> >>>> In principle, you could actually initialize a TDX guest with all of its
> >>>> memory shared and all of it mapped in the host IOMMU.
> >>> Not sure how this works in TDX, but in SEV code fetches are always
> >>> treated as encrypted. So this approach would not work with SEV, not to
> >>> speak about attestation, which will not work with this approach either
> >>> :)
> >>>
> >> Oof.
> > TDX is kinda similar.  _All_ accesses are private if paging is disabled because
> > the shared bit is either bit 48 or bit 51 in the GPA, i.e. can't be reached if
> > paging is disabled.  The vCPU is hardcoded to start in unpaged protected mode,
> > so at least some amount of guest memory needs to be private.
> 
> That's a rule we should definitely add to our page table checker.  Just
> like how we can look for W+X, we should also look for Shared+X.
> 

The only case I can thing of where the TDX vs SEV rule matters is for some mildly crazy user who wants to run user code out of an unencrypted DAX device (or virtio-fs, I guess).  We can save that for another year :)

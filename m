Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DFB3F9EBA
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 20:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhH0SZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 14:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhH0SZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 14:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 847C160EFE;
        Fri, 27 Aug 2021 18:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630088684;
        bh=GZgUgAVx/dgRddny0IXLMsCZm2xbh6JcZV5htCnbqUA=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=BuztgwPAQ3nWhde5Jc8SzsWaqUn5ics5X6QzE8+3FOMwS/HqFVkxgnJqiSIqVnVog
         J0Y9v+wAzEV33jtevrSterz0CgKG2iDPNJu8ZloywV3rRPAY17stVwHzbGi6DwQGvP
         9UOJeFcYuPLT/0mo83z3B09pebo9hYqLUBigD8WoeIuqeueqHRn3+Km1FqBGkMjOLZ
         kPCNMqkVgbQPTo709ZT/BzrWmCka6sEFw69wDIfTmw65VpxNc5dYioJlLNXQN57v6A
         3mTYf0PjByelXEBp7t642K9zdc5lmXYdFWqw6b9kLN+Cw02j8VV2+PbkCbfNKF7F6t
         Y/+oUMZr8v/rw==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 85DF627C005B;
        Fri, 27 Aug 2021 14:24:41 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Fri, 27 Aug 2021 14:24:41 -0400
X-ME-Sender: <xms:5C0pYa63Z2rI7RdyYDqhX8lrgSjlOajbK3ACaA1C9VooeLrEAuiP_Q>
    <xme:5C0pYT6ljf1vWbqJFbtM0GPm7LDRThDWdvdVotT1ulca4XUB_Ol_wAdtq5EPow577
    pnOw2ynZ6SBrZDqc9o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddufedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnhepgeejgffhtdelvdefgeefleevtdfgveekuefgkeffvdevfeefteei
    heeuteevkeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudek
    heeifedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuh
    igrdhluhhtohdruhhs
X-ME-Proxy: <xmx:5C0pYZdnTUiOWN-5cqz7CAY15qS-yrhctiSXkLpcatNeGt37E159sw>
    <xmx:5C0pYXIxHgo0r9HNtT3tVg6FFGlkrQH_uxUVitTeI89Iql-viqgfVQ>
    <xmx:5C0pYeI9oxyAM994QgsUE6SRbjpvco-Bh2rF54yDNMOe3bNeN0YjyA>
    <xmx:6S0pYZc6wV4T00P8gQKZqY9P8fNgMJMHz6FuSc4SMYgw3Ap78YPr60PTbYM>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 60531A038A7; Fri, 27 Aug 2021 14:24:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1125-g685cec594c-fm-20210825.001-g685cec59
Mime-Version: 1.0
Message-Id: <73319f3c-6f5e-4f39-a678-7be5fddd55f2@www.fastmail.com>
In-Reply-To: <cfe75e39-5927-c02a-b8bc-4de026bb7b3b@redhat.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <40af9d25-c854-8846-fdab-13fe70b3b279@kernel.org>
 <cfe75e39-5927-c02a-b8bc-4de026bb7b3b@redhat.com>
Date:   Fri, 27 Aug 2021 11:24:13 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "David Hildenbrand" <david@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Cc:     "Vitaly Kuznetsov" <vkuznets@redhat.com>,
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



On Thu, Aug 26, 2021, at 2:26 PM, David Hildenbrand wrote:
> On 26.08.21 19:05, Andy Lutomirski wrote:

> > Oof.  That's quite a requirement.  What's the point of the VMA once all
> > this is done?
> 
> You can keep using things like mbind(), madvise(), ... and the GUP code 
> with a special flag might mostly just do what you want. You won't have 
> to reinvent too many wheels on the page fault logic side at least.
> 

You can keep calling the functions.  The implementations working is a different story: you can't just unmap (pte_numa-style or otherwise) a private guest page to quiesce it, move it with memcpy(), and then fault it back in.

In any event, adding fd-based NUMA APIs would be quite nice.  Look at the numactl command.

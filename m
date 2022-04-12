Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6255D4FEAFF
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiDLXcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiDLXb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D9A90247;
        Tue, 12 Apr 2022 15:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A6C7B82053;
        Tue, 12 Apr 2022 21:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F4CC385A1;
        Tue, 12 Apr 2022 21:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649798896;
        bh=7S+oixBL7sX4olcPvEogXh1CnNUMKSWXUwyI+LxpXRE=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=VeaZBY812RM8tTVwEPyJ9MBmgJnUTNE3sOrPD+M+bRRQd4EXv4xZNTVDRWsnHQnwQ
         nuEGf6ZS9C+ddtULVHoelJ+Sys31+fgbgfzbPl7GYMkrHkx+KbamhWBM51zUmpa7uC
         Nz3+aaac1rGMVm9tdy/qnGNhTl0Owq87IWjWQ2D1s4XMov8f45oX8L5UFp5j14fKB1
         fUi8j32KOY9GS5oSTtfMNRglZuQ3KRzJIVrSoHc2j3VWCyxbo7QDEh3cyg9pjOTG/b
         pJpnm81PNU1smIdqbJ2fvppy3P5h96qGmyCkUvdLdvoFWbMMEm49cfILB22CFnvhk1
         qy5OI5cnCaJyQ==
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 7946527C0054;
        Tue, 12 Apr 2022 17:28:14 -0400 (EDT)
Received: from imap48 ([10.202.2.98])
  by compute2.internal (MEProxy); Tue, 12 Apr 2022 17:28:14 -0400
X-ME-Sender: <xms:7O5VYs8lwj5MdavzExLyZhrEgbyrMiXO1_DykQcKY2g__StryccvLg>
    <xme:7O5VYksvbMuraQrcmnb8o2HTVmPudvAs7MmppnApRRSbRQMEWGcVhYJ_I038GcBsW
    oGC0DG9AcdNarZgApI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekkedgudeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnheptdfhheettddvtedvtedugfeuuefhtddugedvleevleefvdetleff
    gfefvdekgeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudek
    heeifedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuh
    igrdhluhhtohdruhhs
X-ME-Proxy: <xmx:7O5VYiDdEWrfajiYcqB6p9FGUWaxorJ-LkXsFLirb2kvXcFcs9_BxA>
    <xmx:7O5VYsdSqRSo04iR81u4yMDTPrY70kYHKZ8P32NVv-cia2RpB69IFQ>
    <xmx:7O5VYhPNLgqdnPVunYupFyg9opu97sHVHE74yrryNGsN3ZjS8OKsMA>
    <xmx:7u5VYouNmHo5xGvWKYHuRhvQVKHXleE35LAx2SW8yLyHvIsfA3MUUA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 8882521E0073; Tue, 12 Apr 2022 17:28:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-386-g4174665229-fm-20220406.001-g41746652
Mime-Version: 1.0
Message-Id: <6f44ddf9-6755-4120-be8b-7a62f0abc0e0@www.fastmail.com>
In-Reply-To: <20220412143636.GG64706@ziepe.ca>
References: <20220310140911.50924-1-chao.p.peng@linux.intel.com>
 <20220310140911.50924-5-chao.p.peng@linux.intel.com>
 <Yk8L0CwKpTrv3Rg3@google.com>
 <02e18c90-196e-409e-b2ac-822aceea8891@www.fastmail.com>
 <YlB3Z8fqJ+67a2Ck@google.com>
 <7ab689e7-e04d-5693-f899-d2d785b09892@redhat.com>
 <20220412143636.GG64706@ziepe.ca>
Date:   Tue, 12 Apr 2022 14:27:52 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Jason Gunthorpe" <jgg@ziepe.ca>,
        "David Hildenbrand" <david@redhat.com>
Cc:     "Sean Christopherson" <seanjc@google.com>,
        "Chao Peng" <chao.p.peng@linux.intel.com>,
        "kvm list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        "Linux API" <linux-api@vger.kernel.org>, qemu-devel@nongnu.org,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Hugh Dickins" <hughd@google.com>,
        "Jeff Layton" <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Mike Rapoport" <rppt@kernel.org>,
        "Steven Price" <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Vishal Annapurve" <vannapurve@google.com>,
        "Yu Zhang" <yu.c.zhang@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Linux API" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v5 04/13] mm/shmem: Restrict MFD_INACCESSIBLE memory against
 RLIMIT_MEMLOCK
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, at 7:36 AM, Jason Gunthorpe wrote:
> On Fri, Apr 08, 2022 at 08:54:02PM +0200, David Hildenbrand wrote:
>
>> RLIMIT_MEMLOCK was the obvious candidate, but as we discovered int he
>> past already with secretmem, it's not 100% that good of a fit (unmovable
>> is worth than mlocked). But it gets the job done for now at least.
>
> No, it doesn't. There are too many different interpretations how
> MELOCK is supposed to work
>
> eg VFIO accounts per-process so hostile users can just fork to go past
> it.
>
> RDMA is per-process but uses a different counter, so you can double up
>
> iouring is per-user and users a 3rd counter, so it can triple up on
> the above two
>
>> So I'm open for alternative to limit the amount of unmovable memory we
>> might allocate for user space, and then we could convert seretmem as well.
>
> I think it has to be cgroup based considering where we are now :\
>

So this is another situation where the actual backend (TDX, SEV, pKVM, pure software) makes a difference -- depending on exactly what backend we're using, the memory may not be unmoveable.  It might even be swappable (in the potentially distant future).

Anyway, here's a concrete proposal, with a bit of handwaving:

We add new cgroup limits:

memory.unmoveable
memory.locked

These can be set to an actual number or they can be set to the special value ROOT_CAP.  If they're set to ROOT_CAP, then anyone in the cgroup with capable(CAP_SYS_RESOURCE) (i.e. the global capability) can allocate movable or locked memory with this (and potentially other) new APIs.  If it's 0, then they can't.  If it's another value, then the memory can be allocated, charged to the cgroup, up to the limit, with no particular capability needed.  The default at boot is ROOT_CAP.  Anyone who wants to configure it differently is free to do so.  This avoids introducing a DoS, makes it easy to run tests without configuring cgroup, and lets serious users set up their cgroups.

Nothing is charge per mm.

To make this fully sensible, we need to know what the backend is for the private memory before allocating any so that we can charge it accordingly.

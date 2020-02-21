Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B99167673
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 09:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbgBUIej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 03:34:39 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40869 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730892AbgBUIei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 03:34:38 -0500
Received: by mail-lj1-f195.google.com with SMTP id n18so1308769ljo.7
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 00:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GAUPCeoLmUbGJZ3+4ib2zfRVx/YWbNvBapxhsuZYy9Q=;
        b=v/I8s2jsi6Tfn1/UR6lgR+jvzx+PE3o5TCApKG4ymuUP0qsIDcf/6aY/Ef4Qf1S47y
         QaDvK0ZVv71GxsEjIPWnGSGJ/tUHw8NoocrPhBgqNxYC73kqFWPnqOsO9mq7KHP289kw
         1I+1nrsTDTBWkxwYtr1pGKLyb5YqSqeL6YKmPIg3XcY3pNBeSOyp7ZSDniVdbT33f0by
         SvuzaPMq4hnQGE6Z6tPOP4lC7JTwxBsmdSwj8FPoBTOdJ05dMYIyv0EgRoLNdkHdEkm4
         0Hml9WFH/ncspbKXrKBHli5EFIeKGYdydJEwgioP1rvgxGQKQwWF9bxlc8fc8KvFw5MZ
         TfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GAUPCeoLmUbGJZ3+4ib2zfRVx/YWbNvBapxhsuZYy9Q=;
        b=mD9+NZPGB4MfE2YrNnbTV+x0ssRUhJHHsHYo2ZURuibPjzYYBmIJEfs7BcVAH5bClF
         r+wJEzQNnLubKdx3Bj+SRmR9aa/1BF0B6rkfced2tJGXeU1wGW79vocxA8XGNHj8wZlx
         7wnrFkkmAE2KBTLfiSa1iDqKLu5zQ4hZIPeQpPiyUQtvtPBP29AiUzFdq/vwiVTlHVnF
         XteH6+RRkrkSlZYuGA9SS8owRViOkdUzSXlD1VqqXvz3oACtxYl7fZo4SEvMWX4zKdgS
         HMub90qosVy/22418krOUunEgf4JC9h6InfkrLFU7RBVosjdASuAi5koKnrl5Vy1srAt
         EoFA==
X-Gm-Message-State: APjAAAVD3bF+Y49HSIxgQOpdskR21x6nvjsVui8E2Fr54JUtmM0rotG4
        ywXKn7zd6NR/lzX4GsmscExo8NNoOyhqOP7uj8jDlQ==
X-Google-Smtp-Source: APXvYqw4iG3iiwGz2tuaB36GrFPK1ydrAKGZD1Iv+K5jlT091UX5vaeuCVAegGvZDhIf6VFhh1NftY5tp5Hx64zLcuM=
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr2568751ljq.109.1582274074832;
 Fri, 21 Feb 2020 00:34:34 -0800 (PST)
MIME-Version: 1.0
References: <20200218184756.242904-1-oupton@google.com> <20200218190729.GD28156@linux.intel.com>
 <f08f7a3b-bd23-e8cd-2fd4-e0f546ad02e5@redhat.com> <CAOQ_Qshafx78-O4_HnK9MbOdmoBdZx6_sdAdLmugmXjURTXs6g@mail.gmail.com>
 <096c6b94-c629-7082-cd70-ab59fedffa7c@redhat.com>
In-Reply-To: <096c6b94-c629-7082-cd70-ab59fedffa7c@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 21 Feb 2020 00:34:23 -0800
Message-ID: <CAOQ_QshfVkvSG==rCbROaZ0E6V0s5gTQtcfnDSV-Ar5-jv-Cbg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 12:25 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/02/20 05:32, Oliver Upton wrote:
> > On Thu, Feb 20, 2020 at 3:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 18/02/20 20:07, Sean Christopherson wrote:
> >>> On Tue, Feb 18, 2020 at 10:47:56AM -0800, Oliver Upton wrote:
> >>>> Particularly draconian compilers warn of a possible uninitialized use of
> >>>> the nr_pages_avail variable. Silence this warning by initializing it to
> >>>> zero.
> >>> Can you check if the warning still exists with commit 6ad1e29fe0ab ("KVM:
> >>> Clean up __kvm_gfn_to_hva_cache_init() and its callers")?  I'm guessing
> >>> (hoping?) the suppression is no longer necessary.
> >>
> >> What if __gfn_to_hva_many and gfn_to_hva_many are marked __always_inline?
> >>
> >> Thanks,
> >>
> >> Paolo
> >>
> >
> > Even with this suggestion the compiler is ill-convinced :/
> >
> > in re to Sean: what do I mean by "draconian compiler"
> >
> > Well, the public answer is that both Barret and I use the same
> > compiler. Nothing particularly interesting about it, but idk what our
> > toolchain folks' stance is on divulging details.
> >
> > I'll instead use Sean's suggested fix (which reads much better) and resend.
>
> Can you instead look into fixing that compiler?  After inlining, it is
> trivial to realize that the first two returns imply
> kvm_is_error_hva(ghc->hva).  I'm asking this because even for GCC
> -Wuninitialized *used to be* total crap, but these days it's quite
> reliable and even basic data flow should be able to thread through the
> jumps.

Yeah, at this point I completely agree. I'll move onto a mainline
toolchain going forward. This was just a glaring change when I rebased
some work on top of the -Werror change (as it absolutely should).

>
> I'm more than willing to help the compiler with __always_inline hints,
> but an "uninitialized_var()" adds load on the code and I'm not sure it
> makes sense to do that for the sake of some proprietary, or at least
> unnamed, software.

Absolutely. I thought it sensible to send out the fix in case of other
toolchains out in the wild. But if nobody else other than us has
complained it's quite obvious where the problem lies.

Thanks!

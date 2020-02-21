Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84408166E90
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 05:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgBUEcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 23:32:45 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38326 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbgBUEcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 23:32:45 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so490419lfm.5
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 20:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AVTLDmfJCuhr0FwjNpTFAttVRply77VDT81b6O2Kk8I=;
        b=v+hUKv6UB0Hq0QvGLtM6pfpad/sMVEasrv6JPdM2zkKppeNsPVJBeSi13blj91dPKe
         qN8xeLN1AGabnbP1Q8VJlFxhaYp9HFWGzjy8AlZXeo83SeKatrtfTjGVwSqkSl/TRU3M
         UGM6ce9ckwLhg58V7X6KZKNe9wWrKakiDEJtxIibGBRub3KVY3GKXhflrcHRtyQeE2/8
         Z3USoQlvnzUHNjNNSx+Ds5Kofw3f4vJHRAdX9ikf0PoKyQd87XdFNRX7ktfiLZ7HBx16
         JyP78KWy/4Bl531UElSsqB+Cj37KtR7lKcyEwdmkN7W9H0BEV7kKWcIekeu1JSl90vM7
         GgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AVTLDmfJCuhr0FwjNpTFAttVRply77VDT81b6O2Kk8I=;
        b=jlIuQjCwdbthH+bbe1Mre/AGtA6nWc1jomdnZPSgXWuykqs6+Eu88dsVn3jDGv5SKe
         Li6a3ALSHqry61rX6QgBLhfMHpUMKcGOwc1n8jJZT6qSFZtVtIn6n/kfgqpAN5r3/bak
         +q4Qe1Nove6mzWXk4zmxdEOzfHMMt0xdQ0G7wRRr6OPtveHbYEMAR8GEQ9QDFlu7Nqd9
         a6451yzkuFFFz6S7jVEfT3eVV30UOk8JerfQLqD+tnx80wxYqXBCMxi1rGfIhW1gptVj
         Wp9y7Nv1nwQ2uC0GLGlA1IQtj7jtKGsUqE/FBuNujhU49dAlHafoP0bD68tDqMUoshPG
         iiMw==
X-Gm-Message-State: APjAAAVjZTOgWfZWw49cpX/BMrloVWwen8Ha3DJ063+5AiWY5YMhMIqC
        25ak52MJU6UPHQ8rRI8YHWilRej4AEI7vQ6skDKkOtrA
X-Google-Smtp-Source: APXvYqwGxLcH/JRS+tmS6gQMQUjTL8cvCYayCMNM/lCP0xqnAkLORvzyJTmnoxjV2TKwppt5seYbSgkPrqLL5CX3Dzw=
X-Received: by 2002:a05:6512:31ca:: with SMTP id j10mr7003741lfe.110.1582259562335;
 Thu, 20 Feb 2020 20:32:42 -0800 (PST)
MIME-Version: 1.0
References: <20200218184756.242904-1-oupton@google.com> <20200218190729.GD28156@linux.intel.com>
 <f08f7a3b-bd23-e8cd-2fd4-e0f546ad02e5@redhat.com>
In-Reply-To: <f08f7a3b-bd23-e8cd-2fd4-e0f546ad02e5@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 20 Feb 2020 20:32:30 -0800
Message-ID: <CAOQ_Qshafx78-O4_HnK9MbOdmoBdZx6_sdAdLmugmXjURTXs6g@mail.gmail.com>
Subject: Re: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 3:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 18/02/20 20:07, Sean Christopherson wrote:
> > On Tue, Feb 18, 2020 at 10:47:56AM -0800, Oliver Upton wrote:
> >> Particularly draconian compilers warn of a possible uninitialized use of
> >> the nr_pages_avail variable. Silence this warning by initializing it to
> >> zero.
> > Can you check if the warning still exists with commit 6ad1e29fe0ab ("KVM:
> > Clean up __kvm_gfn_to_hva_cache_init() and its callers")?  I'm guessing
> > (hoping?) the suppression is no longer necessary.
>
> What if __gfn_to_hva_many and gfn_to_hva_many are marked __always_inline?
>
> Thanks,
>
> Paolo
>

Even with this suggestion the compiler is ill-convinced :/

in re to Sean: what do I mean by "draconian compiler"

Well, the public answer is that both Barret and I use the same
compiler. Nothing particularly interesting about it, but idk what our
toolchain folks' stance is on divulging details.

I'll instead use Sean's suggested fix (which reads much better) and resend.

--
Thanks,
Oliver

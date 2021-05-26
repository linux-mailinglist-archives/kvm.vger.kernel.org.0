Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9387391C4B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhEZPqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235381AbhEZPqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 11:46:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BC1C06175F
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 08:44:42 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so562484pjt.1
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 08:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xH9Vy/L4PH5PgZ75Lk40znIEfGow9JElmm1w/62eWLM=;
        b=rJ8j7n0kErNXIoZSRax9qpZ+vYVs1+0fFNK8WhAJkMXZzI3a87O8oeML8U2jTFhUQx
         e6GxZ6TX2CX8DRvtmmOEtp2gtnSnng48tCMRAFXemZPzrExO+tZ5Kwe3w7b53nj0KB6j
         4lbHCHqdBy8oLfx94ri2u0PXhWLPQYm2yIAIYD74dCkQV3f8G+S9vo60yAv4C8+PPmnQ
         if83H6wUx6SgYjzfhh8oRh3KPdrMBIGH5Fh9RSg4vrrNG91TifX++VTimjYemKiMHDCG
         aJmInNZDCrpgcUBISMvXHVYAucwlH0ArNXde2sxdBPg6MZmmMHQ2H6wHk0/HSOzyI1XT
         1HfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xH9Vy/L4PH5PgZ75Lk40znIEfGow9JElmm1w/62eWLM=;
        b=d44WDW353sO8nwmKQbvImTOxiiK3ipd58KYqx0g5pOQe4rJoGcunWz81wfER+OobuY
         wNUj+jgRnRpYMy3soEoGImwmqS2iVa33Vi79n4CUZR08hWyDUTYiKGzi5668yttS65RT
         K38egRZP8OD0eVvKv+bpeFtplpHt21X0vKsq7kC3q5mDmWZv+eTItvwGFpEwjPtYzQfl
         9ainR0rNYmu2eqs+fYlf2Zr9sdVyhwKcEZoKxdj46pqZWVaWdg3bu5oQCtnuEcgZZCPg
         S19+StjZZFp/XKtcB3b2pUadhtaG38kFKpZTpMW8ZAvFXPFWfSwi0X58iuH0Bfhiuuqh
         yGyA==
X-Gm-Message-State: AOAM5339lgcGdJuUFcFw6wqGuJaF0OngooTWOTIcaQW8z8gHSQRiEAV0
        RjlcdHntaJZAC5vtu/Rd2dIvJA==
X-Google-Smtp-Source: ABdhPJweAGgjDENCEg6+wJtGzTpXibg4GLJHlrqIbo/XesV0zJzhrytQ1vkPogyZie6uaBFHWRpvdQ==
X-Received: by 2002:a17:902:6f09:b029:f9:173e:847d with SMTP id w9-20020a1709026f09b02900f9173e847dmr19275180plk.35.1622043881842;
        Wed, 26 May 2021 08:44:41 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id q24sm17055036pgb.19.2021.05.26.08.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:44:41 -0700 (PDT)
Date:   Wed, 26 May 2021 15:44:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Xu <peterx@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: Writable module parameters in KVM
Message-ID: <YK5s5SUQh69a19/F@google.com>
References: <CANgfPd_Pq2MkRUZiJynh7zkNuKE5oFGRjKeCjmgYP4vwvfMc1g@mail.gmail.com>
 <35fe7a86-d808-00e9-a6aa-e77b731bd4bf@redhat.com>
 <2fd417c59f40bd10a3446f9ed4be434e17e9a64f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fd417c59f40bd10a3446f9ed4be434e17e9a64f.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Maxim Levitsky wrote:
> On Wed, 2021-05-26 at 12:49 +0200, Paolo Bonzini wrote:
> > On 26/05/21 01:45, Ben Gardon wrote:
> > > At Google we have an informal practice of adding sysctls to control some 
> > > KVM features. Usually these just act as simple "chicken bits" which 
> > > allow us to turn off a feature without having to stall a kernel rollout 
> > > if some feature causes problems. (Sysctls were used for reasons specific 
> > > to Google infrastructure, not because they're necessarily better.)
> > > 
> > > We'd like to get rid of this divergence with upstream by converting the 
> > > sysctls to writable module parameters, but I'm not sure what the general 
> > > guidance is on writable module parameters. Looking through KVM, it seems 
> > > like we have several writable parameters, but they're mostly read-only.
> > 
> > Sure, making them writable is okay.  Most KVM parameters are read-only 
> > because it's much simpler (the usecase for introducing them was simply 
> > "test what would happen on old processors").  What are these features 
> > that you'd like to control?

My $0.02 is that most parameters should remain read-only, and making a param
writable (new or existing) must come with strong justification for taking on the
extra complexity.

I absolutely agree that making select params writable adds a ton of value, e.g.
being able to switch to/from the TDP MMU without reloading KVM saves a lot of
time when testing, toggling forced flush/sync on PGD reuse is extremely valuable
for triage and/or mitigation, etc...  But writable params should either bring a
lot of value and/or add near-zero complexity.

> > > I also don't see central documentation of the module parameters. They're 
> > > mentioned in the documentation for other features, but don't have their 
> > > own section / file. Should they?
> > 
> > They probably should, yes.
> > 
> > Paolo
> > 
> I vote (because I have fun with my win98 once in a while), to make 'npt'
> writable, since that is the only way to make it run on KVM on AMD.

For posterity, "that" refers to disabling NPT, not making 'npt' writable :-)

Making 'npt' writable is probably feasible ('ept' would be beyond messy), but I
strongly prefer to keep it read-only.  The direct impacts on the MMU and SVM
aren't too bad, but NPT is required for SEV and VLS, affects kvm_cpu_caps, etc...
And, no offense to win98, there's isn't a strong use case because outside of
personal usage, the host admin/VMM doesn't know that the guest will be running a
broken kernel.

> My personal itch only though!
> 
> Best regards,
> 	Maxim Levitsky
> 

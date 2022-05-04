Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75677519736
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 08:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344906AbiEDGIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 02:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344897AbiEDGI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 02:08:27 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCBE2CCA1
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 23:04:01 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id b5so301395ile.0
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 23:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XGV/yI/AH7Vq6Uc1ZUZIrrL18Dvg5tPD/cpS351hyzE=;
        b=CjKN6xU0n0tYzujvDQXMqvW3nb/hGKs45BzPz6TPyYLsCLZIUngG1c1Ey7d0Wo1wsi
         mvCfmDK6EN1wLVPnsAi0Ti26OWOqA5M91zmTRptAkK9Affrz1tyuaBwudacWpSiatA2X
         N+OrWt35yK51LRzzSHCFvR0nEW3tlSDQ4y8dVYcHgxddJ9JP96ODCs9dLCZIsSJKD4HH
         8Nj1mVLgJNre71TKdiDTmIwwzLuSJ576l9uJsCQRj8Nly8jddsI12Gep2+XRelQMWwKU
         vmc3fUXGWAtJTZyxpMidi4CheYqbuCigwhoh5M9MlEJb+Kgmj+ooqcGHLxAmOsUTZVbg
         3ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XGV/yI/AH7Vq6Uc1ZUZIrrL18Dvg5tPD/cpS351hyzE=;
        b=PtnREx4wBKXYMV0b2ERAhdjKeGMXJy/LF+991uY66DYlxHxmcQo0EItds5YyZiem1y
         pOurPsjC7TuyfRQbYLrgjd43ZfjIswvlIkqRu+NoIHIyXTYVQQ+BmLbN2tGsSRvHJKwB
         YsHME4eSzB7LXiP+ei5VZfS7MOfw2SUSjOwwlccn5rQbghrdXUVr4FYdaRjdp4a9C7nj
         sz9U4ETUuMf+9S9RI+niVdSUQaZEE6jcbORYKFJk/ksIpLDjdCi7gWSbcBYpunOLL4dq
         +N04crHrlA0L5vxkPeXC1Awr6+S3sK8xFkOhGvltwa0ul9arRJNbYn9WMB+kExOFa5GQ
         7pBQ==
X-Gm-Message-State: AOAM532eCz4/eeNHd0ZaaUAZCQQVTazBfcr2erfVQyxXEZVQgGq7hJkA
        12i085iNg1H54dAR+WBmG+Eypg==
X-Google-Smtp-Source: ABdhPJybkO0VxMJI+H7Eka4Hn8SbRtzQKe9jcQSiZ5vFKE7B/fVOejbJ5BBtvUMDzEKu291q53LC7g==
X-Received: by 2002:a92:dd86:0:b0:2bc:805c:23c7 with SMTP id g6-20020a92dd86000000b002bc805c23c7mr7513123iln.279.1651644241005;
        Tue, 03 May 2022 23:04:01 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id m10-20020a6b7c0a000000b0065a47e16f4dsm3457342iok.31.2022.05.03.23.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 23:04:00 -0700 (PDT)
Date:   Wed, 4 May 2022 06:03:56 +0000
From:   Oliver Upton <oupton@google.com>
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YnIXTMDpucMxnpFg@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com>
 <YmGJGIrNVmdqYJj8@google.com>
 <YmLRLf2GQSgA97Kr@google.com>
 <YmMTC2f0DiAU5OtZ@google.com>
 <YnE5dfaC3HpXli26@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnE5dfaC3HpXli26@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 02:17:25PM +0000, Quentin Perret wrote:
> On Friday 22 Apr 2022 at 20:41:47 (+0000), Oliver Upton wrote:
> > On Fri, Apr 22, 2022 at 04:00:45PM +0000, Quentin Perret wrote:
> > > On Thursday 21 Apr 2022 at 16:40:56 (+0000), Oliver Upton wrote:
> > > > The other option would be to not touch the subtree at all until the rcu
> > > > callback, as at that point software will not tweak the tables any more.
> > > > No need for atomics/spinning and can just do a boring traversal.
> > > 
> > > Right that is sort of what I had in mind. Note that I'm still trying to
> > > make my mind about the overall approach -- I can see how RCU protection
> > > provides a rather elegant solution to this problem, but this makes the
> > > whole thing inaccessible to e.g. pKVM where RCU is a non-starter.
> > 
> > Heh, figuring out how to do this for pKVM seemed hard hence my lazy
> > attempt :)
> > 
> > > A
> > > possible alternative that comes to mind would be to have all walkers
> > > take references on the pages as they walk down, and release them on
> > > their way back, but I'm still not sure how to make this race-safe. I'll
> > > have a think ...
> > 
> > Does pKVM ever collapse tables into blocks? That is the only reason any
> > of this mess ever gets roped in. If not I think it is possible to get
> > away with a rwlock with unmap on the write side and everything else on
> > the read side, right?
> > 
> > As far as regular KVM goes we get in this business when disabling dirty
> > logging on a memslot. Guest faults will lazily collapse the tables back
> > into blocks. An equally valid implementation would be just to unmap the
> > whole memslot and have the guest build out the tables again, which could
> > work with the aforementioned rwlock.
> 
> Apologies for the delay on this one, I was away for a while.
> 
> Yup, that all makes sense. FWIW the pKVM use-case I have in mind is
> slightly different. Specifically, in the pKVM world the hypervisor
> maintains a stage-2 for the host, that is all identity mapped. So we use
> nice big block mappings as much as we can. But when a protected guest
> starts, the hypervisor needs to break down the host stage-2 blocks to
> unmap the 4K guest pages from the host (which is where the protection
> comes from in pKVM). And when the guest is torn down, the host can
> reclaim its pages, hence putting us in a position to coallesce its
> stage-2 into nice big blocks again. Note that none of this coallescing
> is currently implemented even in our pKVM prototype, so it's a bit
> unfair to ask you to deal with this stuff now, but clearly it'd be cool
> if there was a way we could make these things coexist and even ideally
> share some code...

Oh, it certainly isn't unfair to make sure we've got good constructs
landing for everyone to use :-)

I'll need to chew on this a bit more to have a better answer. The reason
I hesitate to do the giant unmap for non-pKVM is that I believe we'd be
leaving some performance on the table for newer implementations of the
architecture. Having said that, avoiding a tlbi vmalls12e1is on every
collapsed table is highly desirable.

FEAT_BBM=2 semantics in the MMU is also on the todo list. In this case
we'd do a direct table->block transformation on the PTE and elide that
nasty tlbi.

Unless there's objections, I'll probably hobble this series along as-is
for the time being. My hope is that other table walkers can join in on
the parallel party later down the road.

Thanks for getting back to me.

--
Best,
Oliver

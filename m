Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DA059917A
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 01:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346226AbiHRXpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 19:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiHRXpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 19:45:41 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C66C6E897
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:45:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id jl18so2785888plb.1
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 16:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=rnP1Bh0lpl5qrPJmmGeDlykdaH++zpEsQwksAv0VGOc=;
        b=JF6CZHeTOxIrWzrIsYHyhNeJWXKWms2pYm2C77yKrxewRVxRjUWXgIYsoIUd9SPPdC
         NXMTzag5jmE96TMficR1A1qul0Vd/57H5mGaTrfsNwhVJZGu2PFVjxG0vkWMCzT+glZ/
         HPxx4Ey1jAfflJzX/mB3CmmhmXJ5+piLg7v1INa12YrVpx1i6xcIidQ9AnTrESPcLE5T
         Qum9sUB/8w1BY3OVvYbYw1GqBec0M4SfetPMkYNk8h0QiG++8J6McCZazb4TQ/KKYM3j
         L42IAWd6KpZK/Dix5eokGcaHsZHTv8botOeFEFsV3ZOPzBbSfuNoyv6svM7diMkEa06M
         pNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=rnP1Bh0lpl5qrPJmmGeDlykdaH++zpEsQwksAv0VGOc=;
        b=sQUOD3fZeviAmbcuqAqFkzr8SYotfU4erwNJCN3MqRdZAxYnwRy1KyKurPPm/zrbfw
         wBdF/v2rzHaCPvdOaJSOcB880eoBkcs8gLKaE2p40H1xiJnTSFm3UAW1OecKyBffZ7xg
         G6mLv97eO9y9au/RzlqPW38ER3L1eafSwHu3/bIRScvngqF8aWL6lgmNc4wEBLzflqJO
         JshnQmnG0LJHAdOpH1NMF87x4foceUxC3Okp2Zgvqw2uYlYCvEhsIDRypEmRpuYE2ZIi
         mk7RoawhEyhR0G9EiyytjtBeq3VqX77oGPj0VJ2RjArvBQ39+MW2wsP3PQ0fHZiItWLc
         7gKw==
X-Gm-Message-State: ACgBeo2+47d4yHqsqY426zMUzIRFjLlkA4jzrphWfP8FapVgrIXLKaYP
        mx+xzG3Dpm0EhIHUSr5S8A7Rhg==
X-Google-Smtp-Source: AA6agR4i2vPSZlYoMjygsa+gewEk5KPFWp3tffr14cDGfnHl4biS2t19ei+5L35fry9dmB00Ak0YQQ==
X-Received: by 2002:a17:90b:3e8c:b0:1f7:3792:d336 with SMTP id rj12-20020a17090b3e8c00b001f73792d336mr5513681pjb.0.1660866339687;
        Thu, 18 Aug 2022 16:45:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c138-20020a624e90000000b00528a097aeffsm2192919pfb.118.2022.08.18.16.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 16:45:39 -0700 (PDT)
Date:   Thu, 18 Aug 2022 23:45:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 3/8] KVM: x86/mmu: Rename NX huge pages
 fields/functions for consistency
Message-ID: <Yv7PHx2qSB0PwkP/@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-4-seanjc@google.com>
 <YvhL6jKfKCj0+74w@google.com>
 <YvrAoyhgNzTcvzkU@google.com>
 <YvwHpjxS9CCEVER7@google.com>
 <Yv0Tk0WAdxymSyUt@google.com>
 <Yv65c/t23GqpLPg3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv65c/t23GqpLPg3@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022, Mingwei Zhang wrote:
> On Wed, Aug 17, 2022, Sean Christopherson wrote:
> > Yes, they are shadow pages that the NX recovery thread should zap, but the reason
> > they should be zapped is because (a) the shadow page has at least one execute child
> > SPTE, (b) zapping the shadow page will also zap its child SPTEs, and (c) eliminating
> > all executable child SPTEs means KVM _might_ be able to instantiate an NX huge page.
> > 
> 
> oh, I scratched my head and finaly got your point. hmm. So the shadow
> pages are the 'blockers' to (re)create a NX huge page because of at
> least one present child executable spte. So, really, whether these
> shadow pages themselves are NX huge or not does not really matter. All
> we need to know is that they will be zapped in the future to help making
> recovery of an NX huge page possible.

More precisely, we want to zap shadow pages with executable children if and only
if they can _possibly_ be replaced with an NX huge page.  The "possibly" is saying
that zapping _may or may not_ result in an NX huge page.  And it also conveys that
pages that _cannot_ be replaced with an NX huge page are not on the list.

If the guest is still using any of the huge page for execution, then KVM can't
create an NX huge page (or it may temporarily create one and then zap it when the
gets takes an executable fault), but KVM can't know that until it zaps and the
guest takes a fault.  Thus, possibly.

> > > `nx_huge_page_disallowed` is easy to understand because it literally say
> > > 'nx_huge_page is not allowed', which is correct.
> > 
> > No, it's not correct.  The list isn't simply the set of shadow pages that disallow
> > NX huge pages, it's the set of shadow pages that disallow NX huge pages _and_ that
> > can possibly be replaced by an NX huge page if the shadow page and all its
> > (executable) children go away.
> > 
> 
> hmm, I think this naming is correct. The flag is used to talk to the
> 'fault handler' to say 'hey, don't create nx huge page, stupid'. Of
> course, it is also used to by the 'nx huge recovery thread', but the
> recovery thread will only check it for sanity purpose, which really does
> not matter, i.e., the thread will zap the pages anyway.

Ah, sorry, I thought you were suggesting "nx_huge_page_disallowed" for the list
name, but you were talking about the flag.  Yes, 100% agree that the flag is
appropriately named.

> > > But this one, it says 'possible nx_huge_pages', but they are not
> > > nx huge pages at all.
> > 
> > Yes, but they _can be_ NX huge pages, hence the "possible".  A super verbose name
> > would be something like mmu_pages_that_can_possibly_be_replaced_by_nx_huge_pages.
> > 
> 
> I can make a dramtic example as why 'possible' may not help:
> 
> /* Flag that decides something important. */
> bool possible_one;
> 
> The information we (readers) gain from reading the above is _0_.

But that's only half the story.  If we also had an associated flag

  bool one_disallowed;

a.k.a. nx_huge_page_disallowed, then when viewed together, readers know that the
existince of this struct disallows "one", but that structs with one_disallowed=true
_and_ possible_one=true _might_ be converted to "one", whereas structs with
possible_one=false _cannot_ be converted to "one".

> With that, since you already mentioned the name:
> 'mmu_pages_that_can_possibly_be_replaced_by_nx_huge_pages',
> why can't we shorten it by using 'mmu_pages_to_recover_nx_huge' or
> 'pages_to_recover_nx_huge'? 'recover' is the word that immediately
> connects with the 'recovery thread', which I think makes more sense on
> readability.

mmu_pages_to_recover_nx_huge doesn't capture that recovery isn't guaranteed.
IMO it also does a poor job of capturing _why_ pages are on the list, i.e. a
reader knows they are pages that will be "recovered", but it doesn't clarify that
they'll be recovered/zapped because KVM might be able to be replace them with NX
huge pages.  In other words, it doesn't help the reader understand why some, but
not all, nx_huge_page_disallowed are on the recovery list.

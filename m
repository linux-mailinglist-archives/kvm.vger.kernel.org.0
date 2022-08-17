Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006085973E9
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240891AbiHQQNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241016AbiHQQNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:13:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF664AD74
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:13:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a8so12893611pjg.5
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=qqrcs4+75hwSnlAyyJW7CxGuel/Uhq2fMqUXLvr+jl8=;
        b=sFmMnQ/oq7x7WRe9EuENHTmQNcGv4XgE+RNsgCtVxM6MA6778i6ya4GDWGLuk+mStg
         DHmGnn5+zqkU64si194ZaM1s6tMdKph6c+Y70qEfnNgqE24mt5l9CWpaXCZETn1y+rdN
         Vuq5aAUOtZkrJHobDZ7TNKGu+xKW39sL0Bg3JXfF2Huv12wT4ZT4PTWSQ3zVpSiOpT9M
         7OCRkB4+2q9TCTQlIBNyaj+g53Yddo/EQUDt369NvY4UPezz/DvsUFAHQn7Heg8MqzUn
         ky55yiJwqFcpAPceVpQ0QwccBNBEea5qcdXRDsj+Y2PnIZkx4GgJYCkE2cQZsBF75Aop
         Y3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qqrcs4+75hwSnlAyyJW7CxGuel/Uhq2fMqUXLvr+jl8=;
        b=MbquwcxCF/462IGcxUnH0v0qCHghc8DioLKiuOlRSW2wVWvuzJ3W51MUnJQdF7Xouv
         p4B6KdiGXjMU+9Mal+q64gCPECjvOSRT19SwQiRFpzoICmOuDj/ftgPiTFD77gxvM+07
         qtYYrKTvwAg6UpDRsNQJvAb/w7RdnKA/JnXCzpm58VZHSqeFM0GIQ++rhIp13G3XwXrZ
         9LaoopjhECU0gL7dElSTZqgZ2lgxUTNXnVSRFRa3T8GM/zOG7CGtx9ZWO4luuMOmPGFE
         WVfUudFazlEVhmSLdQNGpqcbPGvBn9BTu4z096xBxECPQv/AVnr/b3uDodkMvjbDjkZL
         iV5Q==
X-Gm-Message-State: ACgBeo3yu8kjN7LsmjUcFStltuL+/477N/1cFPY+zgZDccIJwRvZUEDe
        zn7jKj04fQ8Xezttd5O4SaGO8A==
X-Google-Smtp-Source: AA6agR68JEpNnS/Hoo1DyY2Re1ij1m8UmQCEt8XXw+4pPFqb/Ye34YCXob1WeGDc1WVKAntsb8nEQQ==
X-Received: by 2002:a17:902:ea0b:b0:16d:d268:e4c5 with SMTP id s11-20020a170902ea0b00b0016dd268e4c5mr26798569plg.152.1660752791687;
        Wed, 17 Aug 2022 09:13:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z8-20020a170903018800b0016f0d6213a5sm127418plg.2.2022.08.17.09.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 09:13:11 -0700 (PDT)
Date:   Wed, 17 Aug 2022 16:13:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 3/8] KVM: x86/mmu: Rename NX huge pages
 fields/functions for consistency
Message-ID: <Yv0Tk0WAdxymSyUt@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-4-seanjc@google.com>
 <YvhL6jKfKCj0+74w@google.com>
 <YvrAoyhgNzTcvzkU@google.com>
 <YvwHpjxS9CCEVER7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvwHpjxS9CCEVER7@google.com>
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

On Tue, Aug 16, 2022, Mingwei Zhang wrote:
> On Mon, Aug 15, 2022, Sean Christopherson wrote:
> > On Sun, Aug 14, 2022, Mingwei Zhang wrote:
> > > On Fri, Aug 05, 2022, Sean Christopherson wrote:
> > > > Rename most of the variables/functions involved in the NX huge page
> > > > mitigation to provide consistency, e.g. lpage vs huge page, and NX huge
> > > > vs huge NX, and also to provide clarity, e.g. to make it obvious the flag
> > > > applies only to the NX huge page mitigation, not to any condition that
> > > > prevents creating a huge page.
> > > > 
> > > > Leave the nx_lpage_splits stat alone as the name is ABI and thus set in
> > > > stone.
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm_host.h |  8 ++--
> > > >  arch/x86/kvm/mmu/mmu.c          | 70 +++++++++++++++++----------------
> > > >  arch/x86/kvm/mmu/mmu_internal.h | 22 +++++++----
> > > >  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
> > > >  arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++--
> > > >  5 files changed, 59 insertions(+), 51 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index e8281d64a431..5634347e5d05 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1143,7 +1143,7 @@ struct kvm_arch {
> > > >  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> > > >  	struct list_head active_mmu_pages;
> > > >  	struct list_head zapped_obsolete_pages;
> > > > -	struct list_head lpage_disallowed_mmu_pages;
> > > > +	struct list_head possible_nx_huge_pages;
> > > 
> > > Honestly, I am struggling to understand this one. 'possible_*' indicates
> > > that there are other possibilities. But what are those possibilities?
> > 
> > No, possible is being used as an adjective in this case.  possible_nx_huge_pages
> > is the list of shadow pages for which it's possible to replace the shadow page
> > with an NX huge page.
> > 
> > The noun version would yield a name like nx_huge_page_possiblities.
> 
> Right, but these shadow pages are not NX huge pages, right? IIUC, they
> are pages to be zapped due to NX huge pages, aren't they?

Yes, they are shadow pages that the NX recovery thread should zap, but the reason
they should be zapped is because (a) the shadow page has at least one execute child
SPTE, (b) zapping the shadow page will also zap its child SPTEs, and (c) eliminating
all executable child SPTEs means KVM _might_ be able to instantiate an NX huge page.

> `nx_huge_page_disallowed` is easy to understand because it literally say
> 'nx_huge_page is not allowed', which is correct.

No, it's not correct.  The list isn't simply the set of shadow pages that disallow
NX huge pages, it's the set of shadow pages that disallow NX huge pages _and_ that
can possibly be replaced by an NX huge page if the shadow page and all its
(executable) children go away.

> But this one, it says 'possible nx_huge_pages', but they are not
> nx huge pages at all.

Yes, but they _can be_ NX huge pages, hence the "possible".  A super verbose name
would be something like mmu_pages_that_can_possibly_be_replaced_by_nx_huge_pages.

> Instead, they are 'shadow pages that are replaced with nx_huge_pages'. So
> that's why updates to this list is done together with stats nx_plage_splits.
> 
> Please correct me if I am wrong. I am still struggling to understand the
> meaning of these variables.
> 
> >
> > > I feel this name is more confusing than the original one. Maybe just keep
> > 
> > Ignoring lpage => huge_page, the current name is terribly inaccurate.  The list
> > doesn't contain all disallowed huge pages, nor does it even contain all disallowed
> > NX huge pages, it specifically tracks shadow pages that might be able to be
> > replaced with an NX huge page.
> > 
> > I'm open to other names, but whatever we choose should be paired with
> > account_nx_huge_page()'s param that is currently named "nx_huge_page_possible".
> 
> How about mmu_pages_replaced_by_nx_huge,

"replaced" is past tense in this usage, and these are definitely not shadow pages
that have already been replaced by NX huge pages.

> mmu_pages_replaced_by_possible_nx_huge or something starting with

Same issue with "replaced".

> possible_pages_, pages_ instead of possible_nx_huge_pages?

Reprhasing, I think you're asking that the variable have "mmu_pages" somewhere in
the name to clarify that it's a list of kvm_mmu_page structs.  I agree that ideally
it would have "mmu_pages" somewhere in there, but I also think that having both
"nx_huge_pages" and "mmu_pages" in the name makes it unreadable, i.e. we have to
choose one use of "pages".

The only alternative I can come up with that isn't completely gross is
possible_nx_huge_mmu_pages.  I can't tell if that's less confusing or more
confusing.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF0E594E74
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiHPCEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiHPCEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:04:25 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70052230B6
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 14:54:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y141so7701945pfb.7
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 14:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=fE+O/3kXgE+dfXX70zlf5gVmTreUt0ffvp9RAaWF4P4=;
        b=GDo1cXAgIfU3xQO9g+UJaDIXYnd6qyBfZkeZBTu/XEGa3fsc642NUadPJU9PDcUMxt
         3LT1l6boMp7QBD0xlSQjQYOKR5oxzAsEQ92APE0voe82Ep98mKUgaQpjaTiG0ovc1yA+
         ilWEluzTPd59bDIKNf5CULsNvrHig0oE16T8InjQH3yXzl7IVhxsC/SBdM1QlM2nMjcN
         ciOEqIkDHvdROr1YK31FVCwU9E2vNv0Pe0Xiri3i9DZJL9EVqbMokxi8STCcZUk/b7sv
         w6Dd4G8xNF1e3mAh2D+8OpNcCnKli4r0lWaJXKi55fpQ9sUTpm8ZWBaamWc+PF6mBOR9
         rUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fE+O/3kXgE+dfXX70zlf5gVmTreUt0ffvp9RAaWF4P4=;
        b=30ct3Gprjx5VdI1KJ8ttnRzbMbKya+BCmTcjPy9dLvRx+RXGoTwlX9NcFVxFCUuFrD
         quhsrcpnS7Yf3SDdZKrQyOrxXy2r5Kg+3YnhepSRMy13tgq1t0JK0cMWdzEB2Rmbvhrj
         /RPDuvuTzDMoBZxPgRRjhSQkWeN76qCfCVo9oQqVT9L6k34nS0i9D4aMreM55pKVkLYS
         nGDnOP7un8BTaD9YEOAPmPmpNuIyjd8Jo+T+HkJboV2G7bRmiVzGiL08IlUIo4ONxC3v
         jeM5zvsQhPTooNtFR5PXdZdRizzCJ5imBTgJLty8165MklRj4XhfaxJsJUiIKxBcxOw/
         Zz9Q==
X-Gm-Message-State: ACgBeo1AjI0AicXwwNPWy1MfVNySPpOfGAAErn//oftf0CGTHGvzep69
        9Wc2Imqh4XejECXJmhWkj7h7aw==
X-Google-Smtp-Source: AA6agR4LEfebbNxgwZm00oHENwptapxAdoFIvEJrRB8wE/oRxdrmd9As66oLGQflSobKmeTJwzNSPw==
X-Received: by 2002:a63:cd4b:0:b0:421:95f3:1431 with SMTP id a11-20020a63cd4b000000b0042195f31431mr15336377pgj.486.1660600487602;
        Mon, 15 Aug 2022 14:54:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c139-20020a624e91000000b0052dddf69db2sm6966296pfb.57.2022.08.15.14.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:54:47 -0700 (PDT)
Date:   Mon, 15 Aug 2022 21:54:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 3/8] KVM: x86/mmu: Rename NX huge pages
 fields/functions for consistency
Message-ID: <YvrAoyhgNzTcvzkU@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-4-seanjc@google.com>
 <YvhL6jKfKCj0+74w@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvhL6jKfKCj0+74w@google.com>
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

On Sun, Aug 14, 2022, Mingwei Zhang wrote:
> On Fri, Aug 05, 2022, Sean Christopherson wrote:
> > Rename most of the variables/functions involved in the NX huge page
> > mitigation to provide consistency, e.g. lpage vs huge page, and NX huge
> > vs huge NX, and also to provide clarity, e.g. to make it obvious the flag
> > applies only to the NX huge page mitigation, not to any condition that
> > prevents creating a huge page.
> > 
> > Leave the nx_lpage_splits stat alone as the name is ABI and thus set in
> > stone.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  8 ++--
> >  arch/x86/kvm/mmu/mmu.c          | 70 +++++++++++++++++----------------
> >  arch/x86/kvm/mmu/mmu_internal.h | 22 +++++++----
> >  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++--
> >  5 files changed, 59 insertions(+), 51 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index e8281d64a431..5634347e5d05 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1143,7 +1143,7 @@ struct kvm_arch {
> >  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> >  	struct list_head active_mmu_pages;
> >  	struct list_head zapped_obsolete_pages;
> > -	struct list_head lpage_disallowed_mmu_pages;
> > +	struct list_head possible_nx_huge_pages;
> 
> Honestly, I am struggling to understand this one. 'possible_*' indicates
> that there are other possibilities. But what are those possibilities?

No, possible is being used as an adjective in this case.  possible_nx_huge_pages
is the list of shadow pages for which it's possible to replace the shadow page
with an NX huge page.

The noun version would yield a name like nx_huge_page_possiblities.

> I feel this name is more confusing than the original one. Maybe just keep

Ignoring lpage => huge_page, the current name is terribly inaccurate.  The list
doesn't contain all disallowed huge pages, nor does it even contain all disallowed
NX huge pages, it specifically tracks shadow pages that might be able to be
replaced with an NX huge page.

I'm open to other names, but whatever we choose should be paired with
account_nx_huge_page()'s param that is currently named "nx_huge_page_possible".

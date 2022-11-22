Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC66634456
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiKVTJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiKVTJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:09:28 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD39613DC2
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 11:09:26 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id n17so14840286pgh.9
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 11:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2S6j1zmQIQrZnvi67CtdZ53oyoRPz2J2JMs8lQBxICs=;
        b=JLDlF7qOViiO84MJ1yw5zagu82XAo9CyayWMltAu3sWCnb2Fj2fECgnPc6xMyWfLD+
         36LONeZ+ZHL/FA1voyquStCRI93XInt+fPySB87Jxpl9hqve4ZB7mkW9+YlX7l6S04AC
         AfTAzo48E8b4BlRCyv8U1mEbReTWtXrlvY+e+RNpVGVvlFU3w3EHDoHbP2Q+fi/6zZGu
         UTuB+JzZfDhQyYPO/bVxvl9oWRRbltQJxcJyUenpifabglu+5s5KvGX7wS0AeMBuQ5G/
         IE+e343/WjHMmYWUzr/AV1cKkF0wG3q2V/obZEU8Q8LCeQL9F4z6xKM1R2p7sqnykPAY
         BEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2S6j1zmQIQrZnvi67CtdZ53oyoRPz2J2JMs8lQBxICs=;
        b=aUVsA3zAdThP3khuj4lc3i3W9VxbVJbAmErKmoDw3iIE+JTNKVTvIoqybEDLkMF1uN
         eOi7SQbgEMRxxqqBF4Wi4A78opvDgQ+hpwt7h2pNm8/GqkCCROtHjOebYJxbYjPlqDK+
         xbJ/cMhHT0GomRv5YrPLvAymCCGvJJ6iKlrddPJzBNm8RtRkQrw6tZcG4icryR+7PXcI
         loo7s1iGkM0GVew/hlkLHs5WJUBx4+Sn+/3bht68GyKFdrBu2+ERaATJxxoqr3PR/o00
         PI/BtGDBBqzjIuHwckxnbTRWopwOBBct5ZfpNNGac+G8rSGEyzdfVBeLPs4eazpMKt27
         o7uQ==
X-Gm-Message-State: ANoB5pkbFBc99oaTOsUl+kAcbpNsv2mneOdAWb/5+pfqw21BB7BD0Mp7
        s+Z86Amc7fcDjU/28x4qlb/nzA==
X-Google-Smtp-Source: AA0mqf7yk1L6/+BEP+qMsN5LZOtxX60YfdtxTMTduOPYVz1t67jM/k0/2TWSyMSB3W8oXxrzxJVr7w==
X-Received: by 2002:a63:c46:0:b0:476:ed2a:6228 with SMTP id 6-20020a630c46000000b00476ed2a6228mr4713498pgm.137.1669144165988;
        Tue, 22 Nov 2022 11:09:25 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mg24-20020a17090b371800b002071ee97923sm12524752pjb.53.2022.11.22.11.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 11:09:25 -0800 (PST)
Date:   Tue, 22 Nov 2022 19:09:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paul Durrant <xadimgnik@gmail.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>
Subject: Re: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves
 within the same page
Message-ID: <Y30eYdpjClXehwWH@google.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-3-dwmw2@infradead.org>
 <681cf1b4edf04563bba651efb854e77f@amazon.co.uk>
 <Y3z3ZVoXXGWusfyj@google.com>
 <d7ae4bab-e826-ad0f-7248-81574a5f2b5c@gmail.com>
 <c552b55c926d8e284ba24773a02ea7da028787f5.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c552b55c926d8e284ba24773a02ea7da028787f5.camel@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022, David Woodhouse wrote:
> On Tue, 2022-11-22 at 16:49 +0000, Paul Durrant wrote:
> > > Tags need your real name, not just your email address, i.e. this should be:
> > >     Reviewed-by: Paul Durrant <paul@xen.org>
> > 
> > Yes indeed it should. Don't know how I managed to screw that up... It's 
> > not like haven't type that properly hundreds of times on Xen patch reviews.
> 
> All sorted in the tree I'm curating
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/gpc-fixes
> 
> Of those, three are marked as Cc:stable and want to go into the 6.1 release:
> 
>       KVM: x86/xen: Validate port number in SCHEDOP_poll
>       KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0
>       KVM: Update gfn_to_pfn_cache khva when it moves within the same page
> 
> The rest (including the runstate compatibility fixes) are less
> critical.
> 
> Sean, given that this now includes your patch series which in turn you
> took over from Michal, how would you prefer me to proceed?

If you're ok with a slight delay for fixing the runstate stuff, I think it makes
sense to push out everything else to fixes out to 6.3.  At the very least, I want
to explore using a gfn_to_hva_cache instead of two gfn_to_pfn_cache structures
for the runstate, which at this point would be a bit rushed for 6.2.

Pushing out to 6.3 will also give us time to do the more aggressive cleanup of
adding kvm_gpc_lock(), which I think will yield APIs that both of us are happy with,
i.e. the gpa+len of the cache can be immutable, but users can still validate their
individual usage.

> David Woodhouse (7):
>       KVM: x86/xen: Validate port number in SCHEDOP_poll
>       KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0
>       KVM: x86/xen: Add CPL to Xen hypercall tracepoint
>       MAINTAINERS: Add KVM x86/xen maintainer list
>       KVM: x86/xen: Compatibility fixes for shared runstate area
>       KVM: Update gfn_to_pfn_cache khva when it moves within the same page
>       KVM: x86/xen: Add runstate tests for 32-bit mode and crossing page boundary
> 
> Michal Luczaj (6):
>       KVM: Shorten gfn_to_pfn_cache function names
>       KVM: x86: Remove unused argument in gpc_unmap_khva()
>       KVM: Store immutable gfn_to_pfn_cache properties
>       KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_check()
>       KVM: Clean up hva_to_pfn_retry()
>       KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_refresh()
> 
> Sean Christopherson (4):
>       KVM: Drop KVM's API to allow temporarily unmapping gfn=>pfn cache
>       KVM: Do not partially reinitialize gfn=>pfn cache during activation
>       KVM: Drop @gpa from exported gfn=>pfn cache check() and refresh() helpers
>       KVM: Skip unnecessary "unmap" if gpc is already valid during refresh
> 
> We can reinstate the 'immutable length' thing on top, if we pick one of
> the discussed options for coping with the fact that for the runstate
> area, it *isn't* immutable. I'm slightly leaning towards just setting
> the length to '1' despite it being a lie.

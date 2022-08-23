Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE07E59CD0E
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbiHWAQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239119AbiHWAQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:16:26 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1757673
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:15:55 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g129so8591689pfb.8
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=5ONLOfjRsoyPNCSm/9MdBrJPI+jYBbaqSy2BAfAUm/Q=;
        b=OkDfM0p2XEu+RyEIar6eQhsqQQAAvfk5Y2ZPxRZvU28SOe4SV20koCjbQp5WYjV4MV
         10gDz1F5TcGWIN808P9wVGirnJYR45Bt4Z2T8MsF5VvTDh3GS7EPh28GF/ta2jmIFGss
         PzvrdDz10j8/IoefmrDSD23meeYWgxV+B2YhU+mtXDNWT805kwcHSOoo/HlFxaP40rnz
         poybFV1BbAE1QkifbrdVRWaYUv0wow4JkyiN//9CoBd0Ck0hBgIxi0BPjRKFNFYQE05+
         dvEIvK/A/DjdDqToAX2Iwx4TDgN1D7VmcjolXuL/ucnPneinOEZEWKKUksBc44dV3BI3
         Ml4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5ONLOfjRsoyPNCSm/9MdBrJPI+jYBbaqSy2BAfAUm/Q=;
        b=eexYaTOcs3zzuOWpcB1b5DsXEwJOrw2C8VwjfUzhx6tiPh9dxt/Bl61rx6T2rjNW1W
         UVFatHg877ZLswObM/5B8+8PSZLsKTTkvPHTutVBugTCTgITAF+NPzQkP4EVnQ4W05f0
         6QO4JDUlhdAAPH+XFix+jQSlsER8lkvoEoxS/P0UJCINr7VFkQUE+4RWxI63j46iX7Q2
         7j3xW3ee9Z4nT/tK7mY6jVZorLP6r5vKsQXCRQfxqfNnsIUwA+v98Je/u1e6yVIT/1Il
         eYds9yBmE0CPXHjS+KVbpdD4S37PZKG/zJZ9HatpmrGWO+sgDENv3071ARrFn+3zpnTv
         CBFQ==
X-Gm-Message-State: ACgBeo30gfL+r9s3gajHqJuVmO2iFKpGeWNr40qIVVPafLdWEUTu9sKd
        6dfOY96Z0CsFyhetS9zIocdtJFlWCVwcxw==
X-Google-Smtp-Source: AA6agR5bcsmhKNFUmJDECvCD72+wAIOTlxVXT6dxVHmC9aW2Q+UHWDFuOGMUuBSeKiY0xtcD2Gl16Q==
X-Received: by 2002:a63:1208:0:b0:423:c60e:ed09 with SMTP id h8-20020a631208000000b00423c60eed09mr18237602pgl.385.1661213755177;
        Mon, 22 Aug 2022 17:15:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m11-20020a170902db0b00b001637529493esm9055688plx.66.2022.08.22.17.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 17:15:54 -0700 (PDT)
Date:   Tue, 23 Aug 2022 00:15:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
        leobras@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] KVM: x86: Always enable legacy fp/sse
Message-ID: <YwQcN0GKMeZXNmhF@google.com>
References: <20220816175936.23238-1-dgilbert@redhat.com>
 <YvwODUu/rdzjzDjk@google.com>
 <YvzK+slWoAvm0/Wn@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvzK+slWoAvm0/Wn@work-vm>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022, Dr. David Alan Gilbert wrote:
> * Sean Christopherson (seanjc@google.com) wrote:
> > On Tue, Aug 16, 2022, Dr. David Alan Gilbert (git) wrote:
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index de6d44e07e34..3b2319cecfd1 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -298,7 +298,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  	guest_supported_xcr0 =
> > >  		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> > >  
> > > -	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0;
> > > +	vcpu->arch.guest_fpu.fpstate->user_xfeatures = guest_supported_xcr0 |
> > > +		XFEATURE_MASK_FPSSE;
> 
> Hi Sean,
>   Thanks for the reply,
> 
> > I don't think this is correct.  This will allow the guest to set the SSE bit
> > even when XSAVE isn't supported due to kvm_guest_supported_xcr0() returning
> > user_xfeatures.
> > 
> >   static inline u64 kvm_guest_supported_xcr0(struct kvm_vcpu *vcpu)
> >   {
> > 	return vcpu->arch.guest_fpu.fpstate->user_xfeatures;
> >   }
> > 
> > I believe the right place to fix this is in validate_user_xstate_header().  It's
> > reachable if and only if XSAVE is supported in the host, and when XSAVE is _not_
> > supported, the kernel unconditionally allows FP+SSE.  So it follows that the kernel
> > should also allow FP+SSE when using XSAVE too.  That would also align the logic
> > with fpu_copy_guest_fpstate_to_uabi(), which fordces the FPSSE flags.  Ditto for
> > the non-KVM save_xstate_epilog().
> 
> OK, yes, I'd followed the check that failed down to this test; although
> by itself this test works until Leo's patch came along later; so I
> wasn't sure where to fix it.
> 
> > Aha!  And fpu__init_system_xstate() ensure the host supports FP+SSE when XSAVE
> > is enabled (knew their had to be a sanity check somewhere).
> > 
> > ---
> >  arch/x86/kernel/fpu/xstate.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > index c8340156bfd2..83b9a9653d47 100644
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -399,8 +399,13 @@ int xfeature_size(int xfeature_nr)
> >  static int validate_user_xstate_header(const struct xstate_header *hdr,
> >  				       struct fpstate *fpstate)
> >  {
> > -	/* No unknown or supervisor features may be set */
> > -	if (hdr->xfeatures & ~fpstate->user_xfeatures)
> > +	/*
> > +	 * No unknown or supervisor features may be set.  Userspace is always
> > +	 * allowed to restore FP+SSE state (XSAVE/XRSTOR are used by the kernel
> > +	 * if and only if FP+SSE are supported in xstate).
> > +	 */
> > +	if (hdr->xfeatures & ~fpstate->user_xfeatures &
> > +	    ~(XFEATURE_MASK_FP | XFEATURE_MASK_SSE))
> >  		return -EINVAL;
> > 
> >  	/* Userspace must use the uncompacted format */
> 
> That passes the small smoke test for me; will you repost that then?

*sigh*

The bug is more subtle than just failing to restore.  Saving can also "fail".  If
XSAVE is hidden from the guest on an XSAVE-capable host, __copy_xstate_to_uabi_buf()
will happily reinitialize FP+SSE state and thus corrupt guest FPU state on migration.

And not that it matters now, but before realizing that KVM_GET_XSAVE is also broken,
I decided I like Dave's patch better because KVM really should separate what userspace
can save/restore from what the guest can access.

Amusingly, there's actually another bug lurking with respect to usurping user_xfeatures
to represent supported_guest_xcr0.  The latter is zero-initialized, whereas
user_xfeatures is set to the "default" features on initialization, i.e. migrating a
VM without ever doing KVM_SET_CPUID2 would do odd things.

Sending a v2 shortly to reinstate guest_supported_xcr0 before landing Dave's patch.

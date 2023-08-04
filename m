Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827AB7709F6
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 22:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjHDUpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 16:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjHDUpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 16:45:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B344EC8
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 13:45:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5840614b13cso41827937b3.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 13:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691181913; x=1691786713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1IZ9TxmG6rW/P+wqZtdK0JQvLT9QR/+7YuE6G9TOZBI=;
        b=hJWr9iNZ7BGT2VQ6gLFolHQwFpNRi7FPWyBaZ/8LClsSOkgMb0KuXKmwCV7LJJBoEs
         Ck0d/Et14/lhURaSSc9r3WcZZY8KjNPSLCXjVbTBVqejRbleGbw8erJNiGb8+8g0ZbDi
         /gpMCbeax0LRS6LNhzS4Y42bCFUIY6rtufCUjOeZpl/+TXMHrVumGaRz3tISh7Kb0j7e
         nzfbyITqbXai9Js0ghc36Xi4DEJBq1MZsCPTZLpALx44/lLLj5QdqhXDQC9Qs0yLpgWG
         K9mdKiPmKDNXFcYrfE0Oi3sBdBP+j45C+y++V4wTfdXIVpThHhrEOE7d9AbZhnpFSB3o
         VmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691181913; x=1691786713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1IZ9TxmG6rW/P+wqZtdK0JQvLT9QR/+7YuE6G9TOZBI=;
        b=G3nxdtWxmsX9IoY+O5Prq4kfgfNYjSBBGHrdYDg8BO7zPbjWF87ht8BFwhth2MLha+
         9T6nAsANEb23ZF04ZUQmQv4sxguGBN2ITag1slKXAUWcZMOvyyEpYUpGfzFXM4iDu1De
         fqZ1CaMbsXX/t805sBO8lKFYmUM0JvTLWGsUemwe8cJRZOl3ENuC6UvPmt05ju1H2Ikp
         ScLLv6r4XAkv1HeWAApZmjjfC3S9jXYH994XeASG0mmt8a5BHwuNPMmfQgLrLx9Wu52X
         Gz6gewWeFpJ20b1bq5imJD2aHd9mi4vEr+pHwY2ER8Z+CUkMr750l3N8IgXz8sPjExuJ
         Nqkg==
X-Gm-Message-State: AOJu0Yw/cLuem47mnGR5ojDOzETcMBmeCJZhvZcIdQKxrKlRkwsIznti
        P6siyIaiGQcXauGZ0mkOiynQvp5d3DM=
X-Google-Smtp-Source: AGHT+IF2PuxW12h6zfqO88bv+26n+39oznd1/LTsgYYcLOWAbuIVI79Xjo5Y4jv112tU7Ec4Uhs30w/DD4c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2c0a:b0:586:88d5:9434 with SMTP id
 eo10-20020a05690c2c0a00b0058688d59434mr8303ywb.1.1691181913764; Fri, 04 Aug
 2023 13:45:13 -0700 (PDT)
Date:   Fri, 4 Aug 2023 13:45:11 -0700
In-Reply-To: <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com> <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
Message-ID: <ZM1jV3UPL0AMpVDI@google.com>
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023, Weijiang Yang wrote:
> On 8/3/2023 7:15 PM, Chao Gao wrote:
> > On Thu, Aug 03, 2023 at 12:27:22AM -0400, Yang Weijiang wrote:
> > > +void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {

Drop the unlikely, KVM should not speculate on the guest configuration or underlying
hardware.

> > > +		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
> > > +		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
> > > +		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
> > > +		/*
> > > +		 * Omit reset to host PL{1,2}_SSP because Linux will never use
> > > +		 * these MSRs.
> > > +		 */
> > > +		wrmsrl(MSR_IA32_PL0_SSP, 0);
> > This wrmsrl() can be dropped because host doesn't support SSS yet.
> Frankly speaking, I want to remove this line of code. But that would mess up the MSR
> on host side, i.e., from host perspective, the MSRs could be filled with garbage data,
> and looks awful.

So?  :-)

That's the case for all of the MSRs that KVM defers restoring until the host
returns to userspace, i.e. running in the host with bogus values in hardware is
nothing new.

And as I mentioned in the other thread regarding the assertion that SSS isn't
enabled in the host, sanitizing hardware values for something that should never
be consumed is a fools errand.

> Anyway, I can remove it.

Yes please, though it may be a moot point.

> > > +	}
> > > +}
> > > +EXPORT_SYMBOL_GPL(save_cet_supervisor_ssp);
> > > +
> > > +void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
> > ditto
> Below is to reload guest supervisor SSPs instead of resetting host ones.
> > > +		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
> > > +		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
> > > +		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);

Pulling back in the justification from v3:

 the Pros:
  - Super easy to implement for KVM.
  - Automatically avoids saving and restoring this data when the vmexit
    is handled within KVM.

 the Cons:
  - Unnecessarily restores XFEATURE_CET_KERNEL when switching to
    non-KVM task's userspace.
  - Forces allocating space for this state on all tasks, whether or not
    they use KVM, and with likely zero users today and the near future.
  - Complicates the FPU optimization thinking by including things that
    can have no affect on userspace in the FPU

IMO the pros far outweigh the cons.  3x RDMSR and 3x WRMSR when loading host/guest
state is non-trivial overhead.  That can be mitigated, e.g. by utilizing the
user return MSR framework, but it's still unpalatable.  It's unlikely many guests
will SSS in the *near* future, but I don't want to end up with code that performs
poorly in the future and needs to be rewritten.

Especially because another big negative is that not utilizing XSTATE bleeds into
KVM's ABI.  Userspace has to be told to manually save+restore MSRs instead of just
letting KVM_{G,S}ET_XSAVE handle the state.  And that will create a bit of a
snafu if Linux does gain support for SSS.

On the other hand, the extra per-task memory is all of 24 bytes.  AFAICT, there's
literally zero effect on guest XSTATE allocations because those are vmalloc'd and
thus rounded up to PAGE_SIZE, i.e. the next 4KiB.  And XSTATE needs to be 64-byte
aligned, so the 24 bytes is only actually meaningful if the current size is within
24 bytes of the next cahce line.  And the "current" size is variable depending on
which features are present and enabled, i.e. it's a roll of the dice as to whether
or not using XSTATE for supervisor CET would actually increase memory usage.  And
_if_ it does increase memory consumption, I have a very hard time believing an
extra 64 bytes in the worst case scenario is a dealbreaker.

If the performance is a concern, i.e. we don't want to eat saving/restoring the
MSRs when switching to/from host FPU context, then I *think* that's simply a matter
of keeping guest state resident when loading non-guest FPU state.

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1015af1ae562..8e7599e3b923 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -167,6 +167,16 @@ void restore_fpregs_from_fpstate(struct fpstate *fpstate, u64 mask)
                 */
                xfd_update_state(fpstate);
 
+               /*
+                * Leave supervisor CET state as-is when loading host state
+                * (kernel or userspace).  Supervisor CET state is managed via
+                * XSTATE for KVM guests, but the host never consumes said
+                * state (doesn't support supervisor shadow stacks), i.e. it's
+                * safe to keep guest state loaded into hardware.
+                */
+               if (!fpstate->is_guest)
+                       mask &= ~XFEATURE_MASK_CET_KERNEL;
+
                /*
                 * Restoring state always needs to modify all features
                 * which are in @mask even if the current task cannot use


So unless I'm missing something, NAK to this approach, at least not without trying
the kernel FPU approach, i.e. I want somelike like to PeterZ or tglx to actually
full on NAK the kernel approach before we consider shoving a hack into KVM.

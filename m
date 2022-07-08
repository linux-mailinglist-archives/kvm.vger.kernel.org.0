Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1BB56BD9A
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbiGHPaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 11:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238135AbiGHPa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 11:30:29 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DED201AC
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 08:30:28 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fz10so12226565pjb.2
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 08:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d9SZaW9TdUlnYANMiQGXK69jbz9VKFutNOocxVIUW6I=;
        b=Am7vQcOVtmuDVVhXIgmLFXcZrfujW6B/qJNSCRBe1GVQI/DYZi9aq92jCUxmam9Azw
         jpqSseVoL9FJUEW39g8q1aEDhedvPcAElNSnxUGXS6axHO8LZ4US+Mo0uqGYo6c6i20f
         sOd3QnRoMgqnpzQioL/JC2DfK1QclL77mEElABe0NJIQVaur+nzQlz4V4Hb7+Z1qNJYE
         blWSwUJETA8s6aB0IrCRaq629bjh9GovpVViIRDsoTAhGYeBiMuSxZhyyArguDJa+6yz
         pMjy5nJO4X8+GwLPrAA/tAatq1S5YMAqDN1YxN26KeAOTjpaJ3J/2bGYC+yjW6nnpvUD
         D7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d9SZaW9TdUlnYANMiQGXK69jbz9VKFutNOocxVIUW6I=;
        b=Oo5a9FwpfoVg2wLXbhykR8o3DUDqIZeNMLVFI4LLgsLieV/W8Qd9bH0jy+Z0sF+4pj
         HF2wBcNEFpblxMX3PkDjsLsZKUe+vOUMpTJOdjNJWHiTgOeU+StjvK2IGvNpgsXNFYO1
         5o1w8GY7ylurzAbIfWjB/45NaOKh2pL9LG289tLJNH8d3xjys4eGJl9P3h29i6c2rF5/
         Dcmszqqlaujg/8gQeih5WnGqvnsy833cXy6J4oK4BXFM59LZppKyNeTryDDu8Oh6gWDf
         KVKV6QdLvCGqX5NwAOt4KXHheb7hIhcqRPQjjpxmKFInt5XIfbZ3dkGYWQt2QDqQCvXM
         ByCw==
X-Gm-Message-State: AJIora9VmUPokweQC0Wh90OuvdunrdIlZauH4BNMol1Qb8xtq95ght54
        vedRVRPl1gLy3fzBawJnEimelirwHIWhNg==
X-Google-Smtp-Source: AGRyM1v8/BKa+ZbmpdSYTx8XaUJmmyfhYp2ssnW5v8hXn0N968yU1tQvarMVdYM/n4m72pPnT0CDZg==
X-Received: by 2002:a17:903:2302:b0:16b:d9a3:29ab with SMTP id d2-20020a170903230200b0016bd9a329abmr4207456plh.138.1657294228054;
        Fri, 08 Jul 2022 08:30:28 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id r7-20020a170902ea4700b0016b8bec1ed9sm22992981plg.93.2022.07.08.08.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 08:30:26 -0700 (PDT)
Date:   Fri, 8 Jul 2022 15:30:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 036/102] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Message-ID: <YshNjy5RsxYuFxOo@google.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
 <20220708051847.prn254ukwvgkdl3c@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708051847.prn254ukwvgkdl3c@yy-desk-7060>
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

Please trim replies.

On Fri, Jul 08, 2022, Yuan Yao wrote:
> On Mon, Jun 27, 2022 at 02:53:28PM -0700, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 51306b80f47c..f239b6cb5d53 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -668,6 +668,44 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> >  	}
> >  }
> >
> > +static inline void kvm_init_shadow_page(void *page)
> > +{
> > +#ifdef CONFIG_X86_64
> > +	int ign;
> > +
> > +	WARN_ON_ONCE(shadow_nonpresent_value != SHADOW_NONPRESENT_VALUE);
> > +	asm volatile (
> > +		"rep stosq\n\t"

I have a slight preference for:

	asm volatile ("rep stosq\n\t"
		      <align here>
	);

so that searching for "asm" or "asm volatile" shows the "rep stosq" in the
result without needed to capture the next line.

> > +		: "=c"(ign), "=D"(page)
> > +		: "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
> > +		: "memory"
> > +	);
> > +#else
> > +	BUG();
> > +#endif

Rather than put the #ifdef here, split mmu_topup_shadow_page_cache() on 64-bit
versus 32-bit.  Then this BUG() goes away and we don't get slapped on the wrist
by Linus :-)

> > +}
> > +
> > +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
> > +	int start, end, i, r;
> > +	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
> > +
> > +	if (is_tdp_mmu && shadow_nonpresent_value)
> > +		start = kvm_mmu_memory_cache_nr_free_objects(mc);
> > +
> > +	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> > +	if (r)
> > +		return r;

Bailing immediately is wrong.  If kvm_mmu_topup_memory_cache() fails after allocating
at least one page, then KVM needs to initialize those pages, otherwise it will leave
uninitialized pages in the cache.  If userspace frees up memory in response to the
-ENOMEM and resumes the vCPU, KVM will consume uninitialized data.

> > +
> > +	if (is_tdp_mmu && shadow_nonpresent_value) {

So I'm pretty sure I effectively suggested keeping shadow_nonpresent_value, but
seeing it in code, I really don't like it.  It's an unnecessary check on every
SPT allocation, and it's misleading because it suggests shadow_nonpresent_value
might be zero when the TDP MMU is enabled.

My vote is to drop shadow_nonpresent_value and then rename kvm_init_shadow_page()
to make it clear that it's specific to the TDP MMU.

So this?  Completely untested.

#ifdef CONFIG_X86_64
static void kvm_init_tdp_mmu_shadow_page(void *page)
{
	int ign;

	asm volatile ("rep stosq\n\t"
		      : "=c"(ign), "=D"(page)
		      : "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
		      : "memory"
	);
}

static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
{
	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
	int start, end, i, r;

	if (is_tdp_mmu)
		start = kvm_mmu_memory_cache_nr_free_objects(mc);

	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);

	/*
	 * Note, topup may have allocated objects even if it failed to allocate
	 * the minimum number of objects required to make forward progress _at
	 * this time_.  Initialize newly allocated objects even on failure, as
	 * userspace can free memory and rerun the vCPU in response to -ENOMEM.
	 */
	if (is_tdp_mmu) {
		end = kvm_mmu_memory_cache_nr_free_objects(mc);
		for (i = start; i < end; i++)
			kvm_init_tdp_mmu_shadow_page(mc->objects[i]);
	}
	return r;
}
#else
static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
{
	return kvm_mmu_topup_memory_cache(vcpu->arch.mmu_shadow_page_cache,
					  PT64_ROOT_MAX_LEVEL);
}
#endif /* CONFIG_X86_64 */

> > +		end = kvm_mmu_memory_cache_nr_free_objects(mc);
> > +		for (i = start; i < end; i++)
> > +			kvm_init_shadow_page(mc->objects[i]);
> > +	}
> > +	return 0;
> > +}
> > +

...

> > @@ -5654,7 +5698,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> >  	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> >
> > -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > +	if (!(is_tdp_mmu_enabled(vcpu->kvm) && shadow_nonpresent_value))
> > +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> 
> I'm not sure why skip this for TDX, arch.mmu_shadow_page_cache is
> still used for allocating sp->spt which used to track the S-EPT in kvm
> for tdx guest.  Anything I missed for this ?

Shared EPTEs need to be initialized with SUPPRESS_VE=1, otherwise not-present
EPT violations would be reflected into the guest by hardware as #VE exceptions.
This is handled by initializing page allocations via kvm_init_shadow_page() during
cache topup if shadow_nonpresent_value is non-zero.  In that case, telling the
page allocation to zero-initialize the page would be wasted effort.

The initialization is harmless for S-EPT entries because KVM's copy of the S-EPT
isn't consumed by hardware, and because under the hood S-EPT entries should never
#VE (I forget if this is enforced by hardware or if the TDX module sets SUPPRESS_VE).

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303D56A4D95
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjB0Vxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjB0Vxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:53:51 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B84011E96;
        Mon, 27 Feb 2023 13:53:50 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so7621304pjp.2;
        Mon, 27 Feb 2023 13:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vKI1glCOiAiWZLlxPHsOgUwicyb9tqcTxpAktuzQ/5U=;
        b=Z0c6Cj0uBKXA8bwtIxf3mvhqTveoJ+7LN3LnteG97UwhkVgu2hCVvHdPeN0ubq0Kse
         BQw0B6/5z9ct5i/gNjXKslBdwxIKtWLGRGdl29d51Jp7wV4c4ria7gOhCUII6PF9gART
         MKvMWHmElAD/Cwy4Nj92XcyjTcIL6xP4pz8vfArLO0ZaUPU0zf4h6uh1CjiaqMIqnxWA
         nN7wPL0H4XkdcsyJx7clY9b2mZrWW/exOfVwsivnzgp2b8lTuv4LOBTwV3fPQXQS1oNl
         LonhSsjBKBkeNiwM2GtqYcWEhUVQ9ShmusJx2WRvl0+pHU+zJKu0SGVy/AdRiucd5BJO
         2y9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKI1glCOiAiWZLlxPHsOgUwicyb9tqcTxpAktuzQ/5U=;
        b=oZ/8QG9Vdklby291xIVvc5Fo52S1ym0CfdHDBjv9e9531CMGJmLRAihoV61wWxBjoE
         /yEz72ZsFrZbOHOtYuGIIS73JqjBMKOaMophiB8SYk+TKPPJKRnlyJtzqHcuFQ/SIaEq
         BFRlEbYjrnBIwmA/756U2j+1/hGukOwY1qnB1psA+YbNye4624Az3Jb7+h5Rilzp83Ef
         q9Vh8PCOjNJOPKDIyAtsyXbL8gPgjsFbG8vO5vbj2NQ/0Zzo/0AfPOacydOza2A/tekY
         lZjfJEQpJ79ZbiWMsNVk8M63JjYg/Cv4VELnbT9EyJnGO/TzWET8sWlZau/jGxHXi08c
         0glQ==
X-Gm-Message-State: AO0yUKU+09gNA/pHEmfZMeg4MLi+L8Xca3p+h/3czm//ewsGrajaCuVG
        DdSjxn+w2aLIODas1RleCAo=
X-Google-Smtp-Source: AK7set8YxklGyvmNZhX304F2JF7PnZkMGREooI/n20GZN4uTKgoBfdrX35efXcyQlnSRFWdwHn2Ndg==
X-Received: by 2002:a17:902:e745:b0:19c:eaab:653d with SMTP id p5-20020a170902e74500b0019ceaab653dmr10124284plf.15.1677534829950;
        Mon, 27 Feb 2023 13:53:49 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902e8c300b00194c90ca320sm5048615plg.204.2023.02.27.13.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:53:49 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:53:48 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 031/113] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE and removed SPTE
Message-ID: <20230227215348.GM4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <d193421197cb7699d5eee09b72e6ba92e9978a7b.1673539699.git.isaku.yamahata@intel.com>
 <f7fa8e9f35a451a045fd8e07c00ec2d5bb0dbfcb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f7fa8e9f35a451a045fd8e07c00ec2d5bb0dbfcb.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 10:54:35AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > For TD guest, the current way to emulate MMIO doesn't work any more, as KVM
> > is not able to access the private memory of TD guest and do the emulation.
> > Instead, TD guest expects to receive #VE when it accesses the MMIO and then
> > it can explicitly make hypercall to KVM to get the expected information.
> > 
> > To achieve this, the TDX module always enables "EPT-violation #VE" in the
> > VMCS control.  And accordingly, for the MMIO spte for the shared GPA,
> > 1. KVM needs to set "suppress #VE" bit for the non-present SPTE so that EPT
> > violation happens on TD accessing MMIO range.  2. On EPT violation, KVM
> > sets the MMIO spte to clear "suppress #VE" bit so the TD guest can receive
> > the #VE instead of EPT misconfigration unlike VMX case.  For the shared GPA
> > that is not populated yet, EPT violation need to be triggered when TD guest
> > accesses such shared GPA.  The non-present SPTE value for shared GPA should
> > set "suppress #VE" bit.
> > 
> > Add "suppress #VE" bit (bit 63) to SHADOW_NONPRESENT_VALUE and
> > REMOVED_SPTE.  Unconditionally set the "suppress #VE" bit (which is bit 63)
> > for both AMD and Intel as: 1) AMD hardware doesn't use this bit when
> > present bit is off; 2) for normal VMX guest, KVM never enables the
> > "EPT-violation #VE" in VMCS control and "suppress #VE" bit is ignored by
> > hardware.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/vmx.h |  1 +
> >  arch/x86/kvm/mmu/spte.h    | 15 ++++++++++++++-
> >  arch/x86/kvm/mmu/tdp_mmu.c |  8 ++++++++
> >  3 files changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > index 498dc600bd5c..cdbf12c1a83c 100644
> > --- a/arch/x86/include/asm/vmx.h
> > +++ b/arch/x86/include/asm/vmx.h
> > @@ -511,6 +511,7 @@ enum vmcs_field {
> >  #define VMX_EPT_IPAT_BIT    			(1ull << 6)
> >  #define VMX_EPT_ACCESS_BIT			(1ull << 8)
> >  #define VMX_EPT_DIRTY_BIT			(1ull << 9)
> > +#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
> 
> I don't know whether you should introduce this macro, since it's not used in
> this patch.
> 
> >  #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
> >  						 VMX_EPT_WRITABLE_MASK |       \
> >  						 VMX_EPT_EXECUTABLE_MASK)
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index f190eaf6b2b5..471378ee9071 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -148,7 +148,20 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
> >  
> >  #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
> >  
> > +/*
> > + * Non-present SPTE value for both VMX and SVM for TDP MMU.
> > + * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
> > + * For VMX EPT, bit 63 is ignored if #VE is disabled. (EPT_VIOLATION_VE=0)
> > + *              bit 63 is #VE suppress if #VE is enabled. (EPT_VIOLATION_VE=1)
> > + * For TDX:
> > + *   TDX module sets EPT_VIOLATION_VE for Secure-EPT and conventional EPT
> > + */
> > +#ifdef CONFIG_X86_64
> > +#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
> > +static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
> > +#else
> >  #define SHADOW_NONPRESENT_VALUE	0ULL
> > +#endif
> >  
> >  extern u64 __read_mostly shadow_host_writable_mask;
> >  extern u64 __read_mostly shadow_mmu_writable_mask;
> > @@ -195,7 +208,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
> >   *
> >   * Only used by the TDP MMU.
> >   */
> > -#define REMOVED_SPTE	0x5a0ULL
> > +#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> 
> This chunk belongs to the previous patch.

Yes, move this hunk to the previous patch with VMX_EPT_SUPPRESS_VE_BIT.

> >  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
> >  static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 9cf5844dd34a..6111e3e9266d 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -700,6 +700,14 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
> >  	 * overwrite the special removed SPTE value. No bookkeeping is needed
> >  	 * here since the SPTE is going from non-present to non-present.  Use
> >  	 * the raw write helper to avoid an unnecessary check on volatile bits.
> > +	 *
> > +	 * Set non-present value to SHADOW_NONPRESENT_VALUE, rather than 0.
> > +	 * It is because when TDX is enabled, TDX module always
> > +	 * enables "EPT-violation #VE", so KVM needs to set
> > +	 * "suppress #VE" bit in EPT table entries, in order to get
> > +	 * real EPT violation, rather than TDVMCALL.  KVM sets
> > +	 * SHADOW_NONPRESENT_VALUE (which sets "suppress #VE" bit) so it
> > +	 * can be set when EPT table entries are zapped.
> >  	 */
> >  	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
> >  
> 
> I don't quite think this place is the good place to explain "suppress  #VE" bit
> staff.  There are other places that sets non-present SPTE too.  Perhaps putting
> the comment around the macro 'SHADOW_NONPRESENT_VALUE' is better.

Dropped this comment from this patch.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB73D7398E6
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 10:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjFVIBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 04:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjFVIBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 04:01:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05704199F;
        Thu, 22 Jun 2023 01:01:40 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-66767d628e2so2868363b3a.2;
        Thu, 22 Jun 2023 01:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687420899; x=1690012899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cloVSkdWRaIfbBOxPQ/5NL8Y9shMc59TTz/Gk1UTt40=;
        b=O9pJ+eQznYp2MIzSRo3S9XntWTm6Kof6D55uWH6oTEn3Add317V+FtXHscZI0obzjH
         a/+eu8GrEPFlq1GE1laxLMcgvzymjmcNxBX8S2FvGJlVVUsY6d8PUg+hN5Mz2Y8UFYwK
         lZL4I4yhtfVvP3vqrqwugvs9JhQk6zZi5wjxP+u/1PVwbKi62J4ghmJO4zArySk3rTsk
         lwjQZ58RMTmnKeeuJzCbV32kJatoFGLK9jTYADFGxk0wKwoRnfq2EU9xyoLxGvqntchU
         OnyYaz6SMB26PdNQgVZCyT97UA90mdSvzMPDbYCTNGI7oRgtn40HhGEL+fKNe8Hc15s9
         R8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687420899; x=1690012899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cloVSkdWRaIfbBOxPQ/5NL8Y9shMc59TTz/Gk1UTt40=;
        b=T2MyVfkFV06/vFrTU8wAX8HwyQVmU46LYjG1lyNdnZrzVcqsY4cCOENxOYYLhZ70tj
         2gj4Zce6C6oaT/EyYPWuTrngGDyM2eBmYRkX9PzQdleCwnY/lVWTNvVql2pTGHBDU9jM
         ePqV6EXq16EWm2pB7CrC/C5nzMQ28y9Ezr4NzWBpvgX5rBp00BoysxBbG5aJ+BHGSpBl
         ZzXDnil4Pvh78XmrDCyIAt8nNjsq5jsDGLo9tjenOW/Y27d74tzIhEdw9eLo5MU1HFdu
         j/B/73McO9LpjIjILypzJmReb+oHbB+6GSDsyfL+4Lhi1a44+8lf7in8asc8ytd8kvH4
         KR+Q==
X-Gm-Message-State: AC+VfDweA7e74TRAOJrx7725lye0CPmj/9lahtLG986ircwBtTjZ96ZN
        i8MfauHY5E25lsPG+EsuUlc=
X-Google-Smtp-Source: ACHHUZ5EvV0wlwbl0iaemga+IWaQucsxLfY6cbQrae9VK32+zUNMZdtdADk21i1ma7B5boAReNWXtQ==
X-Received: by 2002:a05:6a20:1610:b0:116:5321:63bf with SMTP id l16-20020a056a20161000b00116532163bfmr13456726pzj.41.1687420899092;
        Thu, 22 Jun 2023 01:01:39 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902d3c500b001ae5d21f760sm4752009plb.146.2023.06.22.01.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 01:01:38 -0700 (PDT)
Date:   Thu, 22 Jun 2023 01:01:37 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Message-ID: <20230622080137.GB1808127@ls.amr.corp.intel.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-5-michael.roth@amd.com>
 <20230614164709.GT2244082@ls.amr.corp.intel.com>
 <20230620202841.7qizls3u3kcck45g@amd.com>
 <20230620211845.GV2244082@ls.amr.corp.intel.com>
 <20230621230031.37hdnymbjzwjgbo2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230621230031.37hdnymbjzwjgbo2@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 06:00:31PM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> On Tue, Jun 20, 2023 at 02:18:45PM -0700, Isaku Yamahata wrote:
> > On Tue, Jun 20, 2023 at 03:28:41PM -0500,
> > Michael Roth <michael.roth@amd.com> wrote:
> > 
> > > On Wed, Jun 14, 2023 at 09:47:09AM -0700, Isaku Yamahata wrote:
> > > > On Sun, Jun 11, 2023 at 11:25:12PM -0500,
> > > > Michael Roth <michael.roth@amd.com> wrote:
> > > > 
> > > > > This will be used to determine whether or not an #NPF should be serviced
> > > > > using a normal page vs. a guarded/gmem one.
> > > > > 
> > > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > > ---
> > > > >  arch/x86/include/asm/kvm_host.h |  7 +++++++
> > > > >  arch/x86/kvm/mmu/mmu_internal.h | 35 ++++++++++++++++++++++++++++++++-
> > > > >  2 files changed, 41 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > > index b3bd24f2a390..c26f76641121 100644
> > > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > > @@ -1445,6 +1445,13 @@ struct kvm_arch {
> > > > >  	 */
> > > > >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> > > > >  	struct kvm_mmu_memory_cache split_desc_cache;
> > > > > +
> > > > > +	/*
> > > > > +	 * When set, used to determine whether a fault should be treated as
> > > > > +	 * private in the context of protected VMs which use a separate gmem
> > > > > +	 * pool to back private guest pages.
> > > > > +	 */
> > > > > +	u64 mmu_private_fault_mask;
> > > > >  };
> > > > >  
> > > > >  struct kvm_vm_stat {
> > > > > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > > > > index 780b91e1da9f..9b9e75aa43f4 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > > > > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > > > > @@ -252,6 +252,39 @@ struct kvm_page_fault {
> > > > >  
> > > > >  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> > > > >  
> > > > > +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
> > > > > +{
> > > > > +	struct kvm_memory_slot *slot;
> > > > > +	bool private_fault = false;
> > > > > +	gfn_t gfn = gpa_to_gfn(gpa);
> > > > > +
> > > > > +	slot = gfn_to_memslot(kvm, gfn);
> > > > > +	if (!slot) {
> > > > > +		pr_debug("%s: no slot, GFN: 0x%llx\n", __func__, gfn);
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	if (!kvm_slot_can_be_private(slot)) {
> > > > > +		pr_debug("%s: slot is not private, GFN: 0x%llx\n", __func__, gfn);
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	if (kvm->arch.mmu_private_fault_mask) {
> > > > > +		private_fault = !!(err & kvm->arch.mmu_private_fault_mask);
> > > > > +		goto out;
> > > > > +	}
> > > > 
> > > > What's the convention of err? Can we abstract it by introducing a new bit
> > > > PFERR_PRIVATE_MASK? The caller sets it based on arch specific value.
> > > > the logic will be
> > > >         .is_private = err & PFERR_PRIVATE_MASK;
> > > 
> > > I'm not sure I understand the question. 'err' is just the page fault flags,
> > > and arch.mmu_private_fault_mask is something that can be set on a
> > > per-platform basis when running in a mode where shared/private access
> > > is recorded in the page fault flags during a #NPF.
> > > 
> > > I'm not sure how we'd keep the handling cross-platform by moving to a macro,
> > > since TDX uses a different bit, and we'd want to be able to build a
> > > SNP+TDX kernel that could run on either type of hardware.
> > > 
> > > Are you suggesting to reverse that and have err be set in a platform-specific
> > > way and then use a common PFERR_PRIVATE_MASK that's software-defined and
> > > consistent across platforms? That could work, but existing handling seems
> > > to use page fault flags as-is, keeping the hardware-set values, rather than
> > > modifying them to pass additional metadata, so it seems like it might
> > > make things more confusing to make an exception to that here. Or are
> > > there other cases where it's done that way?
> > 
> > I meant the latter, making PFERR_PRIVATE_MASK common software-defined.
> > 
> > I think the SVM fault handler can use hardware value directly by carefully
> > defining those PFERR values.
> > 
> > TDX doesn't have architectural bit in error code to indicate the private fault.
> > It's coded in faulted address as shared bit. GPA bit 51 or 47.
> > PFERR_{USER, WRITE, FETCH, PRESENT} are already software-defined value for VMX
> > (and TDX).  The fault handler for VMX, handle_ept_violation(), converts
> > encoding.  For TDX, PFERR_PRIVATE_MASK is just one more software defined bit.
> > 
> > I'm fine with either way, variable or macro. Which do you prefer?
> > 
> > - Define variable mmu_private_fault_mask (global or per struct kvm)
> >   The module initialization code, hardware_setup(), sets mmu_private_fault_mask.
> > - Define the software defined value, PFERR_PRIVATE_MASK.
> >   The caller of kvm_mmu_page_fault() parses the hardware value and construct
> >   software defined error_code.
> > - any other?
> >   
> > 
> > > > > +
> > > > > +	/*
> > > > > +	 * Handling below is for UPM self-tests and guests that treat userspace
> > > > > +	 * as the authority on whether a fault should be private or not.
> > > > > +	 */
> > > > > +	private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> > > > 
> > > > This code path is sad. One extra slot lookup and xarray look up.
> > > > Without mmu lock, the result can change by other vcpu.
> > > > Let's find a better way.
> > > 
> > > The intention was to rely on fault->mmu_seq to determine if a
> > > KVM_SET_MEMORY_ATTRIBUTES update came in after .private_fault was set so
> > > that fault handling could be retried, but that doesn't happen until
> > > kvm_faultin_pfn() which is *after* this is logged. So yes, I think there
> > > is a race here, and the approach you took in your Misc. series of
> > > keeping the kvm_mem_is_private() check inside kvm_faultin_pfn() is more
> > > efficient/correct.
> > > 
> > > If we can figure out a way to handle checking the fault flags in a way
> > > that works for both TDX/SNP (and KVM self-test use-case) we can
> > > consolidate around that.
> > 
> > I can think of the following ways. I think the second option is better because
> > we don't need exit bit for error code.
> > 
> > - Introduce software defined error code
> > - Add a flags to struct kvm_arch for self-test use-case VM_TYPE_PROTECTED_VM.
> >   Set it to true for VM_TYPE_PROTECTED_VM case.
> > - any other?
> 
> Vishal: hoping to get your thoughts here as well from the perspective of
> the KVM self-test use-case.
> 
> I was thinking that once we set fault->is_private, that sort of
> becomes our "software-defined" bit, and what KVM would use from that
> point forward to determine whether or not the access should be treated
> as a private one or not, and that whatever handler sets
> fault->is_private would encapsulate away all the platform-specific
> bit-checking needed to do that.
> 
> So if we were to straight-forwardly implement that based on how TDX
> currently handles checking for the shared bit in GPA, paired with how
> SEV-SNP handles checking for private bit in fault flags, it would look
> something like:
> 
>   bool kvm_fault_is_private(kvm, gpa, err)
>   {
>     /* SEV-SNP handling */
>     if (kvm->arch.mmu_private_fault_mask)
>       return !!(err & arch.mmu_private_fault_mask);
> 
>     /* TDX handling */
>     if (kvm->arch.gfn_shared_mask)
>       return !!(gpa & arch.gfn_shared_mask);
> 
>     return false;
>   }
> 
>   kvm_mmu_do_page_fault(vcpu, gpa, err, ...)
>   {
>     struct kvm_page_fault fault = {
>       ...
>       .is_private = kvm_fault_is_private(vcpu->kvm, gpa, err)
>     };
> 
>     ...
>   }
> 
> And then arch.mmu_private_fault_mask and arch.gfn_shared_mask would be
> set per-KVM-instance, just like they are now with current SNP and TDX
> patchsets, since stuff like KVM self-test wouldn't be setting those
> masks, so it makes sense to do it per-instance in that regard.
> 
> But that still gets a little awkward for the KVM self-test use-case where
> .is_private should sort of be ignored in favor of whatever the xarray
> reports via kvm_mem_is_private(). In your Misc. series I believe you
> handled this by introducing a PFERR_HASATTR_MASK bit so we can determine
> whether existing value of fault->is_private should be
> ignored/overwritten or not.
> 
> So maybe kvm_fault_is_private() needs to return an integer value
> instead, like:
> 
>   enum {
>     KVM_FAULT_VMM_DEFINED,
>     KVM_FAULT_SHARED,
>     KVM_FAULT_PRIVATE,
>   }
> 
>   bool kvm_fault_is_private(kvm, gpa, err)
>   {
>     /* SEV-SNP handling */
>     if (kvm->arch.mmu_private_fault_mask)
>       (err & arch.mmu_private_fault_mask) ? KVM_FAULT_PRIVATE : KVM_FAULT_SHARED
> 
>     /* TDX handling */
>     if (kvm->arch.gfn_shared_mask)
>       (gpa & arch.gfn_shared_mask) ? KVM_FAULT_SHARED : KVM_FAULT_PRIVATE
> 
>     return KVM_FAULT_VMM_DEFINED;
>   }
> 
> And then down in __kvm_faultin_pfn() we do:
> 
>   if (fault->is_private == KVM_FAULT_VMM_DEFINED)
>     fault->is_private = kvm_mem_is_private(vcpu->kvm, fault->gfn);
>   else if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
>     return kvm_do_memory_fault_exit(vcpu, fault);
> 
>   if (fault->is_private)
>     return kvm_faultin_pfn_private(vcpu, fault);
> 
> Maybe kvm_fault_is_private() can be simplified based on what direction
> we end up taking WRT ongoing discussions like whether we decide to define
> KVM_X86_{SNP,TDX}_VM vm_types in addition to the KVM_X86_PROTECTED_VM
> type that the selftests uses, but hoping that for this path, any changes
> along that line can be encapsulated away in kvm_fault_is_private() without
> any/much further churn at the various call-sites like __kvm_faultin_pfn().
> 
> We could even push all the above logic down into the KVM self-tests, but
> have:
> 
>   bool kvm_fault_is_private(kvm, gpa, err) {
>     return KVM_FAULT_VMM_DEFINED;
>   }
> 
> And that would be enough to run self-tests as standalone series, with
> TDX/SNP should filling in kvm_fault_is_private() with their
> platform-specific handling.
> 
> Does that seem reasonable to you? At least as a starting point. 

I tried to move the logic to the caller site and hide it from KVM MMU code.
You'd like to move the logic down into KVM MMU side and make the difference
explicit.  Either way works for me.  Let me respin my patches for the direction
you propose.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

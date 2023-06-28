Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA4C7416CD
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 18:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjF1Qxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 12:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjF1Qxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 12:53:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E29B268A
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 09:53:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bfec07e5eb0so6547538276.2
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 09:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687971209; x=1690563209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1R0X/i0lRCH4miOSwDDYOODB6W8gkeuLWHpbyZwxp5Y=;
        b=ghMHaBgSCNiJR8sLHsMY2tLgMF5ts+0OjeJhvhiPngm56U/UbMPyBf5MGIrGSiYwjv
         B03mGv7zHqbKvshpv6IUAS1Vb3zAr4e2MBK3O4BqxDGajsP9Z9sGoDsxBuCNV+qOWEl/
         6K1s05fsig3YTpjCqWUU3MYfhGOY4iel1hn/NJYXfQAyUuPeRrwkFY/AwXDv9R4BG1Il
         qMgXSJSuyUczGK17tfen3bXoZlNWJLn2d+MyLRfNYyS4LsF+NEcu2RoM4rLdJvq9/qNF
         omKtqPYf8NBelEixBTIM0S/CZMjEDshKEhzyWWahTclCdnPJO3V8OdJk/0XeBr8Wi92M
         CK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687971209; x=1690563209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1R0X/i0lRCH4miOSwDDYOODB6W8gkeuLWHpbyZwxp5Y=;
        b=aYEOMRMbuzIeSnG/uDiAUf7dQHmHMUxtcts+qRujJqiHpJtB06KAcYLsx5GaIUzXcz
         kkLt3ixd3jP1//B4ThyZCeD72UB6ywL2bANaJ2hFZaMSSHWcz7FXVkxwpxrKqEhPl536
         6YePhIwf9wfq1gOIRh3sv3Z/V6EG7gYXdHKAtXyi3NcJb4HtBHZTqpLPq7Cr4jJDinVS
         KsYjeuxtB88NxglfoZD+Z4Yf+yr/5IfDJ0nxUiZFzdLOxi1O/40UFSbjfTK1qs3L6sUn
         AmQHM09S/5LiLfxOGsAnh3ogkkfKSt3zp+HPw5qeWfZdh+J+1xk4d6VWJZ4gDY5ddfjm
         aIvA==
X-Gm-Message-State: AC+VfDy4jui05bbTNpEEgvCY4tjVk7DBZrMPr7DUyfCJWZNHutB8L0OA
        yQGvwZenU+jrHaQ/YLFs7LdZfPzs6pU=
X-Google-Smtp-Source: ACHHUZ7fpXjxSyzrjBsRYNYDfUikJP6XXwFS6cHwPIadCTAWuhTjoyYKwCou0aajG7Ys7M7rEHOF143IJS4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:b42:0:b0:bfe:738e:363f with SMTP id
 b2-20020a5b0b42000000b00bfe738e363fmr10416316ybr.1.1687971209560; Wed, 28 Jun
 2023 09:53:29 -0700 (PDT)
Date:   Wed, 28 Jun 2023 09:53:27 -0700
In-Reply-To: <20230627235845.qixtneay2tiv6xuu@amd.com>
Mime-Version: 1.0
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <a3a19de92c7ac6e607ac3e663d84a4312876084b.1687474039.git.isaku.yamahata@intel.com>
 <ZJX6s2HxbHOUMXlj@google.com> <20230626010753.xru5ph3irmyokrgc@amd.com>
 <ZJnXObRHhn5Q1dX2@google.com> <20230627235845.qixtneay2tiv6xuu@amd.com>
Message-ID: <ZJxlh5mql/Y0syHV@google.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: x86: Introduce fault type to indicate kvm
 page fault is private
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023, Michael Roth wrote:
> On Mon, Jun 26, 2023 at 11:21:45AM -0700, Sean Christopherson wrote:
> > "is_private" would serve the same purpose as all the other bits that are derived
> > from the error code, e.g. improve readability, reduce line lengths, etc.  Though
> > looking at the name, just "private" is probably the right name.
> > 
> > 	/* Derived from error_code.  */
> > 	const bool exec;
> > 	const bool write;
> > 	const bool present;
> > 	const bool rsvd;
> > 	const bool user;
> 
> If we go out of our way to pull bits out of error_code so they can be
> accessed more consistently/sensibly, why introduce additional bits into
> error_code in the first place? It just seems like an unecessary
> intermediate step, and introduces error_code bits that TDX/selftests
> don't actually ever need, which raises the specter of "what if hardware
> starts using this synthetic bit for something else?"

It's not a KVM-defined bit though, it's an AMD-defined bit.  That's a very big
difference as AMD and Intel both go to out of their way to not step on each other's
toes.

And *architecturally*, VMX doesn't support #PF error codes larger than 16 bits,
not to mention that all of this needs to be dependent on TDP.  And for EPT
violations, the error code is *fully* synthetic anyways because the error code
passed into kvm_mmu_page_fault is a translation of vmcs.EXIT_QUALIFICATION into
the "legacy" error code format.

So there's really no danger here, whereas a truly synthetic, KVM-defined bit like
PFERR_IMPLICIT_ACCESS *does* carry some risk because AMD in particular might use
bit 48 for a new hardware-defined flags.

> Is it mainly to avoid introducing additional parameters to
> kvm_mmu_page_fault() and instead piggy-backing off of error_code param?
> Or does recording the values into error_code have a use outside of that?

It provides canonical behavior within common KVM code.  Stashing individual flags
in const bools in kvm_page_fault is purely for ease-of-use, they are NOT the canonical
representation of state for the entirety of page fault handling.  E.g. in the unlikely
scenario that kvm_mmu_page_fault() needs to care about shared vs. private, there's
no kvm_page_fault structure to query.

> > > So it makes sense, in the gmem case (and TDX/SNP), to defer the
> > > kvm_mem_is_private() till later in kvm_faultin_pfn(). It avoid a
> > > duplicate lookup, and a race. But .is_private only conveys
> > > encrypted/unencrypted fault in TDX/SNP case, it doesn't have a way to
> > > cleanly convey this case "just use whatever kvm_mem_is_private() reports
> > > later, because it will always be what the VMM set, and it's too early
> > > to check kvm_mem_is_private() right now".
> > 
> > Yeah, the duplicate lookup is unfortunate :-/  But I'd really like to be able to
> > make kvm_page_fault.private const, just like all the other booleans that are
> > derived from the error code.  My concern with making it *not* const is that
> > there will be a discrepancy between "private" and "error_code", and we'll have
> > to be very careful to never touch "private" before kvm_faultin_pfn().
> 
> It can actually be const using the KVM_FAULT_{VMM_DEFINED,SHARED,PRIVATE} 
> abstraction. fault->is_private doesn't really need to be overwritten for
> VMM_DEFINED case later, it can just be treated as "use whatever
> kvm_mem_is_private() reports". But I guess that's what you mean by
> "special casing" below.

That's not constifying the state (private vs. shared), that's constifying behavior.
VMM_DEFINED is like Schrodinger's cat; the fault is neither private nor shared
until KVM actually looks at it.

> > And I don't want to special case "VMM defined", because the primary reason the
> > "VMM defined" case exists at this time is to allow testing KVM's implementation
> > without TDX or SNP.  E.g. I don't want to end up with code in fast_page_fault()
> 
> Are you suggesting VMM_DEFINED would eventually go away once SNP/TDX
> have bigger uptake,

I'm saying I don't want VMM_DEFINED, period.  :-)

> or maybe in favor of tests built around some new VM type (e.g.
> software-protected VMs) that use guest hypercalls to set guest-expected
> memory state rather than always relying on what the VMM sets up?
> 
> I guess in that case VMM_DEFINED handling could just be dropped at
> that point, and KVM_FAULT_{SHARED,PRIVATE} would still be relevant (or they
> could get switched back to bool at that point), and software-protected VMs
> would set that value based on whatever state tracks the hypercalls.
> 
> But if that's the end-game maybe it's a good reason for keeping
> fault->is_private bool and avoiding enums. But still don't really see the
> worth in also setting the bit in error_code.
> 
> > without TDX or SNP.  E.g. I don't want to end up with code in fast_page_fault()
> > or so that does X for KVM_FAULT_VMM_DEFINED, but Y for KVM_FAULT_PRIVATE.
> 
> Hadn't really considered fast_page_fault() for SNP... it seems like
> for explicit page-state changes, the vCPU issuing the conversions
> would just block until the GHCB request it issued was completed. So by
> the time it accesses the GPA, KVM_SET_MEMORY_ATTRIBUTES would have
> already zapped the old entry, so the fast path would get bypassed at
> that point.
> 
> For implicit page-state changes, I guess there's a risk you can
> get stuck looping on fast_page_fault() since it's up to KVM MMU
> to generate the KVM_EXIT_MEMORY_FAULT so KVM_SET_MEMORY_ATTRIBUTES
> gets called eventually. Sort of surprised I haven't encountered
> that case though... but anyway...
> 
> If you rely on similar checks to what slow path does:
> 
>  	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
>  		return kvm_do_memory_fault_exit(vcpu, fault);
> 
> kvm_mem_is_private() could be stale due to unnoticed invalidation,
> but eventually it would reach steady-state and the
> KVM_EXIT_MEMORY_FAULT would fire. Is that sort of what you have in
> mind there?
> 
> For SNP it seems more efficient to check for RMP bit and then head
> straight to the slow-path, but this isn't a hot path so probably
> doesn't matter much.

I'm not concerned about any specific path, i.e. don't read too much into my
arbitrary fast_page_fault() example.

What I am trying to point out is that I don't want to end up in a world where
a page fault is known to be private or shared for TDX/SNP, but not for SW-protected
VMs.  Because if that happens, then we'll end up in one of three situations:

  1. KVM can't act on private versus shared until after __kvm_faultin_pfn()
  2. KVM is buggy because it is consuming undefined state, i.e. querying if memory
     is private versus shared before looking inside the box
  3. KVM has different flows for TDX/SNP versus SW-protected VMs

> > So I'm leaning toward the above be
> > 
> > 	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> > 		if (vcpu->kvm->vm_type == KVM_X86_PROTECTED_VM)
> > 			return RET_PF_RETRY;
> > 		else
> > 			return kvm_do_memory_fault_exit(vcpu, fault);
> > 	}
> > 
> > even though software-protected VMs would perform a technically-unnecessary
> > attributes lookup.  *If* software-protected VMs ever get to the point where folks
> > care about the performance overhead of the extra lookup, then I'm all for
> > revisiting the implementation, but that is a ginormous "if" at this point.  Though
> > even then I'd still prefer to figure out a way to make the flag const, but that's
> > a future problem.
> > 
> > > So that's where this enum type came from. Although in the discussion I
> > > linked to above I suggested just:
> > > 
> > >   enum kvm_fault_type {
> > >     KVM_FAULT_VMM_DEFINED,
> > >     KVM_FAULT_SHARED,
> > >     KVM_FAULT_PRIVATE,
> > > 
> > > Which I think would work just as well,
> > 
> > I want to use vm_type for tracking "VMM_DEFINED".  KVM's ABI easily allows for 64
> > VM types, I see no reason to reuse KVM_X86_PROTECTED_VM for TDX and/or SNP, though
> > the type probably should be KVM_X86_SW_PROTECTED_VM.  With that out of the way,
> > there's no need for an enum to track shared vs. private.
> > 
> 
> Introducing TDX/SNP vm types seems to buy us some flexibility so it
> sounds useful.
> 
> Rather than synthesizing bits in error_code, maybe we could also use it
> to help out there as well? (assuming parameter-passing was the main
> use-case there)
> 
>   static bool kvm_fault_is_private(kvm, gpa, error_code)
>   {
>     if (kvm->vm_type == KVM_X86_TDX_VM)
>       return gpa & TDX_SHARED_GPA_MASK;
> 
>     if (kvm->vm_type == KVM_X86_SNP_VM)
>       return error_code & PFERR_GUEST_ENC_MASK;
> 
>     return kvm_mem_is_private(kvm, gpa);
>   }

That's also an option, but (a) it's a bit kludgy as it requries three pieces of data,
(b) it's suboptimal for KVM_X86_SW_PROTECTED_VM if there are multiple lookups, and
(c) it will result in inconsistent behavior if there are multiple lookups.

E.g. these two things wouldn't be functionally equivalent, which is just asking
for bugs.

	if (!kvm_fault_is_private(...)
		A();

	B();

	if (kvm_fault_is_private(...)
		C();

versus

	bool private = kvm_fault_is_private();

	if (!private)
		A();

	B();

	if (private)
		C();
	

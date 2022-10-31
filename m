Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DD1612F29
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 03:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJaC7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 22:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJaC7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 22:59:40 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A58764A
        for <kvm@vger.kernel.org>; Sun, 30 Oct 2022 19:59:38 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id A3FC532000D7;
        Sun, 30 Oct 2022 22:59:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 30 Oct 2022 22:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1667185174; x=1667271574; bh=iX
        HP+s9VF9+fFLjw1JK+GN8LdbcFfgOK0uK9DoiuD/A=; b=rrbClnH2pUAeFv4jiU
        LL96QXjZsqd2AGLtyggpmEjKv4eGcGjffDqMYdYuNKqCMEupOIvQK+yjNj1LfNP2
        4fmyBw+POPP/FFIRZgaSDPRFXs37rsq3VnEJC4fWXepRfLZpYtAwp1K8rFTn4XQk
        yxA91M87qOLZKhxBZ7uK34/+YsdZfdxUFM7yJnZj26C1+yipGNOrU1mvkrkTINjz
        NrpnyNkr+r9fEOX94xbFU5Htzs1gATDBhfoU67RDEEkmEoMVg2UlW2Gnfkd9HlXN
        //AVEhZuvDurJZEd8UCJJG1AjmMn/jsbaEMHSSVCGy4wDaqHelnk4vZdTlqdfnHp
        yBmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667185174; x=1667271574; bh=iXHP+s9VF9+fFLjw1JK+GN8LdbcF
        fgOK0uK9DoiuD/A=; b=U/K96ighvltiICXTwhDUw3T0inoqAvf8md+Fhk1t8vL2
        5lqaowzssfQo+bUb3OQORVq2zX/GkeB2r8TzuA+lqUM1Z8sL1EIe7B8d1JaYZNW6
        712OIYBbwI23CAT7fGEIvCOuPGPYvRBRM6Ltu0y0HUDTndYjfh+MDsncAp59MLo9
        ABh6nWgS+BExd0VTrB7qpJ97jOTssoRKTpxbZ3LY1qrJEHzeoU4/2W7y3ipaQD/U
        pWrOPgPQX6INwnrsFEKq3MoBjwBwsPhUwck/qcrJ6LMXTkcgCWCqb09ItWAVK4tj
        kPj/mW8FgxQ2tfBiOjnmxNT5Ut04xGzI1JsV8QsFMA==
X-ME-Sender: <xms:FTpfY_XmS-fwjNo11M1N0NNN322u_PzxPgqqc0AlF1u9qyMgSVtLgw>
    <xme:FTpfY3mQo1RTKk2CUZl-TeSOFcKRNR_J3gXPgkiQUNAGAG3thwDDtzonfjHrYNBAz
    8tnYPCzzWxLTgfULvA>
X-ME-Received: <xmr:FTpfY7aRXRIV9VsVILyd5ewwEelg84oWiMylM8tGRaxj_uTKHzbLU9QmbnmcVQVHaIk7vA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedruddugdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdttd
    dttddtvdenucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhi
    rhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpefhieeghf
    dtfeehtdeftdehgfehuddtvdeuheettddtheejueekjeegueeivdektdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuh
    htvghmohhvrdhnrghmvg
X-ME-Proxy: <xmx:FTpfY6X6a0-nNncUTENIATXiPpbN5ND7WE5F8NqymrswjHR2K5LetQ>
    <xmx:FTpfY5m6iTa_ajRFX9W8qURJIth8Q1mt3onGkcWflfa05_IiRQv2XA>
    <xmx:FTpfY3eFPCplgTpV8dcJhCefVG_rlxfAkhPZtW4kPz7zSFBTdY155g>
    <xmx:FjpfY-whjk59Cxskc9UBP3Kjn6tD2e6QjMgxpd_j_EjVTrdoprlhnw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Oct 2022 22:59:33 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 6E064109579; Mon, 31 Oct 2022 05:59:30 +0300 (+03)
Date:   Mon, 31 Oct 2022 05:59:30 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
Message-ID: <20221031025930.maz3g5npks7boixl@box.shutemov.name>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
 <20221017070450.23031-9-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017070450.23031-9-robert.hu@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022 at 03:04:49PM +0800, Robert Hoo wrote:
> When only changes LAM bits, ask next vcpu run to load mmu pgd, so that it
> will build new CR3 with LAM bits updates. No TLB flush needed on this case.
> When changes on effective addresses, no matter LAM bits changes or not, go
> through normal pgd update process.
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>  arch/x86/kvm/x86.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e9b465bff8d3..fb779f88ae88 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1228,9 +1228,9 @@ static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  {
>  	bool skip_tlb_flush = false;
> -	unsigned long pcid = 0;
> +	unsigned long pcid = 0, old_cr3;
>  #ifdef CONFIG_X86_64
> -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>  
>  	if (pcid_enabled) {
>  		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> @@ -1243,6 +1243,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
>  		goto handle_tlb_flush;
>  
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_LAM) &&
> +	    (cr3 & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)))
> +		return	1;
> +
>  	/*
>  	 * Do not condition the GPA check on long mode, this helper is used to
>  	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
> @@ -1254,8 +1258,22 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>  		return 1;
>  
> -	if (cr3 != kvm_read_cr3(vcpu))
> -		kvm_mmu_new_pgd(vcpu, cr3);
> +	old_cr3 = kvm_read_cr3(vcpu);
> +	if (cr3 != old_cr3) {
> +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
> +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
> +					X86_CR3_LAM_U57));
> +		} else {
> +			/* Only LAM conf changes, no tlb flush needed */
> +			skip_tlb_flush = true;

I'm not sure about this.

Consider case when LAM_U48 gets enabled on 5-level paging machines. We may
have valid TLB entries for addresses above 47-bit. It's kinda broken case,
but seems valid from architectural PoV, no?

I guess after enabling LAM, these entries will never match. But if LAM
gets disabled again they will become active. Hm?

Maybe just flush?

> +			/*
> +			 * Though effective addr no change, mark the
> +			 * request so that LAM bits will take effect
> +			 * when enter guest.
> +			 */
> +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +		}
> +	}
>  
>  	vcpu->arch.cr3 = cr3;
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> -- 
> 2.31.1
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

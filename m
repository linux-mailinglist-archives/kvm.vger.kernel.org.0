Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1965373EC18
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 22:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjFZUuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 16:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjFZUuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 16:50:37 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B57D10C1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 13:50:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b7f0264306so9173285ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 13:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687812633; x=1690404633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rjhgD86Qo1kCQsZezQXNy5IN+bFSqWjGtGGtiBxPeuk=;
        b=W/0fqfhygnMUhDbTr8qzJ5TTEiWFZYCehNhWnaqOH6wTHqD5vUNUiUt2LZum/8wymE
         vUOvmOhFWeXYsN3xy7aNW3lZ5hHKUYJFMfQwO6CPy41ubW6zZmkg/sYONrPl418ph8Ad
         tODsCd9GQPoGtbPHvj5zKekbM/C5eTxudJeLwNB3wCD4TUKGGuF1a4EcwLlwh2Rw4aHB
         DuNIpkvBm3RVT0TBdsQnTriWxRd8uw+dM+bI6IY1cmxbFNX1X0QKCXAKWUsoVv6VNYvp
         3uChv8b9GGDxtqh5dnn2LfeQiLdv1EFSWLY1W9jmCtZ94Kle0xcW+C3qUYhkWbhumbU8
         cnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687812633; x=1690404633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjhgD86Qo1kCQsZezQXNy5IN+bFSqWjGtGGtiBxPeuk=;
        b=RkKSSculM1dZbCle5xTNKKLNk+p6P+j2TV8rD35MaVD68/dm5eihlSbP+NWYscfuon
         EeYVuYuNJ4gGMKXswbazTnaqUsALFxv9szaS7IW1gixN97cOU+kGiL4SyyUPRKXBXFtt
         shYZ5FbutrUhk7kVoM9MYmWzeS4orTpJeX1yRqO4PA4MU3d3Ny3dg01LC+aRUN4O4HNv
         GjUr4epL/V3T4jfD7+3gXaFnCRFiL93HFcFqyVUt+Uir1rGrM0USVkAFG9vp9wMCQMD5
         CsEMqcyaFhW897oxxDgR2mEOT17peuDKitbe75yLOKhhY1wXsFIFUz/ofhF9McFp143L
         H/aw==
X-Gm-Message-State: AC+VfDxB4Z1FgoylVq+pN2qroXVRZYGRV9ClI3g6Kef9mgSDMovHIZhz
        6GdckDS4mPZBOLrDrWa21U6A0Qx0fgA=
X-Google-Smtp-Source: ACHHUZ6rycSIxiiq+Km29Ek1X6cS1K0nxjSWz1bBkyQaffwUTLQQGLVJTNTN4EfHp7R1P4u4T4qHlWk4IOc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8b84:b0:1b3:c62d:71b5 with SMTP id
 ay4-20020a1709028b8400b001b3c62d71b5mr526582plb.0.1687812633536; Mon, 26 Jun
 2023 13:50:33 -0700 (PDT)
Date:   Mon, 26 Jun 2023 13:50:31 -0700
In-Reply-To: <3b546ed7-145e-6cd2-effe-e17e958cc226@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-21-weijiang.yang@intel.com> <ZJYyuBdh8Ob+zzT2@google.com>
 <3b546ed7-145e-6cd2-effe-e17e958cc226@intel.com>
Message-ID: <ZJn6F93Ed/i18BL5@google.com>
Subject: Re: [PATCH v3 20/21] KVM:x86: Enable kernel IBT support for guest
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
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

On Mon, Jun 26, 2023, Weijiang Yang wrote:
> 
> On 6/24/2023 8:03 AM, Sean Christopherson wrote:
> > > @@ -7322,6 +7331,19 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >   	kvm_wait_lapic_expire(vcpu);
> > > +	/*
> > > +	 * Save host MSR_IA32_S_CET so that it can be reloaded at vm_exit.
> > > +	 * No need to save the other two vmcs fields as supervisor SHSTK
> > > +	 * are not enabled on Intel platform now.
> > > +	 */
> > > +	if (IS_ENABLED(CONFIG_X86_KERNEL_IBT) &&
> > > +	    (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_CET_STATE)) {
> > > +		u64 msr;
> > > +
> > > +		rdmsrl(MSR_IA32_S_CET, msr);
> > Reading the MSR on every VM-Enter can't possibly be necessary.  At the absolute
> > minimum, this could be moved outside of the fastpath; if the kernel modifies S_CET
> > from NMI context, KVM is hosed.  And *if* S_CET isn't static post-boot, this can
> > be done in .prepare_switch_to_guest() so long as S_CET isn't modified from IRQ
> > context.
> 
> Agree with you.
> 
> > 
> > But unless mine eyes deceive me, S_CET is only truly modified during setup_cet(),
> > i.e. is static post boot, which means it can be read once at KVM load time, e.g.
> > just like host_efer.
> 
> I think handling S_CET like host_efer from usage perspective is possible
> given currently only
> 
> kernel IBT is enabled in kernel, I'll remove the code and initialize the
> vmcs field once like host_efer.
> 
> > 
> > The kernel does save/restore IBT when making BIOS calls, but if KVM is running a
> > vCPU across a BIOS call then we've got bigger issues.
> 
> What's the problem you're referring to?

I was pointing out that S_CET isn't strictly constant, as it's saved/modified/restored
by ibt_save() + ibt_restore().  But KVM should never run between those paired
functions, so from KVM's perspective the host value is effectively constant.

> > > +		vmcs_writel(HOST_S_CET, msr);
> > > +	}
> > > +
> > >   	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
> > >   	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
> > > @@ -7735,6 +7757,13 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> > >   	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> > >   	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
> > > +
> > > +	/*
> > > +	 * If IBT is available to guest, then passthrough S_CET MSR too since
> > > +	 * kernel IBT is already in mainline kernel tree.
> > > +	 */
> > > +	incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> > > +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
> > >   }
> > >   static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > @@ -7805,7 +7834,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
> > >   	vmx_update_exception_bitmap(vcpu);
> > > -	if (kvm_cet_user_supported())
> > > +	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT))
> > Yeah, kvm_cet_user_supported() simply looks wrong.
> 
> These are preconditions to set up CET MSRs for guest, in
> vmx_update_intercept_for_cet_msr(),
> 
> the actual MSR control is based on guest_cpuid_has() results.

I know.  My point is that with the below combination, 

	kvm_cet_user_supported()		= true
	kvm_cpu_cap_has(X86_FEATURE_IBT)	= false 
	guest_cpuid_has(vcpu, X86_FEATURE_IBT)	= true

KVM will passthrough MSR_IA32_S_CET for guest IBT even though IBT isn't supported
on the host.

	incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);

So either KVM is broken and is passing through S_CET when it shouldn't, or the
check on kvm_cet_user_supported() is redundant, i.e. the above combination is
impossible.

Either way, the code *looks* wrong, which is almost as bad as it being functionally
wrong.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9F70CE54
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbjEVWva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbjEVWvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:51:14 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8273310E9
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:50:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-517c06c1a1bso3569280a12.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684795851; x=1687387851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bc5jJ+m1tcxtw8j616gCjMtw6tcRDR1frZV9vlfkfio=;
        b=zWTqbmrQVIwk4Hve+ZzgfU5EKSEgtGvUP65d9xqBIvTMso2XJ7FsHytFLhw0uKduv4
         HY5EujbVEii/zaSAuEe2chCkZCL2vTuFED9rB75iha0g65+ygf0Q7NdPTOYBnC7heuvn
         9LaEaNeugxMMVVDJiJZxlVoSVncfgwThodi3SUyWKKxg7AeACCiHjv3hkI4kzgMhhVvA
         YPJBJaNKnt0Oww1V5VPrZ0NMhm7WkMSKv+2Y5CzNK3Vj6nfM9B+k77leL8LkzIatLjX8
         AhyOmKNceg4VzbkJ5taqKetpTE6HYu6GcpmEnNMPgMx4nIM5TeAB5nLHjxfg69ZtmvFT
         MnaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684795851; x=1687387851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bc5jJ+m1tcxtw8j616gCjMtw6tcRDR1frZV9vlfkfio=;
        b=PJgazzo57M8W/Lz6MsN8hSQ6P01eju5Rsd0JsSBlOwoejKGIxYRGBXVQ/hZWs1PmLD
         JTPAdyhmzJo/5r8TCGszmbNNoIiM/Ka1bbdG/TJ6dErqdBMWlnEvf3fWrStuH0sMXbNp
         zqjRUf1mmK60qpwazxHNUzgXFGqCydRfwOI9+/mBZcdmuFaz3aDxhHKfQEIkdGKkQkuu
         BIMAurGjpP1b/ZM5oXkEI7kmrWpDM22MXZRa/usaHvHZNwK4mJp0niGGpB4lO7Z002z1
         MYT4veTA9jSmVKroeRdXFXCbSSSzJzfZRkbYrb5+AatDMqkAdg1mAwR4qe8bYY431dpt
         SXTQ==
X-Gm-Message-State: AC+VfDxlHpN3vEcMnfDg/E0lakvYJ9+neH+wwdGoTuljYO3XBEDE8h44
        mlOBhvWo8c2OssDUuDaPiXmzT92x2Lc=
X-Google-Smtp-Source: ACHHUZ7Dj8WBk9maf5oJXV41B1Q4+sdaH6HOuUiCpdSlIJ06j9QXT8RVfxkvsvQ81illJ20TYT6T2JMbO1c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5310:0:b0:530:866e:c3c0 with SMTP id
 h16-20020a635310000000b00530866ec3c0mr2799819pgb.10.1684795850767; Mon, 22
 May 2023 15:50:50 -0700 (PDT)
Date:   Mon, 22 May 2023 15:50:49 -0700
In-Reply-To: <20230411125718.2297768-4-aik@amd.com>
Mime-Version: 1.0
References: <20230411125718.2297768-1-aik@amd.com> <20230411125718.2297768-4-aik@amd.com>
Message-ID: <ZGvxyTyzOBod6+ki@google.com>
Subject: Re: [PATCH kernel v5 3/6] KVM: SEV-ES: explicitly disable debug
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
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

On Tue, Apr 11, 2023, Alexey Kardashevskiy wrote:
> SVM/SEV enable debug registers intercepts to skip swapping DRs
> on entering/exiting the guest. When the guest is in control of
> debug registers (vcpu->guest_debug == 0), there is an optimisation to
> reduce the number of context switches: intercepts are cleared and
> the KVM_DEBUGREG_WONT_EXIT flag is set to tell KVM to do swapping
> on guest enter/exit.
> 
> The same code also executes for SEV-ES, however it has no effect as
> - it always takes (vcpu->guest_debug == 0) branch;
> - KVM_DEBUGREG_WONT_EXIT is set but DR7 intercept is not cleared;
> - vcpu_enter_guest() writes DRs but VMRUN for SEV-ES swaps them
> with the values from _encrypted_ VMSA.
> 
> Be explicit about SEV-ES not supporting debug:
> - return right away from dr_interception() and skip unnecessary processing;
> - clear vcpu->guest_debug at SEV-ES' LAUNCH_UPDATE_VMSA if debugging
> was already enabled; after that point the generic x86's
> KVM_SET_GUEST_DEBUG ioctl disallows enabling debug.
> 
> Add WARN_ON to kvm_x86::sync_dirty_debug_regs() (saves guest DRs on
> guest exit) to signify that SEV-ES won't hit that path.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
> Changes:
> v5:
> * new in the series
> ---
>  arch/x86/kvm/svm/sev.c |  6 ++++++
>  arch/x86/kvm/svm/svm.c | 10 +++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0f4761a57d86..b4365622222b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -639,6 +639,12 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	  return ret;
>  
>  	vcpu->arch.guest_state_protected = true;
> +
> +	if (vcpu->guest_debug)
> +		pr_warn_ratelimited("guest_debug (%lx) not supported for SEV-ES",

Note, this needs a newline in the printk, otherwise it'll get buffered until
the next non-cont printk comes along (guess how many times I've been burned by
this).

> +				    vcpu->guest_debug);
> +	vcpu->guest_debug = 0;

Argh, KVM's APIs can be quite frustrating.  IIUC, guest_debug can never actually
be consumed because, per Tom[*], "A guest can't run before the LAUNCH_UPDATE process
is complete".  But because the fact that the VM is an SEV-ES is communicated to
KVM after KVM_CREATE_VM, userspace can do KVM_SET_GUEST_DEBUG before KVM_SEV_ES_INIT
and before KVM_SEV_LAUNCH_UPDATE_VMSA, and thus get KVM into a state where
guest_debug is non-zero for an SEV-ES guest.  Blech.

Instead of a ratelimited warn, can KVM get away with simply rejecting
KVM_SEV_LAUNCH_UPDATE_VMSA if guest_debug is non-zero?  That combo can't work,
so it's seems unlikely userspace is relying on being able to do KVM_SET_GUEST_DEBUG.

If we do "have" to keep this approach, I'm generally opposed to any kind of printk
in KVM, but this one does seem to be justified since the most likely scenario is
that there's a human interactively debugging the guest (or at least, trying to
debug the guest).  But I would say explicitly call out the ioctl(), "guest_debug"
probably won't mean anything to a random user.  And I vote to not print the value,
that implies that the specific value is unsupported, not that debug in general is
disallowed.

Something like this (if we have to)?

		pr_warn_ratelimited("Suppressing KVM_SET_GUEST_DEBUG for SEV-ES guest\n"

[*] https://lore.kernel.org/all/7edcf2c3-005f-04bd-7ec6-80baee236f40@amd.com

> +
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dc12de325cca..179952a31d3b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1980,7 +1980,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	if (vcpu->arch.guest_state_protected)
> +	if (WARN_ON_ONCE(sev_es_guest(vcpu->kvm)))
>  		return;
>  
>  	get_debugreg(vcpu->arch.db[0], 0);
> @@ -2698,6 +2698,14 @@ static int dr_interception(struct kvm_vcpu *vcpu)
>  	unsigned long val;
>  	int err = 0;
>  
> +	/*
> +	 * SEV-ES intercepts DR7 only to disable guest debugging
> +	 * and the guest issues a VMGEXIT for DR7 write only. KVM cannot

Wrapping is a bit aggressive (wrap at 80, not earlier).

> +	 * change DR7 (always swapped as type 'A') so return early.
> +	 */
> +	if (sev_es_guest(vcpu->kvm))
> +		return 1;
> +
>  	if (vcpu->guest_debug == 0) {
>  		/*
>  		 * No more DR vmexits; force a reload of the debug registers
> -- 
> 2.39.1
> 

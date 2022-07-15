Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7425764C6
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiGOP4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGOP4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 11:56:38 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D67661D5C
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 08:56:36 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 72so4797097pge.0
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 08:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qqQJfEW0FN6IJIkIF+XHc3snQAtucZYIpI8xrgMEOoU=;
        b=EC3/IaGbcVPQ8bqDXMt14CoyLb16sGjTQbFo06922wf0cfkug2o8tB7M4h3Qh0Gi9M
         RNzZywpE7iovQRA5Tz209+E9u1G5p0iukRjD33zFw/SUV+GoNa9GVzOIcoeSTv+1Rx6a
         RDhZz5GzuCOp1kHXcQHkF1pgrBW/9MOvI7y4iCNHO3PZvd2RQUri67QqSJ2+PWMI/wBo
         YLfPiULvgDYI6og0Q/tXwkab1RkDLMRp7o0maXmshq5Bk4pqh9MeSZ0bQrzAiEd6Z5zS
         93BhX8mc0lZcWlPJOKQNyLw+KPZD8vuzFMP5PPcg+2IZw8NaqNH6NlcLuGsOfr54D6Gg
         2TRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qqQJfEW0FN6IJIkIF+XHc3snQAtucZYIpI8xrgMEOoU=;
        b=QVdmrh1z51u3mFrND4j1uPaZRlbkjsknBYS+KgzAbQ28ZSQce70vmNbYQDxLCYdYNH
         qg7LiellkTdxzqPi5Jves1OUk1ZAKJxrOkSpiVmv7UgmaZhQDBEhgDrcRoVTd7MDr4Iv
         EtC5W/q/+wj3hH0vwsiaTTUDkuHbZSfzFiHKK/BIIgCRnHz9WS5gQbNIIaRCNg7obf9L
         Zn0G8BrcCLjMyAppP3a9QBahUInBM5u2B93wCYuW6iz6A0RWk/dZYmwuHqD99yFhGRMd
         dV9vB4L1vSYF97pVG6GTInXW64steqbVC9rAkG7j3pLAWEXNQuxgnCFjSaat9Cnx79U8
         PuWQ==
X-Gm-Message-State: AJIora9ByZ1Or0VvAhRbPDlgOro6qHLH1ePmAO8kbfEHzbHCAIdc3FBV
        F4h+QAJIi/Gcnz6/GAEg49j4Kw==
X-Google-Smtp-Source: AGRyM1s6+DI7Oybp0uYSwgx+a5aoVOH/SoXueo79bvrT1WydGkWEHfu0gWEbdlwjEqCYL7WiR8BhOg==
X-Received: by 2002:a63:a47:0:b0:419:d02c:289e with SMTP id z7-20020a630a47000000b00419d02c289emr5281352pgk.46.1657900595490;
        Fri, 15 Jul 2022 08:56:35 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902cecc00b0016c0d531448sm3744333plg.276.2022.07.15.08.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 08:56:35 -0700 (PDT)
Date:   Fri, 15 Jul 2022 15:56:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: X86: Fix the comments in prepare_vmcs02_rare()
Message-ID: <YtGOL4jIMQwoW5vb@google.com>
References: <20220715114211.53175-1-yu.c.zhang@linux.intel.com>
 <20220715114211.53175-3-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715114211.53175-3-yu.c.zhang@linux.intel.com>
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

On Fri, Jul 15, 2022, Yu Zhang wrote:
> Although EB.PF in vmcs02 is still set by simply "or"ing the EB of
> vmcs01 and vmcs12, the explanation is obsolete. "enable_ept" being
> set is not the only reason for L0 to clear its EB.PF.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 778f82015f03..634a7d218048 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2451,10 +2451,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  	 * is not easy (if at all possible?) to merge L0 and L1's desires, we
>  	 * simply ask to exit on each and every L2 page fault. This is done by
>  	 * setting MASK=MATCH=0 and (see below) EB.PF=1.
> -	 * Note that below we don't need special code to set EB.PF beyond the
> -	 * "or"ing of the EB of vmcs01 and vmcs12, because when enable_ept,
> -	 * vmcs01's EB.PF is 0 so the "or" will take vmcs12's value, and when
> -	 * !enable_ept, EB.PF is 1, so the "or" will always be 1.
> +	 * Note that EB.PF is set by "or"ing of the EB of vmcs01 and vmcs12,
> +	 * because when L0 has no desire to intercept #PF, vmcs01's EB.PF is 0
> +	 * so the "or" will take vmcs12's value, otherwise EB.PF is 1, so the
> +	 * "or" will always be 1.

Oof!  I was going to respond with a variety of nits (about the existing comment),
and even suggest that we address the TODO just out of sight, but looking at all
of this made me realize there's a bug here!  vmx_update_exception_bitmap() doesn't
update MASK and MATCH!

Hitting the bug is extremely unlikely, as it would require changing the guest's
MAXPHYADDR via KVM_SET_CPUID2 _after_ KVM_SET_NESTED_STATE, but before KVM_RUN
(because KVM now disallows changin CPUID after KVM_RUN).

During KVM_SET_CPUID2, KVM will invoke vmx_update_exception_bitmap() to refresh
the exception bitmap to handle the ept=1 && allow_smaller_maxphyaddr=1 scenario.
But when L2 is active, vmx_update_exception_bitmap() assumes vmcs02 already has
the correct MASK+MATCH because of the "clear both if KVM and L1 both want #PF"
behavior.  But if KVM's desire to intercept #PF changes from 0=>1, then KVM will
run L2 with the MASK+MATCH from vmcs12 because vmx_need_pf_intercept() would have
returned false at the time of prepare_vmcs02_rare().

Fixing the bug is fairly straightforward, and presents a good opportunity to
clean up the code (and this comment) and address the TODO.

Unless someone objects to my suggestion for patch 01, can you send a new version
of patch 01?  I'll send a separate series to fix this theoretical bug, avoid
writing MASK+MATCH when vmcs0x.EXCEPTION_BITMAP.PF+0, and to address the TODO.

E.g. I believe this is what we want to end up with:

	if (vmcs12)
		eb |= vmcs12->exception_bitmap;

	/*
	 * #PF is conditionally intercepted based on the #PF error code (PFEC)
	 * combined with the exception bitmap.  #PF is intercept if:
	 *
	 *    EXCEPTION_BITMAP.PF=1 && ((PFEC & MASK) == MATCH).
	 *
	 * If any #PF is being intercepted, update MASK+MATCH, otherwise leave
	 * them alone they do not affect interception (EXCEPTION_BITMAP.PF=0).
	 */
	if (eb & (1u << PF_VECTOR)) {
		/*
		 * If EPT is enabled, #PF is only intercepted if MAXPHYADDR is
		 * smaller on the guest than on the host.  In that case, KVM
		 * only needs to intercept present, non-reserved #PF.  If EPT
		 * is disabled, i.e. KVM is using shadow paging, KVM needs to
		 * intercept all #PF.  Note, whether or not KVM wants to
		 * intercept _any_ #PF is handled below.
		 */
		if (enable_ept) {
			pfec_mask = PFERR_PRESENT_MASK | PFERR_RSVD_MASK;
			pfec_match = PFERR_PRESENT_MASK;
		} else {
			pfec_mask = 0;
			pfec_match = 0;
		}

		if (!(vmcs12->exception_bitmap & (1u << PF_VECTOR))) {
			/* L1 doesn't want to intercept #PF, use KVM's MASK+MATCH. */
		} else if (!kvm_needs_pf_intercept) {
			/* KVM doesn't want to intercept #PF, use L1's MASK+MATCH. */
			pfec_mask = vmcs12->page_fault_error_code_mask;
			pfec_match = vmcs12->page_fault_error_code_match;
		} else if (pfec_mask != vmcs12->page_fault_error_code_mask ||
			   pfec_match != vmcs12->page_fault_error_code_mask) {
			/*
			 * KVM and L1 want to intercept #PF with different MASK
			 * and/or MATCH.  For simplicity, intercept all #PF by
			 * clearing MASK+MATCH.  Merging KVM's and L1's desires
			 * is quite complex, while the odds of meaningfully
			 * reducing what #PFs are intercept are low.
			 */
			pfec_mask = 0;
			pfec_match = 0;
		} else {
			/* KVM and L1 have identical MASK+MATCH. */
		}
		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, pfec_mask);
		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, pfec_match);
	}


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAA76DC8B8
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 17:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjDJPrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 11:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjDJPrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 11:47:09 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5F6113
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:47:07 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s18-20020a170902ea1200b001a1f4137086so3498219plg.14
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681141627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSgxZZBUIkwdGxxaEIDig44+mGz6dsvZJjxlvbsSdwM=;
        b=tUYMZF+kNfp7kRJwg/VaD+6vM8QC+7Yj1S/ewwY3KEBfFn8LAGYfZ2KAfp4acU3o6j
         6VjoObnDJC2jH1fdr+NZb0XE7SZswgclbj/Aid4sT8fk1Cqgl+qy3FBPVpXpkZyQbBye
         vH6XTJt6gnpdTSGyyzqcQsxUw6dfCd7cwwxCpD+7ocO8/S9dC390yr3cSa4EmNiuzQj4
         3CT/qa5Okvgt129LDLNfNfF4uee02qtQsLjurnWDsZ9Qez27SPABdONZ4/lP6lGa13qu
         PYGWdKQfWJoosYRejbbmaOuSgjn5smIOWk9otgpOIOZeLUWTOq0gPza9UjJKENIOBIPF
         QovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681141627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSgxZZBUIkwdGxxaEIDig44+mGz6dsvZJjxlvbsSdwM=;
        b=lXyDauMzAzYLB1sdwq5KHd5iREumQ+xgdAf61jJfdYdz/QeoQhrh8sZsR23AyGvFL7
         HfOCe4soybnt9Rr/IDuroNfhsDrFjj8nf3RnD/SqQBJHP4BABK+i0dzHdHmlcmIO8Syo
         Qx7C5YKm9nEWTuN5CTRZs0GvfbkkbGNWMudQznALCOit3j0mugs8tRxH32XeZc5Kgh/c
         yeSgQWPH4PAxjaJT5Vd+MYuenvUdp77uhWawl2IiZHz8X/3dvGrhMuOvO4o4FHfoXfm7
         KWhBKfvV4f35y2LheFTVxRyOODezbAy3eqFehySix51D7hEh+Un4cFpHN7XeKKKXFI6v
         eG6Q==
X-Gm-Message-State: AAQBX9cX+P1wnDghr6kt/xvAfnLrAp14ox6JDwRnTTfO0oS9h3mx4Mf0
        H569/NG6lF3jEvGglXEIWEM6HGrALqQ=
X-Google-Smtp-Source: AKy350Z9Uw0+C4bP+YMFWLmUIlUO5LarjSeyXm8LJbZ7scVwJQBVEf/vQn1MeYKdJldOamvjhpibI81ufxw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4c88:0:b0:513:92e7:4555 with SMTP id
 m8-20020a654c88000000b0051392e74555mr5661893pgt.4.1681141626989; Mon, 10 Apr
 2023 08:47:06 -0700 (PDT)
Date:   Mon, 10 Apr 2023 08:47:05 -0700
In-Reply-To: <20230410141820.57328-1-itazur@amazon.com>
Mime-Version: 1.0
References: <20230410141820.57328-1-itazur@amazon.com>
Message-ID: <ZDQveaSDYx+4z5t4@google.com>
Subject: Re: [PATCH] kvm: x86: Update KVM_GET_CPUID2 to return valid entry count
From:   Sean Christopherson <seanjc@google.com>
To:     Takahiro Itazuri <itazur@amazon.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Takahiro Itazuri <zulinx86@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capitalize KVM please, i.e. "KVM: x86:".

On Mon, Apr 10, 2023, Takahiro Itazuri wrote:
> Modify the KVM_GET_CPUID2 API to return the number of valid entries in
> nent field of kvm_cpuid2, even when the API is successful.
> 
> Previously, the KVM_GET_CPUID2 API only updated the nent field when an

Heh, I am so used to KVM_SET_CPUID2 being a source of bugs that it took me at
least three read throughs before I caught that this is fixing the GET side.

> error was returned. If the API was called with an entry count larger
> than necessary (e.g., KVM_MAX_CPUID_ENTRIES), it would succeed, but the
> nent field would continue to show a value larger than the actual number
> of entries filled by the KVM_GET_CPUID2 API. With this change, users can
> rely on the updated nent field and there is no need to traverse
> unnecessary entries and check whether an entry is valid or not.

While I completely agree that the not updating "nent" on success is asinine, I
am mildly concerned about this being a breaking ABI change, e.g. if a VMM has
"nent" marked as a consant/immutable value.  I suspect it's ok because AFAICT,
pretty much nothing outside of selftests actually uses KVM_GET_CPUID2.  But at
the very least, I'll push this out until 6.5 so that it can soak in linux-next
for a long time.

Paolo, any thoughts/objections?

> Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
> ---
>  arch/x86/kvm/cpuid.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 599aebec2d52..31838dfddda6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -523,10 +523,13 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  			      struct kvm_cpuid2 *cpuid,
>  			      struct kvm_cpuid_entry2 __user *entries)
>  {
> -	int r;
> +	int nent, r;
> +
> +	nent = cpuid->nent;
> +	cpuid->nent = vcpu->arch.cpuid_nent;
>  
>  	r = -E2BIG;
> -	if (cpuid->nent < vcpu->arch.cpuid_nent)
> +	if (nent < vcpu->arch.cpuid_nent)
>  		goto out;
>  	r = -EFAULT;
>  	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
> @@ -535,7 +538,6 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  	return 0;
>  
>  out:
> -	cpuid->nent = vcpu->arch.cpuid_nent;
>  	return r;

I think we should break from the (IMO) somewhat funky KVM ioctl() pattern of

	r = <errno>
	if (try something and it fails)
		goto out;

and instead set "r" in the error paths.  That avoids the need for a scratch "nent",
and IMO makes this much more straightforward.

	int r = 0;

	if (cpuid->nent < vcpu->arch.cpuid_nent)
		r = -E2BIG;
	else if (copy_to_user(entries, vcpu->arch.cpuid_entries,
			      vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
		r = -EFAULT;

	/*
	 * Update "nent" even on failure, e.g. so that userspace can fix an
	 * -E2BIG issue by allocating a larger array.
	 */
	cpuid->nent = vcpu->arch.cpuid_nent;
	return r;

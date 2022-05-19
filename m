Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC0552CA8B
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 05:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiESDsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 23:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiESDsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 23:48:06 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B967A87A23
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 20:48:05 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e3so4524236ios.6
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 20:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V7aykxkpRlTrHcdok+1A8qMCzSLka/rVSLMo9eqIxnA=;
        b=nCjjPyCmNUJwmxdEVP2MJRlqhK1VkKhityQGd1WRlCSn1KQoYBU7MSH7G9iBptN0ZA
         K9F/9TOtJDNQ6HlNozRI9gtk+YKBCMp6p1alj9uaGotX3V4uQnc6RclOHQpJoMb8tC52
         kUfLP0MeMGnms+fOZi0nljeddiouf8PS1LChbh7rouNciJANho6lK6y6e8JZlw5oqc5i
         1HW/FeboKCrQHRzUdaXSuUDy44kHr3JnrNSp55V38SMxTp48Bv65UUhRxDEegqsVbsRv
         x4UiPJUKeZDHotEucB35lECImraRroX9wvVueZLWO2rzVs2iSqBV4wTlAWP3cDy724d3
         UIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V7aykxkpRlTrHcdok+1A8qMCzSLka/rVSLMo9eqIxnA=;
        b=heuUSgqYJLOGtugc3E/nAf7I+YSPBy3DRefFO7li4bg9U/uaYLZB9WHGoYlKpl1/vQ
         IkBFv3kAx9FBTIXRgRukwfYm4uHTuvnXx+UgaqcjRofFqHh8qGROXzbDPLzGN9AgCv0l
         BUgut7CHibge04CjF5q4yRW1Xj4156UKFKa9gAIwF9iIEXRWcBa8Lq3RjPlF6axR/ePy
         G7MKc+v5pazUIujoYHXXM87ommOqjmPr4dm3JvSk5BOYroPjIOiEObr1U1lu0TC0HHcE
         4l04ZTrwR6XeEq7Pon5BumPPC4RmU0sW73DAOEgFrYBUy7yH+moW/ckUauZIdIqZdIug
         6ODg==
X-Gm-Message-State: AOAM533XCviOfhv8tUp3rS1zwnyfUDnTrSDxsfPFyiHsyWJ7Ef6uoeqF
        Qlc/1ZoylnnQ5KgbajeUoqBCOA6xMc/ZUA==
X-Google-Smtp-Source: ABdhPJyF43/gmULs/erOMWf06SK+pEavs8YWgCinIHa60Rx65dQweOqX0OpvpMJfoexchX+275tbQw==
X-Received: by 2002:a05:6602:2f0c:b0:65a:d5f3:7572 with SMTP id q12-20020a0566022f0c00b0065ad5f37572mr1475954iow.22.1652932084930;
        Wed, 18 May 2022 20:48:04 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f1-20020a02a101000000b0032e833105fesm332923jag.177.2022.05.18.20.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 20:48:04 -0700 (PDT)
Date:   Thu, 19 May 2022 03:48:00 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v3 02/13] KVM: selftests: aarch64: Add vm_get_pte_gpa
 library function
Message-ID: <YoW98HI27sP5lHKR@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-3-ricarkol@google.com>
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

Hey Ricardo,

Sorry about my last email hitting your v2. I fudged my inbox filtering
so v3 missed my explicit-cc inbox. Oops!

On Thu, Apr 07, 2022 at 05:41:09PM -0700, Ricardo Koller wrote:
> Add a library function (in-guest)

This function is called from host userspace, no?

> to get the GPA of the PTE of a
> particular GVA.  This will be used in a future commit by a test to clear
> and check the AF (access flag) of a particular page.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h |  2 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 24 +++++++++++++++++--
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 8f9f46979a00..caa572d83062 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -125,6 +125,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
>  void vm_install_sync_handler(struct kvm_vm *vm,
>  		int vector, int ec, handler_fn handler);
>  
> +vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva);
> +
>  static inline void cpu_relax(void)
>  {
>  	asm volatile("yield" ::: "memory");
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 9343d82519b4..ee006d354b79 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -139,7 +139,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>  	_virt_pg_map(vm, vaddr, paddr, attr_idx);
>  }
>  
> -vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> +vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  {
>  	uint64_t *ptep;
>  
> @@ -162,7 +162,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  			goto unmapped_gva;
>  		/* fall through */
>  	case 2:
> -		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
> +		ptep = (uint64_t *)(pte_addr(vm, *ptep) + pte_index(vm, gva) * 8);

this seems a bit odd. ptep is an HVA in the above cases, but really a
GPA here.

Also -- not your code but the baked-in assumption that the stage-1 MMU
always maps at leaf page granularity might be a bit of a mess if we ever
do anything more interesting inside of the guest.

>  		if (!ptep)
>  			goto unmapped_gva;
>  		break;
> @@ -170,6 +170,26 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  		TEST_FAIL("Page table levels must be 2, 3, or 4");
>  	}
>  
> +	return (vm_paddr_t)ptep;
> +
> +unmapped_gva:
> +	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
> +	exit(1);

Isn't this just a workaround for the fact that TEST_FAIL() doesn't have
the noreturn attribute specified somewhere?

> +}
> +
> +vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> +{
> +	uint64_t *ptep;
> +	vm_paddr_t ptep_gpa;
> +
> +	ptep_gpa = vm_get_pte_gpa(vm, gva);
> +	if (!ptep_gpa)
> +		goto unmapped_gva;

This branch will never be taken since vm_get_pte_gpa() will explode on
its own, right?

--
Thanks,
Oliver

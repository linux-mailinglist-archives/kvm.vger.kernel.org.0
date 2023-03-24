Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B636C8361
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjCXRbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 13:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCXRbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 13:31:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029D67EF3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 10:31:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536cb268ab8so25240297b3.17
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 10:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679679061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a/T0dFPDkQ7D0O2ujKj8hG7SaoRSBTKkSxDEkTyraFI=;
        b=kc3n0RfZzKkSztGUKFy8tfBZbwRbC9HP1Ro6l2XBZ8iYJ7CP9CbkghVKu9syInJzdk
         d175b+5UpDnscaRQ1J8s3PcNuMwChBFsNUI1o1b4CigKVcUY7ezY376CZRwu4QLugj6v
         YAIGWKWX5LGP1ipSau6h3WZqH5jtlF+FQl8clWf7Got+iUPIHMzOMYbZPJdweIk10XaZ
         xNAVrONhGtnS9zBzWxNHy3qIKTzLL9udqZJGHpJjj9BJt18VkwUg7SbUiki9sdLqI4yT
         FfA/tAqwK/1z+bKzsSxbgjNNiDFRtj3qCdMLcvFhnGfGvtCk0cjpJ2Co9C8e1zdYfLT9
         X+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679679061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a/T0dFPDkQ7D0O2ujKj8hG7SaoRSBTKkSxDEkTyraFI=;
        b=dJStf3mJCBCiFStriJ9cVUjp++NXif8Z+B2AQ0xURrDn1VksSHfLkJFZlhrgFSm41T
         TBurVAV32AKKf0pPoVI2lwBIGT+y0zKRunBAgPpZwFzDQSRBGTFgs1UQn9xZULjLxy3P
         XI1hmYmuPguj8UK7L+X7/RtcV2L5qLFk+PtMy0HmhBQbtTdS+AEAOqSMk4X9Px8vGX5t
         JZqILiz+SqZsZBHTz23FG7T/gOf4wb4HIocUzq5ifrpPDSu+wGdMZHUdOr2LXYxpr7+E
         Qm6WBYL0JePue26+B5i4VHU/j8ZHx7IWM1BFf7bY9KMEXGA9yX+jO5h41DUGFn+sFiry
         Apwg==
X-Gm-Message-State: AAQBX9dtfZLZF12BGnKwSqZ9lgyxn9lSh3TfDJJPuOLyTdxI1B8RHEGU
        465x1QTT5zTL/KX40cdqHUeV3NYpK0I=
X-Google-Smtp-Source: AKy350YG5y3fwHd5vNaGztENu5MRwTc6rkDfyW/jzhBV2mf8VtOBz+DBwF1pWn6XMUAG2McEmgvDFO4oybs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1205:b0:b69:fab9:de60 with SMTP id
 s5-20020a056902120500b00b69fab9de60mr1822442ybu.0.1679679061302; Fri, 24 Mar
 2023 10:31:01 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:30:59 -0700
In-Reply-To: <20230110175057.715453-5-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com> <20230110175057.715453-5-pgonda@google.com>
Message-ID: <ZB3eU8W9D3c50Kak@google.com>
Subject: Re: [PATCH V6 4/7] KVM: selftests: add support for protected
 vm_vaddr_* allocations
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
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

On Tue, Jan 10, 2023, Peter Gonda wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> Test programs may wish to allocate shared vaddrs for things like
> sharing memory with the guest. Since protected vms will have their
> memory encrypted by default an interface is needed to explicitly
> request shared pages.
> 
> Implement this by splitting the common code out from vm_vaddr_alloc()
> and introducing a new vm_vaddr_alloc_shared().
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++----
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index f84d7777d5ca..5f3150ecfbbf 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -435,6 +435,7 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_mi
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
>  vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
>  			    enum kvm_mem_region_type type);
> +vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);

Wrap.

>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
>  vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
>  				 enum kvm_mem_region_type type);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index ba771c2d949d..0d0a7ad7632d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1305,15 +1305,17 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
>  	return pgidx_start * vm->page_size;
>  }
>  
> -vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
> -			    enum kvm_mem_region_type type)
> +static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
> +				     vm_vaddr_t vaddr_min,
> +				     enum kvm_mem_region_type type,
> +				     bool encrypt)

s/encrypt/protected, or maybe mark_protected so that it's clear that it's a command.

>  {
>  	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
>  
>  	virt_pgd_alloc(vm);
> -	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
> +	vm_paddr_t paddr = _vm_phy_pages_alloc(vm, pages,
>  					      KVM_UTIL_MIN_PFN * vm->page_size,
> -					      vm->memslots[type]);
> +					      vm->memslots[type], encrypt);
>  
>  	/*
>  	 * Find an unused range of virtual page addresses of at least
> @@ -1333,6 +1335,17 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
>  	return vaddr_start;
>  }
>  
> +vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
> +			    enum kvm_mem_region_type type)
> +{
> +	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, vm->protected);
> +}
> +
> +vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
> +{
> +	return ____vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA, false);

This shouldn't be MEM_REGION_TEST_DATA, because then the ucall patches changes
from MEM_REGION_DATA to MEM_REGION_TEST_DATA, which I suspect will break ARM's
page_fault_test.  So, we probably need to have vm_vaddr_alloc_shared() be a true
mirror of the non-shared version and take @type.

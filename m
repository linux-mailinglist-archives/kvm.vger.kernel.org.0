Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3FA371404
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 13:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhECLKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 07:10:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232981AbhECLKQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 07:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620040163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/TtbraNaumD0Cl9ygYI6NPc6Ttc7ibmS10zSQgMklFQ=;
        b=JHlx5KD32xCDfTyYLFOsG+AiUzCJrQNykHdFiNU+bnak4InrRJZworUHnHCkIy45+rgwrh
        7vQkviFErxJmLi2PPAYXgETjtjvLY0gcLohaV8jIamWKusS6nCW8vYSXzNllrEwM6ByRfR
        kfn/l+ioICVla3s4UdiuC2fvo8nLktk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-CwzKj9kxOyeWPQ6BGT7aOA-1; Mon, 03 May 2021 07:09:12 -0400
X-MC-Unique: CwzKj9kxOyeWPQ6BGT7aOA-1
Received: by mail-wr1-f71.google.com with SMTP id 63-20020adf84450000b029010dd0171a96so3147301wrf.21
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 04:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/TtbraNaumD0Cl9ygYI6NPc6Ttc7ibmS10zSQgMklFQ=;
        b=cV2eWPzA5nNodO8pt7goez9osL2Rmd9ALhndWZwt60wtdb69l2/zckIrkmkMT0i9Dp
         W4zLYLvGGsJjTcSYSflDF+CG4Y/dZ7Y9Ajx0cJ48IriA3GwVIW7gVNHRX3USTwkG3f1s
         Hc/1fnxLSnAGc1wGaIWzqyX+0F1UUfROuyoir1vvajJNxkUAxAx5W5Jy3XPoobcmgpGj
         3IgiWq8z9t2FtIvB2ojyIDZxt4g/UcEAtfm3AhIcKDOLXaUWDG4tzy7Op9VHtvQWjZeN
         ZQ17VDxu99SX45NJsaQ1+KGzUgIXZgKJ9T/wJnh2uaaaRq9+japfUmvAnDvA4ijfRi6F
         G57Q==
X-Gm-Message-State: AOAM5339ckXdlllnuvQrrrgH8XFhZbpK20tO61iV2BHFCvdrr1WBwYVH
        Fe8ypsM85oa/RaIcc3cL+wJE6/c5Ux0E/aztTHgPFZwhR0Tu7yfNhB+ozlpJkZvwL7SoCeweTSD
        MzXdd7/AOQHkm
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr32346741wma.31.1620040151828;
        Mon, 03 May 2021 04:09:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcvJLPDIMztZ/pkM3vUQ8uhHe9Kz0grAWyDXSQnMj971ADuUbBalhXfCmbcQiVMQ1hW4A5gg==
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr32346722wma.31.1620040151657;
        Mon, 03 May 2021 04:09:11 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id g25sm4180634wmk.43.2021.05.03.04.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 04:09:11 -0700 (PDT)
Date:   Mon, 3 May 2021 13:09:09 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH v2 2/5] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
Message-ID: <20210503110909.n7chjg2run6gaeq3@gator.home>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430232408.2707420-3-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 04:24:04PM -0700, Ricardo Koller wrote:
> x86, the only arch implementing exception handling, reports unhandled
> vectors using port IO at a specific port number. This replicates what
> ucall already does.
> 
> Introduce a new ucall type, UCALL_UNHANDLED, for guests to report
> unhandled exceptions. Then replace the x86 unhandled vector exception
> reporting to use it instead of port IO.  This new ucall type will be
> used in the next commits by arm64 to report unhandled vectors as well.
> 
> Tested: Forcing a page fault in the ./x86_64/xapic_ipi_test
> 	halter_guest_code() shows this:
> 
> 	$ ./x86_64/xapic_ipi_test
> 	...
> 	  Unexpected vectored event in guest (vector:0xe)
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h    |  1 +
>  .../selftests/kvm/include/x86_64/processor.h      |  2 --
>  .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++---------
>  3 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index bea4644d645d..7880929ea548 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -347,6 +347,7 @@ enum {
>  	UCALL_SYNC,
>  	UCALL_ABORT,
>  	UCALL_DONE,
> +	UCALL_UNHANDLED,
>  };
>  
>  #define UCALL_MAX_ARGS 6
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 12889d3e8948..ff4da2f95b13 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -53,8 +53,6 @@
>  #define CPUID_PKU		(1ul << 3)
>  #define CPUID_LA57		(1ul << 16)
>  
> -#define UNEXPECTED_VECTOR_PORT 0xfff0u
> -
>  /* General Registers in 64-Bit Mode */
>  struct gpr64_regs {
>  	u64 rax;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index e156061263a6..96e2bd9d66eb 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1207,7 +1207,7 @@ static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
>  
>  void kvm_exit_unexpected_vector(uint32_t value)
>  {
> -	outl(UNEXPECTED_VECTOR_PORT, value);
> +	ucall(UCALL_UNHANDLED, 1, value);
>  }
>  
>  void route_exception(struct ex_regs *regs)
> @@ -1260,16 +1260,13 @@ void vm_install_vector_handler(struct kvm_vm *vm, int vector,
>  
>  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
>  {
> -	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
> -		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
> -		&& vcpu_state(vm, vcpuid)->io.size == 4) {
> -		/* Grab pointer to io data */
> -		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
> -			+ vcpu_state(vm, vcpuid)->io.data_offset;
> +	struct ucall uc;
>  
> +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
> +		uint64_t vector = uc.args[0];
>  		TEST_ASSERT(false,
> -			    "Unexpected vectored event in guest (vector:0x%x)",
> -			    *data);
> +			    "Unexpected vectored event in guest (vector:0x%lx)",
> +			    vector);

nit: Could have changed this TEST_ASSERT(false, ...) to TEST_FAIL while
touching it.

>  	}
>  }
>  
> -- 
> 2.31.1.527.g47e6f16901-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew


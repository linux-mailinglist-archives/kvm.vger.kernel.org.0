Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1693D147B
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbhGUQGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 12:06:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232058AbhGUQGF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 12:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626886001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SdDUG3Tlr7StcVQDE/T+VireBjyknjYEkozWsd7mGNo=;
        b=hKFrsC4EEkIstb8QmkUGGFW5qCpEIhAdaBb6qlvZdFqZTtTDxW73XlfIXjOaqierTQXTxg
        gqIYT7CWNzNW7//x3QwuUdLjd/ZI3B8By8L2CVrxgv7HeMg68wRSstgBOGTINaw0Ig8V6Z
        eDKfpYMTuvyXAsUBUmtt6mgKP4+z1l8=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-KuMtj9QROTGlQp8wAsWFEg-1; Wed, 21 Jul 2021 12:46:39 -0400
X-MC-Unique: KuMtj9QROTGlQp8wAsWFEg-1
Received: by mail-io1-f69.google.com with SMTP id d17-20020a0566022291b029053e3f025a44so1959195iod.15
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SdDUG3Tlr7StcVQDE/T+VireBjyknjYEkozWsd7mGNo=;
        b=J9gtJEs6Qrk0+TiEwQ7in0Sl3EMgYNaCW8Tj/jPi9bSFGitRFeo5zjzJRqMyl2JRyg
         AAH7epBCmPgN8UpmF9KBq9fa+dareYwXZ5ZDkqym1NPM5VLR5XF7f8KutrrcwaAvaDJN
         JXwha8eCQ0VZ6G0T30cMzjAGyzKg1wN5Dn05ssUmobqGGJ0Bir/fq5PTahRgeUWj1Sv4
         4ElLh4MvKLbFNeaBNIgipzmOJpO7s/WTj0jg+OlbqEkMJ1y9UHZT/2RaBiIPCT/DwdkN
         4iRyL7YgjnH9uHAEOUUrJM/+yJY80w4NN2ZpDtx43aYzn4va56oscuaaw5WeEclHTnaB
         Sdmw==
X-Gm-Message-State: AOAM533oo2OPQPp272qAJz+XvjOjSYACD359083YBFSyO7Zvu/hYcHv2
        cRrQUzT4fkAnEic2PKOp+TV/qZonIZlYz594ZmGLh9IyZD0QV0KEePNglngIz6cGxhzvsytJyzv
        3FzzyIIuOGqGC
X-Received: by 2002:a92:d58f:: with SMTP id a15mr8037170iln.18.1626885999231;
        Wed, 21 Jul 2021 09:46:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhXSZhbJ3Y7T2Mveqj1UY3BfD2Zr2HtG+rzw/5HH87b6MDaadStM2r2qKfE3lFkz+licmK8w==
X-Received: by 2002:a92:d58f:: with SMTP id a15mr8037150iln.18.1626885999068;
        Wed, 21 Jul 2021 09:46:39 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id y198sm14555037iof.25.2021.07.21.09.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:46:38 -0700 (PDT)
Date:   Wed, 21 Jul 2021 18:46:36 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Raghavendra Rao Anata <rananta@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 11/12] selftests: KVM: Test physical counter offsetting
Message-ID: <20210721164636.yzzhguwzjrtj3ty6@gator>
References: <20210719184949.1385910-1-oupton@google.com>
 <20210719184949.1385910-12-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184949.1385910-12-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 06:49:48PM +0000, Oliver Upton wrote:
> Test that userpace adjustment of the guest physical counter-timer
> results in the correct view of within the guest.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 12 ++++++++
>  .../kvm/system_counter_offset_test.c          | 29 ++++++++++++++++---
>  2 files changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 3168cdbae6ee..7f53d90e9512 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -141,4 +141,16 @@ static inline uint64_t read_cntvct_ordered(void)
>  	return r;
>  }
>  
> +static inline uint64_t read_cntpct_ordered(void)
> +{
> +	uint64_t r;
> +
> +	__asm__ __volatile__("isb\n\t"
> +			     "mrs %0, cntpct_el0\n\t"
> +			     "isb\n\t"
> +			     : "=r"(r));
> +
> +	return r;
> +}
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
> index 88ad997f5b69..3eed9dcb7693 100644
> --- a/tools/testing/selftests/kvm/system_counter_offset_test.c
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -57,6 +57,7 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
>  
>  enum arch_counter {
>  	VIRTUAL,
> +	PHYSICAL,
>  };
>  
>  struct test_case {
> @@ -68,23 +69,41 @@ static struct test_case test_cases[] = {
>  	{ .counter = VIRTUAL, .offset = 0 },
>  	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
>  	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL, .offset = 0 },
> +	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
>  };
>  
>  static void check_preconditions(struct kvm_vm *vm)
>  {
>  	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> -				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER))
> +				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER) &&
> +	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				   KVM_ARM_VCPU_TIMER_OFFSET_PTIMER))
>  		return;
>  
> -	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_VTIMER not supported; skipping test");
> +	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_{VTIMER,PTIMER} not supported; skipping test");
>  	exit(KSFT_SKIP);
>  }
>  
>  static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
>  {
> +	u64 attr = 0;
> +
> +	switch (test->counter) {
> +	case VIRTUAL:
> +		attr = KVM_ARM_VCPU_TIMER_OFFSET_VTIMER;
> +		break;
> +	case PHYSICAL:
> +		attr = KVM_ARM_VCPU_TIMER_OFFSET_PTIMER;
> +		break;
> +	default:
> +		TEST_ASSERT(false, "unrecognized counter index %u",
> +			    test->counter);
> +	}
> +
>  	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> -				KVM_ARM_VCPU_TIMER_OFFSET_VTIMER, &test->offset,
> -				true);
> +				attr, &test->offset, true);
>  }
>  
>  static uint64_t guest_read_system_counter(struct test_case *test)
> @@ -92,6 +111,8 @@ static uint64_t guest_read_system_counter(struct test_case *test)
>  	switch (test->counter) {
>  	case VIRTUAL:
>  		return read_cntvct_ordered();
> +	case PHYSICAL:
> +		return read_cntpct_ordered();
>  	default:
>  		GUEST_ASSERT(0);
>  	}
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>


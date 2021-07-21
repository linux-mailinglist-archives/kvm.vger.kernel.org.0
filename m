Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8C43D142A
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbhGUPqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:46:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235319AbhGUPqP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 11:46:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626884811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m+x1aVmvJEpbSpTNhe+gSPdN5GMbbTZag6bLJsVFPDU=;
        b=CHiHl7DtJ01SHTWIVkKyk38j/UIPOpK2ylGo8zojJDwjmfMgKCSQcj20e1QyasS+Thrp7H
        BvO3tZ8svpVjPnNr5snQHwAzDTQ4PhNGkfY3F/uRU+1WLphrAXXG9S0iMtkVZ9P323m+lR
        noeNuW26JXDXr1XPSISHPF1y1Soqt5g=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-j9nrV3XFPum6Fg8IKDxK8g-1; Wed, 21 Jul 2021 12:26:49 -0400
X-MC-Unique: j9nrV3XFPum6Fg8IKDxK8g-1
Received: by mail-io1-f72.google.com with SMTP id k2-20020a5d8b020000b029050b6f9cfe31so1937150ion.11
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m+x1aVmvJEpbSpTNhe+gSPdN5GMbbTZag6bLJsVFPDU=;
        b=jdahz6ExWQXVqs31zlc+ymTGUPOSYsQ3gtjA4OWPVwI6onokvtctKRgS9QpbUXDJ+c
         QnrJu33T+Wr+ZEZvUIinCkmjF3rkTwWbF3ezQcnxrbQJrBnVlrIaMCBf3g6nbM0xGrhf
         gZpM/BdYXLJcb8+fVfCtF9aqOwbpqZOLQyGHD8mQD1ytEQPBf2JMhKhvV9RSolmWynNM
         E7nsoOmDaMRF7gKcxZ2JgeGKJanNmreSu6SwpCQQZtG2bKmWuJnMtbWxg334yEP66Wky
         euJ0x45nanVJNDGp7QLjsqL4C4HOMdk84UmpuKHMjuJgprOBVvwZeUiEWNmmkFdgpobz
         fIpw==
X-Gm-Message-State: AOAM533BnqtEQ6aoWl7yCTwHx7VCySeJwUOva1KwyPDG4ZEWjR4GucKv
        E7MEhUWO0UmFy8DpU5MEMggninTduB8hqCLAS+TRMPTkVpZT8fMWnVKoOot4IKfPsuKJ7TfaTtF
        BVVo+YAEiyL4I
X-Received: by 2002:a6b:fe03:: with SMTP id x3mr7853639ioh.120.1626884808812;
        Wed, 21 Jul 2021 09:26:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwgzuS9Yi4VtCvnXQZWmI5CguoZwANnXgiGFfIgiUSl1f7p3if1KjZl/ILBiSx0bJnXvz5BQ==
X-Received: by 2002:a6b:fe03:: with SMTP id x3mr7853623ioh.120.1626884808633;
        Wed, 21 Jul 2021 09:26:48 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id m1sm14838987iok.33.2021.07.21.09.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:26:48 -0700 (PDT)
Date:   Wed, 21 Jul 2021 18:26:45 +0200
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
Subject: Re: [PATCH v3 09/12] selftests: KVM: Add support for aarch64 to
 system_counter_offset_test
Message-ID: <20210721162645.5frobtrhtniyanng@gator>
References: <20210719184949.1385910-1-oupton@google.com>
 <20210719184949.1385910-10-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184949.1385910-10-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 06:49:46PM +0000, Oliver Upton wrote:
> KVM/arm64 now allows userspace to adjust the guest virtual counter-timer
> via a vCPU device attribute. Test that changes to the virtual
> counter-timer offset result in the correct view being presented to the
> guest.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/include/aarch64/processor.h | 12 +++++
>  .../kvm/system_counter_offset_test.c          | 54 ++++++++++++++++++-
>  3 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 7bf2e5fb1d5a..d89908108c97 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -96,6 +96,7 @@ TEST_GEN_PROGS_aarch64 += kvm_page_table_test
>  TEST_GEN_PROGS_aarch64 += set_memory_region_test
>  TEST_GEN_PROGS_aarch64 += steal_time
>  TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
> +TEST_GEN_PROGS_aarch64 += system_counter_offset_test
>  
>  TEST_GEN_PROGS_s390x = s390x/memop
>  TEST_GEN_PROGS_s390x += s390x/resets
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 27dc5c2e56b9..3168cdbae6ee 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -129,4 +129,16 @@ void vm_install_sync_handler(struct kvm_vm *vm,
>  
>  #define isb()	asm volatile("isb" : : : "memory")
>  
> +static inline uint64_t read_cntvct_ordered(void)
> +{
> +	uint64_t r;
> +
> +	__asm__ __volatile__("isb\n\t"
> +			     "mrs %0, cntvct_el0\n\t"
> +			     "isb\n\t"
> +			     : "=r"(r));
> +
> +	return r;
> +}
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
> index 7e9015770759..88ad997f5b69 100644
> --- a/tools/testing/selftests/kvm/system_counter_offset_test.c
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -53,7 +53,59 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
>  	return rdtsc() + test->tsc_offset;
>  }
>  
> -#else /* __x86_64__ */
> +#elif __aarch64__ /* __x86_64__ */
> +
> +enum arch_counter {
> +	VIRTUAL,
> +};
> +
> +struct test_case {
> +	enum arch_counter counter;
> +	uint64_t offset;
> +};
> +
> +static struct test_case test_cases[] = {
> +	{ .counter = VIRTUAL, .offset = 0 },
> +	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
> +	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
> +};
> +
> +static void check_preconditions(struct kvm_vm *vm)
> +{
> +	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER))
> +		return;
> +
> +	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_VTIMER not supported; skipping test");
> +	exit(KSFT_SKIP);
> +}
> +
> +static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
> +{
> +	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				KVM_ARM_VCPU_TIMER_OFFSET_VTIMER, &test->offset,
> +				true);
> +}
> +
> +static uint64_t guest_read_system_counter(struct test_case *test)
> +{
> +	switch (test->counter) {
> +	case VIRTUAL:
> +		return read_cntvct_ordered();
> +	default:
> +		GUEST_ASSERT(0);
> +	}
> +
> +	/* unreachable */
> +	return 0;
> +}
> +
> +static uint64_t host_read_guest_system_counter(struct test_case *test)
> +{
> +	return read_cntvct_ordered() - test->offset;
> +}
> +
> +#else /* __aarch64__ */
>  
>  #error test not implemented for this architecture!
>  
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

Reviewed-by: Andrew Jones <drjones@redhat.com>


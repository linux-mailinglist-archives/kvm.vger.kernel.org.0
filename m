Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0FA4044B2
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 07:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350521AbhIIFKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 01:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhIIFKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 01:10:18 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AB9C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 22:09:08 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id l10so683394ilh.8
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 22:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xbj4bHxjm5asqasO4Vc5MjLZ0Sl3pjPtgh9Ovv91F4Q=;
        b=nGJ0Xr7BsULYVjLluGwgpxnkv7l5v9ML6g4sZm6j0Ck/Wc63e5MX9UeWpTexc0+XOb
         GaMJrf05btsC9KlhT9uyiHDMdcwz0vCewRK3pudeocIBWLCqJFRAr7V+BfQDB5e0UYzy
         CXjG+1FkSUaaEHun5Z6hQAMk59Rdsbvga9+EF2lpCiH8tF9rAl+7EtnNcfgPEYusnZbd
         JYglpi1njFXbXwyIhE+1H3+dO3w/8gANwbLp6PK9lwjcpzBiT6LtOGpd7HGe8sMG4KaC
         PCz3KvFpIsKsf969B2lTHEgST1VRrZav0Zjr8bGKH8DEeUe/BEzdz3+BTq/8EPTN+pv1
         S5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xbj4bHxjm5asqasO4Vc5MjLZ0Sl3pjPtgh9Ovv91F4Q=;
        b=7RZrFkKnKQAIFPRcjRT/UnLoMQwTK5oaOxSjHUFz/IO3brFNAjMlwmtalh0/VgRI89
         LgKGQauw/RAwIgIYxHIn5SI085TRwheeMANIsqLwuKJ+qgVHaEShEX/8no6gzA0jBBYh
         krYzZYFow7iVlY2BwUb6B4yatL59GlwUrlD5MDnH4RTHLFKYndj3TAQ+mxyYqr26uztZ
         n8xe0DsupE3y38qTJBKTuTojHVP/bKdXqFPfnVkCDJMpSsVztTcXQCZyZXRCZkhH3apu
         7LnLBNo4cX57+GUI0GGlJr+62222O0CeaKONSVw93vw3Ef3hgtCeWKx8bAP/XUFbO5lI
         MFhw==
X-Gm-Message-State: AOAM530Ijaxw+DywCzdRi7hFy876ONcsGeEvGWTnJKRfNd5049k2Hbz4
        wSZ/eRT4CFIFC59Fje14WStHTg==
X-Google-Smtp-Source: ABdhPJwOXqYFYeLrtyB7/JxA0sr65qpDk6mbK5Ic2/+EtmxUrips9ElJ35ZyMr3Dk5BvHeQ6OyEgow==
X-Received: by 2002:a92:c051:: with SMTP id o17mr918314ilf.308.1631164147930;
        Wed, 08 Sep 2021 22:09:07 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id g12sm381657iok.32.2021.09.08.22.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 22:09:07 -0700 (PDT)
Date:   Thu, 9 Sep 2021 05:09:03 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <YTmW7/pY0E9cHQ+c@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-10-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on. As a result, introduce
> get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> backend, the VMM prepares a map of vcpuid and mpidr during VM
> initialization and exports the map to the guest for it to read.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h |  3 ++
>  .../selftests/kvm/lib/aarch64/processor.c     | 46 +++++++++++++++++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index b6088c3c67a3..150f63101f4c 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -133,6 +133,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
>  		int vector, handler_fn handler);
>  void vm_install_sync_handler(struct kvm_vm *vm,
>  		int vector, int ec, handler_fn handler);
> +void vm_vcpuid_map_init(struct kvm_vm *vm);
>  
>  static inline void cpu_relax(void)
>  {
> @@ -194,4 +195,6 @@ static inline void local_irq_disable(void)
>  	asm volatile("msr daifset, #3" : : : "memory");
>  }
>  
> +int get_vcpuid(void);
> +

I believe both of these functions could use some documentation. The
former has implicit ordering requirements (can only be called after all
vCPUs are created) and the latter can only be used within a guest.

>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..9844b62227b1 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -13,9 +13,17 @@
>  #include "processor.h"
>  
>  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
> +#define VM_VCPUID_MAP_INVAL			-1
>  
>  static vm_vaddr_t exception_handlers;
>  
> +struct vm_vcpuid_map {
> +	uint64_t mpidr;
> +	int vcpuid;
> +};
> +
> +static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
> +

Hmm.

I'm not too big of a fan that the KVM_MAX_VCPUS macro is defined in the
KVM selftests. Really, userspace should discover the limit from the
kernel. Especially when we want to write tests that test behavior at
KVM's limit.

That being said, there are more instances of these static allocations in
the selftests code, so you aren't to be blamed.

Related: commit 074c82c8f7cf ("kvm: x86: Increase MAX_VCPUS to 1024")
has raised this limit.

>  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>  {
>  	return (v + vm->page_size) & ~(vm->page_size - 1);
> @@ -426,3 +434,41 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  	assert(vector < VECTOR_NUM);
>  	handlers->exception_handlers[vector][0] = handler;
>  }
> +
> +void vm_vcpuid_map_init(struct kvm_vm *vm)
> +{
> +	int i = 0;
> +	struct vcpu *vcpu;
> +	struct vm_vcpuid_map *map;
> +
> +	list_for_each_entry(vcpu, &vm->vcpus, list) {
> +		map = &vcpuid_map[i++];
> +		map->vcpuid = vcpu->id;
> +		get_reg(vm, vcpu->id,
> +			ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &map->mpidr);
> +		map->mpidr &= MPIDR_HWID_BITMASK;
> +	}
> +
> +	if (i < KVM_MAX_VCPUS)
> +		vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
> +
> +	sync_global_to_guest(vm, vcpuid_map);
> +}
> +
> +int get_vcpuid(void)

nit: guest_get_vcpuid()

> +{
> +	int i, vcpuid;
> +	uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; i++) {
> +		vcpuid = vcpuid_map[i].vcpuid;
> +		GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
> +
> +		if (mpidr == vcpuid_map[i].mpidr)
> +			return vcpuid;
> +	}
> +
> +	/* We should not be reaching here */
> +	GUEST_ASSERT_1(0, mpidr);
> +	return -1;
> +}
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

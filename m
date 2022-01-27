Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151AF49DBD6
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 08:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbiA0HqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 02:46:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237442AbiA0HqV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 02:46:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643269581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wQwFTIAyd79VtHoizQt/7QTJxDg0e/CzlZ208FfbldU=;
        b=UAARByOqPIKTLVVJPFzvjP7L2BBz47D7efAKj9z1sIFTl72v3gdwozZ9aGaxXAJhQacl7P
        ZHF5R+ynU8gSFXA9dQJBYOPPb9Zy14/IcpMCGU1BZ0jbRashc/JIdT0Kfslm9wdBMovVrD
        B4ydNgK8wr+eoc1mrKKzmZC6yICt0XE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-q1NVkOCzPrS5cvVExBFhIA-1; Thu, 27 Jan 2022 02:46:19 -0500
X-MC-Unique: q1NVkOCzPrS5cvVExBFhIA-1
Received: by mail-ed1-f70.google.com with SMTP id k5-20020a508ac5000000b00408dec8390aso957578edk.13
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 23:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wQwFTIAyd79VtHoizQt/7QTJxDg0e/CzlZ208FfbldU=;
        b=sFdjVaByay7q+OQdzQ/eFgoPZspKNAWIvvx+vW246o7tf6+1K3oUnGpSJ0LA5iLafm
         PS/eytMPgrC2EVdh8bnCKrC4dn/eSs7CpnHRmYpHo3yphI+iSI/23NTDj5K8mUxQcMKE
         iD0KHmG11hbMNrtmaWxlMOcs7v0J4WtYamUFuEN/9wEyIeJBe2CfGJfIwzGBS7j/wkvQ
         yu2FKt6ZZR6pHfOMOMT1PeRvhGXyAgmOWdHTgJNQOfrJldy/pnCrjs2tpYTudc8y0SSP
         w2SMBaH5dMysacXnqniX6ocgtju8SnrOCJk1YVtO46zpXAqMDHafuRo9kv73rw7ByZzX
         3ypw==
X-Gm-Message-State: AOAM5325PXvpyKDIgnYfUtUafO2mMo/BhdHjB8t0MAvk3NycKukiAx0j
        AN6HwL0lpLQZaRk/hbJWDBxQxQM/lZv9jWjQtXoS/zE/HJOK2lcjX/9bgLRoZNzEaEBEQYmJ6hM
        8/a49zVE6LuQG
X-Received: by 2002:a05:6402:387:: with SMTP id o7mr2404984edv.253.1643269578643;
        Wed, 26 Jan 2022 23:46:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiTsNUx+1fk3/qVodbUrliRUrODZ3coLKh7ubQ0zyxCrbDSGtlHbcVOBgwZ1rTbx2jOM2Nsw==
X-Received: by 2002:a05:6402:387:: with SMTP id o7mr2404974edv.253.1643269578445;
        Wed, 26 Jan 2022 23:46:18 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id w24sm3493194edu.97.2022.01.26.23.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:46:18 -0800 (PST)
Date:   Thu, 27 Jan 2022 08:46:16 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 2/5] kvm: selftests: aarch64: pass vgic_irq guest args
 as a pointer
Message-ID: <20220127074616.vyjf2elhcrx4ptfw@gator>
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127030858.3269036-3-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 07:08:55PM -0800, Ricardo Koller wrote:
> The guest in vgic_irq gets its arguments in a struct. This struct used
> to fit nicely in a single register so vcpu_args_set() was able to pass
> it by value by setting x0 with it.

Ouch.

> Unfortunately, this args struct grew
> after some commits and some guest args became random (specically
> kvm_supports_irqfd).
> 
> Fix this by passing the guest args as a pointer (after allocating some
> guest memory for it).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_irq.c  | 29 ++++++++++---------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index e6c7d7f8fbd1..b701eb80128d 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -472,10 +472,10 @@ static void test_restore_active(struct test_args *args, struct kvm_inject_desc *
>  		guest_restore_active(args, MIN_SPI, 4, f->cmd);
>  }
>  
> -static void guest_code(struct test_args args)
> +static void guest_code(struct test_args *args)
>  {
> -	uint32_t i, nr_irqs = args.nr_irqs;
> -	bool level_sensitive = args.level_sensitive;
> +	uint32_t i, nr_irqs = args->nr_irqs;
> +	bool level_sensitive = args->level_sensitive;
>  	struct kvm_inject_desc *f, *inject_fns;
>  
>  	gic_init(GIC_V3, 1, dist, redist);
> @@ -484,11 +484,11 @@ static void guest_code(struct test_args args)
>  		gic_irq_enable(i);
>  
>  	for (i = MIN_SPI; i < nr_irqs; i++)
> -		gic_irq_set_config(i, !args.level_sensitive);
> +		gic_irq_set_config(i, !level_sensitive);
>  
> -	gic_set_eoi_split(args.eoi_split);
> +	gic_set_eoi_split(args->eoi_split);
>  
> -	reset_priorities(&args);
> +	reset_priorities(args);
>  	gic_set_priority_mask(CPU_PRIO_MASK);
>  
>  	inject_fns  = level_sensitive ? inject_level_fns
> @@ -497,17 +497,17 @@ static void guest_code(struct test_args args)
>  	local_irq_enable();
>  
>  	/* Start the tests. */
> -	for_each_supported_inject_fn(&args, inject_fns, f) {
> -		test_injection(&args, f);
> -		test_preemption(&args, f);
> -		test_injection_failure(&args, f);
> +	for_each_supported_inject_fn(args, inject_fns, f) {
> +		test_injection(args, f);
> +		test_preemption(args, f);
> +		test_injection_failure(args, f);
>  	}
>  
>  	/* Restore the active state of IRQs. This would happen when live
>  	 * migrating IRQs in the middle of being handled.
>  	 */
> -	for_each_supported_activate_fn(&args, set_active_fns, f)
> -		test_restore_active(&args, f);
> +	for_each_supported_activate_fn(args, set_active_fns, f)
> +		test_restore_active(args, f);
>  
>  	GUEST_DONE();
>  }
> @@ -739,6 +739,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
>  	int gic_fd;
>  	struct kvm_vm *vm;
>  	struct kvm_inject_args inject_args;
> +	vm_vaddr_t args_gva;
>  
>  	struct test_args args = {
>  		.nr_irqs = nr_irqs,
> @@ -757,7 +758,9 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);
>  
>  	/* Setup the guest args page (so it gets the args). */
> -	vcpu_args_set(vm, 0, 1, args);
> +	args_gva = vm_vaddr_alloc_page(vm);
> +	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
> +	vcpu_args_set(vm, 0, 1, args_gva);
>  
>  	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
>  			GICD_BASE_GPA, GICR_BASE_GPA);
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>


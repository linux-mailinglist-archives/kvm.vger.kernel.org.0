Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35854000B7
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhICNpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 09:45:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235009AbhICNo5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 09:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630676637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FoGa/Z3fE7f3WlDXPF9Tp6VGKV9agCjc0SH7CPYWNiM=;
        b=Tl3Y8+A0CqBYFX8pLFqLRkg+T8BfHVjlqSjzYDErVlV3Mz9nfoY6b5kjdeDCpUTYDRygNU
        2k4PSvkB7EorJ11nDYoWzENySyE8TNeA+Iq/S2QsRPTIBwh3QXg0JUrUIf71RtuR22Wqk1
        ogR2LLy+9/nI44MeuMkpMwdf7XJaBB0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-dEmo8gyaOzeGOR5bmuGwxA-1; Fri, 03 Sep 2021 09:43:56 -0400
X-MC-Unique: dEmo8gyaOzeGOR5bmuGwxA-1
Received: by mail-wm1-f70.google.com with SMTP id a201-20020a1c7fd2000000b002e748bf0544so2695566wmd.2
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 06:43:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FoGa/Z3fE7f3WlDXPF9Tp6VGKV9agCjc0SH7CPYWNiM=;
        b=kk2F7SP6BcKIEAJqkYetAkyjYG5o1ykotDVVK1tFDXjlhkkeWhewBfOUHILxEQ/j+/
         6b1gJXxCF6eWf58iuT1zu6iKhZT3DjS54g0fTwLP2WIA+tCAoPc9TKzyfn2QHGoXyXA3
         6JDE12Wl4bmdQKzIY3SPpw3vHUzd6kULWaleL6XaTxv15MVw4RmIaEkRkv7LTWlubfEw
         DlsyzdkvqgXUFmtCZrph0c8VTnogR+KraZMoYrdIqEvK6qZcCDqyMcZoEVVJpClB2YLL
         hCQRwtXdl1pmgC61UCcpqHeszUr5Xkl4ON2GC9QyTXEyGO028F0TwmLIl2ZNinkpVWC5
         OJCA==
X-Gm-Message-State: AOAM531LI5gsqmCDyjM7BbCK0LNj8Q491wicbgRaOU5DwAHFgtoTV4ii
        aEH/sA0SbjGQgJqEbIU0jNAlmVwbE8EXConcARGWZa2/Hab/3bYdTjUwHS0kiU5JEFhvKf7K9oq
        PvL8mJ7Rkdm5i
X-Received: by 2002:a7b:c197:: with SMTP id y23mr8615685wmi.135.1630676634998;
        Fri, 03 Sep 2021 06:43:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySvrtQAeDjSb3PCbi4cUGEkH5oPIewT8k1/scS7t1Nrphw0caNP0eRw8E00YHp3LiTAxQivA==
X-Received: by 2002:a7b:c197:: with SMTP id y23mr8615661wmi.135.1630676634697;
        Fri, 03 Sep 2021 06:43:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c4sm5291659wme.14.2021.09.03.06.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 06:43:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     maz@kernel.org, ehabkost@redhat.com,
        Juergen Gross <jgross@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 2/6] x86/kvm: add boot parameter for adding vcpu-id bits
In-Reply-To: <20210903130808.30142-3-jgross@suse.com>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-3-jgross@suse.com>
Date:   Fri, 03 Sep 2021 15:43:52 +0200
Message-ID: <874kb1n59j.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juergen Gross <jgross@suse.com> writes:

> Today the maximum vcpu-id of a kvm guest's vcpu on x86 systems is set
> via a #define in a header file.
>
> In order to support higher vcpu-ids without generally increasing the
> memory consumption of guests on the host (some guest structures contain
> arrays sized by KVM_MAX_VCPU_ID) add a boot parameter for adding some
> bits to the vcpu-id. Additional bits are needed as the vcpu-id is
> constructed via bit-wise concatenation of socket-id, core-id, etc.
> As those ids maximum values are not always a power of 2, the vcpu-ids
> are sparse.
>
> The additional number of bits needed is basically the number of
> topology levels with a non-power-of-2 maximum value, excluding the top
> most level.
>
> The default value of the new parameter will be to take the correct
> setting from the host's topology.
>
> Calculating the maximum vcpu-id dynamically requires to allocate the
> arrays using KVM_MAX_VCPU_ID as the size dynamically.
>
> Signed-of-by: Juergen Gross <jgross@suse.com>
> ---
> V2:
> - switch to specifying additional bits (based on comment by Vitaly
>   Kuznetsov)
>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  .../admin-guide/kernel-parameters.txt         | 18 ++++++++++++
>  arch/x86/include/asm/kvm_host.h               |  4 ++-
>  arch/x86/kvm/ioapic.c                         | 12 +++++++-
>  arch/x86/kvm/ioapic.h                         |  4 +--
>  arch/x86/kvm/x86.c                            | 29 +++++++++++++++++++
>  5 files changed, 63 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 84dc5790741b..37e194299311 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2435,6 +2435,24 @@
>  			feature (tagged TLBs) on capable Intel chips.
>  			Default is 1 (enabled)
>  
> +	kvm.vcpu_id_add_bits=
> +			[KVM,X86] The vcpu-ids of guests are sparse, as they
> +			are constructed by bit-wise concatenation of the ids of
> +			the different topology levels (sockets, cores, threads).
> +
> +			This parameter specifies how many additional bits the
> +			maximum vcpu-id needs compared to the maximum number of
> +			vcpus.
> +
> +			Normally this value is the number of topology levels
> +			without the threads level and without the highest
> +			level.
> +
> +			The special value -1 can be used to support guests
> +			with the same topology is the host.
> +
> +			Default: -1
> +
>  	l1d_flush=	[X86,INTEL]
>  			Control mitigation for L1D based snooping vulnerability.
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index af6ce8d4c86a..3513edee8e22 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -39,7 +39,7 @@
>  
>  #define KVM_MAX_VCPUS 288
>  #define KVM_SOFT_MAX_VCPUS 240
> -#define KVM_MAX_VCPU_ID 1023
> +#define KVM_MAX_VCPU_ID kvm_max_vcpu_id()
>  /* memory slots that are not exposed to userspace */
>  #define KVM_PRIVATE_MEM_SLOTS 3
>  
> @@ -1588,6 +1588,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
>  extern u64  kvm_default_tsc_scaling_ratio;
>  /* bus lock detection supported? */
>  extern bool kvm_has_bus_lock_exit;
> +/* maximum vcpu-id */
> +unsigned int kvm_max_vcpu_id(void);
>  
>  extern u64 kvm_mce_cap_supported;
>  
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index ff005fe738a4..52e8ea90c914 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -685,11 +685,21 @@ static const struct kvm_io_device_ops ioapic_mmio_ops = {
>  int kvm_ioapic_init(struct kvm *kvm)
>  {
>  	struct kvm_ioapic *ioapic;
> +	size_t sz;
>  	int ret;
>  
> -	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL_ACCOUNT);
> +	sz = sizeof(struct kvm_ioapic) +
> +	     sizeof(*ioapic->rtc_status.dest_map.map) *
> +		    BITS_TO_LONGS(KVM_MAX_VCPU_ID + 1) +
> +	     sizeof(*ioapic->rtc_status.dest_map.vectors) *
> +		    (KVM_MAX_VCPU_ID + 1);
> +	ioapic = kzalloc(sz, GFP_KERNEL_ACCOUNT);
>  	if (!ioapic)
>  		return -ENOMEM;
> +	ioapic->rtc_status.dest_map.map = (void *)(ioapic + 1);
> +	ioapic->rtc_status.dest_map.vectors =
> +		(void *)(ioapic->rtc_status.dest_map.map +
> +			 BITS_TO_LONGS(KVM_MAX_VCPU_ID + 1));
>  	spin_lock_init(&ioapic->lock);
>  	INIT_DELAYED_WORK(&ioapic->eoi_inject, kvm_ioapic_eoi_inject_work);
>  	kvm->arch.vioapic = ioapic;
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index bbd4a5d18b5d..623a3c5afad7 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -39,13 +39,13 @@ struct kvm_vcpu;
>  
>  struct dest_map {
>  	/* vcpu bitmap where IRQ has been sent */
> -	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
> +	unsigned long *map;
>  
>  	/*
>  	 * Vector sent to a given vcpu, only valid when
>  	 * the vcpu's bit in map is set
>  	 */
> -	u8 vectors[KVM_MAX_VCPU_ID + 1];
> +	u8 *vectors;
>  };
>  
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..6b6f38f0b617 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -78,6 +78,7 @@
>  #include <asm/intel_pt.h>
>  #include <asm/emulate_prefix.h>
>  #include <asm/sgx.h>
> +#include <asm/topology.h>
>  #include <clocksource/hyperv_timer.h>
>  
>  #define CREATE_TRACE_POINTS
> @@ -184,6 +185,34 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
>  int __read_mostly pi_inject_timer = -1;
>  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  
> +static int __read_mostly vcpu_id_add_bits = -1;
> +module_param(vcpu_id_add_bits, int, S_IRUGO);
> +
> +unsigned int kvm_max_vcpu_id(void)
> +{
> +	int n_bits = fls(KVM_MAX_VCPUS - 1);
> +
> +	if (vcpu_id_add_bits < -1 || vcpu_id_add_bits > (32 - n_bits)) {
> +		pr_err("Invalid value of vcpu_id_add_bits=%d parameter!\n",
> +		       vcpu_id_add_bits);
> +		vcpu_id_add_bits = -1;
> +	}
> +
> +	if (vcpu_id_add_bits >= 0) {
> +		n_bits += vcpu_id_add_bits;
> +	} else {
> +		n_bits++;		/* One additional bit for core level. */
> +		if (topology_max_die_per_package() > 1)
> +			n_bits++;	/* One additional bit for die level. */

This assumes topology_max_die_per_package() can not be greater than 2,
or 1 additional bit may not suffice, right?

> +	}
> +
> +	if (!n_bits)
> +		n_bits = 1;

Nitpick: AFAIU n_bits can't be zero here as KVM_MAX_VCPUS is still
static. The last patch of the series, however, makes it possible when
max_vcpus = 1 and vcpu_id_add_bits = 0. With this, I'd suggest to move
the check to the last patch.

> +
> +	return (1U << n_bits) - 1;
> +}
> +EXPORT_SYMBOL_GPL(kvm_max_vcpu_id);
> +
>  /*
>   * Restoring the host value for MSRs that are only consumed when running in
>   * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU

-- 
Vitaly


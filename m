Return-Path: <kvm+bounces-5100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 245BC81BD6E
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 18:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D14AD2898E0
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 17:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D553A634E2;
	Thu, 21 Dec 2023 17:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYrEOObV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E4B62813
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703180362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QFQXXpRys8WU42WqrlmupknTZ9L+If8erTKi3t1kY7c=;
	b=NYrEOObVd8BuA1FDijaepTmzodANHHKArM5beU+SX6WzBXRjl54PIlnkRPsKUD8uvBkLsG
	sDI/PHn/4rOHkGwCCk/6fVcfZYoaZlYdO17koS9en5H3qzHfUHf/BBi3YZNXjaZuf4OLna
	m1v8pdibEpVbWtQnN2AoyYgVQnl4AUA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-U4UV116SNhOO7vrS6jp_CA-1; Thu, 21 Dec 2023 12:39:20 -0500
X-MC-Unique: U4UV116SNhOO7vrS6jp_CA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50e5195db01so825392e87.3
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 09:39:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703180356; x=1703785156;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QFQXXpRys8WU42WqrlmupknTZ9L+If8erTKi3t1kY7c=;
        b=Q7VUaA8q8vftkmncwZ/j25jGG/98wRv1HU+DTQJW+O2iXdn82ZWQJUxCHgqmN1sDDj
         Y5tr8TuN1mLBr7kHJIaq5A85EQuQErg92ymTAywFB8wBxYGh3Cn6Pbt3vZmPyNAO2zrS
         WGxFeiQfyyHU6JsgamE8VWa8ORenxVhkZloRqQwsh8NRPY/06XGsQAx+E4Fym7rMz4hl
         gYPU9ZiJglxRECMfYuAq1QTw0wJhWB1Ab189QDzQtn+k/UWGLWG74hP5ZpIRWNbqIydr
         pCHRZEkaBSZEXSmLsMx/3Axb2yCV74Bqw8OVyvDsAhws+pohm62hu2Sva2i3to4Jufhn
         q/BQ==
X-Gm-Message-State: AOJu0YzBRWxnCGhpUddjV1ml5kLoaWfvaFlrqYW/cUzSlRVRB1A2/PMI
	2Y9IxSt4rWye8hTX8uUvfvTnqE3rlR3EojH1WEuwRlb+RyeiRq4CrmuBmGO6lZeyqf88BFzDKK5
	cTSoctJCS4Gae
X-Received: by 2002:a05:6512:10cd:b0:50e:4b79:d0f7 with SMTP id k13-20020a05651210cd00b0050e4b79d0f7mr3174297lfg.125.1703180356341;
        Thu, 21 Dec 2023 09:39:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVBbN7miAHvpvpy3SXRnCdAgvWogwc3UDqdW/skEJabiL1g+vUsuaA39/TNy2kd8e5zik1MA==
X-Received: by 2002:a05:6512:10cd:b0:50e:4b79:d0f7 with SMTP id k13-20020a05651210cd00b0050e4b79d0f7mr3174294lfg.125.1703180356154;
        Thu, 21 Dec 2023 09:39:16 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id j26-20020a170906411a00b00a26aaad6618sm630767ejk.35.2023.12.21.09.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 09:39:15 -0800 (PST)
Message-ID: <6a9b28efdeac82dca046ea964933a31a428a59b2.camel@redhat.com>
Subject: Re: [PATCH v3 2/4] KVM: x86: Make the APIC bus cycles per nsec VM
 variable
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>, Vishal
 Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@gmail.com
Date: Thu, 21 Dec 2023 19:39:13 +0200
In-Reply-To: <d989708bacb78dc22deaf3f1520a876551eb97e7.1702974319.git.isaku.yamahata@intel.com>
References: <cover.1702974319.git.isaku.yamahata@intel.com>
	 <d989708bacb78dc22deaf3f1520a876551eb97e7.1702974319.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-12-19 at 00:34 -0800, Isaku Yamahata wrote:
> Introduce the VM variable of the APIC cycles per nano second as the
> preparation to make the APIC APIC bus frequency configurable.
> 
> The TDX architecture hard-codes the APIC bus frequency to 25MHz in the
> CPUID leaf 0x15.  The TDX mandates it to be exposed and doesn't allow the
> VMM to override its value.  The KVM APIC timer emulation hard-codes the
> frequency to 1GHz.  To ensure that the guest doesn't have a conflicting
> view of the APIC bus frequency, allow the userspace to tell KVM to use the
> same frequency that TDX mandates instead of the default 1Ghz.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes v3:
> - Update commit message.
> - Dropped apic_bus_frequency according to Maxim Levitsky.

Looks good to me, thanks!



> 
> Changes v2:
> - no change.
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/hyperv.c           | 3 ++-
>  arch/x86/kvm/lapic.c            | 6 ++++--
>  arch/x86/kvm/lapic.h            | 2 +-
>  arch/x86/kvm/x86.c              | 1 +
>  5 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d7036982332e..45ee7a1d13f6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1334,6 +1334,7 @@ struct kvm_arch {
>  
>  	u32 default_tsc_khz;
>  	bool user_set_tsc;
> +	u64 apic_bus_cycle_ns;
>  
>  	seqcount_raw_spinlock_t pvclock_sc;
>  	bool use_master_clock;
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a40ca2fef58c..37ff31c18ad1 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1687,7 +1687,8 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>  		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
>  		break;
>  	case HV_X64_MSR_APIC_FREQUENCY:
> -		data = div64_u64(1000000000ULL, APIC_BUS_CYCLE_NS);
> +		data = div64_u64(1000000000ULL,
> +				 vcpu->kvm->arch.apic_bus_cycle_ns);
>  		break;
>  	default:
>  		kvm_pr_unimpl_rdmsr(vcpu, msr);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 245b20973cae..73956b0ac1f1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1542,7 +1542,8 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
>  		remaining = 0;
>  
>  	ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
> -	return div64_u64(ns, (APIC_BUS_CYCLE_NS * apic->divide_count));
> +	return div64_u64(ns, (apic->vcpu->kvm->arch.apic_bus_cycle_ns *
> +			      apic->divide_count));
>  }
>  
>  static void __report_tpr_access(struct kvm_lapic *apic, bool write)
> @@ -1960,7 +1961,8 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>  
>  static inline u64 tmict_to_ns(struct kvm_lapic *apic, u32 tmict)
>  {
> -	return (u64)tmict * APIC_BUS_CYCLE_NS * (u64)apic->divide_count;
> +	return (u64)tmict * apic->vcpu->kvm->arch.apic_bus_cycle_ns *
> +		(u64)apic->divide_count;
>  }
>  
>  static void update_target_expiration(struct kvm_lapic *apic, uint32_t old_divisor)
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index a20cb006b6c8..51e09f5a7fc5 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -16,7 +16,7 @@
>  #define APIC_DEST_NOSHORT		0x0
>  #define APIC_DEST_MASK			0x800
>  
> -#define APIC_BUS_CYCLE_NS       1
> +#define APIC_BUS_CYCLE_NS_DEFAULT	1
>  
>  #define APIC_BROADCAST			0xFF
>  #define X2APIC_BROADCAST		0xFFFFFFFFul
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1a3aaa7dafae..d7d865f7c847 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12466,6 +12466,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  
>  	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
> +	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
>  	kvm->arch.guest_can_read_msr_platform_info = true;
>  	kvm->arch.enable_pmu = enable_pmu;
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




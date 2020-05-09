Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BD71CC1B7
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 15:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEINRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 09:17:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33770 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726807AbgEINRZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 09:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589030243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uCLyaQCySXTUpxpAFplPmWsaUsPQcDPR7pzHn1NvsX4=;
        b=du44UXfFpg4c8uyUmjP6O7rzZW+3JxW6IED59w+O2EmBYCEIbvh/Eou9kPOUU7MDXH9MJA
        RAx8qtCn/FCTUCLPzi/ZIxrR6WFsz60m2q9jBmXID09pK2EIQ7F3WtmGFuwQeSsYPzF2QM
        RAPU0ww+uvCnIMhZ9JIy/LNLaXX0jlI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-328UObAnPOGuH_9E6L5g0Q-1; Sat, 09 May 2020 09:17:21 -0400
X-MC-Unique: 328UObAnPOGuH_9E6L5g0Q-1
Received: by mail-wr1-f69.google.com with SMTP id u4so2372944wrm.13
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 06:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uCLyaQCySXTUpxpAFplPmWsaUsPQcDPR7pzHn1NvsX4=;
        b=RSogCf4c3bNAErfuZtHH8q4YbKsiDdP771kORcbjJJlETI7AJ0LIyzJc5pjRlcM/tg
         l6VghvPiRM2kXfImWXrTpIh4j7imxFOG196Y20phY3be67xNGVDHtxwWRTHZh9lSIOie
         4Nf+EowF9aXGc2/h1cvpVM4k8xDIiS/LxiUIVF9Y+v5B3vaBulx3BZ63e0gSNNQiQP/C
         8ibeA4wGXdW6hGhYdCWFaOlaP/iRTUP2qrxJqGd3HO21Hzk51hgRunMCIPgFDeDDYQVG
         whoi5UNVNdExw6+wT7kXj0ogmiZZ8giy1Skc5nd3YA/iyuhnqj5+kgzaS7mkrBUAvTiB
         u2pw==
X-Gm-Message-State: AGi0PuZ+wosq5WIf2XWUUPbhNgcR42/kFB5URzJphrszidxYnmpwsMJC
        T2kVfMEb5cB5XkOEJjPAyde6vN0NtqwR4uN0FvwYeCvhZbsEvprZGOPV0ZUYVcV+3oH6A5ag/Me
        V23jOw7gQeI79
X-Received: by 2002:adf:df8a:: with SMTP id z10mr8469590wrl.344.1589030240403;
        Sat, 09 May 2020 06:17:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypLbkVXFck43nu/zbBC6iGfJ3Erup3sWfp7QSwCV9V/SwOv0QE9Nt24katXNDUPNO3xLkfHMQw==
X-Received: by 2002:adf:df8a:: with SMTP id z10mr8469566wrl.344.1589030240152;
        Sat, 09 May 2020 06:17:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id b2sm2478867wrm.30.2020.05.09.06.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 06:17:19 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM: nVMX: Migrate the VMX-preemption timer
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>
References: <20200508203643.85477-1-jmattson@google.com>
 <20200508203643.85477-4-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <15f540b0-de10-6ccc-1c50-9bba3bdede56@redhat.com>
Date:   Sat, 9 May 2020 15:17:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508203643.85477-4-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/20 22:36, Jim Mattson wrote:
> The hrtimer used to emulate the VMX-preemption timer must be pinned to
> the same logical processor as the vCPU thread to be interrupted if we
> want to have any hope of adhering to the architectural specification
> of the VMX-preemption timer. Even with this change, the emulated
> VMX-preemption timer VM-exit occasionally arrives too late.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/irq.c              |  2 ++
>  arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..a47c71d13039 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1254,6 +1254,8 @@ struct kvm_x86_ops {
>  
>  	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>  	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> +
> +	void (*migrate_timers)(struct kvm_vcpu *vcpu);
>  };
>  
>  struct kvm_x86_init_ops {
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index e330e7d125f7..54f7ea68083b 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -159,6 +159,8 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
>  {
>  	__kvm_migrate_apic_timer(vcpu);
>  	__kvm_migrate_pit_timer(vcpu);
> +	if (kvm_x86_ops.migrate_timers)
> +		kvm_x86_ops.migrate_timers(vcpu);
>  }
>  
>  bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2c6335a998c..3896dea72082 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7687,6 +7687,16 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  	return to_vmx(vcpu)->nested.vmxon;
>  }
>  
> +static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
> +{
> +	if (is_guest_mode(vcpu)) {
> +		struct hrtimer *timer = &to_vmx(vcpu)->nested.preemption_timer;
> +
> +		if (hrtimer_try_to_cancel(timer) == 1)
> +			hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
> +	}
> +}
> +
>  static void hardware_unsetup(void)
>  {
>  	if (nested)
> @@ -7838,6 +7848,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.nested_get_evmcs_version = NULL,
>  	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
>  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
> +	.migrate_timers = vmx_migrate_timers,
>  };
>  
>  static __init int hardware_setup(void)
> 

Queued all, thanks.

Paolo


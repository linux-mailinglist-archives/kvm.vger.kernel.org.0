Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E60B019E
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 18:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfIKQ0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 12:26:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbfIKQ0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 12:26:21 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1ABDC058CB8
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 16:26:20 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id s5so10651791wrv.23
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 09:26:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eyaijbgIkayhX4PjBUU3nGz4VJDOHf43oHAeZt11sYU=;
        b=MA2D5EpOwzKNCFtS0CzRJb2PpzPZlWdoREiQbmXgWEbCfisfrPS8+UWPfTBJVH+CLV
         /+4CTpnquvXEEYLI0k+43H1Yz02bIHueXwlt84DymQbAfJ2ZezlsR4+KHA06hxC4Kn2D
         b3TbZo+WAeKTtxYupX2IY60OTCJ3dB77K/rJeWyhlp1BpuTCI1/4NjEArUStRoXs/3k1
         1emwad7nQalcvy2DssL64B1kcXRDSyl9L28MEcJS7DAlzs3Ka8qiPcV8QZKftFwPYZbU
         2V0BSoNs61M9wV0rYdcoBBeub37qTVv86gIH/+Df0Xr+Bz/f3M25XyQkbn+koN7ZCj5g
         j0aQ==
X-Gm-Message-State: APjAAAVKVFCXRlRMzvjdk07r8HIi/ea8XjkKx+XvnGq16bWBswfQCVQw
        WdXEfW5sVvP7tu5fDmBxFD2XO6S4xs3tYJPXMBcimwjAubELsRWgVcU7gblDkDzAPxNKQFnioQ2
        LvLCc2J9ahK13
X-Received: by 2002:a7b:c764:: with SMTP id x4mr4315434wmk.134.1568219179296;
        Wed, 11 Sep 2019 09:26:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwOAVygTquC9Ou/lQms9cBy79Ajfv+C5hPogGsEA3YLASjZm7mPMsJdoVNRdV9fJe20qtNpDg==
X-Received: by 2002:a7b:c764:: with SMTP id x4mr4315419wmk.134.1568219179035;
        Wed, 11 Sep 2019 09:26:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id 17sm16247400wrl.15.2019.09.11.09.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 09:26:18 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] KVM: hyperv: Fix Direct Synthetic timers assert an
 interrupt w/o lapic_in_kernel
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1567733404-7759-1-git-send-email-wanpengli@tencent.com>
 <1567733404-7759-5-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9d244f84-93d3-5e1b-7222-aebb270f3f29@redhat.com>
Date:   Wed, 11 Sep 2019 18:26:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567733404-7759-5-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/19 03:30, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
> 	kasan: GPF could be caused by NULL-ptr deref or user memory access
> 	general protection fault: 0000 [#1] PREEMPT SMP KASAN
> 	RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
> 	Call Trace:
> 	kvm_apic_set_irq+0xb4/0x140 arch/x86/kvm/lapic.c:558
> 	stimer_notify_direct arch/x86/kvm/hyperv.c:648 [inline]
> 	stimer_expiration arch/x86/kvm/hyperv.c:659 [inline]
> 	kvm_hv_process_stimers+0x594/0x1650 arch/x86/kvm/hyperv.c:686
> 	vcpu_enter_guest+0x2b2a/0x54b0 arch/x86/kvm/x86.c:7896
> 	vcpu_run+0x393/0xd40 arch/x86/kvm/x86.c:8152
> 	kvm_arch_vcpu_ioctl_run+0x636/0x900 arch/x86/kvm/x86.c:8360
> 	kvm_vcpu_ioctl+0x6cf/0xaf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765
> 
> The testcase programs HV_X64_MSR_STIMERn_CONFIG/HV_X64_MSR_STIMERn_COUNT,
> in addition, there is no lapic in the kernel, the counters value are small
> enough in order that kvm_hv_process_stimers() inject this already-expired
> timer interrupt into the guest through lapic in the kernel which triggers
> the NULL deferencing. This patch fixes it by don't advertise direct mode 
> synthetic timers and discarding the inject when lapic is not in kernel.
> 
> Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * don't advertise direct mode synthetic timers when lapic is not in kernel
> 
>  arch/x86/kvm/hyperv.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index c10a8b1..069e655 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -645,7 +645,9 @@ static int stimer_notify_direct(struct kvm_vcpu_hv_stimer *stimer)
>  		.vector = stimer->config.apic_vector
>  	};
>  
> -	return !kvm_apic_set_irq(vcpu, &irq, NULL);
> +	if (lapic_in_kernel(vcpu))
> +		return !kvm_apic_set_irq(vcpu, &irq, NULL);
> +	return 0;
>  }
>  
>  static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)
> @@ -1849,7 +1851,13 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  
>  			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>  			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
> -			ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
> +
> +			/*
> +			 * Direct Synthetic timers only make sense with in-kernel
> +			 * LAPIC
> +			 */
> +			if (lapic_in_kernel(vcpu))
> +				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
>  
>  			break;
>  
> 

See replies to the previous version of the individual patches.

Paolo

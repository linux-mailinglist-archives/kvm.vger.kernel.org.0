Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F83D5568
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 11:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbfJMJGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 05:06:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbfJMJGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 05:06:32 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 384F2C0568FA
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 09:06:31 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id w2so7058319wrn.4
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 02:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VqGJ+hSukCwxrY9wctom7RVU8clkF/NcvjQS4FJ08d8=;
        b=cXN4SOj6ow5eJn0i8yFE0IZydge9fn4C9AoYqxx7ZEN4beul/0BDRnFCrYrTAh387/
         gxvYFFc76aA4siRaioJDdt2ds9b72g9HUY0Kmm5JwaW8ZILAgX9H35iVgGioaLOSM3N5
         rFaYkFVPQfE8JdPo4HYhDwHBSG7w055bAuV+9Ywe3nzmLpMqUSKIebltlP06FEAhOI5s
         N5Ss7CtCTfkgjGeXLvov/0U/vnIvQWj6mCIoTVbh86iadboWTZE2Mtv60A3senzRA1O6
         HCXyfm9zCjJx7J43lrsrKGdfxskFRjG26DBkHw3ggk0B+FJqa2U8450WwDLUkXgd/sSz
         XVRw==
X-Gm-Message-State: APjAAAUfdMggML+d1BF+59o7pbJAj8KZZGm+qJCEeMAUlek4clwv2NQn
        6Z7mI+DmLtkGTsiCGkxJaVwpup4jrRoMrQzWNlTlNiudBCXPXk642q30t2zb760Tqq0vx8vPgNN
        fe3D2sTkSxUBl
X-Received: by 2002:a1c:a556:: with SMTP id o83mr11323957wme.0.1570957589790;
        Sun, 13 Oct 2019 02:06:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx9H7YU924Gq8Q6Bdsu5/sBl5aGWk9k6285SStbrDxHGELMBwGpeswMbxzpq3J1tU1U+Tx6Gg==
X-Received: by 2002:a1c:a556:: with SMTP id o83mr11323930wme.0.1570957589541;
        Sun, 13 Oct 2019 02:06:29 -0700 (PDT)
Received: from vitty.brq.redhat.com ([95.82.135.110])
        by smtp.gmail.com with ESMTPSA id z189sm25692604wmc.25.2019.10.13.02.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 02:06:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, peterz@infradead.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5 2/5] x86/kvm: Change print code to use pr_*() format
In-Reply-To: <1570439071-9814-3-git-send-email-zhenzhong.duan@oracle.com>
References: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com> <1570439071-9814-3-git-send-email-zhenzhong.duan@oracle.com>
Date:   Sun, 13 Oct 2019 11:06:26 +0200
Message-ID: <87lftp5819.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zhenzhong Duan <zhenzhong.duan@oracle.com> writes:

> pr_*() is preferred than printk(KERN_* ...), after change all the print
> in arch/x86/kernel/kvm.c will have "kvm_guest: xxx" style.
>
> No functional change.
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/kernel/kvm.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 3bc6a266..ef836d6 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -7,6 +7,8 @@
>   *   Authors: Anthony Liguori <aliguori@us.ibm.com>
>   */
>  
> +#define pr_fmt(fmt) "kvm_guest: " fmt
> +
>  #include <linux/context_tracking.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> @@ -286,8 +288,8 @@ static void kvm_register_steal_time(void)
>  		return;
>  
>  	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
> -	pr_info("kvm-stealtime: cpu %d, msr %llx\n",
> -		cpu, (unsigned long long) slow_virt_to_phys(st));
> +	pr_info("stealtime: cpu %d, msr %llx\n", cpu,
> +		(unsigned long long) slow_virt_to_phys(st));
>  }
>  
>  static DEFINE_PER_CPU_DECRYPTED(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
> @@ -321,8 +323,7 @@ static void kvm_guest_cpu_init(void)
>  
>  		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
>  		__this_cpu_write(apf_reason.enabled, 1);
> -		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
> -		       smp_processor_id());
> +		pr_info("setup async PF for cpu %d\n", smp_processor_id());
>  	}
>  
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
> @@ -347,8 +348,7 @@ static void kvm_pv_disable_apf(void)
>  	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
>  	__this_cpu_write(apf_reason.enabled, 0);
>  
> -	printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
> -	       smp_processor_id());
> +	pr_info("Unregister pv shared memory for cpu %d\n", smp_processor_id());
>  }
>  
>  static void kvm_pv_guest_cpu_reboot(void *unused)
> @@ -469,7 +469,8 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
>  		} else {
>  			ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
>  				(unsigned long)(ipi_bitmap >> BITS_PER_LONG), min, icr);
> -			WARN_ONCE(ret < 0, "KVM: failed to send PV IPI: %ld", ret);
> +			WARN_ONCE(ret < 0, "kvm_guest: failed to send PV IPI: %ld",
> +				  ret);
>  			min = max = apic_id;
>  			ipi_bitmap = 0;
>  		}
> @@ -479,7 +480,8 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
>  	if (ipi_bitmap) {
>  		ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,
>  			(unsigned long)(ipi_bitmap >> BITS_PER_LONG), min, icr);
> -		WARN_ONCE(ret < 0, "KVM: failed to send PV IPI: %ld", ret);
> +		WARN_ONCE(ret < 0, "kvm_guest: failed to send PV IPI: %ld",
> +			  ret);
>  	}
>  
>  	local_irq_restore(flags);
> @@ -509,7 +511,7 @@ static void kvm_setup_pv_ipi(void)
>  {
>  	apic->send_IPI_mask = kvm_send_ipi_mask;
>  	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
> -	pr_info("KVM setup pv IPIs\n");
> +	pr_info("setup pv IPIs\n");

Not your fault but in WARN_ONCE() above we use 'PV' capitalized so I'd
suggest we converge on something: either capitalize them all or make
them all lowercase.

>  }
>  
>  static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
> @@ -631,11 +633,11 @@ static void __init kvm_guest_init(void)
>  	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
>  	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>  		smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
> -		pr_info("KVM setup pv sched yield\n");
> +		pr_info("setup pv sched yield\n");

here

>  	}
>  	if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/kvm:online",
>  				      kvm_cpu_online, kvm_cpu_down_prepare) < 0)
> -		pr_err("kvm_guest: Failed to install cpu hotplug callbacks\n");
> +		pr_err("failed to install cpu hotplug callbacks\n");
>  #else
>  	sev_map_percpu_data();
>  	kvm_guest_cpu_init();
> @@ -738,7 +740,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
>  			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
>  				GFP_KERNEL, cpu_to_node(cpu));
>  		}
> -		pr_info("KVM setup pv remote TLB flush\n");
> +		pr_info("setup pv remote TLB flush\n");

and here too.

>  	}
>  
>  	return 0;
> @@ -866,8 +868,8 @@ static void kvm_enable_host_haltpoll(void *i)
>  void arch_haltpoll_enable(unsigned int cpu)
>  {
>  	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
> -		pr_err_once("kvm: host does not support poll control\n");
> -		pr_err_once("kvm: host upgrade recommended\n");
> +		pr_err_once("host does not support poll control\n");
> +		pr_err_once("host upgrade recommended\n");
>  		return;
>  	}

Other than the above,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

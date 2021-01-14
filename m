Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584BE2F624D
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 14:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbhANNqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 08:46:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726609AbhANNqm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 08:46:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610631915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0z/jAVbB9JGEFaFGRPRMJQOT3/r+X2ii1tNfXu3+OrY=;
        b=PIKT363W5WXc9iK7cfoILu5pyc9/rhczMI3pWJRI6RiHEJid+JXc7SaYwE3VIXSiwS0yo+
        l5tg1ueW9ZdhIiRO721P2J3VaPe2sAXv1145zjd63y8jgJr7tVAvfeWei4DtmQ80wYZ/+T
        TZc8BhzEXEmfqTXrfegT+a7CS1nCn6U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-k_3hlBUXNWKICdaOIjd1AQ-1; Thu, 14 Jan 2021 08:45:13 -0500
X-MC-Unique: k_3hlBUXNWKICdaOIjd1AQ-1
Received: by mail-ej1-f72.google.com with SMTP id gu19so2230610ejb.13
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 05:45:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0z/jAVbB9JGEFaFGRPRMJQOT3/r+X2ii1tNfXu3+OrY=;
        b=gOfyKQeVAhB4fuUQgcghmobuKi8yZEd7p3ufE6O1c947j8geOzWpp8Sn1xTZK2WOFE
         kdMOzGAN6DBYaIFAl/62EdjnymDb2+fpdYj8FZuo01ADGI98wbCeeLaWG1g/fhuPmwDn
         SJDI8yrt18vktNgmpPidM+UPaMAOJkB4woDQzkUKtQ509vAIZ8zxteKnhiaUoFDTRULB
         CH9NhHnqEEMJjUt0dlkBiSukK26WTeIX2mum9vWs32sHTsy4PvP4W/UVgyQQI/Aa9uVE
         HP1o5tFm1Az63ToLxk1mmK6FeqEl1ARPPSSpmD6ZlulKCaUNvRToi7/MRVnBsedH8nty
         wAow==
X-Gm-Message-State: AOAM531PCNexbUtbRZWSt0AAs4/A7hlLKTmcFHjZBbI+T/p946Tc5i8F
        3eBUto6tln+DKnAYuR6WrWIVJ32A5j97vV6CGxJO6nAS04oSHUuR/1jFbYprgMFDpeoA/JiAHGq
        yMxJfRufYxSX+ggNQfzgZsDCM1mMN5gdq10drITKiwLtwT38neWC96TL+WTFGmEVe
X-Received: by 2002:a17:907:9716:: with SMTP id jg22mr4473391ejc.126.1610631912115;
        Thu, 14 Jan 2021 05:45:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNhOIxjWwR6BBP3/fyEyPlCd1LO1r844S80POT9obwh8IR194vV6mHgFe0thE4KCaDVEkv0A==
X-Received: by 2002:a17:907:9716:: with SMTP id jg22mr4473374ejc.126.1610631911850;
        Thu, 14 Jan 2021 05:45:11 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h16sm69379eds.21.2021.01.14.05.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 05:45:11 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
In-Reply-To: <1610623624-18697-1-git-send-email-wanpengli@tencent.com>
References: <1610623624-18697-1-git-send-email-wanpengli@tencent.com>
Date:   Thu, 14 Jan 2021 14:45:10 +0100
Message-ID: <87pn277huh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> The per-cpu vsyscall pvclock data pointer assigns either an element of the 
> static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory 
> hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if 
> kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in 
> kvmclock_setup_percpu() which returns -ENOMEM. This patch fixes it by not 
> assigning vsyscall pvclock data pointer if kvmclock vdso_clock_mode is not 
> VDSO_CLOCKMODE_PVCLOCK.
>
> Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
> Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: stable@vger.kernel.org#v4.19-rc5+
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kernel/kvmclock.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index aa59374..0624290 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -296,7 +296,8 @@ static int kvmclock_setup_percpu(unsigned int cpu)
>  	 * pointers. So carefully check. CPU0 has been set up in init
>  	 * already.
>  	 */
> -	if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)))
> +	if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)) ||
> +	    (kvm_clock.vdso_clock_mode != VDSO_CLOCKMODE_PVCLOCK))
>  		return 0;

The comment above should probably be updated as it is not clear why we
check kvm_clock.vdso_clock_mode here. Actually, I would even suggest we
introduce a 'kvmclock_tsc_stable' global instead to avoid this indirect
check.

>  
>  	/* Use the static page for the first CPUs, allocate otherwise */

Also, would it be better if we just avoid cpuhp_setup_state() call in
this case? E.g. both these ideas combined (completely untested):

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa593743acf6..0827aef3ccb8 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -25,6 +25,7 @@
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
+static bool kvmclock_tsc_stable __ro_after_init = true;
 static int msr_kvm_system_time __ro_after_init = MSR_KVM_SYSTEM_TIME;
 static int msr_kvm_wall_clock __ro_after_init = MSR_KVM_WALL_CLOCK;
 static u64 kvm_sched_clock_offset __ro_after_init;
@@ -275,8 +276,10 @@ static int __init kvm_setup_vsyscall_timeinfo(void)
                return 0;
 
        flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-       if (!(flags & PVCLOCK_TSC_STABLE_BIT))
+       if (!(flags & PVCLOCK_TSC_STABLE_BIT)) {
+               kvmclock_tsc_stable = false;
                return 0;
+       }
 
        kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
 #endif
@@ -325,7 +328,8 @@ void __init kvmclock_init(void)
                return;
        }
 
-       if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
+       if (kvmclock_tsc_stable &&
+           cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
                              kvmclock_setup_percpu, NULL) < 0) {
                return;
        }

-- 
Vitaly


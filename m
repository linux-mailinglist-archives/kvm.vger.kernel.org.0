Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02112B212C
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 17:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgKMQ5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 11:57:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725967AbgKMQ5u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 11:57:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605286668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ZQSCankw5B0QgNiJvLUAMhyn2rU6CiTpgEHp+KAF+c=;
        b=B74z0f9M6MxvRQlcys9mKqVfcsAe37SQsfTIvKTsDKlAOhJzEepRfjGC+jFHN7Ds3L1HFN
        7T1cGS4j2a9pq6mMu1SlcqArxeWE2wg+4cNS73stD+EpOcne9FVUSSIrKEE3SPrR+088i8
        RykvODjzsO6Wtz67oCb3qeZpt8Xt7SY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-Ls6WOfJJPMmb_T0XB7Sl_Q-1; Fri, 13 Nov 2020 11:57:46 -0500
X-MC-Unique: Ls6WOfJJPMmb_T0XB7Sl_Q-1
Received: by mail-wm1-f69.google.com with SMTP id 3so4235009wms.9
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 08:57:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ZQSCankw5B0QgNiJvLUAMhyn2rU6CiTpgEHp+KAF+c=;
        b=Zi3A9sb7xegWiqC5/97hG1iuuHOjQqUHI1ozbidtgAHTzQBD1BYMVg0Fom1Mwo9z1q
         LLOh9MgRoawRLe+C5yEFAVCIRarYG19NERW5gyFvZATxg00d8WE8RD7HzWeCGqEtpJvw
         mraq6qvStStV0ra3Lc7k4o2P57S4MzkJ4ZElOAr04LXvtPgq2Lual81/8DeLGSCncjs4
         yLO/yDOLpMOR+ofR8eP5wgiEC9UKnxRLH3VLs04WYqbEjoqxGmo84Z9kw8mn1H4tH6WX
         aRi1xny1EqBwzJh1ayxR9K/honoYIYg6JcMRucHfD63UGFUVzGw82WDvR89/c3nm58yh
         5S0Q==
X-Gm-Message-State: AOAM5320pvDV2QGvdw3QwT0AFN3J1LhPGLRgiT+v3T76+lxE3/QsIs2K
        haEjkDA2IGU2rRlkuo9OZqv6m7svwQJcYjOX2lVVTO2VKfk5lc2jraf97zcI9afmYsDH84r/FVR
        88Dtp//oRRNCp
X-Received: by 2002:a05:6000:364:: with SMTP id f4mr4554174wrf.290.1605286663939;
        Fri, 13 Nov 2020 08:57:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwi/GV6bvhHaDYjQ+i+BKr+EldsibMpe6ecBnpRLJ7GXLQzaZLuUjw5ChknHnxVrvznO18MeQ==
X-Received: by 2002:a05:6000:364:: with SMTP id f4mr4553781wrf.290.1605286658811;
        Fri, 13 Nov 2020 08:57:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a12sm11508076wrr.31.2020.11.13.08.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 08:57:37 -0800 (PST)
Subject: Re: [PATCH v2 1/2] KVM: SVM: Move asid to vcpu_svm
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
References: <20201011184818.3609-1-cavery@redhat.com>
 <20201011184818.3609-2-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aadb4690-9b2b-4801-f2fc-783cb4ae7f60@redhat.com>
Date:   Fri, 13 Nov 2020 17:57:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201011184818.3609-2-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/20 20:48, Cathy Avery wrote:
> Move asid to svm->asid to allow for vmcb assignment
> during svm_vcpu_run without regard to which level
> guest is running.

Slightly more verbose commit message:

KVM does not have separate ASIDs for L1 and L2; either the nested
hypervisor and nested guests share a single ASID, or on older processor
the ASID is used only to implement TLB flushing.

Either way, ASIDs are handled at the VM level.  In preparation
for having different VMCBs passed to VMLOAD/VMRUN/VMSAVE for L1 and
L2, store the current ASID to struct vcpu_svm and only move it to
the VMCB in svm_vcpu_run.  This way, TLB flushes can be applied
no matter which VMCB will be active during the next svm_vcpu_run.


> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>   arch/x86/kvm/svm/svm.c | 4 +++-
>   arch/x86/kvm/svm/svm.h | 1 +
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d4e18bda19c7..619980a5d540 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1101,6 +1101,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>   		save->cr4 = 0;
>   	}
>   	svm->asid_generation = 0;
> +	svm->asid = 0;
>   
>   	svm->nested.vmcb = 0;
>   	svm->vcpu.arch.hflags = 0;
> @@ -1663,7 +1664,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
>   	}
>   
>   	svm->asid_generation = sd->asid_generation;
> -	svm->vmcb->control.asid = sd->next_asid++;
> +	svm->asid = sd->next_asid++;
>   
>   	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>   }

This vmcb_mark_dirty must be delayed to svm_vcpu_run as well, because 
the active VMCB could change:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 48965bfa3d1e..3b53a7ead04b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1756,12 +1756,11 @@ static void new_asid(struct vcpu_svm *svm, 
struct svm_cpu_data *sd)
  		++sd->asid_generation;
  		sd->next_asid = sd->min_asid;
  		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
  	}

  	svm->asid_generation = sd->asid_generation;
  	svm->asid = sd->next_asid++;
-
-	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
  }

  static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
@@ -3571,7 +3570,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct 
kvm_vcpu *vcpu)

  	sync_lapic_to_cr8(vcpu);

-	svm->vmcb->control.asid = svm->asid;
+	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
+		svm->vmcb->control.asid = svm->asid;
+		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
+	}
  	svm->vmcb->save.cr2 = vcpu->arch.cr2;

  	/*

Queued with this change.

Paolo


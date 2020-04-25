Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55D1B8487
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgDYIHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 04:07:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33826 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYIHk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 04:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587802059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pvUeVwhxbFNu8fxCD76T9F++Vo/CGAqd9wlUHbwgwQs=;
        b=OBHDWeFyP7iPsPQZWCCIhhXi8MkefdlBr9Zzr1ElrUYtmDTuz5CLwSOu4NQNqtiZgrE/q1
        hrqxL/6QA265Jwquo+okSlbEunsxwTfLnoRAip3wS/Q1GCIe6rpe3WjL2gIi3rsrMxjRoF
        VpseQz928dLsM7IeNioCm03bVbMMo20=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-gZ4JKB5yPfSYxNtFrUhMYg-1; Sat, 25 Apr 2020 04:07:36 -0400
X-MC-Unique: gZ4JKB5yPfSYxNtFrUhMYg-1
Received: by mail-wr1-f70.google.com with SMTP id f15so6392658wrj.2
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 01:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pvUeVwhxbFNu8fxCD76T9F++Vo/CGAqd9wlUHbwgwQs=;
        b=Q2kZzqfajsebWfkmb0LrW+kk79CFKYhpXlo1QD8lCUCR3w7tGkaXVFYrvyeQzMVeiD
         FS1zpe3rzhEANMn6se0wRjTpoboXJWzUD6rhZlSc2+kTaTAQYsRhwwfWmaXzjiAdqYwy
         lsQs3d7wp61YtDG9QHuFclHC58zoawC7u7Kiof9bEWzdcf5etMZ0UxpmyGTJ6J1TU6w2
         JmMPgaJ5GN+NLI7pAxJCnrF7IjsorPGoKiN/nvFRbT+ECwC3EzZ6WfWN9eM2uJ6Eharj
         EvuXrqwDe2yIiH+fJ7TD3791BuDyB5HZ5jilfntnTSdMIcGIPRciaDqe6Kakydgq97/5
         prIw==
X-Gm-Message-State: AGi0PuY+GvTkRVIQWleLHeK/HOeRdQEOxN4TaIDKFRdRQke57bpUOhCy
        +wiKa44yomJPqzpfnwzM7gr9k/pwtXA2UzeT7LNYgjJDbXd/KPOGUZtSM+q2TSHbH1tf9C/d+cE
        Z7GRwKMzlExXK
X-Received: by 2002:a5d:42c7:: with SMTP id t7mr15617042wrr.336.1587802054992;
        Sat, 25 Apr 2020 01:07:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypKrwadT37ORpuSWqL7KFA7Vn4EEv0pM8gAAHxk81t93H9Ty3/mW93rUSVcRT1/mVnWRP1JZWg==
X-Received: by 2002:a5d:42c7:: with SMTP id t7mr15617013wrr.336.1587802054737;
        Sat, 25 Apr 2020 01:07:34 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id c190sm6289379wme.4.2020.04.25.01.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 01:07:34 -0700 (PDT)
Subject: Re: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to
 KVM_DEBUGREG_NEED_RELOAD
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-2-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <85cb5946-2109-28a0-578d-bed31d1b8298@redhat.com>
Date:   Sat, 25 Apr 2020 10:07:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416101509.73526-2-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 12:15, Xiaoyao Li wrote:
> To make it more clear that the flag means DRn (except DR7) need to be
> reloaded before vm entry.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

I wonder if KVM_DEBUGREG_RELOAD is needed at all.  It should be easy to
write selftests for it, using the testcase in commit message
172b2386ed16 and the information in commit ae561edeb421.

Paolo

> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/x86.c              | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c7da23aed79a..f465c76e6e5a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -511,7 +511,7 @@ struct kvm_pmu_ops;
>  enum {
>  	KVM_DEBUGREG_BP_ENABLED = 1,
>  	KVM_DEBUGREG_WONT_EXIT = 2,
> -	KVM_DEBUGREG_RELOAD = 4,
> +	KVM_DEBUGREG_NEED_RELOAD = 4,
>  };
>  
>  struct kvm_mtrr_range {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index de77bc9bd0d7..cce926658d10 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1067,7 +1067,7 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
>  	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
>  		for (i = 0; i < KVM_NR_DB_REGS; i++)
>  			vcpu->arch.eff_db[i] = vcpu->arch.db[i];
> -		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_RELOAD;
> +		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_NEED_RELOAD;
>  	}
>  }
>  
> @@ -8407,7 +8407,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		set_debugreg(vcpu->arch.eff_db[2], 2);
>  		set_debugreg(vcpu->arch.eff_db[3], 3);
>  		set_debugreg(vcpu->arch.dr6, 6);
> -		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
> +		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_NEED_RELOAD;
>  	}
>  
>  	kvm_x86_ops.run(vcpu);
> @@ -8424,7 +8424,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		kvm_update_dr0123(vcpu);
>  		kvm_update_dr6(vcpu);
>  		kvm_update_dr7(vcpu);
> -		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
> +		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_NEED_RELOAD;
>  	}
>  
>  	/*
> 


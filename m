Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8A8200877
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 14:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732846AbgFSMO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 08:14:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43352 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732862AbgFSMOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 08:14:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592568885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8cRJ9mKHnqlRMCmgZ9Saj2HVMswrOptw4ckNPEI2IU=;
        b=SBkr9l7oXhrZDGG1UvlquFZpdS/9erxJz5vHupMT81NFmawIXy7D38zvPVMgyrjxAFIJqh
        s4u6TpfWmXO+vPny3xBBX/y/m7eTR8dw0ASfBUWpPjWTbu6wVvc5AzCj1pd6dZj1x9/sRg
        mEea9RA/4HxoBPkv25akCoCr22v0vnw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-0xET-NeFPJSOwiohwRsUzA-1; Fri, 19 Jun 2020 08:14:42 -0400
X-MC-Unique: 0xET-NeFPJSOwiohwRsUzA-1
Received: by mail-wr1-f71.google.com with SMTP id c14so4175815wrw.11
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 05:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R8cRJ9mKHnqlRMCmgZ9Saj2HVMswrOptw4ckNPEI2IU=;
        b=AOXbJ0fZhK7MxA+X4jSqnqFNLoR8OacQ8B+LQPFfdZTkRiK45sdcxwe6kXulXVqBx0
         2LPpR8sNObW1ExIisHvyWWd+uNLbTgX0p1e/yNfDlHJUZsPmTJws8iJjG+4pqZQyNyF8
         yKTgGzb0Ar5n39JSXzh7fSrKzrqKhG/W+UPy6Po75Izt0hN1S81k4Yp28plfzQXfGaqy
         6s18iVmML8PmjKUFO6CgqgeSOlIpeIXp0FtM3ltGSOREg7yuXykiUdfDggavFVzOjN6O
         GX3d9XgjdoWczS0Q7cT+T1PsEAmIcd2+8XOKxWPSccPFCFXCY6hrFQY6b2dG/ctfc3I6
         8dKA==
X-Gm-Message-State: AOAM530tHCuwBImMIDduGqIG0A/Dtu7YaYtZqB9+iEN0mHDIILBWOO+f
        TkCj/oB6TN1CUKmh/yrY0BUgL3UJL3XlcI0KJmmB4ZkWThe+E4cgeMSoSoGQ1g530jyUbvJAnrL
        3gyYCqeOYIvRK
X-Received: by 2002:adf:db09:: with SMTP id s9mr3724451wri.256.1592568881585;
        Fri, 19 Jun 2020 05:14:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzI0DHsQbRkAzRAW/4WimBoJGHA0E5juzZDQy4xA4UsJjmsZK6Wry3yY0B5r4VoAJNzMN1cjA==
X-Received: by 2002:adf:db09:: with SMTP id s9mr3724431wri.256.1592568881336;
        Fri, 19 Jun 2020 05:14:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id b201sm6852671wmb.36.2020.06.19.05.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 05:14:40 -0700 (PDT)
Subject: Re: [PATCH RFC] Revert "KVM: VMX: Micro-optimize vmexit time when not
 exposing PMU"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200619094046.654019-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d72de2a8-7c65-6ad1-8f53-5a2a94533018@redhat.com>
Date:   Fri, 19 Jun 2020 14:13:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200619094046.654019-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/20 11:40, Vitaly Kuznetsov wrote:
> Guest crashes are observed on a Cascade Lake system when 'perf top' is
> launched on the host, e.g.
> 
>  BUG: unable to handle kernel paging request at fffffe0000073038
>  PGD 7ffa7067 P4D 7ffa7067 PUD 7ffa6067 PMD 7ffa5067 PTE ffffffffff120
>  Oops: 0000 [#1] SMP PTI
>  CPU: 1 PID: 1 Comm: systemd Not tainted 4.18.0+ #380
> ...
>  Call Trace:
>   serial8250_console_write+0xfe/0x1f0
>   call_console_drivers.constprop.0+0x9d/0x120
>   console_unlock+0x1ea/0x460
> 
> Call traces are different but the crash is imminent. The problem was
> blindly bisected to the commit 041bc42ce2d0 ("KVM: VMX: Micro-optimize
> vmexit time when not exposing PMU"). It was also confirmed that the
> issue goes away if PMU is exposed to the guest.
> 
> With some instrumentation of the guest we can see what is being switched
> (when we do atomic_switch_perf_msrs()):
> 
>  vmx_vcpu_run: switching 2 msrs
>  vmx_vcpu_run: switching MSR38f guest: 70000000d host: 70000000f
>  vmx_vcpu_run: switching MSR3f1 guest: 0 host: 2
> 
> The current guess is that PEBS (MSR_IA32_PEBS_ENABLE, 0x3f1) is to blame.
> Regardless of whether PMU is exposed to the guest or not, PEBS needs to
> be disabled upon switch.
> 
> This reverts commit 041bc42ce2d0efac3b85bbb81dea8c74b81f4ef9.
> 
> Reported-by: Maxime Coquelin <maxime.coquelin@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - Perf/KVM interractions are a mystery to me, thus RFC.
> ---
>  arch/x86/kvm/vmx/vmx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 36c771728c8c..b1a23ad986ff 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6728,8 +6728,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	pt_guest_enter(vmx);
>  
> -	if (vcpu_to_pmu(vcpu)->version)
> -		atomic_switch_perf_msrs(vmx);
> +	atomic_switch_perf_msrs(vmx);
>  	atomic_switch_umwait_control_msr(vmx);
>  
>  	if (enable_preemption_timer)
> 

Queued, thanks.

Paolo


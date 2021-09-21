Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6317A4138C2
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhIURkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:40:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230356AbhIURki (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 13:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632245949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dol89n1uM/B2bXTU97+WaVIJZe+JvJJV6we1CFEWq9M=;
        b=WfU8iaztck+07PfttztIfXfjQ5hklO29Yz1cJnBkpPiG638VjY1trtPFmh2HpAfbv0vjPH
        uSV+b98Yjb4B8dh3403lgBAQ5Y/aJ5ZsAtJbOwxbYnw0rmsy7LQOCqdAzU0CTtnp58bxVg
        UHPJnrzrelG8EdjUDbVwXuJ5Drybcm0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-4odPPoLtMEafGnYS34xENg-1; Tue, 21 Sep 2021 13:39:08 -0400
X-MC-Unique: 4odPPoLtMEafGnYS34xENg-1
Received: by mail-ed1-f71.google.com with SMTP id h6-20020a50c386000000b003da01adc065so860515edf.7
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dol89n1uM/B2bXTU97+WaVIJZe+JvJJV6we1CFEWq9M=;
        b=wohR0ew5qMwR5W2DZ/rOyzGPkonc2QVaaw0eSwNUrqat4aFBje0GkAzuIUk8kZG09m
         S47KyVJGOPNqx1JLKKfOFvDoK6/jRj90dNdk9BDcug7jS1+R3GXZi+ffYVhZVCq43ahf
         pcfxxTTOESKcg42lGQ5YBsjZDxYW7iUM4MZRkDx9MrE3r2h29+KdhsyxKFOpvc3zBqZe
         ecV/hoq76PSQLEcHiYmKqSLupJsxmv1cG1ViXUUzUQtAX7X9c9NqDduroeGwlTj0vHBE
         0+GkP/pB48tAgKKUyX6RK/NIYtMPMJ91WEiWh3HHkwq/9cOXWYPr09wZCfvsIMc5fnKY
         Amuw==
X-Gm-Message-State: AOAM532zf64PZmFQ37jH3lwDe6SKQh1Yu7bDuem6ZR1sGzQiwMHIIxlY
        U1sKMn+hfiYiXhmIUsABzk3+Jxt3ZnjrMcgzi9qzeXOZU+BqxfWdfo3alJa/0XjEqbs8C2bQOL4
        9hzs/F5CzxdFx
X-Received: by 2002:a17:906:584:: with SMTP id 4mr35828305ejn.56.1632245947125;
        Tue, 21 Sep 2021 10:39:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydAYozLECbAB3FtNwlXLjXnMGQgLVpCGRhOjs5KMtaYsDdVgOsFWPzks3XYTFsXJ4IdZY5lQ==
X-Received: by 2002:a17:906:584:: with SMTP id 4mr35828279ejn.56.1632245946888;
        Tue, 21 Sep 2021 10:39:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w5sm7874823ejz.25.2021.09.21.10.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 10:39:06 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Remove defunct "nr_active_uret_msrs" field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210908002401.1947049-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <712043a4-c4b4-0a94-3bf0-88c12397c49e@redhat.com>
Date:   Tue, 21 Sep 2021 19:39:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210908002401.1947049-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/09/21 02:24, Sean Christopherson wrote:
> Remove vcpu_vmx.nr_active_uret_msrs and its associated comment, which are
> both defunct now that KVM keeps the list constant and instead explicitly
> tracks which entries need to be loaded into hardware.
> 
> No functional change intended.
> 
> Fixes: ee9d22e08d13 ("KVM: VMX: Use flag to indicate "active" uret MSRs instead of sorting list")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.h | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 4858c5fd95f2..02ab3468885f 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -248,12 +248,8 @@ struct vcpu_vmx {
>   	 * only loaded into hardware when necessary, e.g. SYSCALL #UDs outside
>   	 * of 64-bit mode or if EFER.SCE=1, thus the SYSCALL MSRs don't need to
>   	 * be loaded into hardware if those conditions aren't met.
> -	 * nr_active_uret_msrs tracks the number of MSRs that need to be loaded
> -	 * into hardware when running the guest.  guest_uret_msrs[] is resorted
> -	 * whenever the number of "active" uret MSRs is modified.
>   	 */
>   	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
> -	int                   nr_active_uret_msrs;
>   	bool                  guest_uret_msrs_loaded;
>   #ifdef CONFIG_X86_64
>   	u64		      msr_host_kernel_gs_base;
> 

Queued, thanks.

Paolo


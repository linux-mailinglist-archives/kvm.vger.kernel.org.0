Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0C24EFFA4
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 10:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347047AbiDBIQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 04:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbiDBIQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 04:16:20 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501E8FABD1
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 01:14:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id yy13so10299433ejb.2
        for <kvm@vger.kernel.org>; Sat, 02 Apr 2022 01:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ASfglyNGhIYGfLedSdBxygqzN12rw9J2jE3Wf+ebSeY=;
        b=KREy2OZE6S4TplSLUSxs3PkgcFnFHOLnFr5sq5tioMzormRA6w9NknWHwonxzYGa9e
         3VMlS63RrcjF7aJcevnwbm4pq4Y5wzN2ORCJ0l8oLqBjYM3h4SkRXOEFWq4quDOQRtX0
         AXZJL8TXFlTrdCUcQKfrCVbHJACKeZWF8AWdfiDyk4MAgYb2pBhx+x8Q6lqRTWeoLWof
         bwq9O6e7JHQ1k1s7mMAooKpUDvaVNBxwgTkQr3QwAqNQjOeMvuGQc+5hA474Yb3DWdLv
         CQZ1a4SlTT15cMHbqtWPWWRyIuXIWBauI3f+yvGiJAr8N+eZOxRy904yf1rj/RVOQAdx
         osDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ASfglyNGhIYGfLedSdBxygqzN12rw9J2jE3Wf+ebSeY=;
        b=Qf8tDlpTzl/+CpAkru5iUUg7s13ybOxz+iBC93iW95XE2gBhczk5ERmuCUzRGn4HqQ
         ZDHbzizwzejNN86hXLuJSoXFDnGlw8+yjN+2lKN/8nGIA9ULoMEJokBIWTjvW+Mh9RVi
         8VPs3ruY9i/Wa79LLaw2o0aTnuahHgGQ9dybXKT0YXtTCRNOxJ3tXf2XQ7mjg+/q8+Hz
         hyNEHMa+2JqBebw+skRG42cm6hlO3lhd1hcgadCZMtv8ejHtnWVc8z0uBYgUWPSw/XeN
         xLm+Miyyj01BmXBpE7qoybN4ZRhLo54CT0h1E+Wfr9iqmU7s+GRDTf4IS/YEFYhTkxHY
         Kngw==
X-Gm-Message-State: AOAM5306KxrvrBgAfQ/TDKUt7hTfPEEXsQoC5ZfasmynCA6cbwHml6ED
        VnsVw5mqMDbJNcjp61qB+b4=
X-Google-Smtp-Source: ABdhPJwa/Y6/ZS6J5R8KLnICG+MlvwfHRbDC/emvRc6Pdm13Tw09bj83zp6s934W0BiB/Ei/PKrWAQ==
X-Received: by 2002:a17:907:960c:b0:6e4:accf:10e3 with SMTP id gb12-20020a170907960c00b006e4accf10e3mr3136741ejc.173.1648887267790;
        Sat, 02 Apr 2022 01:14:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8ca6:a836:a237:fed1? ([2001:b07:6468:f312:8ca6:a836:a237:fed1])
        by smtp.googlemail.com with ESMTPSA id bn14-20020a170906c0ce00b006c5ef0494besm1850025ejb.86.2022.04.02.01.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 01:14:27 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e7896b4e-0b29-b735-88b8-34dd3b266d3d@redhat.com>
Date:   Sat, 2 Apr 2022 10:14:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: VMX: optimize pi_wakeup_handler
Content-Language: en-US
To:     Li RongQing <lirongqing@baidu.com>, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
References: <1648872113-24329-1-git-send-email-lirongqing@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1648872113-24329-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/2/22 06:01, Li RongQing wrote:
> pi_wakeup_handler is used to wakeup the sleep vCPUs by posted irq
> list_for_each_entry is used in it, and whose input is other function
> per_cpu(), That cause that per_cpu() be invoked at least twice when
> there is one sleep vCPU
> 
> so optimize pi_wakeup_handler it by reading once which is safe in
> spinlock protection
> 
> and same to per CPU spinlock

What's the difference in the generated code?

Paolo

> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>   arch/x86/kvm/vmx/posted_intr.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 5fdabf3..0dae431 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -214,17 +214,21 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>    */
>   void pi_wakeup_handler(void)
>   {
> +	struct list_head *wakeup_list;
>   	int cpu = smp_processor_id();
> +	raw_spinlock_t *spinlock;
>   	struct vcpu_vmx *vmx;
>   
> -	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
> -	list_for_each_entry(vmx, &per_cpu(wakeup_vcpus_on_cpu, cpu),
> -			    pi_wakeup_list) {
> +	spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
> +
> +	raw_spin_lock(spinlock);
> +	wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
> +	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
>   
>   		if (pi_test_on(&vmx->pi_desc))
>   			kvm_vcpu_wake_up(&vmx->vcpu);
>   	}
> -	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
> +	raw_spin_unlock(spinlock);
>   }
>   
>   void __init pi_init_cpu(int cpu)


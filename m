Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8D2518390
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 13:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiECL5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 07:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiECL5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 07:57:43 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A072559F
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 04:54:07 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id w3so5520148qkb.3
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 04:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fKqmIQb/ZgktarEtGwRWxZJn17vnowbPHjSo8Aqk8Cw=;
        b=HIiDVqzAlTGp30sDHe6gbmWemXH3QOEUmLRK/3wLvYLuBpqOYhaJ9DA1JX7EdeckhZ
         2dGRX1s6lQHncF04gUo9RYtC8bUIUDHk7gYqzhBFeiO/Vf+Qx+1Yebii/A8X6vNPMfJN
         ILm/3YZeqRyJ4qf7ZjB9+K/a6b9us7miSXKfOg8bhw9wv6quRvQFP0DEtnNToFakLQ8O
         i3ToaQg/5AZHALJpp8WpN9rtb+6LsO91ak7nJiiK2SjHi/8rwKKJzoSZOw1KPWcxvfd4
         jnyfsC5u5fshT2O6rTtOOMGxclMueIOjhidK5vDrMoHOYFnOgO0G15mrUvM/hLiNosF4
         8C5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fKqmIQb/ZgktarEtGwRWxZJn17vnowbPHjSo8Aqk8Cw=;
        b=USiyACqadC35yGgq3SqJGfRsIDq3l4c9KB9lwEHRsfiwH52xyzXLtpUIxQKoNiUP6d
         WAddTfBCzn/D1IDNWkP5Pz1RAw4eopRMzOT4gcGAhfdnZT1eSnHaorjHn1E3wBfgeNZf
         a5qvEzWDvsFE8xSqNcY/13xBPX1zoZbIGNj6ExBYVEO/+8Dugs4635kdj1G68w8XU7tQ
         VdR1tw5mDTKBOGg0uEYI3vOE6Uqr7rQWaNAOhFT0TENoUFOF3bwgApCjGEBGm72lcpsO
         adRoT7d0LcZHxXSIVOrtLII/ISKa7+2URlLE3UZPQvtVQn78/KH98r0RQ2okOD4qn1kS
         BHcw==
X-Gm-Message-State: AOAM533B8FN90y5LJpjnfWLKYxyAwUEfpPP2GDnh+IxiD+brU55AdCn4
        ECSKcjhkNfi2dPyKo3suqe08L/KJmuw=
X-Google-Smtp-Source: ABdhPJyDdpJY8HkRHvSBQaTDh8+hnK+6Cnt1XrpLVO6U9TEn0Ox7s2splT0KYq5TAUgDanCcZgquDA==
X-Received: by 2002:a37:8644:0:b0:69e:6d99:4a5e with SMTP id i65-20020a378644000000b0069e6d994a5emr11846058qkd.212.1651578846960;
        Tue, 03 May 2022 04:54:06 -0700 (PDT)
Received: from [10.32.181.74] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id e15-20020a05620a014f00b0069fc13ce1desm6020399qkn.15.2022.05.03.04.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 04:54:05 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f0c941f3-7c1b-a9a8-e0a5-cb3b2cf5eb0f@redhat.com>
Date:   Tue, 3 May 2022 13:54:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH][v2] KVM: VMX: optimize pi_wakeup_handler
Content-Language: en-US
To:     Li RongQing <lirongqing@baidu.com>, x86@kernel.org,
        kvm@vger.kernel.org, seanjc@google.com
References: <1649244302-6777-1-git-send-email-lirongqing@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1649244302-6777-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/22 13:25, Li RongQing wrote:
> pi_wakeup_handler is used to wakeup the sleep vCPUs by posted irq
> list_for_each_entry is used in it, and whose input is other function
> per_cpu(), That cause that per_cpu() be invoked at least twice when
> there is one sleep vCPU
> 
> so optimize pi_wakeup_handler it by reading once and same to per CPU
> spinlock
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff v1: move reading the per-cpu variable out of spinlock protection
> 
>   arch/x86/kvm/vmx/posted_intr.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 5fdabf3..c5c1d31 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -215,16 +215,17 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>   void pi_wakeup_handler(void)
>   {
>   	int cpu = smp_processor_id();
> +	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
> +	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
>   	struct vcpu_vmx *vmx;
>   
> -	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
> -	list_for_each_entry(vmx, &per_cpu(wakeup_vcpus_on_cpu, cpu),
> -			    pi_wakeup_list) {
> +	raw_spin_lock(spinlock);
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

Queued, thanks.

Paolo

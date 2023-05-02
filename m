Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBDA6F3BFA
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 04:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjEBCHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 22:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjEBCHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 22:07:48 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521D410F4
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 19:07:47 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1aad5245632so19329665ad.3
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 19:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682993267; x=1685585267;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=COdD/3QMWHnibqBcf92Ik+G8mHJB/QgTMMMz/yGls1s=;
        b=Xa6H8YPKEwDyxC6jHLnd2e11XfblYc5C5wldoTi7ZPBj9vDe7LTRiQ1K8NVfFn9CaT
         iMPhFoYjNST1PsqBgWkiwqE2Z2XF126h9X4XYwlZiQZ+GNSeNXWC8X1ZFGDW+dyUmVlq
         WTQFeCus0qGPt01lWPEB1k63doYd4GQJLNp2W2ulYsuzJEQxvPWvPqc568bVB9XFMZ+V
         4zWLLIygxnhn+y1EeS9t+OSN49QvTirL0hgC0mgGwkc5AEhVJGHPuECAWPNfML08IGJf
         CW5PGH2uLVVuciQl2+JaYo7hRm/NWYy3HyWQZuJe/YfmsAgrro0Y8xwj/YzqfRLj98S/
         D5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682993267; x=1685585267;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=COdD/3QMWHnibqBcf92Ik+G8mHJB/QgTMMMz/yGls1s=;
        b=UFY3ULGoDj/tft24AkUSfIEaze/yRIzCQUvsqxKK+zJZTOXg+t9TcUDetvEL0usqrT
         /ATMpuuvzLK6iBuxcgVLNZi3nHwHpDajB65DHN1afRJ4YBsm2CSkPxJ8WHv1ngmnEKUt
         yPxVkImslBiH3JRRrtqumStfuCQjYBx6ptZStNRCS/dm8r110Jh1qIRsiRWbEsA1XkRy
         1OnkYsrk1Pg0AtKgv9+VM/+oOkkyP9J9+KVco7bNw5WkS+V0cd+yYAGmnKvijeH9zaHs
         Ic418zHfqa8DDHP4EUYIeuqtnZAY9cF2X9eprFiD2G+3vx/70x2h19EbPwzDVvLGtp5g
         BZ2A==
X-Gm-Message-State: AC+VfDyqkMNvp3NQtZNo5IeQfAl0OJY86dYL/o3vGMfOkOrDVXbfZfQ2
        w0Y+j1yFaf/+Ih4MaFz+yrM=
X-Google-Smtp-Source: ACHHUZ41bBIfzAi6DWXmhWZvC2wA9iGg2NbeAtV3zJoKqp5BpGVQzOtQNiiy98uORdxEhHh/KkJsKA==
X-Received: by 2002:a17:902:db07:b0:1aa:f203:781c with SMTP id m7-20020a170902db0700b001aaf203781cmr6901873plx.44.1682993266692;
        Mon, 01 May 2023 19:07:46 -0700 (PDT)
Received: from [172.27.224.2] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902e88400b001a6ed2d0ef8sm3310182plg.273.2023.05.01.19.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 19:07:46 -0700 (PDT)
Message-ID: <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com>
Date:   Tue, 2 May 2023 10:07:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not
 itlb_multihit
Content-Language: en-US
To:     lirongqing@baidu.com, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, kvm@vger.kernel.org, x86@kernel.org
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/23/2023 3:18 PM, lirongqing@baidu.com wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> if CPU has not X86_BUG_ITLB_MULTIHIT bug, kvm-nx-lpage-re kthread
> is not needed to create

(directed by Sean from 
https://lore.kernel.org/kvm/ZE%2FR1%2FhvbuWmD8mw@google.com/ here.)

No, I think it should tie to "nx_huge_pages" value rather than 
directly/partially tie to boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT).
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8354262..be98c69 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6667,6 +6667,11 @@ static bool get_nx_auto_mode(void)
>   	return boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT) && !cpu_mitigations_off();
>   }
>   
> +static bool cpu_has_itlb_multihit(void)
> +{
> +	return boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT);
> +}
> +
>   static void __set_nx_huge_pages(bool val)
>   {
>   	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
> @@ -6677,6 +6682,11 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>   	bool old_val = nx_huge_pages;
>   	bool new_val;
>   
> +	if (!cpu_has_itlb_multihit()) {
> +		__set_nx_huge_pages(false);
> +		return 0;
> +	}
> +
It's rude simply return here just because 
!boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT), leaving all else behind, i.e. 
leaving below sysfs node useless.
If you meant to do this, you should clear these sysfs APIs because of 
!boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT).

>   	/* In "auto" mode deploy workaround only if CPU has the bug. */
>   	if (sysfs_streq(val, "off"))
>   		new_val = 0;
> @@ -6816,6 +6826,9 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>   	uint old_period, new_period;
>   	int err;
>   
> +	if (!cpu_has_itlb_multihit())
> +		return 0;
> +
>   	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
>   
>   	err = param_set_uint(val, kp);
> @@ -6971,6 +6984,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>   {
>   	int err;
>   
> +	if (!cpu_has_itlb_multihit())
> +		return 0;
> +
It's rude to simply return. kvm_mmu_post_init_vm() by name is far more than 
nx_hugepage stuff, though at present only this stuff in.
I would rather

	if (cpu_has_itlb_multihit()) {
		...
	}

Consider people in the future when they do modifications on this function.
>   	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
>   					  "kvm-nx-lpage-recovery",
>   					  &kvm->arch.nx_huge_page_recovery_thread);
> @@ -6982,6 +6998,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>   
>   void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>   {
> +	if (!cpu_has_itlb_multihit())
> +		return;
> Ditto. It looks (wrongly) like: if !cpu_has_itlb_multihit(), no need to do 
anything about pre_destroy_vm.

>   	if (kvm->arch.nx_huge_page_recovery_thread)
>   		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
>   }

To summary, regardless of the concrete patch/implementation, what Sean more 
urgently needs is real world justification to mitigate NX_hugepage; which I 
believe you have at hand: why would you like to do this, what real world 
issue caused by this bothers you. You could have more descriptions.

With regards to NX_hugepage, I see people dislike it [1][2][3], but on HW 
with itlb_multihit, they've no choice but to use it to mitigate.

[1] this patch
[2] 
https://lore.kernel.org/kvm/CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com/
[3] 
https://lore.kernel.org/kvm/20220613212523.3436117-1-bgardon@google.com/ 
(merged)

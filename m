Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA16F9292
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 16:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjEFOt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 10:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjEFOtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 10:49:25 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428F91386E
        for <kvm@vger.kernel.org>; Sat,  6 May 2023 07:49:24 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1aaf91ae451so26731555ad.1
        for <kvm@vger.kernel.org>; Sat, 06 May 2023 07:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683384564; x=1685976564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4fNK5ORv15G/kO0k62wYmWRemmov2paIeYnjkHwzi/0=;
        b=qrsZRjKPxPHNpaRxVJIt+Be9k2ulM6Y3Pwb23UqiK528hjGq3SgeG/oodd6LciSSrp
         FEnPCyaIfdIMiHmCXT+dL+v5mva4sdy/k+l146EVFqcm1KxTQS1v2xyMSlkhSWNCtOv5
         5jZ3EBpJbl/zqTjj4q+G5wbsMik/S76Zv7DZd2XgvqocPvF9ZZswqGdg9K6tr0RHlqSb
         JMupnN/zFq2YA+xJd3rK7zvtDA6qAZMVCWrXnzN3fcYtd48+49z+qkuDazGEfziENGhR
         bTZcURH7uredZ5WS4Mi1SpfnhzsxztaK1JYTKFQaM7C+7PLFVzOmInFIkjAeKO65GCHG
         wofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683384564; x=1685976564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4fNK5ORv15G/kO0k62wYmWRemmov2paIeYnjkHwzi/0=;
        b=ccLQnWclMnHljCv23LABiZjtKjzxFrrQWD7/G+TzUJvhKZCqgMC9KKwIzHxb6p5Uh2
         bBQuX5AgU5OC85q3g/qs/oemT8jfoqI2qlfP1dA8m1aoAH3q0LlzxQZxaNl/X4NLNIhh
         bQKyYgAbNWR/h4PyG6PESYHpmLW0GXzmWAmp8rb2FcFcuFZwi+Yc5lGO6lRyFNCFngl6
         2ZtF7p2Gra9LxXLgji1u6DPKGY3VNsRtbZZHo7xErt3gs2w9yPgym9iXijiyABBKlOWA
         AL+KowM1eP9Rw+4lY/mGqE5LvbqG2rju+ULK2Gmc9N7s9I/pWKbcl6IyanXP2xgWI4GW
         vPjA==
X-Gm-Message-State: AC+VfDzp8j6YJ3cLVAHWcJIIPWjdHJHRIsy6vKRcuVys4Ybqgq7AhPXb
        IVepOhEkTgA5Q22QTPIvDqM=
X-Google-Smtp-Source: ACHHUZ4Sj5BDYwNaIKU4IaeMqMsy7t/xBMlN4h+IXcjWESmyrqPzFpqCzUCWSw0vo84y35aoJoI2Kw==
X-Received: by 2002:a17:902:9342:b0:19c:d309:4612 with SMTP id g2-20020a170902934200b0019cd3094612mr4911476plp.6.1683384563669;
        Sat, 06 May 2023 07:49:23 -0700 (PDT)
Received: from [172.27.224.4] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902bd8500b0019a773419a6sm3719391pls.170.2023.05.06.07.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 May 2023 07:49:23 -0700 (PDT)
Message-ID: <7e8ab4a6-ace9-c284-972c-b818f569cfbf@gmail.com>
Date:   Sat, 6 May 2023 22:49:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not
 itlb_multihit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        zhuangel570 <zhuangel570@gmail.com>
Cc:     lirongqing@baidu.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        kvm@vger.kernel.org, x86@kernel.org
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com>
 <CANZk6aTqiOtJiriSUtZ3myod5hcbV8fb7NA8O2YmUo5PrFyTYw@mail.gmail.com>
 <ZFVAd+SRpnEkw5tx@google.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <ZFVAd+SRpnEkw5tx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2023 1:44 AM, Sean Christopherson wrote:
> Lightly tested.  This is what I'm thinking for a "never" param.  Unless someone
> has an alternative idea, I'll post a formal patch after more testing.
> 
> ---
>   arch/x86/kvm/mmu/mmu.c | 41 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..14713c050196 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -58,6 +58,8 @@
>   
>   extern bool itlb_multihit_kvm_mitigation;
>   
> +static bool nx_hugepage_mitigation_hard_disabled;
> +
>   int __read_mostly nx_huge_pages = -1;
>   static uint __read_mostly nx_huge_pages_recovery_period_ms;
>   #ifdef CONFIG_PREEMPT_RT
> @@ -67,12 +69,13 @@ static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
>   static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
>   #endif
>   
> +static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp);
>   static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
>   static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp);
>   
>   static const struct kernel_param_ops nx_huge_pages_ops = {
>   	.set = set_nx_huge_pages,
> -	.get = param_get_bool,
> +	.get = get_nx_huge_pages,
>   };
>   
>   static const struct kernel_param_ops nx_huge_pages_recovery_param_ops = {
> @@ -6844,6 +6847,14 @@ static void mmu_destroy_caches(void)
>   	kmem_cache_destroy(mmu_page_header_cache);
>   }
>   
> +static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
> +{
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return sprintf(buffer, "never\n");
> +
> +	return param_get_bool(buffer, kp);
> +}
> +
>   static bool get_nx_auto_mode(void)
>   {
>   	/* Return true when CPU has the bug, and mitigations are ON */
> @@ -6860,15 +6871,29 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>   	bool old_val = nx_huge_pages;
>   	bool new_val;
>   
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return -EPERM;
> +
>   	/* In "auto" mode deploy workaround only if CPU has the bug. */
> -	if (sysfs_streq(val, "off"))
> +	if (sysfs_streq(val, "off")) {
>   		new_val = 0;
> -	else if (sysfs_streq(val, "force"))
> +	} else if (sysfs_streq(val, "force")) {
>   		new_val = 1;
> -	else if (sysfs_streq(val, "auto"))
> +	} else if (sysfs_streq(val, "auto")) {
>   		new_val = get_nx_auto_mode();
> -	else if (kstrtobool(val, &new_val) < 0)
> +	} if (sysfs_streq(val, "never")) {

if --> else if?

And, what's the difference between "off" and "never"?

> +		new_val = 0;
> +
> +		mutex_lock(&kvm_lock);
> +		if (!list_empty(&vm_list)) {
> +			mutex_unlock(&kvm_lock);
> +			return -EBUSY;
> +		}
> +		nx_hugepage_mitigation_hard_disabled = true;
> +		mutex_unlock(&kvm_lock);
> +	} else if (kstrtobool(val, &new_val) < 0) {
>   		return -EINVAL;
> +	}
>   
>   	__set_nx_huge_pages(new_val);
>   
> @@ -7006,6 +7031,9 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>   	uint old_period, new_period;
>   	int err;
>   
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return -EPERM;
> +
>   	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
>   
>   	err = param_set_uint(val, kp);
> @@ -7161,6 +7189,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>   {
>   	int err;
>   
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return 0;
> +
I suggest

	if (!nx_hugepage_mitigation_hard_disabled) {
		create worker thread
	}

As this func name is kvm_mmu_post_init_vm(), 
nx_hugepage_mitigation_hard_disabled mean don't need to create the worker 
thread, but not don't need to do post init, although currently the only 
stuff in post init is to create work thread of nx_hugepage, but for the 
sake of future stuff.

>   	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
>   					  "kvm-nx-lpage-recovery",
>   					  &kvm->arch.nx_huge_page_recovery_thread);
> 
> base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac


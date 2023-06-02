Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902FF71F9DC
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 08:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjFBGHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 02:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjFBGHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 02:07:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4367019A;
        Thu,  1 Jun 2023 23:06:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-650c89c7e4fso1405212b3a.0;
        Thu, 01 Jun 2023 23:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685686019; x=1688278019;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AJMzvO4E/sXaVzE/6bU7plmF8MfXT5VBc3za1rua5WE=;
        b=C47aROV7ljKY88UQwUDEuIQHv3lyGAciOwzl3vXALRo3gQPAHnoc4h7avhSHzNA8qL
         LqxyjJMmdNpFlWPsPFR/SqrzpFaHpcKdQvsRwv1xPhOdO5skAowMF/V1YzrTYHhnLG/9
         JxF5vQg0HG/sBd4xohDqLRgG7NVEkslA7uzXy9htOvc+tISPSdWOEU72c1wPQ9sgepOB
         kCgcC3lOmcnzLrNNBYEoG3Y6qMFFyDv/U7aFGfENMt3eArPr4CkQV4+KfAZXWPNMdTsp
         n4TcikBCBoZw48kkt+h71tjkdI+WLvLJMQgdZzDDQBYDdk+NkwZKC8h+GMJfRzGGnQEK
         vYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685686019; x=1688278019;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AJMzvO4E/sXaVzE/6bU7plmF8MfXT5VBc3za1rua5WE=;
        b=RYKZJl68fojHoDpO/CnlTiOzM2JwphrlZyhv2A1iEnMW9DB2UOfrADHK9CjjmiNsIB
         fQT/C0rXIJhJIQWQA6jm/+IS1TllQw0PjxP+F+TW+GSNk6DEeP4f+xItM52LkpZSAN1z
         OaFs1C8+sWMStz+kjKADgQTDmemex1Y3iyDY7n+xDnzNCtrx7EPJiYfZAD5ccKZ72XIk
         hh8ZTmZNAq3yCeodO849u6zJPXpk56A9yJbkoUtPUPaERlffJ0c8JWaxRWvCJXZDOgLn
         wpbEeCBAx9ZKJx7jDjR3wVRDaok2dFZFc/uerneSpiJw3iUW99SUycvQ7c27cAWQ39AD
         PurA==
X-Gm-Message-State: AC+VfDxotmwwcydjcsVkwWDTfN3L9Zu0jkDifdE1z1Kspj0zZqDe2hlv
        Isns8bTX31W5l2IodMVRpcY=
X-Google-Smtp-Source: ACHHUZ5xvCYxxt1Wg4wY/zJbGVqUSdUcj6pNS0JXhYCT4EpUjBPnxGj22wV9QHEkDpuJnWzMl797FA==
X-Received: by 2002:a05:6a00:14c1:b0:650:9ee:c6c6 with SMTP id w1-20020a056a0014c100b0065009eec6c6mr11271572pfu.19.1685686018716;
        Thu, 01 Jun 2023 23:06:58 -0700 (PDT)
Received: from [172.27.224.14] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id m15-20020aa7900f000000b00652f5bd894esm248590pfo.177.2023.06.01.23.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 23:06:58 -0700 (PDT)
Message-ID: <28bd9d11-282f-bb22-66f5-d3d9165d4adf@gmail.com>
Date:   Fri, 2 Jun 2023 14:06:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Kai Huang <kai.huang@intel.com>
References: <20230602005859.784190-1-seanjc@google.com>
Content-Language: en-US
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20230602005859.784190-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/2023 8:58 AM, Sean Christopherson wrote:
> Add a "never" option to the nx_huge_pages module param to allow userspace
> to do a one-way hard disabling of the mitigation, and don't create the
> per-VM recovery threads when the mitigation is hard disabled.  Letting
> userspace pinky swear that userspace doesn't want to enable NX mitigation
> (without reloading KVM) allows certain use cases to avoid the latency
> problems associated with spawning a kthread for each VM.
> 
> E.g. in FaaS use cases, the guest kernel is trusted and the host may
> create 100+ VMs per logical CPU, which can result in 100ms+ latencies when
> a burst of VMs is created.
> 
> Reported-by: Li RongQing <lirongqing@baidu.com>
> Closes: https://lore.kernel.org/all/1679555884-32544-1-git-send-email-lirongqing@baidu.com
> Cc: Yong He <zhuangel570@gmail.com>
> Cc: Robert Hoo <robert.hoo.linux@gmail.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 41 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..2ed38916b904 100644
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
> +	} else if (sysfs_streq(val, "never")) {
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

IIUC, (Initially) "auto_off"/"off" --> create some VM --> turn to "never", 
the created VMs still have those kthreads, but can never be used, until 
destroyed with VM.

Is this designed/accepted pattern?

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
>   	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
>   					  "kvm-nx-lpage-recovery",
>   					  &kvm->arch.nx_huge_page_recovery_thread);
> 
> base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f


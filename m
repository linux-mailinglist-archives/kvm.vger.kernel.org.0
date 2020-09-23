Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221A227502B
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 07:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgIWFCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 01:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgIWFC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 01:02:29 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DA0C061755;
        Tue, 22 Sep 2020 22:02:29 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u24so2818505pgi.1;
        Tue, 22 Sep 2020 22:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pCg8OII21fM9qftK3YuQLgHrdBxiyeL+P1pf3mbhjTQ=;
        b=VEZOYcmAJ53idShJbXFl6a9HCCcv3n5EWI9bUImw9J+mTDyDhddT9pnkzHTIS9M7PL
         U0yVzK0xF/AMNFLpHz1AbX5tzRPaCyLDwV+a6cUCm1cgDBFRXLNeeHWQEA6es70hh3Z+
         eGLjHWS0RpilNPVaaiPmQ9ySxt+Q+bYcINDX4+0reXiGfx4Dt1bCMfFqWKkeckCmTrtr
         jI2in1hdinm5VfWRR8MvqOZMI1Ja0q2K4vh7D8CWS6+Du/x4bx7ZcIGFoR0dzUbvss9D
         NS+gTD0PL9yResD5G8DyjdHqgBCbweOwLgbP8zUinsiek0rxJe7iwsOGuHpNYnQeRkNM
         /kCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pCg8OII21fM9qftK3YuQLgHrdBxiyeL+P1pf3mbhjTQ=;
        b=qMeSu/uUOf7AVLhA8YNtWgCdV/Szxe8ixidJmXsco1yE+Exhah7VbWlzDZyLMuMh/F
         lvXTcq4a7/Ye9pNb6FA4lnGZ0sMMUcW30bJbC2/lLLzdDtw4TPwHhOte+xVG7Ojq1NdW
         odxc36ThFmQM02O//sklZmWsEeLqWOBmqB2rzFZFoiQf66hOTtrd1x+jkoxFi/gSAQOs
         d9Ttb7gGo9d9nosPfZHU50PG19K3ddsgpK231kYn4G3NLsUhmjuLAx1jDirqJeaOnftR
         pJQsbyRpsx2cWwVsnXipZQYTLOc0aHLBVrTiKLZyNmF5th021rUiB/n5SNo79YR2oNNL
         M9Gg==
X-Gm-Message-State: AOAM531ZQpDRidoh9R3POLSNwy/La31D5D9elvlMglqbhSwAlKm+LjFW
        mD9sQHXjp6o4dhp3/uqwjQ==
X-Google-Smtp-Source: ABdhPJwCv/KxBqpu94zRq4IhcahiAW3XOfSyNO9qIZ5rb3W4V8S1vqp6jBHJRPQcfXCaJpgLPqpbbw==
X-Received: by 2002:a63:d604:: with SMTP id q4mr4666582pgg.238.1600837349371;
        Tue, 22 Sep 2020 22:02:29 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id 25sm10543579pgo.34.2020.09.22.22.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 22:02:28 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: Fix the build error
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        lihaiwei@tencent.com, kernel test robot <lkp@intel.com>
References: <20200914091148.95654-1-lihaiwei.kernel@gmail.com>
 <20200914091148.95654-2-lihaiwei.kernel@gmail.com>
 <1810e3e5-8286-29e0-ff10-636d6c32df6d@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <d5ff32e8-1dec-da50-0499-20db08e492fe@gmail.com>
Date:   Wed, 23 Sep 2020 13:02:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <1810e3e5-8286-29e0-ff10-636d6c32df6d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/9/20 21:09, Paolo Bonzini wrote:
> On 14/09/20 11:11, lihaiwei.kernel@gmail.com wrote:
>> From: Haiwei Li <lihaiwei@tencent.com>
>>
>> When CONFIG_SMP is not set, an build error occurs with message "error:
>> use of undeclared identifier 'kvm_send_ipi_mask_allbutself'"
>>
>> Fixes: 0f990222108d ("KVM: Check the allocation of pv cpu mask", 2020-09-01)
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
>> ---
>>   arch/x86/kernel/kvm.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 1b51b727b140..7e8be0421720 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -797,7 +797,9 @@ static __init int kvm_alloc_cpumask(void)
>>   			}
>>   		}
>>   
>> +#if defined(CONFIG_SMP)
>>   	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>> +#endif
>>   	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
>>   	return 0;
>>   
>>
> 
> If CONFIG_SMP is not set you don't need kvm_alloc_cpumask or
> pv_ops.mmu.flush_tlb_others at all.  Can you squash these two into the
> original patch and re-submit for 5.10?

Hi, Paolo

I'm a little confused. Function kvm_flush_tlb_others doesn't seem to be 
related to CONFIG_SMP.

And my patch like:

---
  arch/x86/kernel/kvm.c | 27 ++++++++++++++++++++++++---
  1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9663ba31347c..1e5da6db519c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -553,7 +553,6 @@ static void kvm_send_ipi_mask_allbutself(const 
struct cpumask *mask, int vector)
  static void kvm_setup_pv_ipi(void)
  {
  	apic->send_IPI_mask = kvm_send_ipi_mask;
-	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
  	pr_info("setup PV IPIs\n");
  }

@@ -619,6 +618,11 @@ static void kvm_flush_tlb_others(const struct 
cpumask *cpumask,
  	struct kvm_steal_time *src;
  	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);

+	if (unlikely(!flushmask)) {
+		native_flush_tlb_others(cpumask, info);
+		return;
+	}
+
  	cpumask_copy(flushmask, cpumask);
  	/*
  	 * We have to call flush only on online vCPUs. And
@@ -765,6 +769,14 @@ static __init int activate_jump_labels(void)
  }
  arch_initcall(activate_jump_labels);

+static void kvm_free_cpumask(void)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
+}
+
  static __init int kvm_alloc_cpumask(void)
  {
  	int cpu;
@@ -783,11 +795,20 @@ static __init int kvm_alloc_cpumask(void)

  	if (alloc)
  		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
+			if (!zalloc_cpumask_var_node(
+				per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu)))
+				goto zalloc_cpumask_fail;
  		}

+#if defined(CONFIG_SMP)
+	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
+#endif
  	return 0;
+
+zalloc_cpumask_fail:
+	kvm_free_cpumask();
+	return -ENOMEM;
  }
  arch_initcall(kvm_alloc_cpumask);

--
2.18.4

Do you have any suggestion? Thanks.

     Haiwei

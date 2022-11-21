Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754636320D3
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 12:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiKULih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 06:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiKULiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 06:38:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4B1B9621
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 03:35:40 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id cl5so19415724wrb.9
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 03:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ByHtPoB+P7/uH1wr4e3X4UYeEScZOfqXPAiucxdATp8=;
        b=sjSzqdWLBtvQ6hiwR1lRYNWjaJmOBMN5l6v1pjNeyiMKF7fJeEiz344kH2iLfvrqiR
         qemR1hhqRr/uTXkArjaieC/bcfhySa1VYXblfJnONr7LluVbyBmq7oLT20zOj8gayMuE
         n7DDq0J9xCSn6oEorgxlMCOQTse1UFROUgcimIMth1W8xku1mp7cs6gT6cWQI97XoUU7
         ZSBxJRQdOxknG9Ji2tmKZpabqOKzQpDv0Y8xImvzMbplsZnNnxBPH9CNeLoAlJ+omXZT
         42YvuFeXiDOrNR6EcSaEfrRiGK5xl/qm3T5HtRB2i4Vpig+d1sREDdhsqPhUtwGJLhq9
         9TKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ByHtPoB+P7/uH1wr4e3X4UYeEScZOfqXPAiucxdATp8=;
        b=5pNKQPwM2/5xUdE5eOOuwZY+Up5G6t7CgagkVWOjFO+xcigyLM8dFEc0BAMUwtjOra
         8PX7zR0pjJoKf4m3CwZdgkCwlKIiypMstrKGqaNnxLf8I5a407BE79WcMJNSO1fSIVTA
         IzYmXUZO8PpaCnkQFPjaKYfGmQq1chYrrLBZ8MWSA2O2x4labTuZMgkBlHTqHnU/jnID
         f6zB1Dh2na7ML1v6tJGvNQfKp6DoDeYsgjd5FTz6dOe7KDOghPF9ATc+Z93JWRasZTZF
         rPlNslriUXfB4T7gbhQ3jxhkLa9LcjtINIz3DxAE3wQGNl38O5hS66qibkMfVsIay8yJ
         2CfA==
X-Gm-Message-State: ANoB5pnbciTG3Np545Kd0Rnm5NJzMcsWLFgadVEinKK2IjRiiysXionW
        x0cYKdzeLDA5tFZ9mpyKnvt5q6iPm3xQSA==
X-Google-Smtp-Source: AA0mqf7R8C9DC55+7v6/DaLR9OdftSxbDDkOMkIs3KW9sDZxZ63nyWBXpQHGR4EY4DA83rt4qXWY9w==
X-Received: by 2002:adf:dd81:0:b0:236:88a2:f072 with SMTP id x1-20020adfdd81000000b0023688a2f072mr10848719wrl.516.1669030538622;
        Mon, 21 Nov 2022 03:35:38 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d67ca000000b002302dc43d77sm1909488wrw.115.2022.11.21.03.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 03:35:37 -0800 (PST)
Message-ID: <dcaf828f-5959-e49e-a854-632814772cc1@linaro.org>
Date:   Mon, 21 Nov 2022 12:35:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [RFC PATCH 1/1] Dirty quota-based throttling of vcpus
Content-Language: en-US
To:     Shivam Kumar <shivam.kumar1@nutanix.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
 <20221120225458.144802-2-shivam.kumar1@nutanix.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221120225458.144802-2-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 20/11/22 23:54, Shivam Kumar wrote:
> Introduces a (new) throttling scheme where QEMU defines a limit on the dirty
> rate of each vcpu of the VM. This limit is enfored on the vcpus in small
> intervals (dirty quota intervals) by allowing the vcpus to dirty only as many
> pages in these intervals as to maintain a dirty rate below the set limit.
> 
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>   accel/kvm/kvm-all.c       | 91 +++++++++++++++++++++++++++++++++++++++
>   include/exec/memory.h     |  3 ++
>   include/hw/core/cpu.h     |  5 +++
>   include/sysemu/kvm_int.h  |  1 +
>   linux-headers/linux/kvm.h |  9 ++++
>   migration/migration.c     | 22 ++++++++++
>   migration/migration.h     | 31 +++++++++++++
>   softmmu/memory.c          | 64 +++++++++++++++++++++++++++
>   8 files changed, 226 insertions(+)


>   void migrate_set_state(int *state, int old_state, int new_state);
> diff --git a/softmmu/memory.c b/softmmu/memory.c
> index bc0be3f62c..8f725a9b89 100644
> --- a/softmmu/memory.c
> +++ b/softmmu/memory.c
> @@ -12,6 +12,7 @@
>    * Contributions after 2012-01-13 are licensed under the terms of the
>    * GNU GPL, version 2 or (at your option) any later version.
>    */
> +#include <linux/kvm.h>
>   
>   #include "qemu/osdep.h"
>   #include "qemu/log.h"
> @@ -34,6 +35,10 @@
>   #include "hw/boards.h"
>   #include "migration/vmstate.h"
>   #include "exec/address-spaces.h"
> +#include "hw/core/cpu.h"
> +#include "exec/target_page.h"
> +#include "migration/migration.h"
> +#include "sysemu/kvm_int.h"
>   
>   //#define DEBUG_UNASSIGNED
>   
> @@ -2869,6 +2874,46 @@ static unsigned int postponed_stop_flags;
>   static VMChangeStateEntry *vmstate_change;
>   static void memory_global_dirty_log_stop_postponed_run(void);
>   
> +static void init_vcpu_dirty_quota(CPUState *cpu, run_on_cpu_data arg)
> +{
> +    uint64_t current_time = qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
> +    cpu->kvm_run->dirty_quota = 1;
> +    cpu->dirty_quota_expiry_time = current_time;
> +}
> +
> +void dirty_quota_migration_start(void)
> +{
> +    if (!kvm_state->dirty_quota_supported) {

You are accessing an accelerator-specific variable in an 
accelerator-agnostic file, this doesn't sound correct.

You might introduce some hooks in AccelClass and implement them in
accel/kvm/. See for example gdbstub_supported_sstep_flags() and
kvm_gdbstub_sstep_flags().

> +        return;
> +    }
> +
> +    MigrationState *s = migrate_get_current();
> +    /* Assuming initial bandwidth to be 128 MBps. */
> +    double pages_per_second = (((double) 1e9) / 8.0) /
> +                                    (double) qemu_target_page_size();
> +    uint32_t nr_cpus;
> +    CPUState *cpu;
> +
> +    CPU_FOREACH(cpu) {
> +        nr_cpus++;
> +    }
> +    /*
> +     * Currently we are hardcoding this to 2. There are plans to allow the user
> +     * to manually select this ratio.
> +     */
> +    s->dirty_quota_throttle_ratio = 2;
> +    qatomic_set(&s->per_vcpu_dirty_rate_limit,
> +                pages_per_second / s->dirty_quota_throttle_ratio / nr_cpus);
> +
> +    qemu_spin_lock(&s->common_dirty_quota_lock);
> +    s->common_dirty_quota = 0;
> +    qemu_spin_unlock(&s->common_dirty_quota_lock);
> +
> +    CPU_FOREACH(cpu) {
> +        run_on_cpu(cpu, init_vcpu_dirty_quota, RUN_ON_CPU_NULL);
> +    }
> +}
> +
>   void memory_global_dirty_log_start(unsigned int flags)
>   {
>       unsigned int old_flags;
> @@ -2891,6 +2936,7 @@ void memory_global_dirty_log_start(unsigned int flags)
>       trace_global_dirty_changed(global_dirty_tracking);
>   
>       if (!old_flags) {
> +        dirty_quota_migration_start();
>           MEMORY_LISTENER_CALL_GLOBAL(log_global_start, Forward);
>           memory_region_transaction_begin();
>           memory_region_update_pending = true;
> @@ -2898,6 +2944,23 @@ void memory_global_dirty_log_start(unsigned int flags)
>       }
>   }
>   
> +static void reset_vcpu_dirty_quota(CPUState *cpu, run_on_cpu_data arg)
> +{
> +    cpu->kvm_run->dirty_quota = 0;
> +}
> +
> +void dirty_quota_migration_stop(void)
> +{
> +    if (!kvm_state->dirty_quota_supported) {
> +        return;
> +    }
> +
> +    CPUState *cpu;
> +    CPU_FOREACH(cpu) {
> +        run_on_cpu(cpu, reset_vcpu_dirty_quota, RUN_ON_CPU_NULL);
> +    }
> +}
> +
>   static void memory_global_dirty_log_do_stop(unsigned int flags)
>   {
>       assert(flags && !(flags & (~GLOBAL_DIRTY_MASK)));
> @@ -2907,6 +2970,7 @@ static void memory_global_dirty_log_do_stop(unsigned int flags)
>       trace_global_dirty_changed(global_dirty_tracking);
>   
>       if (!global_dirty_tracking) {
> +        dirty_quota_migration_stop();
>           memory_region_transaction_begin();
>           memory_region_update_pending = true;
>           memory_region_transaction_commit();


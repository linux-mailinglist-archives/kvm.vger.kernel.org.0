Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BBE4AE608
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 01:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237906AbiBIAaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 19:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiBIAaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 19:30:06 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CE7C061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 16:30:05 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id n23so1394224pfo.1
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 16:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0/g46XYpdY+83L4Nhq5fUK5DmKHZmZsCeq+A2IUv7aw=;
        b=E/jx1S3/PFTXHZRylu69yTSRn8YTQ0PkaCRbn39F3+KAS1DSAX3C2O/WQjfRGj1HPh
         arlyqsg2NtmZcg859X1cSmIUbKBBsZR7362pjWhOXloDdle7pw/GtPoxGXI75yVpOkcO
         KG8I7vklsmfDzC+KKeOx4l2MntOna5PUwizngsWFX3+82Ozjviu5BQhLaLDgWiLwsTrF
         GMZmvS5lqb6021b9DprdPMWYgAVuXNQ2KVlKh/bBWkkikau8KjB8nMX8K6Iqe6W65Au8
         29FAamrwrU3AjkDpyZrS4xxliNErLptk+7ekvauMGR45F0wrYJmnnY15Ye+QVku9DzPp
         ZbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0/g46XYpdY+83L4Nhq5fUK5DmKHZmZsCeq+A2IUv7aw=;
        b=zfcMIEc3mRJ3OHGBLg/AtEhWShI+VOSCejfTXbdAbE1OOUgzlHT77/7/BDyLy+/sM3
         94vm4l8sbVeBuFHuoknkazQPt7dFU8l1yxUksIGrJZ4mYHxeQlfDJq+EQs98JardAMf6
         91QK56ViVzqdn8y2W4Mz9tl23azOOOFo86asySCmhIzVLpuXA7Pu2DWs58zn2QJxRHr+
         lqUZl7Gw8UYw/r9LkA71jduZXdrDX2hjyhwrCrtn99/WnEY7XSNAAleDS732tDeO5cDf
         3AJtEsFAyngokJ3oizDxHQ4d4DJ8/VOahtV9DklgpVulZbhqJC3yyGYQs2RdaL7MUQ44
         Y70w==
X-Gm-Message-State: AOAM531XxjNa3wpmUXqkAwje5pf7aVkg0EZ8O8tIQmjFur/xweRtMjuq
        vl0sVEbCtPt+lHCA/TUl7x0kpQ==
X-Google-Smtp-Source: ABdhPJyyHkWQ9J1fF0gJ63uF+8ojHUZgEEO0HMj5VMdg1+GS49MI/QdjLdYIdi3X9v/mLKNy9Qce4w==
X-Received: by 2002:a63:8041:: with SMTP id j62mr5488060pgd.605.1644366604726;
        Tue, 08 Feb 2022 16:30:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l12sm3841830pjq.57.2022.02.08.16.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 16:30:04 -0800 (PST)
Date:   Wed, 9 Feb 2022 00:29:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <YgMLBYl7P1jFA2xe@google.com>
References: <20220118064430.3882337-1-chao.gao@intel.com>
 <20220118064430.3882337-4-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118064430.3882337-4-chao.gao@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022, Chao Gao wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 148f7169b431..528741601122 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4856,13 +4856,25 @@ static void hardware_enable_nolock(void *junk)
>  	}
>  }
>  
> -static int kvm_starting_cpu(unsigned int cpu)
> +static int kvm_online_cpu(unsigned int cpu)
>  {
> +	int ret = 0;
> +
>  	raw_spin_lock(&kvm_count_lock);
> -	if (kvm_usage_count)
> +	/*
> +	 * Abort the CPU online process if hardware virtualization cannot
> +	 * be enabled. Otherwise running VMs would encounter unrecoverable
> +	 * errors when scheduled to this CPU.
> +	 */
> +	if (kvm_usage_count) {


>  		hardware_enable_nolock(NULL);
> +		if (atomic_read(&hardware_enable_failed)) {

This needs:

		atomic_set(&hardware_enable_failed, 0);

otherwise failure to online one CPU will prevent onlining other non-broken CPUs.
It's probably worth adding a WARN_ON_ONCE above this too, e.g.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e034cbe813..b25a00c76b3a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4863,8 +4863,11 @@ static int kvm_online_cpu(unsigned int cpu)
         * errors when scheduled to this CPU.
         */
        if (kvm_usage_count) {
+               WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
+
                hardware_enable_nolock(NULL);
                if (atomic_read(&hardware_enable_failed)) {
+                       atomic_set(&hardware_enable_failed, 0);
                        ret = -EIO;
                        pr_warn("kvm: abort onlining CPU%d", cpu);
                }


> +			ret = -EIO;
> +			pr_warn("kvm: abort onlining CPU%d", cpu);

This is somewhat redundant with the pr_info() message in hardware_enable_nolock().
What about adding the below as a prep patch?  I think/hope it would be obvious to
the user/admin that onlining the CPU failed?  E.g. this for the output

  kvm: enabling virtualization on CPU2 failed during hardware_enable_all()

From: Sean Christopherson <seanjc@google.com>
Date: Tue, 8 Feb 2022 13:26:19 -0800
Subject: [PATCH] KVM: Provide more information in kernel log if hardware
 enabling fails

Provide the name of the calling function to hardware_enable_nolock() and
include it in the error message to provide additional information on
exactly what path failed.

Opportunistically bump the pr_info() to pr_warn(), failure to enable
virtualization support is warn-worthy as _something_ is wrong with the
system.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be614a6325e4..23481fd746aa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4833,7 +4833,7 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };

-static void hardware_enable_nolock(void *junk)
+static void hardware_enable_nolock(void *caller_name)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -4848,7 +4848,8 @@ static void hardware_enable_nolock(void *junk)
 	if (r) {
 		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
 		atomic_inc(&hardware_enable_failed);
-		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
+		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
+			cpu, (const char *)caller_name);
 	}
 }

@@ -4856,7 +4857,7 @@ static int kvm_starting_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
+		hardware_enable_nolock((void *)__func__);
 	raw_spin_unlock(&kvm_count_lock);
 	return 0;
 }
@@ -4905,7 +4906,7 @@ static int hardware_enable_all(void)
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
 		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);

 		if (atomic_read(&hardware_enable_failed)) {
 			hardware_disable_all_nolock();
@@ -5530,7 +5531,7 @@ static void kvm_resume(void)
 #ifdef CONFIG_LOCKDEP
 		WARN_ON(lockdep_is_held(&kvm_count_lock));
 #endif
-		hardware_enable_nolock(NULL);
+		hardware_enable_nolock((void *)__func__);
 	}
 }


base-commit: 357ef9d9c0728bc2bbb9810c662263bba6b8dbc7
--


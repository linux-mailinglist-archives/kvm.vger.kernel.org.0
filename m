Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41815ACD23
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 09:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbiIEHtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 03:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbiIEHts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 03:49:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83059642D;
        Mon,  5 Sep 2022 00:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662364187; x=1693900187;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FAccm/ScXdQpvE2J7OirVwkh6ImZ/zcbX6R20Q7tnVE=;
  b=XfpOsFT40GBQKW/w2575WIffurQnqELKFh1Z+j0V8XvDzekzmv5XCivJ
   DcbSQQ05MV/bir4xvhmdIomlGolfLY9lEHCM3PVPmaWoZz0ZpX8Wycpy3
   hPfWuFdFuNV2DR3zw/4J/jHI4LAX3J8FAAdRzWSZqVg0l9qYZvm5dHwGa
   CSWLY2mYC+uNcHHL7LaocxI0cxk/6f5lu8Sx2gq9lwwVwEUFKI29rodO7
   lw+O2RXascDsa7ya4Xi+xayK6PHwZcEjBzp+y0QBAWz+3SdfzSjDcD5/Y
   5flB/5lY4YMPObTl9BZOc21CIK9RwBHSJFY1gGPNl+p6naeFGSWwgOmlG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="279347696"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="279347696"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 00:49:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="675176865"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 05 Sep 2022 00:49:42 -0700
Date:   Mon, 5 Sep 2022 15:49:41 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 07/22] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <20220905074941.apb7wmkhz47zx3c6@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <04733398cea6ec59827e886a2430482fc258933a.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04733398cea6ec59827e886a2430482fc258933a.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:42PM -0700, isaku.yamahata@intel.com wrote:
> From: Chao Gao <chao.gao@intel.com>
>
> The CPU STARTING section doesn't allow callbacks to fail. Move KVM's
> hotplug callback to ONLINE section so that it can abort onlining a CPU in
> certain cases to avoid potentially breaking VMs running on existing CPUs.
> For example, when kvm fails to enable hardware virtualization on the
> hotplugged CPU.
>
> Place KVM's hotplug state before CPUHP_AP_SCHED_WAIT_EMPTY as it ensures
> when offlining a CPU, all user tasks and non-pinned kernel tasks have left
> the CPU, i.e. there cannot be a vCPU task around. So, it is safe for KVM's
> CPU offline callback to disable hardware virtualization at that point.
> Likewise, KVM's online callback can enable hardware virtualization before
> any vCPU task gets a chance to run on hotplugged CPUs.
>
> KVM's CPU hotplug callbacks are renamed as well.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Link: https://lore.kernel.org/r/20220216031528.92558-6-chao.gao@intel.com
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  include/linux/cpuhotplug.h |  2 +-
>  virt/kvm/kvm_main.c        | 30 ++++++++++++++++++++++--------
>  2 files changed, 23 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 7337414e4947..de45be38dd27 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -185,7 +185,6 @@ enum cpuhp_state {
>  	CPUHP_AP_CSKY_TIMER_STARTING,
>  	CPUHP_AP_TI_GP_TIMER_STARTING,
>  	CPUHP_AP_HYPERV_TIMER_STARTING,
> -	CPUHP_AP_KVM_STARTING,
>  	/* Must be the last timer callback */
>  	CPUHP_AP_DUMMY_TIMER_STARTING,
>  	CPUHP_AP_ARM_XEN_STARTING,
> @@ -200,6 +199,7 @@ enum cpuhp_state {
>
>  	/* Online section invoked on the hotplugged CPU from the hotplug thread */
>  	CPUHP_AP_ONLINE_IDLE,
> +	CPUHP_AP_KVM_ONLINE,
>  	CPUHP_AP_SCHED_WAIT_EMPTY,
>  	CPUHP_AP_SMPBOOT_THREADS,
>  	CPUHP_AP_X86_VDSO_VMA_ONLINE,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 278eb6cc7cbe..db1303e2abc9 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5011,13 +5011,27 @@ static void hardware_enable_nolock(void *caller_name)
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
> +		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> +
>  		hardware_enable_nolock((void *)__func__);
> +		if (atomic_read(&hardware_enable_failed)) {
> +			atomic_set(&hardware_enable_failed, 0);
> +			ret = -EIO;
> +		}
> +	}
>  	raw_spin_unlock(&kvm_count_lock);
> -	return 0;
> +	return ret;
>  }
>
>  static void hardware_disable_nolock(void *junk)
> @@ -5030,7 +5044,7 @@ static void hardware_disable_nolock(void *junk)
>  	kvm_arch_hardware_disable();
>  }
>
> -static int kvm_dying_cpu(unsigned int cpu)
> +static int kvm_offline_cpu(unsigned int cpu)
>  {
>  	raw_spin_lock(&kvm_count_lock);
>  	if (kvm_usage_count)
> @@ -5841,8 +5855,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  			goto out_free_2;
>  	}
>
> -	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
> -				      kvm_starting_cpu, kvm_dying_cpu);
> +	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> +				      kvm_online_cpu, kvm_offline_cpu);
>  	if (r)
>  		goto out_free_2;
>  	register_reboot_notifier(&kvm_reboot_notifier);
> @@ -5903,7 +5917,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	kmem_cache_destroy(kvm_vcpu_cache);
>  out_free_3:
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
> -	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
> +	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
>  out_free_2:
>  	kvm_arch_hardware_unsetup();
>  out_free_1:
> @@ -5929,7 +5943,7 @@ void kvm_exit(void)
>  	kvm_async_pf_deinit();
>  	unregister_syscore_ops(&kvm_syscore_ops);
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
> -	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
> +	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
>  	on_each_cpu(hardware_disable_nolock, NULL, 1);
>  	kvm_arch_hardware_unsetup();
>  	kvm_arch_exit();
> --
> 2.25.1
>

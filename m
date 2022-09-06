Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FEA5ADFB8
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 08:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiIFGZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 02:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiIFGZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 02:25:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4408748CA0;
        Mon,  5 Sep 2022 23:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662445508; x=1693981508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=353raL80awxDlgmu10YKemTNIBIW1838Ug9w266GnMg=;
  b=WLJgVMhRUQvGtBpoc2nhflcAI5othoqNWWrSlhFUJZ7PP23gcQKNc4nu
   p50LY7QiDa8IWRrZu8xQstVv9wpl/OoKnaRqEUwvC2k5HtrKUkPY8mbPS
   uYAG7UsTTYV1T6ZES/afJdujj970VwdYaa/oi2ctW/lJ+R76Lk7oNZd2c
   H148H5wsiX/jUKeNcjm8lJGz6cJ8aL5yyGodN54AGD58DoXb6kSmcbsJe
   5lgACXrXtULsSYVGcmHRoU16nQTjIEP3oJqRBJuacUrAVhsXRxIpne/sb
   thBrdnAd0PSfYGyuY1uft+PZnOCQA1he7VpM0aPz5pzW389Bx+ovHu2ox
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="279529400"
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="279529400"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 23:25:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="675547498"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 05 Sep 2022 23:25:03 -0700
Date:   Tue, 6 Sep 2022 14:25:02 +0800
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
Subject: Re: [PATCH v3 11/22] KVM: Add arch hooks for PM events with empty
 stub
Message-ID: <20220906062502.5rx6n5auoct7t3ei@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <22e86b718ae434e52957d5af9b4c7dd26b2a74ca.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e86b718ae434e52957d5af9b4c7dd26b2a74ca.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:46PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Add arch hooks for reboot, suspend, resume, and CPU-online/offline events
> with empty stub functions.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  include/linux/kvm_host.h |  6 +++++
>  virt/kvm/Makefile.kvm    |  2 +-
>  virt/kvm/kvm_arch.c      | 44 +++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      | 50 +++++++++++++++++++++++++---------------
>  4 files changed, 82 insertions(+), 20 deletions(-)
>  create mode 100644 virt/kvm/kvm_arch.c
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index eab352902de7..dd2a6d98d4de 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1448,6 +1448,12 @@ int kvm_arch_post_init_vm(struct kvm *kvm);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>  int kvm_arch_create_vm_debugfs(struct kvm *kvm);
>
> +int kvm_arch_suspend(int usage_count);
> +void kvm_arch_resume(int usage_count);
> +int kvm_arch_reboot(int val);
> +int kvm_arch_online_cpu(unsigned int cpu, int usage_count);
> +int kvm_arch_offline_cpu(unsigned int cpu, int usage_count);
> +
>  #ifndef __KVM_HAVE_ARCH_VM_ALLOC
>  /*
>   * All architectures that want to use vzalloc currently also
> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
> index 2c27d5d0c367..c4210acabd35 100644
> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -5,7 +5,7 @@
>
>  KVM ?= ../../../virt/kvm
>
> -kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> +kvm-y := $(KVM)/kvm_main.o $(KVM)/kvm_arch.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
>  kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
>  kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
>  kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
> diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
> new file mode 100644
> index 000000000000..4748a76bcb03
> --- /dev/null
> +++ b/virt/kvm/kvm_arch.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * kvm_arch.c: kvm default arch hooks for hardware enabling/disabling
> + * Copyright (c) 2022 Intel Corporation.
> + *
> + * Author:
> + *   Isaku Yamahata <isaku.yamahata@intel.com>
> + *                  <isaku.yamahata@gmail.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +/*
> + * Called after the VM is otherwise initialized, but just before adding it to
> + * the vm_list.
> + */
> +__weak int kvm_arch_post_init_vm(struct kvm *kvm)
> +{
> +	return 0;
> +}
> +
> +__weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
> +{
> +	return 0;
> +}
> +
> +__weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
> +{
> +	return 0;
> +}
> +
> +__weak int kvm_arch_reboot(int val)
> +{
> +	return NOTIFY_OK;
> +}
> +
> +__weak int kvm_arch_suspend(int usage_count)
> +{
> +	return 0;
> +}
> +
> +__weak void kvm_arch_resume(int usage_count)
> +{
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 082d5dbc8d7f..e62240fb8474 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -144,6 +144,7 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
>  #endif
>  static int hardware_enable_all(void);
>  static void hardware_disable_all(void);
> +static void hardware_disable_nolock(void *junk);
>
>  static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>
> @@ -1097,15 +1098,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
>  	return ret;
>  }
>
> -/*
> - * Called after the VM is otherwise initialized, but just before adding it to
> - * the vm_list.
> - */
> -int __weak kvm_arch_post_init_vm(struct kvm *kvm)
> -{
> -	return 0;
> -}
> -
>  /*
>   * Called just after removing the VM from the vm_list, but before doing any
>   * other destruction.
> @@ -5033,6 +5025,10 @@ static int kvm_online_cpu(unsigned int cpu)
>  		if (atomic_read(&hardware_enable_failed)) {
>  			atomic_set(&hardware_enable_failed, 0);
>  			ret = -EIO;
> +		} else {
> +			ret = kvm_arch_online_cpu(cpu, kvm_usage_count);
> +			if (ret)
> +				hardware_disable_nolock(NULL);
>  		}
>  	}
>  	mutex_unlock(&kvm_lock);
> @@ -5053,11 +5049,19 @@ static void hardware_disable_nolock(void *junk)
>
>  static int kvm_offline_cpu(unsigned int cpu)
>  {
> +	int ret = 0;
> +
>  	mutex_lock(&kvm_lock);
> -	if (kvm_usage_count)
> +	if (kvm_usage_count) {
>  		hardware_disable_nolock(NULL);
> +		ret = kvm_arch_offline_cpu(cpu, kvm_usage_count);
> +		if (ret) {
> +			(void)hardware_enable_nolock(NULL);
> +			atomic_set(&hardware_enable_failed, 0);
> +		}
> +	}
>  	mutex_unlock(&kvm_lock);
> -	return 0;
> +	return ret;
>  }
>
>  static void hardware_disable_all_nolock(void)
> @@ -5115,6 +5119,8 @@ static int hardware_enable_all(void)
>  static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
>  		      void *v)
>  {
> +	int r;
> +
>  	/*
>  	 * Some (well, at least mine) BIOSes hang on reboot if
>  	 * in vmx root mode.
> @@ -5123,8 +5129,15 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
>  	 */
>  	pr_info("kvm: exiting hardware virtualization\n");
>  	kvm_rebooting = true;
> +
> +	/* This hook is called without cpuhotplug disabled.  */
> +	cpus_read_lock();
> +	mutex_lock(&kvm_lock);
>  	on_each_cpu(hardware_disable_nolock, NULL, 1);
> -	return NOTIFY_OK;
> +	r = kvm_arch_reboot(val);
> +	mutex_unlock(&kvm_lock);
> +	cpus_read_unlock();
> +	return r;
>  }
>
>  static struct notifier_block kvm_reboot_notifier = {
> @@ -5718,11 +5731,10 @@ static int kvm_suspend(void)
>  	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
>  	 * locking.
>  	 */
> -	if (kvm_usage_count) {
> -		lockdep_assert_not_held(&kvm_lock);
> +	lockdep_assert_not_held(&kvm_lock);
> +	if (kvm_usage_count)
>  		hardware_disable_nolock(NULL);
> -	}
> -	return 0;
> +	return kvm_arch_suspend(kvm_usage_count);
>  }
>
e  static void kvm_resume(void)
> @@ -5734,10 +5746,10 @@ static void kvm_resume(void)
>  		 */
>  		return; /* FIXME: disable KVM */
>
> -	if (kvm_usage_count) {
> -		lockdep_assert_not_held(&kvm_lock);
> +	lockdep_assert_not_held(&kvm_lock);
> +	kvm_arch_resume(kvm_usage_count);
> +	if (kvm_usage_count)
>  		hardware_enable_nolock((void *)__func__);

Is single kvm_arch_{suspend,resume} enough?

The sequence is:

kvm_arch_resume()
hardware_enable_nolock()

But in patch 12 I see below code in x86's kvm_arch_resume():
...
if (!usage_count)
        return;
if (kvm_arch_hardware_enable())
        return;
...

So kvm_arch_resume() may depend on hardware enable, and it checks the
usage_count again, how about call kvm_arch_resume(bool
hardware_enabled) before/after the hardware_enable_nolock() (or even
give different functions with _before/_after suffix) for better
flexibility since it's common code for all architectures, e.g.

if (kvm_usage_count) {
   kvm_arch_resume(false);
   hardware_enable_nolock(__func__);
   kvm_arch_resumt(true);
}

> -	}
>  }
>
>  static struct syscore_ops kvm_syscore_ops = {
> --
> 2.25.1
>

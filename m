Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF2E5AC9CC
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 07:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiIEFaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 01:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiIEFap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 01:30:45 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F44725C5D;
        Sun,  4 Sep 2022 22:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662355844; x=1693891844;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TFBQ1DSUY+hfR/BmI0SQmMCM2w4Yrt6re0aaqSFCaas=;
  b=G8tZZrYQdhvVEAmm3RVXUXtIndIqnkSF7xSFCcIhs9QJ+dQL1f2wGHM0
   fmkQOtpsRgklHjucltIGTKHwLpTXTLDlfQtwwr7x4S4rAee38YdKRWK7x
   O+4C9m80wLgMb93tZMD83EmrF/EhbcizEOuLsnBG8Y8qAZsIJJDLa4sav
   DbWenmtWZ8yFNsgYPFIbqtv/GyJTYMsIqVSxeN6oBQuPaZ+RrPwACNQIB
   MzyBf/Lp1oW3BpBsQ8doxiI4TlM3hTvqXKiiE9CaQOAhQTVt5E2IqgdFE
   wyhnfFwHtcYkWNcACsjuRGyZbYg0UU8qBcw5eSLiW3JZvs5iNDsfM5Gzn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="283303106"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="283303106"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 22:30:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="675132183"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 04 Sep 2022 22:30:38 -0700
Date:   Mon, 5 Sep 2022 13:30:38 +0800
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
Subject: Re: [PATCH v3 01/22] KVM: x86: Drop kvm_user_return_msr_cpu_online()
Message-ID: <20220905053038.4yxctp7lzvy73l75@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <25ff8d1bbf41de4bcf93a184826bd57e140a465b.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25ff8d1bbf41de4bcf93a184826bd57e140a465b.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Thu, Sep 01, 2022 at 07:17:36PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> KVM/X86 uses user return notifier to switch MSR for guest or user space.
> Snapshot host values on CPU online, change MSR values for guest, and
> restore them on returning to user space.  The current code abuses
> kvm_arch_hardware_enable() which is called on kvm module initialization or
> CPU online.
>
> Remove such the abuse of kvm_arch_hardware_enable() by capturing the host
> value on the first change of the MSR value to guest VM instead of CPU
> online.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/kvm/x86.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 205ebdc2b11b..0e200fe44b35 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -196,6 +196,7 @@ module_param(eager_page_split, bool, 0644);
>
>  struct kvm_user_return_msrs {
>  	struct user_return_notifier urn;
> +	bool initialized;
>  	bool registered;
>  	struct kvm_user_return_msr_values {
>  		u64 host;
> @@ -409,18 +410,20 @@ int kvm_find_user_return_msr(u32 msr)
>  }
>  EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
>
> -static void kvm_user_return_msr_cpu_online(void)
> +static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
>  {
> -	unsigned int cpu = smp_processor_id();
> -	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
>  	u64 value;
>  	int i;
>
> +	if (msrs->initialized)
> +		return;
> +
>  	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
>  		rdmsrl_safe(kvm_uret_msrs_list[i], &value);
>  		msrs->values[i].host = value;
>  		msrs->values[i].curr = value;
>  	}
> +	msrs->initialized = true;
>  }
>
>  int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> @@ -429,6 +432,8 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>  	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
>  	int err;
>
> +	kvm_user_return_msr_init_cpu(msrs);
> +
>  	value = (value & mask) | (msrs->values[slot].host & ~mask);
>  	if (value == msrs->values[slot].curr)
>  		return 0;
> @@ -9212,7 +9217,12 @@ int kvm_arch_init(void *opaque)
>  		return -ENOMEM;
>  	}
>
> -	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
> +	/*
> +	 * __GFP_ZERO to ensure user_return_msrs.values[].initialized = false.
> +	 * See kvm_user_return_msr_init_cpu().
> +	 */
> +	user_return_msrs = alloc_percpu_gfp(struct kvm_user_return_msrs,
> +					    GFP_KERNEL | __GFP_ZERO);
>  	if (!user_return_msrs) {
>  		printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
>  		r = -ENOMEM;
> @@ -11836,7 +11846,6 @@ int kvm_arch_hardware_enable(void)
>  	u64 max_tsc = 0;
>  	bool stable, backwards_tsc = false;
>
> -	kvm_user_return_msr_cpu_online();
>  	ret = static_call(kvm_x86_hardware_enable)();
>  	if (ret != 0)
>  		return ret;
> --
> 2.25.1
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E955ACA32
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 08:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbiIEF5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 01:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235572AbiIEF42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 01:56:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E3124F13;
        Sun,  4 Sep 2022 22:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662357384; x=1693893384;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x8BHU7dXBHq49U9pCxfDkV5wzV1bnWJ0MiFkkKRvgo4=;
  b=W6pL3atrNEU4yI7DGrNLmaOCKkPQilTdJv3sZunSUAtPu/pzAEMYsViG
   Hg/AzmBknMdTi6tY1zaUkhQSNlwe4nV1lgFv2I9s79270wcTz94dcgjAt
   Fys3atMXHJbOA+dp9eRWsxuqeXvb6F9L4XakuGVv/mwSF3aCxaN6c6ge3
   vMKGhHx4uPfa6yS+jMYljLcqTKOEPMy3w+lfssk6yoK7mGEgoOy9jynhh
   lIcYJb3Y5l6y7Iy8/DfmiSdl1WRthzREPP8QKlhhc+LCyhDNw3LHSfx9E
   LMugORz0JZa9Rlq+rAYn8LO8knzYi2R6yQY1hhJbhu7mBJJokrV7MkICf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="279328604"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="279328604"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 22:56:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="609571229"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga007.jf.intel.com with ESMTP; 04 Sep 2022 22:56:18 -0700
Date:   Mon, 5 Sep 2022 13:56:17 +0800
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
Subject: Re: [PATCH v3 05/22] KVM: Provide more information in kernel log if
 hardware enabling fails
Message-ID: <20220905055617.cup6tloqxurqznmo@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <5f659936255837f77e821011bb9445a98322e3ae.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f659936255837f77e821011bb9445a98322e3ae.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:40PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> Provide the name of the calling function to hardware_enable_nolock() and
> include it in the error message to provide additional information on
> exactly what path failed.
>
> Opportunistically bump the pr_info() to pr_warn(), failure to enable
> virtualization support is warn-worthy as _something_ is wrong with the
> system.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Link: https://lore.kernel.org/r/20220216031528.92558-4-chao.gao@intel.com
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  virt/kvm/kvm_main.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4243a9541543..278eb6cc7cbe 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4991,7 +4991,7 @@ static struct miscdevice kvm_dev = {
>  	&kvm_chardev_ops,
>  };
>
> -static void hardware_enable_nolock(void *junk)
> +static void hardware_enable_nolock(void *caller_name)
>  {
>  	int cpu = raw_smp_processor_id();
>  	int r;
> @@ -5006,7 +5006,8 @@ static void hardware_enable_nolock(void *junk)
>  	if (r) {
>  		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
>  		atomic_inc(&hardware_enable_failed);
> -		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
> +		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
> +			cpu, (const char *)caller_name);
>  	}
>  }
>
> @@ -5014,7 +5015,7 @@ static int kvm_starting_cpu(unsigned int cpu)
>  {
>  	raw_spin_lock(&kvm_count_lock);
>  	if (kvm_usage_count)
> -		hardware_enable_nolock(NULL);
> +		hardware_enable_nolock((void *)__func__);
>  	raw_spin_unlock(&kvm_count_lock);
>  	return 0;
>  }
> @@ -5063,7 +5064,7 @@ static int hardware_enable_all(void)
>  	kvm_usage_count++;
>  	if (kvm_usage_count == 1) {
>  		atomic_set(&hardware_enable_failed, 0);
> -		on_each_cpu(hardware_enable_nolock, NULL, 1);
> +		on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);
>
>  		if (atomic_read(&hardware_enable_failed)) {
>  			hardware_disable_all_nolock();
> @@ -5686,7 +5687,7 @@ static void kvm_resume(void)
>  {
>  	if (kvm_usage_count) {
>  		lockdep_assert_not_held(&kvm_count_lock);
> -		hardware_enable_nolock(NULL);
> +		hardware_enable_nolock((void *)__func__);
>  	}
>  }
>
> --
> 2.25.1
>

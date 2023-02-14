Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A083469593A
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjBNGfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjBNGfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:35:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850EA1CF45;
        Mon, 13 Feb 2023 22:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676356501; x=1707892501;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O6Zzxski0nTYSlwlDDZxJbBLPLI2TMBdL/M8frVhtPQ=;
  b=UvONV8lhNNR9tcv1RvSSwfNw57aZ63YKIYNcd6v8aMJzNIAeLc9woqLq
   +oxF0V2vqUzrkkvqKEWFUDpskvJolsyI2xes4jaxQ7jeayNylVYjorHX7
   Vpud0ga5VQzik1T/LC4kUhMSIESxFyjVlOGqqEmKKQY2NFg8e9QPsW7V7
   jsqiQMHNOhC+QQqQIXdiIdPF4lSfnpnFvVBoQYWAoMjjeSTZpri/WCFdf
   M3blDcgpBCXQhk4FOhlDjFFyiA/hwIoZ51ss0tndSjCEH6p6GnzNr0DhU
   RkkCkJj4G5Vb4s4X3v4qnO2Hef8neSis7J6UFgZIYrmJSc9nZca+4TRB9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314735019"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314735019"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:35:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701554159"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701554159"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.2]) ([10.255.31.2])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:34:59 -0800
Message-ID: <4af292e8-9407-2271-8531-51f8e3c96750@intel.com>
Date:   Tue, 14 Feb 2023 14:34:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.2
Subject: Re: [PATCH v2 01/21] KVM: x86: Rename kvm_init_msr_list() to clarify
 it inits multiple lists
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-2-seanjc@google.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230210003148.2646712-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/2023 8:31 AM, Sean Christopherson wrote:
> Rename kvm_init_msr_list() to kvm_init_msr_lists() to clarify that it
> initializes multiple lists: MSRs to save, emulated MSRs, and feature MSRs.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f706621c35b8..7b91f73a837d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7071,7 +7071,7 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>   	msrs_to_save[num_msrs_to_save++] = msr_index;
>   }
>   
> -static void kvm_init_msr_list(void)
> +static void kvm_init_msr_lists(void)
>   {
>   	unsigned i;
>   
> @@ -9450,7 +9450,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   		kvm_caps.max_guest_tsc_khz = max;
>   	}
>   	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
> -	kvm_init_msr_list();
> +	kvm_init_msr_lists();
>   	return 0;
>   
>   out_unwind_ops:


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5846C089D
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 02:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjCTBhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 21:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCTBhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 21:37:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275AD83E2
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 18:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679275857; x=1710811857;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fkHt2Ce2ACGLliuAehK41bbTOcWCsmf3hrwIL24gmRE=;
  b=ZRvl3nVA2Fb47cNWVmgZUQljXj4eMRZfrWczL1fFZlgs046Q3kImKt/J
   EtW9hGJF6nD2Rn6f7H9LAwEsSXJEMZ2E9ow6t5qv8OI2QMPD25akQFyF1
   6ustERir0LJtMtJazaT/xe1aUV4k5f5rxE7imXp++zIRCTCAzNzqvp1ov
   fCZgCGOYOcy5CLqHikwvR642K51ZqNM5+MfK9LUtp+22F7O+Vktx/ELC3
   bRtmGpay6Q8zOGhtIqwX5+5H3IyN8i1EYMNd9Qy3Tz/eumpK3j7NpqId7
   Y/ZcVVaO7VOQz94His0+b3xT1oRHQLjPTQ9xUdkjax6STfZ3vwfVz1/dW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="424828726"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="424828726"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 18:30:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="770003878"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="770003878"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.0.239]) ([10.238.0.239])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 18:30:54 -0700
Message-ID: <e8a9c4de-c3d9-7d7b-b041-f6d5f1961a73@linux.intel.com>
Date:   Mon, 20 Mar 2023 09:30:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 1/7] KVM: x86: Explicitly cast ulong to bool in
 kvm_set_cr3()
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-2-binbin.wu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230319084927.29607-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I will drop this patch in this LAM KVM enabling patch series per Sean's 
comments in V5.


On 3/19/2023 4:49 PM, Binbin Wu wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
>
> kvm_read_cr4_bits() returns ulong, explicitly cast it bool when assign to a
> bool variable.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 810cbe3b3ba6..410327e7eb55 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1238,7 +1238,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   	bool skip_tlb_flush = false;
>   	unsigned long pcid = 0;
>   #ifdef CONFIG_X86_64
> -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>   
>   	if (pcid_enabled) {
>   		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;

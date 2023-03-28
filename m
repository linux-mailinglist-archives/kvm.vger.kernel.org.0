Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608BD6CB793
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 09:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjC1HCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 03:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjC1HCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 03:02:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D928D1BE9
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 00:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679986930; x=1711522930;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=As7ijate+oPBzRqz1cTd+la2LOtZVlp2yCDRKJ3QhSw=;
  b=FyjkVRwAO/3HBlM4iDEhwiHuPhvV5WIvz9ggKAJWnYAqsB4GvuHtanDN
   I8RHSxtNNk33O7E5QPXWHNzcMAM+ATN8WytGhKF5fmX2uSjb0FaYe/Wn9
   HVdBvU4NIqBsk0IszVixU94vNDh12+sxY1OLb0MunS42YKSn5viVcssCA
   pjSYtGTzxiR+XiZlXTGfzyiTDOsaMRVHdEPH7BzB9VxBEsfu5P+JLNmLz
   MhPcEgdq3Z90zueuS/eIVVO+bF4lWWKI+XSPYM2MWUWO5279qhu4bxapa
   d90VEiWfx0oVna0s8ztV51fPWL08NDOz5HvrVvS0lfUsJL5+hVdZKTu9E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="426753062"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="426753062"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 00:02:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="929756090"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="929756090"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.209.17]) ([10.254.209.17])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 00:02:09 -0700
Message-ID: <620935f7-dd7a-2db6-1ddf-8dae27326f60@intel.com>
Date:   Tue, 28 Mar 2023 15:02:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add define for
 MSR_IA32_PRED_CMD's PRED_CMD_IBPB (bit 0)
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20230328050231.3008531-1-seanjc@google.com>
 <20230328050231.3008531-2-seanjc@google.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230328050231.3008531-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/2023 1:02 PM, Sean Christopherson wrote:
> Add a define for PRED_CMD_IBPB and use it to replace the open coded '1' in
> the nVMX library.

What does nVMX mean here?

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   lib/x86/msr.h | 1 +
>   x86/vmexit.c  | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/msr.h b/lib/x86/msr.h
> index c9869be5..29fff553 100644
> --- a/lib/x86/msr.h
> +++ b/lib/x86/msr.h
> @@ -34,6 +34,7 @@
>   /* Intel MSRs. Some also available on other CPUs */
>   #define MSR_IA32_SPEC_CTRL              0x00000048
>   #define MSR_IA32_PRED_CMD               0x00000049
> +#define PRED_CMD_IBPB			BIT(0)
>   
>   #define MSR_IA32_PMC0                  0x000004c1
>   #define MSR_IA32_PERFCTR0		0x000000c1
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index b1eed8d1..2e8866e1 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -463,7 +463,7 @@ static int has_spec_ctrl(void)
>   
>   static void wr_ibpb_msr(void)
>   {
> -	wrmsr(MSR_IA32_PRED_CMD, 1);
> +	wrmsr(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
>   }
>   
>   static void toggle_cr0_wp(void)


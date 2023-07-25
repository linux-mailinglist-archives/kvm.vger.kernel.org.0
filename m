Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA62760DF7
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 11:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjGYJHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 05:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbjGYJHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 05:07:19 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCB39C;
        Tue, 25 Jul 2023 02:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690276038; x=1721812038;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VORLw/NLRrDo9YApffYMLtY0n8HoPyeHOUozCEI7DhQ=;
  b=UUfiOcfP1G4x17bKdPGN/bMF2p46u/7pVNRwPLMJFNNs4WCxxXQZu3si
   NcO2GOvnOIMZG2cH0W87JGTyrVwpnINN0CKXhGuVUhPQWt6JWW8DGtzyT
   cdJA9IG/fvhYZYu2tiGu/RveRny/VnV44CiH9sM4qRyE4Q19EMkYJ1Tb0
   Aoc6FsVfRXwKQYQEudLCm601ByYM2rs23/X+64xRpyoYTEg/C2mGYncC4
   5f1v+qgRTH/Cq43MP5WVm1nvNCnkT7RDpss3ySMWB7vEICc61Bj2zSSrO
   /3oB8uhbRC8vgYg9R+4taNUV15mmxdII94BaXoB3nPRfF6LNvgd3Dxhcs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="371272667"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="371272667"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 02:07:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="703206899"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="703206899"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.18.246]) ([10.93.18.246])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 02:07:08 -0700
Message-ID: <9e8a98ad-1f8d-a09c-3173-71c5c3ab5ed4@intel.com>
Date:   Tue, 25 Jul 2023 17:07:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v4 09/10] KVM: x86: Make struct sev_cmd common for
 KVM_MEM_ENC_OP
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <8c0b7babbdd777a33acd4f6b0f831ae838037806.1689893403.git.isaku.yamahata@intel.com>
 <ZLqbWFnm7jyB8JuY@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZLqbWFnm7jyB8JuY@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/2023 10:51 PM, Sean Christopherson wrote:
> On Thu, Jul 20, 2023, isaku.yamahata@intel.com wrote:
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index aa7a56a47564..32883e520b00 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -562,6 +562,39 @@ struct kvm_pmu_event_filter {
>>   /* x86-specific KVM_EXIT_HYPERCALL flags. */
>>   #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
>>   
>> +struct kvm_mem_enc_cmd {
>> +	/* sub-command id of KVM_MEM_ENC_OP. */
>> +	__u32 id;
>> +	/*
>> +	 * Auxiliary flags for sub-command.  If sub-command doesn't use it,
>> +	 * set zero.
>> +	 */
>> +	__u32 flags;
>> +	/*
>> +	 * Data for sub-command.  An immediate or a pointer to the actual
>> +	 * data in process virtual address.  If sub-command doesn't use it,
>> +	 * set zero.
>> +	 */
>> +	__u64 data;
>> +	/*
>> +	 * Supplemental error code in the case of error.
>> +	 * SEV error code from the PSP or TDX SEAMCALL status code.
>> +	 * The caller should set zero.
>> +	 */
>> +	union {
>> +		struct {
>> +			__u32 error;
>> +			/*
>> +			 * KVM_SEV_LAUNCH_START and KVM_SEV_RECEIVE_START
>> +			 * require extra data. Not included in struct
>> +			 * kvm_sev_launch_start or struct kvm_sev_receive_start.
>> +			 */
>> +			__u32 sev_fd;
>> +		};
>> +		__u64 error64;
>> +	};
>> +};
> 
> Eww.  Why not just use an entirely different struct for TDX?  I don't see what
> benefit this provides other than a warm fuzzy feeling that TDX and SEV share a
> struct.  Practically speaking, KVM will likely take on more work to forcefully
> smush the two together than if they're separate things.

generalizing the struct of KVM_MEM_ENC_OP should be the first step. The 
final target should be generalizing a set of commands for confidential 
VMs (SEV-* VMs and TDs, maybe even for other arches), e.g., the commands 
to create a confidential VM and commands to live migration a 
confidential VM.

However, there seems not small divergence between the commands to create 
a SEV-* VM and TDX VMs. I'm not sure if it is worth investigating and 
pursuing.

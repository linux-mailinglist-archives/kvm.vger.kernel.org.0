Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A82C7078B6
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 06:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjEREBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 00:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjEREBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 00:01:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1258119C;
        Wed, 17 May 2023 21:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684382508; x=1715918508;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/f54lyDTOV5ImAqX+HJtrGe9U/rdT/+EHFDiCLpy4pU=;
  b=mD7QyUvAzzy0ncFa8H5oT+O9DqgStCsQRS4wPEweHZMQeVlZrpINgpOO
   OUy9GB67hpo2leRHCqUkc0pKFn+IrneV/SVDbtSNvFLBhIrRqxjZuzgwp
   S8UgeOmeauj5oRws0ESd+0DN/wzie1lZilYBjuhrHIBv0RNRT5NncYUL+
   yY5Aup+VpsahCke2BD+qSoA3uxngpvJWPsgzXRc6fa/JyBcNBB7JMq3CU
   hGhRjfJi8q5+1e5fWJ3U9rVOyU1zftGNy90VHFlDHlWrakLuuo1qAJrrP
   OYfBRncme7xjHOJzUybgORreDD+prMLacpveu/Lc4qf5gONW4Cy+texdP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="351973302"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="351973302"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 21:01:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="814162103"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="814162103"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.208.101]) ([10.254.208.101])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 21:01:42 -0700
Message-ID: <b143c338-270a-ebda-03a3-a85463be2686@linux.intel.com>
Date:   Thu, 18 May 2023 12:01:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v8 2/6] KVM: x86: Virtualize CR4.LAM_SUP
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-3-binbin.wu@linux.intel.com>
 <67a20fe2a41fbe99de1470254b14f282f72571c7.camel@intel.com>
 <abbb7938-0615-8578-0072-a96d21df3b4d@linux.intel.com>
 <982ce5177647331b7b9f6526dfe064b76a921d06.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <982ce5177647331b7b9f6526dfe064b76a921d06.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/2023 6:49 PM, Huang, Kai wrote:
>>>>    
>>> LAM only applies to 64-bit linear address, which means LAM can only be enabled
>>> when CPU is in 64-bit mode with either 4-level or 5-level paging enabled.
>>>
>>> What's the hardware behaviour if we set CR4.LAM_SUP when CPU isn't in 64-bit
>>> mode?  And how does VMENTRY check GUEST_CR4.LAM_SUP and 64-bit mode?
>>>
>>> Looks they are not clear in the spec you pasted in the cover letter:
>>>
>>> https://cdrdv2.intel.com/v1/dl/getContent/671368
>>>
>>> Or I am missing something?
>> Yes, it is not clearly described in LAM spec.
>> Had some internal discussions and also did some tests in host,
>> if the processor supports LAM, CR4.LAM_SUP is allowed to be set even
>> when cpu isn't in 64bit mode.
>>
>> There was a statement in commit message of the last version, but I
>> missed it in this version. I'll add it back.
>> "CR4.LAM_SUP is allowed to be set even not in 64-bit mode, but it will not
>> take effect since LAM only applies to 64-bit linear address."
> Yeah this does help.  Please add it back to the changelog.
>
>> Also, I will try to ask Intel guys if it's possible to update the document.
>>
> Thanks.


Per the internal discussion, there is no need to explicitly callout 
CR4[28] can be set out side of 64-bit mode in SDM/LAM spec for the 
following reasons:

According to SDM Vol.2 Move to/from Control Registers:
- "On a 64-bit capable processor, an execution of MOV to CR outside of 
64-bit mode zeros the upper 32 bits of the control register."
   It doesn't mention of clearing any of the lower bits.

- "Some of the bits in CR0, CR3, and CR4 are reserved and must be 
written with zeros. ...  Attempting to set any reserved bits in CR4 
results in #GP(0)"
   CR4[28] is not reserved on processors that support LAM, and SDM / LAM 
spec doesn't explicitly say the bit cannot be set under some specific 
condition.

So just like the reset of CR4[31:0], CR4[28] can be set by any 32-bit 
load of CR4 when LAM is supported.
For example, CR4[17] is used only with 64-bit paging, but it can be set 
by a 32-bit load of CR4 when 32-bit paging or PAE paging is in use.
Similarly, user-interrupt delivery is enabled by setting CR4[25]. It can 
be set in any mode, even though user-interrupt delivery can occur only 
in 64-bit mode.


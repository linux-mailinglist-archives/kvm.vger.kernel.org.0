Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8988F4F6549
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbiDFQ2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237924AbiDFQ1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:27:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6EBC90E3;
        Tue,  5 Apr 2022 19:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649210782; x=1680746782;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S3UMWP9q80xjVbra32L/7bYAr7VRtOKCeQYbmk+BjJ4=;
  b=km+QpWekPUsnPEV94iFlmdKv2jxCV8ubdo76XqqW/geNwqOG3dEYtJ8B
   Hx5puTdmARC1dGjy0I6HLXZFrOAjrW7RfBg0I3l+Rf0cVo8uExP0qOAtO
   DQnQXytNQu8STNiZhaFF36nbjOVjpUjN66QbPhj1v9YAzbWV5yKYEnor4
   RfiL2BpFjVQU+tQBK09wXPHHX4yFPPyqFf6gwtrPiSWMpqir0kM7OrKvh
   BM7WAO4EBa6Rzzg2MvIJwT9jaHCD+ql+UC4pD6UwmnRVLaeRljsGY6bUG
   c/AYTV8egg9/ncQmX+ayLLCC1XQt8B9P0iU8E3lYt4F5IOSTESV5ymlP2
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="258512925"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="258512925"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 19:06:21 -0700
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="570287264"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.134]) ([10.249.175.134])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 19:06:18 -0700
Message-ID: <36df723c-4794-69a8-8d12-ea371a7865df@intel.com>
Date:   Wed, 6 Apr 2022 10:06:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
 <509fb6fb5c581e6bf14149dff17d7426a6b061f2.camel@intel.com>
 <6e370d39-fcb6-c158-e5fb-690cd3802150@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <6e370d39-fcb6-c158-e5fb-690cd3802150@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/2022 9:01 PM, Paolo Bonzini wrote:
> On 3/31/22 06:55, Kai Huang wrote:
>>> +struct kvm_tdx_init_vm {
>>> +    __u32 max_vcpus;
>>> +    __u32 tsc_khz;
>>> +    __u64 attributes;
>>> +    __u64 cpuid;
>> Is it better to append all CPUIDs directly into this structure, 
>> perhaps at end
>> of this structure, to make it more consistent with TD_PARAMS?
>>
>> Also, I think somewhere in commit message or comments we should 
>> explain why
>> CPUIDs are passed here (why existing KVM_SET_CUPID2 is not sufficient).
>>
> 
> Indeed, it would be easier to use the existing cpuid data in struct 
> kvm_vcpu, because right now there is no way to ensure that they are 
> consistent.
> 
> Why is KVM_SET_CPUID2 not enough?  Are there any modifications done by 
> KVM that affect the measurement?

Then we get the situation that KVM_TDX_INIT_VM must be called after 1 
vcpu is created. It seems illogical that it has chance to fail the VM 
scope initialization after 1 vcpu is successfully created.

> Thanks,
> 
> Paolo
> 


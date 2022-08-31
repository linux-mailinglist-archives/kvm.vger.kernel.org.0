Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FAD5A748F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 05:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiHaDke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 23:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiHaDkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 23:40:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7063D5A4;
        Tue, 30 Aug 2022 20:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661917230; x=1693453230;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4UnPxXmSAR7BcO87OaiX5jBIE02ojL3gV8lzjgFw+ek=;
  b=MB79ibZx1zQxGuEL+NW/UTd654ri+jGvYdvDlHFmQTaq8+yH0gWR5qtX
   eVkT5Gd7i2JZDQR/8SlAHLA68r04qRROF37aW11DCQr5mvAsT41hhRnOi
   q8RuLcORI3FyqInvw7UZR6SBzwOVFxSoyZTNltr+mJ0MDcm4e5nj0+WWP
   n7M8LNwuYLFaF8e1Ml0qkIcFuMUH9hfqK5rvf7gUekQh0hmxOVq5cs60F
   sPcP6xKF1IM2VBnXoJlW3WfMYjAK08VXByJQaxZRsM6gRkV/gGLdJpY8M
   pRqt+/aLL3GhGkXSRHCfA/SG6F3iEEWB2HPphMV+qYKtI557IC1skjsgg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="292940295"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="292940295"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 20:40:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="673175541"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.192.207]) ([10.249.192.207])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 20:40:26 -0700
Message-ID: <37ed6be6-bfa5-e87c-9c74-e5bdacda1600@intel.com>
Date:   Wed, 31 Aug 2022 11:40:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH v8 018/103] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Binbin Wu <binbin.wu@linux.intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <d88e0cee35b70d86493d5a71becffa4ab5c5d97c.1659854790.git.isaku.yamahata@intel.com>
 <651c33a5-4b9b-927f-cb04-ec20b8c3d730@linux.intel.com>
 <YwT0+DO4AuO1xL82@google.com>
 <20220826044817.GE2538772@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220826044817.GE2538772@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/2022 12:48 PM, Isaku Yamahata wrote:
> On Tue, Aug 23, 2022 at 03:40:40PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> 
>> On Tue, Aug 23, 2022, Binbin Wu wrote:
>>>
>>> On 2022/8/8 6:01, isaku.yamahata@intel.com wrote:
>>>> +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
>>>> +{
>>>> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
>>>> +			 "Read/Write to TD VMCS *_HIGH fields not supported");
>>>> +
>>>> +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
>>>> +
>>>> +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
>>>> +			 (((field) & 0x6000) == 0x2000 ||
>>>> +			  ((field) & 0x6000) == 0x6000),
>>>> +			 "Invalid TD VMCS access for 64-bit field");
>>>
>>> if bits is 64 here, "bits != 64" is false, how could this check for "Invalid
>>> TD VMCS access for 64-bit field"?
>>
>> Bits 14:13 of the encoding, which is extracted by "(field) & 0x6000", encodes the
>> width of the VMCS field.  Bit 0 of the encoding, "(field) & 0x1" above, is a modifier
>> that is only relevant when operating in 32-bit mode, and is disallowed because TDX is
>> 64-bit only.
>>
>> This yields four possibilities for TDX:
>>
>>    (field) & 0x6000) == 0x0000 : 16-bit field
>>    (field) & 0x6000) == 0x2000 : 64-bit field
>>    (field) & 0x6000) == 0x4000 : 32-bit field
>>    (field) & 0x6000) == 0x6000 : 64-bit field (technically "natural width", but
>>                                                effectively 64-bit because TDX is
>> 					      64-bit only)
>>
>> The assertion is that if the encoding indicates a 64-bit field (0x2000 or 0x6000),
>> then the number of bits KVM is accessing must be '64'.  The below assertions do
>> the same thing for 32-bit and 16-bit fields.
> 
> Thanks for explanation. I've updated it as follows to use symbolic value.
> 
> #define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
> #define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
> #define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
> #define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)
> 
> 	/* TDX is 64bit only.  HIGH field isn't supported. */
> 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
> 			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
> 			 "Read/Write to TD VMCS *_HIGH fields not supported");
> 
> 	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
> 
> #define VMCS_ENC_WIDTH_MASK	GENMASK_UL(14, 13)
> #define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
> #define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
> #define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
> #define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
> #define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)
> 
> 	/* TDX is 64bit only.  i.e. natural width = 64bit. */
> 	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> 			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
> 			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
> 			 "Invalid TD VMCS access for 64-bit field");
> 	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
> 			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
> 			 "Invalid TD VMCS access for 32-bit field");
> 	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
> 			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
> 			 "Invalid TD VMCS access for 16-bit field");

Actually, the original code is written by me that is copied from 
vmcs_check{16/32/64/l} in arch/x86/kvm/vmx/vmx_ops.h

If you are going to do above change, you'd better cook a patch to change 
it for vmx_ops.h at first and see opinion from community.


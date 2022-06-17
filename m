Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B0954EED3
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 03:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379238AbiFQBan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 21:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiFQBam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 21:30:42 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542C863528
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 18:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655429442; x=1686965442;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=77cjP7D/0L9Vo14OKATchrAX+O+UK74HDOVeZlCAZzU=;
  b=k2Rd9Q6uq+7gRKMcQKrTCSC1BtGUY8oL2LKU+T+DQu+xxtNnPQmxb/T9
   Pxfw/6Ar0JzaTdPVRmLPA1i3AJ+tE2et6JXkCx0rnL2A+zFUxazjbpILI
   My8pPZr6jIPnB8ZEyvhNX2nemDFaXCZOLT+uNPtDtwRueldOVzOl4IXhM
   cBNd+SvN2R2XDLyJtDAxhwYzSnqPx4Kwc6MOmbr883Mbg5+AuQDOk8/Jo
   L+FDXzsrA0L0OUGKdKRLcvKxMR1KpuAyZF2QaX0lUs3xUJC62TLYu8uYi
   4ZZmUwMdmk8/8P0Yl1O6EwSRLS78KtLcOjmYidJrPRT2wfH680ZoKNERA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="278190281"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="278190281"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 18:30:41 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="589900619"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.170.76]) ([10.249.170.76])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 18:30:40 -0700
Message-ID: <5e17314e-d9ff-7e93-e376-a1a19d53f44b@intel.com>
Date:   Fri, 17 Jun 2022 09:30:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 1/3] x86: Remove perf enable bit from
 default config
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, like.xu.linux@gmail.com, jmattson@google.com,
        kvm@vger.kernel.org
References: <20220615084641.6977-1-weijiang.yang@intel.com>
 <20220615084641.6977-2-weijiang.yang@intel.com> <Yqt2xBFkFZw3VaQT@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Yqt2xBFkFZw3VaQT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/17/2022 2:30 AM, Sean Christopherson wrote:
> On Wed, Jun 15, 2022, Yang Weijiang wrote:
>> When pmu is disabled in KVM by enable_pmu=0, bit 7 of guest
>> MSR_IA32_MISC_ENABLE is cleared, but the default value of
>> the MSR assumes pmu is always available, this leads to test
>> failure. Change the logic to make it aligned with KVM config.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Paolo's more generic approach is preferable, though even that can be more generic.
>
> https://lore.kernel.org/all/20220520183207.7952-1-pbonzini@redhat.com
Saw it , thanks! Maybe I just need to help Paolo resend the patch in my 
series.
>
>> ---
>>   x86/msr.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/x86/msr.c b/x86/msr.c
>> index 44fbb3b..fc05d6c 100644
>> --- a/x86/msr.c
>> +++ b/x86/msr.c
>> @@ -34,7 +34,7 @@ struct msr_info msr_info[] =
>>   	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
>>   	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
>>   	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
>> -	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889, false),
>> +	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51809, false),
>>   	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
>>   	MSR_TEST(MSR_FS_BASE, addr_64, true),
>>   	MSR_TEST(MSR_GS_BASE, addr_64, true),
>> @@ -59,6 +59,8 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
>>   	 */
>>   	if (msr->index == MSR_EFER)
>>   		val |= orig;
>> +	if (msr->index == MSR_IA32_MISC_ENABLE)
>> +		val |= MSR_IA32_MISC_ENABLE_EMON & orig;
>>   	wrmsr(msr->index, val);
>>   	r = rdmsr(msr->index);
>>   	wrmsr(msr->index, orig);
>> -- 
>> 2.31.1
>>

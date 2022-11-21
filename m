Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFB7632718
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 15:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiKUO5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 09:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiKUO4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 09:56:19 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185CAD14D0;
        Mon, 21 Nov 2022 06:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669042006; x=1700578006;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fbKJTCgwO7jTDSMZaCLd0+BKHMNRpeWE5PGwz7IlfMU=;
  b=jC6BBdQuZUFqTeUMkdhYPWz8RReC+MluWYYf+Bo4uI5Fqn7Fsv1aeCpF
   7mIiuTt30UekYe/Xd/0ULcURXKs5aosQmveDTjeqMTBDiAMsE/er9cTFk
   MGVzYG1z+4IzcTYKnBhvfgIN4TUPI0OmvE4sE3htWkeVh1yhjE0VW1PR5
   tUzyh4tw0iNDG9DeDTdj1TU9dVCrvCAKBgQ9PakVb7RE2cRedloG5lJNF
   r2+adaBiCLsh/45g1LExgNSpqt6mIh9r2oK3y6yik/uOOD6QhrXqdHfft
   INao0SIfQOmgUVX59UIFwtHYj25FT8C86iWPHSxy+Jw71EZfX7IVBuJwB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="293961780"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="293961780"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 06:46:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="709829528"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="709829528"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.254.209.33]) ([10.254.209.33])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 06:46:23 -0800
Message-ID: <f04c2e74-87e4-5d50-579a-0a60554b83d3@linux.intel.com>
Date:   Mon, 21 Nov 2022 22:46:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4 1/6] x86: KVM: Advertise CMPccXADD CPUID to user space
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-2-jiaxi.chen@linux.intel.com>
 <efb55727-f8bd-815c-ddfc-a8432ae5af4e@intel.com>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <efb55727-f8bd-815c-ddfc-a8432ae5af4e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/2022 12:47 AM, Dave Hansen wrote:
> On 11/18/22 06:15, Jiaxi Chen wrote:
>> CMPccXADD is a new set of instructions in the latest Intel platform
>> Sierra Forest. This new instruction set includes a semaphore operation
>> that can compare and add the operands if condition is met, which can
>> improve database performance.
>>
>> The bit definition:
>> CPUID.(EAX=7,ECX=1):EAX[bit 7]
>>
>> This CPUID is exposed to userspace. Besides, there is no other VMX
>> control for this instruction.
> 
> The last time you posted these, I asked:
> 
>> Intel folks, when you add these bits, can you please include information
>> about the "vetting" that you performed?
> 
> I think you're alluding to that in your comment about VMX contols.
> Could you be more explicit here and include *all* of your logic about
> why this feature is OK to pass through to guests?
> 
Yes, that's very rigorous. Will check and add these for all features in
this patch series.

> Also, do we *want* this showing up in /proc/cpuinfo?
>
> There are also two distinct kinds of features that you're adding here.
> These:
> 
>> +#define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
> 
> and these:
> 
> +#define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
> 
> Could you also please include a sentence or two about why the feature
> was treated on way versus another?  That's frankly a lot more important
> than telling us which random Intel codename this shows up on first, or
> wasting space on telling us what the CPUID bit definition is.  We can
> kinda get that from the patch.
Yes. A few words of description is necessary here.

Features which has been enabled in kernel usually should be added to
/proc/cpuinfo.

The first way is often used for bit whose leaf has many other bits in
use. It's very simple to do, just adding one line for each feature based
on existing words in can get the effect.

For those bits whose leaf has just a few bits in use, they should be
defined in a 'scattered' way. However, this kind of features in this
patch series have no other kernel usage and they just need to be
advertised to kvm userspace. Therefore, define them in a kvm-only way is
more explicit.

> 
> Another nit on these:
> 
>> This CPUID is exposed to userspace. Besides, there is no other VMX
>> control for this instruction.
> 
> Please remember to use imperative voice when describing what the patch
> in question does.  Using passive voice like that makes it seem like
> you're describing the state of the art rather than the patch.
> 
> For example, that should probably be:
> 
> 	Expose CMPCCXADD to KVM userspace.  This is safe because there
> 	are no new VMX controls or host enabling required for guests to
> 	use this feature.
> 
> See how that first sentence is giving orders?  It's *telling* you what
> to do.  That's imperative voice and that's what you use to describe the
> actions of *this* patch.

Appreciate your very detailed suggestions. Thanks very much!
-- 
Regards,
Jiaxi

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455FE632F73
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 23:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiKUWAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 17:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKUWAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 17:00:21 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8BDBF832;
        Mon, 21 Nov 2022 14:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669068020; x=1700604020;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+ma0WakvZrX/QeghPHE60d1tluXLn7n6TDwbT58Zem4=;
  b=TKNP3wfM08EXlQKOE75RHLtphaklaHzj9jUm7AVes2JvylUQkBfvsj1L
   RRuaQWCqUFT5qOIMvHMfWe3bgt3x9C/F5XGpF52OTORBKnd2TWGG8RRMs
   S+TCQHO046vJEQtbRdXbY1MXu975pfvGLrhz5kcbJlyxdnQTdrTAByKW2
   wMcmEf2DiQSoxXqNUskBEzfkP815houvYJNM0yX8lP8YYxwI64mfA40aE
   g3Pmx1349oNrPIkvf7Ku7Pgr5lVGW9LT+rEfpr2exGlmOR8XGcFqMiJMT
   O+tl/T6/fNeSo0oGkRxomrzsCleoW2/SsNn8KHD9sbku9jNGa7eird93g
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="301218039"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="301218039"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 14:00:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="886277273"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="886277273"
Received: from dylanhol-mobl.amr.corp.intel.com (HELO [10.212.242.103]) ([10.212.242.103])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 14:00:16 -0800
Message-ID: <cb64427e-31a2-eac0-a7f6-546571ac2724@linux.intel.com>
Date:   Mon, 21 Nov 2022 14:00:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
 <62c67ed3-e4d1-082f-800a-b0837c9432a9@linux.intel.com>
 <31cb1df3cf21889fb33a7c675aa1bf5fa2078cad.camel@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <31cb1df3cf21889fb33a7c675aa1bf5fa2078cad.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/21/22 1:44 AM, Huang, Kai wrote:
> On Sun, 2022-11-20 at 19:51 -0800, Sathyanarayanan Kuppuswamy wrote:
>>
>> On 11/20/22 4:26 PM, Kai Huang wrote:
>>> The MMIO/xAPIC interface has some problems, most notably the APIC LEAK
>>
>> "some problems" looks more generic. May be we can be specific here. Like
>> it has security issues?
> 
> It was quoted from below upstream commit id (I only kept the one that I quoted
> to save space):

Ok.

> 
> commit b8d1d163604bd1e600b062fb00de5dc42baa355f (tag: x86_apic_for_v6.1_rc1,
> tip/x86/apic)
> Author: Daniel Sneddon <daniel.sneddon@linux.intel.com>
> Date:   Tue Aug 16 16:19:42 2022 -0700
> 
>     x86/apic: Don't disable x2APIC if locked
>     
>     ....
>     
>     The MMIO/xAPIC interface has some problems, most notably the APIC LEAK
>     [1].  This bug allows an attacker to use the APIC MMIO interface to
>     extract data from the SGX enclave.
>     
>     ....
>     
>     [1]: https://aepicleak.com/aepicleak.pdf
>     
>     Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
>     Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>     Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
>     Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
>     Link:
> https://lkml.kernel.org/r/20220816231943.1152579-1-daniel.sneddon@linux.intel.com
> 
> 
>>
>>> [1].  This bug allows an attacker to use the APIC MMIO interface to
>>> extract data from the SGX enclave.
>>>
>>> TDX is not immune from this either.  Early check X2APIC and disable TDX
>>> if X2APIC is not enabled, and make INTEL_TDX_HOST depend on X86_X2APIC.
>>>
>>> [1]: https://aepicleak.com/aepicleak.pdf
>>>
>>> Link: https://lore.kernel.org/lkml/d6ffb489-7024-ff74-bd2f-d1e06573bb82@intel.com/
>>> Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
>>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>>> ---
>>>
>>> v6 -> v7:
>>>  - Changed to use "Link" for the two lore links to get rid of checkpatch
>>>    warning.
>>>
>>> ---
>>>  arch/x86/Kconfig            |  1 +
>>>  arch/x86/virt/vmx/tdx/tdx.c | 11 +++++++++++
>>>  2 files changed, 12 insertions(+)
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index cced4ef3bfb2..dd333b46fafb 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -1958,6 +1958,7 @@ config INTEL_TDX_HOST
>>>  	depends on CPU_SUP_INTEL
>>>  	depends on X86_64
>>>  	depends on KVM_INTEL
>>> +	depends on X86_X2APIC
>>>  	help
>>>  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>>>  	  host and certain physical attacks.  This option enables necessary TDX
>>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>>> index 982d9c453b6b..8d943bdc8335 100644
>>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>>> @@ -12,6 +12,7 @@
>>>  #include <linux/printk.h>
>>>  #include <asm/msr-index.h>
>>>  #include <asm/msr.h>
>>> +#include <asm/apic.h>
>>>  #include <asm/tdx.h>
>>>  #include "tdx.h"
>>>  
>>> @@ -81,6 +82,16 @@ static int __init tdx_init(void)
>>>  		goto no_tdx;
>>>  	}
>>>  
>>> +	/*
>>> +	 * TDX requires X2APIC being enabled to prevent potential data
>>> +	 * leak via APIC MMIO registers.  Just disable TDX if not using
>>> +	 * X2APIC.
>>
>> Remove the double space.
> 
> Sorry which "double space"?

Before Just disable. It looked like double space. Is it not?

> 
>>
>>> +	 */
>>> +	if (!x2apic_enabled()) {
>>> +		pr_info("Disable TDX as X2APIC is not enabled.\n");
>>
>> pr_warn()?
> 
> Why?

Since it is a failure case, I thought pr_warn would be better. It is up
to you.

> 

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer

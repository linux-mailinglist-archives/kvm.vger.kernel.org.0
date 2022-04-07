Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5A54F6F70
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiDGBLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiDGBLG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:11:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75269BADE;
        Wed,  6 Apr 2022 18:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649293747; x=1680829747;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZGVU3ALt+E9ZDKDB1nnL7gAFrYx8O5DiBDhZ/hjTw+M=;
  b=hPKbCzA7Wh3O33TevW5r1SytAQS4UJCw1RUB3Hr30VmaRHry31XuWfgJ
   RqJw3yVtAjhJcWxxNMjIecPx6V57kX91IhpZjxdWwddgIHhVL2GbCRfy4
   X8f045DrKMWcrDqqs+MepqdfgjYVdRoZc08wx4xpHD56WFLY7zcm3V1TM
   kg6WDcTSdp5pqfrcgeSuatvsHBZK5c1OaY9jBBHhP/v67N7J08VuMbYDP
   oSsTDx8EDGNe1YkynW38E2whhn948wlZX8e8j2993DvL9A5zjsrIp683e
   8LPR52wW18FuahLhZebEioo6jJLRBFB/Q76QcImHi7psCjNHPTj7orWv5
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="324361315"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="324361315"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:09:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="722743532"
Received: from zitianwa-mobl.ccr.corp.intel.com (HELO [10.255.28.125]) ([10.255.28.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:09:04 -0700
Message-ID: <a6e31fb0-02af-676d-10d5-8afcf73d098d@intel.com>
Date:   Thu, 7 Apr 2022 09:09:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 086/104] KVM: TDX: handle ept violation/misconfig
 exit
Content-Language: en-US
To:     Sagi Shahar <sagis@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <1df5271baa641d9d189edb86f9ee0921ea3a83e0.1646422845.git.isaku.yamahata@intel.com>
 <CAAhR5DEb+jRfGxK0nv4A_XEEnY4yrw1CzCcXU8HNw=CnHW27Gw@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAAhR5DEb+jRfGxK0nv4A_XEEnY4yrw1CzCcXU8HNw=CnHW27Gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/2022 4:50 AM, Sagi Shahar wrote:
> On Fri, Mar 4, 2022 at 12:23 PM <isaku.yamahata@intel.com> wrote:
>>
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> On EPT violation, call a common function, __vmx_handle_ept_violation() to
>> trigger x86 MMU code.  On EPT misconfiguration, exit to ring 3 with
>> KVM_EXIT_UNKNOWN.  because EPT misconfiguration can't happen as MMIO is
>> trigged by TDG.VP.VMCALL. No point to set a misconfiguration value for the
>> fast path.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 40 ++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 38 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 6fbe89bcfe1e..2c35dcad077e 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1081,6 +1081,40 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>>          __vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
>>   }
>>
>> +#define TDX_SEPT_PFERR (PFERR_WRITE_MASK | PFERR_USER_MASK)
> 
> TDX_SEPT_PFERR is defined using PFERR_.* bitmask but
> __vmx_handle_ept_violation is accepting an EPT_VIOLATION_.* bitmask.
> so (PFERR_WRITE_MASK | PFERR_USER_MASK) will get interpreted as
> (EPT_VIOLATION_ACC_WRITE | EPT_VIOLATION_ACC_INSTR) which will get
> translated to (PFERR_WRITE_MASK | PFERR_FETCH_MASK). Was that the
> intention of this code?

No. It's a mistake. We have corrected internally you can find corrected 
code in github repo or see it in next version.




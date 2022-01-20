Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2183B4946FE
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 06:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358600AbiATFe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 00:34:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:29191 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbiATFe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 00:34:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642656899; x=1674192899;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t27IesemgHjw9RZFxfYR0WfViB/5r1HZWYSRstYTahs=;
  b=bL1p0C0jbULoF1xTMU9Fs8RXD7ziCumyAyiKqaST7ESX4DGfno6iPq1C
   JiC8/ZP/YC8EUBcM8ma7BSmwIsjDp7HHkr2xIhEJUR0ybPECJSmFGSfnI
   CRSZ+zUlTxY6GFyHVf7gXFNi4Xfcp2Txo4wN8JilAgDe5naR2l3F6EZjC
   rIgWYpkIO3y6cydBB4l/U73I6FPHHWXc9JrHag90wv8/N2+gtMhBV5i+Q
   0IJRPOS3bISM5PVkYAz7NanLMTWUkI3svQoMn/nOF5/3bQq4dpxdLVL0h
   ue1ZmoNUoHGD60OBEOz9hcldbbifOjHnbYwvJEoNkZ9Iru87Utalolkti
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="232638817"
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="232638817"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 21:34:58 -0800
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="532623958"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.96]) ([10.238.0.96])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 21:34:53 -0800
Message-ID: <1e285770-ab21-be29-af85-be85b3df5993@intel.com>
Date:   Thu, 20 Jan 2022 13:34:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH v5 4/8] KVM: VMX: dump_vmcs() reports
 tertiary_exec_control field as well
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-5-guang.zeng@intel.com> <YeCTsVCwEkT2N6kQ@google.com>
 <7fd4cb11-9920-6432-747e-633b96db0598@intel.com>
 <Yei1lODnpQTZLa7s@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <Yei1lODnpQTZLa7s@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/2022 9:06 AM, Sean Christopherson wrote:
> On Fri, Jan 14, 2022, Zeng Guang wrote:
>> On 1/14/2022 5:03 AM, Sean Christopherson wrote:
>>> Can you provide a sample dump?  It's hard to visualize the output, e.g. I'm worried
>>> this will be overly log and harder to read than putting tertiary controls on their
>>> own line.
>> Sample dump here.
>> *** Control State ***
>>
>>   PinBased=0x000000ff CPUBased=0xb5a26dfa SecondaryExec=0x061037eb
>> TertiaryExec=0x0000000000000010
> That's quite the line.  What if we reorganize the code to generate output like:
>
>    CPUBased=0xb5a26dfa SecondaryExec=0x061037eb TertiaryExec=0x0000000000000010
>    PinBased=0x000000ff EntryControls=0000d1ff ExitControls=002befff
>
> That keeps the lines reasonable and IMO is better organization too, e.g. it captures
> the relationship between primary, secondary, and tertiary controls.
Make sense. I'll change it as your suggestion. Thanks.
>>   EntryControls=0000d1ff ExitControls=002befff
>>   ExceptionBitmap=00060042 PFECmask=00000000 PFECmatch=00000000
>>   VMEntry: intr_info=00000000 errcode=00000000 ilen=00000000
>>   VMExit: intr_info=00000000 errcode=00000000 ilen=00000003
>>           reason=00000030 qualification=0000000000000784
>>>>    	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl, vmexit_ctl);
>>>>    	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
>>>>    	       vmcs_read32(EXCEPTION_BITMAP),
>>>> -- 
>>>> 2.27.0
>>>>

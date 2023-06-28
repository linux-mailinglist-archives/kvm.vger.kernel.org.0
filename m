Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE159740CAB
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 11:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjF1JZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 05:25:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:41244 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237699AbjF1JL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 05:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687943518; x=1719479518;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NVA8lJOKO6wh9UX4sHEekojP0XeaspzKEC3dMDokcFI=;
  b=UvDnBjXJXZZN7Vt9vEHh4IREcpFHBit6/JY3CpHBpHx0ohWL7wzIKGgb
   6GCzYPThz9Ufgrt2h8nFTh3ZKSDfnVE1riudEuR5ukFfGtuBB9bgOPzrE
   8E/mQzW9dWeDY8MMrATD8C01VqmOW8STqOBPNF5QzR316RhS+UfjaS71p
   sIZ0qSsLdhSeiTMF9qQgZHrdUfjknNPk/Eq5p4MmB3GhkSoil0wtqKtsE
   Qg7UtgKc8FGxRQFEx0katfDcNZASV7NCNExw0qe6OGHz/ZsH1XOmxbZMp
   kasNYAex12Mu+ALnJG0QF9TxCQSO5yfUKQNjw2TFNnQVswlV6Ayk8PlV8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="427790065"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="427790065"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 01:19:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="782191787"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="782191787"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.2.33]) ([10.238.2.33])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 01:19:26 -0700
Message-ID: <737613ab-8b3e-1289-7ed6-0966bd43e359@intel.com>
Date:   Wed, 28 Jun 2023 16:19:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v1 2/6] KVM: x86: Virtualize CR4.LASS
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-3-guang.zeng@intel.com> <ZJsfsjwug9PcQFLA@google.com>
Content-Language: en-US
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZJsfsjwug9PcQFLA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/28/2023 1:43 AM, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Zeng Guang wrote:
>> Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
>> as CR4.LASS generally set once for each vCPU at boot time and won't be
>> toggled at runtime. Besides, only if VM has LASS capability enumerated with
>> CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
>> to set CR4.LASS.
>>
>> Updating cr4_fixed1 to set CR4.LASS bit in the emulated IA32_VMX_CR4_FIXED1
>> MSR for guests and allow guests to enable LASS in nested VMX operaion as well.
> s/operaion/operation.
Will fix in next version. Thanks.

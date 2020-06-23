Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F9E205319
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 15:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732616AbgFWNN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 09:13:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:17374 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgFWNN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 09:13:26 -0400
IronPort-SDR: 7Gm3tEZV3EjtHMTJEzAfW3UctKMDaq6HGEZ6Et0EflnJbIxrZRnxqJnGW0dj4digaitFSkwXND
 cuwvmINQM0bw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209263120"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="209263120"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 06:13:25 -0700
IronPort-SDR: Le9ycPgGvDojUvw7Md80fDMLb9kacjWq24P/YjbEzwBrc835iCcDz4RWW5PN2U2USulevGAv+k
 jX6e5y9up5jA==
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="452218159"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.174.20]) ([10.249.174.20])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 06:13:22 -0700
Subject: Re: [PATCH v12 00/11] Guest Last Branch Recording Enabling
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200613080958.132489-1-like.xu@linux.intel.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <dc1c7ef1-5ab4-0f7b-5036-457193bc722c@linux.intel.com>
Date:   Tue, 23 Jun 2020 21:13:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/6/13 16:09, Like Xu wrote:
> Hi all,
> 
> Please help review this new version for the Kenrel 5.9 release.
> 
> Now, you may apply the last two qemu-devel patches to the upstream
> qemu and try the guest LBR feature with '-cpu host' command line.
> 
> v11->v12 Changelog:
> - apply "Signed-off-by" form PeterZ and his codes for the perf subsystem;
> - add validity checks before expose LBR via MSR_IA32_PERF_CAPABILITIES;
> - refactor MSR_IA32_DEBUGCTLMSR emulation with validity check;
> - reorder "perf_event_attr" fields according to how they're declared;
> - replace event_is_oncpu() with "event->state" check;
> - make LBR emualtion specific to vmx rather than x86 generic;
> - move pass-through LBR code to vmx.c instead of pmu_intel.c;
> - add vmx_lbr_en/disable_passthrough layer to make code readable;
> - rewrite pmu availability check with vmx_passthrough_lbr_msrs();
> 
> You may check more details in each commit.
> 
> Previous:
> https://lore.kernel.org/kvm/20200514083054.62538-1-like.xu@linux.intel.com/
> 
> ---
...
> 
> Wei Wang (1):
>   perf/x86: Fix variable types for LBR registers > Like Xu (10):
>    perf/x86/core: Refactor hw->idx checks and cleanup
>    perf/x86/lbr: Add interface to get LBR information
>    perf/x86: Add constraint to create guest LBR event without hw counter
>    perf/x86: Keep LBR records unchanged in host context for guest usage

Hi Peter,
Would you like to add "Acked-by" to the first three perf patches ?

>    KVM: vmx/pmu: Expose LBR to guest via MSR_IA32_PERF_CAPABILITIES
>    KVM: vmx/pmu: Unmask LBR fields in the MSR_IA32_DEBUGCTLMSR emualtion
>    KVM: vmx/pmu: Pass-through LBR msrs when guest LBR event is scheduled
>    KVM: vmx/pmu: Emulate legacy freezing LBRs on virtual PMI
>    KVM: vmx/pmu: Reduce the overhead of LBR pass-through or cancellation
>    KVM: vmx/pmu: Release guest LBR event via lazy release mechanism
> 

Hi Paolo,
Would you like to take a moment to review the KVM part for this feature ?

Thanks,
Like Xu

> 
> Qemu-devel:
>    target/i386: add -cpu,lbr=true support to enable guest LBR
> 
>   arch/x86/events/core.c            |  26 +--
>   arch/x86/events/intel/core.c      | 109 ++++++++-----
>   arch/x86/events/intel/lbr.c       |  51 +++++-
>   arch/x86/events/perf_event.h      |   8 +-
>   arch/x86/include/asm/perf_event.h |  34 +++-
>   arch/x86/kvm/pmu.c                |  12 +-
>   arch/x86/kvm/pmu.h                |   5 +
>   arch/x86/kvm/vmx/capabilities.h   |  23 ++-
>   arch/x86/kvm/vmx/pmu_intel.c      | 253 +++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.c            |  86 +++++++++-
>   arch/x86/kvm/vmx/vmx.h            |  17 ++
>   arch/x86/kvm/x86.c                |  13 --
>   12 files changed, 559 insertions(+), 78 deletions(-)
> 


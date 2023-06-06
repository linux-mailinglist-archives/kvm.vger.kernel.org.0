Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F25A723563
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbjFFClM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFFClK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:41:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8FF116;
        Mon,  5 Jun 2023 19:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686019269; x=1717555269;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DBnldeDYwgy6qjumt5eswsWOfGKElzGM4x1E6dJ/Kk4=;
  b=j6piMETryci3C4UmwMKoh9NPuHnHIOvq+sD209wQhLAnF7sRAERN9u04
   fG4Cx2yjA5/INEYogZ5L/pxbisegofXqdngBpttWR4SMTWcNfwp2hlMP2
   zq4HnJOUyUNBl+fzfoer1JdaxlPoO+g5LMdvYq6gHu9Dwq/fExQKvmbpF
   aJIHfbZ9yaNXaPsWF2PQ7Z0oRxt1gWJKiGFWERJk6behGW6HrCwcvuGgJ
   fEaQk5lDHgZyt4nADnkB2z4Xv87pI97vy6PZ4WZg4iU1hNmZ5VcEvVulE
   3+Lwbt5GoYvLd3CgGugXKOKTdYhn0BlZX4pUXFDW3YcX6nDQyZuNT6GoL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336166027"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336166027"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:41:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="738581620"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="738581620"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.249.170.218]) ([10.249.170.218])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:41:06 -0700
Message-ID: <1d39cbcc-dae9-d976-b18b-f673cf0f1932@intel.com>
Date:   Tue, 6 Jun 2023 10:40:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 0/6] LASS KVM virtualization support
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <08cf5a8a-7937-c033-06e7-85fe42758eaa@linux.intel.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <08cf5a8a-7937-c033-06e7-85fe42758eaa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/5/2023 9:39 AM, Binbin Wu wrote:
>
> On 6/1/2023 10:23 PM, Zeng Guang wrote:
>> Subject:
>> [PATCH v1 0/6] LASS KVM virtualization support
>> From:
>> Zeng Guang <guang.zeng@intel.com>
>> Date:
>> 6/1/2023, 10:23 PM
>>
>> To:
>> Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
>> <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
>> <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
>> <dave.hansen@linux.intel.com>, H Peter Anvin <hpa@zytor.com>,
>> kvm@vger.kernel.org
>> CC:
>> x86@kernel.org, linux-kernel@vger.kernel.org, Zeng Guang
>> <guang.zeng@intel.com>
>>
>>
>> Linear Address Space Separation (LASS)[1] is an independent mechanism
>> that enforces the mode-based protections on any access to a linear
>> address.
>>
>> Based on a linear-address organization, the 64-bit canonical linear
>> address space is partitioned into two halves: all linear addresses
>> whose most significant bit is 0 are user space addresses, while linear
>> addresses whose most significant bit is 1 are supervisor space address.
>>
>> LASS aims to prevent any attempt to probe supervisor space addresses by
>> user mode, and likewise stop any attempt to access (if SMAP enabled) or
>> execute user space addresses from supervisor mode.
>>
>> When platform has LASS capability, KVM requires to expose this feature
>> to guest VM enumerated by CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], and
>> allow guest to enable it via CR4.LASS[bit 27] on demand. For instruction
>> executed in the guest directly, hardware will perform the check. But KVM
>> also needs to behave same as hardware to apply LASS to kinds of guest
>> memory accesses when emulating privileged instructions by software.
> Not just privileged instructions, e.g. MMIO access instructions.
OK. I'll revise it.
>> KVM will take following LASS voilations check on emulation path.
> /s/voilations/violations
Thanks.
>> User-mode access to supervisor space address:
>>           LA[bit 63] && (CPL == 3)
>> Supervisor-mode access to user space address:
>>           Instruction fetch: !LA[bit 63] && (CPL < 3)
>>           Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
>>                        CPL < 3) || Implicit supervisor access)
>>
>> This patch series provide a LASS KVM solution.
>>
>> We tested the basic function of LASS virtualization including LASS
>> enumeration and enabling in non-root and nested environment. As KVM
>> unittest framework is not compatible to LASS rule, we use kernel module
>> and application test to emulate LASS violation instead. With KVM forced
>> emulation mechanism, we also verified the LASS functionality on some
>> emulation path with instruction fetch and data access to have same
>> behavior as hardware.
>>
>> [1] Intel ISEhttps://cdrdv2.intel.com/v1/dl/getContent/671368
>> Chapter Linear Address Space Separation (LASS)
>>
>> ------------------------------------------------------
>>
>> v0->v1
>> 1. Adapt to new __linearize() API
>> 2. Function refactor of vmx_check_lass()
>> 3. Refine commit message to be more precise
>> 4. Drop LASS kvm cap detection depending
>>      on hardware capability
>>
>>
>> Binbin Wu (1):
>>     KVM: x86: Consolidate flags for __linearize()
>>
>> Zeng Guang (5):
>>     KVM: x86: Virtualize CR4.LASS
>>     KVM: VMX: Add new ops in kvm_x86_ops for LASS violation check
>>     KVM: x86: Add emulator helper for LASS violation check
>>     KVM: x86: LASS protection on KVM emulation
>>     KVM: x86: Advertise LASS CPUID to user space
>>
>>    arch/x86/include/asm/kvm-x86-ops.h |  3 +-
>>    arch/x86/include/asm/kvm_host.h    |  4 ++-
>>    arch/x86/kvm/cpuid.c               |  5 ++-
>>    arch/x86/kvm/emulate.c             | 47 +++++++++++++++++++++++-----
>>    arch/x86/kvm/kvm_emulate.h         |  6 ++++
>>    arch/x86/kvm/vmx/nested.c          |  3 ++
>>    arch/x86/kvm/vmx/sgx.c             |  4 +++
>>    arch/x86/kvm/vmx/vmx.c             | 50 ++++++++++++++++++++++++++++++
>>    arch/x86/kvm/vmx/vmx.h             |  2 ++
>>    arch/x86/kvm/x86.c                 | 12 +++++++
>>    arch/x86/kvm/x86.h                 |  2 ++
>>    11 files changed, 126 insertions(+), 12 deletions(-)
>>
>> -- 2.27.0

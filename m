Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB456EDA06
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 03:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbjDYBtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 21:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDYBtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 21:49:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8DB19BF;
        Mon, 24 Apr 2023 18:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682387352; x=1713923352;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RB7MLCszjLdl8wX7HNrdA2L4B19aRn4tLeyPvTGxnqA=;
  b=M9FPGRK55kG5r/f7tduDmTXFOM1VMchk2lRdkA5pEMG5YleLRN4Veqse
   6BRfEbvwzZwuBaLUw/JdwVBsE0T2vxw4TVVDdeA/MjFNcETzt1xRrIkc/
   rGRphXNmp7n8TlDJ4cgQKB8mu00skUDmWkX2MfoPk4pogjAeQ4CJb2xpv
   4OqfYmHv3JHYiFjwbVVwm/e2jEiFuYeJuiQQ/nQD3ol5zfoPgW/xtcJ9v
   S6sHKpyehulXZ8Adl+TtNTgtPIVAHMFP50PxajKolE9+1QCHEoOYteIOl
   qmqd/1L1i33cihjXMlAKMxDSHCX/l1rUywzsTJy5XT0TM1DJuSrh0amIM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="326929330"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="326929330"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 18:49:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="817488512"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="817488512"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.0.183]) ([10.238.0.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 18:49:06 -0700
Message-ID: <1b0db39e-2591-1af9-06d8-8e65c8a0e1eb@intel.com>
Date:   Tue, 25 Apr 2023 09:49:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/6] LASS KVM virtualization support
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <99fd6359-bc5d-b633-9b16-711f16063da8@linux.intel.com>
Content-Language: en-US
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <99fd6359-bc5d-b633-9b16-711f16063da8@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/24/2023 9:20 AM, Binbin Wu wrote:
> On 4/20/2023 9:37 PM, Zeng Guang wrote:
>> Linear Address Space Separation (LASS)[1] is a new mechanism that
>> enforces the same mode-based protections as paging, i.e. SMAP/SMEP but
>> without traversing the paging structures. Because the protections
>> enforced by LASS are applied before paging, "probes" by malicious
>> software will provide no paging-based timing information.
>>
>> LASS works in long mode and partitions the 64-bit canonical linear
>> address space into two halves:
>>       1. Lower half (LA[63]=0) --> user space
>>       2. Upper half (LA[63]=1) --> kernel space
>>
>> When LASS is enabled, a general protection #GP fault or a stack fault
>> #SS will be generated if software accesses the address from the half
>> in which it resides to another half,
> The accessor's mode is based on CPL, not the address range,
> so it feels a bit inaccurate of descripton "in which it resides".
>
This is alternative description to implicitly signify the privilege level,
i.e. code running in upper half means it is in supervisor mode,
otherwise it's in user mode.  :)

>> e.g., either from user space to
>> upper half, or from kernel space to lower half. This protection applies
>> to data access, code execution.
>>
>> This series add KVM LASS virtualization support.
>>
>> When platform has LASS capability, KVM requires to expose this feature
>> to guest VM enumerated by CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], and
>> allow guest to enable it via CR4.LASS[bit 27] on demand. For instruction
>> executed in the guest directly, hardware will perform the LASS violation
>> check, while KVM also needs to apply LASS to instructions emulated by
>> software and injects #GP or #SS fault to the guest.
>>
>> Following LASS voilations check will be taken on KVM emulation path.
> /s/voilations/violations
>
>
>> User-mode access to supervisor space address:
>>           LA[bit 63] && (CPL == 3)
>> Supervisor-mode access to user space address:
>>           Instruction fetch: !LA[bit 63] && (CPL < 3)
>>           Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
>>                        CPL < 3) || Implicit supervisor access)
>>
>> We tested the basic function of LASS virtualization including LASS
>> enumeration and enabling in non-root and nested environment. As current
>> KVM unittest framework is not compatible to LASS rule that kernel should
>> run in the upper half, we use kernel module and application test to verify
>> LASS functionalities in guest instead. The data access related x86 emulator
>> code is verified with forced emulation prefix (FEP) mechanism. Other test
>> cases are working in progress.
>>
>> How to add tests for LASS in KUT or kselftest is still under investigation.
>>
>> [1] Intel Architecutre Instruction Set Extensions and Future Features
> /s/Architecutre/Architecture
>
Sorry for typos above. Thanks.
>> Programming Reference: Chapter Linear Address Space Separation (LASS)
>> https://cdrdv2.intel.com/v1/dl/getContent/671368
>>
>> Zeng Guang (6):
>>     KVM: x86: Virtualize CR4.LASS
>>     KVM: VMX: Add new ops in kvm_x86_ops for LASS violation check
>>     KVM: x86: Add emulator helper for LASS violation check
>>     KVM: x86: LASS protection on KVM emulation when LASS enabled
>>     KVM: x86: Advertise LASS CPUID to user space
>>     KVM: x86: Set KVM LASS based on hardware capability
>>
>>    arch/x86/include/asm/cpuid.h       | 36 +++++++++++++++++++
>>    arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>    arch/x86/include/asm/kvm_host.h    |  7 +++-
>>    arch/x86/kvm/cpuid.c               |  8 +++--
>>    arch/x86/kvm/emulate.c             | 36 ++++++++++++++++---
>>    arch/x86/kvm/kvm_emulate.h         |  1 +
>>    arch/x86/kvm/vmx/nested.c          |  3 ++
>>    arch/x86/kvm/vmx/sgx.c             |  2 ++
>>    arch/x86/kvm/vmx/vmx.c             | 58 ++++++++++++++++++++++++++++++
>>    arch/x86/kvm/vmx/vmx.h             |  2 ++
>>    arch/x86/kvm/x86.c                 |  9 +++++
>>    arch/x86/kvm/x86.h                 |  2 ++
>>    12 files changed, 157 insertions(+), 8 deletions(-)
>>

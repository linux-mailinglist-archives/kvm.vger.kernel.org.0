Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEF277F14B
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 09:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348516AbjHQHeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 03:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348522AbjHQHds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 03:33:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852F12D69;
        Thu, 17 Aug 2023 00:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692257605; x=1723793605;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Oeel8RcKXRUqYp8g0PmHwTMnKzdDK0ugocS47dqAKrQ=;
  b=X0asVXBJc7bmgUkFo4HdmfI7LZLcD7fIEabryu7l98UEB2rtHXPhGpJp
   +eLvXPhGcgtaFPS2ONrwI6bqgNRHEspHmWR17+Qt8HcB3j9q+oAAuyV1N
   nGbqErm91/T9z/c4hikmZWj4ZQTumV3WfPTIv+8yaSYl9cX6Tmm36rBON
   5cpMMYaqkFiFJrmsNnGRxAwfZFbah/EUWkcmjLQvOc3cVUYQVUvg+OfVW
   L/tZEXXIKQGP8SfT4XXPFNX3N6yxji74zNLhqJwpJtKfIpd4+qjqcv0u2
   pC7f9rs7sznoeMXmHjnPdC+W6B0cKYgSGA+yAyKV+3SfWt4zjv4RSOuGd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="376474730"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="376474730"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 00:32:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="737597124"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="737597124"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.0.211]) ([10.238.0.211])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 00:32:53 -0700
Message-ID: <7a48e28c-d894-c442-05a0-1e5bafd32489@intel.com>
Date:   Thu, 17 Aug 2023 15:32:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2 0/8] LASS KVM virtualization support
To:     "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230718131844.5706-1-guang.zeng@intel.com>
 <6E16A5AF-1970-45FF-8961-85232E920C99@zytor.com>
Content-Language: en-US
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <6E16A5AF-1970-45FF-8961-85232E920C99@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/20/2023 9:59 AM, H. Peter Anvin wrote:
> On July 18, 2023 6:18:36 AM PDT, Zeng Guang <guang.zeng@intel.com> wrote:
>> Linear Address Space Separation (LASS)[1] is a new mechanism that
>> enforces the same mode-based protections as paging, i.e. SMAP/SMEP
>> but without traversing the paging structures. Because the protections
>> enforced by LASS are applied before paging, "probes" by malicious
>> software will provide no paging-based timing information.
>>
>> Based on a linear-address organization, LASS partitions 64-bit linear
>> address space into two halves, user-mode address (LA[bit 63]=0) and
>> supervisor-mode address (LA[bit 63]=1).
>>
>> LASS aims to prevent any attempt to probe supervisor-mode addresses by
>> user mode, and likewise stop any attempt to access (if SMAP enabled) or
>> execute user-mode addresses from supervisor mode.
>>
>> When platform has LASS capability, KVM requires to expose this feature
>> to guest VM enumerated by CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], and
>> allow guest to enable it via CR4.LASS[bit 27] on demand. For instruction
>> executed in the guest directly, hardware will perform the check. But KVM
>> also needs to behave same as hardware to apply LASS to kinds of guest
>> memory accesses when emulating instructions by software.
>>
>> KVM will take following LASS violations check on emulation path.
>> User-mode access to supervisor space address:
>>         LA[bit 63] && (CPL == 3)
>> Supervisor-mode access to user space address:
>>         Instruction fetch: !LA[bit 63] && (CPL < 3)
>>         Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
>>                      CPL < 3) || Implicit supervisor access)
>>
>> This patch series provide a LASS KVM solution and depends on kernel
>> enabling that can be found at
>> https://lore.kernel.org/all/20230609183632.48706-1-alexander.shishkin@linux.intel.com/
>>
>> We tested the basic function of LASS virtualization including LASS
>> enumeration and enabling in non-root and nested environment. As KVM
>> unittest framework is not compatible to LASS rule, we use kernel module
>> and application test to emulate LASS violation instead. With KVM forced
>> emulation mechanism, we also verified the LASS functionality on some
>> emulation path with instruction fetch and data access to have same
>> behavior as hardware.
>>
>> How to extend kselftest to support LASS is under investigation and
>> experiment.
>>
>> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>> Chapter Linear Address Space Separation (LASS)
>>
>> ------------------------------------------------------------------------
>>
>> v1->v2
>> 1. refactor and optimize the interface of instruction emulation
>>    by introducing new set of operation type definition prefixed with
>>    "X86EMUL_F_" to distinguish access.
>> 2. reorganize the patch to make each area of KVM better isolated.
>> 3. refine LASS violation check design with consideration of wraparound
>>    access across address space boundary.
>>
>> v0->v1
>> 1. Adapt to new __linearize() API
>> 2. Function refactor of vmx_check_lass()
>> 3. Refine commit message to be more precise
>> 4. Drop LASS kvm cap detection depending
>>    on hardware capability
>>
>> Binbin Wu (4):
>>   KVM: x86: Consolidate flags for __linearize()
>>   KVM: x86: Use a new flag for branch instructions
>>   KVM: x86: Add an emulation flag for implicit system access
>>   KVM: x86: Add X86EMUL_F_INVTLB and pass it in em_invlpg()
>>
>> Zeng Guang (4):
>>   KVM: emulator: Add emulation of LASS violation checks on linear
>>     address
>>   KVM: VMX: Implement and apply vmx_is_lass_violation() for LASS
>>     protection
>>   KVM: x86: Virtualize CR4.LASS
>>   KVM: x86: Advertise LASS CPUID to user space
>>
>> arch/x86/include/asm/kvm-x86-ops.h |  3 ++-
>> arch/x86/include/asm/kvm_host.h    |  5 +++-
>> arch/x86/kvm/cpuid.c               |  5 ++--
>> arch/x86/kvm/emulate.c             | 37 ++++++++++++++++++++---------
>> arch/x86/kvm/kvm_emulate.h         |  9 +++++++
>> arch/x86/kvm/vmx/nested.c          |  3 ++-
>> arch/x86/kvm/vmx/sgx.c             |  4 ++++
>> arch/x86/kvm/vmx/vmx.c             | 38 ++++++++++++++++++++++++++++++
>> arch/x86/kvm/vmx/vmx.h             |  3 +++
>> arch/x86/kvm/x86.c                 | 10 ++++++++
>> arch/x86/kvm/x86.h                 |  2 ++
>> 11 files changed, 102 insertions(+), 17 deletions(-)
>>
> Equating this with SMEP/SMAP is backwards.
>
> LASS is something completely different: it makes it so *user space accesses* cannot even walk the kernel page tables (specifically, the negative half of the linear address space.)
>
> Such an access with immediately #PF: it is similar to always having U=0 in the uppermost level of the page tables, except with LASS enabled the CPU will not even touch the page tables in memory.
Right. LASS provide a more stricter protect mode without touching/walk 
page table than paging.
The difference is that LASS will generate #GP or #SS exception whenever 
it detects any violation
other than page fault.


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E32721B93
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 03:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjFEBjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 21:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjFEBjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 21:39:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F63A1;
        Sun,  4 Jun 2023 18:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685929177; x=1717465177;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FvdPokw1eJQlrk8ZKjLQCsp3vJvdFbHxCoJqlQurJkE=;
  b=iUnCi5EPoEI9ldYRvY4lcRJUo80ibB2UDmsrl8eqfcHBCeL4ibWefiax
   /w01Onqb5OErGGiN105vNGPjObpMjRksaFj2x/3yXFNT+xx0SkpIONUsJ
   RROkE5wN8OjiKtPFKPZsWAYKWcRAzgpJvN00UISOn67NUMUNkvx+LSGhE
   fjqcR+N5eEub6/J1KYZjWAjPc4Du5FUX+G8390WrrjCJSYzrOjeHj012v
   gKLq9Usi0WcMFlp9De6QIHQ2u5YbVIezWEubk9Bzz3+52ue1Eh3dEJ5TV
   TwhBM/0BZUKGp+ah7F5B2yhiF1zA8gox++m/nEGAEHqNrfbwGj0XKIBS6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="356268227"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="356268227"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 18:39:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="708490085"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="708490085"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.17]) ([10.238.9.17])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 18:39:34 -0700
Message-ID: <08cf5a8a-7937-c033-06e7-85fe42758eaa@linux.intel.com>
Date:   Mon, 5 Jun 2023 09:39:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v1 0/6] LASS KVM virtualization support
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230601142309.6307-1-guang.zeng@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230601142309.6307-1-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/1/2023 10:23 PM, Zeng Guang wrote:
> Subject:
> [PATCH v1 0/6] LASS KVM virtualization support
> From:
> Zeng Guang <guang.zeng@intel.com>
> Date:
> 6/1/2023, 10:23 PM
>
> To:
> Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson 
> <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar 
> <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen 
> <dave.hansen@linux.intel.com>, H Peter Anvin <hpa@zytor.com>, 
> kvm@vger.kernel.org
> CC:
> x86@kernel.org, linux-kernel@vger.kernel.org, Zeng Guang 
> <guang.zeng@intel.com>
>
>
> Linear Address Space Separation (LASS)[1] is an independent mechanism
> that enforces the mode-based protections on any access to a linear
> address.
>
> Based on a linear-address organization, the 64-bit canonical linear
> address space is partitioned into two halves: all linear addresses
> whose most significant bit is 0 are user space addresses, while linear
> addresses whose most significant bit is 1 are supervisor space address.
>
> LASS aims to prevent any attempt to probe supervisor space addresses by
> user mode, and likewise stop any attempt to access (if SMAP enabled) or
> execute user space addresses from supervisor mode.
>
> When platform has LASS capability, KVM requires to expose this feature
> to guest VM enumerated by CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], and
> allow guest to enable it via CR4.LASS[bit 27] on demand. For instruction
> executed in the guest directly, hardware will perform the check. But KVM
> also needs to behave same as hardware to apply LASS to kinds of guest
> memory accesses when emulating privileged instructions by software.
Not just privileged instructions, e.g. MMIO access instructions.

>
> KVM will take following LASS voilations check on emulation path.
/s/voilations/violations

> User-mode access to supervisor space address:
>          LA[bit 63] && (CPL == 3)
> Supervisor-mode access to user space address:
>          Instruction fetch: !LA[bit 63] && (CPL < 3)
>          Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
>                       CPL < 3) || Implicit supervisor access)
>
> This patch series provide a LASS KVM solution.
>
> We tested the basic function of LASS virtualization including LASS
> enumeration and enabling in non-root and nested environment. As KVM
> unittest framework is not compatible to LASS rule, we use kernel module
> and application test to emulate LASS violation instead. With KVM forced
> emulation mechanism, we also verified the LASS functionality on some
> emulation path with instruction fetch and data access to have same
> behavior as hardware.
>
> [1] Intel ISEhttps://cdrdv2.intel.com/v1/dl/getContent/671368
> Chapter Linear Address Space Separation (LASS)
>
> ------------------------------------------------------
>
> v0->v1
> 1. Adapt to new __linearize() API
> 2. Function refactor of vmx_check_lass()
> 3. Refine commit message to be more precise
> 4. Drop LASS kvm cap detection depending
>     on hardware capability
>
>
> Binbin Wu (1):
>    KVM: x86: Consolidate flags for __linearize()
>
> Zeng Guang (5):
>    KVM: x86: Virtualize CR4.LASS
>    KVM: VMX: Add new ops in kvm_x86_ops for LASS violation check
>    KVM: x86: Add emulator helper for LASS violation check
>    KVM: x86: LASS protection on KVM emulation
>    KVM: x86: Advertise LASS CPUID to user space
>
>   arch/x86/include/asm/kvm-x86-ops.h |  3 +-
>   arch/x86/include/asm/kvm_host.h    |  4 ++-
>   arch/x86/kvm/cpuid.c               |  5 ++-
>   arch/x86/kvm/emulate.c             | 47 +++++++++++++++++++++++-----
>   arch/x86/kvm/kvm_emulate.h         |  6 ++++
>   arch/x86/kvm/vmx/nested.c          |  3 ++
>   arch/x86/kvm/vmx/sgx.c             |  4 +++
>   arch/x86/kvm/vmx/vmx.c             | 50 ++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.h             |  2 ++
>   arch/x86/kvm/x86.c                 | 12 +++++++
>   arch/x86/kvm/x86.h                 |  2 ++
>   11 files changed, 126 insertions(+), 12 deletions(-)
>
> -- 2.27.0


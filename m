Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D061D6EC673
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 08:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjDXGpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 02:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjDXGpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 02:45:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64E1270B;
        Sun, 23 Apr 2023 23:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682318737; x=1713854737;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ym78hY4nNNMqICkpjm9E14HXIIRZXu25SHXIuxXeSsk=;
  b=h9x5by5pVo4qEScu2Ilhudq25UDNBl3USu10kq6uFJI3vbFO5L5OtSyL
   U1hR3BvC/Nnt0g64/2N6RcBS4veLvgDj/CIIScDxd6AQ0x+hGuclXpoK+
   4eYFMW+Khwrks3346CNeERsy1PphOaY6y2zCyvrYLzGZ6WxB0Gh2kN3Cg
   Xd0AoftzwLqjgqR33gLcHWbysD5gteMAbODsBc7kHzoFKSLQgzP/45NU3
   qBirs2JTidaYjbcrDJN7mvEzKZWmkYHl34QiIveUaMmmrr+90hkX9ZIIh
   1MWcRwyVky2BKIZ6TPgm1PDZMb9BLe5nDY3b77ZRAdebcXnQo/+9W/xJy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="325984010"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="325984010"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 23:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="670391750"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="670391750"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.3.89]) ([10.238.3.89])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 23:45:33 -0700
Message-ID: <9e2a5232-0c74-585c-9f32-ff9cdd22883a@linux.intel.com>
Date:   Mon, 24 Apr 2023 14:45:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/6] KVM: x86: Virtualize CR4.LASS
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-2-guang.zeng@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230420133724.11398-2-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

one nit below

On 4/20/2023 9:37 PM, Zeng Guang wrote:
> Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
under control of KVM or under KVM's control

Or just simply use "intercept"?

> as CR4.LASS generally set once for each vCPU at boot time and won't be
> toggled at runtime. Besides, only if VM has LASS capability enumerated with
> CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
> to set CR4.LASS. By design CR4.LASS can be manipulated by nested guest as
> well.
>
> Notes: Setting CR4.LASS to 1 enable LASS in IA-32e mode. It doesn't take
> effect in legacy mode even if CR4.LASS is set.
>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 2 +-
>   arch/x86/kvm/vmx/vmx.c          | 3 +++
>   arch/x86/kvm/x86.h              | 2 ++
>   3 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6aaae18f1854..8ff89a52ef66 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -125,7 +125,7 @@
>   			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>   			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>   			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP | X86_CR4_LASS))
>   
>   #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 43ff3276918b..c923d7599d71 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7569,6 +7569,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>   	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>   	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
>   
> +	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
> +	cr4_fixed1_update(X86_CR4_LASS,       eax, feature_bit(LASS));
> +
>   #undef cr4_fixed1_update
>   }
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 7c8a30d44c29..218f4c73789a 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -475,6 +475,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>   		__reserved_bits |= X86_CR4_VMXE;        \
>   	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>   		__reserved_bits |= X86_CR4_PCIDE;       \
> +	if (!__cpu_has(__c, X86_FEATURE_LASS))          \
> +		__reserved_bits |= X86_CR4_LASS;        \
>   	__reserved_bits;                                \
>   })
>   


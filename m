Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90877502C55
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354825AbiDOPJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348301AbiDOPJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:09:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D73BBD7E8;
        Fri, 15 Apr 2022 08:06:54 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso5181843wmz.4;
        Fri, 15 Apr 2022 08:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z+ZzteNL1B5uNdnnAQT3e/XkUjVBtdobVF4d1HQJH34=;
        b=Da0m8fA8NA4Hk4Zzb+pT4m1VE6XRuDvRG5I4hMz+LbJFRS5N15e/mmdHJKT1h7tOYs
         kQfDqSTVlWQWu9dvaZTlYZ+xbgunrhfcPa2XgnkB4hlF3I7NjSizdylpjslQuBGuTVv/
         09IBOG89HozaoPwa7NNFBGLW1o/NhFN9/SOOF40Luk37huFuzFZ1OkPc0TR16QlXXXl4
         n6i9iUN4PBt8xYebpGTyKk5vNm/vtgTxa0Ldgk5ivj9pm7DA4gyt0CF4x19CueBeGcV3
         JaMZU3QhgcmsGiBzKMJ5pA9oagMQKYFZhgM2MMQQaFi9OdLjeAOIPHDt+UQz9PMuU9aP
         Rtag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z+ZzteNL1B5uNdnnAQT3e/XkUjVBtdobVF4d1HQJH34=;
        b=zMN02NPAzAPUgnwYDgOZOOdzfmD2pRfuDcHmR31BEFZpupfiXo4sr7fUPMUtMyTNRP
         0Bs12At8iATVYxUYvhhByx0j2oiSAU+pOdrKyYTJqajy9xIstG/BEdHCnJUL9kClcDyl
         6GLaV9ODwT7L/hyjJGDkPJPKSVsiXb3cCP+dwpqrB75+YKh7d+x9uIE8aR9PqCmPwTwO
         ERVFy6v7s7hjDT7P+QTmFhEoz66jYAaF+yqSQ3WLxf2oVtd/4MODhuA4inHxQP+z8obI
         nODNeB8O1G/ZELhgYnSXpvP9tkqfTwjtDfRViJFPabsZAzMt6AB6em1jYZbLdFhe+SUJ
         qspw==
X-Gm-Message-State: AOAM5321DHiofWlgozILrG9WLI6wQ7qxq48T3yWNpRAIGTkBdC3M88iZ
        L/S1/BM+2nU36RD8WYzV9LNcUQNAk7WEjA==
X-Google-Smtp-Source: ABdhPJz8FaMbQoRRaFwVq5H7k+alQh9LURSn6O2lnjtGsFgzXRyOrLrHypKkJorATMo+BHJd1e5U+g==
X-Received: by 2002:a05:600c:a45:b0:346:5e67:cd54 with SMTP id c5-20020a05600c0a4500b003465e67cd54mr3755891wmq.127.1650035212870;
        Fri, 15 Apr 2022 08:06:52 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id c186-20020a1c35c3000000b0038e6c6fc860sm5176738wma.37.2022.04.15.08.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 08:06:52 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f520643c-76e6-36f3-604f-601a66d6272a@redhat.com>
Date:   Fri, 15 Apr 2022 17:05:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 094/104] KVM: TDX: Handle TDX PV MMIO hypercall
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <2600955a0bd445bff17eb2bb43edbb71035ae2f5.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2600955a0bd445bff17eb2bb43edbb71035ae2f5.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Export kvm_io_bus_read and kvm_mmio tracepoint and wire up TDX PV MMIO
> hypercall to the KVM backend functions.
> 
> kvm_io_bus_read/write() searches KVM device emulated in kernel of the given
> MMIO address and emulates the MMIO.  As TDX PV MMIO also needs it, export
> kvm_io_bus_read().  kvm_io_bus_write() is already exported.  TDX PV MMIO
> emulates some of MMIO itself.  To add trace point consistently with x86
> kvm, export kvm_mmio tracepoint.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.c     |   1 +
>   virt/kvm/kvm_main.c    |   2 +
>   3 files changed, 117 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c900347d0bc7..914af5da4805 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1012,6 +1012,118 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>   	return ret;
>   }
>   
> +static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long val = 0;
> +	gpa_t gpa;
> +	int size;
> +
> +	WARN_ON(vcpu->mmio_needed != 1);
> +	vcpu->mmio_needed = 0;
> +
> +	if (!vcpu->mmio_is_write) {
> +		gpa = vcpu->mmio_fragments[0].gpa;
> +		size = vcpu->mmio_fragments[0].len;
> +
> +		memcpy(&val, vcpu->run->mmio.data, size);
> +		tdvmcall_set_return_val(vcpu, val);
> +		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> +	}
> +	return 1;
> +}
> +
> +static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, int size,
> +				 unsigned long val)
> +{
> +	if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
> +	    kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
> +		return -EOPNOTSUPP;
> +
> +	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
> +	return 0;
> +}
> +
> +static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
> +{
> +	unsigned long val;
> +
> +	if (kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
> +	    kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
> +		return -EOPNOTSUPP;
> +
> +	tdvmcall_set_return_val(vcpu, val);
> +	trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
> +	return 0;
> +}
> +
> +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_memory_slot *slot;
> +	int size, write, r;
> +	unsigned long val;
> +	gpa_t gpa;
> +
> +	WARN_ON(vcpu->mmio_needed);
> +
> +	size = tdvmcall_p1_read(vcpu);
> +	write = tdvmcall_p2_read(vcpu);
> +	gpa = tdvmcall_p3_read(vcpu);
> +	val = write ? tdvmcall_p4_read(vcpu) : 0;
> +
> +	if (size != 1 && size != 2 && size != 4 && size != 8)
> +		goto error;
> +	if (write != 0 && write != 1)
> +		goto error;
> +
> +	/* Strip the shared bit, allow MMIO with and without it set. */
> +	gpa = kvm_gpa_unalias(vcpu->kvm, gpa);
> +
> +	if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK)
> +		goto error;
> +
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
> +	if (slot && !(slot->flags & KVM_MEMSLOT_INVALID))
> +		goto error;
> +
> +	if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> +		trace_kvm_fast_mmio(gpa);
> +		return 1;
> +	}
> +
> +	if (write)
> +		r = tdx_mmio_write(vcpu, gpa, size, val);
> +	else
> +		r = tdx_mmio_read(vcpu, gpa, size);
> +	if (!r) {
> +		/* Kernel completed device emulation. */
> +		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +		return 1;
> +	}
> +
> +	/* Request the device emulation to userspace device model. */
> +	vcpu->mmio_needed = 1;
> +	vcpu->mmio_is_write = write;
> +	vcpu->arch.complete_userspace_io = tdx_complete_mmio;
> +
> +	vcpu->run->mmio.phys_addr = gpa;
> +	vcpu->run->mmio.len = size;
> +	vcpu->run->mmio.is_write = write;
> +	vcpu->run->exit_reason = KVM_EXIT_MMIO;
> +
> +	if (write) {
> +		memcpy(vcpu->run->mmio.data, &val, size);
> +	} else {
> +		vcpu->mmio_fragments[0].gpa = gpa;
> +		vcpu->mmio_fragments[0].len = size;
> +		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
> +	}
> +	return 0;
> +
> +error:
> +	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +	return 1;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -1029,6 +1141,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   		return tdx_emulate_hlt(vcpu);
>   	case EXIT_REASON_IO_INSTRUCTION:
>   		return tdx_emulate_io(vcpu);
> +	case EXIT_REASON_EPT_VIOLATION:
> +		return tdx_emulate_mmio(vcpu);
>   	default:
>   		break;
>   	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9acb33a17445..483fa46b1be7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12915,6 +12915,7 @@ bool kvm_arch_dirty_log_supported(struct kvm *kvm)
>   
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d4e117f5b5b9..6db075db6098 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2259,6 +2259,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>   
>   	return NULL;
>   }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>   
>   bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>   {
> @@ -5126,6 +5127,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>   	r = __kvm_io_bus_read(vcpu, bus, &range, val);
>   	return r < 0 ? r : 0;
>   }
> +EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>   
>   /* Caller must hold slots_lock. */
>   int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

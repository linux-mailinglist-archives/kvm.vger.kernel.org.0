Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB73A2DFF70
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgLUSOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:14:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbgLUSOH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Dec 2020 13:14:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608574360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FNWljgMN9GP4v/GttfkerKbzxoxWratIwvuxaoSFccA=;
        b=TQavvN1imdTyxhQ7SDhJm+HTPHncLYZBiPgWyjDO+9+c1+xk5lvhx2qct4Hqpyof+LImJK
        a3jbGftqVEFxrqebMVw+mdOF2AH4KAVHYw0wPrcwo1wY1ttOCl0VQ01EAF6v6njBWYE9kV
        Pl6FE/mRvFdckKyKhTiE+Y7FEJ7m6X8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-z0kpasI6PcCr8zYt8RDWfA-1; Mon, 21 Dec 2020 13:12:37 -0500
X-MC-Unique: z0kpasI6PcCr8zYt8RDWfA-1
Received: by mail-wm1-f69.google.com with SMTP id 14so5363984wmo.8
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 10:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FNWljgMN9GP4v/GttfkerKbzxoxWratIwvuxaoSFccA=;
        b=XEMP5BlF2MbSuhPzXzzH3CoaVfv4xJawKORaSvs/J/sQTL6zJEJcOxHL+ymfrpatCB
         Qesq95RB2ALjLjPbVofjT+CqGB9z3i7xfCSaDa9DzRbAHX0FDETp9TaQEAvWuUEYx9Re
         mYA3KmJaJrB9q8mDpqbCc3cBtBCpW7TjBA04raEvny7iJ/uwOeMQQdx14mrJYPM9LiN4
         8zJknKAwcN1umGYkYraHv6DuqWcY0gJoFwtphFSk79qZVyRbbiAmDCNYt4JTmhDojSoN
         F93RJUEM9cqUDr3rP1iYZZWR9DjOXpXmTWquKmstm6qQzKNdf3Z3oW4rUaui9xVUcvRx
         gsMw==
X-Gm-Message-State: AOAM531zlmjy98uHB2Bg6lvMwLtOf/nv289Pr9VTl/B7668S4fKLENIA
        LitwENpLz1LFSOFtGl+fkUVdV6Fi29Des/hbbKEEzhSzBPuwZOO8psQErefSfYiju/X9josIzGo
        hcqr5pGB684jv
X-Received: by 2002:adf:ce84:: with SMTP id r4mr19650803wrn.91.1608574355729;
        Mon, 21 Dec 2020 10:12:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzacrgwP2Niy/JAPK2sTsrTEybPDcKTOmrRzQkSs/hVxQi/hairbdj4Xxk29BZYytT0R93dOw==
X-Received: by 2002:adf:ce84:: with SMTP id r4mr19650775wrn.91.1608574355458;
        Mon, 21 Dec 2020 10:12:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r7sm19534725wmh.2.2020.12.21.10.12.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:12:34 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Add register operand to vmsave call in
 sev_es_vcpu_load
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
References: <20201219063711.3526947-1-natechancellor@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f6d61324-4243-e5ed-9450-6ee8f9b1f44b@redhat.com>
Date:   Mon, 21 Dec 2020 19:12:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201219063711.3526947-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/12/20 07:37, Nathan Chancellor wrote:
> When using LLVM's integrated assembler (LLVM_IAS=1) while building
> x86_64_defconfig + CONFIG_KVM=y + CONFIG_KVM_AMD=y, the following build
> error occurs:
> 
>   $ make LLVM=1 LLVM_IAS=1 arch/x86/kvm/svm/sev.o
>   arch/x86/kvm/svm/sev.c:2004:15: error: too few operands for instruction
>           asm volatile(__ex("vmsave") : : "a" (__sme_page_pa(sd->save_area)) : "memory");
>                        ^
>   arch/x86/kvm/svm/sev.c:28:17: note: expanded from macro '__ex'
>   #define __ex(x) __kvm_handle_fault_on_reboot(x)
>                   ^
>   ./arch/x86/include/asm/kvm_host.h:1646:10: note: expanded from macro '__kvm_handle_fault_on_reboot'
>           "666: \n\t"                                                     \
>                   ^
>   <inline asm>:2:2: note: instantiated into assembly here
>           vmsave
>           ^
>   1 error generated.
> 
> This happens because LLVM currently does not support calling vmsave
> without the fixed register operand (%rax for 64-bit and %eax for
> 32-bit). This will be fixed in LLVM 12 but the kernel currently supports
> LLVM 10.0.1 and newer so this needs to be handled.
> 
> Add the proper register using the _ASM_AX macro, which matches the
> vmsave call in vmenter.S.
> 
> Fixes: 861377730aa9 ("KVM: SVM: Provide support for SEV-ES vCPU loading")
> Link: https://reviews.llvm.org/D93524
> Link: https://github.com/ClangBuiltLinux/linux/issues/1216
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>   arch/x86/kvm/svm/sev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e57847ff8bd2..958370758ed0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2001,7 +2001,7 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
>   	 * of which one step is to perform a VMLOAD. Since hardware does not
>   	 * perform a VMSAVE on VMRUN, the host savearea must be updated.
>   	 */
> -	asm volatile(__ex("vmsave") : : "a" (__sme_page_pa(sd->save_area)) : "memory");
> +	asm volatile(__ex("vmsave %%"_ASM_AX) : : "a" (__sme_page_pa(sd->save_area)) : "memory");
>   
>   	/*
>   	 * Certain MSRs are restored on VMEXIT, only save ones that aren't
> 

Queued, thanks.

Paolo


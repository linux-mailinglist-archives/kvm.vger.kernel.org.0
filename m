Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D649316C46
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 18:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhBJRO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 12:14:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232432AbhBJROB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 12:14:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612977155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N0dPBrQbBpoptFsVt/PnRIJbrGhO0kdoQfSLeRfhcHU=;
        b=bkgyaUfWGKEbAbambyBeiRpzBFT2EgXwT+ffDZZD1s61XxlTqSeLkZ5RC5PSsEiemkzkUf
        mjyco1LT2qkl5NAFwXrt8XT6HaMEclokop3x1FzDZWlh+K5iv2YL2uPz9t9oLutOfX9M21
        L39OtyKdiZyZu235wsRzb8lcFP4AD4c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-9qWMk0PhNZCFMlYPYhyuug-1; Wed, 10 Feb 2021 12:12:33 -0500
X-MC-Unique: 9qWMk0PhNZCFMlYPYhyuug-1
Received: by mail-wm1-f72.google.com with SMTP id m25so1704210wmi.6
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 09:12:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N0dPBrQbBpoptFsVt/PnRIJbrGhO0kdoQfSLeRfhcHU=;
        b=qm93xPtGytSWa5lrzhD62EaAODK82cXXWU1WrPZaSVEN9s6TMTU5hixhFrVIenmeJk
         z/bHa5ytz9tFy1KeTPOMFgWC13OlobNvQodBMkpHvmB046x4rK2wD3DJnW8jvoVlF5+V
         E81zB1LZ5b/OCb2JM+LCS8WcefEZ+jXBd6SOWEoI8hUwsC45p3/KVqVHUG8UD/LB9prW
         xHyweKwoVOWTxicToIHYR7XipAklR1y5BmzCvYmK4epa9Bfk2oPy5U1V+tjxFHjYMJho
         4ylwcsHDO4KLdjs5TniQY7qjsCrskD7MSdBAXr/G4m8y0UxVI3KiFmm51lQMxSyS/L73
         ZpKg==
X-Gm-Message-State: AOAM53094ZvaEtsfEQPZzcIZ9raxr1R+Y2zOJbx7fdMHgVVxhBPanpus
        jr3zyqZO/lzkLn76h+02ZioblCqQt6gVmN0Uze9JRAfozkS/ZV8WeU8R+HMKl/n/qQhQynzsVIb
        I2hpV4VaxAnGw
X-Received: by 2002:adf:f344:: with SMTP id e4mr4848087wrp.363.1612977152502;
        Wed, 10 Feb 2021 09:12:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfG5+yG8iFTw16qNFP9GlAejpJaix75FKcIeHDm03be483ATZdO5CIt8wJD6hc2rB9C8sdsw==
X-Received: by 2002:adf:f344:: with SMTP id e4mr4848067wrp.363.1612977152290;
        Wed, 10 Feb 2021 09:12:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f8sm3841800wrp.65.2021.02.10.09.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 09:12:31 -0800 (PST)
Subject: Re: [PATCH] KVM: selftests: Add operand to vmsave/vmload/vmrun in
 svm.c
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20210210031719.769837-1-ricarkol@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7488580b-ca23-0c3c-a298-04371286e712@redhat.com>
Date:   Wed, 10 Feb 2021 18:12:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210210031719.769837-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/21 04:17, Ricardo Koller wrote:
> Building the KVM selftests with LLVM's integrated assembler fails with:
> 
>    $ CFLAGS=-fintegrated-as make -C tools/testing/selftests/kvm CC=clang
>    lib/x86_64/svm.c:77:16: error: too few operands for instruction
>            asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
>                          ^
>    <inline asm>:1:2: note: instantiated into assembly here
>            vmsave
>            ^
>    lib/x86_64/svm.c:134:3: error: too few operands for instruction
>                    "vmload\n\t"
>                    ^
>    <inline asm>:1:2: note: instantiated into assembly here
>            vmload
>            ^
> This is because LLVM IAS does not currently support calling vmsave,
> vmload, or vmload without an explicit %rax operand.
> 
> Add an explicit operand to vmsave, vmload, and vmrum in svm.c. Fixing
> this was suggested by Sean Christopherson.
> 
> Tested: building without this error in clang 11. The following patch
> (not queued yet) needs to be applied to solve the other remaining error:
> "selftests: kvm: remove reassignment of non-absolute variables".
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/kvm/X+Df2oQczVBmwEzi@google.com/
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   tools/testing/selftests/kvm/lib/x86_64/svm.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> index 3a5c72ed2b79..827fe6028dd4 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> @@ -74,7 +74,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
>   	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
>   
>   	memset(vmcb, 0, sizeof(*vmcb));
> -	asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
> +	asm volatile ("vmsave %0\n\t" : : "a" (vmcb_gpa) : "memory");
>   	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
>   	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
>   	vmcb_set_seg(&save->ss, get_ss(), 0, -1U, data_seg_attr);
> @@ -131,19 +131,19 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
>   void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
>   {
>   	asm volatile (
> -		"vmload\n\t"
> +		"vmload %[vmcb_gpa]\n\t"
>   		"mov rflags, %%r15\n\t"	// rflags
>   		"mov %%r15, 0x170(%[vmcb])\n\t"
>   		"mov guest_regs, %%r15\n\t"	// rax
>   		"mov %%r15, 0x1f8(%[vmcb])\n\t"
>   		LOAD_GPR_C
> -		"vmrun\n\t"
> +		"vmrun %[vmcb_gpa]\n\t"
>   		SAVE_GPR_C
>   		"mov 0x170(%[vmcb]), %%r15\n\t"	// rflags
>   		"mov %%r15, rflags\n\t"
>   		"mov 0x1f8(%[vmcb]), %%r15\n\t"	// rax
>   		"mov %%r15, guest_regs\n\t"
> -		"vmsave\n\t"
> +		"vmsave %[vmcb_gpa]\n\t"
>   		: : [vmcb] "r" (vmcb), [vmcb_gpa] "a" (vmcb_gpa)
>   		: "r15", "memory");
>   }
> 

Queued, thanks.

Paolo


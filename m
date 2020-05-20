Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194191DBA23
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgETQuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:50:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23708 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgETQuO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 12:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589993413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXTymJQNnp1YqswORUb9Q++cmRFARlB1HN4U6umjrto=;
        b=WDj6C/jkuTxHKh0Jr7Eew68q57xU/Iy1abLQalux2wHJMHuqgNu4NFUhcLOTyzbEp9IjYF
        Ydm6R/+lT5QosoPz1IcwJYTSRffc9IdASrJlJGhddjYIvQ8SR9TQbpAGG8NNBIAlZSxKt5
        Z9oR3qrr/zRWTmcwQ+lR7ACTpvo54zc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-cfhOFugaOyyCbRZUpFSQcA-1; Wed, 20 May 2020 12:50:10 -0400
X-MC-Unique: cfhOFugaOyyCbRZUpFSQcA-1
Received: by mail-ej1-f69.google.com with SMTP id s7so1609268eji.0
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 09:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rXTymJQNnp1YqswORUb9Q++cmRFARlB1HN4U6umjrto=;
        b=Va2+CJ6gUequnFFYOcEewbFg/ql691c7/AFCGF8dAUqwaZ9wzuwscbcBtkevbvBs50
         +ET05WR778PklCd8f4X9BwR/W4FlNB47N2lEfG6vkm3OGP9PeumOa9XvznGEnUv+ltDg
         lFYkxFRGn2PSrM8aXeb4LPJq+1NYpUMuAG/vZSbxO/Dg6da7WtlUAsbFc+7z+EmBjEGC
         aE4X1+AAiblDjKAK3eWouVfZdsEGcig5duPXNiZCVleOL5a5yxlnAK/Bw7vJkCJpwOwk
         6fKydLJDhnfUe1t+EVDXGpKarMYi0rFazeZt27rISZOqHDnykYgvLkb5ko9PyVx7Peod
         aPRw==
X-Gm-Message-State: AOAM531DKPF9eDnosg88r75sJhrkFU4J2wI6NkFT5lemmQiK3Jzeek+1
        42sFQduAQKghjLB+tIoC5yCL1pkC6Kz6PzxYdmQKQ7S4fBCzjxRn8pRBx1XDjc7sdRIwsrkVfxY
        JzlF4nhjflb3N
X-Received: by 2002:aa7:d2d0:: with SMTP id k16mr4185170edr.272.1589993409425;
        Wed, 20 May 2020 09:50:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGAobpwNZkjUCikORCeYDsn8zxpL1WyvEjubOSA8Bp5jVuA9sEe1UrgNI543D4ovpr0A8txA==
X-Received: by 2002:aa7:d2d0:: with SMTP id k16mr4185150edr.272.1589993409195;
        Wed, 20 May 2020 09:50:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id gx25sm2319388ejb.63.2020.05.20.09.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 09:50:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     oupton@google.com
Subject: Re: [PATCH 1/3] selftests: kvm: add a SVM version of state-test
In-Reply-To: <20200519180740.89884-1-pbonzini@redhat.com>
References: <20200519180740.89884-1-pbonzini@redhat.com>
Date:   Wed, 20 May 2020 18:50:07 +0200
Message-ID: <87y2pmsg8w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  .../testing/selftests/kvm/x86_64/state_test.c | 65 ++++++++++++++++---
>  1 file changed, 55 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
> index 5b1a016edf55..1c5216f1ef0a 100644
> --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/state_test.c
> @@ -18,10 +18,42 @@
>  #include "kvm_util.h"
>  #include "processor.h"
>  #include "vmx.h"
> +#include "svm_util.h"
>  
>  #define VCPU_ID		5
> +#define L2_GUEST_STACK_SIZE 64
> +
> +void svm_l2_guest_code(void)
> +{
> +	GUEST_SYNC(4);
> +        /* Exit to L1 */
> +	vmcall();
> +	GUEST_SYNC(6);
> +	/* Done, exit to L1 and never come back.  */
> +	vmcall();
> +}
> +
> +static void svm_l1_guest_code(struct svm_test_data *svm)
> +{
> +        unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	struct vmcb *vmcb = svm->vmcb;

Nit: indentation

> +
> +	GUEST_ASSERT(svm->vmcb_gpa);
> +	/* Prepare for L2 execution. */
> +        generic_svm_setup(svm, svm_l2_guest_code,
> +                          &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +
> +	GUEST_SYNC(3);
> +	run_guest(vmcb, svm->vmcb_gpa);
> +	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +	GUEST_SYNC(5);
> +	vmcb->save.rip += 3;
> +	run_guest(vmcb, svm->vmcb_gpa);
> +	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +	GUEST_SYNC(7);
> +}
>  
> -void l2_guest_code(void)
> +void vmx_l2_guest_code(void)
>  {
>  	GUEST_SYNC(6);
>  
> @@ -42,9 +74,8 @@ void l2_guest_code(void)
>  	vmcall();
>  }
>  
> -void l1_guest_code(struct vmx_pages *vmx_pages)
> +static void vmx_l1_guest_code(struct vmx_pages *vmx_pages)
>  {
> -#define L2_GUEST_STACK_SIZE 64
>          unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>  
>  	GUEST_ASSERT(vmx_pages->vmcs_gpa);
> @@ -56,7 +87,7 @@ void l1_guest_code(struct vmx_pages *vmx_pages)
>  	GUEST_SYNC(4);
>  	GUEST_ASSERT(vmptrstz() == vmx_pages->vmcs_gpa);
>  
> -	prepare_vmcs(vmx_pages, l2_guest_code,
> +	prepare_vmcs(vmx_pages, vmx_l2_guest_code,
>  		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
>  
>  	GUEST_SYNC(5);
> @@ -106,20 +137,31 @@ void l1_guest_code(struct vmx_pages *vmx_pages)
>  	GUEST_ASSERT(vmresume());
>  }
>  
> -void guest_code(struct vmx_pages *vmx_pages)
> +static u32 cpuid_ecx(u32 eax)
> +{
> +	u32 result;
> +	asm volatile("cpuid" : "=c" (result) : "a" (eax));

Nit: doesn't cpuid clobber ebx/edx too? (and ecx also works as
input). I'd suggest we write correct implementation and put it to
the library (or find a way to use native_cpuid() from
arch/x86/include/asm/processor.h)

> +	return result;
> +}
> +
> +static void __attribute__((__flatten__)) guest_code(void *arg)
>  {
>  	GUEST_SYNC(1);
>  	GUEST_SYNC(2);
>  
> -	if (vmx_pages)
> -		l1_guest_code(vmx_pages);
> +	if (arg) {
> +		if (cpuid_ecx(0x80000001) & CPUID_SVM)
> +			svm_l1_guest_code(arg);
> +		else
> +			vmx_l1_guest_code(arg);
> +	}
>  
>  	GUEST_DONE();
>  }
>  
>  int main(int argc, char *argv[])
>  {
> -	vm_vaddr_t vmx_pages_gva = 0;
> +	vm_vaddr_t nested_gva = 0;
>  
>  	struct kvm_regs regs1, regs2;
>  	struct kvm_vm *vm;
> @@ -136,8 +178,11 @@ int main(int argc, char *argv[])
>  	vcpu_regs_get(vm, VCPU_ID, &regs1);
>  
>  	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
> -		vcpu_alloc_vmx(vm, &vmx_pages_gva);
> -		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
> +		if (kvm_get_supported_cpuid_entry(0x80000001)->ecx & CPUID_SVM)
> +			vcpu_alloc_svm(vm, &nested_gva);
> +		else
> +			vcpu_alloc_vmx(vm, &nested_gva);
> +		vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
>  	} else {
>  		pr_info("will skip nested state checks\n");
>  		vcpu_args_set(vm, VCPU_ID, 1, 0);

With two nitpicks above,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


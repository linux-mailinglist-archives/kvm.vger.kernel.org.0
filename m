Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22DD3753D3
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 14:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhEFM2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 08:28:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229921AbhEFM2v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 08:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620304072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgSadxMph4w8kdj7Ae9ltL+71dKAfC6hOMn4oBADA6s=;
        b=chAWNVIcaRi7wKD4oreh6gW0EE8nnvo35AQ2gRoGEoGfL/ex6Gtrp0Vues56NJqs/3XCIY
        LJ4umP5FuY9/WVB7VaveLWaAzOwWXSd/R9eJCfLUZhiTrDR0ZjuH+DNohvxYYAntulSzu9
        8EmZGKdP6xQV4dtAG2IHhjjzGgJroc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-5rKzy72EOz-gMj98MzJ5Pw-1; Thu, 06 May 2021 08:27:51 -0400
X-MC-Unique: 5rKzy72EOz-gMj98MzJ5Pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7578881840B;
        Thu,  6 May 2021 12:27:49 +0000 (UTC)
Received: from [10.36.113.191] (ovpn-113-191.ams2.redhat.com [10.36.113.191])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2254910023AB;
        Thu,  6 May 2021 12:27:43 +0000 (UTC)
Subject: Re: [PATCH v2 1/5] KVM: selftests: Rename vm_handle_exception
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-2-ricarkol@google.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0e0e8341-9c4d-13e8-f037-e84f0ee291dd@redhat.com>
Date:   Thu, 6 May 2021 14:27:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210430232408.2707420-2-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 5/1/21 1:24 AM, Ricardo Koller wrote:
> Rename the vm_handle_exception function to a name that indicates more
> clearly that it installs something: vm_install_vector_handler.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 +-
>  tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
>  tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 2 +-
>  .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 8 ++++----
>  tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 +-
>  5 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 0b30b4e15c38..12889d3e8948 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -391,7 +391,7 @@ struct ex_regs {
>  
>  void vm_init_descriptor_tables(struct kvm_vm *vm);
>  void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
> -void vm_handle_exception(struct kvm_vm *vm, int vector,
> +void vm_install_vector_handler(struct kvm_vm *vm, int vector,
>  			void (*handler)(struct ex_regs *));
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..e156061263a6 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1250,8 +1250,8 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
>  
> -void vm_handle_exception(struct kvm_vm *vm, int vector,
> -			 void (*handler)(struct ex_regs *))
> +void vm_install_vector_handler(struct kvm_vm *vm, int vector,
> +			       void (*handler)(struct ex_regs *))
>  {
>  	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> index 732b244d6956..5ae5f748723a 100644
> --- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
> @@ -227,7 +227,7 @@ int main(void)
>  
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);
> -	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
> +	vm_install_vector_handler(vm, GP_VECTOR, guest_gp_handler);
>  
>  	enter_guest(vm);
>  	kvm_vm_free(vm);
> diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> index 72c0d0797522..20c373e2d329 100644
> --- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
> @@ -574,7 +574,7 @@ static void test_msr_filter_allow(void) {
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);
>  
> -	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
> +	vm_install_vector_handler(vm, GP_VECTOR, guest_gp_handler);
>  
>  	/* Process guest code userspace exits. */
>  	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
> @@ -588,12 +588,12 @@ static void test_msr_filter_allow(void) {
>  	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
>  	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
>  
> -	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
> +	vm_install_vector_handler(vm, UD_VECTOR, guest_ud_handler);
>  	run_guest(vm);
> -	vm_handle_exception(vm, UD_VECTOR, NULL);
> +	vm_install_vector_handler(vm, UD_VECTOR, NULL);
>  
>  	if (process_ucall(vm) != UCALL_DONE) {
> -		vm_handle_exception(vm, GP_VECTOR, guest_fep_gp_handler);
> +		vm_install_vector_handler(vm, GP_VECTOR, guest_fep_gp_handler);
>  
>  		/* Process emulated rdmsr and wrmsr instructions. */
>  		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
> diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> index 2f964cdc273c..ded70ff465d5 100644
> --- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> @@ -462,7 +462,7 @@ int main(int argc, char *argv[])
>  
>  	vm_init_descriptor_tables(vm);
>  	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
> -	vm_handle_exception(vm, IPI_VECTOR, guest_ipi_handler);
> +	vm_install_vector_handler(vm, IPI_VECTOR, guest_ipi_handler);
>  
>  	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA, 0);
>  
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 617F118FD4C
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgCWTGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:06:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:33352 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727536AbgCWTGy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 15:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584990412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APaNQRxHTARj8BaPbjn67e2tBGbsQUvwirTO/uswCns=;
        b=DIvUTG/ynxPnqrKIQc9HeXrVc/3dl6Q6CMOPRVTDuhblJhhlpojxLWYTjFsAu/jj9Yry8R
        datfo5A9nu9M0SNoXwEhwwFaBnghE6GQSZh573eSqUIVA9SMznVcyGkPxD1uM4njoNOKBl
        L5xTI41n12LQ8NFFcM3lS6d/LowgS38=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-3Yd7ci4UOYCYztJh5W7QJQ-1; Mon, 23 Mar 2020 15:06:41 -0400
X-MC-Unique: 3Yd7ci4UOYCYztJh5W7QJQ-1
Received: by mail-wr1-f72.google.com with SMTP id l17so7435254wro.3
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 12:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=APaNQRxHTARj8BaPbjn67e2tBGbsQUvwirTO/uswCns=;
        b=XLBkn6AMgsWNXEjMLdUvlouFEoZrKbd3z59W9+IlZic0o5DQUHaLYOc3kaelXh/Ib5
         UnMjZcvzHAaghrVsojPi43U+MtWEdagQWL/wyaP+a/jQcTzzGjNu0uEKZfauy+RmqGGs
         EbS24rKnSChwFWReThGzdleajEeJNWUkRba39QRNmwkBfvwdTs9D9zgGaGf1i5j3F57I
         U19SoKmmv8M23/hcpSD7pKtXM1gm4Dkz8GHMEDfk1DK5+8hPC7Qu6fgZmvhXV7DtvynX
         zXEp1RcRAnttPn2WJ+4Z9EMtOhYkIcoomrhOaDimRd7yEm+2owtrz2zySOQN2YfSEpm4
         Ro3g==
X-Gm-Message-State: ANhLgQ0irTyV/zrZUP/l+ABbVdrfvwX8A6Gl/wMR/FE9m41jmQWcf26W
        9RBk3MdY83yD0wj/MixtXbzfsBsNRKtCEgh6Uqpi9ylNhWGM74n7nFTds3DZJqBrb0htxy5fmTM
        RWqQMz0FcbKOi
X-Received: by 2002:a5d:4ac8:: with SMTP id y8mr31386940wrs.272.1584990400701;
        Mon, 23 Mar 2020 12:06:40 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsWEwSE2Xr+j5tv0NNOh61W8hlsYhecrXZL3VhQYuKxOQc/p/2kgcq+l7apJoq1CJ9V3DenmA==
X-Received: by 2002:a5d:4ac8:: with SMTP id y8mr31386901wrs.272.1584990400395;
        Mon, 23 Mar 2020 12:06:40 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id e9sm25072127wrw.30.2020.03.23.12.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 12:06:39 -0700 (PDT)
Date:   Mon, 23 Mar 2020 15:06:36 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 7/7] KVM: selftests: Add "delete" testcase to
 set_memory_region_test
Message-ID: <20200323190636.GM127076@xz-x1>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-8-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320205546.2396-8-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 01:55:46PM -0700, Sean Christopherson wrote:
> Add coverate for running a guest with no memslots, and for deleting
> memslots while the guest is running.  Enhance the test to use, and
> expect, a unique value for MMIO reads, e.g. to verify each stage of
> the test.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  .../kvm/x86_64/set_memory_region_test.c       | 122 ++++++++++++++++--
>  1 file changed, 108 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> index c6691cff4e19..44aed8ac932b 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
> @@ -26,42 +26,109 @@
>  #define MEM_REGION_SIZE		0x200000
>  #define MEM_REGION_SLOT		10
>  
> -static void guest_code(void)
> +static const uint64_t MMIO_VAL = 0xbeefull;
> +
> +extern const uint64_t final_rip_start;
> +extern const uint64_t final_rip_end;
> +
> +static inline uint64_t guest_spin_on_val(uint64_t spin_val)
>  {
>  	uint64_t val;
>  
>  	do {
>  		val = READ_ONCE(*((uint64_t *)MEM_REGION_GPA));
> -	} while (!val);
> +	} while (val == spin_val);
> +	return val;
> +}
>  
> -	if (val != 1)
> -		ucall(UCALL_ABORT, 1, val);
> +static void guest_code(void)
> +{
> +	uint64_t val;
>  
> -	GUEST_DONE();
> +	/*
> +	 * Spin until the memory region is moved to a misaligned address.  This
> +	 * may or may not trigger MMIO, as the window where the memslot is
> +	 * invalid is quite small.
> +	 */
> +	val = guest_spin_on_val(0);
> +	GUEST_ASSERT(val == 1 || val == MMIO_VAL);
> +
> +	/* Spin until the memory region is realigned. */
> +	GUEST_ASSERT(guest_spin_on_val(MMIO_VAL) == 1);

IIUC ideally we should do GUEST_SYNC() after each GUEST_ASSERT() to
make sure the two threads are in sync.  Otherwise e.g. there's no
guarantee that the main thread won't run too fast to quickly remove
the memslot and re-add it back before the guest_spin_on_val() starts
above, then the assert could trigger when it reads the value as zero.

> +
> +	/* Spin until the memory region is deleted. */
> +	GUEST_ASSERT(guest_spin_on_val(1) == MMIO_VAL);
> +
> +	/* Spin until the memory region is recreated. */
> +	GUEST_ASSERT(guest_spin_on_val(MMIO_VAL) == 0);
> +
> +	/* Spin until the memory region is deleted. */
> +	GUEST_ASSERT(guest_spin_on_val(0) == MMIO_VAL);
> +
> +	asm("1:\n\t"
> +	    ".pushsection .rodata\n\t"
> +	    ".global final_rip_start\n\t"
> +	    "final_rip_start: .quad 1b\n\t"
> +	    ".popsection");
> +
> +	/* Spin indefinitely (until the code memslot is deleted). */
> +	guest_spin_on_val(MMIO_VAL);
> +
> +	asm("1:\n\t"
> +	    ".pushsection .rodata\n\t"
> +	    ".global final_rip_end\n\t"
> +	    "final_rip_end: .quad 1b\n\t"
> +	    ".popsection");
> +
> +	GUEST_ASSERT(0);
>  }
>  
>  static void *vcpu_worker(void *data)
>  {
>  	struct kvm_vm *vm = data;
> +	struct kvm_regs regs;
>  	struct kvm_run *run;
>  	struct ucall uc;
> -	uint64_t cmd;
>  
>  	/*
>  	 * Loop until the guest is done.  Re-enter the guest on all MMIO exits,
> -	 * which will occur if the guest attempts to access a memslot while it
> -	 * is being moved.
> +	 * which will occur if the guest attempts to access a memslot after it
> +	 * has been deleted or while it is being moved .
>  	 */
>  	run = vcpu_state(vm, VCPU_ID);
> -	do {
> +
> +	memcpy(run->mmio.data, &MMIO_VAL, 8);
> +	while (1) {
>  		vcpu_run(vm, VCPU_ID);
> -	} while (run->exit_reason == KVM_EXIT_MMIO);
> +		if (run->exit_reason != KVM_EXIT_MMIO)
> +			break;
>  
> -	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +		TEST_ASSERT(!run->mmio.is_write, "Unexpected exit mmio write");
> +		TEST_ASSERT(run->mmio.len == 8,
> +			    "Unexpected exit mmio size = %u", run->mmio.len);
> +
> +		TEST_ASSERT(run->mmio.phys_addr == MEM_REGION_GPA,
> +			    "Unexpected exit mmio address = 0x%llx",
> +			    run->mmio.phys_addr);
> +	}
> +
> +	if (run->exit_reason == KVM_EXIT_IO) {
> +		(void)get_ucall(vm, VCPU_ID, &uc);
> +		TEST_FAIL("%s at %s:%ld",
> +			  (const char *)uc.args[0], __FILE__, uc.args[1]);
> +	}
> +
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN ||
> +		    run->exit_reason == KVM_INTERNAL_ERROR_EMULATION,
>  		    "Unexpected exit reason = %d", run->exit_reason);
>  
> -	cmd = get_ucall(vm, VCPU_ID, &uc);
> -	TEST_ASSERT(cmd == UCALL_DONE, "Unexpected val in guest = %lu", uc.args[0]);
> +	vcpu_regs_get(vm, VCPU_ID, &regs);
> +
> +	TEST_ASSERT(regs.rip >= final_rip_start &&
> +		    regs.rip < final_rip_end,
> +		    "Bad rip, expected 0x%lx - 0x%lx, got 0x%llx\n",
> +		    final_rip_start, final_rip_end, regs.rip);
> +
>  	return NULL;
>  }
>  
> @@ -72,6 +139,13 @@ static void test_move_memory_region(void)
>  	uint64_t *hva;
>  	uint64_t gpa;
>  
> +	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
> +	vm_vcpu_add(vm, VCPU_ID);
> +	/* Fails with ENOSPC because the MMU can't create pages (no slots). */
> +	TEST_ASSERT(_vcpu_run(vm, VCPU_ID) == -1 && errno == ENOSPC,
> +		    "Unexpected error code = %d", errno);
> +	kvm_vm_free(vm);
> +
>  	vm = vm_create_default(VCPU_ID, 0, guest_code);
>  
>  	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> @@ -105,7 +179,6 @@ static void test_move_memory_region(void)
>  	 */
>  	vm_mem_region_move(vm, MEM_REGION_SLOT, MEM_REGION_GPA - 4096);
>  	WRITE_ONCE(*hva, 2);
> -
>  	usleep(100000);
>  
>  	/*
> @@ -116,6 +189,27 @@ static void test_move_memory_region(void)
>  
>  	/* Restore the original base, the guest should see "1". */
>  	vm_mem_region_move(vm, MEM_REGION_SLOT, MEM_REGION_GPA);
> +	usleep(100000);
> +
> +	/* Delete the memory region, the guest should not die. */
> +	vm_mem_region_delete(vm, MEM_REGION_SLOT);
> +	usleep(100000);
> +
> +	/* Recreate the memory region.  The guest should see "0". */
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP,
> +				    MEM_REGION_GPA, MEM_REGION_SLOT,
> +				    MEM_REGION_SIZE / getpagesize(), 0);
> +	usleep(100000);
> +
> +	/* Delete the region again so that there's only one memslot left. */
> +	vm_mem_region_delete(vm, MEM_REGION_SLOT);
> +	usleep(100000);
> +
> +	/*
> +	 * Delete the primary memslot.  This should cause an emulation error or
> +	 * shutdown due to the page tables getting nuked.
> +	 */
> +	vm_mem_region_delete(vm, VM_PRIMARY_MEM_SLOT);
>  
>  	pthread_join(vcpu_thread, NULL);
>  
> -- 
> 2.24.1
> 

-- 
Peter Xu


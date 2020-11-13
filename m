Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB5A2B20A8
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 17:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgKMQmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 11:42:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbgKMQmS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 11:42:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605285736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zvvxVXyjIX2eJdSXRCk44IL0iumUPpGs0fcNEGOV2cM=;
        b=S56dXqKAqjUG3WQSgOZa7ZXv2rLz49ie00szGGTEzCycv3M4jLHR0K2eNGjstm2eXIbTbK
        0d9ePDt8gQ2NoZEyFp/PCUfyhj2DOO6yo9EtxJqxZLHswAhjBDHkwKgxg43+42XDQ6KHRK
        CpXjEA+iZB8tMbT+13lekFvbCSKKSoU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-x9tUmGaXMv-YAMp5G1QU5w-1; Fri, 13 Nov 2020 11:42:15 -0500
X-MC-Unique: x9tUmGaXMv-YAMp5G1QU5w-1
Received: by mail-wm1-f69.google.com with SMTP id j62so2648551wma.4
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 08:42:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zvvxVXyjIX2eJdSXRCk44IL0iumUPpGs0fcNEGOV2cM=;
        b=GEOq/LaeBY/0nGBW485LYpVLutVJfuMyfGVN/6qQcFOxB76SrswIhhclWpZIglq9pS
         +WTdYNDelkDuKhhkfSO4JTQ4F9htpAM2+cj3Xky6NtMwSk3BVKpETInx1NLEtHYz2pJG
         a0pQvPePWDrgMxJJLR9S60B2oyfH7ee2uffhQPbiL40fVV6++ZFTMu3UAlsxtYH5lG8L
         ORNajs6hNPtDvoEq905GBD8A4mfnn6hb3eIHQGkXZ7XdrmXrPbmPx5stSBTBkLP0CPPO
         Rxcxi27Jj7SgqjISugZV2boBtjStGB9VlcXNo4YLiBB6z+uT4wVvsxrWn5e73s57eC+3
         i3mQ==
X-Gm-Message-State: AOAM5302I4eEfy7TBg/eNMv7UjKw289dHhEq0XDpviG4q92tRKIJF0D4
        ggahtqWiL66FEMkYoiKkj28CXec693zarWRF3S4yAMxYQVs18VMz/DLUwPBF7VbbAmd5FgctAyh
        B/3pzE46s/WtU
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr4606635wrx.59.1605285728803;
        Fri, 13 Nov 2020 08:42:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz10oycC8puBQI1QGnBTreDK7VTSJduLIIbz2lFtfHyIeeLfngPchj8I/uQYXFyynI3PnHujw==
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr4606220wrx.59.1605285723669;
        Fri, 13 Nov 2020 08:42:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p3sm5435093wrs.50.2020.11.13.08.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 08:42:02 -0800 (PST)
Subject: Re: [PATCH v2 06/11] KVM: selftests: dirty_log_test: Remove create_vm
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, bgardon@google.com,
        peterx@redhat.com
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-7-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5a580018-21ea-1222-b3aa-a6de284596ea@redhat.com>
Date:   Fri, 13 Nov 2020 17:42:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201111122636.73346-7-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/20 13:26, Andrew Jones wrote:
> Use vm_create_with_vcpus instead of create_vm and do
> some minor cleanups around it.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   tools/testing/selftests/kvm/dirty_log_test.c | 56 ++++++--------------
>   1 file changed, 16 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 1b7375d2acea..2e0dcd453ef0 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -5,8 +5,6 @@
>    * Copyright (C) 2018, Red Hat, Inc.
>    */
>   
> -#define _GNU_SOURCE /* for program_invocation_name */
> -
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <pthread.h>
> @@ -20,6 +18,9 @@
>   
>   #define VCPU_ID				1
>   
> +#define DIRTY_MEM_BITS			30 /* 1G */
> +#define DIRTY_MEM_SIZE			(1UL << 30)
> +
>   /* The memory slot index to track dirty pages */
>   #define TEST_MEM_SLOT_INDEX		1
>   
> @@ -353,27 +354,6 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
>   	}
>   }
>   
> -static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
> -				uint64_t extra_mem_pages, void *guest_code)
> -{
> -	struct kvm_vm *vm;
> -	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
> -
> -	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> -
> -	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
> -	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
> -#ifdef __x86_64__
> -	vm_create_irqchip(vm);
> -#endif
> -	log_mode_create_vm_done(vm);
> -	vm_vcpu_add_default(vm, vcpuid, guest_code);
> -	return vm;
> -}
> -
> -#define DIRTY_MEM_BITS 30 /* 1G */
> -#define PAGE_SHIFT_4K  12
> -
>   struct test_params {
>   	unsigned long iterations;
>   	unsigned long interval;
> @@ -393,43 +373,39 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   		return;
>   	}
>   
> +	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> +
>   	/*
>   	 * We reserve page table for 2 times of extra dirty mem which
> -	 * will definitely cover the original (1G+) test range.  Here
> -	 * we do the calculation with 4K page size which is the
> -	 * smallest so the page number will be enough for all archs
> -	 * (e.g., 64K page size guest will need even less memory for
> -	 * page tables).
> +	 * will definitely cover the original (1G+) test range.
>   	 */
> -	vm = create_vm(mode, VCPU_ID,
> -		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
> -		       guest_code);
> +	vm = vm_create_with_vcpus(mode, 1,
> +			vm_calc_num_guest_pages(mode, DIRTY_MEM_SIZE * 2),
> +			0, guest_code, (uint32_t []){ VCPU_ID });
> +
> +	log_mode_create_vm_done(vm);
>   
>   	guest_page_size = vm_get_page_size(vm);
> +	host_page_size = getpagesize();
> +
>   	/*
>   	 * A little more than 1G of guest page sized pages.  Cover the
>   	 * case where the size is not aligned to 64 pages.
>   	 */
> -	guest_num_pages = (1ul << (DIRTY_MEM_BITS -
> -				   vm_get_page_shift(vm))) + 3;
> -	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> -
> -	host_page_size = getpagesize();
> +	guest_num_pages = vm_adjust_num_guest_pages(mode,
> +				(1ul << (DIRTY_MEM_BITS - vm_get_page_shift(vm))) + 3);
>   	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>   
>   	if (!p->phys_offset) {
> -		guest_test_phys_mem = (vm_get_max_gfn(vm) -
> -				       guest_num_pages) * guest_page_size;
> +		guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) * guest_page_size;
>   		guest_test_phys_mem &= ~(host_page_size - 1);
>   	} else {
>   		guest_test_phys_mem = p->phys_offset;
>   	}
> -
>   #ifdef __s390x__
>   	/* Align to 1M (segment size) */
>   	guest_test_phys_mem &= ~((1 << 20) - 1);
>   #endif
> -
>   	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
>   
>   	bmap = bitmap_alloc(host_num_pages);
> 

This one (even after fixing conflicts) breaks the dirty ring test.

Paolo


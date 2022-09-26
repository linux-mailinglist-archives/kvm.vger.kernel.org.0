Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C5B5EB479
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 00:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiIZWVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 18:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiIZWVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 18:21:01 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53F5BC2
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:20:58 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id f23so7491012plr.6
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=q0d0JcJxo5RXSo0jSn0YKfBLhRe58BO7fShjoEBS1Ks=;
        b=drFyRqv79+aAFp3YKkcEAtyvNvamGSby2hV3WgIar0+plycDgOjym1ov70Q+AP3rSj
         pHK2QSF9lzHcoeGnPjCZRLbrVEGP56J8gxDkEQ8N5YcKSvk14hHefc4sfotesQ1YfLCh
         9PrT/gWEtnB/rP0JnA+eFXt97tM7aCrzA7LnHaJxBATMA2WjkfWaEc1pSOFHLyFtBzNa
         /0unVt8Jdd79NHF27YCvO56q8xF7gAXJqxWruAjjal/l8JUC5l8awZxRaClJNmjB2JaI
         Y8RqbaW0/OwOhhTqukco+YZ9/uVlyUqiqqFg6JmO04gXmQODu1M1edFNBFuAFeBCLrpz
         2fww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=q0d0JcJxo5RXSo0jSn0YKfBLhRe58BO7fShjoEBS1Ks=;
        b=ECUVUFn6HpZ6FSsVw6FaTrrkt6vMrfY853NlmHTCwEp5C+dsRj5s01fZUay+HJ/pQ3
         YTrMhpxVW2Agm9LQckyP6RlsG/oEom29O9qzUdlm/5fGEN+jbNkVynvRxL76BD9IgMJa
         8szfGGGK90GFSTL/OyXmtAlRefKvTmLCgM5xRqMDXnv0RK+Y7DRfJOEAuyKspoUFGglA
         lzu6XJnNbk7BU4pqrl5SEh0IWr/lX6BXFDFPcGTVBPZEknnXmN/ZF4djmQXeFVt6xMdV
         zcz3MhCy9ROBnNIM/M7QRkgeV53kikMaegy18YLeqrQRJAHF9x0dIW1ZwwpIoH7a+IHZ
         e+PA==
X-Gm-Message-State: ACrzQf2h9J1mUyzyXESveCju8Ym20lnDQkaoj/qzYdINJ7I10AgZzIQb
        1j5gvgnzrJ13A8lduuizr/NgWQ==
X-Google-Smtp-Source: AMsMyM6Vp57gjSMhGV468fQd2F4bdER4HWvrg1QRTzE92nU6ZjNYp3SC+OOu4oMXAcMw2GqENdEiQA==
X-Received: by 2002:a17:90b:1809:b0:205:ccba:45a9 with SMTP id lw9-20020a17090b180900b00205ccba45a9mr979740pjb.98.1664230858310;
        Mon, 26 Sep 2022 15:20:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 23-20020a17090a199700b001f2fa09786asm7117883pji.19.2022.09.26.15.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:20:57 -0700 (PDT)
Date:   Mon, 26 Sep 2022 22:20:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Fix nx_huge_pages_test on TDP-disabled
 hosts
Message-ID: <YzIlxmMOeSZHsnOu@google.com>
References: <20220926175219.605113-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926175219.605113-1-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022, David Matlack wrote:
> +void virt_map_2m(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> +		 uint64_t nr_2m_pages)

Gah, the selftest APIs are so frustrating.  Taking the number of pages in virt_map()
and vm_userspace_mem_region_add() is asinine.  Tests either assume a specific page
size, e.g. x86 tests, or manually calculate the number of pages from the number of
bytes, only for those calculations to be reversed.  E.g. set_memory_region_test's
usage of getpagesize().

As a baby step toward providing sane APIs and being able to create huge mappings
in common tests, what about refactoring virt_map() to take the size in bytes (see
below), and then assert in arch code that the page size matches vm->page_size,
except for x86, which translates back to its page "levels".

Then max_guest_memory_test can use virt_map() and __virt_map(), and we could even
delete vm_calc_num_guest_pages().  aarch64's usage in steal_time_init() can be
hardcoded to a single page, the size of the allocation is hardcoded to 64 bytes,
I see no reason to dance around that and pretend that page sizes can be smaller
than 64 bytes.

Then for proper support, we can figure out how to enumerate the allowed page sizes
in the guest for use in common tests.

And in parallel, we can cajole someone into refactoring vm_userspace_mem_region_add()
to take the size in bytes.

E.g.

void __virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
		uint64_t nr_bytes, size_t page_size)
{
	uint64_t nr_pages = DIV_ROUND_UP(nr_bytes, page_size);

	TEST_ASSERT(vaddr + size > vaddr, "Vaddr overflow");
	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");

	while (npages--) {
		virt_pg_map(vm, vaddr, paddr);
		vaddr += page_size;
		paddr += page_size;
	}
}

void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
	      uint64_t nr_bytes)
{
	__virt_map(vm, vaddr, paddr, nr_bytes, vm->page_size);
}

and in max_guest_memory_test:

#ifdef __x86_64__
		/* TODO: use huge pages for other architectures. */
		__virt_map(vm, gpa, gpa, slot_size, PG_SIZE_1G);
#else
		virt_map(vm, gpa, gpa, slot_size);
#endif

> +{
> +	int i;
> +
> +	for (i = 0; i < nr_2m_pages; i++) {
> +		__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_2M);
> +
> +		vaddr += PG_SIZE_2M;
> +		paddr += PG_SIZE_2M;
> +	}
> +}
> +
>  static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
>  					  struct kvm_vcpu *vcpu,
>  					  uint64_t vaddr)
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index cc6421716400..a850769692b7 100644
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -22,7 +22,8 @@
>  #define HPAGE_GPA		(4UL << 30) /* 4G prevents collision w/ slot 0 */
>  #define HPAGE_GVA		HPAGE_GPA /* GVA is arbitrary, so use GPA. */
>  #define PAGES_PER_2MB_HUGE_PAGE 512
> -#define HPAGE_SLOT_NPAGES	(3 * PAGES_PER_2MB_HUGE_PAGE)
> +#define HPAGE_SLOT_2MB_PAGES	3
> +#define HPAGE_SLOT_NPAGES	(HPAGE_SLOT_2MB_PAGES * PAGES_PER_2MB_HUGE_PAGE)
>  
>  /*
>   * Passed by nx_huge_pages_test.sh to provide an easy warning if this test is
> @@ -141,7 +142,11 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
>  				    HPAGE_GPA, HPAGE_SLOT,
>  				    HPAGE_SLOT_NPAGES, 0);
>  
> -	virt_map(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_NPAGES);
> +	/*
> +	 * Use 2MiB virtual mappings so that KVM can map the region with huge
> +	 * pages even if TDP is disabled.
> +	 */
> +	virt_map_2m(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_2MB_PAGES);

Hmm, what about probing TDP support and deliberately using 4KiB pages when TDP is
enabled?  That would give a bit of bonus coverage by verifying that KVM creates
huge pages irrespective of guest mapping level.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C40C57C1DF
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 03:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiGUB3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 21:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGUB3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 21:29:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AA576467
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 18:29:39 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p8so390299plq.13
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 18:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5i7pD9uxt5RO2G3WkfWU+AZkFUM1gKsxzTq2h03Rwm8=;
        b=UeKlj77E4BCKTx4d0a+/5nPInsQYeGAlr99yHD+tb9CgkaZP6cqHzjrIJ3sCjYI9/2
         flpAT5PTfRw0AbNAJcfgs4a5j6TlGOPj+D//HskpzTdLV1i/l3DsBtGAuFF1bw6g2zhh
         t8yp9Vksu4sOXTv42OF/tMYx0jEUJ/dkGNtE38dbyCtT4Wkhr1Xc/X3P+w/BwDojT8Wn
         6+sMCdYwZ5jSzLWJIz9+PswFtFUVQ0gb+eispCeQNyBgJDAr3/EEANSE+52qxVtHf3Hn
         6ZDYzIZODyYTh+kute1q9+WjGVmFX34l0ZQ7IMY2u/7fnlt82h7dVuI95qATVy13/e2Z
         Hz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5i7pD9uxt5RO2G3WkfWU+AZkFUM1gKsxzTq2h03Rwm8=;
        b=6rAq0wBf81caDHqZ3isV7UhSjOdGrXNDK0QUQGz+RVpO9F78f2WrV2ISWyECEHIzoa
         LHwgkZx0OBbG7gwhGuSv08rrYle3GuMInoitnji30fIjiIxWWLMPmHdz+0HIHG9l0rvC
         ZI9dx1JomdyrZvr61Uw1EHBJlKnCEZInx/J3R9C4+AWEOdNzfqJBCXkBc1Jtrmxb7U42
         prg3sgwlAEGoipd1APCjMp7038+YR0+n8nMmyt7nIci8abRC0hhB0EDAWnnwrSWZbzkN
         fTiGOg8cvNHZwQ8bz+AG5grq4dTCy+9wc8UHXjvh5tV/V4dpmrCQGfaF4GEQ7O66L1Rc
         Iw4A==
X-Gm-Message-State: AJIora+px0sy0BGLbhHj5IObkt3g8/VL4iPjanoFRn8f4PKqQAFJOlb4
        RSUvneA3fexvGVy3g9lR9Tg2JA==
X-Google-Smtp-Source: AGRyM1tJ8ImKxlP/BBnxd82Ef5VdSnGALxojQY8p0KS3YXSkLBe8Jd9Fqs/mrjinEPSYxm1dK3lNGg==
X-Received: by 2002:a17:90a:db0b:b0:1f2:25c3:9faf with SMTP id g11-20020a17090adb0b00b001f225c39fafmr3991006pjv.105.1658366978689;
        Wed, 20 Jul 2022 18:29:38 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902e5cf00b0016c40f8cb58sm215888plf.81.2022.07.20.18.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 18:29:38 -0700 (PDT)
Date:   Thu, 21 Jul 2022 01:29:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, bgardon@google.com,
        dmatlack@google.com, pbonzini@redhat.com, axelrasmussen@google.com
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <Ytir/hbU9neBaYqb@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-10-ricarkol@google.com>
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

On Fri, Jun 24, 2022, Ricardo Koller wrote:
> Add a new test for stage 2 faults when using different combinations of
> guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
> and types of faults (e.g., read on hugetlbfs with a hole). The next
> commits will add different handling methods and more faults (e.g., uffd
> and dirty logging). This first commit starts by adding two sanity checks
> for all types of accesses: AF setting by the hw, and accessing memslots
> with holes.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---

...

> +/*
> + * Create a memslot for test data (memslot[TEST]) and another one for PT
> + * tables (memslot[PT]). This diagram show the resulting guest virtual and
> + * physical address space when using 4K backing pages for the memslots, and
> + * 4K guest pages.
> + *
> + *                   Guest physical            Guest virtual
> + *
> + *                  |              |          |             |
> + *                  |              |          |             |
> + *                  +--------------+          +-------------+
> + * max_gfn - 0x1000 | TEST memslot |<---------+  test data  | 0xc0000000
> + *                  +--------------+          +-------------+
> + * max_gfn - 0x2000 |     gap      |<---------+     gap     | 0xbffff000
> + *                  +--------------+          +-------------+
> + *                  |              |          |             |
> + *                  |              |          |             |
> + *                  |  PT memslot  |          |             |
> + *                  |              |          +-------------+
> + * max_gfn - 0x6000 |              |<----+    |             |
> + *                  +--------------+     |    |             |
> + *                  |              |     |    | PTE for the |
> + *                  |              |     |    | test data   |
> + *                  |              |     +----+ page        | 0xb0000000
> + *                  |              |          +-------------+
> + *                  |              |          |             |
> + *                  |              |          |             |
> + *
> + * Using different guest page sizes or backing pages will result in the
> + * same layout but at different addresses. In particular, the memslot
> + * sizes need to be multiple of the backing page sizes (e.g., 2MB).
> + */
> +static void setup_memslots(struct kvm_vm *vm, enum vm_guest_mode mode,
> +		struct test_params *p)
> +{
> +	uint64_t backing_page_size = get_backing_src_pagesz(p->src_type);
> +	uint64_t guest_page_size = vm_guest_mode_params[mode].page_size;
> +	struct test_desc *test = p->test_desc;
> +	uint64_t gap_gpa;
> +	uint64_t alignment;
> +	int i;
> +
> +	memslot[TEST].size = align_up(guest_page_size, backing_page_size);
> +	/*
> +	 * We need one guest page for the PT table containing the PTE (for
> +	 * TEST_GVA), but might need more in case the higher level PT tables
> +	 * were not allocated yet.
> +	 */
> +	memslot[PT].size = align_up(4 * guest_page_size, backing_page_size);
> +
> +	for (i = 0; i < NR_MEMSLOTS; i++) {
> +		memslot[i].guest_pages = memslot[i].size / guest_page_size;
> +		memslot[i].src_type = p->src_type;
> +	}
> +
> +	/* Place the memslots GPAs at the end of physical memory */
> +	alignment = max(backing_page_size, guest_page_size);
> +	memslot[TEST].gpa = (vm->max_gfn - memslot[TEST].guest_pages) *
> +		guest_page_size;
> +	memslot[TEST].gpa = align_down(memslot[TEST].gpa, alignment);
> +
> +	/* Add a 1-guest_page gap between the two memslots */
> +	gap_gpa = memslot[TEST].gpa - guest_page_size;
> +	/* Map the gap so it's still adressable from the guest.  */
> +	virt_pg_map(vm, TEST_GVA - guest_page_size, gap_gpa);
> +
> +	memslot[PT].gpa = gap_gpa - memslot[PT].size;
> +	memslot[PT].gpa = align_down(memslot[PT].gpa, alignment);
> +
> +	vm_userspace_mem_region_add(vm, p->src_type, memslot[PT].gpa,
> +			memslot[PT].idx, memslot[PT].guest_pages,
> +			test->pt_memslot_flags);
> +	vm_userspace_mem_region_add(vm, p->src_type, memslot[TEST].gpa,
> +			memslot[TEST].idx, memslot[TEST].guest_pages,
> +			test->test_memslot_flags);
> +
> +	for (i = 0; i < NR_MEMSLOTS; i++)
> +		memslot[i].hva = addr_gpa2hva(vm, memslot[i].gpa);
> +
> +	/* Map the test TEST_GVA using the PT memslot. */
> +	_virt_pg_map(vm, TEST_GVA, memslot[TEST].gpa, MT_NORMAL,
> +			TEST_PT_SLOT_INDEX);

Use memslot[TEST].idx instead of TEST_PT_SLOT_INDEX to be consistent, though my
preference would be to avoid this API.

IIUC, the goal is to test different backing stores for the memory the guest uses
for it's page tables.  But do we care about testing that a single guest's page
tables are backed with different types concurrently?  If we don't care, and maybe
even if we do, then my preference would be to enhance the __vm_create family of
helpers to allow for specifying what backing type should be used for page tables,
i.e. associate the info the VM instead of passing it around the stack.

One idea would be to do something like David Matlack suggested a while back and
replace extra_mem_pages with a struct, e.g. struct kvm_vm_mem_params  That struct
can then provide the necessary knobs to control how memory is allocated.  And then
the lib can provide a global

	struct kvm_vm_mem_params kvm_default_vm_mem_params;

or whatever (probably a shorter name) for the tests that don't care.  And then
down the road, if someone wants to control the backing type for code vs. data,
we could and those flags to kvm_vm_mem_params and add vm_vaddr_alloc() wrappers
to alloc code vs. data (with a default to data?).

I don't like the param approach because it bleeds implementation details that
really shouldn't matter, e.g. which memslot is the default, into tests.  And it's
not very easy to use, e.g. if a different test wants to do something similar,
it would have to create its own memslot, populate the tables, etc...

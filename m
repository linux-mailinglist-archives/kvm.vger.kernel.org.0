Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2167657E545
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbiGVRTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 13:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiGVRTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 13:19:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038297AB2E
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 10:19:11 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y9so4956252pff.12
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 10:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ZWf1JV0uz/pnulu9uf2lSX3vgqaBVoGX5nLFqa8kn0=;
        b=lSneEgqTzS1psSNcm3ygJBoHk4PDffr7W26qJwy2bJuJEx/zm16oAZheUwF4xx5Jlo
         AXrQhzkrICd1Wc8V7lIGGvVVAYOaoGft27rm9J0uo2/6bSHw0pmhbMeGzONg3ksA/Ygf
         4D8YPZlvb/3SHhFGD3tc37hpwDK9wAHaREGZJD+JnWC+0TDDtEE5UtpbSeCPNIut/Bwk
         Y19YZMxXPbxZiXKRFFjDqRz6TOyBf+lyUah0r4hw3+pU+GOEZHU3k5gYyiwBTByuQlc+
         H4S2GI1CRJg8ESVmIhiPbC2n3yR2cVZsjRdI9uSDJTmJfLL4xst+r8TlvRSnGpjXP6g1
         o0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ZWf1JV0uz/pnulu9uf2lSX3vgqaBVoGX5nLFqa8kn0=;
        b=KrqepRKLjWq9q0JjAhf058OVvXs9SZE8NjZUak21uvTWSVsWgiFfOFftiBJyissSE0
         2IIo+VF6YXD/EMkWPPsuyMVvYAn3ZWiOsofDn93oPvW8kGAhgLorSFCQEvmAVSBBBVKf
         ruDBKpRfNebsIAj3RUyRPnTxrX3+ezzySXtu1SOe3U70oPQq+zglsp6nckPJJ0hOd9op
         JmX7R+H4v50nm9VVXUEiteQcda8VFnVs+LBqz55BtYatj1lA+YGzOJLRsEAoMzZ+BOso
         gOgON1izOWrnyfQX9GJw4OuGviwUkkxzuguBBqArrdFC9TOQBf+TuZRlsQjkBF7KmWom
         IFfw==
X-Gm-Message-State: AJIora+Kr+hKUl2NYOj6+O70n86Aj+G6w3W4N2oa7MoNdzLaeSYpmg7z
        dKxH9d+Iyf0tpvU5Yo4jN9SRvA==
X-Google-Smtp-Source: AGRyM1tQoJON21HQIbt0Q2cvJJDvV6WyXRnzvGb0EvoAi1FvYtwkO8VFBnp2CiNzyPVnybOHhhEa2A==
X-Received: by 2002:a63:d809:0:b0:415:5265:687c with SMTP id b9-20020a63d809000000b004155265687cmr700711pgh.372.1658510350054;
        Fri, 22 Jul 2022 10:19:10 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id p16-20020a170902e75000b0016b90620910sm4074351plf.71.2022.07.22.10.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 10:19:09 -0700 (PDT)
Date:   Fri, 22 Jul 2022 10:19:05 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, bgardon@google.com,
        dmatlack@google.com, pbonzini@redhat.com, axelrasmussen@google.com
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YtrcCeHqBcwy+Mf6@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
 <Ytir/hbU9neBaYqb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytir/hbU9neBaYqb@google.com>
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

On Thu, Jul 21, 2022 at 01:29:34AM +0000, Sean Christopherson wrote:
> On Fri, Jun 24, 2022, Ricardo Koller wrote:
> > Add a new test for stage 2 faults when using different combinations of
> > guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
> > and types of faults (e.g., read on hugetlbfs with a hole). The next
> > commits will add different handling methods and more faults (e.g., uffd
> > and dirty logging). This first commit starts by adding two sanity checks
> > for all types of accesses: AF setting by the hw, and accessing memslots
> > with holes.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> 
> ...
> 
> > +/*
> > + * Create a memslot for test data (memslot[TEST]) and another one for PT
> > + * tables (memslot[PT]). This diagram show the resulting guest virtual and
> > + * physical address space when using 4K backing pages for the memslots, and
> > + * 4K guest pages.
> > + *
> > + *                   Guest physical            Guest virtual
> > + *
> > + *                  |              |          |             |
> > + *                  |              |          |             |
> > + *                  +--------------+          +-------------+
> > + * max_gfn - 0x1000 | TEST memslot |<---------+  test data  | 0xc0000000
> > + *                  +--------------+          +-------------+
> > + * max_gfn - 0x2000 |     gap      |<---------+     gap     | 0xbffff000
> > + *                  +--------------+          +-------------+
> > + *                  |              |          |             |
> > + *                  |              |          |             |
> > + *                  |  PT memslot  |          |             |
> > + *                  |              |          +-------------+
> > + * max_gfn - 0x6000 |              |<----+    |             |
> > + *                  +--------------+     |    |             |
> > + *                  |              |     |    | PTE for the |
> > + *                  |              |     |    | test data   |
> > + *                  |              |     +----+ page        | 0xb0000000
> > + *                  |              |          +-------------+
> > + *                  |              |          |             |
> > + *                  |              |          |             |
> > + *
> > + * Using different guest page sizes or backing pages will result in the
> > + * same layout but at different addresses. In particular, the memslot
> > + * sizes need to be multiple of the backing page sizes (e.g., 2MB).
> > + */
> > +static void setup_memslots(struct kvm_vm *vm, enum vm_guest_mode mode,
> > +		struct test_params *p)
> > +{
> > +	uint64_t backing_page_size = get_backing_src_pagesz(p->src_type);
> > +	uint64_t guest_page_size = vm_guest_mode_params[mode].page_size;
> > +	struct test_desc *test = p->test_desc;
> > +	uint64_t gap_gpa;
> > +	uint64_t alignment;
> > +	int i;
> > +
> > +	memslot[TEST].size = align_up(guest_page_size, backing_page_size);
> > +	/*
> > +	 * We need one guest page for the PT table containing the PTE (for
> > +	 * TEST_GVA), but might need more in case the higher level PT tables
> > +	 * were not allocated yet.
> > +	 */
> > +	memslot[PT].size = align_up(4 * guest_page_size, backing_page_size);
> > +
> > +	for (i = 0; i < NR_MEMSLOTS; i++) {
> > +		memslot[i].guest_pages = memslot[i].size / guest_page_size;
> > +		memslot[i].src_type = p->src_type;
> > +	}
> > +
> > +	/* Place the memslots GPAs at the end of physical memory */
> > +	alignment = max(backing_page_size, guest_page_size);
> > +	memslot[TEST].gpa = (vm->max_gfn - memslot[TEST].guest_pages) *
> > +		guest_page_size;
> > +	memslot[TEST].gpa = align_down(memslot[TEST].gpa, alignment);
> > +
> > +	/* Add a 1-guest_page gap between the two memslots */
> > +	gap_gpa = memslot[TEST].gpa - guest_page_size;
> > +	/* Map the gap so it's still adressable from the guest.  */
> > +	virt_pg_map(vm, TEST_GVA - guest_page_size, gap_gpa);
> > +
> > +	memslot[PT].gpa = gap_gpa - memslot[PT].size;
> > +	memslot[PT].gpa = align_down(memslot[PT].gpa, alignment);
> > +
> > +	vm_userspace_mem_region_add(vm, p->src_type, memslot[PT].gpa,
> > +			memslot[PT].idx, memslot[PT].guest_pages,
> > +			test->pt_memslot_flags);
> > +	vm_userspace_mem_region_add(vm, p->src_type, memslot[TEST].gpa,
> > +			memslot[TEST].idx, memslot[TEST].guest_pages,
> > +			test->test_memslot_flags);
> > +
> > +	for (i = 0; i < NR_MEMSLOTS; i++)
> > +		memslot[i].hva = addr_gpa2hva(vm, memslot[i].gpa);
> > +
> > +	/* Map the test TEST_GVA using the PT memslot. */
> > +	_virt_pg_map(vm, TEST_GVA, memslot[TEST].gpa, MT_NORMAL,
> > +			TEST_PT_SLOT_INDEX);
> 
> Use memslot[TEST].idx instead of TEST_PT_SLOT_INDEX to be consistent, though my
> preference would be to avoid this API.
> 
> IIUC, the goal is to test different backing stores for the memory the guest uses
> for it's page tables.  But do we care about testing that a single guest's page
> tables are backed with different types concurrently?

This test creates a new VM for each subtest, so an API like that would
definitely make this code simpler/nicer.

> If we don't care, and maybe
> even if we do, then my preference would be to enhance the __vm_create family of
> helpers to allow for specifying what backing type should be used for page tables,
> i.e. associate the info the VM instead of passing it around the stack.
> 
> One idea would be to do something like David Matlack suggested a while back and
> replace extra_mem_pages with a struct, e.g. struct kvm_vm_mem_params  That struct
> can then provide the necessary knobs to control how memory is allocated.  And then
> the lib can provide a global
> 
> 	struct kvm_vm_mem_params kvm_default_vm_mem_params;
> 

I like this idea, passing the info at vm creation.

What about dividing the changes in two.

	1. Will add the struct to "__vm_create()" as part of this
	series, and then use it in this commit. There's only one user

		dirty_log_test.c:   vm = __vm_create(mode, 1, extra_mem_pages);

	so that would avoid having to touch every test as part of this patchset.

	2. I can then send another series to add support for all the other
	vm_create() functions.

Alternatively, I can send a new series that does 1 and 2 afterwards.
WDYT?

> or whatever (probably a shorter name) for the tests that don't care.  And then
> down the road, if someone wants to control the backing type for code vs. data,
> we could and those flags to kvm_vm_mem_params and add vm_vaddr_alloc() wrappers
> to alloc code vs. data (with a default to data?).
> 
> I don't like the param approach because it bleeds implementation details that
> really shouldn't matter, e.g. which memslot is the default, into tests.  And it's
> not very easy to use, e.g. if a different test wants to do something similar,
> it would have to create its own memslot, populate the tables, etc...

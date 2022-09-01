Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1841B5A9EE8
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 20:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbiIAS2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 14:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiIAS21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 14:28:27 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B496E7CB7E
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 11:28:25 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q15so12886591pfn.11
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 11:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ndIldFWnVpsGGglHDvm5sbA1GFSZXj+Lb11rFvaAIxc=;
        b=O4paYpiLTVY0VgAIqU37vnsePtMIHdV8Tdht1kbOh9nj3tZOaxPN+eNKX2uD8EkrXS
         qRdtD+RFHo/m/EFVRGfobsca709lx9J+abTaGCSNgenTSXVIWGJjxXlsjZL0qfydqxfc
         NZAHhYe8cokYcGUZTUeuSv00yXUl8aUP6+FqzPYLkxBu++iQIEkl/1E303qGRnzVCHji
         sGtrPr4XZh0dNPdsXe2bmhBfTkyvF1Wla7lJ0cmhFTtmsjL+8Y2Q4vbgdI94tWpDihTm
         Vh174PI59JxYmvNgz0QiMXVS79uBrI1Kw4mCy9HHN2/doa1FZ8Ijf86Udrh8ZH4akeae
         8+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ndIldFWnVpsGGglHDvm5sbA1GFSZXj+Lb11rFvaAIxc=;
        b=uUYMVrL7VWxCD1r0CBTWrA/TT3cL9xsA62IjDqLoPDGiPo9QyjE8VBQXlKJyBlihr2
         tZbEJ7/zERD3hSTuCiOSEzeS6LDB+MA3jYHlDDJQVuqLuwPxnta1AagtU+ygnW+TWkyO
         Oknj/Ft69ab1T9194eU6hoff+MCWko8MSpT4TSDcZUQJuzhFS9S1NXmbg5rH1E92s2jM
         ivsxc5YVDEbMMmnizGadxWZTbFRaxcYdQW0nwSLjgPVx2QdM4IOf7YASSdJgkLMXn2YC
         M+MtVN1a4zoEIAMLrE6AaNSwn2Li7rSlDiauk9xOjkjdlrIKf5km3NrshXAqEWBqyYBz
         ltFA==
X-Gm-Message-State: ACgBeo2KnjjFpzR5GEv6vss0mVg/UmEQRzS5Zkm7SAaLYb73RTDD8Cmo
        c6/P7jdOjnQ3yqIgV/GUosnrsKbc/lMGTg==
X-Google-Smtp-Source: AA6agR6Iqqu2gbxjfzpo94RaERqt3s4eH3fhv4y8aOOlDwv+8rGWsd0X6aJxjFxvfeLoOIPEAPaYZg==
X-Received: by 2002:a05:6a00:170c:b0:537:27b4:ebfe with SMTP id h12-20020a056a00170c00b0053727b4ebfemr32335453pfc.19.1662056905019;
        Thu, 01 Sep 2022 11:28:25 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902dccb00b001755f43bc22sm1825756pll.175.2022.09.01.11.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 11:28:24 -0700 (PDT)
Date:   Thu, 1 Sep 2022 11:28:20 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v5 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
Message-ID: <YxD5xIMaU8Qxw68O@google.com>
References: <20220823234727.621535-1-ricarkol@google.com>
 <20220823234727.621535-8-ricarkol@google.com>
 <20220829172508.oc3rr44q2irwudi5@kamzik>
 <Yw6JAiIfenYafJnZ@google.com>
 <Yw6T591G5hGTBx2t@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw6T591G5hGTBx2t@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 10:49:11PM +0000, Sean Christopherson wrote:
> On Tue, Aug 30, 2022, Ricardo Koller wrote:
> > On Mon, Aug 29, 2022 at 07:25:08PM +0200, Andrew Jones wrote:
> > > On Tue, Aug 23, 2022 at 11:47:21PM +0000, Ricardo Koller wrote:
> > > I feel we'll be revisiting this frequently when more and more region types
> > > are desired. For example, Sean wants a read-only memory region for ucall
> > > exits. How about putting a mem slot array in struct kvm_vm, defining an
> > > enum to index it (which will expand), and then single helper function,
> > > something like
> > > 
> > >  inline struct userspace_mem_region *
> > >  vm_get_mem_region(struct kvm_vm *vm, enum memslot_type mst)
> > >  {
> > >     return memslot2region(vm, vm->memslots[mst]);
> > >  }
> 
> 
> > > 
> > > > +
> > > >  /* Minimum allocated guest virtual and physical addresses */
> > > >  #define KVM_UTIL_MIN_VADDR		0x2000
> > > >  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> > > > @@ -637,19 +662,51 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> > > >  			      vm_paddr_t paddr_min, uint32_t memslot);
> > > >  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> > > >  
> > > > +#define MEM_PARAMS_MAX_MEMSLOTS 3
> > > 
> > > And this becomes MEMSLOT_MAX of the enum proposed above
> > > 
> > >  enum memslot_type {
> > >      MEMSLOT_CODE,
> > >      MEMSLOT_PT,
> > >      MEMSLOT_DATA,
> 
> "memslot" is going to be confusing, e.g. MEMSLOT_MAX is some arbitrary selftests
> constant that has no relationship to maximum number of memslots.
> 
> > >      MEMSLOT_MAX,
> 
> I dislike "max" because it's ambiguous, e.g. is it the maximum number of regions,
> or is the max valid region?
> 
> Maybe something like this?
> 
> 	enum kvm_mem_region_type {
> 		MEM_REGION_CODE
> 		...
> 		NR_MEM_REGIONS,
> 	}
> 
> > > > +#else
> > > > +	.mode = VM_MODE_DEFAULT,
> > > > +#endif
> > > > +	.region[0] = {
> > > > +		.src_type = VM_MEM_SRC_ANONYMOUS,
> > > > +		.guest_paddr = 0,
> > > > +		.slot = 0,
> > > > +		/*
> > > > +		 * 4mb when page size is 4kb. Note that vm_nr_pages_required(),
> > > > +		 * the function used by most tests to calculate guest memory
> > > > +		 * requirements uses around ~520 pages for more tests.
> > > 
> > > ...requirements, currently returns ~520 pages for the majority of tests.
> > > 
> > > > +		 */
> > > > +		.npages = 1024,
> > > 
> > > And here we double it, but it's still fragile. I see we override this
> > > in __vm_create() below though, so now I wonder why we set it at all.
> > > 
> > 
> > I would prefer having a default that can be used by a test as-is. WDYT?
> > or should we make it explicit that the default needs some updates?
> 
> In that case, the default should be '0'.  There are two users of ____vm_create().
> __vm_create() takes the number of "extra" pages and calculates the "base" number
> of pages.  vm_create_barebones() passes '0', i.e. can use default.
> 
> If '0' as a default is too weird, make it an illegal value and force the caller
> to define the number of pages.

Sounds good, will try '0', and will make sure that not defining the
number of pages results in a clear error.

> 
> It's not a coincidence that those are the only two callers, ____vm_create() isn't
> intended to be used directly.  If a test wants to create a VM just to create a VM,
> then it shoulid use vm_create_barebones().  If a test wants to doing anything
> remotely useful with the VM, it should use __vm_create() or something higher up
> the food chain.

Thank you both for the reviews. I think this is ready for a v6, so
sending one soon.

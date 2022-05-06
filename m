Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E71E51CE39
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 04:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387611AbiEFAtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiEFAtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:49:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE5815A3F;
        Thu,  5 May 2022 17:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651797960; x=1683333960;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CEMQwyKyC2z3crG2gLQ2v/yWIWfTJd1sWTDPTFk+RlE=;
  b=RAzjpYdxabP8OD8PwZDgtifc7MSIZ6QjxSgTswM7Gmh2rbfyt8cHa7bK
   9f7OMVFGVFKiORijLIUskqr0m/2FaqYbysczMo2oBqurN4QOT/9loELeQ
   hrjgUltM3iKv9u3sXbjhNK4yqww9wq5ENuHbUap6N/s7QikEfEWC+g1ce
   4/51zFiCnmlf4HUibY6zJDJrndwsDN3BqgPC/gG5fhRzLNScJRKtR8AyZ
   nV6a1MGKCHQrjG4JFjpJJcGxivG3hg9Wu3VmsscnQIk+4d9unnF3lZwvC
   8A7CcnJU4+ySEdVwAyT7ljmzA28fJz5ljqILZMndQmHB1yC703Zj99GYJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="354738487"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="354738487"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 17:46:00 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="600317222"
Received: from anthienn-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.4.139])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 17:45:56 -0700
Message-ID: <b40b3658e1fc7ec15d2adafe7f9562d42bc256f3.camel@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Mike Rapoport <rppt@kernel.org>
Date:   Fri, 06 May 2022 12:45:54 +1200
In-Reply-To: <CAPcyv4jNYqPA2HBaO+9a+ije4jnb6a3Sx_1knrmRF9HCCXQuqg@mail.gmail.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
         <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
         <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
         <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
         <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
         <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
         <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
         <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com>
         <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
         <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
         <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
         <cbb2ea1343079aee546fb44cd59c82f66c875d76.camel@intel.com>
         <CAPcyv4jNYqPA2HBaO+9a+ije4jnb6a3Sx_1knrmRF9HCCXQuqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-05 at 17:22 -0700, Dan Williams wrote:
> On Thu, May 5, 2022 at 3:14 PM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > Thanks for feedback!
> > 
> > On Thu, 2022-05-05 at 06:51 -0700, Dan Williams wrote:
> > > [ add Mike ]
> > > 
> > > 
> > > On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> > > [..]
> > > > 
> > > > Hi Dave,
> > > > 
> > > > Sorry to ping (trying to close this).
> > > > 
> > > > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > > > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > > > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > > > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > > > that no one should just use some random backend to run TD.
> > > 
> > > The platform will already do this, right?
> > > 
> > 
> > In the current v3 implementation, we don't have any code to handle memory
> > hotplug, therefore nothing prevents people from adding legacy PMEMs as system
> > RAM using kmem driver.  In order to guarantee all pages managed by page
> 
> That's the fundamental question I am asking why is "guarantee all
> pages managed by page allocator are TDX memory". That seems overkill
> compared to indicating the incompatibility after the fact.

As I explained, the reason is I don't want to modify page allocator to
distinguish TDX and non-TDX allocation, for instance, having to have a ZONE_TDX
and GFP_TDX.

KVM depends on host's page fault handler to allocate the page.  In fact KVM only
consumes PFN from host's page tables.  For now only RAM is TDX memory.  By
guaranteeing all pages in page allocator is TDX memory, we can easily use
anonymous pages as TD guest memory.  This also allows us to easily extend the
shmem to support a new fd-based backend which doesn't require having to mmap()
TD guest memory to host userspace:

https://lore.kernel.org/kvm/20220310140911.50924-1-chao.p.peng@linux.intel.com/

Also, besides TD guest memory, there are some per-TD control data structures
(which must be TDX memory too) need to be allocated for each TD.  Normal memory
allocation APIs can be used for such allocation if we guarantee all pages in
page allocator is TDX memory.

> 
> > allocator are all TDX memory, the v3 implementation needs to always include
> > legacy PMEMs as TDX memory so that even people truly add  legacy PMEMs as system
> > RAM, we can still guarantee all pages in page allocator are TDX memory.
> 
> Why?

If we don't include legacy PMEMs as TDX memory, then after they are hot-added as
system RAM using kmem driver, the assumption of "all pages in page allocator are
TDX memory" is broken.  A TD can be killed during runtime.

> 
> > Of course, a side benefit of always including legacy PMEMs is people
> > theoretically can use them directly as TD guest backend, but this is just a
> > bonus but not something that we need to guarantee.
> > 
> > 
> > > I don't understand why this
> > > is trying to take proactive action versus documenting the error
> > > conditions and steps someone needs to take to avoid unconvertible
> > > memory. There is already the CONFIG_HMEM_REPORTING that describes
> > > relative performance properties between initiators and targets, it
> > > seems fitting to also add security properties between initiators and
> > > targets so someone can enumerate the numa-mempolicy that avoids
> > > unconvertible memory.
> > 
> > I don't think there's anything related to performance properties here.  The only
> > goal here is to make sure all pages in page allocator are TDX memory pages.
> 
> Please reconsider or re-clarify that goal.
> 
> > 
> > > 
> > > No, special casing in hotplug code paths needed.
> > > 
> > > > 
> > > > I think w/o needing to include legacy PMEM, it's better to get all TDX memory
> > > > blocks based on memblock, but not e820.  The pages managed by page allocator are
> > > > from memblock anyway (w/o those from memory hotplug).
> > > > 
> > > > And I also think it makes more sense to introduce 'tdx_memblock' and
> > > > 'tdx_memory' data structures to gather all TDX memory blocks during boot when
> > > > memblock is still alive.  When TDX module is initialized during runtime, TDMRs
> > > > can be created based on the 'struct tdx_memory' which contains all TDX memory
> > > > blocks we gathered based on memblock during boot.  This is also more flexible to
> > > > support other TDX memory from other sources such as CLX memory in the future.
> > > > 
> > > > Please let me know if you have any objection?  Thanks!
> > > 
> > > It's already the case that x86 maintains sideband structures to
> > > preserve memory after exiting the early memblock code.
> > > 
> > 
> > May I ask what data structures are you referring to?
> 
> struct numa_meminfo.
> 
> > Btw, the purpose of 'tdx_memblock' and 'tdx_memory' is not only just to preserve
> > memblock info during boot.  It is also used to provide a common data structure
> > that the "constructing TDMRs" code can work on.  If you look at patch 11-14, the
> > logic (create TDMRs, allocate PAMTs, sets up reserved areas) around how to
> > construct TDMRs doesn't have hard dependency on e820.  If we construct TDMRs
> > based on a common 'tdx_memory' like below:
> > 
> >         int construct_tdmrs(struct tdx_memory *tmem, ...);
> > 
> > It would be much easier to support other TDX memory resources in the future.
> 
> "in the future" is a prompt to ask "Why not wait until that future /
> need arrives before adding new infrastructure?"

Fine to me.

-- 
Thanks,
-Kai



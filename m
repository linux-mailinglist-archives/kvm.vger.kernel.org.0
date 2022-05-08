Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC0B51ECC0
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 12:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiEHKEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 May 2022 06:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiEHKEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 May 2022 06:04:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5584DCC6;
        Sun,  8 May 2022 03:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652004046; x=1683540046;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+5ktdwTSEzdqIzt2WqQjlTFy9PC3XSm+8de1iAFuTPI=;
  b=WrGVTYIIkudM4sNPi8bf4BDkwMyWNEx7rqQODMi3bbFY4AUQXs3uIwph
   G69llKPJp1SzXjuf19Ue11cATKjExqCvp2oHO/B4fQT9UliXTPURAs0Ar
   B7TVAiC+lDORYPTlk4NHGXXQsFCR22B08K9RmjD9p6xmpJwW3Qxs91uDy
   f9fpVNWYcvkr6D6frHPBp5RrgXvUVNB5A7FXYqEhla+8v7kiKe0GqXXfB
   Sk4Wc2bqQ+Sul7XAU8GFJDsljJIbH3N37ZQJvBjsLsyrle0JbEARvfwiz
   7C1eoa2OdW0Gkvrfm4k57ofyTEdp0jkMg9P/Jp0kQn+6uZ4RrkjdRjX4k
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10340"; a="268724286"
X-IronPort-AV: E=Sophos;i="5.91,208,1647327600"; 
   d="scan'208";a="268724286"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2022 03:00:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,208,1647327600"; 
   d="scan'208";a="813064753"
Received: from prahgoza-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.61.252])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2022 03:00:41 -0700
Message-ID: <5c7196b517398e7697464fe997018e9031d15470.camel@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Mike Rapoport <rppt@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
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
        Isaku Yamahata <isaku.yamahata@intel.com>
Date:   Sun, 08 May 2022 22:00:39 +1200
In-Reply-To: <YnW4nTub1BYUF15W@kernel.org>
References: <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
         <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
         <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
         <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
         <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
         <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
         <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com>
         <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
         <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
         <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
         <YnW4nTub1BYUF15W@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-05-06 at 20:09 -0400, Mike Rapoport wrote:
> On Thu, May 05, 2022 at 06:51:20AM -0700, Dan Williams wrote:
> > [ add Mike ]
> > 
> > On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> > [..]
> > > 
> > > Hi Dave,
> > > 
> > > Sorry to ping (trying to close this).
> > > 
> > > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > > that no one should just use some random backend to run TD.
> > 
> > The platform will already do this, right? I don't understand why this
> > is trying to take proactive action versus documenting the error
> > conditions and steps someone needs to take to avoid unconvertible
> > memory. There is already the CONFIG_HMEM_REPORTING that describes
> > relative performance properties between initiators and targets, it
> > seems fitting to also add security properties between initiators and
> > targets so someone can enumerate the numa-mempolicy that avoids
> > unconvertible memory.
> > 
> > No, special casing in hotplug code paths needed.
> > 
> > > 
> > > I think w/o needing to include legacy PMEM, it's better to get all TDX memory
> > > blocks based on memblock, but not e820.  The pages managed by page allocator are
> > > from memblock anyway (w/o those from memory hotplug).
> > > 
> > > And I also think it makes more sense to introduce 'tdx_memblock' and
> > > 'tdx_memory' data structures to gather all TDX memory blocks during boot when
> > > memblock is still alive.  When TDX module is initialized during runtime, TDMRs
> > > can be created based on the 'struct tdx_memory' which contains all TDX memory
> > > blocks we gathered based on memblock during boot.  This is also more flexible to
> > > support other TDX memory from other sources such as CLX memory in the future.
> > > 
> > > Please let me know if you have any objection?  Thanks!
> > 
> > It's already the case that x86 maintains sideband structures to
> > preserve memory after exiting the early memblock code. Mike, correct
> > me if I am wrong, but adding more is less desirable than just keeping
> > the memblock around?
> 
> TBH, I didn't read the entire thread yet, but at the first glance, keeping
> memblock around is much more preferable that adding yet another { .start,
> .end, .flags } data structure. To keep memblock after boot all is needed is
> something like
> 
> 	select ARCH_KEEP_MEMBLOCK if INTEL_TDX_HOST
> 
> I'll take a closer look next week on the entire series, maybe I'm missing
> some details.
> 

Hi Mike,

Thanks for feedback.

Perhaps I haven't put a lot details of the new TDX data structures, so let me
point out that the new two data structures 'struct tdx_memblock' and 'struct
tdx_memory' that I am proposing are mostly supposed to be used by TDX code only,
which is pretty standalone.  They are not supposed to be some basic
infrastructure that can be widely used by other random kernel components. 

In fact, currently the only operation we need is to allow memblock to register
all memory regions as TDX memory blocks when the memblock is still alive. 
Therefore, in fact, the new data structures can even be completely invisible to
other kernel components.  For instance, TDX code can provide below API w/o
exposing any data structures to other kernel components:

int tdx_add_memory_block(phys_addr_t start, phys_addr_t end, int nid);

And we call above API for each memory region in memblock when it is alive.

TDX code internally manages those memory regions via the new data structures
that I mentioned above, so we don't need to keep memblock after boot.  The
advantage of this approach is it is more flexible to support other potential TDX
memory resources (such as CLX memory) in the future.

Otherwise, we can do as you suggested to select ARCH_KEEP_MEMBLOCK when
INTEL_TDX_HOST is on and TDX code internally uses memblock API directly.

-- 
Thanks,
-Kai



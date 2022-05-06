Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC7051CE1F
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 04:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388065AbiEFBur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 21:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349717AbiEFBun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 21:50:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEDF6161F;
        Thu,  5 May 2022 18:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651801622; x=1683337622;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VjSH5LDnjXIHElITE6SXka1NHyhfRQhUCHFxdPyDuYU=;
  b=MPwdljtrxMoyZG9VfnpVxtZpC59AMbc3iuND8sMrV0sNN18WzBjhY4Se
   A45asLhEkjqMN0sNp9QoZM+dmJpznZmZAVVjJmtmnQMje6Huaf7i79CEi
   sB5+KLKsEXOlqA9uKqai4ja9+1U8J1BAk2clxVmFXNBKysiVxnaQGdx+8
   IXw/5HhM5x+hGVbvOkCWV5amD7z9vAzdxI7+AjeAOX+fbBoCL6FHJ5K70
   iVCDTn5dcycmUv/szd9KHqH58JIoSZtNKLDraS4yMUKHC7LZ/UYnavynx
   ENY0EwGUyX8CCLRUEo/4lMMUBBLmdWfI+yvRuvoECYgdAJyv+MwCutPNX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="267917066"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="267917066"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:47:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632711635"
Received: from anthienn-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.4.139])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:46:58 -0700
Message-ID: <b0d1ed15d8bf99efe1c49182f4a98f4a23f61d0d.camel@intel.com>
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
Date:   Fri, 06 May 2022 13:46:55 +1200
In-Reply-To: <CAPcyv4hdM+0zntuTez9n1-dJ_ODsF_TxAct=VpTs-tWJzBPJqQ@mail.gmail.com>
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
         <b40b3658e1fc7ec15d2adafe7f9562d42bc256f3.camel@intel.com>
         <CAPcyv4hdM+0zntuTez9n1-dJ_ODsF_TxAct=VpTs-tWJzBPJqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-05 at 18:15 -0700, Dan Williams wrote:
> On Thu, May 5, 2022 at 5:46 PM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > On Thu, 2022-05-05 at 17:22 -0700, Dan Williams wrote:
> > > On Thu, May 5, 2022 at 3:14 PM Kai Huang <kai.huang@intel.com> wrote:
> > > > 
> > > > Thanks for feedback!
> > > > 
> > > > On Thu, 2022-05-05 at 06:51 -0700, Dan Williams wrote:
> > > > > [ add Mike ]
> > > > > 
> > > > > 
> > > > > On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> > > > > [..]
> > > > > > 
> > > > > > Hi Dave,
> > > > > > 
> > > > > > Sorry to ping (trying to close this).
> > > > > > 
> > > > > > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > > > > > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > > > > > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > > > > > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > > > > > that no one should just use some random backend to run TD.
> > > > > 
> > > > > The platform will already do this, right?
> > > > > 
> > > > 
> > > > In the current v3 implementation, we don't have any code to handle memory
> > > > hotplug, therefore nothing prevents people from adding legacy PMEMs as system
> > > > RAM using kmem driver.  In order to guarantee all pages managed by page
> > > 
> > > That's the fundamental question I am asking why is "guarantee all
> > > pages managed by page allocator are TDX memory". That seems overkill
> > > compared to indicating the incompatibility after the fact.
> > 
> > As I explained, the reason is I don't want to modify page allocator to
> > distinguish TDX and non-TDX allocation, for instance, having to have a ZONE_TDX
> > and GFP_TDX.
> 
> Right, TDX details do not belong at that level, but it will work
> almost all the time if you do nothing to "guarantee" all TDX capable
> pages all the time.

"almost all the time" do you mean?

> 
> > KVM depends on host's page fault handler to allocate the page.  In fact KVM only
> > consumes PFN from host's page tables.  For now only RAM is TDX memory.  By
> > guaranteeing all pages in page allocator is TDX memory, we can easily use
> > anonymous pages as TD guest memory.
> 
> Again, TDX capable pages will be the overwhelming default, why are you
> worried about cluttering the memory hotplug path for nice corner
> cases.

Firstly perhaps I forgot to mention there are two concepts about TDX memory, so
let me clarify first:

1) Convertible Memory Regions (CMRs).  This is reported by BIOS (thus static) to
indicate which memory regions *can* be used as TDX memory.  This basically means
all RAM during boot for now.

2) TD Memory Regions (TDMRs).  Memory pages in CMRs are not automatically TDX
usable memory.  The TDX module needs to be configured which (convertible) memory
regions can be used as TDX memory.  Kernel is responsible for choosing the
ranges, and configure to the TDX module.  If a convertible memory page is not
included into TDMRs, the TDX module will report error when it is assigned to  a
TD.

> 
> Consider the fact that end users can break the kernel by specifying
> invalid memmap= command line options. The memory hotplug code does not
> take any steps to add safety in those cases because there are already
> too many ways it can go wrong. TDX is just one more corner case where
> the memmap= user needs to be careful. Otherwise, it is up to the
> platform firmware to make sure everything in the base memory map is
> TDX capable, and then all you need is documentation about the failure
> mode when extending "System RAM" beyond that baseline.

So the fact is, if we don't include legacy PMEMs into TDMRs, and don't do
anything in memory hotplug, then if user does kmem-hot-add legacy PMEMs as
system RAM, a live TD may eventually be killed.

If such case is a corner case that we don't need to guarantee, then even better.
And we have an additional reason that those legacy PMEMs don't need to be in
TDMRs.  As you suggested,  we can add some documentation to point out.

But the point we want to do some code check and prevent memory hotplug is, as
Dave said, we want this piece of code to work on *ANY* TDX capable machines,
including future machines which may, i.e. supports NVDIMM/CLX memory as TDX
memory.  If we don't do any code check in  memory hotplug in this series, then
when this code runs in future platforms, user can plug NVDIMM or CLX memory as
system RAM thus break the assumption "all pages in page allocator are TDX
memory", which eventually leads to live TDs being killed potentially.

Dave said we need to guarantee this code can work on *ANY* TDX machines.  Some
documentation saying it only works one some platforms and you shouldn't do
things on other platforms are not good enough:

https://lore.kernel.org/lkml/cover.1649219184.git.kai.huang@intel.com/T/#m6df45b6e1702bb03dcb027044a0dabf30a86e471

> 
> 
> > shmem to support a new fd-based backend which doesn't require having to mmap()
> > TD guest memory to host userspace:
> > 
> > https://lore.kernel.org/kvm/20220310140911.50924-1-chao.p.peng@linux.intel.com/
> > 
> > Also, besides TD guest memory, there are some per-TD control data structures
> > (which must be TDX memory too) need to be allocated for each TD.  Normal memory
> > allocation APIs can be used for such allocation if we guarantee all pages in
> > page allocator is TDX memory.
> 
> You don't need that guarantee, just check it after the fact and fail
> if that assertion fails. It should almost always be the case that it
> succeeds and if it doesn't then something special is happening with
> that system and the end user has effectively opt-ed out of TDX
> operation.

This doesn't guarantee consistent behaviour.  For instance, for one TD it can be
created, while the second may fail.  We should provide a consistent service.

The thing is anyway we need to configure some memory regions to the TDX module.
To me there's no reason we don't want to guarantee all pages in page allocator
are TDX memory. 

> 
> > > > allocator are all TDX memory, the v3 implementation needs to always include
> > > > legacy PMEMs as TDX memory so that even people truly add  legacy PMEMs as system
> > > > RAM, we can still guarantee all pages in page allocator are TDX memory.
> > > 
> > > Why?
> > 
> > If we don't include legacy PMEMs as TDX memory, then after they are hot-added as
> > system RAM using kmem driver, the assumption of "all pages in page allocator are
> > TDX memory" is broken.  A TD can be killed during runtime.
> 
> Yes, that is what the end user asked for. If they don't want that to
> happen then the policy decision about using kmem needs to be updated
> in userspace, not hard code that policy decision towards TDX inside
> the kernel.

This is also fine to me.  But please also see above Dave's comment.

Thanks for those valuable feedback!


-- 
Thanks,
-Kai



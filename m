Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536605141CE
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 07:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354162AbiD2FjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 01:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354154AbiD2Fi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 01:38:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579A5393E8;
        Thu, 28 Apr 2022 22:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651210537; x=1682746537;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mvAgYeegRWpkdqPwWa23w0CfmY0+Nqka53g1SkU+X+U=;
  b=MH4xXw/csU16NXlwY8QmWp+u6NVFchWE3/BrgVvsG/n9hTS8xil2tqpG
   BnvuwN0gOwmRjV/zkyHihAWDrsyH0nmA2D+gDTzZ7LVmFuIrGHL4aYnIe
   +df34wsw7bTOPsFCCjXk7NJgfk3EOhYCwPxwVi1L1XkXTtmZCu+IaTY9t
   le9u51XFU9qli4sTFg6e1jdFIPuBl8V8Rf0STb3Kim2KzeLXSFy8VaxDC
   Mp13jckFiGn+mp1Ku6uoJVhrjrUQeZ6WRRgv3XVTuHHLPO8RmcU/ch0h1
   NWxIpL+ksIt3/5WFguLOT8yQJQsFchhxGBvC5rmvS7RqI4YjHcGWNwmE9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265387032"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="265387032"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 22:35:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="629918139"
Received: from jenegret-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.59.236])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 22:35:32 -0700
Message-ID: <ffa956ade7c784af347da346a61bef22b85d9646.camel@intel.com>
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
        Isaku Yamahata <isaku.yamahata@intel.com>
Date:   Fri, 29 Apr 2022 17:35:30 +1200
In-Reply-To: <CAPcyv4gEwjnNE9cWb_KLZ6C7-UxKdUMZKFPF+LAJ4L1SjByisw@mail.gmail.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
         <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
         <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
         <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
         <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
         <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
         <CAPcyv4gEwjnNE9cWb_KLZ6C7-UxKdUMZKFPF+LAJ4L1SjByisw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 20:04 -0700, Dan Williams wrote:
> On Thu, Apr 28, 2022 at 6:40 PM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > On Thu, 2022-04-28 at 12:58 +1200, Kai Huang wrote:
> > > On Wed, 2022-04-27 at 17:50 -0700, Dave Hansen wrote:
> > > > On 4/27/22 17:37, Kai Huang wrote:
> > > > > On Wed, 2022-04-27 at 14:59 -0700, Dave Hansen wrote:
> > > > > > In 5 years, if someone takes this code and runs it on Intel hardware
> > > > > > with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?
> > > > > 
> > > > > I thought we could document this in the documentation saying that this code can
> > > > > only work on TDX machines that don't have above capabilities (SPR for now).  We
> > > > > can change the code and the documentation  when we add the support of those
> > > > > features in the future, and update the documentation.
> > > > > 
> > > > > If 5 years later someone takes this code, he/she should take a look at the
> > > > > documentation and figure out that he/she should choose a newer kernel if the
> > > > > machine support those features.
> > > > > 
> > > > > I'll think about design solutions if above doesn't look good for you.
> > > > 
> > > > No, it doesn't look good to me.
> > > > 
> > > > You can't just say:
> > > > 
> > > >     /*
> > > >      * This code will eat puppies if used on systems with hotplug.
> > > >      */
> > > > 
> > > > and merrily await the puppy bloodbath.
> > > > 
> > > > If it's not compatible, then you have to *MAKE* it not compatible in a
> > > > safe, controlled way.
> > > > 
> > > > > > You can't just ignore the problems because they're not present on one
> > > > > > version of the hardware.
> > > > 
> > > > Please, please read this again ^^
> > > 
> > > OK.  I'll think about solutions and come back later.
> > > > 
> > 
> > Hi Dave,
> > 
> > I think we have two approaches to handle memory hotplug interaction with the TDX
> > module initialization.
> > 
> > The first approach is simple.  We just block memory from being added as system
> > RAM managed by page allocator when the platform supports TDX [1]. It seems we
> > can add some arch-specific-check to __add_memory_resource() and reject the new
> > memory resource if platform supports TDX.  __add_memory_resource() is called by
> > both __add_memory() and add_memory_driver_managed() so it prevents from adding
> > NVDIMM as system RAM and normal ACPI memory hotplug [2].
> 
> What if the memory being added *is* TDX capable? What if someone
> wanted to manage a memory range as soft-reserved and move it back and
> forth from the core-mm to device access. That should be perfectly
> acceptable as long as the memory is TDX capable.

Please see below.

> 
> > The second approach is relatively more complicated.  Instead of directly
> > rejecting the new memory resource in __add_memory_resource(), we check whether
> > the memory resource can be added based on CMR and the TDX module initialization
> > status.   This is feasible as with the latest public P-SEAMLDR spec, we can get
> > CMR from P-SEAMLDR SEAMCALL[3].  So we can detect P-SEAMLDR and get CMR info
> > during kernel boots.  And in __add_memory_resource() we do below check:
> > 
> >         tdx_init_disable();     /*similar to cpu_hotplug_disable() */
> >         if (tdx_module_initialized())
> >                 // reject memory hotplug
> >         else if (new_memory_resource NOT in CMRs)
> >                 // reject memory hotplug
> >         else
> >                 allow memory hotplug
> >         tdx_init_enable();      /*similar to cpu_hotplug_enable() */
> > 
> > tdx_init_disable() temporarily disables TDX module initialization by trying to
> > grab the mutex.  If the TDX module initialization is already on going, then it
> > waits until it completes.
> > 
> > This should work better for future platforms, but would requires non-trivial
> > more code as we need to add VMXON/VMXOFF support to the core-kernel to detect
> > CMR using  SEAMCALL.  A side advantage is with VMXON in core-kernel we can
> > shutdown the TDX module in kexec().
> > 
> > But for this series I think the second approach is overkill and we can choose to
> > use the first simple approach?
> 
> This still sounds like it is trying to solve symptoms and not the root
> problem. Why must the core-mm never have non-TDX memory when VMs are
> fine to operate with either core-mm pages or memory from other sources
> like hugetlbfs and device-dax?

Basically we don't want to modify page allocator API to distinguish TDX and non-
TDX allocation.  For instance, we don't want a new GFP_TDX.

There's another series done by Chao "KVM: mm: fd-based approach for supporting
KVM guest private memory" which essentially allows KVM to ask guest memory
backend to allocate page w/o having to mmap() to userspace.  

https://lore.kernel.org/kvm/20220310140911.50924-1-chao.p.peng@linux.intel.com/

More specifically, memfd will support a new MFD_INACCESSIBLE flag when it is
created so all pages associated with this memfd will be TDX capable memory.  The
backend will need to implement a new memfile_notifier_ops to allow KVM to get
and put the memory page.

struct memfile_pfn_ops {
	long (*get_lock_pfn)(struct inode *inode, pgoff_t offset, int *order);
	void (*put_unlock_pfn)(unsigned long pfn);
};

With that, it is backend's responsibility to implement get_lock_pfn() callback
in which the backend needs to ensure a TDX private page is allocated.

For TD guest, KVM should enforced to only use those fd-based backend.  I am not
sure whether anonymous pages should be supported anymore.

Sean, please correct me if I am wrong?

Currently only shmem is extended to support it.  By ensuring pages in page
allocator are all TDX memory, shmem can be extended easily to support TD guests.
 
If device-dax and hugetlbfs wants to support TD guests then they should
implement those callbacks and ensure only TDX memory is allocated.  For
instance, when future TDX supports NVDIMM (i.e. NVDIMM is included to CMRs),
then device-dax pages can be included as TDX memory when initializing the TDX
module and device-dax can implement it's own to support allocating page for TD
guests.

But TDX architecture can be changed to support memory hotplug in a more graceful
way in the future.  For instance, it can choose to support dynamically adding
any convertible memory as TDX memory *after* TDX module initialization.  But
this is just my brainstorming.

Anyway, for now, since only shmem (or + anonymous pages) can be used to create
TD guests, I think we can just reject any memory hot-add when platform supports
TDX as described in the first simple approach.  Eventually we may need something
like the second approach but TDX architecture can evolve too.


-- 
Thanks,
-Kai



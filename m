Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254705141DB
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 07:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354184AbiD2Fqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 01:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiD2Fqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 01:46:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E056FF63;
        Thu, 28 Apr 2022 22:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651211013; x=1682747013;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UI81Hy0EeAd+tens49psKJFgFs0JlShTYmgbYNU/Y5k=;
  b=EzAdR29A4QkLg470LLlbVWoBIyG8aCHWwkhki3cFFg2/xWZNbtUan6u3
   C94p9YrdHuLnNnq49A8IrH+9l7i1c6MLM7MXpksjbdDnbp+9zg4G7cpUd
   mBrGYmfHGyvfREBHnx0Ts/P5mpQyeYv/WgUe84SbnPQneXpscL1m1gNsi
   j5vDOnyQjQJvqqErsaofgPgp+LB1ln8iT0qpn993smbSD+DmyA0J9190G
   NfVqCG7fnnHVJHgGRUQf8zo+XCu+6VM4rq/lpY2FSsEsN8UT8RqEsU9Q5
   ykTsNukgasY4BaOqFgo0d5vuT68riusx62t/ha5fkV9BdAcfRaFvS7hoK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266065418"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266065418"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 22:43:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="684103579"
Received: from jenegret-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.59.236])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 22:43:29 -0700
Message-ID: <224392eea0042b621541aa916f49dd830704ba9a.camel@intel.com>
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
Date:   Fri, 29 Apr 2022 17:43:27 +1200
In-Reply-To: <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
         <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
         <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 19:58 -0700, Dan Williams wrote:
> On Wed, Apr 27, 2022 at 6:21 PM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > On Wed, 2022-04-27 at 18:01 -0700, Dan Williams wrote:
> > > On Tue, Apr 26, 2022 at 1:10 PM Dave Hansen <dave.hansen@intel.com> wrote:
> > > [..]
> > > > > 3. Memory hotplug
> > > > > 
> > > > > The first generation of TDX architecturally doesn't support memory
> > > > > hotplug.  And the first generation of TDX-capable platforms don't support
> > > > > physical memory hotplug.  Since it physically cannot happen, this series
> > > > > doesn't add any check in ACPI memory hotplug code path to disable it.
> > > > > 
> > > > > A special case of memory hotplug is adding NVDIMM as system RAM using
> > > 
> > > Saw "NVDIMM" mentioned while browsing this, so stopped to make a comment...
> > > 
> > > > > kmem driver.  However the first generation of TDX-capable platforms
> > > > > cannot enable TDX and NVDIMM simultaneously, so in practice this cannot
> > > > > happen either.
> > > > 
> > > > What prevents this code from today's code being run on tomorrow's
> > > > platforms and breaking these assumptions?
> > > 
> > > The assumption is already broken today with NVDIMM-N. The lack of
> > > DDR-T support on TDX enabled platforms has zero effect on DDR-based
> > > persistent memory solutions. In other words, please describe the
> > > actual software and hardware conflicts at play here, and do not make
> > > the mistake of assuming that "no DDR-T support on TDX platforms" ==
> > > "no NVDIMM support".
> > 
> > Sorry I got this information from planning team or execution team I guess. I was
> > told NVDIMM and TDX cannot "co-exist" on the first generation of TDX capable
> > machine.  "co-exist" means they cannot be turned on simultaneously on the same
> > platform.  I am also not aware NVDIMM-N, nor the difference between DDR based
> > and DDR-T based persistent memory.  Could you give some more background here so
> > I can take a look?
> 
> My rough understanding is that TDX makes use of metadata communicated
> "on the wire" for DDR, but that infrastructure is not there for DDR-T.
> However, there are plenty of DDR based NVDIMMs that use super-caps /
> batteries and flash to save contents. I believe the concern for TDX is
> that the kernel needs to know not use TDX accepted PMEM as PMEM
> because the contents saved by the DIMM's onboard energy source are
> unreadable outside of a TD.
> 
> Here is one of the links that comes up in a search for NVDIMM-N.
> 
> https://www.snia.org/educational-library/what-you-can-do-nvdimm-n-and-nvdimm-p-2019

Thanks for the info.  I need some more time to digest those different types of
DDRs and NVDIMMs.  However I guess they are not quite relevant since TDX has a
concept of "Convertible Memory Region".  Please see below.

> 
> > 
> > > 
> > > > > Another case is admin can use 'memmap' kernel command line to create
> > > > > legacy PMEMs and use them as TD guest memory, or theoretically, can use
> > > > > kmem driver to add them as system RAM.  To avoid having to change memory
> > > > > hotplug code to prevent this from happening, this series always include
> > > > > legacy PMEMs when constructing TDMRs so they are also TDX memory.
> > > 
> > > I am not sure what you are trying to say here?
> > 
> > We want to always make sure the memory managed by page allocator is TDX memory.
> 
> That only seems possible if the kernel is given a TDX capable physical
> address map at the beginning of time.

Yes TDX architecture has a concept "Convertible Memory Region" (CMR). The memory
used by TDX must be convertible memory.  BIOS generates an array of CMR entries
during boot and they are verified by MCHECK.  CMRs are static during machine's
runtime.

> 
> > So if the legacy PMEMs are unconditionally configured as TDX memory, then we
> > don't need to prevent them from being added as system memory via kmem driver.
> 
> I think that is too narrow of a focus.
> 
> Does a memory map exist for the physical address ranges that are TDX
> capable? Please don't say EFI_MEMORY_CPU_CRYPTO, as that single bit is
> ambiguous beyond the point of utility across the industry's entire
> range of confidential computing memory capabilities.
> 
> One strawman would be an ACPI table with contents like:
> 
> struct acpi_protected_memory {
>    struct range range;
>    uuid_t platform_mem_crypto_capability;
> };
> 
> With some way to map those uuids to a set of platform vendor specific
> constraints and specifications. Some would be shared across
> confidential computing vendors, some might be unique. Otherwise, I do
> not see how you enforce the expectation of "all memory in the page
> allocator is TDX capable". 
> 

Please see above.  TDX has CMR.

> The other alternative is that *none* of the
> memory in the page allocator is TDX capable and a special memory
> allocation device is used to map memory for TDs. In either case a map
> of all possible TDX memory is needed and the discussion above seems
> like an incomplete / "hopeful" proposal about the memory dax_kmem, or
> other sources, might online. 

Yes we are also developing a new memfd based approach to support TD guest
memory.  Please see my another reply to you.


> See the CXL CEDT CFWMS (CXL Fixed Memory
> Window Structure) as an example of an ACPI table that sets the
> kernel's expectations about how a physical address range might be
> used.
> 
> https://www.computeexpresslink.org/spec-landing

Thanks for the info. I'll take a look to get some background.

> 
> > 
> > > 
> > > > > 4. CPU hotplug
> > > > > 
> > > > > The first generation of TDX architecturally doesn't support ACPI CPU
> > > > > hotplug.  All logical cpus are enabled by BIOS in MADT table.  Also, the
> > > > > first generation of TDX-capable platforms don't support ACPI CPU hotplug
> > > > > either.  Since this physically cannot happen, this series doesn't add any
> > > > > check in ACPI CPU hotplug code path to disable it.
> > > 
> > > What are the actual challenges posed to TDX with respect to CPU hotplug?
> > 
> > During the TDX module initialization, there is a step to call SEAMCALL on all
> > logical cpus to initialize per-cpu TDX staff.  TDX doesn't support initializing
> > the new hot-added CPUs after the initialization.  There are MCHECK/BIOS changes
> > to enforce this check too I guess but I don't know details about this.
> 
> Is there an ACPI table that indicates CPU-x passed the check? Or since
> the BIOS is invoked in the CPU-online path, is it trusted to suppress
> those events for CPUs outside of the mcheck domain?

No the TDX module (and the P-SEAMLDR) internally maintains some data to record
the total number of LPs and packages, and which logical cpu has been
initialized, etc.

I asked Intel guys whether BIOS would suppress an ACPI CPU hotplug event but I
never got a concrete answer.  I'll try again.

> 
> > > > > Also, only TDX module initialization requires all BIOS-enabled cpus are
> > > 
> > > Please define "BIOS-enabled" cpus. There is no "BIOS-enabled" line in
> > > /proc/cpuinfo for example.
> > 
> > It means the CPUs with "enable" bit set in the MADT table.
> 
> That just indicates to the present CPUs and then a hot add event
> changes the state of now present CPUs to enabled. Per above is the
> BIOS responsible for rejecting those new CPUs, or is the kernel?

I'll ask BIOS guys again to see whether BIOS will suppress ACPI CPU hotplug
event.  But I think we can have a simple patch to reject ACPI CPU hotplug if
platform is TDX-capable?

Or do you think we don't need to explicitly reject ACPI CPU hotplug if we can
confirm with BIOS guys that it will suppress on TDX capable machine?

-- 
Thanks,
-Kai



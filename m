Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F05510DD1
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356613AbiD0BSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiD0BST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:18:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5291149;
        Tue, 26 Apr 2022 18:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651022108; x=1682558108;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0xF4u6bKIDATfFpiOZZrcYPm39KiEoiEAhQO1VPQtS0=;
  b=mARk5qKHTOw4n0X4nroRVcRPjoN/PnZTSHEKBon9Fd9cR/sXHgqA7xVr
   TkMjjobXAxzLPxqPBS+bNvrLFtwkjBfU2Gfs2sgv6mnpkgEtNGONoOO+j
   hb9p0mLjMr+YaPoBZb55rx40eonFcI42CV/m40IKWlAINpAlCquzbHIGt
   f6f13q1ahsVCmkWCYDwxYzh6xtJ1/dq5Xs+OcJWODNzSyOGX/ZlF4k1Q7
   nl7sI1fc6FgHJtZ+KJiZd3D5MO6Ij9vGwDSTFdELLbM+NusPAlH2vpfLE
   tUpfc9dZxcp6YgaBUAyojefK+rPw1TdLm2gW3Dpjg9LVgcQPW9NqMhldj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="328715771"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="328715771"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 18:15:08 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="564846008"
Received: from ssaride-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.221])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 18:15:04 -0700
Message-ID: <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Wed, 27 Apr 2022 13:15:02 +1200
In-Reply-To: <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 13:13 -0700, Dave Hansen wrote:
> On 4/5/22 21:49, Kai Huang wrote:
> > SEAM VMX root operation is designed to host a CPU-attested, software
> > module called the 'TDX module' which implements functions to manage
> > crypto protected VMs called Trust Domains (TD).  SEAM VMX root is also
> 
> "crypto protected"?  What the heck is that?

How about "crypto-protected"?  I googled and it seems it is used by someone
else.

> 
> > designed to host a CPU-attested, software module called the 'Intel
> > Persistent SEAMLDR (Intel P-SEAMLDR)' to load and update the TDX module.
> > 
> > Host kernel transits to either the P-SEAMLDR or the TDX module via a new
> 
>  ^ The

Thanks.

> 
> > SEAMCALL instruction.  SEAMCALLs are host-side interface functions
> > defined by the P-SEAMLDR and the TDX module around the new SEAMCALL
> > instruction.  They are similar to a hypercall, except they are made by
> > host kernel to the SEAM software modules.
> 
> This is still missing some important high-level things, like that the
> TDX module is protected from the untrusted VMM.  Heck, it forgets to
> mention that the VMM itself is untrusted and the TDX module replaces
> things that the VMM usually does.
> 
> It would also be nice to mention here how this compares with SEV-SNP.
> Where is the TDX module in that design?  Why doesn't SEV need all this code?
> 
> > TDX leverages Intel Multi-Key Total Memory Encryption (MKTME) to crypto
> > protect TD guests.  TDX reserves part of MKTME KeyID space as TDX private
> > KeyIDs, which can only be used by software runs in SEAM.  The physical
> 
> 					    ^ which

Thanks.

> 
> > address bits for encoding TDX private KeyID are treated as reserved bits
> > when not in SEAM operation.  The partitioning of MKTME KeyIDs and TDX
> > private KeyIDs is configured by BIOS.
> > 
> > Before being able to manage TD guests, the TDX module must be loaded
> > and properly initialized using SEAMCALLs defined by TDX architecture.
> > This series assumes both the P-SEAMLDR and the TDX module are loaded by
> > BIOS before the kernel boots.
> > 
> > There's no CPUID or MSR to detect either the P-SEAMLDR or the TDX module.
> > Instead, detecting them can be done by using P-SEAMLDR's SEAMLDR.INFO
> > SEAMCALL to detect P-SEAMLDR.  The success of this SEAMCALL means the
> > P-SEAMLDR is loaded.  The P-SEAMLDR information returned by this
> > SEAMCALL further tells whether TDX module is loaded.
> 
> There's a bit of information missing here.  The kernel might not know
> the state of things being loaded.  A previous kernel might have loaded
> it and left it in an unknown state.
> 
> > The TDX module is initialized in multiple steps:
> > 
> >         1) Global initialization;
> >         2) Logical-CPU scope initialization;
> >         3) Enumerate the TDX module capabilities;
> >         4) Configure the TDX module about usable memory ranges and
> >            global KeyID information;
> >         5) Package-scope configuration for the global KeyID;
> >         6) Initialize TDX metadata for usable memory ranges based on 4).
> > 
> > Step 2) requires calling some SEAMCALL on all "BIOS-enabled" (in MADT
> > table) logical cpus, otherwise step 4) will fail.  Step 5) requires
> > calling SEAMCALL on at least one cpu on all packages.
> > 
> > TDX module can also be shut down at any time during module's lifetime, by
> > calling SEAMCALL on all "BIOS-enabled" logical cpus.
> > 
> > == Design Considerations ==
> > 
> > 1. Lazy TDX module initialization on-demand by caller
> 
> This doesn't really tell us what "lazy" is or what the alternatives are.
> 
> There are basically two ways the TDX module could be loaded.  Either:
>   * In early boot
> or
>   * At runtime just before the first TDX guest is run
> 
> This series implements the runtime loading.

OK will do.

> 
> > None of the steps in the TDX module initialization process must be done
> > during kernel boot.  This series doesn't initialize TDX at boot time, but
> > instead, provides two functions to allow caller to detect and initialize
> > TDX on demand:
> > 
> >         if (tdx_detect())
> >                 goto no_tdx;
> >         if (tdx_init())
> >                 goto no_tdx;
> > 
> > This approach has below pros:
> > 
> > 1) Initializing the TDX module requires to reserve ~1/256th system RAM as
> > metadata.  Enabling TDX on demand allows only to consume this memory when
> > TDX is truly needed (i.e. when KVM wants to create TD guests).
> > 
> > 2) Both detecting and initializing the TDX module require calling
> > SEAMCALL.  However, SEAMCALL requires CPU being already in VMX operation
> > (VMXON has been done).  So far, KVM is the only user of TDX, and it
> > already handles VMXON/VMXOFF.  Therefore, letting KVM to initialize TDX
> > on-demand avoids handling VMXON/VMXOFF (which is not that trivial) in
> > core-kernel.  Also, in long term, likely a reference based VMXON/VMXOFF
> > approach is needed since more kernel components will need to handle
> > VMXON/VMXONFF.
> > 
> > 3) It is more flexible to support "TDX module runtime update" (not in
> > this series).  After updating to the new module at runtime, kernel needs
> > to go through the initialization process again.  For the new module,
> > it's possible the metadata allocated for the old module cannot be reused
> > for the new module, and needs to be re-allocated again.
> > 
> > 2. Kernel policy on TDX memory
> > 
> > Host kernel is responsible for choosing which memory regions can be used
> > as TDX memory, and configuring those memory regions to the TDX module by
> > using an array of "TD Memory Regions" (TDMR), which is a data structure
> > defined by TDX architecture.
> 
> 
> This is putting the cart before the horse.  Don't define the details up
> front.
> 
> 	The TDX architecture allows the VMM to designate specific memory
> 	as usable for TDX private memory.  This series chooses to
> 	designate _all_ system RAM as TDX to avoid having to modify the
> 	page allocator to distinguish TDX and non-TDX-capable memory
> 
> ... then go on to explain the details.

Thanks.  Will update.

> 
> > The first generation of TDX essentially guarantees that all system RAM
> > memory regions (excluding the memory below 1MB) can be used as TDX
> > memory.  To avoid having to modify the page allocator to distinguish TDX
> > and non-TDX allocation, this series chooses to use all system RAM as TDX
> > memory.
> > 
> > E820 table is used to find all system RAM entries.  Following
> > e820__memblock_setup(), both E820_TYPE_RAM and E820_TYPE_RESERVED_KERN
> > types are treated as TDX memory, and contiguous ranges in the same NUMA
> > node are merged together (similar to memblock_add()) before trimming the
> > non-page-aligned part.
> 
> This e820 cruft is too much detail for a cover letter.  In general, once
> you start talking about individual functions, you've gone too far in the
> cover letter.

Will remove.

> 
> > 3. Memory hotplug
> > 
> > The first generation of TDX architecturally doesn't support memory
> > hotplug.  And the first generation of TDX-capable platforms don't support
> > physical memory hotplug.  Since it physically cannot happen, this series
> > doesn't add any check in ACPI memory hotplug code path to disable it.
> > 
> > A special case of memory hotplug is adding NVDIMM as system RAM using
> > kmem driver.  However the first generation of TDX-capable platforms
> > cannot enable TDX and NVDIMM simultaneously, so in practice this cannot
> > happen either.
> 
> What prevents this code from today's code being run on tomorrow's
> platforms and breaking these assumptions?

I forgot to add below (which is in the documentation patch):

"This can be enhanced when future generation of TDX starts to support ACPI
memory hotplug, or NVDIMM and TDX can be enabled simultaneously on the
same platform."

Is this acceptable?

> 
> > Another case is admin can use 'memmap' kernel command line to create
> > legacy PMEMs and use them as TD guest memory, or theoretically, can use
> > kmem driver to add them as system RAM.  To avoid having to change memory
> > hotplug code to prevent this from happening, this series always include
> > legacy PMEMs when constructing TDMRs so they are also TDX memory.
> > 
> > 4. CPU hotplug
> > 
> > The first generation of TDX architecturally doesn't support ACPI CPU
> > hotplug.  All logical cpus are enabled by BIOS in MADT table.  Also, the
> > first generation of TDX-capable platforms don't support ACPI CPU hotplug
> > either.  Since this physically cannot happen, this series doesn't add any
> > check in ACPI CPU hotplug code path to disable it.
> > 
> > Also, only TDX module initialization requires all BIOS-enabled cpus are
> > online.  After the initialization, any logical cpu can be brought down
> > and brought up to online again later.  Therefore this series doesn't
> > change logical CPU hotplug either.
> > 
> > 5. TDX interaction with kexec()
> > 
> > If TDX is ever enabled and/or used to run any TD guests, the cachelines
> > of TDX private memory, including PAMTs, used by TDX module need to be
> > flushed before transiting to the new kernel otherwise they may silently
> > corrupt the new kernel.  Similar to SME, this series flushes cache in
> > stop_this_cpu().
> 
> What does this have to do with kexec()?  What's a PAMT?

The point is the dirty cachelines of TDX private memory must be flushed
otherwise they may slightly corrupt the new kexec()-ed kernel.

Will use "TDX metadata" instead of "PAMT".  The former has already been
mentioned above.

> 
> > The TDX module can be initialized only once during its lifetime.  The
> > first generation of TDX doesn't have interface to reset TDX module to
> 
> 				      ^ an

Thanks.

> 
> > uninitialized state so it can be initialized again.
> > 
> > This implies:
> > 
> >   - If the old kernel fails to initialize TDX, the new kernel cannot
> >     use TDX too unless the new kernel fixes the bug which leads to
> >     initialization failure in the old kernel and can resume from where
> >     the old kernel stops. This requires certain coordination between
> >     the two kernels.
> 
> OK, but what does this *MEAN*?

This means we need to extend the information which the old kernel passes to the
new kernel.  But I don't think it's feasible.  I'll refine this kexec() section
to make it more concise next version.

> 
> >   - If the old kernel has initialized TDX successfully, the new kernel
> >     may be able to use TDX if the two kernels have the exactly same
> >     configurations on the TDX module. It further requires the new kernel
> >     to reserve the TDX metadata pages (allocated by the old kernel) in
> >     its page allocator. It also requires coordination between the two
> >     kernels.  Furthermore, if kexec() is done when there are active TD
> >     guests running, the new kernel cannot use TDX because it's extremely
> >     hard for the old kernel to pass all TDX private pages to the new
> >     kernel.
> > 
> > Given that, this series doesn't support TDX after kexec() (except the
> > old kernel doesn't attempt to initialize TDX at all).
> > 
> > And this series doesn't shut down TDX module but leaves it open during
> > kexec().  It is because shutting down TDX module requires CPU being in
> > VMX operation but there's no guarantee of this during kexec().  Leaving
> > the TDX module open is not the best case, but it is OK since the new
> > kernel won't be able to use TDX anyway (therefore TDX module won't run
> > at all).
> 
> tl;dr: kexec() doesn't work with this code.
> 
> Right?
> 
> That doesn't seem good.

It can work in my understanding.  We just need to flush cache before booting to
the new kernel.


-- 
Thanks,
-Kai



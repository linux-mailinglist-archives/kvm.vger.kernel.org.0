Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839DF60F784
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 14:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbiJ0MiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 08:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbiJ0MiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 08:38:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064BD159D60;
        Thu, 27 Oct 2022 05:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666874292; x=1698410292;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7yS5QwXjXqGZIgDaLaYP5yoHgSu+Y+2m+z2a/jBQ0ko=;
  b=PLSXLpBlfeX3l6ID+dOWYAQOEOHA8oY7QABzKFr6YbQVxrtpHMJtoG72
   leUBtRp4ehpLGVTXpKK98KdkgxxjMEEv6fvptia8YBxXa8VjHSAfTUXMl
   iBlPZj3RJoVDB59p8xUgHWWoNjwSLWgE+83CT9FK66qcqWznXzYxwpD+l
   gnS/O20+Nt0wbrlM/UwYXuKnQ0BQQ8WGyapt0q4TbtkktUXAyxk2LXR9W
   nHf8hLNVy05U6B7sSNkk/7k1GkEFV0R77gO3E0lYGvXRwcPwKCCYU5E+Z
   GVXKMUsv7xgGSGnIkQ/D416EL4Vyis1ckWw5cw3EGgDppEucFtEACjHUb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="372422778"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="372422778"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:38:11 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="665664496"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="665664496"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.251.5.115]) ([10.251.5.115])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:38:10 -0700
Message-ID: <b210d6f3-868c-9711-7703-1363dcd9269f@linux.intel.com>
Date:   Thu, 27 Oct 2022 05:38:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v6 21/21] Documentation/x86: Add documentation for TDX
 host support
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <a3783eb87c0b3e652938dfd8714ed2fe93989c76.1666824663.git.kai.huang@intel.com>
From:   Andi Kleen <ak@linux.intel.com>
In-Reply-To: <a3783eb87c0b3e652938dfd8714ed2fe93989c76.1666824663.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/26/2022 4:16 PM, Kai Huang wrote:
> Add documentation for TDX host kernel support.  There is already one
> file Documentation/x86/tdx.rst containing documentation for TDX guest
> internals.  Also reuse it for TDX host kernel support.
>
> Introduce a new level menu "TDX Guest Support" and move existing
> materials under it, and add a new menu for TDX host kernel support.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   Documentation/x86/tdx.rst | 209 ++++++++++++++++++++++++++++++++++++--
>   1 file changed, 198 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
> index b8fa4329e1a5..59481dbe64b2 100644
> --- a/Documentation/x86/tdx.rst
> +++ b/Documentation/x86/tdx.rst
> @@ -10,6 +10,193 @@ encrypting the guest memory. In TDX, a special module running in a special
>   mode sits between the host and the guest and manages the guest/host
>   separation.
>   
> +TDX Host Kernel Support
> +=======================
> +
> +TDX introduces a new CPU mode called Secure Arbitration Mode (SEAM) and
> +a new isolated range pointed by the SEAM Ranger Register (SEAMRR).  A
> +CPU-attested software module called 'the TDX module' runs inside the new
> +isolated range to provide the functionalities to manage and run protected
> +VMs.
> +
> +TDX also leverages Intel Multi-Key Total Memory Encryption (MKTME) to
> +provide crypto-protection to the VMs.  TDX reserves part of MKTME KeyIDs
> +as TDX private KeyIDs, which are only accessible within the SEAM mode.
> +BIOS is responsible for partitioning legacy MKTME KeyIDs and TDX KeyIDs.
> +
> +Before the TDX module can be used to create and run protected VMs, it
> +must be loaded into the isolated range and properly initialized.  The TDX
> +architecture doesn't require the BIOS to load the TDX module, but the
> +kernel assumes it is loaded by the BIOS.
> +
> +TDX boot-time detection
> +-----------------------
> +
> +The kernel detects TDX by detecting TDX private KeyIDs during kernel
> +boot.  Below dmesg shows when TDX is enabled by BIOS::
> +
> +  [..] tdx: TDX enabled by BIOS. TDX private KeyID range: [16, 64).
> +
> +TDX module detection and initialization
> +---------------------------------------
> +
> +There is no CPUID or MSR to detect the TDX module.  The kernel detects it
> +by initializing it.
> +
> +The kernel talks to the TDX module via the new SEAMCALL instruction.  The
> +TDX module implements SEAMCALL leaf functions to allow the kernel to
> +initialize it.
> +
> +Initializing the TDX module consumes roughly ~1/256th system RAM size to
> +use it as 'metadata' for the TDX memory.  It also takes additional CPU
> +time to initialize those metadata along with the TDX module itself.  Both
> +are not trivial.  The kernel initializes the TDX module at runtime on
> +demand.  The caller to call tdx_enable() to initialize the TDX module::
> +
> +        ret = tdx_enable();
> +        if (ret)
> +                goto no_tdx;
> +        // TDX is ready to use
> +
> +Initializing the TDX module requires all logical CPUs being online.
> +tdx_enable() internally temporarily disables CPU hotplug to prevent any
> +CPU from going offline, but the caller still needs to guarantee all
> +present CPUs are online before calling tdx_enable().
> +
> +Also, tdx_enable() requires all CPUs are already in VMX operation
> +(requirement of making SEAMCALL).  Currently, tdx_enable() doesn't handle
> +VMXON internally, but depends on the caller to guarantee that.  So far
> +KVM is the only user of TDX and KVM already handles VMXON.
> +
> +User can consult dmesg to see the presence of the TDX module, and whether
> +it has been initialized.
> +
> +If the TDX module is not loaded, dmesg shows below::
> +
> +  [..] tdx: TDX module is not loaded.
> +
> +If the TDX module is initialized successfully, dmesg shows something
> +like below::
> +
> +  [..] tdx: TDX module: attributes 0x0, vendor_id 0x8086, major_version 1, minor_version 0, build_date 20211209, build_num 160
> +  [..] tdx: 65667 pages allocated for PAMT.
> +  [..] tdx: TDX module initialized.
> +
> +If the TDX module failed to initialize, dmesg shows below::
> +
> +  [..] tdx: Failed to initialize TDX module. Shut it down.
> +
> +TDX Interaction to Other Kernel Components
> +------------------------------------------
> +
> +TDX Memory Policy
> +~~~~~~~~~~~~~~~~~
> +
> +The TDX module reports a list of "Convertible Memory Region" (CMR) to
> +indicate which memory regions are TDX-capable.  Those regions are
> +generated by BIOS and verified by the MCHECK so that they are truly
> +present during platform boot and can meet security guarantees.
> +
> +However those TDX convertible memory regions are not automatically usable
> +to the TDX module.  The kernel needs to choose all TDX-usable memory
> +regions and pass those regions to the TDX module when initializing it.
> +After TDX module is initialized, no more TDX-usable memory can be added
> +to the TDX module.
> +
> +To keep things simple, this initial implementation chooses to use all
> +boot-time present memory managed by the page allocator as TDX memory.
> +This _requires_ all boot-time present memory is TDX convertible memory,
> +which is true in practice.  If there's any boot-time memory isn't TDX
> +convertible memory (which is allowed from TDX architecture's point of
> +view), it will be caught later during TDX module initialization and the
> +initialization will fail.
> +
> +However one machine may support both TDX and non-TDX memory both at
> +machine boot time and runtime.  For example, any memory hot-added at
> +runtime cannot be TDX memory.  Also, for now NVDIMM and CXL memory are
> +not TDX memory, no matter whether they are present at machine boot time
> +or not.
> +
> +This raises a problem that, if any non-TDX memory is hot-added to the
> +system-wide memory allocation pool, a non-TDX page may be allocated to a
> +TDX guest, which will result in failing to create the TDX guest, or
> +killing it at runtime.
> +
> +The current implementation doesn't explicitly prevent adding any non-TDX
> +memory to system-wide memory pool, but depends on the machine owner to
> +make sure such operation won't happen.  For example, the machine owner
> +should never plug any NVDIMM or CXL memory to the machine, or use kmem
> +driver to hot-add any to the core-mm.


I assume that will be fixed in some form, so doesn't need to be in the 
documentation.


> +
> +To keep things simple, this series doesn't handle memory hotplug at all,
> +but depends on the machine owner to not do any memory hotplug operation.
> +For example, the machine owner should not plug any NVDIMM or CXL memory
> +into the machine, or use kmem driver to plug NVDIMM or CXL memory to the
> +core-mm.


Dito. Documentation/* shouldn't contain temporary things like a commit log.



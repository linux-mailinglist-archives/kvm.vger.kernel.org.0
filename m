Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48396111EA
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 14:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJ1MwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 08:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ1MwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 08:52:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D671D29B8;
        Fri, 28 Oct 2022 05:52:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so9739964pji.1;
        Fri, 28 Oct 2022 05:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qACTjt+Z4GkpUaDSye8ybyfRVwtZ7GFRiDcfSTC5Aek=;
        b=YOLq7wUuIpomC7yqsOY+xd++i3T7YeWHZhiFG/Cx0zYCkJwNenU5/qzZa6/xxjMHVy
         vjT0L3b3BLL+/EincBPRtzTS1w6OBSlVALDliwi6DIZqShxcH4UMsWg313smREGFOQXi
         viNjPo5yfLAGJKv10u6+2oPvsAMpvQ5hCuNSVkmN9QJoyUYYIphlQWYVM5X1t69mkvN8
         tZvCT5naIiPUYaMCJ1qDU2CfLkRA7ATMPnpibBBJcLlybOsHx2jp19vGZLnBTw7EcPq0
         hunJ3r90UVPTcfv1ApVJW+3SeVrOmfGA4GOZ5AJxMCfmQgIiARVhoIMsCA5PqWN/+mWY
         OTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qACTjt+Z4GkpUaDSye8ybyfRVwtZ7GFRiDcfSTC5Aek=;
        b=DOq1Xx17rVvh2UtymfZzHeeavPmQmjETe45tR3yksiKQCdTCVQ2gQ9+giwsfeGRHDX
         kafaIbMJxAvGDzsJmNMFLpi6jjVvuUw9+ol/RWctsvvJA39o7gw3xt6HzsdyUiri/Rth
         2kKVE5708DAmH0XmrAZ8Jt/k7tcCeFoyhg5MAZGluX8xF0Ebn2WuXMogNzQyd5sssqP2
         TV/OtCM0T4UfHGVVyEl2aJAO4DDeDg3HtMcJEa9dODk9NIdTXZAqXmdJsEhoDat8Q0r6
         I+yspSBEhb+Z0u11GmzmuP3KzNPhSyPgRORiYTlE6XFZE4OCnRdMHqjVt1P65ikQHXfv
         Gx3A==
X-Gm-Message-State: ACrzQf3re+OI7KfWARtd7JHNbmmJdAluYhuwWf700Mbv033+Ex7Cyycm
        JK7hqgGmmmUcVdOaoynq2qI=
X-Google-Smtp-Source: AMsMyM4vhQOYV+I0Zb4wZ4NmkT4/lyEwsk/G2SjR7XNg66JJkIqCiuodMchXQC4AP35oW+SnZhw4Tg==
X-Received: by 2002:a17:902:ce0e:b0:17d:a730:3835 with SMTP id k14-20020a170902ce0e00b0017da7303835mr57267273plg.131.1666961531522;
        Fri, 28 Oct 2022 05:52:11 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id a15-20020aa795af000000b0056c08c87196sm2821209pfk.48.2022.10.28.05.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 05:52:10 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7A30C10411D; Fri, 28 Oct 2022 19:52:07 +0700 (WIB)
Date:   Fri, 28 Oct 2022 19:52:07 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, sagis@google.com,
        imammedo@redhat.com
Subject: Re: [PATCH v6 21/21] Documentation/x86: Add documentation for TDX
 host support
Message-ID: <Y1vQd+HGhfxkHQrz@debian.me>
References: <cover.1666824663.git.kai.huang@intel.com>
 <a3783eb87c0b3e652938dfd8714ed2fe93989c76.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XFx0h94zd/aVLhpR"
Content-Disposition: inline
In-Reply-To: <a3783eb87c0b3e652938dfd8714ed2fe93989c76.1666824663.git.kai.huang@intel.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--XFx0h94zd/aVLhpR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2022 at 12:16:20PM +1300, Kai Huang wrote:
> diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
> index b8fa4329e1a5..59481dbe64b2 100644
> --- a/Documentation/x86/tdx.rst
> +++ b/Documentation/x86/tdx.rst
> @@ -10,6 +10,193 @@ encrypting the guest memory. In TDX, a special module=
 running in a special
>  mode sits between the host and the guest and manages the guest/host
>  separation.
> =20
> +TDX Host Kernel Support
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> +        ret =3D tdx_enable();
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
> +  [..] tdx: TDX module: attributes 0x0, vendor_id 0x8086, major_version =
1, minor_version 0, build_date 20211209, build_num 160
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
> +
> +This will be enhanced in the future.  One solution is the kernel can be
> +enforced to always guarantee all pages in the page allocator are TDX
> +memory (i.e. by rejecting non-TDX memory in memory hotplug).  Another
> +option is the kernel may support different memory capabilities on basis
> +of NUMA node.  For example, the kernel can have both TDX-compatible NUMA
> +node and non-TDX-compatible memory NUMA node, and the userspace needs to
> +explicitly bind TDX guests to those TDX-compatible memory NUMA nodes.
> +
> +CPU Hotplug
> +~~~~~~~~~~~
> +
> +TDX doesn't support physical (ACPI) CPU hotplug.  During machine boot,
> +TDX verifies all boot-time present logical CPUs are TDX compatible before
> +enabling TDX.  A non-buggy BIOS should never support hot-add/removal of
> +physical CPU.  Currently the kernel doesn't handle physical CPU hotplug,
> +but depends on the BIOS to behave correctly.
> +
> +Note TDX works with CPU logical online/offline, thus the kernel still
> +allows to offline logical CPU and online it again.
> +
> +Memory Hotplug
> +~~~~~~~~~~~~~~
> +
> +TDX doesn't support ACPI memory hotplug of convertible memory.  The list
> +of "Convertible Memory Regions" (CMR) is static during machine's runtime.
> +TDX also assumes convertible memory won't be hot-removed.  A non-buggy
> +BIOS should never support physical hot-removal of convertible memory.
> +Currently the kernel doesn't handle hot-removal of convertible memory but
> +depends on the BIOS to behave correctly.
> +
> +It's possible that one machine can have both TDX and non-TDX memory.
> +Specifically, all hot-added physical memory are not TDX convertible
> +memory.  Also, for now NVDIMM and CXL memory are not TDX convertible
> +memory, no matter whether they are physically present during boot or not.
> +
> +Plug non-TDX memory to the page allocator could result in failing to
> +create a TDX guest, or killing a running TDX guest.
> +
> +To keep things simple, this series doesn't handle memory hotplug at all,
> +but depends on the machine owner to not do any memory hotplug operation.
> +For example, the machine owner should not plug any NVDIMM or CXL memory
> +into the machine, or use kmem driver to plug NVDIMM or CXL memory to the
> +core-mm.
> +
> +Kexec()
> +~~~~~~~
> +
> +TDX (and MKTME) doesn't guarantee cache coherency among different KeyIDs.
> +If the TDX module is ever initialized, the kernel needs to flush dirty
> +cachelines associated with any TDX private KeyID, otherwise they may
> +slightly corrupt the new kernel.
> +
> +Similar to SME support, the kernel uses wbinvd() to flush cache in
> +stop_this_cpu().
> +
> +The current TDX module architecture doesn't play nicely with kexec().
> +The TDX module can only be initialized once during its lifetime, and
> +there is no SEAMCALL to reset the module to give a new clean slate to
> +the new kernel.  Therefore, ideally, if the module is ever initialized,
> +it's better to shut down the module.  The new kernel won't be able to
> +use TDX anyway (as it needs to go through the TDX module initialization
> +process which will fail immediately at the first step).
> +
> +However, there's no guarantee CPU is in VMX operation during kexec(), so
> +it's impractical to shut down the module.  Currently, the kernel just
> +leaves the module in open state.
> +
> +TDX Guest Support
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  Since the host cannot directly access guest registers or memory, much
>  normal functionality of a hypervisor must be moved into the guest. This =
is
>  implemented using a Virtualization Exception (#VE) that is handled by the
> @@ -20,7 +207,7 @@ TDX includes new hypercall-like mechanisms for communi=
cating from the
>  guest to the hypervisor or the TDX module.
> =20
>  New TDX Exceptions
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +------------------
> =20
>  TDX guests behave differently from bare-metal and traditional VMX guests.
>  In TDX guests, otherwise normal instructions or memory accesses can cause
> @@ -30,7 +217,7 @@ Instructions marked with an '*' conditionally cause ex=
ceptions.  The
>  details for these instructions are discussed below.
> =20
>  Instruction-based #VE
> ----------------------
> +~~~~~~~~~~~~~~~~~~~~~
> =20
>  - Port I/O (INS, OUTS, IN, OUT)
>  - HLT
> @@ -41,7 +228,7 @@ Instruction-based #VE
>  - CPUID*
> =20
>  Instruction-based #GP
> ----------------------
> +~~~~~~~~~~~~~~~~~~~~~
> =20
>  - All VMX instructions: INVEPT, INVVPID, VMCLEAR, VMFUNC, VMLAUNCH,
>    VMPTRLD, VMPTRST, VMREAD, VMRESUME, VMWRITE, VMXOFF, VMXON
> @@ -52,7 +239,7 @@ Instruction-based #GP
>  - RDMSR*,WRMSR*
> =20
>  RDMSR/WRMSR Behavior
> ---------------------
> +~~~~~~~~~~~~~~~~~~~~
> =20
>  MSR access behavior falls into three categories:
> =20
> @@ -73,7 +260,7 @@ trapping and handling in the TDX module.  Other than p=
ossibly being slow,
>  these MSRs appear to function just as they would on bare metal.
> =20
>  CPUID Behavior
> ---------------
> +~~~~~~~~~~~~~~
> =20
>  For some CPUID leaves and sub-leaves, the virtualized bit fields of CPUID
>  return values (in guest EAX/EBX/ECX/EDX) are configurable by the
> @@ -93,7 +280,7 @@ not know how to handle. The guest kernel may ask the h=
ypervisor for the
>  value with a hypercall.
> =20
>  #VE on Memory Accesses
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +----------------------
> =20
>  There are essentially two classes of TDX memory: private and shared.
>  Private memory receives full TDX protections.  Its content is protected
> @@ -107,7 +294,7 @@ entries.  This helps ensure that a guest does not pla=
ce sensitive
>  information in shared memory, exposing it to the untrusted hypervisor.
> =20
>  #VE on Shared Memory
> ---------------------
> +~~~~~~~~~~~~~~~~~~~~
> =20
>  Access to shared mappings can cause a #VE.  The hypervisor ultimately
>  controls whether a shared memory access causes a #VE, so the guest must =
be
> @@ -127,7 +314,7 @@ be careful not to access device MMIO regions unless i=
t is also prepared to
>  handle a #VE.
> =20
>  #VE on Private Pages
> ---------------------
> +~~~~~~~~~~~~~~~~~~~~
> =20
>  An access to private mappings can also cause a #VE.  Since all kernel
>  memory is also private memory, the kernel might theoretically need to
> @@ -145,7 +332,7 @@ The hypervisor is permitted to unilaterally move acce=
pted pages to a
>  to handle the exception.
> =20
>  Linux #VE handler
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +-----------------
> =20
>  Just like page faults or #GP's, #VE exceptions can be either handled or =
be
>  fatal.  Typically, an unhandled userspace #VE results in a SIGSEGV.
> @@ -167,7 +354,7 @@ While the block is in place, any #VE is elevated to a=
 double fault (#DF)
>  which is not recoverable.
> =20
>  MMIO handling
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +-------------
> =20
>  In non-TDX VMs, MMIO is usually implemented by giving a guest access to a
>  mapping which will cause a VMEXIT on access, and then the hypervisor
> @@ -189,7 +376,7 @@ MMIO access via other means (like structure overlays)=
 may result in an
>  oops.
> =20
>  Shared Memory Conversions
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +-------------------------
> =20
>  All TDX guest memory starts out as private at boot.  This memory can not
>  be accessed by the hypervisor.  However, some kernel users like device

No new htmldocs warnings but I think the wording can be better:

---- >8 ----

diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index 59481dbe64b22a..5da707e2f83baa 100644
--- a/Documentation/x86/tdx.rst
+++ b/Documentation/x86/tdx.rst
@@ -26,8 +26,8 @@ BIOS is responsible for partitioning legacy MKTME KeyIDs =
and TDX KeyIDs.
=20
 Before the TDX module can be used to create and run protected VMs, it
 must be loaded into the isolated range and properly initialized.  The TDX
-architecture doesn't require the BIOS to load the TDX module, but the
-kernel assumes it is loaded by the BIOS.
+architecture doesn't require the BIOS to load the TDX module, however the
+kernel assumes that it is loaded by the BIOS.
=20
 TDX boot-time detection
 -----------------------
@@ -40,49 +40,47 @@ boot.  Below dmesg shows when TDX is enabled by BIOS::
 TDX module detection and initialization
 ---------------------------------------
=20
-There is no CPUID or MSR to detect the TDX module.  The kernel detects it
-by initializing it.
+There is no CPUID or MSR to detect the TDX module. Instead, the kernel det=
ects
+the module by initializing it.
=20
-The kernel talks to the TDX module via the new SEAMCALL instruction.  The
-TDX module implements SEAMCALL leaf functions to allow the kernel to
-initialize it.
+The kernel talks to the module via the new SEAMCALL instruction.  The modu=
le
+implements SEAMCALL leaf functions to allow the kernel to initialize it.
=20
-Initializing the TDX module consumes roughly ~1/256th system RAM size to
+Initializing the module consumes roughly ~1/256th system RAM size to
 use it as 'metadata' for the TDX memory.  It also takes additional CPU
 time to initialize those metadata along with the TDX module itself.  Both
-are not trivial.  The kernel initializes the TDX module at runtime on
-demand.  The caller to call tdx_enable() to initialize the TDX module::
+resource usages are not trivial.  The kernel initializes the TDX module at
+runtime on demand. The caller calls tdx_enable() to initialize the module::
=20
         ret =3D tdx_enable();
         if (ret)
                 goto no_tdx;
         // TDX is ready to use
=20
-Initializing the TDX module requires all logical CPUs being online.
-tdx_enable() internally temporarily disables CPU hotplug to prevent any
-CPU from going offline, but the caller still needs to guarantee all
-present CPUs are online before calling tdx_enable().
+Initializing the module requires all logical CPUs being online. tdx_enable=
()
+internally temporarily disables CPU hotplug to prevent any CPU from going
+offline, but the caller still needs to guarantee all present CPUs are onli=
ne
+before calling tdx_enable().
=20
 Also, tdx_enable() requires all CPUs are already in VMX operation
 (requirement of making SEAMCALL).  Currently, tdx_enable() doesn't handle
 VMXON internally, but depends on the caller to guarantee that.  So far
 KVM is the only user of TDX and KVM already handles VMXON.
=20
-User can consult dmesg to see the presence of the TDX module, and whether
-it has been initialized.
+User can consult dmesg to see the module presence and initialization statu=
s.
=20
-If the TDX module is not loaded, dmesg shows below::
+If the module is not loaded, dmesg shows below::
=20
   [..] tdx: TDX module is not loaded.
=20
-If the TDX module is initialized successfully, dmesg shows something
+If the module is initialized successfully, dmesg shows something
 like below::
=20
   [..] tdx: TDX module: attributes 0x0, vendor_id 0x8086, major_version 1,=
 minor_version 0, build_date 20211209, build_num 160
   [..] tdx: 65667 pages allocated for PAMT.
   [..] tdx: TDX module initialized.
=20
-If the TDX module failed to initialize, dmesg shows below::
+If the module fails to initialize, dmesg shows below::
=20
   [..] tdx: Failed to initialize TDX module. Shut it down.
=20
@@ -98,17 +96,16 @@ generated by BIOS and verified by the MCHECK so that th=
ey are truly
 present during platform boot and can meet security guarantees.
=20
 However those TDX convertible memory regions are not automatically usable
-to the TDX module.  The kernel needs to choose all TDX-usable memory
-regions and pass those regions to the TDX module when initializing it.
-After TDX module is initialized, no more TDX-usable memory can be added
-to the TDX module.
+to the module. The kernel needs to choose all TDX-usable memory regions and
+pass these to the TDX module when initializing it. After the module is
+initialized, no more TDX-usable memory can be added to the module.
=20
 To keep things simple, this initial implementation chooses to use all
 boot-time present memory managed by the page allocator as TDX memory.
 This _requires_ all boot-time present memory is TDX convertible memory,
-which is true in practice.  If there's any boot-time memory isn't TDX
+which is true in practice.  If there's any boot-time memory that isn't TDX
 convertible memory (which is allowed from TDX architecture's point of
-view), it will be caught later during TDX module initialization and the
+view), it will be caught later during the module initialization and the
 initialization will fail.
=20
 However one machine may support both TDX and non-TDX memory both at
@@ -119,58 +116,57 @@ or not.
=20
 This raises a problem that, if any non-TDX memory is hot-added to the
 system-wide memory allocation pool, a non-TDX page may be allocated to a
-TDX guest, which will result in failing to create the TDX guest, or
-killing it at runtime.
+TDX guest, which will result in failing to create the guest, or killing it
+at runtime.
=20
 The current implementation doesn't explicitly prevent adding any non-TDX
-memory to system-wide memory pool, but depends on the machine owner to
-make sure such operation won't happen.  For example, the machine owner
-should never plug any NVDIMM or CXL memory to the machine, or use kmem
-driver to hot-add any to the core-mm.
+memory to system-wide memory pool, but depends on administrators to
+make sure such operation are prevented.  For example, they should never
+plug any NVDIMM or CXL memory to the machine, or use kmem driver to
+hot-add these to the core-mm.
=20
 This will be enhanced in the future.  One solution is the kernel can be
 enforced to always guarantee all pages in the page allocator are TDX
 memory (i.e. by rejecting non-TDX memory in memory hotplug).  Another
-option is the kernel may support different memory capabilities on basis
-of NUMA node.  For example, the kernel can have both TDX-compatible NUMA
-node and non-TDX-compatible memory NUMA node, and the userspace needs to
-explicitly bind TDX guests to those TDX-compatible memory NUMA nodes.
+option is the kernel may support different memory capabilities per NUMA no=
de.=20
+For example, the kernel can have both TDX-compatible NUMA node and
+non-TDX-compatible counterpart, in which the userspace needs to explicitly
+bind TDX guests to the former.
=20
 CPU Hotplug
 ~~~~~~~~~~~
=20
 TDX doesn't support physical (ACPI) CPU hotplug.  During machine boot,
-TDX verifies all boot-time present logical CPUs are TDX compatible before
-enabling TDX.  A non-buggy BIOS should never support hot-add/removal of
+it verifies all boot-time present logical CPUs are TDX compatible before
+being enabled.  A non-buggy BIOS should never support hot-add/removal of
 physical CPU.  Currently the kernel doesn't handle physical CPU hotplug,
-but depends on the BIOS to behave correctly.
+but assumes that BIOS behaves correctly.
=20
-Note TDX works with CPU logical online/offline, thus the kernel still
-allows to offline logical CPU and online it again.
+Note that TDX works with logical CPU onlining/offlining, thus the kernel
+still allows to switch the logical CPU online or offline.
=20
 Memory Hotplug
 ~~~~~~~~~~~~~~
=20
 TDX doesn't support ACPI memory hotplug of convertible memory.  The list
 of "Convertible Memory Regions" (CMR) is static during machine's runtime.
-TDX also assumes convertible memory won't be hot-removed.  A non-buggy
+It also assumes that convertible memory won't be hot-removed.  A non-buggy
 BIOS should never support physical hot-removal of convertible memory.
-Currently the kernel doesn't handle hot-removal of convertible memory but
-depends on the BIOS to behave correctly.
+Currently the kernel that hot-removal but assumes that BIOS behaves
+correctly.
=20
 It's possible that one machine can have both TDX and non-TDX memory.
 Specifically, all hot-added physical memory are not TDX convertible
 memory.  Also, for now NVDIMM and CXL memory are not TDX convertible
 memory, no matter whether they are physically present during boot or not.
=20
-Plug non-TDX memory to the page allocator could result in failing to
-create a TDX guest, or killing a running TDX guest.
+Plugging in non-TDX memory to the page allocator could result in failing
+to create a TDX guest, or killing a running one.
=20
 To keep things simple, this series doesn't handle memory hotplug at all,
-but depends on the machine owner to not do any memory hotplug operation.
-For example, the machine owner should not plug any NVDIMM or CXL memory
-into the machine, or use kmem driver to plug NVDIMM or CXL memory to the
-core-mm.
+but depends on administrators to not doing that. For example, they should
+not plug any NVDIMM or CXL memory into the machine, or use kmem driver to
+plug it to the core-mm.
=20
 Kexec()
 ~~~~~~~
@@ -183,17 +179,17 @@ slightly corrupt the new kernel.
 Similar to SME support, the kernel uses wbinvd() to flush cache in
 stop_this_cpu().
=20
-The current TDX module architecture doesn't play nicely with kexec().
-The TDX module can only be initialized once during its lifetime, and
-there is no SEAMCALL to reset the module to give a new clean slate to
+The current module architecture doesn't play nicely with kexec(). The
+module can only be initialized once during its lifetime, and there is no
+SEAMCALL to reset the module to give a new clean slate to
 the new kernel.  Therefore, ideally, if the module is ever initialized,
-it's better to shut down the module.  The new kernel won't be able to
-use TDX anyway (as it needs to go through the TDX module initialization
-process which will fail immediately at the first step).
+it's better to remove the module.  The new kernel won't be able to
+use TDX anyway (as it needs to go through the module initialization
+process again).
=20
 However, there's no guarantee CPU is in VMX operation during kexec(), so
-it's impractical to shut down the module.  Currently, the kernel just
-leaves the module in open state.
+it's impractical to remove the module (reboot is required). Currently,
+the kernel just leaves the module in open state.
=20
 TDX Guest Support
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -201,7 +197,7 @@ Since the host cannot directly access guest registers o=
r memory, much
 normal functionality of a hypervisor must be moved into the guest. This is
 implemented using a Virtualization Exception (#VE) that is handled by the
 guest kernel. A #VE is handled entirely inside the guest kernel, but some
-require the hypervisor to be consulted.
+require hypervisor assist.
=20
 TDX includes new hypercall-like mechanisms for communicating from the
 guest to the hypervisor or the TDX module.
@@ -252,7 +248,7 @@ indicates a bug in the guest.  The guest may try to han=
dle the #GP with a
 hypercall but it is unlikely to succeed.
=20
 The #VE MSRs are typically able to be handled by the hypervisor.  Guests
-can make a hypercall to the hypervisor to handle the #VE.
+can make a hypercall to the hypervisor to handle them.
=20
 The "just works" MSRs do not need any special guest handling.  They might
 be implemented by directly passing through the MSR to the hardware or by
@@ -273,7 +269,7 @@ virtualization types:
 - Bit fields for which the hypervisor configures the value such that the
   guest TD either sees their native value or a value of 0.  For these bit
   fields, the hypervisor can mask off the native values, but it can not
-  turn *on* values.
+  turn *on* them.
=20
 A #VE is generated for CPUID leaves and sub-leaves that the TDX module does
 not know how to handle. The guest kernel may ask the hypervisor for the
@@ -309,9 +305,9 @@ stacks.  A good rule of thumb is that hypervisor-shared=
 memory should be
 treated the same as memory mapped to userspace.  Both the hypervisor and
 userspace are completely untrusted.
=20
-MMIO for virtual devices is implemented as shared memory.  The guest must
-be careful not to access device MMIO regions unless it is also prepared to
-handle a #VE.
+MMIO for virtual devices is implemented as shared memory. As such, the
+guest must be careful not to access device MMIO regions unless it is also
+prepared to handle a #VE.
=20
 #VE on Private Pages
 ~~~~~~~~~~~~~~~~~~~~
@@ -334,8 +330,8 @@ to handle the exception.
 Linux #VE handler
 -----------------
=20
-Just like page faults or #GP's, #VE exceptions can be either handled or be
-fatal.  Typically, an unhandled userspace #VE results in a SIGSEGV.
+Just like page faults or #GP's, #VE exceptions can be either handled or
+turned into fatal. Typically, an unhandled userspace #VE results in SIGSEG=
V.
 An unhandled kernel #VE results in an oops.
=20
 Handling nested exceptions on x86 is typically nasty business.  A #VE
@@ -345,12 +341,12 @@ feature to make it slightly less nasty.
=20
 During #VE handling, the TDX module ensures that all interrupts (including
 NMIs) are blocked.  The block remains in place until the guest makes a
-TDG.VP.VEINFO.GET TDCALL.  This allows the guest to control when interrupts
+TDG.VP.VEINFO.GET TDCALL.  This allows the guest to control when to interr=
upt
 or a new #VE can be delivered.
=20
 However, the guest kernel must still be careful to avoid potential
 #VE-triggering actions (discussed above) while this block is in place.
-While the block is in place, any #VE is elevated to a double fault (#DF)
+While this is the case, any #VE is raised to a double fault (#DF)
 which is not recoverable.
=20
 MMIO handling
@@ -359,7 +355,7 @@ MMIO handling
 In non-TDX VMs, MMIO is usually implemented by giving a guest access to a
 mapping which will cause a VMEXIT on access, and then the hypervisor
 emulates the access.  That is not possible in TDX guests because VMEXIT
-will expose the register state to the host. TDX guests don't trust the host
+will expose the register state to the host. They don't trust the host
 and can't have their state exposed to the host.
=20
 In TDX, MMIO regions typically trigger a #VE exception in the guest.  The
@@ -382,13 +378,13 @@ All TDX guest memory starts out as private at boot.  =
This memory can not
 be accessed by the hypervisor.  However, some kernel users like device
 drivers might have a need to share data with the hypervisor.  To do this,
 memory must be converted between shared and private.  This can be
-accomplished using some existing memory encryption helpers:
+accomplished using following existing memory encryption helpers:
=20
  * set_memory_decrypted() converts a range of pages to shared.
  * set_memory_encrypted() converts memory back to private.
=20
-Device drivers are the primary user of shared memory, but there's no need
-to touch every driver. DMA buffers and ioremap() do the conversions
+Device drivers are the primary user of shared memory, however there's no
+need to touch every driver. DMA buffers and ioremap() do the conversions
 automatically.
=20
 TDX uses SWIOTLB for most DMA allocations. The SWIOTLB buffer is

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--XFx0h94zd/aVLhpR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1vQcgAKCRD2uYlJVVFO
oybMAP9p+yZ54uMjPteJOfvjjkRPnqC70486ue8Hpeqgx01SgQEA3Z7PfOpHpN8A
d73Xd+kMInmKjmx98w4vV1lV3bRpWwo=
=M3qH
-----END PGP SIGNATURE-----

--XFx0h94zd/aVLhpR--

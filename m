Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE45140CC
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 05:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiD2DCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 23:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbiD2DCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 23:02:15 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7291BB09A
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 19:58:58 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id bo5so5835546pfb.4
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 19:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZMdJPf2szG7jWooabNPVXM6MEeYUwbGrZLNSWclN2LA=;
        b=moQBxhRZe4qA2k9riOgBJbbxEm04nXLW9FwhVY6asFHo5bHPxjsj4g3UVwhe4d5oJl
         mCj0Tjr3CS3rqYsyRbADS4U8M4YlL+8DQntWM02XwcbUo+UmOmnnDGEO5W++BzX/MW7t
         kYoL7RniuWg2Sc7o9N7pfCL4g76RanUxJ8wb0gmICKuhkquZovxFfiY2LvHlh/XQUdme
         uHNiDokx9eHJ3vvBoV0THW4QAXJwSugTxXEnPYy8VejJq3kpBTdevVkVNJMjwIlBZlNO
         Os9wzijKksm3nDiQQWvZjgdwrAD1031w3xAbpmSHkOyo3p+y+0c5WbaucfwCHFuJPOkO
         a9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZMdJPf2szG7jWooabNPVXM6MEeYUwbGrZLNSWclN2LA=;
        b=KmOElfXmyUjoJ55+QQ0hPryvHlg2Hiq1XcwLBKMaI5QG7ULdkfx9knN683FbbMQMRx
         oFO5BZuhA3LIOyOnNLp9Ad0oZlEehOmur/AnhXUyK01HNy1wpqwAdb3pE/4ZnQ+Mhp1m
         IEbR99I6zA6t4csYxOYrXRfwjowmuJXlHQoVdBRTntrS8SYxTJcj/RnKhrJv6ZBaYCWz
         HHs5FUhxDF8YTKP85Bi3QcrFxVeB9XW2Rhjf0Hp1BkoqAx4Tb3Bi169IVk4AXsX+MsZo
         BQ2SQlt2LLcMxj8adpHYWyltc38dRkxIII6Km4xx5w1t48zfFAJ51iuB/W+BODKTutQv
         TDHw==
X-Gm-Message-State: AOAM530qqZszyH2aWExYuPDi9pPK5Sf9dRYaSdMAX8banosuQZL9vI9u
        sOqVbVfvnBaG25cPokOEEbj7hu04X271N+7FovFysQ==
X-Google-Smtp-Source: ABdhPJynfpp1FDMlID1Fi4CPNT0GJC+7mQt3UP2y/xh9g5J1blG2Zc4OVE3BqXTw5cjIzN9QJPg/gf2nNT4eB78vzmc=
X-Received: by 2002:a63:1117:0:b0:399:2df0:7fb9 with SMTP id
 g23-20020a631117000000b003992df07fb9mr31449685pgl.40.1651201137593; Thu, 28
 Apr 2022 19:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com> <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
In-Reply-To: <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 28 Apr 2022 19:58:46 -0700
Message-ID: <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Kai Huang <kai.huang@intel.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 6:21 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Wed, 2022-04-27 at 18:01 -0700, Dan Williams wrote:
> > On Tue, Apr 26, 2022 at 1:10 PM Dave Hansen <dave.hansen@intel.com> wrote:
> > [..]
> > > > 3. Memory hotplug
> > > >
> > > > The first generation of TDX architecturally doesn't support memory
> > > > hotplug.  And the first generation of TDX-capable platforms don't support
> > > > physical memory hotplug.  Since it physically cannot happen, this series
> > > > doesn't add any check in ACPI memory hotplug code path to disable it.
> > > >
> > > > A special case of memory hotplug is adding NVDIMM as system RAM using
> >
> > Saw "NVDIMM" mentioned while browsing this, so stopped to make a comment...
> >
> > > > kmem driver.  However the first generation of TDX-capable platforms
> > > > cannot enable TDX and NVDIMM simultaneously, so in practice this cannot
> > > > happen either.
> > >
> > > What prevents this code from today's code being run on tomorrow's
> > > platforms and breaking these assumptions?
> >
> > The assumption is already broken today with NVDIMM-N. The lack of
> > DDR-T support on TDX enabled platforms has zero effect on DDR-based
> > persistent memory solutions. In other words, please describe the
> > actual software and hardware conflicts at play here, and do not make
> > the mistake of assuming that "no DDR-T support on TDX platforms" ==
> > "no NVDIMM support".
>
> Sorry I got this information from planning team or execution team I guess. I was
> told NVDIMM and TDX cannot "co-exist" on the first generation of TDX capable
> machine.  "co-exist" means they cannot be turned on simultaneously on the same
> platform.  I am also not aware NVDIMM-N, nor the difference between DDR based
> and DDR-T based persistent memory.  Could you give some more background here so
> I can take a look?

My rough understanding is that TDX makes use of metadata communicated
"on the wire" for DDR, but that infrastructure is not there for DDR-T.
However, there are plenty of DDR based NVDIMMs that use super-caps /
batteries and flash to save contents. I believe the concern for TDX is
that the kernel needs to know not use TDX accepted PMEM as PMEM
because the contents saved by the DIMM's onboard energy source are
unreadable outside of a TD.

Here is one of the links that comes up in a search for NVDIMM-N.

https://www.snia.org/educational-library/what-you-can-do-nvdimm-n-and-nvdimm-p-2019

>
> >
> > > > Another case is admin can use 'memmap' kernel command line to create
> > > > legacy PMEMs and use them as TD guest memory, or theoretically, can use
> > > > kmem driver to add them as system RAM.  To avoid having to change memory
> > > > hotplug code to prevent this from happening, this series always include
> > > > legacy PMEMs when constructing TDMRs so they are also TDX memory.
> >
> > I am not sure what you are trying to say here?
>
> We want to always make sure the memory managed by page allocator is TDX memory.

That only seems possible if the kernel is given a TDX capable physical
address map at the beginning of time.

> So if the legacy PMEMs are unconditionally configured as TDX memory, then we
> don't need to prevent them from being added as system memory via kmem driver.

I think that is too narrow of a focus.

Does a memory map exist for the physical address ranges that are TDX
capable? Please don't say EFI_MEMORY_CPU_CRYPTO, as that single bit is
ambiguous beyond the point of utility across the industry's entire
range of confidential computing memory capabilities.

One strawman would be an ACPI table with contents like:

struct acpi_protected_memory {
   struct range range;
   uuid_t platform_mem_crypto_capability;
};

With some way to map those uuids to a set of platform vendor specific
constraints and specifications. Some would be shared across
confidential computing vendors, some might be unique. Otherwise, I do
not see how you enforce the expectation of "all memory in the page
allocator is TDX capable". The other alternative is that *none* of the
memory in the page allocator is TDX capable and a special memory
allocation device is used to map memory for TDs. In either case a map
of all possible TDX memory is needed and the discussion above seems
like an incomplete / "hopeful" proposal about the memory dax_kmem, or
other sources, might online. See the CXL CEDT CFWMS (CXL Fixed Memory
Window Structure) as an example of an ACPI table that sets the
kernel's expectations about how a physical address range might be
used.

https://www.computeexpresslink.org/spec-landing

>
> >
> > > > 4. CPU hotplug
> > > >
> > > > The first generation of TDX architecturally doesn't support ACPI CPU
> > > > hotplug.  All logical cpus are enabled by BIOS in MADT table.  Also, the
> > > > first generation of TDX-capable platforms don't support ACPI CPU hotplug
> > > > either.  Since this physically cannot happen, this series doesn't add any
> > > > check in ACPI CPU hotplug code path to disable it.
> >
> > What are the actual challenges posed to TDX with respect to CPU hotplug?
>
> During the TDX module initialization, there is a step to call SEAMCALL on all
> logical cpus to initialize per-cpu TDX staff.  TDX doesn't support initializing
> the new hot-added CPUs after the initialization.  There are MCHECK/BIOS changes
> to enforce this check too I guess but I don't know details about this.

Is there an ACPI table that indicates CPU-x passed the check? Or since
the BIOS is invoked in the CPU-online path, is it trusted to suppress
those events for CPUs outside of the mcheck domain?

> > > > Also, only TDX module initialization requires all BIOS-enabled cpus are
> >
> > Please define "BIOS-enabled" cpus. There is no "BIOS-enabled" line in
> > /proc/cpuinfo for example.
>
> It means the CPUs with "enable" bit set in the MADT table.

That just indicates to the present CPUs and then a hot add event
changes the state of now present CPUs to enabled. Per above is the
BIOS responsible for rejecting those new CPUs, or is the kernel?

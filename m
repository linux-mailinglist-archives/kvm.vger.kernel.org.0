Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BD55128B3
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 03:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbiD1BZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 21:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbiD1BZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 21:25:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFD68BF02;
        Wed, 27 Apr 2022 18:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651108910; x=1682644910;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r5hrV7mZOtCpu7DBMAczG1A8dnsdM0A81gJCQHLw+9c=;
  b=MIKPzHJqS99px1iAAQ6m2CBgaWw+mZFkFMSmMWPUT9/gKhGgrbBrFLtV
   Z4qlry7Bka7CkEtXEAOH8BGZrvFZuM91rMS3SqKuxwVqIjCHVfqSAhvN8
   3biOgn7jaBdC+ZFOSHMrsrczWiXAoK3qRhltFzNbUZdn7phJV4pPpFQzi
   M99Bz/t0MS5G+bGVa0WdtmAguB2JNIMFebdkYvEhe0sY6LzHqE7VVIOnI
   rwr+VSywGTJKwQfm1VsVpc8WIqXknXpQFSvnhTXcuaTw9RrrptYNQ79Lu
   0vrKOZtX44fxMPdt1oMF5nLv2WZaRRqLlGWklLFdcn5DR3/O8F5CK+yEP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265936800"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="265936800"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 18:21:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="559328068"
Received: from rrnambia-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 18:21:44 -0700
Message-ID: <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Date:   Thu, 28 Apr 2022 13:21:42 +1200
In-Reply-To: <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
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

On Wed, 2022-04-27 at 18:01 -0700, Dan Williams wrote:
> On Tue, Apr 26, 2022 at 1:10 PM Dave Hansen <dave.hansen@intel.com> wrote:
> [..]
> > > 3. Memory hotplug
> > > 
> > > The first generation of TDX architecturally doesn't support memory
> > > hotplug.  And the first generation of TDX-capable platforms don't support
> > > physical memory hotplug.  Since it physically cannot happen, this series
> > > doesn't add any check in ACPI memory hotplug code path to disable it.
> > > 
> > > A special case of memory hotplug is adding NVDIMM as system RAM using
> 
> Saw "NVDIMM" mentioned while browsing this, so stopped to make a comment...
> 
> > > kmem driver.  However the first generation of TDX-capable platforms
> > > cannot enable TDX and NVDIMM simultaneously, so in practice this cannot
> > > happen either.
> > 
> > What prevents this code from today's code being run on tomorrow's
> > platforms and breaking these assumptions?
> 
> The assumption is already broken today with NVDIMM-N. The lack of
> DDR-T support on TDX enabled platforms has zero effect on DDR-based
> persistent memory solutions. In other words, please describe the
> actual software and hardware conflicts at play here, and do not make
> the mistake of assuming that "no DDR-T support on TDX platforms" ==
> "no NVDIMM support".

Sorry I got this information from planning team or execution team I guess. I was
told NVDIMM and TDX cannot "co-exist" on the first generation of TDX capable
machine.  "co-exist" means they cannot be turned on simultaneously on the same
platform.  I am also not aware NVDIMM-N, nor the difference between DDR based
and DDR-T based persistent memory.  Could you give some more background here so
I can take a look?

> 
> > > Another case is admin can use 'memmap' kernel command line to create
> > > legacy PMEMs and use them as TD guest memory, or theoretically, can use
> > > kmem driver to add them as system RAM.  To avoid having to change memory
> > > hotplug code to prevent this from happening, this series always include
> > > legacy PMEMs when constructing TDMRs so they are also TDX memory.
> 
> I am not sure what you are trying to say here?

We want to always make sure the memory managed by page allocator is TDX memory.
So if the legacy PMEMs are unconditionally configured as TDX memory, then we
don't need to prevent them from being added as system memory via kmem driver.

> 
> > > 4. CPU hotplug
> > > 
> > > The first generation of TDX architecturally doesn't support ACPI CPU
> > > hotplug.  All logical cpus are enabled by BIOS in MADT table.  Also, the
> > > first generation of TDX-capable platforms don't support ACPI CPU hotplug
> > > either.  Since this physically cannot happen, this series doesn't add any
> > > check in ACPI CPU hotplug code path to disable it.
> 
> What are the actual challenges posed to TDX with respect to CPU hotplug?

During the TDX module initialization, there is a step to call SEAMCALL on all
logical cpus to initialize per-cpu TDX staff.  TDX doesn't support initializing
the new hot-added CPUs after the initialization.  There are MCHECK/BIOS changes
to enforce this check too I guess but I don't know details about this.

> 
> > > Also, only TDX module initialization requires all BIOS-enabled cpus are
> 
> Please define "BIOS-enabled" cpus. There is no "BIOS-enabled" line in
> /proc/cpuinfo for example.

It means the CPUs with "enable" bit set in the MADT table.


-- 
Thanks,
-Kai



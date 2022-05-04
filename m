Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF57651B2D4
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379573AbiEDWzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350070AbiEDWy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:29 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A93532D2;
        Wed,  4 May 2022 15:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651704652; x=1683240652;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A7XFxSLvRlucze5cun1lMJ4EA0Zppv8AXe28hpjk+nQ=;
  b=eos/Qo6GspLIboRFPJy3uuZjFjNE1EDsGMcN45NyY3QET4N8cTsKMToS
   nPPiu5LHRodM0p5C3dNY0oFYp5wH5eTV9M6UnNoOBl7j0KvE4EN4DWnF3
   d7bti9h5gHxnupJpswchq/xnTAAYRJLWJ+FwqRCoVvyxNOX27/iQ451di
   2WLwocp6n2zp65Of0yQvbUg4Kz5Fu8qyZb+m0qDmdz4yvb1FFad3T4xck
   y6y1eYVnGiEctc2z5wezs6eXC76aQ3dJ/ZFbQ62V6IYr8a+H7VT3pPNhq
   4H8o3YigfkspGzDf3x4SbiqFjKd4GbEBwJ850q1AOSwogqp1Lkjb0UChM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="330907720"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="330907720"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:50:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="599744287"
Received: from karendt-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.3.218])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:50:48 -0700
Message-ID: <eb67bad8c09bd2c2c0613b864d7232cd8a941bc4.camel@intel.com>
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
Date:   Thu, 05 May 2022 10:50:46 +1200
In-Reply-To: <CAPcyv4jQ6C+vu3ALtG_3k483KYwYGB5gd_auUCeUNaJ=v4eTyQ@mail.gmail.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
         <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
         <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
         <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
         <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
         <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
         <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
         <CAPcyv4jQ6C+vu3ALtG_3k483KYwYGB5gd_auUCeUNaJ=v4eTyQ@mail.gmail.com>
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

On Wed, 2022-05-04 at 07:31 -0700, Dan Williams wrote:
> On Tue, May 3, 2022 at 4:59 PM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > On Fri, 2022-04-29 at 13:40 +1200, Kai Huang wrote:
> > > On Thu, 2022-04-28 at 12:58 +1200, Kai Huang wrote:
> > > > On Wed, 2022-04-27 at 17:50 -0700, Dave Hansen wrote:
> > > > > On 4/27/22 17:37, Kai Huang wrote:
> > > > > > On Wed, 2022-04-27 at 14:59 -0700, Dave Hansen wrote:
> > > > > > > In 5 years, if someone takes this code and runs it on Intel hardware
> > > > > > > with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?
> > > > > > 
> > > > > > I thought we could document this in the documentation saying that this code can
> > > > > > only work on TDX machines that don't have above capabilities (SPR for now).  We
> > > > > > can change the code and the documentation  when we add the support of those
> > > > > > features in the future, and update the documentation.
> > > > > > 
> > > > > > If 5 years later someone takes this code, he/she should take a look at the
> > > > > > documentation and figure out that he/she should choose a newer kernel if the
> > > > > > machine support those features.
> > > > > > 
> > > > > > I'll think about design solutions if above doesn't look good for you.
> > > > > 
> > > > > No, it doesn't look good to me.
> > > > > 
> > > > > You can't just say:
> > > > > 
> > > > >   /*
> > > > >    * This code will eat puppies if used on systems with hotplug.
> > > > >    */
> > > > > 
> > > > > and merrily await the puppy bloodbath.
> > > > > 
> > > > > If it's not compatible, then you have to *MAKE* it not compatible in a
> > > > > safe, controlled way.
> > > > > 
> > > > > > > You can't just ignore the problems because they're not present on one
> > > > > > > version of the hardware.
> > > > > 
> > > > > Please, please read this again ^^
> > > > 
> > > > OK.  I'll think about solutions and come back later.
> > > > > 
> > > 
> > > Hi Dave,
> > > 
> > > I think we have two approaches to handle memory hotplug interaction with the TDX
> > > module initialization.
> > > 
> > > The first approach is simple.  We just block memory from being added as system
> > > RAM managed by page allocator when the platform supports TDX [1]. It seems we
> > > can add some arch-specific-check to __add_memory_resource() and reject the new
> > > memory resource if platform supports TDX.  __add_memory_resource() is called by
> > > both __add_memory() and add_memory_driver_managed() so it prevents from adding
> > > NVDIMM as system RAM and normal ACPI memory hotplug [2].
> > 
> > Hi Dave,
> > 
> > Try to close how to handle memory hotplug.  Any comments to below?
> > 
> > For the first approach, I forgot to think about memory hot-remove case.  If we
> > just reject adding new memory resource when TDX is capable on the platform, then
> > if the memory is hot-removed, we won't be able to add it back.  My thinking is
> > we still want to support memory online/offline because it is purely in software
> > but has nothing to do with TDX.  But if one memory resource can be put to
> > offline, it seems we don't have any way to prevent it from being removed.
> > 
> > So if we do above, on the future platforms when memory hotplug can co-exist with
> > TDX, ACPI hot-add and kmem-hot-add memory will be prevented.  However if some
> > memory is hot-removed, it won't be able to be added back (even it is included in
> > CMR, or TDMRs after TDX module is initialized).
> > 
> > Is this behavior acceptable?  Or perhaps I have misunderstanding?
> 
> Memory online at boot uses similar kernel paths as memory-online at
> run time, so it sounds like your question is confusing physical vs
> logical remove. Consider the case of logical offline then re-online
> where the proposed TDX sanity check blocks the memory online, but then
> a new kernel is kexec'd and that kernel again trusts the memory as TD
> convertible again just because it onlines the memory in the boot path.
> For physical memory remove it seems up to the platform to block that
> if it conflicts with TDX, not for the kernel to add extra assumptions
> that logical offline / online is incompatible with TDX.

Hi Dan,

No we don't block memory online, but we block memory add.  The code I mentioned
is add_memory_resource(), while memory online code path is
memory_block_online().  Or am I wrong?

-- 
Thanks,
-Kai



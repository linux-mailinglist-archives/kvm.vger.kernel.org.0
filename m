Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4318051927D
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 01:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244421AbiEDACm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 20:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEDACk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 20:02:40 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3D91AA;
        Tue,  3 May 2022 16:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651622346; x=1683158346;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VvdDQ9N6B8BjQR7ex6UTn3y2yUJ12GYZkaDzSacm6Ik=;
  b=SSgmILqFLK7oOW4doblzja7ylwuvyGXUfbhHRnaU179sdohOGQ8LVrG/
   tQUWgIiWuBG/rV2rGc0HEoTPIRWcMRrjdNglBDiXhAR6xZcHMOUwgxJ7Q
   slszpNdI7O2+acEOuz0qp179p6r4P29mbDL+nUjaBx7yxVRwx6lU1Bn06
   dS4q76OBvyNOny1HnBqbmLzC8UQOJ3poPSXFy7gnf1DtNK+5qHBKuQ5Mw
   PscfjvQ/36g2vK60BQ/0/cl0pnkbWK9j7NOBbnW3o2osKV1sCdFPtu9Rf
   pbhot6gCWJ63qQZKMNLt0A6R+I9LUIH6P1tGxoNSR+NI68EeVGNOEyQem
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="330609754"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="330609754"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 16:59:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="599291454"
Received: from hsuhsiao-mobl2.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.61.84])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 16:59:03 -0700
Message-ID: <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
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
Date:   Wed, 04 May 2022 11:59:00 +1200
In-Reply-To: <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
         <ecf718abf864bbb2366209f00d4315ada090aedc.camel@intel.com>
         <de24ac7e-349c-e49a-70bb-31b9bc867b10@intel.com>
         <9b388f54f13b34fe684ef77603fc878952e48f87.camel@intel.com>
         <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
         <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
         <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
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

On Fri, 2022-04-29 at 13:40 +1200, Kai Huang wrote:
> On Thu, 2022-04-28 at 12:58 +1200, Kai Huang wrote:
> > On Wed, 2022-04-27 at 17:50 -0700, Dave Hansen wrote:
> > > On 4/27/22 17:37, Kai Huang wrote:
> > > > On Wed, 2022-04-27 at 14:59 -0700, Dave Hansen wrote:
> > > > > In 5 years, if someone takes this code and runs it on Intel hardware
> > > > > with memory hotplug, CPU hotplug, NVDIMMs *AND* TDX support, what happens?
> > > > 
> > > > I thought we could document this in the documentation saying that this code can
> > > > only work on TDX machines that don't have above capabilities (SPR for now).  We
> > > > can change the code and the documentation  when we add the support of those
> > > > features in the future, and update the documentation.
> > > > 
> > > > If 5 years later someone takes this code, he/she should take a look at the
> > > > documentation and figure out that he/she should choose a newer kernel if the
> > > > machine support those features.
> > > > 
> > > > I'll think about design solutions if above doesn't look good for you.
> > > 
> > > No, it doesn't look good to me.
> > > 
> > > You can't just say:
> > > 
> > > 	/*
> > > 	 * This code will eat puppies if used on systems with hotplug.
> > > 	 */
> > > 
> > > and merrily await the puppy bloodbath.
> > > 
> > > If it's not compatible, then you have to *MAKE* it not compatible in a
> > > safe, controlled way.
> > > 
> > > > > You can't just ignore the problems because they're not present on one
> > > > > version of the hardware.
> > > 
> > > Please, please read this again ^^
> > 
> > OK.  I'll think about solutions and come back later.
> > > 
> 
> Hi Dave,
> 
> I think we have two approaches to handle memory hotplug interaction with the TDX
> module initialization.  
> 
> The first approach is simple.  We just block memory from being added as system
> RAM managed by page allocator when the platform supports TDX [1]. It seems we
> can add some arch-specific-check to __add_memory_resource() and reject the new
> memory resource if platform supports TDX.  __add_memory_resource() is called by
> both __add_memory() and add_memory_driver_managed() so it prevents from adding
> NVDIMM as system RAM and normal ACPI memory hotplug [2].

Hi Dave,

Try to close how to handle memory hotplug.  Any comments to below?

For the first approach, I forgot to think about memory hot-remove case.  If we
just reject adding new memory resource when TDX is capable on the platform, then
if the memory is hot-removed, we won't be able to add it back.  My thinking is
we still want to support memory online/offline because it is purely in software
but has nothing to do with TDX.  But if one memory resource can be put to
offline, it seems we don't have any way to prevent it from being removed. 

So if we do above, on the future platforms when memory hotplug can co-exist with
TDX, ACPI hot-add and kmem-hot-add memory will be prevented.  However if some
memory is hot-removed, it won't be able to be added back (even it is included in
CMR, or TDMRs after TDX module is initialized).

Is this behavior acceptable?  Or perhaps I have misunderstanding?

The second approach will behave more nicely, but I don't know whether it is
worth to do it now.

Btw, below logic when adding a new memory resource has a minor problem, please
see below...

> 
> The second approach is relatively more complicated.  Instead of directly
> rejecting the new memory resource in __add_memory_resource(), we check whether
> the memory resource can be added based on CMR and the TDX module initialization
> status.   This is feasible as with the latest public P-SEAMLDR spec, we can get
> CMR from P-SEAMLDR SEAMCALL[3].  So we can detect P-SEAMLDR and get CMR info
> during kernel boots.  And in __add_memory_resource() we do below check:
> 
> 	tdx_init_disable();	/*similar to cpu_hotplug_disable() */
> 	if (tdx_module_initialized())
> 		// reject memory hotplug
> 	else if (new_memory_resource NOT in CMRs)
> 		// reject memory hotplug
> 	else
> 		allow memory hotplug
> 	tdx_init_enable();	/*similar to cpu_hotplug_enable() */

...

Should be:

	// prevent racing with TDX module initialization */
	tdx_init_disable();

	if (tdx_module_initialized()) {
		if (new_memory_resource in TDMRs)
			// allow memory hot-add
		else
			// reject memory hot-add
	} else if (new_memory_resource in CMR) {
		// add new memory to TDX memory so it can be
		// included into TDMRs

		// allow memory hot-add
	}
	else
		// reject memory hot-add
	
	tdx_module_enable();

And when platform doesn't TDX, always allow memory hot-add.


> 
> tdx_init_disable() temporarily disables TDX module initialization by trying to
> grab the mutex.  If the TDX module initialization is already on going, then it
> waits until it completes.
> 
> This should work better for future platforms, but would requires non-trivial
> more code as we need to add VMXON/VMXOFF support to the core-kernel to detect
> CMR using  SEAMCALL.  A side advantage is with VMXON in core-kernel we can
> shutdown the TDX module in kexec().
> 
> But for this series I think the second approach is overkill and we can choose to
> use the first simple approach?
> 
> Any suggestions?
> 
> [1] Platform supports TDX means SEAMRR is enabled, and there are at least 2 TDX
> keyIDs.  Or we can just check SEAMRR is enabled, as in practice a SEAMRR is
> enabled means the machine is TDX-capable, and for now a TDX-capable machine
> doesn't support ACPI memory hotplug.
> 
> [2] It prevents adding legacy PMEM as system RAM too but I think it's fine.  If
> user wants legacy PMEM then it is unlikely user will add it back and use as
> system RAM.  User is unlikely to use legacy PMEM as TD guest memory directly as
> TD guests is likely to use a new memfd backend which allows private page not
> accessible from usrspace, so in this way we can exclude legacy PMEM from TDMRs.
> 
> [3] Please refer to SEAMLDR.SEAMINFO SEAMCALL in latest P-SEAMLDR spec:
> https://www.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-seamldr-interface-specification.pdf
> > > > 


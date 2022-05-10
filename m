Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68D6521223
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 12:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiEJK3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 06:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238069AbiEJK3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 06:29:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDD657142;
        Tue, 10 May 2022 03:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652178316; x=1683714316;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H4Ptgv7Vg5mce1o98ZylLhiyjCmBqWKpu0PzSLtJJIY=;
  b=RtB8Qta4sOjiUtRx/kumvTaHdHOMSCdNO2Q0eMyE7v5i1N3g5uG4rIOR
   6sLKDTUZcmDXg4XezxzT22EpX5oFIrGF0IEQ63cIqGRkX5Ay+2fcK7iy/
   xb0iCApinv5+cbo324wIijukcy53YC3cbdoUEf5PSiw9QY0GIIbxC5NBS
   7WFgZv6l0sWemBAMOieAjUpkxUztzXYdoG7c0LeDTpI7iHBhqh/oLD/+I
   SWAhBATChJ9F7ffN0FPSgwEXIU2vfi+YOmvv+fhDFX6hJxNTo0VzCnwiG
   rBjuTBZyUTCAuV+wUOKfPt/SoOI0GFNqTLm+3K9NONFdKb0qcZD6Za6gK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="268170777"
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="268170777"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 03:25:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="570610794"
Received: from aadavis-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.231])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 03:25:13 -0700
Message-ID: <30c7cc075fb68a2830304e6e807023ba9df7c17b.camel@intel.com>
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
Date:   Tue, 10 May 2022 22:25:11 +1200
In-Reply-To: <c1105c62bcf8c9b9d2313d53982d1ae5d9a1cae8.camel@intel.com>
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
         <b0d1ed15d8bf99efe1c49182f4a98f4a23f61d0d.camel@intel.com>
         <CAPcyv4gfRFUdeSqQE51BKdunJvNMP_DkvthDLvX9v7=kOrN8uA@mail.gmail.com>
         <c1105c62bcf8c9b9d2313d53982d1ae5d9a1cae8.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > 
> > > > 
> > > > Consider the fact that end users can break the kernel by specifying
> > > > invalid memmap= command line options. The memory hotplug code does not
> > > > take any steps to add safety in those cases because there are already
> > > > too many ways it can go wrong. TDX is just one more corner case where
> > > > the memmap= user needs to be careful. Otherwise, it is up to the
> > > > platform firmware to make sure everything in the base memory map is
> > > > TDX capable, and then all you need is documentation about the failure
> > > > mode when extending "System RAM" beyond that baseline.
> > > 
> > > So the fact is, if we don't include legacy PMEMs into TDMRs, and don't do
> > > anything in memory hotplug, then if user does kmem-hot-add legacy PMEMs as
> > > system RAM, a live TD may eventually be killed.
> > > 
> > > If such case is a corner case that we don't need to guarantee, then even better.
> > > And we have an additional reason that those legacy PMEMs don't need to be in
> > > TDMRs.  As you suggested,  we can add some documentation to point out.
> > > 
> > > But the point we want to do some code check and prevent memory hotplug is, as
> > > Dave said, we want this piece of code to work on *ANY* TDX capable machines,
> > > including future machines which may, i.e. supports NVDIMM/CLX memory as TDX
> > > memory.  If we don't do any code check in  memory hotplug in this series, then
> > > when this code runs in future platforms, user can plug NVDIMM or CLX memory as
> > > system RAM thus break the assumption "all pages in page allocator are TDX
> > > memory", which eventually leads to live TDs being killed potentially.
> > > 
> > > Dave said we need to guarantee this code can work on *ANY* TDX machines.  Some
> > > documentation saying it only works one some platforms and you shouldn't do
> > > things on other platforms are not good enough:
> > > 
> > > https://lore.kernel.org/lkml/cover.1649219184.git.kai.huang@intel.com/T/#m6df45b6e1702bb03dcb027044a0dabf30a86e471
> > 
> > Yes, the incompatible cases cannot be ignored, but I disagree that
> > they actively need to be prevented. One way to achieve that is to
> > explicitly enumerate TDX capable memory and document how mempolicy can
> > be used to avoid killing TDs.
> 
> Hi Dan,
> 
> Thanks for feedback.
> 
> Could you elaborate what does "explicitly enumerate TDX capable memory" mean? 
> How to enumerate exactly?
> 
> And for "document how mempolicy can be used to avoid killing TDs", what
> mempolicy (and error reporting you mentioned below) are you referring to?
> 
> I skipped to reply your below your two replies as I think they are referring to
> the same "enumerate" and "mempolicy" that I am asking above.
> 
> 

Hi Dan,

I guess "explicitly enumerate TDX capable memory" means getting the Convertible
Memory Regions (CMR).  And "document how mempolicy can be used to avoid killing
TDs" means we say something like below in the documentation?

	Any non TDX capable memory hot-add will result in non TDX capable pages
	being potentially allocated to a TD, in which case a TD may fail to be
	created or a live TD may be killed at runtime.

And "error reporting" do you mean in memory hot-add code path, we check whether
the new memory resource is TDX capable, if not we print some error similar to
above message in documentation, but still allow the memory hot-add to happen?

Something like below in add_memory_resource()?

	if (platform_has_tdx() && new memory resource NOT in CMRs)
		pr_err("Hot-add non-TDX memory on TDX capable system. TD may
			fail to be created, or a live TD may be killed during
			runtime.\n");

	// allow memory hot-add anyway


I have below concerns of this approach:

1) I think we should provide a consistent service to user, that is, we either to
guarantee that TD won't be failed to be created randomly and a running TD won't
be killed during runtime, or we don't provide any TDX functionality at all.  So
I am not sure only "document how mempolicy can be use to avoid killing TDs" is
good enough.

2) Above code to check whether a new memory resource is in CMRs or not requires
the kernel to get CMRs during kernel boot.  However getting CMRs requires
calling SEAMCALL which requires kernel to support VMXON/VMXOFF.  VMXON/VMXOFF is
currently only handled by KVM.  We'd like to avoid adding VMXON/VMXOFF to core-
kernel now if not mandatory, as eventually we will very likely need to have a
reference-based approach to call VMXON/VMXOFF.  This part is explained in the
cover letter in this series.

Dave suggested for now to keep things simple, we can use "winner take all"
approach:  If TDX is initialized first, don't allow memory hotplug. If memory
hotplug happens first, don't allow TDX to be initialized.

https://lore.kernel.org/lkml/cover.1649219184.git.kai.huang@intel.com/T/#mfa6b5dcc536d8a7b78522f46ccd1230f84d52ae0

I think this is perhaps more reasonable as we are at least providing some
consistent service to user.  And in this approach we don't need to handle
VMXON/VMXOFF in core-kernel.

Comments?


-- 
Thanks,
-Kai



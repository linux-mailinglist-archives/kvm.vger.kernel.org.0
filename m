Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C0151CBF6
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 00:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386238AbiEEWSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 18:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245603AbiEEWSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 18:18:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3375EBCF;
        Thu,  5 May 2022 15:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651788880; x=1683324880;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mFfvP3xGWl8RnhECAgTN2Aa8cOCpiLLNtbGrinxJPVY=;
  b=R9B52ncIlF/TlMJA6vMBuTnhlHWIvDVZsKyBVMYRbPqFI+H4G5mi/KJn
   6YQWL/Q83rGzgzKXABqY+Rej3sMzk+gFKxfcABJlljX0qCP/4ZvyNVYGj
   RcRyvg5/nOhGJkydZ6kwhXQ9zpIFr2abDUDitjoEHie3wSbgxC1iaevOk
   oTucF8a8yBa7Fwm0XZWhlMufF3DNUy13vJtjv0/3nuBBlkgXU7LdBhC3R
   g1gLeBWjCUMmEObj6WioSQ4ORFX4GvK9SvVikzdsj0bAYt9RoXWzhe0PF
   V5jIE3oyk89ksx3CbbjLCY0vaB43s+JHR1HRulIuOqsj4A8vXva7090MG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248175097"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248175097"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 15:14:39 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="694876695"
Received: from anthienn-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.4.139])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 15:14:34 -0700
Message-ID: <cbb2ea1343079aee546fb44cd59c82f66c875d76.camel@intel.com>
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
Date:   Fri, 06 May 2022 10:14:28 +1200
In-Reply-To: <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for feedback!

On Thu, 2022-05-05 at 06:51 -0700, Dan Williams wrote:
> [ add Mike ]
> 
> 
> On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> [..]
> > 
> > Hi Dave,
> > 
> > Sorry to ping (trying to close this).
> > 
> > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > that no one should just use some random backend to run TD.
> 
> The platform will already do this, right? 
> 

In the current v3 implementation, we don't have any code to handle memory
hotplug, therefore nothing prevents people from adding legacy PMEMs as system
RAM using kmem driver.  In order to guarantee all pages managed by page
allocator are all TDX memory, the v3 implementation needs to always include
legacy PMEMs as TDX memory so that even people truly add  legacy PMEMs as system
RAM, we can still guarantee all pages in page allocator are TDX memory.

Of course, a side benefit of always including legacy PMEMs is people
theoretically can use them directly as TD guest backend, but this is just a
bonus but not something that we need to guarantee.


> I don't understand why this
> is trying to take proactive action versus documenting the error
> conditions and steps someone needs to take to avoid unconvertible
> memory. There is already the CONFIG_HMEM_REPORTING that describes
> relative performance properties between initiators and targets, it
> seems fitting to also add security properties between initiators and
> targets so someone can enumerate the numa-mempolicy that avoids
> unconvertible memory.

I don't think there's anything related to performance properties here.  The only
goal here is to make sure all pages in page allocator are TDX memory pages.

> 
> No, special casing in hotplug code paths needed.
> 
> > 
> > I think w/o needing to include legacy PMEM, it's better to get all TDX memory
> > blocks based on memblock, but not e820.  The pages managed by page allocator are
> > from memblock anyway (w/o those from memory hotplug).
> > 
> > And I also think it makes more sense to introduce 'tdx_memblock' and
> > 'tdx_memory' data structures to gather all TDX memory blocks during boot when
> > memblock is still alive.  When TDX module is initialized during runtime, TDMRs
> > can be created based on the 'struct tdx_memory' which contains all TDX memory
> > blocks we gathered based on memblock during boot.  This is also more flexible to
> > support other TDX memory from other sources such as CLX memory in the future.
> > 
> > Please let me know if you have any objection?  Thanks!
> 
> It's already the case that x86 maintains sideband structures to
> preserve memory after exiting the early memblock code. 
> 

May I ask what data structures are you referring to?

Btw, the purpose of 'tdx_memblock' and 'tdx_memory' is not only just to preserve
memblock info during boot.  It is also used to provide a common data structure
that the "constructing TDMRs" code can work on.  If you look at patch 11-14, the
logic (create TDMRs, allocate PAMTs, sets up reserved areas) around how to
construct TDMRs doesn't have hard dependency on e820.  If we construct TDMRs
based on a common 'tdx_memory' like below:

	int construct_tdmrs(struct tdx_memory *tmem, ...);

It would be much easier to support other TDX memory resources in the future.

The thing I am not sure is Dave wants to keep the code minimal (as this series
is already very big in terms of LoC) to make TDX running, and for now in
practice there's only system RAM during boot is TDX capable, so I am not sure we
should introduce those structures now.

> Mike, correct
> me if I am wrong, but adding more is less desirable than just keeping
> the memblock around?

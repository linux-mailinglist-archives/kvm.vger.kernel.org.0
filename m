Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74DF52085E
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 01:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbiEIXbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 19:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiEIXba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 19:31:30 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51478118C;
        Mon,  9 May 2022 16:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652138855; x=1683674855;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=prhLNqLk3ZELQbOpJAUzmyZtueVk5G/zEzxvEY8r+ug=;
  b=LzYVOa0I0zcsr7m68+iLi6HR1j5e7myiN5fmR9hncdMulu+lztsa2oRd
   lWcXYrnBUdTLa0ZrzmdtCxOGwnU32qHDviHDhqhmxeORIseB95njpF1uP
   TbCVjk1iCm/Nd7Fie3Mo+EyRX9zgpO6KLd2NG8CeRQiG7gt4Ru8YPm/f0
   I235JQcWBE+i8z5bPkn77iAI12yBZBWOQWYLezPOs+b9yMIrKUcIadbrl
   0WA/f4bhocGZLbiP117k1LrHrV5MDtGBScWpRKzCuxGOHks6VmLTxZMrw
   k0E+QHxRCujcSVwhdmgxEeHqyBGhF43LgJ82SJ7r2njVAWBYuzkB76Lt0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="249731016"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="249731016"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 16:27:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="602191441"
Received: from abehrenx-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.1.104])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 16:27:31 -0700
Message-ID: <7367cae9957dba0142a878531a71f9873e1d6316.camel@intel.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
From:   Kai Huang <kai.huang@intel.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
Date:   Tue, 10 May 2022 11:27:29 +1200
In-Reply-To: <YnjuFHvyGwa9yHat@kernel.org>
References: <d98ca73b-2d2d-757d-e937-acc83cfedfb0@intel.com>
         <c90a10763969077826f42be6f492e3a3e062326b.camel@intel.com>
         <fc1ca04d94ad45e79c0297719d5ef50a7c33c352.camel@intel.com>
         <664f8adeb56ba61774f3c845041f016c54e0f96e.camel@intel.com>
         <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com>
         <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
         <6bb89ca6e7346f4334f06ea293f29fd12df70fe4.camel@intel.com>
         <CAPcyv4iP3hcNNDxNdPT+iB0E4aUazfqFWwaa_dtHpVf+qKPNcQ@mail.gmail.com>
         <YnW4nTub1BYUF15W@kernel.org>
         <5c7196b517398e7697464fe997018e9031d15470.camel@intel.com>
         <YnjuFHvyGwa9yHat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > 
> > Hi Mike,
> > 
> > Thanks for feedback.
> > 
> > Perhaps I haven't put a lot details of the new TDX data structures, so let me
> > point out that the new two data structures 'struct tdx_memblock' and 'struct
> > tdx_memory' that I am proposing are mostly supposed to be used by TDX code only,
> > which is pretty standalone.  They are not supposed to be some basic
> > infrastructure that can be widely used by other random kernel components. 
> 
> We already have "pretty standalone" numa_meminfo that originally was used
> to setup NUMA memory topology, but now it's used by other code as well.
> And e820 tables also contain similar data and they are supposedly should be
> used only at boot time, but in reality there are too much callbacks into
> e820 way after the system is booted.
> 
> So any additional memory representation will only add to the overall
> complexity and well have even more "eventually consistent" collections of 
> { .start, .end, .flags } structures.
>  
> > In fact, currently the only operation we need is to allow memblock to register
> > all memory regions as TDX memory blocks when the memblock is still alive. 
> > Therefore, in fact, the new data structures can even be completely invisible to
> > other kernel components.  For instance, TDX code can provide below API w/o
> > exposing any data structures to other kernel components:
> > 
> > int tdx_add_memory_block(phys_addr_t start, phys_addr_t end, int nid);
> > 
> > And we call above API for each memory region in memblock when it is alive.
> > 
> > TDX code internally manages those memory regions via the new data structures
> > that I mentioned above, so we don't need to keep memblock after boot.  The
> > advantage of this approach is it is more flexible to support other potential TDX
> > memory resources (such as CLX memory) in the future.
> 
> Please let keep things simple. If other TDX memory resources will need
> different handling it can be implemented then. For now, just enable
> ARCH_KEEP_MEMBLOCK and use memblock to track TDX memory.
>  

Looks good to me.  Thanks for the feedback.

-- 
Thanks,
-Kai



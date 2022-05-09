Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEC451FA1A
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 12:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiEIKmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 06:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiEIKmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 06:42:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DFC205D6;
        Mon,  9 May 2022 03:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B250760FAD;
        Mon,  9 May 2022 10:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D94C385A8;
        Mon,  9 May 2022 10:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652092447;
        bh=NSHAgzSuzjtuD7Tjj9g99sthrjIGsxuDy6cZ0osNlgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KtSDi6ckvqgMOaHS+FfGqqXgAe/cl6zO47IvsmxQYfNan8YoA+cE5a3FOxZpbs0Uj
         pV7P1D2rcTpBc5iYGdFIghkPSRctl/JvAmXEjuueqMF1kH+aY45wduQIBaCkp0dBC6
         dSDExChHLMOXHczNDU6d22Yc1ttxZrUD4Fj1MFxr8xWrZhbK7DxnGwy291li+GhdQ8
         41xOkBIwDDp6uTiGZEAC1XQxEneCVuF3i+O0DJIYgINkU2jICpMpSVcE/NIN312Dq/
         HYBQz1yjC2WaMAjWQ5IZh6JHWrwmRwCZ9rPJm+n9YFUR4doi49RwB/A57IZXOMWGcV
         wwJ+uKTyUgG8g==
Date:   Mon, 9 May 2022 13:33:56 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
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
Subject: Re: [PATCH v3 00/21] TDX host kernel support
Message-ID: <YnjuFHvyGwa9yHat@kernel.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c7196b517398e7697464fe997018e9031d15470.camel@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 08, 2022 at 10:00:39PM +1200, Kai Huang wrote:
> On Fri, 2022-05-06 at 20:09 -0400, Mike Rapoport wrote:
> > On Thu, May 05, 2022 at 06:51:20AM -0700, Dan Williams wrote:
> > > [ add Mike ]
> > > 
> > > On Thu, May 5, 2022 at 2:54 AM Kai Huang <kai.huang@intel.com> wrote:
> > > [..]
> > > > 
> > > > Hi Dave,
> > > > 
> > > > Sorry to ping (trying to close this).
> > > > 
> > > > Given we don't need to consider kmem-hot-add legacy PMEM after TDX module
> > > > initialization, I think for now it's totally fine to exclude legacy PMEMs from
> > > > TDMRs.  The worst case is when someone tries to use them as TD guest backend
> > > > directly, the TD will fail to create.  IMO it's acceptable, as it is supposedly
> > > > that no one should just use some random backend to run TD.
> > > 
> > > The platform will already do this, right? I don't understand why this
> > > is trying to take proactive action versus documenting the error
> > > conditions and steps someone needs to take to avoid unconvertible
> > > memory. There is already the CONFIG_HMEM_REPORTING that describes
> > > relative performance properties between initiators and targets, it
> > > seems fitting to also add security properties between initiators and
> > > targets so someone can enumerate the numa-mempolicy that avoids
> > > unconvertible memory.
> > > 
> > > No, special casing in hotplug code paths needed.
> > > 
> > > > 
> > > > I think w/o needing to include legacy PMEM, it's better to get all TDX memory
> > > > blocks based on memblock, but not e820.  The pages managed by page allocator are
> > > > from memblock anyway (w/o those from memory hotplug).
> > > > 
> > > > And I also think it makes more sense to introduce 'tdx_memblock' and
> > > > 'tdx_memory' data structures to gather all TDX memory blocks during boot when
> > > > memblock is still alive.  When TDX module is initialized during runtime, TDMRs
> > > > can be created based on the 'struct tdx_memory' which contains all TDX memory
> > > > blocks we gathered based on memblock during boot.  This is also more flexible to
> > > > support other TDX memory from other sources such as CLX memory in the future.
> > > > 
> > > > Please let me know if you have any objection?  Thanks!
> > > 
> > > It's already the case that x86 maintains sideband structures to
> > > preserve memory after exiting the early memblock code. Mike, correct
> > > me if I am wrong, but adding more is less desirable than just keeping
> > > the memblock around?
> > 
> > TBH, I didn't read the entire thread yet, but at the first glance, keeping
> > memblock around is much more preferable that adding yet another { .start,
> > .end, .flags } data structure. To keep memblock after boot all is needed is
> > something like
> > 
> > 	select ARCH_KEEP_MEMBLOCK if INTEL_TDX_HOST
> > 
> > I'll take a closer look next week on the entire series, maybe I'm missing
> > some details.
> > 
> 
> Hi Mike,
> 
> Thanks for feedback.
> 
> Perhaps I haven't put a lot details of the new TDX data structures, so let me
> point out that the new two data structures 'struct tdx_memblock' and 'struct
> tdx_memory' that I am proposing are mostly supposed to be used by TDX code only,
> which is pretty standalone.  They are not supposed to be some basic
> infrastructure that can be widely used by other random kernel components. 

We already have "pretty standalone" numa_meminfo that originally was used
to setup NUMA memory topology, but now it's used by other code as well.
And e820 tables also contain similar data and they are supposedly should be
used only at boot time, but in reality there are too much callbacks into
e820 way after the system is booted.

So any additional memory representation will only add to the overall
complexity and well have even more "eventually consistent" collections of 
{ .start, .end, .flags } structures.
 
> In fact, currently the only operation we need is to allow memblock to register
> all memory regions as TDX memory blocks when the memblock is still alive. 
> Therefore, in fact, the new data structures can even be completely invisible to
> other kernel components.  For instance, TDX code can provide below API w/o
> exposing any data structures to other kernel components:
> 
> int tdx_add_memory_block(phys_addr_t start, phys_addr_t end, int nid);
> 
> And we call above API for each memory region in memblock when it is alive.
> 
> TDX code internally manages those memory regions via the new data structures
> that I mentioned above, so we don't need to keep memblock after boot.  The
> advantage of this approach is it is more flexible to support other potential TDX
> memory resources (such as CLX memory) in the future.

Please let keep things simple. If other TDX memory resources will need
different handling it can be implemented then. For now, just enable
ARCH_KEEP_MEMBLOCK and use memblock to track TDX memory.
 
> Otherwise, we can do as you suggested to select ARCH_KEEP_MEMBLOCK when
> INTEL_TDX_HOST is on and TDX code internally uses memblock API directly.
> 
> -- 
> Thanks,
> -Kai
> 
> 

-- 
Sincerely yours,
Mike.

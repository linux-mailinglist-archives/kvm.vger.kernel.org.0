Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F751934B
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 03:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245215AbiEDBUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 21:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343517AbiEDBTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 21:19:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70520443C8;
        Tue,  3 May 2022 18:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651626950; x=1683162950;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4CArX3XTbRLoTNtYO52vIM426MUaEvArB8gnAGDKIO8=;
  b=QV2Wg2s9MqCi7siXjxGtnk6ezDSewyaVbTkw06KiVfjOaDdOvCZzWLfK
   K6ZnH6ktUgER7zQCvu4/OQLaSYI7lcXXRB+YJPO6kokY00j+oreZFeAW9
   eQIdqcjGjbCeWg+NbJlPUFB8UP4i63kD4zVEq522etSZs+FXwvuKjDV2Y
   zduvdfdSL62yG+0Dtut9q2abW9QRf/CpNporJ4chK2nSK82ny/J/ZfWdg
   DShSe0veCUH7S7KYX8/58+GvDYlvxR6QI2DvVa9SY9ylvEdZfPY9ogZ5i
   bSX/hB8fVWuKA6ycF4hXy0vg0gAzmrqaYzAxb1+JA+fXuILe55bVYpgqz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267788149"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267788149"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 18:15:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="664237267"
Received: from hsuhsiao-mobl2.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.61.84])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 18:15:47 -0700
Message-ID: <8bf596b45f68363134f431bcc550e16a9a231b80.camel@intel.com>
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
Date:   Wed, 04 May 2022 13:15:45 +1200
In-Reply-To: <1b681365-ef98-ec78-96dc-04e28316cf0e@intel.com>
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
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-03 at 17:25 -0700, Dave Hansen wrote:
> On 5/3/22 16:59, Kai Huang wrote:
> > Should be:
> > 
> > 	// prevent racing with TDX module initialization */
> > 	tdx_init_disable();
> > 
> > 	if (tdx_module_initialized()) {
> > 		if (new_memory_resource in TDMRs)
> > 			// allow memory hot-add
> > 		else
> > 			// reject memory hot-add
> > 	} else if (new_memory_resource in CMR) {
> > 		// add new memory to TDX memory so it can be
> > 		// included into TDMRs
> > 
> > 		// allow memory hot-add
> > 	}
> > 	else
> > 		// reject memory hot-add
> > 	
> > 	tdx_module_enable();
> > 
> > And when platform doesn't TDX, always allow memory hot-add.
> 
> I don't think it even needs to be *that* complicated.
> 
> It could just be winner take all: if TDX is initialized first, don't
> allow memory hotplug.  If memory hotplug happens first, don't allow TDX
> to be initialized.
> 
> That's fine at least for a minimal patch set.

OK. This should also work.

We will need tdx_init_disable() which grabs the mutex to prevent TDX module
initialization from running concurrently, and to disable TDX module
initialization once for all.
 

> 
> What you have up above is probably where you want to go eventually, but
> it means doing things like augmenting the e820 since it's the single
> source of truth for creating the TMDRs right now.
> 

Yes.  But in this case, I am thinking about probably we should switch from
consulting e820 to consulting memblock.  The advantage of using e820 is it's
easy to include legacy PMEM as TDX memory, but the disadvantage is (as you can
see in e820_for_each_mem() loop) I am actually merging contiguous different
types of RAM entries in order to be consistent with the behavior of
e820_memblock_setup().  This is not nice.

If memory hot-add and TDX can only be one winner, legacy PMEM actually won't be
used as TDX memory anyway now.  The reason is TDX guest will very likely needing
to use the new fd-based backend (see my reply in other emails), but not just
some random backend.  To me it's totally fine to not support using legacy PMEM
directly as TD guest backend (and if we create a TD with real NVDIMM as backend
using dax, the TD cannot be created anyway).  Given we cannot kmem-hot-add
legacy PMEM back as system RAM, to me it's pointless to include legacy PMEM into
TDMRs.

In this case, we can just create TDMRs based on memblock directly.  One problem
is memblock will be gone after kernel boots, but this can be solved either by
keeping the memblock, or build the TDX memory early when memblock is still
alive.

Btw, eventually, as it's likely we need to support different source of TDX
memory (CLX memory, etc), I think eventually we will need some data structures
to represent TDX memory block and APIs to add those blocks to the whole TDX
memory so those TDX memory ranges from different source can be added before
initializing the TDX module.

	struct tdx_memblock {
		struct list_head list;
		phys_addr_t start;
		phys_addr_t end;
		int nid;
		...
	};

	struct tdx_memory {
		struct list_head tmb_list;
		...
	};

	int tdx_memory_add_memblock(start, end, nid, ...);

And the TDMRs can be created based on 'struct tdx_memory'.

For now, we only need to add memblock to TDX memory.

Any comments?

-- 
Thanks,
-Kai



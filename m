Return-Path: <kvm+bounces-1893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE1E7EEA25
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 01:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4F421F21646
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 00:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530B2652;
	Fri, 17 Nov 2023 00:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uh3ZDMaB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE89EA;
	Thu, 16 Nov 2023 16:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700179500; x=1731715500;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vCpoMe2jdL8uHEa4QpYFjqifiicTJLTeMzgEjOKcuyQ=;
  b=Uh3ZDMaBZFfBL0YjdfoXjvpRL1ALDc4zpVwYiHkjPzkKGKkFVqyBL9Jp
   ZrJpj8L7fhTuu+aHHPIphX0JZp+BnEncQOC5OLdIRh2zi2jqXaAtDHsWn
   lBIWlnCeLhHotyysS6YNCK68gXoTfQ/X+fx1UbG1uoBCrmAZlK8Ie+7kO
   Z/YPQAbCTow+1kgRQ7X2AJoInAfEhUENKprVDnxKiZOU2rArUUeToc7oG
   GgOK3K55mwWX+vIG85MBRBiZRJh/8P8SVyoOFeFo/wdxg6M6gtF7dsBGQ
   V6SEtrCadFYg1UxA24A0SEqSytPIKuJVK2RkbX3nrFIeX+BLFNY/bkRBH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="390988321"
X-IronPort-AV: E=Sophos;i="6.04,205,1695711600"; 
   d="scan'208";a="390988321"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 16:05:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="889073721"
X-IronPort-AV: E=Sophos;i="6.04,205,1695711600"; 
   d="scan'208";a="889073721"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 16:04:58 -0800
Date: Thu, 16 Nov 2023 16:04:58 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com, gkirkpatrick@google.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v17 059/116] KVM: TDX: Create initial guest memory
Message-ID: <20231117000458.GB1277973@ls.amr.corp.intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <e8fdc92439efeed0ee05f39b1cd2dc1023014c11.1699368322.git.isaku.yamahata@intel.com>
 <c9413cb8-8aae-4233-b55f-fbac91459173@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c9413cb8-8aae-4233-b55f-fbac91459173@linux.intel.com>

On Thu, Nov 16, 2023 at 02:35:33PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 11/7/2023 10:56 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Because the guest memory is protected in TDX, the creation of the initial
> > guest memory requires a dedicated TDX module API, tdh_mem_page_add, instead
> > of directly copying the memory contents into the guest memory in the case
> > of the default VM type.  KVM MMU page fault handler callback,
> > private_page_add, handles it.
> > 
> > Define new subcommand, KVM_TDX_INIT_MEM_REGION, of VM-scoped
> > KVM_MEMORY_ENCRYPT_OP.  It assigns the guest page, copies the initial
> > memory contents into the guest memory, encrypts the guest memory.  At the
> > same time, optionally it extends memory measurement of the TDX guest.  It
> > calls the KVM MMU page fault(EPT-violation) handler to trigger the
> > callbacks for it.
> > 
> > Reported-by: gkirkpatrick@google.com
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > v15 -> v16:
> > - add check if nr_pages isn't large with
> >    (nr_page << PAGE_SHIFT) >> PAGE_SHIFT
> > 
> > v14 -> v15:
> > - add a check if TD is finalized or not to tdx_init_mem_region()
> > - return -EAGAIN when partial population
> > ---
> >   arch/x86/include/uapi/asm/kvm.h       |   9 ++
> >   arch/x86/kvm/mmu/mmu.c                |   1 +
> >   arch/x86/kvm/vmx/tdx.c                | 167 +++++++++++++++++++++++++-
> >   arch/x86/kvm/vmx/tdx.h                |   2 +
> >   tools/arch/x86/include/uapi/asm/kvm.h |   9 ++
> >   5 files changed, 185 insertions(+), 3 deletions(-)
> > 
> [...]
> > +static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
> > +			     enum pg_level level, kvm_pfn_t pfn)
> 
> For me, the function name is a bit confusing.
> I would relate it to a SEPT table page instead of a normal private page if
> only by the function name.
> 
> Similar to tdx_sept_page_aug(), though it's less confusing due to there is
> no seam call to aug a sept table page.

How about tdx_mem_page_{add, aug}()?
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>


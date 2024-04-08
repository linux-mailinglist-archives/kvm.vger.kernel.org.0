Return-Path: <kvm+bounces-13932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCD2789CEEF
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 570C21F236B0
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7D5148854;
	Mon,  8 Apr 2024 23:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQvSTHAr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CF1171B0;
	Mon,  8 Apr 2024 23:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712618926; cv=none; b=F/0srf/PTCgXlVSbE5ZDlnDQMbAEsy8Sees0jgPmf3XB+oLG6k+oUseWTjkIzIOvFtrx1LGl3QC22w5MvLTabAL+pMBispFNA+4z8zC5NJFtXI0v5VCgvHVrqOD5T59oiJgo7+DMgu/DPJ/PMY2RCKS7Uh0rczbQlk7uHTfr2Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712618926; c=relaxed/simple;
	bh=K69mSg4Q2UMBAOgrSeKGYQMKDq1NHnlIbV87U1U9Jj0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fBwK3jhcEhXLVSeyOvvU5BQ+V1C0OKN0ei6FFOpWxgOe9TNtlEqNtnsGFbNUBVXqv57aWbPdXeYOk9ElED0E8YEWhCgbDqmVHHxV7WpHLAZef7b4tsIRUrhwPVuTYhg2RLHHM2sSrUmyi46+92PEslQcMKKo8oiMNunmLPxUZgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQvSTHAr; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712618924; x=1744154924;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K69mSg4Q2UMBAOgrSeKGYQMKDq1NHnlIbV87U1U9Jj0=;
  b=IQvSTHAr3ebA4BwWWkoo0Spk/+geENTQ06MUuPOTltwWk3/TK21ErygG
   E/hcbmPhUkEQSI1oNLAiHY/qiACHGUn4zGALary43OiupK3ArnphMg4ib
   rNOgMStvJNRoqOmgvP05BiASyhCsY6wwABPNQqas0usCkrdeYVDxlOnhp
   7bEt0rjQPL/oyrPsTSzP8fdM9OMLXB146QyRpMnGsay9DD9TEid63wqJm
   r/wVPwIx4Ke7YMTza7esKEGztq12llJ7Hw8p3kXopuVVuxjgyz0sEwbhN
   93GQ7n+p2lc9trRaYKlQDhNNbUaBk0BgLaqXnLnAC3RKbh+9GuVv8Qgec
   w==;
X-CSE-ConnectionGUID: vgd+vqLDSHOBwWOZRSxfBQ==
X-CSE-MsgGUID: Q93+l0ukTgC40NutLjcznA==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="7790432"
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="7790432"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 16:28:43 -0700
X-CSE-ConnectionGUID: 6RT2yAbSTEyC1B/bT5rWYQ==
X-CSE-MsgGUID: HBafZJIBSSuzHCB6yj8LSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="24521853"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 16:28:43 -0700
Date: Mon, 8 Apr 2024 16:33:12 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
 <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jens
 Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, maz@kernel.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jim.harris@samsung.com, a.manzanares@samsung.com,
 Bjorn Helgaas <helgaas@kernel.org>, guang.zeng@intel.com,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 11/13] iommu/vt-d: Make posted MSI an opt-in cmdline
 option
Message-ID: <20240408163312.7b7f3d18@jacob-builder>
In-Reply-To: <8871e541-4991-44f3-aab7-d3a657fc59db@gmail.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-12-jacob.jun.pan@linux.intel.com>
	<8871e541-4991-44f3-aab7-d3a657fc59db@gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Robert,

On Sat, 6 Apr 2024 12:31:14 +0800, Robert Hoo <robert.hoo.linux@gmail.com>
wrote:

> On 4/6/2024 6:31 AM, Jacob Pan wrote:
> > Add a command line opt-in option for posted MSI if
> > CONFIG_X86_POSTED_MSI=y.
> > 
> > Also introduce a helper function for testing if posted MSI is supported
> > on the platform.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >   Documentation/admin-guide/kernel-parameters.txt |  1 +
> >   arch/x86/include/asm/irq_remapping.h            | 11 +++++++++++
> >   drivers/iommu/irq_remapping.c                   | 13 ++++++++++++-
> >   3 files changed, 24 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt
> > b/Documentation/admin-guide/kernel-parameters.txt index
> > bb884c14b2f6..e5fd02423c4c 100644 ---
> > a/Documentation/admin-guide/kernel-parameters.txt +++
> > b/Documentation/admin-guide/kernel-parameters.txt @@ -2251,6 +2251,7 @@
> >   			no_x2apic_optout
> >   				BIOS x2APIC opt-out request will be
> > ignored nopost	disable Interrupt Posting
> > +			posted_msi enable MSIs delivered as posted
> > interrupts 
> >   	iomem=		Disable strict checking of access to
> > MMIO memory strict	regions from userspace.
> > diff --git a/arch/x86/include/asm/irq_remapping.h
> > b/arch/x86/include/asm/irq_remapping.h index 7a2ed154a5e1..e46bde61029b
> > 100644 --- a/arch/x86/include/asm/irq_remapping.h
> > +++ b/arch/x86/include/asm/irq_remapping.h
> > @@ -50,6 +50,17 @@ static inline struct irq_domain
> > *arch_get_ir_parent_domain(void) return x86_vector_domain;
> >   }
> >   
> > +#ifdef CONFIG_X86_POSTED_MSI
> > +extern int enable_posted_msi;
> > +
> > +static inline bool posted_msi_supported(void)
> > +{
> > +	return enable_posted_msi && irq_remapping_cap(IRQ_POSTING_CAP);
> > +}  
> 
> Out of this patch set's scope, but, dropping into irq_remappping_cap(),
> I'd like to bring this change for discussion:
> 
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index 4047ac396728..ef2de9034897 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -98,7 +98,7 @@ void set_irq_remapping_broken(void)
> 
>   bool irq_remapping_cap(enum irq_remap_cap cap)
>   {
> -       if (!remap_ops || disable_irq_post)
> +       if (!remap_ops || disable_irq_remap)
>                  return false;
> 
>          return (remap_ops->capability & (1 << cap));
> 
> 
> 1. irq_remapping_cap() is to exam some cap, though at present it has only
> 1 cap, i.e. IRQ_POSTING_CAP, simply return false just because of
> disable_irq_post isn't good. Instead, IRQ_REMAP is the foundation of all
> remapping caps. 2. disable_irq_post is used by Intel iommu code only,
> here irq_remapping_cap() is common code. e.g. AMD iommu code doesn't use
> it to judge set cap of irq_post or not.
I agree, posting should be treated as a sub-capability of remapping.
IRQ_POSTING_CAP is only set when remapping is on.

We need to delete this such that posting is always off when remapping is
off.

--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1038,11 +1038,7 @@ static void disable_irq_remapping(void)
                iommu_disable_irq_remapping(iommu);
        }
 
-       /*
-        * Clear Posted-Interrupts capability.
-        */
-       if (!disable_irq_post)
-               intel_irq_remap_ops.capability &= ~(1 << IRQ_POSTING_CAP);
+       intel_irq_remap_ops.capability &= ~(1 << IRQ_POSTING_CAP);
 } 

> > +#else
> > +static inline bool posted_msi_supported(void) { return false; };
> > +#endif  
> 


Thanks,

Jacob


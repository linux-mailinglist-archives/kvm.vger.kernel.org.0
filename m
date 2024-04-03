Return-Path: <kvm+bounces-13413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1F68962A0
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 04:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D009C1C2298B
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 02:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B9A1B969;
	Wed,  3 Apr 2024 02:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SbJD14F3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253D314F70;
	Wed,  3 Apr 2024 02:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712111971; cv=none; b=Y3F3W/oGZRrghV9qlZzn3pr5/cosjOmlIhsMGK1KeNjWTxUuxnf1aj7MZsP8F67T/iUWrJ2frbkqJQfqKD4B+8pUK9oTHxT5lnaMayhtJvaVpiE2E6T2MdY3Sxk+uspoBkVyqXjI6zuxXKbFQbIgQrNLrLPS1fVkFt1mYJW039k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712111971; c=relaxed/simple;
	bh=tue9ayPeZn96trJ0JwvUsXX5dq+DjhDb0/XxC51zF/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RlM2snhygH0edYL4BGDfHCMymU73HN6b47NHeonqyOLhd+o5uJj19dyCyHPXXkpT/bllQ2X25Zu5HE+ca9S8wWidnfuM2+Eqqh4d5qFKhIgjskNuQZWZc1BdN2w29+q+ue849VLCfjW1jD635FGpuuW7L5XQyAyYjg021Avdh6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SbJD14F3; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712111970; x=1743647970;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tue9ayPeZn96trJ0JwvUsXX5dq+DjhDb0/XxC51zF/Y=;
  b=SbJD14F3bvh1L65trKLYZ5wroeeUR24r3qAAjRvsImKv+jhVcnUdBCj8
   OYw6z7gcbpYlFZJ5dc4l8C2pX0oPE462FhK+2tIBst8ZoquOEpR57dWis
   uhiVUU0J0BGsxaxAk3LnjltsWSBrrDfFNGXq3ItMBHj94V9N/H51RpPZh
   U+tkOg3f36UL6Os3h/ZZr2nCpqDhjQbngWDH6n4sPDEfTj8AGyS5M5PWe
   Po3UJsvRcueTXmWQrPf95RTPzx9q807w/X5On7nqrPMDJz8WPPcdZQBM2
   cDUXCI1aKjj3jNdmuVP4eYTsJgWZCMUmm3kJ1u5IUgnTZBpWy/18hV+0i
   Q==;
X-CSE-ConnectionGUID: 8/OR1ilwSX6QfhNMoWW/lQ==
X-CSE-MsgGUID: McQ1TGIKQIubryWynfnfkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="7220949"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="7220949"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 19:39:29 -0700
X-CSE-ConnectionGUID: CHXo6pawQSewMGVX0695hQ==
X-CSE-MsgGUID: Mp3wZMv4SGKNDxiqFqnOgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="18702761"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 19:39:29 -0700
Date: Tue, 2 Apr 2024 19:43:55 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Zeng Guang <guang.zeng@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, Thomas Gleixner <tglx@linutronix.de>, Lu Baolu
 <baolu.lu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H.
 Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 Robin Murphy <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 09/15] x86/irq: Install posted MSI notification handler
Message-ID: <20240402194355.72b2ade8@jacob-builder>
In-Reply-To: <a4f169fa-663d-4a94-878b-d783f67d48c9@intel.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
	<20240126234237.547278-10-jacob.jun.pan@linux.intel.com>
	<a4f169fa-663d-4a94-878b-d783f67d48c9@intel.com>
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

Hi Zeng,

On Fri, 29 Mar 2024 15:32:00 +0800, Zeng Guang <guang.zeng@intel.com> wrote:

> On 1/27/2024 7:42 AM, Jacob Pan wrote:
> > @@ -353,6 +360,111 @@ void intel_posted_msi_init(void)
> >   	pid->nv = POSTED_MSI_NOTIFICATION_VECTOR;
> >   	pid->ndst = this_cpu_read(x86_cpu_to_apicid);
> >   }
> > +
> > +/*
> > + * De-multiplexing posted interrupts is on the performance path, the
> > code
> > + * below is written to optimize the cache performance based on the
> > following
> > + * considerations:
> > + * 1.Posted interrupt descriptor (PID) fits in a cache line that is
> > frequently
> > + *   accessed by both CPU and IOMMU.
> > + * 2.During posted MSI processing, the CPU needs to do 64-bit read and
> > xchg
> > + *   for checking and clearing posted interrupt request (PIR), a 256
> > bit field
> > + *   within the PID.
> > + * 3.On the other side, the IOMMU does atomic swaps of the entire PID
> > cache
> > + *   line when posting interrupts and setting control bits.
> > + * 4.The CPU can access the cache line a magnitude faster than the
> > IOMMU.
> > + * 5.Each time the IOMMU does interrupt posting to the PIR will evict
> > the PID
> > + *   cache line. The cache line states after each operation are as
> > follows:
> > + *   CPU		IOMMU			PID Cache line
> > state
> > + *   ---------------------------------------------------------------
> > + *...read64					exclusive
> > + *...lock xchg64				modified
> > + *...			post/atomic swap	invalid
> > + *...-------------------------------------------------------------
> > + *
> > + * To reduce L1 data cache miss, it is important to avoid contention
> > with
> > + * IOMMU's interrupt posting/atomic swap. Therefore, a copy of PIR is
> > used
> > + * to dispatch interrupt handlers.
> > + *
> > + * In addition, the code is trying to keep the cache line state
> > consistent
> > + * as much as possible. e.g. when making a copy and clearing the PIR
> > + * (assuming non-zero PIR bits are present in the entire PIR), it does:
> > + *		read, read, read, read, xchg, xchg, xchg, xchg
> > + * instead of:
> > + *		read, xchg, read, xchg, read, xchg, read, xchg
> > + */
> > +static __always_inline inline bool handle_pending_pir(u64 *pir, struct
> > pt_regs *regs) +{
> > +	int i, vec = FIRST_EXTERNAL_VECTOR;
> > +	unsigned long pir_copy[4];
> > +	bool handled = false;
> > +
> > +	for (i = 0; i < 4; i++)
> > +		pir_copy[i] = pir[i];
> > +
> > +	for (i = 0; i < 4; i++) {
> > +		if (!pir_copy[i])
> > +			continue;
> > +
> > +		pir_copy[i] = arch_xchg(pir, 0);  
> 
> Here is a problem that pir_copy[i] will always be written as pir[0]. 
> This leads to handle spurious posted MSIs later.
Yes, you are right. It should be
pir_copy[i] = arch_xchg(&pir[i], 0);

Will fix in v2, really appreciated.

> > +		handled = true;
> > +	}
> > +
> > +	if (handled) {
> > +		for_each_set_bit_from(vec, pir_copy,
> > FIRST_SYSTEM_VECTOR)
> > +			call_irq_handler(vec, regs);
> > +	}
> > +
> > +	return handled;
> > +}
> > +
> > +/*
> > + * Performance data shows that 3 is good enough to harvest 90+% of the
> > benefit
> > + * on high IRQ rate workload.
> > + */
> > +#define MAX_POSTED_MSI_COALESCING_LOOP 3
> > +
> > +/*
> > + * For MSIs that are delivered as posted interrupts, the CPU
> > notifications
> > + * can be coalesced if the MSIs arrive in high frequency bursts.
> > + */
> > +DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi_notification)
> > +{
> > +	struct pt_regs *old_regs = set_irq_regs(regs);
> > +	struct pi_desc *pid;
> > +	int i = 0;
> > +
> > +	pid = this_cpu_ptr(&posted_interrupt_desc);
> > +
> > +	inc_irq_stat(posted_msi_notification_count);
> > +	irq_enter();
> > +
> > +	/*
> > +	 * Max coalescing count includes the extra round of
> > handle_pending_pir
> > +	 * after clearing the outstanding notification bit. Hence, at
> > most
> > +	 * MAX_POSTED_MSI_COALESCING_LOOP - 1 loops are executed here.
> > +	 */
> > +	while (++i < MAX_POSTED_MSI_COALESCING_LOOP) {
> > +		if (!handle_pending_pir(pid->pir64, regs))
> > +			break;
> > +	}
> > +
> > +	/*
> > +	 * Clear outstanding notification bit to allow new IRQ
> > notifications,
> > +	 * do this last to maximize the window of interrupt coalescing.
> > +	 */
> > +	pi_clear_on(pid);
> > +
> > +	/*
> > +	 * There could be a race of PI notification and the clearing
> > of ON bit,
> > +	 * process PIR bits one last time such that handling the new
> > interrupts
> > +	 * are not delayed until the next IRQ.
> > +	 */
> > +	handle_pending_pir(pid->pir64, regs);
> > +
> > +	apic_eoi();
> > +	irq_exit();
> > +	set_irq_regs(old_regs);
> >   }
> >   #endif /* X86_POSTED_MSI */
> >     


Thanks,

Jacob


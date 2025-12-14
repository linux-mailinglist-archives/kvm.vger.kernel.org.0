Return-Path: <kvm+bounces-65948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6BBCBBDEC
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 18:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B7E3300BBBE
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 17:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD9F2EBDFD;
	Sun, 14 Dec 2025 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZltDVv7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0333BB4A;
	Sun, 14 Dec 2025 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765732617; cv=none; b=eS4qWp9s0arLLCgs9I/1YhBE7lhJn2mavFnBn8SQVC4w0k7LzvFfhu24mPUK5aq8ZzFoLRX7aNepVwMNn3EintM226HkgI63fybP67K1BWLKdiIpcVfFpaFthxRRL9QziSjlmBkZno+77v1ZAwhSRerp/6I07SeGpVgEWpMdPac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765732617; c=relaxed/simple;
	bh=Hzo91lSZT73zV0+I+4XEn7kaMdDm0Z228rOw/nwbafM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Il3WTbRL9VI127X8NBM/Fm66cg50nH58TNX44qZm9Eq4mr+a8tFuuT8/CHCs9Ai83BdmraPG06h11+9sI+CgDueeSSOvqOGXNNMeF84dbcitqt9KVAvTapzpy8jShTBd6VHoUjD9oAnX/LZn1knm1FAvy8mzI/D3PqQ5+RaDrCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZltDVv7Y; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765732615; x=1797268615;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Hzo91lSZT73zV0+I+4XEn7kaMdDm0Z228rOw/nwbafM=;
  b=ZltDVv7YvnetjDflzAJUeG7XoL9pq8iyS15fzH/BPXv0GqFu07PGojcV
   lhWriqOAlmdinY03jLvcNydUUVtSe9khTgJSx/d8MqotzgBDsFOSX6ixS
   JPaAsR3mCXUl6iQRB/aEpDfmIVT9OEcM/mQUI9FmEAS9X4EhkMtLTzhgF
   Ve1zcb1U9C52DUZ/f7wpSBfUMXpT0RBAvRRvcUJtaGnLjO8+UQakf7L4e
   M7aCcYPWbqWDKnxqRRkWN5ugBcRy1tBFdqKvYT8yEB03pxKONvDHwHboJ
   h7xVX9leU/tNydPf759azU7SmWxxk65ZGU4DYaJjeOxOZUIgKXfyV41BV
   A==;
X-CSE-ConnectionGUID: NES0l1vWSgGQLbzkSQ0LqQ==
X-CSE-MsgGUID: Xrs8oOEGTmq/uwmJYAvVfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="66830871"
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="66830871"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 09:16:55 -0800
X-CSE-ConnectionGUID: nJMR+z2vQXOo1tryivcskw==
X-CSE-MsgGUID: ygG6JGfwQzitWQyQgi9Slg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="197532992"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 09:16:55 -0800
Date: Sun, 14 Dec 2025 09:16:45 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 2/9] x86/bhi: Make clear_bhb_loop() effective on newer
 CPUs
Message-ID: <20251214171645.nd4ripnkjf6ef3df@desk>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
 <fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>

On Wed, Dec 10, 2025 at 02:31:31PM +0200, Nikolay Borisov wrote:
> 
> 
> On 2.12.25 г. 8:19 ч., Pawan Gupta wrote:
> > As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
> > the Branch History Buffer (BHB). On Alder Lake and newer parts this
> > sequence is not sufficient because it doesn't clear enough entries. This
> > was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> > that mitigates BHI in kernel.
> > 
> > BHI variant of VMSCAPE requires isolating branch history between guests and
> > userspace. Note that there is no equivalent hardware control for userspace.
> > To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> > should execute sufficient number of branches to clear a larger BHB.
> > 
> > Dynamically set the loop count of clear_bhb_loop() such that it is
> > effective on newer CPUs too. Use the hardware control enumeration
> > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> > 
> > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> nit: My RB tag is incorrect, while I did agree with Dave's suggestion to
> have global variables for the loop counts I haven't' really seen the code so
> I couldn't have given my RB on something which I haven't seen but did agree
> with in principle.

The tag got applied from v4, but yes the patch got updated since:

https://lore.kernel.org/all/8b657ef2-d9a7-4424-987d-111beb477727@suse.com/

> Now that I have seen the code I'm willing to give my :
> 
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

Thanks.

> > ---
> >   arch/x86/entry/entry_64.S | 8 ++++++--
> >   1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> > index 886f86790b4467347031bc27d3d761d5cc286da1..9f6f4a7c5baf1fe4e3ab18b11e25e2fbcc77489d 100644
> > --- a/arch/x86/entry/entry_64.S
> > +++ b/arch/x86/entry/entry_64.S
> > @@ -1536,7 +1536,11 @@ SYM_FUNC_START(clear_bhb_loop)
> >   	ANNOTATE_NOENDBR
> >   	push	%rbp
> >   	mov	%rsp, %rbp
> > -	movl	$5, %ecx
> > +
> > +	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
> > +	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx",	\
> > +		    "movl $12, %ecx; movl $7, %edx", X86_FEATURE_BHI_CTRL
> 
> nit: Just

Will do:

	/* Just loop count differs based on BHI_CTRL, see Intel's BHI guidance */

> > +
> >   	ANNOTATE_INTRA_FUNCTION_CALL
> >   	call	1f
> >   	jmp	5f
> > @@ -1557,7 +1561,7 @@ SYM_FUNC_START(clear_bhb_loop)
> >   	 * but some Clang versions (e.g. 18) don't like this.
> >   	 */
> >   	.skip 32 - 18, 0xcc
> > -2:	movl	$5, %eax
> > +2:	movl	%edx, %eax
> >   3:	jmp	4f
> >   	nop
> >   4:	sub	$1, %eax
> > 
> 


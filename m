Return-Path: <kvm+bounces-65998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E25DBCBF59E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8A6B305FE5A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD38F3254B6;
	Mon, 15 Dec 2025 18:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RH//T8xH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F871324712;
	Mon, 15 Dec 2025 18:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765821705; cv=none; b=aYB6ak23+23+ntJTDij84ZMDKpb3ra1GK48JQQ3AksJAHzG7iV0Gf3RZMa0tjAWe8ZRBdiEKwq/CV2P8A+z80ddcF4rdWl63+SdL2YJmqNDcWPbD3GYu8ZONg+Y0O5/qegSEiPnozZ1WdCSrTlzR0D+sfArIrmO6K8zZeMZtdbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765821705; c=relaxed/simple;
	bh=HWni25jzINOha7apgKGvk26iKVT+UemHz6A1l0psDP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9MAB3b+Hu3P1ue8dDQ+EZAvput9UKIaxeKgKNMkradRIGAXgdI/Mgot70Fy33pyKawD/EW05NPZv5/Va0XzuFgu0U5r/tRdSngxpZcH+y7/cGF+95XHs2uqH/FNluacNBMujsI4huQDDm3tLOjOEFYhY5Vv+40qQsfhz+SfJto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RH//T8xH; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765821703; x=1797357703;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HWni25jzINOha7apgKGvk26iKVT+UemHz6A1l0psDP8=;
  b=RH//T8xH7fe6lWgtpGFgxx+7rJ2MnE1IrCGwO8Ag/QU2WzRtDNGbS2Kz
   PxwHReb7Gl3QG8Yt0XO0Bq/jqkEdi4CxHFkm645XbOTBeMZ4GkYRL5m0w
   v9pPkh3ZHW3x5q5eku+eCcwCvBHFL1+MNtD8vj5lJAi+Q3WR/4llG9rWm
   qnHTT7mHXN1DR6zPBfEt/7i0sTJvOtv/znxTOXcomQP8ap5hvxkQa1WmB
   fmxR6sRTVsAiP9xmG6sbDUfWji7JGyINDphAB6l3VwWg+JbpH5vGGM2HT
   0m6Xlx5JLGqnCstrj4nIsghf1QJy+XV7Mf/bylh4pyi/0odjF7GuUQN2I
   Q==;
X-CSE-ConnectionGUID: NwIpY/s6SDOcHrwB+Y0iGw==
X-CSE-MsgGUID: 1okO6qZdSWOAfZN16cq3CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="78848897"
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="78848897"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 10:01:42 -0800
X-CSE-ConnectionGUID: DLndmnIST7SM388NMzVdug==
X-CSE-MsgGUID: w1GsVQmXTGe3ERtmglbrUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="197832492"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 10:01:42 -0800
Date: Mon, 15 Dec 2025 10:01:36 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
	David Kaplan <david.kaplan@amd.com>,
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
Message-ID: <20251215180136.sjtvt57autnrassg@desk>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
 <fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
 <20251210133542.3eff9c4a@pumpkin>
 <20251214183827.4z6nrrol4vz2tc5w@desk>
 <20251214190233.4b40fe20@pumpkin>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251214190233.4b40fe20@pumpkin>

On Sun, Dec 14, 2025 at 07:02:33PM +0000, David Laight wrote:
> On Sun, 14 Dec 2025 10:38:27 -0800
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> 
> > On Wed, Dec 10, 2025 at 01:35:42PM +0000, David Laight wrote:
> > > On Wed, 10 Dec 2025 14:31:31 +0200
> > > Nikolay Borisov <nik.borisov@suse.com> wrote:
> > >   
> > > > On 2.12.25 г. 8:19 ч., Pawan Gupta wrote:  
> > > > > As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
> > > > > the Branch History Buffer (BHB). On Alder Lake and newer parts this
> > > > > sequence is not sufficient because it doesn't clear enough entries. This
> > > > > was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> > > > > that mitigates BHI in kernel.
> > > > > 
> > > > > BHI variant of VMSCAPE requires isolating branch history between guests and
> > > > > userspace. Note that there is no equivalent hardware control for userspace.
> > > > > To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> > > > > should execute sufficient number of branches to clear a larger BHB.
> > > > > 
> > > > > Dynamically set the loop count of clear_bhb_loop() such that it is
> > > > > effective on newer CPUs too. Use the hardware control enumeration
> > > > > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> > > > > 
> > > > > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > > > Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> > > > > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>    
> > > > 
> > > > nit: My RB tag is incorrect, while I did agree with Dave's suggestion to 
> > > > have global variables for the loop counts I haven't' really seen the 
> > > > code so I couldn't have given my RB on something which I haven't seen 
> > > > but did agree with in principle.  
> > > 
> > > I thought the plan was to use global variables rather than ALTERNATIVE.
> > > The performance of this code is dominated by the loop.  
> > 
> > Using globals was much more involved, requiring changes in atleast 3 files.
> > The current ALTERNATIVE approach is much simpler and avoids additional
> > handling to make sure that globals are set correctly for all mitigation
> > modes of BHI and VMSCAPE.
> > 
> > [ BTW, I am travelling on a vacation and will be intermittently checking my
> >   emails. ]
> > 
> > > I also found this code in arch/x86/net/bpf_jit_comp.c:
> > > 	if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP)) {
> > > 		/* The clearing sequence clobbers eax and ecx. */
> > > 		EMIT1(0x50); /* push rax */
> > > 		EMIT1(0x51); /* push rcx */
> > > 		ip += 2;
> > > 
> > > 		func = (u8 *)clear_bhb_loop;
> > > 		ip += x86_call_depth_emit_accounting(&prog, func, ip);
> > > 
> > > 		if (emit_call(&prog, func, ip))
> > > 			return -EINVAL;
> > > 		EMIT1(0x59); /* pop rcx */
> > > 		EMIT1(0x58); /* pop rax */
> > > 	}
> > > which appears to assume that only rax and rcx are changed.
> > > Since all the counts are small, there is nothing stopping the code
> > > using the 8-bit registers %al, %ah, %cl and %ch.  
> > 
> > Thanks for catching this.
> 
> I was trying to find where it was called from.
> Failed to find the one on system call entry...

The macro CLEAR_BRANCH_HISTORY calls clear_bhb_loop() at system call entry.

> > > There are probably some schemes that only need one register.
> > > eg two separate ALTERNATIVE blocks.  
> > 
> > Also, I think it is better to use a callee-saved register like rbx to avoid
> > callers having to save/restore registers. Something like below:
> 
> I'm not sure.
> %ax is the return value so can be 'trashed' by a normal function call.
> But if the bpf code is saving %ax then it isn't expecting a normal call.

BHB clear sequence is executed at the end of the BPF JITted code, and %rax
is likely the return value of the BPF program. So, saving/restoring %rax
around the sequence makes sense to me.

> OTOH if you are going to save the register in clear_bhb_loop you might
> as well use %ax to get the slightly shorter instructions for %al.
> (I think 'movb' comes out shorter - as if it really matters.)

%rbx is a callee-saved register so it felt more intuitive to save/restore
it in clear_bhb_loop(). But, I can use %ax if you feel strongly.

> Definitely worth a comment that it must save all resisters.

Yes, will add a comment.

> I also wonder if it needs to setup a stack frame?

I don't know if thats necessary, objtool doesn't complain because
clear_bhb_loop() is marked STACK_FRAME_NON_STANDARD.

> Again, the code is so slow it won't matter.
> 
> 	David


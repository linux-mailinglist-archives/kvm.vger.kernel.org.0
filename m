Return-Path: <kvm+bounces-65949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D497ECBBEE4
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 19:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 253FA300A871
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 18:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067C630DEDD;
	Sun, 14 Dec 2025 18:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S4YI5hiI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A881F513;
	Sun, 14 Dec 2025 18:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765737516; cv=none; b=oOwyVXAOotrtAJ6EgfZqTlxfoLlb/T1hmVZCJhpdC3ol5McfYB69md0jwZ1jiJoHB2AICJq7bvczuNFRy2t3+UwR1yoF6Ofz8NoJKMumIhcZgpWmTDH90reQySKhxaKZ21wFYlUs8N1Ivr5kOtUg64p80TPwY+CJZaVLeopjuIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765737516; c=relaxed/simple;
	bh=9sZOEFTXShcddTpiPh+ivAACiouKNX0J7q0i5QbolzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5cfl621CCwRCEbOaQ8HtJ3qaTCQ/2+8KOGaR0kGxV6iV11HZQ8Rw7dEv1sYP+Nbq913JpXzriln/y6P7kyhzIgprocZo4EilXHKFeOBOyVgQUNOO1G4GNVGYzNEuuXaSehCjxyJDHpRoHVbCSgk5lhdAtSsZ3OzjDADSljCXXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S4YI5hiI; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765737514; x=1797273514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9sZOEFTXShcddTpiPh+ivAACiouKNX0J7q0i5QbolzI=;
  b=S4YI5hiI5Kg8zTkNIrrQGVgnyJtJNV17JjJnsOutBqe5tyq7fMl/kygO
   GLyPo9ceXW7rdKdkfMvjEaoL29ztAi4FvWP87e7qTMHace9NPRuTkUuli
   h9Wr+V4GIFozsRsWokyRm6wnQCJ2lQ51N88Hd9PwmI9esloSdKZNSuXiN
   Uzf2Vc4jaW4hgBQeDiDNeeKlxiPc9aa41j93/C8Pyc2J+CH6MA3k9laXn
   9CqkgoXw6cw/0C+bai5MiMwZbnoC0aAhCvWyio9whT7SRA04ff7Dcx42A
   oILaGjsEk4Q75M/ZsulHTaZItLyyXJznvd87QIOm/JhUTIJs6Or50Djzp
   g==;
X-CSE-ConnectionGUID: x5vPIEihSxeaeBiwbI6spw==
X-CSE-MsgGUID: FDNLfvt2Qr6m7/z2Xr1Nlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="79112589"
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="79112589"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 10:38:33 -0800
X-CSE-ConnectionGUID: WP62vk8tRpCw1h8WkFkKzg==
X-CSE-MsgGUID: XEpmPgLSTjisnU7DvJVBTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,148,1763452800"; 
   d="scan'208";a="201731974"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 10:38:33 -0800
Date: Sun, 14 Dec 2025 10:38:27 -0800
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
Message-ID: <20251214183827.4z6nrrol4vz2tc5w@desk>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
 <fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
 <20251210133542.3eff9c4a@pumpkin>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251210133542.3eff9c4a@pumpkin>

On Wed, Dec 10, 2025 at 01:35:42PM +0000, David Laight wrote:
> On Wed, 10 Dec 2025 14:31:31 +0200
> Nikolay Borisov <nik.borisov@suse.com> wrote:
> 
> > On 2.12.25 г. 8:19 ч., Pawan Gupta wrote:
> > > As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
> > > the Branch History Buffer (BHB). On Alder Lake and newer parts this
> > > sequence is not sufficient because it doesn't clear enough entries. This
> > > was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> > > that mitigates BHI in kernel.
> > > 
> > > BHI variant of VMSCAPE requires isolating branch history between guests and
> > > userspace. Note that there is no equivalent hardware control for userspace.
> > > To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> > > should execute sufficient number of branches to clear a larger BHB.
> > > 
> > > Dynamically set the loop count of clear_bhb_loop() such that it is
> > > effective on newer CPUs too. Use the hardware control enumeration
> > > X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> > > 
> > > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> > > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>  
> > 
> > nit: My RB tag is incorrect, while I did agree with Dave's suggestion to 
> > have global variables for the loop counts I haven't' really seen the 
> > code so I couldn't have given my RB on something which I haven't seen 
> > but did agree with in principle.
> 
> I thought the plan was to use global variables rather than ALTERNATIVE.
> The performance of this code is dominated by the loop.

Using globals was much more involved, requiring changes in atleast 3 files.
The current ALTERNATIVE approach is much simpler and avoids additional
handling to make sure that globals are set correctly for all mitigation
modes of BHI and VMSCAPE.

[ BTW, I am travelling on a vacation and will be intermittently checking my
  emails. ]

> I also found this code in arch/x86/net/bpf_jit_comp.c:
> 	if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP)) {
> 		/* The clearing sequence clobbers eax and ecx. */
> 		EMIT1(0x50); /* push rax */
> 		EMIT1(0x51); /* push rcx */
> 		ip += 2;
> 
> 		func = (u8 *)clear_bhb_loop;
> 		ip += x86_call_depth_emit_accounting(&prog, func, ip);
> 
> 		if (emit_call(&prog, func, ip))
> 			return -EINVAL;
> 		EMIT1(0x59); /* pop rcx */
> 		EMIT1(0x58); /* pop rax */
> 	}
> which appears to assume that only rax and rcx are changed.
> Since all the counts are small, there is nothing stopping the code
> using the 8-bit registers %al, %ah, %cl and %ch.

Thanks for catching this.

> There are probably some schemes that only need one register.
> eg two separate ALTERNATIVE blocks.

Also, I think it is better to use a callee-saved register like rbx to avoid
callers having to save/restore registers. Something like below:

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 9f6f4a7c5baf..ca4a34ce314a 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1535,11 +1535,12 @@ SYM_CODE_END(rewind_stack_and_make_dead)
 SYM_FUNC_START(clear_bhb_loop)
 	ANNOTATE_NOENDBR
 	push	%rbp
+	push	%rbx
 	mov	%rsp, %rbp
 
 	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
-	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx",	\
-		    "movl $12, %ecx; movl $7, %edx", X86_FEATURE_BHI_CTRL
+	ALTERNATIVE "movb $5,  %bl",	\
+		    "movb $12, %bl", X86_FEATURE_BHI_CTRL
 
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
@@ -1561,15 +1562,17 @@ SYM_FUNC_START(clear_bhb_loop)
 	 * but some Clang versions (e.g. 18) don't like this.
 	 */
 	.skip 32 - 18, 0xcc
-2:	movl	%edx, %eax
+2:	ALTERNATIVE "movb $5, %bh",	\
+		    "movb $7, %bh", X86_FEATURE_BHI_CTRL
 3:	jmp	4f
 	nop
-4:	sub	$1, %eax
+4:	sub	$1, %bh
 	jnz	3b
-	sub	$1, %ecx
+	sub	$1, %bl
 	jnz	1b
 .Lret2:	RET
 5:
+	pop	%rbx
 	pop	%rbp
 	RET
 SYM_FUNC_END(clear_bhb_loop)
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index c1ec14c55911..823b3f613774 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1593,11 +1593,6 @@ static int emit_spectre_bhb_barrier(u8 **pprog, u8 *ip,
 	u8 *func;
 
 	if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP)) {
-		/* The clearing sequence clobbers eax and ecx. */
-		EMIT1(0x50); /* push rax */
-		EMIT1(0x51); /* push rcx */
-		ip += 2;
-
 		func = (u8 *)clear_bhb_loop;
 		ip += x86_call_depth_emit_accounting(&prog, func, ip);
 
@@ -1605,8 +1600,6 @@ static int emit_spectre_bhb_barrier(u8 **pprog, u8 *ip,
 			return -EINVAL;
 		/* Don't speculate past this until BHB is cleared */
 		EMIT_LFENCE();
-		EMIT1(0x59); /* pop rcx */
-		EMIT1(0x58); /* pop rax */
 	}
 	/* Insert IBHF instruction */
 	if ((cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP) &&


Return-Path: <kvm+bounces-31523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E85B9C45EB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55BDF1F22B8B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955FC1AA793;
	Mon, 11 Nov 2024 19:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/l92PBi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B231BC4E;
	Mon, 11 Nov 2024 19:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731353587; cv=none; b=BawTfDSFU3vewqmxewo8LVI7XbO0Ne+prGkX2zexF3vYdno6q0VPjPT6XGJRMsD8SzTxhgwzC+Q1vsv6QDOoSFEsT9pfUf5MauKf4q98UrEtaPi7+vLABwSfdHqcCoGEp4GjYvhtLYCXLrws19J5R49dMydp4VyibXN4F8vYQgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731353587; c=relaxed/simple;
	bh=5RZiISb6/xO5J3IRE5Y13VfnPayqmVjIbtVopSSzKuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IBwyPbvmp4IYbR+4EIYaoZSWQQXhPFq4/rtetlOlvEIDpxa3grB+z5KcWZfPivRFrnIbF0q3tAi98yYJS7+WigwHS++OiwK7SxB6fFPH+CQ/3VUKb+xILays3j+HdV3Q8m474ao0rgTLOLCJNmBUDTLzCvNqeM2EZnpPsqrUhJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/l92PBi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6A2C4CECF;
	Mon, 11 Nov 2024 19:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731353587;
	bh=5RZiISb6/xO5J3IRE5Y13VfnPayqmVjIbtVopSSzKuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y/l92PBiL7ky7+tTxQJOTRxmawJGcGGuxQIDF7y8yhMUJ0P5JwoslI4JUbyNkiqvm
	 27Jwki7jhn3WHEQbeOTTTQmFIcT3qSOSi8ETQiKhuPxDf8kB90qabXBwgJSHAY4jiW
	 Vz61OfR6fp5YL+UaBIW/rYRUzzvZqRa8lT9uvaUR0T6xNldWvcpRSvZ284asHqG+XJ
	 Qrp2ykfR+dVBQyZj/1GawwbxoV/Lm0KhefY3GxAk9ZtU8dtPQ1RuENIYH8a4YmzAet
	 SkmlvROai+dlyrEsT7uPFb5nBIu1wqWkZXoPVW29zJWePRJAsfWIebcEHibs2Rl+mD
	 VD0tfbr4PoxCA==
Date: Mon, 11 Nov 2024 11:33:04 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
	hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241111193304.fjysuttl6lypb6ng@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111163913.36139-2-amit@kernel.org>

On Mon, Nov 11, 2024 at 05:39:11PM +0100, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> AMD CPUs do not fall back to the BTB when the RSB underflows for RET
> address speculation.  AMD CPUs have not needed to stuff the RSB for
> underflow conditions.
> 
> The RSB poisoning case is addressed by RSB filling - clean up the FIXME
> comment about it.

I'm thinking the comments need more clarification in light of BTC and
SRSO.

This:

> -	 *    AMD has it even worse: *all* returns are speculated from the BTB,
> -	 *    regardless of the state of the RSB.

is still true (mostly: "all" should be "some"), though it doesn't belong
in the "RSB underflow" section.

Also the RSB stuffing not only mitigates RET, it mitigates any other
instruction which happen to be predicted as a RET.  Which is presumably
why it's still needed even when SRSO is enabled.

Something like below?

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 47a01d4028f6..e95d3aa14259 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1828,9 +1828,6 @@ static void __init spectre_v2_select_mitigation(void)
 	 *    speculated return targets may come from the branch predictor,
 	 *    which could have a user-poisoned BTB or BHB entry.
 	 *
-	 *    AMD has it even worse: *all* returns are speculated from the BTB,
-	 *    regardless of the state of the RSB.
-	 *
 	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
 	 *    scenario is mitigated by the IBRS branch prediction isolation
 	 *    properties, so the RSB buffer filling wouldn't be necessary to
@@ -1850,10 +1847,22 @@ static void __init spectre_v2_select_mitigation(void)
 	 *    The "user -> user" scenario, also known as SpectreBHB, requires
 	 *    RSB clearing.
 	 *
+	 *    AMD Branch Type Confusion (aka "AMD retbleed") adds some
+	 *    additional wrinkles:
+	 *
+	 *      - A RET can be mispredicted as a direct or indirect branch,
+	 *        causing the CPU to speculatively branch to a BTB target, in
+	 *        which case the RSB filling obviously doesn't help.  That case
+	 *        is mitigated by removing all the RETs (SRSO mitigation).
+	 *
+	 *      - The RSB is not only used for architectural RET instructions,
+	 *        it may also be used for other instructions which happen to
+	 *        get mispredicted as RETs.  Therefore RSB filling is still
+	 *        needed even when the RETs have all been removed by the SRSO
+	 *        mitigation.
+	 *
 	 * So to mitigate all cases, unconditionally fill RSB on context
 	 * switches.
-	 *
-	 * FIXME: Is this pointless for retbleed-affected AMD?
 	 */
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");


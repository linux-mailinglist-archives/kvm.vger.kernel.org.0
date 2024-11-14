Return-Path: <kvm+bounces-31844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE609C866C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 10:47:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13C021F22883
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 09:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF46A1F708F;
	Thu, 14 Nov 2024 09:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOQfL1Tn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092EA1632F2;
	Thu, 14 Nov 2024 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731577653; cv=none; b=HxBuCNdD+CoRtV6ubI6qHo3DJJQGqK3lahNMZjMy1UQz41MFxHpx6MqWXnOCV1fNCo0368VnZST7FoRptbeq0AulZd6b0x3uJsmvsbJCOfknxM8G5VUAFKE1nwce+tDJY3JN+0p4zL0VgKinW27v3vG6xH9EAceQQjxcmOu9Z34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731577653; c=relaxed/simple;
	bh=jGIxwE9bbYBj8San2bjvt6eXM5MNiT9cmXr1rAfLAAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoH+oNHHNmnZLDUfQc5XcmOFPnfkIFvuy8njanNToa3etu2L4XtqN1vCTosaFYckVsuUSnvlhQyESdQYJW+rWIZfex10ldYppyEE8G6AfFPz54Z/omyLLJwBhbsNUAdcazibfnCIMvKat/Yy1G6/11kExdDJ10ct+TsBgdFAbSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOQfL1Tn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47D7C4CECD;
	Thu, 14 Nov 2024 09:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731577652;
	bh=jGIxwE9bbYBj8San2bjvt6eXM5MNiT9cmXr1rAfLAAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DOQfL1TnZYVAdUjpohgvIdr+VpMU+dB87EYR12Pf30D1DXmtchMZplhvSvbp7zMtW
	 itzBsdFHV6EUVhO5DhHkGVnaLLpO9seoHiHokqTTUQ5lrTbOXiFJsj3cnzxrIIbFkJ
	 ozpu8RzcEX1a7D7gTnH1aZAxedbvpXssPfMc+2E4Y9nEJGThpsPaN56xYewARr6caB
	 yBsLypi2RtxLlni/U2+BPMglXC6qY9G1ikU48DtvbFvEpcvNZ5wfnYGMm16mIN3cj7
	 LLo1BiSv+UPKFuk+s0SMoxCKX2A8sYGLnpZHtoDgrMZWmSQDVZ5XvsIZ7+0/ZV0t5O
	 8njUNrn0lrmEw==
Date: Thu, 14 Nov 2024 10:47:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, tglx@linutronix.de,
	peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
	hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <ZzXHK1O9E1sQ8mBt@gmail.com>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112115811.GAZzNC08WU5h8bLFcf@fat_crate.local>
 <20241113212440.slbdllbdvbnk37hu@jpoimboe>
 <20241113213724.GJZzUcFKUHCiqGLRqp@fat_crate.local>
 <20241114004358.3l7jxymrtykuryyd@jpoimboe>
 <20241114074733.GAZzWrFTZM7HZxMXP5@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114074733.GAZzWrFTZM7HZxMXP5@fat_crate.local>


* Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Nov 13, 2024 at 04:43:58PM -0800, Josh Poimboeuf wrote:
> > This comment relates to the "why" for the code itself (and its poor
> > confused developers), taking all the RSB-related vulnerabilities into
> > account.
> 
> So use Documentation/arch/x86/.
> 
> This is exactly the reason why we need more "why" documentation - because
> everytime we have to swap the whole bugs.c horror back in, we're poor confused
> developers. And we have the "why" spread out across commit messages and other
> folklore which means everytime we have to change stuff, the git archeology
> starts. :-\ "err, do you remember why we're doing this?!" And so on
> converstaions on IRC.
> 
> So having an implementation document explaining clearly why we did things is
> long overdue.
> 
> But it's fine - I can move it later when the dust settles here.

I think in-line documentation is better in this case: the primary defense
against mistakes and misunderstandings is in the source code itself.

And "it's too long" is an argument *against* moving it out into some obscure
place 99% of developers aren't even aware of...

Thanks,

	Ingo


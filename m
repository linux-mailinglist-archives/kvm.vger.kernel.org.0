Return-Path: <kvm+bounces-31829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71AD39C7F72
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 01:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F26DCB22598
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 00:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F34EEC8;
	Thu, 14 Nov 2024 00:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arX30a25"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6223BE;
	Thu, 14 Nov 2024 00:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731545041; cv=none; b=oszIR2Xd6DD/Ne/ZZyUAxfEJGsS9xVQt4XPHZ0b70GpPDTA8mgWqsjatGgi/VSKsa0m6cgmjKjB2dzrW/9/rVfoz00URTcxpHXCIA/Y6Ju3LgeotifP9TGLSl1a+a61Rvg2xNmL+gpl3ocl8QV9DU+HxphwLyqZndjuvcTbu13w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731545041; c=relaxed/simple;
	bh=8IaEo0YJd0KfTU3+MR/SWm8SxKZ/uphzeYSqSdmUWyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m9A3SBbIGAfZx2Q1SheoNBJVJZY6sgnpTMO6liRDcGi3GxQVFU/a8ojKgCq9xi0IAVK81WhB4EPxq9eeO3QA5uqFHtxEUpXom5Ot7tUXek8givjayXjs/99BXerd4ci42kBOjui5tn+027DlBo+eoye5G5684lJTPZtyl0fSnmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arX30a25; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502E1C4CEC3;
	Thu, 14 Nov 2024 00:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731545041;
	bh=8IaEo0YJd0KfTU3+MR/SWm8SxKZ/uphzeYSqSdmUWyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=arX30a25jj6EIPSUrZ88Ebun2igjpJwHwGtakbmkw/Tf1CSq9GcHYsqQwBzqE7LdK
	 FD3eUtv/0/JV4Lj6FIxE2MPKJvjMdjIwvCQ5zZO9Vg4VDznEZnwUkYdlnfsTBmkrCR
	 nRLW4JeifjTWd3+GGIv5PEErjgtHfxY4rgqDBSmotFJSrdHKkQLvGxxIDnmLdgzWoZ
	 wfdcQp7iOdBeH4oTvJPg7uLQp21jtydi4+qe3mMfOE/OYTKIirM6NqbfnngM2dwCdP
	 adhO7VwQq5gNmva6CVcDDLGjtLSI8gbmWQMCrwQR6SoXrt0Ji1R92IO7VA4cicDVmr
	 RNVoVceGoP4pg==
Date: Wed, 13 Nov 2024 16:43:58 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Amit Shah <amit@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241114004358.3l7jxymrtykuryyd@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112115811.GAZzNC08WU5h8bLFcf@fat_crate.local>
 <20241113212440.slbdllbdvbnk37hu@jpoimboe>
 <20241113213724.GJZzUcFKUHCiqGLRqp@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241113213724.GJZzUcFKUHCiqGLRqp@fat_crate.local>

On Wed, Nov 13, 2024 at 10:37:24PM +0100, Borislav Petkov wrote:
> On Wed, Nov 13, 2024 at 01:24:40PM -0800, Josh Poimboeuf wrote:
> > There are a lot of subtle details to this $#!tstorm, and IMO we probably
> > wouldn't be having these discussions in the first place if the comment
> > lived in the docs, as most people seem to ignore them...
> 
> That's why I'm saying point to the docs from the code. You can't have a big
> fat comment in the code about this but everything else in the hw-vuln docs.

But those docs are user facing, describing the "what" for each
vulnerability individually.  They're basically historical documents
which don't evolve over time unless we tweak an interface or add a new
mitigation.

This comment relates to the "why" for the code itself (and its poor
confused developers), taking all the RSB-related vulnerabilities into
account.

-- 
Josh


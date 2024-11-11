Return-Path: <kvm+bounces-31532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE509C480E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 22:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C230B2F3C1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BDF1BB6B5;
	Mon, 11 Nov 2024 20:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHu05cTb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A991B5827;
	Mon, 11 Nov 2024 20:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731357641; cv=none; b=DyRHtvHVDunvOFJgwX/HjMgzRLxjjqc9H9Jq52bSXcsCwYrjrBKTpc0kT9qAYV1DJTnMbpkEQe9zlmUqncf43kRTd/aRyZLhQRwUQz2U1sCPLtir2BdYt9ONBs+SMkE6L/LxQ7utDiBjOFAvIxMJpcxxa+0+rB7OVhfLuW1aN9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731357641; c=relaxed/simple;
	bh=HyFMaRXITnzt3qjNKojKuR0TkanFbUkPSq/dln3OrRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYoqTYY7QXNEmMUfhZj7GxGb1Wmxh9EP7PrSzOTVMlMIIESrgEOh8JiT69eqyNrn1xbn8KFt7cyvTfhP8EYarhURAZNGL2Z3CRUlAmGLXQpW/XF3ICzZX7AomUP/rp2dt312fkfc6Lym5kf/E5ftQKESpoNS9siGLe8/MWRVbqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHu05cTb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470DAC4CECF;
	Mon, 11 Nov 2024 20:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731357641;
	bh=HyFMaRXITnzt3qjNKojKuR0TkanFbUkPSq/dln3OrRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jHu05cTbLuzCMXfu/EO0asvCTvczfjZetFhAHLh0V4kK9q6DflN9ElW/ljISjezhZ
	 7EZa6FmPUOABOVp7aIzf5RNIi2dorW0d9qRQnHqkIxWouF7R+1+VjAaYoQOTt7mNuB
	 c+7zft/c82ac8mhE00YQZVqn5t2ZQrFwPH2+8XKNIxea+aRi8GWLsgTRiZVdbzG5n0
	 1ayZwIVlTyDJu9VJ59Uk0UOKhwvCCTrSl6tvh7XGrLvV0k5T1orjv04vRwLGtVHndJ
	 +NHrVy2UVGQMZ34BAtbanNgP0C14JwuNvggRlFT8yJEOuEtipWIBt4Ie3hl+wOBC4h
	 aHr9Xw3t0x6CA==
Date: Mon, 11 Nov 2024 12:40:38 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: Amit Shah <amit@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"Shah, Amit" <Amit.Shah@amd.com>,
	"Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
	"kai.huang@intel.com" <kai.huang@intel.com>,
	"Das1, Sandipan" <Sandipan.Das@amd.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"Moger, Babu" <Babu.Moger@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241111204038.63ny4i74irngw2si@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <LV3PR12MB9265A6B2030DAE155E7B560B94582@LV3PR12MB9265.namprd12.prod.outlook.com>
 <20241111203906.a2y55qoi767hcmht@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111203906.a2y55qoi767hcmht@jpoimboe>

On Mon, Nov 11, 2024 at 12:39:09PM -0800, Josh Poimboeuf wrote:
> This is why it's important to spell out all the different cases in the
> comments.  I was attempting to document the justifications for the
> existing behavior.
> 
> You make some good points, though backing up a bit, I realize my comment
> was flawed for another reason: the return thunks only protect the
> kernel, but RSB filling on context switch is meant to protect user
> space.
> 
> So, never mind...

That said, I still think the comments need an update.  I'll try to come
up with something later.

-- 
Josh


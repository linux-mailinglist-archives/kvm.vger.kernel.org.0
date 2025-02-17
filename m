Return-Path: <kvm+bounces-38327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 467E7A37B0E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 06:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE0523A97BA
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 05:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECE5188587;
	Mon, 17 Feb 2025 05:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RLvj2yJI"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3D229A2
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 05:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739771293; cv=none; b=St61vUuh0EBZgEqqewlIUI1MTygbZ75xXQusNUTQMa1FYZKL38yhDtwPLUkzeUl33GZqf7MoAVxjazOAgDkFjfZt9YqzK3fHo/AwnaJDE+BQLl5ACjTMwSEQV90omKmmz6oAFuVSBPYU1Q06weMEkFiilO6ocSdNVkGklyP6LNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739771293; c=relaxed/simple;
	bh=RJ4isYEhu59iqU1rOZHf5p6XuMqMbEBIsJEzGtMs1KU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7WzCDGy5Cj3Cxt+pluJvsF7geD7gVqVOBI9bdfBKNM7kWxGNQvPr4PS+G5c29oTfvqc+OMMealbiQe0me2jdi1MT5hEN8/KnnoZQimfg1yA/a4y/53NZQKE2b9gBbWW5O9xs/3eFwRRLj/SPL0G8QWS5GAJ4sjR/REuAApfd00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RLvj2yJI; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 16 Feb 2025 21:47:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739771288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UkW4mVU4PGjrQhcXaepiFW4DCXib/vQm5uJGHZpQDK0=;
	b=RLvj2yJIbP8AuzXsHnN7NIqWU+zHRRcmjHH29mWGlERK5/PFC5YG9cPSDxHYtoRQPCM/Oq
	T0L+paz5CHqS1BLeGn467Fg5P0pQS/ev/ucXDazkXJax3lIvYZ9KURvevmOzZDgFN/AGR6
	VbudTSZhtowQTx50LCcU8F7n6D/aKKo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Borislav Petkov <bp@alien8.de>
Cc: Patrick Bellasi <derkling@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <Z7LNjEqZELrPmRkV@Asmaa.>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <Z6_mY3a_FH-Zw4MC@google.com>
 <20250215091527.GAZ7BbL2UfeJ0_52ib@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215091527.GAZ7BbL2UfeJ0_52ib@fat_crate.local>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 15, 2025 at 10:15:27AM +0100, Borislav Petkov wrote:
> On Sat, Feb 15, 2025 at 12:57:07AM +0000, Yosry Ahmed wrote:
> > Should this patch (and the two previously merged patches) be backported
> > to stable? I noticed they did not have CC:stable.
> 
> Because a stable backport would require manual backporting, depending on where
> it goes. And Brendan, Patrick or I are willing to do that - it's a question of
> who gets there first. :-)

Thanks for the context, didn't realize a manual backport was needed.


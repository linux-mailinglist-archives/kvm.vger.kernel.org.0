Return-Path: <kvm+bounces-32263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9688F9D4DBD
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 14:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E2421F2223D
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 13:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2161D88CA;
	Thu, 21 Nov 2024 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmqbELAe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F59D1369B4;
	Thu, 21 Nov 2024 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732195570; cv=none; b=cELZ+DBBDVP9brifHrQCiH2BPRfR76cExFvKaoSGTVEYxLEXwgmsGRdUXPwKrGVj6sU9XgQedClEwrdFvyErQvo4ZBrV8hTOoLnFLzSiWFwTzJxDpNZjr5+XpvjS8f2AYmSKt8HdlnUOdmsdoDQHT3VXIsuwzcQMCvJpFdB10P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732195570; c=relaxed/simple;
	bh=hZb9UF78W9QUZ1OdfaHRv3ywLUoZJy5o2aNmapCr66w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGXR+ENu9YLv3G5kGeICGwtJsn68S9kBpMeaxC4EVNCaH2UlR8p7cYLRsPH5MMU52mYRc7kTbpc+LGYpuTjflq3Fg2cYGv7lN+x8KPYVc3cJzwmSh39EFuoZ249XC9odN8qWMpf7hPIvp6PURVPs9+/Ugl52DSKxgjYqAMiHgKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmqbELAe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7541C4CECC;
	Thu, 21 Nov 2024 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732195570;
	bh=hZb9UF78W9QUZ1OdfaHRv3ywLUoZJy5o2aNmapCr66w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JmqbELAeXzlIr62DDCRG8m/onu4eOrBFah0pJVjvY1R8AxxUsWrUk0e1eCvgtFd7x
	 CmaYrZ7bFC+D/onUo1O7KTNY/qZ+OJ3sKDXhB0/BakZHT1tWIMuI9w38HHqsFuNo9G
	 dD23+BkdYETu9JLQdS2zh8yLkqukuRqG+ly1yYPQ6kcPCUPywdkjC7eCgAQ4rn2Kvs
	 6rHaEMzXrKK67mJVuTPCjuxwXTPRdW5E9zOdYlKW2/U6ZydZYO7VErHDbHcFIu4NLf
	 CCzckaMl6z3rUdaDLkh2ZnX4JF//Ek/G4xux39mIFsRe2At/cMTzaAEyRIIW94ypLI
	 xndc2NHY21wgQ==
Date: Thu, 21 Nov 2024 06:26:08 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.13 merge window
Message-ID: <20241121132608.GA4113699@thelio-3990X>
References: <20241120135842.79625-1-pbonzini@redhat.com>
 <Zz8t95SNFqOjFEHe@sashalap>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz8t95SNFqOjFEHe@sashalap>

On Thu, Nov 21, 2024 at 07:56:23AM -0500, Sasha Levin wrote:
> Hi Paolo,
> 
> On Wed, Nov 20, 2024 at 08:58:42AM -0500, Paolo Bonzini wrote:
> >      riscv: perf: add guest vs host distinction
> 
> When merging this PR into linus-next, I've started seeing build errors:
> 
> In file included from /builds/linux/arch/riscv/kernel/asm-offsets.c:12:
> In file included from /builds/linux/arch/riscv/include/asm/kvm_host.h:23:
> In file included from /builds/linux/arch/riscv/include/asm/kvm_vcpu_pmu.h:12:
> In file included from /builds/linux/include/linux/perf/riscv_pmu.h:12:
> /builds/linux/include/linux/perf_event.h:1679:64: error: too many arguments provided to function-like macro invocation
>  1679 | extern unsigned long perf_misc_flags(struct perf_event *event, struct pt_regs *regs);
>       |                                                                ^
> /builds/linux/arch/riscv/include/asm/perf_event.h:15:9: note: macro 'perf_misc_flags' defined here
>    15 | #define perf_misc_flags(regs) perf_misc_flags(regs)
>       |         ^
> 
> Looks like this is due to 2c47e7a74f44 ("perf/core: Correct perf
> sampling with guest VMs") which went in couple of days ago through
> Ingo's perf tree and changed the number of parameters for
> perf_misc_flags().

There is a patch out to fix this but it seems like it needs to be
applied during this merge?

https://lore.kernel.org/20241116160506.5324-1-prabhakar.mahadev-lad.rj@bp.renesas.com/
https://lore.kernel.org/ZzxDvLKGz1ouWzgX@gmail.com/

Cheers,
Nathan


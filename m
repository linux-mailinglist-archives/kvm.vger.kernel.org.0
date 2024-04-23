Return-Path: <kvm+bounces-15630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 881238AE22E
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B6311F25CB8
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 10:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E23B65189;
	Tue, 23 Apr 2024 10:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Z3FH4zLE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFEE57303;
	Tue, 23 Apr 2024 10:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713868135; cv=none; b=i6/NpzemV+3kGA8lqW/YjAv3dj+jm3ylgC6q/jQusXuYIkjXo1S8vf6rQTC/+bCtOn65op/3xmGYsGBkfxuLs3GLfLQYhKPtP0lSxRqkoUf9K5xzEBTT7YKgceR6RVhFnVedQzc7VLZuH7aazPwRzdKkHJaHzPvuofFU8QhRy3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713868135; c=relaxed/simple;
	bh=uh3qowr3m7iMpEAznogEW2Z/W4vdpFPZBLkqnX3kXJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQ/Fgl0byPTY0F4ZemaUcRx5dN+jdpKcW9+VTy83E6EP3dwZxhBtygcKGo8qeMbbi0/U71tQ7bwElKHY5UjrV2USI0+plGWlR2Hg/bYz2x5kaJdOKsJiuPsWa/+XEMhBuQba3YAofjP/7dN6IwbljWjFj34msFNG39vCH0gUI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Z3FH4zLE; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C8C2540E0192;
	Tue, 23 Apr 2024 10:28:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id K4TEGVbBZaV8; Tue, 23 Apr 2024 10:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713868126; bh=c06iWq/U5QU79LoYabk6NNZS2MWKKgb0Cpqli/6PTJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z3FH4zLEd5fO/jmwUKzXZVRNHTIcKRObRRp8a5M6PtmwkQjZ1og+lDQ0PUNGjvFZw
	 5u34wtAYTjZTphebOJxFn9rcKnGTLn9Wr+a4EZbCe50NBnVxUQtX23qQabMWrrXkMx
	 GZjVmxcn3LfHe4QWHKuGOkzGcCJ5feIXugB5CbtPuC02aAAEGTQJ8mzje4fAA7aesI
	 m7NvwXgkE1IXo4MoB0JliP5XKJEgM041bjaapWGKi1ItjJrh+Nst1BYfmuIaVTdY8d
	 XOGbfhKiaqHL90wTM/b5zdFD2TYm3wssUTcp0tCKpKT3O1nE74olmgY5csqVV4ZgwZ
	 HhIm/jsSf1+LqoPQAI6bN9lyBQ8vtCFO70rPEFVuncQuYTk7K9i7RHsmZiPWYAwkuk
	 A7XxLKJZSypuGSmpzEdMMWLi1mZbvn8mIOI/KK5mKhb6rxj9mOJEZhIrOhAdKyWcyG
	 ssJ5sMKTUkZjhVy/vCtvLAEtSP/zG/ed17/wjodJY7zgGfr9FPIDH4WdwUA1X/hAks
	 8eAKWWZrSbAMBU+Tl4ulBjxa8e4OeoSYxA5j1eW5l91WLGR1w87mZJMgXeCZWj5vYi
	 DRsa5rfNkY9JuYyRzPHv0ECfD/f+LS1syX6eLLmwcW3iQofSQHZXTt5DMRjSx2UxrF
	 pwlNX+kwDM0CujqWneLZSfUo=
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7939040E00B2;
	Tue, 23 Apr 2024 10:28:35 +0000 (UTC)
Date: Tue, 23 Apr 2024 12:28:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 06/16] virt: sev-guest: Move SNP Guest command mutex
Message-ID: <20240423102829.GCZieNTcHyuAYMcRf5@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-7-nikunj@amd.com>
 <20240422130012.GAZiZfXM5Z2yRvw7Cx@fat_crate.local>
 <6a7a8892-bb8d-4f03-a802-d7eee48045b5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6a7a8892-bb8d-4f03-a802-d7eee48045b5@amd.com>

On Tue, Apr 23, 2024 at 09:52:41AM +0530, Nikunj A. Dadhania wrote:
> SNP guest messaging will be moving as part of sev.c, and Secure TSC code
> will use this mutex.

No, this is all backwards.

You have a *static* function in sev-guest - snp_guest_ioctl- which takes
an exported lock - snp_guest_cmd_lock - in order to synchronize with
other callers which are only in that same sev-guest driver.

Why do you even need the guest messaging in sev.c?

I guess this: "Many of the required functions are implemented in the
sev-guest driver and therefore not available at early boot."

But then your API is misdesigned: the lock should be private to sev.c
and none of the callers should pay attention to grabbing it - the
callers simply call the functions and underneath the locking works
automatically for them - they don't care. Just like any other shared
resource, users see only the API they call and the actual
synchronization is done behind the scenes.

Sounds like you need to go back to the drawing board and think how this
thing should look like.

And when you have it, make sure to explain the commit messages *why* it
is done this way.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


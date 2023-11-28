Return-Path: <kvm+bounces-2589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 925747FB458
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 09:37:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C9012823C5
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D787199B0;
	Tue, 28 Nov 2023 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="I8Kl7pOf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF90AA;
	Tue, 28 Nov 2023 00:37:01 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D84A840E01A5;
	Tue, 28 Nov 2023 08:36:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1vHsmSMNDYS3; Tue, 28 Nov 2023 08:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701160617; bh=DS2d99Cf/Tm1b0CoskKzTkSL4zfPSaK6CYmxmDpIDno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I8Kl7pOfZkDJ1aauL4p8L+PlN65c8sIR0dkdP1NbqWcLcQY6vEQjYeM/r0US8S9kF
	 RYKot1G8DTIU2i/vJbZ1dY8cBcGfRTw5eFgwVvUfS9BBoA90TBlEUp24OXrYB919e/
	 Oy9SPBMTF8mwOQGo4ENPJBFKDroY/sp19zB/SlzHi4KLsJ7dwdNlb1E3uwAjDanJoQ
	 vo2I6xeoAedHIyLyWVbyRwoypXxt0W/z9QtACLsVB9EJOZcuTpIzfRI0WQVy6PL0gs
	 lmvT8HdZT00moCakbNxG+hW2JFqsKP3UGOqM6ogwuTCRPnTt7vEHovr6BESHhP7Ghd
	 PrmO7bjwnAbf9slrMSVBPDynMcWeQLLh9sCucQNJyRSFHTD1ls5zbvnTNuutqKbcVd
	 2/D/sbPwNva3NafVp2mXa6fzDye7Dr0YJO74ghd0IpJ4svVag2MEsEKbllMGPOFaXB
	 yZKZTGXbFd5A0XC5WOguBvIJ+ogDfpVmSLzBtQ8aaFnZiDT5roz378AGxU0Cs0Jl7g
	 cOR129yb77LRWYUT6q9WwvjgaMIebKAbVM5H2TWl293NIL68arozCJwBKM7mI5u88B
	 1N9KRnvXlfSALDR32hWnUk2p/Kit1WXMb19R1Wxy4zqEb1j33zwAYoVT0pWIswldS1
	 cDLymiOsuFxx+9JUg1fX4yC8=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C01D840E0031;
	Tue, 28 Nov 2023 08:36:34 +0000 (UTC)
Date: Tue, 28 Nov 2023 09:36:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin3.li@intel.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org, pbonzini@redhat.com,
	seanjc@google.com, peterz@infradead.org, jgross@suse.com,
	ravi.v.shankar@intel.com, mhiramat@kernel.org,
	andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
	nik.borisov@suse.com
Subject: Re: [PATCH v12 15/37] x86/ptrace: Cleanup the definition of the
 pt_regs structure
Message-ID: <20231128083629.GOZWWmjTe8l+IwXG5j@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-16-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231003062458.23552-16-xin3.li@intel.com>

On Mon, Oct 02, 2023 at 11:24:36PM -0700, Xin Li wrote:
> -/* Return frame for iretq */
> +
> +	/* The IRETQ return frame starts here */
>  	unsigned long ip;
> -	unsigned long cs;
> +
> +	union {
> +		u64	csx;	// The full 64-bit data slot containing CS
> +		u16	cs;	// CS selector

I know people want to start using those // one-line comments now but
this struct already uses the /* multiline ones. Can we stick to one type
pls, otherwise it'll turn into a mess.

And pls put those comments ontop, not on the side.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


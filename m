Return-Path: <kvm+bounces-37837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1366CA309F0
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA579166746
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856D71F9F73;
	Tue, 11 Feb 2025 11:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWdCVRoU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A438E1B85FD
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 11:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739273444; cv=none; b=nSuLMSszgaVg1nlt3BWGJJhYHm2PgmYNGXCfRM64lU5ajdUVbwUPTe41IrfZHp+6CcghDV4ZGnBL1rkQUo+GAg+YcEcrcVYg/bQ4ksCbgFzwD2/VORLFj0JgrbfG+mvcGKB8CrbhXWrzUadpLGP1kvEBZ3Eyl4gzDqb7JC7ksvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739273444; c=relaxed/simple;
	bh=Au4V4GsfEbiIpjsFHO9z48y1mHenDVZG2MEmp2xspsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbnt3UOdAldWiXTHsI1z8ZT3OIHGGlmXg7KBNJMhJFqbxf3NjT0HHykKsNENtGvn4ORkRYTxIB2R303ug/hUr1dD9p91Jo4sdFDTZK7ndVhHOs94HAvdl7zL3a0K4y3qV+6NUM5fiSXgC687ckOYOYgOI1BfQxn4J1tPnU5UZRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWdCVRoU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3462DC4CEDD;
	Tue, 11 Feb 2025 11:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739273444;
	bh=Au4V4GsfEbiIpjsFHO9z48y1mHenDVZG2MEmp2xspsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rWdCVRoUWSxLVVSqDU+KIsS4X3ZmNIydtCr9skK7QNvgfrBBpjgjHMUrP0MRX2BSL
	 shhx/zpSkY7F5IwPxZ2T0wh7jVsyjVsOnDWwjBXFKn+b2eUF9jsgnU+CNMAVjMUehC
	 ss2u17g2zM8CBUdJRf1qLsEWxN/gJlwy0fY/ZiUiagm3TMKDNLRPOzGIEMoHiqXCkf
	 o1q3wMjwa42Z1E1sijsXB4RvvfBlF0ZiFwBE6fAFo7HxK/Q3lpRGDujQpRc88CAFEl
	 K6PjvaOC0z/K029DfRiMwECbjGUK/A+FQCOJrHCtHiWTD2fweo+K66RsCVQTh/pzcc
	 iRgpiR/Gv9cPw==
Date: Tue, 11 Feb 2025 11:30:39 +0000
From: Will Deacon <will@kernel.org>
To: Anton Blanchard <antonb@tenstorrent.com>
Cc: kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
	apatel@ventanamicro.com
Subject: Re: [PATCH kvmtool] riscv: Allow initrd to be above 256MB on 64 bit
Message-ID: <20250211113039.GA8965@willie-the-truck>
References: <20250126073843.4005907-1-antonb@tenstorrent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250126073843.4005907-1-antonb@tenstorrent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

[+Anup]

On Sun, Jan 26, 2025 at 07:38:43AM +0000, Anton Blanchard wrote:
> Signed-off-by: Anton Blanchard <antonb@tenstorrent.com>
> ---
>  riscv/kvm.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/riscv/kvm.c b/riscv/kvm.c
> index 1d49479..191fc31 100644
> --- a/riscv/kvm.c
> +++ b/riscv/kvm.c
> @@ -109,16 +109,17 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
>  	unsigned long guest_addr, kernel_offset;
>  	ssize_t file_size;
>  
> +#if __riscv_xlen == 64
> +	limit = kvm->ram_start + kvm->ram_size - 1;
> +	/* Linux expects to be booted at 2M boundary for RV64 */
> +	kernel_offset = 0x200000;
> +#else
>  	/*
>  	 * Linux requires the initrd and dtb to be mapped inside lowmem,
>  	 * so we can't just place them at the top of memory.
>  	 */
>  	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
>  
> -#if __riscv_xlen == 64
> -	/* Linux expects to be booted at 2M boundary for RV64 */
> -	kernel_offset = 0x200000;
> -#else
>  	/* Linux expects to be booted at 4M boundary for RV32 */
>  	kernel_offset = 0x400000;
>  #endif

Patch looks fine to me, but it would be good to see an Ack from Anup
given that he's more familiar with the initrd limitations on riscv than
I am.

Will


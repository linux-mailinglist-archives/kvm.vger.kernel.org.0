Return-Path: <kvm+bounces-54782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A99B8B27EA6
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 12:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 340EE1894A0F
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 10:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52D92FFDEA;
	Fri, 15 Aug 2025 10:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GG8TmNAL"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA9319874;
	Fri, 15 Aug 2025 10:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755254798; cv=none; b=GrRjmf/gYc4ivOtq2vtK6RI69NuUwDrJALf/IRHtMCEZQli44KKdVk6Us+cN73f0va3v5eSUzB/SzrSBFSASBVdWFqutEGiKgN3JokFNJtbCBOuZh/qOwDUJV6QkcBMttd0RhxK0gys7y6wpaYADuqZ/PF4ssZkQ5bSBFY+QivE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755254798; c=relaxed/simple;
	bh=QIEf4bRjqwdIw7O9CtQqLo46rfzzGgRT2EkmUSxC7q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dy29RcqhPRthpq0NPGDF1Y6B2l6QqNQoiv8KpHqe/3Sl25IeNLnf9WIuXOl5DPQFgWTd29p5TQ43v2XIeJ7VHy9PpHcn8pC2uxpRhF2UzypJ7LoGG+TpauwfUyBEMBkLe5Ad+MMZ9XJa2cDcx1TuEtmQOuMt7uLNlQZ9UW0sMgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GG8TmNAL; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8579C40E0289;
	Fri, 15 Aug 2025 10:46:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vm8n5Tjcabrr; Fri, 15 Aug 2025 10:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755254790; bh=6sREfrXQXF1MMRVVqb2jaK8lR1Iy0sA+7FMnu50q+UU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GG8TmNALwllVrwNnhCHD2Jgguz/nL0ZTL+O/ziw1OVMu3vVceJQsrFfghPYNmTbzY
	 x66LZaEyDRve40AA149+SRe4uIxJimfNVykL6Kkzh3priJXSF7tp/JxQ9R4fhI2EBu
	 ou+9OLF9L5ZjZWcgtRSChpldt2LSEk7TBPUugQFbv/kru3dYr3XmKoE+NInGnHH2dX
	 2x1rIqVUMBQWuTyKQvYe02XaTUOKd5y4GEiPtzWq/Fal8JPnQoYglKoj8xRAqk/ImV
	 5qY7se9EU//4QhDsNLwWRZ712z8IZDmqoNhj9IplTf5xJWSJhwsNlT4XttXlE08vLu
	 qohx6k8lqyQCY7IR454G7U2rgdNh0oB9v1Rg8ZlzqgFZrUKm6236tw+L8FgMHWWNP7
	 MtKwTzsjiNTl6Q3BXPXzukF0lAGhX6Jo0Aoc3/DX3R8PpVssf2FJPKQluS25+9oXjn
	 jM77khAYByN3fc1oSNH3u4awvIf7onJEm9Z4AHWuSmBZKr4dt6sS1FyvPNtYIbAtrE
	 t8BtQUw+S2G3eJFgV99thRo5rT+KutkDfYf1OMzL6nZKYlVkSlcciRbO8cRvoiNErA
	 ZsZfd7bPJILKHTWUzgT5VqSPs1YPZIcu55FtCos24gKrNmkUja4BjAeF2tFhN2XbnD
	 6GBquVELfue/VcI1cbSlb35E=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1435F40E0254;
	Fri, 15 Aug 2025 10:46:07 +0000 (UTC)
Date: Fri, 15 Aug 2025 12:46:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kai Huang <kai.huang@intel.com>
Cc: dave.hansen@intel.com, tglx@linutronix.de, peterz@infradead.org,
	mingo@redhat.com, hpa@zytor.com, thomas.lendacky@amd.com,
	x86@kernel.org, kas@kernel.org, rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk, linux-kernel@vger.kernel.org,
	pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
	reinette.chatre@intel.com, isaku.yamahata@intel.com,
	dan.j.williams@intel.com, ashish.kalra@amd.com,
	nik.borisov@suse.com, chao.gao@intel.com, sagis@google.com,
	farrah.chen@intel.com
Subject: Re: [PATCH v6 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Message-ID: <20250815104601.GDaJ8P6efRLzRTD-2i@fat_crate.local>
References: <cover.1755126788.git.kai.huang@intel.com>
 <b88c6a54174a757f44e2f44492a21756be05dcda.1755126788.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b88c6a54174a757f44e2f44492a21756be05dcda.1755126788.git.kai.huang@intel.com>

On Thu, Aug 14, 2025 at 11:59:01AM +1200, Kai Huang wrote:
> During kexec, the kernel jumps to the new kernel in relocate_kernel(),
> which is implemented in assembly and both 32-bit and 64-bit have their
> own version.
> 
> Currently, for both 32-bit and 64-bit, the last two parameters of the
> relocate_kernel() are both 'unsigned int' but actually they only convey
> a boolean, i.e., one bit information.  The 'unsigned int' has enough
> space to carry two bits information therefore there's no need to pass
> the two booleans in two separate 'unsigned int'.
> 
> Consolidate the last two function parameters of relocate_kernel() into a
> single 'unsigned int' and pass flags instead.
> 
> Only consolidate the 64-bit version albeit the similar optimization can
> be done for the 32-bit version too.  Don't bother changing the 32-bit
> version while it is working (since assembly code change is required).
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
> 
>  v5 -> v6:
>   - Add Tom's RB.
> 
>  v4 -> v5:
>   - RELOC_KERNEL_HOST_MEM_ACTIVE -> RELOC_KERNEL_HOST_MEM_ENC_ACTIVE
>     (Tom)
>   - Add a comment to explain only RELOC_KERNEL_PRESERVE_CONTEXT is
>     restored after jumping back from peer kernel for preserved_context
>     kexec (pointed out by Tom).
>   - Use testb instead of testq when comparing the flag with R11 to save
>     3 bytes (Hpa).
> 
>  v4:
>   - new patch
> 
> 
> ---
>  arch/x86/include/asm/kexec.h         | 12 ++++++++++--
>  arch/x86/kernel/machine_kexec_64.c   | 22 +++++++++++++---------
>  arch/x86/kernel/relocate_kernel_64.S | 25 +++++++++++++++----------
>  3 files changed, 38 insertions(+), 21 deletions(-)

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


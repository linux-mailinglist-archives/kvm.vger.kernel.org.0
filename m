Return-Path: <kvm+bounces-55855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D39B37DDB
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05800460DB6
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66AD280A3B;
	Wed, 27 Aug 2025 08:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Evxx4xCW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0732F5488;
	Wed, 27 Aug 2025 08:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756283411; cv=none; b=juv9uAPp058yiZMLbathNpKDo54/gzRkOk9AZVn9Q7yz3O6eTWdhdkGk1B8+c5T74TuChkmbXtJ50lTcq1m6TcSLdlUN9DacYSkvdBQCggAaC5mRmZrH3HbR/YS2Hc8xcla1xWHs81xeiOfyJMdFJrC2FGr0PsPLIPkfUv3oapg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756283411; c=relaxed/simple;
	bh=ug3wSCgAifIcIx9UtNYJHfScn3iJIoThJ91pQxKRDOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHJKSoS7PienCUi+mbwAVf9fmh7M9Sx9av9lxTGEnCzGjSh6P07A/vPAmk6IDQH2QhJU23CZ0vJMeX4dj2Abul4Q5InN4DqbsI17R0PWtnELYMHZmCmhJU8TE0XrApPtnOZhNfYKqmhvBSFWAn7WDn+EZ5EMUzzwcniLpJ3sE4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Evxx4xCW; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C073D40E00DA;
	Wed, 27 Aug 2025 08:30:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Uu35_fYwftNZ; Wed, 27 Aug 2025 08:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756283402; bh=sbwN2qrGT6GexdljPB+Nyh9XLHsVDJbgKYHS+rIwOVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Evxx4xCWEHmpRd2SkA7cyYaxuQ49hedSonLXtSPCmoaLQIzByX6Z8t3ThisQwEDAI
	 xKXvd565rW3pVAzT0JhPoIUK1dbPEybqdLobFlVkEZ5LT43vjGWGUoxL7AC1Ug+6l2
	 3rMuR4sTVnplGJgzi6yE+0RnS7kmkedOEQDK54+exvgRr4Qfj3hgc2IFpSRXc4V5Ja
	 jPcakOU9mgJ1lVvnhVjEo2PkwMKv2n4N4ApDN+3WNx21du7xGbJP7gET+7ypd4gTHT
	 0a/5D4Ac9V6VqDpTqvNuiw2zfF7uNE0TKgf9UX58CNJQycWPrL0Ok7MxnNJzINCMgy
	 a6yHhiIdvNFgfPo87XDcUiW3PtVGI/PBmL/thZxUd2zDRiVSE46O3Vfo4jHgG659XD
	 Ewtm6f4Rm1QuJI5fb91yTgOWfDCRlGv6htqdCNKZZD7k+Nt+PkGlhewGmMh2tNE8Q4
	 f90u5zOC81NOkKrENfR9xIymPrEXeaY/LkNoygSNtF/0pNDmbQb3hWZAQJ4LUO7QxN
	 IBPWwOHvZv2Bw9JQ+GXT6MD6jUc5BJbWqa9TpUMvJPlzUbbrutsJ0+/81EvUoQax+c
	 bvdCjVfzXwLscWkGipMi7cwd4rE+Vv2dR8gzV4fkMJVZBDb4XIiDIqly4h4vcpL10m
	 py87qX5tsnsxxe0co6O6uUA4=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 152BF40E0185;
	Wed, 27 Aug 2025 08:29:37 +0000 (UTC)
Date: Wed, 27 Aug 2025 10:29:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, vannapurve@google.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, kai.huang@intel.com,
	reinette.chatre@intel.com, xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>,
	yan.y.zhao@intel.com, chao.gao@intel.com
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Message-ID: <20250827082932.GBaK7B7CdT1gd68C8T@fat_crate.local>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
 <7c5ae62f-c4c7-41d8-af00-7a517e3ed309@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7c5ae62f-c4c7-41d8-af00-7a517e3ed309@intel.com>

On Wed, Aug 27, 2025 at 11:22:07AM +0300, Adrian Hunter wrote:
> +#ifdef CONFIG_X86_MCE_INTEL
> +static __always_inline void tdx_extract_err_addr(struct mce *m)
> +{
> +	if (boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
> +		m->addr &= GENMASK_ULL(boot_cpu_data.x86_phys_bits - 1, 0);

Right, you can stick that thing straight into mce_read_aux() since it is
simple enough and drop the ifdeffery and use cpu_feature_enabled():

mce_read_aux:

	...

	/* Remove TDX KeyID from the address */
	if (cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM))
		m->addr &= GENMASK_ULL(boot_cpu_data.x86_phys_bits - 1, 0);

Something like that...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


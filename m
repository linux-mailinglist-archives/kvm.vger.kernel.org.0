Return-Path: <kvm+bounces-3628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A279D805EE7
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E91E281C43
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 19:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EB96ABB7;
	Tue,  5 Dec 2023 19:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OT/1DqtS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E74C9;
	Tue,  5 Dec 2023 11:57:13 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F08AF40E01AD;
	Tue,  5 Dec 2023 19:57:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id yUI_HMj3NT8T; Tue,  5 Dec 2023 19:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701806228; bh=0ed9OPSTfc1dN0NWcDDbS/2OlgMY/T1QuKWh5NkbUgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OT/1DqtSzk7faj98jQBTLdFpMrsESxnG5QwmxeJTud1hoYYcnN2KAqMM9awCZaJP5
	 24Vui5SNtjuwlBCAm9ExcTolTnEmC3Fnd7gLOYWeVCKJzeaNYemx45zNUjCt7+C2ku
	 W8wSEErOV8qSNAZQ0dAWnSSKbNpGARghUvPPs9xVgmk2ThN2ErXXYTFZqbC05yoltP
	 0+GWfryX/e7wDN9nFUPizJ64TbE2TBg54GP31fhxdrNkGLLBlWgyfuKofMG1npua9W
	 aJmOrBRxHRApGIN0j+0d6Jdu0t5YhLRhy62iu6ERkIEbNKasC1xF5YNFqoKYL3T7em
	 hwz5J3VKUGfGjuyeZQJ2hnK8KVGfWm0H7vRt6WMvd8Ufj2Nsruj9tinM1fKQbaYIvs
	 2dcREWAejYsXoVojQtOyK63jxRYUJvAhEjVGCLz+L7wZ3nCY6HyKg7OEcl8lRpc7Fe
	 oHtmeubTzm9t6jYtkKpq1UxZrk3MmSsX0CjmbawlawH/oZAIWLF4AHU5T5Kxinkoev
	 Z9EpHkdzincnuzF6+qYwKhbim9iHzaLtx3S9KlyZPQU1ppWCZwpURrZY9HJvftQbOI
	 CqtWZ3SFmBYCrXHAqoSHy5pcmz0/jYc9c4MBk70PTqWj4VEgbmdsH/t0vlLmvc4OB0
	 Jb9xojiRyELUIvBIDmzxYWVE=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6BB7740E014B;
	Tue,  5 Dec 2023 19:56:42 +0000 (UTC)
Date: Tue, 5 Dec 2023 20:56:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com" <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"ak@linux.intel.com" <ak@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>,
	"imammedo@redhat.com" <imammedo@redhat.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"Brown, Len" <len.brown@intel.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Message-ID: <20231205195637.GHZW+Add3H/gSefAVM@fat_crate.local>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
 <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
 <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>

On Tue, Dec 05, 2023 at 07:41:41PM +0000, Huang, Kai wrote:
> -static const char *mce_memory_info(struct mce *m)
> +static const char *mce_dump_aux_info(struct mce *m)
>  {
> -       if (!m || !mce_is_memory_error(m) || !mce_usable_address(m))
> -               return NULL;
> -
>         /*
> -        * Certain initial generations of TDX-capable CPUs have an
> -        * erratum.  A kernel non-temporal partial write to TDX private
> -        * memory poisons that memory, and a subsequent read of that
> -        * memory triggers #MC.
> -        *
> -        * However such #MC caused by software cannot be distinguished
> -        * from the real hardware #MC.  Just print additional message
> -        * to show such #MC may be result of the CPU erratum.
> +        * Confidential computing platforms such as TDX platforms
> +        * may occur MCE due to incorrect access to confidential
> +        * memory.  Print additional information for such error.
>          */
> -       if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
> +       if (!m || !mce_is_memory_error(m) || !mce_usable_address(m))
>                 return NULL;

What's the point of doing this on !TDX? None.

> -       return !tdx_is_private_mem(m->addr) ? NULL :
> -               "TDX private memory error. Possible kernel bug.";
> +       if (platform_tdx_enabled())

So is this the "host is TDX" check?

Not a X86_FEATURE flag but something homegrown. And Kirill is trying to
switch the CC_ATTRs to X86_FEATURE_ flags for SEV but here you guys are
using something homegrown.

why not a X86_FEATURE_ flag?

The CC_ATTR things are for guests, I guess, but the host feature checks
should be X86_FEATURE_ flags things.

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


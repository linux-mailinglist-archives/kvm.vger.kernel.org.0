Return-Path: <kvm+bounces-3579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E71F6805746
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 15:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2B62281B92
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 14:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C6865EC4;
	Tue,  5 Dec 2023 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kgh5wyRV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C744D183;
	Tue,  5 Dec 2023 06:25:54 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4159340E0173;
	Tue,  5 Dec 2023 14:25:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LWkzj2GtuatA; Tue,  5 Dec 2023 14:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701786348; bh=6F+/RPhB9lKVw4huSkDDXm/bjBM3T+9fTprCXpFgfjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kgh5wyRVDx3Q+5phGnCP1FvPZByejUfqJ0E59NiY64BWKbMWLRVxc+LyEN93Kke10
	 PhahORLdeA/Ez/hruDwyBL6Q3rW7pPwQZNqIKK6cJQmMAkgIiTFvQG5WAEdRjOhdzo
	 +wh7DzuFfMJJLJ4WiGHwSavfGDnZ8UIdE9MxHevKoq5UOMAIHoT7KoLl8MNmzliXuP
	 eoLbyYGwJwgz6AIspFsHl8+VMJTXbgAB9+5x8gXIXPmNh5YizlYlxdlbnLsDGiOBNI
	 XwKPVnRclRhRZX/ny75i5dt578g2i1HyGwLwKEIoyjAEXFYXCFqHVHkieK2u75Thp7
	 mFFnES5CjAy7QAm8uJ9QZ3jnefWQe8S+g+f5KcgAhMw6O7P8nRXN0SWCRH5c8fVbWp
	 AmLDRsxrJZGXsuxwh7LnONvc6jfHKMhc8DWiAWELsd8+T0iF5u3t19KgKb0hSFS1pu
	 V53d0R+BUUa+rzFH0mr/WArU4CbY6bniO1tG+wB0yc8DIDBRkiaBirRHGFLTAKeXoP
	 KcA0UfL9cjgGA3Z2iU0F85UgyvZpPCwAKP76+piWyK4Hu7Hde5/1Qybqv5cqTWWNvq
	 C9V56lAjimDyAM7R03SpNMzsjjDx3ZstKmKczG2lh4qzhNkpdMahyEirnF8GrZ9W+7
	 COsIwD9U6XMDaMSE22AMHVQE=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2399C40E014B;
	Tue,  5 Dec 2023 14:25:22 +0000 (UTC)
Date: Tue, 5 Dec 2023 15:25:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
	peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
	dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
	isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
	bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Message-ID: <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>

On Fri, Nov 10, 2023 at 12:55:59AM +1300, Kai Huang wrote:
> +static const char *mce_memory_info(struct mce *m)
> +{
> +	if (!m || !mce_is_memory_error(m) || !mce_usable_address(m))
> +		return NULL;
> +
> +	/*
> +	 * Certain initial generations of TDX-capable CPUs have an
> +	 * erratum.  A kernel non-temporal partial write to TDX private
> +	 * memory poisons that memory, and a subsequent read of that
> +	 * memory triggers #MC.
> +	 *
> +	 * However such #MC caused by software cannot be distinguished
> +	 * from the real hardware #MC.  Just print additional message
> +	 * to show such #MC may be result of the CPU erratum.
> +	 */
> +	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
> +		return NULL;
> +
> +	return !tdx_is_private_mem(m->addr) ? NULL :
> +		"TDX private memory error. Possible kernel bug.";
> +}
> +
>  static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
>  {
>  	struct llist_node *pending;
>  	struct mce_evt_llist *l;
>  	int apei_err = 0;
> +	const char *memmsg;
>  
>  	/*
>  	 * Allow instrumentation around external facilities usage. Not that it
> @@ -283,6 +307,15 @@ static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
>  	}
>  	if (exp)
>  		pr_emerg(HW_ERR "Machine check: %s\n", exp);
> +	/*
> +	 * Confidential computing platforms such as TDX platforms
> +	 * may occur MCE due to incorrect access to confidential
> +	 * memory.  Print additional information for such error.
> +	 */
> +	memmsg = mce_memory_info(final);
> +	if (memmsg)
> +		pr_emerg(HW_ERR "Machine check: %s\n", memmsg);
> +

No, this is not how this is done. First of all, this function should be
called something like

	mce_dump_aux_info()

or so to state that it is dumping some auxiliary info.

Then, it does:

	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
		return tdx_get_mce_info();

or so and you put that tdx_get_mce_info() function in TDX code and there
you do all your picking apart of things, what needs to be dumped or what
not, checking whether it is a memory error and so on.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


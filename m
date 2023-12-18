Return-Path: <kvm+bounces-4701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95DE0816ABB
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 11:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51FE0281AAE
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF94513FFA;
	Mon, 18 Dec 2023 10:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fxXH5ry6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B56613ADC;
	Mon, 18 Dec 2023 10:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6872A40E00CB;
	Mon, 18 Dec 2023 10:14:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6gSLe3VmLbrr; Mon, 18 Dec 2023 10:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702894476; bh=flSmrHICJg+bcSVL2Gg7M4juB6JLxKEwKyo/mAL/FNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fxXH5ry6RnlJenPbiE6v3VXxmsrkTHM5Uupmu165JWWiAgHehbqsc4BccpJeJIvU8
	 oXOGZQSlClpqYfk9UrVG5efKbQfGG5lplRVjyUkvs7/EnP/i4LidFQY8B8sXqRFGOf
	 gSrXskQuCeEvDZw/RF0HGvuWPfYcBwYD0dxz2cGonJub0ZJoz9pL9YoG8xHPYeVjtW
	 IaKfeyG5f01ZyhG0Cp7zXMkqHPwuxBtWVtatD0ID+/X+ENwTRoFPYzXmsEDBon+zSu
	 qrdQDWTFEpqTEWvDlXNwLUMhtXlWTUfww0YrzpWJm5BX+D66wTTz9HW6ouIxdpWFN+
	 GGxS5Keuc7leOliayFRH/y3lI/J5L+VLaqHA5qoVC14rNgEiU3Rs7dqlxnyve/h2Zp
	 T9Yos25zGBBBjcERWxAjXWVE0fz86AxGoIY2/qJBS1qJ4+zmeaEgE2Rl7uoWw5oZht
	 oIm33Tv8ybUANBaOyOpHbLe255QGVCCuE1hlKw25bG78+eVCamI9/21sWhJ/YpNPsj
	 KfL+zMlrYgLiJNedm2V2L7fhzneY312Oa7Fs2L4M6nm2LMEHW2GP3UsTpPy7LDtoV3
	 B2qaVZ7dNmD5lOAA+vlsn7ugICNiIo5NC/1e3svNnFoU2nS/4+jLd2rfnCoJbEzDjG
	 uJP/vqTMNYhv3VA64TRIqrI8=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3532640E0030;
	Mon, 18 Dec 2023 10:13:57 +0000 (UTC)
Date: Mon, 18 Dec 2023 11:13:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, marcorr@google.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
Subject: Re: [PATCH v10 20/50] KVM: SEV: Select CONFIG_KVM_SW_PROTECTED_VM
 when CONFIG_KVM_AMD_SEV=y
Message-ID: <20231218101350.GAZYAbXqYLXByk5Akw@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-21-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-21-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:49AM -0500, Michael Roth wrote:
> SEV-SNP relies on the restricted/protected memory support to run guests,
> so make sure to enable that support with the
> CONFIG_KVM_SW_PROTECTED_VM build option.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 8452ed0228cb..71dc506aa3fb 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -126,6 +126,7 @@ config KVM_AMD_SEV
>  	bool "AMD Secure Encrypted Virtualization (SEV) support"
>  	depends on KVM_AMD && X86_64
>  	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
> +	select KVM_SW_PROTECTED_VM
>  	help
>  	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
>  	  with Encrypted State (SEV-ES) on AMD processors.
> -- 

Kconfig doesn't like this one:

WARNING: unmet direct dependencies detected for KVM_SW_PROTECTED_VM
  Depends on [n]: VIRTUALIZATION [=y] && EXPERT [=n] && X86_64 [=y]
  Selected by [m]:
  - KVM_AMD_SEV [=y] && VIRTUALIZATION [=y] && KVM_AMD [=m] && X86_64 [=y] && CRYPTO_DEV_SP_PSP [=y] && (KVM_AMD [=m]!=y || CRYPTO_DEV_CCP_DD [=m]!=m)

WARNING: unmet direct dependencies detected for KVM_SW_PROTECTED_VM
  Depends on [n]: VIRTUALIZATION [=y] && EXPERT [=n] && X86_64 [=y]
  Selected by [m]:
  - KVM_AMD_SEV [=y] && VIRTUALIZATION [=y] && KVM_AMD [=m] && X86_64 [=y] && CRYPTO_DEV_SP_PSP [=y] && (KVM_AMD [=m]!=y || CRYPTO_DEV_CCP_DD [=m]!=m)


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


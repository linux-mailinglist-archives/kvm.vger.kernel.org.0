Return-Path: <kvm+bounces-2438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E15F7F766D
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 15:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDDF5B21522
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 14:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9762D61F;
	Fri, 24 Nov 2023 14:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="C4ZWuUa1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280D519A4;
	Fri, 24 Nov 2023 06:37:22 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7046940E0258;
	Fri, 24 Nov 2023 14:37:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PRqga3sbJpbf; Fri, 24 Nov 2023 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1700836637; bh=ohccp6emLwawWzvtIzIh09L/4m/V7F4sqEbEIpoSnq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4ZWuUa1L7kfp2HdFjJoJ/VJsOFVSUnC0gO9qFwTG3YmBCUPdTYsVqDGWCWhKhwWt
	 bPMfC5FW5UvB9dmwy2CIqzCbKbi5cBjMdkDEa0CeXp+5M+QzDtnelk9TLL/EgQ5NHj
	 McXjzfHSJsgjpj9MqRmHPWcJCCMrAogxjUm0/Jsc72ebMXkCNQAv2djjGq5eNffoAf
	 OMq7FM/q2dgI4mAq6K/W2UfryaZEHOZo9PgaPQCJavHEyqMeOtbKdsxzha219KEvZA
	 X4wIE/IZYEGPevYKN2YBtPnPL5DpnWEEeMQiu/VmvTlcQD+X7yrx99Yo3AdwDF84Ox
	 hyEAoTZMYPGcbo29lPJ7jZX5gfw9buYqXMNsN85LAYacotEiG6IZhHOjIZnf6V/qGJ
	 D4elq+EAdSdHpU94MOeTRjyBVHsxMDXkGH0vd/cN/mdU/okeck6NZxDB9cxZmMQxdS
	 DdAcDBO8v99bXDYNhp74RKKFrlGzQVHoUWww+ITXNOeS5ImW+fkWgECNI4J6p5HHzc
	 tWYWb2LREZVw1alEGmVBJNZW9xdLYefPQ2qHOTWEU8lOdrrttsoCdCD/HPkTNRKylD
	 PudnxC5CBKqZvR0VTaguz2OUBxIbOEGUGX5BFTAzbznuxMmWe5UgIF62+gJycHagac
	 eB1F7hjjZjigIKjjHsZGVU5M=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AD93F40E014B;
	Fri, 24 Nov 2023 14:36:36 +0000 (UTC)
Date: Fri, 24 Nov 2023 15:36:30 +0100
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 13/50] crypto: ccp: Define the SEV-SNP commands
Message-ID: <20231124143630.GKZWC07hjqxkf60ni4@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-14-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-14-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:42AM -0500, Michael Roth wrote:
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 7fd17e82bab4..a7f92e74564d 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -78,6 +78,36 @@ enum sev_cmd {
>  	SEV_CMD_DBG_DECRYPT		= 0x060,
>  	SEV_CMD_DBG_ENCRYPT		= 0x061,
>
> +	/* SNP specific commands */
> +	SEV_CMD_SNP_INIT			= 0x81,

The other commands start with "0x0" - pls do that too here or unify with
a pre-patch.

> +	SEV_CMD_SNP_SHUTDOWN			= 0x82,
> +	SEV_CMD_SNP_PLATFORM_STATUS		= 0x83,
> +	SEV_CMD_SNP_DF_FLUSH			= 0x84,
> +	SEV_CMD_SNP_INIT_EX			= 0x85,
> +	SEV_CMD_SNP_SHUTDOWN_EX			= 0x86,
> +	SEV_CMD_SNP_DECOMMISSION		= 0x90,
> +	SEV_CMD_SNP_ACTIVATE			= 0x91,
> +	SEV_CMD_SNP_GUEST_STATUS		= 0x92,
> +	SEV_CMD_SNP_GCTX_CREATE			= 0x93,
> +	SEV_CMD_SNP_GUEST_REQUEST		= 0x94,
> +	SEV_CMD_SNP_ACTIVATE_EX			= 0x95,
> +	SEV_CMD_SNP_LAUNCH_START		= 0xA0,
> +	SEV_CMD_SNP_LAUNCH_UPDATE		= 0xA1,
> +	SEV_CMD_SNP_LAUNCH_FINISH		= 0xA2,
> +	SEV_CMD_SNP_DBG_DECRYPT			= 0xB0,
> +	SEV_CMD_SNP_DBG_ENCRYPT			= 0xB1,
> +	SEV_CMD_SNP_PAGE_SWAP_OUT		= 0xC0,
> +	SEV_CMD_SNP_PAGE_SWAP_IN		= 0xC1,
> +	SEV_CMD_SNP_PAGE_MOVE			= 0xC2,
> +	SEV_CMD_SNP_PAGE_MD_INIT		= 0xC3,
> +	SEV_CMD_SNP_PAGE_SET_STATE		= 0xC6,
> +	SEV_CMD_SNP_PAGE_RECLAIM		= 0xC7,
> +	SEV_CMD_SNP_PAGE_UNSMASH		= 0xC8,
> +	SEV_CMD_SNP_CONFIG			= 0xC9,
> +	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX	= 0xCA,

You don't have to vertically align those to a different column due to
this command's name not fitting - just do:

        SEV_CMD_SNP_CONFIG              = 0x0C9,
        SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
        SEV_CMD_SNP_COMMIT              = 0x0CB,




> +	SEV_CMD_SNP_COMMIT			= 0xCB,
> +	SEV_CMD_SNP_VLEK_LOAD			= 0xCD,
> +
>  	SEV_CMD_MAX,
>  };

...

> +/**
> + * struct sev_data_snp_launch_start - SNP_LAUNCH_START command params
> + *
> + * @gctx_addr: system physical address of guest context page
> + * @policy: guest policy
> + * @ma_gctx_addr: system physical address of migration agent
> + * @imi_en: launch flow is launching an IMI for the purpose of

What is an "IMI"?

Define it once for the readers pls.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


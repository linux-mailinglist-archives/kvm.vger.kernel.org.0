Return-Path: <kvm+bounces-4214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4272480F3F0
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73C291C20CBE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F278B7B3C9;
	Tue, 12 Dec 2023 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Qz/TWsr2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046FF8F;
	Tue, 12 Dec 2023 09:03:41 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2BBAE40E00CC;
	Tue, 12 Dec 2023 17:03:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Vm7FEEs-_cWK; Tue, 12 Dec 2023 17:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702400615; bh=bhGdrNYqkE3/Qchjg60u36U+e6yzbXIMev4JIq22et0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qz/TWsr2SuS+rR9NHM8oG8oRO23j/1hP7zP0koAIDJ8cigbTGJMi1m2CVlCkSg4O7
	 yzfpnlyeeZ4H0zEiF5UExO4iH0hG7goOGgN0i6auEOOoyxNkK1OqppS7wFb17OKFi4
	 vxPvuCMRmQQLluK4kCOzAvdBN1+RZPb3UIsmOJ+u3UlWTU5zft5kq7FSVZQ181fyTm
	 dMurleDtkvRTuEI8Wc23PX6fhhFNYeATvmmFVPqQs3qHIwKyDD1qctfjZ6UNWjUNEi
	 7MeotyBqeUjkbG8v9HYIqkhxiLCtW0lj6/KG5M0AHfpzCWtDDWJOottvj0mv24ONy5
	 4cm7wGcpwo8MRycvT5RPIxvCCVBVVKD/6W22hOJJ+sFG7YYv4Q2olyDETSiAtk/ssQ
	 J+mMzfxEMzYEpksruaro5BpV1nKHL3x2RV5obNWklibXo4HwKS8wmZUePV/0mjm/qn
	 BA3nRWgth3HfEbXYxOKXhe9M6b77u4d43t+/gaiZECI9hDG7KOylcSuj4MVSbz06LR
	 0p2UMW6G2egnJOxYYy+0rvltabYNwkVYQ777nM3XFaiuA77EWx/mWNFfNQTLUsOW8d
	 nBGxEQ+vRuR/Mj4/bR7FtS9PN1bNV7SYzYExdUV0d3aHAJiWEGs4a+M+j6qaGAmoda
	 /SKfuf7xGSNRMf7dTWdEI6YY=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B914040E00CB;
	Tue, 12 Dec 2023 17:02:54 +0000 (UTC)
Date: Tue, 12 Dec 2023 18:02:53 +0100
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
Subject: Re: [PATCH v10 21/50] KVM: SEV: Add support to handle AP reset MSR
 protocol
Message-ID: <20231212170253.GLZXiSPfJWXfuXzuM9@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-22-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-22-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:50AM -0500, Michael Roth wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Add support for AP Reset Hold being invoked using the GHCB MSR protocol,
> available in version 2 of the GHCB specification.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  2 ++
>  arch/x86/kvm/svm/sev.c            | 56 ++++++++++++++++++++++++++-----
>  arch/x86/kvm/svm/svm.h            |  1 +
>  3 files changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 93ec8c12c91d..57ced29264ce 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -56,6 +56,8 @@
>  /* AP Reset Hold */
>  #define GHCB_MSR_AP_RESET_HOLD_REQ	0x006
>  #define GHCB_MSR_AP_RESET_HOLD_RESP	0x007
> +#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
> +#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)

Align vertically pls.

>  /* GHCB GPA Register */
>  #define GHCB_MSR_REG_GPA_REQ		0x012
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6ee925d66648..4f895a7201ed 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -65,6 +65,10 @@ module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>  #define sev_es_debug_swap_enabled false
>  #endif /* CONFIG_KVM_AMD_SEV */
>  
> +#define AP_RESET_HOLD_NONE		0
> +#define AP_RESET_HOLD_NAE_EVENT		1
> +#define AP_RESET_HOLD_MSR_PROTO		2
> +
>  static u8 sev_enc_bit;
>  static DECLARE_RWSEM(sev_deactivate_lock);
>  static DEFINE_MUTEX(sev_bitmap_lock);
> @@ -2594,6 +2598,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  {
> +	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
> +	svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_NONE;
> +
>  	if (!svm->sev_es.ghcb)
>  		return;
>  
> @@ -2805,6 +2812,22 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  				  GHCB_MSR_INFO_POS);
>  		break;
>  	}
> +	case GHCB_MSR_AP_RESET_HOLD_REQ:
> +		svm->sev_es.ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
> +		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
> +
> +		/*
> +		 * Preset the result to a non-SIPI return and then only set
> +		 * the result to non-zero when delivering a SIPI.
> +		 */
> +		set_ghcb_msr_bits(svm, 0,
> +				  GHCB_MSR_AP_RESET_HOLD_RESULT_MASK,
> +				  GHCB_MSR_AP_RESET_HOLD_RESULT_POS);

Yikes, those defines are a mouthful.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


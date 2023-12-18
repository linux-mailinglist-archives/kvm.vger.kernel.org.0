Return-Path: <kvm+bounces-4704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F355A816AED
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 11:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95A261F21A7B
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B1114AB6;
	Mon, 18 Dec 2023 10:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jyDBqdNM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7E913FE9;
	Mon, 18 Dec 2023 10:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8D96440E0030;
	Mon, 18 Dec 2023 10:24:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id VU4bhOjEhgIz; Mon, 18 Dec 2023 10:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702895084; bh=+qd2C9CoTRT8YdE7RLTwVb7qNN/yqYEkDFQLfrBIgLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jyDBqdNMXR+jZLcCyXJ4YR2GJc9LKFzUfKQU3+hzFPr2OQcmEZmCb/QfiQ9fGD0J9
	 eQYwFxWWXMCvdmIB+F0qxZDDtmSCXC0qZbY41Wjb2pXH1THKaSUAfgZ58i5kPY7QSL
	 WSWSVpxOHcPCd6xS9yGOuh+n+HxUm53a+/piNO0RL9Zjvu9V7zukW0vt81gfS74Dcx
	 aA0wUPFu+W3LkrEt1Wkc3fLEPFALNemjO22dBaz2Q4T8BrzSeI3Sng4aozUlUX2EEu
	 SaEz5M3ODAere1yfS09GTlW6/kVi5rIfYwk1LD7QVs7lPCFolNwcpGcIOB2HSzfaTV
	 MItf1qGYtHgocHKjCn9euwhsyDZmnBVeKMziA0/hLgGbE9u1G/VD3PToB4mKfWlf4X
	 xxtCVWvGGRgUqIkgt6yT/Ri7odTlfxrE3BL0M94Zk3Eykmmnkm+C+OnN/HG0Gv1sVR
	 I9GjsRFtMrl3xUHXPjp2MZ9curGgNAmGbHh88r3Y9Ec13kZ6HaS+iBgpwvIhDmpiIo
	 i5uFIBoZ/R/BFQVomO/iT/1hireFV74sUd2IBJb95rD/0LsCqfzRzG1Hdc0Bodjwff
	 BEfsF00lawewiDqL8njMUlKG1PHYVIQ7lZulWHIFedIHeyLzkmsUsdx/uARXly9hqc
	 hy9nZw4cu/qb4T4O6GAl8IY0=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E8A8140E00CB;
	Mon, 18 Dec 2023 10:24:03 +0000 (UTC)
Date: Mon, 18 Dec 2023 11:23:57 +0100
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
Subject: Re: [PATCH v10 22/50] KVM: SEV: Add GHCB handling for Hypervisor
 Feature Support requests
Message-ID: <20231218102357.GPZYAdvfG5jNyajyu6@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-23-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-23-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:51AM -0500, Michael Roth wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4f895a7201ed..088b32657f46 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2568,6 +2568,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	case SVM_VMGEXIT_AP_HLT_LOOP:
>  	case SVM_VMGEXIT_AP_JUMP_TABLE:
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
> +	case SVM_VMGEXIT_HV_FEATURES:
>  		break;
>  	default:
>  		reason = GHCB_ERR_INVALID_EVENT;
> @@ -2828,6 +2829,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  				  GHCB_MSR_INFO_MASK,
>  				  GHCB_MSR_INFO_POS);
>  		break;
> +	case GHCB_MSR_HV_FT_REQ: {
				^^^

No need to have a statement block here. Neither below.


> +		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
> +				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
> +		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
> +				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
> +		break;
> +	}
>  	case GHCB_MSR_TERM_REQ: {
>  		u64 reason_set, reason_code;
>  
> @@ -2952,6 +2960,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		ret = 1;
>  		break;
>  	}
> +	case SVM_VMGEXIT_HV_FEATURES: {
				      ^^^^

> +		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
> +
> +		ret = 1;
> +		break;
> +	}
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>  		vcpu_unimpl(vcpu,
>  			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


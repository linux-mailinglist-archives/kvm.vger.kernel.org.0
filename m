Return-Path: <kvm+bounces-13005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD4088FE5D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 12:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F21E2963E1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5747E781;
	Thu, 28 Mar 2024 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eoPQlc2s"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6724652F6D;
	Thu, 28 Mar 2024 11:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711626681; cv=none; b=Pc5wYwz71qY4Jirc+lsHCM8oZX9RU/CjoOXlUyS9yMBGQ8Tpew5RNdVmrXKLhYoM8tbAeJvFVGTlYh9nvjVh/Ke+cNp4osbD/cC58+jKyKigjkbe7ywr78AQ+9t59aOyQ//lt6UMH9bR+xeCrJ/yhbGZI0O9Pu1F6viBigWQqiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711626681; c=relaxed/simple;
	bh=VRWpZuzTi9BB9aD9AW0vWrU/mW+SthyAngwyb6SSFYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I7/60LqDRIE0hj4GdKWTMWNBlWKXAu68Zqivk5BLc7lTGl0/BbZqyqXIVbx9txM8nwdEnAWsz2ksbJP27/9eV4ZPhOMVgn99MGBh0S9ZiAnq07iMdc3dDa6IExQJ5UTuRxQpxIJQCazjkaf5gQIYqvnESRqchMtzoFcT9sQb+mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eoPQlc2s; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.66.160.44] (unknown [108.143.43.187])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2F24D20E65E2;
	Thu, 28 Mar 2024 04:51:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2F24D20E65E2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1711626679;
	bh=EQj1f3YmM4oHN7Og4pfPO34QJHC8rf9eB1kPh7mDNtY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eoPQlc2s2nL3pKGB5SoHSgVaolp+ObpGgJThP7ADHQPROshOuJiM+w5mrfkDUBueq
	 XbmLO/KjRNVCKq9JrZCcDEnN1MX4FBY8xJQgYsfcDcq02ccFZ6fkYQy0kFvQ6iXVEu
	 nmfGEQxAGCq4JNhX+8cnTE64+2XOPVXEdPdd3qYc=
Message-ID: <f6bb6f62-c114-4a82-bbaf-9994da8999cd@linux.microsoft.com>
Date: Thu, 28 Mar 2024 12:51:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] x86/CPU/AMD: Track SNP host status with
 cc_platform_*()
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-6-bp@alien8.de>
Content-Language: en-CA
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20240327154317.29909-6-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/2024 16:43, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> The host SNP worthiness can determined later, after alternatives have
> been patched, in snp_rmptable_init() depending on cmdline options like
> iommu=pt which is incompatible with SNP, for example.
> 
> Which means that one cannot use X86_FEATURE_SEV_SNP and will need to
> have a special flag for that control.
> 
> Use that newly added CC_ATTR_HOST_SEV_SNP in the appropriate places.
> 
> Move kdump_sev_callback() to its rightfull place, while at it.
> 
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> ---
>  arch/x86/include/asm/sev.h         |  4 ++--
>  arch/x86/kernel/cpu/amd.c          | 38 ++++++++++++++++++------------
>  arch/x86/kernel/cpu/mtrr/generic.c |  2 +-
>  arch/x86/kernel/sev.c              | 10 --------
>  arch/x86/kvm/svm/sev.c             |  2 +-
>  arch/x86/virt/svm/sev.c            | 26 +++++++++++++-------
>  drivers/crypto/ccp/sev-dev.c       |  2 +-
>  drivers/iommu/amd/init.c           |  4 +++-
>  8 files changed, 49 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 9477b4053bce..780182cda3ab 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -228,7 +228,6 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
>  void snp_accept_memory(phys_addr_t start, phys_addr_t end);
>  u64 snp_get_unsupported_features(u64 status);
>  u64 sev_get_status(void);
> -void kdump_sev_callback(void);
>  void sev_show_status(void);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
> @@ -258,7 +257,6 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
>  static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
>  static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>  static inline u64 sev_get_status(void) { return 0; }
> -static inline void kdump_sev_callback(void) { }
>  static inline void sev_show_status(void) { }
>  #endif
>  
> @@ -270,6 +268,7 @@ int psmash(u64 pfn);
>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
>  int rmp_make_shared(u64 pfn, enum pg_level level);
>  void snp_leak_pages(u64 pfn, unsigned int npages);
> +void kdump_sev_callback(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
>  static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
> @@ -282,6 +281,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
> +static inline void kdump_sev_callback(void) { }
>  #endif
>  
>  #endif
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 6d8677e80ddb..9bf17c9c29da 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -345,6 +345,28 @@ static void srat_detect_node(struct cpuinfo_x86 *c)
>  #endif
>  }
>  
> +static void bsp_determine_snp(struct cpuinfo_x86 *c)
> +{
> +#ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> +	cc_vendor = CC_VENDOR_AMD;

Shouldn't this line be inside the cpu_has(c, X86_FEATURE_SEV_SNP) check?

> +
> +	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
> +		/*
> +		 * RMP table entry format is not architectural and is defined by the
> +		 * per-processor PPR. Restrict SNP support on the known CPU models
> +		 * for which the RMP table entry format is currently defined for.
> +		 */> +		if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&

How about turning this into a more specific check:

  if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) &&

Thanks,
Jeremi

> +		    c->x86 >= 0x19 && snp_probe_rmptable_info()) {
> +			cc_platform_set(CC_ATTR_HOST_SEV_SNP);
> +		} else {
> +			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +			cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
> +		}
> +	}
> +#endif
> +}
> +
>  static void bsp_init_amd(struct cpuinfo_x86 *c)
>  {
>  	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
> @@ -452,21 +474,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
>  		break;
>  	}
>  
> -	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
> -		/*
> -		 * RMP table entry format is not architectural and it can vary by processor
> -		 * and is defined by the per-processor PPR. Restrict SNP support on the
> -		 * known CPU model and family for which the RMP table entry format is
> -		 * currently defined for.
> -		 */
> -		if (!boot_cpu_has(X86_FEATURE_ZEN3) &&
> -		    !boot_cpu_has(X86_FEATURE_ZEN4) &&
> -		    !boot_cpu_has(X86_FEATURE_ZEN5))
> -			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> -		else if (!snp_probe_rmptable_info())
> -			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> -	}
> -
> +	bsp_determine_snp(c);
>  	return;
>  
>  warn:



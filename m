Return-Path: <kvm+bounces-68275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 13136D2945F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 259AB30116CA
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230E733120B;
	Thu, 15 Jan 2026 23:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HTl99NAw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EPYDk/Lq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D485B30F527
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768520238; cv=none; b=JDNxYnRwOR54/qXUGQW4Z8gDLWID4xxSchq66lEXSNGVKPBtR8TVsrhmgOVZM/f+roflrj/blcTipYUoj41JUpetTpi7ll8NOL9P36APzHSOX2jJ+JSau+44Nb3rZkU69W2rT3XM4Pd5AQvbc0H2SvPtiR4NMMmaFkIeHWqha4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768520238; c=relaxed/simple;
	bh=ftNavQ2sNKNlKu0jkcDCpl1T0ALVrV/fzOG0ghevBmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCseEw6EK2hpTX3Ma+ReQCLZ16jNm7WAcX8dx0dj9dIk871FO7VLNDu/VWG+xwfLp4Dd2VObTv1Y4+ZEC8vq6U5PWvv6+IoeNbRoWX7ooGHRCcgRvZeHY9t9hMW/BTz7rCdUZ1Nl5mnTLegt50ch6GfVWRgrzQSjAo6ZF9iaHP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HTl99NAw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EPYDk/Lq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FMbZ8n1240933
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Z2n8CWclOK+qAz33/QIvyokv
	GlStxnKTjh7o52+P4ZA=; b=HTl99NAwcrysLUNfE3tycmK4Btg3pFqr1HiWFBbD
	teWa20AywXozwyn/kXs0tFV8cSgG8yEYevRj2yfp43kVqXW1LhxwI7M2oU49JIpP
	ngvBiAhXCuezePq4mcRp1pz2eTDsajDyjEvkZFwu9VM+SHxLcfvTRKkuOiFYutXz
	MWWQEg7iLCihmWBYeZZu6RsMTu3bfl1TLOr1rItgMU233SO1LAjtohGZ+r4Qi4Kt
	gwJ/18zyK/7P5wDvowjN3Wk8btde0s1MsXW/jA3eORLuyBAELpwyaAOJ33Wsjyoj
	7z8nK21tVhtJBFeL/fgft03fkMJsmCv/RMjfE9Rc8shtQQ==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bq96sr3wa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:37:15 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-123308e5e6aso2743938c88.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 15:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768520234; x=1769125034; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2n8CWclOK+qAz33/QIvyokvGlStxnKTjh7o52+P4ZA=;
        b=EPYDk/LqAnbHB0h18yqWJig4hddJebwjQjIUqdL5h63/4aqRWNy3C987EVtCB0BEUd
         yZ0aBfqLcEKvaTllnlRnqF644m2mzDIrcV0BF6Zk2EGchmP4vM2tSQIsPTFXOiGhKVXt
         PNANgqhv9KXm4mI42Dwk2KnA/fuaoS9ZOaG/UhF8AaKbSeKIt+GLcel6gCp1G9gQ/9Tn
         VZD9ZzbDHN10qS36s59BhKlwerqBz+ubyqjNI7ZnB7GwIbmdE/p+L+q5P1Tzdoongu9+
         DBbox5SyV7dmlHQBvlrztgqXWYXENGkVeWZTY43Vr4tMbRTOqTD3n7ofIheOybPpr3n9
         N9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768520234; x=1769125034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z2n8CWclOK+qAz33/QIvyokvGlStxnKTjh7o52+P4ZA=;
        b=mD0tGEfGwt41tEGicQlpD56OzbBtdWsBf55he37APCWcWF7P/R6o3mDnHkT6A8HsBv
         x0nTnpfeBB4egqg6wmbMs4vDxoB2Yno+N1sP28jCiYpGB1+F/CAjbLBLSJA4wS9nJejT
         g617N69zNh/muWjl4hw+O67lmtrAI4YCLsABCzI+ghsVbnbu+WTaImScoouYiU92JRtK
         575QXBbeFc+rEYnWom/vJP/o6ujX7/gfcCJXQudxM4vtQe+CDqbGpnGAb1YdoMopWUW0
         SWsTJzlTjKMWAbKJKS9pnOE+qX9sl3vWG5dlxBfvQ6jOzlzD/syu+Fxs1ZhYYyxO09uj
         2NUA==
X-Forwarded-Encrypted: i=1; AJvYcCU2LbfUsd7WAl3LiWBWWeJAKs+E1DmAepcXTUf27MmAjLk0e8/4c9Vq+ILd9NAeXuMSzPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YziRZZIfGbw5D1G0Cox3kMnHxBGtoWSViZL0FQWgSY8F6xdhm/J
	vm9RRt5cjzcq87/gTyY6mv7/k7c/wE21WDYEL4UZokRfiHNHWcT3vpyMxM44en+JvolUjDiminv
	keKvIQYwI+jIDh2D2A9EeJXSmX2U35xIMW5/b8Ct5qrer+Alo98aLYBU=
X-Gm-Gg: AY/fxX7+7A7GaXmEpPRUyTCQ1zUEvdrNRhc/hadtxUcQ0J46w6IS2x1IjYg3murYWwo
	elm4br8QMqu1gT8DrN+CrA/dzfBcQ2uINW2aKYIgVJIxar2jmMKqvTKIH8XxI0I19weG81No72k
	6UWnnA3PkHpeylK2/JfgRMAyeu9pJV8poJgQ9j+Bm5z9jMm01VaobGatb5y8H92VX9x2fAmR5UI
	BIMZ5Cb/SBwulbVcVkLm17uJ9csrmYCTWdt1EhkIsisXONR15+YqEMJfNiUggID9x+H9KRiVdxo
	njknGYpmuij3MAygK6cvzgPE1B9G1tK+sg1Nubcz3Da+vyvGuQ7CCzPQuZrpOOjD59QH528nCii
	3rhGJs6PnAzHMgg5ETjw=
X-Received: by 2002:a05:7022:618a:b0:119:e56b:98b1 with SMTP id a92af1059eb24-1244a736612mr1274976c88.24.1768520234274;
        Thu, 15 Jan 2026 15:37:14 -0800 (PST)
X-Received: by 2002:a05:7022:618a:b0:119:e56b:98b1 with SMTP id a92af1059eb24-1244a736612mr1274951c88.24.1768520233582;
        Thu, 15 Jan 2026 15:37:13 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244ac5842csm1024112c88.1.2026.01.15.15.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 15:37:13 -0800 (PST)
Date: Thu, 15 Jan 2026 17:37:11 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: pbonzini@redhat.com, corbet@lwn.net, anup@brainfault.org,
        atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org,
        ajones@ventanamicro.com, rkrcmar@ventanamicro.com,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: KVM: Support runtime configuration for
 per-VM's HGATP mode
Message-ID: <7rxerhpw33mhucn2m563iersxfarcck67vcmm5o3u25tmcrahf@lsjqygd5jj4b>
References: <20260105143232.76715-1-fangyu.yu@linux.alibaba.com>
 <20260105143232.76715-2-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105143232.76715-2-fangyu.yu@linux.alibaba.com>
X-Proofpoint-ORIG-GUID: z3QcGQlsy7rbzvbq3gbVTWfu4sW9EoNv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE4NyBTYWx0ZWRfXzCGnKs8vK2iq
 wLg4NE+ezQnIIpvJ2tqfy6YSA3f/iI5Sb8+p1aKzOu7HSeMdG3C63FrCynDvZC+MWLIUpibx0dU
 CbRbO6kOztEBuiKGjg9SCJNytMrWd3ZM1iLs4Z4REy0Z7+8H6kZyZxxBQfpoJIYo4r4JXfJ5k8a
 lAsWj9246xRc1sHm4h5BsEWuGEgv4r5DOqVKC/+bnjPPfBQ7hNzDsA+S13D1bzKwcDrxrbYp4rP
 2tqfkG9EPk7JOuT9GHJN5iJYIzEJEpjfkYu4Am5SO3iHZwG037gXYjuWyR9ecvwUDTohgtubMRK
 PUvhxrhq7F6dev1O6vkY3pszfwjWeAdXTJ+re6ylU+FsqF8U4XoWwIvXKKgnxUJq6zCQjUxiQ49
 eAFVW2NYpUCO4Pr1OL8lczgjgl3BhiCiO/uPxdNFRZgIPfpv++QLLgHus1KtP7Vy629jf0aAg6q
 9oNDpl6vMluGVwfF82w==
X-Proofpoint-GUID: z3QcGQlsy7rbzvbq3gbVTWfu4sW9EoNv
X-Authority-Analysis: v=2.4 cv=M9tA6iws c=1 sm=1 tr=0 ts=69697a2b cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=oBzv5dPfi-9pHJfKKYwA:9
 a=CjuIK1q_8ugA:10 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 malwarescore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601150187

On Mon, Jan 05, 2026 at 10:32:31PM +0800, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> 
> Introduces two per-VM architecture-specific fields to support runtime
> configuration of the G-stage page table format:
> 
> - kvm->arch.kvm_riscv_gstage_mode: specifies the HGATP mode used by the
>   current VM;
> - kvm->arch.kvm_riscv_gstage_pgd_levels: the corresponding number of page
>   table levels for the selected mode.
> 
> These fields replace the previous global variables
> kvm_riscv_gstage_mode and kvm_riscv_gstage_pgd_levels, enabling different
> virtual machines to independently select their G-stage page table format
> instead of being forced to share the maximum mode detected by the kernel
> at boot time.
> 
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>  arch/riscv/include/asm/kvm_gstage.h | 12 ++---
>  arch/riscv/include/asm/kvm_host.h   |  4 ++
>  arch/riscv/kvm/gstage.c             | 82 +++++++++++++++++------------
>  arch/riscv/kvm/main.c               |  4 +-
>  arch/riscv/kvm/mmu.c                | 18 +++++--
>  arch/riscv/kvm/vm.c                 |  2 +-
>  arch/riscv/kvm/vmid.c               |  2 +-
>  7 files changed, 74 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
> index 595e2183173e..fdcada123b3f 100644
> --- a/arch/riscv/include/asm/kvm_gstage.h
> +++ b/arch/riscv/include/asm/kvm_gstage.h
> @@ -29,16 +29,11 @@ struct kvm_gstage_mapping {
>  #define kvm_riscv_gstage_index_bits	10
>  #endif
>  
> -extern unsigned long kvm_riscv_gstage_mode;
> -extern unsigned long kvm_riscv_gstage_pgd_levels;
> +extern unsigned long kvm_riscv_gstage_max_mode;
> +extern unsigned long kvm_riscv_gstage_max_pgd_levels;
>  
>  #define kvm_riscv_gstage_pgd_xbits	2
>  #define kvm_riscv_gstage_pgd_size	(1UL << (HGATP_PAGE_SHIFT + kvm_riscv_gstage_pgd_xbits))
> -#define kvm_riscv_gstage_gpa_bits	(HGATP_PAGE_SHIFT + \
> -					 (kvm_riscv_gstage_pgd_levels * \
> -					  kvm_riscv_gstage_index_bits) + \
> -					 kvm_riscv_gstage_pgd_xbits)
> -#define kvm_riscv_gstage_gpa_size	((gpa_t)(1ULL << kvm_riscv_gstage_gpa_bits))
>  
>  bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
>  			       pte_t **ptepp, u32 *ptep_level);
> @@ -69,4 +64,7 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>  
>  void kvm_riscv_gstage_mode_detect(void);
>  
> +gpa_t kvm_riscv_gstage_gpa_size(struct kvm_arch *k);
> +unsigned long kvm_riscv_gstage_gpa_bits(struct kvm_arch *k);
> +
>  #endif
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 24585304c02b..27ea8e8fd5b0 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -103,6 +103,10 @@ struct kvm_arch {
>  
>  	/* KVM_CAP_RISCV_MP_STATE_RESET */
>  	bool mp_state_reset;
> +
> +	unsigned long kvm_riscv_gstage_mode;

There's a 1:1 mapping for mode/levels, so we don't need to track both.
Since mode is rarely used, then I think something like this would still
provide enough convenience without requiring the storage allocation.

 static inline unsigned long kvm_riscv_gstage_mode(struct kvm_gstage *gstage)
 {
     unsigned long modes[] = {
         [2] = HGATP_MODE_SV32X4,
         [3] = HGATP_MODE_SV39X4,
         [4] = HGATP_MODE_SV48X4,
         [5] = HGATP_MODE_SV57X4,
     };

     return modes[gstage->kvm->arch.kvm_riscv_gstage_pgd_levels];
 }

> +	unsigned long kvm_riscv_gstage_pgd_levels;
> +	bool gstage_mode_initialized;
>  };
>  
>  struct kvm_cpu_trap {
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index b67d60d722c2..06452e4c2ab2 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -12,22 +12,23 @@
>  #include <asm/kvm_gstage.h>
>  
>  #ifdef CONFIG_64BIT
> -unsigned long kvm_riscv_gstage_mode __ro_after_init = HGATP_MODE_SV39X4;
> -unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init = 3;
> +unsigned long kvm_riscv_gstage_max_mode __ro_after_init = HGATP_MODE_SV39X4;

With a kvm_riscv_gstage_mode() function we don't need
kvm_riscv_gstage_max_mode either.

> +unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 3;
>  #else
> -unsigned long kvm_riscv_gstage_mode __ro_after_init = HGATP_MODE_SV32X4;
> -unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init = 2;
> +unsigned long kvm_riscv_gstage_max_mode __ro_after_init = HGATP_MODE_SV32X4;
> +unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 2;
>  #endif
>  
>  #define gstage_pte_leaf(__ptep)	\
>  	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
>  
> -static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
> +static inline unsigned long gstage_pte_index(struct kvm_gstage *gstage,
> +					     gpa_t addr, u32 level)
>  {
>  	unsigned long mask;
>  	unsigned long shift = HGATP_PAGE_SHIFT + (kvm_riscv_gstage_index_bits * level);
>  
> -	if (level == (kvm_riscv_gstage_pgd_levels - 1))
> +	if (level == (gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1))

nit: we can drop the unnecessary () while touching this line.

>  		mask = (PTRS_PER_PTE * (1UL << kvm_riscv_gstage_pgd_xbits)) - 1;
>  	else
>  		mask = PTRS_PER_PTE - 1;
> @@ -40,12 +41,13 @@ static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
>  	return (unsigned long)pfn_to_virt(__page_val_to_pfn(pte_val(pte)));
>  }
>  
> -static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
> +static int gstage_page_size_to_level(struct kvm_gstage *gstage, unsigned long page_size,
> +				     u32 *out_level)
>  {
>  	u32 i;
>  	unsigned long psz = 1UL << 12;
>  
> -	for (i = 0; i < kvm_riscv_gstage_pgd_levels; i++) {
> +	for (i = 0; i < gstage->kvm->arch.kvm_riscv_gstage_pgd_levels; i++) {
>  		if (page_size == (psz << (i * kvm_riscv_gstage_index_bits))) {
>  			*out_level = i;
>  			return 0;
> @@ -55,21 +57,23 @@ static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
>  	return -EINVAL;
>  }
>  
> -static int gstage_level_to_page_order(u32 level, unsigned long *out_pgorder)
> +static int gstage_level_to_page_order(struct kvm_gstage *gstage, u32 level,
> +				      unsigned long *out_pgorder)
>  {
> -	if (kvm_riscv_gstage_pgd_levels < level)
> +	if (gstage->kvm->arch.kvm_riscv_gstage_pgd_levels < level)
>  		return -EINVAL;
>  
>  	*out_pgorder = 12 + (level * kvm_riscv_gstage_index_bits);
>  	return 0;
>  }
>  
> -static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
> +static int gstage_level_to_page_size(struct kvm_gstage *gstage, u32 level,
> +				     unsigned long *out_pgsize)
>  {
>  	int rc;
>  	unsigned long page_order = PAGE_SHIFT;
>  
> -	rc = gstage_level_to_page_order(level, &page_order);
> +	rc = gstage_level_to_page_order(gstage, level, &page_order);
>  	if (rc)
>  		return rc;
>  
> @@ -81,11 +85,11 @@ bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
>  			       pte_t **ptepp, u32 *ptep_level)
>  {
>  	pte_t *ptep;
> -	u32 current_level = kvm_riscv_gstage_pgd_levels - 1;
> +	u32 current_level = gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1;
>  
>  	*ptep_level = current_level;
>  	ptep = (pte_t *)gstage->pgd;
> -	ptep = &ptep[gstage_pte_index(addr, current_level)];
> +	ptep = &ptep[gstage_pte_index(gstage, addr, current_level)];
>  	while (ptep && pte_val(ptep_get(ptep))) {
>  		if (gstage_pte_leaf(ptep)) {
>  			*ptep_level = current_level;
> @@ -97,7 +101,7 @@ bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
>  			current_level--;
>  			*ptep_level = current_level;
>  			ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
> -			ptep = &ptep[gstage_pte_index(addr, current_level)];
> +			ptep = &ptep[gstage_pte_index(gstage, addr, current_level)];
>  		} else {
>  			ptep = NULL;
>  		}
> @@ -110,7 +114,7 @@ static void gstage_tlb_flush(struct kvm_gstage *gstage, u32 level, gpa_t addr)
>  {
>  	unsigned long order = PAGE_SHIFT;
>  
> -	if (gstage_level_to_page_order(level, &order))
> +	if (gstage_level_to_page_order(gstage, level, &order))
>  		return;
>  	addr &= ~(BIT(order) - 1);
>  
> @@ -125,9 +129,9 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
>  			     struct kvm_mmu_memory_cache *pcache,
>  			     const struct kvm_gstage_mapping *map)
>  {
> -	u32 current_level = kvm_riscv_gstage_pgd_levels - 1;
> +	u32 current_level = gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1;
>  	pte_t *next_ptep = (pte_t *)gstage->pgd;
> -	pte_t *ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
> +	pte_t *ptep = &next_ptep[gstage_pte_index(gstage, map->addr, current_level)];
>  
>  	if (current_level < map->level)
>  		return -EINVAL;
> @@ -151,7 +155,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
>  		}
>  
>  		current_level--;
> -		ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
> +		ptep = &next_ptep[gstage_pte_index(gstage, map->addr, current_level)];
>  	}
>  
>  	if (pte_val(*ptep) != pte_val(map->pte)) {
> @@ -175,7 +179,7 @@ int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
>  	out_map->addr = gpa;
>  	out_map->level = 0;
>  
> -	ret = gstage_page_size_to_level(page_size, &out_map->level);
> +	ret = gstage_page_size_to_level(gstage, page_size, &out_map->level);
>  	if (ret)
>  		return ret;
>  
> @@ -217,7 +221,7 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
>  	u32 next_ptep_level;
>  	unsigned long next_page_size, page_size;
>  
> -	ret = gstage_level_to_page_size(ptep_level, &page_size);
> +	ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
>  	if (ret)
>  		return;
>  
> @@ -229,7 +233,7 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
>  	if (ptep_level && !gstage_pte_leaf(ptep)) {
>  		next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
>  		next_ptep_level = ptep_level - 1;
> -		ret = gstage_level_to_page_size(next_ptep_level, &next_page_size);
> +		ret = gstage_level_to_page_size(gstage, next_ptep_level, &next_page_size);
>  		if (ret)
>  			return;
>  
> @@ -263,7 +267,7 @@ void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
>  
>  	while (addr < end) {
>  		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
> -		ret = gstage_level_to_page_size(ptep_level, &page_size);
> +		ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
>  		if (ret)
>  			break;
>  
> @@ -297,7 +301,7 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>  
>  	while (addr < end) {
>  		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
> -		ret = gstage_level_to_page_size(ptep_level, &page_size);
> +		ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
>  		if (ret)
>  			break;
>  
> @@ -319,41 +323,51 @@ void __init kvm_riscv_gstage_mode_detect(void)
>  	/* Try Sv57x4 G-stage mode */
>  	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
> -		kvm_riscv_gstage_mode = HGATP_MODE_SV57X4;
> -		kvm_riscv_gstage_pgd_levels = 5;
> +		kvm_riscv_gstage_max_mode = HGATP_MODE_SV57X4;
> +		kvm_riscv_gstage_max_pgd_levels = 5;
>  		goto done;
>  	}
>  
>  	/* Try Sv48x4 G-stage mode */
>  	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
> -		kvm_riscv_gstage_mode = HGATP_MODE_SV48X4;
> -		kvm_riscv_gstage_pgd_levels = 4;
> +		kvm_riscv_gstage_max_mode = HGATP_MODE_SV48X4;
> +		kvm_riscv_gstage_max_pgd_levels = 4;
>  		goto done;
>  	}
>  
>  	/* Try Sv39x4 G-stage mode */
>  	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
> -		kvm_riscv_gstage_mode = HGATP_MODE_SV39X4;
> -		kvm_riscv_gstage_pgd_levels = 3;
> +		kvm_riscv_gstage_max_mode = HGATP_MODE_SV39X4;
> +		kvm_riscv_gstage_max_pgd_levels = 3;
>  		goto done;
>  	}
>  #else /* CONFIG_32BIT */
>  	/* Try Sv32x4 G-stage mode */
>  	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV32X4) {
> -		kvm_riscv_gstage_mode = HGATP_MODE_SV32X4;
> -		kvm_riscv_gstage_pgd_levels = 2;
> +		kvm_riscv_gstage_max_mode = HGATP_MODE_SV32X4;
> +		kvm_riscv_gstage_max_pgd_levels = 2;
>  		goto done;
>  	}
>  #endif
>  
>  	/* KVM depends on !HGATP_MODE_OFF */
> -	kvm_riscv_gstage_mode = HGATP_MODE_OFF;
> -	kvm_riscv_gstage_pgd_levels = 0;
> +	kvm_riscv_gstage_max_mode = HGATP_MODE_OFF;
> +	kvm_riscv_gstage_max_pgd_levels = 0;
>  
>  done:
>  	csr_write(CSR_HGATP, 0);
>  	kvm_riscv_local_hfence_gvma_all();
>  }
> +
> +unsigned long kvm_riscv_gstage_gpa_bits(struct kvm_arch *k) {

Did you run checkpatch? I think it requires '{' to be on its own line.

nit: s/k/ka/ would be consistent with other archs, although I see k is
used in riscv's kvm_riscv_mmu_update_hgatp() but that can be fixed up
in this patch since there's a change in the same place too.


> +	return (HGATP_PAGE_SHIFT + (k->kvm_riscv_gstage_pgd_levels *
> +		    kvm_riscv_gstage_index_bits) +
> +		    kvm_riscv_gstage_pgd_xbits);
> +}
> +
> +gpa_t kvm_riscv_gstage_gpa_size(struct kvm_arch *k) {

same comments as above

> +	return ((gpa_t)(1ULL << kvm_riscv_gstage_gpa_bits(k)));

 return BIT_ULL(kvm_riscv_gstage_gpa_bits(ka))

(the cast is implicit from return type)

> +}
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 45536af521f0..56a246e0e791 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -105,7 +105,7 @@ static int __init riscv_kvm_init(void)
>  		return rc;
>  
>  	kvm_riscv_gstage_mode_detect();
> -	switch (kvm_riscv_gstage_mode) {
> +	switch (kvm_riscv_gstage_max_mode) {
>  	case HGATP_MODE_SV32X4:
>  		str = "Sv32x4";
>  		break;
> @@ -164,7 +164,7 @@ static int __init riscv_kvm_init(void)
>  			 (rc) ? slist : "no features");
>  	}
>  
> -	kvm_info("using %s G-stage page table format\n", str);
> +	kvm_info("Max G-stage page table format %s \n", str);
>  
>  	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
>  
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 4ab06697bfc0..574783907162 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -67,7 +67,7 @@ int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>  		if (!writable)
>  			map.pte = pte_wrprotect(map.pte);
>  
> -		ret = kvm_mmu_topup_memory_cache(&pcache, kvm_riscv_gstage_pgd_levels);
> +		ret = kvm_mmu_topup_memory_cache(&pcache,kvm->arch.kvm_riscv_gstage_pgd_levels);
                                                         ^ missing space

>  		if (ret)
>  			goto out;
>  
> @@ -186,8 +186,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	 * space addressable by the KVM guest GPA space.
>  	 */
>  	if ((new->base_gfn + new->npages) >=
> -	    (kvm_riscv_gstage_gpa_size >> PAGE_SHIFT))
> +			(kvm_riscv_gstage_gpa_size(&kvm->arch) >> PAGE_SHIFT)) {
>  		return -EFAULT;
> +	}

nit: Remove the unnecessary () and the '{' and the condition will fit on
one 100 char line.

>  
>  	hva = new->userspace_addr;
>  	size = new->npages << PAGE_SHIFT;
> @@ -332,7 +333,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
>  	memset(out_map, 0, sizeof(*out_map));
>  
>  	/* We need minimum second+third level pages */
> -	ret = kvm_mmu_topup_memory_cache(pcache, kvm_riscv_gstage_pgd_levels);
> +	ret = kvm_mmu_topup_memory_cache(pcache, kvm->arch.kvm_riscv_gstage_pgd_levels);
>  	if (ret) {
>  		kvm_err("Failed to topup G-stage cache\n");
>  		return ret;
> @@ -431,6 +432,11 @@ int kvm_riscv_mmu_alloc_pgd(struct kvm *kvm)
>  		return -ENOMEM;
>  	kvm->arch.pgd = page_to_virt(pgd_page);
>  	kvm->arch.pgd_phys = page_to_phys(pgd_page);
> +	if (!kvm->arch.gstage_mode_initialized) {
> +		/*user-space didn't set KVM_CAP_RISC_HGATP_MODE cap*/
                  ^ missing space                                  ^ missing space
> +		kvm->arch.kvm_riscv_gstage_mode = kvm_riscv_gstage_max_mode;
> +		kvm->arch.kvm_riscv_gstage_pgd_levels = kvm_riscv_gstage_max_pgd_levels;

Missing 'kvm->arch.gstage_mode_initialized = true' statement.

> +	}
>  
>  	return 0;
>  }
> @@ -446,10 +452,12 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
>  		gstage.flags = 0;
>  		gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
>  		gstage.pgd = kvm->arch.pgd;
> -		kvm_riscv_gstage_unmap_range(&gstage, 0UL, kvm_riscv_gstage_gpa_size, false);
> +		kvm_riscv_gstage_unmap_range(&gstage, 0UL, kvm_riscv_gstage_gpa_size(&kvm->arch), false);
>  		pgd = READ_ONCE(kvm->arch.pgd);
>  		kvm->arch.pgd = NULL;
>  		kvm->arch.pgd_phys = 0;
> +		kvm->arch.kvm_riscv_gstage_mode = HGATP_MODE_OFF;
> +		kvm->arch.kvm_riscv_gstage_pgd_levels = 0;
>  	}
>  	spin_unlock(&kvm->mmu_lock);
>  
> @@ -459,8 +467,8 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
>  
>  void kvm_riscv_mmu_update_hgatp(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long hgatp = kvm_riscv_gstage_mode << HGATP_MODE_SHIFT;
>  	struct kvm_arch *k = &vcpu->kvm->arch;
> +	unsigned long hgatp = k->kvm_riscv_gstage_mode << HGATP_MODE_SHIFT;
>  
>  	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
>  	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 66d91ae6e9b2..4b2156df40fc 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -200,7 +200,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = KVM_USER_MEM_SLOTS;
>  		break;
>  	case KVM_CAP_VM_GPA_BITS:
> -		r = kvm_riscv_gstage_gpa_bits;
> +		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
>  		break;
>  	default:
>  		r = 0;
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index cf34d448289d..db27430f111e 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -26,7 +26,7 @@ static DEFINE_SPINLOCK(vmid_lock);
>  void __init kvm_riscv_gstage_vmid_detect(void)
>  {
>  	/* Figure-out number of VMID bits in HW */
> -	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
> +	csr_write(CSR_HGATP, (kvm_riscv_gstage_max_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
>  	vmid_bits = csr_read(CSR_HGATP);
>  	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>  	vmid_bits = fls_long(vmid_bits);
> -- 
> 2.50.1
>

Thanks,
drew


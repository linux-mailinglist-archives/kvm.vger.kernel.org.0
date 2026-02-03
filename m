Return-Path: <kvm+bounces-70013-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNVyIsUFgmmYNgMAu9opvQ
	(envelope-from <kvm+bounces-70013-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 15:27:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9DFDA8E9
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 15:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8D0E310A082
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 14:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0B23A9600;
	Tue,  3 Feb 2026 14:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NfNjyq5n"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C809B3A4F4E;
	Tue,  3 Feb 2026 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770128538; cv=none; b=N2g+WRAqzCnCtqX325s4a1DjA+zxGOXDdQTKbvG0fg+y5q3RF9Cr9W/0i5RJRNnv1dG3lbioH+/baLXLtrluFi+pofXe/9sMKpkyqnKgyWhR3QYipBiSlMLM6JUVQAOM81kdRuXIbBiPXNZBaHtEuMMq+/vSFQPHY027gP8D6l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770128538; c=relaxed/simple;
	bh=4wsLi5Bouoo5PRGeaZoqcAfeHciH8hjPc42bsCQYaP4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GZ4KrUzbYbu/yhiMWqGFFPhP0a09Ell3ogx9LJ1bqm+O8mfYGjIDaKho40i2WOhOfkFGcyEJwHguZbnY7fy0GyC6tYthRjU0zt3kqg48MfWdTq5Ye3ztkVftfr8xs4s3l7E8Tw3T+V9Y0KtdoFRqYBO99260Lmde5AZ7lNWyfRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NfNjyq5n; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770128525; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=GKZoo0J/VDdVWk4ONTShUiBmDnbd5FCIHWlHlNben/s=;
	b=NfNjyq5nUqgXZ7RdpeAE/qRICsQ1UTcil4kFhiGWXS+B/Gx5ynLEOQvguaaTrx8VYPtiobHoy2AeybxwSx7sCSQmFnWbUrfhA1UqdtRp8aFljqEbtfH4/st+XP6LUbOJXgRjf3rNIUCfvmln8m18G6TjpVWyG2pGu7noT2sdVEg=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyTKNws_1770128522 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Feb 2026 22:22:03 +0800
From: fangyu.yu@linux.alibaba.com
To: andrew.jones@oss.qualcomm.com
Cc: ajones@ventanamicro.com,
	alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	corbet@lwn.net,
	fangyu.yu@linux.alibaba.com,
	guoren@kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pbonzini@redhat.com,
	pjw@kernel.org,
	radim.krcmar@oss.qualcomm.com,
	rkrcmar@ventanamicro.com
Subject: Re: Re: [PATCH v4 2/4] RISC-V: KVM: Detect and expose supported HGATP G-stage modes
Date: Tue,  3 Feb 2026 22:22:00 +0800
Message-Id: <20260203142200.98839-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <ftdnjnfvmybiskej3txd23mqn3jpjdewmgjxjbap3y4ekj4h4m@d74ihtpclyps>
References: <ftdnjnfvmybiskej3txd23mqn3jpjdewmgjxjbap3y4ekj4h4m@d74ihtpclyps>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70013-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NO_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[19];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: EE9DFDA8E9
X-Rspamd-Action: no action

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> 
>> Extend kvm_riscv_gstage_mode_detect() to probe all HGATP.MODE values
>> supported by the host and record them in a bitmask. Keep tracking the
>> maximum supported G-stage page table level for existing internal users.
>> 
>> Also provide lightweight helpers to retrieve the supported-mode bitmask
>> and validate a requested HGATP.MODE against it.
>> 
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>>  arch/riscv/include/asm/kvm_gstage.h | 37 +++++++++++++++++++++++++++
>>  arch/riscv/kvm/gstage.c             | 39 ++++++++++++++++-------------
>>  2 files changed, 58 insertions(+), 18 deletions(-)
>> 
>> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
>> index b12605fbca44..c0c5a8b99056 100644
>> --- a/arch/riscv/include/asm/kvm_gstage.h
>> +++ b/arch/riscv/include/asm/kvm_gstage.h
>> @@ -30,6 +30,7 @@ struct kvm_gstage_mapping {
>>  #endif
>>  
>>  extern unsigned long kvm_riscv_gstage_max_pgd_levels;
>> +extern u32 kvm_riscv_gstage_mode_mask;
>>  
>>  #define kvm_riscv_gstage_pgd_xbits	2
>>  #define kvm_riscv_gstage_pgd_size	(1UL << (HGATP_PAGE_SHIFT + kvm_riscv_gstage_pgd_xbits))
>> @@ -75,4 +76,40 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>>  
>>  void kvm_riscv_gstage_mode_detect(void);
>>  
>> +enum kvm_riscv_hgatp_mode_bit {
>> +	HGATP_MODE_SV39X4_BIT = 0,
>> +	HGATP_MODE_SV48X4_BIT = 1,
>> +	HGATP_MODE_SV57X4_BIT = 2,
>> +};
>
>These should be defined in the UAPI, as I see the last patch of the series
>does. No need to define them twice.

ok, I'll drop the duplicated enum from the non-UAPI header and reuse the UAPI
definitions instead.

>
>> +
>> +static inline u32 kvm_riscv_get_hgatp_mode_mask(void)
>> +{
>> +	return kvm_riscv_gstage_mode_mask;
>> +}
>> +
>> +static inline bool kvm_riscv_hgatp_mode_is_valid(unsigned long mode)
>> +{
>> +#ifdef CONFIG_64BIT
>> +	u32 bit;
>> +
>> +	switch (mode) {
>> +	case HGATP_MODE_SV39X4:
>> +		bit = HGATP_MODE_SV39X4_BIT;
>> +		break;
>> +	case HGATP_MODE_SV48X4:
>> +		bit = HGATP_MODE_SV48X4_BIT;
>> +		break;
>> +	case HGATP_MODE_SV57X4:
>> +		bit = HGATP_MODE_SV57X4_BIT;
>> +		break;
>> +	default:
>> +		return false;
>> +	}
>> +
>> +	return kvm_riscv_gstage_mode_mask & BIT(bit);
>> +#else
>> +	return false;
>> +#endif
>
>It seems like we're going out of our way to only provide the capability
>for rv64. While the cap isn't useful for rv32, having #ifdefs in KVM and
>additional paths in kvm userspace is probably worse than just having a
>useless HGATP_MODE_SV32X4_BIT that rv32 userspace can set.
>

Agreed.
I'll drop the CONFIG_64BIT conditional and make the mode validation work
for both RV32 and RV64. On RV32 we'll define/accept an HGATP_MODE_SV32X4
bit.

>> +}
>> +
>>  #endif
>> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
>> index 2d0045f502d1..edbabdac57d8 100644
>> --- a/arch/riscv/kvm/gstage.c
>> +++ b/arch/riscv/kvm/gstage.c
>> @@ -16,6 +16,8 @@ unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 3;
>>  #else
>>  unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 2;
>>  #endif
>> +/* Bitmask of supported HGATP.MODE (see HGATP_MODE_*_BIT). */
>> +u32 kvm_riscv_gstage_mode_mask __ro_after_init;
>>  
>>  #define gstage_pte_leaf(__ptep)	\
>>  	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
>> @@ -315,42 +317,43 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>>  	}
>>  }
>>  
>> +static bool __init kvm_riscv_hgatp_mode_supported(unsigned long mode)
>> +{
>> +	csr_write(CSR_HGATP, mode << HGATP_MODE_SHIFT);
>> +	return ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == mode);
>> +}
>> +
>>  void __init kvm_riscv_gstage_mode_detect(void)
>>  {
>> +	kvm_riscv_gstage_mode_mask = 0;
>> +	kvm_riscv_gstage_max_pgd_levels = 0;
>> +
>>  #ifdef CONFIG_64BIT
>> -	/* Try Sv57x4 G-stage mode */
>> -	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
>> -	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
>> -		kvm_riscv_gstage_max_pgd_levels = 5;
>> -		goto done;
>> +	/* Try Sv39x4 G-stage mode */
>> +	if (kvm_riscv_hgatp_mode_supported(HGATP_MODE_SV39X4)) {
>> +		kvm_riscv_gstage_mode_mask |= BIT(HGATP_MODE_SV39X4_BIT);
>> +		kvm_riscv_gstage_max_pgd_levels = 3;
>>  	}
>>  
>>  	/* Try Sv48x4 G-stage mode */
>> -	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
>> -	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
>> +	if (kvm_riscv_hgatp_mode_supported(HGATP_MODE_SV48X4)) {
>> +		kvm_riscv_gstage_mode_mask |= BIT(HGATP_MODE_SV48X4_BIT);
>>  		kvm_riscv_gstage_max_pgd_levels = 4;
>> -		goto done;
>>  	}
>>  
>> -	/* Try Sv39x4 G-stage mode */
>> -	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
>> -	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
>> -		kvm_riscv_gstage_max_pgd_levels = 3;
>> -		goto done;
>> +	/* Try Sv57x4 G-stage mode */
>> +	if (kvm_riscv_hgatp_mode_supported(HGATP_MODE_SV57X4)) {
>> +		kvm_riscv_gstage_mode_mask |= BIT(HGATP_MODE_SV57X4_BIT);
>> +		kvm_riscv_gstage_max_pgd_levels = 5;
>>  	}
>>  #else /* CONFIG_32BIT */
>>  	/* Try Sv32x4 G-stage mode */
>>  	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
>>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV32X4) {
>
>Can use kvm_riscv_hgatp_mode_supported() here too.

Sure.
I'll switch the 32-bit path to use kvm_riscv_hgatp_mode_supported() as well,
so both RV32 and RV64 use the same helper to probe HGATP mode support.
>
>>  		kvm_riscv_gstage_max_pgd_levels = 2;
>> -		goto done;
>>  	}
>>  #endif
>>  
>> -	/* KVM depends on !HGATP_MODE_OFF */
>> -	kvm_riscv_gstage_max_pgd_levels = 0;
>> -
>> -done:
>>  	csr_write(CSR_HGATP, 0);
>>  	kvm_riscv_local_hfence_gvma_all();
>>  }
>> -- 
>> 2.50.1
>>
>
>Thanks,
>drew
>

Thanks,
Fangyu


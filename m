Return-Path: <kvm+bounces-21936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5D7937A1E
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 17:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58D4DB21E98
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 15:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190B0146583;
	Fri, 19 Jul 2024 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xgE7LJUg"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F82C13CA9C
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 15:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721403949; cv=none; b=NCqxB9wX4pLVy42UoOhsEAVZonl6YUMrShIGxm+P0pNHlbMPD2+MN3Oz/MLfFxy+YjRNIBgwdQ/wEbQo5Zrgvn3N9NsQaEEFNeiSudLIMxYKiHgGWozNoDd29ZGHFjeDEGW+JgHYvwwnegMRCfqMXdlOp346d6+SCxAyiAD6Ntg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721403949; c=relaxed/simple;
	bh=NIQSbyZlUbJiCDWVQ3NU7i/bsDVSE9yTntUG0CxlunI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L99UM0WDzgniUp+AG6HRO54fdY6I3gvAHg5H/9II05lmhGv4lvQf7KynqZoMiDWYN1M8nSF7w4/lxvBSw0gR2qC8djfHzHE3sWLPOmSjeB7rGqIeAnYsx3hYLfP2OYYSCpW9GxS1phfgZEjTx7eRlXA9f4mg32A/rVmKrcTFwBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xgE7LJUg; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jamestiotio@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721403944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tNu7enpoZVXBvNhaTPdRqs2dK8i369uaD7OsmxPU5Hs=;
	b=xgE7LJUggu589P3hPLNd8Wut381yoqmAipgHUYNgHVvVNYQDNvNXMIYfzilFJZYSbIK+PN
	v25O7p1U5wJDSeSqRX7Ankptzivi6vSf8cNV9jbuXDdWLZRyAkvHf5SBgKu3L9WmQlA8E8
	Lio1FqYiQtyURxcOyT+jepNNOJeUR0g=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
Date: Fri, 19 Jul 2024 10:45:39 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v3 3/5] riscv: Add method to probe for SBI
 extensions
Message-ID: <20240719-14d00cb5b5a19d0c09a9ad02@orel>
References: <20240719023947.112609-1-jamestiotio@gmail.com>
 <20240719023947.112609-4-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240719023947.112609-4-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 19, 2024 at 10:39:45AM GMT, James Raphael Tiovalen wrote:
> Add a `sbi_probe` helper method that can be used by SBI extension tests
> to check if a given extension is available.
>

Suggested-by: Andrew Jones <andrew.jones@linux.dev>

> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  lib/riscv/asm/sbi.h |  1 +
>  lib/riscv/sbi.c     | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index d82a384d..5e1a674a 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -49,6 +49,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  
>  void sbi_shutdown(void);
>  struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
> +long sbi_probe(int ext);
>  
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMRISCV_SBI_H_ */
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index f39134c4..7d7d09c3 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -38,3 +38,13 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
>  {
>  	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
>  }
> +
> +long sbi_probe(int ext)
> +{
> +	struct sbiret ret;

Let's also add

  ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
  assert(!ret.error && ret.value >= 2);

> +
> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
> +	assert(!ret.error);
> +
> +	return ret.value;
> +}
> -- 
> 2.43.0
>

With that addition,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew


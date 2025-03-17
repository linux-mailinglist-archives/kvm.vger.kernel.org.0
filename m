Return-Path: <kvm+bounces-41222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 223DAA64EDF
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25AC2171EEC
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C188238D38;
	Mon, 17 Mar 2025 12:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="gTUatejx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2BFEBE
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 12:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742214661; cv=none; b=aVya58/Y0284EzuKSCQsI0SCU+Hfh2900zhGD1HAy/J7Iksxncr619Z218ZMDWp7e5SH7aQRlMd7WeaWbE/4BOKfwuPUU22PGgJPU3/7ksmVb7bvTi0uAYQYm2wkGUYzAesiyMrf5Do+emZCoGAfEXHbCGkVXr8JthC8lczXATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742214661; c=relaxed/simple;
	bh=hKRxw/r8y/lmEliTTii8KMlbYCgaVgAHgYN8gwUmE+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoldLf8ElRK9IJk6qd6+/L3rgmfjP9oFc/OAP++OdCxjIWahyz+9Y76Zr+OYmA62EwTPT936ip1r9PuAONiuhlMBDUZr78Av51G0jd5TbJ9bTB1xz2PjD2LmW4Gk+foQTDAcOOqudmgxQIWdt/j+MKJsHleW6K7cGoITa9YBw+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=gTUatejx; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac339f53df9so202563466b.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742214658; x=1742819458; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=keEF1ClYo9QFdZgk8doZ3yD+Jw42L+l34XOiAAsMsaU=;
        b=gTUatejxRJlQ+OE2kn9k1MmQVNg9jA2urfSV+ZDAZ85YSCYRMtsxrQiKSxNqZ8iOYJ
         pmSnGXRx7GrT1O5cvKeI6Mql+PrRTTLPKbgByRU9R7XgWCKWwiOwDshm+3awGwOMtSeT
         lbswwF2q7/QuSCTrGh3XhhNAHYHdyGk8GrcgtYu/DKkJKhEh9M/OKf4SG/nvPTnzDZ/D
         CJBxTQSHpCB32kWgcK9K7lqHVnfDNFBKhcJexpbNychteoGEts/7O/Km7nCIpKKMM8kS
         pyEukoJ0XEVORFWkhXRQY3G4OOkdNKy3/pimVBeu0V/TIKQl2IuNjAA2BpQ+neoMoXnp
         55Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742214658; x=1742819458;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=keEF1ClYo9QFdZgk8doZ3yD+Jw42L+l34XOiAAsMsaU=;
        b=naFCa5zAfSfUuWqAJw61K7QGYMzsO1vAz2XDpB92JMUPCjIacHSRTGK1Ycbw1jy18q
         /H4M78K7dyruwItrqtLOwW3fkoHUWQRrhowGCsjF2Kn3Gl3gluBeGG10s1IiCSdXcaGE
         un9S/jrv9jhWVU5ZVRGztf1pLjiMXdKK+dFjibh9wipWJziz4CoWPRosgGN6mlLPxBx0
         zZqrhyA/GKeMoUUycjKhm3TcWZdRGvVAzch1Nm+pO37Bby5Adwu/VFhcpg4FZB7DKe3P
         +yQ8/WQ5Mq0AZ0a1Ga+sptLckQeMUK+Ge43e5TfCdfUDMVOITVLbf87I9D+9Wp/yE6v7
         ebsA==
X-Gm-Message-State: AOJu0YyjYJwFbr41+Kskhx0h1NapgwUvm05AJIFF3rKydLnM9Xdq9hb0
	wQf+qwyIHsMzdi8DrbdlGKMWmoXU0RYn+iNhAkteZdp1EShFMDZKL0454V7artE=
X-Gm-Gg: ASbGnctHurF4ae4eFPsu0+VHjU5x/X0UXmB6a/jE7d3vDWW606zGeA3yzFuBl6RZaln
	lmFf8kDDoqr3I1AzSQm9oOcqkPucrmiDnuLDwfCLQyXbmjjaiBeT3oahhPCJhDGT/S20xTAMIM2
	ku85PsV5CGdDK1Yw+YMu40UgiA5dmJiaG2WZ/JGy+esY53dGrwU88TLxwmJTtpIReGy72Ui9/A2
	3m7+VadQqgaSOwBwtxWRhi4lmZkXwOMkP8vQeTFxUnS1lqVFaxK3z2SVYAsh4S504dRef5dXhbB
	b/Arpzo+en/MhTtgaxFwIfFrh/q5vQIH
X-Google-Smtp-Source: AGHT+IHtzVUeirnuse4ZybcWG7nXBAB985STAX7f2lJ+9K3VXptDd5bi0QFu79er9azuzjpbxYPToA==
X-Received: by 2002:a17:906:4795:b0:abf:fb7b:8d09 with SMTP id a640c23a62f3a-ac33041c7a6mr1172606666b.51.1742214657719;
        Mon, 17 Mar 2025 05:30:57 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac314a9db94sm671667366b.171.2025.03.17.05.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 05:30:57 -0700 (PDT)
Date: Mon, 17 Mar 2025 13:30:56 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v10 4/8] riscv: sbi: Add functions for
 version checking
Message-ID: <20250317-4edd893e742f7186b515be76@orel>
References: <20250317101956.526834-1-cleger@rivosinc.com>
 <20250317101956.526834-5-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317101956.526834-5-cleger@rivosinc.com>

On Mon, Mar 17, 2025 at 11:19:50AM +0100, Clément Léger wrote:
> Version checking was done using some custom hardcoded values, backport a
> few SBI function and defines from Linux to do that cleanly.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/sbi.h | 15 +++++++++++++++
>  lib/riscv/sbi.c     |  9 +++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 2f4d91ef..197288c7 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -18,6 +18,12 @@
>  #define SBI_ERR_IO			-13
>  #define SBI_ERR_DENIED_LOCKED		-14
>  
> +/* SBI spec version fields */
> +#define SBI_SPEC_VERSION_DEFAULT	0x1

We don't need this define, since we don't support version 0.1. But there
is another mask we should add. See below.

> +#define SBI_SPEC_VERSION_MAJOR_SHIFT	24
> +#define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
> +#define SBI_SPEC_VERSION_MINOR_MASK	0xffffff
> +
>  #ifndef __ASSEMBLER__
>  #include <cpumask.h>
>  
> @@ -110,6 +116,14 @@ struct sbiret {
>  	long value;
>  };
>  
> +/* Make SBI version */
> +static inline unsigned long sbi_mk_version(unsigned long major, unsigned long minor)
> +{
> +	return ((major & SBI_SPEC_VERSION_MAJOR_MASK) << SBI_SPEC_VERSION_MAJOR_SHIFT)
> +		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
> +}
> +
> +

Extra blank, but I see it goes away with the next patch.

>  struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  			unsigned long arg1, unsigned long arg2,
>  			unsigned long arg3, unsigned long arg4,
> @@ -124,6 +138,7 @@ struct sbiret sbi_send_ipi_cpu(int cpu);
>  struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
>  struct sbiret sbi_send_ipi_broadcast(void);
>  struct sbiret sbi_set_timer(unsigned long stime_value);
> +struct sbiret sbi_get_spec_version(void);
>  long sbi_probe(int ext);
>  
>  #endif /* !__ASSEMBLER__ */
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 02dd338c..3c395cff 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -107,12 +107,17 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>  }
>  
> +struct sbiret sbi_get_spec_version(void)
> +{
> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
> +}
> +
>  long sbi_probe(int ext)
>  {
>  	struct sbiret ret;
>  
> -	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
> -	assert(!ret.error && (ret.value & 0x7ffffffful) >= 2);
> +	ret = sbi_get_spec_version();
> +	assert(!ret.error && ret.value >= sbi_mk_version(2, 0));

This changes the check from >= 0.2 to >= 2.0. Also, before, we were more
tolerant with the return value potentially having upper bits set, since
the spec only recently added "When XLEN is greater than 32, bits 32 and
above are also reserved and must be 0." and we can leave it to the SBI
tests to check those bits. IOW, this should be

#define SBI_SPEC_VERSION_MASK 0x7fffffff

 assert(!ret.error && (ret.value & SBI_SPEC_VERSION_MASK) >= sbi_mk_version(0, 2));

>  
>  	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
>  	assert(!ret.error);
> -- 
> 2.47.2
>

Thanks,
drew


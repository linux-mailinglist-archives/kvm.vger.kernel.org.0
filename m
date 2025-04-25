Return-Path: <kvm+bounces-44310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA9B0A9C920
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DB514E2BD6
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D556024C07D;
	Fri, 25 Apr 2025 12:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NFFWra0Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFC623F291
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745584994; cv=none; b=FXzEXaqLCJv7bkr+3OzkwZsVl0ZO1H5SsuRapvlsWnyGOCEooK1gGuWrG7NvCdzcv7z1hy3sWItIFn1A3fj+WsAkR7iEoBvN9WdMvYR2r+ZIoExXEdQgd3zlPdegu3IUU43G/8WzZYegOS5JCWXvvdptH8SDQXwEgh1IkxgVGXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745584994; c=relaxed/simple;
	bh=440njuXJKD/2yQ8SY/SQTci2FXutgjiR0ESuahE0oHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qilj10qPzQtSA1Cw1Qswjy9hwm2RpL6EZMjjMss5Y3Pu+jzXycqTyovdtToVDkpAPJxcePCWoaDwNugn+lp5NGXmZ638tmnGqluYSji0bsUfRdMPDf0sFgRXyQG5t9VTQwbMryQKk8kfnTAXq1lBHO+aahXuXQfDXtWYKskoTsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=NFFWra0Q; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so1425709f8f.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745584990; x=1746189790; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cf3d2/UTjuBhFnPBgj+LsDiH4ilx2WtXI91CDZT02q8=;
        b=NFFWra0Q7Yeo9RuyqGtSgbSFszw+srubBag9dVt1tfI1UmSqawxBerUV5Rkhlzahud
         QH8RIQ4VK2IIUqN2QGPGKq0ik4CKx5+QzojhHXZ1C+uGOnlkHK/RDBfFYIh1bP/LB/4r
         i6vISlj0AMxlNBDP3k7WdVBFXI0eSzxwsOL0m3SBnyq2n2hi9jNMNqTAp6TlZnMJ0Ii5
         8k2mUnbw47OJlsUsMNHds5RNtnAPFL7r13r6DFeW5Cplkmp78p7WyScgkmFaRGWukkVV
         TcxT5Khc8KNw+bRW7j/4yYaDbNsCMXGI84NhQQh9F6h/CpgRjJfpfxGPONHiH9LVnSB+
         UCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745584990; x=1746189790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cf3d2/UTjuBhFnPBgj+LsDiH4ilx2WtXI91CDZT02q8=;
        b=rVdaJYJCq6f4GPoN15CXsnj0TmyMiPpyV1nm25uDwsnxgSaxcuOw/nkR99xXnhRTiI
         oYmGbT1K/LsLE+YG8MrIn5LGaSB5OB5TLMtDttK9Ol0uxXUjN04kDp0rFRr7t+8qTfMT
         y5A0j+M4vTlzDQZZYnSLSEudpErpwwNbIkKOJE2UUIOWBrvzURTgzT8Ugg+08dfOEBEL
         t1bk6KKqzdHv8uZI4jfFnwG1E+ucDJipMx2eodnv2HWw0kzpdUi8g5WyGlfHH1Fg1Elj
         2KzPfOMnWN64Hbn+vjYvaymRBdM3mEbGFEVLFaPjmZieHV89MSWpliUpqu9xH6tLgXuy
         59EA==
X-Forwarded-Encrypted: i=1; AJvYcCVMvEYc81aztUqjYiZDA/d3w6h2JqGbGzIOUbZ5X77A/Qb/GAYZx7IJiEV9UVvZp0KIhDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqAWBYEh7clk7IrBrkn5gRiaJGSJvzwbuxxk/jyrLEoDtazpUe
	1MLvMkLs1ikcaYijZ84UHPnbfnRuMMIZzSfA314k03AAhoKSIROgTbS0aMwRh5o=
X-Gm-Gg: ASbGnctOMxD41x9NPODNbzFmGtkboy2bzYUz/9qfY3kMkz4WrYg3JIs3azo96putflG
	p0lmVeTpT+/nPQUXgq7rF9OBVvwRGPdj3UVK5qSDKfoWBfnfkp1NS4RKD21lt2jqH+LwfFb/JjN
	0jTJ8S804kKPXBLocWz0zmQO3XQ1yFrs8d+jnZgbbPp7soXWPrpRU/NaaImAYp9kNUhr/f7t5ZO
	gd+8p7/iUBJLb2r8AVy4QnuPc/QG4BD7dCZsl5UJLZczRHks2M5BIHpyYNdvlKjJZO5JV9WUraB
	6WmmnTwxjxhLBBZPt7qnGEnKNTQc
X-Google-Smtp-Source: AGHT+IFA1AA7xPcXMcnBbdezLvvwEkVdUlNYNFgLV6mE5BuEB/JqAab31HMxgk/sqPZatMB0xTSnSg==
X-Received: by 2002:a05:6000:402c:b0:39e:f89b:85dc with SMTP id ffacd0b85a97d-3a074e1eda0mr1619995f8f.17.1745584990421;
        Fri, 25 Apr 2025 05:43:10 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073ca543bsm2312071f8f.34.2025.04.25.05.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:43:09 -0700 (PDT)
Date: Fri, 25 Apr 2025 14:43:09 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 10/10] riscv: Allow including extensions in
 the min CPU type using command-line
Message-ID: <20250425-c0a3a93239d39b73ff176697@orel>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
 <20250424153159.289441-11-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424153159.289441-11-apatel@ventanamicro.com>

On Thu, Apr 24, 2025 at 09:01:59PM +0530, Anup Patel wrote:
> It is useful to allow including extensions in the min CPU type on need
> basis via command-line. To achieve this, parse extension names as comma
> separated values appended to the "min" CPU type using command-line.
> 
> For example, to include Sstc and Ssaia in the min CPU type use
> "--cpu-type min,sstc,ssaia" command-line option.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c | 43 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 5d9b9bf..722493a 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -108,6 +108,20 @@ static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info
>  	return true;
>  }
>  
> +static void __min_enable(const char *ext, size_t ext_len)
> +{
> +	struct isa_ext_info *info;
> +	unsigned long i;
> +
> +	for (i = 0; i < ARRAY_SIZE(isa_info_arr); i++) {
> +		info = &isa_info_arr[i];
> +		if (strlen(info->name) != ext_len)
> +			continue;
> +		if (!strncmp(ext, info->name, ext_len))

Just strcmp since we already checked the length and wouldn't want
something like info->name = mmmmnnnn to match ext = mmmm anyway.

> +			info->min_enabled = true;
> +	}
> +}
> +
>  bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
>  {
>  	struct isa_ext_info *info = NULL;
> @@ -128,15 +142,38 @@ bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
>  int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
>  {
>  	struct kvm *kvm = opt->ptr;
> +	const char *str, *nstr;
> +	int len;
>  
> -	if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
> +	if ((strncmp(arg, "min", 3) || strlen(arg) < 3) &&

The strlen(arg) < 3 will never be true because if strncmp(arg, "min", 3)
returns 0 (false), then that means arg starts with 'min', and therefore
can't have a length less than 3. And, if strncmp(arg, "min", 3) returns
nonzero, then the '|| expression' will be short-circuited.

> +	    (strncmp(arg, "max", 3) || strlen(arg) != 3))

So

 if (strncmp(arg, "min", 3) && (strncmp(arg, "max", 3) || strlen(arg) != 3))

should do it.

>  		die("Invalid CPU type %s\n", arg);
>  
> -	if (!strcmp(arg, "max"))
> +	if (!strcmp(arg, "max")) {
>  		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MAX;
> -	else
> +	} else {
>  		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MIN;
>  
> +		str = arg;
> +		str += 3;
> +		while (*str) {
> +			if (*str == ',') {
> +				str++;
> +				continue;
> +			}
> +
> +			nstr = strchr(str, ',');
> +			if (!nstr)
> +				nstr = str + strlen(str);
> +
> +			len = nstr - str;
> +			if (len) {
> +				__min_enable(str, len);
> +				str += len;
> +			}
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.43.0
>

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


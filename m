Return-Path: <kvm+bounces-11009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E92CB8720D5
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A55522831F7
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47005762DF;
	Tue,  5 Mar 2024 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="dAMoq0OU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD91E58AC7
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646750; cv=none; b=jQzL7Il++inY4MSPaWTKdXSoH3MM3OHwwZwnUxlmy6Cq2PisTsgxBKWrbqrnszvXQEdMBeXi7DAGWLQ+rGkcEaxliHeRz+mM51zglpZsq477ceWJVWfATaUTsu8bU7QGipnN6Bdwa+wVoDy7lIDKA+lmFBR5Qk929ESPjRInza4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646750; c=relaxed/simple;
	bh=E0cup9XHTg0Jk93yvKwsAEASCZWwsWlH8fQYCFJSKrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cdug5GSgwOaXzIFsvafDF44zCQvYr5UvBNfqKDV0H8VboV5QBG52ooFn4Ni9jGP3fNs88VNfRqPJTL4RzlAPt78LK8zU6U9bGhaT8SIddOOM1TlKbEWgXihPTxJo6njVf400SnKDkuil09Y4nfLcjibLjLjzp2jgCf/x27qFFX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=dAMoq0OU; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-513298d6859so861797e87.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709646747; x=1710251547; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x0+/F9yIyDFWa2cLOZBvi3dYezgFdZjlUBtNmjzvp0Y=;
        b=dAMoq0OUVMcjyxAEjYhGDT4OrlsitTsU8cSQGzfL/Cv4W1FdsIXSkz2hXeITQzTi79
         jucw8G2bUfXp5b0rlkWgDY2+X/J7q0HGKb6hOyd4fUOb/VQyNJ+ze2ypHZ0s5kzD5n+I
         3WjQglQBXg1ckRSdJjtmJQxiX97HDQz/v5iK0MiW51d1oxX6v8Y7H/l09g1XrV0htwHR
         cIa5aDe0B4JRZYqGVj/nHRme590JrjmbKrI229tO++1nMgGpw+123CEYDHWhCJcExgqQ
         3792AJUOOUsKeM+dugvQ7F6mJ7/qM3U3P5EHMS8J4+NLtzC5BFSZVX17G13cM/NtvbLV
         EX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646747; x=1710251547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0+/F9yIyDFWa2cLOZBvi3dYezgFdZjlUBtNmjzvp0Y=;
        b=St701m9bE/Ynnen6kSVLpKmSEB9VDyGmgBqH/M6WhtvFLLerd5tcT0ZRhavKfDEECU
         Lu488wWTdgsGK+LIY8zKa3u6mclqA6zTvbGdM4lse6SgzKn9zKka47ireoJz9ldQlyst
         M01VgTIUoGA12edWQ1zVx+BTkehqaoXtL16dG8W9MSo/mne9pfm0nUkahFSPJICKPx8b
         Xrg03hg7To5PKg3F5FpMjJU/VnxCsMCmit5sEwh8k4JxRNB1DV2X+Tn/2x1e69pEO/n8
         1FhuCKwTuKc3IGIhaas5Q4HCTp3AWf7+5o4enFCDQ6qygknbTDijkvkroerPyfvgTaEX
         nzjA==
X-Forwarded-Encrypted: i=1; AJvYcCVM98rxRve1yiawf7NoDL5MPKpk46dfvCUefl7z9YA/xdRAkw4utFU7FW6pqkDaZESIdJuqQVAVJT/Rj0ri6/T8qKbG
X-Gm-Message-State: AOJu0Yx87jkVqJulszIBRdAie4IpCj/hZ+i5alftpweA8yz2BNt/6PBc
	NSa9hdOvfU4KArRmIxyQaRg3cnx8SRkzpC0nLInYnFp4SQTxVtWQptyI5xRna4A=
X-Google-Smtp-Source: AGHT+IFk1xWhU+ZUpYRMGt03Z0RA0hJbI17AYWEhXFT2tGMtV8bWqxsiwi9F6QIc+IsSw3z+tDmcqA==
X-Received: by 2002:a05:6512:3d0d:b0:513:46f2:26 with SMTP id d13-20020a0565123d0d00b0051346f20026mr1703856lfv.66.1709646746897;
        Tue, 05 Mar 2024 05:52:26 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id f17-20020a170906049100b00a40f7ed6cb9sm6076835eja.4.2024.03.05.05.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 05:52:26 -0800 (PST)
Date: Tue, 5 Mar 2024 14:52:25 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 10/10] riscv: Allow disabling SBI STA extension
 for Guest
Message-ID: <20240305-05dffac2a28923796e790f0b@orel>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-11-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214122141.305126-11-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 05:51:41PM +0530, Anup Patel wrote:
> We add "--disable-sbi-sta" options to allow users disable SBI steal-time
> extension for the Guest.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/include/kvm/kvm-config-arch.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index 6415d3d..e562d71 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -186,6 +186,9 @@ struct kvm_config_arch {
>  		    "Disable SBI Vendor Extensions"),			\
>  	OPT_BOOLEAN('\0', "disable-sbi-dbcn",				\
>  		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_DBCN],	\
> -		    "Disable SBI DBCN Extension"),
> +		    "Disable SBI DBCN Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-sbi-sta",				\
> +		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_STA],	\
> +		    "Disable SBI STA Extension"),
>  
>  #endif /* KVM__KVM_CONFIG_ARCH_H */
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


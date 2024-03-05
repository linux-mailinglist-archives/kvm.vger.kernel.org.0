Return-Path: <kvm+bounces-11008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8B28720D2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1746AB2217D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8F886642;
	Tue,  5 Mar 2024 13:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="E7iMScwI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDA086134
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646700; cv=none; b=MZ1MJ9zyHROCqTSsGiJphmPcwVX33VJNOGSc+P15EjRyl5v2RXf2oEBBnWMTj1/eRaCbRmYkbepPH6ptTi0AKoqqAIOJpUFV8OKIg68CPWAgEErxmUWAmunKjz9vFYGEL8Vg6l7PsK9l4Jm9r2V4IJ1tqA/vHByaWBw4ip2o4MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646700; c=relaxed/simple;
	bh=6VodtIj5Ob6p62zwyzVkiJ84poXozA4D6xlpLjNvEv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IAyXKEfayknw3o+peGVHWX8lCbE5CYJdIzydO3zuSpwFzuyiu7Ch3JrcV64rVfUNfzY2Of40tf5sRPYJKHm0XV5dVfBDOpZ0mV1U2/aWgNi9hDczHvcR+B2o4LNTACbIX8/LoSoviieuzc+PpvnPWJcSxHpeJD+TrzNbbRAELjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=E7iMScwI; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5133bd7eb47so3809854e87.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709646697; x=1710251497; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OWoYAqXkdvLJMoSNhispTiTa1qzyShdgEdDmBaoM+so=;
        b=E7iMScwItc3EN4sn7QsljGc5YgVC6yt2mCaOvvnkZ1J0+PsrquzfMb5RNDaOxf3wgP
         WPIdQEuMTZk1diiMVpDiCv50YR9ejqMLP0gDPBMvSwDdQuH/SIkIkDqQDqbA0cHVeXdT
         s+D0DB0c7c/P1eI1RqxSt09wEcWm8j12kp1rVNeYWyQzFLPsZoyh6pN9rPREgMQiFPrO
         fUPvsaIvAl7SwGkaiL1IqJHCDLApuAL2Qm8CGxpB1rnSq5Kb1loP9huFJE04H45rxR9I
         6E4G96SJntqsGFO4BK+jIh69I6oms3rNBD+yQWR8Pt2T/ildOw+PvLb1GZ47ipcFIC0v
         A5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646697; x=1710251497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWoYAqXkdvLJMoSNhispTiTa1qzyShdgEdDmBaoM+so=;
        b=KfnitBNz9szQ3Cvn4boQTLElB/2cddDakMXjfii65wyEwiotiUaTo3dMh9Y5JMXHn0
         Dt12+Ye3lFujAe+W90yRr7NEY0g32AIXeg0b62Sao3mVAtiEKcx78Z0rKuw2AxInz792
         bJIvig0lOdpU08QylW966qUBZXYuNtj1p8VV28sm0NLOPj8XykF6Vk1r02a6LMz0/Pip
         GxisB9uAiCAJvWoMvfsWJIDpiW7+LyOEK1uXX7A4wHc1gQsGd3fbfjsfc1NXBavQRIvg
         ROS/gmotfAGNwfVAMnTS1ZhoSBMhlfV6IBQ3duGS+pBnxAKn7vu6sGwWF0p68zYdAKHR
         CMaw==
X-Forwarded-Encrypted: i=1; AJvYcCXDabWaCLZO/tY/xVvCHbLXc5eQ8NQ//1x1fG6YEcI0wH3PgSA3TeTb+aZrCBP/nR1tEGFpLVSI9RYIs5ihP437VxEC
X-Gm-Message-State: AOJu0YxzWFDBHZJPFRfAFEmOaRDS7tYcjYFlLcJM0TwiuYL9uEh2GKHE
	YPi5lbjwqDqCLOzX12pR3GAzdsWFUcyyrVr+ik/qnh+bPxlSSlHkJLQYWHWjxeY=
X-Google-Smtp-Source: AGHT+IEHcJGlISIHxzeTH1R6KT4gRCipgchF6bx35OnOn3LpzxdtZURhNZph21XF/oJXCKtNSiyO0g==
X-Received: by 2002:a19:644b:0:b0:513:39a0:1fec with SMTP id b11-20020a19644b000000b0051339a01fecmr1315114lfj.66.1709646697404;
        Tue, 05 Mar 2024 05:51:37 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id w16-20020a170906185000b00a4551cc291esm2255452eje.40.2024.03.05.05.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 05:51:36 -0800 (PST)
Date: Tue, 5 Mar 2024 14:51:36 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 09/10] riscv: Add Zfa extensiona support
Message-ID: <20240305-b511f6616851f55ae466a17c@orel>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-10-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214122141.305126-10-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 05:51:40PM +0530, Anup Patel wrote:
> When the Zfa extension is available expose it to the guest
> via device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 005301e..cc8070d 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -29,6 +29,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
>  	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
>  	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
> +	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
>  	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
>  	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
>  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index 10ca3b8..6415d3d 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -64,6 +64,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zbs",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
>  		    "Disable Zbs Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zfa",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
> +		    "Disable Zfa Extension"),				\
>  	OPT_BOOLEAN('\0', "disable-zfh",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFH],	\
>  		    "Disable Zfh Extension"),				\
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


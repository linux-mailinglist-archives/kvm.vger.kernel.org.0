Return-Path: <kvm+bounces-43194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F56A86D56
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 15:46:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58CCE189AF2E
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 13:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DD92B9BF;
	Sat, 12 Apr 2025 13:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="eke3Ab06"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FB52367C1
	for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 13:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744465567; cv=none; b=XCIy+1tBNkiFqj+Uf1xYdQv3ZwgyMPZNi1N45rXRhA8H1VWx7Wl3flHDE8Wv+BRHbLX/EWAhfbgKno2jCtZbAp98aSyidL9rJsFU+UZ47BVydgvQy7Ax/Jcq2ggx+LWZyhdQXV76k2H0YJYv9wlk1dvKgidVK7D6WIKB5slXtNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744465567; c=relaxed/simple;
	bh=njhHKt4PIBR9TOrJOcU3H8+SC/RioxBrOMfQMAjsNCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PAqMggDMBngGLZ7uxlYyAL4o7MeciXP3BxOmfxZzaMPbnlRxDclXb080J+BCw5wYXn8CZh2fl3GY/iorEZl/C+vFuhPn6LVORyaf5oSeR9+GcK5YuKFRJKxBgA/X9dyJ9mjCFJLVr8f522rQpVhZFLIh4YIzcpkcLe9tzBZF53c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=eke3Ab06; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38f2f391864so1567637f8f.3
        for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 06:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1744465564; x=1745070364; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jtwttZvLwlshHSUwBqfCayCIzyCXwqtOPkrJdw9L1s8=;
        b=eke3Ab06+SO5iYvDAycxugeXl8xYca9uGBudzn/6o93dOb6daCBu0GAUnbKnX82KVL
         jFB3Vk8SR3aHo+0gnRG+nrgiVtaU/z0MUfR7P1F/BSifBjt3GIEk6fv6hqZcRiM51cC8
         tghe8InQ6e9+UrPF4/MrkorxaK8+thJyBZ3HwO452b9xRy095nOl9A+rb63UBY6JjdLB
         bdBcPR4Df5r9voaY6PEM93uagZOEbWXipKsPZrn9HtcDDfk5Q8DZcpHYyGHaxyFfElGN
         4g/qFahK2Q3B6sAwSWS2oR8DaQzcheokCRi337O+QwHByiNEyfElwGpj2Ft8HVvCC7tM
         p0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744465564; x=1745070364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtwttZvLwlshHSUwBqfCayCIzyCXwqtOPkrJdw9L1s8=;
        b=RyzqExkiJF2U4zTYePSUyIwX3Kt6hhom2M8/uc9EfSnP5eCsHvYlKCyPrzIzhDmUKa
         BzUB/lhpNn6kJW3sKnsVmKCjq9zea8MqXLA5KATd0hdehkJLo6FzgcQIZSdMyvOIGTPn
         FwgP0PJv2DG/2BaeVtqR1m/x2ZfYHWjiCO78tpwrpMsu1ZjggHOLpsJdlWk25L4xZvSo
         ytPohyYz0bor/DZAnwF+XseANVv4q/vtZ3BSj3ESVT08zAtu5ka4a328czE85HSRQyGJ
         1hKdV/Pzs4gyIXUf+z7rJPAzgfmAgq3oqhVy59YFvQ30G87JbAnWVp9WvSaUy/tNj4bq
         urQw==
X-Forwarded-Encrypted: i=1; AJvYcCVrfFp+1+MrjLXKIdFkx2YbwAEpvb4/ko+xqHTp/HYeQBr+sNk+SRff/9KsNqjibwTDKZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9ZfnOENXAp1qvrmAmlth4UX2fklUeLLop9qPBHViuCAXW0nUI
	Yh3zs3X7cdlPryWFJM24ryk+NkeOGGXetcm9co2xkRlp6IS2GAGE/gqtdzpCg4k=
X-Gm-Gg: ASbGncvTvtpes5+JeBd0jGIao6kgc4OqpBWkBxvg1kAn4rPG48o/UxAuyg2WVVK4IKU
	o2VCwpYYpsdQVrd8PEAaYUvf8QMhdYdPvIuMNCALJ+QOBfqRffLIWaf/WcAiZaerXomAWEQKFqh
	hBwnsS/3Zq4zi5p/rBEpMqb2BPxqmPcYwUc4cvGGlA6TCjJ8ZHld4K2c1wTOoHGsQHCh+Igd+k2
	EfWeo6FINdCKYU3ODFic3rPkJEhwp7N9qkDbtVcMu6DnB9awlSyFkWvfQkAqdhTtSOkSHWnlRaK
	U/k1pTJKf8ni1lY1beiXpKRv1qGe2mK2w821KCgk1KVSH+ia7hXCyW4IXfOk8VhCoj/RBA==
X-Google-Smtp-Source: AGHT+IE+rwHw9nHa6ryoPIEo6O1nhK+baQh0ytegKnWQccKarq/0NciKVPWcuHHHwpI6NIKVm1J1CQ==
X-Received: by 2002:a5d:64ae:0:b0:39c:2688:6904 with SMTP id ffacd0b85a97d-39eaaec7e3dmr4590367f8f.39.1744465563746;
        Sat, 12 Apr 2025 06:46:03 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eae96407esm5152330f8f.17.2025.04.12.06.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 06:46:03 -0700 (PDT)
Date: Sat, 12 Apr 2025 15:46:02 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 02/10] riscv: Add Svvptc extension support
Message-ID: <20250412-4a9f672931bca5890a720923@orel>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-3-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326065644.73765-3-apatel@ventanamicro.com>

On Wed, Mar 26, 2025 at 12:26:36PM +0530, Anup Patel wrote:
> When the Svvptc extension is available expose it to the guest
> via device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 03113cc..c1e688d 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -27,6 +27,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
>  	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
>  	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
> +	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
>  	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
>  	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
>  	{"zba", KVM_RISCV_ISA_EXT_ZBA},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index e56610b..ae01e14 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -58,6 +58,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-svpbmt",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
>  		    "Disable Svpbmt Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-svvptc",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVVPTC],	\
> +		    "Disable Svvptc Extension"),			\
>  	OPT_BOOLEAN('\0', "disable-zacas",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
>  		    "Disable Zacas Extension"),				\
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


Return-Path: <kvm+bounces-39553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 607E9A47831
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 09:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EBBF16B7A0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED13227563;
	Thu, 27 Feb 2025 08:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="CKE1uBGF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38474222595
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 08:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740646180; cv=none; b=Nx17pzkAaIdiun/dRuYvCmngNsD4OEpnHVbAeGJqUxzHo9RFHiqrgHqFqanifjUjmbRMB97NErPxHCsmkR+Rb8yD7YpxA/6TvCn5UyERdp2jtTQxUd5B1//1wnaNd3DTEMJQNYpyd8FRUi8JY4Cyz8v42xXac7XtEQ/qL5vnKt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740646180; c=relaxed/simple;
	bh=BglBE0o1Xf1pxXgJXs2O4w8c/kffMCOkC4hTg3yAXOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mo9A+b88psr0J0OJYg3tU9ybmMxrz6JAZBhSmIdihr/r1lmQgw1HdzTtRwTRPtZ14mPXTh0Df/VhPWcx2IKfh5r1TJoAwj/0YEdDKLy6r44Dt+DGYv0bZereqxi5d2eZrAnwej/WJD4At62LOc4Kxl/YhrQE/s3PJzuyTCo96XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=CKE1uBGF; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4394345e4d5so4402075e9.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740646176; x=1741250976; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8xwt/QS7TwZTYg2MTdoUft0EF5h6WRYVihzhqZrEMa0=;
        b=CKE1uBGFVgI2XAE+HsCFb6ur/ePlLjy+VhXPbRiJ5Jx/PaN9/Jwh4/uswsaCZ7i8r6
         HjlAuMzk+J+de6y/KJO8k492R/4GoApP4EdCDXpLSapMRD9hpesHKkXZF4CnBDQlkszh
         nf8pIy7PhJzkyYVPxj+QVte7QrKkh/YDW7Mtp7JKRE3zP9yA5rA9X4eqpX9AEZlCXNty
         nv+EsCCiDJ4i81//1MSK6GxRk2zPWO3nbTXNPQbFiHbwXzJPIi4JXU1AUqAFs1wQCS6F
         dP0t1pBilGLIjNZYoqKm33iMHXOKJQgcAiiP9pkrw5w9pdhpxU+qStCNGfLrNDPZHkcm
         a4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740646176; x=1741250976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xwt/QS7TwZTYg2MTdoUft0EF5h6WRYVihzhqZrEMa0=;
        b=Gh+37GXMONWGNpIUNTY3+M4jteC8J7TYgR+ybK5JdWRW3+b4zPXJbYsXLNxTfVni+t
         o1LvtqRVPXcrxkD1qV8M6pLTyRvU36j+JBu8q0EorIu3ojAYQ8EI3hIJnZ3xSToVL1L2
         zEnj5VzklPeC032oeDr0FNcVdBkL+zV+wymeAPj8+AGNHJiZ46SsX7CwG+ihmIiZAzq1
         dFW/8oouCekE3uKWOMkMRbIl8qOxiW+ZXr7hZVmWqHOVnsl69OzOAw3eDNPLDAr2OEcf
         8DE5V4FIPWHG0UNcX+MeYysYP/ojg0AidcPe+ixdYGiTQv2SDoRtgCl9duVxy/ITqPmq
         8EyA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ+hDunQq9fv0ZR/gXqnFJTdpHXMnogQhvyCKNM29D8v0dUbhQhcVFcXUBE+KmLlpxf+o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrAisbFTH2GQwEYMm58eN8it7m96t5Se7qaKBO7FFpWVy6HrzS
	tRraf6wrEPaSaPZggFQfNd9D64oLuLndKcqaT18WnPAXgzcV1TUOdzxs9neVVgk=
X-Gm-Gg: ASbGncvweXw0JUdjn/ottftkt8IUbIB9lUwywVHdkPreNmIvGTJig0qigVPm4eC11HS
	Ot0lApcTcbiqC3B9dSPOaemGPtx6pmrsnXQzpwUqsOLHBmFddeuocM78a/xXR2UFetKPD3STYjD
	21giygpZa0Lzz51UG5+yrR0V3GYK+gNJ/NY+j6MMbLAhEKJm2oUopnC+LjBLAE5XHxMPYOwDS0Y
	UJrMiPm53Tyb8LMSF5GVIN4lddr0raJJQFqN14xOeEYILbeqtV1oen79qdbwkBn8MwUbjRYIJCZ
	/mmjI4Jy9LwYNA==
X-Google-Smtp-Source: AGHT+IGsBt36A+nA64K8jmDgdrsH+3epzXLzR2VIcO1N8jO+7h2K8GwaLjrguW+gS8ljkw0FbuPM+w==
X-Received: by 2002:a05:600c:4f47:b0:439:8bb3:cf8e with SMTP id 5b1f17b1804b1-439aebc369dmr183762555e9.20.1740646176499;
        Thu, 27 Feb 2025 00:49:36 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::8cf0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47b7c43sm1308781f8f.49.2025.02.27.00.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 00:49:36 -0800 (PST)
Date: Thu, 27 Feb 2025 09:49:35 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/4] RISC-V: KVM: Disable the kernel perf counter during
 configure
Message-ID: <20250227-d64f688ee1df2811528ec2b9@orel>
References: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
 <20250226-kvm_pmu_improve-v1-1-74c058c2bf6d@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226-kvm_pmu_improve-v1-1-74c058c2bf6d@rivosinc.com>

On Wed, Feb 26, 2025 at 12:25:03PM -0800, Atish Patra wrote:
> The perf event should be marked disabled during the creation as
> it is not ready to be scheduled until there is SBI PMU start call
> or config matching is called with auto start. Otherwise, event add/start
> gets called during perf_event_create_kernel_counter function.
> It will be enabled and scheduled to run via perf_event_enable during
> either the above mentioned scenario.
> 
> Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_pmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 2707a51b082c..78ac3216a54d 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -666,6 +666,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  		.type = etype,
>  		.size = sizeof(struct perf_event_attr),
>  		.pinned = true,
> +		.disabled = true,
>  		/*
>  		 * It should never reach here if the platform doesn't support the sscofpmf
>  		 * extension as mode filtering won't work without it.
> 
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


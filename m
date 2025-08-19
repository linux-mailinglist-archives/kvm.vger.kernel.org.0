Return-Path: <kvm+bounces-55007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1F4B2C904
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0B151C2738F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D822BF013;
	Tue, 19 Aug 2025 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ByKqp2Fi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC302EB873
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619437; cv=none; b=f61jO4MQbh0LkNjLUC3yV4OgNZnZJuLbD7y7hkaAtTLbQvrcJ9N1HtOnymu6rYnC3y5+D/9OCNkU9aYhMoS5GVYFSyP/Aae3LYN+IT+AUT3/5t6awTsWzfiseKg2vO4SFMhKhz8LDBIj7Rm1GvfnuHPvIq+95btgVgtOVba+Rrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619437; c=relaxed/simple;
	bh=ElsK78evf/jSWVT/An81m0pfn9gX4XVTLMYXztIt85c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XHL5RHuI/3Zvu98zqBHiFHPy+Kt+qA+10CM3et7h57htvmlNw2LwRpudqh8KD0AA+xFZUjNn+ZGz7XObGe4YdsulWE2B67xY1A4maEQhdJFd+VyUfm/JYA+Kn/tZym1/UYBWXqkVW+MzU82HS4qpYkXqPGDeJAubuLYxBVzgurQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ByKqp2Fi; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-435de70ed23so2997996b6e.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755619434; x=1756224234; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yC88mGoSbqZk1f9KFdafn4QiNyHx2q3f5J/pFIXzL8g=;
        b=ByKqp2Fi4w4PPaHkLxoaPjtNm3qQV2I1jvR9DsgVqEZoI+hZJx4uCvmh7HVTq4bm+O
         dgnku9e/iLylYxHg4m4M3GtlbuUpZ4c6jbLkBYuNmaJ9Dskqe7EMEFs1XcPace7jaOkT
         MY4X7Dn1vcirCgaQk4JFcE28d9yTwaPfxXja9sx/6Wz7CED40zYZzihKEtkWvqj7JkE1
         Lznb0++JfOJcasQUkUQN/Lm+N9WWo8kKydHPItDh8s1qDC0RrIy6fNV5Fixd7D6zVd9M
         NWIycDmA6asXjvw1/XVsM6qa4PN8DoB/RdrE1csoDMMdQ6l0ww/fiR9J+83gXmJNvCGf
         ybqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755619435; x=1756224235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yC88mGoSbqZk1f9KFdafn4QiNyHx2q3f5J/pFIXzL8g=;
        b=uOeVH3eCNnPpO1EnZeJGCe0jMDSi8je7XTpGFi4kP3IHewL1cCxhMHnR/sB9qgufP5
         m/qZhmDFx1blu6g9gruatEqhJL/YtbiqD+2iiLc6uOIfnTYqFXsQMCHup5J0QSncXafK
         EZP9Gfvn3j1ItgBblJqEQSDNYeFlJHLkkTH9FvAKsyAJg98a46gcuJCayVFgu/iXONjB
         2IShSyGt+hMEHIjOcp7jfuSHDaSOmHelLT1sOHf1WNlDDxSXrwq6+W+EiSVrTNeLP5BV
         FozOFuFiPk3qHUKNXQz2oEeWTLBb8QZz7ugTRYsiE/dhIbt72ZX/I4uFs+L2qIf8mYrd
         oxjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUx/PYZ0eeY6XxvVa6Zbo/gxMi8SkX2sNRMnsTnUDaUYDPBcq4pUhYdyVeJOgD52ZMLqlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF/sIvK0KnRMpB6xUXcYMI1JqnJMAd6izF0sqVMHtUWyEn8fxe
	ynXZ69UENxUPlx0/6QjEs3C+hwoX1AKvvriI4KQouGQkjLuqQb8p0jK8LlkEb2YmimA=
X-Gm-Gg: ASbGncsQcsJKz/pVbychqMAlVPH3/ak/GFWPRPN4s5KAVl87L3tcg41yvKlyGNsgsog
	z2m6bBgzUu2xXj1IPvDxZTg2Fa+4v7hq/dBoosZ25oBBTRf7SNm3BzHI+tDhWnbrtpdazV3927j
	8wCJ+4C7pif6be9cU6HN4s0heAdQK669gl8cpMr5HG/T+8CGKB8603ZV5ClHVHPYPhEmMjexNA5
	aCKwTBzNSNWaH9w5T8kD1yhQdGA3jcWXa317nfNg0kWbxFS99HwVQiFXyPvaXJhvkgnwa5Tu24C
	cZamP04WGI5uTUs72rYFFThG0lhwzMqlOHfykpQB6bdxz5coxeEEypwYGpLfxAzRyGK+SF/lC+c
	Xu5VJEAQHbAMVB8PMClFe2moghmm8x7PDvhA=
X-Google-Smtp-Source: AGHT+IG/y8PrsSJqgoq3CvRF+MG0X5iWsQigK66jrK0xGiIjJMRnFVwGXiYkN7AL+ccvUXU/i/hDzw==
X-Received: by 2002:a05:6808:1b0e:b0:435:744c:9297 with SMTP id 5614622812f47-436cdca93famr1950579b6e.16.1755619434540;
        Tue, 19 Aug 2025 09:03:54 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c949f75d1sm3510509173.79.2025.08.19.09.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 09:03:54 -0700 (PDT)
Date: Tue, 19 Aug 2025 11:03:53 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Jinyu Tang <tjytimi@163.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Conor Dooley <conor.dooley@microchip.com>, Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] riscv: skip csr restore if vcpu preempted reload
Message-ID: <20250819-62ec62e0ef8ed3d928f56ddc@orel>
References: <20250807114220.559098-1-tjytimi@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807114220.559098-1-tjytimi@163.com>

On Thu, Aug 07, 2025 at 07:42:20PM +0800, Jinyu Tang wrote:
> The kvm_arch_vcpu_load() function is called in two cases for riscv:
> 1. When entering KVM_RUN from userspace ioctl.
> 2. When a preempted VCPU is scheduled back.
> 
> In the second case, if no other KVM VCPU has run on this CPU since the
> current VCPU was preempted, the guest CSR values are still valid in
> the hardware and do not need to be restored.
> 
> This patch is to skip the CSR write path when:
> 1. The VCPU was previously preempted
> (vcpu->scheduled_out == 1).
> 2. It is being reloaded on the same physical CPU
> (vcpu->arch.last_exit_cpu == cpu).
> 3. No other KVM VCPU has used this CPU in the meantime
> (vcpu == __this_cpu_read(kvm_former_vcpu)).
> 
> This reduces many CSR writes with frequent preemption on the same CPU.
> 
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> ---
>  arch/riscv/kvm/vcpu.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index f001e5640..1c6c55ee1 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -25,6 +25,8 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>  
> +static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_former_vcpu);
> +
>  const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	KVM_GENERIC_VCPU_STATS(),
>  	STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
> @@ -581,6 +583,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>  	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>  
> +	if (vcpu->scheduled_out && vcpu == __this_cpu_read(kvm_former_vcpu) &&
> +		vcpu->arch.last_exit_cpu == cpu)
> +		goto csr_restore_done;
> +
>  	if (kvm_riscv_nacl_sync_csr_available()) {
>  		nsh = nacl_shmem();
>  		nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
> @@ -624,6 +630,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	kvm_riscv_mmu_update_hgatp(vcpu);
>  
> +csr_restore_done:
>  	kvm_riscv_vcpu_timer_restore(vcpu);
>  
>  	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
> @@ -645,6 +652,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	void *nsh;
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>  
> +	__this_cpu_write(kvm_former_vcpu, vcpu);
> +
>  	vcpu->cpu = -1;
>  
>  	kvm_riscv_vcpu_aia_put(vcpu);
> -- 
> 2.43.0
>

This looks like a good idea, but can't we also apply it to
kvm_riscv_vcpu_aia_load()? And, if we could track whether or
not the kernel uses FP and/or vector then we could also avoid
restoring those registers when they haven't been used.

Thanks,
drew


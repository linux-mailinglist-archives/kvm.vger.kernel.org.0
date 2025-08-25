Return-Path: <kvm+bounces-55609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B399DB33DCB
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 13:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C33851A82AD2
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 11:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D3A2E5B15;
	Mon, 25 Aug 2025 11:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XUY314L8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB982E5411
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 11:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756120676; cv=none; b=ZxaBVw6atwu8gWV776NYbNPv++Chm2HDBekOraRDor3CQTefNltR0/REEHc2dHveoVTbs81rlSGO2s8TTDRJ61PnzwoyPvU+PzSDSeG9u7fZcMhkLQMfssvcwljfnIb9iAy+QCIojoOyptrC5OlXxqE8/9fmQbG/rxzTpuOZj1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756120676; c=relaxed/simple;
	bh=4VifmTidYyjuCM78tKvZIBrBjFrUlRYU5vspOC2YjhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oax3f47vRA4BfLPCmXunSrPhGPCQDxjHoRaK4vKSyUM9iWYThDg/RwQ94gzIfJAT2IfiOLYsbOxLVKD3WpvZVm3dmE/adgdgUVJFC7N+2klGBYTfPLpyNSQVCsrshwv//YT62vCHOPatdmqC+ShScMF0op0yFnI6c/2uzdqhr5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=XUY314L8; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-8845da04587so58466439f.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 04:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1756120674; x=1756725474; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i6Nj+duoF70RMGzdcYouFDD8VMssifTIE0BrLQHJWZQ=;
        b=XUY314L84bZ2V95D0wlsLNjYCefPoKOUmlmqEmfF+egbtDmgxMO4g+/NahpnqgnQWv
         OQRyHedJNKwQFEuX0rYmKLOGPxRRSbM1D74Tq0SajvKy5HMrD8D7ChbUiXmlp5vicF1G
         FTL1y4plN7OLI/yzD4uLL7hUp5kBLfo8+ky/p/vjfTgnDXWbHr7OVo1wQ7ycK7RP7HKz
         Mf5gQnD7Pb8RxQU9+6PzAcmWNvuorpzlAzSzmP8cjkdWHJ0XjbHnbyPP2fO4ygzz64M+
         BKNhwNIRCQKxZP2uQylHAwqzXeOLhhE/U8BwRG6NKcTduuASEnsXyEEQM++e4+v0y5PB
         NgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756120674; x=1756725474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6Nj+duoF70RMGzdcYouFDD8VMssifTIE0BrLQHJWZQ=;
        b=r+TUkF8tykZy5pZT8F0xbYLsUSzmOp1AkEsO6VbmBzmtUGybvCQADMN+Ir3cr2aF1S
         9JuUGhZvS4BAd/QEN8RJZEqK3LSX7PaajJaKFPPA3D+Sj5Wn25GBdetyPmLtj7IEaZeB
         lWoTKGKOoMejMElajcb4n+eAqyx6fQngE8fsZbMuoY+ZPeWZ1S+zP2JkQtGQ5hahjN3h
         bc+HhdMosY0BI/pTRj/usykQph4zljdGItpNFqdq3JD/Dan/Ly0HRuwqfc1ZiTs1cR1A
         hhFZRiK/tE/2oGYQyATqUKIsG/t7t4a9wM6nSpn3WNdFbVTXXN7Ljea2oKD27E077NjX
         PqPw==
X-Forwarded-Encrypted: i=1; AJvYcCXz81py9R4V0DNAC0vu9W2v+Kh1Pvks4qU39NiBv0FvRAvQauZXxUF4yOu+9sKQGOQr1SA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaMcrmEzDPkS3Zcj+wiX8ophAGLo8luumJ7ZZXHsEfnbI+4EKM
	LAR2t6nAs89epLSgJyUm+dB1mzPIjOasBa7K6tiW2I+L9SEvMJxCvT5JPKkjaySt4q8=
X-Gm-Gg: ASbGncsrpD6HJ0EWEBtRrvkNz7/An+ryW36GE6ol22qYTOnNIcrsGMhijDCSlpMzdxs
	OqpmlV9osEKdA8+ByWVAFPDZvvyevrmxujnjVFbT5YX/lFIPFwFu5ZbDuKUTaTgU8w6BjF71sIe
	AJTWeNo79L7/uKud9PpYvVTMgvwsVQ+NlPb6UdfzkZNTPFIiDNyLpVUG+8eAeEnHp59jn4Nxvom
	HGY6051kljUiuF+9ENmM81aZOhYIxjJ+HTJE1SCqYcu4lsGR7epLkTq40+a0aaUCnJffVZZkHw1
	dP4P/saZBq7X5exoE6/9aaDmIM9TCvsgmPIl19h5umDiVNSlEGu7HuG+9FWIqpoy8oZwdqDiyeI
	qfc13p6H1ocvJfIlQnNAvMd6E0WNi9inA/aok
X-Google-Smtp-Source: AGHT+IEigjCbL6EPOUxTZc6hVZl568KpQrRQoMmE5YONwYCGYB+k64Dw2FcHbKRMyeeSPlD17oBMJw==
X-Received: by 2002:a05:6602:13d0:b0:881:8a58:3bc2 with SMTP id ca18e2360f4ac-886bd12e5e5mr1736254339f.6.1756120674148;
        Mon, 25 Aug 2025 04:17:54 -0700 (PDT)
Received: from localhost ([138.199.100.237])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8f0a83esm464303639f.10.2025.08.25.04.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 04:17:53 -0700 (PDT)
Date: Mon, 25 Aug 2025 06:17:51 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Jinyu Tang <tjytimi@163.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Conor Dooley <conor.dooley@microchip.com>, Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Nutty Liu <nutty.liu@hotmail.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] riscv: skip csr restore if vcpu preempted reload
Message-ID: <20250825-a30edf6b9d0301b5fdbcfffa@orel>
References: <20250825110708.75474-1-tjytimi@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825110708.75474-1-tjytimi@163.com>

On Mon, Aug 25, 2025 at 07:07:08PM +0800, Jinyu Tang wrote:
> The kvm_arch_vcpu_load() function is called in two cases for riscv:
> 1. When entering KVM_RUN from userspace ioctl.
> 2. When a preempted VCPU is scheduled back.
> 
> In the second case, if no other KVM VCPU has run on this CPU since the
> current VCPU was preempted, the guest CSR (including AIA CSRS) values 
> are still valid in the hardware and do not need to be restored.
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
> Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
> ---
>  v1 -> v2:
>  Apply the logic to aia csr load. Thanks for
>  Andrew Jones's advice.
> 
>  arch/riscv/kvm/vcpu.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index f001e5640..e50d1f76c 100644
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
> +	if  (vcpu == __this_cpu_read(kvm_former_vcpu) &&
> +		vcpu->arch.last_exit_cpu == cpu)

Why was the vcpu->scheduled_out check dropped? The changelog doesn't
mention that and the commit message still states that it is checked.

Thanks,
drew

> +		goto csr_restore_done;
> +
>  	if (kvm_riscv_nacl_sync_csr_available()) {
>  		nsh = nacl_shmem();
>  		nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
> @@ -624,6 +630,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	kvm_riscv_mmu_update_hgatp(vcpu);
>  
> +	kvm_riscv_vcpu_aia_load(vcpu, cpu);
> +
> +csr_restore_done:
>  	kvm_riscv_vcpu_timer_restore(vcpu);
>  
>  	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
> @@ -633,8 +642,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	kvm_riscv_vcpu_guest_vector_restore(&vcpu->arch.guest_context,
>  					    vcpu->arch.isa);
>  
> -	kvm_riscv_vcpu_aia_load(vcpu, cpu);
> -
>  	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>  
>  	vcpu->cpu = cpu;
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


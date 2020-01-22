Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3922A145C33
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 20:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAVTEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 14:04:40 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37575 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVTEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 14:04:40 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so42314pga.4
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 11:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:subject:cc:to:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=0dIYIQ6Ta05mma/Ewu5gaFGi/nH4knzT9Odj9DRLZBE=;
        b=FZw1Hk8B8vQGLvzhFW6E/YKZrNWQLi3Q2MHUuiH5BUmxks2t4I4h+XV9fKrT4w1etK
         jd13qbCOREwLBDUw6Vd0yBGZjvikx5ia1yckH7iPmShYp+Z7zNKhHGaB2zRzCIBM4ULF
         xPckVN/U8NngMG+4Mp/tffR+f6HD5QRggAyaWYiDVxJIKg5ONQBdMHr6H6VjadGUKHnH
         oXMWFCaptGZR1NATwrcm/CW48pkFLR/oeikBDelJTGrtmxrqrA+/5kTywK4Hux3mVns7
         j39FA2T0WQzdVIA9TG/ktCnWoKwUZoXhv4qzaSfCzfaD/oADMFqFz0Lgv9JUFSTOHYGB
         V3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:to:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=0dIYIQ6Ta05mma/Ewu5gaFGi/nH4knzT9Odj9DRLZBE=;
        b=tFErOHZnjY1iZFhtYWzMzSJFJGkMBcakD20eKQ96DNhQYIqg8dLc1RtGxYUAWXnGqN
         2eLfiMzMNqoResEjAmYg65PmI263W1X4l4y1ksX5eQlTXQeCzUZqCFTOAmCPOO/UtPME
         eBsgfTEYCDcnDv79gb57PH+StGyAZxmoRxFlO3EEJwnNSMfRyRM5Z9YHcZV3TD0hQo4Q
         /qnnB8k+dbiOTkHeMUVJnO/YYwEbYcpGeMHe4g+z0bX1BHru4ZcXG1UeKdNAku+I1RT0
         U4TD6pXR4P0jmv3hPFkggcc0w4N/iBhOWI+KOW9t+3dg+EgTwnT2mMbmzK4pIllkJGFT
         pJQQ==
X-Gm-Message-State: APjAAAXle5YmTsnIPCW+cn8bB0qy+ZSBI76Uah7TVZx0S+SUvWXMNxIZ
        7y0MGpmA2OU3VGlTeYnx6trKmA==
X-Google-Smtp-Source: APXvYqzZt4KvUk7b6wsCtX4ZKWFznEZq0B+74pTWZfzxHWBmsYVzJaLYasTmR5s/oY61YtsMI7mIQA==
X-Received: by 2002:aa7:864a:: with SMTP id a10mr3982379pfo.233.1579719879036;
        Wed, 22 Jan 2020 11:04:39 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:7f69:cd98:a2a2:a03d])
        by smtp.gmail.com with ESMTPSA id j20sm47705279pfe.168.2020.01.22.11.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 11:04:38 -0800 (PST)
Date:   Wed, 22 Jan 2020 11:04:38 -0800 (PST)
X-Google-Original-Date: Wed, 22 Jan 2020 11:04:31 PST (-0800)
From:   Palmer Dabbelt <palmerdabbelt@google.com>
X-Google-Original-From: Palmer Dabbelt <palmer@dabbelt.com>
Subject:     Re: [PATCH v10 05/19] RISC-V: KVM: Implement VCPU create, init and destroy functions
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>, anup@brainfault.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <Anup.Patel@wdc.com>
To:     Anup Patel <Anup.Patel@wdc.com>
In-Reply-To: <20191223113443.68969-6-anup.patel@wdc.com>
References: <20191223113443.68969-6-anup.patel@wdc.com>
  <20191223113443.68969-1-anup.patel@wdc.com>
Message-ID: <mhng-0ada7fd5-2e39-48ff-80fd-32b91b96282f@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Dec 2019 03:35:55 PST (-0800), Anup Patel wrote:
> This patch implements VCPU create, init and destroy functions
> required by generic KVM module. We don't have much dynamic
> resources in struct kvm_vcpu_arch so these functions are quite
> simple for KVM RISC-V.
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
>  arch/riscv/include/asm/kvm_host.h | 68 +++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c             | 68 +++++++++++++++++++++++++++++--
>  2 files changed, 132 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index e0b633f616a4..297431660be6 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -53,7 +53,75 @@ struct kvm_arch {
>  	phys_addr_t pgd_phys;
>  };
>  
> +struct kvm_cpu_context {
> +	unsigned long zero;
> +	unsigned long ra;
> +	unsigned long sp;
> +	unsigned long gp;
> +	unsigned long tp;
> +	unsigned long t0;
> +	unsigned long t1;
> +	unsigned long t2;
> +	unsigned long s0;
> +	unsigned long s1;
> +	unsigned long a0;
> +	unsigned long a1;
> +	unsigned long a2;
> +	unsigned long a3;
> +	unsigned long a4;
> +	unsigned long a5;
> +	unsigned long a6;
> +	unsigned long a7;
> +	unsigned long s2;
> +	unsigned long s3;
> +	unsigned long s4;
> +	unsigned long s5;
> +	unsigned long s6;
> +	unsigned long s7;
> +	unsigned long s8;
> +	unsigned long s9;
> +	unsigned long s10;
> +	unsigned long s11;
> +	unsigned long t3;
> +	unsigned long t4;
> +	unsigned long t5;
> +	unsigned long t6;
> +	unsigned long sepc;
> +	unsigned long sstatus;
> +	unsigned long hstatus;
> +};

Looks like pretty much everyone else is putting 'struct kvm_regs' at the start
of 'struct kvm_cpu_context', which I'm assuming avoids duplication when
implementing KVM_{GET,SET}_REGS.  That would probably be cleaner, but if I
think it'd be best to just have this match our mcontext.

> +
> +struct kvm_vcpu_csr {
> +	unsigned long vsstatus;
> +	unsigned long hie;
> +	unsigned long vstvec;
> +	unsigned long vsscratch;
> +	unsigned long vsepc;
> +	unsigned long vscause;
> +	unsigned long vstval;
> +	unsigned long hip;
> +	unsigned long vsatp;
> +};
> +
>  struct kvm_vcpu_arch {
> +	/* VCPU ran atleast once */
> +	bool ran_atleast_once;
> +
> +	/* ISA feature bits (similar to MISA) */
> +	unsigned long isa;
> +
> +	/* CPU context of Guest VCPU */
> +	struct kvm_cpu_context guest_context;
> +
> +	/* CPU CSR context of Guest VCPU */
> +	struct kvm_vcpu_csr guest_csr;

It looks like other architectures either put the entire CPU state in 'struct
kvm_cpu_context' (arm64, for example) or inline all the definitions (mips, for
example).  I'd lean the arm64 way here, but I haven't gotten sufficiently far
until the user ABI to figure out if this would help in a meaningful fashion.

> +	/* CPU context upon Guest VCPU reset */
> +	struct kvm_cpu_context guest_reset_context;
> +
> +	/* CPU CSR context upon Guest VCPU reset */
> +	struct kvm_vcpu_csr guest_reset_csr;
> +
>  	/* Don't run the VCPU (blocked) */
>  	bool pause;
>  
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index bd7d6b154f61..cf8ca8d4a9ea 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -31,10 +31,48 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ NULL }
>  };
>  
> +#define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
> +				 riscv_isa_extension_mask(c) | \
> +				 riscv_isa_extension_mask(d) | \
> +				 riscv_isa_extension_mask(f) | \
> +				 riscv_isa_extension_mask(i) | \
> +				 riscv_isa_extension_mask(m) | \
> +				 riscv_isa_extension_mask(s) | \
> +				 riscv_isa_extension_mask(u))
> +
> +static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
> +	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> +	struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
> +
> +	memcpy(csr, reset_csr, sizeof(*csr));
> +
> +	memcpy(cntx, reset_cntx, sizeof(*cntx));
> +}
> +
>  struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
>  {
> -	/* TODO: */
> -	return NULL;
> +	int err;
> +	struct kvm_vcpu *vcpu;
> +
> +	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> +	if (!vcpu) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	err = kvm_vcpu_init(vcpu, kvm, id);
> +	if (err)
> +		goto free_vcpu;
> +
> +	return vcpu;
> +
> +free_vcpu:
> +	kmem_cache_free(kvm_vcpu_cache, vcpu);
> +out:
> +	return ERR_PTR(err);
>  }
>  
>  int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
> @@ -48,13 +86,32 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  
>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  {
> -	/* TODO: */
> +	struct kvm_cpu_context *cntx;
> +
> +	/* Mark this VCPU never ran */
> +	vcpu->arch.ran_atleast_once = false;
> +
> +	/* Setup ISA features available to VCPU */
> +	vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
> +
> +	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
> +	cntx = &vcpu->arch.guest_reset_context;
> +	cntx->sstatus = SR_SPP | SR_SPIE;
> +	cntx->hstatus = 0;
> +	cntx->hstatus |= HSTATUS_SP2V;
> +	cntx->hstatus |= HSTATUS_SP2P;
> +	cntx->hstatus |= HSTATUS_SPV;
> +
> +	/* Reset VCPU */
> +	kvm_riscv_reset_vcpu(vcpu);
> +
>  	return 0;
>  }
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> -	/* TODO: */
> +	kvm_riscv_stage2_flush_cache(vcpu);

There needs to be a comment as to why there's a flush here.

The definition of kvm_riscv_stage2_flush_cache() should also have a comment
describing what it actually does.

> +	kmem_cache_free(kvm_vcpu_cache, vcpu);
>  }
>  
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> @@ -199,6 +256,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	int ret;
>  	unsigned long scause, stval, htval, htinst;
>  
> +	/* Mark this VCPU ran atleast once */
> +	vcpu->arch.ran_atleast_once = true;

I'm having some trouble figuring out how this doesn't have a race condition,
but that's probably more applicable to the patch that uses it.  Also, a bit of
a nit pick: "at least" is two words.  I don't care that much about the variable
name, but the comments should use real words.

> +
>  	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>  
>  	/* Process MMIO value returned from user-space */
> -- 
> 2.17.1

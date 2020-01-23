Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA3E1460FD
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 04:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgAWDfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 22:35:03 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40724 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgAWDfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 22:35:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so1477277wrn.7
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 19:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8VB/kti/fUoeko/8qBTt1uUwHz9R7akb1/naXKY5Y1s=;
        b=NKd7GaMvnPzTIbtCz10Kch4dNW/4QeSPm2sUrjmZI3gqDPEFsIEuxwegQz6v2MwVob
         lit8Z44MPXDVIKDOAIJf68vPeNgmYFdtJMfKC5/j8ezegRRZ6XmdiiQOVtBpOqbSMHDh
         qH0X+9aOT6RecTaIyeofdeDL7hGLdWQB80TO5PJ3pgW/s+6mQoL56/rsV/S23NmF4Izi
         Gw2fDo1bDOwE/taNLeoO1Xt5c6IJLfoQA+BR9BNbxB3hiL86NcBX0CPD96yHXnqYtfp4
         CcqMn/K0Pr7q+ldofJs8fow6q26trng125YmA4ovJis80tv4GEkHyENZGUOY53e4OHX7
         fvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8VB/kti/fUoeko/8qBTt1uUwHz9R7akb1/naXKY5Y1s=;
        b=T0cuaBIKsHmSWryFG4P9I71zXhDRK5qDXCK7QqyaDI+1bzAl98YZT1xe9GTy3TqPTO
         y6EbMjWsAr/V2Lc1CbMKg+dAhTnONM8WVERJeMDGnADi01XC3HoGrzi8UVEbQn4zKuSM
         OR6xmKoaWX00Jg3SsuSsHUBPu2LA9duuNiSE4PiC36jEY2Tz3HQbp848S060Hr+YgOPI
         1ebsxVBiJtb79F2oKd4Uequpb3P9Uk8fIeqzXMmMm7bltJT623eiJ4gs1tbDhNLxq+ZB
         tK3syG4G8IlI3FoB+Q8duqSQbQl1tpUF38TGOWTv01NIOsWJL+SPWKqOQ30OboH95ZWu
         QtJg==
X-Gm-Message-State: APjAAAVksoDfKB032eOV9xx6F3qsYySNV5ECELCfM46cz1YWsnooFR1y
        nT2MXdQ0sZE13MACb4TnF9DXQToHGsEiW2leBd4aaA==
X-Google-Smtp-Source: APXvYqxKABLKoYwIQXsFCKEw9z64v4bXCODeazyZHBfwq8J4Mb6WqPz1BhXXNeJ5uYCgQjQeYwizlULhJ1phv4pOdfI=
X-Received: by 2002:a5d:50cf:: with SMTP id f15mr14021933wrt.381.1579750497394;
 Wed, 22 Jan 2020 19:34:57 -0800 (PST)
MIME-Version: 1.0
References: <20191223113443.68969-1-anup.patel@wdc.com> <20191223113443.68969-6-anup.patel@wdc.com>
 <mhng-0ada7fd5-2e39-48ff-80fd-32b91b96282f@palmerdabbelt-glaptop>
In-Reply-To: <mhng-0ada7fd5-2e39-48ff-80fd-32b91b96282f@palmerdabbelt-glaptop>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 23 Jan 2020 09:04:46 +0530
Message-ID: <CAAhSdy2OaNCwbpSbQy=-Q2hPiHZR7-QVxJyM6qraWiVdxvLK_g@mail.gmail.com>
Subject: Re: [PATCH v10 05/19] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>, Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 23, 2020 at 12:34 AM Palmer Dabbelt
<palmerdabbelt@google.com> wrote:
>
> On Mon, 23 Dec 2019 03:35:55 PST (-0800), Anup Patel wrote:
> > This patch implements VCPU create, init and destroy functions
> > required by generic KVM module. We don't have much dynamic
> > resources in struct kvm_vcpu_arch so these functions are quite
> > simple for KVM RISC-V.
> >
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Alexander Graf <graf@amazon.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h | 68 +++++++++++++++++++++++++++++++
> >  arch/riscv/kvm/vcpu.c             | 68 +++++++++++++++++++++++++++++--
> >  2 files changed, 132 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index e0b633f616a4..297431660be6 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -53,7 +53,75 @@ struct kvm_arch {
> >       phys_addr_t pgd_phys;
> >  };
> >
> > +struct kvm_cpu_context {
> > +     unsigned long zero;
> > +     unsigned long ra;
> > +     unsigned long sp;
> > +     unsigned long gp;
> > +     unsigned long tp;
> > +     unsigned long t0;
> > +     unsigned long t1;
> > +     unsigned long t2;
> > +     unsigned long s0;
> > +     unsigned long s1;
> > +     unsigned long a0;
> > +     unsigned long a1;
> > +     unsigned long a2;
> > +     unsigned long a3;
> > +     unsigned long a4;
> > +     unsigned long a5;
> > +     unsigned long a6;
> > +     unsigned long a7;
> > +     unsigned long s2;
> > +     unsigned long s3;
> > +     unsigned long s4;
> > +     unsigned long s5;
> > +     unsigned long s6;
> > +     unsigned long s7;
> > +     unsigned long s8;
> > +     unsigned long s9;
> > +     unsigned long s10;
> > +     unsigned long s11;
> > +     unsigned long t3;
> > +     unsigned long t4;
> > +     unsigned long t5;
> > +     unsigned long t6;
> > +     unsigned long sepc;
> > +     unsigned long sstatus;
> > +     unsigned long hstatus;
> > +};
>
> Looks like pretty much everyone else is putting 'struct kvm_regs' at the start
> of 'struct kvm_cpu_context', which I'm assuming avoids duplication when
> implementing KVM_{GET,SET}_REGS.  That would probably be cleaner, but if I
> think it'd be best to just have this match our mcontext.

The "struct kvm_cpu_context" is internal to KVM RISC-V whereas the
"struct kvm_vcpu_arch" is expected by core KVM

>
> > +
> > +struct kvm_vcpu_csr {
> > +     unsigned long vsstatus;
> > +     unsigned long hie;
> > +     unsigned long vstvec;
> > +     unsigned long vsscratch;
> > +     unsigned long vsepc;
> > +     unsigned long vscause;
> > +     unsigned long vstval;
> > +     unsigned long hip;
> > +     unsigned long vsatp;
> > +};
> > +
> >  struct kvm_vcpu_arch {
> > +     /* VCPU ran atleast once */
> > +     bool ran_atleast_once;
> > +
> > +     /* ISA feature bits (similar to MISA) */
> > +     unsigned long isa;
> > +
> > +     /* CPU context of Guest VCPU */
> > +     struct kvm_cpu_context guest_context;
> > +
> > +     /* CPU CSR context of Guest VCPU */
> > +     struct kvm_vcpu_csr guest_csr;
>
> It looks like other architectures either put the entire CPU state in 'struct
> kvm_cpu_context' (arm64, for example) or inline all the definitions (mips, for
> example).  I'd lean the arm64 way here, but I haven't gotten sufficiently far
> until the user ABI to figure out if this would help in a meaningful fashion.

It's an implementation choice. We don't need flow KVM ARM64.

In fact, having separate "struct kvm_cpu_context" and "struct kvm_vcpu_csr"
is much cleaner.

>
> > +     /* CPU context upon Guest VCPU reset */
> > +     struct kvm_cpu_context guest_reset_context;
> > +
> > +     /* CPU CSR context upon Guest VCPU reset */
> > +     struct kvm_vcpu_csr guest_reset_csr;
> > +
> >       /* Don't run the VCPU (blocked) */
> >       bool pause;
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index bd7d6b154f61..cf8ca8d4a9ea 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -31,10 +31,48 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
> >       { NULL }
> >  };
> >
> > +#define KVM_RISCV_ISA_ALLOWED        (riscv_isa_extension_mask(a) | \
> > +                              riscv_isa_extension_mask(c) | \
> > +                              riscv_isa_extension_mask(d) | \
> > +                              riscv_isa_extension_mask(f) | \
> > +                              riscv_isa_extension_mask(i) | \
> > +                              riscv_isa_extension_mask(m) | \
> > +                              riscv_isa_extension_mask(s) | \
> > +                              riscv_isa_extension_mask(u))
> > +
> > +static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> > +     struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
> > +     struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> > +     struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
> > +
> > +     memcpy(csr, reset_csr, sizeof(*csr));
> > +
> > +     memcpy(cntx, reset_cntx, sizeof(*cntx));
> > +}
> > +
> >  struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
> >  {
> > -     /* TODO: */
> > -     return NULL;
> > +     int err;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> > +     if (!vcpu) {
> > +             err = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     err = kvm_vcpu_init(vcpu, kvm, id);
> > +     if (err)
> > +             goto free_vcpu;
> > +
> > +     return vcpu;
> > +
> > +free_vcpu:
> > +     kmem_cache_free(kvm_vcpu_cache, vcpu);
> > +out:
> > +     return ERR_PTR(err);
> >  }
> >
> >  int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
> > @@ -48,13 +86,32 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> >
> >  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >  {
> > -     /* TODO: */
> > +     struct kvm_cpu_context *cntx;
> > +
> > +     /* Mark this VCPU never ran */
> > +     vcpu->arch.ran_atleast_once = false;
> > +
> > +     /* Setup ISA features available to VCPU */
> > +     vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
> > +
> > +     /* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
> > +     cntx = &vcpu->arch.guest_reset_context;
> > +     cntx->sstatus = SR_SPP | SR_SPIE;
> > +     cntx->hstatus = 0;
> > +     cntx->hstatus |= HSTATUS_SP2V;
> > +     cntx->hstatus |= HSTATUS_SP2P;
> > +     cntx->hstatus |= HSTATUS_SPV;
> > +
> > +     /* Reset VCPU */
> > +     kvm_riscv_reset_vcpu(vcpu);
> > +
> >       return 0;
> >  }
> >
> >  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  {
> > -     /* TODO: */
> > +     kvm_riscv_stage2_flush_cache(vcpu);
>
> There needs to be a comment as to why there's a flush here.
>
> The definition of kvm_riscv_stage2_flush_cache() should also have a comment
> describing what it actually does.

From the implementation its pretty obvious but I will add single line
comment anyway.

>
> > +     kmem_cache_free(kvm_vcpu_cache, vcpu);
> >  }
> >
> >  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> > @@ -199,6 +256,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >       int ret;
> >       unsigned long scause, stval, htval, htinst;
> >
> > +     /* Mark this VCPU ran atleast once */
> > +     vcpu->arch.ran_atleast_once = true;
>
> I'm having some trouble figuring out how this doesn't have a race condition,
> but that's probably more applicable to the patch that uses it.  Also, a bit of
> a nit pick: "at least" is two words.  I don't care that much about the variable
> name, but the comments should use real words.

This variable touched from a single thread only hence no need for protection.

I will fix the comment like you suggested.

>
> > +
> >       vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> >
> >       /* Process MMIO value returned from user-space */
> > --
> > 2.17.1

Regards,
Anup

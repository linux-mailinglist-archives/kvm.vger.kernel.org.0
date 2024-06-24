Return-Path: <kvm+bounces-20352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57937914045
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 03:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C502282148
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 01:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D86A4C97;
	Mon, 24 Jun 2024 01:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIeZa6bj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E144409;
	Mon, 24 Jun 2024 01:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719194329; cv=none; b=jW3GpLYZ4A9TVEUNXtN8QKANqXfHqJ+0Qr+hyVfoWwY2KHC0QbCzjGpaMAMMb5Wd/AwMXY7B7spOH+f3hltXoytrCukxDs23wGZzVy4cpxKgXuNr/cn4tRKdL9BJSNZcWHLLTOPWYXct+lpZuAA4vLoWIrDBEnyyTLyDIjEMz3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719194329; c=relaxed/simple;
	bh=Ym5dadeK/G+3Ievs8mviDvcTyTPI+T4SyShIjcqBiH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M0YvGPyYdH8PCDkp8IsV/AFgeb6nSv3FUUcY0ADzJMHZ6PmLBtQPyNcZ2+5TvHJMGmaOjHQZbrYzWQKuxrOuoKFoq9ncFVaH6EPVbWFdu16868N5ry6VF0/9j5gIUbnOH+lfdOAyKzlzmFk7+ixGrxO36t2JxnCQXxb2J8d2knk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIeZa6bj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52530C32786;
	Mon, 24 Jun 2024 01:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719194329;
	bh=Ym5dadeK/G+3Ievs8mviDvcTyTPI+T4SyShIjcqBiH4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VIeZa6bj+vTCEytaYnPn32QV4xBSHVW6OTBLV1a7wHvfQA40om440CPpj6zFZ+got
	 McGIfxhmpCIKBZUJIOWZHcvI0GLnHXFTpP4xdqpF3ulb5yNj8ipSnC+Nnlawg2Gjh7
	 8/VzNYty3svWTI+mFMMEQXaW8Zc0W8bH9nBYXYRjfLrXOMIQQFgDrfcQaGbdFp6N+v
	 VoaqlpJ1rfk9MbVVM1fO+u0JERkirgfhsqiq2KY3X+Ue83lYC61i6NEsw/aQ9yMnuR
	 8u1SdLgJzIbhAYfmKW+yP/SEW8+9EI8MB+8Phgrc4hd1wyLJDNTNfUHnbCfHSJp15c
	 P7mfhbSNH+OUQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a72510ebc3fso61642366b.2;
        Sun, 23 Jun 2024 18:58:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUkPA/0BAyUJ0HQoqoRjhl+NlXBUZbbCiAQT9nIxBxjdb2m0VZuXR8bBxk4KeOM5XRBt/BSGEl9niOGUkmGMl8tXwF386ddyH3bwSmcPLB+AmqhiWu/0AXkLS3ivFcN+/hu
X-Gm-Message-State: AOJu0YwE0lNbPqC/bx1YAJRzE1DTmJptwcjXmjNirzGifg84qOPxzQlM
	0Nf76YeeHMEUMdTx1S3DLwMw0pDi7hRM9K4zRpKuKYTs6dNK89DpUxZUCERvv35ba6U+0bvrkBr
	Mck548Din6vOOsiouh4pFubNQAqQ=
X-Google-Smtp-Source: AGHT+IEuPjW79aIwhy9fhK2HSNCoRDcHWPKk6rPKq6995J/Un/dVryD18DRz1KCCZtK9g1jF2VyRtbaC8h3onjwcSoo=
X-Received: by 2002:a17:906:9814:b0:a70:c038:ed01 with SMTP id
 a640c23a62f3a-a7242c39c54mr241857466b.27.1719194327844; Sun, 23 Jun 2024
 18:58:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619080940.2690756-1-maobibo@loongson.cn> <20240619080940.2690756-2-maobibo@loongson.cn>
 <CAAhV-H7zF7zDZQ0tHtZndTmWDteaV=nAwXL3Q1P2zcJssVt7tA@mail.gmail.com> <5df4d756-d261-2629-a938-c9bfdb9d2534@loongson.cn>
In-Reply-To: <5df4d756-d261-2629-a938-c9bfdb9d2534@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Jun 2024 09:58:37 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7m7b-yQLOCo9B0mGkBLMp9Xfpe6evJs33pmWvKykDKqw@mail.gmail.com>
Message-ID: <CAAhV-H7m7b-yQLOCo9B0mGkBLMp9Xfpe6evJs33pmWvKykDKqw@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] LoongArch: KVM: Delay secondary mmu tlb flush
 until guest entry
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 9:23=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/6/23 =E4=B8=8B=E5=8D=883:54, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Wed, Jun 19, 2024 at 4:09=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> If there is page fault for secondary mmu, there needs tlb flush
> > What does "secondary mmu" in this context mean? Maybe "guest mmu"?
> "secondary mmu" following x86 concepts, the weblink is:
>     https://lwn.net/Articles/977945/
>
> It is called stage-2 mmu on ARM64 also. "guest mmu" cannot represent
> whether it is gva to gpa, or gpa to hpa, or gva to hpa directly.
Then it is better to explain "what is secondary mmu" in the commit
message when it appears at the first time.

Huacai

>
> Regards
> Bibo Mao
>
> >
> > Huacai
> >
> >> operation indexed with fault gpa address and VMID. VMID is stored
> >> at register CSR_GSTAT and will be reload or recalculated during
> >> guest entry.
> >>
> >> Currently CSR_GSTAT is not saved and restored during vcpu context
> >> switch, it is recalculated during guest entry. So CSR_GSTAT is in
> >> effect only when vcpu runs in guest mode, however it may be not in
> >> effected if vcpu exits to host mode, since register CSR_GSTAT may
> >> be stale, it maybe records VMID of last scheduled vcpu, rather than
> >> current vcpu.
> >>
> >> Function kvm_flush_tlb_gpa() should be called with its real VMID,
> >> here move it to guest entrance. Also arch specific request id
> >> KVM_REQ_TLB_FLUSH_GPA is added to flush tlb, and it can be optimized
> >> if VMID is updated, since all guest tlb entries will be invalid if
> >> VMID is updated.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/kvm_host.h |  2 ++
> >>   arch/loongarch/kvm/main.c             |  1 +
> >>   arch/loongarch/kvm/mmu.c              |  4 ++--
> >>   arch/loongarch/kvm/tlb.c              |  5 +----
> >>   arch/loongarch/kvm/vcpu.c             | 18 ++++++++++++++++++
> >>   5 files changed, 24 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/in=
clude/asm/kvm_host.h
> >> index c87b6ea0ec47..32c4948f534f 100644
> >> --- a/arch/loongarch/include/asm/kvm_host.h
> >> +++ b/arch/loongarch/include/asm/kvm_host.h
> >> @@ -30,6 +30,7 @@
> >>   #define KVM_PRIVATE_MEM_SLOTS          0
> >>
> >>   #define KVM_HALT_POLL_NS_DEFAULT       500000
> >> +#define KVM_REQ_TLB_FLUSH_GPA          KVM_ARCH_REQ(0)
> >>
> >>   #define KVM_GUESTDBG_SW_BP_MASK                \
> >>          (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> >> @@ -190,6 +191,7 @@ struct kvm_vcpu_arch {
> >>
> >>          /* vcpu's vpid */
> >>          u64 vpid;
> >> +       gpa_t flush_gpa;
> >>
> >>          /* Frequency of stable timer in Hz */
> >>          u64 timer_mhz;
> >> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> >> index 86a2f2d0cb27..844736b99d38 100644
> >> --- a/arch/loongarch/kvm/main.c
> >> +++ b/arch/loongarch/kvm/main.c
> >> @@ -242,6 +242,7 @@ void kvm_check_vpid(struct kvm_vcpu *vcpu)
> >>                  kvm_update_vpid(vcpu, cpu);
> >>                  trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
> >>                  vcpu->cpu =3D cpu;
> >> +               kvm_clear_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
> >>          }
> >>
> >>          /* Restore GSTAT(0x50).vpid */
> >> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> >> index 98883aa23ab8..9e39d28fec35 100644
> >> --- a/arch/loongarch/kvm/mmu.c
> >> +++ b/arch/loongarch/kvm/mmu.c
> >> @@ -908,8 +908,8 @@ int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, uns=
igned long gpa, bool write)
> >>                  return ret;
> >>
> >>          /* Invalidate this entry in the TLB */
> >> -       kvm_flush_tlb_gpa(vcpu, gpa);
> >> -
> >> +       vcpu->arch.flush_gpa =3D gpa;
> >> +       kvm_make_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
> >>          return 0;
> >>   }
> >>
> >> diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
> >> index 02535df6b51f..ebdbe9264e9c 100644
> >> --- a/arch/loongarch/kvm/tlb.c
> >> +++ b/arch/loongarch/kvm/tlb.c
> >> @@ -23,10 +23,7 @@ void kvm_flush_tlb_all(void)
> >>
> >>   void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
> >>   {
> >> -       unsigned long flags;
> >> -
> >> -       local_irq_save(flags);
> >> +       lockdep_assert_irqs_disabled();
> >>          gpa &=3D (PAGE_MASK << 1);
> >>          invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa=
);
> >> -       local_irq_restore(flags);
> >>   }
> >> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >> index 9e8030d45129..b747bd8bc037 100644
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -51,6 +51,16 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu=
)
> >>          return RESUME_GUEST;
> >>   }
> >>
> >> +static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
> >> +{
> >> +       lockdep_assert_irqs_disabled();
> >> +       if (kvm_check_request(KVM_REQ_TLB_FLUSH_GPA, vcpu))
> >> +               if (vcpu->arch.flush_gpa !=3D INVALID_GPA) {
> >> +                       kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
> >> +                       vcpu->arch.flush_gpa =3D INVALID_GPA;
> >> +               }
> >> +}
> >> +
> >>   /*
> >>    * Check and handle pending signal and vCPU requests etc
> >>    * Run with irq enabled and preempt enabled
> >> @@ -101,6 +111,13 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *v=
cpu)
> >>                  /* Make sure the vcpu mode has been written */
> >>                  smp_store_mb(vcpu->mode, IN_GUEST_MODE);
> >>                  kvm_check_vpid(vcpu);
> >> +
> >> +               /*
> >> +                * Called after function kvm_check_vpid()
> >> +                * Since it updates csr_gstat used by kvm_flush_tlb_gp=
a(),
> >> +                * also it may clear KVM_REQ_TLB_FLUSH_GPA pending bit
> >> +                */
> >> +               kvm_late_check_requests(vcpu);
> >>                  vcpu->arch.host_eentry =3D csr_read64(LOONGARCH_CSR_E=
ENTRY);
> >>                  /* Clear KVM_LARCH_SWCSR_LATEST as CSR will change wh=
en enter guest */
> >>                  vcpu->arch.aux_inuse &=3D ~KVM_LARCH_SWCSR_LATEST;
> >> @@ -994,6 +1011,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >>          struct loongarch_csrs *csr;
> >>
> >>          vcpu->arch.vpid =3D 0;
> >> +       vcpu->arch.flush_gpa =3D INVALID_GPA;
> >>
> >>          hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MO=
DE_ABS_PINNED);
> >>          vcpu->arch.swtimer.function =3D kvm_swtimer_wakeup;
> >> --
> >> 2.39.3
> >>
>
>


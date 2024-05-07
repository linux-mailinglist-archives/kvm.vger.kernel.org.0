Return-Path: <kvm+bounces-16777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DA328BD94B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 04:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5337F284061
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 02:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0755228;
	Tue,  7 May 2024 02:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEOqBwYe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90678139F;
	Tue,  7 May 2024 02:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047571; cv=none; b=bH2MYqD+MNKTUTRGH7AksF2IF6mEC8j+PnrpL/MppCyYKxUHG1w3v2W9pCiipVHP6mZm3yQl0uqM/pV8CoDSaElM/roz6LyUGAt5wGZWNcqyKOqfmpqpZMuU216LZhWnzXqnsiTNIhza4wq4xa8jRaf8J1AZgd2uJoyeV0o20lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047571; c=relaxed/simple;
	bh=8iHTmb9VgE5jmJWE4hY5qzuKhGc1EcWsdCuEgTy1hEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qq6/0DnOL7mh/a97R3fo9VTUfVrMo+WVzDNahzr+n7gkxzI1dcWMehSiz1HtPUB4Pfw4cPiJhmOYwYIatVyYa59kjhO4d/AiWpfLqtTagpNqu+iKj7vKQc34R33r9nt7xBqVewxurV0JcrmzRhSK/DKwOPmN+41N+IctFh0q0Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEOqBwYe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23484C4AF67;
	Tue,  7 May 2024 02:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715047571;
	bh=8iHTmb9VgE5jmJWE4hY5qzuKhGc1EcWsdCuEgTy1hEA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NEOqBwYeqAAem2uk2ZdaXFNs/omq5+8ej8VhBtzvMB5dEf13Awx5/8tCq4QYRcvyR
	 yKtMOYJ8O5XsaVdUXYTTPS7Rf4MNkwnrYYws4sQBXcKRkscuWgTDJNVJrxl6P8vgsj
	 Y04LHwkDsvaXNz8agW3SE9NHDsqxtkSqB4AZvu7dujusDXyA0TGL2J1r7klgdy/0vc
	 yHWbhnk7jfyVwavlIdwqK7XmI70Ks25n95a7xHLHueW0aEP1IAPwkH5Abm9cetYgrP
	 0BLyz60buMVxne/b+h+oUe3CsTn2bIkl0rvcuvQcOWxOSBVBuvNHSlXuKCiIK8RDFH
	 3sCBWWeIn+v4g==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a59c0a6415fso515762566b.1;
        Mon, 06 May 2024 19:06:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXC2Ac15C0W3ltdOqrepyIffswQv021CCEMLfGTiHLIt2TzRKJ9FjNxhV0W3isDx09T/8pVKkKoNQxrQJajbZpbkRRptc3LhQz7Lk0likTzXb16uCzHeBFNSFpdXWD6Ntez
X-Gm-Message-State: AOJu0YzKNh+6U+6awQ08x/0OH1MJvexPI3o1Rp7OkP3u9vsO7kiUqlUC
	NmHrHIX/gpStJBFuyHo2z68qCFbtjXPVL3rdGVFIS5JRiWxx2CGpSqHtQnuuAPtjPh8iLx6/r25
	owObZ2vix/b8n6ogBiNRq101ivlw=
X-Google-Smtp-Source: AGHT+IEFjX3jGF9ey5LQCdka7emdknvXqArs24mMzgfIpLPQEjSIglWWf8tzG/XOVUPWcwL8NIN6F1Gk2dBgLe45FhU=
X-Received: by 2002:a17:907:da9:b0:a59:c9ad:bd23 with SMTP id
 go41-20020a1709070da900b00a59c9adbd23mr3661378ejc.6.1715047569555; Mon, 06
 May 2024 19:06:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240428100518.1642324-1-maobibo@loongson.cn> <20240428100518.1642324-5-maobibo@loongson.cn>
 <CAAhV-H6kBO_RTTHoLfKdAtLO1Aqb0KmAJ6wn0wZrvbCkzMszDQ@mail.gmail.com>
 <7335dcde-1b3a-1260-ac62-d2d9fcbd6a78@loongson.cn> <CAAhV-H5WJ0o3bJZBq2zx7ejjFkFwYVTyVJEzJuAHEs+uMg-sxw@mail.gmail.com>
 <b10b46ce-8219-8863-470f-9bfa173b22b0@loongson.cn> <CAAhV-H7fbrOXTtSwBmR3kyTW7yhsifycjynky4HPrUJiS9s=cg@mail.gmail.com>
 <540aa8dd-eada-1f77-0a20-38196fb5472a@loongson.cn> <CAAhV-H7o3oG2KXc2Ou0aWXTLPSNiM3evSB5Z-5dH4bLRd_P_0Q@mail.gmail.com>
 <61670353-90c6-6d0c-4430-7655b5251e17@loongson.cn> <CAAhV-H5wNmgxGincGE7cJ8WvrpKFauAJvMHrPttW-LrKB4UeHg@mail.gmail.com>
 <a6d49710-1580-809d-5dcf-ea4207257ae7@loongson.cn>
In-Reply-To: <a6d49710-1580-809d-5dcf-ea4207257ae7@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 7 May 2024 10:05:59 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4ir++y+46-g43-9bLvY8cv79fB6bKbWgkhDzDV7QQg9g@mail.gmail.com>
Message-ID: <CAAhV-H4ir++y+46-g43-9bLvY8cv79fB6bKbWgkhDzDV7QQg9g@mail.gmail.com>
Subject: Re: [PATCH v8 4/6] LoongArch: KVM: Add vcpu search support from
 physical cpuid
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 7, 2024 at 9:40=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/5/6 =E4=B8=8B=E5=8D=8810:17, Huacai Chen wrote:
> > On Mon, May 6, 2024 at 6:05=E2=80=AFPM maobibo <maobibo@loongson.cn> wr=
ote:
> >>
> >>
> >>
> >> On 2024/5/6 =E4=B8=8B=E5=8D=885:40, Huacai Chen wrote:
> >>> On Mon, May 6, 2024 at 5:35=E2=80=AFPM maobibo <maobibo@loongson.cn> =
wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2024/5/6 =E4=B8=8B=E5=8D=884:59, Huacai Chen wrote:
> >>>>> On Mon, May 6, 2024 at 4:18=E2=80=AFPM maobibo <maobibo@loongson.cn=
> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2024/5/6 =E4=B8=8B=E5=8D=883:06, Huacai Chen wrote:
> >>>>>>> Hi, Bibo,
> >>>>>>>
> >>>>>>> On Mon, May 6, 2024 at 2:36=E2=80=AFPM maobibo <maobibo@loongson.=
cn> wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> On 2024/5/6 =E4=B8=8A=E5=8D=889:49, Huacai Chen wrote:
> >>>>>>>>> Hi, Bibo,
> >>>>>>>>>
> >>>>>>>>> On Sun, Apr 28, 2024 at 6:05=E2=80=AFPM Bibo Mao <maobibo@loong=
son.cn> wrote:
> >>>>>>>>>>
> >>>>>>>>>> Physical cpuid is used for interrupt routing for irqchips such=
 as
> >>>>>>>>>> ipi/msi/extioi interrupt controller. And physical cpuid is sto=
red
> >>>>>>>>>> at CSR register LOONGARCH_CSR_CPUID, it can not be changed onc=
e vcpu
> >>>>>>>>>> is created and physical cpuid of two vcpus cannot be the same.
> >>>>>>>>>>
> >>>>>>>>>> Different irqchips have different size declaration about physi=
cal cpuid,
> >>>>>>>>>> max cpuid value for CSR LOONGARCH_CSR_CPUID on 3A5000 is 512, =
max cpuid
> >>>>>>>>>> supported by IPI hardware is 1024, 256 for extioi irqchip, and=
 65536
> >>>>>>>>>> for MSI irqchip.
> >>>>>>>>>>
> >>>>>>>>>> The smallest value from all interrupt controllers is selected =
now,
> >>>>>>>>>> and the max cpuid size is defines as 256 by KVM which comes fr=
om
> >>>>>>>>>> extioi irqchip.
> >>>>>>>>>>
> >>>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>>>>>>>> ---
> >>>>>>>>>>       arch/loongarch/include/asm/kvm_host.h | 26 ++++++++
> >>>>>>>>>>       arch/loongarch/include/asm/kvm_vcpu.h |  1 +
> >>>>>>>>>>       arch/loongarch/kvm/vcpu.c             | 93 +++++++++++++=
+++++++++++++-
> >>>>>>>>>>       arch/loongarch/kvm/vm.c               | 11 ++++
> >>>>>>>>>>       4 files changed, 130 insertions(+), 1 deletion(-)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loon=
garch/include/asm/kvm_host.h
> >>>>>>>>>> index 2d62f7b0d377..3ba16ef1fe69 100644
> >>>>>>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>>>>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>>>>>>>> @@ -64,6 +64,30 @@ struct kvm_world_switch {
> >>>>>>>>>>
> >>>>>>>>>>       #define MAX_PGTABLE_LEVELS     4
> >>>>>>>>>>
> >>>>>>>>>> +/*
> >>>>>>>>>> + * Physical cpu id is used for interrupt routing, there are d=
ifferent
> >>>>>>>>>> + * definitions about physical cpuid on different hardwares.
> >>>>>>>>>> + *  For LOONGARCH_CSR_CPUID register, max cpuid size if 512
> >>>>>>>>>> + *  For IPI HW, max dest CPUID size 1024
> >>>>>>>>>> + *  For extioi interrupt controller, max dest CPUID size is 2=
56
> >>>>>>>>>> + *  For MSI interrupt controller, max supported CPUID size is=
 65536
> >>>>>>>>>> + *
> >>>>>>>>>> + * Currently max CPUID is defined as 256 for KVM hypervisor, =
in future
> >>>>>>>>>> + * it will be expanded to 4096, including 16 packages at most=
. And every
> >>>>>>>>>> + * package supports at most 256 vcpus
> >>>>>>>>>> + */
> >>>>>>>>>> +#define KVM_MAX_PHYID          256
> >>>>>>>>>> +
> >>>>>>>>>> +struct kvm_phyid_info {
> >>>>>>>>>> +       struct kvm_vcpu *vcpu;
> >>>>>>>>>> +       bool            enabled;
> >>>>>>>>>> +};
> >>>>>>>>>> +
> >>>>>>>>>> +struct kvm_phyid_map {
> >>>>>>>>>> +       int max_phyid;
> >>>>>>>>>> +       struct kvm_phyid_info phys_map[KVM_MAX_PHYID];
> >>>>>>>>>> +};
> >>>>>>>>>> +
> >>>>>>>>>>       struct kvm_arch {
> >>>>>>>>>>              /* Guest physical mm */
> >>>>>>>>>>              kvm_pte_t *pgd;
> >>>>>>>>>> @@ -71,6 +95,8 @@ struct kvm_arch {
> >>>>>>>>>>              unsigned long invalid_ptes[MAX_PGTABLE_LEVELS];
> >>>>>>>>>>              unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
> >>>>>>>>>>              unsigned int  root_level;
> >>>>>>>>>> +       spinlock_t    phyid_map_lock;
> >>>>>>>>>> +       struct kvm_phyid_map  *phyid_map;
> >>>>>>>>>>
> >>>>>>>>>>              s64 time_offset;
> >>>>>>>>>>              struct kvm_context __percpu *vmcs;
> >>>>>>>>>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loon=
garch/include/asm/kvm_vcpu.h
> >>>>>>>>>> index 0cb4fdb8a9b5..9f53950959da 100644
> >>>>>>>>>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> >>>>>>>>>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> >>>>>>>>>> @@ -81,6 +81,7 @@ void kvm_save_timer(struct kvm_vcpu *vcpu);
> >>>>>>>>>>       void kvm_restore_timer(struct kvm_vcpu *vcpu);
> >>>>>>>>>>
> >>>>>>>>>>       int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, stru=
ct kvm_interrupt *irq);
> >>>>>>>>>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int c=
puid);
> >>>>>>>>>>
> >>>>>>>>>>       /*
> >>>>>>>>>>        * Loongarch KVM guest interrupt handling
> >>>>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vc=
pu.c
> >>>>>>>>>> index 3a8779065f73..b633fd28b8db 100644
> >>>>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>>>>>>>> @@ -274,6 +274,95 @@ static int _kvm_getcsr(struct kvm_vcpu *v=
cpu, unsigned int id, u64 *val)
> >>>>>>>>>>              return 0;
> >>>>>>>>>>       }
> >>>>>>>>>>
> >>>>>>>>>> +static inline int kvm_set_cpuid(struct kvm_vcpu *vcpu, u64 va=
l)
> >>>>>>>>>> +{
> >>>>>>>>>> +       int cpuid;
> >>>>>>>>>> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> >>>>>>>>>> +       struct kvm_phyid_map  *map;
> >>>>>>>>>> +
> >>>>>>>>>> +       if (val >=3D KVM_MAX_PHYID)
> >>>>>>>>>> +               return -EINVAL;
> >>>>>>>>>> +
> >>>>>>>>>> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> >>>>>>>>>> +       map =3D vcpu->kvm->arch.phyid_map;
> >>>>>>>>>> +       spin_lock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>>>>>>> +       if (map->phys_map[cpuid].enabled) {
> >>>>>>>>>> +               /*
> >>>>>>>>>> +                * Cpuid is already set before
> >>>>>>>>>> +                * Forbid changing different cpuid at runtime
> >>>>>>>>>> +                */
> >>>>>>>>>> +               if (cpuid !=3D val) {
> >>>>>>>>>> +                       /*
> >>>>>>>>>> +                        * Cpuid 0 is initial value for vcpu, =
maybe invalid
> >>>>>>>>>> +                        * unset value for vcpu
> >>>>>>>>>> +                        */
> >>>>>>>>>> +                       if (cpuid) {
> >>>>>>>>>> +                               spin_unlock(&vcpu->kvm->arch.p=
hyid_map_lock);
> >>>>>>>>>> +                               return -EINVAL;
> >>>>>>>>>> +                       }
> >>>>>>>>>> +               } else {
> >>>>>>>>>> +                        /* Discard duplicated cpuid set */
> >>>>>>>>>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map=
_lock);
> >>>>>>>>>> +                       return 0;
> >>>>>>>>>> +               }
> >>>>>>>>>> +       }
> >>>>>>>>> I have changed the logic and comments when I apply, you can dou=
ble
> >>>>>>>>> check whether it is correct.
> >>>>>>>> I checkout the latest version, the modification in function
> >>>>>>>> kvm_set_cpuid() is good for me.
> >>>>>>> Now the modified version is like this:
> >>>>>>>
> >>>>>>> + if (map->phys_map[cpuid].enabled) {
> >>>>>>> + /* Discard duplicated CPUID set operation */
> >>>>>>> + if (cpuid =3D=3D val) {
> >>>>>>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>>>> + return 0;
> >>>>>>> + }
> >>>>>>> +
> >>>>>>> + /*
> >>>>>>> + * CPUID is already set before
> >>>>>>> + * Forbid changing different CPUID at runtime
> >>>>>>> + * But CPUID 0 is the initial value for vcpu, so allow
> >>>>>>> + * changing from 0 to others
> >>>>>>> + */
> >>>>>>> + if (cpuid) {
> >>>>>>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>>>> + return -EINVAL;
> >>>>>>> + }
> >>>>>>> + }
> >>>>>>> But I still doubt whether we should allow changing from 0 to othe=
rs
> >>>>>>> while map->phys_map[cpuid].enabled is 1.
> >>>>>> It is necessary since the default sw cpuid is zero :-( And we can
> >>>>>> optimize it in later, such as set INVALID cpuid in function
> >>>>>> kvm_arch_vcpu_create() and logic will be simple in function kvm_se=
t_cpuid().
> >>>>> In my opinion, if a vcpu with a uninitialized default physid=3D0, t=
hen
> >>>>> map->phys_map[cpuid].enabled should be 0, then code won't come here=
.
> >>>>> And if a vcpu with a real physid=3D0, then map->phys_map[cpuid].ena=
bled
> >>>>> is 1, but we shouldn't allow it to change physid in this case.
> >>>> yes, that is actually a problem.
> >>>>
> >>>> vcpu0 firstly set physid=3D0, and vcpu0 set physid=3D1 again is not =
allowed.
> >>>> vcpu0 firstly set physid=3D0, and vcpu1 set physid=3D1 is allowed.
> >>>
> >>> So can we simply drop the if (cpuid) checking? That means:
> >>> + if (map->phys_map[cpuid].enabled) {
> >>> + /* Discard duplicated CPUID set operation */
> >>> + if (cpuid =3D=3D val) {
> >>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>> + return 0;
> >>> + }
> >>> +
> >>> + spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>> + return -EINVAL;
> >>> + }
> >> yes, the similar modification such as following, since the secondary
> >> scenario should be allowed.
> >>    "vcpu0 firstly set physid=3D0, and vcpu1 set physid=3D1 is allowed =
though
> >> default sw cpuid is zero"
> >>
> >> --- a/arch/loongarch/kvm/vcpu.c
> >> +++ b/arch/loongarch/kvm/vcpu.c
> >> @@ -272,7 +272,7 @@ static inline int kvm_set_cpuid(struct kvm_vcpu
> >> *vcpu, u64 val)
> >>           cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_CPUID);
> >>
> >>           spin_lock(&vcpu->kvm->arch.phyid_map_lock);
> >> -       if (map->phys_map[cpuid].enabled) {
> >> +       if ((cpuid !=3D KVM_MAX_PHYID) && map->phys_map[cpuid].enabled=
) {
> >>                   /* Discard duplicated CPUID set operation */
> >>                   if (cpuid =3D=3D val) {
> >>                           spin_unlock(&vcpu->kvm->arch.phyid_map_lock)=
;
> >> @@ -282,13 +282,9 @@ static inline int kvm_set_cpuid(struct kvm_vcpu
> >> *vcpu, u64 val)
> >>                   /*
> >>                    * CPUID is already set before
> >>                    * Forbid changing different CPUID at runtime
> >> -                * But CPUID 0 is the initial value for vcpu, so allow
> >> -                * changing from 0 to others
> >>                    */
> >> -               if (cpuid) {
> >> -                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >> -                       return -EINVAL;
> >> -               }
> >> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >> +               return -EINVAL;
> >>           }
> >>
> >>           if (map->phys_map[val].enabled) {
> >> @@ -1029,6 +1025,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >>
> >>           /* Set cpuid */
> >>           kvm_write_sw_gcsr(csr, LOONGARCH_CSR_TMID, vcpu->vcpu_id);
> >> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, KVM_MAX_PHYID);
> >>
> >>           /* Start with no pending virtual guest interrupts */
> >>           csr->csrs[LOONGARCH_CSR_GINTC] =3D 0;
> > Very nice, but I think kvm_drop_cpuid() should also set to KVM_MAX_PHYI=
D.
> > Now I update my loongarch-kvm branch, you can test it again, and hope
> > it is in the perfect status.
> I sync and test the latest code from loongarch-kvm, pv ipi works well
> with 256 vcpus. And the code looks good to me, thanks for your review in
> short time.
OK, if SWDBG also works well, I will send PR to Paolo tomorrow.

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >>
> >>
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>>
> >>>>>
> >>>>> Huacai
> >>>>>
> >>>>>>
> >>>>>> Regards
> >>>>>> Bibo Mao
> >>>>>>
> >>>>>>>
> >>>>>>> Huacai
> >>>>>>>
> >>>>>>>>>
> >>>>>>>>>> +
> >>>>>>>>>> +       if (map->phys_map[val].enabled) {
> >>>>>>>>>> +               /*
> >>>>>>>>>> +                * New cpuid is already set with other vcpu
> >>>>>>>>>> +                * Forbid sharing the same cpuid between diffe=
rent vcpus
> >>>>>>>>>> +                */
> >>>>>>>>>> +               if (map->phys_map[val].vcpu !=3D vcpu) {
> >>>>>>>>>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map=
_lock);
> >>>>>>>>>> +                       return -EINVAL;
> >>>>>>>>>> +               }
> >>>>>>>>>> +
> >>>>>>>>>> +               /* Discard duplicated cpuid set operation*/
> >>>>>>>>>> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>>>>>>> +               return 0;
> >>>>>>>>>> +       }
> >>>>>>>>>> +
> >>>>>>>>>> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, val);
> >>>>>>>>>> +       map->phys_map[val].enabled      =3D true;
> >>>>>>>>>> +       map->phys_map[val].vcpu         =3D vcpu;
> >>>>>>>>>> +       if (map->max_phyid < val)
> >>>>>>>>>> +               map->max_phyid =3D val;
> >>>>>>>>>> +       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
> >>>>>>>>>> +       return 0;
> >>>>>>>>>> +}
> >>>>>>>>>> +
> >>>>>>>>>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int c=
puid)
> >>>>>>>>>> +{
> >>>>>>>>>> +       struct kvm_phyid_map  *map;
> >>>>>>>>>> +
> >>>>>>>>>> +       if (cpuid >=3D KVM_MAX_PHYID)
> >>>>>>>>>> +               return NULL;
> >>>>>>>>>> +
> >>>>>>>>>> +       map =3D kvm->arch.phyid_map;
> >>>>>>>>>> +       if (map->phys_map[cpuid].enabled)
> >>>>>>>>>> +               return map->phys_map[cpuid].vcpu;
> >>>>>>>>>> +
> >>>>>>>>>> +       return NULL;
> >>>>>>>>>> +}
> >>>>>>>>>> +
> >>>>>>>>>> +static inline void kvm_drop_cpuid(struct kvm_vcpu *vcpu)
> >>>>>>>>>> +{
> >>>>>>>>>> +       int cpuid;
> >>>>>>>>>> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> >>>>>>>>>> +       struct kvm_phyid_map  *map;
> >>>>>>>>>> +
> >>>>>>>>>> +       map =3D vcpu->kvm->arch.phyid_map;
> >>>>>>>>>> +       cpuid =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
> >>>>>>>>>> +       if (cpuid >=3D KVM_MAX_PHYID)
> >>>>>>>>>> +               return;
> >>>>>>>>>> +
> >>>>>>>>>> +       if (map->phys_map[cpuid].enabled) {
> >>>>>>>>>> +               map->phys_map[cpuid].vcpu =3D NULL;
> >>>>>>>>>> +               map->phys_map[cpuid].enabled =3D false;
> >>>>>>>>>> +               kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, 0)=
;
> >>>>>>>>>> +       }
> >>>>>>>>>> +}
> >>>>>>>>> While kvm_set_cpuid() is protected by a spinlock, do kvm_drop_c=
puid()
> >>>>>>>>> and kvm_get_vcpu_by_cpuid() also need it?
> >>>>>>>>>
> >>>>>>>> It is good to me that spinlock is added in function kvm_drop_cpu=
id().
> >>>>>>>> And thinks for the efforts.
> >>>>>>>>
> >>>>>>>> Regards
> >>>>>>>> Bibo Mao
> >>>>>>>>>> +
> >>>>>>>>>>       static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned i=
nt id, u64 val)
> >>>>>>>>>>       {
> >>>>>>>>>>              int ret =3D 0, gintc;
> >>>>>>>>>> @@ -291,7 +380,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vc=
pu, unsigned int id, u64 val)
> >>>>>>>>>>                      kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT,=
 gintc);
> >>>>>>>>>>
> >>>>>>>>>>                      return ret;
> >>>>>>>>>> -       }
> >>>>>>>>>> +       } else if (id =3D=3D LOONGARCH_CSR_CPUID)
> >>>>>>>>>> +               return kvm_set_cpuid(vcpu, val);
> >>>>>>>>>>
> >>>>>>>>>>              kvm_write_sw_gcsr(csr, id, val);
> >>>>>>>>>>
> >>>>>>>>>> @@ -943,6 +1033,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcp=
u *vcpu)
> >>>>>>>>>>              hrtimer_cancel(&vcpu->arch.swtimer);
> >>>>>>>>>>              kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_ca=
che);
> >>>>>>>>>>              kfree(vcpu->arch.csr);
> >>>>>>>>>> +       kvm_drop_cpuid(vcpu);
> >>>>>>>>> I think this line should be before the above kfree(), otherwise=
 you
> >>>>>>>>> get a "use after free".
> >>>>>>>>>
> >>>>>>>>> Huacai
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>>              /*
> >>>>>>>>>>               * If the vCPU is freed and reused as another vCP=
U, we don't want the
> >>>>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >>>>>>>>>> index 0a37f6fa8f2d..6006a28653ad 100644
> >>>>>>>>>> --- a/arch/loongarch/kvm/vm.c
> >>>>>>>>>> +++ b/arch/loongarch/kvm/vm.c
> >>>>>>>>>> @@ -30,6 +30,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsig=
ned long type)
> >>>>>>>>>>              if (!kvm->arch.pgd)
> >>>>>>>>>>                      return -ENOMEM;
> >>>>>>>>>>
> >>>>>>>>>> +       kvm->arch.phyid_map =3D kvzalloc(sizeof(struct kvm_phy=
id_map),
> >>>>>>>>>> +                               GFP_KERNEL_ACCOUNT);
> >>>>>>>>>> +       if (!kvm->arch.phyid_map) {
> >>>>>>>>>> +               free_page((unsigned long)kvm->arch.pgd);
> >>>>>>>>>> +               kvm->arch.pgd =3D NULL;
> >>>>>>>>>> +               return -ENOMEM;
> >>>>>>>>>> +       }
> >>>>>>>>>> +
> >>>>>>>>>>              kvm_init_vmcs(kvm);
> >>>>>>>>>>              kvm->arch.gpa_size =3D BIT(cpu_vabits - 1);
> >>>>>>>>>>              kvm->arch.root_level =3D CONFIG_PGTABLE_LEVELS - =
1;
> >>>>>>>>>> @@ -44,6 +52,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsign=
ed long type)
> >>>>>>>>>>              for (i =3D 0; i <=3D kvm->arch.root_level; i++)
> >>>>>>>>>>                      kvm->arch.pte_shifts[i] =3D PAGE_SHIFT + =
i * (PAGE_SHIFT - 3);
> >>>>>>>>>>
> >>>>>>>>>> +       spin_lock_init(&kvm->arch.phyid_map_lock);
> >>>>>>>>>>              return 0;
> >>>>>>>>>>       }
> >>>>>>>>>>
> >>>>>>>>>> @@ -51,7 +60,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >>>>>>>>>>       {
> >>>>>>>>>>              kvm_destroy_vcpus(kvm);
> >>>>>>>>>>              free_page((unsigned long)kvm->arch.pgd);
> >>>>>>>>>> +       kvfree(kvm->arch.phyid_map);
> >>>>>>>>>>              kvm->arch.pgd =3D NULL;
> >>>>>>>>>> +       kvm->arch.phyid_map =3D NULL;
> >>>>>>>>>>       }
> >>>>>>>>>>
> >>>>>>>>>>       int kvm_vm_ioctl_check_extension(struct kvm *kvm, long e=
xt)
> >>>>>>>>>> --
> >>>>>>>>>> 2.39.3
> >>>>>>>>>>
> >>>>>>>>
> >>>>>>
> >>>>
> >>
>
>


Return-Path: <kvm+bounces-9068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 824A7859FD6
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07D361F21787
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A6524A06;
	Mon, 19 Feb 2024 09:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVSnOFwx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755FC2560B;
	Mon, 19 Feb 2024 09:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708335531; cv=none; b=NZJYtzsri3Ae+J1xxvcJgd0CUtCh4RfFQ6P2/9HFeLbRXJe4NZa/8YYwX8dchQSQsjs7n2UTBcJpLHrt8EkNx6gklsS9VRR4GSValEgrJlpxSQ5X3g4SXq3I5huYHj77kA7k46GMVIAxUnp0ifDUS9bWkRw+28mpUNoaxae5HsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708335531; c=relaxed/simple;
	bh=jc3LBUVtway1vGTolYxXisE/4dUQ5PTWqaduGD770pE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQ2atlzMj3xhv4byg/Bd0tR60FvvuYwJjtlRGdXs8RM1R2r0HBaZSmtoBTPGKwDvLzJZ0FYr+g9HR1A3UWPVvwL10aYOBquRMsAO0eny2fjNo3M0PsgaNWWAqjjJWq1oYSctw27ruk3Q985Lodd9SNyUKK8G2IHeXlE9TopO61A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVSnOFwx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16096C43394;
	Mon, 19 Feb 2024 09:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708335531;
	bh=jc3LBUVtway1vGTolYxXisE/4dUQ5PTWqaduGD770pE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mVSnOFwxoEmv5z69wlrNPiYnP/JtBXZGvb2fXnMIncaKQxnm8o1/gZAZA61mqT/WP
	 IL7kddbj6k3AXyp4pRsdY47W55kZRYF5rIR+uyaEr716Pkn+UPTKiWnnzJE582QNTq
	 rxU9nrGwVj0WymKQXPWFB1bKkHjO6p3fNhBIN3EWc1+E47Znajm5DAHe9DxEfK3jH3
	 ZEdOwaxtCTgs0J42VtP6PCjvkEQOpysHOWU9QMoodY5KXOOwu/0MXa5TlVDT+8Qh/V
	 EXkgrm8ThPFmMwwPbApT4RcXBLr+ueLiSpvEOodG8DIR+UE3J2Sw8lbV5BRqrUuriN
	 QUWSA8PQYhMvQ==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-563f675be29so3070927a12.0;
        Mon, 19 Feb 2024 01:38:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVwow6yZLQ3jGBwpWDHiiSvvfh57a/thysOxBwzzIGmiyzJ3LOXpC1FC4BjvsV832xQULjdie/p6JBUZJCMkAMkh91JfXo0MblE6clS0ffm0v77udbLSz0kw2hkgCHX8OH2
X-Gm-Message-State: AOJu0YxXd1/IkaYIOvt11VPBEMRPCo7Ba9JrllsKVswDUr41fDWNqVEl
	fa1Wxxp1+WoK9zPpI8fK9snsG6nFRRL2d0i8DQjzk61Gu45Y3upOQVMNo2CqaaN2KI9TYQqAjML
	Ac93WSiFrCsw5egU3k9U4UcTU0sg=
X-Google-Smtp-Source: AGHT+IE02Je77TAG6hdG7xZ1GJAMfud3RHKcsINYlTB1mt7PGcsVr5gsnSzlqPCwtdI7QHTip0RT3+B+CsDtncoHLk0=
X-Received: by 2002:aa7:c655:0:b0:561:8918:9f5d with SMTP id
 z21-20020aa7c655000000b0056189189f5dmr7815076edr.20.1708335529394; Mon, 19
 Feb 2024 01:38:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240201031950.3225626-1-maobibo@loongson.cn> <20240201031950.3225626-5-maobibo@loongson.cn>
 <CAAhV-H7dXsU+WM172PWi_m8TYpYmzG_SW-vVQcdnOdETUxQ9+w@mail.gmail.com>
 <63f8bd29-c0da-167b-187d-61c56eb081a6@loongson.cn> <CAAhV-H6HQHyu=0zyv6FVLRJTkOcmnkLk5h361yGd2igYnuMMng@mail.gmail.com>
 <4dcbd5b2-ba69-e254-b3bb-75a75e5f9215@loongson.cn>
In-Reply-To: <4dcbd5b2-ba69-e254-b3bb-75a75e5f9215@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 19 Feb 2024 17:38:45 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7UyOX6ifKzUdTQiPuueOwsBUO2Jhtfcb832Gc0DTpQKQ@mail.gmail.com>
Message-ID: <CAAhV-H7UyOX6ifKzUdTQiPuueOwsBUO2Jhtfcb832Gc0DTpQKQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] LoongArch: Add paravirt interface for guest kernel
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2024 at 5:21=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/2/19 =E4=B8=8B=E5=8D=884:48, Huacai Chen wrote:
> > On Mon, Feb 19, 2024 at 12:11=E2=80=AFPM maobibo <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2024/2/19 =E4=B8=8A=E5=8D=8810:42, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Thu, Feb 1, 2024 at 11:19=E2=80=AFAM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> The patch adds paravirt interface for guest kernel, function
> >>>> pv_guest_initi() firstly checks whether system runs on VM mode. If k=
ernel
> >>>> runs on VM mode, it will call function kvm_para_available() to detec=
t
> >>>> whether current VMM is KVM hypervisor. And the paravirt function can=
 work
> >>>> only if current VMM is KVM hypervisor, since there is only KVM hyper=
visor
> >>>> supported on LoongArch now.
> >>>>
> >>>> This patch only adds paravirt interface for guest kernel, however th=
ere
> >>>> is not effective pv functions added here.
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/Kconfig                        |  9 ++++
> >>>>    arch/loongarch/include/asm/kvm_para.h         |  7 ++++
> >>>>    arch/loongarch/include/asm/paravirt.h         | 27 ++++++++++++
> >>>>    .../include/asm/paravirt_api_clock.h          |  1 +
> >>>>    arch/loongarch/kernel/Makefile                |  1 +
> >>>>    arch/loongarch/kernel/paravirt.c              | 41 ++++++++++++++=
+++++
> >>>>    arch/loongarch/kernel/setup.c                 |  2 +
> >>>>    7 files changed, 88 insertions(+)
> >>>>    create mode 100644 arch/loongarch/include/asm/paravirt.h
> >>>>    create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.=
h
> >>>>    create mode 100644 arch/loongarch/kernel/paravirt.c
> >>>>
> >>>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> >>>> index 10959e6c3583..817a56dff80f 100644
> >>>> --- a/arch/loongarch/Kconfig
> >>>> +++ b/arch/loongarch/Kconfig
> >>>> @@ -585,6 +585,15 @@ config CPU_HAS_PREFETCH
> >>>>           bool
> >>>>           default y
> >>>>
> >>>> +config PARAVIRT
> >>>> +       bool "Enable paravirtualization code"
> >>>> +       depends on AS_HAS_LVZ_EXTENSION
> >>>> +       help
> >>>> +          This changes the kernel so it can modify itself when it i=
s run
> >>>> +         under a hypervisor, potentially improving performance sign=
ificantly
> >>>> +         over full virtualization.  However, when run without a hyp=
ervisor
> >>>> +         the kernel is theoretically slower and slightly larger.
> >>>> +
> >>>>    config ARCH_SUPPORTS_KEXEC
> >>>>           def_bool y
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/=
include/asm/kvm_para.h
> >>>> index 9425d3b7e486..41200e922a82 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_para.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_para.h
> >>>> @@ -2,6 +2,13 @@
> >>>>    #ifndef _ASM_LOONGARCH_KVM_PARA_H
> >>>>    #define _ASM_LOONGARCH_KVM_PARA_H
> >>>>
> >>>> +/*
> >>>> + * Hypcall code field
> >>>> + */
> >>>> +#define HYPERVISOR_KVM                 1
> >>>> +#define HYPERVISOR_VENDOR_SHIFT                8
> >>>> +#define HYPERCALL_CODE(vendor, code)   ((vendor << HYPERVISOR_VENDO=
R_SHIFT) + code)
> >>>> +
> >>>>    /*
> >>>>     * LoongArch hypcall return code
> >>>>     */
> >>>> diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/=
include/asm/paravirt.h
> >>>> new file mode 100644
> >>>> index 000000000000..b64813592ba0
> >>>> --- /dev/null
> >>>> +++ b/arch/loongarch/include/asm/paravirt.h
> >>>> @@ -0,0 +1,27 @@
> >>>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>>> +#ifndef _ASM_LOONGARCH_PARAVIRT_H
> >>>> +#define _ASM_LOONGARCH_PARAVIRT_H
> >>>> +
> >>>> +#ifdef CONFIG_PARAVIRT
> >>>> +#include <linux/static_call_types.h>
> >>>> +struct static_key;
> >>>> +extern struct static_key paravirt_steal_enabled;
> >>>> +extern struct static_key paravirt_steal_rq_enabled;
> >>>> +
> >>>> +u64 dummy_steal_clock(int cpu);
> >>>> +DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
> >>>> +
> >>>> +static inline u64 paravirt_steal_clock(int cpu)
> >>>> +{
> >>>> +       return static_call(pv_steal_clock)(cpu);
> >>>> +}
> >>> The steal time code can be removed in this patch, I think.
> >>>
> >> Originally I want to remove this piece of code, but it fails to compil=
e
> >> if CONFIG_PARAVIRT is selected. Here is reference code, function
> >> paravirt_steal_clock() must be defined if CONFIG_PARAVIRT is selected.
> >>
> >> static __always_inline u64 steal_account_process_time(u64 maxtime)
> >> {
> >> #ifdef CONFIG_PARAVIRT
> >>           if (static_key_false(&paravirt_steal_enabled)) {
> >>                   u64 steal;
> >>
> >>                   steal =3D paravirt_steal_clock(smp_processor_id());
> >>                   steal -=3D this_rq()->prev_steal_time;
> >>                   steal =3D min(steal, maxtime);
> >>                   account_steal_time(steal);
> >>                   this_rq()->prev_steal_time +=3D steal;
> >>
> >>                   return steal;
> >>           }
> >> #endif
> >>           return 0;
> >> }
> > OK, then keep it.
> >
> >>
> >>>> +
> >>>> +int pv_guest_init(void);
> >>>> +#else
> >>>> +static inline int pv_guest_init(void)
> >>>> +{
> >>>> +       return 0;
> >>>> +}
> >>>> +
> >>>> +#endif // CONFIG_PARAVIRT
> >>>> +#endif
> >>>> diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h b/arch/=
loongarch/include/asm/paravirt_api_clock.h
> >>>> new file mode 100644
> >>>> index 000000000000..65ac7cee0dad
> >>>> --- /dev/null
> >>>> +++ b/arch/loongarch/include/asm/paravirt_api_clock.h
> >>>> @@ -0,0 +1 @@
> >>>> +#include <asm/paravirt.h>
> >>>> diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/=
Makefile
> >>>> index 3c808c680370..662e6e9de12d 100644
> >>>> --- a/arch/loongarch/kernel/Makefile
> >>>> +++ b/arch/loongarch/kernel/Makefile
> >>>> @@ -48,6 +48,7 @@ obj-$(CONFIG_MODULES)         +=3D module.o module=
-sections.o
> >>>>    obj-$(CONFIG_STACKTRACE)       +=3D stacktrace.o
> >>>>
> >>>>    obj-$(CONFIG_PROC_FS)          +=3D proc.o
> >>>> +obj-$(CONFIG_PARAVIRT)         +=3D paravirt.o
> >>>>
> >>>>    obj-$(CONFIG_SMP)              +=3D smp.o
> >>>>
> >>>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kerne=
l/paravirt.c
> >>>> new file mode 100644
> >>>> index 000000000000..21d01d05791a
> >>>> --- /dev/null
> >>>> +++ b/arch/loongarch/kernel/paravirt.c
> >>>> @@ -0,0 +1,41 @@
> >>>> +// SPDX-License-Identifier: GPL-2.0
> >>>> +#include <linux/export.h>
> >>>> +#include <linux/types.h>
> >>>> +#include <linux/jump_label.h>
> >>>> +#include <linux/kvm_para.h>
> >>>> +#include <asm/paravirt.h>
> >>>> +#include <linux/static_call.h>
> >>>> +
> >>>> +struct static_key paravirt_steal_enabled;
> >>>> +struct static_key paravirt_steal_rq_enabled;
> >>>> +
> >>>> +static u64 native_steal_clock(int cpu)
> >>>> +{
> >>>> +       return 0;
> >>>> +}
> >>>> +
> >>>> +DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
> >>> The steal time code can be removed in this patch, I think.
> >> Ditto, the same reason with above.
> >>>
> >>>> +
> >>>> +static bool kvm_para_available(void)
> >>>> +{
> >>>> +       static int hypervisor_type;
> >>>> +       int config;
> >>>> +
> >>>> +       if (!hypervisor_type) {
> >>>> +               config =3D read_cpucfg(CPUCFG_KVM_SIG);
> >>>> +               if (!memcmp(&config, KVM_SIGNATURE, 4))
> >>>> +                       hypervisor_type =3D HYPERVISOR_KVM;
> >>>> +       }
> >>>> +
> >>>> +       return hypervisor_type =3D=3D HYPERVISOR_KVM;
> >>>> +}
> >>>> +
> >>>> +int __init pv_guest_init(void)
> >>>> +{
> >>>> +       if (!cpu_has_hypervisor)
> >>>> +               return 0;
> >>>> +       if (!kvm_para_available())
> >>>> +               return 0;
> >>>> +
> >>>> +       return 1;
> >>>> +}
> >>>> diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/s=
etup.c
> >>>> index edf2bba80130..de5c36dccc49 100644
> >>>> --- a/arch/loongarch/kernel/setup.c
> >>>> +++ b/arch/loongarch/kernel/setup.c
> >>>> @@ -43,6 +43,7 @@
> >>>>    #include <asm/efi.h>
> >>>>    #include <asm/loongson.h>
> >>>>    #include <asm/numa.h>
> >>>> +#include <asm/paravirt.h>
> >>>>    #include <asm/pgalloc.h>
> >>>>    #include <asm/sections.h>
> >>>>    #include <asm/setup.h>
> >>>> @@ -367,6 +368,7 @@ void __init platform_init(void)
> >>>>           pr_info("The BIOS Version: %s\n", b_info.bios_version);
> >>>>
> >>>>           efi_runtime_init();
> >>>> +       pv_guest_init();
> >>> I prefer use CONFIG_PARAVIRT here, though you have a dummy version fo=
r
> >>> !CONFIG_PARAVIRT, I think it is better to let others clearly know tha=
t
> >>> PARAVIRT is an optional feature.
> >> I remember that there is rule that CONFIG_xxx had better be used in
> >> header files rather than c code, so that the code looks neat. Am I wro=
ng?
> > That depends on what we want, sometimes we want to hide the details,
> > but sometimes we want to give others a notice.
> I want to keep code clean here :)
>
> >
> > And there is another problem: if you want to centralize all pv init
> > functions, it is better to use pv_features_init() rather than
> > pv_guest_init(); if you want to give each feature an init function,
> > then we don't need pv_guest_init here, and we can then add a
> > pv_ipi_init() in the last patch.
> Currently I have no idea how to add other pv features like pv
> stealtimer, I will consider this when adding other pv features.
> pv_ipi_init/pv_guest_init is both ok for me, pv_ipi_init is better for no=
w.
Then you want to add an init function for each feature, so please
rename to pv_ipi_init(), move to the last patch and in
loongson_smp_setup().

Huacai

>
> Regards
> Bibo Mao
>
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>>
> >>> Huacai
> >>>>    }
> >>>>
> >>>>    static void __init check_kernel_sections_mem(void)
> >>>> --
> >>>> 2.39.3
> >>>>
> >>>>
> >>
>


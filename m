Return-Path: <kvm+bounces-10094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD7F869998
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 16:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12A9B292798
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F8B148300;
	Tue, 27 Feb 2024 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCLYeDkT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BBC1482F5;
	Tue, 27 Feb 2024 14:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045840; cv=none; b=BGD4N0ca72+orkbodomsjXRrWdie194w9+eW/l4lA9I+yD62jGk4PfSF5z6G+9hOKliorlDfRRqJs5i7wgPPkFd3OlJRY2IXOArsr7tng4qxy17O6nvbfnSxhtXTBqxCr7akMKlFvdAWWsFNjPR/E8vJfdEjav4WH7bx8QWNqa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045840; c=relaxed/simple;
	bh=kNT7bnt1rPGgFookSGlOqrNUkGMcqjGSZ5SZmXT1qEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=plLqZqrBVyLylTzIQgi8uE+kJzxQ8+1z8MeiwUb28757yNHycrsKREzLfZebBsMEoqY9v68bmUcLf7Kl0yxXKvU8vsX1BcCR+68S4HQdX5DjHwh08RqJmjEcipNvhB5xO1bMKHobifOZ56lekrqWurlwyBxDp+L+I0hbKc5Ef8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCLYeDkT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82E8C433A6;
	Tue, 27 Feb 2024 14:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709045839;
	bh=kNT7bnt1rPGgFookSGlOqrNUkGMcqjGSZ5SZmXT1qEs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bCLYeDkTii8jh+FByN5BtWWYY+ezhCi0eK0A2ZMWHaq7gdYoS8/xyeYPlUFfU/A1e
	 om+suB8N5IxiB8E2xawB5g0iulSAUohgYpTJecuLF3w1ntZl2YT4FziYV8cnDAhHxa
	 2YLQGJNFPBvHXfDUZyeTsHRQ2/EeiPt7kt48/xJk3LJaMtzIw7GML5O/MjTVIjFEjy
	 NukCyKZK8ZdKuqYblwyFTEkv9uTNUXfbt7E+tF2NB+3JEDYPUywmUiFZ+aLT1e4ywF
	 cnqBp+TOkumCRb1D0a4dPvEXhhF9728MB910fFEccclJmjFOVZbWjG8xi0oDOEU3ET
	 SZFEYkmkUbBpQ==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-512bd533be0so5284073e87.0;
        Tue, 27 Feb 2024 06:57:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWRM55khmA9NKb9yririQPG6SU/l/OEIR+VyxRjWgQEWHKvOxk2frv9zv/dzDfemon0o+1qQBepMo1NdfvBF+BKyHGvfbo2lCNL4eXbYDXrcW/ppyaeM35TLr5Flb5LklTS
X-Gm-Message-State: AOJu0YxddbOeLdkXu7hGNIqpWxXnp811CfNX3YW5DFFUKoiD+zvNEizx
	FURXdZ/O1vV8fXOFgXiP1AbxSVe85QNj7Gboj0aB1WQ61ZuRIBqsL2uzVe9yTvoMUPaVuBmK2TT
	pCgbBpUuHBBfkTATytz2AhCJyK04=
X-Google-Smtp-Source: AGHT+IHB9E4WvglrZzPpM9DyeTp5HFtYnqxx7WeFnVt/nlI/OHsBWtuzj7Rj/8+lT+gnSHZ/ooQZbrc3bgyia8WjSyg=
X-Received: by 2002:a05:6512:68c:b0:512:f258:7d53 with SMTP id
 t12-20020a056512068c00b00512f2587d53mr7287290lfe.30.1709045837892; Tue, 27
 Feb 2024 06:57:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222032803.2177856-1-maobibo@loongson.cn> <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn> <CAAhV-H7p114hWUVrYRfKiBX3teG8sG7xmEW-Q-QT3i+xdLqDEA@mail.gmail.com>
 <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn> <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
 <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn> <327808dd-ac34-4c61-9992-38642acc9419@xen0n.name>
 <62cc24fd-025a-53c6-1c8e-2d20de54d297@loongson.cn> <431111f3-d84a-4311-986d-eebd91559cd3@xen0n.name>
In-Reply-To: <431111f3-d84a-4311-986d-eebd91559cd3@xen0n.name>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 27 Feb 2024 22:57:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H47DCmYeT0jx3zkk=48amaMTxHDbDyGB0=WNPbsDR=dXQ@mail.gmail.com>
Message-ID: <CAAhV-H47DCmYeT0jx3zkk=48amaMTxHDbDyGB0=WNPbsDR=dXQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: WANG Xuerui <kernel@xen0n.name>, Paolo Bonzini <pbonzini@redhat.com>
Cc: maobibo <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Paolo,

I'm very sorry to bother you, now we have a controversy about how to
query hypervisor features (PV IPI, PV timer and maybe PV spinlock) on
LoongArch, and we have two choices:
1, Get from CPUCFG registers;
2, Get from a hypercall.

CPUCFG are unprivileged registers which can be read from user space,
so the first method can unnecessarily leak information to userspace,
but this method is more or less similar to x86's CPUID solution.
Hypercall is of course a privileged method (so no info leak issues),
and this method is used by ARM/ARM64 and most other architectures.

Besides, LoongArch's CPUCFG is supposed to provide per-core features,
while not all hypervisor features are per-core information (Of course
PV IPI is, but others may be or may not be, while 'extioi' is
obviously not). Bibo thinks that only CPUCFG has enough space to
contain all hypervisor features (CSR and IOCSR are not enough).
However it is obvious that we don't need any register space to hold
these features, because they are held in the hypervisor's memory. The
only information that needs register space is "whether I am in a VM"
(in this case we really cannot use hypercall), but this feature is
already in IOCSR (LOONGARCH_IOCSR_FEATURES).

Now my question is: for a new architecture, which method is
preferable, maintainable and extensible? Of course "they both OK" for
the current purpose in this patch, but I think you can give us more
useful information from a professor's view.

More details are available in this thread, about the 3rd patch. Any
suggestions are welcome.






Huacai

On Tue, Feb 27, 2024 at 6:19=E2=80=AFPM WANG Xuerui <kernel@xen0n.name> wro=
te:
>
> On 2/27/24 18:12, maobibo wrote:
> >
> >
> > On 2024/2/27 =E4=B8=8B=E5=8D=885:10, WANG Xuerui wrote:
> >> On 2/27/24 11:14, maobibo wrote:
> >>>
> >>>
> >>> On 2024/2/27 =E4=B8=8A=E5=8D=884:02, Jiaxun Yang wrote:
> >>>>
> >>>>
> >>>> =E5=9C=A82024=E5=B9=B42=E6=9C=8826=E6=97=A5=E4=BA=8C=E6=9C=88 =E4=B8=
=8A=E5=8D=888:04=EF=BC=8Cmaobibo=E5=86=99=E9=81=93=EF=BC=9A
> >>>>> On 2024/2/26 =E4=B8=8B=E5=8D=882:12, Huacai Chen wrote:
> >>>>>> On Mon, Feb 26, 2024 at 10:04=E2=80=AFAM maobibo <maobibo@loongson=
.cn> wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>> On 2024/2/24 =E4=B8=8B=E5=8D=885:13, Huacai Chen wrote:
> >>>>>>>> Hi, Bibo,
> >>>>>>>>
> >>>>>>>> On Thu, Feb 22, 2024 at 11:28=E2=80=AFAM Bibo Mao <maobibo@loong=
son.cn>
> >>>>>>>> wrote:
> >>>>>>>>>
> >>>>>>>>> Instruction cpucfg can be used to get processor features. And
> >>>>>>>>> there
> >>>>>>>>> is trap exception when it is executed in VM mode, and also it i=
s
> >>>>>>>>> to provide cpu features to VM. On real hardware cpucfg area 0 -=
 20
> >>>>>>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is u=
sed
> >>>>>>>>> for KVM hypervisor to privide PV features, and the area can be
> >>>>>>>>> extended
> >>>>>>>>> for other hypervisors in future. This area will never be used f=
or
> >>>>>>>>> real HW, it is only used by software.
> >>>>>>>> After reading and thinking, I find that the hypercall method
> >>>>>>>> which is
> >>>>>>>> used in our productive kernel is better than this cpucfg method.
> >>>>>>>> Because hypercall is more simple and straightforward, plus we do=
n't
> >>>>>>>> worry about conflicting with the real hardware.
> >>>>>>> No, I do not think so. cpucfg is simper than hypercall, hypercall
> >>>>>>> can
> >>>>>>> be in effect when system runs in guest mode. In some scenario
> >>>>>>> like TCG
> >>>>>>> mode, hypercall is illegal intruction, however cpucfg can work.
> >>>>>> Nearly all architectures use hypercall except x86 for its historic=
al
> >>>>> Only x86 support multiple hypervisors and there is multiple hypervi=
sor
> >>>>> in x86 only. It is an advantage, not historical reason.
> >>>>
> >>>> I do believe that all those stuff should not be exposed to guest
> >>>> user space
> >>>> for security reasons.
> >>> Can you add PLV checking when cpucfg 0x40000000-0x400000FF is
> >>> emulated? if it is user mode return value is zero and it is kernel
> >>> mode emulated value will be returned. It can avoid information leakin=
g.
> >>
> >> I've suggested this approach in another reply [1], but I've rechecked
> >> the manual, and it turns out this behavior is not permitted by the
> >> current wording. See LoongArch Reference Manual v1.10, Volume 1,
> >> Section 2.2.10.5 "CPUCFG":
> >>
> >>  > CPUCFG =E8=AE=BF=E9=97=AE=E6=9C=AA=E5=AE=9A=E4=B9=89=E7=9A=84=E9=85=
=8D=E7=BD=AE=E5=AD=97=E5=B0=86=E8=AF=BB=E5=9B=9E=E5=85=A8 0 =E5=80=BC=E3=80=
=82
> >>  >
> >>  > Reads of undefined CPUCFG configuration words shall return all-zero=
es.
> >>
> >> This sentence mentions no distinction based on privilege modes, so it
> >> can only mean the behavior applies universally regardless of privilege
> >> modes.
> >>
> >> I think if you want to make CPUCFG behavior PLV-dependent, you may
> >> have to ask the LoongArch spec editors, internally or in public, for a
> >> new spec revision.
> > No, CPUCFG behavior between CPUCFG0-CPUCFG21 is unchanged, only that it
> > can be defined by software since CPUCFG 0x400000000 is used by software=
.
>
> The 0x40000000 range is not mentioned in the manuals. I know you've
> confirmed privately with HW team but this needs to be properly
> documented for public projects to properly rely on.
>
> >> (There are already multiple third-party LoongArch implementers as of
> >> late 2023, so any ISA-level change like this would best be
> >> coordinated, to minimize surprises.)
> > With document Vol 4-23
> > https://www.intel.com/content/dam/develop/external/us/en/documents/3355=
92-sdm-vol-4.pdf
> >
> > There is one line "MSR address range between 40000000H - 400000FFH is
> > marked as a specially reserved range. All existing and
> > future processors will not implement any features using any MSR in this
> > range."
>
> Thanks for providing this info, now at least we know why it's this
> specific range of 0x400000XX that's chosen.
>
> >
> > It only says that it is reserved, it does not say detailed software
> > behavior. Software behavior is defined in hypervisor such as:
> > https://github.com/MicrosoftDocs/Virtualization-Documentation/blob/main=
/tlfs/Requirements%20for%20Implementing%20the%20Microsoft%20Hypervisor%20In=
terface.pdf
> > https://kb.vmware.com/s/article/1009458
> >
> > If hypercall method is used, there should be ABI also like aarch64:
> > https://documentation-service.arm.com/static/6013e5faeee5236980d08619
>
> Yes proper documentation of public API surface is always necessary
> *before* doing real work. Because right now the hypercall provider is
> Linux KVM, maybe we can document the existing and planned hypercall
> usage and ABI in the kernel docs along with code changes.
>
> --
> WANG "xen0n" Xuerui
>
> Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/
>


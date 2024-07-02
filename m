Return-Path: <kvm+bounces-20815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4889191ECDB
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 03:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1071B1C221C1
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 01:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2259BE7F;
	Tue,  2 Jul 2024 01:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gzo4mmP4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88759441;
	Tue,  2 Jul 2024 01:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719885554; cv=none; b=IK8VHW7PZ7H788QadCY4gpYA1S8AO4iv9+RcAbq4nC60I96cvF8NkHx8Zwfn00f1kkV3F/FkMNvJGMiU8+wy7UXTb5JZYXWimAH/p+yIrDfu7d4EwQG6SXdmDBFTv1qhMoQpn1nnnkvxl5HzyJhI5f+Iy0K+jjtJtD9ifY3rCtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719885554; c=relaxed/simple;
	bh=R8ygghPnMfeWQ9Y4PoN7pER1HV/QcG/H9FSCeeKEm4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TrLQWlqUFneRKiCct/gXyPXDhVFUdZZ4WE+MyDnub6wtdBwnAixrYIFTmHVhy07rwDP168SDxoqcW4osr2V20mByzsIPVJpaNmnxXQUjoHl0dh2a5HwRa3MxvoGvHbdovNYqeUnfUDiFoL8NKTGFNEJFEGErFwENYIDjSfXgP4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gzo4mmP4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E826C2BD10;
	Tue,  2 Jul 2024 01:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719885554;
	bh=R8ygghPnMfeWQ9Y4PoN7pER1HV/QcG/H9FSCeeKEm4U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Gzo4mmP4ASTKe1swkDTOnnNFG8ffE9s9UJAD8iT1kulSuTuGODqy2c5WIQhEhssal
	 OZNPBS8BZcquJZzT9MFyzHT9C1QXKQ63dnJKYgGKpJr7Y8Ohp5N9yOaV4JGCQxcabH
	 drnaFsX37xy8YdLQ0ZhGVGSj2nVDpESXbGvs07mc4vxHC2wUnQbdxVmX9kIiq/Xw4T
	 HBpaeUqmW2lZw1trUyisJdMdqcu8TNjSudZe5LeVHZgXFQmAtRe2WyM5td22ow6bdj
	 7Hsea9WOvpktPQ5viknXFW8/x0Fm5UsXmHWUg8RqmuQT3acu3KShFthaK4M7EMICCg
	 QmqM+WVOww8KA==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-584ef6c07c2so1233987a12.1;
        Mon, 01 Jul 2024 18:59:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUaj+0wiK5skIKbQZS8cxAI91eDelcsPPSCMNO6L6wcm3Y5aC/pMmfDf8WtVpd9eWNZpXQ3XItK4EZkcCdXrIDzXch5tU9NYBv6g1RJmIfMpyRRnEEAy+k+Hzs9BcDG4BlE
X-Gm-Message-State: AOJu0Yz2YabA/qiVx9Lw2STT9CiPKrGWstaghSFsMiZoUfPmaX0++095
	Py1FTGF3xCQzyi75kdIJOJYiFrUop11DasJ2Cc6jlL9LyzEWkFaf9X9VG/azop7cJInWHiNhAse
	eDEP/WcBoo+n1ELv3TUoO2lMfCag=
X-Google-Smtp-Source: AGHT+IFtsV1QUGIFWF3mQ/wUe8OQuXpfXGrZ6rn6PRIo37hgmZtPg1Xazv1l/NOIgekb2HfJCqfdflFbHBYjUx00tNc=
X-Received: by 2002:a17:906:2709:b0:a6f:e699:a9f8 with SMTP id
 a640c23a62f3a-a72aeeb255fmr645830866b.18.1719885552896; Mon, 01 Jul 2024
 18:59:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240626063239.3722175-1-maobibo@loongson.cn> <20240626063239.3722175-3-maobibo@loongson.cn>
 <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
 <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn> <CAAhV-H5bQutcLcVaHn-amjF6_NDnCf2BFqqnGSRT_QQ_6q6REg@mail.gmail.com>
 <9c7d242e-660b-8d39-b69e-201fd0a4bfbf@loongson.cn>
In-Reply-To: <9c7d242e-660b-8d39-b69e-201fd0a4bfbf@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 2 Jul 2024 09:59:02 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4wwrYyMYpL1u5Z3sFp6EeW4eWhGbBv0Jn9XYJGXgwLfg@mail.gmail.com>
Message-ID: <CAAhV-H4wwrYyMYpL1u5Z3sFp6EeW4eWhGbBv0Jn9XYJGXgwLfg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 2, 2024 at 9:51=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote:
>
> Huacai,
>
> On 2024/7/1 =E4=B8=8B=E5=8D=886:26, Huacai Chen wrote:
> > On Mon, Jul 1, 2024 at 9:27=E2=80=AFAM maobibo <maobibo@loongson.cn> wr=
ote:
> >>
> >>
> >> Huacai,
> >>
> >> On 2024/6/30 =E4=B8=8A=E5=8D=8810:07, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Wed, Jun 26, 2024 at 2:32=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> Two kinds of LBT feature detection are added here, one is VCPU
> >>>> feature, the other is VM feature. VCPU feature dection can only
> >>>> work with VCPU thread itself, and requires VCPU thread is created
> >>>> already. So LBT feature detection for VM is added also, it can
> >>>> be done even if VM is not created, and also can be done by any
> >>>> thread besides VCPU threads.
> >>>>
> >>>> Loongson Binary Translation (LBT) feature is defined in register
> >>>> cpucfg2. Here LBT capability detection for VCPU is added.
> >>>>
> >>>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macro
> >>>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. And
> >>>> three sub-features relative with LBT are added as following:
> >>>>    KVM_LOONGARCH_VM_FEAT_X86BT
> >>>>    KVM_LOONGARCH_VM_FEAT_ARMBT
> >>>>    KVM_LOONGARCH_VM_FEAT_MIPSBT
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
> >>>>    arch/loongarch/kvm/vcpu.c             |  6 ++++
> >>>>    arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++=
++++-
> >>>>    3 files changed, 55 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/=
include/uapi/asm/kvm.h
> >>>> index ddc5cab0ffd0..c40f7d9ffe13 100644
> >>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >>>> @@ -82,6 +82,12 @@ struct kvm_fpu {
> >>>>    #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_L=
OONGARCH_CSR, REG)
> >>>>    #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_L=
OONGARCH_CPUCFG, REG)
> >>>>
> >>>> +/* Device Control API on vm fd */
> >>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
> >>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
> >>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
> >>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
> >>>> +
> >>>>    /* Device Control API on vcpu fd */
> >>>>    #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>>>    #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> >>> If you insist that LBT should be a vm feature, then I suggest the
> >>> above two also be vm features. Though this is an UAPI change, but
> >>> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been released. W=
e
> >>> have a chance to change it now.
> >>
> >> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every vcpu
> >> has is own different gpa address.
> > Then leave this as a vm feature.
> >
> >>
> >> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We cannot bre=
ak
> >> the API even if it is 6.10-rc1, VMM has already used this. Else there =
is
> >> uapi breaking now, still will be in future if we cannot control this.
> > UAPI changing before the first release is allowed, which means, we can
> > change this before the 6.10-final, but cannot change it after
> > 6.10-final.
> Now QEMU has already synced uapi to its own directory, also I never hear
> about this, with my experience with uapi change, there is only newly
> added or removed deprecated years ago.
>
> Is there any documentation about UAPI change rules?
No document, but learn from my more than 10 years upstream experience.

> >
> >>
> >> How about adding new extra features capability for VM such as?
> >> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
> >> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
> > They should be similar as LBT, if LBT is vcpu feature, they should
> > also be vcpu features; if LBT is vm feature, they should also be vm
> > features.
> On other architectures, with function kvm_vm_ioctl_check_extension()
>     KVM_CAP_XSAVE2/KVM_CAP_PMU_CAPABILITY on x86
>     KVM_CAP_ARM_PMU_V3/KVM_CAP_ARM_SVE on arm64
> These features are all cpu features, at the same time they are VM feature=
s.
>
> If they are cpu features, how does VMM detect validity of these features
> passing from command line? After all VCPUs are created and send bootup
> command to these VCPUs? That is too late, VMM main thread is easy to
> detect feature validity if they are VM features also.
>
> To be honest, I am not familiar with KVM still, only get further
> understanding after actual problems solving. Welcome to give comments,
> however please read more backgroud if you insist on, else there will be
> endless argument again.
I just say CPUCFG/LSX/LASX and LBT should be in the same class, I
haven't insisted on whether they should be vcpu features or vm
features.

Huacai

>
> Regards
> Bibo, Mao
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>> index 233d28d0e928..9734b4d8db05 100644
> >>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
> >>>>                           *v |=3D CPUCFG2_LSX;
> >>>>                   if (cpu_has_lasx)
> >>>>                           *v |=3D CPUCFG2_LASX;
> >>>> +               if (cpu_has_lbt_x86)
> >>>> +                       *v |=3D CPUCFG2_X86BT;
> >>>> +               if (cpu_has_lbt_arm)
> >>>> +                       *v |=3D CPUCFG2_ARMBT;
> >>>> +               if (cpu_has_lbt_mips)
> >>>> +                       *v |=3D CPUCFG2_MIPSBT;
> >>>>
> >>>>                   return 0;
> >>>>           case LOONGARCH_CPUCFG3:
> >>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> >>>> index 6b2e4f66ad26..09e05108c68b 100644
> >>>> --- a/arch/loongarch/kvm/vm.c
> >>>> +++ b/arch/loongarch/kvm/vm.c
> >>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> >>>>           return r;
> >>>>    }
> >>>>
> >>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_devi=
ce_attr *attr)
> >>>> +{
> >>>> +       switch (attr->attr) {
> >>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
> >>>> +               if (cpu_has_lbt_x86)
> >>>> +                       return 0;
> >>>> +               return -ENXIO;
> >>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
> >>>> +               if (cpu_has_lbt_arm)
> >>>> +                       return 0;
> >>>> +               return -ENXIO;
> >>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
> >>>> +               if (cpu_has_lbt_mips)
> >>>> +                       return 0;
> >>>> +               return -ENXIO;
> >>>> +       default:
> >>>> +               return -ENXIO;
> >>>> +       }
> >>>> +}
> >>>> +
> >>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr =
*attr)
> >>>> +{
> >>>> +       switch (attr->group) {
> >>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
> >>>> +               return kvm_vm_feature_has_attr(kvm, attr);
> >>>> +       default:
> >>>> +               return -ENXIO;
> >>>> +       }
> >>>> +}
> >>>> +
> >>>>    int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsi=
gned long arg)
> >>>>    {
> >>>> -       return -ENOIOCTLCMD;
> >>>> +       struct kvm *kvm =3D filp->private_data;
> >>>> +       void __user *argp =3D (void __user *)arg;
> >>>> +       struct kvm_device_attr attr;
> >>>> +
> >>>> +       switch (ioctl) {
> >>>> +       case KVM_HAS_DEVICE_ATTR:
> >>>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> >>>> +                       return -EFAULT;
> >>>> +
> >>>> +               return kvm_vm_has_attr(kvm, &attr);
> >>>> +       default:
> >>>> +               return -EINVAL;
> >>>> +       }
> >>>>    }
> >>>> --
> >>>> 2.39.3
> >>>>
> >>
>


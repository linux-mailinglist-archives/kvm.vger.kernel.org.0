Return-Path: <kvm+bounces-32913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 636419E16FD
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28BF6163A99
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B253B1DED53;
	Tue,  3 Dec 2024 09:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFc8O9oo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C395A19C543;
	Tue,  3 Dec 2024 09:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733217438; cv=none; b=AVMbwajUwe+MyAvF8qrOBuWestHtJHALYHohHaAco6rgR+1vBszlhEDvIJypSMJ4pAy2hNmu4arsuLcW+nAtNSKqOV60K4bAl7FJ40za5su6iEFB6kQIUwAqM3hCxSuHtBF3o4mS6Lpe5RRTJTS2E0snARJ4ljRU6vaGsn5JiIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733217438; c=relaxed/simple;
	bh=Mm+270InuXW4V+yYCDDQXwH3B1E27S4QTtpkk0TtKIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E9CtVcd5Oz1KyAhal2h7AAEQc97TkUCNZmm0kq6aIBmuNC/y94po2DPtNkKvsJEzqvl/MoOtPQ9jgMF6WGLL2JSfKM8n+g557ZKpp9JcCV9TORbsffuFmzfxoL0MAJdq/zUACGLa8iNIVmtZUxrrK5YesGGykSH1bm7duI9htRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFc8O9oo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800F0C4CEDA;
	Tue,  3 Dec 2024 09:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733217438;
	bh=Mm+270InuXW4V+yYCDDQXwH3B1E27S4QTtpkk0TtKIE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YFc8O9ooVjlinp7b76LDLm8IwaQOkVpKGrPwv7Df/iWT3gcMZDCxIBTx/X1GDtvba
	 KZFN/p+cEKCITuruMcMUqsWz4kqVenkKgplSvIurmj/nJi7BhLtl4IyGY+ZheOXUiz
	 WsntnS4EMtu/f0T7UsmXoANsAKXI97t7nFrzPghsslHEsFIZj8PameCF7SjRO2/IZz
	 9KLo4elgzPX8KtCsoD5fG6eYv8v80x4dtDCDhZLiYL1fHv62fv2dK508WX4NK1UxWz
	 MUMJLaootVRv+JDpveapEeXsoof7HzdF9s+Uo8GCicUJW/6XoQ5PVApqU6EXG6yqBC
	 SlqPMmD1hIgww==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53df6322ea7so9018040e87.0;
        Tue, 03 Dec 2024 01:17:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVPS9qW1C76/iRjTgFpnsY8GPLvdZa3fSD4Oq6l5JuYYFz+oUSe4SVjU/NCtDPd2S8J9ofG2iW8@vger.kernel.org, AJvYcCVu6lE3odF8o5JBTn6DgHqbQ1bChq4KTIcR+icgLjAoD5/ZgFN3WwN4+5FS7slHNf9xI7Y=@vger.kernel.org, AJvYcCXwZkb+KDcbeqorUDI0frQcT+VsAKPp+wRHCzptscK3sgy64Go06no9VBZvAoi008v7cXScEPU3hD2Y+28C@vger.kernel.org
X-Gm-Message-State: AOJu0YzYZwETTXgkT2tG5n5XQcKXasI/Te5F1X+1erEEzfxpP9ISkuts
	CunIeuaHQzYtYY9hh7AL4GX8fAct2KUjx+GtxEGW5nRcPibbjhgm3U0I0GHEHXxULr5I+ZFnw5U
	wtOgkvLwHoyiSEJl09rzd+i24BjU=
X-Google-Smtp-Source: AGHT+IHWQfIrndfB98TtLAtHKiRdwn/fuXrMMY8g+Ye7zMHVObxe+6srcegoXHPwcagdFF66wmqT8AioviE8HwFt7rw=
X-Received: by 2002:a19:e006:0:b0:53e:1364:d756 with SMTP id
 2adb3069b0e04-53e1364d988mr740188e87.13.1733217436844; Tue, 03 Dec 2024
 01:17:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203065058.4164631-1-chenhuacai@loongson.cn> <e0c59558-09ec-1e51-9b36-86b69f7e8bde@loongson.cn>
In-Reply-To: <e0c59558-09ec-1e51-9b36-86b69f7e8bde@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Dec 2024 17:17:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H58ct9uGzyyL5Pz2kVM50K+1B0eGJ0zzb_2aV1Jzwp5+Q@mail.gmail.com>
Message-ID: <CAAhV-H58ct9uGzyyL5Pz2kVM50K+1B0eGJ0zzb_2aV1Jzwp5+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] LoongArch: KVM: Protect kvm_check_requests() with SRCU
To: bibo mao <maobibo@loongson.cn>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 4:27=E2=80=AFPM bibo mao <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/12/3 =E4=B8=8B=E5=8D=882:50, Huacai Chen wrote:
> > When we enable lockdep we get such a warning:
> >
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >   WARNING: suspicious RCU usage
> >   6.12.0-rc7+ #1891 Tainted: G        W
> >   -----------------------------
> >   include/linux/kvm_host.h:1043 suspicious rcu_dereference_check() usag=
e!
> >   other info that might help us debug this:
> >   rcu_scheduler_active =3D 2, debug_locks =3D 1
> >   1 lock held by qemu-system-loo/948:
> >    #0: 90000001184a00a8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+=
0xf4/0xe20 [kvm]
> >   stack backtrace:
> >   CPU: 0 UID: 0 PID: 948 Comm: qemu-system-loo Tainted: G        W     =
     6.12.0-rc7+ #1891
> >   Tainted: [W]=3DWARN
> >   Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A50=
00-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.0-prebeta9 10/21/2022
> >   Stack : 0000000000000089 9000000005a0db9c 90000000071519c8 900000012c=
578000
> >           900000012c57b920 0000000000000000 900000012c57b928 9000000007=
e53788
> >           900000000815bcc8 900000000815bcc0 900000012c57b790 0000000000=
000001
> >           0000000000000001 4b031894b9d6b725 0000000004dec000 9000000100=
3299c0
> >           0000000000000414 0000000000000001 000000000000002d 0000000000=
000003
> >           0000000000000030 00000000000003b4 0000000004dec000 9000000118=
4a0000
> >           900000000806d000 9000000007e53788 00000000000000b4 0000000000=
000004
> >           0000000000000004 0000000000000000 0000000000000000 9000000107=
baf600
> >           9000000008916000 9000000007e53788 9000000005924778 0000000010=
000044
> >           00000000000000b0 0000000000000004 0000000000000000 0000000000=
071c1d
> >           ...
> >   Call Trace:
> >   [<9000000005924778>] show_stack+0x38/0x180
> >   [<90000000071519c4>] dump_stack_lvl+0x94/0xe4
> >   [<90000000059eb754>] lockdep_rcu_suspicious+0x194/0x240
> >   [<ffff8000022143bc>] kvm_gfn_to_hva_cache_init+0xfc/0x120 [kvm]
> >   [<ffff80000222ade4>] kvm_pre_enter_guest+0x3a4/0x520 [kvm]
> >   [<ffff80000222b3dc>] kvm_handle_exit+0x23c/0x480 [kvm]
> >
> > Fix it by protecting kvm_check_requests() with SRCU.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >   arch/loongarch/kvm/vcpu.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> > index cab1818be68d..d18a4a270415 100644
> > --- a/arch/loongarch/kvm/vcpu.c
> > +++ b/arch/loongarch/kvm/vcpu.c
> > @@ -240,7 +240,7 @@ static void kvm_late_check_requests(struct kvm_vcpu=
 *vcpu)
> >    */
> >   static int kvm_enter_guest_check(struct kvm_vcpu *vcpu)
> >   {
> > -     int ret;
> > +     int idx, ret;
> >
> >       /*
> >        * Check conditions before entering the guest
> > @@ -249,7 +249,9 @@ static int kvm_enter_guest_check(struct kvm_vcpu *v=
cpu)
> >       if (ret < 0)
> >               return ret;
> >
> > +     idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> >       ret =3D kvm_check_requests(vcpu);
> > +     srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >
> >       return ret;
> >   }
> >
> How about adding rcu readlock with closest function
> kvm_update_stolen_time()?
I have considered this method before. But then I read vcpu_run() of
x86, it protect the whole vcpu_run() except  the subroutine
xfer_to_guest_mode_handle_work(), so I think protect the whole
kvm_check_requests() is more like x86.

Huacai

>
>   static int kvm_check_requests(struct kvm_vcpu *vcpu)
>   {
> +       int idx;
> +
>          if (!kvm_request_pending(vcpu))
>                  return RESUME_GUEST;
>
> @@ -213,8 +215,11 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
>          if (kvm_dirty_ring_check_request(vcpu))
>                  return RESUME_HOST;
>
> -       if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
> +       if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu)) {
> +               idx =3D srcu_read_lock(&vcpu->kvm->srcu);
>                  kvm_update_stolen_time(vcpu);
> +               srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +       }
>
>          return RESUME_GUEST;
>   }
>
> Both method look good to me.
>
> Regards
> Bibo Mao
>


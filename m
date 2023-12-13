Return-Path: <kvm+bounces-4297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C137810AC2
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:59:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1EF21F21804
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 06:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD24712B65;
	Wed, 13 Dec 2023 06:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="kago5zP5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849FED0
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 22:58:56 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-5c66b093b86so5788943a12.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 22:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702450736; x=1703055536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bf5KPLLb5mppiqs2V6fQXEFnrR5qxzVp6zV/S8php7g=;
        b=kago5zP5qVzZdiiFSAWsUlll3+uS2kBoj1cV77yAUWeM9HcjI7f1RPoUhv9EieGBdP
         tcXZ/B3MDr/T6ys6En0Zf/VZgS6Q2hnZNQJaA1wDmzTRq/L0uXtsUiPNrDUnbI/bBDWi
         O0WzieA+UcFy078/YBNWqDZdOjLFbLIxQcHnkYfrq1CsM3rqAxJnbGokvWjiWlve9O77
         RkicZlhTkAV52UuA+zIXIhUCUJ6+pJ7FF9NgsM78n3LByp3GAtwKlWv4m+XzdlxUNMIy
         +97qsTz0I0+Kfmt50eDkW6WnzW8k9u5VDkkj/STv6MH3KPma3tuuV9b+ntJ+7D4+6FWm
         6bzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702450736; x=1703055536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bf5KPLLb5mppiqs2V6fQXEFnrR5qxzVp6zV/S8php7g=;
        b=URVn24bIhC6OYekiMA6eg6HY8KLHnTIrJehhBmS24gSfuN9WUsyfnN0L/FnfGov2OB
         UESwtuKTTKkrLdEJ//gbqx1L0EuQ5GNZD2dZJrScmiCbqrBoXwtCjP9dy7M6XWajf7qA
         6OgBcdBFf07Y9ASE4qUaZD1OelL9LVwVlT+kD9rVRC/BzM33hOFq2HBPyhlGHXh2et0l
         C9WH9+72A+bHyaHjk+IoiK7zQtVZNv5sMReL08IfoFmKtNuVsiFPgP8F9H12JXrCr0pR
         HLFUWrtTZMGxHagZCehYiny8Qb/+fTM/ZlyWczzdGgRA12QWk2Ka4fixrFabCCyy5sUb
         p+FQ==
X-Gm-Message-State: AOJu0YywNWNo9sB2G28/4s4V/Y4pj+1T5ECs1CLsbBssykrP/qwEBEMD
	IwEIBuAy08e949trgVnA72rBE8fnyAWvcQBOXEPBlw==
X-Google-Smtp-Source: AGHT+IHcel4RGxuhUT4S+8ysviVVjUdeLRd5uUE5iIk9tDQ4l9HK3ci0gXUWjTSy85PhMRS2cyHdeWlEIcHWxtLc5Bs=
X-Received: by 2002:a17:90a:fd0b:b0:286:6cd8:ef09 with SMTP id
 cv11-20020a17090afd0b00b002866cd8ef09mr9239266pjb.33.1702450735785; Tue, 12
 Dec 2023 22:58:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231213061610.11100-1-yongxuan.wang@sifive.com>
In-Reply-To: <20231213061610.11100-1-yongxuan.wang@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 13 Dec 2023 12:28:44 +0530
Message-ID: <CAAhSdy11SyXB0f0TOB4jX6mxCXTS-_RTXm6bFSfyY+4PThY5bg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] RISCV: KVM: update external interrupt atomically
 for IMSIC swfile
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 11:46=E2=80=AFAM Yong-Xuan Wang
<yongxuan.wang@sifive.com> wrote:
>
> The emulated IMSIC update the external interrupt pending depending on the
> value of eidelivery and topei. It might lose an interrupt when it is
> interrupted before setting the new value to the pending status.
>
> For example, when VCPU0 sends an IPI to VCPU1 via IMSIC:
>
> VCPU0                           VCPU1
>
>                                 CSRSWAP topei =3D 0
>                                 The VCPU1 has claimed all the external
>                                 interrupt in its interrupt handler.
>
>                                 topei of VCPU1's IMSIC =3D 0
>
> set pending in VCPU1's IMSIC
>
> topei of VCPU1' IMSIC =3D 1
>
> set the external interrupt
> pending of VCPU1
>
>                                 clear the external interrupt pending
>                                 of VCPU1
>
> When the VCPU1 switches back to VS mode, it exits the interrupt handler
> because the result of CSRSWAP topei is 0. If there are no other external
> interrupts injected into the VCPU1's IMSIC, VCPU1 will never know this
> pending interrupt unless it initiative read the topei.
>
> If the interruption occurs between updating interrupt pending in IMSIC
> and updating external interrupt pending of VCPU, it will not cause a
> problem. Suppose that the VCPU1 clears the IPI pending in IMSIC right
> after VCPU0 sets the pending, the external interrupt pending of VCPU1
> will not be set because the topei is 0. But when the VCPU1 goes back to
> VS mode, the pending IPI will be reported by the CSRSWAP topei, it will
> not lose this interrupt.
>
> So we only need to make the external interrupt updating procedure as a
> critical section to avoid the problem.
>
> Fixes: db8b7e97d613 ("RISC-V: KVM: Add in-kernel virtualization of AIA IM=
SIC")
> Tested-by: Roy Lin <roy.lin@sifive.com>
> Tested-by: Wayling Chen <wayling.chen@sifive.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>

Queued as fixes for Linux-6.7

Thanks,
Anup

> ---
> Changelog
> v2:
> - rename the variable and add a short comment in the code
> ---
>  arch/riscv/kvm/aia_imsic.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index 6cf23b8adb71..e808723a85f1 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -55,6 +55,7 @@ struct imsic {
>         /* IMSIC SW-file */
>         struct imsic_mrif *swfile;
>         phys_addr_t swfile_pa;
> +       spinlock_t swfile_extirq_lock;
>  };
>
>  #define imsic_vs_csr_read(__c)                 \
> @@ -613,12 +614,23 @@ static void imsic_swfile_extirq_update(struct kvm_v=
cpu *vcpu)
>  {
>         struct imsic *imsic =3D vcpu->arch.aia_context.imsic_state;
>         struct imsic_mrif *mrif =3D imsic->swfile;
> +       unsigned long flags;
> +
> +       /*
> +        * The critical section is necessary during external interrupt
> +        * updates to avoid the risk of losing interrupts due to potentia=
l
> +        * interruptions between reading topei and updating pending statu=
s.
> +        */
> +
> +       spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
>
>         if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
>             imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
>                 kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_EXT);
>         else
>                 kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
> +
> +       spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
>  }
>
>  static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
> @@ -1039,6 +1051,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *=
vcpu)
>         }
>         imsic->swfile =3D page_to_virt(swfile_page);
>         imsic->swfile_pa =3D page_to_phys(swfile_page);
> +       spin_lock_init(&imsic->swfile_extirq_lock);
>
>         /* Setup IO device */
>         kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
> --
> 2.17.1
>


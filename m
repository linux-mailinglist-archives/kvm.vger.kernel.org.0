Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE654842E7
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 15:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiADOAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 09:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiADOAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 09:00:12 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7467C061784
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 06:00:11 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id b186-20020a1c1bc3000000b00345734afe78so1500163wmb.0
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 06:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LAi/zMLDUkXA55ptMHaAtcTiIFXbdm+3dHnXo6tH6To=;
        b=mRc+fKjFCLxv1tB++H8YO7Ja92cyl7ysVXH0gvFwP8a/h7jN6F1I88slAfmXwpNrCE
         9iqa6hA9cBdP4GzTfatDmB8bQHgwlnNtLpwc4yj8KIHX2QYw1Afru8Yrg787Thq6LbKi
         X5Fm7mf2iN3ljpDxCg2+DAtmJ8gXl97NFnQBp5gUffZPu3zb2DgkLTqCeE8Jxgb8ciLM
         OpltDN5JU+/0hqCPRbNJGm6ChzqvelKZsBTQqov3FQJ04GzM13eZi0Fy2Lfmy6rnYdf/
         su5R5IuHUAsMfMaup67+GdOsH0/xMQPYn4ZMQ+mvu4l0ELyYmlV3Im5hs8fvsSJ5c2TF
         WIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LAi/zMLDUkXA55ptMHaAtcTiIFXbdm+3dHnXo6tH6To=;
        b=sfNIngb7WUpVN/Uiw7ZOjBgQCyY7uxAMNx7qc7t6V9MWD3y0PsKcEkKFHe7ClqZrxl
         8mcffuJ4YuPpQAqXVEqEI7HiVGGxilr9YpUWQb/abaHJVf9M4rUNjxDQ07s8fG9Cxj1p
         WQqizszKTU5QgWNpH3QwCWdaEVe178cAZ9cTDGQBhyz8AI/XWL4XQuDAe/UPruWoVpTm
         G3vS0OAaFZ8VkDlPoAQg7DJPykQ2ppx46S7a0fyYM1c0Qfcvu0avjM9o9z3/uNpwOL++
         KzWVwqZOrdm0roaNf2QTCNlqBpkuuX4CZuNxhSP3PmYjNtH+vjjzJm56mWXTFMFIM+Jk
         g2qA==
X-Gm-Message-State: AOAM5310WCy1JN7O1GYk3jKO/WzAohU3k0EGTfDzyN+7RUpmUobc30CB
        bw8/x8sZRsDY7RGmTgvtnYUK8fBy5/5zlRixTrDJRw==
X-Google-Smtp-Source: ABdhPJxshd4qMDQyCd0C74OyBKCvDdeUgBw0LwKdi1bze+9JK/GGFMAZ+nHe++OKjLTKJw7qt/730w8by/yH6EhdSsg=
X-Received: by 2002:a7b:c243:: with SMTP id b3mr42380051wmj.61.1641304810085;
 Tue, 04 Jan 2022 06:00:10 -0800 (PST)
MIME-Version: 1.0
References: <20211118083912.981995-1-atishp@rivosinc.com> <20211118083912.981995-2-atishp@rivosinc.com>
 <6615284.qex3tTltCR@diego> <8323751.1mJVJdxAKN@diego>
In-Reply-To: <8323751.1mJVJdxAKN@diego>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 4 Jan 2022 19:29:58 +0530
Message-ID: <CAAhSdy0J7WVJO5vbz1JeHChitbJpagyuE1nF8XHfY-K=DnySGg@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] RISC-V: KVM: Mark the existing SBI implementation
 as v01
To:     =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 4, 2022 at 6:57 PM Heiko St=C3=BCbner <heiko@sntech.de> wrote:
>
> Am Dienstag, 4. Januar 2022, 14:19:41 CET schrieb Heiko St=C3=BCbner:
> > Hi Atish,
> >
> > Am Donnerstag, 18. November 2021, 09:39:08 CET schrieb Atish Patra:
> > > From: Atish Patra <atish.patra@wdc.com>
> > >
> > > The existing SBI specification impelementation follows v0.1
> > > specification. The latest specification allows more
> > > scalability and performance improvements.
> > >
> > > Rename the existing implementation as v01 and provide a way to allow
> > > future extensions.
> > >
> > > Reviewed-by: Anup Patel <anup.patel@wdc.com>
> > > Signed-off-by: Atish Patra <atish.patra@wdc.com>
> > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > ---
> >
> > > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > > index eb3c045edf11..32376906ff20 100644
> > > --- a/arch/riscv/kvm/vcpu_sbi.c
> > > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > > @@ -1,5 +1,5 @@
> > >  // SPDX-License-Identifier: GPL-2.0
> > > -/**
> > > +/*
> > >   * Copyright (c) 2019 Western Digital Corporation or its affiliates.
> > >   *
> > >   * Authors:
> >
> > This got already fixed by [0]
> > commit 0e2e64192100 ("riscv: kvm: fix non-kernel-doc comment block")
> > so this patch doesn't apply cleanly anymore.
>
> hmm, just found Anup's "I've queued this..." message after
> writing my reply, so scratch the above ;-) .
>
> @Anup: I've looked at git.kernel.org but didn't find a tree
> there, can you tell me where this did go to?

All queued patches are in riscv_kvm_queue branch of
the KVM RISC-V tree at https://github.com/kvm-riscv/linux.git

Regards,
Anup

>
> Thanks
> Heiko
>
>

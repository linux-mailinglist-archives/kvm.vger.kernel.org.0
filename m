Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4095215122
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfEFQWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:22:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36839 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfEFQWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 12:22:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id 85so6701321pgc.3
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 09:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=40wSFiuSnxDz381aUfzuDl5Kav43yI7Ct1/keTyO3F8=;
        b=DVotpDP1BfYOu9EIG5sO2py/kG385U8+4RKehRk0tC71Vfe/y8Dohrbwudfghmv4gC
         V1LDKukVm8TPgSIGKPKH/+AzQnvMn07KhJn3HSkyadIn3jlSJ5ClUm6UwCAwkx5Lj2ec
         jTZ+KF06FbPmw0HHf3CBeQEfXVzStv1Mct1AUlW1wy4NJfE7vbBjZ0bMdocNxT2oB1CS
         9lHhKeWSjQzqoRHwiiBianLagL8GKIjs0O4OySI/oLm6QzImAzv5mMB4tTPiN7x1FtTU
         rnBUs5QzACe456XBtVa1RIzVbxerlIOvNFz0tCOCg55SYKbtj/SOkAkOVG3enaPf58Zc
         SNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=40wSFiuSnxDz381aUfzuDl5Kav43yI7Ct1/keTyO3F8=;
        b=dQZpgdlQLWZLFTXCpbxvWWpY7g2vdjTvM7SPR0pGCGq0uq5BSx8rXJXAK3kY7Z8zaL
         Kxa0r+jql2otDfnGE73xZe699xzKjmQUdTjBIXSG63mCgR11BGXGXZm4uD0U2FMID+vL
         nj8EJ6p56RfXCIZGoFYTQYskqc1quMkdeP3qVZjzRCSrxnS9WL1M76PUwW5sbxVaNvpi
         2GpUYX/RTdAeFn3+5sFcZu1vMvMasuIdzTM/Jtbtie6BTiSP6w2FgTB4bvv+b+upxFGP
         xfsqJyOgZOJ8WZPaLQOK1T9jm3WBocsyWb8Qc6f5nRKkhUSKLfHw7Z8Z63qKMyJN5KKG
         oHOg==
X-Gm-Message-State: APjAAAVUlFTssft3oLZ5USjZJdA5Rk+tWkgc4XLNTpYIHBI5IpTek1wh
        mHpyz6TXkJEtzvD0Bl39oK14PVczfqHJD9UvEHhvaw==
X-Google-Smtp-Source: APXvYqw0KbWeRobzhAngWvuw0v+iBDWRKwDC2xGNXHO8L4kdi1iOFuLP64D72WK0vtdzu/2x0qr2r6kf9SEmu6uA3nY=
X-Received: by 2002:aa7:90ce:: with SMTP id k14mr30343128pfk.239.1557159727868;
 Mon, 06 May 2019 09:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1556630205.git.andreyknvl@google.com> <05c0c078b8b5984af4cc3b105a58c711dcd83342.1556630205.git.andreyknvl@google.com>
 <20190503170310.GL55449@arrakis.emea.arm.com>
In-Reply-To: <20190503170310.GL55449@arrakis.emea.arm.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 6 May 2019 18:21:56 +0200
Message-ID: <CAAeHK+weVYv4Tgj8DXv0ZTFZzGEpLYsn-3wxxmQN+ZW88MXbMw@mail.gmail.com>
Subject: Re: [PATCH v14 13/17] IB/mlx4, arm64: untag user pointers in mlx4_get_umem_mr
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        kvm@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>, Kuehling@google.com,
        Felix <Felix.Kuehling@amd.com>, Deucher@google.com,
        Alexander <Alexander.Deucher@amd.com>, Koenig@google.com,
        Christian <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Chintan Pandya <cpandya@codeaurora.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Leon Romanovsky <leonro@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 3, 2019 at 7:03 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Apr 30, 2019 at 03:25:09PM +0200, Andrey Konovalov wrote:
> > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > pass tagged user pointers (with the top byte set to something else other
> > than 0x00) as syscall arguments.
> >
> > mlx4_get_umem_mr() uses provided user pointers for vma lookups, which can
> > only by done with untagged pointers.
> >
> > Untag user pointers in this function.
> >
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/infiniband/hw/mlx4/mr.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
> > index 395379a480cb..9a35ed2c6a6f 100644
> > --- a/drivers/infiniband/hw/mlx4/mr.c
> > +++ b/drivers/infiniband/hw/mlx4/mr.c
> > @@ -378,6 +378,7 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
> >        * again
> >        */
> >       if (!ib_access_writable(access_flags)) {
> > +             unsigned long untagged_start = untagged_addr(start);
> >               struct vm_area_struct *vma;
> >
> >               down_read(&current->mm->mmap_sem);
> > @@ -386,9 +387,9 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
> >                * cover the memory, but for now it requires a single vma to
> >                * entirely cover the MR to support RO mappings.
> >                */
> > -             vma = find_vma(current->mm, start);
> > -             if (vma && vma->vm_end >= start + length &&
> > -                 vma->vm_start <= start) {
> > +             vma = find_vma(current->mm, untagged_start);
> > +             if (vma && vma->vm_end >= untagged_start + length &&
> > +                 vma->vm_start <= untagged_start) {
> >                       if (vma->vm_flags & VM_WRITE)
> >                               access_flags |= IB_ACCESS_LOCAL_WRITE;
> >               } else {
>
> Discussion ongoing on the previous version of the patch but I'm more
> inclined to do this in ib_uverbs_(re)reg_mr() on cmd.start.

OK, I want to publish v15 sooner to fix the issue with emails
addresses, so I'll implement this approach there for now.



>
> --
> Catalin

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C96553C3C9
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 06:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbiFCEdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 00:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiFCEdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 00:33:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29443617D
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 21:33:13 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t6so8876443wra.4
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 21:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vD4OLfKIFfGtPa5y0jFVwdykOdv+Mnr0Uixx1FpZoy0=;
        b=yU/SgzSBAt1nzCv+gtsQNekuiPdjc7en8Za9CNTL+CXMx+z1HaYPZjPlIpqzf5rIlg
         cao9VPP6LfSHgTMgw3UZopSsoOgZQnYAPvnLEPez95+7+vUHCdbZLwoaMqIOfvZN/CNO
         W9qHVGZPGJGLpXImyr0XPjtFB0u0MBd5lBU8/3Trugv5obA4YQxLackcJW8QS5vTrSXs
         24EGlZZmaokB5XPj5tviqqAaOjogoR9AJTfM1FQQ0ewV9gkCw9ysoTgVq9ZOCkLH8DAa
         iGu6a1c0Rbe7onMz5grzmI1C9A5OZaPs5vdn1H84YoLg/yRQNJVUilWrbIj/mDa0vpZB
         0k0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vD4OLfKIFfGtPa5y0jFVwdykOdv+Mnr0Uixx1FpZoy0=;
        b=kZ33XzfbGORw+T6yZuSizMFew0JxzIqEoQrMJNOL1V/ND1xPqfXiQQ60kAq7/FY5C8
         lAfRCRi0Za1UgELHCrus1a2gbJ4z7M/2uM8UEMY0TKtpIHcsYC2lsYuIOL59yqW/ugGu
         tR2NPNlQLeGym+4OQLWy84w+INWwQBHyy1dsx+Eborp5Dh0xMAQoUf1lsMhX3WBPWguE
         XLVQeOG+LUTmNy0I0HSvcj34tt1Hb2/mGo18lDz4wb9hcGIVq6Uu+4Q3OUDy1VkYxoxO
         QeGQMaBmqGLd045CBT/ltRbIs89Lj2H975TBciSAu3cglsC+PbVLWROxCIquVX5Ik9jP
         WQCg==
X-Gm-Message-State: AOAM530ql3qAkarSd7G2jAYfOYg6qgSj473KG1NyfmLaRWqCFFBfYZls
        SgdBAP81tzNHuz9bosw4QWGf/+mYgPoqBm2+zzkQ1w==
X-Google-Smtp-Source: ABdhPJwt7W+KX4MtCMg6NzWsDLRyzubaw5RShkTBjOfLyk3i7t5J1gsnfZjgOrEkIxeXfFUcKMzwahlSWGkcgBksuGc=
X-Received: by 2002:a05:6000:1f18:b0:20f:e61b:520e with SMTP id
 bv24-20020a0560001f1800b0020fe61b520emr6348325wrb.214.1654230792135; Thu, 02
 Jun 2022 21:33:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220430191122.8667-6-Julia.Lawall@inria.fr> <mhng-523319d8-fda9-4737-9c43-d54bcfd7a7f2@palmer-ri-x1c9>
In-Reply-To: <mhng-523319d8-fda9-4737-9c43-d54bcfd7a7f2@palmer-ri-x1c9>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Jun 2022 10:03:00 +0530
Message-ID: <CAAhSdy3+imWabbArUAg0Bki3qvD1PGVB-L-xY5CvNa_YBu80aA@mail.gmail.com>
Subject: Re: (RISC-V KVM) Re: [PATCH] RISC-V: fix typos in comments
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Julia Lawall <Julia.Lawall@inria.fr>,
        kernel-janitors@vger.kernel.org,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 2, 2022 at 9:56 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Sat, 30 Apr 2022 12:11:20 PDT (-0700), Julia.Lawall@inria.fr wrote:
> > Various spelling mistakes in comments.
> > Detected with the help of Coccinelle.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> >
> > ---
> >  arch/riscv/kvm/vmid.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> > index 2fa4f7b1813d..4a2178c60b5d 100644
> > --- a/arch/riscv/kvm/vmid.c
> > +++ b/arch/riscv/kvm/vmid.c
> > @@ -92,7 +92,7 @@ void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
> >                * We ran out of VMIDs so we increment vmid_version and
> >                * start assigning VMIDs from 1.
> >                *
> > -              * This also means existing VMIDs assignement to all Guest
> > +              * This also means existing VMIDs assignment to all Guest
> >                * instances is invalid and we have force VMID re-assignement
> >                * for all Guest instances. The Guest instances that were not
> >                * running will automatically pick-up new VMIDs because will
>
> Anup: I'm guessing you didn't see this because it didn't have KVM in the
> subject?
>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>
> if that helps any, I don't see in anywhere but not sure if I'm just
> missing it.

Thanks Palmer, I had already planned to pick this as a RC fix for 5.19
but I forgot to reply here.

Regards,
Anup

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D23B468238
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 05:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377070AbhLDEM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 23:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242844AbhLDEM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 23:12:58 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4428BC061354
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 20:09:33 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id i12so3892966wmq.4
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 20:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4tpeccUSJsSvJStEMWbp4Kpifv0i5piggQ5Q0bjyTPA=;
        b=lQqC1ucSfqkj6ErW6i6uVxmWz2Ddcj3w7qmEBbovctdRbp6rkD8Isid4VbPDf/gYRB
         S4fALxLnn2HH2WUSaWcfzPi0Bcp1APHkcJDJQmWE9mZc0+cQiA/JFjYcw3fWKFMQm6AQ
         kNl1YijqrzJcfR+rs72T/qAn54aVsry59XOHTvSO5fWlaBoeGC0tBvrwef0jF+nJ9wLO
         JFmgqQKq0IGiXBVXJCvSuO53PAu+MYoVl4QbB2dzlP/QMviEzORW+TiHHpZ4riRf/Ro2
         k5LzXNu9OT1TxUb6voyzJ4mqBSupe9ggvCUnzvNZqCvfmDqpfT5oMgAtUHbG0L2iBUWh
         pRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4tpeccUSJsSvJStEMWbp4Kpifv0i5piggQ5Q0bjyTPA=;
        b=FrfHJgf6IzO6enGiE2TLBtFkr8BHJfmXFtlI41r2ZIukDMPyxJXSWj0GpmFHKzRilq
         VKoUwgPv6Pps+QS8fJ5VTrrZeeSsXwBjEx98S0a+dMkNo22ACWcjQ+wtgoMK06bQ7Tby
         oGJ+1Om/oH4Z5dpuQzKvcayVKQBS3qPlfdl0I740ILqOv+rRqZQm99fVFVR03Uk1D8c9
         Ue8hbWR+uzhX57xW64EVxDOLszTO9jDm+Dxm7Gg8j9IMkTxO8Cz3P/vrWbVUf5SOF4SB
         8WC0d1KWxts1+NlI1cOg/ibo9MJKB1ZdXo+bxTk23upMMo7uQn+Urc+VdjHe8ghVXe3t
         uWlQ==
X-Gm-Message-State: AOAM531U2jVk2QS3XSFZUdvara3kYP9eik4//1ast28sDnlwhW7aArCp
        W2qtc/eK5tEK2tJ+dRORG7yvX0iMPUUD6uW1D0rA3Q==
X-Google-Smtp-Source: ABdhPJw51KWA7sJPb31HUd4HOH4EkxzkMBiXdbkuk+r3buWjXUnh3vSsgBHiqTq5ETSkoyKshmo70CmljLiANghRt8w=
X-Received: by 2002:a7b:c256:: with SMTP id b22mr20250612wmj.176.1638590971589;
 Fri, 03 Dec 2021 20:09:31 -0800 (PST)
MIME-Version: 1.0
References: <20211202235823.1926970-1-atishp@atishpatra.org> <f63e9f1b-4b8e-6c3e-8e21-f9a5f97ca17d@arm.com>
In-Reply-To: <f63e9f1b-4b8e-6c3e-8e21-f9a5f97ca17d@arm.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 4 Dec 2021 09:39:20 +0530
Message-ID: <CAAhSdy2xRwUmdi7Kc7ZokgB5W1LWKZ7YU-doHZ5dfaVKvzRdUg@mail.gmail.com>
Subject: Re: [PATCH v3] MAINTAINERS: Update Atish's email address
To:     Steven Price <steven.price@arm.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 3, 2021 at 9:40 PM Steven Price <steven.price@arm.com> wrote:
>
> On 02/12/2021 23:58, Atish Patra wrote:
> > I am no longer employed by western digital. Update my email address to
> > personal one and add entries to .mailmap as well.
> >
> > Signed-off-by: Atish Patra <atishp@atishpatra.org>
> > ---
> >  .mailmap    | 1 +
> >  MAINTAINERS | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/.mailmap b/.mailmap
> > index 6277bb27b4bf..23f6b0a60adf 100644
> > --- a/.mailmap
> > +++ b/.mailmap
> > @@ -50,6 +50,7 @@ Archit Taneja <archit@ti.com>
> >  Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
> >  Arnaud Patard <arnaud.patard@rtp-net.org>
> >  Arnd Bergmann <arnd@arndb.de>
> > +Atish Patra <atishp@atishpatra.org> <atish.patra@wdc.com> <atishp@rivosinc.com>
>
> I don't think this does what you expect. You can't list more than one
> email address to replace on the same line. You can use the command "git
> check-mailmap" to test what happens, e.g. with this change applied:
>
>   $ git check-mailmap "<atishp@rivosinc.com>"
>   <atishp@rivosinc.com>
>   $ git check-mailmap "<atish.patra@wdc.com>"
>   Atish Patra <atishp@atishpatra.org>
>   $ git check-mailmap "<atishp@atishpatra.org>"
>   <atishp@atishpatra.org>
>
> So only your @wdc.com address is translated. If you want to translate
> the @rivosinc.com address as well you need a second line. As the file says:

Thanks Steve for noticing this. Even, I realized this while queuing the patch.

I have removed @rivosinc.com email address from the patch in my queue. I
believe Atish currently uses both personal and @rivosinc.com email addresses
on LKML.

Refer,
https://github.com/kvm-riscv/linux/commit/2255b100410179bb8151e99e8396debddea0ef1d
https://github.com/kvm-riscv/linux/commits/riscv_kvm_queue

Regards,
Anup

>
> # For format details, see "MAPPING AUTHORS" in "man git-shortlog".
>
> Steve
>
> >  Axel Dyks <xl@xlsigned.net>
> >  Axel Lin <axel.lin@gmail.com>
> >  Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5250298d2817..6c2a34da0314 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10434,7 +10434,7 @@ F:    arch/powerpc/kvm/
> >
> >  KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
> >  M:   Anup Patel <anup.patel@wdc.com>
> > -R:   Atish Patra <atish.patra@wdc.com>
> > +R:   Atish Patra <atishp@atishpatra.org>
> >  L:   kvm@vger.kernel.org
> >  L:   kvm-riscv@lists.infradead.org
> >  L:   linux-riscv@lists.infradead.org
> >
>

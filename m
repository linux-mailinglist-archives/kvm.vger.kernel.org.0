Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAE777056
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbfGZRel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 13:34:41 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:40762 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387653AbfGZRel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 13:34:41 -0400
Received: by mail-io1-f42.google.com with SMTP id h6so19855266iom.7
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 10:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VM6QcyYtmoUIAEEgaIXBG1Y50lo7oqpYxWqPVuZTL/s=;
        b=UlYOcPWlY1WKThR2wj1Iy0fYhf2mjYbhXFBuUDgvO05h/XPVOFYRk7OfuB0q4sT4b+
         8HScZWyXhq0CisCvne+2mWdo3zwz1LKcimOPuPh7FbmckiAPTEg5kAxNj3OSl+NCXMhz
         69pjuOmMUPcaLNT0VZf/i/J/f+IGxhKCalN3R8hDii2pGe6S9J9B80g1G1VxnFz60OWr
         Od0dKTm+tyCOSdizOVNujeWqiM2ODh3TYsT/zlpA07MVYL1Pmq69A+el3Z9QzNW4CPA7
         o/Z44u8Cj/tPuEOBTGFMA9Vr0zPR9CtI9Wri8twz8Zihr3GJPviU7yquHkW7qKeWttl/
         PNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VM6QcyYtmoUIAEEgaIXBG1Y50lo7oqpYxWqPVuZTL/s=;
        b=H7zfghXaALnB56CNASpYS1GxVbm9v3LEsTtOT++pRFHiYx8X/0spgjrRjofBAZA0Hs
         hdA9qrDzK6Sg91RKqR8f+jVUKSrI8X4xWyemq2U0NvAFWHVDHuO1nIiKrkEYMuGFz0bU
         DauZErwR4MG49xk/HqV4dtyX/GMHb9XHKoSJ6SkIiQPLlrvYLs90d5hEMOcIMNDWcHQX
         0CsrK6kzNVERV/xodaQ9YmVluB1iUrtfLp/yGQiQeLi0drYNU5mUqmb1UbXMqy/DMq4T
         KOFvmnJtmJh9zFBJPLcNCdAp0+PNPAW4mXiOLyPG+DcUf4JAGvj/yCG1G1LZuITo0YN/
         9cjg==
X-Gm-Message-State: APjAAAXcSONU354MHZ6KRy8ltLFDWjiL3mMhKwnxzZFKiIRSdezP3vLC
        5fJDCRtfWQJQ3NdZa+vPZj+ok0ZRvaqTzzQoqHhT99TIx0E=
X-Google-Smtp-Source: APXvYqwiwWCKCBFe1bVrTLFie7EBzPHidQ85JUlt7Ai07XeVAqAluBYUS86aZ7d0XIBIlJ/Pd352rJW212f1GOzUsew=
X-Received: by 2002:a6b:f80b:: with SMTP id o11mr80569544ioh.40.1564162480574;
 Fri, 26 Jul 2019 10:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eSYQGy4ZEXtO92zr-NG5cvDdA4qK+PzqbzwFP3TU-=hGg@mail.gmail.com>
 <C3CF882E-C7B4-459B-A3A3-25C5E453C512@oracle.com>
In-Reply-To: <C3CF882E-C7B4-459B-A3A3-25C5E453C512@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 26 Jul 2019 10:34:29 -0700
Message-ID: <CALMp9eSbX8orxJkJ8f2aGX5DJ2FbB6nu60TeVz-0GuRpcQDwxQ@mail.gmail.com>
Subject: Re: Intercepting MOV to/from CR3 when using EPT
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ah. That makes sense! I should have looked at the call stack.

Thanks!

On Fri, Jul 26, 2019 at 10:32 AM Liran Alon <liran.alon@oracle.com> wrote:
>
>
> > On 26 Jul 2019, at 20:22, Jim Mattson <jmattson@google.com> wrote:
> >
> > When using EPT, why does kvm intercept MOV to/from CR3 when paging is
> > disabled in the guest? It doesn't seem necessary to me, but perhaps I
> > am missing something.
> >
> > I'm referring to this code in ept_update_paging_mode_cr0():
> >
> > exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
> > CPU_BASED_CR3_STORE_EXITING);
> >
> > Thanks!
>
> Note that ept_update_paging_mode_cr0() is called only in case (enable_ept=
 && !enable_unrestricted_guest).
> Even though function name doesn=E2=80=99t imply this=E2=80=A6
>
> When unrestricted-guest is not enabled, KVM runs a vCPU with paging disab=
led, with paging enabled in VMCS and CR3 of ept_identity_map_addr.
> See how it is initialised at init_rmode_identity_map().
>
> -Liran
>

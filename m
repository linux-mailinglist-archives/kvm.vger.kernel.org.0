Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7048B17C09B
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 15:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgCFOnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 09:43:10 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40215 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbgCFOnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 09:43:09 -0500
Received: by mail-lf1-f68.google.com with SMTP id p5so2106783lfc.7;
        Fri, 06 Mar 2020 06:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o3DVrX7dUQC3QbATMcETpnI+Z1HuqofnTymVGHpuzYY=;
        b=EzhkDARjUonOmJKZoBakTmmlGVDqNwzGwuuQy1BwfgVX1ZPNyRN5CkIAkTQ+F7vec9
         MkLjHlk+N1stZU4cVrxU/yj/oMih/909riqXGFFYvoGSWTlUY5Yb8eNM+Sr9i3xNwSJV
         paRrBnSAYwW1P80pEsG1bz+cmroutc329rCzWAKM/BNL9Eo47fQmBwk1i9hiSI7/AJdq
         7cikL7nijfYad/JHCVfJGue/VCN+t28u0MdKp22DRF5Hz6ckdTa2IXm0rIiUQm7Fb0rj
         /Qe9b6vhn+XrGqrE+od5CYKWBekJMAMO+OSFa3wQ24ycxxUh25Fe10dA+aQ201YZXCTX
         iPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o3DVrX7dUQC3QbATMcETpnI+Z1HuqofnTymVGHpuzYY=;
        b=Gdey5uVXO6lyOBET/CiCmeSeEntcRdkNvkeZ3ILGhq8Cg72Y2zFpbRwBnh2XAlVoQO
         GzhgWZROA7jlu372eIjyod+nTr8UKxkjw17RB7UbtV+AiqVTJLWyDN+lFfbmlbXAJDHi
         Ta9J73OpQgjT8QxbiScIpsg4tZTyXsA1VMFq8QAzNagFYo5qYMAmNAbVE9NpJgiaUSt8
         +xi1XZbZBlm8j2n4YgtSgyzqH19CNAUGuMllMFIIPujS3fayE7cBf4sWhlrJxn2PcA+L
         hX1oThehlSnHvSGDh+ybpLg7po4NAgcK1tUPfIxEe9r7hlI06a6XK7lK1fZv+OM+Hnam
         ZUrg==
X-Gm-Message-State: ANhLgQ0p6XYtaKo6kRkX5HaTouKbOPpuMT2vBj6JUKYUe36AMuSh+aMo
        kDAbxkMRfdelBglmfOwluQcOR8PCGTLdWfxxTgs=
X-Google-Smtp-Source: ADFU+vtgJtFcdoBBGOREy3c0wSP0h7mwVRGzOddZ4+/os0YZq+NZJqsqxRhrORPMro+0YFi++XxBHND5tERQDnkkBRY=
X-Received: by 2002:a19:f507:: with SMTP id j7mr2186508lfb.161.1583505787299;
 Fri, 06 Mar 2020 06:43:07 -0800 (PST)
MIME-Version: 1.0
References: <20200305140142.413220-1-arilou@gmail.com> <20200305140142.413220-2-arilou@gmail.com>
 <09762184-9913-d334-0a33-b76d153bc371@redhat.com> <CAP7QCoj9=mZCWdiOa92QP9Fjb=p3DfKTs0xHKZYQ+yRiMabmLA@mail.gmail.com>
 <0edfee0e-01ee-bb62-5fc5-67d7d45ec192@redhat.com> <87ftelepwz.fsf@vitty.brq.redhat.com>
In-Reply-To: <87ftelepwz.fsf@vitty.brq.redhat.com>
From:   Jon Doron <arilou@gmail.com>
Date:   Fri, 6 Mar 2020 16:42:55 +0200
Message-ID: <CAP7QCoiqjtpmMwo_P17pzNg5wP=6MaCRw7_TLu6GPQHH1XVT0g@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] x86/kvm/hyper-v: Align the hcall param for kvm_hyperv_exit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Vitaly and Paoloo I'll fix the 1st patch and wait for the final
review on the other 3 and submit v3, I'll also look into adding
the proper test for the Hypercall patch to
https://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git, and submit
a separate patch
to that repository.

Thanks,
-- Jon.

On Fri, Mar 6, 2020 at 12:30 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Paolo Bonzini <pbonzini@redhat.com> writes:
>
> > On 05/03/20 15:53, Jon Doron wrote:
> >> Vitaly recommended we will align the struct to 64bit...
> >
> > Oh, then I think you actually should add a padding after "__u32 type;"
> > and "__u32 msr;" if you want to make it explicit.  The patch, as is, is
> > not aligning anything, hence my confusion.
> >
>
> Right,
>
> the problem I tried to highlight is that without propper padding ABI may
> change, e.g.
>
> #include <stdio.h>
> #include <stdint.h>
> #include <stddef.h>
>
> #define __u32 uint32_t
> #define __u64 uint64_t
>
> struct kvm_hyperv_exit {
>         __u32 type;
>         union {
>                 struct {
>                         __u32 msr;
>                         __u64 control;
>                         __u64 evt_page;
>                         __u64 msg_page;
>                 } synic;
>                 struct {
>                         __u64 input;
>                         __u64 result;
>                         __u64 params[2];
>                 } hcall;
>         } u;
> };
>
> int main() {
>         printf("%d\n", offsetof(struct kvm_hyperv_exit, u.synic.control));
>         printf("%d\n", offsetof(struct kvm_hyperv_exit, u.hcall.input));
>
>         return 0;
> }
>
> $ gcc -m32 1.c -o 1
> $ ./1
> 8
> 4
>
> $ gcc 1.c -o 1
> $ ./1
> 16
> 8
>
> if we add a padding after 'type' and 'msr' we'll get
> $ gcc -m32 1.c -o 1
> $ ./1
> 16
> 8
>
> $ gcc 1.c -o 1
> $ ./1
> 16
> 8
>
> which is much better. Technically, this is an ABI change on 32 bit but
> I'm pretty sure noone cares (famous last words!).
>
> --
> Vitaly
>

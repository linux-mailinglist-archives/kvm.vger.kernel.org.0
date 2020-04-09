Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3151A36EC
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgDIPXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:23:01 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37402 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgDIPXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 11:23:00 -0400
Received: by mail-ot1-f67.google.com with SMTP id g23so10862533otq.4
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 08:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vgEQvvnJoquOGzGtJREDN5USMlXV+4P/x5EsAI2d6zc=;
        b=CSr6492WZ0/6vPLAPxMxzzM42U3DllbebcNqQ2ZLUGYDbje3VkNh4OEX3PKcco5B1F
         aI5WZ1HGy0kwZiRNxRMKr37ICaRvMivASl1MFsOYI14Qf40WnLlZweFp9W48x2aY/xrC
         yDPoLUnRJbZ6z2Yomz6ryfKpgh4tfDtNMBIGNK87M6eKxZguH5o35TjaH+OY4XoyTXF6
         sBhzDw2qyzpKTyA6MPpGPJrIOS550tOA88yblwbGi4ocFCLFYhJHvMyttn6ejkiwOtJ0
         gVOvke+jeOVJk8pYuWmUx1Hhrc7d5VLtkcsOTehiL1El13AoS5GxnPkMaCmQjAosKxUK
         5N6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vgEQvvnJoquOGzGtJREDN5USMlXV+4P/x5EsAI2d6zc=;
        b=W4PHUspW+0BznVgsY1fhROmBqZaftwOo4alsrCak6HsxuOkfUIsUDUbecuMz8LLwJc
         IEiie1Ji7UIz/Q8f15riU8yqgbJ2UIPjz+3akDS3ELB26wi/rhWhDWEGxeA1e2zI9x5R
         7xKIE6+If9daPaA5cGPqnJOb1pglSY/4DZWbQ+Ts/5LWx23gmMhC0IRd4TW5gG/Wldnm
         3zhpWMB9ZVRyBzrsMNVcoFSySel1Udew3vI20PXDIX5J2puWaRrlkHjpZ3VkdbCn3c4K
         xOu/A3DTq91qy5+4wsp4V6e7GycZUHWYFol9ZggF1darvg/1IeLO+1teh6pdRaShyA6k
         9rVQ==
X-Gm-Message-State: AGi0PuZ1tvBgkTyEnNzy5r2GwZokkj6lSTe0z+xmXzdMMI4Ybz1E4kyI
        KvHIgOrFlA8aU41YTssVIHOhZaWNQ+eT3D/8MUG1mQ==
X-Google-Smtp-Source: APiQypJRkHrtZ8xwgQFQh9fHwNPp224Z1VyW2q4b6zJ+iuZEnRKzEYEnYhRknJcPEh3e5cefJZ0fSxfOHXfJZc8R124=
X-Received: by 2002:a4a:d516:: with SMTP id m22mr355695oos.72.1586445779925;
 Thu, 09 Apr 2020 08:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw> <fb39d3d2-063e-b828-af1c-01f91d9be31c@redhat.com>
 <017E692B-4791-46AD-B9ED-25B887ECB56B@lca.pw> <CANpmjNMiHNVh3BVxZUqNo4jW3DPjoQPrn-KEmAJRtSYORuryEA@mail.gmail.com>
 <B7F7F73E-EE27-48F4-A5D0-EBB29292913E@lca.pw>
In-Reply-To: <B7F7F73E-EE27-48F4-A5D0-EBB29292913E@lca.pw>
From:   Marco Elver <elver@google.com>
Date:   Thu, 9 Apr 2020 17:22:48 +0200
Message-ID: <CANpmjNMEgc=+bLU472jy37hYPYo5_c+Kbyti8-mubPsEGBrm3A@mail.gmail.com>
Subject: Re: KCSAN + KVM = host reset
To:     Qian Cai <cai@lca.pw>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Apr 2020 at 17:10, Qian Cai <cai@lca.pw> wrote:
>
>
>
> > On Apr 9, 2020, at 3:03 AM, Marco Elver <elver@google.com> wrote:
> >
> > On Wed, 8 Apr 2020 at 23:29, Qian Cai <cai@lca.pw> wrote:
> >>
> >>
> >>
> >>> On Apr 8, 2020, at 5:25 PM, Paolo Bonzini <pbonzini@redhat.com> wrote=
:
> >>>
> >>> On 08/04/20 22:59, Qian Cai wrote:
> >>>> Running a simple thing on this AMD host would trigger a reset right =
away.
> >>>> Unselect KCSAN kconfig makes everything work fine (the host would al=
so
> >>>> reset If only "echo off > /sys/kernel/debug/kcsan=E2=80=9D before ru=
nning qemu-kvm).
> >>>
> >>> Is this a regression or something you've just started to play with?  =
(If
> >>> anything, the assembly language conversion of the AMD world switch th=
at
> >>> is in linux-next could have reduced the likelihood of such a failure,
> >>> not increased it).
> >>
> >> I don=E2=80=99t remember I had tried this combination before, so don=
=E2=80=99t know if it is a
> >> regression or not.
> >
> > What happens with KASAN? My guess is that, since it also happens with
> > "off", something that should not be instrumented is being
> > instrumented.
>
> No, KASAN + KVM works fine.
>
> >
> > What happens if you put a 'KCSAN_SANITIZE :=3D n' into
> > arch/x86/kvm/Makefile? Since it's hard for me to reproduce on this
>
> Yes, that works, but this below alone does not work,
>
> KCSAN_SANITIZE_kvm-amd.o :=3D n

There are some other files as well, that you could try until you hit
the right one.

But since this is in arch, 'KCSAN_SANITIZE :=3D n' wouldn't be too bad
for now. If you can't narrow it down further, do you want to send a
patch?

Thanks,
-- Marco

> I have been able to reproduce this on a few AMD hosts.
>
> > exact system, I'd ask you to narrow it down by placing 'KCSAN_SANITIZE
> > :=3D n' into suspect subsystems' Makefiles. Once you get it to work wit=
h
> > that, we can refine the solution.
> >
> > Thanks,
> > -- Marco
>

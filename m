Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0415C1A37AE
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgDIQDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 12:03:23 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44601 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgDIQDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 12:03:22 -0400
Received: by mail-oi1-f194.google.com with SMTP id o25so274249oic.11
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 09:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tjHIQBCBSrHwNHPc99hMBF0pIDG2KesjmgOXuqoKDMM=;
        b=hTXModHkfdlX4RpWCP0A8PlGie48zk3lgc/GhvV68BZ/2aFTULVRTRqzfiLrEzbp0c
         ZKAIlsAUDMHBfH+Tm+tEkVwivavdnnnUlzWGkKC0h8JWKx2uSLpFCRwppcZoCtGZa/HD
         u2R43yOje8QjZT6SEJmT7a2S8n+s65ArUAGaee5e4pAjrqJwPswZWhJPtmiOYFl8b/TM
         /rzlesPZIDJRpWedg4VX6ouyELcid/NqcHPreWZWu6uj6TAg5nCUYfwqVRXU+zx+sIq2
         gT8LaiWk7S2hJJD3820Bmji/zmlOnTznAOc14FpxaXSXfraYIEA9ZrEmwkkYmGLA9R2c
         u1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tjHIQBCBSrHwNHPc99hMBF0pIDG2KesjmgOXuqoKDMM=;
        b=I10iaQASiyD+sj1/ECzX5o9YsTw7uJUUiSg0mGf7ptx4vSeM2iVlBp3giJagZCCP0c
         aOOfi+B0eYOROYX8HUGbPH2ie14tjUZJkQKoK+txwgWO3tphLdtdqzKHhdaKnItm06om
         ag9KrPagIRPdOFpOuOeGTBsXBbyQ+57pnONVWRHK6GuEvwysL0IdElWHjmVixAGOYnoQ
         ODGtDLOhlMEB6qEG2IML/EOwZeE5mVxPMe8nWtpZK4jHnhrL+TC0ABmwgQbnkyOqqaAt
         FTv4DWgcoXKJa22aTirgDmLwbIT1wDgyT8tx7/xQnK0zOms6Qx27Myy4jQV3Tu/+IhGw
         l21Q==
X-Gm-Message-State: AGi0PuZkGzEreszJmQqZ7Xk3JTWbBX6WmusSZLvO1V5I4jpCf85OjTZI
        W8iEi7an5mZqBxyaawjzOgkw20KAu0ofYzk93sBSSQ==
X-Google-Smtp-Source: APiQypKFcY0QZIxSnMvqOumGL+bCUZQWyP22MGaxw3k465l/nIpOkbNXdj9LwkwU0lNfgWhrUjuExNoRAwBspu6AUvw=
X-Received: by 2002:aca:620a:: with SMTP id w10mr1792454oib.121.1586448202131;
 Thu, 09 Apr 2020 09:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw> <fb39d3d2-063e-b828-af1c-01f91d9be31c@redhat.com>
 <017E692B-4791-46AD-B9ED-25B887ECB56B@lca.pw> <CANpmjNMiHNVh3BVxZUqNo4jW3DPjoQPrn-KEmAJRtSYORuryEA@mail.gmail.com>
 <B7F7F73E-EE27-48F4-A5D0-EBB29292913E@lca.pw> <CANpmjNMEgc=+bLU472jy37hYPYo5_c+Kbyti8-mubPsEGBrm3A@mail.gmail.com>
 <2730C0CC-B8B5-4A65-A4ED-9DFAAE158AA6@lca.pw>
In-Reply-To: <2730C0CC-B8B5-4A65-A4ED-9DFAAE158AA6@lca.pw>
From:   Marco Elver <elver@google.com>
Date:   Thu, 9 Apr 2020 18:03:10 +0200
Message-ID: <CANpmjNNUn9_Q30CSeqbU_TNvaYrMqwXkKCA23xO4ZLr2zO0w9Q@mail.gmail.com>
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

On Thu, 9 Apr 2020 at 17:30, Qian Cai <cai@lca.pw> wrote:
>
>
>
> > On Apr 9, 2020, at 11:22 AM, Marco Elver <elver@google.com> wrote:
> >
> > On Thu, 9 Apr 2020 at 17:10, Qian Cai <cai@lca.pw> wrote:
> >>
> >>
> >>
> >>> On Apr 9, 2020, at 3:03 AM, Marco Elver <elver@google.com> wrote:
> >>>
> >>> On Wed, 8 Apr 2020 at 23:29, Qian Cai <cai@lca.pw> wrote:
> >>>>
> >>>>
> >>>>
> >>>>> On Apr 8, 2020, at 5:25 PM, Paolo Bonzini <pbonzini@redhat.com> wro=
te:
> >>>>>
> >>>>> On 08/04/20 22:59, Qian Cai wrote:
> >>>>>> Running a simple thing on this AMD host would trigger a reset righ=
t away.
> >>>>>> Unselect KCSAN kconfig makes everything work fine (the host would =
also
> >>>>>> reset If only "echo off > /sys/kernel/debug/kcsan=E2=80=9D before =
running qemu-kvm).
> >>>>>
> >>>>> Is this a regression or something you've just started to play with?=
  (If
> >>>>> anything, the assembly language conversion of the AMD world switch =
that
> >>>>> is in linux-next could have reduced the likelihood of such a failur=
e,
> >>>>> not increased it).
> >>>>
> >>>> I don=E2=80=99t remember I had tried this combination before, so don=
=E2=80=99t know if it is a
> >>>> regression or not.
> >>>
> >>> What happens with KASAN? My guess is that, since it also happens with
> >>> "off", something that should not be instrumented is being
> >>> instrumented.
> >>
> >> No, KASAN + KVM works fine.
> >>
> >>>
> >>> What happens if you put a 'KCSAN_SANITIZE :=3D n' into
> >>> arch/x86/kvm/Makefile? Since it's hard for me to reproduce on this
> >>
> >> Yes, that works, but this below alone does not work,
> >>
> >> KCSAN_SANITIZE_kvm-amd.o :=3D n
> >
> > There are some other files as well, that you could try until you hit
> > the right one.
> >
> > But since this is in arch, 'KCSAN_SANITIZE :=3D n' wouldn't be too bad
> > for now. If you can't narrow it down further, do you want to send a
> > patch?
>
> No, that would be pretty bad because it will disable KCSAN for Intel
> KVM as well which is working perfectly fine right now. It is only AMD
> is broken.

Interesting. Unfortunately I don't have access to an AMD machine right now.

Actually I think it should be:

  KCSAN_SANITIZE_svm.o :=3D n
  KCSAN_SANITIZE_pmu_amd.o :=3D n

If you want to disable KCSAN for kvm-amd.

Thanks,
-- Marco

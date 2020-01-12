Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4575D1385B8
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2020 10:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732533AbgALJt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jan 2020 04:49:29 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45650 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732381AbgALJt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jan 2020 04:49:29 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so4692055lfa.12
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2020 01:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gFJu0ECQYPDpnOY6gf8MGQ1UvMvuAoTJib9HaOc9GXQ=;
        b=cpWz+GXZHIjC9AHIUR8spRUWa7LF2oEfJYja5QUKfDA21ScagU0gJWDXznfVZiwP6Z
         i6d7yYztKEm5VOY1zAobQ2PJP4wiIWY1CEej3HOp4jix6w1pSFWEGv0BuKmh4r2NssGI
         PtDNX3+KJ4aEG90UZ69Hnzs4K0UCR8MfW1mdhTYX1zYEJxcK6q/xcbAwWtd/zP4Q0yIq
         cv6Pxh1fbV6rOykH8J9ojGIERfWXdSBdwL32gKpqz5as5oBdrkTeGwwaIjinXMp4bPPC
         sdjqrdakNAec54187FCuKHuAOlQeghe2sbhPFS0d/7U717ljqVO9coZMakqNPQlycQ2f
         IEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gFJu0ECQYPDpnOY6gf8MGQ1UvMvuAoTJib9HaOc9GXQ=;
        b=FgHYvKqYX51eLXY4cRcTtniAk4K/96sCMsWlzcN8hS0zL4Y6+F6cK0E+TDI6drBp5f
         ACSs9foxUJI+Mc6Ng75w+/TnZjQJodgogwkTrlDbJGM4SSsRg3nsljUgLwUnE9KT/qyK
         DQTrD1YPoPErPycSx8kOjDIOuiPvryro1egYM9A+Stc2KwIj6W41ERQIKVMaLJbh0ASM
         /zrCACCmzIosj9cFTuEBKeFPwkZson+VzQ28RGQY+FhJAp+xpepmyYlMNiDwSOt8PC9L
         9FnsRIVymHMhGpLjikK71s64YxU3wvhN56IUzRJtHOqj/KZvdM+iL7kKpjeRXtBF42My
         oLXA==
X-Gm-Message-State: APjAAAV4XUivR931eq9ZfBCusA7RpoxRFdqRDaM31waj0ZjGce79i1CB
        HD2ZMlAEjjeFg5Sd6lBfxaYPXkyxAhdiJ/Pix0w=
X-Google-Smtp-Source: APXvYqyfFmBy6C5PIruqGp+b0n1EEL++TBcSqCFsy3+IrY7TEH59DfehfRjU5O3OcAzZPQfAAn/XJlYZmr09b0FcjY4=
X-Received: by 2002:ac2:4834:: with SMTP id 20mr6382556lft.166.1578822566702;
 Sun, 12 Jan 2020 01:49:26 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-11-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-11-philmd@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Sun, 12 Jan 2020 17:48:58 +0800
Message-ID: <CAKmqyKNrgTbiipNK1wrwCMqk_=7cJmc4rBwO1zxjFiVV+TRSgQ@mail.gmail.com>
Subject: Re: [PATCH 10/15] memory: Replace current_machine by qdev_get_machine()
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "open list:Overall" <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        "open list:New World" <qemu-ppc@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 9, 2020 at 11:29 PM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> As we want to remove the global current_machine,
> replace 'current_machine' by MACHINE(qdev_get_machine()).
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  memory.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/memory.c b/memory.c
> index d7b9bb6951..57e38b1f50 100644
> --- a/memory.c
> +++ b/memory.c
> @@ -3004,6 +3004,7 @@ static void mtree_print_flatview(gpointer key, gpoi=
nter value,
>      int n =3D view->nr;
>      int i;
>      AddressSpace *as;
> +    MachineState *ms;
>
>      qemu_printf("FlatView #%d\n", fvi->counter);
>      ++fvi->counter;
> @@ -3026,6 +3027,7 @@ static void mtree_print_flatview(gpointer key, gpoi=
nter value,
>          return;
>      }
>
> +    ms =3D MACHINE(qdev_get_machine());

Why not set this at the top?

Alistair

>      while (n--) {
>          mr =3D range->mr;
>          if (range->offset_in_region) {
> @@ -3057,7 +3059,7 @@ static void mtree_print_flatview(gpointer key, gpoi=
nter value,
>          if (fvi->ac) {
>              for (i =3D 0; i < fv_address_spaces->len; ++i) {
>                  as =3D g_array_index(fv_address_spaces, AddressSpace*, i=
);
> -                if (fvi->ac->has_memory(current_machine, as,
> +                if (fvi->ac->has_memory(ms, as,
>                                          int128_get64(range->addr.start),
>                                          MR_SIZE(range->addr.size) + 1)) =
{
>                      qemu_printf(" %s", fvi->ac->name);
> --
> 2.21.1
>
>

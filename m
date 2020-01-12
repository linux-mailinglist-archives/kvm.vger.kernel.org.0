Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647A71385B3
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2020 10:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732534AbgALJpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jan 2020 04:45:10 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35229 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732531AbgALJpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jan 2020 04:45:09 -0500
Received: by mail-lf1-f66.google.com with SMTP id 15so4727460lfr.2
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2020 01:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mvEyv8WsHK+y4lyiLI8T8Cwz0UxNsAP1n8oZu5GDpas=;
        b=EsExOqT+WaKoepgqT7oBU0FbwwVcObGIbJj0xCQa354MC9I0rlak12h/IOaCdVNjOM
         TS9B4peK4Wy1n3LNE7VUeZeAiNxuJMTDtOlZkmLlTMxebjdYlkuArnnwDHlyNP/IgbIY
         NE+3m9HIEl6y3exSWSEKN+obmsDn4n6eauER6SWszp2tmiqxez40m7fCaai4EScYBfzI
         CzshAOOXWob9ahNuiw+zOgiUw5FULJnXuY+LvF6XF9nIkmJCenbXBL9D1p8t4YMmXDdC
         hm93ccuX8jC1DQoRT3nOGwRFAxnKTMb6OsT7WPYMCJ9Rrtsmll0xv1zh+fKXXf/vNghk
         2iwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mvEyv8WsHK+y4lyiLI8T8Cwz0UxNsAP1n8oZu5GDpas=;
        b=W8x2KeZaVs+B50+ZOFghQqrqBaf/YQ8toV8QKWbvV61tNcgSnNsjfx2gUu7OjY0hWb
         3H1NxhoePFZmmr6vAtoOpk5B3axXyz/vavkwejO3waeb/bPeuPe2JiGICRQXatp7EZzx
         X/XRTuShhnmdIinZK11/KWv+Iq85igQK9NeZsg68l4oo8BJHHHdIirHKlPe1RSDnbZyL
         XYlsJWrwfdfAY/vHN3m3lPdkJMad0s3AWv69n+skmcA7F3hMjuc3ovVq1ndjKxepDF1d
         IKP0OWBjzzU24Jvhx+ZcLuDT/xPuepqh2YohnLb7xrQo7T69FR8J9KUT0uwHhV6iAlPs
         KMQg==
X-Gm-Message-State: APjAAAW39C1r1RIDpm9xsnXUvgCqX4b0YgggPxeQy4jOGonWtbnvqKBh
        wM4sG9GeYr2B0HgqRBsvsk4byQ14+w3eUk5J+wQ=
X-Google-Smtp-Source: APXvYqxBsmT3/S/ksEIf8xngcs0t6C+b9DJlHarA6JCrshF+M3Qvub4y4aPAefRQPsUZqr5EcjM401Rlfz38uhniS/w=
X-Received: by 2002:ac2:5498:: with SMTP id t24mr7132155lfk.84.1578822307837;
 Sun, 12 Jan 2020 01:45:07 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-8-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-8-philmd@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Sun, 12 Jan 2020 17:44:40 +0800
Message-ID: <CAKmqyKNbbkBeoVTfvyLt_krei-nCP_sGY_70GSiLFrQVOdd1Ag@mail.gmail.com>
Subject: Re: [PATCH 07/15] hw/core/machine-qmp-cmds: Replace current_machine
 by qdev_get_machine()
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

On Thu, Jan 9, 2020 at 11:30 PM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> As we want to remove the global current_machine,
> replace MACHINE_GET_CLASS(current_machine) by
> MACHINE_GET_CLASS(qdev_get_machine()).
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  hw/core/machine-qmp-cmds.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
> index eed5aeb2f7..5a04d00e4f 100644
> --- a/hw/core/machine-qmp-cmds.c
> +++ b/hw/core/machine-qmp-cmds.c
> @@ -280,9 +280,9 @@ void qmp_cpu_add(int64_t id, Error **errp)
>  {
>      MachineClass *mc;
>
> -    mc =3D MACHINE_GET_CLASS(current_machine);
> +    mc =3D MACHINE_GET_CLASS(qdev_get_machine());
>      if (mc->hot_add_cpu) {
> -        mc->hot_add_cpu(current_machine, id, errp);
> +        mc->hot_add_cpu(MACHINE(qdev_get_machine()), id, errp);
>      } else {
>          error_setg(errp, "Not supported");
>      }
> --
> 2.21.1
>
>

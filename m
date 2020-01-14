Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E91139F40
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 02:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgANB7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 20:59:36 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41984 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbgANB7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 20:59:36 -0500
Received: by mail-lf1-f65.google.com with SMTP id y19so8473095lfl.9
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 17:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5OXR1lgWAptLKU3W0CQIZNE+hOvlwc8nHcCeOKgikCc=;
        b=ldG5Kb8Xh6+ISy/6M54NdrAwwDLsh66IGzfYLcVVU4QSsBHgAHo3KU4OxzOD/8Ic68
         plq1yDtgwqyTzATD/ld0jlxwDkm3v2+KbGdHf4Rn1TTntg2f3e+dJ+A4cQKDUOUqj/K2
         T806kS52ldq6cOCKN0qXiNVZlgN/pBHxiUl4S5P9mnt5JJcg/pXSCUUxzqOTGqbZMuXo
         WTPo8k2HjXHyWns5E4e8rN64JFSPmYm87BxhTbq0cCuUX6EJt1aCp7GyAlQ80J9O29dd
         KRtoMDGxeDhgZqImrxAZAvW8Px3NHISp3unhudz/I1Iyn+tp16qmBO9+FA9NUBIGKkkf
         U9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5OXR1lgWAptLKU3W0CQIZNE+hOvlwc8nHcCeOKgikCc=;
        b=AcgnLZTLVSe1UTztWScgKrB+9DFPZjuiFO5+jbyQcPyOv1TTY3slCVZCktYE/GI66D
         k72Vw3OpDTCfqcrgXW1nGeYIBdOkb7YzaUv7HilaqF+5aPzxZh7HIzSso4HtRp4C4Kwl
         gIlFmByRQitSUQCA1JQ8rCgFgZzZwmEDGRZZ+VwantJxzUemHC1YtiMdogt8S+RxPtMZ
         fuD4ceyzprawRX3CDPLPxrp32rfWeMSGKMJylSXDxJVdKNwLqTgIZYhXaUOqpVfAzKj1
         GOOboCtoh33rasDXU1sVcWAVH/lVOwlOuf8WKoSd3KaQFiHRJ1H/KKsiqAL0ZPxY01Du
         UBXw==
X-Gm-Message-State: APjAAAVHcAINJ2vb4iDH8bqqyQJlg43ycMelZ3CmscWxVNnDEHKgGMcG
        /wbsG82TK75gsHfZEgd/FdMSl4wuo7VGQzG1Kxc=
X-Google-Smtp-Source: APXvYqyc60nAVZIP/khaHSKFSbqDkQ8o2ZT3rRwZZiRCLs8WEvt5bZycEm1x0HSBiWNbIlCrFwD/SlCWkEpEDF8sqQQ=
X-Received: by 2002:ac2:46dc:: with SMTP id p28mr235710lfo.23.1578967174451;
 Mon, 13 Jan 2020 17:59:34 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-13-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-13-philmd@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 14 Jan 2020 11:59:07 +1000
Message-ID: <CAKmqyKNrNKGiwVzubZjJtBj+=7vCs6tMN+7jGx6Zme=8sgLPZg@mail.gmail.com>
Subject: Re: [PATCH 12/15] accel: Introduce the current_accel() method
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

On Fri, Jan 10, 2020 at 1:27 AM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> We want to remove the global current_machine. The accel/
> code access few times current_machine->accelerator. Introduce
> the current_accel() method first, it will then be easier to
> replace 'current_machine' by MACHINE(qdev_get_machine()).
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  include/sysemu/accel.h | 2 ++
>  accel/accel.c          | 5 +++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/include/sysemu/accel.h b/include/sysemu/accel.h
> index d4c1429711..47e5788530 100644
> --- a/include/sysemu/accel.h
> +++ b/include/sysemu/accel.h
> @@ -70,4 +70,6 @@ int accel_init_machine(AccelState *accel, MachineState =
*ms);
>  /* Called just before os_setup_post (ie just before drop OS privs) */
>  void accel_setup_post(MachineState *ms);
>
> +AccelState *current_accel(void);
> +
>  #endif
> diff --git a/accel/accel.c b/accel/accel.c
> index 1c5c3a6abb..cb555e3b06 100644
> --- a/accel/accel.c
> +++ b/accel/accel.c
> @@ -63,6 +63,11 @@ int accel_init_machine(AccelState *accel, MachineState=
 *ms)
>      return ret;
>  }
>
> +AccelState *current_accel(void)
> +{
> +    return current_machine->accelerator;
> +}
> +
>  void accel_setup_post(MachineState *ms)
>  {
>      AccelState *accel =3D ms->accelerator;
> --
> 2.21.1
>
>

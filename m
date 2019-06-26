Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D2568B9
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 14:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfFZMYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 08:24:23 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:42517 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFZMYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 08:24:22 -0400
Received: by mail-vs1-f65.google.com with SMTP id 190so1419433vsf.9
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 05:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CT1Gv4AMdpnoqpjWY2ev6cLuFa53kAL9ZaegsrQDcUw=;
        b=bTKfyPyfUWE9WU0gz42tUqzN3p/2GZckP1UIz2ihopb0QhJTKc9oVGpLDVMmBppyV3
         hnAYcdI355svogcdqWz54JU3DaO7EH24gjLL+UCxBU2NIlFAt7f/oxGPBvLVtfG9nb/k
         nqqoqY6aEuY6mUy6yJ8kDNCKsMDGFYbH+HZisj3GW5vVixuY+8k/9yvhdiofbqivC6iT
         gb3ITTI/wslLqxGkcW7XPYXyoTOYOLx99TAYUDFmhrzkEEsT/K4pAK7WIhl3O5ww6kzW
         D5lFxw+6Ts9Iz9lViwcpz0cSUfzEDMh41S5zgdcU0+mIH/dCxRGE4r3zWrylNOCvXkEU
         G55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CT1Gv4AMdpnoqpjWY2ev6cLuFa53kAL9ZaegsrQDcUw=;
        b=OkyU0TDLFKCXexBEoCeoNBICfHHjM5FKg0OV2yB5fDt3YYmiAgIfjAGSSc1HxbEB1+
         /dngsZYgAqiBt2RUloSv8o4ts5CL2JftbjNN1qFJUEKmkatAFJLpcGNLTG3BNOdX+du/
         tUca9Vei8oDCHmf39HjBbuzym2pQs4THh3/uTAeSkcCr2lBIyGqqaxxCHVaOZBF9wET5
         ocxU6uXUeHNQW0VErX6vROaPtZRz0S8JymECzqbAFSwCKohKJzbPiSfDtJ1y4Ibb0d+v
         5Ukjt+dQTYAv8Gbw75PbWQMCVMba7fdksMFIIPFRRaiTCSEckENoLpIbw3xjh7QwgDAn
         rFtw==
X-Gm-Message-State: APjAAAXhwXmWSLxocSqRDe3sMS7D7ZtJlZ4vhUpr6AkH1KzVESnzUszf
        GQ3ISPhs6Z6N2H1BGZ7pNqlMQRUnTrVxem3IIo27sq0shqyaCA==
X-Google-Smtp-Source: APXvYqwWhfJFPRJFZc3jcdaHqCNzTd8XU5d9G89vRba9t/r3cKI/rxrN4UtcGcnp3FAa/7lrDQENl0r1gvkUOqZENvw=
X-Received: by 2002:a67:11c1:: with SMTP id 184mr2726115vsr.217.1561551861586;
 Wed, 26 Jun 2019 05:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <1561551539-18251-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1561551539-18251-1-git-send-email-pbonzini@redhat.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 26 Jun 2019 14:24:10 +0200
Message-ID: <CAG_fn=UdN-nPHGBT_t7Dco3287=kGhy5VUOwvKJo4mFY2RZ8Fw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: degrade WARN to pr_warn_ratelimited
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 26, 2019 at 2:19 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This warning can be triggered easily by userspace, so it should certainly=
 not
> cause a panic if panic_on_warn is set.
>
Can you please also add the Reported-by tag here?

Reported-by: syzbot+c03f30b4f4c46bdf8575@syzkaller.appspotmail.com
> Suggested-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Alexander Potapenko <glider@google.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83aefd759846..66585cf42d7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1557,7 +1557,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 u=
ser_tsc_khz, bool scale)
>                         vcpu->arch.tsc_always_catchup =3D 1;
>                         return 0;
>                 } else {
> -                       WARN(1, "user requested TSC rate below hardware s=
peed\n");
> +                       pr_warn_ratelimited("user requested TSC rate belo=
w hardware speed\n");
>                         return -1;
>                 }
>         }
> @@ -1567,8 +1567,8 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 u=
ser_tsc_khz, bool scale)
>                                 user_tsc_khz, tsc_khz);
>
>         if (ratio =3D=3D 0 || ratio >=3D kvm_max_tsc_scaling_ratio) {
> -               WARN_ONCE(1, "Invalid TSC scaling ratio - virtual-tsc-khz=
=3D%u\n",
> -                         user_tsc_khz);
> +               pr_warn_ratelimited("Invalid TSC scaling ratio - virtual-=
tsc-khz=3D%u\n",
> +                                   user_tsc_khz);
>                 return -1;
>         }
>
> --
> 1.8.3.1
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

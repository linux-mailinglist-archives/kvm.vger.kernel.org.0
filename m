Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAA7139F45
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 03:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgANCAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 21:00:24 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36709 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729427AbgANCAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 21:00:24 -0500
Received: by mail-lf1-f68.google.com with SMTP id n12so8481925lfe.3
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 18:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8TABIaesLWHDdS8DK0RdBcbOgWuOS8JDBz9kVGBhjg8=;
        b=uRmU8IrV2Kwgz/8qAURHetLcRDt3Xpz+7Q+UEKS2zWcNKTiiWfpPHx5mdVxEnoixfX
         36yfOm0yDR879p/RKRBHVx8EtNtQJ5qBPMyzweYPSU2w+444J8Jt9SRsRZG0wvAu9hQu
         TauGzJurlrQNCk4DOMnvefBI8pHg2UTDjnnbZcoTeTZtYnTGE6HYxiAN5+0wQmhB3I+n
         o4c7A5cNIUw0C+gAcNQHLOeJ9jUE9sSW0fPJgXejwbEVaD6zo5fCH+HvVYL1Jf6Of71+
         Rjmp2ryhqLzn2vcPE2we56FnkGK8xyLaeHLN5XaF7oeaqGv5nHLLzbbx3EBoF93P34/N
         bkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8TABIaesLWHDdS8DK0RdBcbOgWuOS8JDBz9kVGBhjg8=;
        b=sm8SxzbIeb82HWHMSUYrc5tcYHJT3EEpFmQ2j7QdNZ6FG5NktugybDiFn6oMqjmVxB
         tfix7SA82KaPKXGu8wPAoFJpkI0Hl08LhGzhG81yK7+ETWDICrntHS7K/u6FNAusIvqS
         t95QA2EIfEWNqLIa/EJRjaek/ATFCC4QyDUXmEu947cgUkJar9DFBZ9w+60KFVfO3Ny9
         xXtU5JrzNWzrFuK3fey3mWlL0XcQ0tlIEPQUP+y53xbM0g/SJZdaiMz5haUkTP6ukk2v
         gU8UuogHZ9Cy1ULCoAOyK0LG82xLnop7IKtOVOf1zH4Gu/WeuH8EGQVTUaZRqB2+ZnLo
         hA1g==
X-Gm-Message-State: APjAAAXi7Ld0XxSc4L8WK4RtKDhO0cggXO8FSFXKvHBUqZDjOlU7n6s2
        P1cSNk/LzmWQaOOMBOJfR74l1YA1e0GU4OQgUhU=
X-Google-Smtp-Source: APXvYqwUIQSiQcj1gBt1vZS9VSYTqmqQ5Z0LwWrxO9JJb50ZRngJxt2wHTwfjP90rCFRNHVqaZezjew947fjp7tLGnk=
X-Received: by 2002:ac2:5498:: with SMTP id t24mr250782lfk.84.1578967222098;
 Mon, 13 Jan 2020 18:00:22 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-15-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-15-philmd@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 14 Jan 2020 11:59:55 +1000
Message-ID: <CAKmqyKPa0F6B1PR3O4-Tsz64guywyLxHO5FSQVZAw4D3KNrGZA@mail.gmail.com>
Subject: Re: [PATCH 14/15] accel/accel: Replace current_machine by qdev_get_machine()
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

On Fri, Jan 10, 2020 at 1:40 AM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> As we want to remove the global current_machine,
> replace 'current_machine' by MACHINE(qdev_get_machine()).
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

I feel like this could be squashed with the one that adds this
function, but either way:

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  accel/accel.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/accel/accel.c b/accel/accel.c
> index cb555e3b06..777d6ba119 100644
> --- a/accel/accel.c
> +++ b/accel/accel.c
> @@ -65,7 +65,9 @@ int accel_init_machine(AccelState *accel, MachineState =
*ms)
>
>  AccelState *current_accel(void)
>  {
> -    return current_machine->accelerator;
> +    MachineState *ms =3D MACHINE(qdev_get_machine());
> +
> +    return ms->accelerator;
>  }
>
>  void accel_setup_post(MachineState *ms)
> --
> 2.21.1
>
>

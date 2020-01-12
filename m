Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E061385B1
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2020 10:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732395AbgALJnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jan 2020 04:43:15 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45034 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732307AbgALJnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jan 2020 04:43:14 -0500
Received: by mail-lj1-f196.google.com with SMTP id u71so6692515lje.11
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2020 01:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uQmpwxVEj1cR4VjtZn7xRR3NzxiwsRUjQ/Q0ih7Ijuw=;
        b=lz/w3v3FvAImk7GIfeLMkjq7yFJEO27+zK0Trfs/b6YTLzlbx4zyrGmcYD5lup1nyi
         hdf54ZKtgUWMHwcA0ZCauN1r7BGXb6sRsJpw3sc2lLdV84h+oDivN4YzY2GdJWcD5NF9
         LCPlvrzEl/MnPz6qdIEt4MUWdwQLVWLs2e0+L+imOZHL1QBd9Q1RiURQ1Z7G3bVESAKX
         xvWR8jjK6XeaCb6+QObz4P49sgddj7H8lfmdPdysgvTLtuc0nfea0P9EaAptRhhP86KQ
         EwArp9tWLTwNvdSjCwwcbGNfG/uVQmNGZCefwAQFRAtttELBxu22e/W1/EXG2/jNkH9J
         kmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uQmpwxVEj1cR4VjtZn7xRR3NzxiwsRUjQ/Q0ih7Ijuw=;
        b=bz35zvexeMyRyNjy12iCWgO3wYbA4UGoliXL/DOOcZQRINS3gk7rvEZogwnuRSloDh
         tM5P894SqgaKzgeX2N51ust9Z1one/0QeLwaeuzNBDyEoCpy8HXU3+IRyNX+v1DHRwfl
         /avP4kS+QFvpwAKl03+fhujXnkWepTvtp07vv47CChwOlIvkyF8SabkGOiY1OFrHaidl
         Uoe41lYvyuCxkjXqwott8/3EixbP6Gs4KOrAyqgweMtp3gLDP65CigQ1C2wdcLQmy4dK
         jCpLT8nhhF4zs5lMS0vQlfD/KO8GBB7R2uxVe7JGzynghlUBKV4Hb57kBtaKl896yA8+
         xMhQ==
X-Gm-Message-State: APjAAAX+GCFy9gNQAkIY3usg46TBo0LPTlXGbYkyb0KbJGUn4p/wc1Zx
        qSVsFCg5ABoCaxlrl4XX9Z6ATUIBmkiYxtnx+zU=
X-Google-Smtp-Source: APXvYqx2g1B8y9igJ79V+P1O1imbGLRFl3oMl1i8j7mLFRCVYeIYDi7trAw9KXRVQNnUEJuDknDqFeYmZsHJGGOEhaU=
X-Received: by 2002:a2e:9b03:: with SMTP id u3mr7679182lji.87.1578822193085;
 Sun, 12 Jan 2020 01:43:13 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-6-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-6-philmd@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Sun, 12 Jan 2020 17:42:45 +0800
Message-ID: <CAKmqyKMOznT5OspQYB41+xYNWK6BnxYeYT7qUWk=KJLv7i6XmQ@mail.gmail.com>
Subject: Re: [PATCH 05/15] device-hotplug: Replace current_machine by qdev_get_machine()
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

On Thu, Jan 9, 2020 at 11:27 PM Philippe Mathieu-Daud=C3=A9
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
>  device-hotplug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/device-hotplug.c b/device-hotplug.c
> index f01d53774b..44d687f254 100644
> --- a/device-hotplug.c
> +++ b/device-hotplug.c
> @@ -45,7 +45,7 @@ static DriveInfo *add_init_drive(const char *optstr)
>      if (!opts)
>          return NULL;
>
> -    mc =3D MACHINE_GET_CLASS(current_machine);
> +    mc =3D MACHINE_GET_CLASS(qdev_get_machine());
>      dinfo =3D drive_new(opts, mc->block_default_type, &err);
>      if (err) {
>          error_report_err(err);
> --
> 2.21.1
>
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5151D7E08
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgERQMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbgERQMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 12:12:14 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E86C061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:12:14 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id j145so9457902oib.5
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BPSGc1YOAbwiDqGSIPUq/PBsbDFhhz8vXhf0ZS70vnA=;
        b=x8oz22uumUoP6A+CO8dA0XbrRX4DdTY7++0C960rhAkQL2bAmiDeWn+k9dqlQx8vil
         QjF56wGpVk39pfx8nwVkKxFVEawv5sscJ6b1bmbuxrOZx9dShf4cTORkwiJj12Ap8Uv1
         ILQGhn5zxKW/QFP5Ia7FB2r2/sWd8OyItfveA825sCZ2wmgJG/Bu9FyjK85ehN48sWrp
         WWgub6JxfJ14Hiwr3X4tCVWj7iIkzfnvytYnVkOXlCtlx4E2VlqwHp4FakUMEbaYghxF
         ZNEVeJFzBG2t+MW/nUPCezcPI5HZ+U9LGkXkhXlioPQcSl8pXJdChfOYM4cRUtLo9xwF
         HAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BPSGc1YOAbwiDqGSIPUq/PBsbDFhhz8vXhf0ZS70vnA=;
        b=aKMD6RsaKZI0WOLEIcd6n/kWuZ44eii8PX/oFrSH9wZ6Kz/XDdk2SOWuHJthZlrOeY
         aRvntfhnuvG1JCaMaAodPtALq33TrQOVcJtx4nuXrChKMJ0hwsEGhRGFi6JvpaJpTl1m
         QjSKDarvT90FXv4LlRLzKiJj4yzbm+UUYPkify0RpZW/XkXeire0pc8GazY49yMhsqEW
         cIowtVa3Mowgd7WJ1HOWjJ2kYIa1aBMsZOasF0yArW9Z6zArO02vF8OUWjahVA5aNKgk
         jg+UEMdU+kBLFzo1wVXYrJ+6sfB3BDHT0AyLB+FJ1+bcmJ7LgoyhGXUyHW4mlFXOiSFH
         BEMg==
X-Gm-Message-State: AOAM5335m0excyGEu6hSqgippYSSRl/evKEWCYIdhZsKh/TR8JPHDgxD
        HXy28OkPXCCrG56LDPHw3W6AwhZ6x9doPgQ3GrgBnA==
X-Google-Smtp-Source: ABdhPJwVPkvmnyBFGfSqQO36dYU4yQaoMbq8NJKMnZxBnOljQTUxrKffpT9sNkKNu0DVXBGl/i/3CwmM9KVFbSqsw8I=
X-Received: by 2002:aca:895:: with SMTP id 143mr66214oii.163.1589818333787;
 Mon, 18 May 2020 09:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200518155308.15851-1-f4bug@amsat.org> <20200518155308.15851-8-f4bug@amsat.org>
In-Reply-To: <20200518155308.15851-8-f4bug@amsat.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 18 May 2020 17:12:02 +0100
Message-ID: <CAFEAcA97bYXyN-GSXUk_OetroaHFExXFwYH1bhexHwRW0+NEVw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 7/7] hw/core/loader: Assert loading ROM regions
 succeeds at reset
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 at 16:53, Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>=
 wrote:
>
> If we are unable to load a blob in a ROM region, we should not
> ignore it and let the machine boot.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
> ---
> RFC: Maybe more polite with user to use hw_error()?
> ---
>  hw/core/loader.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/hw/core/loader.c b/hw/core/loader.c
> index 8bbb1797a4..4e046388b4 100644
> --- a/hw/core/loader.c
> +++ b/hw/core/loader.c
> @@ -1146,8 +1146,12 @@ static void rom_reset(void *unused)
>              void *host =3D memory_region_get_ram_ptr(rom->mr);
>              memcpy(host, rom->data, rom->datasize);
>          } else {
> -            address_space_write_rom(rom->as, rom->addr, MEMTXATTRS_UNSPE=
CIFIED,
> -                                    rom->data, rom->datasize);
> +            MemTxResult res;
> +
> +            res =3D address_space_write_rom(rom->as, rom->addr,
> +                                          MEMTXATTRS_UNSPECIFIED,
> +                                          rom->data, rom->datasize);
> +            assert(res =3D=3D MEMTX_OK);

We shouln't assert(), because this is easy for a user to trigger
by loading an ELF file that's been linked to the wrong address.
Something helpful that ideally includes the name of the ELF file
and perhaps the address might be nice.

(But overall I'm a bit wary of this and other patches in the series
just because they add checks that were previously not there, and
I'm not sure whether users might be accidentally relying on
the continues-anyway behaviour.)

thanks
-- PMM

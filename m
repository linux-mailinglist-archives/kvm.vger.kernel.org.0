Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112921D290C
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 09:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgENHrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 03:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgENHrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 03:47:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E23C061A0C;
        Thu, 14 May 2020 00:47:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w7so2511570wre.13;
        Thu, 14 May 2020 00:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h2/xdeIsYvOOG2mOpvdD/Yx/5G5+S5ETnQrkMRrgqgY=;
        b=tYEWwXN3jhZg2qwyy+5Sg1S2/WassGFVKjnk+qAEs5d+GtuyxXhY1yktI35DOg3eXx
         2g3RS5wRxBQdWByUWtTAPJMoyDgKaL7s4Ix0KH4dC9xilicEPLIaH3kymhY2BLWuvBcc
         iqqKPTqNv/Ln/ox6EQB8iEd5mpGYiuFAECBWrE06bG1O3r4ULG0UBhKQ1CLNElQY/DMT
         yCk5HUg0oVa1qHl6o77bMkCnz/MWPWIBKSZ2gFehsIqBDCcxKp79TeLxUNKPHexv4oai
         tJpiWXX7I6mdrAYFlKPjliH0BQSFFNzAz8hkdMEkJlzHGQLM9Is9tqn8EaiFoQUdk40i
         B4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h2/xdeIsYvOOG2mOpvdD/Yx/5G5+S5ETnQrkMRrgqgY=;
        b=kmIThysle8Nv6bunSdlBYVINmlX1ficqyV8dHG9TiJ8fvvFJH8yuH3mEupWGCUxMAL
         oylGUnMsPAQCQdXiRLdRKkDu5hkb0PuTduZ86CT2xgAXe2kETIe9U/GtJSVJBFIp2Gr+
         /0PrrhayMbI99BaVq9w9mVnlutB/UjEhQeWRPIjniqo4LSb1sUpaLb9rw/qyoJ44pprI
         UJ03/RZpP4qBE6A7kWBTzab6yYRcOIWlFWXFrZWpNzoYI5TtD0Nz9ZS2s7pWDGiM1Kyj
         JE5IxfpZg52GnYS9z3Yly+AeY4pu1cmPURXpiCI+HjiUj8TS+3TwxbLP3hyAvQCx9E3a
         3B8A==
X-Gm-Message-State: AOAM530+z2vzGKFl9c1hBoh2NytaBGSuHGb7191bSXX4O6HbDdK3b4wn
        2j3TvGHUxSDRfyY+GP6eBd5dtFkMh6o9JskkdHU=
X-Google-Smtp-Source: ABdhPJzINS4Ge+3Ox04BRWiaeaepz5YgTIbWC9ztdewLUX0KbTB3XawPOgcPkI4y0qU46zMOzHfiLmdvLjY/yKOJQwc=
X-Received: by 2002:adf:dc50:: with SMTP id m16mr3869260wrj.329.1589442464629;
 Thu, 14 May 2020 00:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com> <1589359366-1669-16-git-send-email-chenhc@lemote.com>
In-Reply-To: <1589359366-1669-16-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Thu, 14 May 2020 09:47:31 +0200
Message-ID: <CAHiYmc4E18qb9L+P7TWXLciTstrooa4jPxpwVj0KNx5EpEhHAA@mail.gmail.com>
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D1=81=D1=80=D0=B5, 13. =D0=BC=D0=B0=D1=98 2020. =D1=83 10:48 Huacai Chen <=
chenhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> James Hogan has become inactive for a long time and leaves KVM for MIPS
> orphan. I'm working on KVM/Loongson and attempt to make it upstream both
> in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
> QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> made some contributions in kernel and QEMU. If possible, we want to take
> the KVM/MIPS maintainership.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>

>  MAINTAINERS | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e64e5db..59b3f43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9302,9 +9302,11 @@ F:       include/kvm/arm_*
>  F:     virt/kvm/arm/
>
>  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> +M:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> +M:     Huacai Chen <chenhc@lemote.com>
>  L:     linux-mips@vger.kernel.org
>  L:     kvm@vger.kernel.org
> -S:     Orphan
> +S:     Maintained
>  F:     arch/mips/include/asm/kvm*
>  F:     arch/mips/include/uapi/asm/kvm*
>  F:     arch/mips/kvm/
> --
> 2.7.0
>

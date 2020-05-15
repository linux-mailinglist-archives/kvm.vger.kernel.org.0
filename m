Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1431D433C
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 03:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEOBuP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 14 May 2020 21:50:15 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:40174 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgEOBuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 21:50:15 -0400
Received: by mail-il1-f195.google.com with SMTP id e8so904965ilm.7;
        Thu, 14 May 2020 18:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JfcJwOjz9RXRUQpkXkIR/GLlPPGXPrK7BjAdsObVwTI=;
        b=kOeBzGiw38s+/xbvuJQhkC89Sn3z7JWPiI20Ihr+1KUoeu79D9puSsc71Lbyvs5rpA
         50UQg2k+bNDAL42VArdzXMWdy1pFNWb+cn+GPPFzqYVWVB4zif5iUeCoOUi3+UVIE2XG
         ICJRD2CvdLcS9d1zDKlOaYiPKdIE85X9lntpsPG21qhHq312ppuH6IMhjTFh10lKGjfe
         zWQVJQLpJkkFEbvzGCB5oDZBLTP+CcIAdnwFTveDkjUa9McA9SsAK6J6Uxlo+fJSiIYR
         53jXZdU6NTUq5mHOs8036bsJzqG2/bLws/Nm50ZkVv+Crgwe64nuYjNXY7ynVe5+iyEc
         i+xw==
X-Gm-Message-State: AOAM533eeltJX9s2WBivuke0J0+1uJsaLN3EQKpkC3nM17puHUkgDAxf
        GKWHrlBexova1lyzsVZusAROcg18luL/mJpaQEs=
X-Google-Smtp-Source: ABdhPJxyoyUCvceLnDefUyOdxb19iWJfJ5neAUdgZAsqOBEqFn7CWztNlWMjq4WJZvLRRQgNGHenz+sw5ASBLceoSzs=
X-Received: by 2002:a92:980f:: with SMTP id l15mr1040218ili.251.1589507414350;
 Thu, 14 May 2020 18:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-16-git-send-email-chenhc@lemote.com> <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
In-Reply-To: <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 15 May 2020 09:50:04 +0800
Message-ID: <CAAhV-H7OTeMy2Yp2PunD+2KVzzPDT+-xGGgbpRNzhb8C-p8-7g@mail.gmail.com>
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jiaxun,

On Thu, May 14, 2020 at 9:34 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
>
>
>
> 于 2020年5月13日 GMT+08:00 下午4:42:46, Huacai Chen <chenhc@lemote.com> 写到:
> >James Hogan has become inactive for a long time and leaves KVM for MIPS
> >orphan. I'm working on KVM/Loongson and attempt to make it upstream both
> >in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
> >QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> >made some contributions in kernel and QEMU. If possible, we want to take
> >the KVM/MIPS maintainership.
> >
> >Signed-off-by: Huacai Chen <chenhc@lemote.com>
> >---
>
> Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>
> Huacai is extremely experienced on virtualization,
> his PhD thesis is about virtualization too.
> He had been working on Loongson kernel for a long period.
>
> Alexander maintained QEMU/MIPS for some years, he is a expert on
> QEMU and MIPS architecture.
>
> I believe these guys can effectively bring MIPS/KVM support back to sea level again.
Thank you very much, and I think you won't be disappointed in us.

>
> Best wishes!
> --
> Jiaxun Yang
Regards,
Huacai

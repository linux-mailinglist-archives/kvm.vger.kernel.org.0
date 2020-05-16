Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A311D600D
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 11:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgEPJgO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 16 May 2020 05:36:14 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:46963 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgEPJgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 05:36:14 -0400
Received: by mail-il1-f195.google.com with SMTP id w18so4945539ilm.13;
        Sat, 16 May 2020 02:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BGd/n1T/7dZ2lsUxrqXc0tcSix1e9+New+enM5rhHeU=;
        b=KpYZ2BLHJuqpuxhGaE4tFJgw2+beZWCFmEEUzOTigAltRVT++m4EIxZ96EiUWcZk1d
         XR+gksEWpcSL2LbdT0NrtlWxGQHMon4J1v+El7xzGthdV6EUSsVh5taoQouh4GfTdxbk
         vNXWR9RlNgiLRc1U5MzXnWkrjvQO68eUW1gFgKwhbOcSOnwj0UhW28LE4lDycR/aso72
         VeEWMz144KUetLQkW0lStqLW+biSYKvM3UCJZXrgw8jJqOt1/hiwec34Q0LCjwMg2Fzp
         pOsET0lza3FMWA94gDL8UuieXo0XJ9pvGaATL3WRHQpUAqfLsBtbhJgAMRUXSzWUSErz
         xHzw==
X-Gm-Message-State: AOAM532sA62zlAd/Pt+f71z8z4xC8//hjkp7/ZGSEDk3x5GacsDb60Ox
        lP+nkeHSiq3u4xLKKyr51WYcjcqMUkbckjzSZqA=
X-Google-Smtp-Source: ABdhPJyRkqbO/i5CqXW5Dv69KaIqpmP+7RhEWtwnJNGFXtNyl4TdXeS3B73pHBG5f3a0vc1v09eWTYdPODi/DLYEElE=
X-Received: by 2002:a92:980f:: with SMTP id l15mr7313113ili.251.1589621773489;
 Sat, 16 May 2020 02:36:13 -0700 (PDT)
MIME-Version: 1.0
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-16-git-send-email-chenhc@lemote.com> <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
 <CAAhV-H7OTeMy2Yp2PunD+2KVzzPDT+-xGGgbpRNzhb8C-p8-7g@mail.gmail.com> <20200515211353.GB22922@alpha.franken.de>
In-Reply-To: <20200515211353.GB22922@alpha.franken.de>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Sat, 16 May 2020 17:36:04 +0800
Message-ID: <CAAhV-H58G7+se6VTBMo2R4joDXngF-c_W=fh8=zD8rVnono=gg@mail.gmail.com>
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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

Hi, Thomas,

On Sat, May 16, 2020 at 5:14 AM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
>
> On Fri, May 15, 2020 at 09:50:04AM +0800, Huacai Chen wrote:
> > On Thu, May 14, 2020 at 9:34 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
> > > 于 2020年5月13日 GMT+08:00 下午4:42:46, Huacai Chen <chenhc@lemote.com> 写到:
> > > >James Hogan has become inactive for a long time and leaves KVM for MIPS
> > > >orphan. I'm working on KVM/Loongson and attempt to make it upstream both
> > > >in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
> > > >QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> > > >made some contributions in kernel and QEMU. If possible, we want to take
> > > >the KVM/MIPS maintainership.
> > > >
> > > >Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > >---
> > >
> > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > >
> > > Huacai is extremely experienced on virtualization,
> > > his PhD thesis is about virtualization too.
> > > He had been working on Loongson kernel for a long period.
> > >
> > > Alexander maintained QEMU/MIPS for some years, he is a expert on
> > > QEMU and MIPS architecture.
> > >
> > > I believe these guys can effectively bring MIPS/KVM support back to sea level again.
> > Thank you very much, and I think you won't be disappointed in us.
>
> I'm happy to see you taking care of the KVM part. So how is your plan
> to handle patches ? Do want to collect them and send pull requests to
> me ? Or should I just pick them up with your Acked-by ?
I think we can only use the second method, because both Aleksandar and
me don't have a kernel tree in kernel.org now.

>
> And could you do me a favour and check your mail setup. I always
> get failed deliveries:
>
>   chenhc@lemote.com
>     SMTP error from remote mailer after end of data:
>     host mxbiz1.qq.com [203.205.232.191]: 550 Mail content denied. http://servic
> e.exmail.qq.com/cgi-bin/help?subtype=1&&id=20022&&no=1000726
>
> or
>
>   chenhc@lemote.com
>     SMTP error from remote mailer after end of data:
>     host mxbiz1.qq.com [203.205.232.191]: 550 Ip frequency limited. http://servi
> ce.exmail.qq.com/cgi-bin/help?subtype=1&&id=20022&&no=1000725
I only use chenhc@lemote.com to sign-off my patches, and you can
communicate with me via chenhuacai@gmail.com. Thank you.


>
> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
> good idea.                                                [ RFC1925, 2.3 ]

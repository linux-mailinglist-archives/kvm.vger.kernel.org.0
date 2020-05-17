Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CF21D6637
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 07:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgEQFuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 01:50:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46575 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgEQFuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 01:50:21 -0400
Received: by mail-io1-f66.google.com with SMTP id j8so7050369iog.13;
        Sat, 16 May 2020 22:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YTo0vYUI6upoh7iQLUM6+NT1auQ+09atmg1LaeyqP7s=;
        b=EN8TUdErSkO8NnRI6u95cwl2Gob5e3/dtlaT2rtc6Om9THroSaDjJu0H/9HHW6bhbP
         w6MMzZ46Jw1jbAIGrRcdCImDb8rc835n1G/4BaBLoHfnK2AtOWHXIS2cCWXOWctnIxS+
         9ZEW1kF/q/5r7z7BJLaj6wVlZcVxgQVwc7j7QgwhSK+WC4cFsJrZWtjC3MTkvdTi6fmJ
         oRmBm9OmT3gwEXkcGSyUrsUeSCt9jcZ+m7v9lLYKYlj8VjJuYZiGb2JRKkdOoydr2CEI
         pZc/7oxGd2l3Uhq+imJns1cGFlYTpwOADz1kQh1CgQhm1Dy+QGlEuNzjlS3wAJju/PVy
         K74Q==
X-Gm-Message-State: AOAM5324JdE9jyaLgnCO2WTR9I4bjRNXF1AWsZeqIIJ3XgtMkRNYkWWo
        EuCbSwRUoiL7FrGnwhRBE+C5vAAilM3HydGlRsw=
X-Google-Smtp-Source: ABdhPJylbOP5KeMpaO2XS9FzqtNMS8Du/iphjjy3BnqP1IdouM5LOMof/0ZaIRe+v5i8WcBwJQ2gwT3O8J5iE65x6zY=
X-Received: by 2002:a6b:dc11:: with SMTP id s17mr9670559ioc.42.1589694620594;
 Sat, 16 May 2020 22:50:20 -0700 (PDT)
MIME-Version: 1.0
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-16-git-send-email-chenhc@lemote.com> <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
 <CAAhV-H7OTeMy2Yp2PunD+2KVzzPDT+-xGGgbpRNzhb8C-p8-7g@mail.gmail.com>
 <20200515211353.GB22922@alpha.franken.de> <CAAhV-H58G7+se6VTBMo2R4joDXngF-c_W=fh8=zD8rVnono=gg@mail.gmail.com>
 <1a22adb0-0b7a-24a3-e762-7b9919a70a8e@redhat.com> <20200516153804.GD3334@alpha.franken.de>
In-Reply-To: <20200516153804.GD3334@alpha.franken.de>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Sun, 17 May 2020 13:50:09 +0800
Message-ID: <CAAhV-H77soa1H7Cd-XTknZbj0P2OXjAtdmxbxug2D4YwOvO2qQ@mail.gmail.com>
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo and Thomas,

On Sat, May 16, 2020 at 11:39 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
>
> On Sat, May 16, 2020 at 01:55:23PM +0200, Paolo Bonzini wrote:
> > On 16/05/20 11:36, Huacai Chen wrote:
> > >> I'm happy to see you taking care of the KVM part. So how is your plan
> > >> to handle patches ? Do want to collect them and send pull requests to
> > >> me ? Or should I just pick them up with your Acked-by ?
> > > I think we can only use the second method, because both Aleksandar and
> > > me don't have a kernel tree in kernel.org now.
> >
> > If you don't mind, I generally prefer to have MIPS changs submitted
> > through the KVM tree, because KVM patches rarely have intrusive changes
> > in generic arch files.  It's more common to have generic KVM patches
> > that require touching all architectures.
>
> works for me.
>
> > For 5.8 I don't have anything planned that could cause conflicts, so
> > this time it doesn't matter; but I can pick these up too if Thomas acks
> > patches 6, 12 and 14.
>
> I've acked all three pacthes
>
> Thomas.
Thank you very much, I've send V6 instead of V5, because V5 has a
small rebase issue.

>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
> good idea.                                                [ RFC1925, 2.3 ]

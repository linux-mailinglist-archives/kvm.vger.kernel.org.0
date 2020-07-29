Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6C8231C80
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 12:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgG2KIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 06:08:36 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:41688 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgG2KIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 06:08:36 -0400
Received: by mail-il1-f195.google.com with SMTP id c16so7079313ils.8;
        Wed, 29 Jul 2020 03:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EvMl0qvQb+jx+7NrSC3p+seDViq+tdV7DqvHK41k5Pk=;
        b=Mihu02plrkILuvWb5qSPBGzvtTqYHm6UbTHb/MHYt0bJv3f+xIfIVheJ41sJSHZjc6
         HgTqWtRtvLlOdh94IFBYGM4TG8AvE7jr2BryDlUtgxYeoht6MVU5WFQVtCYqD37JHo69
         ZNxIQch27LSD5jyeY3HZMPH7S2yqClQTxjZ+nW2XNFkBZtz+HtmSuqmr4EkiErjv78tN
         EjszetogIpDIUVZ2AAhvfZA69qtIv/iBE0SiMESNie/GxXALOYJxjWGshh4IbzaM+aPb
         DrpJr3Ad8M4mT7VEoRU2LEYEJNXh3qJkwRdnhZvP/R3w/X/aJAeNKLSEOrkpQFT5HqDM
         INQw==
X-Gm-Message-State: AOAM533Alrn3jV40aeQWC+uzCFVMPn47cm7smjEHlolV+rclikYpXUgI
        sjyejyPY7HyybSyj3jaQHHVYh1mtG9872dt7Log=
X-Google-Smtp-Source: ABdhPJxxYw3JHbWt2yX4I3lgL29whhgai7wbVUBwqEea98C/D0nS5byjebP8p+/QhoYJQBZq309k3DN2EERfZKWoXH8=
X-Received: by 2002:a92:dcc6:: with SMTP id b6mr6330769ilr.147.1596017315490;
 Wed, 29 Jul 2020 03:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
 <1596005919-29365-2-git-send-email-chenhc@lemote.com> <20200729095248.GA9234@alpha.franken.de>
In-Reply-To: <20200729095248.GA9234@alpha.franken.de>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Wed, 29 Jul 2020 18:08:24 +0800
Message-ID: <CAAhV-H7MzcW6Uv8XPaOh=5PmsFbRa9n=W1GjWP1WWwCYL_r-hA@mail.gmail.com>
Subject: Re: [PATCH 2/5] dt-bindings: mips: Document Loongson kvm guest board
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Thomas,


On Wed, Jul 29, 2020 at 6:00 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
>
> On Wed, Jul 29, 2020 at 02:58:36PM +0800, Huacai Chen wrote:
> > Document loongson64v-4core-virtio, a virtio based kvm guest board for
> > Loongson-3.
> >
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>
> hmm, I can't remember adding my signed-off to this patch. Could you
> give me a reference for this ?
>
I'm sorry, this is a copy paste error..

Huacai

> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
> good idea.                                                [ RFC1925, 2.3 ]

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C3B233D8D
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 05:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbgGaDCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 23:02:12 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38093 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730820AbgGaDCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 23:02:11 -0400
Received: by mail-io1-f66.google.com with SMTP id l1so30345587ioh.5;
        Thu, 30 Jul 2020 20:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pC14QFTjuYSw8RWlL+X9P/YXc9lp6PG2Z5LhcJK0Hkc=;
        b=rdkHmGyt2m8KRH/djnGqd8mLGaA6V1kHcIaddEHgH8mDFbAGkC+nslOR+MGuqH7cAQ
         a3sD29xw+VfLRSyWbo7mThrJZsy44ju6mye87wMNmA4Fudb64+AdlyPhkzi00PsyqSCl
         cpfRAJlBXmcCDtPoUDCrZbn9in+FdBCd9ciJtibYjrBbEbpztjf2sOnagRsPp4nEDcGc
         IgZXP1e4tRhJ2QcaMfdAYo1mVwRxpcfLW64QEFzkQiwHzC2RxhHGYnj7dfyibKWCfekG
         0stCOaPltp7+0WJ37pb406GaTZA7xf737ygyHl0lrmRuh6R23UqL3xyWtzvZUc48LVVh
         9v6g==
X-Gm-Message-State: AOAM532knp6hMkX2Ws2fUIupawtUtqz2BBz+6murSz/aAWhO4F8itJ0A
        T8NddgIv/ha8WJcAMt+4O4ve6uePhN2bwUTnbgU=
X-Google-Smtp-Source: ABdhPJwmwdh3rVol/y6zJOOtutlLkYY85E5N3T1VR1Kv1Xda2xSPZnFR/3HsIdIeCA3Zow6BMKr9MVfJIRrh0Gsfopo=
X-Received: by 2002:a6b:ba03:: with SMTP id k3mr1664581iof.72.1596164530621;
 Thu, 30 Jul 2020 20:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
 <1596005919-29365-2-git-send-email-chenhc@lemote.com> <20200729095248.GA9234@alpha.franken.de>
 <CAAhV-H7MzcW6Uv8XPaOh=5PmsFbRa9n=W1GjWP1WWwCYL_r-hA@mail.gmail.com>
In-Reply-To: <CAAhV-H7MzcW6Uv8XPaOh=5PmsFbRa9n=W1GjWP1WWwCYL_r-hA@mail.gmail.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 31 Jul 2020 11:01:58 +0800
Message-ID: <CAAhV-H4SXCmW8V-fXhGGiSQbM4cQ3bN3K76JK61Ms+vWxiuviw@mail.gmail.com>
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

On Wed, Jul 29, 2020 at 6:08 PM Huacai Chen <chenhc@lemote.com> wrote:
>
> Hi, Thomas,
>
>
> On Wed, Jul 29, 2020 at 6:00 PM Thomas Bogendoerfer
> <tsbogend@alpha.franken.de> wrote:
> >
> > On Wed, Jul 29, 2020 at 02:58:36PM +0800, Huacai Chen wrote:
> > > Document loongson64v-4core-virtio, a virtio based kvm guest board for
> > > Loongson-3.
> > >
> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >
> > hmm, I can't remember adding my signed-off to this patch. Could you
> > give me a reference for this ?
> >
> I'm sorry, this is a copy paste error..
>
Should I send V2 for this series?

> Huacai
>
> > Thomas.
> >
> > --
> > Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
> > good idea.                                                [ RFC1925, 2.3 ]

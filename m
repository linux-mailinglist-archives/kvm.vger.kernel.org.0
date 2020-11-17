Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B152B562A
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 02:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgKQBS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 20:18:28 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:44032 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgKQBS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 20:18:28 -0500
Received: by mail-io1-f66.google.com with SMTP id o11so19465415ioo.11;
        Mon, 16 Nov 2020 17:18:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FWAP333w94hyR1l4hvmRMbP8VukKi52sst6NEV009g=;
        b=qSjKN1YIIVwcXqoLWCJ9f/reVaI7Vtj4ZzAii+hmXOfSB8ghzEHqCdeDf4pXFcpO8o
         xHEvUP0JrrcI73NNz9lTKsZpXl0MUZOEGTW47W3FMLuWvhDDrOF3KozTgKYUInSiwKNW
         59xigv1TGzlzkS4DNBIW5v2HkbB5NhR4+8TH1GTq+iJZd9v3AoVEa7or7noJS59Bw9OR
         +eqR5BY0LPFnMSOpWMkYNQEaQwJ8vEgWU2sIuHuV8hgj4xm9C4zVsQ4bN6wV2GOPDT07
         At5xFZPobgSsbpUk6iJ33CIVoJnMuWfqtV3Ou2GbG5sYGWw6i2Bz/d8AfweBtf+pKAaz
         Hrqw==
X-Gm-Message-State: AOAM532+B1CfpvAlkl6yfODKkyFFFIlnOpTWaCjLkAJ3dob5QERCVLV+
        M1oWlM0W446TG+kQM/dnXfI2fsHCrpNi8fqi9sg=
X-Google-Smtp-Source: ABdhPJx2FY24KGOnWg678c/JvQfGvSMNswqrUSVq4vpE1J1Qku21XhcfegU08YzERDaLb3KcCespJK0dJfWJeV14uq8=
X-Received: by 2002:a02:9987:: with SMTP id a7mr1896651jal.38.1605575907625;
 Mon, 16 Nov 2020 17:18:27 -0800 (PST)
MIME-Version: 1.0
References: <20201113110952.68086-1-tsbogend@alpha.franken.de>
 <20201113110952.68086-2-tsbogend@alpha.franken.de> <CAAhV-H7Sc6tmsfRcxOkx3rPk85Ey6XtxqhDB0RWokk+XSGVJ9A@mail.gmail.com>
 <20201116123009.GA7555@alpha.franken.de>
In-Reply-To: <20201116123009.GA7555@alpha.franken.de>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Tue, 17 Nov 2020 09:18:15 +0800
Message-ID: <CAAhV-H57XNHurOYw8PG4=praXEWQ7h_TKM08cGBVRgAth1Rx1A@mail.gmail.com>
Subject: Re: [PATCH 2/4] MIPS: kvm: Use vm_get_page_prot to get protection bits
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Thomas,

On Mon, Nov 16, 2020 at 8:35 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
>
> On Sat, Nov 14, 2020 at 03:34:14PM +0800, Huacai Chen wrote:
> > Hi, Thomas,
> >
> > On Fri, Nov 13, 2020 at 7:13 PM Thomas Bogendoerfer
> > <tsbogend@alpha.franken.de> wrote:
> > >
> > > MIPS protection bits are setup during runtime so using defines like
> > > PAGE_SHARED ignores this runtime changes. Using vm_get_page_prot
> > > to get correct page protection fixes this.
> > Is there some visible bugs if without this fix?
>
> no exec isn't enabled for these mappings, if cpu supports it.
The whole series wants to set XI if supported?

Huacai


Huacai

>
> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
> good idea.                                                [ RFC1925, 2.3 ]

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE277239F66
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 08:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgHCGFe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 3 Aug 2020 02:05:34 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:43567 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgHCGFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 02:05:34 -0400
Received: by mail-ej1-f67.google.com with SMTP id a21so37350756ejj.10;
        Sun, 02 Aug 2020 23:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P5/aFjolm3M+oCoTSlbVZywzMbGCJC0bsu5eqXOedy4=;
        b=Nj2MODNP+s48shkPhJ4N7+NWWEMHhyS/0yNXppp1tFWlZMXDfdGhEq2dXOHebg6MOd
         AtGTiP60GkL0PURKuEWuvej4F/qyyJNYwzzpX28wxsrP3zGZ60Ug7RdnTb+BqKZ+lsx5
         Exs7sD5U1APr+kAFa5Ew8trWGqCEM5Ne//ZoOi+JfTEtHqqzT5yhmIgR8ns6cpNkSvpd
         pZn14j6pOlXhP/BFIYS4m7LN1A3I/aRLluIiHDkFkGn/W2OrWUT0H9F3rSGkaSqaemrM
         pIzQhU+/ygzXmuAmKm+agdxdm0mZiuqBdkc1JaXsXWFnimJwafgzOpw1t8BT+Clkitj5
         GUpw==
X-Gm-Message-State: AOAM531XjDyPHXnHYVmJj0gTLFI7CGFW1qHMbRVGFjs5iNmxDBWK2pJO
        9uzdVA3kHqJF2wao3bu1Q+9zE6rxy2WODtqB524=
X-Google-Smtp-Source: ABdhPJwWWqvObnrecqnO/2BhEsCNEUqOGTb5s/4nUYl9UEviwLlifCJjoEUYRsE2/aUjVz8mB0om3ZsjuV4vacGZUsQ=
X-Received: by 2002:a17:907:42cb:: with SMTP id nz19mr14956717ejb.447.1596434732278;
 Sun, 02 Aug 2020 23:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
 <1596005919-29365-2-git-send-email-chenhc@lemote.com> <20200729095248.GA9234@alpha.franken.de>
 <CAAhV-H7MzcW6Uv8XPaOh=5PmsFbRa9n=W1GjWP1WWwCYL_r-hA@mail.gmail.com>
 <CAAhV-H4SXCmW8V-fXhGGiSQbM4cQ3bN3K76JK61Ms+vWxiuviw@mail.gmail.com>
 <20200731083252.GA7946@alpha.franken.de> <89376514-e6c1-469c-f212-865d7a549854@flygoat.com>
In-Reply-To: <89376514-e6c1-469c-f212-865d7a549854@flygoat.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Mon, 3 Aug 2020 14:05:20 +0800
Message-ID: <CAAhV-H4amAWtNr-DTWV=W-g-B4eob3+zLjVDN5GgKMumnjqYjw@mail.gmail.com>
Subject: Re: [PATCH 2/5] dt-bindings: mips: Document Loongson kvm guest board
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Fuxin Zhang <zhangfx@lemote.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Thomas,

On Fri, Jul 31, 2020 at 7:57 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
>
>
>
> 在 2020/7/31 下午4:32, Thomas Bogendoerfer 写道:
> > On Fri, Jul 31, 2020 at 11:01:58AM +0800, Huacai Chen wrote:
> >> Hi, Thomas,
> >>
> >> On Wed, Jul 29, 2020 at 6:08 PM Huacai Chen <chenhc@lemote.com> wrote:
> >>> Hi, Thomas,
> >>>
> >>>
> >>> On Wed, Jul 29, 2020 at 6:00 PM Thomas Bogendoerfer
> >>> <tsbogend@alpha.franken.de> wrote:
> >>>> On Wed, Jul 29, 2020 at 02:58:36PM +0800, Huacai Chen wrote:
> >>>>> Document loongson64v-4core-virtio, a virtio based kvm guest board for
> >>>>> Loongson-3.
> >>>>>
> >>>>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> >>>>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> >>>>> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >>>> hmm, I can't remember adding my signed-off to this patch. Could you
> >>>> give me a reference for this ?
> >>>>
> >>> I'm sorry, this is a copy paste error..
> >>>
> >> Should I send V2 for this series?
> > no, if nothing else needs a resent. Problem with this series is,
> > that it touches a few places, so it's not clear who should merge
> > it...
>
> Actually the first patch is already in the next. I suspect they should
> go through MIPS tree.
> Probably this patch needs a ack from Rob?
I agree with Jiaxun, this series should go through MIPS tree.

Huacai
>
> - Jiaxun
>
> >
> > Thomas.
> >

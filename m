Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC579234212
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbgGaJJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:09:57 -0400
Received: from elvis.franken.de ([193.175.24.41]:56285 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731818AbgGaJJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 05:09:56 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1k1R33-0005K6-00; Fri, 31 Jul 2020 11:09:53 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 46B4FC0AFD; Fri, 31 Jul 2020 10:32:52 +0200 (CEST)
Date:   Fri, 31 Jul 2020 10:32:52 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 2/5] dt-bindings: mips: Document Loongson kvm guest board
Message-ID: <20200731083252.GA7946@alpha.franken.de>
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
 <1596005919-29365-2-git-send-email-chenhc@lemote.com>
 <20200729095248.GA9234@alpha.franken.de>
 <CAAhV-H7MzcW6Uv8XPaOh=5PmsFbRa9n=W1GjWP1WWwCYL_r-hA@mail.gmail.com>
 <CAAhV-H4SXCmW8V-fXhGGiSQbM4cQ3bN3K76JK61Ms+vWxiuviw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H4SXCmW8V-fXhGGiSQbM4cQ3bN3K76JK61Ms+vWxiuviw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 11:01:58AM +0800, Huacai Chen wrote:
> Hi, Thomas,
> 
> On Wed, Jul 29, 2020 at 6:08 PM Huacai Chen <chenhc@lemote.com> wrote:
> >
> > Hi, Thomas,
> >
> >
> > On Wed, Jul 29, 2020 at 6:00 PM Thomas Bogendoerfer
> > <tsbogend@alpha.franken.de> wrote:
> > >
> > > On Wed, Jul 29, 2020 at 02:58:36PM +0800, Huacai Chen wrote:
> > > > Document loongson64v-4core-virtio, a virtio based kvm guest board for
> > > > Loongson-3.
> > > >
> > > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > >
> > > hmm, I can't remember adding my signed-off to this patch. Could you
> > > give me a reference for this ?
> > >
> > I'm sorry, this is a copy paste error..
> >
> Should I send V2 for this series?

no, if nothing else needs a resent. Problem with this series is,
that it touches a few places, so it's not clear who should merge
it...

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

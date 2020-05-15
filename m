Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4483F1D5B46
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 23:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgEOVOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 17:14:09 -0400
Received: from elvis.franken.de ([193.175.24.41]:54593 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbgEOVOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 17:14:09 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jZheg-000560-01; Fri, 15 May 2020 23:14:06 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id A4250C04C5; Fri, 15 May 2020 23:13:53 +0200 (CEST)
Date:   Fri, 15 May 2020 23:13:53 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
Message-ID: <20200515211353.GB22922@alpha.franken.de>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-16-git-send-email-chenhc@lemote.com>
 <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
 <CAAhV-H7OTeMy2Yp2PunD+2KVzzPDT+-xGGgbpRNzhb8C-p8-7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H7OTeMy2Yp2PunD+2KVzzPDT+-xGGgbpRNzhb8C-p8-7g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 09:50:04AM +0800, Huacai Chen wrote:
> On Thu, May 14, 2020 at 9:34 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
> > 于 2020年5月13日 GMT+08:00 下午4:42:46, Huacai Chen <chenhc@lemote.com> 写到:
> > >James Hogan has become inactive for a long time and leaves KVM for MIPS
> > >orphan. I'm working on KVM/Loongson and attempt to make it upstream both
> > >in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
> > >QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> > >made some contributions in kernel and QEMU. If possible, we want to take
> > >the KVM/MIPS maintainership.
> > >
> > >Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > >---
> >
> > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> >
> > Huacai is extremely experienced on virtualization,
> > his PhD thesis is about virtualization too.
> > He had been working on Loongson kernel for a long period.
> >
> > Alexander maintained QEMU/MIPS for some years, he is a expert on
> > QEMU and MIPS architecture.
> >
> > I believe these guys can effectively bring MIPS/KVM support back to sea level again.
> Thank you very much, and I think you won't be disappointed in us.

I'm happy to see you taking care of the KVM part. So how is your plan
to handle patches ? Do want to collect them and send pull requests to
me ? Or should I just pick them up with your Acked-by ?

And could you do me a favour and check your mail setup. I always
get failed deliveries:

  chenhc@lemote.com
    SMTP error from remote mailer after end of data:
    host mxbiz1.qq.com [203.205.232.191]: 550 Mail content denied. http://servic
e.exmail.qq.com/cgi-bin/help?subtype=1&&id=20022&&no=1000726

or

  chenhc@lemote.com
    SMTP error from remote mailer after end of data:
    host mxbiz1.qq.com [203.205.232.191]: 550 Ip frequency limited. http://servi
ce.exmail.qq.com/cgi-bin/help?subtype=1&&id=20022&&no=1000725

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

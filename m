Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C9423B646
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 10:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgHDIFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 04:05:06 -0400
Received: from elvis.franken.de ([193.175.24.41]:33542 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgHDIFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 04:05:06 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1k2rwP-000517-00; Tue, 04 Aug 2020 10:04:57 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 5A819C0B3D; Tue,  4 Aug 2020 09:47:30 +0200 (CEST)
Date:   Tue, 4 Aug 2020 09:47:30 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Fuxin Zhang <zhangfx@lemote.com>
Subject: Re: [PATCH 2/5] dt-bindings: mips: Document Loongson kvm guest board
Message-ID: <20200804074730.GA7536@alpha.franken.de>
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
 <1596005919-29365-2-git-send-email-chenhc@lemote.com>
 <20200729095248.GA9234@alpha.franken.de>
 <CAAhV-H7MzcW6Uv8XPaOh=5PmsFbRa9n=W1GjWP1WWwCYL_r-hA@mail.gmail.com>
 <CAAhV-H4SXCmW8V-fXhGGiSQbM4cQ3bN3K76JK61Ms+vWxiuviw@mail.gmail.com>
 <20200731083252.GA7946@alpha.franken.de>
 <89376514-e6c1-469c-f212-865d7a549854@flygoat.com>
 <CAAhV-H4amAWtNr-DTWV=W-g-B4eob3+zLjVDN5GgKMumnjqYjw@mail.gmail.com>
 <a1147c93-8852-4a6f-fdee-214b64f2db65@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1147c93-8852-4a6f-fdee-214b64f2db65@flygoat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 03, 2020 at 05:13:39PM +0800, Jiaxun Yang wrote:
> 
> 
> 在 2020/8/3 下午2:05, Huacai Chen 写道:
> >Hi, Thomas,
> >
> >On Fri, Jul 31, 2020 at 7:57 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
> >>
> >>
> >>在 2020/7/31 下午4:32, Thomas Bogendoerfer 写道:
> >>>On Fri, Jul 31, 2020 at 11:01:58AM +0800, Huacai Chen wrote:
> >>>>Hi, Thomas,
> >>>>
> >>>>On Wed, Jul 29, 2020 at 6:08 PM Huacai Chen <chenhc@lemote.com> wrote:
> >>>>>Hi, Thomas,
> >>>>>
> >>>>>
> >>>>>On Wed, Jul 29, 2020 at 6:00 PM Thomas Bogendoerfer
> >>>>><tsbogend@alpha.franken.de> wrote:
> >>>>>>On Wed, Jul 29, 2020 at 02:58:36PM +0800, Huacai Chen wrote:
> >>>>>>>Document loongson64v-4core-virtio, a virtio based kvm guest board for
> >>>>>>>Loongson-3.
> >>>>>>>
> >>>>>>>Signed-off-by: Huacai Chen <chenhc@lemote.com>
> >>>>>>>Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> >>>>>>>Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >>>>>>hmm, I can't remember adding my signed-off to this patch. Could you
> >>>>>>give me a reference for this ?
> >>>>>>
> >>>>>I'm sorry, this is a copy paste error..
> >>>>>
> >>>>Should I send V2 for this series?
> >>>no, if nothing else needs a resent. Problem with this series is,
> >>>that it touches a few places, so it's not clear who should merge
> >>>it...
> >>Actually the first patch is already in the next. I suspect they should
> >>go through MIPS tree.
> >>Probably this patch needs a ack from Rob?
> >I agree with Jiaxun, this series should go through MIPS tree.
> 
> I'd suggest to have a topic branch for this after getting PCI tree merged.
> 
> Anyway, I really wish to see this as a part of 5.9 release.

I've applied patches 2-5 to mips-next. To avoid the mess with the
first patch, I've removed the case PCI_VENDOR_ID_REDHAT: from
patch 3 as this is the same as the default: case. It would help
a lot to not mix patches to different trees in one series next time.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

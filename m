Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A492B5D16
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 11:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgKQKkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 05:40:41 -0500
Received: from elvis.franken.de ([193.175.24.41]:37962 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbgKQKkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 05:40:40 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1keyPb-00016U-00; Tue, 17 Nov 2020 11:40:35 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id DF346C0211; Tue, 17 Nov 2020 11:40:06 +0100 (CET)
Date:   Tue, 17 Nov 2020 11:40:06 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] MIPS: kvm: Use vm_get_page_prot to get protection
 bits
Message-ID: <20201117104006.GA9345@alpha.franken.de>
References: <20201113110952.68086-1-tsbogend@alpha.franken.de>
 <20201113110952.68086-2-tsbogend@alpha.franken.de>
 <CAAhV-H7Sc6tmsfRcxOkx3rPk85Ey6XtxqhDB0RWokk+XSGVJ9A@mail.gmail.com>
 <20201116123009.GA7555@alpha.franken.de>
 <CAAhV-H57XNHurOYw8PG4=praXEWQ7h_TKM08cGBVRgAth1Rx1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H57XNHurOYw8PG4=praXEWQ7h_TKM08cGBVRgAth1Rx1A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 17, 2020 at 09:18:15AM +0800, Huacai Chen wrote:
> Hi, Thomas,
> 
> On Mon, Nov 16, 2020 at 8:35 PM Thomas Bogendoerfer
> <tsbogend@alpha.franken.de> wrote:
> >
> > On Sat, Nov 14, 2020 at 03:34:14PM +0800, Huacai Chen wrote:
> > > Hi, Thomas,
> > >
> > > On Fri, Nov 13, 2020 at 7:13 PM Thomas Bogendoerfer
> > > <tsbogend@alpha.franken.de> wrote:
> > > >
> > > > MIPS protection bits are setup during runtime so using defines like
> > > > PAGE_SHARED ignores this runtime changes. Using vm_get_page_prot
> > > > to get correct page protection fixes this.
> > > Is there some visible bugs if without this fix?
> >
> > no exec isn't enabled for these mappings, if cpu supports it.
> The whole series wants to set XI if supported?

that and RI where possible. I want to get rid of the PAGE_* defines,
because they lead to forgetting about RI and XI protection map setup,
which doesn't use the defines and would need another set of defines.
So by using only protection_map[] everything goes via one place.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12B51D6257
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgEPPib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 11:38:31 -0400
Received: from elvis.franken.de ([193.175.24.41]:55491 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbgEPPia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 11:38:30 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jZytP-0004GR-03; Sat, 16 May 2020 17:38:27 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 15B63C04D3; Sat, 16 May 2020 17:38:04 +0200 (CEST)
Date:   Sat, 16 May 2020 17:38:04 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
Message-ID: <20200516153804.GD3334@alpha.franken.de>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-16-git-send-email-chenhc@lemote.com>
 <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
 <CAAhV-H7OTeMy2Yp2PunD+2KVzzPDT+-xGGgbpRNzhb8C-p8-7g@mail.gmail.com>
 <20200515211353.GB22922@alpha.franken.de>
 <CAAhV-H58G7+se6VTBMo2R4joDXngF-c_W=fh8=zD8rVnono=gg@mail.gmail.com>
 <1a22adb0-0b7a-24a3-e762-7b9919a70a8e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a22adb0-0b7a-24a3-e762-7b9919a70a8e@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 16, 2020 at 01:55:23PM +0200, Paolo Bonzini wrote:
> On 16/05/20 11:36, Huacai Chen wrote:
> >> I'm happy to see you taking care of the KVM part. So how is your plan
> >> to handle patches ? Do want to collect them and send pull requests to
> >> me ? Or should I just pick them up with your Acked-by ?
> > I think we can only use the second method, because both Aleksandar and
> > me don't have a kernel tree in kernel.org now.
> 
> If you don't mind, I generally prefer to have MIPS changs submitted
> through the KVM tree, because KVM patches rarely have intrusive changes
> in generic arch files.  It's more common to have generic KVM patches
> that require touching all architectures.

works for me.

> For 5.8 I don't have anything planned that could cause conflicts, so
> this time it doesn't matter; but I can pick these up too if Thomas acks
> patches 6, 12 and 14.

I've acked all three pacthes

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

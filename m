Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFEF29107C
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 09:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437403AbgJQHSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 03:18:02 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43868 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411783AbgJQHSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 03:18:02 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09H7HL0w014146;
        Sat, 17 Oct 2020 09:17:21 +0200
Date:   Sat, 17 Oct 2020 09:17:21 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Jann Horn <jannh@google.com>
Cc:     Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jason Donenfeld <Jason@zx2c4.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, oridgar@gmail.com,
        ghammer@redhat.com, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Message-ID: <20201017071721.GA14143@1wt.eu>
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu>
 <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com>
 <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu>
 <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu>
 <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 17, 2020 at 08:55:34AM +0200, Jann Horn wrote:
> My suggestion is to use a counter *in the UAPI*, not in the hypervisor
> protocol. (And as long as that counter can only miss increments in a
> cryptographically negligible fraction of cases, everything's fine.)

OK I got it now and I agree.

> > If what is sought is pure
> > randomness (in the sense that it's unpredictable, which I don't think
> > is needed here), then randoms are better.
> 
> And this is what *the hypervisor protocol* gives us (which could be
> very useful for reseeding the kernel RNG).

As an external source, yes very likely, as long as it's not trivially
observable by everyone under the same hypervisor :-)

> > Now the initial needs in the forwarded message are not entirely clear
> > to me but I wanted to rule out the apparent mismatch between the expressed
> > needs for uniqueness and the proposed solutions solely based on randomness.
> 
> Sure, from a theoretical standpoint, it would be a little bit nicer if
> the hypervisor protocol included a generation number along with the
> 128-bit random value. But AFAIU it doesn't, so if we want this to just
> work under Microsoft's existing hypervisor, we'll have to make do with
> checking whether the random value changed. :P

OK got it, thanks for the explanation!

Willy

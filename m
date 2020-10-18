Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFB2291849
	for <lists+kvm@lfdr.de>; Sun, 18 Oct 2020 18:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgJRQOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Oct 2020 12:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgJRQOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Oct 2020 12:14:15 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B63CE22240
        for <kvm@vger.kernel.org>; Sun, 18 Oct 2020 16:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603037655;
        bh=QkAuJOFzVf0Wwxo6H++VdX8xdeoi48QFNUPVWESxEeY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rffJvgFw8irrIGZAcek+x0zg/gt4Gi/MwUN3UHhn0YsqDBUlTjD/VMQRp4txU3C+R
         9evpOGeEmginVuSv16P6vdFf9xqJoNVP8Pi/M625Nhhn3oq9KVeHXUUkp59uv/Qj1A
         1hXbIGy2bo1vH3hofY0qSAhRGjG62+Ze93DId1hg=
Received: by mail-wm1-f51.google.com with SMTP id a72so7946467wme.5
        for <kvm@vger.kernel.org>; Sun, 18 Oct 2020 09:14:14 -0700 (PDT)
X-Gm-Message-State: AOAM533IJp9kYt2U+wqNhSwKrvxYNHSDCbUTRmRV4rOIW7TIUUTm2WOy
        fQkRjo3liUaDjSsQSeH7KtoviljsHPdMGe+GuPgfUQ==
X-Google-Smtp-Source: ABdhPJzAXECqLOcgtU/8DSPTTXSAjc3cG+qUKXcQQZ/UMNZ2TU+94ycOvtKGPaT5rUWM66K+feNpmT6EZJqfh4RkIck=
X-Received: by 2002:a05:600c:2256:: with SMTP id a22mr13760040wmm.138.1603037652395;
 Sun, 18 Oct 2020 09:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com> <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu> <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu> <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
 <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
 <20201018114625-mutt-send-email-mst@kernel.org> <CALCETrXBJZnKXo2QLKVWSgAhSMdwEVHeut6pRw4P92CR_5A-fQ@mail.gmail.com>
 <20201018115524-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201018115524-mutt-send-email-mst@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 18 Oct 2020 09:14:00 -0700
X-Gmail-Original-Message-ID: <CALCETrUeRAhmEFR6EFXz8HzDYd2doZ2TMyZmu1pU_-yAPA6KDw@mail.gmail.com>
Message-ID: <CALCETrUeRAhmEFR6EFXz8HzDYd2doZ2TMyZmu1pU_-yAPA6KDw@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>, Willy Tarreau <w@1wt.eu>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
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
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 18, 2020 at 8:59 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sun, Oct 18, 2020 at 08:54:36AM -0700, Andy Lutomirski wrote:
> > On Sun, Oct 18, 2020 at 8:52 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Sat, Oct 17, 2020 at 03:24:08PM +0200, Jason A. Donenfeld wrote:
> > > > 4c. The guest kernel maintains an array of physical addresses that are
> > > > MADV_WIPEONFORK. The hypervisor knows about this array and its
> > > > location through whatever protocol, and before resuming a
> > > > moved/snapshotted/duplicated VM, it takes the responsibility for
> > > > memzeroing this memory. The huge pro here would be that this
> > > > eliminates all races, and reduces complexity quite a bit, because the
> > > > hypervisor can perfectly synchronize its bringup (and SMP bringup)
> > > > with this, and it can even optimize things like on-disk memory
> > > > snapshots to simply not write out those pages to disk.
> > > >
> > > > A 4c-like approach seems like it'd be a lot of bang for the buck -- we
> > > > reuse the existing mechanism (MADV_WIPEONFORK), so there's no new
> > > > userspace API to deal with, and it'd be race free, and eliminate a lot
> > > > of kernel complexity.
> > >
> > > Clearly this has a chance to break applications, right?
> > > If there's an app that uses this as a non-system-calls way
> > > to find out whether there was a fork, it will break
> > > when wipe triggers without a fork ...
> > > For example, imagine:
> > >
> > > MADV_WIPEONFORK
> > > copy secret data to MADV_DONTFORK
> > > fork
> > >
> > >
> > > used to work, with this change it gets 0s instead of the secret data.
> > >
> > >
> > > I am also not sure it's wise to expose each guest process
> > > to the hypervisor like this. E.g. each process needs a
> > > guest physical address of its own then. This is a finite resource.
> > >
> > >
> > > The mmap interface proposed here is somewhat baroque, but it is
> > > certainly simple to implement ...
> >
> > Wipe of fork/vmgenid/whatever could end up being much more problematic
> > than it naively appears -- it could be wiped in the middle of a read.
> > Either the API needs to handle this cleanly, or we need something more
> > aggressive like signal-on-fork.
> >
> > --Andy
>
>
> Right, it's not on fork, it's actually when process is snapshotted.
>
> If we assume it's CRIU we care about, then I
> wonder what's wrong with something like
> MADV_CHANGEONPTRACE_SEIZE
> and basically say it's X bytes which change the value...

I feel like we may be approaching this from the wrong end.  Rather
than saying "what data structure can the kernel expose that might
plausibly be useful", how about we try identifying some specific
userspace needs and see what a good solution could look like.  I can
identify two major cryptographic use cases:

1. A userspace RNG.  The API exposed by the userspace end is a
function that generates random numbers.  The userspace code in turn
wants to know some things from the kernel: it wants some
best-quality-available random seed data from the kernel (and possibly
an indication of how good it is) as well as an indication of whether
the userspace memory may have been cloned or rolled back, or, failing
that, an indication of whether a reseed is needed.  Userspace could
implement a wide variety of algorithms on top depending on its goals
and compliance requirements, but the end goal is for the userspace
part to be very, very fast.

2. A userspace crypto stack that wants to avoid shooting itself in the
foot due to inadvertently doing the same thing twice.  For example, an
AES-GCM stack does not want to reuse an IV, *expecially* if there is
even the slightest chance that it might reuse the IV for different
data.  This use case doesn't necessarily involve random numbers, but,
if anything, it needs to be even faster than #1.

The threats here are not really the same.  For #1, a userspace RNG
should be able to recover from a scenario in which an adversary clones
the entire process *and gets to own the clone*.  For example, in
Android, an adversary can often gain complete control of a fork of the
zygote -- this shouldn't adversely affect the security properties of
other forks.  Similarly, a server farm could operate by having one
booted server that is cloned to create more workers.  Those clones
could be provisioned with secrets and permissions post-clone, and at
attacker gaining control of a fresh clone could be considered
acceptable.  For #2, in contrast, if an adversary gains control of a
clone of an AES-GCM session, they learn the key outright -- the
relevant attack scenario is that the adversary gets to interact with
two clones without compromising either clone per se.

It's worth noting that, in both cases, there could possibly be more
than one instance of an RNG or an AES-GCM session in the same process.
This means that using signals is awkward but not necessarily
impossibly.  (This is an area in which Linux, and POSIX in general, is
much weaker than Windows.)

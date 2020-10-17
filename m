Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C5291200
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438058AbgJQNY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 09:24:28 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57293 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436577AbgJQNYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 09:24:24 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bac32541;
        Sat, 17 Oct 2020 12:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=uGCG7KNtg2p4bchOTMYLEyZNL+g=; b=QxUmPA
        mGKLUxw8T3WCFlV0XpwpKEj0fsH9rWxbR1s8qeVdIsVRxoYn0Qu7i3QvXemqb6UA
        fYbrwB8JGevznVpLa00KYO2fmQHumHJuYSy6jjVhji4gR/LlzFNK2Wou7HV+gLy+
        4KwI/h+xMMZGKOvyk2K3FbVosThwTVJEPa790gKKGbaiKnXIAdlQfLQBSVFaoe5I
        +6tnhlM1Gu53be2m6+cDvU6p4wJrwXfJ9FtzAC01yf+CsaTu+b75RVlQapwM4Ggk
        AyT7iGA+0UDknsRX9CBK0IqkEMLCEHce1RMYcRDtm6J+7dy+5XEcZezQ61gjqzI6
        zOhO/QG1w5i5FQug==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b66e6cb2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 17 Oct 2020 12:50:26 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id q9so7380252iow.6;
        Sat, 17 Oct 2020 06:24:21 -0700 (PDT)
X-Gm-Message-State: AOAM5337ef0MRnTGOcNE7I33BrLLSpaPXbhhh/VBBaqtmZwCLQVy2TUe
        vRWD24lmoduk1pWYLTGF77hwIC3M4wMyZbS0Tis=
X-Google-Smtp-Source: ABdhPJyVxZDidiJqmIZbWDt23iI4Qy6FrajshbbcrzIpyjI66H8R1XUYjnt0B8/rT53Orh6wpTDpZ4jH9cVkio72wDE=
X-Received: by 2002:a05:6638:f03:: with SMTP id h3mr5867605jas.36.1602941059429;
 Sat, 17 Oct 2020 06:24:19 -0700 (PDT)
MIME-Version: 1.0
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu> <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com> <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu> <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu> <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
In-Reply-To: <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 17 Oct 2020 15:24:08 +0200
X-Gmail-Original-Message-ID: <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
Message-ID: <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     Jann Horn <jannh@google.com>
Cc:     Willy Tarreau <w@1wt.eu>, Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After discussing this offline with Jann a bit, I have a few general
comments on the design of this.

First, the UUID communicated by the hypervisor should be consumed by
the kernel -- added as another input to the rng -- and then userspace
should be notified that it should reseed any userspace RNGs that it
may have, without actually communicating that UUID to userspace. IOW,
I agree with Jann there. Then, it's the functioning of this
notification mechanism to userspace that is interesting to me.

There are a few design goals of notifying userspace: it should be
fast, because people who are using userspace RNGs are usually doing so
in the first place to completely avoid syscall overhead for whatever
high performance application they have - e.g. I recall conversations
with Colm about his TLS implementation needing to make random IVs
_really_ fast. It should also happen as early as possible, with no
race or as minimal as possible race window, so that userspace doesn't
begin using old randomness and then switch over after the damage is
already done.

I'm also not wedded to using Microsoft's proprietary hypervisor design
for this. If we come up with a better interface, I don't think it's
asking too much to implement that and reasonably expect for Microsoft
to catch up. Maybe someone here will find that controversial, but
whatever -- discussing ideal designs does not seem out of place or
inappropriate for how we usually approach things in the kernel, and a
closed source hypervisor coming along shouldn't disrupt that.

So, anyway, here are a few options with some pros and cons for the
kernel notifying userspace that its RNG should reseed.

1. SIGRND - a new signal. Lol.

2. Userspace opens a file descriptor that it can epoll on. Pros are
that many notification mechanisms already use this. Cons is that this
requires syscall and might be more racy than we want. Another con is
that this a new thing for userspace programs to do.

3. We stick an atomic counter in the vDSO, Jann's suggestion. Pros are
that this is extremely fast, and also simple to use and implement.
There are enough sequence points in typical crypto programs that
checking to see whether this counter has changed before doing whatever
operation seems easy enough. Cons are that typically we've been
conservative about adding things to the vDSO, and this is also a new
thing for userspace programs to do.

4. We already have a mechanism for this kind of thing, because the
same issue comes up when fork()ing. The solution was MADV_WIPEONFORK,
where userspace marks a page to be zeroed when forking, for the
purposes of the RNG being notified when its world gets split in two.
This is basically the same thing as we're discussing here with guest
snapshots, except it's on the system level rather than the process
level, and a system has many processes. But the problem space is still
almost the same, and we could simply reuse that same mechanism. There
are a few implementation strategies for that:

4a. We mess with the PTEs of all processes' pages that are
MADV_WIPEONFORK, like fork does now, when the hypervisor notifies us
to do so. Then we wind up reusing the already existing logic for
userspace RNGs. Cons might be that this usually requires semaphores,
and we're in irq context, so we'd have to hoist to a workqueue, which
means either more wake up latency, or a larger race window.

4b. We just memzero all processes' pages that are MADV_WIPEONFORK,
when the hypervisor notifies us to do so. Then we wind up reusing the
already existing logic for userspace RNGs.

4c. The guest kernel maintains an array of physical addresses that are
MADV_WIPEONFORK. The hypervisor knows about this array and its
location through whatever protocol, and before resuming a
moved/snapshotted/duplicated VM, it takes the responsibility for
memzeroing this memory. The huge pro here would be that this
eliminates all races, and reduces complexity quite a bit, because the
hypervisor can perfectly synchronize its bringup (and SMP bringup)
with this, and it can even optimize things like on-disk memory
snapshots to simply not write out those pages to disk.

A 4c-like approach seems like it'd be a lot of bang for the buck -- we
reuse the existing mechanism (MADV_WIPEONFORK), so there's no new
userspace API to deal with, and it'd be race free, and eliminate a lot
of kernel complexity.

But 4b and 3 don't seem too bad either.

Any thoughts on 4c? Is that utterly insane, or does that actually get
us somewhere close to what we want?

Jason

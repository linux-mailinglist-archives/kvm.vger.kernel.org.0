Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5826B291546
	for <lists+kvm@lfdr.de>; Sun, 18 Oct 2020 04:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440093AbgJRCIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 22:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439906AbgJRCIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 22:08:35 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D588C0613D3
        for <kvm@vger.kernel.org>; Sat, 17 Oct 2020 19:08:33 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y16so7271468ljk.1
        for <kvm@vger.kernel.org>; Sat, 17 Oct 2020 19:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EoL7d0lHzdswPEFGsAEJJdNfE07sA8igVy5PEUcTbDQ=;
        b=JYBvkmsN9RysEeFQRgQMS2IGgQheKP8WCpVEITeoShBcDrScb2YzXJWCS9fBQBrxMO
         n86hAFDTEQHXskSLJ578m/TKYBOiwMg0z/aLu4hSKM9fzy3Bml2AtFnKiNFHXmC81ou5
         oLgoTyjjd7m8dU7zn1iDkaLBmUIFwukS3W1degboeUcB5xxmHAwJ7X7ZJjY5qLq4Uevz
         9565oX51vhmKmr/jiZRuPNAZjyZvYkS6kUYo9TyvCsqYY8xkBsy/gcixSZeElDfa4GKl
         lQjC5lLseYNii8XoYpb7znRj1djIzK3pwUzl9c71Hf2cfPLya0ovLXiar856omGyFgtc
         cBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EoL7d0lHzdswPEFGsAEJJdNfE07sA8igVy5PEUcTbDQ=;
        b=F33whTDL4L38MnuzF0jAXARsKotmtI38HkLj4WSNcFLk+rGt+3NBsAWTjUau5cRDsh
         IZGgxPp1w9R2RE4wxQnv3koX9aCIKphD/6f4Oba7FN4TQIh2iRu6DqtorR+1wkvc0bs5
         JOFH063ytGOzuiNkthBDvWIImR0/lMAl5Amks2Z9y8oaWrSUP+YZk8CW+/W4FpGzNNCy
         11DN8KzQd7LUiPKXt5+LpBWpdtc2s3xfBzlT8Dtld+1UdMFOI0VKSypOpXtZ2ovekwEF
         O73fJx3IIIb1t53G5sq/oJMurnOEX1a0+cFvo8q0CiTJFo2gKZQ9i/wdvMAHgkmani5L
         PWWA==
X-Gm-Message-State: AOAM530hJ82nmgfrzDcXm5EL3VQOrX0oOIjelOnxdWN5/fpHYnlqrehn
        hXwLhi5DHbS33bm4eepO8/tYxpM8sY/QFuAu8BRdFg==
X-Google-Smtp-Source: ABdhPJxVC4A8hz5Ph8xI5Lcuiwu6i49AGWglYFrVbrHYISFimwHqgN7R9bAY4u2r3Hi8cj+JpNCqLDs0HlkcXSFAtqI=
X-Received: by 2002:a05:651c:1313:: with SMTP id u19mr1073920lja.47.1602986911177;
 Sat, 17 Oct 2020 19:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu> <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com> <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu> <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu> <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
 <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com> <aacdff7a-2af1-4f46-6ab2-2a9d5b865d35@amazon.de>
In-Reply-To: <aacdff7a-2af1-4f46-6ab2-2a9d5b865d35@amazon.de>
From:   Jann Horn <jannh@google.com>
Date:   Sun, 18 Oct 2020 04:08:04 +0200
Message-ID: <CAG48ez0JYK2_tk0DuEgKY2y0d38N+O5HJrH2je7RRk6o7XBixA@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     Alexander Graf <graf@amazon.de>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, Willy Tarreau <w@1wt.eu>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
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
        Linux API <linux-api@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 17, 2020 at 8:09 PM Alexander Graf <graf@amazon.de> wrote:
> There are applications way beyond that though. What do you do with
> applications that already consumed randomness? For example a cached pool
> of SSL keys. Or a higher level language primitive that consumes
> randomness and caches its seed somewhere in an internal data structure.

For deterministic protection, those would also have to poll some
memory location that tells them whether the VmGenID changed:

1. between reading entropy from their RNG pool and using it
2. between collecting data from external sources (user input, clock,
...) and encrypting it

and synchronously shoot down the connection if a change happened. If
e.g. an application inside the VM has an AES-GCM-encrypted TLS
connection and, directly after the VM is restored, triggers an
application-level timeout that sends some fixed message across the
connection, then the TLS library must guarantee that either the VM was
already committed to sending exactly that message before the VM was
forked or the message will be blocked. If we don't do that, an
attacker who captures both a single packet from the forked VM and
traffic from the old VM can decrypt the next message from the old VM
after the fork (because AES-GCM is like AES-CTR plus an authenticator,
and CTR means that when keystream reuse occurs and one of the
plaintexts is known, the attacker can simply recover the other
plaintext using XOR).

(Or maybe, in disaster failover environments, TLS 1.3 servers could
get away with rekeying the connection instead of shooting it down? Ask
your resident friendly cryptographer whether that would be secure, I
am not one.)

I don't think a mechanism based around asynchronously telling the
application and waiting for it to confirm the rotation at a later
point is going to cut it; we should have some hard semantics on when
an application needs to poll this value.

> Or even worse: your system's host ssh key.

Mmmh... I think I normally would not want a VM to reset its host ssh
key after merely restoring a snapshot though? And more importantly,
Microsoft's docs say that they also change the VmGenID on disaster
failover. I think you very much wouldn't want your server to lose its
host key every time disaster failover happens. On the other hand,
after importing a public VM image, it might be a good idea.

I guess you could push that responsibility on the user, by adding an
option to the sshd_config that tells OpenSSH whether the host key
should be rotated on an ID change or not... but that still would not
be particularly pretty.

Ideally we would have the host tell us what type of events happened to
the VM, or something like that... or maybe even get the host VM
management software to ask the user whether they're importing a public
image... I really feel like with Microsoft's current protocol, we
don't get enough information to figure out what we should do about
private long-term authentication keys.

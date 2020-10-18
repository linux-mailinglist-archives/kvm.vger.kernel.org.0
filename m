Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9B291823
	for <lists+kvm@lfdr.de>; Sun, 18 Oct 2020 17:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgJRPyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Oct 2020 11:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbgJRPyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Oct 2020 11:54:51 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EC0A21D7F
        for <kvm@vger.kernel.org>; Sun, 18 Oct 2020 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603036490;
        bh=Ij8hCcQO2WHfMKXqZ9b6mcj8QwkRUY/6wK0sNA0dh5k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lzbXoiBwUCx8VRbmkG4nkt885exxkcqhAsuLb2fvr3fqkTlejSRJaeNyAYD2epEgu
         vJrqpsB5FALFVLCoGKlM+wXxG2Q+07RP85AFYpIjgIZz1hwOnr1NJ6Q7FSrx4ODrF0
         EFWrMcx3j36Aefjfb3FMwtF5XgySaAaPGPvN45OQ=
Received: by mail-wm1-f44.google.com with SMTP id a72so7917275wme.5
        for <kvm@vger.kernel.org>; Sun, 18 Oct 2020 08:54:50 -0700 (PDT)
X-Gm-Message-State: AOAM532GNBt/0f60bnkT2TfPn71y+zMdGwrQrss+d6GpEYjYZm0MQXyp
        EAlfPU9iV+oTTUUxlXzUo0MoH/0OQMmcXmH+r7OjZQ==
X-Google-Smtp-Source: ABdhPJzOzWCZEG9azNTIf9qwP5griKMHkVzCTru01xShRnsJyxl7Sq+uw//hwIlw3LWqPCYWr/akWwABt07P/Tsxr5M=
X-Received: by 2002:a05:600c:2256:: with SMTP id a22mr13689655wmm.138.1603036488608;
 Sun, 18 Oct 2020 08:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu> <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com> <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu> <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu> <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
 <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com> <20201018114625-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201018114625-mutt-send-email-mst@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 18 Oct 2020 08:54:36 -0700
X-Gmail-Original-Message-ID: <CALCETrXBJZnKXo2QLKVWSgAhSMdwEVHeut6pRw4P92CR_5A-fQ@mail.gmail.com>
Message-ID: <CALCETrXBJZnKXo2QLKVWSgAhSMdwEVHeut6pRw4P92CR_5A-fQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>, Willy Tarreau <w@1wt.eu>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
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

On Sun, Oct 18, 2020 at 8:52 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sat, Oct 17, 2020 at 03:24:08PM +0200, Jason A. Donenfeld wrote:
> > 4c. The guest kernel maintains an array of physical addresses that are
> > MADV_WIPEONFORK. The hypervisor knows about this array and its
> > location through whatever protocol, and before resuming a
> > moved/snapshotted/duplicated VM, it takes the responsibility for
> > memzeroing this memory. The huge pro here would be that this
> > eliminates all races, and reduces complexity quite a bit, because the
> > hypervisor can perfectly synchronize its bringup (and SMP bringup)
> > with this, and it can even optimize things like on-disk memory
> > snapshots to simply not write out those pages to disk.
> >
> > A 4c-like approach seems like it'd be a lot of bang for the buck -- we
> > reuse the existing mechanism (MADV_WIPEONFORK), so there's no new
> > userspace API to deal with, and it'd be race free, and eliminate a lot
> > of kernel complexity.
>
> Clearly this has a chance to break applications, right?
> If there's an app that uses this as a non-system-calls way
> to find out whether there was a fork, it will break
> when wipe triggers without a fork ...
> For example, imagine:
>
> MADV_WIPEONFORK
> copy secret data to MADV_DONTFORK
> fork
>
>
> used to work, with this change it gets 0s instead of the secret data.
>
>
> I am also not sure it's wise to expose each guest process
> to the hypervisor like this. E.g. each process needs a
> guest physical address of its own then. This is a finite resource.
>
>
> The mmap interface proposed here is somewhat baroque, but it is
> certainly simple to implement ...

Wipe of fork/vmgenid/whatever could end up being much more problematic
than it naively appears -- it could be wiped in the middle of a read.
Either the API needs to handle this cleanly, or we need something more
aggressive like signal-on-fork.

--Andy

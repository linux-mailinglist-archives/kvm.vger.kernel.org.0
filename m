Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD73290F78
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 07:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436557AbgJQFjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 01:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436538AbgJQFjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 01:39:43 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98260C05BD2E
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 22:01:59 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i2so4994880ljg.4
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 22:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hx7Q/ww8SNQlC+Vff55Qg1KHQPfa6zByV8YGUpfQHNk=;
        b=Mj4ipAZT8hm2EFBVYWNa/tPYN08h/c6I9aqqDDNKd/U1Gx8lY/fq6SCOLleNehgJrg
         16iTyZDjW3bOYh1hhqWtA77oKiTI+TPM4N1Keo/JnJzSrlqFLzW7RPlCSwXodHNBHioe
         60sjtbu/3EHa3YEwd0uy5df4RemUuD5LYm5H+8Y1Jz0qZOf6lUVUq/8KwhvUZ8M3r7Gw
         bWF2ycp8+cBNuu5EidPWzLVcRpMEVOSaAgokNP1gQ/Vcr6lzp6alR3rT1I0+BfHSKna1
         MUB9pFRtzc7GBqzTpgUnKrsGKvi+izpGnZj97WNgEpuknnloyOVePKBpgA5B1rIzMjOM
         A/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hx7Q/ww8SNQlC+Vff55Qg1KHQPfa6zByV8YGUpfQHNk=;
        b=CYjdKb7SzqWSyDDBt/qgB6xof1+XjdJZwB7A8oct3CHnDK/paql9WlQSUkPSyUVchl
         Nhq3TzTvMHytQZY3YT/DTh7IQpryqqzLmgdjN2vyiWZvtTuceTDo2OKoaPzRnnsY71nq
         kGiSW8mkzhdwJxhS0DkNJxgBiEdnjJ+fXuk8RtuwPpzrIgLZB/OWXXmK1cckIjuWqCtO
         IP/oFQIr2i6FPgtCgsNdRFGGkzPhk72wPsUggKcT4YoZDgrBL6P+KdHk5thfn1vlswgv
         wKcChn1CBw2j8LJWGAj4fE88zZUQDVZDeruVmAAPrCIaFTcBBGX5cXDmHEG/BtgmF6hy
         vFEw==
X-Gm-Message-State: AOAM531gCZE9utwEotI1GqcgBMnnvzL/VOrirKKnDMkYe7FjO+BGOn62
        pFd51QXW8wX5OsV9CayjMgxIeqExCykx/uXHN3pgFw==
X-Google-Smtp-Source: ABdhPJxCQSIczBapjLlcHFxQX22QzzHRPdqAFoK5FO3ftEN502eaH7vfcq23H3Fg7kt7YZD0VFtLi0VxAAPhKjminMo=
X-Received: by 2002:a2e:b6cf:: with SMTP id m15mr2566942ljo.74.1602910917566;
 Fri, 16 Oct 2020 22:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu> <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com>
In-Reply-To: <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 17 Oct 2020 07:01:31 +0200
Message-ID: <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     Colm MacCarthaigh <colmmacc@amazon.com>
Cc:     Willy Tarreau <w@1wt.eu>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 17, 2020 at 6:34 AM Colm MacCarthaigh <colmmacc@amazon.com> wro=
te:
> On 16 Oct 2020, at 21:02, Jann Horn wrote:
> > On Sat, Oct 17, 2020 at 5:36 AM Willy Tarreau <w@1wt.eu> wrote:
> > But in userspace, we just need a simple counter. There's no need for
> > us to worry about anything else, like timestamps or whatever. If we
> > repeatedly fork a paused VM, the forked VMs will see the same counter
> > value, but that's totally fine, because the only thing that matters to
> > userspace is that the counter changes when the VM is forked.
>
> For user-space, even a single bit would do. We added MADVISE_WIPEONFORK
> so that userspace libraries can detect fork()/clone() robustly, for the
> same reasons. It just wipes a page as the indicator, which is
> effectively a single-bit signal, and it works well. On the user-space
> side of this, I=E2=80=99m keen to find a solution like that that we can u=
se
> fairly easily inside of portable libraries and applications. The =E2=80=
=9Chave
> I forked=E2=80=9D checks do end up in hot paths, so it=E2=80=99s nice if =
they can be
> CPU cache friendly. Comparing a whole 128-bit value wouldn=E2=80=99t be m=
y
> favorite.

I'm pretty sure a single bit is not enough if you want to have a
single page, shared across the entire system, that stores the VM
forking state; you need a counter for that.

> > And actually, since the value is a cryptographically random 128-bit
> > value, I think that we should definitely use it to help reseed the
> > kernel's RNG, and keep it secret from userspace. That way, even if the
> > VM image is public, we can ensure that going forward, the kernel RNG
> > will return securely random data.
>
> If the image is public, you need some extra new raw entropy from
> somewhere. The gen-id could be mixed in, that can=E2=80=99t do any harm a=
s
> long as rigorous cryptographic mixing with the prior state is used, but
> if that=E2=80=99s all you do then the final state is still deterministic =
and
> non-secret.

Microsoft's documentation
(http://go.microsoft.com/fwlink/?LinkId=3D260709) says that the VM
Generation ID that we get after a fork "is a 128-bit,
cryptographically random integer value". If multiple people use the
same image, it guarantees that each use of the image gets its own,
fresh ID: The table in section "How to implement virtual machine
generation ID support in a virtualization platform" says that (among
other things) "Virtual machine is imported, copied, or cloned"
generates a new generation ID.

So the RNG state after mixing in the new VM Generation ID would
contain 128 bits of secret entropy not known to anyone else, including
people with access to the VM image.

Now, 128 bits of cryptographically random data aren't _optimal_; I
think something on the order of 256 bits would be nicer from a
theoretical standpoint. But in practice I think we'll be good with the
128 bits we're getting (since the number of users who fork a VM image
is probably not going to be so large that worst-case collision
probabilities matter).

> The kernel would need to use the change as a trigger to
> measure some entropy (e.g. interrupts and RDRAND, or whatever). Our just
> define the machine contract as =E2=80=9Cthis has to be unique random data=
 and
> if it=E2=80=99s not unique, or if it=E2=80=99s pubic, you=E2=80=99re toas=
t=E2=80=9D.

As far as I can tell from Microsoft's spec, that is a guarantee we're
already getting.

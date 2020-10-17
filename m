Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD2D290FA4
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 07:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436763AbgJQFxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 01:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436688AbgJQFxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 01:53:17 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3818C0613E7
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 22:53:16 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id c21so5013200ljn.13
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 22:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M3YB82PP3WUpBHFEbh3oPhQQSux8Pw6AFe+SN7DiJGw=;
        b=amsP3PlI3ZycdlVxgLx5tS3RcZ/aE2JugXN/de8WjJzEbbWQfg5yay9mu9yMNOTQEG
         zDGufeyQG0D8nAwfy0A+eh+5b93z85bXUL2cX8T/4mhVh2wiIWZNqlk28ZRb4QzNB/dh
         AIBnGWL+ksEigCgQdVu62IDy26gLVIDUnczpRvNend8MTTwuaCQtont43SmFPbW4CRcT
         cmRIzAt2jsd2hPhc8PRzFfChw9wh+qGJaBiAl8a3e2bI5TkwKjB9tCNO3N3jC/SV0wIn
         USEp5Yt0/QCw/q0JJrWcSGJN2B9ryqMiiGMVPf4OXy69UAR96sfkVVyhw3En3TdcYtr6
         S+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M3YB82PP3WUpBHFEbh3oPhQQSux8Pw6AFe+SN7DiJGw=;
        b=pDCJzusI+9KBOPl37L3EFXmuYWB/B8NuxUgzmoYLKf6PjjfIMgI0eMkXxoRmsgMc62
         xJUT+qQLjuIfj0/27N5mChf3qRU4kqUPkilNk9KAh/1AnUZkvcrA8OsEI3KFIgqffGBM
         BcZwnmvxlH5STEttEM5HZKP8oIfOm1+TVHh1HoE/hT6rKpF4hk+uuHCaMJZ3O1cLpvxN
         VTpCvO4vrajcPWwtGg6iW7BC389cOScZ6Ov8PYTuzFLyLLcBMoXoYnamZAyd1FZD1B6n
         79FbH6/WaA2NhsNPSk3FXoFy6IAYDLOWr5FZsWEwK9twCaqaDtnauzXYclWLJKWEP64M
         xBhg==
X-Gm-Message-State: AOAM532ePyb9oq9Sfwjz3f8XIWN6I8IeAqVpyHoAn41G6iR82hwbCsPy
        vk61npK6oGhmqyzKe7JwrKtlpbWR/K1apOnpGhg0Ng==
X-Google-Smtp-Source: ABdhPJyqRwgfzaNO4k6jC4+ngiz4xp94h1rvkVA6jI+YkhoWwbWi6nRJWMl5uQZtM/9C6Yz+umn28GEOA1tFiD8OGAE=
X-Received: by 2002:a2e:504b:: with SMTP id v11mr2673538ljd.138.1602913994976;
 Fri, 16 Oct 2020 22:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu> <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com> <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu>
In-Reply-To: <20201017053712.GA14105@1wt.eu>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 17 Oct 2020 07:52:48 +0200
Message-ID: <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     Willy Tarreau <w@1wt.eu>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 17, 2020 at 7:37 AM Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Oct 17, 2020 at 07:01:31AM +0200, Jann Horn wrote:
> > Microsoft's documentation
> > (http://go.microsoft.com/fwlink/?LinkId=260709) says that the VM
> > Generation ID that we get after a fork "is a 128-bit,
> > cryptographically random integer value". If multiple people use the
> > same image, it guarantees that each use of the image gets its own,
> > fresh ID:
>
> No. It cannot be more unique than the source that feeds that cryptographic
> transformation. All it guarantees is that the entropy source is protected
> from being guessed based on the output. Applying cryptography on a simple
> counter provides apparently random numbers that will be unique for a long
> period for the same source, but as soon as you duplicate that code between
> users and they start from the same counter they'll get the same IDs.
>
> This is why I think that using a counter is better if you really need something
> unique. Randoms only reduce predictability which helps avoiding collisions.

Microsoft's spec tells us that they're giving us cryptographically
random numbers. Where they're getting those from is not our problem.
(And if even the hypervisor is not able to collect enough entropy to
securely generate random numbers, worrying about RNG reseeding in the
guest would be kinda pointless, we'd be fairly screwed anyway.)

Also note that we don't actually need to *always* reinitialize RNG
state on forks for functional correctness; it is fine if that fails
with a probability of 2^-128, because functionally everything will be
fine, and an attacker who is that lucky could also just guess an AES
key (which has the same probability of being successful). (And also
2^-128 is such a tiny number that it doesn't matter anyway.)

> And I'm saying this as someone who had on his external gateway the same SSH
> host key as 89 other hosts on the net, each of them using randoms to provide
> a universally unique one...

If your SSH host key was shared with 89 other hosts, it evidently
wasn't generated from cryptographically random numbers. :P Either
because the key generator was not properly hooked up to the system's
entropy pool (if you're talking about the Debian fiasco), or because
the system simply did not have enough entropy available. (Or because
the key generator is broken, but I don't think that ever happened with
OpenSSH?)

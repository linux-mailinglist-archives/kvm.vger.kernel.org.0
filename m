Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7186E11C09F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 00:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfLKXeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 18:34:46 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45084 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLKXep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 18:34:45 -0500
Received: by mail-lf1-f65.google.com with SMTP id 203so171362lfa.12
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 15:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=McF4m/OHEBC1L05eglJmJ+UhN+oTS3o4fcogIM9KyH0=;
        b=gPoCDuRLA2ViDUzUbkM3G3Kyn0SFQNWxjT+whG12NfO7GiTrZs/LjMAzjC0Xif25VD
         fq6sTmg1Yrl4llSnmU7pKgyBrAv8MqwjdvELYIXpadZjLbzb4KXmj8Ie8UQlqYmvr1cT
         RwIe3aqLO3jmw0ep20qFbwAmmxLrgQUADoSKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=McF4m/OHEBC1L05eglJmJ+UhN+oTS3o4fcogIM9KyH0=;
        b=sQfn1qBKBQ5Nb/Xyuj/XK/8tNQphdwi0kbaBlIJS+8wIVlHt97mmLUA5dF6tgH/Fmy
         P76wEwMBK9+909ucJ5h4DOn3HzmqdT6Lh8rUfspb7e5oNNBo2/kV2EjFulXPQTlF1cu9
         VEinyGZ13ZRfGA3Wnmjz41cxeKl16nBHZLDhxYpy7WE6j8aPFZk+ESHmA3LVeH25/M84
         q1aB9xkwW8T41SqeiAfqwDiyWT7LZMe3NtKOzdveWQklfG0M86Ovs77120s4E1tv244g
         Fzhb12/DdOMBQkGRiBpx0lH26SLXLPVnR36HDn9YxpUU4g4JOU0hu+6EiPwWaj1XVxmB
         yt5w==
X-Gm-Message-State: APjAAAUPhfVZdptKgIExPGOnZLaae6WMRITTfLR5S87rGocWvwNMy7db
        +6+8718reqfWVJHxzeIOm19RFR7Qn28=
X-Google-Smtp-Source: APXvYqyKyekNl+VEvD9LTCj5yptZU+QySST03oFfmJ9ejFh7fDlo+Yk/9mFyASsvnwqfz/3shD6LLA==
X-Received: by 2002:ac2:4d04:: with SMTP id r4mr3818738lfi.77.1576107282860;
        Wed, 11 Dec 2019 15:34:42 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id a24sm1886560ljp.97.2019.12.11.15.34.42
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 15:34:42 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id m30so185089lfp.8
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 15:34:42 -0800 (PST)
X-Received: by 2002:a05:6512:c7:: with SMTP id c7mr4092706lfp.120.1576107281798;
 Wed, 11 Dec 2019 15:34:41 -0800 (PST)
MIME-Version: 1.0
References: <CAAfnVB=8aWSHXHOP8erepbuxOO_-yz04tm8ToA7pLwNAYqA-xQ@mail.gmail.com>
 <dee7353e807f5ea2c8a7e84623332f1b@www.loen.fr>
In-Reply-To: <dee7353e807f5ea2c8a7e84623332f1b@www.loen.fr>
From:   Gurchetan Singh <gurchetansingh@chromium.org>
Date:   Wed, 11 Dec 2019 15:34:30 -0800
X-Gmail-Original-Message-ID: <CAAfnVBmhusVt5yTGvh2KtcH_Q6gDdb-FXqY8JBuTKSPDXvGJOw@mail.gmail.com>
Message-ID: <CAAfnVBmhusVt5yTGvh2KtcH_Q6gDdb-FXqY8JBuTKSPDXvGJOw@mail.gmail.com>
Subject: Re: How to expose caching policy to a para-virtualized guest?
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Gerd Hoffmann <kraxel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 3:08 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Gurchetan,
>
> I don't know anything about graphics API, so please bear with me.

Vulkan exposes the concept of memory types to userspace.  These memory
types describe the memory properties of a heap.  For example, any
memory type with the HOST_COHERENT_BIT specifies the application isn't
required to send certain cache management commands
(vkFlushMappedMemoryRanges, vkInvalidateMappedMemoryRanges).

1) HOST_CACHED => cached, no cache management
2) HOST_COHERENT_BIT => write combine, no cache management, no snooping
3) HOST_COHERENT_BIT | HOST_CACHED => cached, gpu snoops cpu caches,
no cache management

Here's some more reading on that:

https://static.docs.arm.com/100019/0100/arm_mali_application_developer_best_practices_developer_guide_100019_0100_00_en2.pdf

(1) and (3) aren't too difficult -- just use
KVM_SET_USER_MEMORY_REGION. (2) is, since it may lead to inconsistent
mappings.

vmware has a very nice emulated solution for this:

https://lwn.net/Articles/804114/

We're planning on building off vmware's solution, and if possible, add
some additional optimizations.

>
> On 2019-12-11 01:32, Gurchetan Singh wrote:
> > Hi,
> >
> > We're trying to implement Vulkan with virtio-gpu, and that API
> > exposes
> > the difference between cached and uncached mappings to userspace
> > (i.e,
> > some older GPUs can't snoop the CPU's caches).
> >
> > We need to make sure that the guest and host caching attributes are
> > aligned, or there's a proper API between the virtio driver and device
> > to ensure coherence.
>
> I think you trying to cross two barriers at once here.
>
> Virtio is always coherent between host and guest, and the guest should
> use cacheable mappings. That's at least my expectation, and I don't
> know of any exception to this rule.

Where is this ruled stated?  We may need to modify the spec.  At the
very least, we need anything mapped on the host with HOST_COHERENT_BIT
only to be write combine in the guest.

However, there's an additional caveat: on x86, cache management
(clflush) is available to the guest.  So it's possible to map host
cached memory as write-combine, and import guest memory to Vulkan.
This is an optimization limited to non-zero amount of x86 devices.

So, something like arch_does_guest_attribute_matter() or
arch_can_guest_flush() in the guest kernel would be useful.  But it
doesn't sound like this is readily available?

> You have then the coherency of the physical device, and that's a host
> kernel (and maybe userspace) matter. Why should the guest ever know
> about
> this constraint?
>
> > One issue that needs to be addressed is the caching policy is
> > variable
> > dependent on the VM configuration and architecture.  For example, on
> > x86, it looks like a MTRR controls whether the guest caching
> > attribute
> > predominates[1].  On ARM, it looks like the MMU registers control
> > whether the guest can override the host attribute, but in general
> > it's
> > most restrictive attribute that makes a difference[2].  Let me if
> > that's incorrect.
>
> For ARM, this is true up to ARMv8.3. Starting with ARMv8.4, FWB gives
> the hypervisor the opportunity to force memory mappings as cacheable
> write-back. None of that is visible to userspace, thankfully.

Is there some open-source code available on ARM showing how the MMU is
configured (which forces guest attribute override)?

>
> > I'm wondering if there's some standard kernel API to query such
> > attributes.  For example, something like
> > arch_does_guest_attribute_matter() or arch_can_guest_flush() would do
> > the trick.  Without this, we may need to introduce VIRTIO_GPU_F_*
> > flags set by the host, but that may make the already giant QEMU
> > command line even bigger.
>
> If something has to manage the coherency, it should be the host that
> knows how the memory traffic flows between host and guest, and apply
> cache management as required. Note that on arm64, cache management
> instructions are available from userspace. On systems that are
> fully coherent, they are expected to be little more than NOPs.
>
>  From the above, it is pretty obvious that I don't understand what
> problem you are trying to solve. Maybe you could explain how
> you envisage things to work, who maps what where, and the expected
> semantics. Once we have a common understanding of the problem,
> maybe we can think of a decent solution.
>
> Thanks,
>
>          M.
> --
> Jazz is not dead. It just smells funny...

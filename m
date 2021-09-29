Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0987541CBC1
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 20:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345837AbhI2SYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 14:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345440AbhI2SYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 14:24:00 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B637AC06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 11:22:18 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i19so11530047lfu.0
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 11:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qtfpl4QD2zskjNpgRMOv1rx5s1LAJUZnW7UP8LdwoyI=;
        b=jNO8noc6wU0vBuBuA5SgzKDJSdjcJtQzSu6NU2uxa8ZSMdSU0rBu5zmLhm+/yKCjoy
         ef+9UZO7RcYlfw89pWUi7lY4xnn8me2aZdS3wY5HXVu5P3KcRiAQQ6flwJa5W7D9nNWE
         +vtTRXVJPaeLOhyI/rzF4EWfzApnPvO8UWRG2sY1OU74NZvn/66Z2/yMf3454os4jWBw
         iQT+Gwy5fTV072sCo8419n5yroRDCEbVmOY6QLwxGPPPnFv8scUz0XuRBI51kwyt2WTW
         3VWE5RJiCfA+/3QrFCWXNZWBAWYucDnltzpZp8V3SPSuPmWyMavydbnEeT8F6fDR5ZBi
         midQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qtfpl4QD2zskjNpgRMOv1rx5s1LAJUZnW7UP8LdwoyI=;
        b=KaPssxFTD2lXlHtWKDw6ERziu411jtsrBVpf14kKmugi+z0hnkTJzbdMQS/G0ow4Bs
         1hhHMExias2sb2xkeXOj0NzgmXu1P8c80q9nrkrKMQiD9Sxl9YvhetSN6e62YnzttTrL
         EiLY58CjRVj/bDFQK8PVZiLPBwMQvoqpHwRhMJ/UsWENlX29R3LTlBRCOTt2lrEYH6cX
         cXsQE+cpaBWhMlh6sxQtEQUJtL+P2ZR+xATwlNeGXY6xMXhAm0doeuPlCtacFUZ0ZWsl
         D7aWLXW0P6/l1JIY7nUUdk9E6Q0f1JFEVEVXK/oTfohkNeGIafsDJTSox6Sl/xebsJrw
         IWvA==
X-Gm-Message-State: AOAM530yjiM3WOo/rvuNZPNm/gQ9yx7/6gxFSdY0Yfitwg2S7Av7nIn3
        6Ddr4ZJX6utPUjogy2TrORErm8DjMkK/A5ZoQiLINCn7tJB8tQ==
X-Google-Smtp-Source: ABdhPJzaUBqKkCyaK9Fbh1Rz2z0TQHkOtkLi8JOjPmgJpuI5lcxIdv+YXlRfj2naCQ46/v6CbxB5cMwrUmzNFTnMYlI=
X-Received: by 2002:ac2:4217:: with SMTP id y23mr1086804lfh.361.1632939736699;
 Wed, 29 Sep 2021 11:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com> <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
In-Reply-To: <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 29 Sep 2021 11:22:05 -0700
Message-ID: <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        pshier@google.com, ricarkol@google.com, rananta@google.com,
        reijiw@google.com, jingzhangos@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        Alexandru.Elisei@arm.com, suzuki.poulose@arm.com,
        Peter Maydell <peter.maydell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 12:40 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Aug 26, 2021 at 06:49:27PM +0000, Oliver Upton wrote:
> > On Thu, Aug 26, 2021 at 09:37:42AM +0100, Marc Zyngier wrote:
> > > On Wed, 25 Aug 2021 19:14:59 +0100,
> > > Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > On Wed, Aug 25, 2021 at 8:07 AM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > [...]
> > >
> > > > > Thanks for including me Marc. I think you've mentioned all the examples
> > > > > of why we don't generally expect N+1 -> N migrations to work that I
> > > > > can think of. While some of the examples like get-reg-list could
> > > > > eventually be eliminated if we had CPU models to tighten our machine type
> > > > > state, I think N+1 -> N migrations will always be best effort at most.
> > > > >
> > > > > I agree with giving userspace control over the exposer of the hypercalls
> > > > > though. Using pseudo-registers for that purpose rather than a pile of
> > > > > CAPs also seems reasonable to me.
> > > > >
> > > > > And, while I don't think this patch is going to proceed, I thought I'd
> > > > > point out that the opt-out approach doesn't help much with expanding
> > > > > our migration support unless we require the VMM to be upgraded first.
> > > > >
> > > > > And, even then, the (N_kern, N+1_vmm) -> (N+1_kern, N_vmm) case won't
> > > > > work as expected, since the source enforce opt-out, but the destination
> > > > > won't.
> > > >
> > > > Right, there's going to need to be a fence in both kernel and VMM
> > > > versions. Before the fence, you can't rollback with either component.
> > > > Once on the other side of the fence, the user may freely migrate
> > > > between kernel + VMM combinations.
> > > >
> > > > > Also, since the VMM doesn't key off the kernel version, for the
> > > > > most part N+1 VMMs won't know when they're supposed to opt-out or not,
> > > > > leaving it to the user to ensure they consider everything. opt-in
> > > > > usually only needs the user to consider what machine type they want to
> > > > > launch.
> > > >
> > > > Going the register route will implicitly require opt-out for all old
> > > > hypercalls. We exposed them unconditionally to the guest before, and
> > > > we must uphold that behavior. The default value for the bitmap will
> > > > have those features set. Any hypercalls added after that register
> > > > interface will then require explicit opt-in from userspace.
> > >
> > > I disagree here. This makes the ABI inconsistent, and means that no
> > > feature can be implemented without changing userspace. If you can deal
> > > with the existing features, you should be able to deal with the next
> > > lot.
> > >
> > > > With regards to the pseudoregister interface, how would a VMM discover
> > > > new bits? From my perspective, you need to have two bitmaps that the
> > > > VMM can get at: the set of supported feature bits and the active
> > > > bitmap of features for a running guest.
> > >
> > > My proposal is that we have a single pseudo-register exposing the list
> > > of implemented by the kernel. Clear the bits you don't want, and write
> > > back the result. As long as you haven't written anything, you have the
> > > full feature set. That's pretty similar to the virtio feature
> > > negotiation.
> >
> > Ah, yes I agree. Thinking about it more we will not need something
> > similar to KVM_GET_SUPPORTED_CPUID.
> >
> > So then, for any register where userspace/KVM need to negotiate
> > features, the default value will return the maximum feature set that is
> > supported. If userspace wants to constrain features, read out the
> > register, make sure everything you want is there, and write it back
> > blowing away the superfluous bits. Given this should we enforce ordering
> > on feature registers, such that a VMM can only write to the registers
> > before a VM is started?
>
> That's a good idea. KVM_REG_ARM64_SVE_VLS has this type of constraint so
> we can model the feature register control off that.
>
> >
> > Also, Reiji is working on making the identity registers writable for the
> > sake of feature restriction. The suggested negotiation interface would
> > be applicable there too, IMO.
>
> This this interesting news. I'll look forward to the posting.
>
> >
> > Many thanks to both you and Drew for working this out with me.
> >
>
> Thanks,
> drew
>

Hey folks,

I have some lingering thoughts on this subject since we last spoke and
wanted to discuss.

I'm having a hard time figuring out how a VMM should handle a new
hypercall identity register introduced on a newer kernel. In order to
maintain guest ABI, the VMM would need to know about that register and
zero it when restoring an older guest.

Perhaps instead we could reserve a range of firmware registers as the
'hypercall identity' registers. Implement all of them as RAZ/WI by
default, encouraging userspace to zero these registers away for older
VMs but still allowing an old userspace to pick up new KVM features.
Doing so would align the hypercall identity registers with the feature
ID registers from the architecture.

Thoughts?

--
Thanks,
Oliver

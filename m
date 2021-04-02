Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B9C35253B
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 03:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhDBBkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 21:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhDBBkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 21:40:45 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74761C0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 18:40:45 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r193so1113339ior.9
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 18:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BYRYEHo5Qq9x0q8CQNej+qVvQqMTQr6QPG404HMuZyQ=;
        b=wIr572cj7EWZQK2u5tojEpXl8Iq/tC76EPb1VHr9GTOz2eMWV+fFJmZKERo0gznlnz
         MyQnMNQKrwvJLaJJKXG3FC/3Vxecz7BrkuPPvmOE+G1jV/yO3iOPIu8G1MHui7BemZta
         eU1lhOjvXvqEI4txZ8GEv2JB7IzTGPODDtbdeWupsIhF5bGC4Wo4JxubVTauO0WRHkwb
         qMS7Jr5SJhwx7Ng575id5ACcCkJ+/nwEDyBhtqvIz8sKDowQ7mHKRSPRKlIGYvfCj93N
         2QNQ2aoUAAZuu7wsfDmnpxYJJrB0PxTx6E8R/0UqKT3+PwyFxVx9ZMcqep07j9WXRDxh
         2veA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BYRYEHo5Qq9x0q8CQNej+qVvQqMTQr6QPG404HMuZyQ=;
        b=QQsggMzW4ZNyIWohyFoUFDkoq8GqmeHIBFocDeKtpFIlza0MmtgqsehlJXcbjX7I6A
         y1gaSqU9CswRq5Fyu8RilowTokzars3JDC/pW6wKBRDtGeJ2P4iWAwpMU8jxaH+sb6AV
         79Mctj2gNn2Ta2etJF0br5dMyMpy2htWDrmm+DzP+hveTV9B+tUHC726NPvkyZPWcmr9
         OXdt1ix7Xu1kEQSO30snmhqz0sElj0+MdbQdyDEERCr7pIThcjazXlCSPcWCckZMbKkh
         lPwPp7In7d/JzyLnY0hIaBORp261508+T0TFE/DRjM6QLRusz5rG9PLbWkj1sySrusfY
         4rLQ==
X-Gm-Message-State: AOAM533htz8wZ0KMG1QasozuJcfLeiVZ/e2qzhvXX2g0MfFK9UrBd4m5
        AMdOFxPx0htWo/8jXdXMxsCfwRhTG/zmdb/KLqIN9Q==
X-Google-Smtp-Source: ABdhPJzZTqNstwSg+fmrmIvqxruwwnuUKcvg/aS2kCLMyyOUqLWd5Obf0qRjUVqrqTzczeGMbKLBwut5r5dr8GzsOyA=
X-Received: by 2002:a5d:8ad2:: with SMTP id e18mr9221863iot.51.1617327644384;
 Thu, 01 Apr 2021 18:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com> <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server> <YDkzibkC7tAYbfFQ@google.com>
 <20210302145543.GA29994@ashkalra_ubuntu_server> <20210303185441.GA19944@willie-the-truck>
 <20210311181458.GA6650@ashkalra_ubuntu_server> <CABayD+cXH0oeV4-Ah3y6ThhNt3dhd0qDh6JmimjSz=EFjC+SYw@mail.gmail.com>
 <20210319175953.GA585@ashkalra_ubuntu_server>
In-Reply-To: <20210319175953.GA585@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 1 Apr 2021 18:40:06 -0700
Message-ID: <CABayD+eJzGRsE_Y+YRJ+w-PKbXyX0_kvTSZhZqhMLQtQj2w_7g@mail.gmail.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Quentin Perret <qperret@google.com>, maz@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 11:00 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Thu, Mar 11, 2021 at 12:48:07PM -0800, Steve Rutherford wrote:
> > On Thu, Mar 11, 2021 at 10:15 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > >
> > > On Wed, Mar 03, 2021 at 06:54:41PM +0000, Will Deacon wrote:
> > > > [+Marc]
> > > >
> > > > On Tue, Mar 02, 2021 at 02:55:43PM +0000, Ashish Kalra wrote:
> > > > > On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > > > > > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > > > > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > > > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > > > > > Thanks for grabbing the data!
> > > > > > > >
> > > > > > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > > > > > hypercall exiting, so I think that would be the current consensus.
> > > > > >
> > > > > > Yep, though it'd be good to get Paolo's input, too.
> > > > > >
> > > > > > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > > > > > series where we implement something more generic, e.g. a hypercall
> > > > > > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > > > > > exit route, we can drop the kvm side of the hypercall.
> > > > > >
> > > > > > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > > > > > rather, I think hypercall interception should be an orthogonal implementation.
> > > > > >
> > > > > > The guest, including guest firmware, needs to be aware that the hypercall is
> > > > > > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > > > > > implement a common ABI is an unnecessary risk.
> > > > > >
> > > > > > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > > > > > require further VMM intervention.  But, I just don't see the point, it would
> > > > > > save only a few lines of code.  It would also limit what KVM could do in the
> > > > > > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > > > > > then mandatory interception would essentially make it impossible for KVM to do
> > > > > > bookkeeping while still honoring the interception request.
> > > > > >
> > > > > > However, I do think it would make sense to have the userspace exit be a generic
> > > > > > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > > > > > just not used anywhere.
> > > > > >
> > > > > >   /* KVM_EXIT_HYPERCALL */
> > > > > >   struct {
> > > > > >           __u64 nr;
> > > > > >           __u64 args[6];
> > > > > >           __u64 ret;
> > > > > >           __u32 longmode;
> > > > > >           __u32 pad;
> > > > > >   } hypercall;
> > > > > >
> > > > > >
> > > > > > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > > > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > > > > >
> > > > > > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > > > > > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > > > > > that will result in truly heinous guest code, and extensibility issues.
> > > > > >
>
> We may also need to pass-through the MSR to userspace, as it is a part of this
> complete host (userspace/kernel), OVMF and guest kernel negotiation of
> the SEV live migration feature.
>
> Host (userspace/kernel) advertises it's support for SEV live migration
> feature via the CPUID bits, which is queried by OVMF and which in turn
> adds a new UEFI runtime variable to indicate support for SEV live
> migration, which is later queried during guest kernel boot and
> accordingly the guest does a wrmrsl() to custom MSR to complete SEV
> live migration negotiation and enable it.
>
> Now, the GET_SHARED_REGION_LIST ioctl returns error, until this MSR write
> enables SEV live migration, hence, preventing userspace to start live
> migration before the feature support has been negotiated and enabled on
> all the three components - host, guest OVMF and kernel.
>
> But, now with this ioctl not existing anymore, we will need to
> pass-through the MSR to userspace too, for it to only initiate live
> migration once the feature negotiation has been completed.
Hey Ashish,

I can't tell if you were waiting for feedback on this before posting
the follow-up patch series.

Here are a few options:
1) Add the MSR explicitly to the list of custom kvm MSRs, but don't
have it hooked up anywhere. The expectation would be for the VMM to
use msr intercepts to handle the reads and writes. If that seems
weird, have svm_set_msr (or whatever) explicitly ignore it.
2) Add a getter and setter for the MSR. Only allow guests to use it if
they are sev_guests with the requisite CPUID bit set.

I think I prefer the former, and it should work fine from my
understanding of the msr intercepts implementation. I'm also open to
other ideas. You could also have the MSR write trigger a KVM_EXIT of
the same type as the hypercall, but have it just say "the msr value
changed to XYZ", but that design sounds awkward.

Thanks,
Steve

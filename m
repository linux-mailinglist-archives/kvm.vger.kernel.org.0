Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CB93319A3
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhCHVtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbhCHVtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 16:49:19 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57169C06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 13:49:19 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id u8so11610545ior.13
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 13:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PxGFNYkB+PhlnpyiOlFoWVSJQKIgr40ZX6iXKcdwu4A=;
        b=gJNLuxmt0KtJp3ttogLnImrqCPW2373mtXzi38n1BVU9eZC/3wENGXcP9pKWCvS6x2
         yC5zi+Dj+1ueV+/UJskxqdrYiGSQkXYL+bHeAX4qgKJ86p9are5Lb8+frxC2yPznRIQ+
         HGKaTkYEMDK0e07xpgEQoJuhIAUOBXtW4Yh3qXUHCxN8WHepNADEJccNeqTX35wk5qJE
         /6IOeQ5Z1QsiREl75+0mnumOFDIprze+QMQVc8e7nDLa7Yl1DUD3yBVRmQwMC+1zfe8Q
         4mzsr4krTfI3KYCAHsUHM2sHdR4x/oJ7+gw0tBAPRYR7f1QUlrvnlQSYO4AVjED1btEZ
         eHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PxGFNYkB+PhlnpyiOlFoWVSJQKIgr40ZX6iXKcdwu4A=;
        b=BV0cyW8KrlwHQY6yGTFgeGSx1Rfn4x5R+y5m8YlT9z7txoNHhDLe+SfOgOdr/jWJmX
         F2iOQSeFV0F9dHvkc1PW9UE3+23Uijo3efm/kPtRBdYM0f/TjYI9d8JNNOHKD3C/FTaz
         617rjMzUnKp3XrMbYsCpy3TgB5mscJi+sEqhLaKwjIDymcVYFvtjdAW4LzQ74Bd4zmoT
         +RdcnK0pCiWxvaMI9SHJWXbQ7uwr2K8ux0HUiHmqFpmGePzdoO2CJ5wc13iyJKD/V0pF
         n3MHjQBZAr8uHDKUU9QqTtpefJYOk+gq1lGnaeb0iWpkWFOM0/rg/WaR/uB/Dh0LbS3i
         LIUA==
X-Gm-Message-State: AOAM533iwyylfXRFG6XeW6zsoVkq0+jbiuYXEF5RN8yj72ZkzpUw2DTy
        RZQrVIQHCkC2XOhNrI3zDhibB98K3ei8W26sZ9pECQ==
X-Google-Smtp-Source: ABdhPJxlBqh/azr1ukxSIXFdrDYqrJSd2aUrVCrr+PL/A2NM0tCc67jOlSuyo7JBvnYwyMArqxa/F4/qsnUbDS+hSmU=
X-Received: by 2002:a6b:c40b:: with SMTP id y11mr19946301ioa.205.1615240158545;
 Mon, 08 Mar 2021 13:49:18 -0800 (PST)
MIME-Version: 1.0
References: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com> <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server> <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server> <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server> <YDkzibkC7tAYbfFQ@google.com>
 <20210308104014.GA5333@ashkalra_ubuntu_server> <YEaAXXGZH0uSMA3v@google.com>
In-Reply-To: <YEaAXXGZH0uSMA3v@google.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 8 Mar 2021 13:48:43 -0800
Message-ID: <CABayD+eCPebG2R74Huoff5yj1PqEMnri2znn26EOf=qRKYw6Aw@mail.gmail.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 8, 2021 at 11:52 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Mar 08, 2021, Ashish Kalra wrote:
> > On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > > +Will and Quentin (arm64)
> > >
> > > Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
> > > point.
> > >
> > > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > > Thanks for grabbing the data!
> > > > >
> > > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > > hypercall exiting, so I think that would be the current consensus.
> > >
> > > Yep, though it'd be good to get Paolo's input, too.
> > >
> > > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > > series where we implement something more generic, e.g. a hypercall
> > > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > > exit route, we can drop the kvm side of the hypercall.
> > >
> > > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > > rather, I think hypercall interception should be an orthogonal implementation.
> > >
> > > The guest, including guest firmware, needs to be aware that the hypercall is
> > > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > > implement a common ABI is an unnecessary risk.
> > >
> > > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > > require further VMM intervention.  But, I just don't see the point, it would
> > > save only a few lines of code.  It would also limit what KVM could do in the
> > > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > > then mandatory interception would essentially make it impossible for KVM to do
> > > bookkeeping while still honoring the interception request.
> > >
> > > However, I do think it would make sense to have the userspace exit be a generic
> > > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > > just not used anywhere.
> > >
> > >     /* KVM_EXIT_HYPERCALL */
> > >     struct {
> > >             __u64 nr;
> > >             __u64 args[6];
> > >             __u64 ret;
> > >             __u32 longmode;
> > >             __u32 pad;
> > >     } hypercall;
> > >
> > >
> > > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > >
> > > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > > that will result in truly heinous guest code, and extensibility issues.
> > >
> > > The data limitation is a moot point, because the x86-only thing is a deal
> > > breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> > > memory with a host.  I can't think of a clever way to avoid having to support
> > > TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> > > multiple KVM variants.
> > >
> >
> > Potentially, there is another reason for in-kernel hypercall handling
> > considering SEV-SNP. In case of SEV-SNP the RMP table tracks the state
> > of each guest page, for instance pages in hypervisor state, i.e., pages
> > with C=0 and pages in guest valid state with C=1.
> >
> > Now, there shouldn't be a need for page encryption status hypercalls on
> > SEV-SNP as KVM can track & reference guest page status directly using
> > the RMP table.
>
> Relying on the RMP table itself would require locking the RMP table for an
> extended duration, and walking the entire RMP to find shared pages would be
> very inefficient.
>
> > As KVM maintains the RMP table, therefore we will need SET/GET type of
> > interfaces to provide the guest page encryption status to userspace.
>
> Hrm, somehow I temporarily forgot about SNP and TDX adding their own hypercalls
> for converting between shared and private.  And in the case of TDX, the hypercall
> can't be trusted, i.e. is just a hint, otherwise the guest could induce a #MC in
> the host.
>
> But, the different guest behavior doesn't require KVM to maintain a list/tree,
> e.g. adding a dedicated KVM_EXIT_* for notifying userspace of page encryption
> status changes would also suffice.
>
> Actually, that made me think of another argument against maintaining a list in
> KVM: there's no way to notify userspace that a page's status has changed.
> Userspace would need to query KVM to do GET_LIST after every GET_DIRTY.
> Obviously not a huge issue, but it does make migration slightly less efficient.
>
> On a related topic, there are fatal race conditions that will require careful
> coordination between guest and host, and will effectively be wired into the ABI.
> SNP and TDX don't suffer these issues because host awareness of status is atomic
> with respect to the guest actually writing the page with the new encryption
> status.
>
> For SEV live migration...
>
> If the guest does the hypercall after writing the page, then the guest is hosed
> if it gets migrated while writing the page (scenario #1):
>
>   vCPU                 Userspace
>   zero_bytes[0:N]
>                        <transfers written bytes as private instead of shared>
>                        <migrates vCPU>
>   zero_bytes[N+1:4095]
>   set_shared (dest)
>   kaboom!
>
> If userspace does GET_DIRTY after GET_LIST, then the host would transfer bad
> data by consuming a stale list (scenario #2):
>
>   vCPU               Userspace
>                      get_list (from KVM or internally)
>   set_shared (src)
>   zero_page (src)
>                      get_dirty
>                      <transfers private data instead of shared>
>                      <migrates vCPU>
>   kaboom!
>
> If both guest and host order things to avoid #1 and #2, the host can still
> migrate the wrong data (scenario #3):
>
>   vCPU               Userspace
>   set_private
>   zero_bytes[0:4096]
>                      get_dirty
>   set_shared (src)
>                      get_list
>                      <transfers as shared instead of private>
>                      <migrates vCPU>
>   set_private (dest)
>   kaboom!
>
> Scenario #3 is unlikely, but plausible, e.g. if the guest bails from its
> conversion flow for whatever reason, after making the initial hypercall.  Maybe
> it goes without saying, but to address #3, the guest must consider existing data
> as lost the instant it tells the host the page has been converted to a different
> type.
This requires the guest to bail on the conversion flow, and
subsequently treat the page as having it's previous value. The kernel
does not currently do this. I don't think it should ever do this.
Currently, each time the guest changes it's view of a page, it
re-zeroes that page, and it does so after flipping the c-bit and
calling the hypercall (IIRC). This is much more conservative than is
necessary for supporting LM, but does suffice. I think the minimal
requirement for LM support is "Flipping a page's encryption status
(and advertising that flip to the host) twice is not a no-op. The
kernel must reinitialize that page". This invariant should also be
necessary for anything that moves pages around on the same host (COPY,
SWAP_OUT, SWAP_IN).

Relatedly, there is no workaround if the kernel does in-place
reencryption (since the page would be both encrypted and unencrypted).
That said, I believe the spec affirmatively tells you not to do this
outside of SME.

There's also no solution if the guest relies on the value of
ciphertext, or on the value of "decrypted plaintext". The guest could
detect live migration by noticing that a page's value from an
unencrypted perspective has changed when it's value from an encrypted
perspective has not (or the other way around). This would also imply
that a very strange guest could be broken by live migration.

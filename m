Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8A63319B6
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhCHVwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhCHVwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 16:52:14 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F49C06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 13:52:14 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id z13so11663681iox.8
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 13:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Itj6WtlNyY9ZkwtqzOc2QoQ+TaqM3Jrz8aSQdw2aEDE=;
        b=Gvn5LdKQVrXN2u40LQsMQ28u1XcpmV6oFFRLYnWGhddVc0kjHLtEka72OcJsoOdaOP
         eRNnUV+X7bx9C3fUXkM/cZRwmPeUgBWslkqOJlvD87uQLJ5byfOBmm4V60wxY8TzuhJF
         nRrsYieGIA6vZ/yKRIBbRwrh+VogbpG0l145snnDXBk/8/DjBx/r3lCnaW6TJYuzOoEX
         q97RPQKUsloGZMiYOZY0Mn8rlIrkZLP7smfHEECO/W/lBMfD4vIA0+tcscUQFmH8fydC
         Wx9ykoa2d/pVUHZvircjtMz/JgdlMPUjunBd+A5pXokh4fJ+JbDp2IWFH1kwfQcyUXhE
         WXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Itj6WtlNyY9ZkwtqzOc2QoQ+TaqM3Jrz8aSQdw2aEDE=;
        b=jPpfjoxPNE47KEZdtDy9Brq90yP79+1t4Or6yHXRuhHTS5Z3q4kA8hs2a8CgDCcX+w
         RYDYKScOsu2nrgcUtxo2tjz5hfLLTAdMmuUghlAv7YHxIEP5+z1lqNMm7vXpNzQzQV0J
         C5UbKihRtpJ8H/gIq0LTiQur4n2MEnUMTgw4pTEIv0wg/UULhylziMrE2HyLO8fnso9y
         RvmdLNVgqz+0I0QxAtuw6xtou2OAV25nztH8Dbu6V0K0uN2IdFPZpV0gpUFtqTP6CIli
         t/ToTu3AklMbPVqYdfO3Wip10CXJKA7ssoZmm2MX/oBkUbq+7H2bNR8Xrhb/h6kEdbrB
         GJNA==
X-Gm-Message-State: AOAM531zLo4KzeBstRnQL4gtIi80aIMCt4zLgworFMp3BUSMht9Gl9TT
        ea3SsmTD+/xka1tieNNuNrAoANxfqPX39uKSVhwEgA==
X-Google-Smtp-Source: ABdhPJzIdnwTDgw/GkN5/Tid4F9vrfnZ5u7l5lzrtHsKAgmMo6zKbNU/h40FaQmvypLNK8ulSqVtNjqdp+gQVvxdwaw=
X-Received: by 2002:a05:6602:1641:: with SMTP id y1mr20070492iow.34.1615240333468;
 Mon, 08 Mar 2021 13:52:13 -0800 (PST)
MIME-Version: 1.0
References: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com> <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server> <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server> <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server> <YDkzibkC7tAYbfFQ@google.com>
 <20210308104014.GA5333@ashkalra_ubuntu_server> <YEaAXXGZH0uSMA3v@google.com> <bdf0767f-c2c4-5863-fd0d-352a3f68f7f9@amd.com>
In-Reply-To: <bdf0767f-c2c4-5863-fd0d-352a3f68f7f9@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 8 Mar 2021 13:51:38 -0800
Message-ID: <CABayD+ftv5DNdXj-Bs8MXGeFNKx7-aTt99fPuD2R6w1mJ2u8TQ@mail.gmail.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 8, 2021 at 1:11 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 3/8/21 1:51 PM, Sean Christopherson wrote:
> > On Mon, Mar 08, 2021, Ashish Kalra wrote:
> >> On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> >>> +Will and Quentin (arm64)
> >>>
> >>> Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
> >>> point.
> >>>
> >>> On Fri, Feb 26, 2021, Ashish Kalra wrote:
> >>>> On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> >>>>> On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >>>>> Thanks for grabbing the data!
> >>>>>
> >>>>> I am fine with both paths. Sean has stated an explicit desire for
> >>>>> hypercall exiting, so I think that would be the current consensus.
> >>> Yep, though it'd be good to get Paolo's input, too.
> >>>
> >>>>> If we want to do hypercall exiting, this should be in a follow-up
> >>>>> series where we implement something more generic, e.g. a hypercall
> >>>>> exiting bitmap or hypercall exit list. If we are taking the hypercall
> >>>>> exit route, we can drop the kvm side of the hypercall.
> >>> I don't think this is a good candidate for arbitrary hypercall interception.  Or
> >>> rather, I think hypercall interception should be an orthogonal implementation.
> >>>
> >>> The guest, including guest firmware, needs to be aware that the hypercall is
> >>> supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> >>> implement a common ABI is an unnecessary risk.
> >>>
> >>> We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> >>> require further VMM intervention.  But, I just don't see the point, it would
> >>> save only a few lines of code.  It would also limit what KVM could do in the
> >>> future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> >>> then mandatory interception would essentially make it impossible for KVM to do
> >>> bookkeeping while still honoring the interception request.
> >>>
> >>> However, I do think it would make sense to have the userspace exit be a generic
> >>> exit type.  But hey, we already have the necessary ABI defined for that!  It's
> >>> just not used anywhere.
> >>>
> >>>     /* KVM_EXIT_HYPERCALL */
> >>>     struct {
> >>>             __u64 nr;
> >>>             __u64 args[6];
> >>>             __u64 ret;
> >>>             __u32 longmode;
> >>>             __u32 pad;
> >>>     } hypercall;
> >>>
> >>>
> >>>>> Userspace could also handle the MSR using MSR filters (would need to
> >>>>> confirm that).  Then userspace could also be in control of the cpuid bit.
> >>> An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> >>> The data limitation could be fudged by shoving data into non-standard GPRs, but
> >>> that will result in truly heinous guest code, and extensibility issues.
> >>>
> >>> The data limitation is a moot point, because the x86-only thing is a deal
> >>> breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> >>> memory with a host.  I can't think of a clever way to avoid having to support
> >>> TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> >>> multiple KVM variants.
> >>>
> >> Potentially, there is another reason for in-kernel hypercall handling
> >> considering SEV-SNP. In case of SEV-SNP the RMP table tracks the state
> >> of each guest page, for instance pages in hypervisor state, i.e., pages
> >> with C=0 and pages in guest valid state with C=1.
> >>
> >> Now, there shouldn't be a need for page encryption status hypercalls on
> >> SEV-SNP as KVM can track & reference guest page status directly using
> >> the RMP table.
> > Relying on the RMP table itself would require locking the RMP table for an
> > extended duration, and walking the entire RMP to find shared pages would be
> > very inefficient.
> >
> >> As KVM maintains the RMP table, therefore we will need SET/GET type of
> >> interfaces to provide the guest page encryption status to userspace.
> > Hrm, somehow I temporarily forgot about SNP and TDX adding their own hypercalls
> > for converting between shared and private.  And in the case of TDX, the hypercall
> > can't be trusted, i.e. is just a hint, otherwise the guest could induce a #MC in
> > the host.
> >
> > But, the different guest behavior doesn't require KVM to maintain a list/tree,
> > e.g. adding a dedicated KVM_EXIT_* for notifying userspace of page encryption
> > status changes would also suffice.
> >
> > Actually, that made me think of another argument against maintaining a list in
> > KVM: there's no way to notify userspace that a page's status has changed.
> > Userspace would need to query KVM to do GET_LIST after every GET_DIRTY.
> > Obviously not a huge issue, but it does make migration slightly less efficient.
> >
> > On a related topic, there are fatal race conditions that will require careful
> > coordination between guest and host, and will effectively be wired into the ABI.
> > SNP and TDX don't suffer these issues because host awareness of status is atomic
> > with respect to the guest actually writing the page with the new encryption
> > status.
> >
> > For SEV live migration...
> >
> > If the guest does the hypercall after writing the page, then the guest is hosed
> > if it gets migrated while writing the page (scenario #1):
> >
> >   vCPU                 Userspace
> >   zero_bytes[0:N]
> >                        <transfers written bytes as private instead of shared>
> >                      <migrates vCPU>
> >   zero_bytes[N+1:4095]
> >   set_shared (dest)
> >   kaboom!
>
>
> Maybe I am missing something, this is not any different from a normal
> operation inside a guest. Making a page shared/private in the page table
> does not update the content of the page itself. In your above case, I
> assume zero_bytes[N+1:4095] are written by the destination VM. The
> memory region was private in the source VM page table, so, those writes
> will be performed encrypted. The destination VM later changed the memory
> to shared, but nobody wrote to the memory after it has been transitioned
> to the  shared, so a reader of the memory should get ciphertext and
> unless there was a write after the set_shared (dest).
>
>
> > If userspace does GET_DIRTY after GET_LIST, then the host would transfer bad
> > data by consuming a stale list (scenario #2):
> >
> >   vCPU               Userspace
> >                      get_list (from KVM or internally)
> >   set_shared (src)
> >   zero_page (src)
> >                      get_dirty
> >                      <transfers private data instead of shared>
> >                      <migrates vCPU>
> >   kaboom!
>
>
> I don't remember how things are done in recent Ashish Qemu/KVM patches
> but in previous series, the get_dirty() happens before the querying the
> encrypted state. There was some logic in VMM to resync the encrypted
> bitmap during the final migration stage and perform any additional data
> transfer since last sync.
>
>
> > If both guest and host order things to avoid #1 and #2, the host can still
> > migrate the wrong data (scenario #3):
> >
> >   vCPU               Userspace
> >   set_private
> >   zero_bytes[0:4096]
> >                      get_dirty
> >   set_shared (src)
> >                      get_list
> >                      <transfers as shared instead of private>
> >                    <migrates vCPU>
> >   set_private (dest)
> >   kaboom!
>
>
> Since there was no write to the memory after the set_shared (src), so
> the content of the page should not have changed. After the set_private
> (dest), the caller should be seeing the same content written by the
> zero_bytes[0:4096]
I think Sean was going for the situation where the VM has moved to the
destination, which would have changed the VEK. That way the guest
would be decrypting the old ciphertext with the new (wrong) key.
>
>
> > Scenario #3 is unlikely, but plausible, e.g. if the guest bails from its
> > conversion flow for whatever reason, after making the initial hypercall.  Maybe
> > it goes without saying, but to address #3, the guest must consider existing data
> > as lost the instant it tells the host the page has been converted to a different
> > type.
> >
> >> For the above reason if we do in-kernel hypercall handling for page
> >> encryption status (which we probably won't require for SEV-SNP &
> >> correspondingly there will be no hypercall exiting),
> > As above, that doesn't preclude KVM from exiting to userspace on conversion.
> >
> >> then we can implement a standard GET/SET ioctl interface to get/set the guest
> >> page encryption status for userspace, which will work across SEV, SEV-ES and
> >> SEV-SNP.

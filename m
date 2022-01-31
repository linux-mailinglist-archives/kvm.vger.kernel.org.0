Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6005F4A4D65
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 18:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381061AbiAaRiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 12:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381040AbiAaRh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 12:37:59 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DD8C061714
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 09:37:59 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id e81so28064530oia.6
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 09:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0bXT2h3+incwSsplxB+avwxd6FZTg6t/dVeS+3LCWcE=;
        b=YrmJyIg+zr1kAGySQCbXX9+gCazNqM8JdKrSV3+p3GKUXnoBwi5o7cJs3pQGtVp2Mr
         Vw6pDbBoUv5aYAtVYeZOCTMKbUZiiK39HiDOPeP10vePKgNJeS2YfJAASkxynn4TiwGI
         wkH597YHmayJGj5YIM3+W/OBFTzE+0F6kr5kX4mC1kkTbCgaG408Ms7vkcyToZ8p4EXj
         Qtr3YOK3RJ6+lCDZ9mAKLKEEQQSjYdl8L98p8srK2fD3zZPoImW+UmYwaeAaPaXiuYZG
         FMLCjAvAK5eHy9SWx0ln73iz2dCy+/NwScrqUb8hKDbq1/ugYo4Uf6El84EYnl9DZSu/
         hDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0bXT2h3+incwSsplxB+avwxd6FZTg6t/dVeS+3LCWcE=;
        b=FEX7vQg8qrzyp460K7llrOx5GNKO8IwMgYKyiGVb1Et+G7QEGVQp3mWRymzpsjL/hh
         zYY+U0OLdoD18QbLoROJVR5GIYKEUKpFsMnpxPXUPopSomFDowVPxymE74peYdFJO2u8
         PJ31qV/Ntt6myhUVK79gFh4uyPnLUgd+NEu9ed8fm2ayPRTRopD1JsjxvKQrlksrG5wy
         j8DQfUGFCYGHebbLSZb4XATj8xRYW1RKgodA2kOn8sskYwQGPRi6qbPezoDnZXiKy2GC
         qBNYlEHyxXOq46Ye2zTdoODKnzZxKFj8v/6w6A377O37PtIfQdIATRRD51/fgb8bEARm
         8uyQ==
X-Gm-Message-State: AOAM532wKcwhT84eIphqSiFvRnBfQJ/3jaAp6WpTZrlflglHU29oKiB7
        ZnMZOaiyA/YCiB+Gm30i1jkppVktdPV6b7S22w6Haw==
X-Google-Smtp-Source: ABdhPJz2dwH56OIeRwteXPtfrX9XwlfxjvSivCta70cAiBi0dPIrJmuY9zLV8pshfD3G5mESInh6Ag11Le5XWIgWXLU=
X-Received: by 2002:a05:6808:e85:: with SMTP id k5mr19148153oil.238.1643650677942;
 Mon, 31 Jan 2022 09:37:57 -0800 (PST)
MIME-Version: 1.0
References: <fc6bea3249f26e8dd973ce1bd1e3f6f42c142469.camel@redhat.com>
 <CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com>
 <11324ba7075ce90dee9d424c78db0bf97b1c4444.camel@redhat.com>
 <CALMp9eSX8sgyF_CkKQuYP6P5ZGN+t82bmmk9aTfBivSh1+yHiQ@mail.gmail.com> <5de8aeb0adab563667d784bab6fbd235f0208ee0.camel@redhat.com>
In-Reply-To: <5de8aeb0adab563667d784bab6fbd235f0208ee0.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 31 Jan 2022 09:37:46 -0800
Message-ID: <CALMp9eRMv0bb7UQApX12g3dyNtCfJKhR++bkb3TLxCQH7NGZyg@mail.gmail.com>
Subject: Re: Why do we need KVM_REQ_GET_NESTED_STATE_PAGES after all
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gilbert <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 31, 2022 at 2:32 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Sun, 2022-01-30 at 15:46 -0800, Jim Mattson wrote:
> > On Sun, Jan 30, 2022 at 6:29 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > On Thu, 2022-01-27 at 11:39 -0800, Jim Mattson wrote:
> > > > On Thu, Jan 27, 2022 at 8:04 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > > > I would like to raise a question about this elephant in the room which I wanted to understand for
> > > > > quite a long time.
> > > > >
> > > > > For my nested AVIC work I once again need to change the KVM_REQ_GET_NESTED_STATE_PAGES code and once
> > > > > again I am asking myself, maybe we can get rid of this code, after all?
> > > >
> > > > We (GCE) use it so that, during post-copy, a vCPU thread can exit to
> > >
> > > Thank you very much for a very detailed response!
> > >
> > > > userspace and demand these pages from the source itself, rather than
> > > > funneling all demands through a single "demand paging listener"
> > > That is something I didn't think of!
> > >
> > > The question is however, can that happen between setting the nested state
> > > and running a vCPU first time.
> > >
> > > I guess it is possible in therory that you set the nested state, then run 1 vCPU,
> > > which faults and exits to userspace,
> > > then userspace populates the faulted memory which triggers memslots update,
> > > and only then you run another vCPU for first time.
> > > needs will be need when this request is processed, and it will fail if they aren't.
> >
> > That isn't quite how our post-copy works.  There is no memslots
> > update. When post-copy starts, the source sends a bitmap of dirty
> > pages to the destination. This bitmap is installed in kvm via a
> > Google-local ioctl. Then, all vCPUs on the destination start running,
> > while the source pushes dirty pages to the destination. As EPT
> > violations occur for cold mappings at the destination, we check the
> > bitmap to see if we need to demand the page from the source
> > out-of-band. We know that the page will eventually come across, but we
> > need it *now*, so that the vCPU thread that incurred the EPT violation
> > can resume. If the page is in the dirty bitmap, the vCPU thread that
> > incurred the EPT violation will exit to userspace and request the page
> > from the source. When the page arrives, we overwrite the stale page in
> > the memslot and clear the bit in the dirty page bitmap.
> >
> > For cases where kvm needs a dirty page to do software page walks or
> > instruction emulation or whatever, the vCPU thread sends a request to
> > the "demand page listener" thread via a netlink socket and then
> > blocks, waiting for the bit to clear in the dirty bitmap. For various
> > reasons, including the serialization on the listener thread and the
> > unreliability of the netlink socket, we didn't want to have all of the
> > vmcs12 pages use the netlink request path. (This concern may be
> > largely moot, since modification of most pages hanging off of the VMCS
> > while the (v)CPU is in VMX non-root mode leads to undefined behavior.)
> >
> > > > thread, which I believe is the equivalent of qemu's userfaultfd "fault
> > > > handler" thread. Our (internal) post-copy mechanism scales quite well,
> > > > because most demand paging requests are triggered by an EPT violation,
> > > > which happens to be a convenient place to exit to userspace. Very few
> > > > pages are typically demanded as a result of
> > > > kvm_vcpu_{read,write}_guest, where the vCPU thread is so deep in the
> > > > kernel call stack that it has to request the page via the demand
> > > > paging listener thread. With nested virtualization, the various vmcs12
> > > > pages consulted directly by kvm (bypassing the EPT tables) were a
> > > > scalability issue.
> > > I assume that you patched all these calls to exit to userspace for the
> > > demand paging scheme you are using.
> > >
> > > > (Note that, unlike upstream, we don't call nested_get_vmcs12_pages
> > > > directly from VMLAUNCH/VMRESUME emulation; we always call it as a
> > > > result of this request that you don't like.)
> > > Also I guess something specific to your downstream patches.
> > >
> > >
> > > > As we work on converting from our (hacky) demand paging scheme to
> > > > userfaultfd, we will have to solve the scalability issue anyway
> > > > (unless someone else beats us to it). Eventually, I expect that our
> > > > need for this request will go away.
> > >
> > > Great!
> > >
> > > The question is, if we remove it now, will that affect you?
> >
> > No. By the time we get to 5.17, I don't expect any of our current
> > post-copy scheme to survive.
> >
> > > What if we depricate it (add option to keep the current behavier,
> > > but keep an module param to revert back to old behavier, with
> > > the eventual goal of removing it.
> >
> > Don't bother on our account. :-)
> > > > Honestly, without the exits to userspace, I don't really see how this
> > > > request buys you anything upstream. When I originally submitted it, I
> > > > was prepared for rejection, but Paolo said that qemu had a similar
> > > > need for it, and I happily never questioned that assertion.
> > >
> > > Exactly! I didn't questioned it as well, because I didn't knew MMU at all,
> > > and it is one of the harderst KVM parts - who knows what it caches,
> > > and what magic it needs to be up to date.
> >
> > The other question, which may have been what motivated Paolo to keep
> > the GET_NESTED_VMCS12_PAGES request, is whether or not the memslots
> > have been established before userspace calls the ioctl for
> > SET_NESTED_STATE. If not, it is impossible to do any GPA->HPA lookups
> > for VMCS12 fields that are necessary for the vCPU to enter VMX
> > non-root mode as part of SET_NESTED_STATE. The only field I can think
> > of off the top of my head is the VMCS12 APIC-access address, which,
> > sadly, has to be backed by an L1 memslot, even though the page is
> > never accessed. (VMware always sets the APIC-access address to 0, for
> > all VMCSs, at L1 or L2. That makes things a lot easier.) If the
> > memslots are established before SET_NESTED_STATE, this isn't a
> > problem, but I don't recall that constraint being documented anywhere.
>
> This is the exactly only reason for KVM_REQ_GET_NESTED_STATE_PAGES and what it does.
> The only thing KVM_REQ_GET_NESTED_STATE_PAGES buy us is exactly this - ability to
> set memslots after setting the nested state.
>
> This is indeed not documented, but there is hope that none of the userspace relies on this
> (the opposite is also not documented)
>
> Qemu AFAIK doesn't rely on this - I can't be 100% sure because the code is complex and I
> could have missed some corner case like that virtio-mem case Paolo mentioned to me
> (I checked it, and there seems to be no reason for it to set memslots after migration).
>
> Practically speaking, memslots can update any moment, but there is no reason to have different
> memslots between sending the migration state and restoring it. As soon as restore of the migration
> state is complete, yes there could be memslots modifications, in theory even before the VM runs,
> but these modifications can't not make memory that a nested VMCS/VMCB reference available again,
> which is the only thing that KVM_REQ_GET_NESTED_STATE_PAGES buys us.
>
> TL;DR - no matter how userspace modifies the memslots after the migration,
> it must restore the memslots that contain pages that are referenced by the nested state,
> exactly as is.
>
> The only change to userspace expected behavier by removing the KVM_REQ_GET_NESTED_STATE_PAGES
> would be that userspace would have to restore those memslots prior to setting the nested state
> (but not the memory itself contained within, as it can be later brought in via userfaltd).
>
>
> About the referenced pages:
> In addition to apic access page, there are more pages that are referenced from vmcb/vmcs:
> There is apic backing page for both AVIC/APICv which we map and passthrough to the guest,
> there is PIR descriptior for APICv, there is the msr bitmap, and io bitmap,
> there are msr load/store lists on VMX, and probably more).

Pages that are only accessed on VM-entry or VM-exit are not a problem.
The pages that could be trouble are the ones used to construct a
vmc[sb]02 for an L2 VM that's in VMX non-root mode (guest mode) at the
time of migration. So, for instance, the vmc[sb]12 I/O bitmaps are no
trouble, because we're going to configure the vmc[sb]02 to exit on any
port access. However, the vmc[sb]12 MSR bitmap(s) could be a problem,
since they are used to construct the vmc[sb]02 MSR bitmap(s). Also a
potential problem are L1 pages that are directly accessed from the
vmc[sb]02, such as the virtual APIC page.

>
> >
> > > But now, I don't think there are still large areas of MMU that I don't understand,
> > > thus I started asking myself why it is need.
> > >
> > > That request is a ripe source of bugs. Just off my hand, Vitaly spent at least a week
> > > understanding why after vmcb01/02 split, eVMCS stopped working, only to figure out that
> > > KVM_REQ_GET_NESTED_STATE_PAGES might not be called after nested entry since there
> > > could be nested VM exit before we even enter the guest, and since then one more
> > > hack has to be added to work that around (nothing against the hack, its not the
> > > root cause of the problem).
> > >
> > > I also indirectly caused and fixed a CVE like issue, which started
> > >  with the patch that added KVM_REQ_GET_NESTED_STATE_PAGES to SVM -
> > > it made KVM switch to nested msr bitmap
> > > and back then there was no vmcb01/02 split. Problem is that back then
> > > we didn't cancel that request if we have VM exit right after VM entry,
> > > so it would be still pending on VM entry, and it will switch to nested MSR bitmap
> > > even if we are no longer nested - then I added patch to free the nested state
> > > on demand, and boom - we have L1 using freed (and usualy zeroed) MSR bitmap - free
> > > access to all host msrs from L1...
> > >
> > > There is another hidden issue in this request, that it makes it impossible to
> > > handle failure gracefully.
> > >
> > > If for example, loading nested state pages needs to allocate memory and that
> > > fails, we could just fail the nested VM entry if that request wasn't there.
> > > While this is not ideal for the nested guest, it likely to survive, and
> > > might even retry entering the nested guest.
> > >
> > > On the other hand during the request if something fails, nested state is
> > > already loaded, and all we can do is to kill the L1.
> >
> > I apologize for all of that pain.
>
> No problem. IMHO the request was created out of abundance of caution
> (which I understand very well), and back then nobody could predict the issues it will create,
> but as it stands now, it might be better to remove it that keep on adding more code to the mess.
>
> I btw tested the attached patch a bit more and it seems to survive so far.

To be reasonably certain that you do not need this code, you should
test migration of active L2 VMs with both pre-copy and background
post-copy disabled. In other words, the only way to get a page
transferred from the source to the destination is by faulting it in on
the destination.

> Best regards,
>         Maxim Levitsky
>
>
> >
> > > Thanks again!
> > > Best regards,
> > >         Maxim Levitsky
> > >
> > >
> > >
> > >
>
>

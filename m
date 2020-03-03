Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975001769D3
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 02:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgCCBGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 20:06:09 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41986 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCCBGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 20:06:09 -0500
Received: by mail-lj1-f194.google.com with SMTP id q19so666312ljp.9
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 17:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Mm7g4ThWIBVvq83U2u9/ErkVb6lacOR4YWjhrtHPMc=;
        b=KtWRNYb3o/jtauqC79PfPfeY+JnnTfoxEwz5eIiSy0wc6OavhpI+hgWk/kfj/zVSpa
         tS0kPTLlAuIOgQopl2h6a+vNEsLFXV7Ab/CFvYl7b4oagIjx3jfqTXdruHoR97bj+8Ww
         +q1I0KbH4zyyXpds65ciRLw0HfHMMDC0+DOR9PTJXJcDz8oTZsXODgA+rzFQ1w7KdbKu
         fd4CGQCrsT0m7iKfH6JKTJT+5K6/XRC4Q1Rr3AIhDyRzpvHDhUJfdSK6uazjacSUxvEG
         6tW4Qa8VVqrS2rhuCme1vp9Hju4vlb0zOdj6MXixh2+U2KuKJjxhc6Llr5B78m+i0RLh
         tNfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Mm7g4ThWIBVvq83U2u9/ErkVb6lacOR4YWjhrtHPMc=;
        b=CK5yxXTo8394k9HX78YQaLWJl5gDvPFJ8IbQCJC/QNVtz8HHZiXCAMUHOU6HziJQMG
         2l0VJPkLrkOm3Ba6iEStaRLeAuPyjKAB2Hu3JxwJfjGO0pWyT6agLgLc3jdpH2/DIqjC
         Gn5S38XC5UIaHWY8lSI3CFV2OehsYJSuyWdjUclZgvpozHtr/jj15ygzdtvwuuU9s6/k
         viSyYB13KDHbCpW/EPoxCJ2mRUWa2Olh3HAIrIUAYzvLmv8bJcfRZEE2kVA96MS98Fht
         PkzCN8FO9FoNO0wQGkXJgcrCLEWPLZExHQ9+zw90ZoFrIb7vN8tRir2RGHCwUrX/Nrpl
         N/wA==
X-Gm-Message-State: ANhLgQ1k1RU2DbvXLNNyiUxMmpRY1okbgwJfzB6rpyv52G7S1KLy5ftu
        Ote5VQUU+/drwnLPybiM7m8fKQlv+xPzXz0Q/OnslA==
X-Google-Smtp-Source: ADFU+vvV70jM7BzUx8uPcSYxs3eYc9iPMdp0foKtqfROXrafn4q8tiylUhJK4O7Th3gji0LUIdEoT3zq5Dh9VTGqY/s=
X-Received: by 2002:a2e:7d0e:: with SMTP id y14mr924639ljc.158.1583197566576;
 Mon, 02 Mar 2020 17:06:06 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
 <20200213230916.GB8784@ashkalra_ubuntu_server> <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
 <20200217194959.GA14833@ashkalra_ubuntu_server>
In-Reply-To: <20200217194959.GA14833@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 2 Mar 2020 17:05:29 -0800
Message-ID: <CABayD+dVEMBhva5DOtBph+Ms559q014pbjP9=6ycJ5KpiiJzVg@mail.gmail.com>
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I think this patch series might be incompatible with kexec, but I'm
not sure since I'm really not familiar with that subsystem. It seems
like you need to explicitly mark all shared pages as encrypted again
before rebooting into the new kernel. If you don't do this, and the
newly booted kernel believes RAM is encrypted and has always been, you
won't flip formerly decrypted shared device pages back to encrypted.
For example, if the swiotlb moves, you need to tell KVM that the old
swiotlb pages are now encrypted.

I could imagine this being handled implicitly by the way kexec handles
freeing memory, but I would find this surprising. I only see
enlightenment for handling SME's interaction with the initial image in
the kexec implementation.

On Mon, Feb 17, 2020 at 11:50 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Fri, Feb 14, 2020 at 10:58:46AM -0800, Andy Lutomirski wrote:
> > On Thu, Feb 13, 2020 at 3:09 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > >
> > > On Wed, Feb 12, 2020 at 09:43:41PM -0800, Andy Lutomirski wrote:
> > > > On Wed, Feb 12, 2020 at 5:14 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > > >
> > > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > >
> > > > > This patchset adds support for SEV Live Migration on KVM/QEMU.
> > > >
> > > > I skimmed this all and I don't see any description of how this all works.
> > > >
> > > > Does any of this address the mess in svm_register_enc_region()?  Right
> > > > now, when QEMU (or a QEMU alternative) wants to allocate some memory
> > > > to be used for guest encrypted pages, it mmap()s some memory and the
> > > > kernel does get_user_pages_fast() on it.  The pages are kept pinned
> > > > for the lifetime of the mapping.  This is not at all okay.  Let's see:
> > > >
> > > >  - The memory is pinned and it doesn't play well with the Linux memory
> > > > management code.  You just wrote a big patch set to migrate the pages
> > > > to a whole different machines, but we apparently can't even migrate
> > > > them to a different NUMA node or even just a different address.  And
> > > > good luck swapping it out.
> > > >
> > > >  - The memory is still mapped in the QEMU process, and that mapping is
> > > > incoherent with actual guest access to the memory.  It's nice that KVM
> > > > clflushes it so that, in principle, everything might actually work,
> > > > but this is gross.  We should not be exposing incoherent mappings to
> > > > userspace.
> > > >
> > > > Perhaps all this fancy infrastructure you're writing for migration and
> > > > all this new API surface could also teach the kernel how to migrate
> > > > pages from a guest *to the same guest* so we don't need to pin pages
> > > > forever.  And perhaps you could put some thought into how to improve
> > > > the API so that it doesn't involve nonsensical incoherent mappings.o
> > >
> > > As a different key is used to encrypt memory in each VM, the hypervisor
> > > can't simply copy the the ciphertext from one VM to another to migrate
> > > the VM.  Therefore, the AMD SEV Key Management API provides a new sets
> > > of function which the hypervisor can use to package a guest page for
> > > migration, while maintaining the confidentiality provided by AMD SEV.
> > >
> > > There is a new page encryption bitmap created in the kernel which
> > > keeps tracks of encrypted/decrypted state of guest's pages and this
> > > bitmap is updated by a new hypercall interface provided to the guest
> > > kernel and firmware.
> > >
> > > KVM_GET_PAGE_ENC_BITMAP ioctl can be used to get the guest page encryption
> > > bitmap. The bitmap can be used to check if the given guest page is
> > > private or shared.
> > >
> > > During the migration flow, the SEND_START is called on the source hypervisor
> > > to create an outgoing encryption context. The SEV guest policy dictates whether
> > > the certificate passed through the migrate-set-parameters command will be
> > > validated. SEND_UPDATE_DATA is called to encrypt the guest private pages.
> > > After migration is completed, SEND_FINISH is called to destroy the encryption
> > > context and make the VM non-runnable to protect it against cloning.
> > >
> > > On the target machine, RECEIVE_START is called first to create an
> > > incoming encryption context. The RECEIVE_UPDATE_DATA is called to copy
> > > the received encrypted page into guest memory. After migration has
> > > completed, RECEIVE_FINISH is called to make the VM runnable.
> > >
> >
> > Thanks!  This belongs somewhere in the patch set.
> >
> > You still haven't answered my questions about the existing coherency
> > issues and whether the same infrastructure can be used to migrate
> > guest pages within the same machine.
>
> Page Migration and Live Migration are separate features and one of my
> colleagues is currently working on making page migration possible and removing
> SEV Guest pinning requirements.
> >
> > Also, you're making guest-side and host-side changes.  What ensures
> > that you don't try to migrate a guest that doesn't support the
> > hypercall for encryption state tracking?
>
> This is a good question and it is still an open-ended question. There
> are two possibilities here: guest does not have any unencrypted pages
> (for e.g booting 32-bit) and so it does not make any hypercalls, and
> the other possibility is that the guest does not have support for
> the newer hypercall.
>
> In the first case, all the guest pages are then assumed to be
> encrypted and live migration happens as such.
>
> For the second case, we have been discussing this internally,
> and one option is to extend the KVM capabilites/feature bits to check for this ?
>
> Thanks,
> Ashish

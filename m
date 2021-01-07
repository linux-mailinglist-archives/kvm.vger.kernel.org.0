Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8662EC792
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 02:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbhAGBCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 20:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbhAGBCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 20:02:50 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A89C0612F0
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 17:02:10 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id w12so5099841ilm.12
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 17:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+pZOMzSXqNqYPvJOHrAbmHBwI3d/1d3BxFzjQ+5ESHg=;
        b=nF1BO2XeUF0Sob8cJWpcsXHIRqZiFoaX2vqKapBT5/7rNA/5oqFv1F1C059wh0aJGn
         a/msaX4q+YoFhR4H9CBcTnQbz1GChYYZyyvU1Ehv4o2ZV9VSzYCMENcWMDiI3SCknpW2
         c0OBDT97gDOTMP0tT8L87Oqha1Vuv0BjbtG2TDGx6CUWRh5D0+1+npVAmugu3V97Ypai
         2PpD4LW9rtEkbvTlDBsiDMuI7MEFVtL3HCs6+HOtviPDNgnhoUip/ojK8CXaQLncEO7u
         ySYOj2UQp6uLsEmeicyt4CKqwNGOafpA3OKbKnorEk8zSCqV62GsAsT+MvW1t3F4gaHr
         71Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+pZOMzSXqNqYPvJOHrAbmHBwI3d/1d3BxFzjQ+5ESHg=;
        b=TLHV/vPaa1hKbaNKwR7Eji6wd2Efqnf0AWLMUYCL92pjmmbxR8X7mHD/Uc69982Z4E
         m5/CcuLL5gtqsLsoXqcnWQLLl33C0TFtCwiS2DEIfwBNLYpBtyg+N7HgwmarB967ofWx
         nvXDkfYwgLqq3lu7z85IUPlwWcYDUM+wqUbBGzxRdnaJjovKEL53TBm/n+a75otrf/2K
         HuRWGLIrV6IxMsi421WzE2CnCKcAFR8PKwII8nTXcaDSzEH8EwfPRjmQa9Yu9WVNBg1+
         NOGGLVxO7ja400TbZCY4eKSOj+iObGtVUcbr7XOqJRnqfW2GrfKpiHS1wTfzOOx0nHjR
         /qtg==
X-Gm-Message-State: AOAM533qW087w0i0RUItj2UJWJd3wY+plSFPUdRhKhH4ss93lYwVgXHC
        jWeR7le7zxzCZ4EafqsEH+Wo5ww/dYlQFd1+cETKLQ==
X-Google-Smtp-Source: ABdhPJzJPG26ePUWa10vkv65AY22i3kXxu/rjqhtw2LFcZaHLqtplru3E6RwvkRyjpXNoxTxcCat8LixKUKStX2bBhA=
X-Received: by 2002:a92:204:: with SMTP id 4mr6817617ilc.79.1609981329421;
 Wed, 06 Jan 2021 17:02:09 -0800 (PST)
MIME-Version: 1.0
References: <X8gyhCsEMf8QU9H/@google.com> <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
 <X86Tlin14Ct38zDt@google.com> <CABayD+esy0yeKi9W3wQw+ou4y4840LPCwd-PHhN1J6Uh_fvSjA@mail.gmail.com>
 <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com> <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server> <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com> <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server>
In-Reply-To: <20210106230555.GA13999@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 6 Jan 2021 17:01:33 -0800
Message-ID: <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoiding an rbtree for such a small (but unstable) list seems correct.

For the unencrypted region list strategy, the only questions that I
have are fairly secondary.
- How should the kernel upper bound the size of the list in the face
of malicious guests, but still support large guests? (Something
similar to the size provided in the bitmap API would work).
- What serialization format should be used for the ioctl API?
(Usermode could send down a pointer to a user region and a size. The
kernel could then populate that with an array of structs containing
bases and limits for unencrypted regions.)
- How will the kernel tag a guest as having exceeded its maximum list
size, in order to indicate that the list is now incomplete? (Track a
poison bit, and send it up when getting the serialized list of
regions).

In my view, there are two main competitors to this strategy:
- (Existing) Bitmap API
- A guest memory donation based model

The existing bitmap API avoids any issues with growing too large,
since it's size is predictable.

To elaborate on the memory donation based model, the guest could put
an encryption status data structure into unencrypted guest memory, and
then use a hypercall to inform the host where the base of that
structure is located. The main advantage of this is that it side steps
any issues around malicious guests causing large allocations.

The unencrypted region list seems very practical. It's biggest
advantage over the bitmap is how cheap it will be to pass the
structure up from the kernel. A memory donation based model could
achieve similar performance, but with some additional complexity.

Does anyone view the memory donation model as worth the complexity?
Does anyone think the simplicity of the bitmap is a better tradeoff
compared to an unencrypted region list?
Or have other ideas that are not mentioned here?


On Wed, Jan 6, 2021 at 3:06 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Fri, Dec 18, 2020 at 07:56:41PM +0000, Dr. David Alan Gilbert wrote:
> > * Kalra, Ashish (Ashish.Kalra@amd.com) wrote:
> > > Hello Dave,
> > >
> > > On Dec 18, 2020, at 1:40 PM, Dr. David Alan Gilbert <dgilbert@redhat.=
com> wrote:
> > >
> > > =EF=BB=BF* Ashish Kalra (ashish.kalra@amd.com) wrote:
> > > On Fri, Dec 11, 2020 at 10:55:42PM +0000, Ashish Kalra wrote:
> > > Hello All,
> > >
> > > On Tue, Dec 08, 2020 at 10:29:05AM -0600, Brijesh Singh wrote:
> > >
> > > On 12/7/20 9:09 PM, Steve Rutherford wrote:
> > > On Mon, Dec 7, 2020 at 12:42 PM Sean Christopherson <seanjc@google.co=
m> wrote:
> > > On Sun, Dec 06, 2020, Paolo Bonzini wrote:
> > > On 03/12/20 01:34, Sean Christopherson wrote:
> > > On Tue, Dec 01, 2020, Ashish Kalra wrote:
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > >
> > > KVM hypercall framework relies on alternative framework to patch the
> > > VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > > apply_alternative() is called then it defaults to VMCALL. The approac=
h
> > > works fine on non SEV guest. A VMCALL would causes #UD, and hyperviso=
r
> > > will be able to decode the instruction and do the right things. But
> > > when SEV is active, guest memory is encrypted with guest key and
> > > hypervisor will not be able to decode the instruction bytes.
> > >
> > > Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hyp=
ercall
> > > will be used by the SEV guest to notify encrypted pages to the hyperv=
isor.
> > > What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to=
 VMMCALL
> > > and opt into VMCALL?  It's a synthetic feature flag either way, and I=
 don't
> > > think there are any existing KVM hypercalls that happen before altern=
atives are
> > > patched, i.e. it'll be a nop for sane kernel builds.
> > >
> > > I'm also skeptical that a KVM specific hypercall is the right approac=
h for the
> > > encryption behavior, but I'll take that up in the patches later in th=
e series.
> > > Do you think that it's the guest that should "donate" memory for the =
bitmap
> > > instead?
> > > No.  Two things I'd like to explore:
> > >
> > >  1. Making the hypercall to announce/request private vs. shared commo=
n across
> > >     hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-=
* and TDX).
> > >     I'm concerned that we'll end up with multiple hypercalls that do =
more or
> > >     less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Mayb=
e it's a
> > >     pipe dream, but I'd like to at least explore options before shovi=
ng in KVM-
> > >     only hypercalls.
> > >
> > >
> > >  2. Tracking shared memory via a list of ranges instead of a using bi=
tmap to
> > >     track all of guest memory.  For most use cases, the vast majority=
 of guest
> > >     memory will be private, most ranges will be 2mb+, and conversions=
 between
> > >     private and shared will be uncommon events, i.e. the overhead to =
walk and
> > >     split/merge list entries is hopefully not a big concern.  I suspe=
ct a list
> > >     would consume far less memory, hopefully without impacting perfor=
mance.
> > > For a fancier data structure, I'd suggest an interval tree. Linux
> > > already has an rbtree-based interval tree implementation, which would
> > > likely work, and would probably assuage any performance concerns.
> > >
> > > Something like this would not be worth doing unless most of the share=
d
> > > pages were physically contiguous. A sample Ubuntu 20.04 VM on GCP had
> > > 60ish discontiguous shared regions. This is by no means a thorough
> > > search, but it's suggestive. If this is typical, then the bitmap woul=
d
> > > be far less efficient than most any interval-based data structure.
> > >
> > > You'd have to allow userspace to upper bound the number of intervals
> > > (similar to the maximum bitmap size), to prevent host OOMs due to
> > > malicious guests. There's something nice about the guest donating
> > > memory for this, since that would eliminate the OOM risk.
> > >
> > >
> > > Tracking the list of ranges may not be bad idea, especially if we use
> > > the some kind of rbtree-based data structure to update the ranges. It
> > > will certainly be better than bitmap which grows based on the guest
> > > memory size and as you guys see in the practice most of the pages wil=
l
> > > be guest private. I am not sure if guest donating a memory will cover
> > > all the cases, e.g what if we do a memory hotplug (increase the guest
> > > ram from 2GB to 64GB), will donated memory range will be enough to st=
ore
> > > the metadata.
> > >
> > > .
> > >
> > > With reference to internal discussions regarding the above, i am goin=
g
> > > to look into specific items as listed below :
> > >
> > > 1). "hypercall" related :
> > > a). Explore the SEV-SNP page change request structure (included in GH=
CB),
> > > see if there is something common there than can be re-used for SEV/SE=
V-ES
> > > page encryption status hypercalls.
> > > b). Explore if there is any common hypercall framework i can use in
> > > Linux/KVM.
> > >
> > > 2). related to the "backing" data structure - explore using a range-b=
ased
> > > list or something like rbtree-based interval tree data structure
> > > (as mentioned by Steve above) to replace the current bitmap based
> > > implementation.
> > >
> > >
> > >
> > > I do agree that a range-based list or an interval tree data structure=
 is a
> > > really good "logical" fit for the guest page encryption status tracki=
ng.
> > >
> > > We can only keep track of the guest unencrypted shared pages in the
> > > range(s) list (which will keep the data structure quite compact) and =
all
> > > the guest private/encrypted memory does not really need any tracking =
in
> > > the list, anything not in the list will be encrypted/private.
> > >
> > > Also looking at a more "practical" use case, here is the current log =
of
> > > page encryption status hypercalls when booting a linux guest :
> > >
> > > ...
> > >
> > > <snip>
> > >
> > > [   56.146336] page_enc_status_hc invoked, gpa =3D 1f018000, npages  =
=3D 1, enc =3D 1
> > > [   56.146351] page_enc_status_hc invoked, gpa =3D 1f00e000, npages  =
=3D 1, enc =3D 0
> > > [   56.147261] page_enc_status_hc invoked, gpa =3D 1f00e000, npages  =
=3D 1, enc =3D 0
> > > [   56.147271] page_enc_status_hc invoked, gpa =3D 1f018000, npages  =
=3D 1, enc =3D 0
> > > ....
> > >
> > > [   56.180730] page_enc_status_hc invoked, gpa =3D 1f008000, npages  =
=3D 1, enc =3D 0
> > > [   56.180741] page_enc_status_hc invoked, gpa =3D 1f006000, npages  =
=3D 1, enc =3D 0
> > > [   56.180768] page_enc_status_hc invoked, gpa =3D 1f008000, npages  =
=3D 1, enc =3D 1
> > > [   56.180782] page_enc_status_hc invoked, gpa =3D 1f006000, npages  =
=3D 1, enc =3D 1
> > >
> > > ....
> > > [   56.197110] page_enc_status_hc invoked, gpa =3D 1f007000, npages  =
=3D 1, enc =3D 0
> > > [   56.197120] page_enc_status_hc invoked, gpa =3D 1f005000, npages  =
=3D 1, enc =3D 0
> > > [   56.197136] page_enc_status_hc invoked, gpa =3D 1f007000, npages  =
=3D 1, enc =3D 1
> > > [   56.197148] page_enc_status_hc invoked, gpa =3D 1f005000, npages  =
=3D 1, enc =3D 1
> > > ....
> > >
> > > [   56.222679] page_enc_status_hc invoked, gpa =3D 1e83b000, npages  =
=3D 1, enc =3D 0
> > > [   56.222691] page_enc_status_hc invoked, gpa =3D 1e839000, npages  =
=3D 1, enc =3D 0
> > > [   56.222707] page_enc_status_hc invoked, gpa =3D 1e83b000, npages  =
=3D 1, enc =3D 1
> > > [   56.222720] page_enc_status_hc invoked, gpa =3D 1e839000, npages  =
=3D 1, enc =3D 1
> > > ....
> > >
> > > [   56.313747] page_enc_status_hc invoked, gpa =3D 1e5eb000, npages  =
=3D 1, enc =3D 0
> > > [   56.313771] page_enc_status_hc invoked, gpa =3D 1e5e9000, npages  =
=3D 1, enc =3D 0
> > > [   56.313789] page_enc_status_hc invoked, gpa =3D 1e5eb000, npages  =
=3D 1, enc =3D 1
> > > [   56.313803] page_enc_status_hc invoked, gpa =3D 1e5e9000, npages  =
=3D 1, enc =3D 1
> > > ....
> > > [   56.459276] page_enc_status_hc invoked, gpa =3D 1d767000, npages  =
=3D 100, enc =3D 0
> > > [   56.459428] page_enc_status_hc invoked, gpa =3D 1e501000, npages  =
=3D 1, enc =3D 1
> > > [   56.460037] page_enc_status_hc invoked, gpa =3D 1d767000, npages  =
=3D 100, enc =3D 1
> > > [   56.460216] page_enc_status_hc invoked, gpa =3D 1e501000, npages  =
=3D 1, enc =3D 0
> > > [   56.460299] page_enc_status_hc invoked, gpa =3D 1d767000, npages  =
=3D 100, enc =3D 0
> > > [   56.460448] page_enc_status_hc invoked, gpa =3D 1e501000, npages  =
=3D 1, enc =3D 1
> > > ....
> > >
> > > As can be observed here, all guest MMIO ranges are initially setup as
> > > shared, and those are all contigious guest page ranges.
> > >
> > > After that the encryption status hypercalls are invoked when DMA gets
> > > triggered during disk i/o while booting the guest ... here again the
> > > guest page ranges are contigious, though mostly single page is touche=
d
> > > and a lot of page re-use is observed.
> > >
> > > So a range-based list/structure will be a "good" fit for such usage
> > > scenarios.
> > >
> > > It seems surprisingly common to flick the same pages back and forth b=
etween
> > > encrypted and clear for quite a while;  why is this?
> > >
> > >
> > > dma_alloc_coherent()'s will allocate pages and then call
> > > set_decrypted() on them and then at dma_free_coherent(), set_encrypte=
d()
> > > is called on the pages to be freed. So these observations in the logs
> > > where a lot of single 4K pages are seeing C-bit transitions and
> > > corresponding hypercalls are the ones associated with
> > > dma_alloc_coherent().
> >
> > It makes me wonder if it might be worth teaching it to hold onto those
> > DMA pages somewhere until it needs them for something else and avoid th=
e
> > extra hypercalls; just something to think about.
> >
> > Dave
>
> Following up on this discussion and looking at the hypercall logs and DMA=
 usage scenarios on the SEV, I have the following additional observations a=
nd comments :
>
> It is mostly the Guest MMIO regions setup as un-encrypted by uefi/edk2 in=
itially, which will be the "static" nodes in the backing data structure for=
 page encryption status.
> These will be like 15-20 nodes/entries.
>
> Drivers doing DMA allocations using GFP_ATOMIC will be fetching DMA buffe=
rs from the pre-allocated unencrypted atomic pool, hence it will be a "stat=
ic" node added at kernel startup.
>
> As we see with the logs, almost all runtime C-bit transitions and corresp=
onding hypercalls will be from DMA I/O and dma_alloc_coherent/dma_free_cohe=
rent calls, these will be
> using 4K/single pages and mostly fragmented ranges, so if we use a "rbtre=
e" based interval tree then there will be a lot of tree insertions and dele=
tions
> (dma_alloc_coherent followed with a dma_free_coherent), so this will lead=
 to a lot of expensive tree rotations and re-balancing, compared to much le=
ss complex
> and faster linked list node insertions and deletions (if we use a list ba=
sed structure to represent these interval ranges).
>
> Also as the static nodes in the structure will be quite limited (all the =
above DMA I/O added ranges will simply be inserted and removed), so a linke=
d list lookup
> won't be too expensive compared to a tree lookup. In other words, this be=
 a fixed size list.
>
> Looking at the above, I am now more inclined to use a list based structur=
e to represent the page encryption status.
>
> Looking fwd. to any comments/feedback/thoughts on the above.
>
> Thanks,
> Ashish
>

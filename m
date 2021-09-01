Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24013FE0F4
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 19:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345596AbhIARLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 13:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236271AbhIARLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 13:11:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C839C61058;
        Wed,  1 Sep 2021 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630516216;
        bh=BeSjTyk8IACcdnvMjm5tLUlTS5W7wDTBRMg6jrANFuw=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=PdQElsi7VKnwDy88y+JdYK1So+Eu+TwJoL7hzyymopjEWpRiPjwEfAVF3LDSHvO2/
         ZSBZT9dDyfeqjeil3NrwxlCywVnR0NPDFOgz53ARsvbH4BmQdFB2rLpElFKD+bAzvS
         K1JclkPoKH4T4vhxs4Xht9T5hSPHbez4GcM0Y68o2P17l3ghjvt2kTb86YcJVblGpm
         2teVT33ZeTO7ggBxsjx9zbBjBQfoH2onaYZmK+jOjrlzdq54CBCkDVPMz6vQbM/upm
         acrao1ghIRgjgbfRm9jFRn5Q3ySiuGNrfPjQ+A1wPgl9ecLIgLDvdjxkH8jYSMo86l
         1hO9oW1OWBfRA==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id F2B4D27C005A;
        Wed,  1 Sep 2021 13:10:13 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 13:10:13 -0400
X-ME-Sender: <xms:8bMvYYpCXUaX87ZNfovzBsIL0l2kt7JSUBNSkM7Me_HUvu9XnZucrQ>
    <xme:8bMvYepsqwqGedYrNcczCqPecCKz7T1v4Ucm7Fc4H84s7tIZgZlbl6yf-Ox9wE3JH
    F1JnzRFP5wVGc4X_6Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    nhguhicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpedvleehjeejvefhuddtgeegffdtjedtffegveethedvgfejieev
    ieeufeevuedvteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedu
    keehieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinh
    hugidrlhhuthhordhush
X-ME-Proxy: <xmx:8bMvYdPz79kC1d4xlLxGp-fxRlsUj7XQa3VllBVc_CLVNwtlws4KRg>
    <xmx:8bMvYf7OoWXSKdaBQHOJtSD25fDftaDl1B10amGjfXPDklZ4uSNRiQ>
    <xmx:8bMvYX4aSfgupLti9k4CUV2OkdeLUig6Mm37FfqDyEe5A7LqokIvfA>
    <xmx:9bMvYTOV_Vb3JvMrqUw14mvxrHOm4zjlHRd5bfeiRTkJohRGh5IbqwBr7yw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 62C92A002E4; Wed,  1 Sep 2021 13:10:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <e7513990-47c9-478d-a636-f16caef62a60@www.fastmail.com>
In-Reply-To: <37d70069-b59f-04c7-f9af-a08af18d0339@redhat.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <YSlkzLblHfiiPyVM@google.com>
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
 <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
 <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
 <37d70069-b59f-04c7-f9af-a08af18d0339@redhat.com>
Date:   Wed, 01 Sep 2021 10:09:48 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "David Hildenbrand" <david@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>, "kvm list" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@alien8.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Joerg Roedel" <jroedel@suse.de>,
        "Andi Kleen" <ak@linux.intel.com>,
        "David Rientjes" <rientjes@google.com>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Varad Gautam" <varad.gautam@suse.com>,
        "Dario Faggioli" <dfaggioli@suse.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-mm@kvack.org,
        linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Sathyanarayanan Kuppuswamy" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Yu Zhang" <yu.c.zhang@linux.intel.com>
Subject: =?UTF-8?Q?Re:_[RFC]_KVM:_mm:_fd-based_approach_for_supporting_KVM_guest_?=
 =?UTF-8?Q?private_memory?=
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Wed, Sep 1, 2021, at 9:16 AM, David Hildenbrand wrote:
> On 01.09.21 17:54, Andy Lutomirski wrote:
> > On Wed, Sep 1, 2021, at 1:09 AM, David Hildenbrand wrote:
> >>>> Do we have to protect from that? How would KVM protect from user =
space
> >>>> replacing private pages by shared pages in any of the models we d=
iscuss?
> >>>
> >>> The overarching rule is that KVM needs to guarantee a given pfn is=
 never mapped[*]
> >>> as both private and shared, where "shared" also incorporates any m=
apping from the
> >>> host.  Essentially it boils down to the kernel ensuring that a pfn=
 is unmapped
> >>> before it's converted to/from private, and KVM ensuring that it ho=
nors any
> >>> unmap notifications from the kernel, e.g. via mmu_notifier or via =
a direct callback
> >>> as proposed in this RFC.
> >>
> >> Okay, so the fallocate(PUNCHHOLE) from user space could trigger the
> >> respective unmapping and freeing of backing storage.
> >>
> >>>
> >>> As it pertains to PUNCH_HOLE, the responsibilities are no differen=
t than when the
> >>> backing-store is destroyed; the backing-store needs to notify down=
stream MMUs
> >>> (a.k.a. KVM) to unmap the pfn(s) before freeing the associated mem=
ory.
> >>
> >> Right.
> >>
> >>>
> >>> [*] Whether or not the kernel's direct mapping needs to be removed=
 is debatable,
> >>>       but my argument is that that behavior is not visible to user=
space and thus
> >>>       out of scope for this discussion, e.g. zapping/restoring the=
 direct map can
> >>>       be added/removed without impacting the userspace ABI.
> >>
> >> Right. Removing it shouldn't also be requited IMHO. There are other=
 ways
> >> to teach the kernel to not read/write some online pages (filter
> >> /proc/kcore, disable hibernation, strict access checks for /dev/mem=
 ...).
> >>
> >>>
> >>>>>> Define "ordinary" user memory slots as overlay on top of "encry=
pted" memory
> >>>>>> slots.  Inside KVM, bail out if you encounter such a VMA inside=
 a normal
> >>>>>> user memory slot. When creating a "encryped" user memory slot, =
require that
> >>>>>> the whole VMA is covered at creation time. You know the VMA can=
't change
> >>>>>> later.
> >>>>>
> >>>>> This can work for the basic use cases, but even then I'd strongl=
y prefer not to
> >>>>> tie memslot correctness to the VMAs.  KVM doesn't truly care wha=
t lies behind
> >>>>> the virtual address of a memslot, and when it does care, it tend=
s to do poorly,
> >>>>> e.g. see the whole PFNMAP snafu.  KVM cares about the pfn<->gfn =
mappings, and
> >>>>> that's reflected in the infrastructure.  E.g. KVM relies on the =
mmu_notifiers
> >>>>> to handle mprotect()/munmap()/etc...
> >>>>
> >>>> Right, and for the existing use cases this worked. But encrypted =
memory
> >>>> breaks many assumptions we once made ...
> >>>>
> >>>> I have somewhat mixed feelings about pages that are mapped into $=
WHATEVER
> >>>> page tables but not actually mapped into user space page tables. =
There is no
> >>>> way to reach these via the rmap.
> >>>>
> >>>> We have something like that already via vfio. And that is fundame=
ntally
> >>>> broken when it comes to mmu notifiers, page pinning, page migrati=
on, ...
> >>>
> >>> I'm not super familiar with VFIO internals, but the idea with the =
fd-based
> >>> approach is that the backing-store would be in direct communicatio=
n with KVM and
> >>> would handle those operations through that direct channel.
> >>
> >> Right. The problem I am seeing is that e.g., try_to_unmap() might n=
ot be
> >> able to actually fully unmap a page, because some non-synchronized =
KVM
> >> MMU still maps a page. It would be great to evaluate how the fd
> >> callbacks would fit into the whole picture, including the current r=
map.
> >>
> >> I guess I'm missing the bigger picture how it all fits together on =
the
> >> !KVM side.
> >=20
> > The big picture is fundamentally a bit nasty.  Logically (ignoring t=
he implementation details of rmap, mmu_notifier, etc), you can call try_=
to_unmap and end up with a page that is Just A Bunch Of Bytes (tm).  The=
n you can write it to disk, memcpy to another node, compress it, etc. Wh=
en it gets faulted back in, you make sure the same bytes end up somewher=
e and put the PTEs back.
> >=20
> > With guest-private memory, this doesn't work.  Forget about the impl=
ementation: you simply can't take a page of private memory, quiesce it s=
o the guest can't access it without faulting, and turn it into Just A Bu=
nch Of Bytes.  TDX does not have that capability.  (Any system with inte=
grity-protected memory won't without having >PAGE_SIZE bytes or otherwis=
e storing metadata, but TDX can't do this at all.)  SEV-ES *can* (I thin=
k -- I asked the lead architect), but that's not the same thing as sayin=
g it's a good idea.
> >=20
> > So if you want to migrate a TDX page from one NUMA node to another, =
you need to do something different (I don't know all the details), you w=
ill have to ask Intel to explain how this might work in the future (it w=
asn't in the public docs last time I looked), but I'm fairly confident t=
hat it does not resemble try_to_unmap().
> >=20
> > Even on SEV, where a page *can* be transformed into a Just A Bunch O=
f Bytes, the operation doesn't really look like try_to_unmap().  As I un=
derstand it, it's more of:
> >=20
> > look up the one-and-only guest and GPA at which this page is mapped.
> > tear down the NPT PTE.  (SEV, unlike TDX, uses paging structures in =
normal memory.)
> > Ask the magic SEV mechanism to turn the page into swappable data
> > Go to town.
> >=20
> > This doesn't really resemble the current rmap + mmu_notifier code, a=
nd shoehorning this into mmu_notifier seems like it may be uglier and mo=
re code than implementing it more directly in the backing store.
> >=20
> > If you actually just try_to_unmap() a SEV-ES page (and it worked, wh=
ich it currently won't), you will have data corruption or cache incohere=
ncy.
> >=20
> > If you want to swap a page on TDX, you can't.  Sorry, go directly to=
 jail, do not collect $200.
> >=20
> > So I think there are literally zero code paths that currently call t=
ry_to_unmap() that will actually work like that on TDX.  If we run out o=
f memory on a TDX host, we can kill the guest completely and reclaim all=
 of its memory (which probably also involves killing QEMU or whatever ot=
her user program is in charge), but that's really our only option.
>=20
> try_to_unmap() would actually do the right thing I think. It's the use=
rs=20
> that access page content (migration, swapping) that need additional ca=
re=20
> to special-case these pages. Completely agree that these would be brok=
en.

I suspect that the eventual TDX numa migration flow will involve asking =
the TD module to relocate the page without unmapping it first. TDX doesn=
=E2=80=99t really have a nondestructive unmap operation.

>=20
>=20
> --=20
> Thanks,
>=20
> David / dhildenb
>=20
>=20

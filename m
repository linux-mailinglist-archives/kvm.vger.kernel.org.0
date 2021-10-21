Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D08436409
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhJUOZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhJUOZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 10:25:09 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5A2C0613B9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:22:54 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id z126so1011394oiz.12
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lryIt0qusZAixHtxWEAHB9bI3XGhlPYxhAGTdXgwNbE=;
        b=o1O6A3A8T0toxDxwR1tIxfj1aKYHLbCTEvkTnwT9tXXQ8kA5lOenhTG0+GH0y/je4T
         ETz5hgfh09jQAu1HTCjoV2JMJCnaMDyFt14FR+btKiX2GBBpKP4ar2btgsiw/NkD4fTg
         9tVOSWW7rWeEwodWnetPpmdbSd7uNMbQIAFzMmddGRJbXN0Dtutu7y8Ij7NeCrCuCACg
         PWuXV0iK8piDzf3QRp1cqENGSDAFKcBHRY1TwqjgZ4XUsgYWRCXknNnSzs/XWvwE1hLb
         Xsj0iPJVGWYyRFzZCTdg8/TymrGW3UGEXDVKu2KrmoSQG85pyRu5fEYnVVyxoGrWUHfb
         o21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lryIt0qusZAixHtxWEAHB9bI3XGhlPYxhAGTdXgwNbE=;
        b=p02Y/ZN308Jevw2pwJqoh1dQ1liIHKY5AIsxV+sm+gGlgypTeG5uX/SEnFMMGHHf55
         DlpF0p+PzXXzh6xj1bDuNnzEbLe2nfJWzm9qzps4ith3aA1KyzsHXqzg1EIIfJj6YNzd
         Zcs+6ily0CRDci8xQDIWhWnO1JGdHcp2bAPw4X1IpYbQS9Rk5zMTmMwqjNHVQ4VIh5ID
         hxwEdv6xVAGYXuR/dwkJZfYVbtbZ/wCCZdM/F+bTFgNkrwE4KBe09W9IwQp0YH8+mu7k
         9KvNcaeqhP09SF1DzRNvLYxLH0lHFWUav5LmrbXOexrqqpOMBMj6nhRr7lgeU2YZPo2a
         0bhA==
X-Gm-Message-State: AOAM533q+UomRVlz2lO6uyxJY53F9ld3U/e5N7x3D9shyPYhD08KarGo
        bUIJpc1JVwvzaDJxIlWJmWiq9cDy0YcItwNAHRVhtQ==
X-Google-Smtp-Source: ABdhPJwavaEVfOCpNXpBt8lDnWa6Bi6oYgU4TKu7k5hH+JqcqiRLj6dphhna8fETToyw6p2grBBD+uPjNqD4/agTUCA=
X-Received: by 2002:a05:6808:3c2:: with SMTP id o2mr4630131oie.15.1634826173072;
 Thu, 21 Oct 2021 07:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211004204931.1537823-1-zxwang42@gmail.com> <4d3b7ca8-2484-e45c-9551-c4f67fc88da6@redhat.com>
In-Reply-To: <4d3b7ca8-2484-e45c-9551-c4f67fc88da6@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 21 Oct 2021 07:22:42 -0700
Message-ID: <CAA03e5E9BSLsuv5XQiMZGAL+MOqcbyWok0p6Z7U3m14W0p9bsA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 00/17] x86_64 UEFI and AMD SEV/SEV-ES support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zixuan Wang <zxwang42@gmail.com>, kvm list <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 7:10 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/10/21 22:49, Zixuan Wang wrote:
> > Hello,
>
> WHOA IT WORKS! XD
>
> There are still a few rough edges around the build system (and in
> general, the test harness is starting to really show its limits), but
> this is awesome work.  Thanks Drew, Varad and Zixuan (in alphabetic and
> temporal order) for the combined contribution!
>
> For now I've placed it at a 'uefi' branch on gitlab, while I'm waiting
> for some reviews of my GDT cleanup work.  Any future improvements can be
> done on top.

Phenomenal! And +1 on thanking Drew, Varad, and Zixuan! (And thanks
Paolo for reviewing, testing, and setting up a branch for this work
:-).)

Zixuan has actually had a v4 ready to go since last week that
incorporates Drew's last round of reviews, but we were holding off on
posting it because we kept getting more comments and Zixuan wanted to
incorporate all of the feedback :-).

Should we go ahead and post it to the list (and perhaps update the
branch in the gitlab so everyone can work off of that)? Or would it be
easier to wait for the GDT cleanup work to finalize, and then post it
afterward?

>
> Paolo
>
> > This patch series updates the x86_64 KVM-Unit-Tests to run under UEFI
> > and culminates in enabling AMD SEV/SEV-ES. The patches are organized as
> > four parts.
> >
> > The first part (patch 1) refactors the current Multiboot start-up code
> > by converting assembly data structures into C. This enables the
> > follow-up UEFI patches to reuse these data structures without redefining
> > or duplicating them in assembly.
> >
> > The second part (patches 2-3) copies code from Varad's patch set [1]
> > that builds EFI stubs without depending on GNU-EFI. Part 3 and 4 are
> > built on top of this part.
> >
> > The third part (patches 4-11) enables the x86_64 test cases to run
> > under UEFI. In particular, these patches allow the x86_64 test cases to
> > be built as EFI executables and take full control of the guest VM. The
> > efi_main() function sets up the KVM-Unit-Tests framework to run under
> > UEFI and then launches the test cases' main() functions. To date, we
> > have 38/43 test cases running with UEFI using this approach.
> >
> > The fourth part of the series (patches 12-17) focuses on SEV. In
> > particular, these patches introduce SEV/SEV-ES set up code into the EFI
> > set up process, including checking if SEV is supported, setting c-bits
> > for page table entries, and (notably) reusing the UEFI #VC handler so
> > that the set up process does not need to re-implement it (a test case
> > can always implement a new #VC handler and load it after set up is
> > finished). Using this approach, we are able to launch the x86_64 test
> > cases under SEV-ES and exercise KVM's VMGEXIT handler.
> >
> > Note, a previous feedback [3] indicated that long-term we'd like to
> > instrument KVM-Unit-Tests with it's own #VC handler. However, we still
> > believe that the current approach is good as an intermediate solution,
> > because it unlocks a lot of testing and we do not expect that testing
> > to be inherently tied to the UEFI's #VC handler. Rather, test cases
> > should be tied to the underlying GHCB spec implemented by an
> > arbitrary #VC handler.
> >
> > See the Part 1 to Part 4 summaries, below, for a high-level breakdown
> > of how the patches are organized.
> >
> > Part 1 Summary:
> > Commit 1 refactors boot-related data structures from assembly to C.
> >
> > Part 2 Summary:
> > Commits 2-3 copy code from Varad's patch set [1] that implements
> > EFI-related helper functions to replace the GNU-EFI library.
> >
> > Part 3 Summary:
> > Commits 4-5 introduce support to build test cases with EFI support.
> >
> > Commits 6-10 set up KVM-Unit-Tests to run under UEFI. In doing so, these
> > patches incrementally enable most existing x86_64 test cases to run
> > under UEFI.
> >
> > Commit 11 fixes several test cases that fail to compile with EFI due
> > to UEFI's position independent code (PIC) requirement.
> >
> > Part 4 Summary:
> > Commits 12-13 introduce support for SEV by adding code to set the SEV
> > c-bit in page table entries.
> >
> > Commits 14-16 introduce support for SEV-ES by reusing the UEFI #VC
> > handler in KVM-Unit-Tests. They also fix GDT and IDT issues that occur
> > when reusing UEFI functions in KVM-Unit-Tests.
> >
> > Commit 17 adds additional test cases for SEV-ES.
> >
> > Changes V2 -> V3:
> > V3 Patch #  Changes
> > ----------  -------
> >       01/17  (New patch) refactors assembly data structures in C
> >       02/17  Adds a missing alignment attribute
> >              Renames the file uefi.h to efi.h
> >       03/17  Adds an SPDX header, fixes a comment style issue
> >       06/17  Removes assembly data structure definitions
> >       07/17  Removes assembly data structure definitions
> >       12/17  Simplifies an if condition code
> >       14/17  Simplifies an if condition code
> >       15/17  Removes GDT copying for SEV-ES #VC handler
> >
> > Notes on page table set up code:
> > Paolo suggested unifying  the page table definitions in cstart64.S and
> > UEFI start-up code [5]. We tried but found it hard to implement due to
> > the real/long mode issue: a page table set up function written in C is
> > by default compiled to run in long mode. However, cstart64.S requires
> > page table setup before entering long mode. Calling a long mode function
> > from real/protected mode crashes the guest VM. Thus we chose not to
> > implement this feature in this patch set. More details can be found in
> > our off-list GitHub review [6].
> >
> > Changes V1 -> V2:
> > 1. Merge Varad's patches [1] as the foundation of our V2 patch set [4].
> > 2. Remove AMD SEV/SEV-ES config flags and macros (patches 11-17)
> > 3. Drop one commit 'x86 UEFI: Move setjmp.h out of desc.h' because we do
> > not link GNU-EFI library.
> >
> > Notes on authorships and attributions:
> > The first two commits are from Varad's patch set [1], so they are
> > tagged as 'From:' and 'Signed-off-by:' Varad. Commits 3-7 are from our
> > V1 patch set [2], and since Varad implemented similar code [1], these
> > commits are tagged as 'Co-developed-by:' and 'Signed-off-by:' Varad.
> >
> > Notes on patch sets merging strategy:
> > We understand that the current merging strategy (reorganizing and
> > squeezing Varad's patches into two) reduces Varad's authorships, and we
> > hope the additional attribution tags make up for it. We see another
> > approach which is to build our patch set on top of Varad's original
> > patch set, but this creates some noise in the final patch set, e.g.,
> > x86/cstart64.S is modified in Varad's part and later reverted in our
> > part as we implement start up code in C. For the sake of the clarity of
> > the code history, we believe the current approach is the best effort so
> > far, and we are open to all kinds of opinions.
> >
> > [1] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/
> > [2] https://lore.kernel.org/kvm/20210818000905.1111226-1-zixuanwang@google.com/
> > [3] https://lore.kernel.org/kvm/YSA%2FsYhGgMU72tn+@google.com/
> > [4] https://lore.kernel.org/kvm/20210827031222.2778522-1-zixuanwang@google.com/
> > [5] https://lore.kernel.org/kvm/3fd467ae-63c9-adba-9d29-09b8a7beb92d@redhat.com/
> > [6] https://github.com/marc-orr/KVM-Unit-Tests-dev-fork/pull/1
> >
> > Regards,
> > Zixuan Wang
> >
> > Varad Gautam (2):
> >    x86 UEFI: Copy code from Linux
> >    x86 UEFI: Implement UEFI function calls
> >
> > Zixuan Wang (15):
> >    x86: Move IDT, GDT and TSS to desc.c
> >    x86 UEFI: Copy code from GNU-EFI
> >    x86 UEFI: Boot from UEFI
> >    x86 UEFI: Load IDT after UEFI boot up
> >    x86 UEFI: Load GDT and TSS after UEFI boot up
> >    x86 UEFI: Set up memory allocator
> >    x86 UEFI: Set up RSDP after UEFI boot up
> >    x86 UEFI: Set up page tables
> >    x86 UEFI: Convert x86 test cases to PIC
> >    x86 AMD SEV: Initial support
> >    x86 AMD SEV: Page table with c-bit
> >    x86 AMD SEV-ES: Check SEV-ES status
> >    x86 AMD SEV-ES: Copy UEFI #VC IDT entry
> >    x86 AMD SEV-ES: Set up GHCB page
> >    x86 AMD SEV-ES: Add test cases
> >
> >   .gitignore                 |   3 +
> >   Makefile                   |  29 +-
> >   README.md                  |   6 +
> >   configure                  |   6 +
> >   lib/efi.c                  | 118 ++++++++
> >   lib/efi.h                  |  22 ++
> >   lib/linux/efi.h            | 539 +++++++++++++++++++++++++++++++++++++
> >   lib/x86/acpi.c             |  38 ++-
> >   lib/x86/acpi.h             |  11 +
> >   lib/x86/amd_sev.c          | 174 ++++++++++++
> >   lib/x86/amd_sev.h          |  63 +++++
> >   lib/x86/asm/page.h         |  28 +-
> >   lib/x86/asm/setup.h        |  35 +++
> >   lib/x86/desc.c             |  46 +++-
> >   lib/x86/desc.h             |   6 +-
> >   lib/x86/setup.c            | 246 +++++++++++++++++
> >   lib/x86/usermode.c         |   3 +-
> >   lib/x86/vm.c               |  18 +-
> >   x86/Makefile.common        |  68 +++--
> >   x86/Makefile.i386          |   5 +-
> >   x86/Makefile.x86_64        |  58 ++--
> >   x86/access.c               |   9 +-
> >   x86/amd_sev.c              |  94 +++++++
> >   x86/cet.c                  |   8 +-
> >   x86/cstart64.S             |  77 +-----
> >   x86/efi/README.md          |  63 +++++
> >   x86/efi/crt0-efi-x86_64.S  |  79 ++++++
> >   x86/efi/efistart64.S       |  77 ++++++
> >   x86/efi/elf_x86_64_efi.lds |  81 ++++++
> >   x86/efi/reloc_x86_64.c     |  96 +++++++
> >   x86/efi/run                |  63 +++++
> >   x86/emulator.c             |   5 +-
> >   x86/eventinj.c             |   6 +-
> >   x86/run                    |  16 +-
> >   x86/smap.c                 |   8 +-
> >   x86/umip.c                 |  10 +-
> >   x86/vmx.c                  |   8 +-
> >   37 files changed, 2067 insertions(+), 155 deletions(-)
> >   create mode 100644 lib/efi.c
> >   create mode 100644 lib/efi.h
> >   create mode 100644 lib/linux/efi.h
> >   create mode 100644 lib/x86/amd_sev.c
> >   create mode 100644 lib/x86/amd_sev.h
> >   create mode 100644 lib/x86/asm/setup.h
> >   create mode 100644 x86/amd_sev.c
> >   create mode 100644 x86/efi/README.md
> >   create mode 100644 x86/efi/crt0-efi-x86_64.S
> >   create mode 100644 x86/efi/efistart64.S
> >   create mode 100644 x86/efi/elf_x86_64_efi.lds
> >   create mode 100644 x86/efi/reloc_x86_64.c
> >   create mode 100755 x86/efi/run
> >
>

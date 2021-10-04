Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73133420F1B
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhJDNbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 09:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236945AbhJDN3P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 09:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633354044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3wIeBAbZa+UudCtpRgxTIjdaXZdYNzzwzAilVSKwWm4=;
        b=SA6W7j3OngE6LpEZI3Eat9tfdk81WkJQY6mAeASv3bPmZxOw9Mrxhg72TYcSwdeSVxD+Oq
        /kKKrX5+F2+K/Fg/BcZt7tvYNG9fEGOfVwnQ4fQSOIv2RfbfUMj6TT6ibRMUUklzIIKjSx
        tCq6I9+IIaND2kWA5dgtRIGcvB4DqX4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-jC2b08XIOcWABcXKHgwIeQ-1; Mon, 04 Oct 2021 09:27:23 -0400
X-MC-Unique: jC2b08XIOcWABcXKHgwIeQ-1
Received: by mail-wm1-f70.google.com with SMTP id 75-20020a1c004e000000b00307b9b32cc9so5137333wma.1
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 06:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3wIeBAbZa+UudCtpRgxTIjdaXZdYNzzwzAilVSKwWm4=;
        b=7xRzEeLQLmxZiEhjDc6y95MKFTS8i87qFgk0WzXbWpgNM1exxSXoJRWtl6RLw3Nh9O
         RmHVihnamsQi2yERj3sA/qDgx6MDJWVAqbFugoT1j0bAFpAn+8mALyqbRDtX8p0PVsn3
         HhL+25fUsjYKNIB1H1j++5NEJslCAA+80mea+IUueUOGwlhyfuqW+9MNiOUqhxmPsSAg
         FHH6vNZHWXVaMXXcfupQAEZmhnRkzw4lS0DtrvJNB8Q8LQVJ/fp0Mw7Kus6neWnunESh
         k9mRqfz7LDHIKBk7fWso4Ye3+F1gkD5SHCiCN5P38o0ZiGxk0R0Ltr1OlqigSuxn2qip
         ceAg==
X-Gm-Message-State: AOAM530d03grn7B4/I/+eilHnSDM9Qnan8ci3vgyVa4tCYNdLySjLIDf
        mwhyUJ8klOAGYSn8VfzRPuGXsKbLr9K5RZLbacYShAcRAS4xmrzbJjGWSVTXYombmqPC/PDGbfB
        xIZsvY+f0g9Wu
X-Received: by 2002:adf:b304:: with SMTP id j4mr14640449wrd.160.1633354042662;
        Mon, 04 Oct 2021 06:27:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzn/mnWHiCImFvYw7s7SIgiUIDei7STTNKk1DBc5LTbD18UZOFQwGkVA2QocET1t6DzwmkDSg==
X-Received: by 2002:adf:b304:: with SMTP id j4mr14640424wrd.160.1633354042436;
        Mon, 04 Oct 2021 06:27:22 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id f123sm17070106wmf.30.2021.10.04.06.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 06:27:22 -0700 (PDT)
Date:   Mon, 4 Oct 2021 15:27:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     zxwang42@gmail.com
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, marcorr@google.com,
        baekhw@google.com, tmroeder@google.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 00/17] x86_64 UEFI and AMD SEV/SEV-ES
 support
Message-ID: <20211004132720.i77d2knwl7gxi3mx@gator>
References: <20210827031222.2778522-1-zixuanwang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 03:12:05AM +0000, Zixuan Wang wrote:
> Hello,
> 
> This patch series updates the x86_64 KVM-Unit-Tests to run under UEFI
> and culminates in enabling AMD SEV/SEV-ES. The patches are organized as
> three parts.
> 
> The first part (patches 1-2) copies code from Varad's patch set [1]
> that builds EFI stubs without depending on GNU-EFI. Part 2 and 3 are
> built on top of this part.
> 
> The second part (patches 3-10) enables the x86_64 test cases to run
> under UEFI. In particular, these patches allow the x86_64 test cases to
> be built as EFI executables and take full control of the guest VM. The
> efi_main() function sets up the KVM-Unit-Tests framework to run under
> UEFI and then launches the test cases' main() function. To date, we
> have 38/43 test cases running with UEFI using this approach.
> 
> The third part of the series (patches 11-17) focuses on SEV. In
> particular, these patches introduce SEV/SEV-ES set up code into the EFI
> set up process, including checking if SEV is supported, setting c-bits
> for page table entries, and (notably) reusing the UEFI #VC handler so
> that the set up process does not need to re-implement it (a test case
> can always implement a new #VC handler and load it after set up is
> finished). Using this approach, we are able to launch the x86_64 test
> cases under SEV-ES and exercise KVM's VMGEXIT handler.
> 
> Note, a previous feedback [3] indicated that long-term we'd like to
> instrument KVM-Unit-Tests with it's own #VC handler. However, we still
> believe that the current approach is good as an intermediate solution,
> because it unlocks a lot of testing and we do not expect that testing
> to be inherently tied to the UEFI's #VC handler. Rather, test cases
> should be tied to the underlying GHCB spec implemented by an
> arbitrary #VC handler.
> 
> See the Part 1 to Part 3 summaries, below, for a high-level breakdown
> of how the patches are organized.
> 
> Part 1 Summary:
> Commits 1-2 copy code from Varad's patch set [1] that implements
> EFI-related helper functions to replace the GNU-EFI library.
> 
> Part 2 Summary:
> Commits 3-4 introduce support to build test cases with EFI support.
> 
> Commits 5-9 set up KVM-Unit-Tests to run under UEFI. In doing so, these
> patches incrementally enable most existing x86_64 test cases to run
> under UEFI.
> 
> Commit 10 fixes several test cases that fail to compile with EFI due
> to UEFI's position independent code (PIC) requirement.
> 
> Part 3 Summary:
> Commits 11-12 introduce support for SEV by adding code to set the SEV
> c-bit in page table entries.
> 
> Commits 13-16 introduce support for SEV-ES by reusing the UEFI #VC
> handler in KVM-Unit-Tests. They also fix GDT and IDT issues that occur
> when reusing UEFI functions in KVM-Unit-Tests.
> 
> Commit 17 adds additional test cases for SEV-ES.
> 
> Changes in V2:
> 1.Merge Varad's patch set [1] as the foundation of this V2 patch set.
> 2.Remove AMD SEV/SEV-ES config flags and macros (patches 11-17)
> 3.Drop one commit 'x86 UEFI: Move setjmp.h out of desc.h' because we do
> not link GNU-EFI library.
> 
> Notes on authorships and attributions:
> The first two commits are from Varad's patch set [1], so they are
> tagged as 'From:' and 'Signed-off-by:' Varad. Commits 3-7 are from our
> V1 patch set [2], and since Varad implemented similar code [1], these
> commits are tagged as 'Co-developed-by:' and 'Signed-off-by:' Varad.
> 
> Notes on patch sets merging strategy:
> We understand that the current merging strategy (reorganizing and
> squeezing Varad's patches into two) reduces Varad's authorships, and we
> hope the additional attribution tags make up for it. We see another
> approach which is to build our patch set on top of Varad's original
> patch set, but this creates some noise in the final patch set, e.g.,
> x86/cstart64.S is modified in Varad's part and later reverted in our
> part as we implement start up code in C. For the sake of the clarity of
> the code history, we believe the current approach is the best effort so
> far, and we are open to all kinds of opinions.
> 
> [1] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/
> [2] https://lore.kernel.org/kvm/20210818000905.1111226-1-zixuanwang@google.com/
> [3] https://lore.kernel.org/kvm/YSA%2FsYhGgMU72tn+@google.com/
> 
> Regards,
> Zixuan Wang
> 
> Varad Gautam (2):
>   x86 UEFI: Copy code from Linux
>   x86 UEFI: Implement UEFI function calls
> 
> Zixuan Wang (15):
>   x86 UEFI: Copy code from GNU-EFI
>   x86 UEFI: Boot from UEFI
>   x86 UEFI: Load IDT after UEFI boot up
>   x86 UEFI: Load GDT and TSS after UEFI boot up
>   x86 UEFI: Set up memory allocator
>   x86 UEFI: Set up RSDP after UEFI boot up
>   x86 UEFI: Set up page tables
>   x86 UEFI: Convert x86 test cases to PIC
>   x86 AMD SEV: Initial support
>   x86 AMD SEV: Page table with c-bit
>   x86 AMD SEV-ES: Check SEV-ES status
>   x86 AMD SEV-ES: Load GDT with UEFI segments
>   x86 AMD SEV-ES: Copy UEFI #VC IDT entry
>   x86 AMD SEV-ES: Set up GHCB page
>   x86 AMD SEV-ES: Add test cases
> 
>  .gitignore                 |   3 +
>  Makefile                   |  29 +-
>  README.md                  |   6 +
>  configure                  |   6 +
>  lib/efi.c                  | 117 ++++++++
>  lib/efi.h                  |  18 ++
>  lib/linux/uefi.h           | 539 +++++++++++++++++++++++++++++++++++++
>  lib/x86/acpi.c             |  38 ++-
>  lib/x86/acpi.h             |  11 +
>  lib/x86/amd_sev.c          | 214 +++++++++++++++
>  lib/x86/amd_sev.h          |  64 +++++
>  lib/x86/asm/page.h         |  28 +-
>  lib/x86/asm/setup.h        |  31 +++
>  lib/x86/setup.c            | 246 +++++++++++++++++
>  lib/x86/usermode.c         |   3 +-
>  lib/x86/vm.c               |  18 +-
>  x86/Makefile.common        |  68 +++--
>  x86/Makefile.i386          |   5 +-
>  x86/Makefile.x86_64        |  58 ++--
>  x86/access.c               |   9 +-
>  x86/amd_sev.c              |  94 +++++++
>  x86/cet.c                  |   8 +-
>  x86/efi/README.md          |  63 +++++
>  x86/efi/crt0-efi-x86_64.S  |  79 ++++++
>  x86/efi/efistart64.S       | 143 ++++++++++
>  x86/efi/elf_x86_64_efi.lds |  81 ++++++
>  x86/efi/reloc_x86_64.c     |  97 +++++++
>  x86/efi/run                |  63 +++++
>  x86/emulator.c             |   5 +-
>  x86/eventinj.c             |   6 +-
>  x86/run                    |  16 +-
>  x86/smap.c                 |   8 +-
>  x86/umip.c                 |  10 +-
>  33 files changed, 2110 insertions(+), 74 deletions(-)
>  create mode 100644 lib/efi.c
>  create mode 100644 lib/efi.h
>  create mode 100644 lib/linux/uefi.h
>  create mode 100644 lib/x86/amd_sev.c
>  create mode 100644 lib/x86/amd_sev.h
>  create mode 100644 lib/x86/asm/setup.h
>  create mode 100644 x86/amd_sev.c
>  create mode 100644 x86/efi/README.md
>  create mode 100644 x86/efi/crt0-efi-x86_64.S
>  create mode 100644 x86/efi/efistart64.S
>  create mode 100644 x86/efi/elf_x86_64_efi.lds
>  create mode 100644 x86/efi/reloc_x86_64.c
>  create mode 100755 x86/efi/run
> 
> --
> 2.33.0.259.gc128427fd7-goog
>

Hi Zixuan,

If you still intend to work on this series, please send a new posting from
your personal mail address to avoid mail bounces on reviews.

Thanks,
drew


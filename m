Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EF13EF54C
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 23:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhHQVzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 17:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbhHQVzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 17:55:23 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE16C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 14:54:49 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id f15so63094ilk.4
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 14:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hDhPksNxyR4TcPdTSzYAamiTSiyDlI9TxfOng/Fc6A=;
        b=I/30yJpCzozkdrYlUv3IltB0unFSuxTmp9pBOvZekLWYygJEwBi8l84vfYI4Sj4E6+
         jlLIRwTNXyJMb5hXdAig9QX3QBraYEhqhAFaCv8Gg8XTrbB2zKY4ckVR0JwrwViQly0O
         m+RNE4/u+WJxQp71/OrtkW8twRgrR1RiOhix2CTOv4VgOI6BBWDYPAoXrELdcmGEULND
         JiNbTKwUWF8NuuRJ8gS3xSWr43Kjp8dkEUSJPanGjGhCJ8ys8nAcGocSOGf09BYgycDO
         cZlTOvv6A7jU3aVizCNfauwloxVJZvRRc84TrLtNIotIGmjNRlTcbk09W8FLDCnfQVlR
         dNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hDhPksNxyR4TcPdTSzYAamiTSiyDlI9TxfOng/Fc6A=;
        b=TxPAdfofeJmo6AsDy0zl+GF9EeqJrnLuXBXnE0dRU52rILE2ic+feiJkKWLgRjpsp1
         tCVBIQt/idcTH1NArnbdRcObnjfhUmWf8HPUD1d63S+GWFhEKUoAyc6Go9tPkL6MuvXb
         kLprZ3TjJFLh++efYRCClcSxAtk57N+d8d8Z39AlYwY27KZ2AJza8ZHjj3gp2B7V9aH9
         a0vfMETpKuftIcKvx6x6jyeu5fuv+El/tsssqRVKQsphANckAgChNZvSyoSuplNP7oxM
         gBub8mVBU1HvdA1Ak6CXBM+KoKhEiD75IWZCcb2M8TidlUUgZ4/Ypx0OKYY++2f/vc9P
         IuEw==
X-Gm-Message-State: AOAM531cQnHfVGEPHVix+ATlZpDOKJe5rt6VEigOwq7zs7Yht+Tp6Pyr
        T2xpbS/iRU9map+X4woXP3twBAZXvMDmNSNI3P7OMg==
X-Google-Smtp-Source: ABdhPJwHOvXMyv6GRsxj3q3yeK+mab9ypJGKr5LiN8i8B2n95hYEaeBdjtkyPw5waFYCTiZ0LCTWJmJW5W2OAMWJ9a4=
X-Received: by 2002:a92:6a0d:: with SMTP id f13mr4102979ilc.212.1629237288724;
 Tue, 17 Aug 2021 14:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629118207.git.ashish.kalra@amd.com> <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
In-Reply-To: <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 17 Aug 2021 14:54:12 -0700
Message-ID: <CABayD+d4dHBMbshx_gMUxaHkJZENYYRMrzatDtS-a1awGQKv2A@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        jejb@linux.ibm.com, tobin@ibm.com, dovmurik@linux.vnet.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 9:32 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 17/08/21 01:53, Steve Rutherford wrote:
> > Separately, I'm a little weary of leaving the migration helper mapped
> > into the shared address space as writable.
>
> A related question here is what the API should be for how the migration
> helper sees the memory in both physical and virtual address.
>
> First of all, I would like the addresses passed to and from the
> migration helper to *not* be guest physical addresses (this is what I
> referred to as QEMU's ram_addr_t in other messages).  The reason is that
> some unmapped memory regions, such as virtio-mem hotplugged memory,
> would still have to be transferred and could be encrypted.  While the
> guest->host hypercall interface uses guest physical addresses to
> communicate which pages are encrypted, the host can do the
> GPA->ram_addr_t conversion and remember the encryption status of
> currently-unmapped regions.
>
> This poses a problem, in that the guest needs to prepare the page tables
> for the migration helper and those need to use the migration helper's
> physical address space.
>
> There's three possibilities for this:
>
> 1) the easy one: the bottom 4G of guest memory are mapped in the mirror
> VM 1:1.  The ram_addr_t-based addresses are shifted by either 4G or a
> huge value such as 2^42 (MAXPHYADDR - physical address reduction - 1).
> This even lets the migration helper reuse the OVMF runtime services
> memory map (but be careful about thread safety...).
If I understand what you are proposing, this would only work for
SEV/SEV-ES, since the RMP prevents these remapping games. This makes
me less enthusiastic about this (but I suspect that's why you call
this less future proof).
>
> 2) the more future-proof one.  Here, the migration helper tells QEMU
> which area to copy from the guest to the mirror VM, as a (main GPA,
> length, mirror GPA) tuple.  This could happen for example the first time
> the guest writes 1 to MSR_KVM_MIGRATION_CONTROL.  When migration starts,
> QEMU uses this information to issue KVM_SET_USER_MEMORY_REGION
> accordingly.  The page tables are built for this (usually very high)
> mirror GPA and the migration helper operates in a completely separate
> address space.  However, the backing memory would still be shared
> between the main and mirror VMs.  I am saying this is more future proof
> because we have more flexibility in setting up the physical address
> space of the mirror VM.
>
> 3) the paranoid one, which I think is what you hint at above: this is an
> extension of (2), where userspace invokes the PSP send/receive API to
> copy the small requested area of the main VM into the mirror VM.  The
> mirror VM code and data are completely separate from the main VM.  All
> that the mirror VM shares is the ram_addr_t data.  Though I am not even
> sure it is possible to use the send/receive API this way...
Moreso what I was hinting at was treating the MH's code and data as
firmware is treated, i.e. initialize it via LAUNCH_UPDATE_DATA.
Getting the guest to trust host supplied code (i.e. firmware) needs to
happen regardless.

>
> What do you think?

My intuition for this leans more on the host, but matches some of the
bits you've mentioned in (2)/(3). My intuition would be to put the
migration helper incredibly high in gPA space, so that it does not
collide with the rest of the guest (and can then stay in the same
place for a fairly long period of time without needing to poke a hole
in the guest). Then you can leave the ram_addr_t-based addresses
mapped normally (without the offsetting). All this together allows the
migration helper to be orthogonal to the normal guest and normal
firmware.

In this case, since the migration helper has a somewhat stable base
address, you can have a prebaked entry point and page tables
(determined at build time). The shared communication pages can come
from neighboring high-memory. The migration helper can support a
straightforward halt loop (or PIO loop, or whatever) where it reads
from a predefined page to find what work needs to be done (perhaps
with that page depending on which CPU it is, so you can support
multithreading of the migration helper). Additionally, having it high
in memory makes it quite easy to assess who owns which addresses: high
mem is under the purview of the migration helper and does not need to
be dirty tracked. Only "low" memory can and needs to be encrypted for
transport to the target side.

--Steve
>
> Paolo
>

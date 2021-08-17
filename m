Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD483EF5C9
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 00:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhHQWiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 18:38:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230089AbhHQWiV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 18:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629239867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ud67t+V8KE9MuyGseGBuIWrgMVsL3BWFvN9kMjxMs9c=;
        b=GrXSyGX/FklT9GCUN+/ec7IhvKEne5BZfeP70rvIOSkcaqDxEA2M9GlAGzZy1gAFyvj8yx
        2fx/flXEpAcdt/imT1pUq7M3W8ffRMBFEbOyjnWU/bloTQw8Dxze58GZaOUQaJv75oW9v0
        tmOnud4Ws5+e0mnivzBxkkDQ1B5YA0I=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-1UVJ4bgoO7KeNaSfh7TbPw-1; Tue, 17 Aug 2021 18:37:46 -0400
X-MC-Unique: 1UVJ4bgoO7KeNaSfh7TbPw-1
Received: by mail-pj1-f71.google.com with SMTP id nn1-20020a17090b38c100b0017941ed86c2so3714731pjb.6
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 15:37:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ud67t+V8KE9MuyGseGBuIWrgMVsL3BWFvN9kMjxMs9c=;
        b=gAUZv2w9Jl2For7KqENpab/Dz4JjWWpScM4o6ix5vRQwPVZVM5FDwOVUGzyn0mCCMb
         BJrUHCnScwShWLqyorfNh2gKOPEMRfZZZXaZWcbmTdI4gF3Cu5n4/gnMjd2w+oJbmPpn
         anweXF/TLzqwx4ETIPysHISLuwnghew+z19d1Nx8DuJz0jmVAWKozfiCSZXbQ7pVxAIh
         +TVKz/yb48CLAD1yPD7QMjuYXkRArBsJzg4i2WMa5XXhXp0AXPjRM1r5ptACBf2RFM1/
         mAq1TESoK+cxARGuXJweBdWm01BvDvGp2DX82GDjwFNhaOPlyc8uyYlfQxw5ykv9A8Og
         OL7Q==
X-Gm-Message-State: AOAM532Ca2NQa/9+b1DDj0xu8VMu0uizGIKnZETJlMCEkFjRisMe7pt7
        aR/NPSuNMjZbIUtHp+SH/6nmCgOZT9gXqbv3U33mMNw4JsFZmD9DclIv20b5y7rMizad3E/AM7h
        p4TopC2SFc3VGUJv8bner4KJchgFO
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr5748559pjl.150.1629239865211;
        Tue, 17 Aug 2021 15:37:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTku+Tm4Wt2F3MT9pxv3jSPWrXGEtk0whqu3ZBkk/d4FX3y3csXAmjv8kbrejRyGhVMB/oLNuF3ALAOuUVf0c=
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr5748541pjl.150.1629239864959;
 Tue, 17 Aug 2021 15:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629118207.git.ashish.kalra@amd.com> <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com> <CABayD+d4dHBMbshx_gMUxaHkJZENYYRMrzatDtS-a1awGQKv2A@mail.gmail.com>
In-Reply-To: <CABayD+d4dHBMbshx_gMUxaHkJZENYYRMrzatDtS-a1awGQKv2A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 18 Aug 2021 00:37:32 +0200
Message-ID: <CABgObfZbyTxSO9ScE0RMK2vgyOam_REo+SgLA+-1XyP=8Vx+uQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Steve Rutherford <srutherford@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Habkost, Eduardo" <ehabkost@redhat.com>,
        "S. Tsirkin, Michael" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        David Gilbert <dgilbert@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 11:54 PM Steve Rutherford
<srutherford@google.com> wrote:
> > 1) the easy one: the bottom 4G of guest memory are mapped in the mirror
> > VM 1:1.  The ram_addr_t-based addresses are shifted by either 4G or a
> > huge value such as 2^42 (MAXPHYADDR - physical address reduction - 1).
> > This even lets the migration helper reuse the OVMF runtime services
> > memory map (but be careful about thread safety...).
>
> If I understand what you are proposing, this would only work for
> SEV/SEV-ES, since the RMP prevents these remapping games. This makes
> me less enthusiastic about this (but I suspect that's why you call
> this less future proof).

I called it less future proof because it allows the migration helper
to rely more on OVMF details, but those may not apply in the future.

However you're right about SNP; the same page cannot be mapped twice
at different GPAs by a single ASID (which includes the VM and the
migration helper). :( That does throw a wrench in the idea of mapping
pages by ram_addr_t(*), and this applies to both schemes.

Migrating RAM in PCI BARs is a mess anyway for SNP, because PCI BARs
can be moved and every time they do the migration helper needs to wait
for validation to happen. :(

Paolo

(*) ram_addr_t is not a GPA; it is constant throughout the life of the
guest and independent of e.g. PCI BARs. Internally, when QEMU
retrieves the dirty page bitmap from KVM it stores the bits indexed by
ram_addr_t (shifted right by PAGE_SHIFT).

> > 2) the more future-proof one.  Here, the migration helper tells QEMU
> > which area to copy from the guest to the mirror VM, as a (main GPA,
> > length, mirror GPA) tuple.  This could happen for example the first time
> > the guest writes 1 to MSR_KVM_MIGRATION_CONTROL.  When migration starts,
> > QEMU uses this information to issue KVM_SET_USER_MEMORY_REGION
> > accordingly.  The page tables are built for this (usually very high)
> > mirror GPA and the migration helper operates in a completely separate
> > address space.  However, the backing memory would still be shared
> > between the main and mirror VMs.  I am saying this is more future proof
> > because we have more flexibility in setting up the physical address
> > space of the mirror VM.
>
> My intuition for this leans more on the host, but matches some of the
> bits you've mentioned in (2)/(3). My intuition would be to put the
> migration helper incredibly high in gPA space, so that it does not
> collide with the rest of the guest (and can then stay in the same
> place for a fairly long period of time without needing to poke a hole
> in the guest). Then you can leave the ram_addr_t-based addresses
> mapped normally (without the offsetting). All this together allows the
> migration helper to be orthogonal to the normal guest and normal
> firmware.
>
> In this case, since the migration helper has a somewhat stable base
> address, you can have a prebaked entry point and page tables
> (determined at build time). The shared communication pages can come
> from neighboring high-memory. The migration helper can support a
> straightforward halt loop (or PIO loop, or whatever) where it reads
> from a predefined page to find what work needs to be done (perhaps
> with that page depending on which CPU it is, so you can support
> multithreading of the migration helper). Additionally, having it high
> in memory makes it quite easy to assess who owns which addresses: high
> mem is under the purview of the migration helper and does not need to
> be dirty tracked. Only "low" memory can and needs to be encrypted for
> transport to the target side.
>
> --Steve
> >
> > Paolo
> >
>


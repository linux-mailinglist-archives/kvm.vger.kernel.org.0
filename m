Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC49528DD25
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 11:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgJNJWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 05:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388018AbgJNJU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 05:20:58 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D92BC0610D2
        for <kvm@vger.kernel.org>; Tue, 13 Oct 2020 15:40:39 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c21so1129811ljj.0
        for <kvm@vger.kernel.org>; Tue, 13 Oct 2020 15:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C95JE+mHODDodnLkF36OpP56wFAkD0TkDH/Ba36Rdpo=;
        b=mbpELPlfanPl29T0k9DKIe6P+LRDcNhcTIBjOF6J45FU1I/v0Vu2zI7kZHCAZO/BDG
         3Iubz9p8HnQZx+b5ojmN763j1/9CTbWMYRej0aGcW2wBLQ9iu2zD/uf8TSOCS4IL+wgP
         fHHJ7mOlkaMn67Z8XB9KDzCHJ8UW5D45oEyPcEQx6g8Yb70LErQ8ZtA5NkkbUw7EOBbH
         8QRbRN98JrCBrAxdfPNO5WAow/G5jSps3aOhoLj1E2gsWSFXxEW3HdqZzYlryqdloExS
         XjwEg7JrdKNsHTN1S7mh2WaIuCBhJ+a6jHMgEbZ7ZCZs2r4BoJiETyk6oKoMGECwm3IE
         ctOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C95JE+mHODDodnLkF36OpP56wFAkD0TkDH/Ba36Rdpo=;
        b=tA0NspJKXqDq2GoCxudnmxpNDKDIFhnM6IzUTVzd9Aexu1+8w8uqkzChxyN1CnlGfq
         FEfluZoH9tz9kFtiM/2Utuzmj177qyAS46q2qt/itxWO8JccQswX/VNO6G3tBiRUua+u
         cLrzHk0RPSqRSvN2xNDquPcrqZVmt475TsMkNe/Qv8pGLSt5RsXXZUUUa7skTsJf25xb
         0+7012kl3HS8WMOg/YlvIumMt5DqQnqnGAk098U7lyySMLKnnWzuh8j/dR/rY8zgM1uz
         sSpe/3WbvqLJOlt1my4viwJXL/bXFwdB83XF1MvwTeInRhtgjU4dnB6BXtxxHX0PfVYo
         OFmA==
X-Gm-Message-State: AOAM532iZGJWkhgVJUh/VuWiXTBHR3KwmuYqPGGkEjSaoGP4n7R7+NQc
        Hxiz/uDSiNp8jr65gKwIqVJN9RgYap66nmsbw4o=
X-Google-Smtp-Source: ABdhPJzpPWP5mrM5qGjhGlnmvUPWBacR1EMrK8VlvEEi2Vo7FK4UeC+GkOI7BgUWWEvCRzk3gr/ntKVwOYlvsoWgOZ4=
X-Received: by 2002:a2e:b006:: with SMTP id y6mr564022ljk.462.1602628837706;
 Tue, 13 Oct 2020 15:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com> <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
 <20201013045245.GA11344@linux.intel.com> <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
 <20201013070329.GC11344@linux.intel.com>
In-Reply-To: <20201013070329.GC11344@linux.intel.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Tue, 13 Oct 2020 18:40:19 -0400
Message-ID: <CA+-xGqO37RzQDg5dnE_3NWMp6+u2L02GQDqoSr3RdedoMBugrg@mail.gmail.com>
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks much for your detailed replies. It's clear to me why GPAs are
different from HVAs in QEM/KVM. Thanks! I appreciate it if you could
help with the following two more questions.

On Tue, Oct 13, 2020 at 3:03 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> This is where memslots come in.  Think of memslots as a one-level page tablea
> that translate GPAs to HVAs.  A memslot, set by userspace, tells KVM the
> corresponding HVA for a given GPA.
>
> Before the guest is running (assuming host userspace isn't broken), the
> userspace VMM will first allocate virtual memory (HVA) for all physical
> memory it wants to map into the guest (GPA).  It then tells KVM how to
> translate a given GPA to its HVA by creating a memslot.
>
> To avoid getting lost in a tangent about page offsets, let's assume array[0]'s
> GPA = 0xa000.  For KVM to create a GPA->HPA mapping for the guest, there _must_
> be a memslot that translates GPA 0xa000 to an HVA[*].  Let's say HVA = 0xb000.
>
> On an EPT violation, KVM does a memslot lookup to translate the GPA (0xa000) to
> its HVA (0xb000), and then walks the host page tables to translate the HVA into
> a HPA (let's say that ends up being 0xc000).  KVM then stuffs 0xc000 into the
> EPT tables, which yields:
>
>   GPA    -> HVA    (KVM memslots)
>   0xa000    0xb000
>
>   HVA    -> HPA    (host page tables)
>   0xb000    0xc000
>
>   GPA    -> HPA    (extended page tables)
>   0xa000    0xc000
>
> To keep the EPT tables synchronized with the host page tables, if HVA->HPA
> changes, e.g. HVA 0xb000 is remapped to HPA 0xd000, then KVM will get notified
> by the host kernel that the HVA has been unmapped and will find and unmap
> the corresponding GPA (again via memslots) to HPA translations.
>
> Ditto for the case where userspace moves a memslot, e.g. if HVA is changed
> to 0xe000, KVM will first unmap all old GPA->HPA translations so that accesses
> to GPA 0xa000 from the guest will take an EPT violation and see the new HVA
> (and presumably a new HPA).

Q1: Is there any file like ``/proc/pid/pagemap'' to record the
mappings between GPAs and HVAs in the host OS?

Q2: Seems that there might be extra overhead (e.g., synchronization
between EPT tables and host regular page tables; maintaining extra
regular page tables and data structures), which is caused by the extra
translation between GPAs to HVAs via memslots. Why doesn't KVM
directly use GPAs as HVAs and leverage extended/nested page tables to
translate HVAs (i.e., GPAs) to HPAs?

Thanks,
Harry

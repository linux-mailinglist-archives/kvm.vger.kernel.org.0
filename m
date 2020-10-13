Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC0528C811
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 07:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbgJMFBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 01:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgJMFBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 01:01:06 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C512C0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 22:01:06 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c141so14046668lfg.5
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 22:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4tUFkCjr3BR4BPVQ1A2IdcD3uE18Oab1p6vpEeHtR3k=;
        b=utQZ9ggKNRuPFPYeI52bpvk5FdbHiRnsW8MS2LyeDtmrEm/j0NJXyNaB2fUO+fWTDw
         LLdOq08+UIOmXwW4v7znBzgkspAj4s4I2TLUivUwFuCN4nWLNZPd2mGpVm/SGDp3jU8P
         F5JtGISzUVW9I1VpZmsLyHZI7wLTFgZJtTR4cQglTyUKX0J7rRgjhyHpvmOMyOU6q9YQ
         fMAwT1jWheIHSy4x4XQYb6jgQU8bOu67ygtL2QgTRlkK42+7vosQCWisSd0n3B4ZYp68
         XnQSxHa/DNlulRyo5h8CRSqxSukzskMRoDlMr8mT097B97UblboAGbGYGWF10N+Z8RjG
         FEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4tUFkCjr3BR4BPVQ1A2IdcD3uE18Oab1p6vpEeHtR3k=;
        b=t5c8usD6SNDcpsGowvyLrfIPSkg1hnJz3pEelPWR+bKGJD27/cpWdr6C3p+ODmOABg
         RFR6oL1uMGpPK2fMCJN8c8yPNu+SBmzAVPoabs5/zwvijt4rszDq2eMbXrOY9xc36Z96
         SYhuRfXdJavEST54VqCAODt4K70CkpcM1BC7Do4QHbZvzotwRQ/iQF9Lku48AV/Bq8Um
         yXptHvaO3rSFg0O3GR9w4s6/W0d72n0oIyLaYDH8Bklsi4bK/c/qpQOW2FzbabDtX91H
         uqZ0E/OEhudidcj7F4Y5SKP2aiRoeAwzKCoAzyxGM9A3B47iimYYboFZBL8HQyzSrgSH
         Xf9w==
X-Gm-Message-State: AOAM533M9TjrWsDKWU3IRUNIJWbsjlm03js1fcbCTMbyoSE++/brTmJZ
        MvLnseQg0EcZ/K8AVGadyf/x6jeP3jNELN5ACQQ=
X-Google-Smtp-Source: ABdhPJxsDMs5v4qG7zLIU+Y8ZxU1bF2RlHuTOOp2qn/CEuXbMiL0Hy6LhJcVYbty1SbXw0do35Th4Nf/WfvQlDX0j00=
X-Received: by 2002:a19:8256:: with SMTP id e83mr8521474lfd.530.1602565264506;
 Mon, 12 Oct 2020 22:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com> <20201012165428.GD26135@linux.intel.com>
In-Reply-To: <20201012165428.GD26135@linux.intel.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Tue, 13 Oct 2020 01:00:47 -0400
Message-ID: <CA+-xGqNd37hyhAbkWxcze3YoVxY3a=_79b+ecF9+ZFCpbqcnnA@mail.gmail.com>
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

BTW, I still have one more question as follows. Thanks!

On Mon, Oct 12, 2020 at 12:54 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> No, the guest physical address spaces is not intrinsically tied to the host
> virtual address spaces.  The fact that GPAs and HVAs are related in KVM is a
> property KVM's architecture.  EPT/NPT has absolutely nothing to do with HVAs.
>
> As Maxim pointed out, KVM links a guest's physical address space, i.e. GPAs, to
> the host's virtual address space, i.e. HVAs, via memslots.  For all intents and
> purposes, this is an extra layer of address translation that is purely software
> defined.  The memslots allow KVM to retrieve the HPA for a given GPA when
> servicing a shadow page fault (a.k.a. EPT violation).
>
> When EPT is enabled, a shadow page fault due to an unmapped GPA will look like:
>
>  GVA -> [guest page tables] -> GPA -> EPT Violation VM-Exit
>
> The above walk of the guest page tables is done in hardware.  KVM then does the
> following walks in software to retrieve the desired HPA:
>
>  GPA -> [memslots] -> HVA -> [host page tables] -> HPA
>
> KVM then takes the resulting HPA and shoves it into KVM's shadow page tables,
> or when TDP is enabled, the EPT/NPT page tables.  When the guest is run with
> TDP enabled, GVA->HPA translations look like the following, with all walks done
> in hardware.
>
>  GVA -> [guest page tables] -> GPA -> [extended/nested page tables] -> HPA

If I understand correctly, the hardware logic of MMU to walk ``GPA ->
[extended/nested page tables] -> HPA''[1] should be the same as ``HVA
-> [host page tables] -> HPA"[2]. If not true, how does KVM find the
correct HPAs when there are EPT violations?

[1] Please note that this hardware walk is the last step, which only
translates the guest physical address to the host physical address
through the four-level nested page table.
[2] Please note that this hardware walk assumes translating the HVA to
the HPA without virtualization involvement.

Thanks,
Harry

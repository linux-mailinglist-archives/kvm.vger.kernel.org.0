Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F85295221
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 20:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504033AbgJUSVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 14:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389009AbgJUSVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 14:21:11 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11BEC0613CE
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 11:21:10 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id q5so3597475wmq.0
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 11:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8EasOxRhOP4tKSelXi8vOrt3irONBkQC3+dFEG5bU0=;
        b=Mlb6bwWn6Gm4wUGJrY2+hFY3C4CVXYM4RKDORq9plubHdK5JFCxrzlK8tWW2WyhiW0
         +1bmCbOY9cvLDsUqrlEdlXXK3cUeQFSE2EgCpPiScdBXi94x32bHTPWDlwjFKvi+liNe
         uDD5PL5oUZnuOCPjueMfEmwtHQOXCpm/y3FNnczTQ2O/dLX042Z9F66jY6ZLVYA9houk
         ++xik8f53NSFyhCOYynA11/0mdWGqA4Plx/DTN+E02yOOAgZfIeaOZ9ESZJrTftpjLuM
         T6FL9e2iSUAV438PzGCWoPCZnNOqLjWrXaWF4wGsXW0Z97vvZ2YboI7Re2zsP6v+jttq
         J64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8EasOxRhOP4tKSelXi8vOrt3irONBkQC3+dFEG5bU0=;
        b=oYpHGuaxN+7RXyFBY1v+9VFuB5Hpp1Euk/45GtVOc8/dpWnyuBcKqDgeHPnQ46Zx17
         2cXHXLzIJHglxw6zm0EQOzcLD0QddRZrj+Qn//yfAz23zqWqd7dElf7uZVRzs8G4MLhQ
         zS1594cjiWWTSOl7At3iAA14MG9z8IGu2j4zgVTpFS1tMHvFdnIu14sYiBnVeF7AJuMr
         vwrmMwoFlGhIOMsecXNOpvIbYTfcVQtqWaQH3ylP29eEGuREJaEMfez3QIzctc8GUWgL
         se43DN5jOJv56l/rwFGPdXwrXID/jevvR3vrnScWYj74QRQA7icWplMHuB2YbrIC93Uo
         ewOA==
X-Gm-Message-State: AOAM533z9dmqjEpTs8Oz8PSFxPejW23cFuX0gFE2CvwAE7zfTEn1pmba
        mGCeF9gc/1vPFJh17luc8QKS88PE/EQKqs6MT54zwQ==
X-Google-Smtp-Source: ABdhPJxeaHvFlSYfCn7icCcIaUnLYahs9NWAn8zCXcfEhTk7pgP/2yR1U+LNEDK6a6A9XIMuZAh6eXp/2YTAXoW/dOg=
X-Received: by 2002:a05:600c:2241:: with SMTP id a1mr5097261wmm.49.1603304468859;
 Wed, 21 Oct 2020 11:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Wed, 21 Oct 2020 11:20:56 -0700
Message-ID: <CALCETrXn_ghtLK34jmKSSp5_SF6hh5GOfBLKdxXgp5ZTbN8uEA@mail.gmail.com>
Subject: Re: [RFCv2 00/16] KVM protected memory extension
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 19, 2020, at 11:19 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:

> For removing the userspace mapping, use a trick similar to what NUMA
> balancing does: convert memory that belongs to KVM memory slots to
> PROT_NONE: all existing entries converted to PROT_NONE with mprotect() and
> the newly faulted in pages get PROT_NONE from the updated vm_page_prot.
> The new VMA flag -- VM_KVM_PROTECTED -- indicates that the pages in the
> VMA must be treated in a special way in the GUP and fault paths. The flag
> allows GUP to return the page even though it is mapped with PROT_NONE, but
> only if the new GUP flag -- FOLL_KVM -- is specified. Any userspace access
> to the memory would result in SIGBUS. Any GUP access without FOLL_KVM
> would result in -EFAULT.
>

I definitely like the direction this patchset is going in, and I think
that allowing KVM guests to have memory that is inaccessible to QEMU
is a great idea.

I do wonder, though: do we really want to do this with these PROT_NONE
tricks, or should we actually come up with a way to have KVM guest map
memory that isn't mapped into QEMU's mm_struct at all?  As an example
of the latter, I mean something a bit like this:

https://lkml.kernel.org/r/CALCETrUSUp_7svg8EHNTk3nQ0x9sdzMCU=h8G-Sy6=SODq5GHg@mail.gmail.com

I don't mean to say that this is a requirement of any kind of
protected memory like this, but I do think we should understand the
tradeoffs, in terms of what a full implementation looks like, the
effort and time frames involved, and the maintenance burden of
supporting whatever gets merged going forward.

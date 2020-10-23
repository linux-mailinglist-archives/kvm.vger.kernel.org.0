Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149CC297569
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465824AbgJWQ7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462951AbgJWQ7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 12:59:16 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC535C0613CE
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 09:59:15 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id h62so1957635oth.9
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 09:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GSVr128pqOoBVgaQYWDeH7y0Q+csz3WwPIzOZPNEXDU=;
        b=Gm9gB8LfWqXjYNl+ezisHjcKPpuYsHthevYvIaDtlEB9d+b83tyLXhvxMbEAce2RCO
         CmF8L6JhFKT5CK4tQHjNkssG/iskl/etKY6pLS+99Ew2EqkVPbrprYCdRzwzkjudwoPf
         Dfkh6+Z5B7HoPwQvg1wb//RugPRsKW2CDOH9dKQLQ7WLbz4rR5u4HvTWlgz5rgBdDd+j
         3WTb3QYAXr7pej5bwi+5CdYDUZi9D4M5JopRMJee1TnfGVj3oVywjh7rApTeHq4nqZDp
         GTDkyqsJy2mwxZ/NVxcjG+ll2QChI1WzogLNWiZ8G0k6ung0cvBNwr8oZIExoq4nG1Yo
         0fIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GSVr128pqOoBVgaQYWDeH7y0Q+csz3WwPIzOZPNEXDU=;
        b=lpn2frs842slYR+wuby+tcfQoexPxSp8KaAmlCvUE0fAknI7TSV5rd42rWOKtnPBxT
         88hnnAwyeE555Bo9RgqKhVWp1AzUBAT5+rwCzOXc8QcH4HQ2eoZwkPzOdHnVkfNryRWD
         pFzwi3LLCg/Kh01CLoFgujePzr7DEdUKJThlm9j3ChmfpomOTrgwpJtevV+gjD0MIly5
         GWs/kyDpMgG1vlDdoGkeJmfoy+FINm94dK1p49TbiRO5+/K9C/J81kktCuTnWQ1XmsX9
         PCeEB4Ic/B6x117o9F0T5J0P+lL0zv7GiJROuvNm4tcizynDXbPo8dfv9K6Lez8OmKtH
         q+Gg==
X-Gm-Message-State: AOAM533+1XBEGUEvcdDcxtOjRoV9KO1k9Yh2hpQ7ozG3MNyOg/R+ydW3
        p/rUBxdsMCH9zAUjQO4WQ7zWKdOn7nm5/0JfD6pQ0g==
X-Google-Smtp-Source: ABdhPJyeGWHQQDGVimyZ+QBAQPt7x+bmS1YILgkR+mEnGxuK2O6BoKn48ADm59edMi2szBv9/R+InVHL3y6rZeYy5GA=
X-Received: by 2002:a05:6830:10d3:: with SMTP id z19mr2501059oto.295.1603472354961;
 Fri, 23 Oct 2020 09:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200710154811.418214-1-mgamal@redhat.com> <20200710154811.418214-8-mgamal@redhat.com>
 <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
 <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
 <20201023031433.GF23681@linux.intel.com> <498cfe12-f3e4-c4a2-f36b-159ccc10cdc4@redhat.com>
In-Reply-To: <498cfe12-f3e4-c4a2-f36b-159ccc10cdc4@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 23 Oct 2020 09:59:03 -0700
Message-ID: <CALMp9eQ8C0pp5yP4tLsckVWq=j3Xb=e4M7UVZz67+pngaXJJUw@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Mohammed Gamal <mgamal@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 23, 2020 at 2:22 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/10/20 05:14, Sean Christopherson wrote:
> >>>> +
> >>>> +       /*
> >>>> +        * Check that the GPA doesn't exceed physical memory limits, as that is
> >>>> +        * a guest page fault.  We have to emulate the instruction here, because
> >>>> +        * if the illegal address is that of a paging structure, then
> >>>> +        * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
> >>>> +        * would also use advanced VM-exit information for EPT violations to
> >>>> +        * reconstruct the page fault error code.
> >>>> +        */
> >>>> +       if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
> >>>> +               return kvm_emulate_instruction(vcpu, 0);
> >>>> +
> >>> Is kvm's in-kernel emulator up to the task? What if the instruction in
> >>> question is AVX-512, or one of the myriad instructions that the
> >>> in-kernel emulator can't handle? Ice Lake must support the advanced
> >>> VM-exit information for EPT violations, so that would seem like a
> >>> better choice.
> >>>
> >> Anyone?
> >
> > Using "advanced info" if it's supported seems like the way to go.  Outright
> > requiring it is probably overkill; if userspace wants to risk having to kill a
> > (likely broken) guest, so be it.
>
> Yeah, the instruction is expected to page-fault here.  However the
> comment is incorrect and advanced information does not help here.
>
> The problem is that page fault error code bits cannot be reconstructed
> from bits 0..2 of the EPT violation exit qualification, if bit 8 is
> clear in the exit qualification (that is, if the access causing the EPT
> violation is to a paging-structure entry).  In that case bits 0..2 refer
> to the paging-structure access rather than to the final access.  In fact
> advanced information is not available at all for paging-structure access
> EPT violations.

True, but the in-kernel emulator can only handle a very small subset
of the available instructions.

If bit 8 is set in the exit qualification, we should use the advanced
VM-exit information. If it's clear, we should just do a software page
walk of the guest's x86 page tables. The in-kernel emulator should
only be used as a last resort on hardware that doesn't support the
advanced VM-exit information for EPT violations.

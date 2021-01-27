Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B66C306589
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 22:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhA0U6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 15:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbhA0U6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 15:58:03 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FFBC061573
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 12:57:22 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id j25so3724607oii.0
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 12:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/5giWFO3wXBwHEfC55BSYMxpJoJpAHOtOFoV5lHHRA=;
        b=JPqZdhXyX1eoR5kq9AJVmmHtPIf8+TmY20tZ1iOVqrJYJ8CuKijXF/eZokWKR/JE3f
         pHt3FTS0eCKoOE/7mlq0BvkQcwRekHJnRDaWObJkDEXu66CB4Fjk8laq9J8Pr8kHpapi
         2mI5B64ZVH7Le+0FqQ2JifJ1RFea6Iinj32vjRKuel2gBlWEyfa2HzLtgQCcMIdYyY2D
         AAyCUagm8BquLXLh9+mRd0+cuCcLlCIf6VO6LjJQpG7MF7yVh2HuCMDHP4YqnmvrkhLT
         nQlayhBo0NS6DgzZ4knY55DrQLM0MRC6fIDyPWyjzQ3hJnZF+0/LirccUXYO/ypeNRVV
         ZJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/5giWFO3wXBwHEfC55BSYMxpJoJpAHOtOFoV5lHHRA=;
        b=ex+Krf6jx4j3msK+p56t8e2jOFTyOdQGB5T7O8A9sZcxtwwyvRqT8XPnborF0jFupN
         X4XyVOd/pF2QOFWHYsWOLfJAJ7fq9vXwqzDKSf6UmTb6IRXFbUtg79eYvwNPgyI7OBXJ
         mfF6XZIWJKIbwQxbm4ODUPqIxIrSvnswGma15d+qLPeV6QmYS6tce/+sZX0OqVJaILtQ
         OPcO5ekR7FLf7lLj8pVjrgVEYxkHEaxM08EwOO+7VvkXPnd3xZUJH9DL3DgqDEBIRLxB
         d81lmmCV68Nb6ypwMMmbEav9XqI0zFriHwuE9RbDbaHZtPNc4URmFdZigBPfSBOj9VK3
         hx9w==
X-Gm-Message-State: AOAM530sJJ23fSYY5VanqFec89LuCp83jkjiNeIW8LIetdGgTyxPKzTf
        oH6EuMldsjv7VsxkDqhhVNWv0P60hp5J3mjPvk9j+g==
X-Google-Smtp-Source: ABdhPJzI9VMOhe2Vm3gxoArLG691jzZ+q1LVeqHx82wJThfCmBid7tvx1tL8lNW4pOrJLIQqXv1m5Swfob8ImGMF1mM=
X-Received: by 2002:a05:6808:8fa:: with SMTP id d26mr4522331oic.6.1611781041985;
 Wed, 27 Jan 2021 12:57:21 -0800 (PST)
MIME-Version: 1.0
References: <20200710154811.418214-1-mgamal@redhat.com> <20200710154811.418214-8-mgamal@redhat.com>
 <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
 <CALMp9eTFzQMpsrGhN4uJxyUHMKd5=yFwxLoBy==2BTHwmv_UGQ@mail.gmail.com>
 <20201023031433.GF23681@linux.intel.com> <498cfe12-f3e4-c4a2-f36b-159ccc10cdc4@redhat.com>
 <CALMp9eQ8C0pp5yP4tLsckVWq=j3Xb=e4M7UVZz67+pngaXJJUw@mail.gmail.com>
 <f40e5d23-88b6-01c0-60f9-5419dac703a2@redhat.com> <CALMp9eRGBiQDPr1wpAY34V=T6Jjij_iuHOX+_-QQPP=5SEw3GQ@mail.gmail.com>
 <4463f391-0a25-017e-f913-69c297e13c5e@redhat.com> <CALMp9eRnjdJtmU9bBosGNAxa2pvMzB8mHjtbYa-yb2uNoAkgdA@mail.gmail.com>
 <CALMp9eR2ONSpz__H2+ZpM4qqT7FNowNwOfe4x9o-ocfhwRnEhw@mail.gmail.com>
In-Reply-To: <CALMp9eR2ONSpz__H2+ZpM4qqT7FNowNwOfe4x9o-ocfhwRnEhw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 27 Jan 2021 12:57:10 -0800
Message-ID: <CALMp9eTyoVwvkc6YH9oBPP74dABJmUsA0Gz98+O+5kANHobWbQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 1:16 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Jan 15, 2021 at 11:35 AM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Oct 23, 2020 at 10:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 23/10/20 19:23, Jim Mattson wrote:
> > > >> The information that we need is _not_ that provided by the advanced
> > > >> VM-exit information (or by a page walk).  If a page is neither writable
> > > >> nor executable, the advanced information doesn't say if the injected #PF
> > > >> should be a W=1 or a F=1 fault.  We need the information in bits 0..2 of
> > > >> the exit qualification for the final access, which however is not
> > > >> available for the paging-structure access.
> > > >>
> > > > Are you planning to extend the emulator, then, to support all
> > > > instructions? I'm not sure where you are going with this.
> > >
> > > I'm going to fix the bit 8=1 case, but for bit 8=0 there's not much that
> > > you can do.  In all likelihood the guest is buggy anyway.
> >
> > Did this drop off your radar? Are you still planning to fix the bit8=1
> > case to use advanced EPT exit qualification information? Or did I just
> > miss it?
>
> Paolo,
> If you're not working on this, do you mind if I ask Aaron to take a look at it?

Ugh. The advanced EPT exit qualification contains nothing useful here,
AFAICT. It only contains x86 page protection information--nothing
about the access itself.

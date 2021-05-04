Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350703731CD
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 23:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhEDVRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 17:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhEDVRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 17:17:52 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC91C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 14:16:56 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id j20so7563328ilo.10
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 14:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NO76g2V6YO9liWnh4UbX1vxV8zjs7Pw4ACyPlVCyUgY=;
        b=FxUEulgNjm630aSSiUIdWNw+5aClOyUoVxmAZPKeNQbuP+r6214kJ1TXDXcZGcvzJ6
         yVhu1OQilQw9gJ7+VE3diVVksHZN8aV4qoQ3olrWU29HfoXxFQT0QcnPAvZd6EuYOavH
         XN4Tzf5PmgJugVixxb/fS3RJzh1F7MKD7B9b+hiizf8GGFFN1ChpYONsA+JCtSALwVeK
         gjEjG7go/wJr46tA+lU7c74kbFQjSAaf2VJONJjm+hi8qib/bkEogLZ9LJUaiJg2CcE3
         /miK/WGaphVKGlLNRYqbXqCCBqR5oU2r3cDoTpUP+oinSgd2FRQSy27EZwWAAloDeT2z
         9HVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NO76g2V6YO9liWnh4UbX1vxV8zjs7Pw4ACyPlVCyUgY=;
        b=npTGsmBLfdL8GH48YC7qXYiyjigAgRplXoJGIP1teUOeQn+XNUCV3V8EStb8mbASy+
         PSqTxPnJwLyGLBZZVw2ETd7SpvQi3jLo8kVn78YxXEaAfy/8H/njNxK+BrO7ms1v1/vS
         G00YKMILlZFZdSfky/ecUWpEyBWr27eGakFflJkXjt1Kb/E6G08YxQU3aNYKUg58GqvC
         Km9WP6+iSEd5NTnuExdfwbqdzwRDlIozwOEDcg+8RtRsjeOEa7Y0kZHj7I3FFa+4xYdh
         y80gm52CTsLqJtHv/gnLQ6/kXa3n5sh/i10xPxQuFBtNwKgUn9kJh2U7DmLkoczNYURv
         vkYw==
X-Gm-Message-State: AOAM530mLjYmIP25wn4+YEARoIeRrUTBPCCqSc1/2YQX5Y8/W9KJB+h2
        5abRFbkuovuMdVSU8w5gHkTGvTFzuTZjebkWkPumvA==
X-Google-Smtp-Source: ABdhPJyjGp6M1Ccx/0P616YGwvLUxrAlDyzng4BCHiM33P2X481G4H2BSk3AI94JS7I+h/glGqhDeO+lcPn9qc4fr5c=
X-Received: by 2002:a05:6e02:1a8d:: with SMTP id k13mr3708510ilv.31.1620163015905;
 Tue, 04 May 2021 14:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210429104707.203055-1-pbonzini@redhat.com> <20210429104707.203055-3-pbonzini@redhat.com>
 <YIxkTZsblAzUzsf7@google.com> <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
 <YJF/3d+VBfJKqXV4@google.com> <f7300393-6527-005f-d824-eed5f7f2f8a8@redhat.com>
 <YJGvrYWLQwiRSNLt@google.com> <55db8e64-763b-9ecc-9c9a-6d840628e763@redhat.com>
In-Reply-To: <55db8e64-763b-9ecc-9c9a-6d840628e763@redhat.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 4 May 2021 14:16:20 -0700
Message-ID: <CABayD+eAJjVjoh9GAnvC9z64pL9GnpHomCqXtw_=EPDr=vz7hA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 1:56 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/05/21 22:33, Sean Christopherson wrote:
> > On Tue, May 04, 2021, Paolo Bonzini wrote:
> >> On 04/05/21 19:09, Sean Christopherson wrote:
> >>> On Sat, May 01, 2021, Paolo Bonzini wrote:
> >>>> - make it completely independent from migration, i.e. it's just a facet of
> >>>> MSR_KVM_PAGE_ENC_STATUS saying whether the bitmap is up-to-date.  It would
> >>>> use CPUID bit as the encryption status bitmap and have no code at all in KVM
> >>>> (userspace needs to set up the filter and implement everything).
> >>>
> >>> If the bit is purely a "page encryption status is up-to-date", what about
> >>> overloading KVM_HC_PAGE_ENC_STATUS to handle that status update as well?   That
> >>> would eliminate my biggest complaint about having what is effectively a single
> >>> paravirt feature split into two separate, but intertwined chunks of ABI.
> >>
> >> It's true that they are intertwined, but I dislike not having a way to read
> >> the current state.
> >
> >  From the guest?
>
> Yes, host userspace obviously doesn't need one since it's implemented
> through an MSR filter.  It may not be really necessary to read it, but
> it's a bit jarring compared to how the rest of the PV APIs uses MSRs.
>
> Also from a debugging/crashdump point of view the VMM may have an
> established way to read an MSR from a vCPU, but it won't work if you
> come up with a new way to set the state.

Agreed on the preference for an MSR. I particularly appreciate that it
reduces the kernel footprint for these changes.


Steve

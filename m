Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F03A214E7C
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 20:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgGESXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 14:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgGESXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jul 2020 14:23:19 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0329C08C5DE
        for <kvm@vger.kernel.org>; Sun,  5 Jul 2020 11:23:18 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id o5so37031902iow.8
        for <kvm@vger.kernel.org>; Sun, 05 Jul 2020 11:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HMEHe+br8dXcHI+hB4O6nEY5v7Sg6St98G6CWcHOLAY=;
        b=p5/pIAXf3CKYBu7XQ+eET85u6p43lVcZZCEJzOCn6xIig95QPwz/9I/2x+weOJLgxn
         Cie31azzWN79bqQqUdusC9nA9+hbL9kvsl1MJwazGnkcJn1kiG3l6fQ1dV2Ib6ejFaTp
         WjCjV1l5Ehh2ZrunNBhIrGkQMyglDkpgtqJ2U/MIXQ8luL+uaTBJn1aWJKcwAkBhMVAX
         P2IY3nJQcZI7yfOYlFzUvVdgsBKEMcyevYLUwC1XYkeeD6Sw4vzLu0lMNHRQSsnMpPsK
         1dNu8PjzqnGWr0G9s2y6gBF3/WNe3mf2YHQmY+3ZgezLAq1YbzpBMbbRVlAbJ+hGGI6R
         U4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HMEHe+br8dXcHI+hB4O6nEY5v7Sg6St98G6CWcHOLAY=;
        b=Nh1+XN+vbUJlQPIYnYuMVKlAwqau1q7Qw4GhRJAy+SWwXSfUuD96EiTjYQr6ESFHeU
         e65OFmfJN09KD8aPXVxj3czt+mtKWvzzGlEgcF5VIkOeptZNnaJezNtZ1BZMD0yTHIR4
         C5qAMAYQfZ6JSkmHfO4Xv9JyC6k0X3jokAVTb4sb0EeHPVxI7F++cObd1NS9zKEfy6yN
         Lcrpcy54scaLJmdjkFlsTd4Wu5PEQdzbn+dtt+wA0xuUomcwUqGSuoJkAgHWzRvW+Q/N
         C7/0+IfoRu+HXO5B8iHTIqvQ5HXI+l5YUK5dFXedZERdT97e7rm2weuPJlPr4hNLNSYm
         uPnA==
X-Gm-Message-State: AOAM531dQAVrXSfpybuWYnrMexAEmAcs7M5we1wsx50nzr9ynPOjNnlm
        G8VwSz5P1uUSodKE4nYcZM9n8QIEdE/tZoMkGRh8wg==
X-Google-Smtp-Source: ABdhPJyBOWuLUXOzG6o2lDDAnLH070zEuFx/Po3XVCpmBC/ky8dEjid7/3THBJAz32DNG7JWCQm++YJmtgD+wfcVmls=
X-Received: by 2002:a5e:cb42:: with SMTP id h2mr21634185iok.43.1593973397858;
 Sun, 05 Jul 2020 11:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200702221237.2517080-1-abhishekbh@google.com>
 <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com> <CAN_oZf2t+gUqXe19Yo1mTzAgk2xNhssE-9p58EvH-gw5jpuvzA@mail.gmail.com>
 <CA+noqoj6u9n_KKohZw+QCpD-Qj0EgoCXaPEsryD7ABZ7QpqQfg@mail.gmail.com>
 <20200703114037.GD2999146@linux.ibm.com> <CAD=FV=XRbrFqSbR619h+9HXNyrYNbqfBF2e-+iUZco9qQ8Wokg@mail.gmail.com>
 <20200705152304.GE2999146@linux.ibm.com> <5d2ccf3d-b473-cf30-b863-e29bb33b7284@redhat.com>
In-Reply-To: <5d2ccf3d-b473-cf30-b863-e29bb33b7284@redhat.com>
From:   Abhishek Bhardwaj <abhishekbh@google.com>
Date:   Sun, 5 Jul 2020 11:22:42 -0700
Message-ID: <CA+noqojih03kKsWs33EUMV4H6RkWSRSQD=DHa9pAQ03yiz2GtQ@mail.gmail.com>
Subject: Re: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Waiman Long <longman@redhat.com>
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        Doug Anderson <dianders@google.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 5, 2020 at 8:57 AM Waiman Long <longman@redhat.com> wrote:
>
> On 7/5/20 11:23 AM, Mike Rapoport wrote:
> >> Nothing prevents people from continuing to use the command line
> >> options if they want, right?  This just allows a different default.
> >> So if a distro is security focused and decided that it wanted a slower
> >> / more secure default then it could ship that way but individual users
> >> could still override, right?
> > Well, nothing prevents you from continuing to use the command line as
> > well;-)
> >
> > I can see why whould you want an ability to select compile time default
> > for an option, but I'm really not thrilled by the added ifdefery.
> >
>
> It turns out that CONFIG_KVM_VMENTRY_L1D_FLUSH values match the enum
> vmx_l1d_flush_state values. So one way to reduce the ifdefery is to do,
> for example,
>
> +#ifdef CONFIG_KVM_VMENTRY_L1D_FLUSH
> +#define VMENTER_L1D_FLUSH_DEFAULT CONFIG_KVM_VMENTRY_L1D_FLUSH
> +#else
> +#define VMENTER_L1D_FLUSH_DEFAULT      VMENTER_L1D_FLUSH_AUTO
> #endif
> -enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
> +enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_DEFAULT;
>
> Of course, we may need to add a comment on enum vmx_l1d_flush_state
> definition to highlight the dependency of CONFIG_KVM_VMENTRY_L1D_FLUSH
> on it to avoid future mismatch.

I explicitly wanted to avoid doing that for this very reason. In my
opinion this is brittle and bound to be missed
sooner or later.

I'd rather have the value assignment be explicit rather than some
clever hack. Notice, this wouldn't work if the enum
values were not contiguous. We just got lucky.

Do people feel strongly against this ifdef ladder ?

>
> Cheers,
> Longman
>



--
Abhishek

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A501C2190AE
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgGHTdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgGHTdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:33:05 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7647EC08C5C1
        for <kvm@vger.kernel.org>; Wed,  8 Jul 2020 12:33:05 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so34615375iob.4
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=slImY14f0rNlEWIkm1VGpH6ry5mubIzN1YXFRSQUYYw=;
        b=EIzmcXfUjvt2TpgoLMvmOT/1wauSIofM4ahX4qssit2mGp/aZJvZpH0CRIzLFtLSzj
         6kOGwZNSPgSre7jg2e413VgkxMXoVHdCL2ISAnaA7VDlGOgsOXE67V7PkS+g2IrVAPpM
         4RDM2PSqPHKBq7sucj1es79e+9iuSaSUercAkwFBm+PTQ/TWXGBAfqkJWSkC7i5fA8EX
         pdC8XtamtPprKBVLrjxBiPVyfIKH9tNEPD1PeHISshRyle6SIZnT9Aa8V131VZ5g48zs
         59t53fKWZnIRKv8irTmRNGVXDECNokzdTN08hCWuJgj9+wO5jjZcv85b8NjobvZWHKce
         xrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=slImY14f0rNlEWIkm1VGpH6ry5mubIzN1YXFRSQUYYw=;
        b=dxB5NUcpRf4jQfCZoj3+y3zi78f9zzci7HMV0ynTg7pM6vyPA6j1yghNwRp16STxZV
         yMhA4A/kzM0w2yD0Kf75BygLikoDym/zGm6/NT6v8NeX2XOCF7Kc33wuvuYAITbMcmZW
         3rGAEJvX+9Cz5385Cpzx3QaJpZMvWb1SU2m4jyzlBCwGGgy0zIg5+O6ZgmO3a/je3u9G
         WvMKthFzssx/Y0otx2FkDJEuckuGctVQWJZxAMHRtUL7tnAjAuQI27oKPZtoro13m3Ru
         l0zjtoyWvRp+2fJVfVnlbdJpp0i5aM2gGsKZ1K4opLJkThrjNhpivIFm6VVeyaV1kkll
         yVzg==
X-Gm-Message-State: AOAM532JcFfLupy2qxVvC1cxLFzHq4gOWs8S5gnhLi1gvmuCf9C+XS1F
        uSgqf4ZgXj8CRA4BXvpD9TzfW03j5tHmJ26tBEfeCQ==
X-Google-Smtp-Source: ABdhPJzDCnsVGm3VcsqdzLHzVCHdu3/UfHN/Is45+S8jIg9IrJQNXCoiom79Lh+8ZiI4+GAHi9UzpqcSFOyp8/SmOGg=
X-Received: by 2002:a5e:cb42:: with SMTP id h2mr37795277iok.43.1594236784442;
 Wed, 08 Jul 2020 12:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200702221237.2517080-1-abhishekbh@google.com>
 <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com> <CAN_oZf2t+gUqXe19Yo1mTzAgk2xNhssE-9p58EvH-gw5jpuvzA@mail.gmail.com>
 <CA+noqoj6u9n_KKohZw+QCpD-Qj0EgoCXaPEsryD7ABZ7QpqQfg@mail.gmail.com>
 <20200703114037.GD2999146@linux.ibm.com> <CAD=FV=XRbrFqSbR619h+9HXNyrYNbqfBF2e-+iUZco9qQ8Wokg@mail.gmail.com>
 <20200705152304.GE2999146@linux.ibm.com> <5d2ccf3d-b473-cf30-b863-e29bb33b7284@redhat.com>
 <CA+noqojih03kKsWs33EUMV4H6RkWSRSQD=DHa9pAQ03yiz2GtQ@mail.gmail.com>
 <48f82669-f1ff-0f5e-e531-ebbd151205f9@redhat.com> <CA+noqoj70jThJ-N9DhWi8wnCLueJNfYKEU72HaMjSsMhJQEzJA@mail.gmail.com>
 <f8e84764-1cc7-c4e5-4e4f-4b907204a374@redhat.com>
In-Reply-To: <f8e84764-1cc7-c4e5-4e4f-4b907204a374@redhat.com>
From:   Abhishek Bhardwaj <abhishekbh@google.com>
Date:   Wed, 8 Jul 2020 12:32:27 -0700
Message-ID: <CA+noqoh90h3Mtk_3++bnMGMYyEGmUUq09R1k2WzCUbKX1jgQXQ@mail.gmail.com>
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

On Mon, Jul 6, 2020 at 8:14 AM Waiman Long <longman@redhat.com> wrote:
>
> On 7/5/20 5:51 PM, Abhishek Bhardwaj wrote:
>
> That is why I said a comment will have to be added to highlight this
> dependency. For instance,
>
> +/*
> + * Three of the enums are explicitly assigned as the KVM_VMENTRY_L1D_FLUSH
> + * config entry in arch/x86/kvm/Kconfig depends on these values.
> + */
>   enum vmx_l1d_flush_state {
>          VMENTER_L1D_FLUSH_AUTO,
> -       VMENTER_L1D_FLUSH_NEVER,
> -       VMENTER_L1D_FLUSH_COND,
> -       VMENTER_L1D_FLUSH_ALWAYS,
> +       VMENTER_L1D_FLUSH_NEVER = 1,
> +       VMENTER_L1D_FLUSH_COND = 2,
> +       VMENTER_L1D_FLUSH_ALWAYS = 3,
>          VMENTER_L1D_FLUSH_EPT_DISABLED,
>          VMENTER_L1D_FLUSH_NOT_REQUIRED,
>   };
>
> Of course, this is just a suggestion.
>
> I'd rather avoid this dependency. However, if people are okay with the
> CONFIG option then I am happy to oblige with whatever people agree on.
> Can a maintainer chime in ? Waiman if you're the final authority on
> this, will you accept the patch if I incorporated your suggestion ?
>
> It is fine if you think this is not what you want.
>
> BTW, I am not a maintainer. However, no maintainer will give pre-approval. At least, you have to give the reason why this patch is needed in the patch itself. Before that happens, I don't see how it will get merged upstream.

I just updated the patch with the reasoning in the commit message -
https://lkml.org/lkml/2020/7/8/1325


>
> Cheers,
> Longman



-- 
Abhishek

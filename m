Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65445383C03
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 20:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbhEQSQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 14:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbhEQSQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 14:16:36 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA15C061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:15:19 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so6404973oto.0
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NsGr4mQGD2hjDVdRYUkjKAO890pGgLZTF6RGBYaeOA0=;
        b=VJ7RSqvQgDgYhQxXP4qtehv91Fl7mVi7hp3Yd1uGO1XsIDC8/vgE28mMLpq4MUSQFO
         Y/qMv00VsAx1d16W3GjxMLhWR9EWeZwd974xma/LV19e/7+0pd2xNMrl/GMB389OlNU9
         eJySKBA1kR/z1EG/qS7wRfcNgFPKSFVD1ifGje/P6fDbud9dlxwVvCGH5gzbmfWMUfAk
         moIjILaG/qheIKOkY8CBLGBp1Lz/lRDo1m/obYxij44KvHJjHgCQ8Mda3BUwjTt9h22G
         gSU0Zj76BYXkyflnGbtYYr7hfFi7xDwyUSPtYpjTD4Rlnn0v4IAm5nyn6IV9oAlCaBA/
         8UKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NsGr4mQGD2hjDVdRYUkjKAO890pGgLZTF6RGBYaeOA0=;
        b=XBO9XjE3N5T8D3a9GbmcaEM7izKygG3Ie93cv0PMSVDTc0mrkkPaDyUWeSYQQOGB69
         Aen9fcIRQRdirQoOyYF/vvytQ/Q8bzeRDrQ1Cjs0+MWLfqLW2HK15chSAq2cJbwk+zQp
         7xJGiORwoS3Q5LHt4mp8dOidU9/pdegC/nLisl9YOsQgkRqB2NkbJBcGecjpWZcLJ9mp
         xcUJslt90X6iyoVQYyHr1e6HWjbUJRA+OAuovAAGSvul+WfoTacLaqNHcwNZNDvLzalX
         xjrYoPwMMP3YT8MpWb8e0QAKxd+PNuvxaI8ErXlTlBZ6YOgCLNmvwJXxMbtV98RR9vbb
         Q0tw==
X-Gm-Message-State: AOAM532KfKPKnHe2MZIwWmTQp3zb3cgO1pL+SNRYVWtFsUMDbW8P035/
        Hcb7j6LlPiiaBqrjgwaUqelJ8RDa2E1hnKcchfw7dw==
X-Google-Smtp-Source: ABdhPJxqCMtx8p/vitR8eon8ANCmD2XK5xnWe0vfbPgKoIExMnBu0MXy3EEVgVrtRjyrQdc5r5C7vIiTSN55N1Sp0jw=
X-Received: by 2002:a9d:131:: with SMTP id 46mr699009otu.241.1621275319019;
 Mon, 17 May 2021 11:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210507164456.1033-1-jon@nutanix.com> <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
 <5e01d18b-123c-b91f-c7b4-7ec583dd1ec6@redhat.com> <YKKqQZH7bX+7PDjX@google.com>
 <4e6f7056-6b66-46b9-9eac-922ae1c7b526@www.fastmail.com> <342a8ba9-037e-b841-f9b1-cb62e46c0db8@intel.com>
 <YKKwSLnkzc77HcnG@google.com>
In-Reply-To: <YKKwSLnkzc77HcnG@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 17 May 2021 11:15:07 -0700
Message-ID: <CALMp9eS80a+Oy6spKT3cG7DCTW6jVwhyBuZ_t0SND=80Lg1XWA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under kvm_load_host_xsave_state
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 11:05 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 17, 2021, Dave Hansen wrote:
> > On 5/17/21 10:49 AM, Andy Lutomirski wrote:
> > >> The least awful solution would be to have the NMI handler restore
> > >> the host's PKRU.  The NMI handler would need to save/restore the
> > >> register, a la CR2, but the whole thing could be optimized to run
> > >> if and only if the NMI lands in the window where the guest's PKRU
> > >> is loaded.
> > >
> > > Or set a flag causing nmi_uaccess_ok() to return false.
> >
> > Oh, that doesn't sound too bad.  The VMENTER/EXIT paths are also
> > essentially a context switch.
>
> I like that idea, too.
>
> The flag might also be useful to fix the issue where the NMI handler activates
> PEBS after KVM disables it.  Jim?

The issue is actually that the NMI handler *clears* IA32_PEBS_ENABLE
bits after giving out the host value of the MSR to KVM. If we were to
block the NMI handler from modifying IA32_PEBS_ENABLE until after the
next VM-exit, that could solve this issue. I don't know if it makes
sense to piggyback on nmi_uaccess(), though.

> > Will widening the window where nmi_uaccess_okay()==false anger any of
> > the perf folks?  It looks like perf knows how to handle it nicely.

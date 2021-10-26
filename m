Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E83F43AC47
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 08:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhJZG32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 02:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJZG31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 02:29:27 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C02C061745
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 23:27:03 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id k13so1049559ljj.12
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 23:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hQaOAxX7BvTpJD5atNWBkDW/jFvHgvU+9LT0US+JHAk=;
        b=GJ3PC2KSkStOMDOvjR32eW/9dEOqrF88C16zgnHylO/ln1X1i1s8ABcFP4ADANfQ06
         xVzqAD00ObbjX/JXOYn154Lma9v+Ce8c2zAsJrxjIIQmc+1hvnJttX9jUI6LqReTv8ib
         t0fjtjmSjsFtQqbZqcmskq4BI3Ng+bJntMPaebJZ563N/oVIYACFbfUuqtGDSJnREwDM
         5na+AHpMZVuqXILWbWXTtmORSqG38tokPtwG9iry+RB3laRrWKrU1460n6kyG8Xq62+M
         Jhs1Z6FJW6k3/jbGwg2X8N2Djlyc8QWMkW2dMpngk+H4eNH/booV/CKpn29grsXXidt/
         rfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hQaOAxX7BvTpJD5atNWBkDW/jFvHgvU+9LT0US+JHAk=;
        b=shPZmIoFR/9B0D15UvUa1ZXF480+XVoFhU0V7ZZcmD+OH41Fp/1zrw9OWQQy2x8+0h
         ZmH3lY9r97R2oMZyRHdKoyRyH+unCyYvNPyGu/yOOcYjTGbtBb94aylSDMNDmgqn1sma
         W5lYuwYTIF3azLrmEws64fhvr+rHgtmAKFHb8Kn6LGfz82nhHrH8tUH8KyQ3z2PANsT7
         GdOh0GgXaXUsVArfKzNmIzmaPz/Xz9Io35OqZJE5TP9nTuSPNWvg+NGeXtAH0PFijOTc
         1BdSXh4Q0ASJZPfHESDdfvoE64fvuvyH/V4229ojPz6p0LDGh2ysNsDarJ8NwO5kz79y
         B6HQ==
X-Gm-Message-State: AOAM5310UVRjx0qy2WYx3KaxP8lYdK03bEjCKrG4cSeNOfrGmuxOMBdj
        1GJqDcH5i5/baBHcDhgbJ++UDFIxXQ4hDXjwqMe/TWknoHGccw==
X-Google-Smtp-Source: ABdhPJwPi5y51llC0/yrXXGjrriUXs6G6JzKWLqf8YiZEjnKzG0gu60tX+vsQ0Mo6P5zMW6fpy8NztmOXjUb8Lkh10U=
X-Received: by 2002:a2e:a5c8:: with SMTP id n8mr23829633ljp.307.1635229622080;
 Mon, 25 Oct 2021 23:27:02 -0700 (PDT)
MIME-Version: 1.0
References: <20211004204931.1537823-1-zxwang42@gmail.com> <20211004204931.1537823-12-zxwang42@gmail.com>
 <7179dbe7-b5bb-7336-bda7-6207979bc52b@redhat.com>
In-Reply-To: <7179dbe7-b5bb-7336-bda7-6207979bc52b@redhat.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 25 Oct 2021 23:26:00 -0700
Message-ID: <CAEDJ5ZQfwDmTburh6sBQH96KG5EYoip092rW8SkJUxFbgFkhZA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/17] x86 UEFI: Convert x86 test cases
 to PIC
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 7:12 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/10/21 22:49, Zixuan Wang wrote:
> > From: Zixuan Wang <zixuanwang@google.com>
> >
> > UEFI loads EFI applications to dynamic runtime addresses, so it requires
> > all applications to be compiled as PIC (position independent code). PIC
> > does not allow the usage of compile time absolute address.
> >
> > This commit converts multiple x86 test cases to PIC so they can compile
> > and run in UEFI:
> >
> > - x86/cet.efi
> >
> > - x86/emulator.c: x86/emulator.c depends on lib/x86/usermode.c. But
> > usermode.c contains non-PIC inline assembly code. This commit converts
> > lib/x86/usermode.c and x86/emulator.c to PIC, so x86/emulator.c can
> > compile and run in UEFI.
> >
> > - x86/vmware_backdoors.c: it depends on lib/x86/usermode.c and now works
> > without modifications
> >
> > - x86/eventinj.c
> >
> > - x86/smap.c
> >
> > - x86/access.c
> >
> > - x86/umip.c
> >
> > Signed-off-by: Zixuan Wang <zixuanwang@google.com>
>
> I have left this patch out for now, because it breaks 32-bit builds.
> It's not a huge deal and can be redone on top of the rest.
>
> Paolo
>

Marc and I are working on a follow-up patch set that includes the
fixes for this patch under 32-bit mode. I have also identified a
potential bug in x86/umip.c and fixed it in the next patch set. The
full debugging detail is described in our off-list GitHub discussion
[1].

In summary, in the following line, %[sp0] can be compiled as a
%r8-based offset address:

x86/umip.c:127
"mov %%" R "sp, %[sp0]\n\t" /* kernel sp for exception handlers */

%r8 is then modified in the function call without saving/restoring,
thus making the following line using the wrong address.

x86/umip.c:148
"mov %[sp0], %%" R "sp\n\t"

This register is selected by the compiler, it's not guaranteed to be
%r8 so we cannot just push/pop %r8 before/after the function call. A
simple fix is to save the %rsp to %rbx (in addition to saving it to
%[sp0]). %rbx is a callee-saved register, so its value is not
modified.

We already have this fix in the patch set draft [1] and will post it once ready.

[1] https://github.com/marc-orr/KVM-Unit-Tests-dev-fork/pull/9

Best regards,
Zixuan

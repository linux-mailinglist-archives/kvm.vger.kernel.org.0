Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC10E10764D
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 18:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVRSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 12:18:30 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42782 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 12:18:30 -0500
Received: by mail-io1-f68.google.com with SMTP id k13so8852523ioa.9
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 09:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8FwEq5/p32a1eY3isWRrwz0NOl7g5eBH/DEgCOZNq0=;
        b=TsdtXkPhnVRqTlZ0bTiedQHTxqBTrFiBuPfGICaLLceRbaJi/U0hhDX5++62v/pj0w
         PSJbqeZNLGvdwEX2I7/93IkZP1tWVrnS52R/TPzRh3/llJ3Oqm0P5Bdj4Bn7V3zcQepr
         +q1vSjCYzw8nTLaKFMgX0Odjm4lUSddPfcz0ugr54QWTev86Y33l1kMgdDxR7nHgNqCS
         Q3rRbllrfXKf+zb4FPYwlk8SA6X2maB/DLqhmWqodG+xWPG23smszkzby8Tv/q77Y9Rw
         v+eJ4u7DMKFnVxon/4QHSkDEmBZraPTpxDELkNSPJi9PF4++kioVWj4hOL4Lk42jFixq
         dN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8FwEq5/p32a1eY3isWRrwz0NOl7g5eBH/DEgCOZNq0=;
        b=IitSdXdagg+eHAJDgtJzqY6fUdqTzaOtxPzZcz74b0IWE7BBn9f70OUnBkaYVPg+PC
         FJP2SjVJcvGp+xgKXe5z/er9XRN87ztClfms6iA6f9R+isq9lwanLw+xGxXX1pEIsi74
         fxM7ZMetvrgFvAqt6ejFKddNYCn0MPsVSVfQsLDJosjRVeN2aYPkCheuSUtQdjB/LXQ7
         F7xKCYB8beV3lZTSQt7ZK9pberRccPP1eGegiJ/THAsR9irWXQJctrsPA01tkqoK4DTJ
         M1CKoDQp0YvCRmd1jLQxrSo7dMf8HP9kBiPbTCKLuXMXzmi3C95gIlkbk2zHrcTSZXPE
         U9ug==
X-Gm-Message-State: APjAAAUC7QNl76jX9AqHNz17noi+0tBqdScJVexqXolPQ8BaDDWIwVfo
        PMgw8mkwXDCfiQHrfJzXomADL5vmAm6U3ljiXro2Zw==
X-Google-Smtp-Source: APXvYqyROlENwv1nj2jwYjvNqrdmbHrOhBkcZHVpPhDK5Gq6jk2IF9hA68o6068LM2aVj5tqSU/mAnYosFlWEZpNkvM=
X-Received: by 2002:a5d:9b08:: with SMTP id y8mr14653675ion.108.1574443108920;
 Fri, 22 Nov 2019 09:18:28 -0800 (PST)
MIME-Version: 1.0
References: <20191121203344.156835-1-pgonda@google.com> <20191121203344.156835-3-pgonda@google.com>
 <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com>
In-Reply-To: <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Nov 2019 09:18:17 -0800
Message-ID: <CALMp9eRVNDvy65AFDz=KjUT0M0rCtgCECuMS0nUZqAhy2S=MsA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Does SEV-ES indicate that SEV-ES guests are supported, or that the
current (v)CPU is running with SEV-ES enabled, or both?

On Fri, Nov 22, 2019 at 5:01 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 11/21/19 2:33 PM, Peter Gonda wrote:
> > Only pass through guest relevant CPUID information: Cbit location and
> > SEV bit. The kernel does not support nested SEV guests so the other data
> > in this CPUID leaf is unneeded by the guest.
> >
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 946fa9cb9dd6..6439fb1dbe76 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> >               break;
> >       /* Support memory encryption cpuid if host supports it */
> >       case 0x8000001F:
> > -             if (!boot_cpu_has(X86_FEATURE_SEV))
> > +             if (boot_cpu_has(X86_FEATURE_SEV)) {
> > +                     /* Expose only SEV bit and CBit location */
> > +                     entry->eax &= F(SEV);
>
>
> I know SEV-ES patches are not accepted yet, but can I ask to pass the
> SEV-ES bit in eax?
>
>
> > +                     entry->ebx &= GENMASK(5, 0);
> > +                     entry->edx = entry->ecx = 0;
> > +             } else {
> >                       entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> > +             }
> >               break;
> >       /*Add support for Centaur's CPUID instruction*/
> >       case 0xC0000000:

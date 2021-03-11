Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B222A337F9A
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 22:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhCKVYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 16:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhCKVYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 16:24:00 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32852C061574
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 13:24:00 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso340899otq.3
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 13:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKbLUfcRPlMmivv7LqZuqcBPXaLhbBwd6AOGXhYBN7w=;
        b=hfsDyraBk0D2ZtYQmKosU65268PIWr7x2FoDvEbfOX4Bab6xVuABTf651MQpXLqg9U
         D1Djf92keOAk3HkRfyMT+531R8ta92FcDuthE+VDbbwmh5cq7rqA7SoYqarLOiVSvZLx
         WLPaMcUOqLiyalAFQmragGmt72GZAOL2UvOkD97mlKYEw0Y/+SRGJ7hIrZYc7kMEUwGA
         DZ9TiAxuaDx0Hxb9BD4bN8yXRJMJL7Jo510fFf92U0Ehi4z4xjLB7xdetmmCCiKbLZNh
         nCOZuVGj6Bf/CfQFOENcFuXv/2xiDuGvhmxBdZXNQocITGDFv34caMFM0lG9QlJ7TsTb
         +eCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKbLUfcRPlMmivv7LqZuqcBPXaLhbBwd6AOGXhYBN7w=;
        b=dCN77nuk2MbaRYlgiqo4JexZAZ20XNpXYtloTaTVqrRNDnMR1pikyAB8cF4Gjb/SYc
         Zs8Bfl4ytj6r5Ehxg4PDfKsRITg/PozlU7ZOnfhnxSCSTlNcFcY/8UvS1omKFWry9e7u
         KvSjjNZhjsJOVKahIa+DY0qPt2FD/wWqV/nYw4X7wRmEr9qaSGLotvQITq/WAZlAjKpa
         pxguknnvKDjd9s0Epi3QPRKslHL7XzN3eraEDYlh16fb8OldQTLoiUVtnvgSchibCAeN
         Xp8ShUeU8h+2sNRTuExku5afgZGNBvtNfRTMzoZU6/wbwJZCZKhFAB9fwIEFXoz5c5E8
         qDeg==
X-Gm-Message-State: AOAM531t45SHG/B6OKW0Cz6ESIVhu/RtdWDqDunbXMj54xkMewyPfbx6
        kUiho0yd8yKOBMKHN1VsL6UpwyxAi8l+Q+XCrG/KLg==
X-Google-Smtp-Source: ABdhPJyIpqYQ3Fu+fDIsygrqCEN8CkrhNyvgLeNGfFRz5squWHECRMcDifRvmc770Xh31/K7HQ8lC8HZ7gBLe38B8KE=
X-Received: by 2002:a05:6830:4d:: with SMTP id d13mr709579otp.295.1615497839332;
 Thu, 11 Mar 2021 13:23:59 -0800 (PST)
MIME-Version: 1.0
References: <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com> <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
 <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com> <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com> <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com> <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com> <20210311200755.GE5829@zn.tnic>
 <20210311203206.GF5829@zn.tnic>
In-Reply-To: <20210311203206.GF5829@zn.tnic>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 11 Mar 2021 13:23:47 -0800
Message-ID: <CALMp9eQC5V_FQWGLUjc3pMziPeO0it_Mcm=L3bYcTMSEuFdGrA@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 12:32 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Mar 11, 2021 at 09:07:55PM +0100, Borislav Petkov wrote:
> > On Wed, Mar 10, 2021 at 07:21:23PM -0600, Babu Moger wrote:
> > > # git bisect good
> > > 59094faf3f618b2d2b2a45acb916437d611cede6 is the first bad commit
> > > commit 59094faf3f618b2d2b2a45acb916437d611cede6
> > > Author: Borislav Petkov <bp@suse.de>
> > > Date:   Mon Dec 25 13:57:16 2017 +0100
> > >
> > >     x86/kaiser: Move feature detection up
> >
> > What is the reproducer?
> >
> > Boot latest 4.9 stable kernel in a SEV guest? Can you send guest
> > .config?
> >
> > Upthread is talking about PCID, so I'm guessing host needs to be Zen3
> > with PCID. Anything else?
>
> That oops points to:
>
> [    1.237515] kernel BUG at /build/linux-dqnRSc/linux-4.9.228/arch/x86/kernel/alternative.c:709!
>
> which is:
>
>         local_flush_tlb();
>         sync_core();
>         /* Could also do a CLFLUSH here to speed up CPU recovery; but
>            that causes hangs on some VIA CPUs. */
>         for (i = 0; i < len; i++)
>                 BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);       <---
>         local_irq_restore(flags);
>         return addr;
>
> in text_poke() which basically says that the patching verification
> fails. And you have a local_flush_tlb() before that. And with PCID maybe
> it is not flushing properly or whatnot.
>
> And deep down in the TLB flushing code, it does:
>
>         if (kaiser_enabled)
>                 kaiser_flush_tlb_on_return_to_user();
>
> and that uses PCID...

I would expect kaiser_enabled to be false (and PCIDs not to be used),
since AMD CPUs are not vulnerable to Meltdown.

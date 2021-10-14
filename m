Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E9F42E000
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 19:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhJNRZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 13:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbhJNRZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 13:25:39 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32149C061570
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 10:23:34 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso2119736ooq.8
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 10:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8lr7xp60Qc/2Z6cfSIlrK2r8D4YH1IU8NKqFQ+OfqZA=;
        b=AQglkdR1nF8pamfw3YijpS+lNnsg2ekOKFPB5pnljfQvDy2o4dFd7mhVHoNwTybRw8
         9yk9cJwDKjUD3RN52Ym2pKoSp0Vbb3ZjqTSN79wDnvPiIJjWPItZkOf0VdTB8B20YhBp
         rhVxg5R3diC6S2+tGRM1O9yfjH2xkbVM8ysIe8bLBfXTzFHZi8Ti/5b9eTvX71Tcjsqt
         wh/ElYJZTbIPFpGMFp5gwYdW7u+ER9aHhiFTTyl80sOYAhN32bRAdXYkZrKViJAesMqf
         FC7KLhn2xbZmZumXNT+sUpER8vkawIsHowdvKnP5uNYPEwpYso290YDD/81DnQvvepcP
         IoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8lr7xp60Qc/2Z6cfSIlrK2r8D4YH1IU8NKqFQ+OfqZA=;
        b=p54MBIyXBbtc5B0kI5YS9fAJWqDOJgiJHhG6yhZGkvoPAVTmEU2HTFgHPCqcru2G4O
         SJ51jxsBD32OE3kKYbJ3bS3ToZOh02W1l3SONFmbhOTcla9gQqhn6XgJZHvZUUSlBLyS
         +jYenTFq8pPTqGfl4olnntpMQ5IpbDhmbYFV2VSI7EqtshMgvC6xwf4/fXHIAnwCqsTz
         G9gnVl2ycXLM7gbL5RfvVs7mphSTdxWkhX9vvNlm8QEdBLG310yKR+ZntMj1QZBrSUa2
         uoyYPGKATXXB0++SqmLd16RHJNJh9QmfK307kzDyuWrIxw1W4dXkYZCssfQE9giNnNVP
         +sgQ==
X-Gm-Message-State: AOAM531GuqbLwWvnHsRRUq4sc5aXOyuiZPYBxHMBr65UOzWXxIVfy5p4
        sqjt9IEwCEvI09rIShnDI1onwwc3AgpsFAdXHik=
X-Google-Smtp-Source: ABdhPJzxm0dnux5o6M4X/GI6OkRIxopL0jvAZ4ISzXYGKTN604lNYAtIbO+SbJD+tMQ8lu6Y0ZV1MZwTGzqwe2Ht9LA=
X-Received: by 2002:a4a:d5c8:: with SMTP id a8mr4730917oot.18.1634232213463;
 Thu, 14 Oct 2021 10:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <1631894159-10146-1-git-send-email-ajaygargnsit@gmail.com> <YWcswAD9dmYun+sI@google.com>
In-Reply-To: <YWcswAD9dmYun+sI@google.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Thu, 14 Oct 2021 22:53:21 +0530
Message-ID: <CAHP4M8XwS-4W6gWga5C=AgipJntR3X944kJ3v4CXkZ+BTTUZbg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: (64-bit x86_64 machine) : fix
 -frame-larger-than warnings/errors.
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks for your time.

I have cloned the kernel many times since the time the patch was
posted, and have not seen the issue again.

One thing I distinctly remember that when the build was breaking, it
was with staging-drivers disabled. Since then, I have disabled the
staging-drivers. Today, I again enabled staging-drivers, and build
went fine.

So, I am ok with archiving this patch. We can revisit if someone else
reports this/similar issue.


Thanks and Regards,
Ajay


On Thu, Oct 14, 2021 at 12:30 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Sep 17, 2021, Ajay Garg wrote:
> > From: ajay <ajaygargnsit@gmail.com>
> >
> > Issue :
> > =======
> >
> > In "kvm_hv_flush_tlb" and "kvm_hv_send_ipi" methods, defining
> > "u64 sparse_banks[64]" inside the methods (on the stack), causes the
> > stack-segment-memory-allocation to go beyond 1024 bytes, thus raising the
> > warning/error which breaks the build.
> >
> > Fix :
> > =====
> >
> > Instead of defining "u64 sparse_banks [64]" inside the methods, we instead
> > define this array in the (only) client method "kvm_hv_hypercall", and then
> > pass the array (and its size) as additional arguments to the two methods.
>
> > Doing this, we do not exceed the 1024 bytes stack-segment-memory-allocation,
> > on any stack-segment of any method.
>
> This is a hack, and it's not guaranteed to work, e.g. if the compiler decided to
> inline the helpers, then presumably this problem would rear its head again.
>
> However, I don't think this is a problem any more.  gcc-10 and clang-11 are both
> comfortably under 1024, even if I force both helpers to be inlined.  Neither
> function has variables that would scale with NR_CPUS (and I verified high number
> of NR_CPUS for giggles).  Can you try reproducing the behavior on the latest
> kvm/queue?  I swear I've seen this in the past, but I couldn't find a commit that
> "fixed" any such warning.
>
> If it does repro, can you provide your .config and compiler version?  Maybe your
> compiler is doing somethign funky?
>
> > Signed-off-by: ajay <ajaygargnsit@gmail.com>
>
> The SoB needs your full name.
>
> > ---
> >  arch/x86/kvm/hyperv.c | 34 ++++++++++++++++++++++++----------
> >  1 file changed, 24 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 232a86a6faaf..5340be93daa4 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -1750,7 +1750,8 @@ struct kvm_hv_hcall {
> >       sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
> >  };
> >
> > -static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> > +static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc,
> > +                            bool ex, u64 *sparse_banks, u32 num_sparse_banks)
>
>
> >  {
> >       int i;
> >       gpa_t gpa;
> > @@ -1762,10 +1763,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
> >       DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
> >       unsigned long *vcpu_mask;
> >       u64 valid_bank_mask;
> > -     u64 sparse_banks[64];
> >       int sparse_banks_len;
> >       bool all_cpus;
> >
> > +        memset(sparse_banks, 0, sizeof(u64) * num_sparse_banks);
> > +
>
> FWIW, the array size needs to be validated, there is other code in this function
> that assumes it's at least 64 entries.

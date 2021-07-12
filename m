Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D7A3C5E6D
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 16:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhGLOjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 10:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbhGLOjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 10:39:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A3AC0613E5
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 07:36:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso110076pjp.2
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 07:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=odpZLNPMc7XYOJg4WAjgRzU40NqCOqtx42Rk0WM2s8Q=;
        b=ccZ563+VV+52OBsIFH3Aw7IcIzyEFxDuWoPL/0/Ik9RJfCbUb9xS2zP5h+vMjB5lGT
         UovueBCODylFLwLm2y/1KXaxxDlJ7rC713azl6HojRAE56wP85G1zm8m7WfkCGk4B5cD
         gKE1SRURXYSE6wGHqOU/iydAh2okH9ACEOPYJTLKCobp3p/GNIR+CorF4Pr3DaKkTO8P
         o42U5J73ZidVYKNSRerp2T5cwgCANolDgNT5C1Hhwu6AlVaancH/VeQZJkkSa0UytTnp
         Cj2ZNcBEBCbfuRKnK48fYKFvAGLaLm6wrsafx0cy5C7iyN5XNAOcFYpK6JyKOOMZ8FgF
         KPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=odpZLNPMc7XYOJg4WAjgRzU40NqCOqtx42Rk0WM2s8Q=;
        b=W2aQccdNH8l/Z2I5w6E1xdlJmB+nyg6k/dlIGVUSuhPQahamX40GbCMRxznhz9znsC
         h+FZKxKgVYgQLjo+uGxQNDfuG505luoUzUdwKbv/ZnMoMU4uf9B0rAribxhBKN4/kk3h
         6y68I/+erXlpPPHG/LjL0ToWTmzxIHlCP/v+1Ly2JudVpG7V7ntBMmPOEpcPiHtzkfvK
         Vugo39n5lMnpAozbq4+IFkclkAxdXQak4jdPsNmNB9v54te/Qy08qjJuDnQJABfqp3JH
         Tp80v7yTafMMruXjrccAVbHO1+ZvZ68U0PUoP8DP/F+RzUgJA1Wr7Hm1FDpUDJPLAf/c
         nNyw==
X-Gm-Message-State: AOAM531RNWmf2eQH/TIBrwKRyU28HMFWivZvPr2d66DFE+WSJj2/tsAJ
        zzu32CEtFFYDVst/xx+OLiT/Cg==
X-Google-Smtp-Source: ABdhPJwnHw0fPqz0rqhI99sLF99SJZNDiWLEHr3fi5BvinY9+07QGr9tGi3TR61W+NCXS3E6nyOp1w==
X-Received: by 2002:a17:90a:af90:: with SMTP id w16mr14567927pjq.129.1626100617660;
        Mon, 12 Jul 2021 07:36:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k9sm16054928pfu.100.2021.07.12.07.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 07:36:57 -0700 (PDT)
Date:   Mon, 12 Jul 2021 14:36:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled"
Message-ID: <YOxThZrKeyONVe4i@google.com>
References: <20210625001853.318148-1-seanjc@google.com>
 <28ec9d07-756b-f546-dad1-0af751167838@redhat.com>
 <YOiFsB9vZgMcpJZu@google.com>
 <20210712075223.hqqoi4yp4fkkhrt5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712075223.hqqoi4yp4fkkhrt5@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021, Yu Zhang wrote:
> On Fri, Jul 09, 2021 at 05:21:52PM +0000, Sean Christopherson wrote:
> > On Thu, Jul 08, 2021, Paolo Bonzini wrote:
> > > So do we want this or "depends on X86_64 || X86_PAE"?
> > 
> > Hmm, I'm leaning towards keeping !PAE support purely for testing the !PAE<->PAE
> > MMU transitions for nested virtualization.  It's not much coverage, and the !PAE
> 
> May I ask what "!PAE<->PAE MMU transition for nested virtualization" means?
> Running L1 KVM with !PAE and L0 in PAE? I had thought KVM can only function
> with PAE set(though I did not see any check of CR4 in kvm_arch_init()). Did
> I miss something?

When L1 uses shadow paging, L0 KVM's uses a single MMU instance for both L1 and
L2, and relies on the MMU role to differentiate between L1 and L2.  KVM requires
PAE for shadow paging, but does not require PAE in the host kernel.  So when L1
KVM uses shadow paging, it can effectively use !PAE paging for L1 and PAE paging
for L2.  L0 KVM needs to handle that the !PAE<->PAE transitions when switching
between L1 and L2, e.g. needs to correctly reinitialize the MMU context.

> > NPT horror is a much bigger testing gap (because KVM doesn't support it), but on
> > the other hand setting EFER.NX for !PAE kernels appears to be trivial, e.g.
> > 
> > diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> > index 67f590425d90..bfbea25a9fe8 100644
> > --- a/arch/x86/kernel/head_32.S
> > +++ b/arch/x86/kernel/head_32.S
> > @@ -214,12 +214,6 @@ SYM_FUNC_START(startup_32_smp)
> >         andl $~1,%edx                   # Ignore CPUID.FPU
> >         jz .Lenable_paging              # No flags or only CPUID.FPU = no CR4
> > 
> > -       movl pa(mmu_cr4_features),%eax
> > -       movl %eax,%cr4
> > -
> > -       testb $X86_CR4_PAE, %al         # check if PAE is enabled
> > -       jz .Lenable_paging
> > -
> >         /* Check if extended functions are implemented */
> >         movl $0x80000000, %eax
> >         cpuid
> > 
> > My only hesitation is the risk of somehow breaking ancient CPUs by falling into
> > the NX path.  Maybe try forcing EFER.NX=1 for !PAE, and fall back to requiring
> > PAE if that gets NAK'd or needs to be reverted for whatever reason?
> > 
> 
> One more dumb question: are you planning to set NX for linux with !PAE?

Yep.

> Why do we need EFER in that case? Thanks! :)

Because as you rightly remembered above, KVM always uses PAE paging for the guest,
even when the host is !PAE.  And KVM also requires EFER.NX=1 for the guest when
using shadow paging to handle a potential SMEP and !WP case.  

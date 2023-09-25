Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0BF7ADF75
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 21:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjIYTQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 15:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjIYTQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 15:16:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96BCFC
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:16:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f7d109926so48007847b3.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 12:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695669394; x=1696274194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MBb7/o1IRk0JElBFa4klbTWLM6mKvJph/LCCzFiKFTQ=;
        b=bdCxsRsuc6E/4uG33ZbF7h9ni1HZOQM67sMu51HAfAAS4zlgo0HSPBU3eLq6NvdHpf
         yjN0QQGHskEmGy+HP27CJ/F/tGOWGfsy9UMQIoIZXmzw/ERJC46aAxPQgQLo9QtAdu8I
         uH36WitWtQ56nNGynkpDOORRFY0pJ/jd/80aCC2oStQUk7tSKM3pIdGZmrj17B7t+g0U
         d3Xt9YTEPFoH9cjWZ7uw9WCS5CJJmfeNad75bUq5PCntCq2auPuftVKV0ocyTzrwNFeH
         P6whpXQkW7rOz5QRmyXtO65yxc3GxX9M6ctx+OJ1RgVDIikob2tve+p9hBGwtMdzDleJ
         gKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695669394; x=1696274194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBb7/o1IRk0JElBFa4klbTWLM6mKvJph/LCCzFiKFTQ=;
        b=R/Rv8Iw+jkKkutqqpJE5pbaJRO4W32nDv9RhFbguJbtQyN6KClrBIBvac1Xxd++9PJ
         sXr19F1T/ryjY/7RR3C1FQdafGDuFAggMqlKtC3mPM5Mp06KK2mji9l70ZfXA3muhMDl
         Z0iSwWwt5hV4QIvTXzB0fliQmwWy/lXiMgRHhUMsTDttsqslAHrcJHPxwmjEkQQ5ezxt
         289PkSpcT8AyJZru0kzjt16j1U6GY6LDtXRSc5x2zMdUQhpkpw04yXlI6zmvtSXyK/Wc
         bOu4SmBHjTJ73HDwSQb9llhJG5dO/ErrKbAdR95QNds2IPjL4qqkef1pe2E9N77sNmca
         BpAQ==
X-Gm-Message-State: AOJu0YzveWFK0NHGfLqTJnyHRyxdoramQ+CIPhZH2Q9cXWZhs/Y/9Pqd
        WZLlYbJcayN7psUA2KsKvJ0BEvlv/1s=
X-Google-Smtp-Source: AGHT+IHwqJPElF/D6RnFeZcgh5HTfyZNmRDOTT6D2UxYulQBeoscMRWpl5d03Kc5Cj4wlAC1nyC02Ad7ufI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ec12:0:b0:589:a5c6:4a8e with SMTP id
 j18-20020a81ec12000000b00589a5c64a8emr88716ywm.1.1695669394067; Mon, 25 Sep
 2023 12:16:34 -0700 (PDT)
Date:   Mon, 25 Sep 2023 12:16:32 -0700
In-Reply-To: <8c6a1fc8-2ac5-4767-8b02-9ef56434724e@maciej.szmigiero.name>
Mime-Version: 1.0
References: <0ffde769702c6cdf6b6c18e1dcb28b25309af7f7.1695659717.git.maciej.szmigiero@oracle.com>
 <ZRHRsgjhOmIrxo0W@google.com> <8c6a1fc8-2ac5-4767-8b02-9ef56434724e@maciej.szmigiero.name>
Message-ID: <ZRHckCMwOv3jfSs7@google.com>
Subject: Re: [PATCH] KVM: x86: Ignore MSR_AMD64_BU_CFG access
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Tom

On Mon, Sep 25, 2023, Maciej S. Szmigiero wrote:
> On 25.09.2023 20:30, Sean Christopherson wrote:
> >>
> >> Hyper-V enabled Windows Server 2022 KVM VM cannot be started on Zen1 Ryzen
> >> since it crashes at boot with SYSTEM_THREAD_EXCEPTION_NOT_HANDLED +
> >> STATUS_PRIVILEGED_INSTRUCTION (in other words, because of an unexpected #GP
> >> in the guest kernel).
> >>
> >> This is because Windows tries to set bit 8 in MSR_AMD64_BU_CFG and can't
> >> handle receiving a #GP when doing so.
> >
> > Any idea why?
>
> I guess it is trying to set some chicken bit?
>
> By the way, I tested Windows Server 2019 now - it has the same problem.
>
> So likely Windows 11 and newer version of Windows 10 have it, too.

...

> > > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > > index 1d111350197f..c80a5cea80c4 100644
> > > --- a/arch/x86/include/asm/msr-index.h
> > > +++ b/arch/x86/include/asm/msr-index.h
> > > @@ -553,6 +553,7 @@
> > >   #define MSR_AMD64_CPUID_FN_1		0xc0011004
> > >   #define MSR_AMD64_LS_CFG		0xc0011020
> > >   #define MSR_AMD64_DC_CFG		0xc0011022
> > > +#define MSR_AMD64_BU_CFG		0xc0011023
> > 
> > What document actually defines this MSR?  All of the PPRs I can find for Family 17h
> > list it as:
> > 
> >     MSRC001_1023 [Table Walker Configuration] (Core::X86::Msr::TW_CFG)
> 
> It's partially documented in various AMD BKDGs, however I couldn't find
> any definition for this particular bit (8) - other than that it is reserved.

I found it as MSR_AMD64_BU_CFG for Model 16h, but that's Jaguar/Puma, not Zen1.
My guess is that Windows is trying to write this thing:

  MSRC001_1023 [Table Walker Configuration] (Core::X86::Msr::TW_CFG)
  Read-write. Reset: 0000_0000_0000_0000h.
  _lthree0_core[3,1]; MSRC001_1023

  Bits   Description
  63:50  Reserved.
  49     TwCfgCombineCr0Cd: combine CR0_CD for both threads of a core. Read-write. Reset: 0. Init: BIOS,1.
         1=The host Cr0_Cd values from the two threads are OR'd together and used by both threads.
  48:0   Reserved.

Though that still doesn't explain bit 8...  Perhaps a chicken-bit related to yet
another speculation bug?

Boris or Tom, any idea what Windows is doing?  I doubt it changes our options in
terms of "fixing" this in KVM, but having a somewhat accurate/helpful changelog
would be nice.

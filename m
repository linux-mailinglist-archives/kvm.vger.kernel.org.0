Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1637128B7
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244011AbjEZOkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244089AbjEZOkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:40:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7005AE4B
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:39:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8337a5861so2198212276.0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685111956; x=1687703956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HNAPtYMKE2DwuE0/Om5XERH8unHdbvGM9xOlT/rQSiM=;
        b=qsUncX2EbLctr4fP8gajSri5U1pxUkivvKJRV9QQZmG0n0CaNsLFJVwgtgSWDD+SMJ
         2SdsjklIMX7MTPqTAJd6xEdCOhoRT1rQhi3AonOw5G76o0mFvMlyx2d+x+u3Lv3sR5XU
         SpIntlAP1o1CdhXFFuU5KFnjUOPei3x70ZeBUQzhnzfj1yKSBUU7AwTHLeMWgZpAsbgh
         zuODJ2RLL4JnK45BOaGIm4QWeVWqU00jBeMbuLaRDcz1u9yNd4/1VUeVhTAWMR5UXyCT
         aY3ep4oSH6a2l8RdFYcyXK7LfRXeh/9jcPQiNaj/YT6UTvBvSzXnYlMJLGCqHwQVu6Ai
         D9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685111956; x=1687703956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNAPtYMKE2DwuE0/Om5XERH8unHdbvGM9xOlT/rQSiM=;
        b=d2FMD4CqUKJDTHnZt9FpuccPB1z8ZAoDbpWsyyPIIgvvLtTIQv2r2Eu5tx9lwun2wM
         JVaovDbf6JAWjCPnwYACSyGoyXWMbppLFEI/SVw53JTfbwQR+02AyRLuXUma1BzzJF5H
         rjoA3AUhy7+0sQ/+iatEHwDtnIvxBoh5pocyYHKupgxULz/1w4nepICkTUScRtEsqSVL
         VrKVT/dzwyFz9A4np4EUttBEFw38FCnnVD1HecfKD6YNJNthYYakAlE/is9pcReEk2q7
         jq5/gYtERtC7lTdfCionwZvNb1wGBKKD6PgiJKaRfVEaUJJCRBMEwSCvOeHp6OjQ/Nmb
         Ni/A==
X-Gm-Message-State: AC+VfDxOWuw3RboUS7JAhWKaJqTehahiVz9T4Zk1/cNQCoG/Fy8pVu4Y
        ZV7VXl35BYFoFupz6rcjv6v5Si31syk=
X-Google-Smtp-Source: ACHHUZ47oCO6HwXqYzWIxcyvOS4fpxEXPkDQACfUzuqbBxss74rfmln5dAtL/xTF8sqWXxmiF1DIIzBlvQQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8206:0:b0:b9e:7fbc:15e1 with SMTP id
 q6-20020a258206000000b00b9e7fbc15e1mr4332600ybk.0.1685111955796; Fri, 26 May
 2023 07:39:15 -0700 (PDT)
Date:   Fri, 26 May 2023 07:39:14 -0700
In-Reply-To: <fc82a8a7-af38-5037-1862-ba2315c4e5af@amd.com>
Mime-Version: 1.0
References: <20230411125718.2297768-1-aik@amd.com> <20230411125718.2297768-6-aik@amd.com>
 <ZGv9Td4p1vtXC0Hy@google.com> <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com>
 <ZGzfWQub4FQOrEtw@google.com> <fc82a8a7-af38-5037-1862-ba2315c4e5af@amd.com>
Message-ID: <ZHDEkuaVjs/0kM6t@google.com>
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Alexey Kardashevskiy wrote:
> 
> On 24/5/23 01:44, Sean Christopherson wrote:
> > On Tue, May 23, 2023, Alexey Kardashevskiy wrote:
> > > > Actually, can't disabling #DB interception for DebugSwap SEV-ES guests be a
> > > > separate patch?  KVM can still inject #DBs for SEV-ES guests, no?
> > > 
> > > Sorry for my ignorance but what is the point of injecting #DB if there is no
> > > way of changing the guest's DR7?
> > 
> > Well, _injecting_ the #DB is necessary for correctness from the guest's perspective.
> > "What's the point of _intercepting_ #DB" is the real question.  And for SEV-ES guests
> > with DebugSwap, there is no point, which is why I agree that KVM should disable
> > interception in that case.  What I'm calling out is that disabling #Db interception
> > isn't _necessary_ for correctness (unless I'm missing something), which means that
> > it can and should go in a separate patch.
> 
> 
> About this. Instead of sev_es_init_vmcb(), I can toggle the #DB intercept
> when toggling guest_debug, see below. This
> kvm_x86_ops::update_exception_bitmap hook is called on vcpu reset and
> kvm_arch_vcpu_ioctl_set_guest_debug (which skips this call if
> guest_state_protected = true).

KVM also intercepts #DB when single-stepping over IRET to find an NMI window, so
you'd also have to factor in nmi_singlestep, and update svm_enable_nmi_window()
and disable_nmi_singlestep() to call svm_update_exception_bitmap().

> Is there any downside?

Complexity is the main one.  The complexity is quite low, but the benefit to the
guest is likely even lower.  A #DB in the guest isn't likely to be performance
sensitive.  And on the flip side, opening an NMI window would be a tiny bit more
expensive, though I doubt that would be meaningful either.

All in all, I think it makes sense to just keep intercepting #DB for non-SEV-ES
guests.

Side topic, isn't there an existing bug regarding SEV-ES NMI windows?  KVM can't
actually single-step an SEV-ES guest, but tries to set RFLAGS.TF anyways.  Blech,
and suppressing EFER.SVME in efer_trap() is a bit gross, but I suppose since the
GHCB doesn't allow for CLGI or STGI it's "fine".

E.g. shouldn't KVM do this?

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca32389f3c36..4e4a49031efe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3784,6 +3784,16 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
        if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
                return; /* IRET will cause a vm exit */
 
+       /*
+        * KVM can't single-step SEV-ES guests and instead assumes that IRET
+        * in the guest will always succeed, i.e. clears NMI masking on the
+        * next VM-Exit.  Note, GIF is guaranteed to be '1' for SEV-ES guests
+        * as the GHCB doesn't allow for CLGI or STGI (and KVM suppresses
+        * EFER.SVME for good measure, see efer_trap()).
+        */
+       if (sev_es_guest(vcpu->kvm))
+               return;
+
        if (!gif_set(svm)) {
                if (vgif)
                        svm_set_intercept(svm, INTERCEPT_STGI);

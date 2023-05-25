Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F233711A2C
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 00:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242108AbjEYWaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 18:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbjEYWaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 18:30:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B49D187
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 15:30:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba82ed6e450so377170276.2
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 15:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685053812; x=1687645812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tpe07KW4MlBzxlGn7n37Z+ZqlMCf6ry7/JhPxHNLhGc=;
        b=gnIqfD78xjJBrl22JS5xn0bJm2eRs9S14W4Wng9ZmN/KRqAlYoQCuuH4TE99W8J0Gw
         DqJTar/YTthPR0dQielI1FOXVatroR8HUJuyf+cuNIIxNech7uODHv0p8Rzqq304rN4v
         sZzHeaLXRJQ+32bQ8wm/EDFDhmOzwzoPHYf8Ii381bdvMLoWClbe+59CLtJmE+43626j
         2NulVW9L0ULrslMvVfoO5v8PHnvaaxbEjYq9SEnxNW6qg8LvT3/FJcdb4a0cmKIxPt00
         hlLUHZv6s2N42FO7nOEg3vvryPM+OO6YjcCIl3fy6jbjMCoQSEjzb3ex13zRiIkaYEFY
         OOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685053812; x=1687645812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tpe07KW4MlBzxlGn7n37Z+ZqlMCf6ry7/JhPxHNLhGc=;
        b=Imp+jA+29I7C8yjoqgf1Wuu50XehnS9WS2yMJjbSnLuehELg+nuA5ueZyuZKFJA3Ao
         5qkmzqX4/25EZm33HIWDVx9k0k34VToarL3k+VlyXRsoscS3wPohXjo5bDtY/tKtX4XK
         sm7J7grd5DA3ldkD6jQKXRnNJYvVKO6vj9plVxSS6Wb0NN/P91U9Wm/4wnsaKTkGR7Lf
         CFBNLlayTtbhfDjM1VHtPL3DJzSSzyf6/fzCCFASGlvX0lMor7gYmQ9v9vsuqvYRHtdx
         DqvVSof0VxzQTO3gghihNUhlvbi8E6bakCYsur9LmSiziYzZLLVIwv88mlhHcorr+Hau
         3NWw==
X-Gm-Message-State: AC+VfDxurU18MG+QBsKs42MdkBkZOa24ENWeMjoGwCHg/mFpJSh2muvz
        pPwfgZWjSo3K3lIA0jBWsjm34p9cNRA=
X-Google-Smtp-Source: ACHHUZ62cNRvxG25DIpG9Icp/006GZJVCqE64XxsrFxfdoy7ebQaEM9QJ0+Xwo1aB7s3oHXb9fFnwi+6caE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5485:0:b0:ba7:3724:37dc with SMTP id
 i127-20020a255485000000b00ba7372437dcmr2251497ybb.13.1685053812610; Thu, 25
 May 2023 15:30:12 -0700 (PDT)
Date:   Thu, 25 May 2023 15:30:11 -0700
In-Reply-To: <2d7f7f80-278d-9fcf-cfc4-c433e95d9842@gmail.com>
Mime-Version: 1.0
References: <20230427095333.35038-1-abusse@amazon.com> <2d7f7f80-278d-9fcf-cfc4-c433e95d9842@gmail.com>
Message-ID: <ZG/hc+9/2BraMrZB@google.com>
Subject: Re: [PATCH 0/2] KVM support for Intel PMU v5 fixed function PMC bitmap
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Anselm Busse <abusse@amazon.com>, dwmw@amazon.co.uk,
        hborghor@amazon.de, sironi@amazon.de,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023, Like Xu wrote:
> On 27/4/2023 5:53 pm, Anselm Busse wrote:
> > Starting with v5, the Intel PMU allows to indicate the available fixed
> > function PMCs not only through CPUID.0AH.EDX[4:0] but also through a
> > bit mask in CPUID.0AH.ECX. According to the SDM the OS can consider a
> > fix function PMC i supported for:
> > 
> > CPUID.0AH.ECX[i] || (CPUID.0AH.EDX[4:0] > i)
> 
> Yes, this feature is attractive for virtualization scenarios, and it gives
> flexibility to control which fixed counters are available or not in the
> virtual machine.
> 
> However, currently KVM/x86 also supports Intel PMU V2, so I would expect
> that we will review the enablement code for v3 and v4 first.

Looking at v3, I think we probably want to skip straight to v5.  I don't see a sane
way for KVM to emulate/virtualize AnyThread, which comes in v3 without a separate
CPUID feature flag.  The SDM even calls out that it'd be a mess to deal with in a
virtualized environment.  v5 introduces a CPUID bit to allow deprecating AnyThread,
i.e. would give KVM the ability to advertise a sane vPMU model to userspace.
Amusingly, KVM advertises "edx.split.anythread_deprecated = 1" for v1+, so maybe
we don't even need to do any enabling?  At glance, I don't see any other changes
in v3 that require KVM support.

v4 looks to be an entirely different story than v3 though.  So I agree with Like
that we need to enable v3 and v4 before advertising support for v5.  And KVM *does*
need to actually advertise v5.  Emulating the fixed counter bitmap without a way to
tell userspace about the functionality will create a mess.

TL;DR: If y'all want the shiny features in v5, please enable v3 and v4 first.  I'm
totally fine taking a series to go all the way to v5 (might even be preferred due
to the AnyThread crud), but I don't want to advertise v5 without supporting the
required v3/v4 features.

> Ref: https://lore.kernel.org/kvm/CALMp9eQVnk8gkOpX5AHhaCr8-5Fe=qNuX8PUP1Gv2H5FSYmHSw@mail.gmail.com/

I agree 100% with Jim, the bitmask stuff is firmly v5+.

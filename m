Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F84F5BD48D
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 20:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiISSKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 14:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiISSKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 14:10:04 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E9BBE12
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 11:09:40 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11eab59db71so525003fac.11
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 11:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kinTjsTMKWd+HF2A95PNPhp0ZSHokoUBxlIlduG7fRs=;
        b=Z9n+eNdWdh71NGqMwqlMdnGMkR+MfqHA3wiPVazUKLvvgnHURhbyz5tXcX8OndG0jF
         URQm5pcCEx33iQRKI5zFPbEgH51JFbW9BaAXYNFjgA5EPgMkmh2V98Civxgd5idJUz4q
         N8bx3Ufnvv5tXmdkiuZqMFqLzJ5RWk/VVEmZ/5r6upWFCH9p4MHsGu5NNqC6soqW2oB3
         lwtV5aFIKP1Mk+gChIWcM5JW1eZiH3puViRgtakqwSp1UjXFmmBx/jq37EYsyjSMOtet
         U0hoQISnRKXADaLvG+0m5BWoyOYnTaFmXyNvfsj2FyDAvW8FK+lchT/JgcpwM3NoIZ2G
         iDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kinTjsTMKWd+HF2A95PNPhp0ZSHokoUBxlIlduG7fRs=;
        b=jhzwrNFJ8I7GJ0HgocijNB0tye2W/GzsIc52e+XMkUHHo0/m8AXOt/rsFxqCtjxKs7
         ly88t7WeBAfKMlUQO37i6GMPGgi/i5MHBECF5Bj1SiFzIUP/xH8W1i8dSjfVs1d4jIdr
         /YUwjFImRi1/ddbtcETOwt6zhoBmJIYxWRjDmbBwtOV3R4pWAPtIE1BwBhX0NdzTU5mo
         kl0e/6Th6GvJsuI3fwRBzTQZsJ/d3QKn9GYm25h9abR3AcFtYrXLtL0dFrrWZnO5qDeI
         3kTLfTd6n1Mx77TjnPrgueXYIZct4j4x4awpG/r8BnFBGiiB+Rai+c2QLZAzsQLHdgO3
         tkaQ==
X-Gm-Message-State: ACgBeo00MumIcQ/p3ncLoRSDvH8FxhxauVlVhggtvg3CjRtHCg92W/kl
        C16jTO93Zg82s7yODG5C05PZoGEp89B1/P1WUxCeBg==
X-Google-Smtp-Source: AA6agR5DN+7DnOIoUE61op1nJjTuN8PFxR6X8cvIHEmjOifcEhIIHF7V7R8Ea8/MENkIhjW/tg4kd/FPe8WCOTlndv0=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr15703777oap.269.1663610979201; Mon, 19
 Sep 2022 11:09:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220916045832.461395-1-jmattson@google.com> <20220916045832.461395-3-jmattson@google.com>
 <YyTZFzaDOufASxqd@google.com> <CALMp9eQXroxQYiWUCejd0Cj7kD5g5navWY_E2O_vzbVAQjLyNg@mail.gmail.com>
 <YyT0G9y0RRyBDiPD@zn.tnic> <YyT5uW8bjXae2c4l@google.com> <YydrsMjAF5zjqTGK@zn.tnic>
In-Reply-To: <YydrsMjAF5zjqTGK@zn.tnic>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 19 Sep 2022 11:09:28 -0700
Message-ID: <CALMp9eTmcTjJ+aAN3EPANqx3Qo3Psiafz1iuT3fKgpM4Qe0OaA@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: svm: Disallow EFER.LMSLE on hardware that
 doesn't support it
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Avi Kivity <avi@redhat.com>, Babu Moger <babu.moger@amd.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 18, 2022 at 12:04 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Fri, Sep 16, 2022 at 10:33:29PM +0000, Sean Christopherson wrote:
> > ...
> > Either way, KVM appears to be carrying a half-baked "fix" for a buggy guest that's
> > long since gone.  So like we did in commit 8805875aa473 ("Revert "KVM: nVMX: Do not
> > expose MPX VMX controls when guest MPX disabled""), I think we should just revert
> > the "fix".
>
> If, as message 0/5 says, setting this bit so that SLE11 Xen 4.0 boots as
> a nested hypervisor is the use case, then sure, unconditional NO_LSMLE
> and we all should go on with our lives.

Fantastic! That's what I'll do in V2.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5E65A71E4
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiH3XeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiH3Xdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:33:38 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053BE9F1BE
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:32:34 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-11f34610d4aso9703684fac.9
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=QoQMpjqxJlADfnUCJp6OYozlgIQ996aVrO548ZR6pGU=;
        b=hVsETSJFSqjLYqgLzaFV0FMIxY+wnY0KAmZPQUvvwLWCmvi1aqhDFlnNl1HiC515hk
         TxgH1ta3K5GmjZx1DCoJgZ+OOPEo0mU1h7F2k1XTigWiBCsWJRGHZOr7lOWYfZpY8lsD
         fT818ScHdr4UktGV5H7wcZzXPYWo/hM3ibynQrKLvYuwjZ+OzAuywHGUppmdsYgqtfxh
         rdwSqzqQFIaErGLH+nHLbyD3M9yZv9bWLmyDY39Wt86TchqoBEPWAvZdl2SVFbVez0+1
         1PpJOHguSszj1Y9bUGX7mENJo86qHVbMgGoM/MN4cNhZuB16v4O26GQvvAjgHt8aEkxY
         VjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=QoQMpjqxJlADfnUCJp6OYozlgIQ996aVrO548ZR6pGU=;
        b=hE6NIZ1Z5/M36WzoZ+fdtZaxYMcepxVTqVR23nIgFpG3VklHIiAkpJun8ixPrHJ7b8
         fexDlX/XupNU/mqeemHlFQw9jzPy/ato/mxaJpOpRnwW9lqK+GpCna7sZFrTWkVzqesN
         1huadHIcR3CNmFRYAcojGKb/9Aq62/8FnJz+Ws1hqEH3pilXGc1tIL6OLK5dJInwdDqI
         lOdCw5YM3NA3ZcgYqpg9S64PcVRT3+Lpk+lma1xlto61YmoABtj7rqnspEjpAzmYUIOE
         zWrlK9mDqwwid61woz9prEmqy5Mrgy7PKfBEHWm9JXicRlmGKyQ6/T9g1DC7Zv+5ObZm
         p6uw==
X-Gm-Message-State: ACgBeo3ffWEPjNEfsK2eImgSqte91BFHpfGj7N2wz3dUyJBBZQkWHE+C
        dSI/fi2EaRilHNIHqbKSS2wjqbjikD/lFFC59Dju0w==
X-Google-Smtp-Source: AA6agR4OkbuNvoTGDO1VVxpTty/2Pz0+OSr97rGkNyttNIvw2drXz6UkYH4u+wva8KNxgg4OvLgKQyCLR1UgvQLcxrQ=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr213149oab.112.1661902348958; Tue, 30
 Aug 2022 16:32:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220830225210.2381310-1-jmattson@google.com> <Yw6c7X1ymnrAEIVu@google.com>
In-Reply-To: <Yw6c7X1ymnrAEIVu@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 Aug 2022 16:32:18 -0700
Message-ID: <CALMp9eQA-D+=1Os=WaHh29_z=kz8_7uuR+D584_Mc1OS9fN4gw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: Insert "AMD" in KVM_X86_FEATURE_PSFD
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Babu Moger <Babu.Moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 4:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Aug 30, 2022, Jim Mattson wrote:
> > Intel and AMD have separate CPUID bits for each SPEC_CTRL bit. In the
> > case of every bit other than PFSD, the Intel CPUID bit has no vendor
> > name qualifier, but the AMD CPUID bit does. For consistency, rename
> > KVM_X86_FEATURE_PSFD to KVM_X86_FEATURE_AMD_PSFD.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Cc: Babu Moger <Babu.Moger@amd.com>
> > ---
> >  v1 -> v2: Dropped patch 2/3.
> >
> >  arch/x86/kvm/cpuid.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 75dcf7a72605..07be45c5bb93 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -62,7 +62,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
> >   * This one is tied to SSB in the user API, and not
> >   * visible in /proc/cpuinfo.
> >   */
> > -#define KVM_X86_FEATURE_PSFD         (13*32+28) /* Predictive Store Forwarding Disable */
> > +#define KVM_X86_FEATURE_AMD_PSFD     (13*32+28) /* Predictive Store Forwarding Disable */
>
> This is asinine.  If KVM is forced to carry the feature bit then IMO we have every
> right to the "real" name.  If we can't convince others that this belongs in
> cpufeatures.h, then I vote to rename this to X86_FEATURE_AMD_PSFD so that we don't
> have to special case this thing.

You won't get any argument from me!

If Borislav objects to seeing the feature in /proc/cpuinfo, can't we
just begin the cpufeatures.h descriptive comment with ""?

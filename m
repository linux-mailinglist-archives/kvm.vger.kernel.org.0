Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A94656FAA
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 22:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiL0VAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 16:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiL0VAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 16:00:13 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E2F18B3C
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:44:08 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p66so7430585iof.1
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vmpC2FF6Ebjz2eeveFJ/mrf0H/NQvhzO57EvF2jGpgU=;
        b=X2VYlxcXTSHnJpgV/kG8zMl559/2ZawiUb1eQOC6zvT3Pz5V9WiKio71PzEDn/grFV
         hZiFnM2orGBWdAt3MlCJbnzeCZdJQSLMUKUzNHHV9ggrxpS5xiYdyZlnhbFJ6AeS5A30
         dAxCQMcmfEkpwKOx9u/pLLg5PNH+wV0dSNrVP4kPwNE6YmVhoLF/7m+XxR3iycRz3sTI
         PqkfVLgkTjMLiwybwH/iFnGb34vwKuyjiOAuDLsp8GBdBhNfqkoEeFI/VEpMuX7LGC6a
         GLx4aEWwXh0405OeB4OwES++Kp1yISIGWDEYcokM0bBi+uv7rNGOEk1SQLQ96vBQuqMe
         D1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vmpC2FF6Ebjz2eeveFJ/mrf0H/NQvhzO57EvF2jGpgU=;
        b=cuYT9uulFmu90J67gz7fKMo0fueLhvV8uQoua7QCMMe+2az4/H2YVMheAlLjp4aw+Z
         k94wZ4hFueKjWlje/pVRf4Ewlw55Fh9unP6hy9iS9UAm4TYIK/uRI7+D62qv16DGF6BX
         q++lJPe1WkMCm2n0/+ehVdkwYjo7+e7Xs7yKypR88N69Zd416B3mMRuuvt3ZjXiuKS/D
         hVAr/OEPhK2vSdvQbyoV4gOf/OEMpH6qcIzJl+UQvtJFs8Au79ml0T8GDl85tHlnPEqj
         h1i0Avk7yAbtrbQ4NW6vZvojj66ufjlSyYUkgeHaoUeesQ6d/t1sHFb2gk6WRdGjuEDV
         u/aQ==
X-Gm-Message-State: AFqh2koMURQl12/69WAidyI0HD5BVjSmyo64B1Cjw6w9wNRLv2IshBvg
        Zkaybh3RWS74ixIdYDh+4RxFyZZxlmWsN4SDPDAepg==
X-Google-Smtp-Source: AMrXdXtuGcVYOF6fIFvKdUDD9Q6TqYZTt4yoSci6jWLkkh6/UYVIu5M7SNaIJXN+bMDTy+URV4GINeSCxtcdelNI0CQ=
X-Received: by 2002:a02:b784:0:b0:38a:7a:26e8 with SMTP id f4-20020a02b784000000b0038a007a26e8mr1617893jam.168.1672173847323;
 Tue, 27 Dec 2022 12:44:07 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com> <20221227183713.29140-2-aaronlewis@google.com>
 <CALMp9eRidX1TkpdLzzLyC6HhREhPsPeh2MZ5itoLbv3ik+a29g@mail.gmail.com>
In-Reply-To: <CALMp9eRidX1TkpdLzzLyC6HhREhPsPeh2MZ5itoLbv3ik+a29g@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 27 Dec 2022 20:43:56 +0000
Message-ID: <CAAAPnDH6CqvtgT_ykn-BfP=hTUUugYbgOpcOWTx7ZaS__JyheQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86: Clear XTILE_CFG if XTILE_DATA is clear
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        like.xu.linux@gmail.com
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

> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 0b5bf013fcb8e..2d9910847786a 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -977,6 +977,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >                 u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> >                 u64 permitted_xss = kvm_caps.supported_xss;
> >
> > +               if (!(permitted_xcr0 & XFEATURE_MASK_XTILE_CFG) ||
> > +                   !(permitted_xcr0 & XFEATURE_MASK_XTILE_DATA))
> > +                       permitted_xcr0 &= ~XFEATURE_MASK_XTILE;
> > +
> >                 entry->eax &= permitted_xcr0;
> >                 entry->ebx = xstate_required_size(permitted_xcr0, false);
> >                 entry->ecx = entry->ebx;
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
>
> Two questions:
>
> 1) Under what circumstances would this happen?
This would happen if userspace hasn't opted in to using AMX via arch_prctl().

> 2) Shouldn't we also clear XFEATURE_MASK_CFG if both bits are not set?
Both CFG and DATA are cleared with XFEATURE_MASK_XTILE.  It defines both.

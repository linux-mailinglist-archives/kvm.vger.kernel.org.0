Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC30656FE6
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 22:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiL0VOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 16:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiL0VOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 16:14:32 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3157111E
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 13:14:31 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id j16-20020a056830271000b0067202045ee9so8851793otu.7
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 13:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5B3gRbk7mPTy6cABE5bRAfMgyd0DMPubiMozUKCh0xs=;
        b=kj/ebOrzNTFjaJ3PIhpn1A93x2Rf4mlsy4MQgOuZbnIvkTa8M2ef2dYXNPH/apaqWZ
         WcXzTBRaLbPeZI4KiKmOI0XbNOSkk51Pd2Y7Ds1H0LglgJAYLw0Rd7QQ7fFNdwVM0pEw
         586zJb04MDAHHKfLAMS7MVydF0lFRPXIgbsZat5A+lcMHfafmmfgRUhY6FBIcE+HQLCa
         zSFsIOKk/molyqnYsvnA7A+im6UbPnjfrWjLY+XJIcCO5RGgcfx45NuYljvjm6pT+MS/
         PDlm6MuoQ7bhyHyxatnRUfYiETDB8rC2iuYCnXWGklf9S/H4N0IrIydecN/S7diUM6MN
         PybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5B3gRbk7mPTy6cABE5bRAfMgyd0DMPubiMozUKCh0xs=;
        b=Sqhvs1YS6tPP+NbxRBEBhHez4Q0WUCXjMJ35G72G68HvmirS+DF68m/NbbtpdoDJi7
         f92disAR+Bkkj1/ktt9izBP20gVIS5P2z7OxPLb9OmplGZHz5twQ8kIm8owiRGs8oTwH
         9zd0lSKxB2U4+hc8ZFRRDy8al0AZoeswtsXwqn0/uxgkqRLVsdWd1B+vrVQLhi2JP7fo
         Ai8k98A+9Db9C47N+smvsa79FI96s/6RGglBxsnldAzqdmcSqbyBzbo9we0RUAYNIckQ
         d+SwFhbltznggkFveRD8CPcCYewZd524NTDzze1g7hiL7p/1rxXdCF51+DnvI8MNxbSl
         Yq+A==
X-Gm-Message-State: AFqh2koSTfl+QaDohi9I/MYNvjJzb9ZBZlI6TPECgW7xaVl0XItgpecg
        YGFQNDgL3W3w62G//4VAL4k6LmFWgf/4yeIV1E8dKA==
X-Google-Smtp-Source: AMrXdXttjUPZGgWXlpUzktmXjvoZEX08g9rVnFYgBy6JmWurRqMwD1RGt7c69aTPAYANoe+P0YdSeEpv6FE6wPVVAsc=
X-Received: by 2002:a9d:6d84:0:b0:66c:a613:9843 with SMTP id
 x4-20020a9d6d84000000b0066ca6139843mr1662571otp.8.1672175670362; Tue, 27 Dec
 2022 13:14:30 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com> <20221227183713.29140-2-aaronlewis@google.com>
 <CALMp9eRidX1TkpdLzzLyC6HhREhPsPeh2MZ5itoLbv3ik+a29g@mail.gmail.com> <CAAAPnDH6CqvtgT_ykn-BfP=hTUUugYbgOpcOWTx7ZaS__JyheQ@mail.gmail.com>
In-Reply-To: <CAAAPnDH6CqvtgT_ykn-BfP=hTUUugYbgOpcOWTx7ZaS__JyheQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Dec 2022 13:14:19 -0800
Message-ID: <CALMp9eRH6YRmksZPY2=8FXnxGMS4WHAQeBsY5Ppc7d1rTGHgsw@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86: Clear XTILE_CFG if XTILE_DATA is clear
To:     Aaron Lewis <aaronlewis@google.com>
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

On Tue, Dec 27, 2022 at 12:44 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 0b5bf013fcb8e..2d9910847786a 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -977,6 +977,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> > >                 u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> > >                 u64 permitted_xss = kvm_caps.supported_xss;
> > >
> > > +               if (!(permitted_xcr0 & XFEATURE_MASK_XTILE_CFG) ||
> > > +                   !(permitted_xcr0 & XFEATURE_MASK_XTILE_DATA))
> > > +                       permitted_xcr0 &= ~XFEATURE_MASK_XTILE;
> > > +
> > >                 entry->eax &= permitted_xcr0;
> > >                 entry->ebx = xstate_required_size(permitted_xcr0, false);
> > >                 entry->ecx = entry->ebx;
> > > --
> > > 2.39.0.314.g84b9a713c41-goog
> > >
> >
> > Two questions:
> >
> > 1) Under what circumstances would this happen?
> This would happen if userspace hasn't opted in to using AMX via arch_prctl().
>
> > 2) Shouldn't we also clear XFEATURE_MASK_CFG if both bits are not set?
> Both CFG and DATA are cleared with XFEATURE_MASK_XTILE.  It defines both.
Doh!

Reviewed-by: Jim Mattson <jmattson@google.com>

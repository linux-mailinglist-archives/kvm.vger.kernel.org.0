Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B855F4DFC
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 04:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJEC72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 22:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiJEC7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 22:59:21 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E27E5D10D
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 19:59:20 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id m81so16351568oia.1
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 19:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o5M3+7RUxrkIIZHvVM5xjYTfJjQaC+saLXzSqSDfEkw=;
        b=JeyyILs+ECdXjqaSYJFxq719GG+/SDu0Bmq9ACybqU8Qel5g2FykrBs1b+IfovkNoh
         yD0CGIFCXsjOy2iTjb7Ll4EkMwHbxZig9RBDUpMt0HVUqsf+665yg71wnL2g4zHSYcdy
         INDcJ6siIe9weG3kgOtgONQ4QT1E8iz/bEYXQSgic3YwBjdn0/iTZFDfXJsfGmUPCtEk
         5GF7VIJKHiW2aIKawb77BGzinetPi62dgBgoXf89hcwukcGql70egCq5ofXGuqoBu+vS
         jPf2qkyyOj/EnvvpbYvxyUTS94Dy+KZMZsfFvpdUz1TZNd3yoQppmFqavssUDF2XjVZ3
         21wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5M3+7RUxrkIIZHvVM5xjYTfJjQaC+saLXzSqSDfEkw=;
        b=fAzJTIFpHHmgszp6iDkzkrTQDkxQTFqw4IM1Tc8adwvf1tivyDSzbIDjzWHsSYRYUp
         x4S/p37qZeiANzexl2dXKEM14XkbVEC5pJIbvFwWGLbRoynJuT8V1/K+/AEx5IrfwZmi
         dWBnIgdOLDvQvQj98YxMzJj+T+9A0ioODj6W2nLd6fIDw5tdieiJorr5f7Wx4kMr8LzU
         2yqDjOMNICeBxvWyTBJM82Uh/Cpol46r4jvCopgsgLTxpH7mUsnQaJO5eH3QNgscCFwj
         SupsOjUJE+vmAPNnqh9gsxI1LnTak467c/QNep1AyZyXskh2ybjJs5i8qoltDPwvAdqr
         4KIw==
X-Gm-Message-State: ACrzQf0lTIEmwr3QjP4HV+GKmeFPmBtZuSqstmqBaMzbP2pnYHfJJ6hN
        LZhY336drAmeUzLPUCeHks0zm5+P+8yhNleQj7OKay9U9uvtdQ==
X-Google-Smtp-Source: AMsMyM4g7k3M6vZW2FA8OEz0BW4COw3PaFJJI+H2CTdUwRQG3xqibR+2CaZwlT7FeGfzyi+d4voA/V87znof81Egw90=
X-Received: by 2002:a05:6808:f8e:b0:351:a39:e7ca with SMTP id
 o14-20020a0568080f8e00b003510a39e7camr1231956oiw.269.1664938759382; Tue, 04
 Oct 2022 19:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com> <20220929225203.2234702-2-jmattson@google.com>
 <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com>
 <BL0PR11MB30421511435BFEF36E482AC28A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eTNeeCNt=xMFBKSnXV+ReSXR=D11BQACS3Gwm7my+6sHA@mail.gmail.com>
 <BL0PR11MB3042784D7E66686207D679268A5B9@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eRJOHwh1twmS5X+ooGQqn+y0YrNXgJoB7UhMb+nUa+EFw@mail.gmail.com> <BL0PR11MB30426E91DB220599F53F577F8A5D9@BL0PR11MB3042.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB30426E91DB220599F53F577F8A5D9@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 Oct 2022 19:59:08 -0700
Message-ID: <CALMp9eS0-j7mV8M-G30XqR3wyLhoOK3JEs5PYag7s-3fVMd=5w@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
To:     "Dong, Eddie" <eddie.dong@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
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

On Tue, Oct 4, 2022 at 5:08 PM Dong, Eddie <eddie.dong@intel.com> wrote:
>
> > Hardware reserved CPUID bits are always zero today, though that may not be
> > architecturally specified.
>
> entry->edx is initialized to native value in do_host_cpuid(), which executes physical CPUID.
> I guess I am disconnected here.

Hardware values should only be passed through for features that KVM
can support. Reserved bits should be set to 0, because KVM has no idea
whether or not it will be able to support them once they are defined.

Perhaps an example will help.

At one time, leaf 7 was completely reserved. Following the principle
that KVM should not pass through reserved CPUID bits, KVM zeroed out
this leaf prior to commit 611c120f7486 ("KVM: Mask function7 ebx
against host capability word9").
Suppose that the legacy KVM had, as you suggest, passed through the
hardware values for leaf 7. As CPUs appeared with SMEP, SMAP, Intel
Processor Trace, SGX, and a whole slew of other features, that version
of KVM would claim that it supported those features. Not true.

How would userspace be able to tell a version of KVM that could really
support SMEP from one that just blindly passed the bit through without
knowing what it meant? The KVM_GET_SUPPORTED_CPUID results would be
identical.

In some cases, if KVM claims to support a feature that it doesn't
(like SMEP), a guest that tries to use the feature will fail to boot
(e.g. setting CR4.SMEP will raise an unexpected #GP).

However, as you alluded to earlier, zeroing out reserved bits does not
always work out. Again, looking at leaf 7, the old KVM that clears all
of leaf 7 claims legacy x87 behavior with respect to the FPU data
pointer, FPU CS and FPU DS values, even on newer chips where that is
not true. This is because of the two "reverse polarity" feature bits
in leaf 7, where '0' indicates the presence of the feature and '1'
indicates that the feature has been removed. At least, in this case,
userspace can tell if KVM is wrong, just by querying CPUID leaf 7
itself. Long after leaf 7 support was added to KVM, it continued to
make the mistake of clearing those two bits. That bug wasn't addressed
until commit e3bcfda012ed ("KVM: x86: Report deprecated x87 features
in supported CPUID"). Fortunately, no software actually looks at those
two bits.

The KVM_GET_SUPPORTED_CPUID API is abysmal, but it is what we have for
now. The best thing we can do is to zero out reserved bits. Passing
through the hardware values is likely to get us into trouble in the
future, when those bits are defined to mean something that we don't
support.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377CA5C056D
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiIURqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiIURqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:46:02 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C018A1D04
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:46:01 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1280590722dso10209808fac.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=IqpJMvr6QOojppOTB8iyTdKxCDEypFmvkfPtQjp1qN4=;
        b=VJGkBNovoBW0ZTmaa5yGPlkwJmYFhQzAx/ARWFo6YlaQIlgv6kf/6SUpnZkkgCZWie
         MvGcfQiYhg/Lvz9XWhbr36zuQNinQ4I62SqXS4zTJUaYxjtDNLZo8OCN/zS2TnLbj3Vf
         zhQtU29hU6oA+ofOTebj3Q0n7bpZrv6UOeCg0K+1tzoQq8EIg3qWmMEzVNj6zCA55quC
         QWhL/5Vg0nUmUFF/FbkBXFpn5EnACSBUj2XtgdyZoIWwkKhleDY5TZvf0f3KNcpQPYrq
         XOw3Xb4Fuxc/BRsxuHExsHSyJAFCqkIZ2rFHyUT9ubspbD4SAPjpqpVOhicJ2uAKW0OL
         EmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=IqpJMvr6QOojppOTB8iyTdKxCDEypFmvkfPtQjp1qN4=;
        b=su8nV1ZExYHBS8vcw7QCyGAVErXh76J6BT5egTwXex648LmG2hKgmy7XXcQO+OjnVi
         DNbiwM0TafsM1X+6A+JDjAI+B966fZsqvn1p8W7lB1+a5ovaLY0E/1FIRYPmZLuFcIJ0
         QKOri8kc7ZlbhnxoaJFpma8IT7wN9LRx4gax/WQhkIu9N9j2bnCJxQvLt9ZqbNASg8LV
         aHu1LdDWXKasMuTZ+Sf8oEtEYz1hTp75FNrh9Nv1TElrJDbrjn3O9LfgrcQgfE+LCR1s
         duWhpfwUgVThdHtgU5ZAY8AX3vqhiSbi+kiUuVl2H5UOTnOFegwzHL0mfLOV6P1F7HMc
         qdKg==
X-Gm-Message-State: ACrzQf3fVsLCr8UU/QkXu/UHDa9K0r4q/Mo7cqNHwox1tAErph9wxJ+H
        2JWHjF/mB9vv/kNasNc39SoFtRLn4yY3+ZftkCbHRg==
X-Google-Smtp-Source: AMsMyM7ROHkOGtCBSmQoyiiffLBjCIuZK+Ww3QXBi3qLqjP1Nrp9cYq8j+CSIRrsediibkRzAh2IJhQWCfv/HEGo3SM=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr5635355oap.269.1663782360610; Wed, 21
 Sep 2022 10:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220920205922.1564814-1-jmattson@google.com> <Yyot34LGkFR2/j5f@zn.tnic>
 <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
 <YyrZOLq8z+lIORvP@zn.tnic> <CALMp9eRG6g-95zCxTD1NnxpZ+Vm6VMTA0_uaHV=b-hDkeOYSuA@mail.gmail.com>
 <YysXeXKY36yXj68q@zn.tnic> <CALMp9eTuO79+NfHxLi8FnqdOpzXO7eQUntvN23EfR+shg+wg2Q@mail.gmail.com>
 <Yys2ikzV73upzlEj@zn.tnic> <CALMp9eQ-qkjBm8qPhOaMzZLWeHJcrwksV+XLQ9DfOQ_i1aykqQ@mail.gmail.com>
 <YytFzvQx0BbSCT7m@zn.tnic>
In-Reply-To: <YytFzvQx0BbSCT7m@zn.tnic>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Sep 2022 10:45:49 -0700
Message-ID: <CALMp9eQgsONsRVwA+bnGvccUFd9YDDRF=4PCP4rVV24fTA--+A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 10:11 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Sep 21, 2022 at 09:23:40AM -0700, Jim Mattson wrote:
> > AMD defined the 64-bit x86 extensions while Intel was distracted with
> > their VLIW science fair project. In this space, Intel produces AMD64
> > compatible CPUs.
>
> Almost-compatible. And maybe, just maybe, because Intel were probably
> and practically forced to implement AMD64 but then thought, oh well,
> we'll do some things differently.
>
> > The definitive specification comes from AMD (which is sad, because
> > AMD's documentation is abysmal).
>
> Just don't tell me the SDM is better...
>
> But you and I are really talking past each other: there's nothing
> definitive about a spec if, while implementing it, the other vendor is
> doing some subtle, but very software visible things differently.
>
> I.e., the theory vs reality point I'm trying to get across.

I get it. In reality, all of the reverse polarity CPUID feature bits
are essentially useless.

The only software that actually uses LMSLE is defunct. That software
predated the definition of CPUID.80000008:EBX.EferLmlseUnsupported and
is no longer being updated, so it isn't going to check the feature
bit. It's just going to fail with an unexpected #GP.

Maybe you think I'm being overly pedantic, but the code to do the
right thing is trivial, so why not do it?

This way, if anyone files a bug against KVM because an old VMware
hypervisor dies with an unexpected #GP, I can point to the spec and
say that it's user error.

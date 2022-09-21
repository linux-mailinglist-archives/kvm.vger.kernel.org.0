Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6335C045E
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiIUQip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiIUQiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:38:22 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AC49DB50
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 09:23:52 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1278624b7c4so9809526fac.5
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 09:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=c0RkeYzaVmPEsrZ5EMX9GaWUzmBrwnO4Ngp7mcr6270=;
        b=mclHjr/Fs7SL8F+F1lWzX0r9UcdRoDguRRxPSp+ho6sqozHcX+AjvJ5xpr0V3e1/Q/
         +c+WVecvKeIFAn8SIlKHOt/eEiV+zHBPoLKh+fwlCmVx7Lm4QtY1uOW1czzBfhvybyUF
         +HoxJk/yRuTrdb2Ot8vLIw2Pyv+VmyEMNe8x8ORYb9gPlZaqR4i3mw7IBvtsQiUQ5qMl
         zD2bNR3+acOJOi+D7XFMIEwwKFdUTK/G4gViPhJ9xLHg8rpDx8UZlaI+HyckwibnSeSh
         r05ZMc6qgdf1jRIPWKNygBlVDuBxocBMoye/PC88Kpau/Z6Pe2cbvkw+8QITUJ9Chgt/
         GZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=c0RkeYzaVmPEsrZ5EMX9GaWUzmBrwnO4Ngp7mcr6270=;
        b=U8zzm6X75eOCf2u0dEdva9ZAxvmbjzBPKADUF5Hm8AFw1QUeoAHaG18qO9ggiGJZtH
         a4rdsSOCujfuvLrKWm5seA+i865yF1MMiYrTka2IUgal23gYpta6d3KyFy7S7sCmVfMR
         GIH3eaW3zrfkNsVS0sNN9xjv1gQbJ5bcMvQQEJcQbvQBpOTIZHPR7WkTd4kwPLvhPuL7
         QbOGKGma+s7MXrcqFpksqZ+atQZzgMdzoXrUbq7d9QMraJMscIoa2LbzGVDyeydUO0G/
         QEAp5un92Sk1Dqz0CjOvWlNubDSn/IZL1V6FK6iGVGqJA+h8JboGPTJNwzb/yhz9rWNh
         2qdg==
X-Gm-Message-State: ACrzQf0jnQoWH6txXkLvIHS7Tm6Fcek5L2X/6DZUWPFpbmAV0wwXx19k
        DjapOQ5sbMgPjRGqZ4z7UfSgry83SOB1flUqmkMcuA==
X-Google-Smtp-Source: AMsMyM6udKO0mM416CuGNqHAwIob8j7/AVRQHFn1HV+/sWmesQmURFFmLUYUAP/MZg19xYHGWdzVHZOYi3AOvF4Mwuc=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr5412294oap.269.1663777431692; Wed, 21
 Sep 2022 09:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220920205922.1564814-1-jmattson@google.com> <Yyot34LGkFR2/j5f@zn.tnic>
 <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
 <YyrZOLq8z+lIORvP@zn.tnic> <CALMp9eRG6g-95zCxTD1NnxpZ+Vm6VMTA0_uaHV=b-hDkeOYSuA@mail.gmail.com>
 <YysXeXKY36yXj68q@zn.tnic> <CALMp9eTuO79+NfHxLi8FnqdOpzXO7eQUntvN23EfR+shg+wg2Q@mail.gmail.com>
 <Yys2ikzV73upzlEj@zn.tnic>
In-Reply-To: <Yys2ikzV73upzlEj@zn.tnic>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Sep 2022 09:23:40 -0700
Message-ID: <CALMp9eQ-qkjBm8qPhOaMzZLWeHJcrwksV+XLQ9DfOQ_i1aykqQ@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 9:06 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Sep 21, 2022 at 08:11:29AM -0700, Jim Mattson wrote:
> > Yes, after the revert, KVM will treat the bit as reserved, and it will
> > synthesize a #GP, *in violation of the architectural specification.*
>
> Architectural, schmarchitectural... Intel hasn't implemented it so meh.
>
> > KVM can't just decide willy nilly to reserve arbitrary bits. If it is
> > in violation of AMD's architectural specification, the virtual CPU is
> > defective.
>
> Grrr, after your revert that this bit was *only* reserved and nothing
> else to KVM. Like every other reserved bit in EFER. Yeah, yeah, AMD
> specified it as architectural but Intel didn't implement it so there's
> this thing on paper and there's reality...

AMD defined the 64-bit x86 extensions while Intel was distracted with
their VLIW science fair project. In this space, Intel produces AMD64
compatible CPUs. The definitive specification comes from AMD (which is
sad, because AMD's documentation is abysmal).

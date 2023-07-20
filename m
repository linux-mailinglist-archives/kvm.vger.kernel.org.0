Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70B775A577
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 07:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjGTF0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 01:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGTF0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 01:26:17 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE07B6;
        Wed, 19 Jul 2023 22:26:15 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-579dfae6855so4907637b3.1;
        Wed, 19 Jul 2023 22:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689830775; x=1690435575;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hCxDK9VUPIDMrMu5ej3bfQ9eGHY6r4R51jPQ7myjstE=;
        b=U6Izhqpw692FvYENjOF4P81Id8HtA76Q8GXLE1AEZfZVV0v7bA6AYkbn70rCXgTisZ
         jxfYKVjDPCRjHVHwffgeoFfKkqM3qYM0zhBXqGmD2IgjYLH8EG8svsghoN95rSYev4UO
         ZHmJ6c4701FiMW3IjVQXgJ1KwQF+zfuJuEz9840B6gxZr15C8Re/WxkjZDujOgvSErCY
         aOt0HU3SYwrwWph9ys631/Tab7Ldxy8ubWf4wB2wrgESeNki10pxliJFfU5m8g60mDj/
         +zC4I8e+7TJ3X2R9UAqN3YG3dq4G6EnN2YUebzsWIaJU5gqSA1p7P1gh+ORFZU0U2DH/
         pW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689830775; x=1690435575;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hCxDK9VUPIDMrMu5ej3bfQ9eGHY6r4R51jPQ7myjstE=;
        b=J77e1V1X1/b/4hZxVU9b7wlSKU5aPlzJCSSih9coEzSXHT9Omven9rPgEE8wFJ2BZg
         GXZGsdvAT2zwTzWfy7ctlZwRVl1zwdThqpeELlTAHIgPDab8YXW/ljcgzTIilm4HmqFd
         SnQv28rPXbL87xephx8RAerutxqE47mtIG4bJyfGDTA1jHo5mc9dKOPjp0vb6rGh+H40
         fmCKnKzfXTCeJBSr5VN5JHsjw5xpJYvIVOHpfEPUfiN+mCLEfWhIpoK5f3x5bdtf+YDD
         H6Rpk/nU3q8UlOFiQOhYdCk1ngph+fS8B1P/e0sfSD3+LbJ1nZB8ghE+kbKGEgRIe454
         p46A==
X-Gm-Message-State: ABy/qLZIMJxIrxiZm2CVmmSuuU2l6CmMJVXdbAb/73AuGfLKHtXbvSCE
        WClF68qK8Ai+ExV2zIUUYL2dgRLyaXxW02gBmjY=
X-Google-Smtp-Source: APBJJlGWVyvJw7CAZ8s9rVM4E5+H2on70fP2tQpiaVWhPmkxYVCZepfRhHCQVOrqc8aWAhoYRUws44ohPSittecYMSI=
X-Received: by 2002:a81:8315:0:b0:579:f5e3:ad07 with SMTP id
 t21-20020a818315000000b00579f5e3ad07mr5017768ywf.14.1689830774906; Wed, 19
 Jul 2023 22:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com> <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com> <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com> <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
 <ZLg8ezG/XrZH+KGD@google.com> <20230719203658.GE3529734@hirez.programming.kicks-ass.net>
In-Reply-To: <20230719203658.GE3529734@hirez.programming.kicks-ass.net>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 20 Jul 2023 07:26:04 +0200
Message-ID: <CAM9Jb+hkbUpTNy-jqf8tevKeEsQjhkpBtD5iESSoPsATVfA9tg@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
        binbin.wu@linux.intel.com, rick.p.edgecombe@intel.com,
        john.allen@amd.com, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > My understanding is that PL[0-2]_SSP are used only on transitions to the
> > corresponding privilege level from a *different* privilege level.  That means
> > KVM should be able to utilize the user_return_msr framework to load the host
> > values.  Though if Linux ever supports SSS, I'm guessing the core kernel will
> > have some sort of mechanism to defer loading MSR_IA32_PL0_SSP until an exit to
> > userspace, e.g. to avoid having to write PL0_SSP, which will presumably be
> > per-task, on every context switch.
> >
> > But note my original wording: **If that's necessary**
> >
> > If nothing in the host ever consumes those MSRs, i.e. if SSS is NOT enabled in
> > IA32_S_CET, then running host stuff with guest values should be ok.  KVM only
> > needs to guarantee that it doesn't leak values between guests.  But that should
> > Just Work, e.g. KVM should load the new vCPU's values if SHSTK is exposed to the
> > guest, and intercept (to inject #GP) if SHSTK is not exposed to the guest.
> >
> > And regardless of what the mechanism ends up managing SSP MSRs, it should only
> > ever touch PL0_SSP, because Linux never runs anything at CPL1 or CPL2, i.e. will
> > never consume PL{1,2}_SSP.
>
> To clarify, Linux will only use SSS in FRED mode -- FRED removes CPL1,2.

Trying to understand more what prevents SSS to enable in pre FRED, Is
it better #CP exception
handling with other nested exceptions?

Won't same problems (to some extent) happen in user-mode shadow stack
(and in case of guest, SSS inside VM)?

Thanks,
Pankaj

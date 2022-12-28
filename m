Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C69657162
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 01:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiL1APf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 19:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiL1APd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 19:15:33 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E86A466
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 16:15:32 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p6so7643766iod.13
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 16:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0nnP2nOMltREuugSAoOonbwMZSkILdgvupYi9aWzyto=;
        b=iNh7oGl0wg6z14ap/+yLyQGpmzBvEtdutnph9qg5DTp+3R/MK5Qhx8MLXRgcRRcjBl
         nROWk3lk8VOkFJc0oW3OZhKR5cnf27rYc7HvHNF+y+Y8whGkG6ZF9QhnaYWIASkFHR4w
         ArXY3NUQufurPEF7WOlCMMWTneLs5U5TOYTqlkrlpvNMt731/JdlEsHugE8N6Xy+TB7G
         eI7fwe4AOUWnDWxaZkVMc7JYKe9Yw/dfFBwB5CYGU8LId1Xkv8D2VWo6TQT/cuiJlifK
         IlrDKe0th4rk8+aQdzer3aI7VDWisVaFCLSjWtcsumOoZBXUm00xF1+f/yazuT4iqwHe
         3z1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0nnP2nOMltREuugSAoOonbwMZSkILdgvupYi9aWzyto=;
        b=IEWqjeGPHpjVN+QQ04Q2HeUqgvV6H0wjJdIf6KOUfWO9vHYQ4nXUOrwhFGT1SYv30L
         Gc4h1eLl2vhTF+1o8Cp1xP+lEtxkvszsBI6wODPOI0n+Cu0sLsN7YxFEg8U4DqmSaStn
         Yzgoz6F1SE6Is1wAi4zaN2kKKrPwQdcFoqJVlo/t6XAijVUxv9ddwOxoJiBBKK9Gc0tH
         gi41KJRPzJVkfLMOJwlAymuTb9xDSDOniak/ejjGTJRzGzNJy3V1jXndCdDxw/wBBpZ8
         kH3LHmSBFn7u9NNcQyLaFA0ngGM9pHJTGyrvOHxejluW230vxxt3/owq25FG9iNKkgMj
         1F3w==
X-Gm-Message-State: AFqh2koFCGPFLVjiuZ+IfEm2pNaF/8OCOpO+fr3sLXaJdZPr/UeH0u1L
        BqJ3IhfhBkiGHA7uUNtF8cSC0Ls9CdEsHL3rRhC5TA==
X-Google-Smtp-Source: AMrXdXsp7najYhTnO1hCCzCp6cfNbf91LkEUtBfB8hHhkrYO/wvyXy6sTDja/9swT2/UNZCa0soczE415hS/y+Nl47g=
X-Received: by 2002:a02:340b:0:b0:38a:2499:c04b with SMTP id
 x11-20020a02340b000000b0038a2499c04bmr1893144jae.72.1672186532100; Tue, 27
 Dec 2022 16:15:32 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com> <20221227183713.29140-4-aaronlewis@google.com>
 <CALMp9eQD8EpS50A0iAxsoaW-_yFmWERWw6rbAh9VSEJjDrMkNQ@mail.gmail.com>
In-Reply-To: <CALMp9eQD8EpS50A0iAxsoaW-_yFmWERWw6rbAh9VSEJjDrMkNQ@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 28 Dec 2022 00:15:20 +0000
Message-ID: <CAAAPnDEP0jTUyNPss4EnYrz_f4u36aCHZP-vR77cKNBL0rYeBA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Add XCR0 Test
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

> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +
> > +#define XFEATURE_MASK_SSE              (1ul << 1)
> > +#define XFEATURE_MASK_YMM              (1ul << 2)
> > +#define XFEATURE_MASK_BNDREGS          (1ul << 3)
> > +#define XFEATURE_MASK_BNDCSR           (1ul << 4)
> > +#define XFEATURE_MASK_OPMASK           (1ul << 5)
> > +#define XFEATURE_MASK_ZMM_Hi256                (1ul << 6)
> > +#define XFEATURE_MASK_Hi16_ZMM         (1ul << 7)
> > +#define XFEATURE_MASK_XTILECFG         (1ul << 17)
> > +#define XFEATURE_MASK_XTILEDATA                (1ul << 18)
> > +#define XFEATURE_MASK_XTILE            (XFEATURE_MASK_XTILECFG | \
> > +                                        XFEATURE_MASK_XTILEDATA)
>
> With XSETBV hoisted into processor.h, shouldn't these macros be more
> widely available as well?

Sure, I'll hoist them up there too.

>
> > +static uint64_t get_supported_user_xfeatures(void)
> > +{
> > +       uint32_t a, b, c, d;
> > +
> > +       cpuid(0xd, &a, &b, &c, &d);
> > +
> > +       return a | ((uint64_t)d << 32);
> > +}
> > +
> > +       GUEST_ASSERT(xcr0_rest == 1ul);
> > +
> > +       /* Check AVX */
> > +       xfeature_mask = XFEATURE_MASK_SSE | XFEATURE_MASK_YMM;
> > +       supported_state = supported_xcr0 & xfeature_mask;
> > +       GUEST_ASSERT(supported_state != XFEATURE_MASK_YMM);
> > +
> > +       /* Check MPX */
> > +       xfeature_mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> > +       supported_state = supported_xcr0 & xfeature_mask;
> > +       GUEST_ASSERT((supported_state == xfeature_mask) ||
> > +                    (supported_state == 0ul));
> > +
> > +       /* Check AVX-512 */
> > +       xfeature_mask = XFEATURE_MASK_OPMASK |
> > +                       XFEATURE_MASK_ZMM_Hi256 |
> > +                       XFEATURE_MASK_Hi16_ZMM;
> > +       supported_state = supported_xcr0 & xfeature_mask;
> > +       GUEST_ASSERT((supported_state == xfeature_mask) ||
> > +                    (supported_state == 0ul));
> > +
> > +       /* Check AMX */
> > +       xfeature_mask = XFEATURE_MASK_XTILE;
> > +       supported_state = supported_xcr0 & xfeature_mask;
> > +       GUEST_ASSERT((supported_state == xfeature_mask) ||
> > +                    (supported_state == 0ul));
>
> In this series, you've added code to __do_cpuid_func() to ensure that
> XFEATURE_MASK_XTILECFG and XFEATURE_MASK_XTILEDATA can't be set unless
> the other is set. Do we need to do something similar for AVX-512 and
> MPX?

That does sound like a natural extension of this.  I can add support
for that in v2.

>
> > +       GUEST_SYNC(0);
> > +
> > +       xsetbv(0, supported_xcr0);
> > +
> > +       GUEST_DONE();
> > +}
> > +
> > +static void guest_gp_handler(struct ex_regs *regs)
> > +{
> > +       GUEST_ASSERT(!"Failed to set the supported xfeature bits in XCR0.");
> > +}
> > +

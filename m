Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5280A656E7E
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 21:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiL0UBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 15:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0UBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 15:01:01 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59D8C0A
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:01:00 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id i26-20020a9d68da000000b00672301a1664so8757416oto.6
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 12:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4VAL3DeAX58VLHn/2RTmElxk6IH1Cdb+7IOYdSiiefI=;
        b=DQNZ8yhk3dcKcmDA9aLCpeGKFZU6W5omKAAIjeVci6YzuNWY1eWHkN5VWH2T5lomvx
         7NGx7C+Q/craZcONT5TIb4gjQcU+qVti+Mxil9wTHgdKBmkeHJW3TlN+01yW8Ftn7R2S
         pSsunIWB/wM6orthABAx9o7QCFBdfbftcJ93A6qvT2n8lysRRU7XnDE5HEF+Lr42EZUn
         k2Yv2qk9QkeJC8kMdmHplNT1p6isHJyCyViDt7zOouChi6r8FetXS713Z4LEGjaHd+To
         jlbBgYo2Fpey1PzII7ALrc1ipOBjJ0Xice/7CeAzU9zcGAkrktW3dJrSYoBiD0VOhHTz
         tDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4VAL3DeAX58VLHn/2RTmElxk6IH1Cdb+7IOYdSiiefI=;
        b=7V3DxApdGm/LwWet7/CVaua9QzQI80TFME0vUoUMTLp+nhNo+y5OctW7pwmO3WR5rp
         vf+QliYgi4v+KmnmPiZBSxvAFbwf7Tkbl3T5CTnxuKgJcKi3qBWFq2Nx8O0q2UFzJhiX
         8pnKViZorXx9DBpm3WYmo2Mb2iwsxu6g8QvGsPshgBTCG09eAdccQac4ka8GNtoit4aR
         +ueeCYNkFbDUk71O4wOSGjcIIClGjlbkhp7Yy0loGFY/M43QoCcmaMk2Fg+Ryfk9SiLw
         uZdolmT7JFdI2RLpqybsRSMCfFIVN3t7S4/LRv+rVKlsveOf7dGPUbs8pj/xQ7+b7j3M
         BXbw==
X-Gm-Message-State: AFqh2kqWheIDm7/P/nAs+jFWAE85ljPFoH1gTGxxJ2tu2AYVGjnlEuzl
        3F8Sy+ov4Y1bRpMS361csT02PZbPZErnwYTIe+9qpg==
X-Google-Smtp-Source: AMrXdXvq0gajIyjneJ9tPOfCxdmhveWkGGSmozLyTWruI7uPfOUJ4/VPZChL4pFA2Gn4TS71NQ7VMLeNADekxkaA5hE=
X-Received: by 2002:a05:6830:14d5:b0:678:1d9f:20c9 with SMTP id
 t21-20020a05683014d500b006781d9f20c9mr1269302otq.45.1672171259996; Tue, 27
 Dec 2022 12:00:59 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com>
In-Reply-To: <20221227183713.29140-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Dec 2022 12:00:49 -0800
Message-ID: <CALMp9eRe+8ypPXVvR5cwRT7YeuXFtT2HjiyGOU9a1U5WjoD0Pw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Clean up AMX cpuid bits XTILE_CFG and XTILE_DATA
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

On Tue, Dec 27, 2022 at 10:38 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> When running a SPR guest without AMX enabled

Can you clarify what "without AMX enabled" means? Do you mean that
userspace hasn't opted in to AMX via arch_prctl()?

> CPUID.(EAX=0DH,ECX=0):EAX.XTILE_CFG[bit-17] will be set and
> CPUID.(EAX=0DH,ECX=0):EAX.XTILE_DATA[bit-18] will be clear.  While this
> is architecturally correct it can be a little awkward for userspace
> or a guest when using them.  Instead of leaving the CPUID leaf in a
> half baked state, either clear them both or leave them both set.
>
> Additionally, add testing to verify the CPUID isn't in such a state.
>
> Aaron Lewis (3):
>   KVM: x86: Clear XTILE_CFG if XTILE_DATA is clear
>   KVM: selftests: Hoist XGETBV and XSETBV to make them more accessible
>   KVM: selftests: Add XCR0 Test
>
>  arch/x86/kvm/cpuid.c                          |   4 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/processor.h  |  19 +++
>  tools/testing/selftests/kvm/x86_64/amx_test.c |  24 +---
>  .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 134 ++++++++++++++++++
>  5 files changed, 161 insertions(+), 21 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
>
> --
> 2.39.0.314.g84b9a713c41-goog
>

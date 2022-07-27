Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCCB582A10
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 17:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbiG0P4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 11:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiG0P4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 11:56:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B8F2B180
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 08:56:50 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i8so2111874wro.11
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 08:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R+iHvXmGgVaJk0aTh2lYJmpaG/4QQy4FTMp2abmiQFI=;
        b=ou6drcieFoAL/2jVRHRvVPeGXUiZrIcxmlxj02X4BKD5PU9TSwkz5pldwQqFmKeq28
         eSpeM8YdOdCwYCYQjPbCBCiULep9PWCMgm2bEKsLlP0o7m4kRO1BT5H3HWDmuBLBbrah
         UP1y2wk3TbO9ap4H0rQtVvsxiyvc87i5GehoQAkgmH+l9YSRdFLM2BaaI9PmitoBT+x4
         9ihGde66eQDgfwbdvT7Jgiv86rHIPRC7VXlvzS3w4ZD6nCUgj+OkmDNirdiX8a0+11tq
         PrL2RL7QVhmD/hi/cVS09E78jmRv/Zl/dQ12esYwyhLqT7+0jnanJx2d2cZTKB5ClqMT
         W1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R+iHvXmGgVaJk0aTh2lYJmpaG/4QQy4FTMp2abmiQFI=;
        b=D1AljSy3u+WV0DZumE4nPzZouMKCbp73XoJoMM0KlJ3C50OWARz/YErL8ml441hpAQ
         bynS5ji6va06p8/VJ0SXelJZey0Gxip4Z3XsSdaHdES6+mFL6zGrR2iYaIn6N53yYpm/
         dYGkQ6STXz3De1VgW/H442py2WsIm5RQcov2g56wMbQELzr9lxZxQa3gG6iyYF3Rluh/
         jhZEdfGGmAWRHPPHgeiqyHKfvJ7In1pFdObUa9PTwpZwQaatPhublqNFwOQNcwzwFwFa
         /OpuWdFhtHaYGtENyCXnr9QpHoj76fw3T+9R90+ju8VzKY8yPdNjBW56Ov5d8e/TDYg8
         mAHA==
X-Gm-Message-State: AJIora8PWsIHWNlmMcmX6fnAzEhCIuiJbGD+AspQavpUZH8+Z4LvZPbg
        U/cIt4Uspt7ChYgfKIhZ6arLShAXEtLFkgdChz7nnw==
X-Google-Smtp-Source: AGRyM1stHHn7Piw8GeQ+7b5ehtj7eu1dtqVUc5aek0kwLB+Q7n1iOV/shAexJBJLvMhuZfljNNCjn5b56S32LIlqvvM=
X-Received: by 2002:a05:6000:508:b0:21d:4105:caf9 with SMTP id
 a8-20020a056000050800b0021d4105caf9mr15132968wrf.699.1658937408834; Wed, 27
 Jul 2022 08:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220726073750.3219117-18-kaleshsingh@google.com> <20220727142906.1856759-1-maz@kernel.org>
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
From:   Kalesh Singh <kaleshsingh@google.com>
Date:   Wed, 27 Jul 2022 08:56:37 -0700
Message-ID: <CAC_TJvc6TPin-B-pQ7g-doMUUH5Eywo5GF5crGBmWoD=G2yBxA@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: arm64: nVHE stack unwinder rework
To:     Marc Zyngier <maz@kernel.org>
Cc:     "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Marco Elver <elver@google.com>, Keir Fraser <keirf@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Oliver Upton <oupton@google.com>,
        "Cc: Android Kernel" <kernel-team@android.com>
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

On Wed, Jul 27, 2022 at 7:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi all,
>
> As Kalesh's series[1] already went through quite a few rounds and that
> it has proved to be an extremely useful debugging help, I'd like to
> queue it for 5.20.
>
> However, there is a couple of nits that I'd like to address:
>
> - the code is extremely hard to follow, due to the include maze and
>   the various levels of inline functions that have forward
>   declarations...
>
> - there is a subtle bug in the way the kernel on_accessible_stack()
>   helper has been rewritten
>
> - the config symbol for the protected unwinder is oddly placed

Hi Marc,

Thanks for doing this rework.

For the series:
Reviewed-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: Kalesh Singh <kaleshsingh@google.com>

Thanks,
Kalesh

>
> Instead of going for another round and missing the merge window, I
> propose to stash the following patches on top, which IMHO result in
> something much more readable.
>
> This series directly applies on top of Kalesh's.
>
> [1] https://lore.kernel.org/r/20220726073750.3219117-1-kaleshsingh@google.com
>
> Marc Zyngier (5):
>   KVM: arm64: Move PROTECTED_NVHE_STACKTRACE around
>   KVM: arm64: Move nVHE stacktrace unwinding into its own compilation
>     unit
>   KVM: arm64: Make unwind()/on_accessible_stack() per-unwinder functions
>   KVM: arm64: Move nVHE-only helpers into kvm/stacktrace.c
>   arm64: Update 'unwinder howto'
>
> Oliver Upton (1):
>   KVM: arm64: Don't open code ARRAY_SIZE()
>
>  arch/arm64/include/asm/stacktrace.h        |  74 -------
>  arch/arm64/include/asm/stacktrace/common.h |  69 ++-----
>  arch/arm64/include/asm/stacktrace/nvhe.h   | 125 +-----------
>  arch/arm64/kernel/stacktrace.c             |  90 +++++++++
>  arch/arm64/kvm/Kconfig                     |  24 ++-
>  arch/arm64/kvm/Makefile                    |   2 +-
>  arch/arm64/kvm/handle_exit.c               |  98 ---------
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c       |  55 +++++-
>  arch/arm64/kvm/stacktrace.c                | 218 +++++++++++++++++++++
>  9 files changed, 394 insertions(+), 361 deletions(-)
>  create mode 100644 arch/arm64/kvm/stacktrace.c
>
> --
> 2.34.1
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF7B64AD2A
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 02:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbiLMBhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 20:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbiLMBhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 20:37:19 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1FA1D664
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:37:09 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so1901702pjj.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iJwqdDN1RvNeTFiZyaSzmASJkDq0+IG5uFFQ0Vq+pIE=;
        b=UOLR4/D4l8GUzElS0sejD2JapJwiXXo2meP6+lJ4UUi6Oj9CCz+E9FE2qBHGrI7Utw
         7OokGhkdZbKxc3Ctt6ZZXN0i35uOg0peSR+0R+WVwqWr9OVFPJSib+WjKq5pQzui/58i
         Y8s1Y27VjQTtgwC7o5gYdWnjHddNTpRNWzMaZm5tNwUVmLRfMdVKxsEBBWh6ITeGtOW7
         gXOTqvopxiSjsYbG5ApbWUNiAL3dozmKHp10byFJU92ZP4hQWonUzETTShKtTRFN2+Hf
         tAOTXVSSNORLHBQ3eDPsuPXE6+G5eltxPXeLQCSKhU6J5/WfdMsaHX1ArV2nqpfebXr2
         dRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJwqdDN1RvNeTFiZyaSzmASJkDq0+IG5uFFQ0Vq+pIE=;
        b=FDyzcSXZ3z+RvL7qj9kLNU6I7VpEuIFGaN72ioHv0uNN+sXzv8w5m5yYPCjv05asWj
         xQxn81Ckt5/LDBH60En2CdmVSLRHSvt1ekkzUYnF72J51MqDg0xZjAB5sWPBM+Np+zkc
         /Oq3o4PfFTWtjkkpCMnmCnScHkX+VzX2+adJQyzArGwhcwBC1T8lq47zEZhR+B/NQRBd
         GKAxYZq8GV48yimliGV7PvEYh9k71RGGbZ2vFN3mskaFhDbEh6/IGJWnzXc1vNyvwy61
         sH7UzsPLEmECwm5Uu6osl2cl8RQnSOPuKlv147y6+UJ0cMH5vdOh2pQtfrh2gwlN0SqF
         REcQ==
X-Gm-Message-State: ANoB5pnN3jlc0mj3Jm20Qr3GOFxZrDNaHbm+Ax73jJ78TT24hNwWl7ma
        bddJC15Ecxt/Mbm5KBhi7uLcZD2l3a9BxOeh5dYMiQ==
X-Google-Smtp-Source: AA0mqf59hLKHWHycEAofu9/939ZBb87HK2lBuOCJYN0Zs3K9cbu8MbXmw0OtELFZfn97VUt5D/c7xWXV2p8gd3eTyxg=
X-Received: by 2002:a17:902:f092:b0:189:9b43:a082 with SMTP id
 p18-20020a170902f09200b001899b43a082mr45842703pla.95.1670895428992; Mon, 12
 Dec 2022 17:37:08 -0800 (PST)
MIME-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com> <20221213001653.3852042-12-seanjc@google.com>
In-Reply-To: <20221213001653.3852042-12-seanjc@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Dec 2022 17:36:58 -0800
Message-ID: <CAKwvOdnRQQb9YbH=MgDymBmmjYgajc8tkyjbJVxjpA5zDZpNTQ@mail.gmail.com>
Subject: Re: [PATCH 11/14] KVM: selftests: Disable "gnu-variable-sized-type-not-at-end"
 warning
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

On Mon, Dec 12, 2022 at 4:17 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Disable gnu-variable-sized-type-not-at-end so that tests and libraries
> can create overlays of variable sized arrays at the end of structs when
> using a fixed number of entries, e.g. to get/set a single MSR.
>
> It's possible to fudge around the warning, e.g. by defining a custom
> struct that hardcodes the number of entries, but that is a burden for
> both developers and readers of the code.
>
> lib/x86_64/processor.c:664:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> lib/x86_64/processor.c:772:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> lib/x86_64/processor.c:787:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> 3 warnings generated.
>
> x86_64/hyperv_tlb_flush.c:54:18: warning: field 'hv_vp_set' with variable sized type 'struct hv_vpset'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>         struct hv_vpset hv_vp_set;
>                         ^
> 1 warning generated.
>
> x86_64/xen_shinfo_test.c:137:25: warning: field 'info' with variable sized type 'struct kvm_irq_routing'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>         struct kvm_irq_routing info;
>                                ^
> 1 warning generated.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 2487db21b177..9cff99a1cb2e 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -196,6 +196,7 @@ else
>  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
>  endif
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> +       -Wno-gnu-variable-sized-type-not-at-end \

This is a clang-specific warning. This will need to be wrapped in a
cc-option check.

tools/build/Build.include seems to redefine that make macro, so be
sure to test it first.

>         -fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
>         -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>         -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
>


-- 
Thanks,
~Nick Desaulniers

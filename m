Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7326D437D
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 13:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjDCL2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 07:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjDCL2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 07:28:41 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DA4B44F
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 04:28:39 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id y14so28996942wrq.4
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 04:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680521317;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kbcceqI+2pKpuXfzcAGNVPpZeOMu2CsxP+dsznNa4l8=;
        b=Z3adzZ362LMcVsF9ahhS3xhjeZ3BKz8Dw561S5ke8kCI7L2IYHFiHh475BI8kZLLRF
         gHnZPZ0pAeUFm2Cn4ujcUGG6TCgg915fhYdp8fcXE8EC5wgEnq3h+DE0+9YICCOKgPPP
         pm87/5Uw0wFvvmIGyZyWyY3kpCC2F8RLYUbf7gtKWHI4jPuTFPApzeaVW/ChU8cfaA5F
         ccPZd4KXGS+rVjXgHYeZ+tPo7mWc3Ay1cGRcdCTkgn7L4lgTyz3Vf8Ce/24o2DymoTyR
         tlG0EVqHXUuTZkfRAw7K2aadXBF+soKv04+cn8reR7kdekDFwK41xk1v+SWSPQx0YKoq
         BeHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680521317;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kbcceqI+2pKpuXfzcAGNVPpZeOMu2CsxP+dsznNa4l8=;
        b=t+zfQnlRS62cj7n0ySv/70JVXQkkYdbLszlIE3R96mxBbtAYJT5bnNi/78o8Tgi2/I
         FWQngWYb1PegO15yrNTVllCuTaE6BMDvk+fOJryz4CYBWsM0sLDmM0R1zaWBlOjrxJ2A
         ZA0pbBC4phCkavQqqB32nBaGKN/hrPxeOldsgl2IxUyXjuDkIj4u7of9ijm2BnKt/4pZ
         nZdkQ6K+yRzgxrPegZzXKrUMsTqPJyUK90AIF4Y+XLCOYVa1Zs4SseopZ4chvDRxKXKd
         X032QlF4G+XUTmWA1AuthuC35VwFvZ3FGrM8KN2qZPbCV0jj8QVL6PNd+Y41vZLoIg9j
         IJfg==
X-Gm-Message-State: AAQBX9eADUEAetmjzDM6N3EqBkQ9Fyr1gFF/wW5ff9JdpytJfCrFQ8EF
        hp+UiYVb2FSE3SYZ2Og88dlHx9/kXrw7mLEJh2uaHg==
X-Google-Smtp-Source: AKy350YAh+na9aQjLXnf4GF/VDPY3OKi2qJsvqFuk0EwPsm4rnjU2+sKJynG6DQDHLyp8u/QORxq6Q==
X-Received: by 2002:adf:e748:0:b0:2e5:8874:d883 with SMTP id c8-20020adfe748000000b002e58874d883mr8583060wrn.8.1680521317558;
        Mon, 03 Apr 2023 04:28:37 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:1600:2f4c:bf50:182f:1b04? (p200300f6af2216002f4cbf50182f1b04.dip0.t-ipconnect.de. [2003:f6:af22:1600:2f4c:bf50:182f:1b04])
        by smtp.gmail.com with ESMTPSA id e38-20020a5d5966000000b002d78a96cf5fsm9591452wri.70.2023.04.03.04.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 04:28:37 -0700 (PDT)
Message-ID: <dc285a74-9cce-2886-f8aa-f10e1a94f6f5@grsecurity.net>
Date:   Mon, 3 Apr 2023 13:28:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation
 support
Content-Language: en-US, de-DE
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>
References: <20230403105618.41118-1-minipli@grsecurity.net>
 <20230403105618.41118-4-minipli@grsecurity.net>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230403105618.41118-4-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.04.23 12:56, Mathias Krause wrote:
> Add support to enforce access tests to be handled by the emulator, if
> supported by KVM. Exclude it from the ac_test_exec() test, though, to
> not slow it down too much.

I tend to read a lot of objdumps and when initially looking at the
generated code it was kinda hard to recognize the FEP instruction, as
the FEP actually decodes to UD2 followed by some IMUL instruction that
lacks a byte, so when objdump does its linear disassembly, it eats a
byte from the to-be-emulated instruction. Like, "FEP; int $0xc3" would
decode to:
   0:	0f 0b                	ud2
   2:	6b 76 6d cd          	imul   $0xffffffcd,0x6d(%rsi),%esi
   6:	c3                   	retq
This is slightly confusing, especially when the shortened instruction is
actually a valid one as above ("retq" vs "int $0xc3").

I have the below diff to "fix" that. It adds 0x3e to the FEP which would
restore objdump's ability to generate a proper disassembly that won't
destroy the to-be-emulated instruction. As 0x3e decodes to the DS prefix
byte, which the emulator assumes by default anyways, this should mostly
be a no-op. However, it helped me to get a proper code dump.

If there's interest, I can send a proper patch. If not, this might help
others to understand garbled objdumps involving the FEP ;)

--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -104,6 +104,7 @@ typedef struct  __attribute__((packed)) {

 /* Forced emulation prefix, used to invoke the emulator unconditionally. */
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+#define KVM_FEP_PRETTY KVM_FEP ".byte 0x3e;"
 #define ASM_TRY_FEP(catch) __ASM_TRY(KVM_FEP, catch)

 static inline bool is_fep_available(void)
diff --git a/x86/access.c b/x86/access.c
index eab3959bc871..ab1913313fbb 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -811,7 +811,7 @@ static int ac_test_do_access(ac_test_t *at)
                asm volatile ("mov $fixed2, %%rsi \n\t"
                              "cmp $0, %[fep] \n\t"
                              "jz 1f \n\t"
-                             KVM_FEP
+                             KVM_FEP_PRETTY
                              "1: mov (%[addr]), %[reg] \n\t"
                              "fixed2:"
                              : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
@@ -838,12 +838,12 @@ static int ac_test_do_access(ac_test_t *at)
                      "jnz 1f \n\t"
                      "cmp $0, %[fep] \n\t"
                      "jz 0f \n\t"
-                     KVM_FEP
+                     KVM_FEP_PRETTY
                      "0: mov (%[addr]), %[reg] \n\t"
                      "jmp done \n\t"
                      "1: cmp $0, %[fep] \n\t"
                      "jz 0f \n\t"
-                     KVM_FEP
+                     KVM_FEP_PRETTY
                      "0: mov %[reg], (%[addr]) \n\t"
                      "jmp done \n\t"
                      "2: call *%[addr] \n\t"


Thanks,
Mathias

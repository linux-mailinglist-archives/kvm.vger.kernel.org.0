Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43FD58AA56
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238049AbiHELuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 07:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiHELuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 07:50:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60E064BD01
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 04:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659700206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VB+wZX4czUIneiXsFWS1r94G+mlqIsZGN1WlJ2Gc89s=;
        b=RJeldPosA7Ndc5YZ/xfgg2nG44fsQ8+fhovgeSzSxIypugu6IXZ+P4voOWzXEuXKNChuqK
        hMdTr6gM3YWlUhgo/+BV2XBK8WuMHofh+mI0vyeGrG5kaDNKSG84tzeooPW3XLDWSpO0kF
        5xVyBpw5IXMcC5yn+xB3yFfQe9wD3HE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-YTRVztYGMranoYne9Lmidw-1; Fri, 05 Aug 2022 07:50:03 -0400
X-MC-Unique: YTRVztYGMranoYne9Lmidw-1
Received: by mail-ej1-f71.google.com with SMTP id nc38-20020a1709071c2600b007309af9e482so1137060ejc.2
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 04:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VB+wZX4czUIneiXsFWS1r94G+mlqIsZGN1WlJ2Gc89s=;
        b=DkHhxjWrKAnNTEoWm7WSmfRnaZ2Qt32zh6QWZnZkU+koLVKiChJAXPpdKCToz9jm4f
         64p6sQM6ek+2V0JNSESBAKTpsmrJXNXfQ2THawM+6waJWFXWD5vV6BeIQmoTBr4fM99K
         QF3XCbf+JH0wc9xEjYDuGsuQuVNpMVF58BN8Eyw4kSf7PzDZT8zWP82gokAdGH/IvgKe
         VqdeYDt+efupRelRFoZ6mSXttBQ9z8LZGXqCf4VUrc46+Xl7xC3Z5OsKd73LeXYjXx3l
         dhpGF9FiTKBoeqAScl4SLKTcdBUPZs8f0BPCCKQEb352pBOQ+NfV1bpuweq4R+OnJoRB
         AYRA==
X-Gm-Message-State: ACgBeo24OKXiowqRfA9MI+Ub+7qSEEIec8BM5szEATi26NNnuKzxxcf2
        9r9PxPJpydkY3ui74VpqwXLTFni3HWKjY7cmpFBR6TBoDDKAOwGvGXXszrcIB0dOu+xCWHl1JJ6
        CIthZsXBiOAjf
X-Received: by 2002:a17:906:dc90:b0:72f:c504:45c with SMTP id cs16-20020a170906dc9000b0072fc504045cmr5033086ejc.386.1659700202155;
        Fri, 05 Aug 2022 04:50:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR49r0X1ME51F4w0wTcquJPOGKMjaedea4wgdCSxYdo15mZ+VIVx6YgNv8K2DBKlB6MTnm03Ow==
X-Received: by 2002:a17:906:dc90:b0:72f:c504:45c with SMTP id cs16-20020a170906dc9000b0072fc504045cmr5033077ejc.386.1659700201921;
        Fri, 05 Aug 2022 04:50:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l18-20020a1709063d3200b006fee98045cdsm1536734ejf.10.2022.08.05.04.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 04:50:01 -0700 (PDT)
Message-ID: <9109bc62-a56d-0c6f-3326-3e43fc9ac6a1@redhat.com>
Date:   Fri, 5 Aug 2022 13:50:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH 4/4] x86: Extend ASM_TRY to handle #UD
 thrown by FEP-triggered emulator
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
References: <Yum2LpZS9vtCaCBm@google.com> <20220803172508.1215-1-mhal@rbox.co>
 <20220803172508.1215-4-mhal@rbox.co> <Yuq7gMTpRqGlVdcW@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yuq7gMTpRqGlVdcW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/22 20:16, Sean Christopherson wrote:
>> While here, I've also took the opportunity to merge both 32 and 64-bit
>> versions of ASM_TRY() (.dc.a for .long and .quad), but perhaps there
>> were some reasons for not using .dc.a?
> This should be a separate patch, and probably as the very last patch in case dc.a
> isn't viable for whatever reason.  I've never seen/used dc.a so I really have no
> idea whether or not it's ok to use.

Yes, for now I'll squash this, which is similar to Michal's idea but 
using the trusty double underscore prefix:

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 2a285eb..5b21820 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -81,11 +81,12 @@ typedef struct  __attribute__((packed)) {
  } tss64_t;

  #ifdef __x86_64
-#define ASM_TRY(catch)			\
+#define __ASM_TRY(prefix, catch)	\
  	"movl $0, %%gs:4 \n\t"		\
  	".pushsection .data.ex \n\t"	\
  	".quad 1111f, " catch "\n\t"	\
  	".popsection \n\t"		\
+	prefix "\n\t"			\
  	"1111:"
  #else
  #define ASM_TRY(catch)			\
@@ -96,6 +97,8 @@ typedef struct  __attribute__((packed)) {
  	"1111:"
  #endif

+#define ASM_TRY(catch) __ASM_TRY("", catch)
+
  /*
   * selector     32-bit                        64-bit
   * 0x00         NULL descriptor               NULL descriptor
diff --git a/x86/emulator.c b/x86/emulator.c
index df0bc49..6d2f166 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -19,6 +19,7 @@ static int exceptions;

  /* Forced emulation prefix, used to invoke the emulator 
unconditionally. */
  #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+#define ASM_TRY_FEP(catch) __ASM_TRY(KVM_FEP, catch)

  struct regs {
  	u64 rax, rbx, rcx, rdx;
@@ -900,8 +901,8 @@ static void test_illegal_lea(void)
  {
  	unsigned int vector;

-	asm volatile (ASM_TRY("1f")
-		      KVM_FEP ".byte 0x8d; .byte 0xc0\n\t"
+	asm volatile (ASM_TRY_FEP("1f")
+		      ".byte 0x8d; .byte 0xc0\n\t"
  		      "1:"
  		      : : : "memory", "eax");


and the __ASM_SEL() idea can be sent as a separate patch.


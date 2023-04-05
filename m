Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5952F6D8B2E
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjDEXpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDEXpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:45:43 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EF56E82
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:45:41 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-500349a5139so4299244a12.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google; t=1680738339;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Kzqf201an38ArCTju9fdnnRDIzPUKA5H25bQRmA6lYA=;
        b=MmFH3Zf2aD4FRFjsu3xr8cxuOm2Ne8U8sdkhVR5NLMAywiZTfd2MwVx2GhT3rWHkM+
         pR9ZtMV3lQwVcgtvjp85kGVs+90wQRoHj2LpSL/AP8/ZOhq8VVLXPt2YLZ944CM4SE9q
         iit9vR853TWKK6S752NGOXKPiyoEHzWhcGtNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680738339;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kzqf201an38ArCTju9fdnnRDIzPUKA5H25bQRmA6lYA=;
        b=WbAnK6TVl9McxPisP2smytQYdQ7Ai8Ol6hfkJcQSGaKtQEXKjkSsoD+nSCjFdAZ9zF
         x0FdyRp9FCtcmpwpphj81YtkK27VvtafPFh5+o4+1se1G6/9PweECu7D5YMve8Pp3BeF
         42+JoF+XUYw+uceici0gz+56onRz6nn5JTHA6+qddQzQYVKj67d5m71h7TFZ6rSeuSq4
         CChepl27OquHCH4MCayrKYaXIB6sQRK6huS+NrTwMbxPBH/nFZnmbjsj4An6Jg78lmiT
         Ji3U22AB7AEUuWowMcZ/B41k+n6fYuvuOIdoh9HW7Rkf1DTSZQssUxXSQ4qLIWV7vB+C
         u6BA==
X-Gm-Message-State: AAQBX9cbgDeNSOelvNjknZWB3BR/utOOPqZw+KVde04kFfLx1jPH0pqa
        5x1rwo63Y3DtGswyxAGK6Ray+6Hc+Svq9S4pIDA=
X-Google-Smtp-Source: AKy350YCwHg6lOWS/NQyziUctmuLoShEo2Jl0H/kt3uyA/4hYAhlwuwBdMYrufJYRGZROr/W23Os0KviCW51xixVo/8=
X-Received: by 2002:a50:9e09:0:b0:4fb:7ccf:337a with SMTP id
 z9-20020a509e09000000b004fb7ccf337amr2002627ede.3.1680738339150; Wed, 05 Apr
 2023 16:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230327124520.2707537-1-npiggin@gmail.com> <20230327124520.2707537-11-npiggin@gmail.com>
In-Reply-To: <20230327124520.2707537-11-npiggin@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 5 Apr 2023 23:45:27 +0000
Message-ID: <CACPK8Xfpsn7QoSUCZM_z7yaG5hda409ZhehXyzsgEnwOXagNwQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests v3 10/13] powerpc: Add support for more
 interrupts including HV interrupts
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nick,

On Mon, 27 Mar 2023 at 12:55, Nicholas Piggin <npiggin@gmail.com> wrote:
>
> Interrupt vectors were not being populated for all architected
> interrupt types, which could lead to crashes rather than a message for
> unhandled interrupts.
>
> 0x20 sized vectors require some reworking of the code to fit. This
> also adds support for HV / HSRR type interrupts which will be used in
> a later change.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  powerpc/cstart64.S | 79 ++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 65 insertions(+), 14 deletions(-)
>
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S

> +handler_trampoline:
> +       mfctr   r0
> +       std     r0,_CTR(r1)
> +
> +       ld      r0, P_HANDLER(0)
> +       mtctr   r0
> +
> +       /* nip and msr */
> +       mfsrr0  r0

I tried building the tests on a power8 box with binutils 2.34 and gas complains:

powerpc/cstart64.S: Assembler messages:
powerpc/cstart64.S:337: Error: unrecognized opcode: `mfhsrr0'
powerpc/cstart64.S:340: Error: unrecognized opcode: `mfhsrr1'

It appears this mnemonic is only supported for power10 (and were only
added in binutils 2.36):

$ git grep -i mfhsrr
opcodes/ppc-opc.c:{"mfhsrr0",   XSPR(31,339,314), XSPR_MASK, POWER10,
 EXT,            {RS}},
opcodes/ppc-opc.c:{"mfhsrr1",   XSPR(31,339,315), XSPR_MASK, POWER10,
 EXT,            {RS}},

I replaced it with mfspr and the tests ran fine:

@@ -334,10 +338,10 @@ handler_htrampoline:
        mtctr   r0

        /* nip and msr */
-       mfhsrr0 r0
+       mfspr   r0, SPRN_HSRR0
        std     r0, _NIP(r1)

-       mfhsrr1 r0
+       mfspr   r0, SPRN_HSRR1
        std     r0, _MSR(r1)

Cheers,

Joel

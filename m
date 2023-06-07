Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AC57272FA
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjFGX3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjFGX3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:29:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA5E2683
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:29:21 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-258caf97a4eso4824a91.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686180561; x=1688772561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Il4eA7Xpqt9LrUsV5a0licRHCPGUr83rDIk37Ke/P4s=;
        b=nzGdQHk5IXpHb5JtzU4WFZWQxr6RfR1K5gc2YR22e0jgBQGaLL7AmC7AM61pEHM7hY
         ClTulBKrmhsTBzVTLCQJQgV995gcAav3UBcXeMShJZ1kKb8AOP4RCXh1+UUSYIJkJxYB
         w0c7SX/21dsoOiqSme1OY8zBdmeGMMG6zUMWpyHjbxy45ShDSGbQDL+5Ibr3c8pLKAro
         TFEqdMVgQyCpyVtbPvohtX7fO3zCrBD/bCz6dXeBzqngAK9qMzalyxROi8qZUZQ1E0xc
         BalkNxPVmF6kZfD7IFSqA4tyMqnGF40QJj3q4TJm/JF+gBCb/K33whJ6emDYjRaoFlOX
         y8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180561; x=1688772561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Il4eA7Xpqt9LrUsV5a0licRHCPGUr83rDIk37Ke/P4s=;
        b=T4IMrphwaFHVP9gmn8nojmMs6Famq2IBsn5sg/B6JPQAxA/gxoXuLu8njNTw+mP13g
         Arw6KU7gv5fq7sPAJQCNLVDWbjdN03WpW8UZOwns9l+iEw5Uq7ox21ZjTMz6xxe96YYT
         Z5Ny8tFKceV/7CEnr3TnsKgk1Ne+CBCTqSgXTO+7VzJoTSAmpJkQKkq6Z5DMKPcoGOrH
         1yuDY1Cnzrc9fVnhD3ELCQaaQQqR8UaVQyYvJjENw/YkdoiG2fMF2widAXc+8AqMp1sw
         A5V1EEx8qA6a0BRpAZbJNz8gTZLsfIGig9KVBFWdvXADc+MUMgK8wi9vER/iOfKsDL+v
         6jYA==
X-Gm-Message-State: AC+VfDyHjh/3dQz9Q1ZriTcEU3rLyvbUEWLdahq3WWp5hKW4/Jv2yCGB
        baV+vDKiVbxs3EC2V5/o23RCsEJ/Idc=
X-Google-Smtp-Source: ACHHUZ7+lLwdoilk+3aHfhgGaQZPjGnSdjEy6Fj84hpUa3JG74mmTbDygjWF/FuAAxQtTDDrvd55zS5ovUg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c306:b0:256:2b11:1c9f with SMTP id
 g6-20020a17090ac30600b002562b111c9fmr1814469pjt.6.1686180561107; Wed, 07 Jun
 2023 16:29:21 -0700 (PDT)
Date:   Wed,  7 Jun 2023 16:25:58 -0700
In-Reply-To: <20230406025117.738014-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230406025117.738014-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168617888523.1602036.1833500387937919302.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] x86: Add "safe" macros to wrap ASM_TRY()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 05 Apr 2023 19:51:12 -0700, Sean Christopherson wrote:
> Provide macros to wrap single instructions with ASM_TRY(), and to
> automagically report success/fault as appropriate.  In other words, make
> it easier to write code for testing (non)faulting instruction behavior.
> 
> Sean Christopherson (5):
>   x86: Add macros to wrap ASM_TRY() for single instructions
>   x86: Convert inputs-only "safe" instruction helpers to asm_safe()
>   x86: Add macros to wrap ASM_TRY() for single instructions with
>     output(s)
>   x86: Move invpcid_safe() to processor.h and convert to asm_safe()
>   x86: Move XSETBV and XGETBV "safe" helpers to processor.h
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/5] x86: Add macros to wrap ASM_TRY() for single instructions
      https://github.com/kvm-x86/kvm-unit-tests/commit/72e2642f2aaf
[2/5] x86: Convert inputs-only "safe" instruction helpers to asm_safe()
      https://github.com/kvm-x86/kvm-unit-tests/commit/b470217dd120
[3/5] x86: Add macros to wrap ASM_TRY() for single instructions with output(s)
      https://github.com/kvm-x86/kvm-unit-tests/commit/82f7d076088b
[4/5] x86: Move invpcid_safe() to processor.h and convert to asm_safe()
      https://github.com/kvm-x86/kvm-unit-tests/commit/8ddc0f0c2d39
[5/5] x86: Move XSETBV and XGETBV "safe" helpers to processor.h
      https://github.com/kvm-x86/kvm-unit-tests/commit/700c2b7e5007

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

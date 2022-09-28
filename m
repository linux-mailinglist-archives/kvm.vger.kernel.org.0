Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9935EEA48
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiI1XpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiI1XpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:45:08 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B86FB333
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:45:06 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id w22-20020a056830061600b006546deda3f9so9169883oti.4
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ESo7dYY6GfSDr+r4KK+gGMltslb0uxWselTUsHs3b/I=;
        b=oItvueHC9rGpEb1pjDREbzHBF4FsxPszjkSVzhJXqpPU49y/K5jjrfmA7oddFNQfmP
         sR629g48JwNN9T6R8G660mC9vUqTrrGYcg30Wdo+KgVe2AEYXxT0AqJRF6IxQCT7U3wz
         HN8BVD0i673m0Llrhm1mnVpn5n0b9H+HvrBP+p43/3wVnBLIluaF6JazpmqonSDZmMSx
         rcazm5CE45xgvNTlQGaHPuiick8amlxtoYzCvslzqE8f/L9VW5Mi7TziUCMHaDlzKyj+
         LnLxsGsboagft/aX9Aanz8y41bPYUD6i/5aiU+zhx4vN6qQjNMp+6HtDmMytNC2gdTlu
         GM0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ESo7dYY6GfSDr+r4KK+gGMltslb0uxWselTUsHs3b/I=;
        b=Nh9b7x7dVSR+aiyltVczaaKwUxN5UMHJx3tKStOncs8RRGqxAELFaZoG+sRS9YqVaP
         CapiH5twSBXvvSNBtaSsALjzZUfRUEo53qVFT/KlM5mPToVinQ/QhuyW3UOyRsf/puaB
         Xu30R+RcuUlWqZco8SWSqL1HfDJD7KQHWeO0pGUQ4ECSRjdy0YedoSMgbs4Vgy+YpCIA
         mG0xrofqtu9PwBL78O4vOnEP8cOPPJFtpva7AUkMeTXF49wjMqv5qJcDro2SyzfzQbOS
         0RrvYMob2tKUPwf/mG6r2yOjXJIP3F521StsEYOLb2KLlOyPFD4JdYxiYpfhIPyMR9sI
         77Jw==
X-Gm-Message-State: ACrzQf1+hDCcYtPa9BbjEvtlyJXGRQq31pgJGt9iU2oHsYjSChDnly9S
        Xjdj1LsXdqpozHtRRlo7QMA4ZTNXnLkkMIWt7WpaTA==
X-Google-Smtp-Source: AMsMyM5BEgYUYkwCxhv/sZA35LzbvEoRuf+YYFHT4kB7vvwY9taFoIle4rOgzDexyQJ331I5KruMLo+4Blr6HuHoaCo=
X-Received: by 2002:a9d:6296:0:b0:656:761:28bc with SMTP id
 x22-20020a9d6296000000b00656076128bcmr172073otk.14.1664408705832; Wed, 28 Sep
 2022 16:45:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220928233652.783504-1-seanjc@google.com> <20220928233652.783504-8-seanjc@google.com>
In-Reply-To: <20220928233652.783504-8-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 28 Sep 2022 16:44:53 -0700
Message-ID: <CALMp9eTysg_AdBi3BsbMzj4uKjsHLOOa1B3x+j8=CH=Lvzr8jQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] Revert "KVM: selftests: Fix nested SVM tests when
 built with clang"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

On Wed, Sep 28, 2022 at 4:37 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Revert back to using memset() in generic_svm_setup() now that KVM
> selftests override memset() and friends specifically to prevent the
> compiler from generating fancy code and/or linking to the libc
> implementation.
>
> This reverts commit ed290e1c20da19fa100a3e0f421aa31b65984960.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
I love it!

Reviewed-by: Jim Mattson <jmattson@google.com>

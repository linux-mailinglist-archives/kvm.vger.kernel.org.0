Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0336D4BC6
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 17:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjDCPYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 11:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDCPYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 11:24:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726EA1BE6
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 08:24:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id k4-20020a17090aef0400b0023fcccbd7e6so9118159pjz.5
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 08:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680535490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9sC8H5VzjjhpCcVyFK02+wGSIDDjTLiGBsWhqbtn/fo=;
        b=tY+Uce7KcLNj8AJF+w+3SgeQBCMtUQseMecEfr3e3mY5mbevJzC8UTw6dr3Tnj5FnI
         S6O9diljZ3b1r1Nf8P+5ahTe4hi3UWZutrVn93ZtteGIxrakqck2xI2X5WWBuqGrgg0o
         cyNyEEOCu2JNKK47DWj/CHKaeiOX+80r4CCqSBFqwzVHNmiBnE3RRFQXrzY/VwirVrX3
         T2wPk2waJlM2LNjaNQoNgZVv7znaJo/+MFAc3qqDTkjO2+L3C5oUhCJu4cK1p97xB5Co
         T3NBcuk0/MG6AzNklwQu99UH/gn5isI44G/4wN4282yATvYKvvt0+UMaddgxa2oma23T
         wpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680535490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9sC8H5VzjjhpCcVyFK02+wGSIDDjTLiGBsWhqbtn/fo=;
        b=K5JdrHehqoCQKOlCdBfvIKrIsxlfk4wXl9q3CNwNYNIos0X7UQGrrP2pRV57RsQgMu
         7XKn95WBzwu5qnjUEYprHUo4em0vTilzZexe1hZHaUimq2BGJkwQ9HfQ51QcomjVGnMs
         kL5PzN9u1VQl5IOp4Hn1K9fKPmkSq/soB4oK3BAV6mClD1VTm+U2r7qPtHC9UgcI78ew
         0xTc0YcH34BLXni93i/nQr91KQ1GlWQUfPCvweB1hmQ9ZSH1+kD4cIpPsZ0K+3DcJyrp
         YJWbBHoQnX0w6wJC9gaMaFhMnHyXq0lNduSFI8LtbR0QO0DUtXL5mO0cAs4zUeNlo1Vy
         n66Q==
X-Gm-Message-State: AAQBX9d/0JjmMF0xDLS9vhgn7oaw3+NacM1AvKK/tOqtM2QG5Cs4VTLj
        heataJRXbaR3hG9VGOCbnKkheCVfBoY=
X-Google-Smtp-Source: AKy350YE1K9YcZhsFGhu7+QhEIz/or2+TVrxV1gxrfDrv9SUPxhnGaTKfIHzC94mIZXY7ewyJ8ghcuGvkCw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2282:b0:1a0:428c:1dae with SMTP id
 b2-20020a170903228200b001a0428c1daemr13841278plh.5.1680535490028; Mon, 03 Apr
 2023 08:24:50 -0700 (PDT)
Date:   Mon, 3 Apr 2023 08:24:48 -0700
In-Reply-To: <20230403112625.63833-1-thuth@redhat.com>
Mime-Version: 1.0
References: <20230403112625.63833-1-thuth@redhat.com>
Message-ID: <ZCrvwEhb45cqGhmP@google.com>
Subject: Re: [kvm-unit-tests PATCH] ci/cirrus-ci-fedora.yml: Disable the
 "memory" test in the KVM job
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023, Thomas Huth wrote:
> Two of the sub-tests are currently failing in the Fedora KVM job
> on Cirrus-CI:
> 
> FAIL: clflushopt (ABSENT)
> FAIL: clwb (ABSENT)
> 
> Looks like the features have been marked as disabled in the L0 host,
> while the hardware supports them. Since neither VMX nor SVM have
> intercept controls for the instructions, KVM has no way to enforce the
> guest's CPUID model, so this test is failing now in this environment.
> There's not much we can do here except for disabling the test here.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  ci/cirrus-ci-fedora.yml | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
> index 918c9a36..c83aff46 100644
> --- a/ci/cirrus-ci-fedora.yml
> +++ b/ci/cirrus-ci-fedora.yml
> @@ -35,7 +35,6 @@ fedora_task:
>          ioapic
>          ioapic-split
>          kvmclock_test
> -        memory

What if we fix the test by making it TCG-only?  None of the other instructions in
the test have intercepts, i.e. will also fail if the instructions are supported in
bare metal but not the test VM.

An alternative would be to force emulation when using KVM, but KVM doesn't currently
emulating pcommit (deprecated by Intel), clwb, or any of the fence instructions
(at least, not afaict; I'm somewhat surprised *fence isn't "required").

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f324e32d..5afb5dad 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -185,6 +185,7 @@ arch = x86_64
 
 [memory]
 file = memory.flat
+accel = tcg
 extra_params = -cpu max
 arch = x86_64

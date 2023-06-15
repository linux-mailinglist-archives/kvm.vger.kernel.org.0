Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F802731B75
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 16:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344028AbjFOOg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 10:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344268AbjFOOg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 10:36:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500A9194
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 07:36:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bc4c832c501so2044036276.0
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 07:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686839814; x=1689431814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X+7G//ecHjNVG/jfa9hG3bCxnnojYsnnlngJwYilFX0=;
        b=6JCZdSWWBXcfcB1sYGiAmGvvmRR7N9BwMhNOn64TlZnfvyfm1eJtsD78+gu+EjJKIQ
         cqsAGRHDxrxNdD8r9kjfRsKO+huWQAX+5hdN7VGbh/7JgHYZA7EOy71d4xDCZzxP1JKP
         CZgEpo1agqlabTrH/uHxEQ9kTq+0BWPMnhYIHb0rKlUGwzlyLb/zJLXwmIUJmnK6aTee
         JA5uk+U7B/RxOu8vpYnQZL6uMFMiB3agjF2/9n1hCGYgq9k3aV7KdnsMmqoi65F42KRr
         ThK2dfO0L3uL4iN+nunLZyFvsY01SNSJtNj2B2e/917ZfRTFTokKlGAbHeTF7PZQdFXb
         PkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686839814; x=1689431814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+7G//ecHjNVG/jfa9hG3bCxnnojYsnnlngJwYilFX0=;
        b=hrp6NvhdwFSb+zqnkgtZc/PHJGaQNRiLcLVymbpR3ubS+0efedd8KHexMFd3TxaBJr
         m6nir27KdQumepTbBFeONnKivx0VqoeFlWr0epTV53DuvEE6L7wfZf/krrgTEmINg8rW
         b70Y0LXeA0JA3dW6RmLfrh7EGlnryI7ssOcg8pYorWOnexLDScUjwjGkPasT0gWhvzVf
         B/shP0mqf16+mWOD4nTO+dzMjPsvdoWH6KofQqLtWBhhjl7j+bL8GFa/rIabT/AN9O31
         WINheUj69KKf7DXyUwOZyGzEAcXx8F+CyL+fJhRkWEepbq5yv/D9AmONXEWLU3XjKAyr
         AMZQ==
X-Gm-Message-State: AC+VfDxc0sF/rKZQ+zr+rVeRrJOPGAZyhR5eFwMK3XQVPxetofAJWZ3s
        jy27gkk+/X1RThLQX1x/nfZF8cg4vh0=
X-Google-Smtp-Source: ACHHUZ7cVcvbTLgG2oGuHIlvWPaGf57oWLskFn184gpneooP01xurOPGVteuaZ8+XavJujWn4Oe63gNj58A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab85:0:b0:ba8:4ba3:5b54 with SMTP id
 v5-20020a25ab85000000b00ba84ba35b54mr651969ybi.11.1686839814563; Thu, 15 Jun
 2023 07:36:54 -0700 (PDT)
Date:   Thu, 15 Jun 2023 07:36:52 -0700
In-Reply-To: <20230615091819.fzr67tevfxmcbnqo@linux.intel.com>
Mime-Version: 1.0
References: <20230615080624.725551-1-jun.miao@intel.com> <20230615091819.fzr67tevfxmcbnqo@linux.intel.com>
Message-ID: <ZIsiBCYB+18KG1XR@google.com>
Subject: Re: [PATCH] KVM: x86: Update the version number of SDM in comments
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Jun Miao <jun.miao@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023, Yu Zhang wrote:
> On Thu, Jun 15, 2023 at 04:06:24PM +0800, Jun Miao wrote:
> > A little optimized update version number of SDM and corresponding
> > public date, making it more accurate to retrieve.
> > 
> > Signed-off-by: Jun Miao <jun.miao@intel.com>
> > ---
> >  arch/x86/kvm/lapic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index d7639d126e6c..4c5493e08d2e 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2260,7 +2260,7 @@ static int apic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> >  	/*
> >  	 * APIC register must be aligned on 128-bits boundary.
> >  	 * 32/64/128 bits registers must be accessed thru 32 bits.
> > -	 * Refer SDM 8.4.1
> 
> I would suggest just remove this line.

+1, and clean up the other part too?  The line about 32/64/128 bits registers is
also flawed; there are no 128-bit registers, just 256-bit registers.  I see no
reason to precisely call out the sizes.  And this would be a good opportunity to
call out that KVM allows smaller reads, but not smaller writes.

E.g. something like this?

	/*
	 * APIC registers must be aligned on 128-bit boundaries, and must be
	 * written using 32-bit stores regardless of the register size.  Note,
	 * KVM allows smaller 8-bit and 16-bit loads to be compatible with
	 * guest software (some microarchitectures support such loads, even
	 * though only 32-bit loads are architecturally guaranteed to work).
	 */

> And maybe, add "According to Intel SDM, " at the beginning of the comments.

Nah, not necessary.  It's implied that KVM is implementing architecturally behavior
unless otherwise stated.  And this isn't Intel specific code, e.g. the APM (hopefully)
says the same thing.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54C763D70
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 19:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjGZRRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 13:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjGZRRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 13:17:38 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A51B173B
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 10:17:36 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55ac8fcc887so3393372a12.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 10:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690391856; x=1690996656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fpLTY9pQ6b5U6N7qzDsfr5J52TsXnYFwiLdUlnnqaAA=;
        b=GKjB/KcCAeZ7SwlkvJgNzGkbjHliLMDKfabPjyRYmNHQdfgiXz/TIxm4eZ7wMri9Eu
         ewNGXZNHWeuPaQNeaxoylgtBfB1UMIkQaerks/mLj5xuoTdU9C3V6bWOpPM8BkNM8wcK
         LCFmyjxtin39bFtoE6crhGgw+EouhFf+fBCBe9Fr1JDNTepQ4oE+uLfTqC5IfmeKBLHy
         9T4thTdg3+av8czQnPfJDkN6ngVKQDQq9NjvDjmXePOe2iriCpy9vko1ywSP3Ow+KujP
         wVftqa5zdkF805w3Jre93/05TNjfEfdGn/gJxXNsSjhD40O0iZCMT5ja6D20aMZUQATG
         aqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690391856; x=1690996656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fpLTY9pQ6b5U6N7qzDsfr5J52TsXnYFwiLdUlnnqaAA=;
        b=LyALgbLiUz5N/jIUr0H/0ecB0z/wNUhIwi4UGYf784M/QGAUNoPdvx5yWbxP10wmWa
         LH+QVEmclkFRqojNDyeFkTg6MhdRfXMF2x7h1thQRSMjqKx0gP3mFpiVBxEFX24aPnlz
         LL8Ej/Jk/hdjtzXTAl0nO2KCVZTWM2bZ4idZ4NUwij1RX8/dV5LjscJi4PLYgESjGKcH
         RZbU0Rl0LEl8BoXOYitBCusjxCZrKxaCk6I9byANQiawxOkBQLT2A1o7WeGsXzDtdsHi
         3BlrASle4ZfcsObnAok10N/LO04DA9puRF6i0QF2s7Y9grZKLOB11nCKPGXeil+dPaxd
         JZfA==
X-Gm-Message-State: ABy/qLbPIi6wVSKdD7er2eerDThFqkzYLLlfeGXadw5k+9XkYS6F9EO+
        cH3H2DCQmTITGeQS6KGqahIpclykVsk=
X-Google-Smtp-Source: APBJJlF0bmkqPioSMPv+t11hLeXRMgIw787azegLyjzTsNZo9HPtgJ3RxQ9KHXw4BkTYihQr8Kjx75X/e7o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f145:b0:1ae:6895:cb96 with SMTP id
 d5-20020a170902f14500b001ae6895cb96mr10221plb.5.1690391856068; Wed, 26 Jul
 2023 10:17:36 -0700 (PDT)
Date:   Wed, 26 Jul 2023 10:17:34 -0700
In-Reply-To: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
Mime-Version: 1.0
References: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
Message-ID: <ZMFVLiC3YvPY3bSP@google.com>
Subject: Re: KVM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 7
From:   Sean Christopherson <seanjc@google.com>
To:     Yahya Sohail <ysohail@cs.utexas.edu>
Cc:     kvm@vger.kernel.org
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

On Wed, Jul 26, 2023, Yahya Sohail wrote:
> Hi,
> 
> I'm trying to copy the state of an x86 emulator into a KVM VM.
> 
> I've loaded the relevant state (i.e. registers and memory) into a KVM VM and
> VCPU, and tried to do a KVM_RUN on the VCPU, but it fails with
> KVM_EXIT_FAIL_ENTRY and hardware_entry_failure_reason = 7. I looked through
> the KVM source and Intel manuals to determine that this either means that
> the CPU is in an interrupt window and the VM was setup to exit on an
> interrupt window, or that a VM entry occurred with invalid control fields.
> The former is not possible because my RFLAGS.IF = 0, meaning interrupts are
> currently disabled, so I think it's the latter.

No, there are far, far more possible problems.  Error code 7 is "invalid control
field", which is a gigantic bin for any failed consistency check that is related
to one or more VMCS control fields.

> Is it possible for someone using the KVM API to set the VMCS to an invalid
> state?

Yes.  Ideally it _shouldn't_ be possible[*], but practically speaking I don't think
there's ever been a version of KVM that prevents userspace from coercing KVM into
loading invalid state.  E.g. see https://lore.kernel.org/all/20230613203037.1968489-1-seanjc@google.com

[*] For VMCS control fields specifically.  Preventing userspace from loading
    invalid guest state is extremely difficult, and not something I realistically
    expect KVM to get 100% right anytime soon.

> If so, what fields in the kvm_run struct should I check that could cause such
> an issue?

Heh, all of them.  I'm only somewhat joking.  Root causing "invalid control field"
errors on bare metal is painfully difficult, bordering on impossible if you don't
have something to give you a hint as to what might be going wrong.

If you can, try running a nested setup, i.e. run a normal Linux guest as your L1
VM (L0 is bare metal), and then run your problematic x86 emulator VM within that
L1 guest (that's your L2).  Then, in L0 (your bare metal host), enable the
kvm_nested_vmenter_failed tracepoint.

The kvm_nested_vmenter_failed tracepoint logs all VM-Enter failures that _KVM_
detects when L1 attempts a nested VM-Enter from L1 to L2.  If you're at all lucky,
KVM in L0 (acting a the CPU from L1's perspective) will detect the invalid state
and explicitly log which consistency check failed.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9536D555B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 02:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjDDAEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 20:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDDAEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 20:04:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345223C26
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 17:04:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p12-20020a25420c000000b00b6eb3c67574so30188641yba.11
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 17:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680566658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5x57LUNzKcptAoUpJxkv+TXi+hRZ31dL4t96oBhs0s4=;
        b=G7+1KbvPCL7wp7GVSS71w3LD38oKAZ0ssahJhiQVhRc7R2TuyBpF/VbXToc+kNbaPS
         JNeK5lSqPrWK74UOA46BTbl6tDs7sX1rTtSW9fnxbbhe23h51qZJmXtZqwxgIzth386a
         1nB1JvZXLnzuiRvWPbSyNeA0nNnAS7io6JlvkWgb0uLFkUh6XE+MUVhmiUAAJjj6Ndea
         kJnRFwvvSKLQmuWQK6KvIPP1ZIWRWSiwMkaeKFkzLVOnGQiB+sqcDMQB6O2wiKjdvUxz
         n8+l1Tv2wBv23pUjmbZc4Is83dK8moTi22VBOJQV16XoIRIkwLBVOXd6HJ1OtsimTx7a
         hBnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680566658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5x57LUNzKcptAoUpJxkv+TXi+hRZ31dL4t96oBhs0s4=;
        b=ttBngjPuOlsRbRHxxyN4VFjB0tjYOTogbWYopCA54IF8DSF5MibSD17PtrKs+ZkLFJ
         o9Cik6zHTpl5XufftQ/n1ANGGpokcAaTAi4hEm7vLTrvyh+QvdTzgMOFJ7LuPe0nY7PF
         fHZEVwH8XOiUnkZvpYYS8GvmUMJwMFw3JXfho1s8eDTRzsocp+bGrK5c/i4iEFUEeyyw
         FrLroHNJ6K1VV1PLO0ymhKLPY9E6SCRdG/VDnsg0gOiYujpHYwaGj/2tRo6bs7WwFfM8
         kTCk97VjTj9YOK0vWLw36kPlVaxrwsz2GibbarGxxDjnVfFt0RD0dcM/snlKkGoy+APZ
         N0nw==
X-Gm-Message-State: AAQBX9eTmR7J8J62gzvLSwp4kygLTjjuxX64jxHDYFekuAi6D4VwKWSu
        c2nWylYU1IzlpNuIwolSZbU7A59yS4c=
X-Google-Smtp-Source: AKy350b4nKt2UtFZmeieWFOBCYRUF+d71VpGleCTzSMDf+CwNpYo+A8ES1tDDSy1ebNajnSfcQi+5GoQNnQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6a88:0:b0:b75:e15a:a91b with SMTP id
 f130-20020a256a88000000b00b75e15aa91bmr10003176ybc.6.1680566658340; Mon, 03
 Apr 2023 17:04:18 -0700 (PDT)
Date:   Mon, 3 Apr 2023 17:04:16 -0700
In-Reply-To: <20230403105618.41118-4-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230403105618.41118-1-minipli@grsecurity.net> <20230403105618.41118-4-minipli@grsecurity.net>
Message-ID: <ZCtpgGaRN+B91B3G@google.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation support
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
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

On Mon, Apr 03, 2023, Mathias Krause wrote:
> Add support to enforce access tests to be handled by the emulator, if
> supported by KVM. Exclude it from the ac_test_exec() test, though, to
> not slow it down too much.

IMO, the slowdown is nowhere near bad enought to warrant exclusion.  On bare metal
without KASAN and other debug gunk, the total runtime with EPT enabled is <6s.
With EPT disabled, it's <8s.  In a VM, they times are <16s and <26s respectively.
Those are perfectly reasonable, and forcing emulation actually makes the EPT case,
interesting.  And the KASAN/debug builds are so horrendously slow that I think we
should figure out a way to special case those kernels anyways.

If you don't object, I'll include FEP as a regular flag when applying.

One other fun thing the usage from vmx_pf_exception_test_guest(), which runs afoul
of a KVM bug.  The VMX #PF test runs the access test as an L2 guest (from KVM's
perspective), i.e. triggers emulation from L2.  KVM's emulator is goofy and checks
nested intercepts for PAUSE even on vanilla NOPs.  SVM filters out non-PAUSE instructions
on the backend, but VMX does not (VMX doesn't have any logic for PAUSE interception
and just ends up injecting a #UD).

I'll post this as a KVM patch.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ae4044f076f..1e560457bf9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7898,6 +7898,21 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
                /* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
                break;
 
+       case x86_intercept_pause:
+               /*
+                * PAUSE is a single-byte NOP with a REPE prefix, i.e. collides
+                * with vanilla NOPs in the emulator.  Apply the interception
+                * check only to actual PAUSE instructions.  Don't check
+                * PAUSE-loop-exiting, software can't expect a given PAUSE to
+                * exit, i.e. KVM is within its rights to allow L2 to execute
+                * the PAUSE.
+                */
+               if ((info->rep_prefix != REPE_PREFIX) ||
+                   !nested_cpu_has2(vmcs12, CPU_BASED_PAUSE_EXITING))
+                       return X86EMUL_CONTINUE;
+
+               break;
+
        /* TODO: check more intercepts... */
        default:
                break;


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907347272FB
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbjFGX3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjFGX3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:29:39 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370782696
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:29:37 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53ba38cf091so673109a12.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686180576; x=1688772576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r3QrMflVFxoCs+GTxgBoD8UqAE1XJUZtO7A6e0WuA5E=;
        b=4Sgi9WQ9nfkb3hPy/P0XKXbheDEDah/+zcOTvhHiFWxEeGd/3SNFLK0QMJb4ojZjN5
         qX2Y7TohCl0+d67WscKD2tWKp+obJX8tOmfYMiFxNyUu3beOJWJJU8pW6lniLbUFv4Sn
         UCiEgfnPNqNv/UxUlrqPZlUgsyr7VAM1rbg+5ROQQnq+1/i6EYeXfH0bk5qjHTnz/CjQ
         aCDj7flK3W0KWam5GLdUFJHKJVjJd0CPFg9VFvwIcEYOGLoqRVWiy9Kx8ulTO0G9opDh
         Q0V8pMGguQcIO6n+T+QRPvcsIh9anK7F3IxBWBrIj8GoUTTBcQECnwbCUojFGtYKoX4/
         /7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180576; x=1688772576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r3QrMflVFxoCs+GTxgBoD8UqAE1XJUZtO7A6e0WuA5E=;
        b=ccylv40PXgWMdKPqoZlTVU9hztpdy4X3QpDLoE3e8qabJb6Z4NdW46ndTmmvSrcDfY
         2s8JU7Ww5vvI4yg6wo2sXLiWGV2/KY0M7oQHlNyoZebYKQpz+q4HI7aZo5QB7FXY3rzU
         4yahiYFtWlMdcmPWcwIsFTAKqkOr4k6BJwwsI0oftHoAcVUcGrq94lv9RukLBXQXoiVt
         yBPgQQ2hSTWUTJSGdjKz4ydVVk1DcCfsJWV4EWIVuFMcUmL+9s09UUFf7joyPfN2dBa4
         uvwhEMz/5AxlW3DT3Sj2K8CHoFU2yq6+KmVvN7WV4Zks5UKoLxqyJTXw5AoYk+vHKnz2
         S8PQ==
X-Gm-Message-State: AC+VfDzIOBmTs7JrFRokJmeq/9UIAyjR215NJKyrSrFnuvIVDdc8hvHe
        ss90maquHGOWMh12QscuBmlgcuQbIU0=
X-Google-Smtp-Source: ACHHUZ4YS9gkCW4DsY3REcV8lxO84FpXJ52JqO1U2D1XK8f2BlkvzldBDRzT6vGhdc08MAzJIMNouTGpyRQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1302:b0:1b0:46ae:ff83 with SMTP id
 iy2-20020a170903130200b001b046aeff83mr133914plb.1.1686180576688; Wed, 07 Jun
 2023 16:29:36 -0700 (PDT)
Date:   Wed,  7 Jun 2023 16:26:00 -0700
In-Reply-To: <20230607210959.1577847-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607210959.1577847-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168617891041.1602224.7033425983942538294.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] x86: nSVM: Fix bugs in LBRV tests
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

On Wed, 07 Jun 2023 14:09:53 -0700, Sean Christopherson wrote:
> Fix bugs in the LBRV tests, and try to make them a bit less painful to
> debug (goes from "excruitating" to just "awful").  The tests have been
> failing on our Milan systems for quite some time, but debugging them was
> painful and I wasn't sufficiently motivated until I wanted to clean up
> KVM's code :-/
> 
> The Milan failures are due to AMD shoving a "mispredict" bit in the LBR
> records, i.e. the tests fail if the CPU mispredicts the branch being
> tested.  Debug was especially difficult because the tests also neglected
> to setup a guest stack, i.e. adding debug code created a completely
> different failure that looked similar at first glance.
> 
> [...]

Applied quickly to kvm-x86 next, as I'm OOO the rest of this week.  I won't
send a pull request until sometime next week, e.g. if anyone objects to
putting the assertion macros in common util.h.

[1/6] x86: nSVM: Set up a guest stack in LBRV tests
      https://github.com/kvm-x86/kvm-unit-tests/commit/bef5a3677b60
[2/6] lib: Expose a subset of VMX's assertion macros
      https://github.com/kvm-x86/kvm-unit-tests/commit/11e5dc0f9ed4
[3/6] x86: Add defines for the various LBR record bit definitions
      https://github.com/kvm-x86/kvm-unit-tests/commit/691df8f964df
[4/6] x86: nSVM: Ignore mispredict bit in LBR records
      https://github.com/kvm-x86/kvm-unit-tests/commit/3ffa0914672e
[5/6] x86: nSVM: Replace check_dbgctl() with TEST_EXPECT_EQ() in LBRV test
      https://github.com/kvm-x86/kvm-unit-tests/commit/d8849d8f3702
[6/6] x86: nSVM: Print out RIP and LBRs from VMCB if LBRV guest test fails
      https://github.com/kvm-x86/kvm-unit-tests/commit/11c7d0604a50

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

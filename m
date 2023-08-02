Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA476DA61
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 00:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbjHBWEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 18:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbjHBWEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 18:04:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EC3EA
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 15:04:48 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bba5563cd6so4869665ad.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 15:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691013887; x=1691618687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s4pG+0ROPLN5wFPTceCIK9yMxb584BXYEH3MDjAMHUI=;
        b=5IThkL7mCuko/iZIqR7UMcifDGS27vvyStr3c+LzjuZVQG91qOky9lKg+zrOiZTMpU
         OwwWPgG4cke3/T3XBolLw2Cx3WUuGyiif6ZowjDo07N0l7srbZJ6chbQoBVzIZBAk36f
         vOsJLqY8XbXpAV4lcysaz5w2Q7x8+E2jcr4xl4PoVSbEfMXaCQYRcBOftfG+xqOa9+A1
         7wD40U6lLvSLC2KpqHnU2BJ36ecpDnhMawcETwGiYTqZ6YZVuaKEKYzU6SDT2fW6vWk5
         kd4mjyDCuLytL9hJoedPQORuBvRjh15HoKTWlu0MrSrLcGPDhhGsnL2+Rh40VubQgp28
         KP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691013887; x=1691618687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s4pG+0ROPLN5wFPTceCIK9yMxb584BXYEH3MDjAMHUI=;
        b=HaFYhO44qQ0STIS+yVBCOZtL9eQOnhpXlQjGuK7du4oCkXmKe4ZQjC4bA+E6+2JIlF
         0lV0PtEQRmcmsiu8Pj+gUeb1a4wTLvGGf+fdx3eTtioAFi8Nm+vqTdUR+krZ61XbRhES
         +lbEsIso6CSA6cp4K5fBXLrUZ8qezmpwgehZk6nVnG0NNUCYU+Yg9e/z6cqi6PynFqS6
         Rk+5SLzdAnKkmmhGUnTkQuM51KFATCbvQkpSOUELza5NUgCTWP3+YfPHqAIoz3y1FbPq
         KtOyHEht68fPenT/1w+b91T/LhekL2+Yo3LeCvbK410oxsoUQEpmGAkMW7gPQ8AT8kTy
         kA3g==
X-Gm-Message-State: ABy/qLYh5LEGDI1FnoGbky/xdUR9/d9+lX5ULutaxHec9VOF85CEJaU/
        vevVyNjq9CfcBRPJturyn7DnFLgzNbA=
X-Google-Smtp-Source: APBJJlF5RdyRksKOEIlR2G5Z4RvCvNZ4hcQlx656VIxEW0DE1DwYcEzBQVuH42ayiSXyOKOjkSa++KcJmYM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2309:b0:1b3:bfa6:d064 with SMTP id
 d9-20020a170903230900b001b3bfa6d064mr104865plh.1.1691013887511; Wed, 02 Aug
 2023 15:04:47 -0700 (PDT)
Date:   Wed,  2 Aug 2023 15:01:41 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169101267140.1755771.17089576255751273053.b4-ty@google.com>
Subject: Re: [PATCH v4 00/34] KVM: selftests: Guest printf and asserts overhaul
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jul 2023 17:36:09 -0700, Sean Christopherson wrote:
> This is effectively v4 of Aaron's series to add printf capabilities to
> the guest[*].  I also pulled in Thomas' patch to rename ASSERT_EQ() to
> TEST_ASSERT_EQ(), mainly so that we can decide on a common output format
> for both host and guest asserts in a single series, but also so that all
> these basically treewide patches are contained in a single series.
> 
> Note, Aaron did all of the heavy lifting, I just mopped up.  The core code
> is pretty much unchanged from Aaron's v3, v4 massages the assert code a
> bit and converts all the tests.
> 
> [...]

Applied to kvm-x86 selftests and officially started this runaway train.  I'll
give this a few days to stew in linux-next, and assuming no fireworks, will
create a tag and make everything up to that point immutable.

I will follow-up with all the in-flight selftests series I can find to
coordinate, though I'm hoping we'll get lucky and just not have any major
conflitcs.

Please yell asap if you encounter issues and/or object to any of this.
 
Note, I technically applied patch 1 from Thomas' original posting, but captured
it here too as I figured that'd be the least confusing thing.

[1/36] KVM: selftests: Rename the ASSERT_EQ macro
      https://github.com/kvm-x86/linux/commit/6d85f51a1f08
[2/36] KVM: selftests: Make TEST_ASSERT_EQ() output look like normal TEST_ASSERT()
      https://github.com/kvm-x86/linux/commit/b145c58d95ff
[3/36] KVM: selftests: Add a shameful hack to preserve/clobber GPRs across ucall
      https://github.com/kvm-x86/linux/commit/6783ca4105a7
[4/36] KVM: selftests: Add strnlen() to the string overrides
      https://github.com/kvm-x86/linux/commit/a1c1b55e116c
[5/36] KVM: selftests: Add guest_snprintf() to KVM selftests
      https://github.com/kvm-x86/linux/commit/e5119382499c
[6/36] KVM: selftests: Add additional pages to the guest to accommodate ucall
      https://github.com/kvm-x86/linux/commit/215a681710a5
[7/36] KVM: selftests: Add string formatting options to ucall
      https://github.com/kvm-x86/linux/commit/57e5c1fef5ec
[8/36] KVM: selftests: Add formatted guest assert support in ucall framework
      https://github.com/kvm-x86/linux/commit/289c2b4db8f3
[9/36] KVM: selftests: Add arch ucall.h and inline simple arch hooks
      https://github.com/kvm-x86/linux/commit/b35f4c73d389
[10/36] KVM: selftests: Add #define of expected KVM exit reason for ucall
      https://github.com/kvm-x86/linux/commit/edb5b700f9f8
[11/36] KVM: selftests: Add a selftest for guest prints and formatted asserts
      https://github.com/kvm-x86/linux/commit/5d1d46f9d56f
[12/36] KVM: selftests: Convert aarch_timer to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/db44e1c871bc
[13/36] KVM: selftests: Convert debug-exceptions to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/bac9aeecc387
[14/36] KVM: selftests: Convert ARM's hypercalls test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/af5b41b97f1c
[15/36] KVM: selftests: Convert ARM's page fault test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/df27f6b45454
[16/36] KVM: selftests: Convert ARM's vGIC IRQ test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/d0ad3bacc523
[17/36] KVM: selftests: Convert the memslot performance test to printf guest asserts
      https://github.com/kvm-x86/linux/commit/c55a475d5fc4
[18/36] KVM: selftests: Convert s390's memop test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/428c76c769fa
[19/36] KVM: selftests: Convert s390's tprot test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/5f82bbab84ad
[20/36] KVM: selftests: Convert set_memory_region_test to printf-based GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/9291c9cef5b5
[21/36] KVM: selftests: Convert steal_time test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/3d9bd831175e
[22/36] KVM: selftests: Convert x86's CPUID test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/06b651d250e5
[23/36] KVM: selftests: Convert the Hyper-V extended hypercalls test to printf asserts
      https://github.com/kvm-x86/linux/commit/82cb0ed66d4e
[24/36] KVM: selftests: Convert the Hyper-V feature test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/8d1d3ce604e5
[25/36] KVM: selftests: Convert x86's KVM paravirt test to printf style GUEST_ASSERT
      https://github.com/kvm-x86/linux/commit/bf6c760b9df3
[26/36] KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest asserts
      https://github.com/kvm-x86/linux/commit/0f52e4aaa614
[27/36] KVM: selftests: Convert x86's nested exceptions test to printf guest asserts
      https://github.com/kvm-x86/linux/commit/b13a307ce3c6
[28/36] KVM: selftests: Convert x86's set BSP ID test to printf style guest asserts
      https://github.com/kvm-x86/linux/commit/40b319d6b4e1
[29/36] KVM: selftests: Convert the nSVM software interrupt test to printf guest asserts
      https://github.com/kvm-x86/linux/commit/a925f7994281
[30/36] KVM: selftests: Convert x86's TSC MSRs test to use printf guest asserts
      https://github.com/kvm-x86/linux/commit/847ae0795514
[31/36] KVM: selftests: Convert the x86 userspace I/O test to printf guest assert
      https://github.com/kvm-x86/linux/commit/417bfd0c820f
[32/36] KVM: selftests: Convert VMX's PMU capabilities test to printf guest asserts
      https://github.com/kvm-x86/linux/commit/30a6e0b4553d
[33/36] KVM: selftests: Convert x86's XCR0 test to use printf-based guest asserts
      https://github.com/kvm-x86/linux/commit/4e15c38a1aca
[34/36] KVM: selftests: Rip out old, param-based guest assert macros
      https://github.com/kvm-x86/linux/commit/7ce7f8e75418
[35/36] KVM: selftests: Print out guest RIP on unhandled exception
      https://github.com/kvm-x86/linux/commit/6f321017c84b
[36/36] KVM: selftests: Use GUEST_FAIL() in ARM's arch timer helpers
      https://github.com/kvm-x86/linux/commit/a05c4c2bd8b5

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes

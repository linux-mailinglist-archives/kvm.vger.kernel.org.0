Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B84063FC5C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiLAX5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLAX5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:57:37 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF332F41
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:57:34 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id c15so3365163pfb.13
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XRzqbOs8rLS817dsOnVehegPaU6Vc6rFVWa2dHzsWAY=;
        b=m2b7/mhmXPOEMn/Q1pOQgTccqYQzlMDfh7GOuEa/uMFVBKCcqPpIxTx3EZsagaixi3
         9yzZ21zAQfPaJ3MxuhOCLnNoTXPql3ZKSYr0ef+9SdHdlmarrO5reqtOpztwqxs/hf8m
         SYValF9xANRQ1fpLEdjlTXy3zCj53bxFb7gm07uRUnCQsOot8usD41OT5PVU0RjMRUxH
         mLLtDMFl5X/d+iE091w0anO1Z323ZOhRB5yAXmMLaQU65omkSZyLH7vhdR/wjqXD/1ky
         b1cMj7OziL0kcCUW1PkgpVs0IgIWAomqjT7SzvMCft5WXxH70MSHAdsu8zdtYyfiVvjP
         97Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XRzqbOs8rLS817dsOnVehegPaU6Vc6rFVWa2dHzsWAY=;
        b=kpwCgS/fXG1032mYF+IU/8P0LOkCfWjEpnfQldSpjNajSFsFowH4AYtqBRtxUTh9YQ
         uRixTHvg8AJP9MyWkghzTnpOAdVsU+jfQJFw78qiPDgODdG+p9Km6SJgF2+g4OO8Qwkl
         FPd1Hi71UqO1eGIlFuSfadTAJiwXL4rMxTA3oAvbRM/jwWwls9M1xBXXJ/2E8TnrRiSZ
         fzSdVMbC7WiTMvMfFzfw3L3tPqWiWTLxW6HD4afTUkg1X1fVzu819t/rXy6ZdCIAy+/e
         WJNq+LzH9pvBsfgBQ95HpO3KLpscrQVJSWQgD1TrLqhOxj96nsOjps7ewaPkTXRdNAtT
         nXiw==
X-Gm-Message-State: ANoB5pkeKfdvGLvzpN50ujHqes1ykGnKY+sA/8SHBbZqpyQL0YCz9OcV
        RDSwWmZN+tPj2XlLtAeH5pxypA==
X-Google-Smtp-Source: AA0mqf72cqn34v4/3vZSGzA1XaSbUpv0JCVk7udK7vKyVVNnV4sde0SBH1pe2EBJnQmVx4ftUjdDKg==
X-Received: by 2002:a63:f253:0:b0:434:afab:5ff9 with SMTP id d19-20020a63f253000000b00434afab5ff9mr41527069pgk.349.1669939054270;
        Thu, 01 Dec 2022 15:57:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902c11100b001869f2120a6sm4193125pli.108.2022.12.01.15.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:57:33 -0800 (PST)
Date:   Thu, 1 Dec 2022 23:57:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [GIT PULL] KVM: selftests: Fixes for 6.2
Message-ID: <Y4k/ajYqnHhwv6lA@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Please pull selftests fixes for 6.2.  Most of these are fixes for things
that are sitting in kvm/queue.

Thanks!


The following changes since commit df0bb47baa95aad133820b149851d5b94cbc6790:

  KVM: x86: fix uninitialized variable use on KVM_REQ_TRIPLE_FAULT (2022-11-30 11:50:39 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-selftests-6.2-2

for you to fetch changes up to 0c3265235fc17e78773025ed0ddc7c0324b6ed89:

  KVM: selftests: Define and use a custom static assert in lib headers (2022-12-01 15:31:46 -0800)

----------------------------------------------------------------
KVM selftests fixes for 6.2

 - Fix an inverted check in the access tracking perf test, and restore
   support for asserting that there aren't too many idle pages when
   running on bare metal.

 - Fix an ordering issue in the AMX test introduced by recent conversions
   to use kvm_cpu_has(), and harden the code to guard against similar bugs
   in the future.  Anything that tiggers caching of KVM's supported CPUID,
   kvm_cpu_has() in this case, effectively hides opt-in XSAVE features if
   the caching occurs before the test opts in via prctl().

 - Fix build errors that occur in certain setups (unsure exactly what is
   unique about the problematic setup) due to glibc overriding
   static_assert() to a variant that requires a custom message.

----------------------------------------------------------------
Lei Wang (1):
      KVM: selftests: Move XFD CPUID checking out of __vm_xsave_require_permission()

Sean Christopherson (6):
      KVM: selftests: Fix inverted "warning" in access tracking perf test
      KVM: selftests: Restore assert for non-nested VMs in access tracking test
      KVM: selftests: Move __vm_xsave_require_permission() below CPUID helpers
      KVM: selftests: Disallow "get supported CPUID" before REQ_XCOMP_GUEST_PERM
      KVM: selftests: Do kvm_cpu_has() checks before creating VM+vCPU
      KVM: selftests: Define and use a custom static assert in lib headers

 tools/testing/selftests/kvm/access_tracking_perf_test.c | 22 ++++++++++++++--------
 tools/testing/selftests/kvm/include/kvm_util_base.h     | 14 +++++++++++++-
 tools/testing/selftests/kvm/include/x86_64/processor.h  | 23 ++++++++++++-----------
 tools/testing/selftests/kvm/lib/x86_64/processor.c      | 84 ++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 tools/testing/selftests/kvm/x86_64/amx_test.c           | 11 ++++++++---
 5 files changed, 91 insertions(+), 63 deletions(-)

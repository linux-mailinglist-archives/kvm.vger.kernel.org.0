Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB87570EA0
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 02:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiGLAKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 20:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiGLAKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 20:10:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E190422C9
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 17:10:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31c9d560435so56820757b3.21
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 17:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=c6tE9FSTjLeW1DF9aaU2MnGuUgTm/OgjsymJvQgYO64=;
        b=q7yEuu3wxjd1FpnVuoPWrLmkJ1//9pwSP872/0TyEiqITyWDdBVx//pOYGzc6P3j7A
         gAfi66HDkWAe9kLirQ7OrPRyknf83wOzfIPK+5Nufku4tFqdSY63/oGb37a/meIoj6/Y
         wNN+8BMJySIhcWUvF78q6VKWRnizh1f8T4lHzxijPbQJ2vuMRH3fVUcJloxopNcUQwjO
         z3fca+Ja78cAt1UEogZ22OrdL1gtDtDfWEXnEEuQ57rRqi4eXneAolpziaKaXcytmXEp
         Cx4fBDiyi2XdFXbTRKo/4LDB4LZZCp3Zb9ufWxwFiDjPLg7bmY4mu7Feo2rVqq14W5sp
         Pm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=c6tE9FSTjLeW1DF9aaU2MnGuUgTm/OgjsymJvQgYO64=;
        b=PC71yf0aReAqsix1DA5v1YqtcdBht8Oed4Pb6JVoVBkqi3nKOwcmVXCiqxiAEDQLyo
         ldtsrsnkHCAYZ2QjSAyearccwnm8Ls54js4bOeSNsrrKso3UzXuMMbORAnmMyACYvnc/
         40Wey4QUAzSd1Gy9+Ju9wJS+4GHh5BUu73vUSinSsUCNyjREKMFpLlYEHYz/y7eQZj6f
         sHxgGsDcAUSJAx4ZIgtz89+MH33FDzateD7GFblrwykrMrc4WyYyao+alMnyh1kCvN0L
         wd8d9EmWeH0yAv/SO91IVDG1YWCBvHg4y8bwrNowluiCv27ZNQ1ilBDV3zLaZtvQ0xsl
         aTUQ==
X-Gm-Message-State: AJIora9eQOKjvk+cr09kjLI+i1MbYBi/XjQyGxYycTn3iK7s4cC6dc5c
        j9LT2vWaCjJWgJecl4s/sHWsdjQyPf1/UbKpSdp47D1EnSg3/AgE+z0GeGT4qbfgTJXsPFdYMY+
        aGxqita4dwQxOhvnzdwuVL6vD4v99k0As9XXQLQjUQkq9vVGpJMflZRPdc0Xxl9si3ucf
X-Google-Smtp-Source: AGRyM1t9eTTvQdL29qAptuHIH5uH6YBIgF4C0dz2m9PxfAccNstsDuk7sLmc5pbKCHMp14eVsPB0aS3y3GTprKKI
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a0d:f602:0:b0:31d:a033:3438 with SMTP
 id g2-20020a0df602000000b0031da0333438mr15161ywf.39.1657584649678; Mon, 11
 Jul 2022 17:10:49 -0700 (PDT)
Date:   Tue, 12 Jul 2022 00:10:43 +0000
Message-Id: <20220712001045.2364298-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2 0/2] MSR Filtering documentation updates
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix and update documentation for MSR Filtering.  Then, add a commit to
prevent MSRs that are not allow to be filtered from being sent to
userspace.

v1 -> v2
 - Removed patch 3 "KVM: x86: Don't deflect MSRs to userspace that
   can't be filtered";

Aaron Lewis (2):
  KVM: x86: fix documentation for KVM_X86_SET_MSR_FILTER
  KVM: x86: update documentation for MSR filtering

 Documentation/virt/kvm/api.rst | 132 +++++++--------------------------
 1 file changed, 25 insertions(+), 107 deletions(-)

-- 
2.37.0.144.g8ac04bfd2-goog


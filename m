Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A99C53B011
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiFAV6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 17:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiFAV6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 17:58:39 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B516455
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 14:58:35 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q74so915910qke.12
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 14:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GqneKf1ZagN95/3RdG4s49E5y9AiNaX5bKX0//hJ/E4=;
        b=Z6jSIMVU7qhb+I8TUddY5L2Nw30ek1TLL8Vt6yveJOwxxXAJfws23U4PyKoQ65BTDD
         x6qDuZZAKDE3lbxXNI8pFnKQMVyHT8kNBZK8dtD3tw1LMTyaGUXtlDx6AV+oU1eRj4uN
         Yg3YCdXkufi/cvlRkQRTg/Q1PeS6ptS0tFKG85YAudjNDk0aNhzpnXhWcqfvjOddMUZ9
         kflrGow7ES0rbcF7r5ijQrjN/3X524PYpANG7BX+Wk/XAJBaB6QS2DsiH2N4Cu94KE9d
         nFQi9JoRzzn3OkXvy1K4b0n8QzfDPbGkWjHeJjaAu7At01Vn+mTBO7sX//r2ynW7y2fU
         YQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GqneKf1ZagN95/3RdG4s49E5y9AiNaX5bKX0//hJ/E4=;
        b=EgMOFUgH2YWFNxKMZZ+VlNYBNqgrSUx/m/uyWlMw5/CozMgkXl7vZlcXt1O8lJTAMn
         kHXt6pKNskVxGmk5kNrxe+8IaBDeY2OB4kgF/4/I0GNZlsmrGGrHTgDqoOrJGEfvVqzt
         aiq+WCUCBvkQWKU/EKiMg+OlsRkU+P2upPLk3HWxbG+32ueHH/F+qAbFQ9S0wWmmMTXW
         I+/qj52tyDeGDdUfP95ZnfLYAMPM7TOgSM18ep8NBW7IPa4/rdef+f8tMmhviMYvEtgT
         RrDFG3xMBhsMI/BPUrmDUkjr0epWPFAuE75Si8fDVF6LQC6K4kIGlMdbZBdt4UD+G8pL
         fqyg==
X-Gm-Message-State: AOAM530mOxBnQO8XLNbxaGLlPqSTeGmcG3HsJ4R0ORM/PhEcjk0N9W1U
        1AbUn0vca4kwkYdkdJ1cpRhKWnVmNZMG4ev3
X-Google-Smtp-Source: ABdhPJwmzZBKGHShtcu6k6XLd7m/do4xKjTYzmMmJJYLIL7PR4eEgWKDX7HaIORV3GAmpIlswChdaw==
X-Received: by 2002:a05:620a:1a14:b0:69e:9090:a7ba with SMTP id bk20-20020a05620a1a1400b0069e9090a7bamr1244841qkb.582.1654120714205;
        Wed, 01 Jun 2022 14:58:34 -0700 (PDT)
Received: from igor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id f4-20020a05620a20c400b006a659ce9821sm1823611qka.63.2022.06.01.14.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 14:58:33 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH v4 0/2] kvm-unit-tests: Build changes to support illumos.
Date:   Wed,  1 Jun 2022 21:57:47 +0000
Message-Id: <20220601215749.30223-1-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <CAA9fzEHQ49hsCMKG_=R_6R6wN8V8fDDibLJee1a1xLCcrkom-Q@mail.gmail.com>
References: <CAA9fzEHQ49hsCMKG_=R_6R6wN8V8fDDibLJee1a1xLCcrkom-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have begun using kvm-unit-tests to test Bhyve under
illumos.  We started by cross-compiling the tests on Linux
and transfering the binary artifacts to illumos machines,
but it proved more convenient to build them directly on
illumos.

This patch series modifies the build infrastructure to allow
building on illumos; the changes were minimal.  I have also
tested these changes on Linux to ensure no regressions.

Dan Cross (2):
  kvm-unit-tests: configure changes for illumos.
  kvm-unit-tests: invoke $LD explicitly

 configure           | 6 +++---
 x86/Makefile.common | 9 +++++----
 x86/Makefile.i386   | 1 +
 x86/Makefile.x86_64 | 2 ++
 4 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.36.1


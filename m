Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565BD7801C7
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356151AbjHQXlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356167AbjHQXlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:41:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D2B35A5
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:41:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589f986ab8aso7466347b3.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692315678; x=1692920478;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25F8YYuLbjvNhO3HlPt4M0cUfz5VnLi83gNLVuSeAB4=;
        b=LA57IVI5cF6mONL1RTwjov7pbY9Lkrbv4Psb+Ja5qZWoysVg/HAEMuFvtZr7bM/n9l
         6djlZk/YSfQdXJDdNFoMUYf50PktBs8mvlTWdYFYNpmtiwv307STKg40/01A24feB1Cd
         +LXtUGSwO9QiwNfeiayKZS4Pm7MvUcXOdk2SB0UD1Kerylh2zDBLwb2+2KWo3gD2Aq/T
         7Y2EcHMv9q2nt22wRPs0DiGi2gE2n7+zlG18TJTb9Tf1AXEpoAOpVdTK0FsRCIv2mwgr
         KmwMb/um94c0aPYHrC5wi7UrzB2XR3H0ONM6rpA/wZwwYYmPItcmZKEt98qo+Mhh2KiQ
         R1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692315678; x=1692920478;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=25F8YYuLbjvNhO3HlPt4M0cUfz5VnLi83gNLVuSeAB4=;
        b=Z/OGcjUuJH3YwrbZelptWrmLwGVFFlF69MhULXIXyPwoAOc+BiYCvazdTlOd0fOUXV
         pRLGUjpbdEB8rJYRytaZ1+kYb4nwwriGFk2anM90yewsW64FysvZj/yHjAzRRQuUTVHR
         EksbBxPF9MaXTuoB/T7MY8s+UM6kA0bun+gMSMYLBrWo2j1SdbWmBAButS+2ojFNOPWN
         f8JZEuZ4ZOJ4+HxtNV6fpQzUsvBt0tB1wvQL/rxlVqwGG9clI0GgMqFxpeh8EIoLkVqn
         MBXy6ASXAGxRePk9NheHs7MVApiujqoS89PM7mlWYuYlihIIdc7yFL7ErqA0icaGWhM5
         nwKA==
X-Gm-Message-State: AOJu0Yz/w6E2tfEBjNho4f7VDgjNwA1XymFjY2vsMfDzMow+Yj7TAzZk
        RMKMjZGElaA/6203oGOh32gYCLs52vE=
X-Google-Smtp-Source: AGHT+IFkDF22iybvHPX6lg3hnpgEATiZYD+VWU1sap3dXt09kr+ZOxmv27SFflzuVRb5v/HO3klb6AhjFS8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad65:0:b0:58d:4ff2:58c with SMTP id
 l37-20020a81ad65000000b0058d4ff2058cmr84914ywk.1.1692315677997; Thu, 17 Aug
 2023 16:41:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 17 Aug 2023 16:41:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230817234114.1420092-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Update MAINTAINTERS to include selftests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Give KVM x86 the same treatment as all other KVM architectures, and
officially take ownership of x86 specific KVM selftests (changes have
been routed through kvm and/or kvm-x86 for quite some time).

Cc: kvm@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aee340630eca..2adf76b044c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11498,6 +11498,8 @@ F:	arch/x86/include/uapi/asm/svm.h
 F:	arch/x86/include/uapi/asm/vmx.h
 F:	arch/x86/kvm/
 F:	arch/x86/kvm/*/
+F:	tools/testing/selftests/kvm/*/x86_64/
+F:	tools/testing/selftests/kvm/x86_64/
 
 KERNFS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>

base-commit: aaf44a3a699309c77537d0abf49411f9dc7dc523
-- 
2.42.0.rc1.204.g551eb34607-goog


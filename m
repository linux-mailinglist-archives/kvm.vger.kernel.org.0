Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE305BF514
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiIUDx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiIUDxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:53:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1B341983
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-34577a9799dso41230187b3.6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date;
        bh=4XpPYlBUoO+WRk0V0AWUxRzw3Rg/SavqF4W61Vi+Vh0=;
        b=YI9YTrZeD2JX0QYLMS9rcEsnQKi2nn+tGC4bgSYbMP88F+TWT+sfC+ABpLRV9kABWZ
         7IgDYo1oeJdskEllVO50FzDiU7l7NtZW1ZjvRXgSBWwB/twXdM9CImyLjjepysc2aCFF
         FWhGgsOWXR8PXvJ5fSv5UJ+XWR3aq8m1fg37xeWmB5zdYkFPeDIHXAFb5eSxTKhotk9m
         SfDuXaI4J1IeLrvxsbOHF/LjFdfqyDNhi/bZh+cl4Y90aJQb1S845E1VB7M3fjogATDm
         1Iz7A82xrGtHr6v7V+JxrTSyfqLLEVxoCFAz+Ju1mqkNGkX9SSPkaQJgWyaHt7R1fdhA
         7Ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=4XpPYlBUoO+WRk0V0AWUxRzw3Rg/SavqF4W61Vi+Vh0=;
        b=aoIGOwklkmTUE/F8gEysPgl7+ugIhrq4UB/A+3s8L0bWKx3Pfs//AxuXvBmh2c/GNn
         +UNEmwMxvfS3oIWH28teQ3FeI87w9D23qWBnkMOZCqffv6LqU4EALQ+0lnSiey0hy56O
         5PP5a4uNudVuXapR7X9symQ86DQeK29AnxkyxvaV0D4O7c9XVqNqnygSYUwfy72WwQQo
         ftsUO3sBeL30zji4NibW58DqRsr1GLIBTDlN3Xa6WJShc7qgulx/BRC6PL4LoeHk2GtD
         sYwDP1yTvBDOGLbvV+C64JJhisJrAHYKKeMk5djPE8vayISFnlqSfzd6zc3cbnRY/Onb
         9mBA==
X-Gm-Message-State: ACrzQf2XLrkLkIxAf7LItXZKDYJ69xRhEZhp71K4txo+EGpF/sONCdcf
        UjzPtCBZnYc4xImQnrRLXfsQRmc=
X-Google-Smtp-Source: AMsMyM4h7TI5G+sFMd7rTrrgzthVtJC4/9i0nc1N+1MngQu+uhxfzMb9nU4Ew6v+tvv2pLYsS0wjV3c=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a5b:a0c:0:b0:6b4:446d:2f9 with SMTP id
 k12-20020a5b0a0c000000b006b4446d02f9mr9242835ybq.138.1663732390317; Tue, 20
 Sep 2022 20:53:10 -0700 (PDT)
Date:   Tue, 20 Sep 2022 20:51:40 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-9-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 8/8] Documentation: document the ABI changes for KVM_CAP_ARM_MTE
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document both the restriction on VM_MTE_ALLOWED mappings and
the relaxation for shared mappings.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..7afe603567fd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7486,8 +7486,9 @@ hibernation of the host; however the VMM needs to manually save/restore the
 tags as appropriate if the VM is migrated.
 
 When this capability is enabled all memory in memslots must be mapped as
-not-shareable (no MAP_SHARED), attempts to create a memslot with a
-MAP_SHARED mmap will result in an -EINVAL return.
+``MAP_ANONYMOUS`` or with a RAM-based file mapping (``tmpfs``, ``memfd``),
+attempts to create a memslot with an invalid mmap will result in an
+-EINVAL return.
 
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
-- 
2.37.3.968.ga6b4b080e4-goog


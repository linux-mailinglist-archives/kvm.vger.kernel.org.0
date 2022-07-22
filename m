Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F3257D829
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 03:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiGVBvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 21:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiGVBvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 21:51:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097E7868B9
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o135-20020a25738d000000b0066f58989d75so2633708ybc.13
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h8uEQ9pObe4PCZBHvRMWu04/OqsxiUE5izQACc/t1qA=;
        b=Ukex56V06NQTMwxsfTfflZTIhlPAb6x0ltdKx1zBysm7RfXqd7wFZZQRKyH0VzOFQr
         Y+L4jMyhTpQ+5w62O8ljEcGyetRTzpXeuJgVDGx43FYmUqMCaazs1z2HBznVt+e4xRTq
         8BTFjP0UISkfuw1zjrGHTk4NeN9Gui7Aq8k3JLm7lnIxA8ow7cBGdHuEknVOeG4Zq2jJ
         J9377HHBqBU/OmUz2MYbyVym3D1J4ix3ONzdHWHv+cgfaKXYyjSk51Fxzzm8xDa3ZIuJ
         bPVIvVXhJSKu35qiAyGNuqhVJ+94oMqsxGmrvFTR76HbL2jMIv5z7gCGfkLNOmC1jMDe
         iMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h8uEQ9pObe4PCZBHvRMWu04/OqsxiUE5izQACc/t1qA=;
        b=Ij1ip3AgRzu/zZZrIiQWdvkjBWwJaFD4/wxpb6J2c55Yi/4HIokxOqUfM432M7HzJC
         rCwr0A+oCDdQ8tJKluXX2TN5EEqr2xZju4oGIIFG5Tl2ZEWPzkjB2ENhnRGaMzJeYYdD
         hgyOPV9ColWbePHhbVrj5oQ9eGugX7j7rBse/w/OoHzLhJZi+N6/rTxOjsbtIuxLfo06
         XQUr3z6bCcw3ddwFuJT4OUqlEkjtQIASfS2Eq92dhx5/UewOwX5ec9AXI2NbH8HDAVfs
         wEQixw4fx1EJfVRaGYHzqLcwYcbQq/b2jiIOID8PwJJJaAlUopIx8GIorHycazXrMb53
         lk2w==
X-Gm-Message-State: AJIora+48K6WpQZ+PTCeWeP09FCaz3udBHyBMHhhEWmLDALjZLbEcG4V
        OBPkNBc01KxH4JofBXw0UVRFMgE=
X-Google-Smtp-Source: AGRyM1vtD7rOxtriQj5Ecvofp6SqMq07c0PbfEhxrYPq2ZOkp7UkUbp02IAcwvO8QMo59HdQ9f5IQn4=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a25:5ec5:0:b0:66f:b76a:c5e9 with SMTP id
 s188-20020a255ec5000000b0066fb76ac5e9mr1185482ybb.334.1658454672828; Thu, 21
 Jul 2022 18:51:12 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:50:33 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-8-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 7/7] Documentation: document the ABI changes for KVM_CAP_ARM_MTE
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
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebc5a519574f..5bb74b73bff3 100644
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
2.37.1.359.gd136c6c3e2-goog


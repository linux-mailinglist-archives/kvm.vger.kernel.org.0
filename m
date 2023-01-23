Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB70B67890A
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 22:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjAWVDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 16:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbjAWVDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 16:03:36 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87B9366BC;
        Mon, 23 Jan 2023 13:03:34 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674507813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u0DaW6+xUkZTOmdfdR63nZEEMc0/wQOkFz9Q14P/+yY=;
        b=fGQTyYJgYamLLrFp9IiLF+IyEzs/al43U+rzCny6lg7UWhzZ/SmERGHio2WAJxLTHJRQHX
        p4qoBBBozoOjVQbhH4O89YnnMxVU92mQroZNdHVogis1G6ScP+yLUiA9c8Iu9NjwV5Du5M
        i0Ir7zlCr8IOFkDvHjsOVzAWkM+cHt8=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] MAINTAINERS: Add Oliver Upton as co-maintainer of KVM/arm64
Date:   Mon, 23 Jan 2023 21:02:56 +0000
Message-Id: <20230123210256.2728218-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Going forward I intend to help Marc with maintaining KVM/arm64. We've
spoken about this quite a bit and he has been a tremendous help in
ramping up to the task (thank you!). We haven't worked out the exact
details of how the process will work, but the goal is to even out the
maintenance responsibilities to give us both ample time for development.

To that end, updating the maintainers entry to reflect the change.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 42fc47c6edfd..7323efcc1270 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11355,9 +11355,9 @@ F:	virt/kvm/*
 
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
+M:	Oliver Upton <oliver.upton@linux.dev>
 R:	James Morse <james.morse@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
-R:	Oliver Upton <oliver.upton@linux.dev>
 R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev

base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.1.405.gd4c25cc71f-goog


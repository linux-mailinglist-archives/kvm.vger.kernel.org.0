Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A18772A79
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 18:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjHGQWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 12:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjHGQWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 12:22:20 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0DD1711
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 09:22:18 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb982d2603so50277415ad.3
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 09:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425338; x=1692030138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UvlKkKGF/kFP9AffqyFNxO/Nk3ZjRfMjltkT5eP+nnI=;
        b=yaywMyegsUVAykdodkjlqrjCgSVozCCG3p2WYuAfCvJ1RQmLkZzmt+qbDqmQHDzUJK
         7UxZAcE/TzVEVtDSSRETGTWUcRgTjRkPvRfGB0uQxpPlJyuYQc5ITAUUk9YCHRKShjoq
         WrOWqdHDFoKUYacc8pKTxYAAB/9nRCMYHvblka8Fp0OdQp0knuaFjpCO/TGJfIuceGBe
         Djp3idxnp9oKc/JhAUuRNSZDv0CWkJ1p+SnsetlZYE1IBYTqVW8x6dfx7hBEUVI2+d8h
         Hhes5lNy2UIgD8VNCi8kZiXYqqHnl7KJJD4xFD4atVxXKToc3y5Z4dI2ewVfWTed3V9V
         5Qxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425338; x=1692030138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvlKkKGF/kFP9AffqyFNxO/Nk3ZjRfMjltkT5eP+nnI=;
        b=mEurpqSQgRU/5y6FmmVa6foii4GNJkQq1xGWgS0eUDy6XvXBKk43ubnqe1v7TiJrBJ
         8B+AmVBZSCRgi1ZWS+hOFh6fP4zdVCRtIvafuBXf4Mj+jMo1gxB5Fa4BRX5ChVeq3P8b
         j0tYe/x9mJMFcRYG1Prkx7aJsUQPhhOuDQJA/lhUxaLXyRHU7XH7fSgIXCLu6a6sPzYm
         vMNyaQtTC5l8Dckv0C+8wUvOif11rN23/FtgrCp3ObvCezOXWgYtIQpaGFK3G4pxYue0
         7EVX/2a6qFeaVHNDhV/Gu7dOvfD5GhAaKnEBPDOxcQb/kJsGAw7IHK1z8On81CFtnUj2
         iAOw==
X-Gm-Message-State: AOJu0YwOQ4X9DY7Ct00yCa1uwbSQRyu7foOVlOgge+fBMPwXOc0UvHnQ
        DsrhUFmuvv8N07GTXD1sXds8TSh3EtXA067TORBSwV3iPFoByvRoymUbmdnfBf29Jl3suaTOzEk
        Sfb23a0tnNC/aUG59zxqr1SlSWbLhVhSPjPkmfKU0WeSf4v2qJp4j63gIP7DGCsPlzTRA+Bg=
X-Google-Smtp-Source: AGHT+IGuXkq8LTZnL60VWKI+SwwrejjgXSyjSRwPgRFDyLKb6Xmr9dv6PXaPAY+M9cQo6KA3Zecp2f5PvwBqysYNpA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:e748:b0:1b3:e4f1:1b3f with
 SMTP id p8-20020a170902e74800b001b3e4f11b3fmr36931plf.2.1691425337815; Mon,
 07 Aug 2023 09:22:17 -0700 (PDT)
Date:   Mon,  7 Aug 2023 09:22:00 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-3-jingzhangos@google.com>
Subject: [PATCH v8 02/11] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
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

Add some basic documentation on how to get feature ID register writable
masks from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c0ddd3035462..92a9b20f970e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6068,6 +6068,35 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: none
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct reg_mask_range (in/out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+
+        struct reg_mask_range {
+                __u64 addr;             /* Pointer to mask array */
+                __u64 reserved[7];
+        };
+
+This ioctl would copy the writable masks for feature ID registers to userspace.
+The Feature ID space is defined as the System register space in AArch64 with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+To get the index in the mask array pointed by ``addr`` for a specified feature
+ID register, use the macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``.
+This allows the userspace to know upfront whether it can actually tweak the
+contents of a feature ID register or not.
+The ``reserved[7]`` is reserved for future use to add other register space. For
+feature ID registers, it should be 0, otherwise, KVM may return error.
+
 5. The kvm_run structure
 ========================
 
-- 
2.41.0.585.gd2178a4bd4-goog


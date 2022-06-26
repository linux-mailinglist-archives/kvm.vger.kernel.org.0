Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE1F55B0BF
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 11:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiFZJLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 05:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiFZJLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 05:11:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0538512A94;
        Sun, 26 Jun 2022 02:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D63261187;
        Sun, 26 Jun 2022 09:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E51C341CE;
        Sun, 26 Jun 2022 09:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656234670;
        bh=8FZLUqXlt4kX0eBdlVb+sYAB98PK6Yu7ycSI8qBBmeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihh4Didv1uMwr3X/E0EFfQ5nIcDRiiCd44NN5clCMtqQqM2T95eOp1oP+BTInBuvS
         lMfu2VVwxhFJevYuOT1mv+SHvmD786Yy04YFxWLzOQJ346BDy/sC7280gZZSqGP+uM
         cltz3Qh+vCegNGmfzIDMxvHVTPW5luu9QJQmwQVwbSxOQas4eyBN7khX1QGsr2b+H+
         pMIJ7bOE/bnFvSoP9ArDY7Oa9CyczyaG9lOGxxxFq6WesoaD6KXRR509/dnf1ZQEdU
         RRKadWSmx/9n8QxW73uj/ySOiZXbJmn5hD56dfG+FxktNpL5lYeQpJq1sow5Xf5umU
         PFX/JLZSSv1Bg==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1o5OIO-001cow-3S;
        Sun, 26 Jun 2022 10:11:08 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/20] Documentation: KVM: update msr.rst reference
Date:   Sun, 26 Jun 2022 10:10:59 +0100
Message-Id: <5652b7f5caff3b817a660b75f1f319a2f8962380.1656234456.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656234456.git.mchehab@kernel.org>
References: <cover.1656234456.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changeset daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
renamed: Documentation/virt/kvm/msr.rst
to: Documentation/virt/kvm/x86/msr.rst.

Update its cross-reference accordingly.

Fixes: daec8d408308 ("Documentation: KVM: add separate directories for architecture-specific documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v2 00/20] at: https://lore.kernel.org/all/cover.1656234456.git.mchehab@kernel.org/

 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9260152c37cb..41afd1125cb1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7894,7 +7894,7 @@ architecture-specific interfaces.  This capability and the architecture-
 specific interfaces must be consistent, i.e. if one says the feature
 is supported, than the other should as well and vice versa.  For arm64
 see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
-For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
+For x86 see Documentation/virt/kvm/x86/msr.rst "MSR_KVM_STEAL_TIME".
 
 8.25 KVM_CAP_S390_DIAG318
 -------------------------
-- 
2.36.1


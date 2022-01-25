Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3D49B116
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbiAYKCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238381AbiAYJ7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:22 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DB4C06173E;
        Tue, 25 Jan 2022 01:59:20 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id d7so18734260plr.12;
        Tue, 25 Jan 2022 01:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MQeM6vIxMZvFlKo4v9hbzR1rquivdNYZS0j3o7B/fwk=;
        b=S/XB1UxNdTAu3Pt96Tx2FkHJeD7V1KI5QaimN/TSbPStOm23ogD0frWiuy4Gjvut+v
         YZnf+wOLcvtgnN6k/Zt6EP+ZK+lLKYPMGnu0UOpaXHq2fq4VaZQyZeJBLEseuzlTFfyb
         93M8Dc0wf5bXyTjY3CtAFrxJdZXKRed4n5MhgfeYzmZ4moD4daebq05x+7YoZkh4gVkT
         wW3AfMIIMQNRChxBSy5K+djQE+LpyHIK4jpotGxt/kbyrHxAg/8HaTpvJdX/Y/A7+wL1
         5FF4mDE36SbkZm5MI03NL9VXB1iwDpfFsQ9E0v9kfkJ5DYlWVRWwWbKHLe7mc3Iv8lXe
         3rkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQeM6vIxMZvFlKo4v9hbzR1rquivdNYZS0j3o7B/fwk=;
        b=Wq6VwrBI852Q5pZbS6bnPXQLNPx7h5I/SW6vMaPuW1lHFI5nTsA28OY+tNqm9cEtTm
         7gvvpiqyidQlRqlE6BvXs9R35aBWxm/GoP+falaLiw8xoQjekWofmbpGvqds3aYvmarK
         xNBsUcXyNM+CefHv7H5ILglEj5IUEwmekHEivf2Nh+Hr09VGjQJXNQn9XV6IEeSECREc
         ciKC6LYVDpvNStTjgAmDbz0CFwdxI/B2d52cncO3UchcVD5xv6Z/8svrkbSeoG+JngtC
         KWftL13lO5NcHyl0RCV88NECRP9Z/5BArwiFBhb4IjJsb1wtKyAACWxEz1ncPCBnv5AM
         D+/g==
X-Gm-Message-State: AOAM533kveZ7WzR7lViFvFj+WcoUEUEyuR5Y8qzE9kmcX5xTjcwbwhpB
        k25UbMHB4+i01Hecv0emQqfo31OemgXxfg==
X-Google-Smtp-Source: ABdhPJwApbcOM6iYH3gdbKpV8Q3BpENbIjt5SquZUGzAwxYkKwLk1g70YihEKH+jBj+vtAol5vsxFg==
X-Received: by 2002:a17:903:41cf:b0:14b:5b0:484b with SMTP id u15-20020a17090341cf00b0014b05b0484bmr18518725ple.155.1643104759854;
        Tue, 25 Jan 2022 01:59:19 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:19 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/19] KVM: x86/mmu: Remove unused "kvm" of kvm_mmu_unlink_parents()
Date:   Tue, 25 Jan 2022 17:58:51 +0800
Message-Id: <20220125095909.38122-2-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm *kvm" parameter of kvm_mmu_unlink_parents()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 593093b52395..305aa0c5026f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2307,7 +2307,7 @@ static int kvm_mmu_page_unlink_children(struct kvm *kvm,
 	return zapped;
 }
 
-static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void kvm_mmu_unlink_parents(struct kvm_mmu_page *sp)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -2351,7 +2351,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	*nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
-	kvm_mmu_unlink_parents(kvm, sp);
+	kvm_mmu_unlink_parents(sp);
 
 	/* Zapping children means active_mmu_pages has become unstable. */
 	list_unstable = *nr_zapped;
-- 
2.33.1


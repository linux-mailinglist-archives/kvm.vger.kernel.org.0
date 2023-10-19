Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABF27CEEAC
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 06:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjJSEeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 00:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjJSEeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 00:34:00 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BD0121
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 21:33:58 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1c9c5a1b87bso54247265ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 21:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697690038; x=1698294838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1sbBww99CRG5Ar6AdVSepMD9dC8OWDbKNMdl1TqodoE=;
        b=a5xmDQoqWy86EdRV8gldjbSt0k75J1Be3hzb/gz3g7enntZNzGhdXtbw6wAZPXHsoA
         +8Y7Tp7q6uqEvXlWySJ1hROrAd+m4XvBlSIacZgfvJKzqp8nK/5ejaH9tDCeRQgsEk6i
         78rQkyAfVDN5G6hakrOSCuEa9FS7kJeGKb5BbISv9SUWinwjCiQ8PXrLaT7oNqtEEN3G
         1IoEqqQjND+ZvWeU5eTBKO3LpVz7H9ckzSAJEWg3sw8X49fGtTECcf0tW59bw056Oog+
         fSTFoP7Try4JL11Ib3sy5WWwOQnt5BTtU97T2CmUBLxfiHlcIf5jecb8gekJjKVLnx/R
         aPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697690038; x=1698294838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1sbBww99CRG5Ar6AdVSepMD9dC8OWDbKNMdl1TqodoE=;
        b=xFDoiubsoM2Nm4Y9nsa3x7DFWNm7BdCTPHHFz/rQOMBPE+VmAr8bWsiNvok4rkuQxG
         d75J3dwkhiLfoXQfpY/X6f4EJ0FDEcmog284VfXfr3+1ikJ5GIbceGEBQdfv8NAY/evK
         6VQiAKM+nAqyrp5l8SPBZfH2xTWOE3Bq8e5HDq/5m1CI3hAqMWSd9c1wnT1yZyyM/lOC
         OuZ66f/HNvqKK+/FTEzRZRKrtNN0oKFdjX13m9jFhwsC91p3UNPiK9B+R8uByjXKmOF9
         r3uHrAoWSCa/rtXuscdsu+x+WKDDN+3WPqPqJKdUHfssxOPuzTUaNw+43l2X3KHHep/X
         8mVA==
X-Gm-Message-State: AOJu0YzXVYAuj4GBV8rj9dfMr6HiVqct50NBekekmvPamwlR4GqyVjWy
        jb8AfZTnyubkKBb4LlcXskE=
X-Google-Smtp-Source: AGHT+IFuOLCsg5qbrfBMvNJkgJQmD7Np5zKoPLDixPduJ9QHco2908FHhXtisbQ9lxNFNirxTBT+KA==
X-Received: by 2002:a17:902:ec8e:b0:1c3:c127:540 with SMTP id x14-20020a170902ec8e00b001c3c1270540mr1524294plg.29.1697690037955;
        Wed, 18 Oct 2023 21:33:57 -0700 (PDT)
Received: from localhost.localdomain ([108.181.15.109])
        by smtp.gmail.com with ESMTPSA id jk4-20020a170903330400b001bf5e24b2a8sm776599plb.174.2023.10.18.21.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 21:33:56 -0700 (PDT)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, liangchen.linux@gmail.com
Subject: [PATCH] KVM: x86: remove the unused assigned_dev_head from kvm_arch
Date:   Thu, 19 Oct 2023 12:33:36 +0800
Message-Id: <20231019043336.8998-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Legacy device assignment was dropped years ago. This field is not used
anymore.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/x86.c              | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70d139406bc8..f43065b08cbc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1275,7 +1275,6 @@ struct kvm_arch {
 	 */
 	spinlock_t mmu_unsync_pages_lock;
 
-	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
 #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 41cce5031126..3b450f697678 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12326,7 +12326,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		goto out_uninit_mmu;
 
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
-	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
-- 
2.40.1


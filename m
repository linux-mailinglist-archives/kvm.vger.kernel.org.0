Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966FF649A0A
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 09:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiLLIeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 03:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiLLIee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 03:34:34 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F663DFAA;
        Mon, 12 Dec 2022 00:34:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so14911901pjj.2;
        Mon, 12 Dec 2022 00:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3XG1FDSbN84YuWL1rhQtaPSVYHFaS7/iTj3wcBHrbpA=;
        b=i2fkxJzf2YX4Ip9wNBJZ27KQGAbQLzBnlHnRn5qKMHlTU/PNg4qTp2IgGNKrEsmvDV
         ySdhelDfiYpTINSawG1WHEjuhE0llMwZ6GqWA8Kv8xmtBlMPvS7dyfA8Fnh0pFgXtMv5
         MxJ69fFa8xEDPO3pn4gmXatB+9J/ibO4SZ7esoXWztb3JPYX1KS6ya/BGoEhiyfIHYfx
         RWvx1pxfkehwdOK6Iq/b5D4PoN3VDBhA/l42XhDZKfkanAjOdgyK90tOjbmV6KiEicah
         ZZLGsgi2k2sx+ehi35fgZbWxTQy6zF57VtJcULQ1QUjUVyp7LqV7Ktmi4IReNDhRUcB1
         GBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3XG1FDSbN84YuWL1rhQtaPSVYHFaS7/iTj3wcBHrbpA=;
        b=w/DanRSJkR3g/7WMtEzFUfYex5ix2mpQXyTvGUMB11m/5wMmeODD6TPtXsrHELZPOR
         WcN49rfgsCaOIDAS0c3jFtRzP0Sx1ja4Hul1JzO+55DC2KuuVNuMAwESxsXG887jXGr8
         ZokzzZrHLv+xBV0lvTMP3Edd7AABdOAWyyO+CXCX6J31ZXG9OTm1ozzrg1f+p91Kkwfs
         IyWRL3cdtOjTGzGUoz27E553iE+sflPhDxQDn79OnwZNdaUmxXze7PkHZrPsrdLp8pQB
         zclvkgbJli+IV9vp60qqZfXuFXrmmoS22PGwlVle61C3anaC5A9TV5gwzWBptXfIP1PT
         mFsA==
X-Gm-Message-State: ANoB5plUCXss/1xxnHoKloGkFHWAKpiYB737Ts2Iilo5+jzQ7kmcpBlL
        CJHexHqsCJxgj44hEvJqFh8CYcil0Vw=
X-Google-Smtp-Source: AA0mqf7JLqOZDyRUzgsSZ3ieAVTRHEhjsl6mQtIikpRXgKnjSzDNs5+LOxw4IWZQ8sSsg/dJYOgrLA==
X-Received: by 2002:a05:6a20:c194:b0:ad:600c:54b1 with SMTP id bg20-20020a056a20c19400b000ad600c54b1mr8199425pzb.59.1670834072041;
        Mon, 12 Dec 2022 00:34:32 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id r19-20020a170902c61300b0017a032d7ae4sm5703554plr.104.2022.12.12.00.34.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Dec 2022 00:34:31 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH V2] kvm: Remove the unused macro KVM_MMU_READ_[UN]LOCK()
Date:   Mon, 12 Dec 2022 16:35:32 +0800
Message-Id: <20221212083532.369940-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

No code is using KVM_MMU_READ_[UN]LOCK().

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 virt/kvm/kvm_mm.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index a1ab15006af3..180f1a09e6ba 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -14,14 +14,10 @@
 #define KVM_MMU_LOCK_INIT(kvm)		rwlock_init(&(kvm)->mmu_lock)
 #define KVM_MMU_LOCK(kvm)		write_lock(&(kvm)->mmu_lock)
 #define KVM_MMU_UNLOCK(kvm)		write_unlock(&(kvm)->mmu_lock)
-#define KVM_MMU_READ_LOCK(kvm)		read_lock(&(kvm)->mmu_lock)
-#define KVM_MMU_READ_UNLOCK(kvm)	read_unlock(&(kvm)->mmu_lock)
 #else
 #define KVM_MMU_LOCK_INIT(kvm)		spin_lock_init(&(kvm)->mmu_lock)
 #define KVM_MMU_LOCK(kvm)		spin_lock(&(kvm)->mmu_lock)
 #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
-#define KVM_MMU_READ_LOCK(kvm)		spin_lock(&(kvm)->mmu_lock)
-#define KVM_MMU_READ_UNLOCK(kvm)	spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
 kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
-- 
2.19.1.6.gb485710b


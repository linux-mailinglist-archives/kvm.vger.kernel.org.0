Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B0649755F
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 20:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239742AbiAWTxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 14:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiAWTxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jan 2022 14:53:17 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D730C06173D
        for <kvm@vger.kernel.org>; Sun, 23 Jan 2022 11:53:17 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u185-20020a2560c2000000b0060fd98540f7so30850472ybb.0
        for <kvm@vger.kernel.org>; Sun, 23 Jan 2022 11:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=X37eMl3APSVy1gq/GXP9UYLX6M5sd5Ovz0EUG6x1n+Y=;
        b=Hz6Aa5t9vfsTBNkKfqva2R1u6XTxPFGed2nYoSSrtt0fZIMaeQVvRKP1ylb1So7f/Z
         qYDWNWnhyu+HlM+qlPKaz6SnvgzuAnVJmukXQsyKFv8Gz7chPxZLKgrp2ljIkQ+yd9GY
         2qxpNTPp9ulEX32ctHsjYefVqijkK3819B0NnKiwAurc7/WaY4G/09V6001gm7ZKUjZs
         NqCGx61PDrzpVBp2VocuhCqUcmlO6f2JvfGJJBZEJAnNQAMgWX9aBqEu8HvGtHGrMdPV
         PufY/lRNSP2tk1nO38pOy3D3llR/guvFVhPb3Nv/sSp9Ww8zD1NIFkwu4/R6kB/naaiG
         /CXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=X37eMl3APSVy1gq/GXP9UYLX6M5sd5Ovz0EUG6x1n+Y=;
        b=7vdn/NR/ARB5JvGEwMwOU5A2lDulkGfYaO4dcomtINu1Gjw1O8H0lUVo1456nNsJR+
         1UJls+1TkGAhD0rYTYlqsZ1xz0i5CNHyWjl5+oK7xmHEaJd6iC02SSZkUkx65bJKBajq
         yRP1oH7aSpKJ0lqohGcNFisSNOn2GNBQ5lDaW21BoEpvHGFnR5yYhqgs5o16kon3ZcKo
         UEdpOO1b87hSfe+v0WNTlBj3o7N7onzZhlJ+0v3c1q891cneGs2tjVSmXQIMQTuxkgBF
         5wwuPHdsojrExeYaO4uEb1COMUky1pi10iYmUZKGmj+DB1YfrUUE2vzcKSgM97Y8Ia5v
         i0ew==
X-Gm-Message-State: AOAM532vfEy7y7Xznd4CsnizEhyI4E7/wLIKfsJuwQIR7k9C6bwAElay
        2Q00lRLYBOMYNVnKbMYRv6atx6vjPcZu/bUfXw==
X-Google-Smtp-Source: ABdhPJwzbwUXVIFTTHrzK1en80KpUAaBmklZhi5KzK/vPdoK2wpFfl2nyD4+1PpYcjCNNqrT/L0T+W/JhwLNXICWmg==
X-Received: from ayushranjan-desktop0.svl.corp.google.com ([2620:15c:2c4:203:9c4d:cd55:e8a3:9536])
 (user=ayushranjan job=sendgmr) by 2002:a05:6902:10a:: with SMTP id
 o10mr18148218ybh.104.1642967596309; Sun, 23 Jan 2022 11:53:16 -0800 (PST)
Date:   Sun, 23 Jan 2022 11:52:39 -0800
Message-Id: <20220123195239.509528-1-ayushranjan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] x86: add additional EPT bit definitions
From:   Ayush Ranjan <ayushranjan@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ben Gardon <bgardon@google.com>, Jim Mattson <jmattson@google.com>,
        Andrei Vagin <avagin@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Pratt <mpratt@google.com>,
        Ayush Ranjan <ayushranjan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Pratt <mpratt@google.com>

Used in gvisor for EPT support.

Tested: Builds cleanly
Signed-off-by: Ayush Ranjan <ayushranjan@google.com>
Signed-off-by: Michael Pratt <mpratt@google.com>
---
 arch/x86/include/asm/vmx.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..c77ad687cdf7 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -496,7 +496,9 @@ enum vmcs_field {
 #define VMX_EPT_WRITABLE_MASK			0x2ull
 #define VMX_EPT_EXECUTABLE_MASK			0x4ull
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
-#define VMX_EPT_ACCESS_BIT			(1ull << 8)
+#define VMX_EPT_PSE_BIT				(1ull << 7)
+#define VMX_EPT_ACCESS_SHIFT			8
+#define VMX_EPT_ACCESS_BIT			(1ull << VMX_EPT_ACCESS_SHIFT)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
-- 
2.35.0.rc0.227.g00780c9af4-goog


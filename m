Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0469E453A49
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 20:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239756AbhKPTm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 14:42:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236700AbhKPTm5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 14:42:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637091599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vUm/TldBGul3tXTFoBTYvPf/CBw3dYy/5GqR7NLE5aM=;
        b=N4N2g2iIyXof+U9nBqg3SXdYqTFdls0Fky8GrC4XJRq298hJIFe7FSW7qYf8A+YGhlkkDF
        Wdi9LH5AYI4AGzLz7JLYNxIKyuRAP0eyS1O7QztVPSLIKSv/mPkrP8PLpZsTqHQYXKOuCA
        pMxLBkr1goTortUOsbTR6kuUc7pe4g0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-x4ghApwSNY6Sq1v8PCIJoA-1; Tue, 16 Nov 2021 14:39:58 -0500
X-MC-Unique: x4ghApwSNY6Sq1v8PCIJoA-1
Received: by mail-wm1-f71.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso1657535wms.4
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 11:39:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vUm/TldBGul3tXTFoBTYvPf/CBw3dYy/5GqR7NLE5aM=;
        b=vgdRnpZt72Z7yxirRpHMNMxbunNxxxbtkQcUeUdbABGRFkSnImy4xFcAl+JwYjIsH5
         5aN4M0RUZjbYNnJwiNgaypsF1Wy4ijKf/KezTCG2FfaYTTEGS/lsSNG+vi3CtQ87mZGH
         8u+kjSxpXKl7yWagEO3LDHE/Q56wKQLuxLKtei4HyGieN7alR4DA8cyZhr07NGvE7C0C
         Ywe8RLuROrn0/+8vJ0FOiZ7+lIFznigGxDHjOMLZnZC6w0Y5ZK1A44jwSu8+9k0xKJUG
         rzbAf6krZkHSFCeULO1dF+gs788su7bp7jJlH+hmQYfPntHEjFdWiHYeqy0ZqmlYAKqr
         TpQQ==
X-Gm-Message-State: AOAM533dphqizOxrED3eh8UH70rCxeYvJfbjrcAGd4nL4+lcZhspV06A
        CQl0+wf4XlNwwo/oqS7yd48kxF5PhXwNhapmN02EXYeHGVFcgUFTl3jSVXdlfWcV2SaqhVl4EPv
        izqzZCqi5EP7z
X-Received: by 2002:a5d:6d88:: with SMTP id l8mr12099844wrs.270.1637091596792;
        Tue, 16 Nov 2021 11:39:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjY6Ggy48Sz4Z7KSFG/UEcnlEmgFThlxSG+OeC1hX1jIxFW4ooC+TV0bBUU9e86E9prClV6w==
X-Received: by 2002:a5d:6d88:: with SMTP id l8mr12099825wrs.270.1637091596610;
        Tue, 16 Nov 2021 11:39:56 -0800 (PST)
Received: from x1w.. (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id j19sm18354634wra.5.2021.11.16.11.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 11:39:56 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-trivial@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH-for-7.0] target/i386/kvm: Replace use of __u32 type
Date:   Tue, 16 Nov 2021 20:39:55 +0100
Message-Id: <20211116193955.2793171-1-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU coding style mandates to not use Linux kernel internal
types for scalars types. Replace __u32 by uint32_t.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 5a698bde19a..13f8e30c2a5 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1406,7 +1406,7 @@ static int hyperv_fill_cpuids(CPUState *cs,
     c->edx = cpu->hyperv_limits[2];
 
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_EVMCS)) {
-        __u32 function;
+        uint32_t function;
 
         /* Create zeroed 0x40000006..0x40000009 leaves */
         for (function = HV_CPUID_IMPLEMENT_LIMITS + 1;
-- 
2.31.1


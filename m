Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B31E61C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 02:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfEOA2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 20:28:20 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37871 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfEOA2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 20:28:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id p15so413504pll.4;
        Tue, 14 May 2019 17:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hnc8cznRhYvEAOZ3BRQNnfK9FHmywKk+08nAcSSfYMY=;
        b=tlNOsJIVMuq2Haokf4av2xT9NaQbpQaKdW2+XmSkOAj6f3EOu5K0ADEtfUb0kvn4CK
         uOVx0u/7RVvw1B0BTxhRr6VvScBagqCHQPSr6zIe8jdJeaTBVwXHpcyXmyUXD3rWjuVk
         jb1lugDhjvbYYzJUcxuqw18wOtsSLqrzqMRQC05SeEAKViVjL4vLRyshfyeKZxZmS6Yn
         xz2rTfP53XTnrGjpNJfMkM3Fgoc55diP7+Z6phv5ArsZlUjT/InwLhRo2x/EKKBmV9RA
         CSeqKR+isS8wEilish5TVi+pjO4ZoKrCRVgt0akffc9//5eNSql67U3gobUuUB98vy6B
         60MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hnc8cznRhYvEAOZ3BRQNnfK9FHmywKk+08nAcSSfYMY=;
        b=j1WQIgI/TGYR2CpcBLaHp/Fbd6b3gPDFpQDXB6RnTiUe6R1IIeDMK59mrzwSqVJzja
         LI6rF4Qd1MNqBpkzKrXIMnM8F1l/jfkBFn2kVARGoR22tK041th3/79/3SSiHWxvMl7p
         dKPitV1Oc4oi8RX0HleNVi9fJO34Gfv3o/VaSkiQnsqYHAYmNx+Oc1zVPnPXtoCDhRbs
         F7Tw6PXgCqiXVqRUX1rFoQqzzEpJ4qVDmuRCumMKZ0OyUae8GV9rgG0VcP9f/vG2IZee
         gat99CeUU3RGjeZoVYgIpWimZEcpnKRr1XvFff2rHqVfihd9x+w1FsTFWTT2m9oDTmTx
         8oFg==
X-Gm-Message-State: APjAAAVNQxgohSlCyELoax4enY4NVZ88CDgAYk6Uv6+Mr2VtVtceWaBc
        xhjDY4HzsaZfxBXfSt8nMT7YPbpX
X-Google-Smtp-Source: APXvYqwFHEh87hcCLCaEyqi0/kpApBt8yMnJXmhhd6QQZm3J48f3nSsjX/TKkB5Dwbc7p3watBk0Jw==
X-Received: by 2002:a17:902:e785:: with SMTP id cp5mr21917647plb.167.1557880099260;
        Tue, 14 May 2019 17:28:19 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id o2sm281374pgq.1.2019.05.14.17.28.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 17:28:18 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        dgibson@redhat.com, Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [kvm-unit-tests PATCH v2 2/2] powerpc: Make h_cede_tm test run by default
Date:   Wed, 15 May 2019 10:28:01 +1000
Message-Id: <20190515002801.20517-2-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190515002801.20517-1-sjitindarsingh@gmail.com>
References: <20190515002801.20517-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test was initially designed to test for a known bug where
performing a sequence of H_CEDE hcalls while suspended would cause a
vcpu to lockup in the host. The fix has been available for some time
now, so to increase coverage of this test remove the no-default flag.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 powerpc/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index af535b7..1e74948 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -64,7 +64,7 @@ file = emulator.elf
 file = tm.elf
 smp = 2,threads=2
 extra_params = -machine cap-htm=on -append "h_cede_tm"
-groups = nodefault,h_cede_tm
+groups = h_cede_tm
 
 [sprs]
 file = sprs.elf
-- 
2.13.6


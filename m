Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50D349B149
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbiAYKEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238530AbiAYJ7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:47 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02508C06175F;
        Tue, 25 Jan 2022 01:59:47 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id c9so18743507plg.11;
        Tue, 25 Jan 2022 01:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xy58X9ZqsU+Q+x1fD7dGP98jr1M3OQ5O7hFyw/uTpBo=;
        b=K1csWq0YFWq17jyYUVKdjSWRmI9iFTTulrCS8E81NVmcF5tVCX3tYwOWDkjGG9uDgZ
         S71g6dScNDDK2kJIyb2zRwlBRLJTTbhLWCO645QTYytf+zmY+jUpVtCGl+Y8+mNl/Ood
         VEWfj0YcCnbZkgUh/bExJckvquMNY6e0BUEhYRgi3aCmG/rJR4Bsy6kjcYzIWKOYd7sO
         LWHfi6ey9ev+O5OGhH0gHOWYUP4Hf7rJclBZMvxDrfO8llYsi7P+3se3Q4I/RACKbTXL
         uZULM8kNpohHbIkOhTDcHenEGFdd9PhcwuvOSi+qILGzQMK5+N1h27WtT3Q5kTqIHBJm
         8vFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xy58X9ZqsU+Q+x1fD7dGP98jr1M3OQ5O7hFyw/uTpBo=;
        b=lfbgLCbeZ9xJ757YWtxo6wX5QOjd/D+dzSslWolgFweSfBMn3fXEasblRvoGlrB3wg
         r7OODd4b/zvIMCJbFfrb44gmzqB+WOT7Nj4fU87pYy+UsuK0AmX7AzSUThYWqPIQIX0m
         YUV0zGra2otcOfW5cOFSixbAqRRAE9QZUx8xhCiiscX63Tw7ItAvKsbaONRzZRkYWK9d
         QW0K0vIHhBXBIFv29LIaIXiQpljrYxCE4t5k5PfEdNOq1aPmIfy22gWrdBfq8Iqt7bYP
         osmr/gOkiNQOI3oLxSuvNbIfAzTkprH4EFZPn01K/Hz13MdpRl1nrvWgmp/bU3LSbLJa
         bONw==
X-Gm-Message-State: AOAM532eDyDas/kOPoDztzgBMD5q0OdZtQLoWh22WulDMa7g6MTyzCBS
        rUJzfqCN5qKir0edeUVxB2Q=
X-Google-Smtp-Source: ABdhPJzhUcAag9bH49+qyomod77yB4zrMr6c2mVnNwikP5K8xDfXGKVEcCyL1nqCdpa2kl1JeFxt0g==
X-Received: by 2002:a17:90a:5503:: with SMTP id b3mr2630839pji.187.1643104786499;
        Tue, 25 Jan 2022 01:59:46 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:46 -0800 (PST)
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
Subject: [PATCH 12/19] KVM: x86/i8259: Remove unused "addr" of elcr_ioport_{read,write}()
Date:   Tue, 25 Jan 2022 17:59:02 +0800
Message-Id: <20220125095909.38122-13-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "u32 addr" parameter of elcr_ioport_write() and elcr_ioport_read()
is not used, so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/i8259.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 814064d06016..be99dc86293d 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -437,13 +437,13 @@ static u32 pic_ioport_read(void *opaque, u32 addr)
 	return ret;
 }
 
-static void elcr_ioport_write(void *opaque, u32 addr, u32 val)
+static void elcr_ioport_write(void *opaque, u32 val)
 {
 	struct kvm_kpic_state *s = opaque;
 	s->elcr = val & s->elcr_mask;
 }
 
-static u32 elcr_ioport_read(void *opaque, u32 addr1)
+static u32 elcr_ioport_read(void *opaque)
 {
 	struct kvm_kpic_state *s = opaque;
 	return s->elcr;
@@ -474,7 +474,7 @@ static int picdev_write(struct kvm_pic *s,
 	case 0x4d0:
 	case 0x4d1:
 		pic_lock(s);
-		elcr_ioport_write(&s->pics[addr & 1], addr, data);
+		elcr_ioport_write(&s->pics[addr & 1], data);
 		pic_unlock(s);
 		break;
 	default:
@@ -505,7 +505,7 @@ static int picdev_read(struct kvm_pic *s,
 	case 0x4d0:
 	case 0x4d1:
 		pic_lock(s);
-		*data = elcr_ioport_read(&s->pics[addr & 1], addr);
+		*data = elcr_ioport_read(&s->pics[addr & 1]);
 		pic_unlock(s);
 		break;
 	default:
-- 
2.33.1


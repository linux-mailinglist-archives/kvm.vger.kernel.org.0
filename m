Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D22315CD46
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 22:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgBMVat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 16:30:49 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45226 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgBMVat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 16:30:49 -0500
Received: by mail-pl1-f195.google.com with SMTP id b22so2839663pls.12
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 13:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7j+aqI6mcS2t54y8WBsKTQVk+8Kre6NazUv5XEvuQ4k=;
        b=VKYav0f415oiCoOPWgkmakg0CHFwQ9wtx/v0IZR0l+/KzKbQZo8nhG4j6/qlGqCvkR
         t2e2E8bXWSu06Lo5rZ8AvBuhmyvIffq9XAA2rceEQybe+5PgYkKCMlzeGmrtjjXdNcEJ
         T8TW+MibuMZArOxM0MlqTseRz8vv0+sB/oEuVlXfQXE3yYulvvnvUfKpTRl23LJ2CZhy
         oFTFTiFUefC52HPGukG8BK37jJ0ddMaxp+S6zu+py+UvQIwsbymAnBMfq9UKrl5/HZw5
         ciXNUJhJoR9sbs0/2FcadbW5nVJAW6pbE3a4kdWBnZETwqTgfVTV46pU2mY7jjQM9F8x
         ejBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7j+aqI6mcS2t54y8WBsKTQVk+8Kre6NazUv5XEvuQ4k=;
        b=C0mmkwzMTG8ZxFSmpFFkPT/a3UPy1YvVIvrSyZvIY+1t6S2nCb0DyF9zEb0eT6fqQI
         4yi85Nm9v+XJ04ATlJ4AGj2syQP5zovr+7KksIQ0CpnJUF6bV6GxAC9OswuW/pDUK4fY
         B8DpbYgY+IoxGn6cqXOOXcd4Z0gAZD9PBXcph3oalsUrtGx6vNcCpnLCA6xXDxmYErXn
         jsADhAgInEBLXi6N2gMEGr0TKt7/P4xteLyfW3+kW7FTJ/WACnwJEVENzHQgHEubTihR
         3H2MyUYzIMmp6TNNB/XGPlZGhj7pcux50YEoKk1bRWA6cpoEeVIZ3F0dG14YkWBHY6YD
         kitQ==
X-Gm-Message-State: APjAAAXpM6DQa7vhjALwOzn9IjzqHGYxMz1M23JrL/IIHip9cnqh8AYk
        fGL4cF0qkbtUy/CB0Lwrj+ityt7A
X-Google-Smtp-Source: APXvYqwcfvGpQWXobqIwyn10/AWqbi/QWVme4KdemjFiaVWwsLy9ZrLAzxGbTP303AVgbN7atSEmbA==
X-Received: by 2002:a17:902:9687:: with SMTP id n7mr31124873plp.168.1581629446812;
        Thu, 13 Feb 2020 13:30:46 -0800 (PST)
Received: from olv0.mtv.corp.google.com ([2620:15c:202:201:9649:82d6:f889:b307])
        by smtp.gmail.com with ESMTPSA id s130sm4346683pfc.62.2020.02.13.13.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 13:30:46 -0800 (PST)
From:   Chia-I Wu <olvaffe@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, gurchetansingh@chromium.org,
        kraxel@redhat.com, dri-devel@lists.freedesktop.org
Subject: [RFC PATCH 1/3] KVM: vmx: rewrite the comment in vmx_get_mt_mask
Date:   Thu, 13 Feb 2020 13:30:34 -0800
Message-Id: <20200213213036.207625-2-olvaffe@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200213213036.207625-1-olvaffe@gmail.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Better reflect the structure of the code and metion why we could not
always honor the guest.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Cc: Gurchetan Singh <gurchetansingh@chromium.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3be25ecae145..266ef87042da 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6854,17 +6854,24 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	u8 cache;
 	u64 ipat = 0;
 
-	/* For VT-d and EPT combination
-	 * 1. MMIO: always map as UC
-	 * 2. EPT with VT-d:
-	 *   a. VT-d without snooping control feature: can't guarantee the
-	 *	result, try to trust guest.
-	 *   b. VT-d with snooping control feature: snooping control feature of
-	 *	VT-d engine can guarantee the cache correctness. Just set it
-	 *	to WB to keep consistent with host. So the same as item 3.
-	 * 3. EPT without VT-d: always map as WB and set IPAT=1 to keep
-	 *    consistent with host MTRR
+	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
+	 * memory aliases with conflicting memory types and sometimes MCEs.
+	 * We have to be careful as to what are honored and when.
+	 *
+	 * For MMIO, guest CD/MTRR are ignored.  The EPT memory type is set to
+	 * UC.  The effective memory type is UC or WC depending on guest PAT.
+	 * This was historically the source of MCEs and we want to be
+	 * conservative.
+	 *
+	 * When there is no need to deal with noncoherent DMA (e.g., no VT-d
+	 * or VT-d has snoop control), guest CD/MTRR/PAT are all ignored.  The
+	 * EPT memory type is set to WB.  The effective memory type is forced
+	 * WB.
+	 *
+	 * Otherwise, we trust guest.  Guest CD/MTRR/PAT are all honored.  The
+	 * EPT memory type is used to emulate guest CD/MTRR.
 	 */
+
 	if (is_mmio) {
 		cache = MTRR_TYPE_UNCACHABLE;
 		goto exit;
-- 
2.25.0.265.gbab2e86ba0-goog


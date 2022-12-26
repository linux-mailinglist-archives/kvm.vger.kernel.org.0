Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECFB656224
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 12:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiLZLRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 06:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiLZLRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 06:17:42 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA0F62EE;
        Mon, 26 Dec 2022 03:17:37 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id g16so828007plq.12;
        Mon, 26 Dec 2022 03:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ndX3aqFP5QuEDhvL4ldT5jQnDdYTin+9vnF0038Ulgg=;
        b=RphvVQzwFXgVoTS5jqEvakUba+uXRziyjLAqub7pHS+ZxoTKe1DC6NcicuVTOMjJ59
         QjADRpuZusVxBx0L5uhUDwYWUkbY4Nn91UdQ7NguH0j2ac9hhJgZDMeQagI/DLejcTve
         NCzT0s18AeKXfqavujK8qYIIHkoWkx3HsN4hLcNpgvTwFr/VxV1mUG/INW6/+fKec3fQ
         kHyfaC+GIL+oVgOp6Mbgs9UVGtNd0X/TeoltDnW9j4RqOoc3vsvAPsfB7MaexZLSQe+G
         vWX3aKbdrUgRq09zjHjSjmbhmu3f5DPdA++MWDNYinIQyerdfqGTI4R9P6KUj8a/n7J1
         J+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ndX3aqFP5QuEDhvL4ldT5jQnDdYTin+9vnF0038Ulgg=;
        b=WvsnffwsgSIX5fgWKqFiZ0YxTt0uwpYSsdKMt55u6WGg6bFsHuIgMe7ixfEmperpfj
         1TBYeMrzOy4WYR1iGu9RR1VtmZnnDPwaGPyvixrnUy9gzlHA0M59oApqLAvjdnUzkk81
         C0a2DCcnw/muM7mIechFMegGVZnnn77rAsD3Phua94lBc8g1uVkUs4qrBAr+0yBO1kq8
         VI029ZOdtBmoZF+qOFoza94U8VG+41FV/fEf0/+lJRWdMgTRnUhcCQ16mdZiChU0XXTa
         QmNtQ1UZsv20N/MuiOAIdvquhsHG2rTnL4cZbzxBRILoRXeaAW0Z64qpq+vLfaO6/zCs
         z+gg==
X-Gm-Message-State: AFqh2krRf9B6b/l3sajth05sI7ODoYONtPJUbk3zKeTrARJnbt2+YatL
        /seye3/CX/79wFGWVoFVLQs=
X-Google-Smtp-Source: AMrXdXvyf7fgBvsBrFaC8Q2Bx7zb02JCWMfOL9SqfqIbHMsH0YCX802LXrGHzUZDESkNe49KfuNFpQ==
X-Received: by 2002:a05:6a20:ce4b:b0:b2:ed11:284e with SMTP id id11-20020a056a20ce4b00b000b2ed11284emr10544156pzb.52.1672053457446;
        Mon, 26 Dec 2022 03:17:37 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id dw6-20020a17090b094600b00223f495dc28sm6281490pjb.14.2022.12.26.03.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 03:17:37 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86: Fix a typo about msrs_to_save_all[] in kvm_init_msr_list()
Date:   Mon, 26 Dec 2022 19:17:10 +0800
Message-Id: <20221226111710.51831-4-likexu@tencent.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221226111710.51831-1-likexu@tencent.com>
References: <20221226111710.51831-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

The commit 7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")
changed the variable name from msrs_to_save[] to msrs_to_save_all[]
but it still misused "msrs_to_saved_all[]" in kvm_init_msr_list(). Fix it.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fcb9c317df59..b419ff9cef3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7012,7 +7012,7 @@ static void kvm_init_msr_list(void)
 	unsigned i;
 
 	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 3,
-			 "Please update the fixed PMCs in msrs_to_saved_all[]");
+			 "Please update the fixed PMCs in msrs_to_save_all[]");
 
 	num_msrs_to_save = 0;
 	num_emulated_msrs = 0;
-- 
2.39.0


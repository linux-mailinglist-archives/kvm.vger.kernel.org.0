Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCAE6279C9
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbiKNJ7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbiKNJ6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:58:34 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A37E1FF81;
        Mon, 14 Nov 2022 01:57:10 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q9so10507050pfg.5;
        Mon, 14 Nov 2022 01:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ccZiWPsj90sIvFSVbuXn3m5I4XZuLJxz6wzsnjwAo5w=;
        b=k8cTh9C06Opq104Iymh5+kbFbPD7WZPNGa7NSxb0kfk01Rht+Y8vodld11NScwj1Mq
         GBG/q+uexLG+y0/X1zrdhGk2W8+AW68F5ZJ8b2bWFgA+duw+xOv15DDXVkDeW8tOWb9D
         lyVMd4dOX7+CBj51RM6pSVDzsldk6sV35WEKY389ncXkv2KAOs20gxwn7usITqUTEFT9
         UmLXcMNdKutk1pFLre5vgPzWLVFlYT+nrtwvPkGK2nivFbM4A4pXEFoh1RPgpyk6XH2C
         K09FN7Fz6pkuHZC325s7SErYOsK/Fvcv9tFtzS3XWQVNjSPXjiGmaiCEim8rKXrQePaK
         41xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ccZiWPsj90sIvFSVbuXn3m5I4XZuLJxz6wzsnjwAo5w=;
        b=V4osZdCR79Fn/K3bcsE1vTu29sxSOk4OZD1/E0xfXssLpFkjvIjLJDPQod6Lo0eEPM
         mc3wqpilJLbQgjGgSSjaQgJil3mgW8D77LqzmQZa55UQ3pNTVQY0zLWQZOS5N5nxr/Mg
         THfpqMeumUfAtakI8ovGzVu4Xv4zDeek2aydoz3V/FGVR6zwR1eup6xuuDSxjGCuANot
         vjXoaJRvFmIDsGZy0Eg9QS8vQkq79BW9EI39tCWPEPdGQlVrE/kUFcI7dsJ+IZBpAULk
         0Ik8zEojkeHzfqHMHitIHYKIuDkbkNlJLGj4ZkyjGNws8pNLn7S2WWWKoNMwbR4058bC
         oWWA==
X-Gm-Message-State: ANoB5pkQloDGpJ5Oo13htK1XRkbVBxD6iFBnzcuPznP9JBT6Md1eKFYy
        eCBrsKI7Y+SJ9EEkLpiCXg8=
X-Google-Smtp-Source: AA0mqf6rKk1TAJ1xRxMxsJCgCfngtD6Auhmpz6x7+FlXTw0eG3bhllrlDX7cMkDQ3Ef87psdHJcSXQ==
X-Received: by 2002:a62:e117:0:b0:53e:6210:96de with SMTP id q23-20020a62e117000000b0053e621096demr13163504pfh.58.1668419817537;
        Mon, 14 Nov 2022 01:56:57 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:57 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] KVM: x86: Remove unnecessary export of kvm_apic_update_apicv()
Date:   Mon, 14 Nov 2022 17:56:06 +0800
Message-Id: <20221114095606.39785-15-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
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

Don't export x86's kvm_apic_update_apicv(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/lapic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f59e7db2af2f..b55042462d39 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2430,7 +2430,6 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
-- 
2.38.1


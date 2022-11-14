Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A736279C1
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbiKNJ64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbiKNJ6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:58:01 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001411EAF2;
        Mon, 14 Nov 2022 01:57:04 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so13277363pjk.2;
        Mon, 14 Nov 2022 01:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTLEyqbjC9BryqtpbllpLrImB8bg3DlkHgH/+DPhCkw=;
        b=krlwna1jIZMzCZL1mKGmz+yePRa9bwt5HUMkNclRCaIp9UmHMlixJvXBNFM2BOml0H
         DOQkj7g8DGnszDvPRX18AByQeND6zUKNh06/gHynqmjudA2WlqEG+tF5r98idlfghtfL
         z/qjqGAwfzpvwWCo+ZwCinbX2H7/Jg3XzoXVzZaMfuiz3o3jctyze/r8C5dNadGBHp0k
         kSH0ikEKTKGKp51IFf66br1ahssoy1Q4JHyz1jReuNmhLmN2FDwxIcgIb8znux73pYyX
         cGHACxICaq4mcZB4G2CupKMWF6ta+Ra0K/vB2ERMI30Rxilh9SuvbeJ9wORyKqUqpiQz
         HXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTLEyqbjC9BryqtpbllpLrImB8bg3DlkHgH/+DPhCkw=;
        b=djfb9nZyUtC5SX9hCPnTATQo3p1mOfhYqJ+PqlbI/XqoWkmlnIwxfxUjjgnv7gOqEK
         aScBmx0d8+41TvXrbMuGven/M1sU0YHrDfgchQsBWib1EOpO1/9oCF2PHat4iADTwFEU
         ND1FB+ohvOIDWY5J09YNAqd/Gj+FLL1uPMWs6rW+Mz2xFmx3M6ewmJgqq29tI4azsX54
         vldEItFWcDSNfq4lxTqpd9ohgEJ5T0LntnC67z0Acv5dxdXR0wHEyifgUkLMsdXMUGXY
         9ROIlDFer2BbTcKJWRGlznHuXH0S2A07sSg0R06tDPcux0VNlfFXu7FL1Vbb0ylUPJOv
         vYTw==
X-Gm-Message-State: ANoB5pk7N/OchoiI5pzIqsMEnBelhVTxvIW0q/AhKYFRd9LiHADgn25e
        0d7d2C2OaKHMNWTXELLl+/Y=
X-Google-Smtp-Source: AA0mqf74WUDi/0NYgJRUaYerIPJgJ8VH+3io111L5pqECEnE2yLSXNbHO0J4CJfiXH4YzabW7OgpIQ==
X-Received: by 2002:a17:902:f612:b0:186:6c10:7260 with SMTP id n18-20020a170902f61200b001866c107260mr12837936plg.26.1668419811854;
        Mon, 14 Nov 2022 01:56:51 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:51 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] KVM: x86: Remove unnecessary export of kvm_hv_assist_page_enabled()
Date:   Mon, 14 Nov 2022 17:56:03 +0800
Message-Id: <20221114095606.39785-12-likexu@tencent.com>
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

Don't export x86's kvm_hv_assist_page_enabled(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/hyperv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0adf4a437e85..072303aa4e42 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -895,7 +895,6 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 		return false;
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
-EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
 
 bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
 			    struct hv_vp_assist_page *assist_page)
-- 
2.38.1


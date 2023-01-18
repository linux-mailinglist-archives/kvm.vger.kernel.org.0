Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6CE672591
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjARRxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjARRxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:53:12 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA484DE0A
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:10 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id w14-20020a25ac0e000000b007d519140f18so12938045ybi.3
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQJqGyKMVZBnVtnX5pQVog8PyIcLu+fjz+wxKZGn5E8=;
        b=o+82nZCzxGaEG+l0JTCDWWE0LucXLNOrsxfPruiVK24eCoCK4joFkAF94zkhfI9+hY
         F0bwoj67XoJAMZcEwS/ptOnbO34LnQ2sA5d9t+sR+MHATaXuhrdfuW79aadb7xLKoisb
         a8NRDE3oPQPMkXFIbn2PmGzvc9tQDXTi6Uln4hTkEgG4rYP03SHLZGxdD51fhTMLH51A
         cU42c87J+WVSKgOUj99ZVnofaz57hWd6gTOhi6WDflEnlQFHkUYYb/AOXC9v731urbl9
         0aogSoGGWESuSA4TOwMPIj2HcazdbFC2DIO/93TJBPRXhfa3WjfWseyNPfS6q6rvXrON
         r78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQJqGyKMVZBnVtnX5pQVog8PyIcLu+fjz+wxKZGn5E8=;
        b=A3KVMV9bLTVUhFtZpK+LLrCihiSyhfxmc5KNK3nkUTG3wQb46r0CkrZUcA6vTp/OlA
         YwbzjEAby9djl8iAMpKnvRycC/h5Yx8h/4PzK45fUBj8sbsFR2xfwhvG7GZfstQR3vl6
         TkOPrAKpDOHUucS3aN8Qhf8QnDwkoLHTIvQzkLN9SsVYwK1G76mBAnhQhYlQ6tQRyGkN
         V4hbaF02H0Y2/M7dhytI6v+2fjbCM0SKIsZmGZCwDnRjVipWpSAsVEM28vsA0GyOed57
         qOcA1Y3vUsu5zBKbOi1OWdUvi9rPoiWcT2iWSZjZXk9kMS73ROWOwWE8bHofWrU0UO4E
         omww==
X-Gm-Message-State: AFqh2kp4l1smCAFXq34lup3otpL+tMDN9C2OpkLnlMW+Qq+P6vHZOXIe
        BYma0CuP0xJa6oDYC+NDQt6azmzCkhRG8A==
X-Google-Smtp-Source: AMrXdXvC7yXxhjAj3GmMBrxMAtaDLYpi3mTEq23uqtP464YKWjMUEWuhcMWdGtuyZstMYNt2oetaf1SgshV12A==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d809:0:b0:74e:c305:653e with SMTP id
 p9-20020a25d809000000b0074ec305653emr1012866ybg.113.1674064389484; Wed, 18
 Jan 2023 09:53:09 -0800 (PST)
Date:   Wed, 18 Jan 2023 09:52:58 -0800
In-Reply-To: <20230118175300.790835-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230118175300.790835-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230118175300.790835-4-dmatlack@google.com>
Subject: [PATCH 3/5] KVM: Fix indentation in stats macros
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the indentation in the various stats macros so that parameter lists
that are split across lines are aligned with the open parenthesis on the
previous line.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ce196d69f64..cceb159727b5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1802,55 +1802,55 @@ struct _kvm_stats_desc {
 
 #define STATS_DESC_CUMULATIVE(SCOPE, _stat, _unit, _base, exponent)	       \
 	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_CUMULATIVE,		       \
-		_unit, _base, exponent, 1, 0)
+		   _unit, _base, exponent, 1, 0)
 #define STATS_DESC_INSTANT(SCOPE, _stat, _unit, _base, exponent)	       \
 	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_INSTANT,		       \
-		_unit, _base, exponent, 1, 0)
+		   _unit, _base, exponent, 1, 0)
 #define STATS_DESC_PEAK(SCOPE, _stat, _unit, _base, exponent)		       \
 	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_PEAK,			       \
-		_unit, _base, exponent, 1, 0)
+		   _unit, _base, exponent, 1, 0)
 #define STATS_DESC_LINEAR_HIST(SCOPE, _stat, _unit, _base, exponent, _size,    \
 			       _bucket_size)				       \
 	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_LINEAR_HIST,		       \
-		_unit, _base, exponent, _size, _bucket_size)
+		   _unit, _base, exponent, _size, _bucket_size)
 #define STATS_DESC_LOG_HIST(SCOPE, _stat, _unit, _base, exponent, _size)       \
 	STATS_DESC(SCOPE, _stat, KVM_STATS_TYPE_LOG_HIST,		       \
-		_unit, _base, exponent, _size, 0)
+		   _unit, _base, exponent, _size, 0)
 
 /* Cumulative counter, read/write */
 #define STATS_DESC_COUNTER(SCOPE, _stat)				       \
 	STATS_DESC_CUMULATIVE(SCOPE, _stat, KVM_STATS_UNIT_NONE,	       \
-		KVM_STATS_BASE_POW10, 0)
+			      KVM_STATS_BASE_POW10, 0)
 /* Instantaneous counter, read only */
 #define STATS_DESC_ICOUNTER(SCOPE, _stat)				       \
 	STATS_DESC_INSTANT(SCOPE, _stat, KVM_STATS_UNIT_NONE,		       \
-		KVM_STATS_BASE_POW10, 0)
+			   KVM_STATS_BASE_POW10, 0)
 /* Peak counter, read/write */
 #define STATS_DESC_PCOUNTER(SCOPE, _stat)				       \
 	STATS_DESC_PEAK(SCOPE, _stat, KVM_STATS_UNIT_NONE,		       \
-		KVM_STATS_BASE_POW10, 0)
+			KVM_STATS_BASE_POW10, 0)
 
 /* Instantaneous boolean value, read only */
 #define STATS_DESC_IBOOLEAN(SCOPE, _stat)				       \
 	STATS_DESC_INSTANT(SCOPE, _stat, KVM_STATS_UNIT_BOOLEAN,	       \
-		KVM_STATS_BASE_POW10, 0)
+			   KVM_STATS_BASE_POW10, 0)
 /* Peak (sticky) boolean value, read/write */
 #define STATS_DESC_PBOOLEAN(SCOPE, _stat)				       \
 	STATS_DESC_PEAK(SCOPE, _stat, KVM_STATS_UNIT_BOOLEAN,		       \
-		KVM_STATS_BASE_POW10, 0)
+			KVM_STATS_BASE_POW10, 0)
 
 /* Cumulative time in nanosecond */
 #define STATS_DESC_TIME_NSEC(SCOPE, _stat)				       \
 	STATS_DESC_CUMULATIVE(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
-		KVM_STATS_BASE_POW10, -9)
+			      KVM_STATS_BASE_POW10, -9)
 /* Linear histogram for time in nanosecond */
 #define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, _stat, _size, _bucket_size)	       \
 	STATS_DESC_LINEAR_HIST(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
-		KVM_STATS_BASE_POW10, -9, _size, _bucket_size)
+			       KVM_STATS_BASE_POW10, -9, _size, _bucket_size)
 /* Logarithmic histogram for time in nanosecond */
 #define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, _stat, _size)		       \
 	STATS_DESC_LOG_HIST(SCOPE, _stat, KVM_STATS_UNIT_SECONDS,	       \
-		KVM_STATS_BASE_POW10, -9, _size)
+			    KVM_STATS_BASE_POW10, -9, _size)
 
 #define KVM_GENERIC_VM_STATS()						       \
 	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush),		       \
-- 
2.39.0.246.g2a6d74b583-goog


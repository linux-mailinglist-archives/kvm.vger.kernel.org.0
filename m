Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AD66279BB
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbiKNJ6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbiKNJ5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:57:19 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93BE1F63D;
        Mon, 14 Nov 2022 01:56:48 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id io19so9583200plb.8;
        Mon, 14 Nov 2022 01:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmf8HZalToYEZyqhmS66CbNmx+ryp8w0AolHigIfczE=;
        b=m2LI1kCnRbnjDK3j4Y2S/phpe+XWA5iy5kHbuTnedqVJJYXfPM67fKLznsu6Y1Wkjn
         +EQQoCvAyiK+YxNUjzfW40ggaygyjSd/ELixiY1NXV6KObZ431ktjQY0HRinpVckbhj5
         eG1c2+n9U4nOKaO0/9smIsRvc5S0jRNf+OSoIVwlxyXyAqUSdcczD3afz99J0oJW3+if
         aqRJSztJ6ej+sap65JiFkMong7aXkXwG9qerAxv74l2yd1OKtOKZiRJ72ziWOk1Smckf
         r4E0YdF0eh7v3662Zt8ozMFaNhDdMqeaZ4XFTrC/2eZMfCU53HUml2oiAHGDcODmigUd
         tgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cmf8HZalToYEZyqhmS66CbNmx+ryp8w0AolHigIfczE=;
        b=l5j6AoZLApU4Na5eI2eoSG2PeTp/G0JvDpYRMOw+3+9RDiC5QYyDZF3p1yXn2W1mQU
         U2EjjPLG3wPdSsHYhCVsDpz6U1GAMfa0dbUgSD218VFbxHYtmkEh5iHJbpZBzJODNvm2
         yblZAvKP17F2tAOFRhfZhHOT1sa8vX4AKsSGb0gwiP5QJz2HF2Skn7PQUwjwbJEntSUI
         itu98v3yfGUsegJR+mMiqqClTFtMw42wfC+OGvnXRwu8pKIN9hEnfZG+jze5IadZZFTy
         /TCofhcW1xQWvxjd700kxhNz3QV9qlcbAtHM89dJHHKp1Cr7df0NhdLRuLXNt+y48GBx
         ks4g==
X-Gm-Message-State: ANoB5pn2s+riVAnbPRB+A/RaxgCGM5aA3FfGsPOhgUjFamKFu/BEwUCh
        REUWxSV+QE6Vyvo/VG+kVA0=
X-Google-Smtp-Source: AA0mqf6dwe24dHEoLsNBzJ5cAH4GDY9D7+4N37B5uAdEpvx06C++/vp86rMm5qZuL8eJtem12sYiIw==
X-Received: by 2002:a17:90a:9914:b0:20a:4804:4ccf with SMTP id b20-20020a17090a991400b0020a48044ccfmr13129293pjp.209.1668419808059;
        Mon, 14 Nov 2022 01:56:48 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:47 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] KVM: x86: Remove unnecessary export of kvm_scale_tsc()
Date:   Mon, 14 Nov 2022 17:56:01 +0800
Message-Id: <20221114095606.39785-10-likexu@tencent.com>
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

Don't export x86's kvm_scale_tsc(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 41b6361dde62..f325710a4f25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2503,7 +2503,6 @@ u64 kvm_scale_tsc(u64 tsc, u64 ratio)
 
 	return _tsc;
 }
-EXPORT_SYMBOL_GPL(kvm_scale_tsc);
 
 static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
-- 
2.38.1


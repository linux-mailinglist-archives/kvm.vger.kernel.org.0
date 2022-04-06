Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437B24F5AA1
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357310AbiDFKQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 06:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350735AbiDFKHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 06:07:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548BA11D;
        Tue,  5 Apr 2022 23:37:23 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j17so149742pfi.9;
        Tue, 05 Apr 2022 23:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FQQt7+yobA+b0Z1BhiU8usjPaq4hXnJ7fnVB/29gryw=;
        b=W6d70wd7S/Bv79cRQA8+RDhX9uuxwccal05yNA2C/njdkP6kIVCxmn1DErmU9BnQMM
         DQsXLsSfLgXDKMc8NKB+RjZdAfo29DJ/+Q5BpuxmHPzqi12Nx5vTDpntyqgpbFt9gn1m
         canTOV00Ivf1Z3XlTUKYEOrTj9ypDdqkHngEPZI/6QcksQYQEDzbBFF2kAtnHjySn9m5
         /PAOfgdIUM99ghaZ65eUSAurY+oj1YGqgGkIEHcg6t+kArRq2Pty1SeLEKJZcprrAegq
         z5kTQh+N9u+DKM4/TsH/xcgJSW+YR7W3s4DqGOA4A+hTjoVM99joxyF5nwPVoa5AKrjU
         LWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQQt7+yobA+b0Z1BhiU8usjPaq4hXnJ7fnVB/29gryw=;
        b=fNxQx6h91W0tUsn5IspfPXQhmd35dcsxgJzA+c7tWMWssxG0cXUkk+zcNGHCbtUIAH
         1FL9+/10uLmY2gCbloCPZUQes7ebHvi0yLG61LQoHxv8l7funyLN/B2eegog8VsTk47I
         EViGgvMYkuoA7gezr1JR2JXKkm5LnuuWlTUJ3r5PIbtyFf5qbghO5nmbNC5Ui6Q2P3b1
         v6QlEhlxO73TCnFeXWXGM1Mjyjj9t/ZSHBl7SvwrtI/qdA4M2UjJn8jdJ9FO+QhqoWu1
         jVBV7S+5SyEm+unxY572cAFehfqqw2rkQZf83K2aResjpPYcKpLz2o1A9W7hyBpLPfdy
         0QOA==
X-Gm-Message-State: AOAM530FfeTj2bDdNpqjI3WB/ckq17uXQ4CFRFeEupQb9Z0aNmDEID+c
        Lw9WVRrcvyQw7a0vWUjJI6I=
X-Google-Smtp-Source: ABdhPJwXdf/ennUM/lzhinl+XP81CRe1e/sjNoZtpFl9HWmQamnh2LX+gQEXs7wnys4JzkrTwIpSwQ==
X-Received: by 2002:a05:6a00:1a12:b0:4fd:a5b4:b4c0 with SMTP id g18-20020a056a001a1200b004fda5b4b4c0mr7287467pfv.16.1649227042913;
        Tue, 05 Apr 2022 23:37:22 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056a00439200b004faad3ae59esm17286650pfb.95.2022.04.05.23.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 23:37:22 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: x86/xen: Remove the redundantly included header file lapic.h
Date:   Wed,  6 Apr 2022 14:37:12 +0800
Message-Id: <20220406063715.55625-2-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406063715.55625-1-likexu@tencent.com>
References: <20220406063715.55625-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The header lapic.h is included more than once, remove one of them.

Signed-off-by: Like Xu <likexu@tencent.com>
---
Note: repeated as https://lore.kernel.org/kvm/20220401001442.100637-1-yang.lee@linux.alibaba.com/

 arch/x86/kvm/xen.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 7e7c8a5bff52..610beba35907 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -8,7 +8,6 @@
 
 #include "x86.h"
 #include "xen.h"
-#include "lapic.h"
 #include "hyperv.h"
 #include "lapic.h"
 
-- 
2.35.1


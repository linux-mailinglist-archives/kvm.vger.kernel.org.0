Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8273A640C73
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiLBRpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbiLBRp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:28 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C59DEFD3A
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:14 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id s24-20020a7bc398000000b003d087485a9aso950352wmj.1
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1JhQFmKC0trfMj3OYJRD3fE4sfKhFU5srepZrR6R1LA=;
        b=OGIdvxnj2RZt51XNqSbWS7t5fAHAqWtMKWXV/YtKDXlYfLuRJEFdiJnABW2Gso5oOS
         7yRInVbZ8Uv2PW+z3iSaYxlGA6rYbxH3VLrdHRDwL6JOGWCiQGXTfJtcYgfViVlGK60r
         7oe3RZG0wFfvuCWvdxG7V34m3+pt3ka95Zr/XB+ySGymC0/seh7oyusMl4j0XCwgb+JF
         iEzV+GQF9Vwh9VAC6KGcvOJjRFn0i8ADPPjtonhPrjwK7zc2irTsEKKPZFEc/CM9GDJq
         4K00ICeazPb+0ByTSgXEwr9Qtm6bIznfvWtD+DlggttmKekRUofEhM367P5Pal3V630P
         RSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1JhQFmKC0trfMj3OYJRD3fE4sfKhFU5srepZrR6R1LA=;
        b=fAw/hhfLj9TfLyqclFF7icPSRPZKlPsTuhi0ZV5MAX30EyXt68pOoWip42uLuFYZhL
         zO4kwtW26fJ/Xd3KSYJVipdTMcxk6VihINQpR1bfd/90gMMljsVvlqDWHWJpV24Wcn1b
         iF+kAcYDVNuqWX8/FkTlZaGorXbkiQ9okTsFoa5xd7mwn9GIOq+wR5QHZe3D95htNM+I
         PRqpYjVf/eeaD6fM4MGL57QfohtC3LzwL7svTW8xK18HI6vZxneMYPlawGEJbGWpKeH5
         Sz4aaQyEKJSfATHqzCgTKQtsRfb0VAw7ml52rp7ivlvpNQ8f9cwDKGYPJCwlxt0h7Q3B
         Hh3g==
X-Gm-Message-State: ANoB5pm3Rx7Sq/oIh+Ce9lEMTJ/ZDzdaIZ0l1XN3yeUu2tsfOGs+GzAA
        5tvteJ0VrW/ZQbsZy6JEASp9DhlebpCB5mijiSBT0ca0BV2RcV2ckUz2TCgs1Ex5pLxV5h6fbiY
        zsdHE4dYATGLKCIPW0pMBcqgfP+WUkdtYaEua3c88WK7/RFZCLACTxsc=
X-Google-Smtp-Source: AA0mqf6SdCgGxNMSUKjDcZ3Pyx0Rvw6lzLFadPcCmIoTZD3xODT7kWVEvwNp99Eq+mP8hnzO0geg4Xa7MQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:4a:b0:242:2db9:df6e with SMTP id
 k10-20020a056000004a00b002422db9df6emr8279492wrx.480.1670003104425; Fri, 02
 Dec 2022 09:45:04 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:06 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-22-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 21/32] Add option for enabling restricted
 memory for guests
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
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

Currently this way for testing only.

When the option restricted_mem is set, the guest will use the new
restricted memory extensions.

This is done this way for now to enable testing and debugging.
In the future, pKVM will require that all its guest use
restricted memory, so instead of a flag, the intention is for the
final version of this patch series to rely on KVM_CAP_PRIVATE_MEM
and fail if that capability isn't supported.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/kvm.c                | 5 +++++
 builtin-run.c            | 2 ++
 include/kvm/kvm-config.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/arm/kvm.c b/arm/kvm.c
index 8772a55..094fbe4 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -74,6 +74,11 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_init(struct kvm *kvm)
 {
+	if (kvm->cfg.restricted_mem &&
+	    !kvm__supports_extension(kvm, KVM_CAP_PRIVATE_MEM)) {
+		die("Guest restricted memory capability not supported.");
+	}
+
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
diff --git a/builtin-run.c b/builtin-run.c
index bb7e6e8..4642bc4 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -202,6 +202,8 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 			"Hugetlbfs path"),				\
 	OPT_BOOLEAN('\0', "virtio-legacy", &(cfg)->virtio_legacy,	\
 		    "Use legacy virtio transport"),			\
+	OPT_BOOLEAN('\0', "restricted_mem", &(cfg)->restricted_mem,	\
+		    "Use restricted memory for guests"),		\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 368e6c7..ea5f3ea 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -65,6 +65,7 @@ struct kvm_config {
 	bool ioport_debug;
 	bool mmio_debug;
 	bool virtio_legacy;
+	bool restricted_mem;
 };
 
 #endif
-- 
2.39.0.rc0.267.gcb52ba06e7-goog


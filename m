Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBE34D01AA
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243348AbiCGOo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243345AbiCGOo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:44:28 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17055694A3
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:43:34 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id f24-20020a1c6a18000000b00388874b17a8so5420769wmc.3
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 06:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8vfdxo7n+Gbh4TlZhji4JKiUvRF4h9GSw6jba/4cxHI=;
        b=O5JID2lGDVqJ0hq37t1pp/7me2ZaJQCqPi1Od9E+QVst7wj+smEABDuPqGndDdTtgK
         WKZ7dDwQoM31mOd7EKHoI4SXQv3xAtfoiNwvnOx567z2jOHPXY0V6ZBfAm/lwRVN+ane
         EDiirXPlDTtPK/JqIKAdjd11DKAtfYwdh6nxL3z3EG6nvj3OX5J4TdKwAT6z/uLsFrTL
         ib2ovM2wSyaa7Fj9IZU0DSHSGnuFn+VmAAEmsS8zdpDNcjKPk2KWx4i1cLBUhQwA0j7x
         T9hSoIvK4nFCOPLDXsMRyISbTiyRnhyJXHHLZtNeYgksPJRwXMZVBQDtc8kE4pyKwvmI
         geWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8vfdxo7n+Gbh4TlZhji4JKiUvRF4h9GSw6jba/4cxHI=;
        b=PdrdTJPVPloO7ltLOn8f6HOTvyKZHpQ/wHt7krXQ3bEJ/dKb86KbiPL7x3W+2fOu6x
         YWfL5esCu9V8tCjiPlStFyX3u7zjRr5OG9ma06YdAV/e1KFOaXpflFX4mpz82F8wen62
         NqitEhE85jg0x5oElEV1Ad6y+WZP17iFBEwhfa7q0nBqspgSupfM45EOmM4i5P7zZXsC
         qFTSd53O+tlGyTYGLIwevtmLU0bWZd4KbRDrPCLXTmEZMQPU6RxqDPPvyIQ3b6FNTYsH
         OFTfACTt9funh3CITa2p1QgWwY/3rNxbLCz1oXIp+L8FOA5tSKnHf1e66Af8lziqtv+j
         x72Q==
X-Gm-Message-State: AOAM532XSvMnx+dRDGvzZRPogbyPpBCnl3zj6q8e5G2/g4ayZpBI21jI
        4DD2CMNAjNPgNybWY4AFMkHeQKK1nxS01rHjfT4zbP3FUdLAeKZxfl5hxuboNrfeXFPZOnIZyRf
        FkN8szTl7B5U8Jg9Z+TviG5fXe0ie0KJhmICkAVA8rJpcCsm5Md7ZS6sjYi3Pvagig0PMorPHJg
        ==
X-Google-Smtp-Source: ABdhPJzIqsNDChPGDDa8s233hYyYPgCOXIktSSMRNy/1R7UCheDRSRvylPuiXhyQ0e34swtPtAiVK1YpY4nFvVLrTLg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a1c:e908:0:b0:37c:3d08:e0d3 with SMTP
 id q8-20020a1ce908000000b0037c3d08e0d3mr9308531wmc.97.1646664212579; Mon, 07
 Mar 2022 06:43:32 -0800 (PST)
Date:   Mon,  7 Mar 2022 14:42:44 +0000
In-Reply-To: <20220307144243.2039409-1-sebastianene@google.com>
Message-Id: <20220307144243.2039409-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220307144243.2039409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v8 3/3] Add --no-pvtime command line argument
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The command line argument disables the stolen time functionality when is
specified.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 builtin-run.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1..7c8be9d 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,6 +128,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
+			" stolen time"),				\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
-- 
2.35.1.616.g0bdcbb4464-goog


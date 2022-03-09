Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2EB4D300B
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiCINgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiCINgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:36:02 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC4817585A
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 05:35:03 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id z1-20020adfec81000000b001f1f7e7ec99so771467wrn.17
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 05:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=txkn166+EfY7PppLWw4qc4C+/p2UR63wD9i9h0OJBgQ=;
        b=ZCgrb3FToHMhfcZlVFPL3oJER5BGYQVAaQvgcAUa/DciOsVvbDUTwDTOFRZvZzEBWL
         2rwa48OxFzZN8vZl6zkdwmKD2j2spF1kvSe3fcpRqlzqOKr4ibCm3eBH+2jHSMrlpFdQ
         /B4v+x/KYK7zLPQxU/V9AxHHcAOTMT8vn1FF/Xhift8Ml9ZG3rtUhkB8OxLiaO3YI8V7
         ElI2gQyQlBen8ohgI6m9Xw2ZAZRRnqz8jlB2L1aQYdwQrlaHHyRhnOKR+StiyI+Dl1J9
         Mf3CS+Op2k9SV5smEB6D6Nxy8f8Ox7t+iSzgwvMGlCdFoNc5PYkXQixN1cEV76AK5cEi
         q6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=txkn166+EfY7PppLWw4qc4C+/p2UR63wD9i9h0OJBgQ=;
        b=yI8jruyTIeici/TbDuvFgVE39W45+AfOWYf+cmmCXXe7X2bp56CImglSQ4HFuL3GId
         RXjz2oz8dI3fo3xnub7LtG7RJIurVW19NjlbN6D19/hK0WlNpkh+Muw3k/wnFSkSvNXq
         Qs5bJspPdf2T0Af8jhZNlsmo0v9RPf0oCrWnKVms/jfEmxuRPlkJvGyG2X1eHMVO7kNu
         FkJcT6iZhbE8RBULInGJYmETiS/cu6Tp1l6UWBFPn7DNuFM8YOrsBxB6GA6Zi+WahwG3
         uc3rcALBHumXd1h3YrExJoy2l+TgIyNKzFkW7LAPSWXfsGnKN946/yRJND1JOxEzpOSf
         p1qw==
X-Gm-Message-State: AOAM531qcP72n5Cm2liNzrZlDcgTvkMt6wKBnk1CZoih4WGXj6AxJIFZ
        eSijdqd+68k/BPlSBeeTLK07L/9RstFr9+4yLsAKB9aXaf9Jo+Ia0PW/sS1lROhVwTmFt3yzAOh
        ipcfiFLCPidRcAxx5984yeK8Lq0RYE8qXw3Co8pLV/DP9xlEPSLDwazTL8aE1suD1KNhRaeecUg
        ==
X-Google-Smtp-Source: ABdhPJyy5Jec64Gj0xLgU8Y1HqV/oWzty8Va5II4Mvi0EqoCxwaWwm9iCORkRTBPpUECUBLrnJrTnt8dB1Nt8F/AA+Y=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:1c02:b0:389:cf43:da63 with
 SMTP id j2-20020a05600c1c0200b00389cf43da63mr3332701wms.205.1646832902270;
 Wed, 09 Mar 2022 05:35:02 -0800 (PST)
Date:   Wed,  9 Mar 2022 13:34:24 +0000
In-Reply-To: <20220309133422.2432649-1-sebastianene@google.com>
Message-Id: <20220309133422.2432649-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220309133422.2432649-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v10 3/3] Add --no-pvtime command line argument
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
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

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
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


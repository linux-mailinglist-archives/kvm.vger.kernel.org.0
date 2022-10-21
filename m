Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35446080A8
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiJUVSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiJUVSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:18:31 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67C02A4E12
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id lk10-20020a17090b33ca00b0020da9954852so4777631pjb.1
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2nZIMOkxkPqMdJjizNd12NlButg+wAhOHsOCFogicCg=;
        b=WcPSPUKF7ggBl0Y2IXHy1DMp3RWNL9m8VHXZLCw+DdLzcdtF1JNMgKQ4+7na6BJAIO
         AW0w9JlOFe31ljI0u5nBDWCR37+o2mlUwocMEAqlXjxOFu3JOXkgDD+L7q3ytVQ0j/d0
         UP6haL7G1S52AUDMJEYSVcTRzCj5FokhTEhpN4n5Munvo7sDoC1885BRAhDqnqDwLtC9
         dof/6ipmS0UF3J3LivuOP9ww1qTXAHQ0nYkCdlgv5JnnQNjCbZpfv2DMclRVGtRirlmi
         d3k13p9vzhP6XRidDpiN63cvd8szHaO9Ra9A2xCCBM+I8GXMEtMCp5Kc00ArOhXzxz0l
         cEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2nZIMOkxkPqMdJjizNd12NlButg+wAhOHsOCFogicCg=;
        b=7B7xHN0LVJfJXY9U6pxayqH4WAwyGEUy0+BFYR0ARaFg/FzLFo5EdnF9cUCcAMe8Q6
         eG4vbbV1VeBXZNFnKv1xuIa4jUKN203lrqGZlrYjslYCotVeM26LobCRAQheWE79vgrX
         Zsewhx+HNFIaWf+PcbIvgPNR3rrkMVjLXGzsM1rT8+aDIwSsmeLy894FXgKTUpxnwjSS
         rIolu/QnQ9LSFkBwOq13lQGiULoAbteyWvhwZZMrGga2TJmTHN0j4cPbubd6foESjiL4
         KCvQXU0VjVizgbAvKraLqfctgdtkmKiC058Weo1WKN8eJ+/PRY5C1knmcUzGE6OFVFxX
         aclQ==
X-Gm-Message-State: ACrzQf14gDqmbUFJ5XVzYjLpTAi9oqe+slMbyypgCk0Ts+DHdj8hG5Hz
        ZOURZQBYmf5jvcaoVZ4gowP7znqe/6rU
X-Google-Smtp-Source: AMsMyM4OXiD+7ajtPxOEHRiPXDK+Af2oMl5k7lHB7wGjmfZQr6qEo6HimWCgs7KwZeOsUn41bSVTpJY776yt
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:91c7:0:b0:460:156c:ded7 with SMTP id
 l190-20020a6391c7000000b00460156cded7mr17952216pge.298.1666387106255; Fri, 21
 Oct 2022 14:18:26 -0700 (PDT)
Date:   Fri, 21 Oct 2022 14:18:12 -0700
In-Reply-To: <20221021211816.1525201-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221021211816.1525201-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021211816.1525201-2-vipinsh@google.com>
Subject: [PATCH v6 1/5] KVM: selftests: Add missing break between -e and -g
 option in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Passing -e option (Run VCPUs while dirty logging is being disabled) in
dirty_log_perf_test also unintentionally enables -g (Do not enable
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2). Add break between two switch case
logic.

Fixes: cfe12e64b065 ("KVM: selftests: Add an option to run vCPUs while disabling dirty logging")
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..56e08da3a87f 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -411,6 +411,7 @@ int main(int argc, char *argv[])
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
+			break;
 		case 'g':
 			dirty_log_manual_caps = 0;
 			break;
-- 
2.38.0.135.g90850a2211-goog


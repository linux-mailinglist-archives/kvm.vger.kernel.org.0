Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B17E613C3F
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 18:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJaRi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 13:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJaRiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 13:38:25 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF6FDF8F
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:38:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id j7-20020a170902da8700b0018540711393so8537689plx.18
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Jpq5jfGphmK9drIKQAVv+M/tTwLOmGvjLrn0VHckf8=;
        b=YPLI9uJ3gSAKoLonts19Zv0B3kfm5cmzTD+PCI18Cp7fF5belHNpwoGaTT6nXkHdnK
         d/tu7JUiJeqq3rpVel3sasfOjdiLHnp7dUeyP3NTsEPAnPOSrpvbfxPYRbRk4opBZzKk
         io8XUAK8Cyglj2sXdKPXkG+yQVH5kmeWwO8mxtsrOssf+jejlgb2L9srXRBlqbg+0MtV
         F9U/lQAqTm2AkgkYBvp0Nqg4Exsu+LltlQ7iLoe0+JEbRwDxh/TFotkO26MetrL7BCa+
         NNEfZ52iYcSgBi982Ewr3NnnA6Zjsc3ZxXrs8sciImoVivkngaa1PvPMcHszVdAn9YiZ
         rq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Jpq5jfGphmK9drIKQAVv+M/tTwLOmGvjLrn0VHckf8=;
        b=zeqRNIWzZ4IfGWnrZAhJZ7xidzmFOAiikzi2I0l61aTGYXqXwBYtof4enAIgqZTzZy
         BOCKf9u0+wKsYLV4nh2HhEj3jHDlfIKO4DxRbidlpETOjJHNTyW13IjjQyA1mMvjBOj5
         PuvQxro+VjrWvEws8zRbmMJ7j3hpehzDP8erB8bF6ejt3ZMOti+UwGfRiQzWzN6RKux9
         Llo2WzOMeBEtLnGY1JcEuye9hsJbHmxhOxaEHnXpO4w1waI7WQ1HsG1+lVyE6aXIIINA
         QP3ANGryo3kOIA/h6ZetYT2dDPgRIEfFzoXt9QWnyvg1eYeYGDaajqQ76cmW21GQTV00
         OerQ==
X-Gm-Message-State: ACrzQf3x1rY44yIFAFqzsCgXHKFen01AwPUeVbX2gRaRgXrATIJzm/hR
        /gJXk9sUyh0ImXPOmbZpQYUu1NTTh5mf
X-Google-Smtp-Source: AMsMyM4Cbtpv/FdUZxJeoD0+/Fl4R4E6qozoguIxnFXwKgT5BcRUM5AsVWymzrMoFALv4gJow+kv3fT5hT7X
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:ce0f:b0:187:640:42f with SMTP id
 k15-20020a170902ce0f00b001870640042fmr14060846plg.115.1667237904395; Mon, 31
 Oct 2022 10:38:24 -0700 (PDT)
Date:   Mon, 31 Oct 2022 10:38:15 -0700
In-Reply-To: <20221031173819.1035684-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221031173819.1035684-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031173819.1035684-2-vipinsh@google.com>
Subject: [PATCH v7 1/5] KVM: selftests: Add missing break between -e and -g
 option in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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
2.38.1.273.g43a17bfeac-goog


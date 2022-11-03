Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB706188A2
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 20:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiKCTTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 15:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiKCTTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 15:19:31 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D444021266
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 12:17:44 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id f19-20020a056a001ad300b0056dd07cebfcso1164024pfv.3
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 12:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nVq0NRECYhHBmuOUXw4sr1sSZUg51GxJ+DVIz9UL7cI=;
        b=PZBhgqs/avqYfO2rxz/ROGVj8Yf+KVawDpJUSJWaYxMktMhLq80Qa6x+fL1oLdyOBn
         tijGtDrD75BP0KkYOQqFKG1GufslY1KcExKxD1UiKYU16dRDVk+WHjG/0rrHXAXIyNTE
         y8YRbIBNVTRJk/+ZnwYD7CYJSiGuRjk8BwO1xvfSuBZe+CNMgsxAxNPdidLb9aDbbDMb
         3BmUEyQle9dxXlIQU4OlA+xgZqhDOGngQk1DrUrwLibBdKcS562IZuqoEUDyDTP327cv
         dZewcU9FPD0BbPJpND111+HBDtDd0dZrkwPh9yKoWclCUIIvLcrJj8s4fc31yZu5ASUz
         hlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nVq0NRECYhHBmuOUXw4sr1sSZUg51GxJ+DVIz9UL7cI=;
        b=h+Lmu/vKVkaYsjJhluUjyBB8hu6YgJElK41nhNRxCk6qLJGHCxgIuxsygNupEQw/df
         u9ZTyMeZDW6TboEpILFyoO3lCCZiX6zlxED57rWWQUx56x+WGj3C51DrMUGmwif4iCA7
         ngNlwMPhx9tbk9izweB2dABMwIMD/wYRv7zJQwhqRUbpd/YTgMvY4kuC33w4seFVCTiT
         f5rqvBfgo8VvVfKyywrbtMkS2jRyLHKsFhzrD7evouFFGY8D9wilHbRtrH9HKzHBB+xw
         VVS3CyUon6y/g7NddQjEbZbQb3TW+DExBgSlt0WBr8Wzefr9VKv4BAQrXV9ZgqS2zmmV
         8Inw==
X-Gm-Message-State: ACrzQf0LW7XBW6G/0nuL0vNy6K0q3ej2DSp4tqi1Ro4UqHVkQx7mYWYE
        M/du3/KsjMcMu8zE8pmSoc9mixC88Zfz
X-Google-Smtp-Source: AMsMyM6UNcs9I6+e7aM5S9m1UyC1w6jPRxGNXipf7CBwJoM8Z9M6K1w7kaCnF+KmVc93LzhizJsBnCVKap70
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:903:185:b0:187:25bf:dbe with SMTP id
 z5-20020a170903018500b0018725bf0dbemr21275767plg.74.1667503047254; Thu, 03
 Nov 2022 12:17:27 -0700 (PDT)
Date:   Thu,  3 Nov 2022 12:17:13 -0700
In-Reply-To: <20221103191719.1559407-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221103191719.1559407-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221103191719.1559407-2-vipinsh@google.com>
Subject: [PATCH v9 1/7] KVM: selftests: Add missing break between -e and -g
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
Reviewed-by: Sean Christopherson <seanjc@google.com>

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


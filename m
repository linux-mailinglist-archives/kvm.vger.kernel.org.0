Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC7A5FA781
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 00:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJJWFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 18:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJJWFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 18:05:51 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA3961708
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:05:45 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id cb7-20020a056a00430700b00561b86e0265so6287090pfb.13
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mLExz0EMZSyuFB8Q/Foo73cV0V2iUxH9jl6FjrHgHuA=;
        b=MkaNzqUg6OQAS3KXi/d3EbVRp+bK/mHHYYU7YS4eEOcwCnxft2bx4VYtxVPSxLKiwC
         fQ7Tw1l+vwPqb+QLM/2zYNjyrfI3p/HNNpyYmPzjk0HMovr2yeCwxe4dmKj8eNjaAqlK
         mAL3alJu+IyzyVhVzBZifiCqjtB43ANoyE2nRCVK8unJoXM/kkEgyo+1fdj7ZLwmbf+M
         7wF1YLY42oeGeT5iPsipXNXuxmyszTUnbfQjfZTu9C51ffB0Tn5nffKn1sANITjR4Sg1
         CIFjcb0yQf3xwNvje8haD83ZeMqbmdUO9SvYNgoBdjcyDfzdR5VOi5XQSSZNHZzBVf7W
         ZrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mLExz0EMZSyuFB8Q/Foo73cV0V2iUxH9jl6FjrHgHuA=;
        b=Q6CV9hqaBvfo3d3NVGnabpY07HI46qlaKykcb+Fl6JeNqV/NRAQft5CcbFqaLUb9R8
         wQ665LyrA68I/Bm+V21E+C3yXObukbfLqhItxNv/tgouOhMkUludNj3Jp8PdeWirMqGf
         nNm1TcirB/u2TpvpPcmu9a1kLIgpUi9mUDBCRsvmn+7TNrm++BzBJR4Q2RJcqSYojnDt
         XtsBXC1V7qCUOS1YW/PthTGNZ+Ch0s/1w18JSLhosOb53ThJap7upeye8ld0vOBRBhxC
         AAIKqIGMvE/ih5ro0dfbhOvo3VcxkMDxu/2awa58XzwtxyBhr9O+VecDn+zyu94RLV1Y
         0Tvw==
X-Gm-Message-State: ACrzQf01q+NaH4i3J8Mw/PxZjxM3/kk2EQPW8EHylkC/yMCEsVuZ8Hth
        hRJ5HA7Hm+Ju869R7VxCN1p6koVzWitf
X-Google-Smtp-Source: AMsMyM4seMxlZd3QKtALD3XcVrNvAyFwyzsTklJg8t92jVWY9SS0eoPi2DPJxddWEJzfefZiARsvcz1CeL54
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:e09:b0:563:69ac:5633 with SMTP id
 bq9-20020a056a000e0900b0056369ac5633mr6808226pfb.54.1665439544947; Mon, 10
 Oct 2022 15:05:44 -0700 (PDT)
Date:   Mon, 10 Oct 2022 15:05:34 -0700
In-Reply-To: <20221010220538.1154054-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221010220538.1154054-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221010220538.1154054-2-vipinsh@google.com>
Subject: [PATCH v5 1/5] KVM: selftests: Add missing break between -e and -g
 option in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, kvm@vger.kernel.org,
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
2.38.0.rc1.362.ged0d419d3c-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CDE69B52A
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 23:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBQWAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 17:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjBQWAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 17:00:20 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8195F64B17
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:19 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5366333bdb5so12519007b3.19
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 14:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ax1DcGoLiLxZwgQzmuNdmNdXr6vzAEjDqxAb7c6JEUk=;
        b=IMPJ+mcHcIXW/UTi2L5jv9YTQUPSXf986Vqjn1IQ5yFma7mqU050Jll0vTJnGuHcXO
         xhoDOYHUBW9ws706UrHkfzDGrctbXqNBMAVmlhTm4ZKA4HKvf98v+rQ+p21fSDanhi+j
         hCoLMeD1sIF0GTIQo/Iqo6sAzSVuqwimdmSRnd7kLngHl1mfJb7mdVytCFr3Dj8lGGiA
         zILSGb2kznAoXrApI7uAPAxDmhVkD30WxQYkMoWH95bwFZgfaPjYli1wHtree2nUX7fi
         Qv9R684Vu0XSoKKah+65CdIS7Ly6XA4bDiuuQBhxrSQYIbmEJzLbpjPiQ+mTh8Lbw8eO
         JvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ax1DcGoLiLxZwgQzmuNdmNdXr6vzAEjDqxAb7c6JEUk=;
        b=ue4Pw+oyIPowAEDzg14gCi28j0myVZ22b2v6z+8i3/QntWrKt1JbGMaL5nLg5TcKNc
         iAY59K36i4H55+UNj8IzkJgDNtjshmKJRpHdINriRsTLHautvVUk6eH1ASggPFqiNuaB
         WDvroIOtZa+dcq05ltXP1Vekai6vuHxoDUPL36FXo2cXpx64PMPVKW5x2gBUielbDiEg
         U7i3PLCRS3dDTFSzFy/RIQWm0ZcjxETtah9P9r3bp8hnHRWc2x3nXSqN5Tw7lDa8CZvB
         kY3avnu9LaMGaP659mwrWDCoEc0cEfm0x88lGV4/PMVsJrDGvRO9escP0cO5b/OMf7lB
         I65A==
X-Gm-Message-State: AO0yUKU82rVvnrQ0uSZykFHlCO2qanS2YyxDAwO13hB/nDBcuB8UfuvR
        q8awUDZsCHXxIibkE/BCXa9/AbSIZi93pA0P4ANp5xaqLqkoWqL0qXvFexWRdu797EOfDDpoMMj
        6ZSJbl5qwbSaCiAUbLuCAaT8ByG78Mvqb1NLAH9JNe/53qV84LQ/LHbB3/fa5vBwers5R
X-Google-Smtp-Source: AK7set9eNWsRwlNHBEftQgg1CO9RzIf8fdO4PIbsnjoMB7dMzLV0R7geKgvzRBU5TecHmT3ttnS1/E2alM2rSE3y
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a0d:e8c2:0:b0:52e:c5e0:6564 with SMTP
 id r185-20020a0de8c2000000b0052ec5e06564mr1119623ywe.280.1676671218760; Fri,
 17 Feb 2023 14:00:18 -0800 (PST)
Date:   Fri, 17 Feb 2023 21:59:59 +0000
In-Reply-To: <20230217215959.1569092-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230217215959.1569092-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217215959.1569092-6-aaronlewis@google.com>
Subject: [PATCH 5/5] KVM: selftests: Check that XTILEDATA supports XFD
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

In amx_test, add the requirement that the guest allows the xfeature,
XTILEDATA, to be set in XFD.  The test relies on it.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/x86_64/amx_test.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 8211b9de6e7b9..647cc6b9839d5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -125,6 +125,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_XTILEDATA		KVM_X86_CPU_FEATURE(0xD, 0, EAX, 18)
 #define	X86_FEATURE_XSAVES		KVM_X86_CPU_FEATURE(0xD, 1, EAX, 3)
 #define	X86_FEATURE_XFD			KVM_X86_CPU_FEATURE(0xD, 1, EAX, 4)
+#define X86_FEATURE_XTILEDATA_XFD	KVM_X86_CPU_FEATURE(0xD, 18, ECX, 2)
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index ab66a51228fff..d1a029f132d94 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -254,6 +254,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_AMX_TILE));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILECFG));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILEDATA));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILEDATA_XFD));
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-- 
2.39.2.637.g21b0678d19-goog


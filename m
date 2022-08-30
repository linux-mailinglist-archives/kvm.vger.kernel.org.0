Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE05B5A7120
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 00:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiH3WwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 18:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiH3WwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 18:52:17 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2439074372
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:52:16 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id a33-20020a630b61000000b00429d91cc649so6096048pgl.8
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=6SfeEbNNqw9PSiADIQQeOAQy1EZZ76k5SYj5KpzlAj8=;
        b=HZw6OaQhYVtJODoeN/uSuw5q1ulAoa8I1aZdSkYkgjLD9DzM5S9DpV264Tct7RK9AP
         GunUnAoYK+GidDSMfzPR+O2onlhPrbWbk5ugAxnC1fiGlEzGWxtwLxnbDbMGVwSPbveB
         yxK4JN17eMS7hjkCQ27GICOTNdbNQRrnKYwYHWKZkGZ8wuQ2Er3AnT8zUIS6iQ9IcIKU
         0yspUDwz0UKDos6iE6NRa0oHrDTYJtDQ38tT+v5Ijv+UtT+Vgq3krnzelmop1tUFKYjO
         Ul6fVEHz72XzcGB3S1quPbNrMZRzlHJg1RzEJfn0rhDUNqxUfVZbDRzNvcAQSQeMKuOs
         1cjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=6SfeEbNNqw9PSiADIQQeOAQy1EZZ76k5SYj5KpzlAj8=;
        b=SklOWFhp/A1gq7mOoj8NNcHUodbRRRpco/bjQusYVcECY3lWzutmLD6rO4t841NeZm
         17+fjQhxv/R6q7GO5h5wW+NgWAZPsn3kfYh+AkQmM8joU3NATNUrakbHMD4nhC2DjUVP
         wRHM2sVSqec7MTRCxTSuaYNljwWSzAxwaodVa2y+8ynG/n4GJ88a4Qg7CcfdBU9K4bp7
         sPXNMTM9CCPNuU6eiepBTMURamP4ZQ3KXab4PXNnf98Y01oNuICy4+qvYn+W0cz2QIY5
         l0DE3lVWTQFILUKOIKaV91XvB27yljpjabqts8vTO6sdtjukm77UZa6LFTD8MgPhM2fx
         F8rA==
X-Gm-Message-State: ACgBeo1ZNUus9FqtpX7jwVqjeA25zz2iYzAqFsuxVoZ+HR6n/Tobt+hl
        KHpQeeZHM/Gw/FPvKCKTV18HVNDJ4P1Bpu2EAJHzuigOeuUAEjr4J82MquSI12L4VoDCM0pJ8pm
        jePU7vw9KH3nI5cenKGzOa3zatz18ffFjOv6EmNZMpYXf/eu1o5blcLV/fnasPyg=
X-Google-Smtp-Source: AA6agR5A0JFI+qRwqHCW5743uOiVV0qKRay/mRD/PQz1YXfzGy2uu1yt+gHpqP/ZH4eym8xl8IDAi0dD6X4DMg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90a:bd05:b0:1fb:c4b6:a83c with SMTP
 id y5-20020a17090abd0500b001fbc4b6a83cmr267368pjr.142.1661899935568; Tue, 30
 Aug 2022 15:52:15 -0700 (PDT)
Date:   Tue, 30 Aug 2022 15:52:09 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830225210.2381310-1-jmattson@google.com>
Subject: [PATCH v2 1/2] KVM: x86: Insert "AMD" in KVM_X86_FEATURE_PSFD
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Babu Moger <Babu.Moger@amd.com>
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

Intel and AMD have separate CPUID bits for each SPEC_CTRL bit. In the
case of every bit other than PFSD, the Intel CPUID bit has no vendor
name qualifier, but the AMD CPUID bit does. For consistency, rename
KVM_X86_FEATURE_PSFD to KVM_X86_FEATURE_AMD_PSFD.

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Babu Moger <Babu.Moger@amd.com>
---
 v1 -> v2: Dropped patch 2/3.

 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..07be45c5bb93 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -62,7 +62,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
  * This one is tied to SSB in the user API, and not
  * visible in /proc/cpuinfo.
  */
-#define KVM_X86_FEATURE_PSFD		(13*32+28) /* Predictive Store Forwarding Disable */
+#define KVM_X86_FEATURE_AMD_PSFD	(13*32+28) /* Predictive Store Forwarding Disable */
 
 #define F feature_bit
 #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
@@ -673,7 +673,7 @@ void kvm_set_cpu_caps(void)
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
 		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
-		__feature_bit(KVM_X86_FEATURE_PSFD)
+		__feature_bit(KVM_X86_FEATURE_AMD_PSFD)
 	);
 
 	/*
-- 
2.37.2.672.g94769d06f0-goog


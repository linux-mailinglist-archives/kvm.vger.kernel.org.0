Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8459F5A30B8
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 23:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345022AbiHZVAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 17:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbiHZVA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 17:00:29 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1609DE1916
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:00:28 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c135-20020a624e8d000000b0053617082770so1366022pfb.8
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=kKEei8yAqADdtFSTkBJAqxxc/VkzhmqquJB4WzGX/lg=;
        b=HGIkNNvNfFuRTV1NzxYWfcLHK2EqNDy1qPNe4jKYWKPKfJT1k6B6D4xWvTI9MrS+zE
         0gqqVXsm2+TWENyW33Bf12O4MKNDL8n9hpm1YrP2MU2lvrRFeg1f2q2tZLaD95gK/kLY
         6hHfzhTfaRffLA1OoACODVmSDxg6GP0xVpaouNtRV8toIKhcF+ZufLFDi+1fP1A635l5
         rmKlbYVKilf1mC6mByzgtwfJBuAJKmI25N5R/TxVg7LsKPibAfr1UA27IulsraTWWg2Q
         aVMcy28/Bf/mX7v+1PVjMvoaHrm1/kHR70JDAThSCpZY3FfAGjNuGu8n3SDMN93sCc9X
         uuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=kKEei8yAqADdtFSTkBJAqxxc/VkzhmqquJB4WzGX/lg=;
        b=a7Nc6x20KzSTgCp/4s6VK3jCRDXjQeAHqT32pqgTzTuNueClYWFUUg+eA8B2nILWZS
         FZ42/ySz1t3qYan6mVcjJKRFM0+P7Z7Bt4YOnNvM2TyKCuryrIz8M+b7reQ7fe+K/LhP
         v6Wc2znpv5k9m/2CqiqDyMhhzAjiTp9MASvuYw/Lth37qTUp7R6lf6xjr8dYlPF3fSSq
         YeMcfgFqQuIN0PbSlxboLQEXq9CxWOb/qCvbEuC6UgPk9m1t1v92WWxRx5OhCeQb4sxD
         ESAMBPBjTpUA5auRw9IGUalnxOJ00Jn6qQ0ESpQFl+UGraNBmnxIMdgy5fzI8bIe/i+r
         UvPA==
X-Gm-Message-State: ACgBeo0BYYDEm8/WgVZZQaFkcsiqjt2HVc51JEtH7sjPYfEoMQin/lEm
        VJ/AgGcPRGG5J7bMdpXzf6UNa4R7QeePKqWeut5spsL86q2711F/KKHiQQFLHmpNlYhjikw4jgP
        pV/UJQVN4okiiaw9VXHiwI6zeSyH0bVlEbr+SGRcdvwwyKc1sEUen17/tH0vvqxg=
X-Google-Smtp-Source: AA6agR44YgVjl+zSdjdmZzaAaHy96t1Ze+2e/RYJnTzHOcfLWqMjm14EfFmxSrQoDYyXyZivoKiVQXAlpYWhYg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a63:5702:0:b0:42a:b77b:85b3 with SMTP id
 l2-20020a635702000000b0042ab77b85b3mr4511539pgb.263.1661547627489; Fri, 26
 Aug 2022 14:00:27 -0700 (PDT)
Date:   Fri, 26 Aug 2022 14:00:17 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826210019.1211302-1-jmattson@google.com>
Subject: [PATCH 1/3] KVM: x86: Insert "AMD" in KVM_X86_FEATURE_PSFD
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


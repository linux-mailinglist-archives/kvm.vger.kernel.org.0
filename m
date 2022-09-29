Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CB25F0100
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 00:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiI2WwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 18:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiI2WwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 18:52:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E10122059
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:15 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-34558a60c39so26567677b3.16
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2OFdCaRagb593fYnvEdJFi/bj1YV59jE/09bR+4NEGQ=;
        b=a/9Wqu4BL6XoolgS4oa6jdVHaHeKic7k0TMfw5kLWNMfbVJ/MoKf6fuAqJLXaE9Qiz
         ldc8aUifKKHX/GzctBDyU20wM0XurYSB/a/g+IoOE+5tQAFXdtr/Q/m2s4ZOqZkoWYN5
         TWLk1laCdElAkFHeVewn8lVG9JBGRRONLvQeX2V0v5L2+y5WapE1t3UsJu3r349QsYVc
         dMfsmwUDEbmsRpC4T9CJVXI5MHcmJn3MPZwR90WcRAb7GZ9NB2BfHMVZvmWrpxQoPZvU
         kzhl3JbqfNK6ey2yb4WlG7tuR8cGkKelwVaoajEmamC/h5xfabF3foqPxOeWWm7befr8
         F3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2OFdCaRagb593fYnvEdJFi/bj1YV59jE/09bR+4NEGQ=;
        b=cIiT98sTa7W4zCOBrBnKT9HwyjMzfc0PIaSl2hGUElRll+J9oQWZ1n2r6JcIwxSepD
         Pb4Ttsipm4ohDtOSNl+WAZ3F3WbA5AaWPoZNT09PeTX4Vj8+8Fg7XDusXqAx5WPvBlAY
         lCBtqPovXn5cWh/M8M/DhCpEx/f0QSqMUN0/gfsvH6n2zcsQbc2Y9jmeaIRkoRTAiMJz
         Ip6GdHRe2zW1I2w7UZ1vlN5mYbd9er+nacRdoeU8vWddz5L9RODH2+efcmxkr3FHYWK2
         GIHqKyYr2aBwT5xCiBhf2UybdtPmiuLXmAIwZfMgC87z/WsiXHxbqvIbHwpQ2GqGRG+9
         8sXw==
X-Gm-Message-State: ACrzQf1lgPF70i8GD1dp5LsJh4Uz7Z6AXCil0k37c28aVSXZ2QbbRupP
        z2N44ud5MqvFnbPxa5iyCRgbjMBagBKatOB53paML3G2YYmz0eltbm58rD6n8aP7yactuhG1FIg
        aggA6NtPg3wl3I8RmHXc7tA4elFz5Grv1LlZieQlrSAVilwzlL8gvE8CCBD5R7j8=
X-Google-Smtp-Source: AMsMyM73uhcyjHRdUR6sgfu3bDyhG0BxQmWuXBupdVkLvtTBMdfD4tmuhrxOUtTKoUpF+VWZR0VdFSyBT19yww==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:8550:0:b0:691:11f9:41dd with SMTP id
 f16-20020a258550000000b0069111f941ddmr5371186ybn.600.1664491934515; Thu, 29
 Sep 2022 15:52:14 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:52:03 -0700
In-Reply-To: <20220929225203.2234702-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929225203.2234702-6-jmattson@google.com>
Subject: [PATCH 6/6] KVM: x86: Mask off reserved bits in CPUID.8000001FH
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
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

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. CPUID.8000001FH:EBX[31:16] are reserved bits and
should be masked off.

Fixes: 8765d75329a3 ("KVM: X86: Extend CPUID range to include new leaf")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 576cbcf489ce..58dabc9e54db 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1188,7 +1188,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		} else {
 			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
-
+			entry->ebx &= ~GENMASK(31, 16);
 			/*
 			 * Enumerate '0' for "PA bits reduction", the adjusted
 			 * MAXPHYADDR is enumerated directly (see 0x80000008).
-- 
2.38.0.rc1.362.ged0d419d3c-goog


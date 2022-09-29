Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16915F00FB
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 00:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiI2WwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 18:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiI2WwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 18:52:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC206120597
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b14-20020a056902030e00b006a827d81fd8so2312814ybs.17
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kKsPvqIyW4p0dj5/5l/6rX3b2gtbR/FFBwPE/+n7sEQ=;
        b=tGY9xjkHqkOFYwd/aXFe9KXVqSE7S8HHTsWciMJWauAsHTwqBrpwuckiM3Ev2rnowM
         vY7jB7nELi924oz7LNkvGeW5UBBswyzvcJCFsSpRGnBwj5jH5Dtx8NsyJiKm0YbCtEN2
         9Md6r+g467ZfG8V2IQX2ZDrneZeNTNQbi/qKn3HX0GgsRQcFk9x5vzv+4XmT0fw87Wjh
         hh62ddIE8J649Y5iuhW/OVcEpZK+J9qGNFivmIb8miuSpyVWAwuE8j0pDv2A5WiMnx5u
         ZxccAZbvoDw7o2F9HwkEW+QJSLP+NvhmSFBmLNNgW0ud4CTGP/bQhH6HsL6OE9/Y1p5/
         q/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kKsPvqIyW4p0dj5/5l/6rX3b2gtbR/FFBwPE/+n7sEQ=;
        b=ejekBi914KEiTwnL1LP5X45/7jm1UZ39MU35VwNx8WsyXkJqhj0KIE9frjpj7uSumh
         i2OwpYkob+bf5rFLdNipILQ4+fM3c24fzFNwg3ST+AePq7MQ/RxAU29PV/ErnJ69leD3
         CJZvJSVOk0NtfW5PDIKNcOy0U2eO3PbI3ao12qBmMaD/cv8QbnlhWdTWZ3I+1pyeLP36
         tAp7ur1AVmSKjscOJbGSQPVLDZpbzVZ8dp1Wc5tQFQeCFoflR9kr2aJP4yKheaPUVOM+
         KWWHoYBi0VLeOt6vxWGW79Wjg/JSMK27H/xHS6855fnvPAlTHxEgKAChNy3zOIfCwLXu
         H/gA==
X-Gm-Message-State: ACrzQf1FTrLYN84o6gSSacd9xarMIphXNsUUg/IraJOFi6nGHEP8oCYa
        YC8HPiDOBp5449fq/IdEnW2wIO8fcO+Zei4Fo2SVK2nmsa0D4RLI5VlSEaFax1mk82cDL/vDQvt
        bXRIYavNH2BMWMF8GtqWmhfR2PJ2moeEedyfOcLVPaB3UUoZfv7jGlke50VbenNo=
X-Google-Smtp-Source: AMsMyM7PfBUYGBRago5rGLshIrN2DomWAF/HdzJu5KoDA+WBSMoLEQD9cR09sptYrpuL6XsuVO+k+Cb5isEfTw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:af8e:0:b0:67c:3f7:e8eb with SMTP id
 g14-20020a25af8e000000b0067c03f7e8ebmr5698441ybh.646.1664491927977; Thu, 29
 Sep 2022 15:52:07 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:51:59 -0700
In-Reply-To: <20220929225203.2234702-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929225203.2234702-2-jmattson@google.com>
Subject: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
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
actually supports. CPUID.80000006H:EDX[17:16] are reserved bits and
should be masked off.

Fixes: 43d05de2bee7 ("KVM: pass through CPUID(0x80000006)")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ea4e213bcbfb..90f9c295825d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1125,6 +1125,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0x80000006:
 		/* L2 cache and TLB: pass through host info. */
+		entry->edx &= ~GENMASK(17, 16);
 		break;
 	case 0x80000007: /* Advanced power management */
 		/* invariant TSC is CPUID.80000007H:EDX[8] */
-- 
2.38.0.rc1.362.ged0d419d3c-goog


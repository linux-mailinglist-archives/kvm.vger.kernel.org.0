Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C52A5F00FC
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 00:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiI2WwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 18:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiI2WwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 18:52:10 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D4C120BC2
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:10 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l2-20020a170902f68200b00177ee7e673eso1897374plg.2
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9EK6+OCif4txEax6qNB8fO7zvcUwT71+kULa+mgJizE=;
        b=ImgvDWbgQPRvawqfIOrX+0np6oEmyuyB0C7QkFnHJ3ydaRiN0d/wDU25fd2CEvLLlI
         i1GxeHQQHC8l+YLPkHl6A2f2LzkEZ42qXJgflUotnbdkKB90jbXemYd6ZuPlsxJSoE4h
         rFOTz/69sccUS/D/FJ4+jvEaVeVSiwmtRz+10yMHCAbHLMOvkJ0D0orf1vkAuC1202rc
         /1H1HBD6996BLUqIvxyuX05tdOmvcxSJjsiU+lEDvOPyMgRK2Ig2B1ZGn1tMKkNLwPYr
         5QdnbNmjr4XvFA3oN4bQV0Blx+TMggkVBoSbErnhvIlSHE1t/9R/YYehC6GivdvPR21v
         /r8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9EK6+OCif4txEax6qNB8fO7zvcUwT71+kULa+mgJizE=;
        b=e71CL197+l6kNRHJHx2RPmjGFJcCvmEmVdqM4yfRN1TPtr7DS0gCXfkzMvJn9ie2BX
         3PerD3VWWGyJ6qcr0Z1CKmjHXxtay/tWqE6hzwNDPKaSt8QoixNuCUd5hRmYLQSzS4+p
         jNITy5CpfGr3e+2YDDZCgiwHTAwhYOPU2FQ/n4In8JvQNgVhkiZlBTpe3QgfE2LHSlrj
         DpEfmIbnusCGQtIC6DP6Wy5xJxUqU2zvQ4tkG9NQ9bLE5YLkWQeDf3baWv/eCJtiSxtg
         B93bidtGQgZgUoldBkPMuy38tZ5R/yvJbQQL1E95BbU2yDumw/xp7UJsbC3AI7B+Oa9Y
         F24A==
X-Gm-Message-State: ACrzQf1wtVOUhEIYcCpTR2ItaF2N50AHpbOncPoF0TZ0a1ec+VYpVBW9
        8EhrOQU7wDJKXQoAzzgeW2bCBJicDGEVzgwJpxsMZMdo6wHfMrrMn5W8Ynhl9uyus6/n5W99mqE
        t8klcbiM5Q/JucDSYnaicuUQkmzedEdagYiWBqZ24LR+IdXyc0v1xjSggJGQO0Ic=
X-Google-Smtp-Source: AMsMyM4KFC+8VP5Pvhk/XuJ5QhqbwJ338BItLuAoc/AnkkFHW6wjvW5X9flSTSEoEyyB23y2st21fN1IqtVRPA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:b8d:b0:543:6731:8b6c with SMTP
 id g13-20020a056a000b8d00b0054367318b6cmr5676492pfj.80.1664491929365; Thu, 29
 Sep 2022 15:52:09 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:52:00 -0700
In-Reply-To: <20220929225203.2234702-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929225203.2234702-3-jmattson@google.com>
Subject: [PATCH 3/6] KVM: x86: Mask off reserved bits in CPUID.80000008H
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
actually supports. The following ranges of CPUID.80000008H are reserved
and should be masked off:
    EDX[31:18]
    EDX[11:8]

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 90f9c295825d..15318f3f415e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1156,6 +1156,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
+		entry->ecx &= ~(GENMASK(31, 18) | GENMASK(11, 8));
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
 		break;
 	}
-- 
2.38.0.rc1.362.ged0d419d3c-goog


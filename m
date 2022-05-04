Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23B251B24A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379120AbiEDWxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379108AbiEDWxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:12 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD77553728
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:35 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id a11-20020a170902900b00b0015ebbae6dd9so1370651plp.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Cqs5TIeLdHODF4WijWucbG7WQzY3+z3c6FfhuiqpzWI=;
        b=HFrNCi/d1jFJZljXfD8H2ZOJbbMk7b/nb6i58/0Vsm+DeIwjrTLBO1cW2b9QblhZYu
         KP50apJ1fzaikVTQs/lIokm3asXVha+5DjgUYAe4Fb5e5G/06LFh/VodwPHgn/tDJfhx
         BurHKe+NCrSg4Tqo5BmOVfPXtwiQWMvw/KqdmzWTEviYw4j2SQrDXPcpz+EKCWv8r/KS
         S+EzojfwULkUEoi2/t8u/xiKLbzTPZNvAnzvk79zrcLu2NZHsE8CT+5iUZ9X9wGGBkQr
         6J3xAOZJt7OE6+aHDhDzgjfzqDxqXXJ72p1/Yy8a/NGj6TQDQOaUmwv5J67xVKCqK1OC
         8QCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Cqs5TIeLdHODF4WijWucbG7WQzY3+z3c6FfhuiqpzWI=;
        b=ita5tX3uS5SiHynn9/Bd/KsQUtJSh5D5g63EtfD0rqqBZnExGWN7zfo1oW5e6Jsge4
         g8OzeJLVcVb8lFRXlFC4SB6J/wFyf+zvzZqwmkNkRTyZnK2rv4wl8A6whEqstJQyo8ka
         uDeHyuiA2m0r3MYB2ispDDzQAHd8IqCn1bZdZdtDLlcdsCzYat9XMGU4M+18oSkclcz0
         lYHbVRStW0QtXeNH8lX4UODGCHi6gPAXrAXXN3hdAK15kHzU2zWHwJR8wETTfVRo4zoT
         Nh7tp4j5V6J7irq5n2fqNxkKY3Ew0lk5M87utjjLYRy+9K9+Ddo+VgIBnPNm5iWD3F4/
         mYlA==
X-Gm-Message-State: AOAM5329sDJiW487IYm7bNguqu3GRrdEGhcXambjsrbWCk3gJSmUKKlJ
        llLu0FkxEhm0+Teo5lVhYioXJ+x6Vn8=
X-Google-Smtp-Source: ABdhPJzDMLEOlYFuGSLY/Czn/CXsJqXWiHgx1OzRw3017HQFvTuATu/4dg2i6DFrSpbEdy6IROuA6T/tlFA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea06:b0:15e:8367:150b with SMTP id
 s6-20020a170902ea0600b0015e8367150bmr23440476plg.167.1651704575333; Wed, 04
 May 2022 15:49:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:08 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 002/128] KVM: selftests: Drop stale declarations from kvm_util_base.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Drop declarations for allocate_kvm_dirty_log() and vm_create_device(),
which no longer have implementations.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 92cef0ffb19e..47b77ebda6a3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -381,11 +381,6 @@ struct kvm_userspace_memory_region *
 kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 				 uint64_t end);
 
-struct kvm_dirty_log *
-allocate_kvm_dirty_log(struct kvm_userspace_memory_region *region);
-
-int vm_create_device(struct kvm_vm *vm, struct kvm_create_device *cd);
-
 #define sync_global_to_guest(vm, g) ({				\
 	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
 	memcpy(_p, &(g), sizeof(g));				\
-- 
2.36.0.464.gb9c8b46e94-goog


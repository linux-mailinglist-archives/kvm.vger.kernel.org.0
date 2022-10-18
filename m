Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE2660347B
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 22:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiJRU7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 16:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiJRU7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 16:59:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AFBC14AB
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:59:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h2-20020a170902f54200b0018553a8b797so3984625plf.9
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vkb6jpXxRXZcay7XTYkpdaFUx0NcW26q2P9aH4gnX04=;
        b=IH/dgM5QKzU6C10PzalpoK2rBbFJNvA1rL1ERHjeWHFmjnozppx/HMFwk94ecDWk8s
         fAZwZdDI/u79+0/2WLTJ5ndBjDvrYCTW9+8yeM8uSof9OmmYD0Wug3u3JB2D76IutTMT
         FV8Xy19ZjJphypvoCzFUFTHb4KvwiekOsCvpSFasHhjM/Xeoyxv39S+rgjP1pNJR+u60
         OIFtcFw/ArZOasgeq26VYKJanrmsiiclQESeI7tkWSoF2GKoEC1G58fV8ZJMGaEKCNiX
         1PVbb9jZpAo9UwN8nZOdd1gQZOPt92nEgEbu1brp1iT9JIGaPaAnpaourRvYQrWqfPoH
         UrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vkb6jpXxRXZcay7XTYkpdaFUx0NcW26q2P9aH4gnX04=;
        b=L+SXdS9x1ZnuaE0hmxVKR3HsBAu38j8JzjN8hkTMDqZzkurDc8ALnFVhXDjHckLMcq
         9OLa5uICiSjrO1eKgpiogbi7esz4bjB36KjXNRaYJs3MKeSmJC32XmBZZJ/jt2AtqaFt
         n9wbQr0YFfuPaKCgHt4hv/3of6tVDFCqfOzlT8uxCD7dRo+FMl4gkfL3qBT3tkD93n22
         8dVJqrjkEh9Ad3najydaS6DewwuO6Hoi6hXe2O70g9qcLH1hNM/0HFOUaOm9gedVuJpz
         bgGKwXRHH4lVkf+9tXB6HJ2Ead1ezIkhT269b1AZJafJ9JY4IzzK7QnE9xptKFkVlaAn
         G78Q==
X-Gm-Message-State: ACrzQf1vu+BYlPQX336sxS0kKe7ZIwyX8hPeHgGQJDK/xT0EWVCoJpBQ
        lrP/uKzCR8EL4Oi1300tHsdlZVACb8Jzidj2re9k5hEHNZCwnD5Dz1nLErcGbjvPEOAa6ig2O4T
        HoS60hELbbHroZXrcMU5zGTD3y9nhlRZ17Hfe/1yCcGlmn2dEf5F/aGAqHQ==
X-Google-Smtp-Source: AMsMyM6gWaM+5KHq5DwDpoeWgVDI44spRtgwQiBXuCMKoRb9lPcBx9WZlc9ds26VUJSxhYirnqGK6AzDdGg=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:c89b:7f49:3437:9db8])
 (user=pgonda job=sendgmr) by 2002:a17:90b:48c1:b0:20c:8edd:59a3 with SMTP id
 li1-20020a17090b48c100b0020c8edd59a3mr5603433pjb.222.1666126745539; Tue, 18
 Oct 2022 13:59:05 -0700 (PDT)
Date:   Tue, 18 Oct 2022 13:58:44 -0700
In-Reply-To: <20221018205845.770121-1-pgonda@google.com>
Message-Id: <20221018205845.770121-7-pgonda@google.com>
Mime-Version: 1.0
References: <20221018205845.770121-1-pgonda@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Subject: [PATCH V5 6/7] KVM: selftests: Update ucall pool to allocate from
 shared memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, pgonda@google.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the per VM ucall_header allocation from vm_vaddr_alloc() to
vm_vaddr_alloc_shared(). This allows encrypted guests to use ucall pools
by placing their shared ucall structures in unencrypted (shared) memory.
No behavior change for non encrypted guests.

Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index fcae96461e46..b4168e562255 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -22,7 +22,7 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.38.0.413.g74048e4d9e-goog


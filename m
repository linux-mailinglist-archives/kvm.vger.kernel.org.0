Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8F06646F4
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238747AbjAJREb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238540AbjAJREM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:04:12 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B3E44C42
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:12 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a18-20020a62bd12000000b0056e7b61ec78so5496907pff.17
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wd8IRDcm/I+X4nIj9mIHk75KksnNCPDW6vKldjVyscc=;
        b=sXj2PNkyoMv/M5+nsVqLWsJP641hr0cV8y9ddDpJOvUNXV1XuSoarlapj938jgSnhS
         7rNRsSXpXqyhkaSWdzHRtCItCxinKVzUL1Jr1X2XUz/VU3KzXYASlQpsAGFOkCjC/8vm
         +eddG+vkUrudOO9iwYbhlgBEhcUgq5bqdYfWPPmLUFBBXflINQYNwrKNDdfkdHCjoXTX
         84PKqSQ6IiMWLXX9QaOsjUuZzZpfKP+/yBlcRPZOUYMK6H4Fnv4fDdpDqUs4SEqBh9l9
         IR2wCyk7YMUJQxWDCYE21/tnCf/pN3Bv7lV2XR8opOHl/r0GYPJGKrmX6e+s+8QzWWej
         h6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wd8IRDcm/I+X4nIj9mIHk75KksnNCPDW6vKldjVyscc=;
        b=O1KpFOOdMKrR/pj69vqxGaWJ2hGfp0+M9Ko7BUtW5Wgb+st7QLbZgJFGgbN5dUW5Fm
         KcJ2mCtV3mE5iHKKJreLuxb8edHmvt1abjU4XQvQqKUU58ByjIK0qgbgRIYEka7xKO3S
         CWWrZDvT2dNKcZghu/MVHVNlM5YDx4nosr6UReVVBpTDElbXi+reohtddBRbWqTERdwI
         VY0vd7g5HJbo+NuPpOTD5tS2H8V3VtXo2kMRfurRic7dNXL7KkCDFsC93CtVJEtm3eXM
         GlGlx/WUMQ4dZaBadLNOC4biykfa3tJUBIOZHgKj3k8h82Fi8qcvFaVqkF2WD+wvtPqi
         wJTQ==
X-Gm-Message-State: AFqh2kpqtOSNtB3Hf5byBDKrgkEjBHsmO2yxBvlGh081ueNcd37yqQWx
        T8wvcquTssaR6IbbJ/kCswKZHoLBBwkXOktkrj/r0mvDLa/h7PvaXXH4E1COeB+oJtADg2l18Dd
        bz+N2b2n/3JKdyJkgzPuOuMd1ASuUcBxwjJ9zJvG6wHzRFIoOyYnZdr3b9w==
X-Google-Smtp-Source: AMrXdXszK0rmsMkcBRtmXc4668zB9ryouhknfZXU3pTVF/td7AQOuETq73YFekoXrqc2NHF3PrMnIsCgsyw=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a63:5c54:0:b0:49d:7f4c:f695 with SMTP id
 n20-20020a635c54000000b0049d7f4cf695mr3213615pgm.311.1673370251512; Tue, 10
 Jan 2023 09:04:11 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:03:57 -0800
In-Reply-To: <20230110170358.633793-1-pgonda@google.com>
Message-Id: <20230110170358.633793-7-pgonda@google.com>
Mime-Version: 1.0
References: <20230110170358.633793-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 6/7] KVM: selftests: Update ucall pool to allocate from
 shared memory
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerly Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
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

Update the per VM ucall_header allocation from vm_vaddr_alloc() to
vm_vaddr_alloc_shared(). This allows encrypted guests to use ucall pools
by placing their shared ucall structures in unencrypted (shared) memory.
No behavior change for non encrypted guests.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 2f0e2ea941cc..99ef4866a001 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -24,7 +24,7 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = __vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR, MEM_REGION_DATA);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.39.0.314.g84b9a713c41-goog


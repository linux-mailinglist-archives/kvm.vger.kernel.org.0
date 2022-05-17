Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4552AB78
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352495AbiEQTFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349953AbiEQTFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:35 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88703F322
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:34 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p18-20020aa78612000000b0050d1c170018so8107803pfn.15
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DnnFlLu/52FYYZr9wXdmSOKepKzJDBtm1RTeG5CUNV4=;
        b=Obu5/CRlI4gPbTWSTGOb3i51Ln4WBIFrTFBdbAA5rhI4/318nV8J0yNP2DJfx3BXdo
         iqORzLRYXAnBcc7UmAYQZN+F1PvdRXSFRfjOCbEAGAhQj3gCtdYDMjzgRBuaBlDUeEBo
         MnVLwizHKVZ0adlzd0SAXM3I8Rmug4MrEBQdSOf3RnY+/Cb9cG6j7D/wWcpYBnojZsdO
         1pvfUC0cYpdUMUB8FDIFH3h81iO+MCC6SceTlS60oZHi9ygneskqz2MppeZUMsjsxLN0
         Ccc+OP9+gTW/J6NtpNkHOBUpXnKfl23Jzt4xhsyLd45jKrWaaZzqzTQUWzOTzQLjtXi7
         nHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DnnFlLu/52FYYZr9wXdmSOKepKzJDBtm1RTeG5CUNV4=;
        b=rjpdZdldNZPXnbfd8bMFchQmu8h9X2KKqVnOSJA/G3qvTeUq5YAxLq912PUYFFzzaR
         uDrifnWSG9VgcMTk8hDhAd4xAM9hbOibl75fwcY+wGXeBwfwQYj8HJ75hgF/0N53oHkM
         aMdzWTamDubAn2eyZaP3fUfNFWnpfunnrgsPDRt2GFaLdbKNeURachVzis7DjncUSNDW
         hPWpXg2saES4uNCv61vLQzF+42XSHVG0tgSMkJE7o5bL3PwNysKOk5nXo/KrKB0P5hHv
         BEmaVBxSh5fh9dG1CHdRwzde5ogTGJwPe3uHOlWmOVVnAKr2pgfTWTI787Z4jM7DYfSw
         HWGQ==
X-Gm-Message-State: AOAM5315JiY5nBjUIy6WWF67DniqtEjIP1GvP627RokdtObQWk5Jxrt3
        M5C6Iz5wRKC11/182ikFBGikpy97D11csQ==
X-Google-Smtp-Source: ABdhPJw+5+0muhQTAljpvErY2kDwFWekG3fk/QxA/Da+4uXGFY4LuEG6qIpJg54USoQ2tnndEmYVoxz6xGiwsQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:4091:b0:510:71b1:963e with SMTP
 id bw17-20020a056a00409100b0051071b1963emr23762972pfb.31.1652814334344; Tue,
 17 May 2022 12:05:34 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:19 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 05/10] KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to vmx.h
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

This is a VMX-related macro so move it to vmx.h. While here, open code
the mask like the rest of the VMX bitmask macros.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 3 ---
 tools/testing/selftests/kvm/include/x86_64/vmx.h       | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 434a4f60f4d9..04f1d540bcb2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -494,9 +494,6 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 #define X86_CR0_CD          (1UL<<30) /* Cache Disable */
 #define X86_CR0_PG          (1UL<<31) /* Paging */
 
-/* VMX_EPT_VPID_CAP bits */
-#define VMX_EPT_VPID_CAP_AD_BITS       (1ULL << 21)
-
 #define XSTATE_XTILE_CFG_BIT		17
 #define XSTATE_XTILE_DATA_BIT		18
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..3b1794baa97c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -96,6 +96,8 @@
 #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 
+#define VMX_EPT_VPID_CAP_AD_BITS		0x00200000
+
 #define EXIT_REASON_FAILED_VMENTRY	0x80000000
 #define EXIT_REASON_EXCEPTION_NMI	0
 #define EXIT_REASON_EXTERNAL_INTERRUPT	1
-- 
2.36.0.550.gb090851708-goog


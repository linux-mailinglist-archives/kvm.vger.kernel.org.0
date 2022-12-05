Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEA6642465
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 09:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiLEIVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 03:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiLEIVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 03:21:19 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980D915A1B;
        Mon,  5 Dec 2022 00:21:17 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h7so11361041wrs.6;
        Mon, 05 Dec 2022 00:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AoYiUm0CAuKiBijaDIoS23ayBhfa6Vxgpoz9/9wHDCY=;
        b=MU/F4mHxbDQV0ncGQ1q7mZM3A1oDKoawjBYD/MsUMNywpIpqVbk6c465LE78KIml0Q
         eO+uYjMN5F6ZgcnLNtWItfC+KFLwL1ArMcYX5oXyXzxPzmFykgQL8QnvzvckK/+Wjca6
         nzA22sZGqAdkDqZUIWvXMT1/UWbBcaJV+CA8wX2QCRKtQn7IOYxJT+WQvAvQMDOxd9qa
         l6wFlqBwGa/0GuHLEwPrgWmV0jdTbMNaugfO3oTMr8bwh/tzunJvKP6rw9EiH18/abyX
         TCiwK9g/kuVqcxIxJASOnwbyrPUV8aAXsxdK1eVcasEsSAbgeoWQZEH+aBgvZwKdDj/P
         PeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AoYiUm0CAuKiBijaDIoS23ayBhfa6Vxgpoz9/9wHDCY=;
        b=SjlZNiyoMmW0w25sY55ER9R6KSHQuTE4mXlcXZEX5ULykwh+RRJpohbpJ1B9kFCWfL
         h/she4ejesxJ9DEK90GptmUD6QEZldx+sAitxO95tal9z9ocdNDkNvQDEzdelK6CEFP5
         gPu1mLs3KgvYCfH57uH7m+MXcUNiDsDI5U0/k8Sb0w6LIyn/87RPHRSPFPyCUImEvGm9
         GzI2RbmcT97LY28TgoL1pkrnqCnt1CtzpI5qYED4Bs8ehONFskDlYViQY3LWJk5jzred
         5u8oMSdYOEAdNWxDZ9EDU2ONXABsXoHwwPHzEqva/Z1NLum7H5fCLAc0zDZKagqf/P4N
         MalQ==
X-Gm-Message-State: ANoB5plrQqXUuxugeNZ46JyfTk4iAY4TTZNiuhu1R6fEew/dqqs5DnSH
        o4JBoz5MSAXF2unB3WhoxJQ=
X-Google-Smtp-Source: AA0mqf7XDfL88V/zuF3ps7+lP7rAf8Tmlm26ebdLUUXu14RS20LjHG81XovN0UYrCwQ1JIwnY6U/Mw==
X-Received: by 2002:adf:a413:0:b0:242:1cbf:8f73 with SMTP id d19-20020adfa413000000b002421cbf8f73mr20448189wra.317.1670228475933;
        Mon, 05 Dec 2022 00:21:15 -0800 (PST)
Received: from felia.fritz.box (200116b826fd9e0089413745833bd418.dip.versatel-1u1.de. [2001:16b8:26fd:9e00:8941:3745:833b:d418])
        by smtp.gmail.com with ESMTPSA id bg28-20020a05600c3c9c00b003cfa3a12660sm26317084wmb.1.2022.12.05.00.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 00:21:15 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: adjust entry after renaming the vmx hyperv files
Date:   Mon,  5 Dec 2022 09:20:44 +0100
Message-Id: <20221205082044.10141-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit a789aeba4196 ("KVM: VMX: Rename "vmx/evmcs.{ch}" to
"vmx/hyperv.{ch}"") renames the VMX specific Hyper-V files, but does not
adjust the entry in MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

Repair this file reference in KVM X86 HYPER-V (KVM/hyper-v).

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ceda8a0abffa..8fda3844b55b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11457,7 +11457,7 @@ F:	arch/x86/kvm/hyperv.*
 F:	arch/x86/kvm/kvm_onhyperv.*
 F:	arch/x86/kvm/svm/hyperv.*
 F:	arch/x86/kvm/svm/svm_onhyperv.*
-F:	arch/x86/kvm/vmx/evmcs.*
+F:	arch/x86/kvm/vmx/hyperv.*
 
 KVM X86 Xen (KVM/Xen)
 M:	David Woodhouse <dwmw2@infradead.org>
-- 
2.17.1


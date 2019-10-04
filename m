Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B907CC41D
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 22:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbfJDUW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 16:22:59 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:45365 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729079AbfJDUW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 16:22:59 -0400
Received: by mail-vk1-f202.google.com with SMTP id q84so3101800vkb.12
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 13:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qJDTT4TzSeM6Ovj+jHpxrL9mwVSVi8k8BDpDAv20MTU=;
        b=dvVFZMsfHuYIqaLHJklvqK9f+qzvk35qAJsMoBxiPLkbyumc8k+ZhLW2Sw4F0Mgz69
         8NLIjjpYDavr4DfYDNuac9vhiDqekaoPQsCe2C21nhMkSOAzR0HqZq2IDje/5YjK3vFH
         r2aaE5rvb/HO/pwXPF8+Dz79iNB68n8A/iKSKlxERlzOj4XNO9yc9erSW/7wK/O0LVki
         Dps5ZbVIGf86051T65wcyEfrtGwRvCtBGFUJCpjgdHA55TDqqEbBfXXN83+VhK0+t9rK
         mzhH8R037X0MPaMii0V9av6O586XZ1wUTim74ZIz/b6LBg7zmp3Td3xtJS5rEVk5dDsT
         mAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qJDTT4TzSeM6Ovj+jHpxrL9mwVSVi8k8BDpDAv20MTU=;
        b=p+PTALnPEFnYe/1g8Dip9Ak9FkL1BOqCFEkc0jaq1QxbBW7VFNZGTf0Jy16A+eWiJT
         b7wyDZ/Z3fs07ppBbW6ljwoAmwO9oy1NA3mwR+MfAEswMs0sY5F2fn+8vpgy+jL7Aa+b
         yFpTcuj1sBvwthh25z4EZfMA7nxmEmNDmWln53r9pNduggIOdP4Ov4HjKYjUBEwJW9TW
         OIlh08XV0YvT3g10LDqgZ3CjdXRCx81yPWAGe/WktNwMfIf3hE24PYu5VmfBXTUFoCpY
         /GzGAIDaNjlZhqYCvdWG0yerqFxpt2PBX2g1B8IWKhBiT8JhkhjVj9v4oTW+T32ypGoh
         2epw==
X-Gm-Message-State: APjAAAU0g6+cyvuM62dS8vmvbpnRHpr5jYoVWdcqnSxNEaKN38KUsVqe
        YH7axfaGAeAPE/02yLAaoGiawx11rPfAEiL6NUtgq/z868wbgaUw/eVB8S2UYLGzdOYJ5Dz7HZ+
        qtRmhwuGjqVwGIX3G139Il562ocW2vWZtWQ3hE4+R9+6LfLPjMNoro11GRUEF3xI=
X-Google-Smtp-Source: APXvYqxDBs1MunWLoVdvn9DuiZTa26vmQ3PveqfRoanmVeBobh3RHhZyXd3GOr+gBpo2YKZNqbh41I7a+A8iYQ==
X-Received: by 2002:ac5:c186:: with SMTP id z6mr2003757vkb.45.1570220577770;
 Fri, 04 Oct 2019 13:22:57 -0700 (PDT)
Date:   Fri,  4 Oct 2019 13:22:47 -0700
Message-Id: <20191004202247.179660-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH] kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the RDPID instruction is supported on the host, enumerate it in
KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9c5029cf6f3f..f68c0c753c38 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -363,7 +363,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 
 	/* cpuid 7.0.ecx*/
 	const u32 kvm_cpuid_7_0_ecx_x86_features =
-		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
+		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
-- 
2.23.0.581.g78d2f28ef7-goog


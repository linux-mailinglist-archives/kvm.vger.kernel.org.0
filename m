Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1781328CAD1
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 11:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404228AbgJMJOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 05:14:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45946 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403911AbgJMJOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 05:14:31 -0400
Received: from mail-pj1-f70.google.com ([209.85.216.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kSGO5-0007Ic-HY
        for kvm@vger.kernel.org; Tue, 13 Oct 2020 09:14:29 +0000
Received: by mail-pj1-f70.google.com with SMTP id r1so1820078pjp.5
        for <kvm@vger.kernel.org>; Tue, 13 Oct 2020 02:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VNJOKkvPfRVJ4oA2MF0E6/OVvHsrdR5Ytgp8RCYFYlY=;
        b=VNBbeZu9qtiyrYse34uDRh6DKS+bRb6BHxYbLv/lFntiOSfJziHk6IhTCdO7a4/Jzl
         kMnVrpBHmx1kUoAOha0d2pPzFcETfo+NzWdj8Fa07gmwryunGCMOTIxoSFfsTtyxqmWP
         Undr8khgm5iG8wuSaXaPgcimcPV6nsrjMtI5yk84nN57v0whkGOxmRCXNn/M/Ra8IGGt
         zR+gKsRSDm7Ot/iRY36sneQ1PPCNgUdqjRceThxzB8lxFLdNyJnDvu0F9kpexPJ/t8Nj
         M02WThCCOb7wtDUqA0GIyl2ZWttbV02FTp9orbC52qt206DIWORMXAdWDsgWHPMCYcV2
         d11A==
X-Gm-Message-State: AOAM533eY3smldd2Ww39cUKoeNgDJJDZHBkFSqRq8LLX6mJdCCTpDoTl
        GSZpo//MViwCo8iKFH2uePyfhVfLQDPYcMFTezas6OY/q47x5tFpGJ5XPUusE+F9ySLA0jSnvE/
        lEGW2TTGAk71W6mjpNK9KdpBK21Wp
X-Received: by 2002:aa7:93b6:0:b029:155:3b0b:d47a with SMTP id x22-20020aa793b60000b02901553b0bd47amr23779681pff.47.1602580467914;
        Tue, 13 Oct 2020 02:14:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgkPdSOroV9BNlKuvtOXnMSHizdH5O609f2SgXbAJfwi//GVI3+Ao6/PO6xSCXVyC2IVavwQ==
X-Received: by 2002:aa7:93b6:0:b029:155:3b0b:d47a with SMTP id x22-20020aa793b60000b02901553b0bd47amr23779665pff.47.1602580467618;
        Tue, 13 Oct 2020 02:14:27 -0700 (PDT)
Received: from localhost.localdomain ([2001:67c:1560:8007::aac:c227])
        by smtp.gmail.com with ESMTPSA id m22sm21112458pfk.214.2020.10.13.02.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 02:14:26 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     po-hsu.lin@canonical.com
Subject: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic test
Date:   Tue, 13 Oct 2020 17:12:37 +0800
Message-Id: <20201013091237.67132-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We found that on Azure cloud hyperv instance Standard_D48_v3, it will
take about 45 seconds to run this apic test.

It takes even longer (about 150 seconds) to run inside a KVM instance
VM.Standard2.1 on Oracle cloud.

Bump the timeout threshold to give it a chance to finish.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 872d679..c72a659 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -41,7 +41,7 @@ file = apic.flat
 smp = 2
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline
 arch = x86_64
-timeout = 30
+timeout = 240
 
 [ioapic]
 file = ioapic.flat
-- 
2.25.1


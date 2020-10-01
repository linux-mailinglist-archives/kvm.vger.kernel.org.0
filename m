Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06AD27FE3C
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbgJALU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 07:20:26 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55235 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731134AbgJALU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 07:20:26 -0400
Received: by mail-wm1-f68.google.com with SMTP id s13so2486034wmh.4;
        Thu, 01 Oct 2020 04:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZt2zy/Lwar12EpzsAU+4I+PUix2uePSQ1boZKXlZbM=;
        b=B+hp5AXvO+qvWEMhpHX10f+zMcOxZDHJvY+z8gF+vQLDc3H2wHIXZwC9jEDbZtvMtO
         WUyDG9eUlKGijywFeNxxJrs/iK0KyTSn3pF7KNjTxlHvBFafmA/zm6Qqyb/fClEmNtqe
         5HOtDO9mDFg3cPLt11QL5uFMNb/Si8H9pwrByx0WQ646hPJFsfetIwYd3ew8caGv1cCw
         IXAz5xMTKo4whPm4w0nM+Z+S7Y/m2aufogjGvwxiS6ef1S905/O7KUyg+6FE+Wh7YAwJ
         0n+uEw5s4v4c6g0IxilMpc5c1/MXCzJ64xUtpfq+u6Logkwbj2KF7qSZx88cC/JKg5lV
         rrrA==
X-Gm-Message-State: AOAM530V96R8dytvswaNBtmnMfvpbIG7vFrdLnHrAh6CmQuVxStZ3Qyz
        UbJqDmEWJP451oSMigD77xmCaks6Ppw=
X-Google-Smtp-Source: ABdhPJxkB1EfFW+sdX3dph2xmIMIlse6uAZJ5j9V/jkkxdGL2OujglwQsUXsdaNBzRAi0Zsl1b3rfA==
X-Received: by 2002:a7b:c958:: with SMTP id i24mr8349585wml.50.1601551221189;
        Thu, 01 Oct 2020 04:20:21 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-95-179-222.cust.vodafonedsl.it. [5.95.179.222])
        by smtp.gmail.com with ESMTPSA id r14sm8406689wrn.56.2020.10.01.04.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 04:20:20 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/kvm: hide KVM options from menuconfig when KVM is not compiled
Date:   Thu,  1 Oct 2020 13:20:14 +0200
Message-Id: <20201001112014.9561-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Let KVM_WERROR depend on KVM, so it doesn't show in menuconfig alone.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fbd5bd7a945a..f92dfd8ef10d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -66,6 +66,7 @@ config KVM_WERROR
 	default y if X86_64 && !KASAN
 	# We use the dependency on !COMPILE_TEST to not be enabled
 	# blindly in allmodconfig or allyesconfig configurations
+	depends on KVM
 	depends on (X86_64 && !KASAN) || !COMPILE_TEST
 	depends on EXPERT
 	help
-- 
2.26.2


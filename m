Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA9714BAA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 16:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfEFOTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 10:19:15 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:47413 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEFOTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 10:19:15 -0400
Received: by mail-vs1-f73.google.com with SMTP id h23so2566337vsp.14
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 07:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DW5TEc9dftjGwF3cHqm/Wd7O5YYKpwazUd03pdv4LAE=;
        b=J9d5OXAM9dtxJ6tX+POujBS2d/BqFrFpsD/6PF7+7huItzfX5515ckZ1RRobVIibVo
         TrIrNulQg/W9e2BMdTisZUEcG2n9CCatLUchMSumkD8bcZ3fVTlfO/hF4bGQ+OcNaR0n
         542Uql4W9+6ANOyN58yzqf/cyNHvEixi2/KhIoDvxsawMOACqa5ivtB5Bi75QlyZeGuM
         eHzAsNQdfSwD0/qtVA7kI1g3WZ74HSgC8joWZIPxKNDXRvqG5scl295w6Pvn2A/3FaDN
         wWGviKvLeOay2d2A+fMV0IdpJ6ahwyT8ew9fxBTfYJSpd2Sbd5M/aTU+/vs3Ww2zJ1a5
         ov7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DW5TEc9dftjGwF3cHqm/Wd7O5YYKpwazUd03pdv4LAE=;
        b=qcWjYXsSPR6TYx3FxMVHO6KHrRonXkt2wXQwOC6nj8cDuE9Bx0LKvNYuMSLXzRyTNn
         WAuLPjvmI5aP21DcAIkMI3TsvKXPLH6uMEn05ShCPf1kzeT9oJwUyNIXpqL7mI3SD946
         aZUsgZQtNt1zlRvlf99i+o1N3g60haGSKXxqC8ZvYysWLI6ckEjAiK/TeWeg27+g+C4O
         i1vVhwTiybF7tcKfniNDdIyankjknZiJ+nbN+kHYSB0qc3U4EcBSn5jND68NgkLlp/Qn
         a4nzeZRCaR4oVvSDEVTb2pS6GOhYedMb/GAs7V5QOI0CPPnxD0pVwT5in0qpF0bHSAFJ
         yPFg==
X-Gm-Message-State: APjAAAVqHPqKqaYJCYB//0MmO2xDD55OdgrCJZTNgZz6q8vnaN4j+zme
        /A41f2eDeD14KW6vZ77czE7TWxzzI/jzGQDy
X-Google-Smtp-Source: APXvYqxm09bGPVc073hJ/l7Ai97H86OzOiUKIomhZCkabvtIVCfWHrSIT1E1IEFxRMA2qBwE171vvGO4Zn3saGDQ
X-Received: by 2002:ab0:1646:: with SMTP id l6mr13112138uae.75.1557152353871;
 Mon, 06 May 2019 07:19:13 -0700 (PDT)
Date:   Mon,  6 May 2019 07:19:10 -0700
Message-Id: <20190506141910.197288-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v2] tests: kvm: Add tests to .gitignore
From:   Aaron Lewis <aaronlewis@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        pshier@google.com, marcorr@google.com, kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/.gitignore | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2689d1ea6d7a..6027b5f3d72d 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,9 +1,12 @@
 /x86_64/cr4_cpuid_sync_test
 /x86_64/evmcs_test
+/x86_64/hyperv_cpuid
 /x86_64/platform_info_test
 /x86_64/set_sregs_test
+/x86_64/smm_test
+/x86_64/state_test
 /x86_64/sync_regs_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_tsc_adjust_test
-/x86_64/state_test
+/clear_dirty_log_test
 /dirty_log_test
-- 
2.21.0.1020.gf2820cf01a-goog


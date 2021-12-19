Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A512547A1E7
	for <lists+kvm@lfdr.de>; Sun, 19 Dec 2021 20:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhLSTQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Dec 2021 14:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbhLSTQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Dec 2021 14:16:19 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A63EC061574;
        Sun, 19 Dec 2021 11:16:19 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v7so8366158wrv.12;
        Sun, 19 Dec 2021 11:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxJ5JO+xr+aGyZmZfIMhLhWi2LJHaqw8GY1jAJCXnAo=;
        b=JHhVaAun1KN1qTic3NvX3Th0fZ0ocVkdjnGz+3LPWOeX7ypFIv73TtXwLvd8+XEEaJ
         dGf20q57l0fYUM+/+bJD+C3RME3PcHxzCXRnOE/qmaVMcnMN5ClpoVZBlnWaoFAekhn8
         h7NGMRdh7Ge2yBKXHnOQHndQT3LJw9vpfnwYwJcJRVIpg2Ush9BGGuYzE+s1tugEz8K9
         6G7Tpz/z50s79uYrh8r/kghIfMB76wJEd5CPcpcp5afrM69o4MyG/K11jkWBBxWZoVOg
         EtT8QsFXr3cQNivd2cNdFHIeIznzfCN0r81PbvWQNB6mD0uEvC5SyTHJtFqdR/xHkjGR
         7U2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=GxJ5JO+xr+aGyZmZfIMhLhWi2LJHaqw8GY1jAJCXnAo=;
        b=RyoMDSNJmscQA0aZIKKrj14xNOXaxXxwml/qIfkZcPq0/q1OdNv2EGLlX0FBFt3B5S
         FUidJ693zzVO6G9GktNggRa49jumr38MMusjA4TurHvOWkSQpiZofL/0CJRrd+oVNLrw
         bf3j5UBmiaPTDqSO5XGNPPOaKMnvXNrOIVVEEZQCKIQ1n8aBDiJn1lQDQdhIb94I7Q1R
         Dp9OI9ZLvnhKPyeplLBRCbrq+p1fzqCqKUFvMSQgKFD2RnHDrHtRPfCUYo7X+d4gTOJ6
         bIzEMZgtmobZpOSp5X8iSiKmRzc94C659aetew0XAWwdAKiuGSH2rBj7qI6K1l7KyjYv
         vS1Q==
X-Gm-Message-State: AOAM531hXgOh+eMDbWgTv6DwOB6IOGQ1uvPPr/S0Z6iFocz2dqlwBcgQ
        Z21l8zgp19BmFNQTvx+cV40=
X-Google-Smtp-Source: ABdhPJzct5xjVSnX+MDcq6O3NtGCgBxYeBAm2FsOC4zMUMiUP2tze8I54+EGQQrTofPd0Nq4jl+aiA==
X-Received: by 2002:a05:6000:1845:: with SMTP id c5mr37332wri.420.1639941377766;
        Sun, 19 Dec 2021 11:16:17 -0800 (PST)
Received: from localhost.localdomain ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id l26sm6286187wme.36.2021.12.19.11.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 11:16:17 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rkrcmar@kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.16-rc6
Date:   Sun, 19 Dec 2021 20:16:08 +0100
Message-Id: <20211219191608.265537-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 10e7a099bfd860a2b77ea8aaac661f52c16dd865:

  selftests: KVM: Add test to verify KVM doesn't explode on "bad" I/O (2021-12-10 09:38:02 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 18c841e1f4112d3fb742aca3429e84117fcb1e1c:

  KVM: x86: Retry page fault if MMU reload is pending and root has no sp (2021-12-19 19:38:58 +0100)

----------------------------------------------------------------
Two small fixes, one of which was being worked around in selftests.

----------------------------------------------------------------
Sean Christopherson (1):
      KVM: x86: Retry page fault if MMU reload is pending and root has no sp

Vitaly Kuznetsov (2):
      KVM: x86: Drop guest CPUID check for host initiated writes to MSR_IA32_PERF_CAPABILITIES
      KVM: selftests: vmx_pmu_msrs_test: Drop tests mangling guest visible CPUIDs

 arch/x86/kvm/mmu/mmu.c                                 | 16 +++++++++++++++-
 arch/x86/kvm/x86.c                                     |  2 +-
 tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c | 17 -----------------
 3 files changed, 16 insertions(+), 19 deletions(-)

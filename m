Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E2B67A0DB
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 19:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjAXSGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 13:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjAXSGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 13:06:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC189772
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 10:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674583552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2N+kM/3dF+O6lMdyXgsFWVkaLPgjCZtQ7IuExEmDs+k=;
        b=Uug8QAEv6+R+2zE6apmBsqIzeoI0PzGpkKOriV+wt5Os/QgmN+uMLPSep5PMMvTO7iJjTf
        nyCuCNoBVMAnrrWVD8Exn3B73RVHuRXiiB8pWJF5jQ9mtLelN3Q6Zfg6CLAUeTH7wxzOcS
        ou+Q8Jg+F1e53Lx/4F4ZrlcGxQBXyJg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-m2TkqPBDMve15awijoak0g-1; Tue, 24 Jan 2023 13:05:48 -0500
X-MC-Unique: m2TkqPBDMve15awijoak0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 691A53C42201;
        Tue, 24 Jan 2023 18:05:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D0612026D2A;
        Tue, 24 Jan 2023 18:05:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.2-rc6
Date:   Tue, 24 Jan 2023 13:05:47 -0500
Message-Id: <20230124180547.4192955-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 2241ab53cbb5cdb08a6b2d4688feb13971058f65:

  Linux 6.2-rc5 (2023-01-21 16:27:01 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c2c46b10d52624376322b01654095a84611c7e09:

  KVM: selftests: Make reclaim_period_ms input always be positive (2023-01-22 04:10:24 -0500)

----------------------------------------------------------------
ARM64:

- Pass the correct address to mte_clear_page_tags() on initialising
  a tagged page

- Plug a race against a GICv4.1 doorbell interrupt while saving
  the vgic-v3 pending state.

x86:

- A command line parsing fix and a clang compilation fix for selftests

- A fix for a longstanding VMX issue, that surprisingly was only found
  now to affect real world guests

----------------------------------------------------------------
Catalin Marinas (1):
      KVM: arm64: Pass the actual page address to mte_clear_page_tags()

Hendrik Borghorst (1):
      KVM: x86/vmx: Do not skip segment attributes if unusable bit is set

Marc Zyngier (1):
      KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-6.2-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      selftests: kvm: move declaration at the beginning of main()

Vipin Sharma (1):
      KVM: selftests: Make reclaim_period_ms input always be positive

 arch/arm64/kvm/guest.c                             |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      | 25 ++++++++++------------
 arch/arm64/kvm/vgic/vgic-v4.c                      |  8 +++++--
 arch/arm64/kvm/vgic/vgic.h                         |  1 +
 arch/x86/kvm/vmx/vmx.c                             | 21 ++++++++----------
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |  2 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  7 +++---
 7 files changed, 32 insertions(+), 34 deletions(-)


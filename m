Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D4B68AA87
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 15:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbjBDOO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 09:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDOOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 09:14:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3062214EBB
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 06:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675520049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b/NFYebpTt4n4gN331Zbam2UQ88UtxYfxZP2QmqljgU=;
        b=LQFy+BdR+W4susXJYQAmB8bA0QJ2o+iMfRmZW8Y8S5I6RzRZevbAnNYbfnb8n9qG84TVqO
        S5TpkjybPTjgYrJGXYe3PQalgbGdHC3aGOm17zxGtpsHArYouXiAPdmXW8E4WkmcYbgEGy
        KR2cGO7VSNMzkF7c6U3EtA/0GkggwHs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-ClzwWrF6NcyCxAbHLjHQIw-1; Sat, 04 Feb 2023 09:14:06 -0500
X-MC-Unique: ClzwWrF6NcyCxAbHLjHQIw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C446D80D0E8;
        Sat,  4 Feb 2023 14:14:05 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7F6F492C14;
        Sat,  4 Feb 2023 14:14:05 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.2-rc7
Date:   Sat,  4 Feb 2023 09:14:05 -0500
Message-Id: <20230204141405.875815-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit c2c46b10d52624376322b01654095a84611c7e09:

  KVM: selftests: Make reclaim_period_ms input always be positive (2023-01-22 04:10:24 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 25b72cf7da9f0d66eef3979187ddfda98d4efcd0:

  Merge tag 'kvmarm-fixes-6.2-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2023-02-04 08:57:43 -0500)

----------------------------------------------------------------
ARM64:

- Yet another fix for non-CPU accesses to the memory backing
  the VGICv3 subsystem

- A set of fixes for the setlftest checking for the S1PTW
  behaviour after the fix that went in ealier in the cycle

----------------------------------------------------------------
Gavin Shan (3):
      KVM: arm64: Add helper vgic_write_guest_lock()
      KVM: arm64: Allow no running vcpu on restoring vgic3 LPI pending status
      KVM: arm64: Allow no running vcpu on saving vgic3 pending table

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-6.2-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Ricardo Koller (4):
      KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
      KVM: selftests: aarch64: Do not default to dirty PTE pages on all S1PTWs
      KVM: selftests: aarch64: Fix check of dirty log PT write
      KVM: selftests: aarch64: Test read-only PT memory regions

 Documentation/virt/kvm/api.rst                     |  10 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  13 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   4 +-
 arch/arm64/kvm/vgic/vgic.h                         |  14 ++
 include/kvm/arm_vgic.h                             |   2 +-
 .../selftests/kvm/aarch64/page_fault_test.c        | 187 ++++++++++++---------
 6 files changed, 132 insertions(+), 98 deletions(-)


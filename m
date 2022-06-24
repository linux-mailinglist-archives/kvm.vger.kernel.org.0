Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E6555957B
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 10:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiFXIca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 04:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiFXIcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 04:32:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F07824BD7
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 01:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656059538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CgygOx5yPDyYMb31XsTetk6Htk9rXafuen11iv6Q0EQ=;
        b=eZAmA4MXAeSHaXHZzlywhzrCo50Xu7kXGBm1Pn60KT2exxYOJWB8lpVn+M2GRzHc+B8e/A
        Rph51Gve8F4olf5+jOD9J3EuJxH8P0duueeBg2zXwdWxqhlyLu7czVM3bp+Z3nZjOkq2ne
        qo8WS8QwkO5GlLnEKC9YMc1vNGxId0M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-D107xuevOlKyKasx9ESEeg-1; Fri, 24 Jun 2022 04:32:16 -0400
X-MC-Unique: D107xuevOlKyKasx9ESEeg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 682B785A589;
        Fri, 24 Jun 2022 08:32:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AB79416171;
        Fri, 24 Jun 2022 08:32:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.19-rc4
Date:   Fri, 24 Jun 2022 04:32:16 -0400
Message-Id: <20220624083216.2723369-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 24625f7d91fb86b91e14749633a7f022f5866116:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2022-06-14 07:57:18 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 6defa24d3b12bbd418bc8526dea1cbc605265c06:

  KVM: SEV: Init target VMCBs in sev_migrate_from (2022-06-24 04:10:18 -0400)

----------------------------------------------------------------
ARM64:

* Fix a regression with pKVM when kmemleak is enabled

* Add Oliver Upton as an official KVM/arm64 reviewer

selftests:

* deal with compiler optimizations around hypervisor exits

x86:

* MAINTAINERS reorganization

* Two SEV fixes

----------------------------------------------------------------
Dmitry Klochkov (1):
      tools/kvm_stat: fix display of error when multiple processes are found

Marc Zyngier (1):
      KVM: arm64: Add Oliver as a reviewer

Mingwei Zhang (1):
      KVM: x86/svm: add __GFP_ACCOUNT to __sev_dbg_{en,de}crypt_user()

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-5.19-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      MAINTAINERS: Reorganize KVM/x86 maintainership

Peter Gonda (1):
      KVM: SEV: Init target VMCBs in sev_migrate_from

Quentin Perret (1):
      KVM: arm64: Prevent kmemleak from accessing pKVM memory

Raghavendra Rao Ananta (1):
      selftests: KVM: Handle compiler optimizations in ucall

 MAINTAINERS                                     | 42 +++++++++++----
 arch/arm64/kvm/arm.c                            |  6 +--
 arch/x86/kvm/svm/sev.c                          | 72 ++++++++++++++++---------
 arch/x86/kvm/svm/svm.c                          | 11 +---
 arch/x86/kvm/svm/svm.h                          |  2 +-
 tools/kvm/kvm_stat/kvm_stat                     |  3 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c |  9 ++--
 7 files changed, 92 insertions(+), 53 deletions(-)


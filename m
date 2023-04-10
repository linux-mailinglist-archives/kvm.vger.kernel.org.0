Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570BB6DC8A1
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 17:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDJPkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 11:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjDJPkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 11:40:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E47330C8
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681141162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=txWd2dHY1jKmJaXlngkV7LKfXExjOljbbsG1zTM1SKw=;
        b=fJbVomNH1y/WCRJ/nQ439i8O6vCRQTa4716JCtM7FiRGG4JJby7t/tgZ+6DXt9pLDq7ksK
        +CAGIm3oj7puToQHGx9n6gvY6W8wd1U1GsKqB3LWzlPWvc29thiNQG5/KLXaP5PWccDgTC
        Rly2o8wBnX5DRVAR+bHz2WqZ+L+xoEA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-3YIPTR51Oy638WLZm_U0_Q-1; Mon, 10 Apr 2023 11:39:18 -0400
X-MC-Unique: 3YIPTR51Oy638WLZm_U0_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AF2385A5B1;
        Mon, 10 Apr 2023 15:39:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E875240C83AC;
        Mon, 10 Apr 2023 15:39:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        oliver.upton@linux.dev
Subject: [GIT PULL] KVM changes for Linux 6.3-rc7
Date:   Mon, 10 Apr 2023 11:39:17 -0400
Message-Id: <20230410153917.1313858-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit fb5015bc8b733323b58f015b88e4f316010ec856:

  docs: kvm: x86: Fix broken field list (2023-04-04 13:22:05 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 0bf9601f8ef0703523018e975d6c1f3fdfcff4b9:

  Merge tag 'kvmarm-fixes-6.3-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2023-04-06 13:34:19 -0400)

----------------------------------------------------------------
Two ARM fixes:

* Ensure the guest PMU context is restored before the first KVM_RUN,
  fixing an issue where EL0 event counting is broken after vCPU
  save/restore

* Actually initialize ID_AA64PFR0_EL1.{CSV2,CSV3} based on the
  sanitized, system-wide values for protected VMs

----------------------------------------------------------------
Fuad Tabba (1):
      KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-6.3-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Reiji Watanabe (1):
      KVM: arm64: PMU: Restore the guest's EL0 event counting after migration

 arch/arm64/kvm/arm.c                           | 26 +++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c             |  7 -------
 arch/arm64/kvm/pmu-emul.c                      |  1 +
 arch/arm64/kvm/sys_regs.c                      |  1 -
 5 files changed, 30 insertions(+), 10 deletions(-)


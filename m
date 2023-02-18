Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2026D69BA7D
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 15:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjBROv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Feb 2023 09:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBROvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Feb 2023 09:51:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A82A18B2B
        for <kvm@vger.kernel.org>; Sat, 18 Feb 2023 06:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676731869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xWDY+y6aMm72KIKZRN8pGLzKB4D2OL4KEZ9ZcfaQzSU=;
        b=ErtWIKHgl9i8tv2dJWPWf9bGvXCKBvDv6krDkHqOuq2JljArIPPYCjpEczyxYa/daZt4E4
        RSuQWvk5lnspMstDr1CcJjP/+YuxTA5Xi+i7Xz8PJrFvyyH5EAKCB20kNZgkeg/68CcVvC
        VPcN5Z7hWjAUsC+l/FsbU7JGIhHBBYk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-J4q8vHHLNT-fgb_GXAjQpg-1; Sat, 18 Feb 2023 09:51:03 -0500
X-MC-Unique: J4q8vHHLNT-fgb_GXAjQpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89E3529AB3EB;
        Sat, 18 Feb 2023 14:51:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CBEE2166B30;
        Sat, 18 Feb 2023 14:51:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final batch KVM changes for Linux 6.2
Date:   Sat, 18 Feb 2023 09:51:02 -0500
Message-Id: <20230218145102.1610745-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

The following changes since commit 493a2c2d23ca91afba96ac32b6cbafb54382c2a3:

  Documentation/hw-vuln: Add documentation for Cross-Thread Return Predictions (2023-02-10 07:27:37 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2c10b61421a28e95a46ab489fd56c0f442ff6952:

  kvm: initialize all of the kvm_debugregs structure before sending it to userspace (2023-02-16 12:31:40 -0500)

----------------------------------------------------------------
x86:

* zero all padding for KVM_GET_DEBUGREGS

* fix rST warning

* disable vPMU support on hybrid CPUs

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      kvm: initialize all of the kvm_debugregs structure before sending it to userspace

Paolo Bonzini (1):
      Documentation/hw-vuln: Fix rST warning

Sean Christopherson (2):
      KVM: x86/pmu: Disable vPMU support on hybrid CPUs (host PMUs)
      perf/x86: Refuse to export capabilities for hybrid PMUs

 .../admin-guide/hw-vuln/cross-thread-rsb.rst       |  3 +--
 arch/x86/events/core.c                             | 12 +++++-----
 arch/x86/kvm/pmu.h                                 | 26 ++++++++++++++++------
 arch/x86/kvm/x86.c                                 |  3 +--
 4 files changed, 28 insertions(+), 16 deletions(-)


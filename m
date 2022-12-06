Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EF76449B7
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 17:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiLFQuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 11:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbiLFQtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 11:49:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B281037
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 08:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670345309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EY22TUQQWLcxjDqZXv1ZQFqWQM2RSEk78RhFgF6fnNA=;
        b=CyIk+nI3LIijqwfTIA5ruYfbyWjkVVhX56lS4ISGGuFuhzeco2LlLefp7psk6CftZU0zlC
        nE4jxY0qPNBYbb1IdevzipGsw0xsm22+9bdfcop56B0dEKmoygyDStItNZ7xOsz2C1ODOI
        gtkeCFfj2l7ywiLiQHB5n7VuYiJf8pM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-8wEqMsc6PbOCjf6-F68lkw-1; Tue, 06 Dec 2022 11:48:26 -0500
X-MC-Unique: 8wEqMsc6PbOCjf6-F68lkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA1D2381A723;
        Tue,  6 Dec 2022 16:48:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD1D040C6EC3;
        Tue,  6 Dec 2022 16:48:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final KVM changes for Linux 6.1
Date:   Tue,  6 Dec 2022 11:48:25 -0500
Message-Id: <20221206164825.1758138-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

The following changes since commit b7b275e60bcd5f89771e865a8239325f86d9927d:

  Linux 6.1-rc7 (2022-11-27 13:31:48 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 34e30ebbe48cc43c14276f863f0d2995c8f13186:

  KVM: Document the interaction between KVM_CAP_HALT_POLL and halt_poll_ns (2022-12-02 13:20:30 -0500)

Unless anything comes from the ARM side, this should be the last pull
request for this release---and it's mostly documentation.

Thanks,

Paolo

----------------------------------------------------------------
* Document the interaction between KVM_CAP_HALT_POLL and halt_poll_ns

* s390: fix multi-epoch extension in nested guests

* x86: fix uninitialized variable on nested triple fault

----------------------------------------------------------------
David Matlack (2):
      KVM: Move halt-polling documentation into common directory
      KVM: Document the interaction between KVM_CAP_HALT_POLL and halt_poll_ns

Paolo Bonzini (2):
      Merge tag 'kvm-s390-master-6.1-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      KVM: x86: fix uninitialized variable use on KVM_REQ_TRIPLE_FAULT

Thomas Huth (1):
      KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field

 Documentation/virt/kvm/api.rst                    | 15 +++++++--------
 Documentation/virt/kvm/{x86 => }/halt-polling.rst | 13 +++++++++++++
 Documentation/virt/kvm/index.rst                  |  1 +
 Documentation/virt/kvm/x86/index.rst              |  1 -
 arch/s390/kvm/vsie.c                              |  4 +++-
 arch/x86/kvm/x86.c                                |  2 +-
 6 files changed, 25 insertions(+), 11 deletions(-)
 rename Documentation/virt/kvm/{x86 => }/halt-polling.rst (92%)


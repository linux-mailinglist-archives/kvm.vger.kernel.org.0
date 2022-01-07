Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEA2487B09
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348484AbiAGRJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:09:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229546AbiAGRJp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 12:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641575385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FpOad2eLYihlJrzMNsHFWzeQoLxz0b6WB3NiZ2/5w2s=;
        b=VOEFyaDsfddjZS5RlteC+qqqo55HXLRNN/J7V88CVJH7asPaSYZQAIruAW/mV2iIbf7J7Z
        F+spiYUqIUOI0+rlVt/ktlwN5T4hsr0fzrO77pHptwMuBb7AVSsZi/pPfiFs+guAL0owvy
        dn0C5MM5ZOm0csz7CXJGIhOV7u3mu0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-7rboLUw6PemWXUcKemzNZA-1; Fri, 07 Jan 2022 12:09:41 -0500
X-MC-Unique: 7rboLUw6PemWXUcKemzNZA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC7218015CD;
        Fri,  7 Jan 2022 17:09:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CAC577447;
        Fri,  7 Jan 2022 17:09:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final batch of KVM fixes for Linux 5.16
Date:   Fri,  7 Jan 2022 12:09:40 -0500
Message-Id: <20220107170940.653733-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit fdba608f15e2427419997b0898750a49a735afcb:

  KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU (2021-12-21 12:39:03 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to fffb5323780786c81ba005f8b8603d4a558aad28:

  KVM: x86: Check for rmaps allocation (2022-01-07 12:04:01 -0500)

----------------------------------------------------------------
Two small fixes for x86:
* lockdep WARN due to missing lock nesting annotation
* NULL pointer dereference when accessing debugfs

----------------------------------------------------------------
Nikunj A Dadhania (1):
      KVM: x86: Check for rmaps allocation

Wanpeng Li (1):
      KVM: SEV: Mark nested locking of kvm->lock

 arch/x86/kvm/debugfs.c | 3 +++
 arch/x86/kvm/svm/sev.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A6201A9E
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 20:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbgFSSqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 14:46:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33028 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731358AbgFSSqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 14:46:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592592395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m0FpzCva/zyn/UMs7J4w8ZtycrPgdRAxriFzKZK3P20=;
        b=I5LPmvFIgCYfpFvZPzb3XxhJn5c0qeClkVfb448XfPd4EKs2AChB0fjpTK/aXE5Tfc9o66
        ZsG+f8o9D9yjvHgdQRwOH9uMRKFX0EHxePxUrukQ4TERRPgqrOM5URuoBezydDcGS6WoJz
        lfy1hPu1vlpCLmRXvngIDZmnJh5RqoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-3iUouf49P-q72fQsgHn2hg-1; Fri, 19 Jun 2020 14:46:33 -0400
X-MC-Unique: 3iUouf49P-q72fQsgHn2hg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87D3BEC1A0;
        Fri, 19 Jun 2020 18:46:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C160F60BF4;
        Fri, 19 Jun 2020 18:46:30 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, steven.price@arm.com
Subject: [PATCH 0/4] arm64/x86: KVM: Introduce KVM_CAP_STEAL_TIME
Date:   Fri, 19 Jun 2020 20:46:25 +0200
Message-Id: <20200619184629.58653-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series introduces a KVM CAP for steal time to arm64 and x86.
For arm64 the cap resolves a couple issues described in the second
patch's commit message. The cap isn't necessary for x86, but is
added for consistency.

Thanks,
drew

Andrew Jones (4):
  KVM: Documentation minor fixups
  arm64/x86: KVM: Introduce steal time cap
  tools headers kvm: Sync linux/kvm.h with the kernel sources
  KVM: selftests: Use KVM_CAP_STEAL_TIME

 Documentation/virt/kvm/api.rst           | 20 ++++++++++++++++----
 arch/arm64/kvm/arm.c                     |  3 +++
 arch/x86/kvm/x86.c                       |  3 +++
 include/uapi/linux/kvm.h                 |  1 +
 tools/include/uapi/linux/kvm.h           | 15 +++++++++++++++
 tools/testing/selftests/kvm/steal_time.c |  8 ++++++++
 6 files changed, 46 insertions(+), 4 deletions(-)

-- 
2.25.4


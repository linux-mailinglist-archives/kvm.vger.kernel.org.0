Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C0521C371
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 12:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgGKKEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jul 2020 06:04:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24346 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726208AbgGKKEo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 11 Jul 2020 06:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594461883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VKBB5okw8SKPQ8TKlGmPfFr4Jdt7zbRqxy7S7JmXFQw=;
        b=VEP/Wuz0GgTNojdz+NiBLWI/n6/oW8j3iQN32Ajj0lxz5SP/IpoPakGXUypkXqJ14wMgqT
        j60QkVxKGvaRliEtjoTkvXlXytlAJ3redDEIalWbIxXH7ElEQXDDhSy3kH8/LPMwWKA4fl
        wrSruLZA4IcKJVN2hXX6mXJUmzW/HME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135--wLag4N5OjCR61GbjcBMqQ-1; Sat, 11 Jul 2020 06:04:42 -0400
X-MC-Unique: -wLag4N5OjCR61GbjcBMqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CC47100960F;
        Sat, 11 Jul 2020 10:04:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 970D019D61;
        Sat, 11 Jul 2020 10:04:35 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, steven.price@arm.com
Subject: [PATCH 0/5] KVM: arm64: pvtime: Fixes and a new cap
Date:   Sat, 11 Jul 2020 12:04:29 +0200
Message-Id: <20200711100434.46660-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first three patches in the series are fixes that come from testing
and reviewing pvtime code while writing the QEMU support (I'll reply
to this mail with a link to the QEMU patches after posting - which I'll
do shortly). The last patch is only a convenience for userspace, and I
wouldn't be heartbroken if it wasn't deemed worth it. The QEMU patches
I'll be posting are currently written without the cap. However, if the
cap is accepted, then I'll change the QEMU code to use it.

Thanks,
drew

Andrew Jones (5):
  KVM: arm64: pvtime: steal-time is only supported when configured
  KVM: arm64: pvtime: Fix potential loss of stolen time
  KVM: arm64: pvtime: Fix stolen time accounting across migration
  KVM: Documentation minor fixups
  arm64/x86: KVM: Introduce steal-time cap

 Documentation/virt/kvm/api.rst    | 20 ++++++++++++++++----
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pvtime.c           | 31 +++++++++++++++----------------
 arch/x86/kvm/x86.c                |  3 +++
 include/linux/kvm_host.h          | 19 +++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 7 files changed, 58 insertions(+), 21 deletions(-)

-- 
2.25.4


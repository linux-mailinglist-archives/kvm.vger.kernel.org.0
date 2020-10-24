Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733B7297B8A
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 11:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760185AbgJXJCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 05:02:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S464830AbgJXJCC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 24 Oct 2020 05:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603530121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WsLnm4h/QDa//59tO5yt/GI/Eb0fBcrMjcG64YafxHk=;
        b=dEKjDMwE8BlznUw+sjvdtYP/ByKlRPkH44Vq1T+Y6hTT+CGIdDz6LM2cAXU76LVgbnxwLr
        VjeHTK9rgptFvNp8856Za7A9NHdeUEBXhFc+fZnHoAVSYi8KTwgPz8WyEJWDWgYmVkpMHh
        ZkLmk4HYIYsr9/7IVUrIcHIClbH3b2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-qpo_KEXKO6acdAvr6sRrLA-1; Sat, 24 Oct 2020 05:01:59 -0400
X-MC-Unique: qpo_KEXKO6acdAvr6sRrLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58DD85F9E8;
        Sat, 24 Oct 2020 09:01:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E903D10027AB;
        Sat, 24 Oct 2020 09:01:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.10-rc1
Date:   Sat, 24 Oct 2020 05:01:57 -0400
Message-Id: <20201024090157.2818024-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 29cf0f5007a215b51feb0ae25ca5353480d53ead:

  kvm: x86/mmu: NX largepage recovery for TDP MMU (2020-10-23 03:42:16 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 77377064c3a94911339f13ce113b3abf265e06da:

  KVM: ioapic: break infinite recursion on lazy EOI (2020-10-24 04:42:06 -0400)

----------------------------------------------------------------
Two fixes for the pull request, and an unrelated bugfix for
a host hang.

----------------------------------------------------------------

Paolo Bonzini (1):
      KVM: vmx: rename pi_init to avoid conflict with paride

Sean Christopherson (1):
      KVM: x86/mmu: Avoid modulo operator on 64-bit value to fix i386 build

Vitaly Kuznetsov (1):
      KVM: ioapic: break infinite recursion on lazy EOI

 arch/x86/kvm/ioapic.c          | 5 +----
 arch/x86/kvm/mmu/tdp_mmu.c     | 2 +-
 arch/x86/kvm/vmx/posted_intr.c | 2 +-
 arch/x86/kvm/vmx/posted_intr.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c         | 2 +-
 5 files changed, 6 insertions(+), 9 deletions(-)


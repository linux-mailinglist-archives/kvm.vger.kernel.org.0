Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458E9440D5C
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 07:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJaGh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 02:37:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229638AbhJaGh6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 02:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635662126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fV1bLwwaMTS/hDiWda3o4PnJEaNxbPpK2smCN/BJhKA=;
        b=G4AmKILGn4B5fyUAbyd5Hh5ZyrZHEV7or4oAyUo90SLbXGwgRXbWmYH9rshUKbQ5XtdiKa
        HU9VLGyefab8ZrLUNzKSjpoW0CNUekwHk9quqf1NUNZbMLUfqmX4N1gkfuZTdJdYP8OfVv
        sLaLlIXotv1898v7bu75WWLgfkU7Vk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-lBCVqD0VNiOWBvxmV6UPIw-1; Sun, 31 Oct 2021 02:35:22 -0400
X-MC-Unique: lBCVqD0VNiOWBvxmV6UPIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D842806688;
        Sun, 31 Oct 2021 06:35:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C6415F4E0;
        Sun, 31 Oct 2021 06:35:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.15 (rc8 or final)
Date:   Sun, 31 Oct 2021 02:35:20 -0400
Message-Id: <20211031063520.4090094-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit fa13843d1565d4c5b3aeb9be3343b313416bef46:

  KVM: X86: fix lazy allocation of rmaps (2021-10-18 14:07:17 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f3d1436d4bf8ced1c9a62a045d193a65567e1fcc:

  KVM: x86: Take srcu lock in post_kvm_run_save() (2021-10-28 10:45:38 -0400)

----------------------------------------------------------------
* Fixes for s390 interrupt delivery
* Fixes for Xen emulator bugs showing up as debug kernel WARNs
* Fix another issue with SEV/ES string I/O VMGEXITs

----------------------------------------------------------------
David Woodhouse (3):
      KVM: x86: switch pvclock_gtod_sync_lock to a raw spinlock
      KVM: x86/xen: Fix kvm_xen_has_interrupt() sleeping in kvm_vcpu_block()
      KVM: x86: Take srcu lock in post_kvm_run_save()

Halil Pasic (2):
      KVM: s390: clear kicked_mask before sleeping again
      KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu

Paolo Bonzini (2):
      Merge tag 'kvm-s390-master-5.15-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      KVM: SEV-ES: fix another issue with string I/O VMGEXITs

 arch/s390/kvm/interrupt.c       |  5 +++--
 arch/s390/kvm/kvm-s390.c        |  1 +
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/sev.c          | 15 ++++++++++++---
 arch/x86/kvm/x86.c              | 36 ++++++++++++++++++++++--------------
 arch/x86/kvm/xen.c              | 27 ++++++++++++++++++++++-----
 6 files changed, 61 insertions(+), 25 deletions(-)


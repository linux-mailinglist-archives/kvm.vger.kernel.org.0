Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08082723F9
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgIUMf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:35:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26261 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726827AbgIUMf0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 08:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600691724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3MHjQ9sOgc6BwRarKA9h7qCAMjbrE8l16YL9VPJPBJw=;
        b=E2R/MG9u8kdd34t50pwgAS3qktDyakddMQUrsNtuOnOu+LLuKOouYMJX2pkLa7RTh6qr0k
        xtYhqrk/yyjwTuB6uERDYmVjIHmEw1KlJBPpJVj8uuG5ndPxt5nJEj9hSIT5hx3jyhvO7D
        fhr3bN8tyNoHbjXxLZ4kG2FPhVbNsB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-JiOu7vgSNympMUI_0jrkFA-1; Mon, 21 Sep 2020 08:35:22 -0400
X-MC-Unique: JiOu7vgSNympMUI_0jrkFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C459B10BBEC0;
        Mon, 21 Sep 2020 12:35:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 633FF7881A;
        Mon, 21 Sep 2020 12:35:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.9-rc7
Date:   Mon, 21 Sep 2020 08:35:20 -0400
Message-Id: <20200921123520.1255391-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 37f66bbef0920429b8cb5eddba849ec4308a9f8e:

  KVM: emulator: more strict rsm checks. (2020-09-12 12:22:55 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to be6c230c3c471d32ef9d18559dc50bd5b01aa068:

  Merge tag 'kvm-s390-master-5.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master (2020-09-20 09:14:54 -0400)

----------------------------------------------------------------
ARM:
- fix fault on page table writes during instruction fetch

s390:
- doc improvement

x86:
- The obvious patches are always the ones that turn out to be
  completely broken.  /me hangs his head in shame.

----------------------------------------------------------------
Collin Walling (1):
      docs: kvm: add documentation for KVM_CAP_S390_DIAG318

Marc Zyngier (2):
      KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
      KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite()

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-5.9-2' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master
      Merge tag 'kvm-s390-master-5.9-1' of git://git.kernel.org/.../kvms390/linux into kvm-master

Vitaly Kuznetsov (1):
      Revert "KVM: Check the allocation of pv cpu mask"

 Documentation/virt/kvm/api.rst          | 20 ++++++++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h    | 14 +++++++++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/mmu.c                    |  4 ++--
 arch/x86/kernel/kvm.c                   | 22 +++-------------------
 5 files changed, 37 insertions(+), 25 deletions(-)


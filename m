Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7655C2822FD
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgJCJTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:19:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgJCJTA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 05:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601716739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Xaa+/b2Y/z1dPGM7nkR+iaYhP57s9DiHPFtFLQ2sRIw=;
        b=QplHiVXvKzfrDsflaVx0YZX7Um5q2X1OeODCCgq+KqXyltENdxVCq6pVTY7jNWpgwOY/rg
        k/SECEqz/mbrsnMSsCAkyulvFt76oyvLfWBBW5PnR65QfEtAvq7t2o4wAIhtpYEuRi5aJR
        znZg2XoH1erOIG7qdDSEbgdhefgytho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-FMuPZXG4OWaNaYSX9yXZAQ-1; Sat, 03 Oct 2020 05:18:57 -0400
X-MC-Unique: FMuPZXG4OWaNaYSX9yXZAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0849100746F;
        Sat,  3 Oct 2020 09:18:55 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D39A60C05;
        Sat,  3 Oct 2020 09:18:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.9-rc8
Date:   Sat,  3 Oct 2020 05:18:54 -0400
Message-Id: <20201003091854.240100-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 4bb05f30483fd21ea5413eaf1182768f251cf625:

  KVM: SVM: Add a dedicated INVD intercept routine (2020-09-25 13:27:35 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e2e1a1c86bf32a8d7458b9024f518cf2434414c8:

  Merge tag 'kvmarm-fixes-5.9-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2020-10-03 05:07:59 -0400)

----------------------------------------------------------------
Two bugfix patches.

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Restore missing ISB on nVHE __tlb_switch_to_guest

Paolo Bonzini (2):
      KVM: VMX: update PFEC_MASK/PFEC_MATCH together with PF intercept
      Merge tag 'kvmarm-fixes-5.9-3' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master

 arch/arm64/kvm/hyp/nvhe/tlb.c |  7 +++++++
 arch/x86/kvm/vmx/vmx.c        | 22 ++++++++++++----------
 2 files changed, 19 insertions(+), 10 deletions(-)


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CA32794D4
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 01:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgIYXg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 19:36:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgIYXg5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 19:36:57 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601077016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WD+Mt/pFl73GwFi148Y3nb0ypbYCbFWTzG/uad5+3Yc=;
        b=gkN98x6xvUvHcysf8EHNU93RCgdgFf0BhScT/XtVO6u+teu7A+r/pHmvhOIypKuaDVfeIJ
        rsJzHO41MX5/8MM/ENwoi3M7FUyDu9oB5OEQiU2ZoW8yecYElsPg4eMmA8ZcrlmsK27hVn
        Z9uPZt27E4HKRaFRP9BPQnaoYWl65Mw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-uZ1HHfikPIeHM8yKzTDdOg-1; Fri, 25 Sep 2020 19:36:53 -0400
X-MC-Unique: uZ1HHfikPIeHM8yKzTDdOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4E8680732A;
        Fri, 25 Sep 2020 23:36:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8505F19C66;
        Fri, 25 Sep 2020 23:36:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM fixes for Linux 5.9-rc7
Date:   Fri, 25 Sep 2020 19:36:52 -0400
Message-Id: <20200925233652.2187766-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 32251b07d532174d66941488c112ec046f646157:

  Merge tag 'kvm-s390-master-5.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master (2020-09-20 17:31:15 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 4bb05f30483fd21ea5413eaf1182768f251cf625:

  KVM: SVM: Add a dedicated INVD intercept routine (2020-09-25 13:27:35 -0400)

----------------------------------------------------------------
Five small fixes.  The nested migration bug will be fixed
with a better API in 5.10 or 5.11, for now this is a fix
that works with existing userspace but keeps the current
ugly API.

----------------------------------------------------------------
Maxim Levitsky (1):
      KVM: x86: fix MSR_IA32_TSC read for nested migration

Mohammed Gamal (1):
      KVM: x86: VMX: Make smaller physical guest address space support user-configurable

Sean Christopherson (1):
      KVM: x86: Reset MMU context if guest toggles CR4.SMAP or CR4.PKE

Tom Lendacky (1):
      KVM: SVM: Add a dedicated INVD intercept routine

Yang Weijiang (1):
      selftests: kvm: Fix assert failure in single-step test

 arch/x86/kvm/svm/svm.c                          |  8 +++++++-
 arch/x86/kvm/vmx/vmx.c                          | 15 ++++++++++-----
 arch/x86/kvm/vmx/vmx.h                          |  5 ++++-
 arch/x86/kvm/x86.c                              | 22 ++++++++++++++++++----
 tools/testing/selftests/kvm/x86_64/debug_regs.c |  2 +-
 5 files changed, 40 insertions(+), 12 deletions(-)

